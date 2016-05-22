-- Minetest Quests
-- By Sys4

-- This mod add quests based on default minetest game

if not minetest.get_modpath("sys4_quests")
and not minetest.get_modpath("default") then
   return
end

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

-- Get variable for register quests
local quests = sys4_quests.initQuests(mod, S) -- set S has above if you want your intllib support (!)

----- Quests with type="dig" -----
local t = "dig"

-- tree_digger
ins(quests, {
       'tree_digger', "Tree Digger", nil, {"default:tree", "default:jungletree", "default:acacia_tree", "default:pine_tree", "default:aspen_tree"}, 1, {"default:wood", "default:junglewood", "default:acacia_wood", "default:pine_wood", "default:aspen_wood"}, nil, type = t
	    })

-- papyrus_digger
ins(quests, {
       'papyrus_digger', "Papyrus Digger", nil, {"default:papyrus"}, 3, {"default:paper"}, nil, type = t
	    })

-- clay_digger
ins(quests, {
       'clay_digger', "Clay Crafter", nil, {"default:clay"}, 1, {"default:clay", "default:brick"}, nil, type = t
	    })

-- coal_digger
ins(quests, {
       'coal_digger', "Coal Digger", nil, {"default:stone_with_coal"}, 1, {"default:torch"}, "more_tools", type = t
	    })

-- coal_digger_lover
ins(quests, {
       'coal_digger_lover', "Coal Digger Lover", nil, {"default:stone_with_coal"}, 8, {"default:coalblock", "default:coal_lump"}, "coal_digger", type = t
	    })

-- stone_digger
ins(quests, {
       'stone_digger', "Stone Digger", nil, {"default:stone", "default:desert_stone", "default:cobble", "default:desert_cobble", "default:mossycobble", "default:stonebrick", "default:desert_stonebrick"}, 1, {"default:shovel_stone"}, "more_tools", type = t
	    })

-- stone_digger_lover
ins(quests, {
       'stone_digger_lover', "Stone Digger Lover", nil, {"default:stone", "default:desert_stone", "default:cobble", "default:desert_cobble", "default:mossycobble", "default:stonebrick", "default:desert_stonebrick"}, 1, {"default:sword_stone"}, "stone_digger", type = t
	    })

-- stone_digger_pro
ins(quests, {
       'stone_digger_pro', "Stone Digger Pro", nil, {"default:stone", "default:desert_stone", "default:cobble", "default:desert_cobble", "default:mossycobble", "default:stonebrick", "default:desert_stonebrick"}, 1, {"default:pick_stone", "default:axe_stone", "stairs:slab_cobble", "stairs:slab_desert_cobble"}, "stone_digger_lover", type = t
	    })

-- stone_digger_expert
ins(quests, {
       'stone_digger_expert', "Stone Digger Expert", nil, {"default:stone", "default:desert_stone", "default:cobble", "default:desert_cobble", "default:mossycobble", "default:stonebrick", "default:desert_stonebrick"}, 3, {"stairs:stair_cobble", "stairs:stair_desert_cobble"}, "stone_digger_pro", type = t
	    })

-- stone_digger_master
ins(quests, {
       'stone_digger_master', "Stone Digger Master", nil, {"default:stone", "default:desert_stone", "default:cobble", "default:desert_cobble", "default:mossycobble", "default:stonebrick", "default:desert_stonebrick"}, 2, {"default:furnace"}, "stone_digger_expert", type = t
	    })

----- Quests with type="craft" -----
t = "craft"

-- wood_crafter
ins(quests, {
       'wood_crafter', "Wood Crafter", nil, {"default:wood", "default:junglewood", "default:acacia_wood", "default:pine_wood", "default:aspen_wood"}, 1, {"default:stick"}, "tree_digger", type = t
	    })

-- wood_crafter_lover
ins(quests, {
       'wood_crafter_lover', "Wood Crafter Lover", nil, {"default:wood", "default:junglewood", "default:acacia_wood", "default:pine_wood", "default:aspen_wood"}, 1, {"default:sword_wood"}, "wood_crafter", type = t
	    })

-- wood_crafter_pro
ins(quests, {
       'wood_crafter_pro', "Wood Crafter Pro", nil, {"default:wood", "default:junglewood", "default:acacia_wood", "default:pine_wood", "default:aspen_wood"}, 1, {"stairs:slab_wood", "stairs:slab_junglewood", "stairs:slab_pine_wood", "stairs:slab_acacia_wood", "stairs:slab_aspen_wood"}, "wood_crafter_lover", type = t
	    })

-- wood_crafter_expert
ins(quests, {
       'wood_crafter_expert', "Wood Crafter Expert", nil, {"default:wood", "default:junglewood", "default:acacia_wood", "default:pine_wood", "default:aspen_wood"}, 3, {"default:sign_wall_wood", "stairs:stair_wood", "stairs:stair_junglewood", "stairs:stair_pine_wood", "stairs:stair_acacia_wood", "stairs:stair_aspen_wood"}, "wood_crafter_pro", type = t
	    })

-- wood_crafter_master
ins(quests, {
       'wood_crafter_master', "Wood Crafter Master", nil, {"default:wood", "default:junglewood", "default:acacia_wood", "default:pine_wood", "default:aspen_wood"}, 2, {"default:chest"}, "wood_crafter_expert", type = t
	    })

-- sticks_crafter
ins(quests, {
       'sticks_crafter', "Sticks Crafter", nil, {"default:stick"}, 2, {"default:shovel_wood"}, "wood_crafter", type = t
	    })

-- sticks_crafter_lover
ins(quests, {
       'sticks_crafter_lover', "Sticks Crafter Lover", nil, {"default:stick"}, 5, {"default:ladder_wood"}, "sticks_crafter", type = t
	    })

-- more_tools
ins(quests, {
       'more_tools', "More Tools", nil, {"default:wood", "default:junglewood", "default:acacia_wood", "default:pine_wood", "default:aspen_wood"}, 1, {"default:axe_wood", "default:pick_wood"}, {"wood_crafter_lover", "sticks_crafter"}, type = t
	    })

-- paper_crafter
ins(quests, {
       'paper_crafter', "Paper Crafter", nil, {"default:paper"}, 3, {"default:book"}, "papyrus_digger", type = t
	    })

-- book_crafter
ins(quests, {
       'book_crafter', "Book Crafter", nil, {"default:book"}, 3, {"default:bookshelf"}, {"wood_crafter_expert", "paper_crafter"}, type = t
	    })

-- clay_crafter
ins(quests, {
       'clay_crafter', "Clay Crafter", nil, {"default:clay"}, 1, {"default:clay_lump"}, "clay_digger", type = t
	    })

-- wood_architect
ins(quests, {
       'wood_architect', "Wood Architect", nil, {"default:wood", "default:junglewood", "default:acacia_wood", "default:pine_wood", "default:aspen_wood"}, 1, {"default:fence_wood", "default:fence_junglewood", "default:fence_pine_wood", "default:fence_acacia_wood", "default:fence_aspen_wood"}, {"sticks_crafter", "wood_crafter_pro"}, type = t
	    })

-- furnace_crafter
ins(quests, {
       'furnace_crafter', "Furnace Crafter", nil, {"default:furnace"}, 1, {"default:stonebrick", "default:desert_stonebrick", "stairs:slab_stonebrick", "stairs:slab_desert_stonebrick", "stairs:stair_stonebrick", "stairs:stair_desert_stonebrick", "stairs:slab_stone", "stairs:slab_desert_stone", "stairs:stair_stone", "stairs:stair_desert_stone"}, "stone_digger_master", type = t, custom_level = true
	    })

-- brick_crafter
ins(quests, {
       'brick_crafter', "Bricks Crafter", nil, {"default:brick"}, 1, {"default:clay_brick"}, {"clay_digger", "furnace_crafter"}, type = t
	    })

mod = "farming"
quests = sys4_quests.initQuests(mod, S)

t = "craft"

-- farming_tools
ins(quests, {
       'farming_tools', "Farming Tools", nil, {"default:wood", "default:junglewood", "default:acacia_wood", "default:pine_wood", "default:aspen_wood"}, 1, {"farming:hoe_wood"}, {"wood_crafter","sticks_crafter"}, type = t
	    })

sys4_quests.registerQuests()

-- updates

up('stone_digger_lover', nil, {"farming:hoe_stone"})
