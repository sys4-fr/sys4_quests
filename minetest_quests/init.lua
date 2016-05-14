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
       'tree_digger', "Tree Digger", nil, {"default:tree", "default:jungletree", "default:acacia_tree", "default:pine_tree"}, 100, {"default:wood", "default:junglewood", "default:acacia_wood", "default:pine_wood"}, nil, type = t
	    })

-- crumbly_nodes_digger
ins(quests, {
       'crumbly_nodes_digger', 'Crumbly Nodes Digger', "Blocks of Crumbly Nodes", {'default:gravel', 'default:dirt', 'default:dirt_with_grass', 'default:dirt_with_dry_grass', 'default:dirt_with_snow', 'default:clay', 'default:desert_sand', 'default:sand', 'default:sandstone', 'default:snowblock', 'default:snow'}, 100, {"default:clay", "default:clay_lump", "default:sand", "default:sandstone", "default:snowblock", "default:snow"}, nil, type = t
	    })

-- papyrus_digger
ins(quests, {
       'papyrus_digger', 'Papyrus Digger', nil, {'default:papyrus'}, 100, {'default:paper'}, nil, type = t
	    })

-- coal_digger
ins(quests, {
       'coal_digger', 'Coal Digger', nil, {'default:stone_with_coal'}, 100, {"default:torch", "default:coal_lump", "default:coalblock"}, 'tools_crafter', type = t
	    })

-- stone_digger
ins(quests, {
       'stone_digger', "Stone Digger", nil, {'default:stone', 'default:desert_stone', 'default:cobble', 'default:desert_cobble', 'default:mossycobble'}, 100, {'default:sword_stone', 'default:axe_stone', 'default:shovel_stone', 'default:furnace'}, 'tools_crafter', type = t
	    })

-- iron_digger
ins(quests, {
       'iron_digger', 'Iron Digger', nil, {'default:stone_with_iron'}, 100, { 'default:steel_ingot', 'default:steelblock', 'default:sword_steel', 'default:axe_steel', 'default:shovel_steel', 'default:chest_locked', 'default:rail'}, 'tools_crafter_lover', type = t
	    })

-- copper_digger
ins(quests, {
       'copper_digger', 'Copper Digger', nil, {'default:stone_with_copper'}, 100, {'default:copper_ingot', 'default:copperblock', 'default:bronze_ingot'}, 'tools_crafter_lover', type = t
	    })

-- gold_digger
ins(quests, {
       'gold_digger', 'Gold Digger', nil, {'default:stone_with_gold'}, 100, {'default:gold_ingot', 'default:goldblock'}, 'tools_crafter_lover', type = t
	    })

-- mese_digger
ins(quests, {
       'mese_digger', 'Mese Digger', nil, {'default:stone_with_mese', 'default:mese'}, 100, {'default:mese', 'default:mese_crystal', 'default:mese_crystal_fragment', 'default:sword_mese', 'default:axe_mese', 'default:shovel_mese', 'default:meselamp'}, 'tools_crafter_pro', type = t
	    })

-- diamond_digger
ins(quests, {
       'diamond_digger', 'Diamond Digger', nil, {'default:stone_with_diamond'}, 100, {'default:diamond', 'default:diamondblock', 'default:sword_diamond', 'default:axe_diamond', 'default:shovel_diamond'}, 'tools_crafter_pro', type = t
	    })

-- obsidian_digger
ins(quests, {
       'obsidian_digger', 'Obsidian Digger', nil, {'default:obsidian'}, 100, {'default:obsidian', 'default:obsidian_shard', 'default:obsidianbrick'}, "tools_crafter_pro", type = t
	    })

----- Quests with type="craft" -----
t = "craft"

-- wood_crafter
ins(quests, {
       'wood_crafter', "Wood Crafter", nil, {"default:wood", "default:junglewood", "default:acacia_wood", "default:pine_wood"}, 100, {"default:stick", "default:chest", "default:sign_wall", "default:sword_wood", "default:axe_wood", "default:shovel_wood"}, "tree_digger", type = t
	    })

-- sticks_crafter
ins(quests, {
       'sticks_crafter', "Sticks Crafter", nil, {"default:stick"}, 100, {'default:ladder', 'default:fence_wood'}, 'wood_crafter', type = t
	    })

-- sandstone_crafter
ins(quests, {
       'sandstone_crafter', "Sandstone Crafter", nil, {'default:sandstone'}, 100, {'default:sandstonebrick'}, 'crumbly_nodes_digger', type = t
	    })

-- paper_crafter
ins(quests, {
       'paper_crafter', "Papers Crafter", nil, {'default:paper'}, 100, {'default:book'}, 'papyrus_digger', type = t
	    })

-- book_crafter
ins(quests, {
       'book_crafter', "Books Crafter", nil, {'default:book'}, 100, {'default:bookshelf'}, {'paper_crafter', 'wood_crafter'}, type = t
	    })

-- bronze_crafter
ins(quests, {
       'bronze_crafter', "Bronze Crafter", nil, {'default:bronze_ingot'}, 100, {'default:sword_bronze', 'default:axe_bronze', 'default:shovel_bronze'}, 'copper_digger', type = t
	    })

-- tools_crafter
ins(quests, {
       'tools_crafter', "Tools Crafter", "Wooden Tools", {'default:sword_wood', 'default:axe_wood', 'default:shovel_wood'}, 20, {'default:pick_wood'},  'wood_crafter', type = t
	    })

-- tools_crafter_lover
ins(quests, {
       'tools_crafter_lover', "Tools Crafter Lover", "Stone Tools", {'default:sword_stone', 'default:axe_stone', 'default:shovel_stone'}, 15, {'default:pick_stone'},  'stone_digger', type = t
	    })

-- tools_crafter_pro
ins(quests, {
       'tools_crafter_pro', "Tools Crafter Pro", "Steel or Bronze Tools", {'default:sword_steel', 'default:axe_steel', 'default:shovel_steel', 'default:sword_bronze', 'default:axe_bronze', 'default:shovel_bronze'}, 10, {'default:pick_steel', 'default:pick_bronze'},  'iron_digger', type = t
	    })

-- tools_crafter_expert
ins(quests, {
       'tools_crafter_expert', "Tools Crafter Expert", "Mese Tools", {'default:sword_mese', 'default:axe_mese', 'default:shovel_mese'}, 5, {'default:pick_mese'},  'mese_digger', type = t
	    })

-- tools_crafter_master
ins(quests, {
       'tools_crafter_master', "Tools Crafter Master", "Diamond Tools", {'default:sword_diamond', 'default:axe_diamond', 'default:shovel_diamond'}, 5, {'default:pick_diamond'}, 'diamond_digger', type = t
	    })

----- Quests with type="place" -----
t = "place"

-- furnace_builder
ins(quests, {
       'furnace_builder', "Furnace Builder", nil, {'default:furnace'}, 2, {'default:clay_brick', 'default:brick', 'default:stonebrick', 'default:desert_stonebrick'}, 'stone_digger', type = t
	    })

-- wood_builder
ins(quests, {
       'wood_builder', "Wood Builder", "Wooden Planks", {'default:wood', 'default:junglewood', 'default:acacia_wood', 'default:pine_wood'}, 100, {'stairs:slab_wood', 'stairs:slab_junglewood', 'stairs:slab_acacia_wood', 'stairs:slab_pine_wood'}, 'tree_digger', type = t
	    })

-- wood_builder_lover
ins(quests, {
       'wood_builder_lover', "Wood Builder Lover", "stairs:slab_wood", {'stairs:slab_wood', 'stairs:slab_junglewood', 'stairs:slab_acacia_wood', 'stairs:slab_pine_wood'}, 100, {'stairs:stair_wood', 'stairs:stair_junglewood', 'stairs:stair_acacia_wood', 'stairs:stair_pine_wood'}, 'wood_builder', type = t
	    })

----------- Register quests ----------
sys4_quests.registerQuests(mod)


---------- Quests for farming mod ----------
mod = "farming"
if minetest.get_modpath(mod) then
   quests = sys4_quests.initQuests(mod, S)
   
   -- Type Dig --
   t = "dig"
   
   -- wood_crafter UP
   up('wood_crafter', nil, {'farming:hoe_wood'})
   
   -- stone_digger UP
   up('stone_digger', nil, {'farming:hoe_stone'})
   
   -- iron_digger UP
   up('iron_digger', nil, {'farming:hoe_steel'})
   
   -- mese_digger UP
   up('mese_digger', nil, {'farming:hoe_mese'})
   
   -- diamond_digger UP
   up('diamond_digger', nil, {'farming:hoe_diamond'})
   
   -- wheat_digger
   ins(quests, {
	  'wheat_digger', "Wheat Digger", nil, {'farming:wheat_1', 'farming:wheat_2', 'farming:wheat_3', 'farming:wheat_4', 'farming:wheat_5', 'farming:wheat_6', 'farming:wheat_7', 'farming:wheat_8'}, 100, {'farming:flour'}, 'wood_crafter', type = t
	       })
   
   -- Type Craft --
   t = "craft"
   
   -- bronze_crafter UP
   up('bronze_crafter', nil, {'farming:hoe_bronze'})

   -- tools_crafter UP
   up('tools_crafter', {'farming:hoe_wood'}, nil)

   -- tools_crafter_lover UP
   up('tools_crafter_lover', {'farming:hoe_stone'}, nil)

   -- tools_crafter_pro UP
   up('tools_crafter_pro', {'farming:hoe_steel', 'farming:hoe_bronze'}, nil)

   -- tools_crafter_expert UP
   up('tools_crafter_expert', {'farming:hoe_mese'}, nil)

   -- tools_crafter_master UP
   up('tools_crafter_master', {'farming:hoe_diamond'}, nil)
   
   -- flour_crafter
   ins(quests, {
	  'flour_crafter', "Flour Crafter", nil, {'farming:flour'}, 100, {'farming:wheat', 'farming:straw'}, 'wheat_digger', type = t
	       })
   
   -- Type Place
   t = "place"

   -- straw_builder
   ins(quests, {
	  'straw_builder', "Straw Builder", nil, {'farming:straw'}, 100, {'stairs:slab_straw'}, 'flour_crafter', type = t
	       })

   -- straw_builder_lover
   ins(quests, {
	  'straw_builder_lover', "Straw Builder Lover", nil, {'stairs:slab_straw'}, 100, {'stairs:stair_straw'}, 'straw_builder', type = t
	       })

   sys4_quests.registerQuests(mod)
end

---------- Quests for wool mod ----------
mod = "wool"
if minetest.get_modpath(mod)
and minetest.get_modpath("farming") then
   quests = sys4_quests.initQuests(mod, S)
   
   -- Type Dig --
   t = "dig"

   -- Cotton_digger
   ins(quests, {
	  'cotton_digger', "Cotton Digger", nil, {'farming:cotton_1', 'farming:cotton_2', 'farming:cotton_3', 'farming:cotton_4', 'farming:cotton_5', 'farming:cotton_6', 'farming:cotton_7', 'farming:cotton_8', }, 100, {'wool:white'}, 'wood_crafter', type = t
       })

   -- Type Craft --
   t = "craft"

   -- wool_crafter
   ins(quests, {
	  'wool_crafter', "Wool Crafter", nil, {'wool:white'}, 100, {'wool:black', 'wool:blue', 'wool:brown', 'wool:cyan', 'wool:dark_green', 'wool:dark_grey', 'wool:green', 'wool:grey', 'wool:magenta', 'wool:orange', 'wool:pink', 'wool:red', 'wool:violet', 'wool:yellow'}, 'cotton_digger', type = t
	       })

   sys4_quests.registerQuests(mod)
end

---------- Quests for dye mod ----------
mod = "dye"
if minetest.get_modpath(mod) then
   quests = sys4_quests.initQuests(mod, S)
   
   -- Type Dig --
   t = "dig"

   -- coal_digger UP
   up('coal_digger', nil, {'dye:black'})

   if minetest.get_modpath("flowers") then

      -- flower_digger
      ins(quests, {
	     'flower_digger', "Flower Digger", "Flowers", {'flowers:dandelion_white', 'flowers:dandelion_yellow', 'flowers:geranium', 'flowers:rose', 'flowers:tulip', 'flowers:viola'}, 100, {'dye:blue', 'dye:brown', 'dye:cyan', 'dye:dark_green', 'dye:dark_grey', 'dye:green', 'dye:grey', 'dye:magenta', 'dye:orange', 'dye:pink', 'dye:red', 'dye:violet', 'dye:yellow', 'dye:white'}, nil, type = t
		  })
   end

   sys4_quests.registerQuests(mod)
end

---------- Quests for beds mod ----------
mod = "beds"
if minetest.get_modpath(mod)
and minetest.get_modpath("wool") then
   quests = sys4_quests.initQuests(mod)
   
   -- Type Craft --
   t = "craft"

   -- wool_crafter_lover
   ins(quests, {
	  'wool_crafter_lover', "Wool Crafter Lover", "Colored Wools", {'wool:black', 'wool:blue', 'wool:brown', 'wool:cyan', 'wool:dark_green', 'wool:dark_grey', 'wool:green', 'wool:grey', 'wool:magenta', 'wool:orange', 'wool:pink', 'wool:red', 'wool:violet', 'wool:yellow'}, 100, {'beds:bed_bottom', 'beds:fancy_bed_bottom'}, 'wool_crafter', type = t
	       })

   sys4_quests.registerQuests(mod)
end

---------- Quests for boats mod ----------
mod = "boats"
if minetest.get_modpath(mod) then
   quests = sys4_quests.initQuests(mod, S)

   -- Type Craft --
   t = "craft"

   -- wood_crafter UP
   up('wood_crafter', nil, {'boats:boat'})

   -- sys4_quests.registerQuests(mod)
   -- Not needeed here, because there is no quest insertion
end

---------- Quests for bucket mod ----------
mod = "bucket"
if minetest.get_modpath(mod) then
   quests = sys4_quests.initQuests(mod, S)

   -- Type Place --
   t = "place"

   -- furnace_builder UP
   up('furnace_builder', nil, {'bucket:bucket_empty'})

end

---------- Quests for doors mod ----------
mod = "doors"
if minetest.get_modpath(mod) then
   quests = sys4_quests.initQuests(mod)

   -- Type Craft --
   t = "craft"

   -- wood_crafter UP
   up('wood_crafter', nil, {'doors:door_wood', 'doors:trapdoor'})

   -- obsidian_shard_crafter
   ins(quests, {
	  'obsidian_shard_crafter', "Obsidian shard Crafter", nil, {'default:obsidian_shard'}, 100, {'doors:door_obsidian_glass'}, 'obsidian_digger', type = t
	       })

   -- Type Dig --
   t = "dig"
   
   -- iron_digger UP
   up('iron_digger', nil, {'doors:door_steel'})

   -- Type Place --
   t = "place"

   -- glass_builder
   ins(quests, {
	  'glass_builder', "Glass Builder", nil, {'default:glass'}, 100, {'doors:door_glass'}, 'furnace_builder', type = t
	       })

   sys4_quests.registerQuests(mod)
end

---------- Quests for screwdriver mod ----------
mod = "screwdriver"
if minetest.get_modpath(mod) then
   quests = sys4_quests.initQuests(mod, S)

   -- Type Place --
   t = "place"

   -- furnace_builder
   up('furnace_builder', nil, {'screwdriver:screwdriver'})
end

---------- Quests for tnt mod ----------
mod = "tnt"
if minetest.get_modpath(mod) then
   quests = sys4_quests.initQuests(mod, S)

   -- Type Dig --
   t = "dig"
   
   -- gravel_digger
   ins(quests, {
	  'gravel_digger', "Gravel Digger", nil, {'default:gravel'}, 100, {'tnt:gunpowder'}, nil, type = t
	       })

   -- Type Craft --
   t = "craft"

   -- gunpowder_crafter
   ins(quests, {
	  'gunpowder_crafter', "Gunpowder Crafter", nil,{'tnt:gunpowder'}, 10, {'tnt:tnt'}, 'gravel_digger', type = t
	       })

   sys4_quests.registerQuests(mod)
end

---------- Quests for vessels mod ----------
mod = "vessels"
if minetest.get_modpath(mod) then
   quests = sys4_quests.initQuests(mod, S)

   -- Type Place --
   t = "place"

   -- furnace_builder UP
   up('furnace_builder', nil, {'vessels:steel_bottle', 'vessels:drinking_glass', 'vessels:glass_bottle', 'vessels:glass_fragments'})

   -- Type Craft --
   t = "craft"

   -- vessels_crafter
   ins(quests, {
	  'vessels_crafter', "Vessels Crafter", "Vessels Items", {'vessels:steel_bottle', 'vessels:drinking_glass', 'vessels:glass_bottle'}, 100, {'vessels:shelf'}, 'furnace_builder', type = t
	       })

   sys4_quests.registerQuests(mod)
end

---------- Quests for xpanes mod ----------
mod = "xpanes"
if minetest.get_modpath(mod) then
   quests = sys4_quests.initQuests(mod, S)

   -- Type Dig --
   t = "dig"

   -- iron_digger UP
   up('iron_digger', nil, {'xpanes:bar'})

   -- Type Place --
   t = "place"

   if minetest.get_modpath("doors") then
      -- glass_builder UP
      up('glass_builder', nil, {'xpanes:pane'})

   else
      -- glass_builder
      ins(quests, {
	     'glass_builder', "Glass Builder", nil, {'default:glass'}, 100, {'xpanes:pane'}, 'furnace_builder', type = t
		  })

      sys4_quests.registerQuests(mod)
   end
end
