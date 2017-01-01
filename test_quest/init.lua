local S
if minetest.get_modpath("intllib") then
	S = intllib.Getter()
else
	S = function(s) return s end
end

-- Make local shortcuts of tool functions --
local ins = table.insert
local update = sys4_quests.updateQuest
local replace = sys4_quests.replace_quest
local setparent = sys4_quests.set_parent_quest
local setaction = sys4_quests.set_action_quest
local add_itemGroup = sys4_quests.add_itemGroup
local add_questGroup = sys4_quests.addQuestGroup
local register = sys4_quests.registerQuests
local init = sys4_quests.initQuests

----- Quests Groups -----
local dark = "Dark Age"
local wood = "Wood Age"
local farm = "Farming Age"
local stone = "Stone Age"
local metal = "Metal Age"
local middle = "Middle Age"
local questGroups = {dark, wood, farm, stone, metal, middle}

--[[
for i=1, #questGroups do
	add_questGroup(questGroups[i])
end
--]]

---------- Quests for mod default ----------
local mod = "default"
local auto = true -- Quests of mod default will be generated automatically

-- Make quests based on the following groups of items if possible
local itemGroups = {"tree", "wood", "sand", "stone", "stick"}
for i=1, #itemGroups do
	add_itemGroup(itemGroups[i])
end

-- generate our quests and get their structure in a variable
local quests = init(mod, S, auto)

-- Reorganisation of quests dependencies

setparent("group_stone_quest", "group_stick_quest")
setparent("default_coal_lump_quest", "group_stick_quest")
setparent("default_gold_lump_quest", "group_stone_quest")
setparent("default_gold_ingot_quest", "default_gold_lump_quest")
setparent("default_skeleton_key_quest", "default_gold_ingot_quest")
setparent("default_iron_lump_quest", "group_stone_quest")
setparent("default_copper_lump_quest", "group_stone_quest")
setparent("default_diamond_quest", "default_steel_ingot_quest")
setparent("default_obsidian_quest", "default_steel_ingot_quest")
setparent("default_mese_crystal_quest", "default_steel_ingot_quest")
setparent("default_mese_quest", "default_mese_crystal_quest")
setparent("default_bronze_ingot_quest", "default_copper_ingot_quest")
setparent("default_bronzeblock_quest", "default_bronze_ingot_quest")
setparent("default_chest_quest", "default_steel_ingot_quest")
setparent("default_snow_quest", nil)
setparent("default_snowblock_quest", "default_snow_quest")
setparent("default_steel_ingot_quest", "default_iron_lump_quest")
setparent("default_steelblock_quest", "default_steel_ingot_quest")
setparent("default_copper_ingot_quest", "default_copper_lump_quest")
setparent("default_copperblock_quest", "default_copper_ingot_quest")
setparent("default_mese_crystal_fragment_quest", "default_mese_crystal_quest")

-- correction of type action

setaction("group_sand_quest", "dig")
setaction("default_clay_quest", "dig")
setaction("default_snow_quest", "dig")
setaction("group_stone_quest", "dig")
setaction("default_coal_lump_quest", "dig")
setaction("default_diamond_quest", "dig")
setaction("default_obsidian_quest", "dig")
setaction("default_mese_crystal_quest", "dig")

-- farming
local redo = farming.mod and farming.mod == "redo"
quests = init("farming", S, auto)
setparent("farming_wheat_quest", "group_stick_quest")
setparent("farming_straw_quest", "farming_wheat_quest")
setaction("farming_wheat_quest", "dig")
ins(quests, {
		 "farming_cotton_quest",
		 "farming_cotton_quest",
		 nil,
		 {"farming:cotton_1","farming:cotton_2","farming:cotton_3",
		  "farming:cotton_4","farming:cotton_5","farming:cotton_6",
		  "farming:cotton_7","farming:cotton_8"},
		 1,
		 {"wool:white"},
		 {"group_stick_quest"},
		 type = "dig"
})

if redo then
	setaction("farming_pumpkin_quest", "dig")
	setaction("farming_melon_slice_quest", "dig")
	
	setparent("farming_carrot_quest", "default_gold_lump_quest")
	setparent("farming_rhubarb_quest", "farming_wheat_quest")
	setparent("farming_potato_quest", "group_stone_quest")
	setparent("farming_pumpkin_quest", "group_stick_quest")
	setparent("farming_barley_quest", "group_stick_quest")
	setparent("farming_blueberries_quest", "farming_bread_quest")
	setparent("farming_melon_slice_quest", "group_stick_quest")
end

-- vessels
add_itemGroup("vessel")
init("vessels", S, auto)
setaction("group_vessel_quest", "craft")
if redo then
	setparent("farming_corn_quest", "group_vessel_quest")
	setparent("farming_raspberries_quest", "group_vessel_quest")
	setparent("farming_coffee_beans_quest", "group_vessel_quest")
	setparent("farming_drinking_cup_quest", "farming_coffee_beans_quest")
end

-- boats
init("boats", S, auto)

-- flowers
add_itemGroup("flower")
quests = init("flowers", S, auto)
ins(quests, {
		 "group_flower_quest",
		 "group_flower_quest",
		 nil,
		 {"group:flower"},
		 1,
		 {"group:dye"},
		 nil,
		 type = "dig"
})

-- dye
add_itemGroup("dye")
init("dye", S, auto)
setparent("group_dye_quest", "group_flower_quest")

-- wool
add_itemGroup("wool")
init("wool", S, auto)
setparent("group_wool_quest", "farming_cotton_quest")

-- doors
quests = init("doors", S, auto)
ins(quests, {
		 "default_obsidian_glass_quest",
		 "default_obsidian_glass_quest",
		 nil,
		 {"default:obsidian_glass"},
		 6,
		 {"doors:door_obsidian_glass"},
		 {"default_obsidian_shard_quest"},
		 type = "cook"
})

-- others
init("walls", S, auto)
init("xpanes", S, auto)
init("tnt", S, auto)
init("fire", S, auto)
init("beds", S, auto)
init("bucket", S, auto)
init("carts", S, auto)
init("stairs", S, auto)

-- register quests
register()

-- correction of items to unlock
mod = "default"
update("default_clay_quest", nil, {mod..":clay"})
update("default_clay_lump_quest", nil, {mod..":clay_lump"})

mod = "farming"
update("farming_wheat_quest", {mod..":wheat_1", mod..":wheat_2", mod..":wheat_3", mod..":wheat_4", mod..":wheat_5", mod..":wheat_6", mod..":wheat_7", mod..":wheat_8"}, nil)
