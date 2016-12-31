local S = sys4_quests.intllib

function sys4_quests.get_quests(modName)
	local quests = sys4_quests.registeredQuests[modName]
	if quests then return quests.quests end
	return nil
end

function sys4_quests.get_quest(questName)
	for _, quests in pairs(sys4_quests.registeredQuests) do
		for _, quest in ipairs(quests.quests) do
			if quest[1] == questName then return quest end
		end
	end
	return nil
end

local function is_questActive(questName, playern)
	return quests.active_quests[playern] and quests.active_quests[playern]["sys4_quests:"..questName]
end

local function is_questSuccessfull(questName, playern)
	return quests.successfull_quests[playern]	and quests.successfull_quests[playern]["sys4_quests:"..questName]
end

local function get_itemGroup(groupName)
	for _, group in ipairs(sys4_quests.itemGroups) do
		if group == groupName then return group end
	end
	return nil
end

local function get_questGroup_by_questIndex(questIndex)
	for name, group in pairs(sys4_quests.questGroups) do
		for _, index in ipairs(group.questsIndex) do
			if index == questIndex and name ~= "global" then
				return name
			end
		end
	end

	return nil
end

local function get_questGroup(name)
	for groupname, group in pairs(sys4_quests.questGroups) do
		if groupname == name then
			return group
		end
	end
	return nil
end

local function get_questGroup_order(questGroup)
	local group = get_questGroup(questGroup)
	if group then return group.order end
	return nil
end

local function get_questGroup_by_order(order)
	for name, group in pairs(sys4_quests.questGroups) do
		if group.order == order then
			return name
		end
	end
	return nil
end

local function get_next_questGroup(currentQuestGroup)
	local groupTotal = 0
	for _, group in pairs(sys4_quests.questGroups) do
		groupTotal = groupTotal + 1
	end

	local groupOrder = get_questGroup_order(currentQuestGroup)

	if not groupOrder or groupOrder == groupTotal then
		return nil
	else
		return get_questGroup_by_order(groupOrder + 1)
	end
end

-- functions for registering quests automatically

local function contain_item(liste, item)
	for _, liste_iter in ipairs(liste) do
		if liste_iter == item then return true end
	end
	return false
end

local function get_groups(itemName)
	local split = string.split(itemName, ":")
	if split[1] == "group" then
		return string.split(split[2], ",")
	else
		return nil
	end
end

local function get_itemChilds(itemName, mod)
	local childs = nil
	for name, _ in pairs(minetest.registered_items) do
		local recipes = nil
		if name ~= "" and string.split(name, ":")[1] ~= name
		and string.split(name, ":")[1] == mod then
			recipes = minetest.get_all_craft_recipes(name)
			if recipes then
				for __, recipe in ipairs(recipes) do
					local ingredients = recipe.items
					for i=1, #ingredients do
						if ingredients[i] then
							local sameGroup = false
							local groupItemSplit = string.split(itemName, ":")

							if groupItemSplit[1] == "group"
							and minetest.get_item_group(ingredients[i], groupItemSplit[2]) >= 1 then
								sameGroup = true
								
							elseif ingredients[i] == itemName then
								sameGroup = true
							elseif get_groups(ingredients[i]) then
								for ___, group in ipairs(get_groups(ingredients[i])) do
									sameGroup = minetest.get_item_group(itemName, group) > 0
								end
							end
							if sameGroup then
								if not childs then childs = {} end
								if not contain_item(childs, name) then
									table.insert(childs, name)
								end
							end
						end
					end
				end
			end
		end
	end
	return childs
end

local function check_item(itemName)
	local itemNameSplit = string.split(itemName, ":")
	local item = minetest.registered_items[itemName]
	if itemNameSplit[1] ~= "" and itemNameSplit[1] ~= itemName
	and item["groups"].not_in_creative_inventory ~= 1 then
		return true
	end
	return false
end

local function add_itemChilds(questTrees, mod)
	for i=1, #questTrees do
		local itemChilds = get_itemChilds(questTrees[i]:get_quest():get_item():get_name(), mod)
		if itemChilds then
			questTrees[i]:get_quest():get_item():add_childs(itemChilds)
		end

		local childQuests = questTrees[i]:get_quest():get_questTrees()
		if childQuests then
			add_itemChilds(childQuests, mod)
		end
	end
end

local function rebuild_questTrees(questTrees)
	local newQuestTrees = {}

	for i=1, #questTrees do
		local treeToMove = questTrees[i]
		local isAdded = false
		for j=i, #questTrees do
			if j ~= i then
				local currentTree = questTrees[j]:get_tree_with_item_child(treeToMove:get_quest():get_item():get_name())
				if currentTree	then
					currentTree:add(treeToMove)
					isAdded = true
					break
				end
			end
		end
		if not isAdded then
			for k=1, #newQuestTrees do
				local currentTree = newQuestTrees[k]:get_tree_with_item_child(treeToMove:get_quest():get_item():get_name())
				if currentTree then
					currentTree:add(treeToMove)
					isAdded = true
					break
				end
			end
			if not isAdded then
				table.insert(newQuestTrees, treeToMove)
			end
		end
	end
	return newQuestTrees
end

local function get_modItems(mod)
	local modItems = sys4_quests.MinetestItems()
	
	if mod and minetest.get_modpath(mod) then
		for name, item in pairs(minetest.registered_items) do
			if string.split(name, ":")[1] == mod
			and check_item(name) then
				modItems:add(item, get_itemChilds(name, mod))
			end
		end
	else
		minetest.log("error", "sys4_quests: Mod "..mod.." not found !")
		return nil
	end
	
	return modItems
end

local function get_itemTargets(itemName)
	if string.split(itemName, ":")[1] ~= "group" then
		local itemTargets = {}
		for name, item in pairs(minetest.registered_items) do
			local itemTarget = item.drop
			if itemTarget then
				if itemTarget.items then
					for i=1, #itemTarget.items do
						if #itemTarget.items[i].items then
							for j=1, #itemTarget.items[i].items do
								local itemTarget_str = string.split(itemTarget.items[i].items[j], " ")[1]
								if itemTarget_str == itemName then table.insert(itemTargets, item.name) end
							end
						end
					end
				elseif string.split(itemTarget, " ")[1] == itemName then
					table.insert(itemTargets, item.name)
				end
			end
		end
		if #itemTargets == 0 then table.insert(itemTargets, itemName) end
		return itemTargets
	else return {itemName} end
end

local function make_quests(mod, questTrees, parentQuest)
	local registerQuests = {}

	for i=1, #questTrees do
		local quest = questTrees[i]:get_quest()

		if quest:get_item():get_field("mod_origin") == mod then
			local questName = quest:get_name()
			local questTitle = questName -- Titre par défaut, devrait être changé
			local questDescription = nil -- Peut être changé
			local itemTarget = get_itemTargets(quest:get_item():get_name())
			local targetCount = quest:get_targetCount()
			local items_to_unlock = quest:get_item():get_childs()
			local action = quest:get_action()
			
			table.insert(registerQuests,
							 { questName,
								questTitle,
								questDescription,
								itemTarget,
								targetCount,
								items_to_unlock,
								{parentQuest},
								type = action
			})
		end
		local childs = quest:get_questTrees()
		if childs then
--			for j, child in ipairs(childs) do
				for k, questT in ipairs(make_quests(mod, childs, quest:get_name())) do
					table.insert(registerQuests, questT)
				end
--			end
		end
	end
	return registerQuests
end

local function make_auto_quests(mod, intllib)
	print("MOD : "..mod)
	local modItems = get_modItems(mod)
	if modItems then
		
		-- Construction de l'arbre des quêtes
		if not sys4_quests.questTrees then sys4_quests.questTrees = {} end
		local questTrees = sys4_quests.questTrees

		-- ajout d'items provenant du mod pouvant être rajoutés
		-- dans l'arbre de quetes déjà existant.
		add_itemChilds(questTrees, mod)

		local rootQuests = {}

		for _, item in ipairs(modItems:get_items()) do
			if item:has_childs()
				and item:is_hand_diggable()
					 and not item:get_recipes()
			then
				local questTree = sys4_quests.QuestTree(sys4_quests.Quest(item))
				table.insert(questTrees, questTree)
				table.insert(rootQuests, questTree)
			end
		end

		for _, item in ipairs(modItems:get_items()) do
			if item:has_childs() then
				local isPresent = false
				for i=1, #rootQuests do
					if rootQuests[i]:get_quest():get_item():get_name() ==
					item:get_name() then
						isPresent = true
					end
				end
				if not isPresent then
					local questTree = sys4_quests.QuestTree(sys4_quests.Quest(item))
					table.insert(questTrees, questTree)
				end
			end
		end

		local treeLen = 0
		local loop = 0
		while treeLen ~= #questTrees do
			treeLen = #questTrees
			questTrees = rebuild_questTrees(questTrees)
			loop = loop + 1
		end
		print("rebuild_questTrees loop:"..loop)
		print("questTrees length: "..#questTrees)
		print("RootQuest length: "..#rootQuests)

		-- remplissage des quêtes à enregistrer
		sys4_quests.registeredQuests[mod].quests = make_quests(mod, questTrees, nil)
		sys4_quests.questTrees = questTrees
	end
end

local function intllib_by_item(item)
	print("DEBUGGGG ::::::: "..item)
	local mod = string.split(item, ":")[1]
	if mod == "stairs" or mod == "group" then
		for questsMod, registeredQuests in pairs(sys4_quests.registeredQuests) do
			for _, quest in ipairs(registeredQuests.quests) do
				for __, titem in ipairs(quest[4]) do
					if item == titem then
						return registeredQuests.intllib
					end
				end
				for __, titem in ipairs(quest[6]) do
					if item == titem then
						return registeredQuests.intllib
					end
				end
			end
		end
	end

	local quests = sys4_quests.registeredQuests[mod]
	if not quests then
		sys4_quests.registeredQuests[mod] = {}
		quests = sys4_quests.registeredQuests[mod]
		quests.intllib = S
		quests.quests = {}
	end
	return sys4_quests.registeredQuests[mod].intllib
end

local function print_itemsUnlocked(items)
	local str = ""
	for _, item in ipairs(items) do
		local itemMod = string.split(item, ":")[1]
		local intllibMod
		if itemMod == "stairs" or itemMod == "group" then
			for mod, registeredQuests in pairs(sys4_quests.registeredQuests) do
				for _, quest in ipairs(registeredQuests.quests) do
					for __, titem in ipairs(quest[4]) do
						if item == titem then
							intllibMod = registeredQuests.intllib
						end
					end
					for __, titem in ipairs(quest[6]) do
						if item == titem then
							intllibMod = registeredQuests.intllib
						end
					end
				end
			end
		else
			intllibMod = sys4_quests.registeredQuests[itemMod].intllib
		end
		str = str.." - "..intllibMod(item).."\n"
	end

	return str
end

local function format_description(quest, level, intllib)
	local questType = quest.type
	local targetCount = level
	local customDesc = quest[3]

	local str = S(questType).." "..targetCount.." "
	if customDesc ~= nil then
		str = str..intllib(customDesc).."."
	else
		local itemTarget = quest[4][1]
		local item_intllib = intllib_by_item(itemTarget)
		str = str..item_intllib(itemTarget).."."
	end

	-- Print Unlocked Items
	str = str.."\n \n"..S("The end of the quest unlock this items").." :\n"
	return str..print_itemsUnlocked(quest[6])
end

local function has_dependences(questName)
	for mod, registeredQuests in pairs(sys4_quests.registeredQuests) do
		for _, quest in ipairs(registeredQuests.quests) do
			if quest[7] and quest[7] ~= nil and type(quest[7]) == "string" then
				local alternQuests = string.split(quest[7], "|")
				for __, alternQuest in ipairs(alternQuests) do
					if alternQuest == questName then
						return true
					end
				end
			elseif type(quest[7]) == "table" then
				for __, quest_1 in ipairs(quest[7]) do
					local alternQuests = string.split(quest_1, "|")
					for ___, alternQuest in ipairs(alternQuests) do
						if alternQuest == questName then
							return true
						end
					end
				end
			end
		end
	end
	return false
end

local function contains(quests, quest)
	local questsList = {}

	if type(quests) == "string" then
		table.insert(questsList, quests)
	else
		questsList = quests
	end

	for _, currentQuest in pairs(questsList) do
		local splittedQuests = string.split(currentQuest, "|")

		for __, splittedQuest in pairs(splittedQuests) do
			if splittedQuest == quest then
				return true
			end
		end
	end

	return false
end

local function is_questParents_successfull(parentQuests, currentQuest, playern)
	local parentQuestsList = {}

	if type(parentQuests) == "string" then
		table.insert(parentQuestsList, parentQuests)
	else
		parentQuestsList = parentQuests
	end

	local isAllFinished = true
	for _, parentQuest in pairs(parentQuestsList) do

		local isFinished = false
		local splittedParentQuests = string.split(parentQuest, "|")

		for __, splittedParentQuest in pairs(splittedParentQuests) do
			if splittedParentQuest == currentQuest then
				isFinished = true
				break
			else
				isFinished = isFinished or is_questSuccessfull(splittedParentQuest, playern)
			end
		end

		isAllFinished = isAllFinished and isFinished
	end

	return isAllFinished
end

local function get_next_quests(questname, playern)
	local insert = table.insert
	local nextQuests = {}

	if questname ~= "" then

		local currentQuest = string.split(questname, ":")[2]

		for mod, registeredQuests in pairs(sys4_quests.registeredQuests) do
			for _, registeredQuest in ipairs(registeredQuests.quests) do

				if registeredQuest[1] ~= currentQuest
					and not is_questActive(registeredQuest[1], playern)
					and not is_questSuccessfull(registeredQuest[1], playern)
				then
					local parentQuests = registeredQuest[7]

					if parentQuests ~= nil
						and contains(parentQuests, currentQuest)
					and is_questParents_successfull(parentQuests, currentQuest, playern) then
						insert(nextQuests, registeredQuest)
					end
				end
			end
		end
	end
	return nextQuests
end

local function is_all_groupQuests_successfull(currentQuestGroup, questname, playern)
	local successfull = true
	local currentQuest = string.split(questname, ":")[2]

	for mod, registeredQuests in pairs(sys4_quests.registeredQuests) do
		for _, registeredQuest in ipairs(registeredQuests.quests) do
			if registeredQuest[1] ~= currentQuest
			and get_questGroup_by_questIndex(registeredQuest.index) == currentQuestGroup then
				successfull = successfull and is_questSuccessfull(registeredQuest[1], playern)
			end
		end
	end
	return successfull
end

function sys4_quests.nextQuest(playername, questname)
	local nextQuests = get_next_quests(questname, playername)
	local currentQuestGroup = sys4_quests.playerList[playername].activeQuestGroup
	local nextQuestGroup = get_next_questGroup(currentQuestGroup)

	if nextQuestGroup ~= nil
	and is_all_groupQuests_successfull(currentQuestGroup, questname, playername) then
		sys4_quests.playerList[playername].activeQuestGroup = nextQuestGroup

		-- start quests of the next group
		for mod, registeredQuests in pairs(sys4_quests.registeredQuests) do
			for _, registeredQuest in ipairs(registeredQuests.quests) do
				if registeredQuest[7] == nil and get_questGroup_by_questIndex(registeredQuest.index) == nextQuestGroup then
					minetest.after(1, function() quests.start_quest(playername, "sys4_quests:"..registeredQuest[1]) end)
				end
			end
		end

		if #nextQuests > 0 then
			for _, nextQuest in pairs(nextQuests) do
				minetest.after(1, function() quests.start_quest(playername, "sys4_quests:"..nextQuest[1]) end)
			end
		end

	else

		for _, nextQuest in pairs(nextQuests) do
			minetest.after(1, function() quests.start_quest(playername, "sys4_quests:"..nextQuest[1]) end)
		end
	end
end

-- functions to use for make quests
function sys4_quests.initQuests(mod, intllib, auto)
	if not intllib then
		intllib = S
	end

	if not sys4_quests.registeredQuests then
		sys4_quests.registeredQuests = {}
	end

	sys4_quests.registeredQuests[mod] = {}
	sys4_quests.registeredQuests[mod].intllib = intllib
	sys4_quests.registeredQuests[mod].quests = {}
	if auto then
		make_auto_quests(mod, intllib)
	end
	return sys4_quests.registeredQuests[mod].quests
end

function sys4_quests.addInitialStuff(stack)
	if stack then
		if not sys4_quests.stuff then sys4_quests.stuff = {} end
		table.insert(sys4_quests.stuff, stack)
	end
end

function sys4_quests.add_itemGroup(groupName)
	local itemGroups = sys4_quests.itemGroups
	local isPresent = false
	for _, group in ipairs(itemGroups) do
		if group == groupName then isPresent = true end
	end
	if not isPresent then
		table.insert(itemGroups, groupName)
	end
end

function sys4_quests.add_questGroup(groupName)
	if groupName ~= nil and groupName ~= "" and groupName ~= "global" then
		local groupLen = 0
		for _, group in pairs(sys4_quests.questGroups) do
			groupLen = groupLen + 1
		end
		sys4_quests.questGroups[groupName] = {order = groupLen + 1,
														  questsIndex = {}}
	end
end

function sys4_quests.insertQuestGroup(existingGroupName, newGroupName)
	if checkGroupName(existingGroupName) and checkGroupName(newGroupName)
		and isGroupExist(existingGroupName) and not isGroupExist(newGroupName)
	then
		-- get order of existing group
		local existingGroupOrder = sys4_quests.questGroups[existingGroupName].order

		-- Increment by one the order of this group and the following others
		for name, group in pairs(sys4_quests.questGroups) do
			if group.order >= existingGroupOrder then
				group.order = group.order + 1
			end
		end

		-- add new group in place of the existing group
		sys4_quests.questGroups[newGroupName] = {order = existingGroupOrder, questsIndex = {}}
	end
end

function sys4_quests.set_parent_quest(quest, parentQuest)
	for mod, registeredQuests in pairs(sys4_quests.registeredQuests) do
		for _, rquest in ipairs(registeredQuests.quests) do
			if rquest[1] == quest then
				rquest[7] = {parentQuest}
			end
		end
	end
end

function sys4_quests.set_action_quest(quest, action)
	for mod, registeredQuests in pairs(sys4_quests.registeredQuests) do
		for _, rquest in ipairs(registeredQuests.quests) do
			if rquest[1] == quest then
				rquest.type = action
			end
		end
	end
end

function sys4_quests.updateQuest(questName, targetNodes, items)
	for mod, registeredQuests in pairs(sys4_quests.registeredQuests) do
		for _, quest in ipairs(registeredQuests.quests) do
			if questName == quest[1] then
				if targetNodes ~= nil and type(targetNodes) == "table" then
					for __,targetNode in ipairs(targetNodes) do
						if minetest.registered_nodes[targetNode] or minetest.registered_items[targetNode] then
							table.insert(quest[4], targetNode)
						else
							local nodeMod = string.split(targetNode, ":")[1]
							minetest.log("warning", "sys4_quests.updateQuest (triggered by mod '"..mod.."'): '"..nodeMod.."' mod not fully supported : Target node '"..targetNode.."' not found.")
						end
					end
				end

				if items ~= nil and type(items) == "table" then
					for __,item in ipairs(items) do
						if minetest.registered_nodes[item] or minetest.registered_items[item] then
							table.insert(quest[6], item)
						else
							local itemMod = string.split(item, ":")[1]
							minetest.log("warning", "sys4_quests.updateQuest (triggered by mod '"..mod.."'): '"..itemMod.."' mod not fully supported : Unlockable item '"..item.."' not found.")
						end
					end
					
					local questDescription = quests.registered_quests['sys4_quests:'..questName].description
					questDescription = questDescription..print_itemsUnlocked(items)
					quests.registered_quests['sys4_quests:'..questName].description = questDescription
				end
			end
		end
	end
end

local function get_questGraph(parent)
	local questTrees = nil

	if not parent then
		for mod, registeredQuest in pairs(sys4_quests.registeredQuests) do
			for _, quest in ipairs(registeredQuest.quests) do
				if not quest[7] or #quest[7] == 0 then
					if not questTrees then questTrees = {} end
					local questTree = { quest = quest,
											  childs = get_questGraph(quest[1])
					}
					table.insert(questTrees, questTree)
				end
			end
		end
	else
		for mod, registeredQuest in pairs(sys4_quests.registeredQuests) do
			for _, quest in ipairs(registeredQuest.quests) do
				if quest[7] and quest[7][1] == parent then
					if not questTrees then questTrees = {} end
					local questTree = { quest = quest,
											  childs = get_questGraph(quest[1])
					}
					table.insert(questTrees, questTree)
				end
			end
		end
	end

	return questTrees
end

local function has_item_to_unlock(quest_graph, itemToVerify)
	if quest_graph and itemToVerify then
		local hasItem = false
		for _, quest in ipairs(quest_graph) do
			for _, item in ipairs(quest.quest[6]) do
				if item == itemToVerify then
					hasItem = true
					break
				end
			end
			if not hasItem and quest.childs then
				hasItem = has_item_to_unlock(quest.childs, itemToVerify)
			end
		end
		return hasItem
	end
end

local function clean_itemsToUnlock(quest_graph)
	if quest_graph then
		for _, quest in ipairs(quest_graph) do
			local items_unlock = quest.quest[6]
			local items_unlock_new = {}
			for _, item in ipairs(items_unlock) do
				if quest.childs then
					if not has_item_to_unlock(quest.childs, item) then
						table.insert(items_unlock_new, item)
					end
				else
					table.insert(items_unlock_new, item)
				end
			end

			for mod, rQuests in pairs(sys4_quests.registeredQuests) do
				for _, rQuest in ipairs(rQuests.quests) do
					if rQuest[1] == quest.quest[1] then
						rQuest[6] = items_unlock_new
					end
				end
			end

			clean_itemsToUnlock(quest.childs)
		end
	end
end

local lastQuestIndex = 0

function sys4_quests.registerQuests()
	-- Clean items to unlock
	clean_itemsToUnlock(get_questGraph(nil))
	
	for mod, registeredQuests in pairs(sys4_quests.registeredQuests) do
		local modIntllib = registeredQuests.intllib

		-- init quests index
		for _, quest in pairs(registeredQuests.quests) do
			local maxlevel = quest[5] * sys4_quests.level
			if quest.custom_level then
				maxlevel = quest[5]
			end

			-- If a target node or item is inexistant then remove it.
			local targets = {}
			for k, node in ipairs(quest[4]) do
				if minetest.registered_nodes[node]
					or minetest.registered_items[node]
					or (string.split(node, ":")[1] == "group"
							 and get_itemGroup(string.split(node, ":")[2]))
				then
					table.insert(targets, node)
				else
					local nodeMod = string.split(node, ":")[1]
					minetest.log("warning", "sys4_quests.registerQuests (triggered by mod '"..mod.."'): '"..nodeMod.."' mod not fully supported --> target node '"..node.."' not found.")
				end
			end
			quest[4] = targets
			
			-- If an unlockable node or item is inexistant then remove it.
			local items = {}
			for k, item in ipairs(quest[6]) do
				if minetest.registered_nodes[item]
					or minetest.registered_items[item]
					or (string.split(item, ":")[1] == "group"
							 and get_itemGroup(string.split(item, ":")[2]))
				then
					table.insert(items, item)
				else
					local itemMod = string.split(item, ":")[1]
					minetest.log("warning", "sys4_quests.registerQuests (triggered by mod '"..mod.."'): '"..itemMod.."' mod not fully supported --> unlockable item '"..item.."' not found.")
				end
			end
			quest[6] = items
			
			-- Register quest
			if quests.register_quest(
				"sys4_quests:"..quest[1],
				{ title = modIntllib(quest[2]),
				  description = format_description(quest, maxlevel, modIntllib),
				  max = maxlevel,
				  --autoaccept = sys4_quests.has_dependences(quest[1]),
				  autoaccept = true,
				  callback = sys4_quests.nextQuest
				})
			then
				lastQuestIndex = lastQuestIndex + 1
				quest.index = lastQuestIndex

				print("Quest Registered : "..quest[1])
				
				-- insert quest index in specified group
				if not quest.group then
					table.insert(sys4_quests.questGroups['global'].questsIndex, quest.index)
				elseif sys4_quests.questGroups[quest.group] ~= nil then
					--	       print("Insert New QuestGroup : "..quest.group)
					table.insert(sys4_quests.questGroups[quest.group].questsIndex, quest.index)
				end

			elseif not quests.registered_quests["sys4_quests:"..quest[1] ].autoaccept
			and has_dependences(quest[1]) then
				quests.registered_quests["sys4_quests:"..quest[1] ].autoaccept = true
			end
			
		end
	end
end

