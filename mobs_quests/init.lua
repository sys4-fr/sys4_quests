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
	     'unlock_net', "Unlock Net", nil, {"default:stick"}, 3, {mod..":net"}, {"sticks_crafter", "farming_tools"}, type = t
		  })
   end

   sys4_quests.registerQuests()

   up('iron_digger_lover', nil, {mod..":shears"})

end
