sys4_quests.MinetestItem = {}  -- My custom item data
sys4_quests.MinetestItems = {} -- Collection of my custom items

sys4_quests.MinetestItem.__index = sys4_quests.MinetestItem
sys4_quests.MinetestItems.__index = sys4_quests.MinetestItems

setmetatable(sys4_quests.MinetestItem, {
					 __call = function (cls, ...)
						 return cls.new(...)
					 end,
})

setmetatable(sys4_quests.MinetestItems, {
					 __call = function(cls, ...)
						 return cls.new(...)
					 end,
})

local function get_item_recipes(itemName)
	local groupSplit = string.split(itemName, ":")
	local recipes = nil
	
	if groupSplit[1] == "group" then
		local group = groupSplit[2]
		for name, item in pairs(minetest.registered_items) do
			if minetest.get_item_group(name, group) > 0 then
				local itemRecipes = minetest.get_all_craft_recipes(name)
				if itemRecipes then
					for _, recipe in ipairs(itemRecipes) do
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

function sys4_quests.MinetestItem.new(item, childs)
	local self = setmetatable({}, sys4_quests.MinetestItem)
	self.stack = ItemStack(item.name)
	self.name = item.name
	self.def = item
	self.recipes = get_item_recipes(item.name)
	self.childs = childs
	return self
end

function sys4_quests.MinetestItems.new()
	local self = setmetatable({}, sys4_quests.MinetestItems)
	self.items = nil
	return self
end

-- MinetestItem methods

function sys4_quests.MinetestItem:get_stack()
	return self.stack
end

function sys4_quests.MinetestItem:get_name()
	return self.name
end

function sys4_quests.MinetestItem:get_field(fieldName)
	if fieldName then return self.def[fieldName] end
	return nil
end

function sys4_quests.MinetestItem:get_def()
	return self.def
end

function sys4_quests.MinetestItem:get_recipes(tRecipe)
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

function sys4_quests.MinetestItem:get_childs()
	return self.childs
end

function sys4_quests.MinetestItem:has_childs()
	return self:get_childs()
end

function sys4_quests.MinetestItem:has_child(name)
	if self:has_childs() then
		for _, child in ipairs(self:get_childs()) do
			if child == name then
				return true
			end
		end
	end
	return false
end

function sys4_quests.MinetestItem:add_child(child)
	for _, group in ipairs(sys4_quests.itemGroups) do
		if minetest.get_item_group(child, group) > 0 then
			child = "group:"..group
		end
	end

	if not self:has_childs() then	self.childs = {} end
	if not self:has_child(child) then table.insert(self.childs, child) end
end

function sys4_quests.MinetestItem:add_childs(childs)
	for _, child in ipairs(childs) do
		self:add_child(child)
	end
end

function sys4_quests.MinetestItem:is_tool()
	if self:get_field("tool_capabilities") then return true end
	return false
end

function sys4_quests.MinetestItem:is_hand_diggable()
	local groups = self:get_field("groups")
	if groups.crumbly and not groups.cracky
		or groups.snappy and not groups.choppy
		or groups.choppy and groups.oddly_breakable_by_hand
	then
		return true
	end
	return false
end

function sys4_quests.MinetestItem:is_diggable_by(itemTool)
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

function sys4_quests.MinetestItems:add(item, childs)
	if not self.items then self.items = {} end
	for _, group in ipairs(sys4_quests.itemGroups) do
		if minetest.get_item_group(item.name, group) > 0 then
			item.name = "group:"..group
		end
	end

	local isAdded = false
	for _, currentItem in ipairs(self:get_items()) do
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
		table.insert(self.items, sys4_quests.MinetestItem(item, childs))
	end
end

function sys4_quests.MinetestItems:get_items()
	return self.items
end

function sys4_quests.MinetestItems:get_item(itemName)
	for _, item in ipairs(self:get_items()) do
		if item:get_name() == itemName then
			return item
		end
	end
	return nil
end

function sys4_quests.MinetestItems:get_itemField(itemName, fieldName)
	local item = self:get_item(itemName)
	if item then return item:get_field(fieldName) end
	return nil
end

