local S
if minetest.get_modpath("intllib") then
	S = intllib.Getter()
else
	S = function(s) return s end
end

-- Make local shortcuts of global functions --
local ins = table.insert
local up = sys4_quests.updateQuest
local setp = sys4_quests.set_parent_quest
local seta = sys4_quests.set_action_quest
---------- Quests for default mod ----------
local mod = "default"

----- Quests Groups -----
local dark = "Dark Age"
local wood = "Wood Age"
local farm = "Farming Age"
local stone = "Stone Age"
local metal = "Metal Age"
local middle = "Middle Age"

--[[sys4_quests.addQuestGroup(dark)
sys4_quests.addQuestGroup(wood)
sys4_quests.addQuestGroup(farm)
sys4_quests.addQuestGroup(stone)
sys4_quests.addQuestGroup(metal)
sys4_quests.addQuestGroup(middle)
--]]

-- Get variable for register quests
local auto = true
local quests = sys4_quests.initQuests("default", S, auto)
setp("group_stone_quest", "group_stick_quest")
setp("default_coal_lump_quest", "group_stick_quest")
setp("default_coalblock_quest", "default_coal_lump_quest")
setp("default_gold_lump_quest", "group_stone_quest")
setp("default_iron_lump_quest", "group_stone_quest")
setp("default_copper_lump_quest", "group_stone_quest")
setp("default_steel_ingot_quest", "default_iron_lump_quest")
setp("default_steelblock_quest", "default_steel_ingot_quest")
setp("default_diamond_quest", "default_steel_ingot_quest")
setp("default_obsidian_quest", "default_steel_ingot_quest")
setp("default_mese_quest", "default_steel_ingot_quest")

seta("group_stone_quest", "dig")
seta("default_coal_lump_quest", "dig")
seta("group_sand_quest", "dig")

up("default_coal_lump_quest", {"default:stone_with_coal"}, nil)
up("default_iron_lump_quest", {"default:stone_with_iron"}, nil)
up("default_copper_lump_quest", {"default:stone_with_copper"}, nil)
up("default_gold_lump_quest", {"default:stone_with_gold"}, nil)
up("default_diamond_quest", {"default:stone_with_diamond"}, nil)
up("default_mese_crystal_quest", {"default:stone_with_mese"}, nil)

--[[
sys4_quests.initQuests("flowers", S, auto)
sys4_quests.initQuests("wool", S, auto)
sys4_quests.initQuests("farming", S, auto)
sys4_quests.initQuests("dye", S, auto)
sys4_quests.initQuests("walls", S, auto)
sys4_quests.initQuests("xpanes", S, auto)
sys4_quests.initQuests("tnt", S, auto)
sys4_quests.initQuests("fire", S, auto)
sys4_quests.initQuests("beds", S, auto)
sys4_quests.initQuests("boats", S, auto)
sys4_quests.initQuests("bucket", S, auto)
sys4_quests.initQuests("carts", S, auto)
sys4_quests.initQuests("doors", S, auto)
sys4_quests.initQuests("stairs", S, auto)
--]]
sys4_quests.registerQuests()
