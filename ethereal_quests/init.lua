-- Ethereal Quests
-- By Sys4

-- This mod add quests based on ethereal mod

if not minetest.get_modpath("sys4_quests") then
   return
end

local S
if minetest.get_modpath("intllib") then
   S = intllib.Getter()
else
   S = function(s) return s end
end

local ins = table.insert
local up = sys4_quests.updateQuest

---------- Quests for ethereal mod ----------
local mod = "ethereal"
local quests = sys4_quests.initQuests(mod, S)

----- Quests with type="dig" -----
local t = "dig"

up('tree_digger', {"ethereal:banana_trunk", "ethereal:birch_trunk", "ethereal:frost_tree", "ethereal:palm_trunk", "ethereal:redwood_trunk", "ethereal:willow_trunk", "ethereal:yellow_trunk"}, {"ethereal:banana_wood", "ethereal:birch_wood", "ethereal:frost_wood", "ethereal:palm_wood", "ethereal:redwood_wood", "ethereal:willow_wood", "ethereal:yellow_wood"})

up('crumbly_nodes_digger', {"ethereal:bamboo_dirt", "ethereal:cold_dirt", "ethereal:crystal_dirt", "ethereal:dry_dirt", "ethereal:fiery_dirt", "ethereal:gray_dirt", "ethereal:green_dirt", "ethereal:grove_dirt", "ethereal:jungle_dirt", "ethereal:mushroom_dirt", "ethereal:prairie_dirt"}, {"default:desert_sand", "ethereal:snowbrick", "ethereal:worm"})

up('papyrus_digger', {"ethereal:bamboo"}, {"ethereal:bamboo_floor"})

up('coal_digger', nil, {"ethereal:scorched_tree"})

up('stone_digger', nil, {"ethereal:stone_ladder"})

up('iron_digger', nil, {"ethereal:bucket_cactus"})

up('mese_digger', nil, {"ethereal:light_staff"})

up("wood_crafter", nil, {'ethereal:bowl'})

----- Quests with type="craft" -----
t = "craft"

up('wood_crafter', {"ethereal:banana_wood", "ethereal:birch_wood", "ethereal:frost_wood", "ethereal:palm_wood", "ethereal:redwood_wood", "ethereal:willow_wood", "ethereal:yellow_wood"}, {'ethereal:bowl'})

up('sticks_crafter', nil, {'ethereal:paper_wall', 'ethereal:fishing_rod', 'ethereal:fishing_rod_baited', 'ethereal:fence_acacia', 'ethereal:fence_banana', 'ethereal:fence_birch', 'ethereal:fence_frostwood', 'ethereal:fence_junglewood', 'ethereal:fence_mushroom', 'ethereal:fence_palm', 'ethereal:fence_pine', 'ethereal:fence_redwood', 'ethereal:fence_scorched', 'ethereal:fence_willow', 'ethereal:fence_yelowwood', 'ethereal:fence_acacia_closed', 'ethereal:fence_banana_closed', 'ethereal:fence_birch_closed', 'ethereal:fence_frostwood_closed', 'ethereal:fence_junglewood_closed', 'ethereal:fence_mushroom_closed', 'ethereal:fence_palm_closed', 'ethereal:fence_pine_closed', 'ethereal:fence_redwood_closed', 'ethereal:fence_scorched_closed', 'ethereal:fence_willow_closed', 'ethereal:fence_yelowwood_closed', 'ethereal:fencegate_wood_closed'})

t = "dig"

-- leave_digger
ins(quests, {
		'leave_digger', 'Leaves Digger', 'Leaves Blocks', {'default:acacia_leaves', 'default:jungleleaves', 'default:leaves', 'default:pine_needles', 'ethereal:bamboo_leaves', 'ethereal:bananaleaves', 'ethereal:birch_leaves', 'ethereal:frost_leaves', 'ethereal:orange_leaves', 'ethereal:palmleaves', 'ethereal:redwood_leaves', 'ethereal:willow_twig', 'ethereal:yellowleaves', 'ethereal:dry_shrub'}, 100, {'ethereal:vine', 'ethereal:bush', 'ethereal:green_moss', 'ethereal:crystal_moss', 'ethereal:gray_moss', 'ethereal:fiery_moss', 'ethereal:mushroom_moss'}, nil, type = t
		     })

-- banana_digger
ins(quests, {
       "banana_digger", "Banana Digger", nil, {"ethereal:banana"}, 100, {'ethereal:banana_dough'}, nil, type = t
	    })

-- ice_digger
ins(quests, {
       "ice_digger", "Ice Digger", nil, {"default:ice"}, 100, {'ethereal:icebrick'}, 'tools_crafter', type = t
	    })

-- crystal_spike_digger
ins(quests, {
       "crystal_spike_digger", "Crystal Spike Digger", nil, {"ethereal:crystal_spike"}, 100, {'ethereal:crystal_ingot'}, "tools_crafter_pro", type = t
	    })

t = 'craft'

-- crystal_crafter
ins(quests, {
       'crystal_crafter', "Crystal Crafter", nil, {'ethereal:crystal_ingot'}, 50, {'ethereal:sword_crystal', 'ethereal:axe_crystal', 'ethereal:shovel_crystal', 'ethereal:crystal_block'}, 'crystal_spike_digger', type = t
	    })

-- crystal_tools_crafter
ins(quests, {
       'crystal_tools_crafter', "Crystal Tools Crafter", "Crystal Tools", {'ethereal:sword_crystal', 'ethereal:axe_crystal', 'ethereal:shovel_crystal'}, 5, {'ethereal:crystal_gilly_staff', 'ethereal:pick_crystal'}, 'crystal_crafter', type = t 
	    })

-- bowl_crafter
ins(quests, {
       'bowl_crafter', "Bowl Crafter", nil, {'ethereal:bowl'}, 1, {'ethereal:mushroom_soup', 'ethereal:hearty_stew'}, 'wood_crafter', type = t
	    })

-- fire_dust_crafter
ins(quests, {
       'fire_dust_crafter', "Fire Dust Crafter", nil, {'ethereal:fire_dust'}, 50, {'ethereal:lightstring'}, 'flower_digger', type = t
	    })

-- register quests
sys4_quests.registerQuests(mod)
