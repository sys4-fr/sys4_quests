--
-- Build a new quest tree for default mod
--

-- intllib support
local S
if minetest.get_modpath("intllib") then
	S = intllib.Getter()
else
	S = function(s) return s end
end

-- Make quests based on the following groups of items if possible
local itemGroups = {"tree", "wood", "sand", "stone", "stick"}
for i=1, #itemGroups do
	sys4_quests.add_itemGroup(itemGroups[i])
end

-- build default quests hierarchy
local quest_tree = sys4_quests.new_tree()
local coord = {}

quest_tree:add("sys4_quests:quest_book", {})
coord["sys4_quests:quest_book"] = { x = 0, y = 0}
quest_tree:add("group:sand", {"sys4_quests:quest_book"})
coord["group:sand"] = { x = 2, y = 1}
quest_tree:add("default:sandstone", {"group:sand"})
coord["default:sandstone"] = { x = 2, y = 2}
quest_tree:add("default:clay_lump", {"sys4_quests:quest_book"})
coord["default:clay_lump"] = { x = 3, y = 1}
quest_tree:add("default:papyrus", {"sys4_quests:quest_book"})
coord["default:papyrus"] = { x = 4, y = 1}
quest_tree:add("default:paper", {"default:papyrus"})
coord["default:paper"] = { x = 4, y = 2}
quest_tree:add("group:tree", {"sys4_quests:quest_book"})
coord["group:tree"] = { x = 0, y = 1}
quest_tree:add("group:wood", {"group:tree"})
coord["group:wood"] = { x = 0, y = 2}
quest_tree:add("default:book", {"default:paper", "group:wood"})
coord["default:book"] = { x = 4, y = 3}
quest_tree:add("group:stick", {"group:wood"})
coord["group:stick"] = { x = 0, y = 3}
quest_tree:add("default:pick_wood", {"group:stick"})
coord["default:pick_wood"] = { x = 0, y = 4}
quest_tree:add("group:stone", {"default:pick_wood"})
coord["group:stone"] = { x = 0, y = 5}
quest_tree:add("default:coal_lump", {"default:pick_wood"})
coord["default:coal_lump"] = { x = 1, y = 5}
quest_tree:add("default:furnace", {"group:stone"})
coord["default:furnace"] = { x = 0, y = 6}
quest_tree:add("default:clay_brick", {"default:furnace", "default:clay_lump"})
coord["default:clay_brick"] = { x = 3, y = 2}
quest_tree:add("default:pick_stone", {"group:stone"})
coord["default:pick_stone"] = { x = 1, y = 6}
quest_tree:add("default:copper_ingot", {"default:pick_stone", "default:furnace"})
coord["default:copper_ingot"] = { x = 1, y = 7}
quest_tree:add("default:steel_ingot", {"default:pick_stone", "default:furnace"})
coord["default:steel_ingot"] = { x = 2, y = 7}
quest_tree:add("default:gold_ingot", {"default:pick_stone", "default:furnace"})
coord["default:gold_ingot"] = { x = 3, y = 7}
quest_tree:add("default:bronze_ingot", {"default:copper_ingot", "default:steel_ingot"})
coord["default:bronze_ingot"] = { x = 1, y = 8}
quest_tree:add("default:pick_steel", {"default:steel_ingot"})
coord["default:pick_steel"] = { x = 2, y = 8}
quest_tree:add("default:pick_bronze", {"default:bronze_ingot"})
coord["default:pick_bronze"] = { x = 1, y = 9}
quest_tree:add("default:mese_crystal", {"default:pick_steel"})
coord["default:mese_crystal"] = { x = 2, y = 9}
quest_tree:add("default:diamond", {"default:pick_steel"})
coord["default:diamond"] = { x = 3, y = 9}
quest_tree:add("default:obsidian", {"default:pick_steel"})
coord["default:obsidian"] = { x = 4, y = 9}

-- build quests list
local auto = true -- auto determination of items to unlock
local quests = sys4_quests.build_quests(quest_tree, coord, auto)

-- Make quest custom modifications
quests["sys4_quests:quest_book"]:set_targetCount(1)
quests["default:pick_wood"]:set_targetCount(1)
quests["default:furnace"]:set_targetCount(1)
quests["default:furnace"]:add_target_item("default:furnace") -- bug
quests["group:sand"]:set_action("dig")
quests["default:clay_lump"]:set_action("dig")
quests["default:clay_lump"]:get_item():add_child("default:clay_lump")
quests["default:coal_lump"]:set_action("dig")
quests["group:stone"]:set_action("dig")

-- register quests
sys4_quests.register_mod_quests("default", quests, S)
