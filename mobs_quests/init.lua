-- mobs Quests
-- By Sys4

-- This mod add quests based on mobs mod

if minetest.get_modpath("sys4_quests")
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
   
   ----- Quests with type="dig" -----
   local t = "dig"

   if minetest.get_modpath("farming") then
      -- unlock_magic_lasso
      ins(quests, {
	     'unlock_magic_lasso', "Unlock Magic Lasso", nil, {"default:stone_with_gold"}, 4, {mod..":magic_lasso"}, {"stone_digger_pro", "farming_tools", "diamond_digger_expert"}, type = t
		  })
      
      t = "craft"
      
      if minetest.get_modpath("dye") then
	 -- unlock_nametag
	 ins(quests, {
		'unlock_nametag', "Unlock Nametag", nil, {"dye:black"}, 1, {mod..":nametag"}, {"coal_digger", "papyrus_digger", "farming_tools"}, type = t
		     })
	 
      end

      -- unlock_net
      ins(quests, {
	     'unlock_net', "Unlock Net", nil, {"default:stick"}, 3, {mod..":net", mod..":beehive"}, {"sticks_crafter", "farming_tools"}, type = t
		  })

      -- beehive_crafter
      ins(quests, {
	     'beehive_crafter', "Beehive Crafter", nil, {mod..":beehive"}, 1, {mod..":honey", mod..":honey_block"}, "unlock_net", type = t, custom_level = true
		  })
   end

   t = "craft"
   
   if minetest.get_modpath("bucket") then
      -- bucket_crafter
      ins(quests, {
	     'bucket_crafter', "Bucket Crafter", nil, {"bucket:bucket_empty"}, 1, {mod..":cheese", mod..":cheeseblock"}, "iron_digger_pro", type = t, custom_level = true
		  })
   end

   -- unlock_lava_pickaxe
   ins(quests, {
	  'unlock_lava_pickaxe', "Unlock Lava Pickaxe", nil, {"default:obsidian_shard"}, 2, {mod..":pick_lava"}, "obsidian_digger", type = t
	       })

   sys4_quests.registerQuests()

   up('iron_digger_lover', nil, {mod..":shears"})

end
