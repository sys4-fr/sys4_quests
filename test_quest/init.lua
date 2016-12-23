local S
if minetest.get_modpath("intllib") then
	S = intllib.Getter()
else
	S = function(s) return s end
end

-- Make local shortcuts of global functions --
local ins = table.insert
local up = sys4_quests.updateQuest

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
local makeAutoQuests = true
local quests = sys4_quests.initQuests("default", S, makeAutoQuests)
ins(quests, {
	 "default_furnace_quest",
	 "default_furnace_quest",
	 nil,
	 {"default:furnace"},
	 1,
	 {},
	 {"group_stone_quest"},
	 type = "craft",
	 custom_level = true
})

sys4_quests.set_parent_quest("group_stone_quest", "group_stick_quest")
sys4_quests.set_parent_quest("default_gold_lump_quest", "default_furnace_quest")
sys4_quests.set_parent_quest("default_iron_lump_quest", "default_furnace_quest")
sys4_quests.set_parent_quest("default_steel_ingot_quest", "default_iron_lump_quest")
sys4_quests.set_parent_quest("default_steelblock_quest", "default_steel_ingot_quest")
sys4_quests.set_parent_quest("default_copper_lump_quest", "default_furnace_quest")

sys4_quests.set_parent_quest("default_coal_lump_quest", "group_stick_quest")
sys4_quests.set_parent_quest("default_brick_quest", "default_furnace_quest")
sys4_quests.set_parent_quest("default_obsidian_quest", "default_steel_ingot_quest")
sys4_quests.set_parent_quest("default_mese_quest", "default_steel_ingot_quest")
sys4_quests.set_parent_quest("default_diamond_quest", "default_iron_ingot_quest")
sys4_quests.set_parent_quest("default_glass_quest", "default_furnace_quest")

sys4_quests.initQuests("stairs", S, makeAutoQuests)
sys4_quests.initQuests("farming", S, makeAutoQuests)
sys4_quests.initQuests("flowers", S, makeAutoQuests)
sys4_quests.initQuests("dye", S, makeAutoQuests)
sys4_quests.initQuests("wool", S, makeAutoQuests)
sys4_quests.initQuests("doors", S, makeAutoQuests)
sys4_quests.initQuests("walls", S, makeAutoQuests)
sys4_quests.initQuests("xpanes", S, makeAutoQuests)
sys4_quests.initQuests("tnt", S, makeAutoQuests)
sys4_quests.initQuests("fire", S, makeAutoQuests)
sys4_quests.initQuests("beds", S, makeAutoQuests)
sys4_quests.initQuests("boats", S, makeAutoQuests)
sys4_quests.initQuests("bucket", S, makeAutoQuests)

sys4_quests.registerQuests()
