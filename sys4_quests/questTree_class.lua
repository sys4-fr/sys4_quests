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
	return self
end

function sys4_quests.Quest.new(item)
	local self = setmetatable({}, sys4_quests.Quest)
	self.item = item
	local splittedName = string.split(item:get_name(), ":")
	self.name = splittedName[1].."_"..splittedName[2].."_quest"
	self.questTrees = nil
	return self
end

-- Quest methods

function sys4_quests.Quest:get_name()
	return self.name
end
function sys4_quests.Quest:set_name(name)
	self.name = name
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

function sys4_quests.Quest:get_targetCount()
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

	return count
end

function sys4_quests.Quest:get_action()
	local action = nil
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
	return action
end

-- QuestTree methods

function sys4_quests.QuestTree:add(questTree)
	self:get_quest():add(questTree)
end

function sys4_quests.QuestTree:get_tree_with_item_child(name)
	local treeFound = nil
	local itemChilds = self:get_quest():get_item():get_childs()
	print("QuestTree getTree item Cjilds ::::::: "..self:get_quest():get_item():get_name())
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
