-- mobs Quests
-- By Sys4

-- This mod add quests based on mobs mod

if minetest.get_modpath("minetest_quests")
and minetest.get_modpath("mobs") then
   
   local S
   if minetest.get_modpath("intllib") then
      S = intllib.Getter()
   else
      S = function(s) return s end
   end
   
   local ins = table.insert
   local up = sys4_quests.updateQuest
   
   ---------- Quests for mobs mod ----------
   local mod = "mobs"
   local quests = sys4_quests.initQuests(mod, S)
   
   ----- Quests Groups -----
   local farm = "Farming Age"
   local stone = "Stone Age"
   local metal = "Metal Age"
   local middle = "Middle Age"

   ----- Quests with type="dig" -----
   local t = "craft"

   if minetest.get_modpath("farming") then
      -- unlock_magic_lasso
      ins(quests, {
	     'unlock_magic_lasso', "Unlock Magic Lasso", nil, {"default:diamondblock"}, 1, {mod..":magic_lasso"}, {"diamond_digger_expert"}, type = t, custom_level = true, group = middle
		  })
      
      if minetest.get_modpath("dye") then
	 -- unlock_nametag
	 ins(quests, {
		'unlock_nametag', "Unlock Nametag", nil, {"dye:black"}, 1, {mod..":nametag"}, {"coal_digger"}, type = t, group = stone
		     })
	 
      end

      -- unlock_net
      ins(quests, {
	     'unlock_net', "Unlock Net", nil, {"farming:cotton_1","farming:cotton_2","farming:cotton_3","farming:cotton_4","farming:cotton_5","farming:cotton_6","farming:cotton_7","farming:cotton_8"}, 2, {mod..":net", mod..":beehive"}, {"book_crafter"}, type = "dig", group = farm
		  })

      -- beehive_crafter
      ins(quests, {
	     'beehive_crafter', "Beehive Crafter", nil, {mod..":beehive"}, 1, {mod..":honey", mod..":honey_block"}, "unlock_net", type = t, custom_level = true, group = farm
		  })
   end

   if minetest.get_modpath("bucket") then
      -- bucket_crafter
      ins(quests, {
	     'bucket_crafter', "Bucket Crafter", nil, {"bucket:bucket_empty"}, 1, {mod..":cheese", mod..":cheeseblock"}, "iron_digger_pro", type = t, custom_level = true, group = metal
		  })
   end

   -- unlock_lava_pickaxe
   ins(quests, {
	  'unlock_lava_pickaxe', "Unlock Lava Pickaxe", nil, {"default:obsidian_shard"}, 2, {mod..":pick_lava"}, "obsidian_digger", type = t, group = middle
	       })

   sys4_quests.registerQuests()

   up('iron_digger_lover', nil, {mod..":shears"})

end
