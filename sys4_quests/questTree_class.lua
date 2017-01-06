sys4_quests.QuestTree = {}
sys4_quests.Quest = {}

sys4_quests.QuestTree.__index = sys4_quests.QuestTree
sys4_quests.Quest.__index = sys4_quests.Quest

setmetatable(sys4_quests.QuestTree, {
					 __call = function (cls, ...)
						 return cls.new(...)
					 end,
})

setmetatable(sys4_quests.Quest, {
					 __call = function (cls, ...)
						 return cls.new(...)
					 end,
})

-- Constructors

function sys4_quests.QuestTree.new(quest)
	local self = setmetatable({}, sys4_quests.QuestTree)
	self.quest = quest
	self.parent = nil
	return self
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
								if itemTarget_str == itemName then
									table.insert(itemTargets, item.name)
								end
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

function sys4_quests.Quest.new(item, coord)
	local self = setmetatable({}, sys4_quests.Quest)
	self.item = item
	local splittedName = string.split(item:get_name(), ":")
	self.name = splittedName[1].."_"..splittedName[2].."_quest"
	self.questTrees = nil
	self.action = nil
	self.targets = get_itemTargets(item:get_name())
	self.description = nil
	self.index = nil
	self.groupQuest = "global"
	self.coord = coord
	return self
end

-- Quest methods

function sys4_quests.Quest:get_name()
	return self.name
end
function sys4_quests.Quest:set_name(name)
	self.name = name
end

function sys4_quests.Quest:get_description()
	return self.description
end
function sys4_quests.Quest:set_description(description)
	self.description = description
end

function sys4_quests.Quest:get_index()
	return self.index
end
function sys4_quests.Quest:set_index(index)
	self.index = index
end

function sys4_quests.Quest:get_groupQuest()
	return self.groupQuest
end
function sys4_quests.Quest:set_groupQuest(name)
	self.groupQuest = name
end

function sys4_quests.Quest:get_coord()
	return self.coord
end
function sys4_quests.Quest:set_coord(coord)
	self.coord = coord
end


function sys4_quests.Quest:get_item()
	return self.item
end

function sys4_quests.Quest:get_questTrees()
	return self.questTrees
end

function sys4_quests.Quest:add(questTree)
	if self.questTrees == nil then self.questTrees = {} end
	table.insert(self.questTrees, questTree)
end

function sys4_quests.Quest:add_target_item(item)
	if not self.targets then self.targets = {} end

	local exist = false
	for i, target in ipairs(self.targets) do
		if target == item then exist = true ; break end
	end

	if not exist then
		table.insert(self.targets, item)
	end
end

function sys4_quests.Quest:add_target_items(items)
	for i, item in ipairs(items) do
		self:add_target_item(item)
	end
end

function sys4_quests.Quest:get_target_items()
	return self.targets
end

function sys4_quests.Quest:get_targetCount()
	if self.targetCount then
		return self.targetCount
	end
	
	local itemTarget = self:get_item()
	local count = 6
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

	self.targetCount = count * sys4_quests.level
	return self.targetCount
end

function sys4_quests.Quest:set_targetCount(count)
	self.targetCount = count
end

function sys4_quests.Quest:set_action(action)
	self.action = action
end

function sys4_quests.Quest:get_action()
	local action = self.action
	if action then return action end
	
	local item = self:get_item()

	if not item:get_recipes() then
		action = "dig"
	else
		action = "craft"
		for i, recipe in ipairs(item:get_recipes()) do
			if recipe.type == "cooking" then
				action = "cook"
				break
			end
		end
	end
	self.action = action
	return action
end

-- QuestTree methods

function sys4_quests.QuestTree:get_parent()
	return self.parent
end

function sys4_quests.QuestTree:set_parent(parent)
	self.parent = parent
end

function sys4_quests.QuestTree:add(questTree)
	questTree:set_parent(self)
	self:get_quest():add(questTree)
end

function sys4_quests.QuestTree:get_last_tree_with_item_child(name)
	local treeFound = nil
	
	local childQuestTrees = self:get_quest():get_questTrees()
	if childQuestTrees then
		for i=1, #childQuestTrees do
			treeFound = childQuestTrees[i]:get_last_tree_with_item_child(name)
			if treeFound then return treeFound end
		end
	end
	
	local itemChilds = self:get_quest():get_item():get_childs()
	for i=1, #itemChilds do
		if itemChilds[i] == name then
			return self
		end
	end

	return treeFound
end

function sys4_quests.QuestTree:get_tree(name)
	local treeFound = nil
	local treeName = self:get_quest():get_name()
	if treeName == name then
		treeFound = self
	elseif self:get_quest():get_questTrees() then
		for i, tree in ipairs(self:get_quest():get_questTrees()) do
			treeFound = tree:get_tree(name)
			if treeFound then break end
		end
	end

	return treeFound
end

function sys4_quests.QuestTree:get_tree_with_item_child(name)
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

function sys4_quests.QuestTree:get_quest()
	return self.quest
end
