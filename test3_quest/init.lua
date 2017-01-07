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
local coord = {} -- coords for quests display placement

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
quest_tree:add("default:mese_crystal", {"default:pick_steel"})
coord["default:mese_crystal"] = { x = 2, y = 9}
quest_tree:add("default:diamond", {"default:pick_steel"})
coord["default:diamond"] = { x = 3, y = 9}
quest_tree:add("default:obsidian", {"default:pick_steel"})
coord["default:obsidian"] = { x = 4, y = 9}

-- build quests list --
--[[ Enable auto determination of items to unlock.
	  Note: If enabled, unlocked items are not displayed for now, because 
	  the successful craft determination is dynamically calculated when the 
	  player try to craft an item.
--]]
local auto = true

-- build and get quests data accordingly to 'quest_tree' and 'auto' option.
local quests = sys4_quests.build_quests(quest_tree, coord, auto)

-- Make quests custom modifications if needed
quests["sys4_quests:quest_book"]:set_targetCount(1) -- custom level
quests["sys4_quests:quest_book"]:get_item():add_childs({"default:snow", "default:snowblock"}) -- add another items to unlock in this quest
quests["group:tree"]:add_target_items({"default:bush_stem", "default:acacia_bush_stem"})
quests["default:pick_wood"]:set_targetCount(1)
quests["default:pick_stone"]:set_targetCount(1)
quests["default:pick_steel"]:set_targetCount(1)
quests["default:furnace"]:set_targetCount(1)
quests["default:furnace"]:add_target_item("default:furnace") -- add another target item into this quest (TODO in this case fix bug, this may not happen)
quests["group:sand"]:set_action("dig") -- force quest action ("dig", "craft", "cook" or "place"
quests["default:clay_lump"]:set_action("dig")
quests["default:clay_lump"]:get_item():add_child("default:clay_lump") -- add another item to unlock in this quest
quests["default:coal_lump"]:set_action("dig")
quests["default:coal_lump"]:get_item():add_child("default:coal_lump")
quests["group:stone"]:set_action("dig")

-- register quests
sys4_quests.register_mod_quests("default", quests, S)

--
-- farming mod
--

-- get existing quests tree and update it
quest_tree = sys4_quests.quests_tree

quest_tree:add("farming:wheat", {"group:stick"})
coord["farming:wheat"] = {x = 1, y = 4}

-- rebuild quests
quests = sys4_quests.build_quests(quest_tree, coord, true)

-- customize quests
quests["farming:wheat"]:add_target_item("farming:wheat")
quests["farming:wheat"]:set_action("dig")

-- register modifications
sys4_quests.register_mod_quests("farming", quests, S)

--
-- wool
--

quest_tree = sys4_quests.quests_tree

quest_tree:add("farming:cotton", {"group:stick"})
coord["farming:cotton"] = {x = 2, y = 4}
quest_tree:add("wool:white", {"farming:cotton"})
coord["wool:white"] = {x = 2, y = 5}

quests = sys4_quests.build_quests(quest_tree, coord, true)

quests["farming:cotton"]:add_target_item("farming:cotton")

sys4_quests.register_mod_quests("wool", quests, S)

-- flowers (no quests added but we needs items for others mod)
sys4_quests.add_itemGroup("flower")
sys4_quests.register_mod("flowers", S)

-- Dye
quest_tree = sys4_quests.quests_tree
sys4_quests.add_itemGroup("dye")
sys4_quests.add_itemGroup("wool")

quest_tree:add("group:flower", {"sys4_quests:quest_book"})
coord["group:flower"] = {x = 5, y = 1}
quest_tree:add("group:dye", {"group:flower"})
coord["group:dye"] = {x = 5, y = 2}

quests = sys4_quests.build_quests(quest_tree, coord, true)

sys4_quests.register_mod_quests("dye", quests, S)

--
-- beds
--
quest_tree = sys4_quests.quests_tree
quest_tree:add("group:wool", {"wool:white", "group:dye"})
coord["group:wool"] = {x = 2, y = 6}

quests = sys4_quests.build_quests(quest_tree, coord, true)

sys4_quests.register_mod_quests("beds", quests, S)

--
-- tnt
--

quest_tree = sys4_quests.quests_tree
quest_tree:add("default:gravel", {"default:coal_lump"})
coord["default:gravel"] = {x = 6, y = 1}
quest_tree:add("tnt:gunpowder", {"default:gravel"})
coord["tnt:gunpowder"] = {x = 6, y = 2}

quests = sys4_quests.build_quests(quest_tree, coord, true)

sys4_quests.register_mod_quests("tnt", quests, S)

--
-- vessels
--

sys4_quests.add_itemGroup("vessel")

quest_tree = sys4_quests.quests_tree
quest_tree:add("default:glass", {"default:furnace", "group:sand"})
coord["default:glass"] = {x = 0, y = 7}
quest_tree:add("group:vessel", {"default:glass"})
coord["group:vessel"] = {x = 0, y = 8}

quests = sys4_quests.build_quests(quest_tree, coord, true)

sys4_quests.register_mod_quests("vessels", quests, S)

--
-- Doors
--

quest_tree = sys4_quests.quests_tree
quest_tree:add("default:obsidian_glass", {"default:obsidian"})
coord["default:obsidian_glass"] = {x = 4, y = 10}

quests = sys4_quests.build_quests(quest_tree, coord, true)

sys4_quests.register_mod_quests("doors", quests, S)

-- fire (no quest added, but previously quests updated)
quest_tree = sys4_quests.quests_tree
quests = sys4_quests.build_quests(quest_tree, coord, true)

-- update quest
quests["default:gravel"]:get_item():add_child("default:flint")

sys4_quests.register_mod_quests("fire", quests, S)

-- xpanes
sys4_quests.register_mod("xpanes", S)

-- Screwdriver
sys4_quests.register_mod("screwdriver", S)

-- Bucket
sys4_quests.register_mod("bucket", S)

-- walls
sys4_quests.register_mod("walls", S)

-- Boats
sys4_quests.register_mod("boats", S)

-- stairs
quest_tree = sys4_quests.quests_tree
quests = sys4_quests.build_quests(quest_tree, coord, true)

quests["farming:wheat"]:get_item():add_childs({"stairs:slab_straw", "stairs:stair_straw"})
quests["default:sandstone"]:get_item():add_childs({"stairs:slab_sandstonebricks", "stairs:stair_sandstonebricks", "stairs:slab_sandstone_block", "stairs:stair_sandstone_block"})
quests["default:clay_brick"]:get_item():add_childs({"stairs:slab_brick", "stairs:stair_brick"})
quests["default:bronze_ingot"]:get_item():add_childs({"stairs:slab_bronzeblock", "stairs:stair_bronzeblock"})
quests["default:steel_ingot"]:get_item():add_childs({"stairs:slab_steelblock", "stairs:stair_steelblock"})
quests["default:copper_ingot"]:get_item():add_childs({"stairs:slab_copperblock", "stairs:stair_copperblock"})
quests["default:obsidian"]:get_item():add_childs({"stairs:slab_obsidianbricks", "stairs:stair_obsidianbricks", "stairs:slab_obsidian_block", "stairs:stair_obsidian_block"})

sys4_quests.register_mod_quests("stairs", quests, S)

-- Carts
quest_tree = sys4_quests.quests_tree
quests = sys4_quests.build_quests(quest_tree, coord, true)

quests["default:mese_crystal"]:get_item():add_child("default:mese_crystal_fragment")

sys4_quests.register_mod_quests("carts", quests, S)
