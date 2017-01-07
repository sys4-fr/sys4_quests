local S = sys4_quests.S

function sys4_quests.save()
	local data = {}
	for name, player in pairs (sys4_quests.playerList) do
		data[name] = {new = player.isNew,
						  craftmode = player.craftMode,
						  bookmode = player.bookMode,
						  current_questGroup = player.activeQuestGroup,
						  progress_data = player.progress_data:serialize()
		}
	end
	local file = io.open(minetest.get_worldpath().."/sys4_quests.txt", "w")
	if file then
		file:write(minetest.serialize(data))
		file:close()
	end
end

local function get_first_questGroup()
	for name, group in pairs(sys4_quests.questGroups) do
		if group.order == 2 then
			return name
		end
	end
	return nil
end

function sys4_quests.load(playern)
	local file = io.open(minetest.get_worldpath().."/sys4_quests.txt", "r")
	if file then
		local data = minetest.deserialize(file:read("*all"))[playern]
		data.progress_data = progress_tree.deserialize_player_data(sys4_quests.quests_tree, data.progress_data)
		return { name = playern,
					isNew = data.new,
					craftMode = data.craftmode,
					bookMode = data.bookmode,
					activeQuestGroup= data.current_questGroup,
					progress_data = data.progress_data
		}
	end

	local firstQuestGroup = get_first_questGroup()
	if not firstQuestGroup then
		firstQuestGroup = 'global'
	end
	return {name = playern,
			  isNew = true,
			  craftMode = true,
			  bookMode = false,
			  activeQuestGroup = firstQuestGroup,
			  progress_data = progress_tree.new_player_data(sys4_quests.quests_tree)
	}
end

function sys4_quests.new_tree()
	return progress_tree.new_tree()
end

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

function sys4_quests.replace_quest(quest)
	if quest[1] then
		for _, quests in pairs(sys4_quests.registeredQuests) do
			for _, currentQuest in ipairs(quests.quests) do
				if currentQuest[1] == quest[1] then
					currentQuest = quest
				end
			end
		end
	end
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

local function is_diggable_by(itemName, itemTool)
	if itemTool then
		local item = minetest.registered_items[itemTool]
		if item.tool_capabilities then
			local toolGroup = item.tool_capabilities.groupcaps
			local group = nil
			if toolGroup.cracky then
				group = "cracky"
			elseif toolGroup.choppy then
				group = "choppy"
			elseif toolGroup.crumbly then
				group = "crumbly"
			elseif toolGroup.snappy then
				group = "snappy"
			end

			if toolGroup[group].times[minetest.get_item_group(itemName, group)]
			then return true
			else return false	end
		else return false	end
	else return false end
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
		local dbg = (questTrees[i]:get_quest():get_name() == "default_glass_quest" and mod == "vessels")
		or (questTrees[i]:get_quest():get_name() == "group_stick_quest" and mod == "farming")
		if dbg then
			print("Add itemChilds Mod : "..mod)
		end
		local itemChilds = get_itemChilds(questTrees[i]:get_quest():get_item():get_name(), mod)
		if dbg then
			print("dump :"..dump(itemChilds))
		end
		if itemChilds then
			questTrees[i]:get_quest():get_item():add_childs(itemChilds)
		end

		local childQuests = questTrees[i]:get_quest():get_questTrees()
		if childQuests then
			add_itemChilds(childQuests, mod)
		end
	end
end

local function get_minimum_tool_item(item)
	local deb = true
	
	if item:is_hand_diggable() then return nil end

	if deb then print("Is Not hand_diggable !!!") end
	
	local tool_shovel = item:get_def().groups.crumbly
	local tool_axe = item:get_def().groups.choppy
	local tool_pick = item:get_def().groups.cracky
	local tool_sword = item:get_def().groups.snappy

	local tool_level = 0
	local tool_type
	if tool_axe then tool_level = tool_axe; tool_type = "choppy"
	elseif tool_shovel then tool_level = tool_shovel; tool_type = "crumbly"
	elseif tool_pick then tool_level = tool_pick; tool_type = "cracky"
	elseif tool_sword then tool_level = tool_sword; tool_type = "snappy"
	else return nil end

	if deb then print("Tool Type : "..tool_type) end

	local tools_found = {}
	for name, rItem in pairs(minetest.registered_items) do
		local tool_item  = sys4_quests.MinetestItem(rItem, nil)
		if tool_item:is_tool() then
			if deb then print("get tool : "..tool_item:get_name()) end
			if item:is_diggable_by(tool_item) then
				if deb then print(item:get_name().." is diggable by "..tool_item:get_name()) end
				table.insert(tools_found, tool_item)
			end
		end
	end

	if deb then print("Tools found : "..#tools_found) end

	local minimal_tool = nil
	for i, tool in ipairs(tools_found) do
		if not minimal_tool then
			minimal_tool = tool
		elseif tool:get_field("tool_capabilities").groupcaps[tool_type] and minimal_tool:get_field("tool_capabilities").groupcaps[tool_type]
			and minimal_tool:get_field("tool_capabilities").groupcaps[tool_type].times[tool_level] <= tool:get_field("tool_capabilities").groupcaps[tool_type].times[tool_level]
		then
			minimal_tool = tool
		end
	end

	return minimal_tool
end

local function rebuild_questTrees(questTrees)
	local newQuestTrees = {}

	for i=1, #questTrees do
		local treeToMove = questTrees[i]
		local isAdded = false

		local treeMove_item = treeToMove:get_quest():get_item()
		local item_targets = treeToMove:get_quest():get_target_items()
		local tool_item = nil
		if item_targets then
			for _, target in ipairs(item_targets) do
				if target ~= treeMove_item:get_name() and not tool_item and string.split(target, ":")[1] ~= "group" then
					print("TARGET :"..target.." of "..treeMove_item:get_name())
					tool_item = get_minimum_tool_item(sys4_quests.MinetestItem(minetest.registered_items[target], nil))
					break
				end
			end
		end
		
		--if not tool_item then
		--	tool_item = get_minimum_tool_item(treeMove_item)
		--end
		
		for j=i, #questTrees do
			if j ~= i then		
				local currentTree = nil
				if tool_item then
					currentTree = questTrees[j]:get_last_tree_with_item_child(tool_item:get_name())
				else
					currentTree = questTrees[j]:get_tree_with_item_child(treeMove_item:get_name())
					--currentTree = questTrees[j]:get_last_tree_with_item_child(treeMove_item:get_name())
				end
				
				--DEBUG
				if treeMove_item:get_name() == "default:iron_lump" then
					print("TreeToMove Item : "..treeMove_item:get_name())
					local tool_str = "nil"
					local tree_str = "nil"
					if tool_item then tool_str = tool_item:get_name() end
					if currentTree then tree_str = currentTree:get_quest():get_name() end
					print("Tool Item : "..tool_str)
					print("CurrentTree : "..tree_str)
				end
				--
				
				if currentTree	then
					currentTree:add(treeToMove)
					isAdded = true
					break
				end
			end
		end
		if not isAdded then
			for k=1, #newQuestTrees do
				local currentTree = nil
				if tool_item then
					currentTree = newQuestTrees[k]:get_last_tree_with_item_child(tool_item:get_name())
				else
					currentTree = newQuestTrees[k]:get_tree_with_item_child(treeMove_item:get_name())
					--currentTree = newQuestTrees[k]:get_last_tree_with_item_child(treeMove_item:get_name())
				end

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

local function make_quests(mod, questTrees, parentQuest)
	local registerQuests = {}

	for i=1, #questTrees do
		local quest = questTrees[i]:get_quest()

		if quest:get_item():get_field("mod_origin") == mod then
			local questName = quest:get_name()
			local questTitle = questName -- Titre par défaut, devrait être changé
			local questDescription = nil -- Peut être changé
			local itemTarget = quest:get_target_items()
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
			for k, questT in ipairs(make_quests(mod, childs, quest:get_name())) do
				table.insert(registerQuests, questT)
			end
		end
	end
	return registerQuests
end

local function make_auto_quests(mod, intllib)
	local modItems = get_modItems(mod)
	if modItems then
		
		-- Construction de l'arbre des quêtes
		if not sys4_quests.questTrees then sys4_quests.questTrees = {} end
		local questTrees = sys4_quests.questTrees

		-- ajout d'items provenant du mod pouvant être rajoutés
		-- dans l'arbre de quetes déjà existant.
		add_itemChilds(questTrees, mod)
		
		-- debug
		local dbg = mod == "vessels"
		if dbg then
			for i, tree in ipairs(questTrees) do
				local tree_tmp = tree:get_tree("default_glass_quest")
				if tree_tmp then
					print(dump(tree_tmp:get_quest():get_item():get_childs()))
				end
			end
		end
		
		local rootQuests = {}

		if modItems:get_items() then
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

		else
			print("No items for mod : "..mod)
		end

		local treeLen = 0
		local loop = 0
		while treeLen ~= #questTrees do
			treeLen = #questTrees
			questTrees = rebuild_questTrees(questTrees)
			loop = loop + 1
		end

		sys4_quests.questTrees = questTrees

		if dbg then
			for i, tree in ipairs(questTrees) do
				local tree_tmp = tree:get_tree("default_glass_quest")
				if tree_tmp then
					print(dump(tree_tmp:get_quest():get_item():get_childs()))
				end
			end
		end
	end
end

local function intllib_by_item(item)
	return sys4_quests.S
end

local function print_itemsUnlocked(items)
	local str = ""
	if not items then return str end
	for _, item in ipairs(items) do
		local itemMod = string.split(item, ":")[1]
		local intllibMod
		if itemMod == "group" then
			-- TODO
			intllibMod = sys4_quests.intllib["default"]
		else
			intllibMod = sys4_quests.intllib[itemMod]
		end
		str = str.." - "..intllibMod(item).."\n"
	end

	return str
end

local function format_description(quest, level, intllib)
	local questType = quest:get_action()
	local targetCount = quest:get_targetCount()
	local customDesc = quest:get_description()

	local str = S(questType).." "..targetCount.." "
	if customDesc ~= nil then
		str = str..intllib(customDesc).."."
	else
		local itemTarget = quest:get_target_items()[1]
		local item_intllib = intllib_by_item(itemTarget)
		str = str..item_intllib(itemTarget).."."
	end

	-- Print Unlocked Items
	str = str.."\n \n"..S("The end of the quest unlock this items").." :\n"
	return str..print_itemsUnlocked(quest:get_item():get_childs())
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

function sys4_quests.next_quests(playername, current_quest)
	print("Next Quest :")
	local player_data = sys4_quests.playerList[playername].progress_data
	print(dump(player_data))
	local squests = sys4_quests.quests

	for quest in pairs(player_data.available) do
		if "sys4_quests:"..squests[quest]:get_name() == current_quest then
			player_data:learn(quest)
			break
		end
	end
	
	for quest in pairs(player_data.available) do
		minetest.after(1, function()
			quests.start_quest(playername, "sys4_quests:"..squests[quest]:get_name())
		end)
	end

	sys4_quests.save()
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

function sys4_quests.set_parent_questTree(quest, parentQuest)
	local treeToMove = nil
	for i, tree in ipairs(sys4_quests.questTrees) do
		treeToMove = tree:get_tree(quest)
		if treeToMove then break end
	end

	if not treeToMove then error("Tree '"..quest.."' not found !") end

	local parentTree = nil
	if parentQuest then
		for i, tree in ipairs(sys4_quests.questTrees) do
			parentTree = tree:get_tree(parentQuest)
			if parentTree then break end
		end

		if not parentTree then error("Parent tree '"..parentQuest.."' not found !") end
	end
	
	-- rebuild child trees of the parent treeToMove
	local parent_treeToMove = treeToMove:get_parent()
	
	if parent_treeToMove then
		for i, tree in ipairs(sys4_quests.questTrees) do
			local currentTree = tree:get_tree(parent_treeToMove:get_quest():get_name())
			if currentTree and currentTree:get_quest():get_questTrees() then
				
				local new_childTrees = nil
				for j, tree2 in ipairs(currentTree:get_quest():get_questTrees()) do
					if tree2:get_quest():get_name() ~= quest then
						if not new_childTrees then new_childTrees = {} end
						table.insert(new_childTrees, tree2)
					end
				end

				currentTree:get_quest().questTrees = new_childTrees
			end
		end
	end

	local new_trees = {}
	
	-- add treeToMove to parentTree
	if parentTree then
		parentTree:add(treeToMove)
	else
		table.insert(new_trees, treeToMove)
	end

	-- rebuild questTrees
	for i, tree in ipairs(sys4_quests.questTrees) do
		if tree:get_quest():get_name() ~= quest then
			table.insert(new_trees, tree)
		end
	end

	sys4_quests.questTrees = new_trees
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

function sys4_quests.get_tree(treeName)
	local treeFound = nil
	for i, tree in ipairs(sys4_quests.questTrees) do
		treeFound = tree:get_tree(treeName)
		if treeFound then return treeFound end
	end
	return nil
end

function sys4_quests.del_tree(treeName)
	for i, tree in ipairs(sys4_quests.questTrees) do
		if tree:get_tree(treeName) then
			local parentTree = tree:get_tree(treeName):get_parent()
			
			if parentTree then
				local new_childs = nil
				for j, childTree in ipairs(parentTree:get_quest():get_questTrees()) do
					if childTree:get_quest():get_name() ~= treeName then
						if not new_childs then new_childs = {} end
						table.insert(new_childs, childTree)
					end
				end
				parentTree:get_quest().questTrees = new_childs
			else
				table.remove(sys4_quests.questTrees, i)
				break
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
				if quest[7] and (quest[7] == parent or quest[7][1] == parent) then
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

function sys4_quests.register_mod(mod, intllib)
	if not minetest.get_modpath(mod) then
		error("Mod '"..mod.."' not found !")
	end

	sys4_quests.intllib[mod] = intllib
end

function sys4_quests.register_mod_quests(mod, questList, intllib)
	if not minetest.get_modpath(mod) then
		error("Mod '"..mod.."' not found !")
	end

	sys4_quests.intllib[mod] = intllib
	sys4_quests.quests = questList

	for _, quest in pairs(questList) do
		if quests.register_quest(
			"sys4_quests:"..quest:get_name(),
			{ title = intllib(quest:get_name()),
				  description = format_description(quest, intllib),
				  max = quest:get_targetCount(),
				  --autoaccept = sys4_quests.has_dependences(quest[1]),
				  autoaccept = true,
				  callback = sys4_quests.next_quests
				})
		then
			local index = 0
			for i in pairs(sys4_quests.quests) do
				index = index + 1
			end
			quest:set_index(index + 1)

			print("Quest Registered : "..quest:get_name())
				
			-- insert quest index in specified group
			table.insert(sys4_quests.questGroups[quest:get_groupQuest()].questsIndex, index)

		end
	end
end

local lastQuestIndex = 0

function sys4_quests.registerQuests()
	-- remplissage des quêtes à enregistrer
	for mod, _ in pairs(sys4_quests.registeredQuests) do
		sys4_quests.registeredQuests[mod].quests = make_quests(mod, sys4_quests.questTrees, nil)
	end
		
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

local function get_items_by_group(groups)
	if type(groups) == "string" then groups = {groups} end

	local items = {}
	for _, group in ipairs(groups) do
		for name, item in pairs(minetest.registered_items) do
			if minetest.get_item_group(name, group) >= 1 then
				table.insert(items, name)
			end
		end
	end
	return items
end

function sys4_quests.build_quests(quest_tree, coord, auto)

	local quests = {}
	local items = sys4_quests.MinetestItems()

	local old_quests = sys4_quests.quests
	
	for name in pairs(quest_tree) do
		if not old_quests or not old_quests[name] then
			
			local item = minetest.registered_items[name]
			
			if not item and get_groups(name) then
				item = minetest.registered_items[get_items_by_group(get_groups(name))[1] ]
			end
			
			if item then
				items:add(item)
			else
				error("sys4_quests : item unknown !")
			end
		end
	end

	if old_quests then
		quests = old_quests
	end

	if items:get_items() then
		for _, item in ipairs(items:get_items()) do
			quests[item:get_name()] = sys4_quests.Quest(item, coord[item:get_name()], auto)
		end
	end

	sys4_quests.quests_tree = quest_tree
	return quests
end
