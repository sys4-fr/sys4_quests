-- ethereal Quests
-- By Sys4

-- This mod add quests based on ethereal mod

if minetest.get_modpath("minetest_quests")
and minetest.get_modpath("ethereal") then
   
   -- give initial stuff
   sys4_quests.addInitialStuff("default:junglesapling")
   sys4_quests.addInitialStuff("ethereal:bamboo_sprout")

   -- Redefine ethereal.grow_sapling for the bamboo_sprout grow on ethereal:green_moss --

   -- check if sapling has enough height room to grow
   local function enough_height(pos, height)

      local nod = minetest.line_of_sight(
	 {x = pos.x, y = pos.y + 1, z = pos.z},
	 {x = pos.x, y = pos.y + height, z = pos.z})

      if not nod then
	 return false -- obstructed
      else
	 return true -- can grow
      end
   end

   local grow_sapling = ethereal.grow_sapling
   
   ethereal.grow_sapling = function(pos, node)
      grow_sapling(pos, node)
      
      local under =  minetest.get_node({
					  x = pos.x,
					  y = pos.y - 1,
					  z = pos.z
				       }).name
      
      if not minetest.registered_nodes[node.name] then
	 return
      end
      
      local height = minetest.registered_nodes[node.name].grown_height
      
      -- do we have enough height to grow sapling into tree?
      if not height or not enough_height(pos, height) then
	 return
      end
      
      -- Check if Ethereal Sapling is growing on correct substrate
      
      if node.name == "ethereal:bamboo_sprout"
      and under == "ethereal:bamboo_dirt" or under == "ethereal:green_moss" then
	 ethereal.grow_bamboo_tree(pos)
      end   
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

   ----- Quests Groups -----
   local dark = "Dark Age"
   local wood = "Wood Age"
   local farm = "Farming Age"
   local stone = "Stone Age"
   local metal = "Metal Age"
   local middle = "Middle Age"

   -- update quests from default
   up('snow_digger', {'default:ice'}, {mod..":icebrick", mod..":snowbrick"})
      
   local dirtNodes = {mod..":bamboo_dirt", mod..":cold_dirt", mod..":crystal_dirt", mod..":dry_dirt", mod..":fiery_dirt", mod..":gray_dirt", mod..":green_dirt", mod..":grove_dirt", mod..":jungle_dirt", mod..":mushroom_dirt", mod..":prairie_dirt"}
   
   if minetest.get_modpath("moreblocks_quests") then
      up('dirt_digger', dirtNodes, {mod..":bonemeal", mod..":worm", "default:desert_sand"})
      
      up('torch_placer', nil, {mod..":glostone"})
   else
      ins(dirtNodes, {"default:dirt", "default:dirt_with_grass", "default:dirt_with_dry_grass", "default:dirt_with_snow"})
      
      ins(quests, {
	     'dirt_digger', "Dirt Digger", "dirt blocks", dirtNodes, 1, {"default:desert_sand", mod..":bonemeal", mod..":worm"}, nil, type = "dig", group = dark
		  })
      
      ins(quests, {
	     'torch_placer', "Torch Placer", nil, {"default:torch"}, 1, {mod..":glostone"}, {"coal_digger", "furnace_crafter"}, type = "place"
		  })
   end

   local treeNodes = {mod..":banana_trunk", mod..":birch_trunk", mod..":frost_tree", mod..":palm_trunk", mod..":redwood_trunk", mod..":willow_trunk", mod..":yellow_trunk"}
   local woodNodes = {mod..":banana_wood", mod..":birch_wood", mod..":frost_wood", mod..":palm_wood", mod..":redwood_wood", mod..":willow_wood", mod..":yellow_wood"}

   up('tree_digger', treeNodes, woodNodes)

   up('wood_crafter', woodNodes, {mod..":bowl"})
   up('wood_crafter_lover', woodNodes, nil)

   local fenceNodes = {mod..":fence_banana", mod..":fence_birch", mod..":fence_frostwood", mod..":fence_mushroom", mod..":fence_palm", mod..":fence_redwood", mod..":fence_scorched", mod..":fence_willow", mod..":fence_yelowwood"}
   local fenceGates = {mod..":fencegate_banana_closed", mod..":fencegate_birch_closed", mod..":fencegate_frostwood_closed", mod..":fencegate_mushroom_closed", mod..":fencegate_palm_closed", mod..":fencegate_redwood_closed", mod..":fencegate_scorched_closed", mod..":fencegate_willow_closed", mod..":fencegate_yelowwood_closed"}

   local woodStairsNodes = {"stairs:slab_banana_wood", "stairs:slab_birch_wood", "stairs:slab_frost_wood", "stairs:slab_palm_wood", "stairs:slab_redwood_wood", "stairs:slab_willow_wood", "stairs:slab_yellow_wood", "stairs:stair_banana_wood", "stairs:stair_birch_wood", "stairs:stair_frost_wood", "stairs:stair_palm_wood", "stairs:stair_redwood_wood", "stairs:stair_willow_wood", "stairs:stair_yellow_wood"}

   up('wood_builder', woodNodes, woodStairsNodes)

   for i = 1, #woodNodes do
      ins(woodStairsNodes, woodNodes[i])
   end
   up('wood_builder_lover', woodStairsNodes, nil)

   up('sticks_crafter', nil, fenceNodes)
   up('fence_placer', fenceNodes, fenceGates)

   up('papyrus_digger', {mod..":bamboo"}, nil)
   up('paper_crafter', nil, {mod..":paper_wall"})
   up('cotton_digger', nil, {mod..":fishing_rod", mod..":fishing_rod_baited", mod..":sashimi"})
   up('flower_digger', {mod..":fire_flower"}, {mod..":fire_dust", mod..":lightstring"})

   up('coal_digger', nil, {mod..":charcoal_lump", mod..":scorched_tree"})
   up('stone_digger_pro', nil, {"default:gravel"})
   up('stone_digger_expert', nil, {mod..":stone_ladder"})
   up('gravel_digger', nil, {"default:dirt"})
   up('furnace_crafter', nil, {mod..":candle"})

   up('iron_digger_pro', nil, {mod..":bucket_cactus"})

   up('mese_digger', nil, {mod..":light_staff"})

   local t = "dig"

   -- leaves_digger
   ins(quests, {
	  'leaves_digger', "Leaves Digger", nil, {"default:leaves", "default:acacia_leaves", "default:aspen_leaves", "default:jungleleaves", "default:pine_needles", mod..":bamboo_leaves", mod..":bananaleaves", mod..":birch_leaves", mod..":frost_leaves", mod..":orange_leaves", mod..":palmleaves", mod..":redwood_leaves", mod..":willow_twig", mod..":yellowleaves"}, 9, {mod..":bush", mod..":bush2", mod..":bush3", mod..":vine"}, nil, type = t, group = dark
	       })

   -- bamboo_digger
   ins(quests, {
	  'bamboo_digger', "Bamboo Digger", nil, {mod..":bamboo"}, 9, {mod..":bamboo_floor"}, nil, type = t, group = dark
	       })

   -- unlock_moss
   ins(quests, {
	  'unlock_moss', "Unlock Moss", "frost/jungle leaves or dry shrub/snowy grass", {mod..":frost_leaves", mod..":dry_shrub", mod..":snowygrass", "default:jungleleaves"}, 1, {mod..":crystal_moss", mod..":fiery_moss", mod..":gray_moss", mod..":green_moss"}, {"dirt_digger", "leaves_digger"}, type = t, group = dark
	       })

   -- mushroom_digger
   ins(quests, {
	  'mushroom_digger', "Mushroom Digger", "mushrooms", {"flowers:mushroom_brown", "flowers:mushroom_red"}, 2, {mod..":mushroom_soup", mod..":mushroom", mod..":mushroom_moss"}, "wood_crafter", type = t, group = wood
	       })

   -- vegetable_digger
   ins(quests, {
	  'vegetable_digger', "Vegetable Digger", "vegetables", {mod..":onion_4", mod..":fern"}, 2, {mod..":hearty_stew"}, "mushroom_digger", type = t, group = wood
	       })

   -- banana_digger
   ins(quests, {
	  'banana_digger', "Banana Digger", nil, {mod..":banana"}, 1, {mod..":banana_dough"}, "furnace_crafter", type = t, group = stone
	       })

   -- crystal_digger
   ins(quests, {
	  'crystal_digger', "Crystal Digger", nil, {mod..":crystal_spike"}, 2, {mod..":crystal_ingot"}, "mese_digger_lover", type = t, group = middle
	       })

   t = "craft"

   -- crystal_crafter
   ins(quests, {
	  'crystal_crafter', "Crystal Crafter", nil, {mod..":crystal_ingot"}, 1, {mod..":shovel_crystal"}, "crystal_digger", type = t, group = middle
	       })

   -- crystal_crafter_lover
   ins(quests, {
	  'crystal_crafter_lover', "Crystal Crafter Lover", nil, {mod..":crystal_ingot"}, 1, {mod..":sword_crystal", mod..":crystal_gilly_staff"}, "crystal_crafter", type = t, group = middle
	       })

   -- crystal_crafter_pro
   ins(quests, {
	  'crystal_crafter_pro', "Crystal Crafter Pro", nil, {mod..":crystal_ingot"}, 1, {mod..":axe_crystal", mod..":pick_crystal"}, "crystal_crafter_lover", type = t, group = middle
	       })

   -- crystal_crafter_expert
   ins(quests, {
	  'crystal_crafter_expert', "Crystal Crafter Expert", nil, {mod..":crystal_ingot"}, 6, {mod..":crystal_block"}, "crystal_crafter_pro", type = t, group = middle
	       })

   sys4_quests.registerQuests()
end
