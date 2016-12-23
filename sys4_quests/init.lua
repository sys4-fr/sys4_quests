-- Sys4 Quests
-- By Sys4

-- This mod provide an api that could be used by others mods for easy creation of quests.
local modpath = minetest.get_modpath(minetest.get_current_modname())
dofile(modpath.."/mod_patch.lua")

local S
if minetest.get_modpath("intllib") then
	S = intllib.Getter()
else
	S = function(s) return s end
end

-- New Waste Node
minetest.register_node(
	"sys4_quests:waste",
	{
		description = S("Waste"),
		tiles = {"waste.png"},
		is_ground_content = false,
		groups = {crumbly=2, flammable=2},
	})

-- init
sys4_quests = {}
sys4_quests.questGroups = {}
sys4_quests.questGroups['global'] = {order = 1, questsIndex = {}}

local lastQuestIndex = 0
local level = 1
local playerList = {}

local groupsToVerify = {"tree", "wood", "flower", "dye", "wool", "sand", "stone", "soil", "stick", "leaves"}

-- Classes Definitions
local QuestTree = {}
local Quest = {}
QuestTree.__index = QuestTree
Quest.__index = Quest

local MinetestItem = {}  -- My custom item data
local MinetestItems = {} -- Collection of my custom items

MinetestItem.__index = MinetestItem
MinetestItems.__index = MinetestItems

setmetatable(MinetestItem, {
					 __call = function (cls, ...)
						 return cls.new(...)
					 end,
})

setmetatable(MinetestItems, {
					 __call = function(cls, ...)
						 return cls.new(...)
					 end,
})

setmetatable(QuestTree, {
					 __call = function (cls, ...)
						 return cls.new(...)
					 end,
})

setmetatable(Quest, {
					 __call = function (cls, ...)
						 return cls.new(...)
					 end,
})

-- Constructors

function QuestTree.new(quest)
	local self = setmetatable({}, QuestTree)
	self.quest = quest
	return self
end

function Quest.new(item)
	local self = setmetatable({}, Quest)
	self.item = item
	local splittedName = string.split(item:get_name(), ":")
	self.name = splittedName[1].."_"..splittedName[2].."_quest"
	self.questTrees = nil
	return self
end

local function get_item_recipes(itemName)
	local groupSplit = string.split(itemName, ":")
	local recipes = nil
	
	if groupSplit[1] == "group" then
		local group = groupSplit[2]
		for name, item in pairs(minetest.registered_items) do
			if minetest.get_item_group(name, group) > 0 then
				local itemRecipes = minetest.get_all_craft_recipes(name)
				if itemRecipes then
					for i, recipe in ipairs(itemRecipes) do
						if not recipes then recipes = {} end
						table.insert(recipes, recipe)
					end
				end
			end
		end
	else
		recipes = minetest.get_all_craft_recipes(itemName)
	end
	return recipes
end

function MinetestItem.new(item, childs)
	local self = setmetatable({}, MinetestItem)
	self.stack = ItemStack(item.name)
	self.name = item.name
	self.def = item
	self.recipes = get_item_recipes(item.name)
	self.childs = childs
	return self
end

function MinetestItems.new()
	local self = setmetatable({}, MinetestItems)
	self.items = nil
	return self
end

-- Quest methods

function Quest:get_name()
	return self.name
end
function Quest:set_name(name)
	self.name = name
end

function Quest:get_item()
	return self.item
end

function Quest:get_questTrees()
	return self.questTrees
end

function Quest:add(questTree)
	if self.questTrees == nil then self.questTrees = {} end
	table.insert(self.questTrees, questTree)
end

function Quest:get_targetCount()
	local itemTarget = self:get_item()
	local count = 9
	if itemTarget:has_childs() then
		local itemChilds = {}
		for i, itemChild in ipairs(itemTarget:get_childs()) do
			local itemSplit = string.split(itemChild, ":")
			if itemSplit[1] == "group" then
				local group = itemSplit[2]
				for itemName, _ in pairs(minetest.registered_items) do
					if minetest.get_item_group(itemName, group) >= 1 then
						table.insert(itemChilds, itemName)
					end
				end
			else
				table.insert(itemChilds, itemChild)
			end
		end
		for i, itemChild in ipairs(itemChilds) do
			local recipes = minetest.get_all_craft_recipes(itemChild)
			if recipes then
				for j, recipe in ipairs(recipes) do
					local sCount = 0
					for k, ingredient in ipairs(recipe.items) do
						if ingredient == itemTarget:get_name() then
							sCount = sCount + 1
						end
					end
					
					if sCount > 0 and count > sCount then
						count = sCount
					end
				end
			end
		end
	end

	return count
end

function Quest:get_action()
	local action = nil
	local item = self:get_item()

	if not item:get_recipes() then
		action = "dig"
	else
		action = "craft"
		for i, recipe in ipairs(item:get_recipes()) do
			if recipe.type == "cooking" then
				action = "cook"
			end
		end
	end
	return action
end

-- QuestTree methods

function QuestTree:add(questTree)
	self:get_quest():add(questTree)
end

local count = 0
function QuestTree:get_tree_with_item_child(name)
	count = count + 1
	print (count..": "..name)
	local treeFound = nil
	local itemChilds = self:get_quest():get_item():get_childs()
	for i=1, #itemChilds do
		if itemChilds[i] == name then
			treeFound = self
			break
		end
	end
	if not treeFound then
		local childQuestTrees = self:get_quest():get_questTrees()
		if childQuestTrees then
			for i=1, #childQuestTrees do
				treeFound = childQuestTrees[i]:get_tree_with_item_child(name)
				if treeFound then break end
			end
		end
	end

	return treeFound
end

function QuestTree:get_quest()
	return self.quest
end

-- MinetestItem methods

function MinetestItem:get_stack()
	return self.stack
end

function MinetestItem:get_name()
	return self.name
end

function MinetestItem:get_field(fieldName)
	if fieldName then return self.def[fieldName] end
	return nil
end

function MinetestItem:get_def()
	return self.def
end

function MinetestItem:get_recipes(tRecipe)
	if self.recipes then
		local recipes = nil
		for _, recipe in ipairs(self.recipes) do
			if not tRecipe or recipe.type == tRecipe then
				if not recipes then recipes = {} end
				table.insert(recipes, recipe)
			end
		end
		
		return recipes
	else
		return nil
	end
end

function MinetestItem:get_childs()
	return self.childs
end

function MinetestItem:has_childs()
	return self:get_childs()
end

function MinetestItem:has_child(name)
	if self:has_childs() then
		for _, child in ipairs(self:get_childs()) do
			if child == name then
				return true
			end
		end
	end
	return false
end

function MinetestItem:add_child(child)
	for _, group in ipairs(groupsToVerify) do
		if minetest.get_item_group(child, group) > 0 then
			child = "group:"..group
		end
	end

	if not self:has_childs() then
		self.childs = {}
	end

	local isPresent = false
	for _, currentChild in ipairs(self:get_childs()) do
		if currentChild == child then
			isPresent = true
		end
	end
	if not isPresent then
		table.insert(self.childs, child)
	end
end

function MinetestItem:is_tool()
	if self:get_field("tool_capabilities") then return true end
	return false
end

function MinetestItem:is_hand_diggable()
	local groups = self:get_field("groups")
	if groups.crumbly and not groups.cracky
		or groups.snappy and not groups.choppy
		or groups.choppy and groups.oddly_breakable_by_hand
	then
		return true
	end
	return false
end

function MinetestItem:is_diggable_by(itemTool)
	if itemTool then
		if itemTool:is_tool() then
			local toolGroup = itemTool:get_field("tool_capabilities").groupcaps
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

			if toolGroup[group].times[minetest.get_item_group(self:get_name(), group)]
			then return true
			else return false	end
		else return false	end
	else return self:is_hand_diggable()	end
end

-- MinetestItems methods

function MinetestItems:add(item, childs)
	if not self.items then self.items = {} end
	for _, group in ipairs(groupsToVerify) do
		if minetest.get_item_group(item.name, group) > 0 then
			item.name = "group:"..group
		end
	end

	local isAdded = false
	for _, currentItem in ipairs(self.items) do
		if currentItem:get_name() == item.name then
			isAdded = true
			if childs then
				for __, child in ipairs(childs) do
					currentItem:add_child(child)
				end
			end
		end
	end
	if not isAdded then
		table.insert(self.items, MinetestItem(item, childs))
	end
end

function MinetestItems:get_items()
	return self.items
end

function MinetestItems:get_item(itemName)
	for _, item in ipairs(self:get_items()) do
		if item:get_name() == itemName then
			return item
		end
	end
	return nil
end

function MinetestItems:get_itemField(itemName, fieldName)
	local item = self:get_item(itemName)
	if item then return item:get_field(fieldName) end
	return nil
end

-- Sys4_Quests

function sys4_quests.addInitialStuff(stack)
	if not sys4_quests.stuff or sys4_quests.stuff == nil then
		sys4_quests.stuff = {}
	end

	if stack ~= nil then
		table.insert(sys4_quests.stuff, stack)
	end
end

function sys4_quests.addQuestGroup(groupName)

	if groupName ~= nil and groupName ~= "" and groupName ~= "global" then
		local groupLen = 0
		for _, group in pairs(sys4_quests.questGroups) do
			groupLen = groupLen + 1
		end
		sys4_quests.questGroups[groupName] = {order = groupLen + 1,
														  questsIndex = {}}
	end
end

local function isGroupExist(groupName)
	for name, group in pairs(sys4_quests.questGroups) do
		if name == groupName then
			return true
		end
	end
	return false
end

local function checkGroupName(groupName)
	if groupName ~= nil and groupName ~= "" and groupName ~= "global" then
		return true
	else
		return false
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

local function isQuestActive(questName, playern)
	if quests.active_quests[playern] ~= nil
	and quests.active_quests[playern]["sys4_quests:"..questName] ~= nil then
		return true
	else
		return false
	end
end

local function isQuestSuccessfull(questName, playern)
	if quests.successfull_quests[playern] ~= nil
		and quests.successfull_quests[playern]["sys4_quests:"..questName] ~= nil
	then
		return true else return false
	end
end

local function getGroupByQuestIndex(questIndex)
	local groupName = nil
	local isFound = false
	for name, group in pairs(sys4_quests.questGroups) do
		for _, index in ipairs(group.questsIndex) do
			if index == questIndex and name ~= "global" then
				groupName = name
				isFound = true
				break
			end
		end
		if isFound then break end
	end

	return groupName
end

local function getActiveQuestGroup(playern)
	local groupName = nil
	local isFound = false
	for mod, registeredQuests in pairs(sys4_quests.registeredQuests) do
		for _, quest in ipairs(registeredQuests.quests) do
			if isQuestActive(quest[1], playern) then
				groupName = getGroupByQuestIndex(quest.index)
				if groupName ~= nil then
					isFound = true
					break
				end
			end
		end
		if isFound then break end
	end
	return groupName
end

local function getFirstQuestGroup()
	for name, group in pairs(sys4_quests.questGroups) do
		if group.order == 2 then
			return name
		end
	end
	return nil
end

local function getQuestGroupOrder(questGroup)
	for name, group in pairs(sys4_quests.questGroups) do
		if name == questGroup then
			return group.order
		end
	end
	return nil
end

local function getQuestGroupByGroupOrder(order)
	for name, group in pairs(sys4_quests.questGroups) do
		if group.order == order then
			return name
		end
	end
	return nil
end

local function getNextQuestGroup(currentQuestGroup)
	local groupTotal = 0
	for _, group in pairs(sys4_quests.questGroups) do
		groupTotal = groupTotal + 1
	end

	local groupOrder = getQuestGroupOrder(currentQuestGroup)

	if groupOrder == nil or groupOrder == groupTotal then
		return nil
	else
		return getQuestGroupByGroupOrder(groupOrder + 1)
	end
end

-- Experimental functions for registering quests automatically

local function containsItem(liste, item)
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

local function get_item_childs(itemName, mod)
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
							if ingredients[i] == itemName then
								sameGroup = true
							elseif get_groups(ingredients[i]) then
								for ___, group in ipairs(get_groups(ingredients[i])) do
									sameGroup = minetest.get_item_group(itemName, group) > 0
								end
							end
							
							if sameGroup then
								if not childs then childs = {} end
								if not containsItem(childs, name) then
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

local function rebuildQuestTrees(questTrees)
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

local function get_mod_items(mod)
	local modItems = MinetestItems()
	
	if mod and minetest.get_modpath(mod) then
		for name, item in pairs(minetest.registered_items) do
			if string.split(name, ":")[1] == mod
			and check_item(name) then
				modItems:add(item, get_item_childs(name, mod))
			end
		end
	else
		minetest.log("error", "sys4_quests: Mod "..mod.." not found !")
	end
	
	return modItems
end

local function makeQuests(mod, questTrees, parentQuest)
	local registerQuests = {}

	for i=1, #questTrees do
		local quest = questTrees[i]:get_quest()

		if quest:get_item():get_field("mod_origin") == mod then
			local questName = quest:get_name()
			local questTitle = questName -- Titre par défaut, devrait être changé
			local questDescription = nil -- Peut être changé
			local itemTarget = quest:get_item():get_name()
			local targetCount = quest:get_targetCount()
			local items_to_unlock = quest:get_item():get_childs()
			local action = quest:get_action()
			
			table.insert(registerQuests,
							 { questName,
								questTitle,
								questDescription,
								{itemTarget},
								targetCount,
								items_to_unlock,
								{parentQuest},
								type = action
			})
		end
		local childs = quest:get_questTrees()
		if childs then
			for j, child in ipairs(childs) do
				for k, questT in ipairs(makeQuests(mod, childs, quest:get_name())) do
					table.insert(registerQuests, questT)
				end
			end
		end
	end
	return registerQuests
end

local function makeAutoQuests(mod, intllib)
	local modItems = get_mod_items(mod)
	if modItems then
		-- Construction de l'arbre des quêtes
		local questTrees = sys4_quests.questTrees
		local rootQuests = {}

		for _, item in ipairs(modItems:get_items()) do
			if item:has_childs()
				and item:is_hand_diggable()
				and not item:get_recipes()
			then
				local questTree = QuestTree(Quest(item))
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
					local questTree = QuestTree(Quest(item))
					table.insert(questTrees, questTree)
				end
			end
		end

		local treeLen = 0
		local loop = 0
		while treeLen ~= #questTrees do
			treeLen = #questTrees
			questTrees = rebuildQuestTrees(questTrees)
			loop = loop + 1
		end
		print("rebuildQuestTrees loop:"..loop)
		print("questTrees length: "..#questTrees)
		print("RootQuest length: "..#rootQuests)

		-- remplissage des quêtes à enregistrer
		sys4_quests.registeredQuests[mod].quests = makeQuests(mod, questTrees, nil)
		sys4_quests.questTrees = questTrees
	end
end

local function isQuestExist(questName)
	for mod, registeredQuests in pairs(sys4_quests.registeredQuests) do
		for _, quest in ipairs(registeredQuests.quests) do
			if quest[1] == questName then
				return true
			end
		end
	end
	return false
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
	sys4_quests.questTrees = {}
	if auto then
		makeAutoQuests(mod, intllib)
	end
	return sys4_quests.registeredQuests[mod].quests
end

local function is_known_group(group)
	for i, knownGroup in ipairs(groupsToVerify) do
		if knownGroup == group then return true end
	end
	return false
end

function sys4_quests.registerQuests()
	for mod, registeredQuests in pairs(sys4_quests.registeredQuests) do
		local modIntllib = registeredQuests.intllib

		-- init quests index
		for _, quest in pairs(registeredQuests.quests) do
			local maxlevel = quest[5] * level
			if quest.custom_level then
				maxlevel = quest[5]
			end

			-- If a target node or item is inexistant then remove it.
			local targets = {}
			for k, node in ipairs(quest[4]) do
				if minetest.registered_nodes[node]
					or minetest.registered_items[node]
					or (string.split(node, ":")[1] == "group"
							 and is_known_group(string.split(node, ":")[2]))
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
							 and is_known_group(string.split(item, ":")[2]))
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
				  description = sys4_quests.formatDescription(quest, maxlevel, modIntllib),
				  max = maxlevel,
				  --autoaccept = sys4_quests.hasDependencies(quest[1]),
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
			and sys4_quests.hasDependencies(quest[1]) then
				quests.registered_quests["sys4_quests:"..quest[1] ].autoaccept = true
			end
			
		end
	end
end

function sys4_quests.intllib_by_item(item)
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
	return sys4_quests.registeredQuests[mod].intllib
end

function sys4_quests.formatDescription(quest, level, intllib)
	local questType = quest.type
	local targetCount = level
	local customDesc = quest[3]

	local str = S(questType).." "..targetCount.." "
	if customDesc ~= nil then
		str = str..intllib(customDesc).."."
	else
		local itemTarget = quest[4][1]
		local item_intllib = sys4_quests.intllib_by_item(itemTarget)
		str = str..item_intllib(itemTarget).."."
	end

	-- Print Unlocked Items
	str = str.."\n \n"..S("The end of the quest unlock this items").." :\n"
	return str..sys4_quests.printUnlockedItems(quest[6])
end

function sys4_quests.printUnlockedItems(items)
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
					questDescription = questDescription..sys4_quests.printUnlockedItems(items)
					quests.registered_quests['sys4_quests:'..questName].description = questDescription
				end
			end
		end
	end
end

function sys4_quests.hasDependencies(questName)
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

local function isParentQuestsAreSuccessfull(parentQuests, currentQuest, playern)
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
				isFinished = isFinished or isQuestSuccessfull(splittedParentQuest, playern)
			end
		end

		isAllFinished = isAllFinished and isFinished
	end

	return isAllFinished
end

local function getNextQuests(questname, playern)
	local insert = table.insert
	local nextQuests = {}

	if questname ~= "" then

		local playerActiveGroup = playerList[playern].activeQuestGroup

		local currentQuest = string.split(questname, ":")[2]

		for mod, registeredQuests in pairs(sys4_quests.registeredQuests) do
			for _, registeredQuest in ipairs(registeredQuests.quests) do

				if registeredQuest[1] ~= currentQuest
					and not isQuestActive(registeredQuest[1], playern)
					and not isQuestSuccessfull(registeredQuest[1], playern)
				then
					local parentQuests = registeredQuest[7]

					if parentQuests ~= nil
						and contains(parentQuests, currentQuest)
					and isParentQuestsAreSuccessfull(parentQuests, currentQuest, playern) then
						insert(nextQuests, registeredQuest)
					end
				end
			end
		end
	end
	return nextQuests
end

local function isAllQuestsGroupSuccessfull(currentQuestGroup, questname, playern)
	local successfull = true
	local currentQuest = string.split(questname, ":")[2]

	for mod, registeredQuests in pairs(sys4_quests.registeredQuests) do
		for _, registeredQuest in ipairs(registeredQuests.quests) do
			if registeredQuest[1] ~= currentQuest
			and getGroupByQuestIndex(registeredQuest.index) == currentQuestGroup then
				successfull = successfull and isQuestSuccessfull(registeredQuest[1], playern)
			end
		end
	end
	return successfull
end

function sys4_quests.nextQuest(playername, questname)
	local nextQuests = getNextQuests(questname, playername)
	local currentQuestGroup = playerList[playername].activeQuestGroup
	local nextQuestGroup = getNextQuestGroup(currentQuestGroup)

	if nextQuestGroup ~= nil
	and isAllQuestsGroupSuccessfull(currentQuestGroup, questname, playername) then
		playerList[playername].activeQuestGroup = nextQuestGroup

		-- start quests of the next group
		for mod, registeredQuests in pairs(sys4_quests.registeredQuests) do
			for _, registeredQuest in ipairs(registeredQuests.quests) do
				if registeredQuest[7] == nil and getGroupByQuestIndex(registeredQuest.index) == nextQuestGroup then
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


local function isNodesEquivalent(nodeTargets, nodeDug)
	for _, nodeTarget in pairs(nodeTargets) do
		local groupSplit = string.split(nodeTarget, ":")
		if groupSplit[1] == "group"
			and minetest.get_item_group(nodeDug, groupSplit[2]) >= 1
		or nodeTarget == nodeDug then	return true	end
	end
	return false
end

local function getCraftRecipes(item)
	local str = ""
	if item ~= nil and item ~= "" then
		local craftRecipes = minetest.get_all_craft_recipes(item)

		if craftRecipes ~= nil then
			local first = true
			for i=1, #craftRecipes do
				if craftRecipes[i].type == "normal" then
					if not first then
						str = str.."\n--- "..S("OR").." ---\n\n"
					end		
					first = false
					
					local width = craftRecipes[i].width
					local items = craftRecipes[i].items
					local maxn = table.maxn(items)
					local h = 0
					local g
					if width == 0 then
						g = 1
						while g*g < maxn do g = g + 1 end
						width = maxn
					else
						h = math.ceil(maxn / width)
						g = width < h and h or width
					end
					
					for y=1, g do
						str = str..y..": "
						for x=1, width do
							local itemIngredient = items[(y-1) * width + x]
							if itemIngredient ~= nil then
								-- local intllib = sys4_quests.intllib_by_item(itemIngredient)
								-- str = str.."'"..intllib(itemIngredient).."' "
								str = str.."["..itemIngredient.."]  "
							else
								str = str.."[                    ]  "
							end
							if x == width then
								str = str.."\n"
							end
						end
					end
				end
			end
		else
			str = S("No craft for this item").."\n"
		end
	end
	return str   
end

local function writeBook(content, items, playern)
	local txt = ""

	if content and content ~= nil then
		txt = txt..content.."\n\n"
	end

	if items and items ~= nil then
		txt = txt..playern.." "..S("has unlocked these crafts").." :"

		local tt= "\n\n"

		for _, item in ipairs(items) do
			
			local intllib = sys4_quests.intllib_by_item(item)
			
			tt = tt..">>>> "..intllib(item).." <<<<\n\n"
			tt = tt..S("Craft recipes").." :\n"
			tt = tt..getCraftRecipes(item).."\n\n"
		end
		txt = txt..tt.."\n"
	end

	return txt
end

local function getRegisteredQuest(questName)
	if questName and questName ~= nil then
		for mod, registeredQuests in pairs(sys4_quests.registeredQuests) do
			for _, registeredQuest in ipairs(registeredQuests.quests) do
				if questName == registeredQuest[1] then
					return registeredQuest
				end
			end
		end
	end

	return nil
end

local function giveBook(playerName, quest)
	if playerName and playerName ~= nil and quest and quest ~= nil then
		local bookItem = ItemStack('default:book_written')
		local registeredQuest = getRegisteredQuest(quest)

		local bookData = {}
		bookData.title = "SYS4 QUESTS : "..registeredQuest[2]
		bookData.text = writeBook(nil, registeredQuest[6], playerName)
		bookData.owner = playerName

		bookItem:set_metadata(minetest.serialize(bookData))

		local receiverRef = core.get_player_by_name(playerName)
		if receiverRef == nil then return end
		receiverRef:get_inventory():add_item("main", bookItem)
	end
end

-- Replace quests.show_message function for customize central_message sounds if the mod is present
if (cmsg) then
	quests.show_message = function (t, playername, text)
		if (quests.hud[playername].central_message_enabled) then
			local player = minetest.get_player_by_name(playername)
			cmsg.push_message_player(player, text, quests.colors[t])
			minetest.sound_play("sys4_quests_" .. t, {to_player = playername})
		end
	end
end

minetest.register_on_newplayer(
	function(player)
		local playern = player:get_player_name()
		local firstQuestGroup = getFirstQuestGroup()
		if firstQuestGroup == nil then
			firstQuestGroup = 'global'
		end
		playerList[playern] = {
			name = playern,
			isNew = true,
			craftMode = true,
			bookMode = false,
			activeQuestGroup = firstQuestGroup
		}

		-- give initial stuff
		if minetest.get_modpath("give_initial_stuff")
			and give_initial_stuff
			and sys4_quests.stuff
		then
			give_initial_stuff.clear()
			local stuff = sys4_quests.stuff
			for i = 1, #stuff do
				give_initial_stuff.add(stuff[i])
			end
			give_initial_stuff.give(player)
		end
	end)

minetest.register_on_joinplayer(
	function(player)
		local playern = player:get_player_name()
		if not playerList[playern] or playerList[playern] == nil then
			local activeGroup = getActiveQuestGroup(playern)
			if activeGroup == nil then
				activeGroup = 'global'
			end
			playerList[playern] = {
				name = playern,
				isNew = false,
				craftMode = true,
				bookMode = false,
				activeQuestGroup = activeGroup
			}
		end

		if (playerList[playern].isNew) then
			for mod, registeredQuests in pairs(sys4_quests.registeredQuests) do
				for _, registeredQuest in ipairs(registeredQuests.quests) do
					if (registeredQuest[7] == nil or #registeredQuest[7] == 0)
						and (getGroupByQuestIndex(registeredQuest.index) == nil
							  or getGroupByQuestIndex(registeredQuest.index) == playerList[playern].activeQuestGroup)	then
							quests.start_quest(playern, "sys4_quests:"..registeredQuest[1])
					end
				end
			end
			
			playerList[playern].isNew = false
		end
	end)


--Called when a button is pressed in player's inventory form
--Newest functions are called first
--#If function returns true, remaining functions are not called
minetest.register_on_player_receive_fields(
	function(player, formname, fields)
		minetest.chat_send_player(player:get_player_name(), "Event register_on_player_receive_fields triggered")
	end)

minetest.register_on_dignode(
	function(pos, oldnode, digger)
		if digger ~= nil then
			local playern = digger:get_player_name()
			for mod, registeredQuests in pairs(sys4_quests.registeredQuests) do
				for _, registeredQuest in ipairs(registeredQuests.quests) do
					local questName = registeredQuest[1]
					local type = registeredQuest.type

					if type == "dig" and isNodesEquivalent(registeredQuest[4], oldnode.name) then
						if quests.update_quest(playern, "sys4_quests:"..questName, 1) then
							minetest.after(1, quests.accept_quest, playern, "sys4_quests:"..questName)
							if playerList[playern].bookMode then
								giveBook(playern, questName)
							end
						end
					end
				end
			end
		end
	end)

minetest.register_on_craft(
	function(itemstack, player, old_craft_grid, craft_inv)
		local playern = player:get_player_name()

		-- DEBUG
		minetest.chat_send_player(playern, "Event register_on_craft triggered")
		local wasteItem = "sys4_quests:waste"
		local itemstackName = itemstack:get_name()
		local itemstackCount = itemstack:get_count()

		for mod, registeredQuests in pairs(sys4_quests.registeredQuests) do
			for _, registeredQuest in ipairs(registeredQuests.quests) do
				local questType = registeredQuest.type
				local questName = registeredQuest[1]
				local items = registeredQuest[6]

--				for __, item in ipairs(items) do	
				if (item == itemstackName or isNodesEquivalent(items, itemstackName))
						and quests.successfull_quests[playern] ~= nil
						and quests.successfull_quests[playern]["sys4_quests:"..questName ] ~= nil
					then
						wasteItem = nil
					end
--				end
			end
		end

		for mod, registeredQuests in pairs(sys4_quests.registeredQuests) do
			for _, registeredQuest in ipairs(registeredQuests.quests) do
				local questType = registeredQuest.type
				local questName = registeredQuest[1]

				if questType == "craft" and wasteItem == nil
				and isNodesEquivalent(registeredQuest[4], itemstackName) then 
					
					if quests.update_quest(playern, "sys4_quests:"..questName, itemstackCount) then
						minetest.after(1, quests.accept_quest, playern, "sys4_quests:"..questName)
						if playerList[playern].bookMode then
							giveBook(playern, questName)
						end
					end
				end
			end
		end

		if wasteItem == nil then
			return wasteItem
		elseif not playerList[playern].craftMode then
			return nil
		else
			return ItemStack(wasteItem)
		end
	end)

local function register_on_placenode(pos, node, placer)
	local playern = placer:get_player_name()

	for mod, registeredQuests in pairs(sys4_quests.registeredQuests) do
		for _, registeredQuest in ipairs(registeredQuests.quests) do
			local questName = registeredQuest[1]
			local type = registeredQuest.type
			
			if type == "place" and isNodesEquivalent(registeredQuest[4], node.name) then
				if quests.update_quest(playern, "sys4_quests:"..questName, 1) then
					minetest.after(1, quests.accept_quest, playern, "sys4_quests:"..questName)
					if playerList[playern].bookMode then
						giveBook(playern, questName)
					end
				end
			end
		end
	end
end

minetest.register_on_placenode(register_on_placenode)

local function register_on_place(itemstack, placer, pointed_thing)
	local node = {}
	node.name = itemstack:get_name()
	register_on_placenode(pointed_thing, node, placer)

	-- Meme portion de code que dans la fonction core.rotate_node
	core.rotate_and_place(
		itemstack, placer, pointed_thing,
		core.setting_getbool("creative_mode"),
		{invert_wall = placer:get_player_control().sneak}
	)

	return itemstack
end

local nodes = {
	minetest.registered_nodes["default:tree"],
	minetest.registered_nodes["default:jungletree"],
	minetest.registered_nodes["default:acacia_tree"],
	minetest.registered_nodes["default:pine_tree"],
	minetest.registered_nodes["default:aspen_tree"]
}

for i=1, #nodes do
	nodes[i].on_place = register_on_place
end

-- Furnace inventory take event
local furnace = minetest.registered_nodes["default:furnace"]
local old_allow_metadata_inventory_take = furnace.allow_metadata_inventory_take
local function allow_metadata_inventory_take(pos, listname, index, stack, player)
	local stackCount = old_allow_metadata_inventory_take(pos, listname, index, stack, player)
	minetest.chat_send_player(player:get_player_name(), "Furnace Event")
	if player ~= nil and listname == "dst" then
		local playern = player:get_player_name()
		for mod, registeredQuests in pairs(sys4_quests.registeredQuests) do
			for _, registeredQuest in ipairs(registeredQuests.quests) do
				local questName = registeredQuest[1]
				
				if registeredQuest.type == "cook" and isNodesEquivalent(registeredQuest[4], stack:get_name()) then
					if quests.update_quest(playern, "sys4_quests:"..questName, stackCount) then
						minetest.after(1, quests.accept_quest, playern, "sys4_quests:"..questName)
						if playerList[playern].bookMode then
							giveBook(playern, questName)
						end
					end
				end
			end
		end
	end
	return stackCount
end	
furnace.allow_metadata_inventory_take = allow_metadata_inventory_take 

minetest.register_chatcommand(
	"lcraft",
	{
		params = "[on|off]",
		description = S("Enable or not locked crafts")..".",
		func = function(name, param)
			if param == "on" then
				playerList[name].craftMode = true
				minetest.chat_send_player(name, S("Locked crafts Enabled")..".")
			else
				playerList[name].craftMode = false
				minetest.chat_send_player(name, S("Locked crafts Disabled")..".")
			end
		end
	})

minetest.register_chatcommand(
	"bookmode",
	{
		params = "[on|off]",
		description = S("Enable or not books that describe unlocked craft recipes")..".",
		func = function(name, param)
			if param == "on" then
				playerList[name].bookMode = true
				minetest.chat_send_player(name, S("Book Mode Enabled")..".")
			else
				playerList[name].bookMode = false
				minetest.chat_send_player(name, S("Book Mode Disabled")..".")
			end
		end
	})

minetest.register_chatcommand(
	"lqg",
	{
		params = "["..S("group index").."]",
		description = S("Display groups of quests or display quests of a group if group index is given as argument")..".",
		func = function(name, param)
			if param ~= "" then
				local isGroupValid = false
				for groupName, group in pairs(sys4_quests.questGroups) do
					if ""..group.order == param then
						isGroupValid = true
						minetest.chat_send_player(name, S("Legend")..":")
						minetest.chat_send_player(name, " [*] <-- "..S("Successfull quest"))
						minetest.chat_send_player(name, " [>] <-- "..S("Active quest"))
						minetest.chat_send_player(name, " [ ] <-- "..S("Not reached quest"))
						minetest.chat_send_player(name, " ")
						minetest.chat_send_player(name, S("Quests of group").." \""..groupName.."\" : ")
						for mod, registeredQuests in pairs(sys4_quests.registeredQuests) do
							local modIntllib = registeredQuests.intllib
							for _, quest in ipairs(registeredQuests.quests) do
								local qIndex = quest.index
								for __, index in ipairs(group.questsIndex) do
									if index == qIndex then
										local questState = "[ ]"
										if isQuestActive(quest[1], name) then
											questState = "[>]"
										end
										if isQuestSuccessfull(quest[1], name) then
											questState = "[*]"
										end
										
										minetest.chat_send_player(name, questState.." "..modIntllib(quest[2]).." ["..quest[1].."]".." {mod: "..mod.."}")
									end
								end
							end
						end
					end
				end

				if not isGroupValid then
					minetest.chat_send_player(name, S("Sorry, but this group doesn't exist")..".")
				end
			else
				local groups = {}
				for groupName, group in pairs(sys4_quests.questGroups) do
					groups[group.order] = groupName
					if playerList[name].activeQuestGroup == groupName then
						groups[group.order] = groupName.." <-- "..S("Active Quests Group")
					end
				end
				
				for i = 1, #groups do
					minetest.chat_send_player(name, i.." - "..groups[i])
				end
			end
		end
	})

minetest.register_chatcommand(
	"lqm",
	{
		params = "["..S("mod name").."]",
		description = S("Display mods currently loaded and supported by quests system or display quests related to given mod as argument")..".",
		func = function(name, param)
			if param ~= "" then
				local isModValid = false
				for mod, registeredQuests in pairs(sys4_quests.registeredQuests) do
					if mod == param then
						isModValid = true
						minetest.chat_send_player(name, S("Legend")..":")
						minetest.chat_send_player(name, " [*] <-- "..S("Successfull quest"))
						minetest.chat_send_player(name, " [>] <-- "..S("Active quest"))
						minetest.chat_send_player(name, " [ ] <-- "..S("Not reached quest"))
						minetest.chat_send_player(name, " <U>{mod} <-- "..S("Quest from {mod} used by mod").." "..mod)
						minetest.chat_send_player(name, " ")
						minetest.chat_send_player(name, S("Quests of mod").." \""..mod.."\" : ")
						local modIntllib = registeredQuests.intllib
						for _, quest in ipairs(registeredQuests.quests) do
							local questState = "[ ]"
							if isQuestActive(quest[1], name) then
								questState = "[>]"
							end
							if isQuestSuccessfull(quest[1], name) then
								questState = "[*]"
							end

							minetest.chat_send_player(name, questState.." "..modIntllib(quest[2]).." ["..quest[1].."]")
						end
					end
				end

				if not isModValid then
					minetest.chat_send_player(name, S("Sorry, but this mod isn't supported")..".")
				else
					-- Display quests from other mods wich use this given mod
					for mod, registeredQuests in pairs(sys4_quests.registeredQuests) do
						if mod ~= param then
							local modIntllib = registeredQuests.intllib
							for _, quest in ipairs(registeredQuests.quests) do
								local tNodes = quest[4] -- target Nodes
								local uItems = quest[6] -- Unlockable items

								local isQuestUpdated = false
								
								for i = 1, #tNodes do
									if string.split(tNodes[i], ":")[1] == param then
										isQuestUpdated = true
										break;
									end
								end

								if not isQuestUpdated then
									for i = 1, #uItems do
										if string.split(uItems[i], ":")[1] == param then
											isQuestUpdated = true
											break;
										end
									end
								end

								if isQuestUpdated then
									local questState = "[ ]"
									if isQuestActive(quest[1], name) then
										questState = "[>]"
									end
									if isQuestSuccessfull(quest[1], name) then
										questState = "[*]"
									end

									minetest.chat_send_player(name, "<U>{"..mod.."}"..questState.." "..modIntllib(quest[2]).." ["..quest[1].."]")
								end
							end
						end
					end
				end
				
			else
				for mod, registeredQuests in pairs(sys4_quests.registeredQuests) do
					minetest.chat_send_player(name, mod)
				end
			end
		end
})

minetest.register_chatcommand(
	"itemqq",
	{
		params = "<"..S("item")..">",
		description = S("Display the quest to finish which will unlock this item")..".",
		func = function(name, param)
			local isItemFound = false
			for mod, registeredQuests in pairs(sys4_quests.registeredQuests) do
				local modIntllib = registeredQuests.intllib
				for _, quest in ipairs(registeredQuests.quests) do
					for __, uItem in ipairs(quest[6]) do
						if uItem == param then
							isItemFound = true
							minetest.chat_send_player(name, S("Quest to finish for unlock").." \""..modIntllib(uItem).."\" :")

							local groupName = getGroupByQuestIndex(quest.index)
							if groupName == nil then
								groupName = "global"
							end

							local questState = ""
							if isQuestActive(quest[1], name) then
								questState = "<-- "..S("Active")
							end
							if isQuestSuccessfull(quest[1], name) then
								questState = "<-- "..S("Successfull")
							end
							
							minetest.chat_send_player(name, "  "..modIntllib(quest[2]).." ["..quest[1].."]".." {mod: "..mod.."} "..S("in group").." "..groupName.." "..questState)
							break
						end
					end
					if isItemFound then break end
				end
				if isItemFound then break end
			end
			if not isItemFound then
				minetest.chat_send_player(name, S("Sorry, but this item is not unlockable")..".")
			end
		end
	})

minetest.register_chatcommand(
	"fquest",
	{
		params = "<"..S("quest_name")..">",
		description = S("Force an active quest to be immediately finished")..".",
		func = function(name, param)
			local quest = getRegisteredQuest(param)
			local maxValue
			if quest ~= nil then
				if quest.custom_level then
					maxValue = quest[5]
				else
					maxValue = quest[5] * level
				end
				
				if quests.update_quest(name, "sys4_quests:"..param, maxValue) then
					minetest.chat_send_player(name, S("The quest has been finished successfully")..".")
				else
					minetest.chat_send_player(name, S("The quest must be active to do that")..".")
				end
			else
				minetest.chat_send_player(name, S("Sorry, but this quest doesn't exist")..".")
			end
		end
	})

local function getModQuest(questName)
	for mod, registeredQuests in pairs(sys4_quests.registeredQuests) do
		for _, quest in ipairs(registeredQuests.quests) do
			if quest[1] == questName then
				return mod
			end
		end
	end
	return nil
end

minetest.register_chatcommand(
	"iquest",
	{
		params = "<"..S("quest_name")..">",
		description = S("Display info of the quest")..".",
		func = function(name, param)
			local quest = getRegisteredQuest(param)
			if quest ~= nil then
				local qMod = getModQuest(quest[1])
				local modIntllib = sys4_quests.registeredQuests[qMod].intllib
				local groupName = getGroupByQuestIndex(quest.index)
				if groupName == nil then
					groupName = "global"
				end
				minetest.chat_send_player(name, "> "..S("Index")..": "..quest.index)
				minetest.chat_send_player(name, "> "..S("Name")..": "..quest[1])
				minetest.chat_send_player(name, "> "..S("Title")..": "..modIntllib(quest[2]))
				local cDesc = quest[3]
				if cDesc == nil then cDesc = "" end
				minetest.chat_send_player(name, "> "..S("Custom Desc.")..": "..modIntllib(cDesc))
				minetest.chat_send_player(name, "> "..S("Group")..": "..groupName)
				minetest.chat_send_player(name, "> "..S("Mod")..": "..qMod)
				minetest.chat_send_player(name, "> "..S("Action Type")..": "..S(quest.type))
				minetest.chat_send_player(name, "> "..S("Target Nodes")..": "..dump(quest[4]))
				local maxLevel = quest[5] * level
				if quest.custom_level then
					maxLevel = quest[5]
				end
				minetest.chat_send_player(name, "> "..S("Target count")..": "..maxLevel)
				minetest.chat_send_player(name, "> "..S("Custom Level")..": "..dump(quest.custom_level))
				minetest.chat_send_player(name, "> "..S("Parent quests")..": "..dump(quest[7]))
				
				local childQuests = {}
				for mod, registeredQuests in pairs(sys4_quests.registeredQuests) do
					for _, rQuest in ipairs(registeredQuests.quests) do
						if rQuest[7] and rQuest[7] ~= nil and type(rQuest[7]) == "string" then
							local alternQuests = string.split(rQuest[7], "|")
							for __, alternQuest in ipairs(alternQuests) do
								if alternQuest == quest[1] then
									table.insert(childQuests, rQuest[1])
								end
							end
						elseif type(rQuest[7]) == "table" then
							for __, quest_1 in ipairs(rQuest[7]) do
								local alternQuests = string.split(quest_1, "|")
								for ___, alternQuest in ipairs(alternQuests) do
									if alternQuest == quest[1] then
										table.insert(childQuests, rQuest[1])
									end
								end
							end
						end
					end
				end
				minetest.chat_send_player(name, "> "..S("Child Quests")..": "..dump(childQuests))
				
				minetest.chat_send_player(name, "> "..S("Items to unlock")..": "..dump(quest[6]))
				local questState = "Inactive"
				if isQuestActive(quest[1], name) then
					questState = "Active"
				end
				if isQuestSuccessfull(quest[1], name) then
					questState = "Successfull"
				end
				minetest.chat_send_player(name, "> "..S("State")..": "..S(questState))
			else
				minetest.chat_send_player(name, S("Sorry, but this quest doesn't exist")..".")
			end
		end
	})

minetest.register_chatcommand(
	"getcraft",
	{
		params = "<"..S("item")..">",
		description = S("Display craft recipes of this item")..".",
		func = function(name, param)
			minetest.chat_send_player(name, getCraftRecipes(param))
		end

	})

-- QuestTrees DEBUG
local function print_questTrees(str, questTrees)
	local str = str.."==> "
	local output = ""

	if questTrees then
		for i=1, #questTrees do
			output = output..str..questTrees[i]:get_quest():get_item():get_name().."\n"
			output = output..print_questTrees(str, questTrees[i]:get_quest():get_questTrees())
		end
	end

	return output
end

local function get_registeredQuestsTrees(parent)
	local questTrees = nil

	if not parent then
		for mod, registeredQuest in pairs(sys4_quests.registeredQuests) do
			for _, quest in ipairs(registeredQuest.quests) do
				if not quest[7] or #quest[7] == 0 then
					if not questTrees then questTrees = {} end
					local questTree = { name = quest[1],
											  childs = get_registeredQuestsTrees(quest[1])
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
					local questTree = { name = quest[1],
											  childs = get_registeredQuestsTrees(quest[1])
					}
					table.insert(questTrees, questTree)
				end
			end
		end
	end

	return questTrees
end
	
local function print_questTrees2(str, questTrees)
	local str = str.."==> "
	local output = ""

	if questTrees then
		for i, quest in ipairs(questTrees) do
			
			output = output..str..quest.name.."\n"
			output = output..print_questTrees2(str, quest.childs)
		end
	end

	return output
end

minetest.register_chatcommand(
	"questree",
	{
		params = nil,
		description = "display quests tree.",
		func = function(name, param)
			minetest.chat_send_player(name, print_questTrees("", sys4_quests.questTrees))
		end
})

minetest.register_chatcommand(
	"quest",
	{
		params = nil,
		description = "display quests tree.",
		func = function(name, param)
			local questTrees = get_registeredQuestsTrees(nil)
			minetest.chat_send_player(name, print_questTrees2("", questTrees))
		end
})

