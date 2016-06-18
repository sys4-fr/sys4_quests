-- thirsty Quests
-- By Sys4

-- This mod add quests based on thirsty mod

if minetest.get_modpath("minetest_quests")
and minetest.get_modpath("thirsty") then
   
   local S
   if minetest.get_modpath("intllib") then
      S = intllib.Getter()
   else
      S = function(s) return s end
   end
   
   local ins = table.insert
   local up = sys4_quests.updateQuest
   
   ---------- Quests for thirsty mod ----------
   local mod = "thirsty"
   local quests = sys4_quests.initQuests(mod, S)
   
   up('wood_crafter_pro', nil, {mod..":wooden_bowl"})

   ----- Quests with type="dig" -----
   local t = "dig"

   -- water_drinker
   ins(quests, {
	  'water_drinker', "Water Drinker", nil, {"default:stone_with_iron"}, 1, {mod..":steel_canteen"}, {"wood_crafter_pro", "iron_digger_pro"}, type = t
	       })

   t = "craft"
   
   -- water_drinker_lover
   ins(quests, {
	  'water_drinker_lover', "Water Drinker Lover", nil, {"default:bronze_ingot"}, 1, {mod..":bronze_canteen"}, {"water_drinker", "bronze_crafter_pro"}, type = t
	       })

   -- water_tools_crafter
   ins(quests, {
	  'water_tools_crafter', "Water Tools Crafter", nil, {"bucket:bucket_empty"}, 1, {mod..":drinking_fountain"}, "water_drinker", type = t, custom_level = true
	       })

   t = "dig"
   
   -- water_tools_crafter_lover
   ins(quests, {
	  'water_tools_crafter_lover', "Water Tools Crafter Lover", nil, {"default:stone_with_copper"}, 5, {mod..":water_fountain"}, {"water_tools_crafter", "bronze_crafter_pro", "mese_digger"}, type = t
	       })

   t = "craft"

   -- water_tools_crafter_pro
   ins(quests, {
	  'water_tools_crafter_pro', "Water Tools Crafter Pro", nil, {"bucket:bucket_empty"}, 1, {mod..":water_extender"}, "water_tools_crafter_lover", type = t, custom_level = true
	       })

   -- water_tools_crafter_expert
   ins(quests, {
	  'water_tools_crafter_expert', "Water Tools Crafter Expert", nil, {"bucket:bucket_empty"}, 1, {mod..":extractor"}, {"water_tools_crafter_pro", "mese_digger_pro", "diamond_digger_pro"}, type = t, custom_level = true
	       })

   -- water_tools_crafter_master
   ins(quests, {
	  'water_tools_crafter_master', "Water Tools Crafter Master", nil, {mod..":extractor"}, 1, {mod..":injector"}, "water_tools_crafter_expert", type = t, custom_level = true
	       })

   sys4_quests.registerQuests()

end
