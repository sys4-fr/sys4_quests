-- carts Quests
-- By Sys4

-- This mod add quests based on carts mod

if minetest.get_modpath("minetest_quests") and
   (minetest.get_modpath("carts") or
    minetest.get_modpath("boost_cart")) then
   
   local S
   if minetest.get_modpath("intllib") then
      S = intllib.Getter()
   else
      S = function(s) return s end
   end
   
   local ins = table.insert
   local up = sys4_quests.updateQuest
   
   ---------- Quests for carts mod ----------
   local mod = "carts"
   local quests = sys4_quests.initQuests(mod, S)

   ----- Quests Groups -----
   local metal = "Metal Age"

   -- Update default quests
   up('mese_digger', nil, {mod..":powerrail"})

   ----- Quests with type="place" -----
   local t = "place"

   if minetest.get_modpath("moreores_quests") then
      ins(quests, {
	     'rail_installer', "Rail Installer", nil, {"default:rail", "moreores:copper_rail"}, 24, {mod..":cart", mod..":brakerail"}, "iron_digger_expert|unlock_copper_rail", type = t, custom_level = true, group = metal
		  })
   elseif minetest.get_modpath("boost_cart") then
	 -- unlock_copper_rail
	 ins(quests, {
		'unlock_copper_rail', "Unlock Copper Rail", nil, {"default:stone_with_copper"}, 6, {mod..":copperrail"}, nil, type = "dig", group = metal
		     })

	 ins(quests, {
		'rail_installer', "Rail Installer", nil, {"default:rail", mod..":copperrail"}, 24, {mod..":cart", mod..":brakerail"}, "iron_digger_expert|unlock_copper_rail", type = t, custom_level = true, group = metal
		     })
	 
   else

	 ins(quests, {
		'rail_installer', "Rail Installer", nil, {"default:rail"}, 24, {mod..":cart", mod..":brakerail"}, "iron_digger_expert", type = t, custom_level = true, group = metal
		     })
   end

   sys4_quests.registerQuests()
   
end
