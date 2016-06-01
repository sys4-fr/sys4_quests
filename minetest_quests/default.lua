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
local quests = sys4_quests.initQuests(mod, S)

----- Quests with type="dig" -----
local t = "dig"

-- tree_digger
ins(quests, {
       'tree_digger', "Tree Digger", nil, {mod..":tree", mod..":jungletree", mod..":acacia_tree", mod..":pine_tree", mod..":aspen_tree"}, 1, {mod..":wood", mod..":junglewood", mod..":acacia_wood", mod..":pine_wood", mod..":aspen_wood"}, nil, type = t
	    })

-- papyrus_digger
ins(quests, {
       'papyrus_digger', "Papyrus Digger", nil, {mod..":papyrus"}, 3, {mod..":paper"}, nil, type = t
	    })

-- clay_digger
ins(quests, {
       'clay_digger', "Clay Digger", nil, {mod..":clay"}, 1, {mod..":clay"}, nil, type = t
	    })

-- coal_digger
ins(quests, {
       'coal_digger', "Coal Digger", nil, {mod..":stone_with_coal"}, 1, {mod..":torch"}, "more_tools", type = t, custom_level = true
	    })

-- coal_digger_lover
ins(quests, {
       'coal_digger_lover', "Coal Digger Lover", nil, {mod..":stone_with_coal"}, 8, {mod..":coalblock", mod..":coal_lump"}, "coal_digger", type = t
	    })

-- stone_digger
ins(quests, {
       'stone_digger', "Stone Digger", nil, {mod..":stone", mod..":desert_stone", mod..":cobble", mod..":desert_cobble", mod..":mossycobble", mod..":stonebrick", mod..":desert_stonebrick"}, 1, {mod..":shovel_stone"}, "more_tools", type = t
	    })

-- stone_digger_lover
ins(quests, {
       'stone_digger_lover', "Stone Digger Lover", nil, {mod..":stone", mod..":desert_stone", mod..":cobble", mod..":desert_cobble", mod..":mossycobble", mod..":stonebrick", mod..":desert_stonebrick"}, 1, {mod..":sword_stone"}, "stone_digger", type = t
	    })

-- stone_digger_pro
ins(quests, {
       'stone_digger_pro', "Stone Digger Pro", nil, {mod..":stone", mod..":desert_stone", mod..":cobble", mod..":desert_cobble", mod..":mossycobble", mod..":stonebrick", mod..":desert_stonebrick"}, 1, {mod..":pick_stone", mod..":axe_stone", "stairs:slab_cobble", "stairs:slab_desert_cobble"}, "stone_digger_lover", type = t
	    })

-- stone_digger_expert
ins(quests, {
       'stone_digger_expert', "Stone Digger Expert", nil, {mod..":stone", mod..":desert_stone", mod..":cobble", mod..":desert_cobble", mod..":mossycobble", mod..":stonebrick", mod..":desert_stonebrick"}, 3, {"stairs:stair_cobble", "stairs:stair_desert_cobble"}, "stone_digger_pro", type = t
	    })

-- stone_digger_master
ins(quests, {
       'stone_digger_master', "Stone Digger Master", nil, {mod..":stone", mod..":desert_stone", mod..":cobble", mod..":desert_cobble", mod..":mossycobble", mod..":stonebrick", mod..":desert_stonebrick"}, 2, {mod..":furnace"}, "stone_digger_expert", type = t
	    })

-- sand_digger
ins(quests, {
       'sand_digger', "Sand Digger", nil, {mod..":sand", mod..":desert_sand"}, 4, {mod..":sandstone"}, nil, type = t
	    })

-- snow_digger
ins(quests, {
       'snow_digger', "Snow Digger", nil, {mod..":snow"}, 9, {mod..":snowblock"}, nil, type = t
	    })

-- chest_locker
ins(quests, {
       'chest_locker', "Chest Locker", nil, {mod..":stone_with_iron"}, 1, {mod..":chest_locked"}, {"furnace_crafter", "wood_crafter_master"}, type = t
	    })

-- iron_digger
ins(quests, {
       'iron_digger', "Iron Digger", nil, {mod..":stone_with_iron"}, 1, {mod..":shovel_steel"}, "furnace_crafter", type = t
	    })

-- iron_digger_lover
ins(quests, {
       'iron_digger_lover', "Iron Digger Lover", nil, {mod..":stone_with_iron"}, 1, {mod..":sword_steel"}, "iron_digger", type = t
	    })

-- iron_digger_pro
ins(quests, {
       'iron_digger_pro', "Iron Digger Pro", nil, {mod..":stone_with_iron"}, 1, {mod..":pick_steel", mod..":axe_steel"}, "iron_digger_lover", type = t
	    })

-- iron_digger_expert
ins(quests, {
       'iron_digger_expert', "Iron Digger Expert", nil, {mod..":stone_with_iron"}, 3, {mod..":sign_wall_steel", mod..":rail"}, "iron_digger_pro", type = t
	    })

-- iron_digger_master
ins(quests, {
       'iron_digger_master', "Iron Digger Master", nil, {mod..":stone_with_iron"}, 1, {mod..":ladder_steel"}, "iron_digger_expert", type = t
	    })

-- iron_digger_god
ins(quests, {
       'iron_digger_god', "Iron Digger God", nil, {mod..":stone_with_iron"}, 2, {mod..":steelblock"}, "iron_digger_master", type = t
	    })

-- copper_digger
ins(quests, {
       'copper_digger', "Copper Digger", nil, {mod..":stone_with_copper"}, 9, {mod..":copperblock"}, "furnace_crafter", type = t
	    })

-- bronze_era
ins(quests, {
       'bronze_era', "Bronze Era", nil, {mod..":stone_with_copper"}, 1, {mod..":bronze_ingot"}, {"furnace_crafter", "iron_digger"}, type = t
	    })

-- gold_digger
ins(quests, {
       'gold_digger', "Gold Digger", nil, {mod..":stone_with_gold"}, 9, {mod..":goldblock"}, "furnace_crafter", type = t
	    })

-- mese_digger
ins(quests, {
       'mese_digger', "Mese Digger", nil, {mod..":stone_with_mese"}, 1, {mod..":mese_crystal_fragment", mod..":shovel_mese"}, "iron_digger_pro|bronze_crafter_pro", type = t
	    })

-- mese_digger_lover
ins(quests, {
       'mese_digger_lover', "Mese Digger Lover", nil, {mod..":stone_with_mese"}, 1, {mod..":sword_mese"}, "mese_digger", type = t
	    })

-- mese_digger_pro
ins(quests, {
       'mese_digger_pro', "Mese Digger Pro", nil, {mod..":stone_with_mese"}, 1, {mod..":pick_mese", mod..":axe_mese", mod..":meselamp"}, "mese_digger_lover", type = t
	    })

-- mese_digger_expert
ins(quests, {
       'mese_digger_expert', "Mese Digger Expert", nil, {mod..":stone_with_mese"}, 6, {mod..":mese"}, "mese_digger_pro", type = t
	    })

-- diamond_digger
ins(quests, {
       'diamond_digger', "Diamond Digger", nil, {mod..":stone_with_diamond"}, 1, {mod..":shovel_diamond"}, "iron_digger_pro|bronze_crafter_pro", type = t
	    })

-- diamond_digger_lover
ins(quests, {
       'diamond_digger_lover', "Diamond Digger Lover", nil, {mod..":stone_with_diamond"}, 1, {mod..":sword_diamond"}, "diamond_digger", type = t
	    })

-- diamond_digger_pro
ins(quests, {
       'diamond_digger_pro', "Diamond Digger Pro", nil, {mod..":stone_with_diamond"}, 1, {mod..":pick_diamond", mod..":axe_diamond"}, "diamond_digger_lover", type = t
	    })

-- diamond_digger_expert
ins(quests, {
       'diamond_digger_expert', "Diamond Digger Expert", nil, {mod..":stone_with_diamond"}, 6, {mod..":diamondblock"}, "diamond_digger_pro", type = t
	    })

-- obsidian_digger
ins(quests, {
       'obsidian_digger', "Obsidian Digger", nil, {mod..":obsidian"}, 1, {mod..":obsidian_shard"}, "iron_digger_pro|bronze_crafter_pro", type = t
	    })

-- obsidian_digger_lover
ins(quests, {
       'obsidian_digger_lover', "Obsidian Digger Lover", nil, {mod..":obsidian"}, 2, {"stairs:slab_obsidian"}, "obsidian_digger", type = t
	    })

-- obsidian_digger_pro
ins(quests, {
       'obsidian_digger_pro', "Obsidian Digger Pro", nil, {mod..":obsidian"}, 1, {mod..":obsidianbrick"}, "obsidian_digger_lover", type = t
	    })

-- obsidian_digger_expert
ins(quests, {
       'obsidian_digger_expert', "Obsidian Digger Expert", nil, {mod..":obsidian"}, 2, {"stairs:stair_obsidian"}, "obsidian_digger_pro", type = t
	    })

----- Quests with type="craft" -----
t = "craft"

-- wood_crafter
ins(quests, {
       'wood_crafter', "Wood Crafter", nil, {mod..":wood", mod..":junglewood", mod..":acacia_wood", mod..":pine_wood", mod..":aspen_wood"}, 1, {mod..":stick"}, "tree_digger", type = t
	    })

-- wood_crafter_lover
ins(quests, {
       'wood_crafter_lover', "Wood Crafter Lover", nil, {mod..":wood", mod..":junglewood", mod..":acacia_wood", mod..":pine_wood", mod..":aspen_wood"}, 1, {mod..":sword_wood"}, "wood_crafter", type = t
	    })

-- wood_crafter_pro
ins(quests, {
       'wood_crafter_pro', "Wood Crafter Pro", nil, {mod..":wood", mod..":junglewood", mod..":acacia_wood", mod..":pine_wood", mod..":aspen_wood"}, 1, {"stairs:slab_wood", "stairs:slab_junglewood", "stairs:slab_pine_wood", "stairs:slab_acacia_wood", "stairs:slab_aspen_wood"}, "wood_crafter_lover", type = t
	    })

-- wood_crafter_expert
ins(quests, {
       'wood_crafter_expert', "Wood Crafter Expert", nil, {mod..":wood", mod..":junglewood", mod..":acacia_wood", mod..":pine_wood", mod..":aspen_wood"}, 3, {mod..":sign_wall_wood", "stairs:stair_wood", "stairs:stair_junglewood", "stairs:stair_pine_wood", "stairs:stair_acacia_wood", "stairs:stair_aspen_wood"}, "wood_crafter_pro", type = t
	    })

-- wood_crafter_master
ins(quests, {
       'wood_crafter_master', "Wood Crafter Master", nil, {mod..":wood", mod..":junglewood", mod..":acacia_wood", mod..":pine_wood", mod..":aspen_wood"}, 2, {mod..":chest"}, "wood_crafter_expert", type = t
	    })

-- sticks_crafter
ins(quests, {
       'sticks_crafter', "Sticks Crafter", nil, {mod..":stick"}, 2, {mod..":shovel_wood"}, "wood_crafter", type = t
	    })

-- sticks_crafter_lover
ins(quests, {
       'sticks_crafter_lover', "Sticks Crafter Lover", nil, {mod..":stick"}, 5, {mod..":ladder_wood"}, "sticks_crafter", type = t
	    })

-- more_tools
ins(quests, {
       'more_tools', "More Tools", nil, {mod..":wood", mod..":junglewood", mod..":acacia_wood", mod..":pine_wood", mod..":aspen_wood"}, 1, {mod..":axe_wood", mod..":pick_wood"}, {"wood_crafter_lover", "sticks_crafter"}, type = t
	    })

-- paper_crafter
ins(quests, {
       'paper_crafter', "Paper Crafter", nil, {mod..":paper"}, 3, {mod..":book"}, "papyrus_digger", type = t
	    })

-- book_crafter
ins(quests, {
       'book_crafter', "Book Crafter", nil, {mod..":book"}, 3, {mod..":bookshelf"}, {"wood_crafter_expert", "paper_crafter"}, type = t
	    })

-- clay_crafter
ins(quests, {
       'clay_crafter', "Clay Crafter", nil, {mod..":clay"}, 1, {mod..":clay_lump"}, "clay_digger", type = t
	    })

-- wood_architect
ins(quests, {
       'wood_architect', "Wood Architect", nil, {mod..":wood", mod..":junglewood", mod..":acacia_wood", mod..":pine_wood", mod..":aspen_wood"}, 1, {mod..":fence_wood", mod..":fence_junglewood", mod..":fence_pine_wood", mod..":fence_acacia_wood", mod..":fence_aspen_wood"}, {"sticks_crafter", "wood_crafter_pro"}, type = t
	    })

-- furnace_crafter
ins(quests, {
       'furnace_crafter', "Furnace Crafter", nil, {mod..":furnace"}, 1, {mod..":brick", mod..":stonebrick", mod..":desert_stonebrick", "stairs:slab_stonebrick", "stairs:slab_desert_stonebrick", "stairs:stair_stonebrick", "stairs:stair_desert_stonebrick", "stairs:slab_stone", "stairs:slab_desert_stone", "stairs:stair_stone", "stairs:stair_desert_stone"}, "stone_digger_master", type = t, custom_level = true
	    })

-- brick_crafter
ins(quests, {
       'brick_crafter', "Bricks Crafter", nil, {mod..":brick"}, 1, {mod..":clay_brick"}, {"clay_digger", "furnace_crafter"}, type = t
	    })

-- brick_crafter_lover
ins(quests, {
       'brick_crafter_lover', "Bricks Crafter Lover", nil, {mod..":brick"}, 2, {"stairs:slab_brick"}, "brick_crafter", type = t
	    })

-- brick_crafter_pro
ins(quests, {
       'brick_crafter_pro', "Bricks Crafter Pro", nil, {mod..":brick"}, 3, {"stairs:stair_brick"}, "brick_crafter_lover", type = t
	    })

-- sandstone_crafter
ins(quests, {
       'sandstone_crafter', "Sandstone Crafter", nil, {mod..":sandstone"}, 1, {mod..":sand"}, "sand_digger", type = t
	    })

-- sandstone_crafter_lover
ins(quests, {
       'sandstone_crafter_lover', "Sandstone Crafter Lover", nil, {mod..":sandstone"}, 2, {"stairs:slab_sandstone"}, "sandstone_crafter", type = t
	    })

-- sandstone_crafter_pro
ins(quests, {
       'sandstone_crafter_pro', "Sandstone Crafter Pro", nil, {mod..":sandstone"}, 1, {mod..":sandstonebrick"}, "sandstone_crafter_lover", type = t
	    })

-- sandstone_crafter_expert
ins(quests, {
       'sandstone_crafter_expert', "Sandstone Crafter Expert", nil, {mod..":sandstone"}, 2, {"stairs:stair_sandstone"}, "sandstone_crafter_pro", type = t
	    })

-- sandstonebrick_crafter
ins(quests, {
       'sandstonebrick_crafter', "Sandstone Bricks Crafter", nil, {mod..":sandstonebrick"}, 3, {"stairs:slab_sandstonebrick"}, "sandstone_crafter_pro", type = t
	    })

-- sandstonebrick_crafter_lover
ins(quests, {
       'sandstonebrick_crafter_lover', "Sandstone Bricks Crafter Lover", nil, {mod..":sandstonebrick"}, 2, {"stairs:stair_sandstonebrick"}, "sandstonebrick_crafter", type = t
	    })

-- snowblock_crafter
ins(quests, {
       'snowblock_crafter', "Snow Block Crafter", nil, {mod..":snowblock"}, 1, {mod..":snow"}, "snow_digger", type = t
	    })

-- steelblock_crafter
ins(quests, {
       'steelblock_crafter', "Steel Block Crafter", nil, {mod..":steelblock"}, 1, {mod..":steel_ingot"}, "iron_digger_god", type = t
	    })

-- steelblock_crafter_lover
ins(quests, {
       'steelblock_crafter_lover', "Steel Block Crafter Lover", nil, {mod..":steelblock"}, 2, {"stairs:slab_steelblock"}, "steelblock_crafter", type = t
	    })

-- steelblock_crafter_pro
ins(quests, {
       'steelblock_crafter_pro', "Steel Block Crafter Pro", nil, {mod..":steelblock"}, 3, {"stairs:stair_steelblock"}, "steelblock_crafter_lover", type = t
	    })

-- copperblock_crafter
ins(quests, {
       'copperblock_crafter', "Copper Block Crafter", nil, {mod..":copperblock"}, 1, {mod..":copper_ingot"}, "copper_digger", type = t
	    })

-- copperblock_crafter_lover
ins(quests, {
       'copperblock_crafter_lover', "Copper Block Crafter Lover", nil, {mod..":copperblock"}, 2, {"stairs:slab_copperblock"}, "copperblock_crafter", type = t
	    })

-- copperblock_crafter_pro
ins(quests, {
       'copperblock_crafter_pro', "Copper Block Crafter Pro", nil, {mod..":copperblock"}, 3, {"stairs:stair_copperblock"}, "copperblock_crafter_lover", type = t
	    })

-- bronze_crafter
ins(quests, {
       'bronze_crafter', "Bronze Crafter", nil, {mod..":bronze_ingot"}, 1, {mod..":shovel_bronze"}, "bronze_era", type = t
	    })

-- bronze_crafter_lover
ins(quests, {
       'bronze_crafter_lover', "Bronze Crafter Lover", nil, {mod..":bronze_ingot"}, 1, {mod..":sword_bronze"}, "bronze_crafter", type = t
	    })

-- bronze_crafter_pro
ins(quests, {
       'bronze_crafter_pro', "Bronze Crafter Pro", nil, {mod..":bronze_ingot"}, 1, {mod..":pick_bronze", mod..":axe_bronze"}, "bronze_crafter_lover", type = t
	    })

-- bronze_crafter_expert
ins(quests, {
       'bronze_crafter_expert', "Bronze Crafter Expert", nil, {mod..":bronze_ingot"}, 6, {mod..":bronzeblock"}, "bronze_crafter_pro", type = t
	    })

-- bronzeblock_crafter
ins(quests, {
       'bronzeblock_crafter', "Bronze Block Crafter", nil, {mod..":bronzeblock"}, 3, {"stairs:slab_bronzeblock"}, "bronze_crafter_expert", type = t
	    })

-- bronzeblock_crafter_lover
ins(quests, {
       'bronzeblock_crafter_lover', "Bronze Block Crafter Lover", nil, {mod..":bronzeblock"}, 3, {"stairs:stair_bronzeblock"}, "bronzeblock_crafter", type = t
	    })

-- goldblock_crafter
ins(quests, {
       'goldblock_crafter', "Gold Block Crafter", nil, {mod..":goldblock"}, 1, {mod..":gold_ingot"}, "gold_digger", type = t
	    })

-- goldblock_crafter_lover
ins(quests, {
       'goldblock_crafter_lover', "Gold Block Crafter Lover", nil, {mod..":goldblock"}, 2, {"stairs:slab_goldblock"}, "goldblock_crafter", type = t
	    })

-- goldblock_crafter_pro
ins(quests, {
       'goldblock_crafter_pro', "Gold Block Crafter Pro", nil, {mod..":goldblock"}, 3, {"stairs:stair_goldblock"}, "goldblock_crafter_lover", type = t
	    })

-- obsidian_shard_crafter
ins(quests, {
       'obsidian_shard_crafter', "Obsidian Shard Crafter", nil, {mod..":obsidian_shard"}, 9, {mod..":obsidian"}, "obsidian_digger", type = t
	    })

-- obsidianbrick_crafter
ins(quests, {
       'obsidianbrick_crafter', "Obsidian Brick Crafter", nil, {mod..":obsidianbrick"}, 3, {"stairs:slab_obsidianbrick"}, "obsidian_digger_pro", type = t
	    })

-- obsidianbrick_crafter_lover
ins(quests, {
       'obsidianbrick_crafter_lover', "Obsidian Brick Crafter Lover", nil, {mod..":obsidianbrick"}, 3, {"stairs:stair_obsidianbrick"}, "obsidianbrick_crafter", type = t
	    })

-- diamondblock_crafter
ins(quests, {
       'diamondblock_crafter', "Diamond Block Crafter", nil, {mod..":diamondblock"}, 1, {mod..":diamond"}, "diamond_digger_expert", type = t
	    })

-- mese_crafter
ins(quests, {
       'mese_crafter', "Mese Crafter", nil, {mod..":mese"}, 1, {mod..":mese_crystal"}, "mese_digger_expert", type = t
	    })

-- register quests
sys4_quests.registerQuests()
