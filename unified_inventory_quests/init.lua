-- unified_inventory Quests
-- By Sys4

-- This mod add quests based on unified_inventory mod

if minetest.get_modpath("sys4_quests")
   and minetest.get_modpath("unified_inventory") then
   
   local S
   if minetest.get_modpath("intllib") then
      S = intllib.Getter()
   else
      S = function(s) return s end
   end
   
   local ins = table.insert
   local up = sys4_quests.updateQuest
   
   ---------- Quests for unified_inventory mod ----------
   local mod = "unified_inventory"
   local quests = sys4_quests.initQuests(mod, S)
   
   ----- Quests with type="dig" -----
   local t = "craft"

   -- wool_crafter_pro
   ins(quests, {
	  'wool_crafter_pro', "Wool Crafter Pro", "wools", {"wool:white", "wool:black", "wool:blue", "wool:orange", "wool:red", "wool:violet", "wool:yellow", "wool:brown", "wool:cyan", "wool:dark_green", "wool:dar_grey", "wool:green", "wool:grey", "wool:magenta", "wool:pink"}, 4, {mod..":bag_small"}, "wool_crafter_lover", type = t
	       })

   -- bag_crafter
   ins(quests, {
	  'bag_crafter', "Bag Crafter", nil, {mod..":bag_small"}, 4, {mod..":bag_medium"}, "wool_crafter_pro", type = t, custum_level = true
	       })

   -- bag_crafter_lover
   ins(quests, {
	  'bag_crafter_lover', "Bag Crafter Lover", nil, {mod..":bag_medium"}, 4, {mod..":bag_large"}, "bag_crafter", type = t, custum_level = true
	       })

   sys4_quests.registerQuests()

end
