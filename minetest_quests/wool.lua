local S
if minetest.get_modpath("intllib") then
   S = intllib.Getter()
else
   S = function(s) return s end
end

-- Make local shortcuts of global functions --
local ins = table.insert
local up = sys4_quests.updateQuest

---------- Quests for wool mod ----------
local mod = "wool"

-- Get variable for register quests
local quests = sys4_quests.initQuests(mod, S)

local t = "dig"

if minetest.get_modpath("dye") then

   -- cotton_farmer (with dye mod)
   ins(quests, {
	  'cotton_farmer', "Cotton Farmer", nil, {"farming:cotton_1","farming:cotton_2","farming:cotton_3","farming:cotton_4","farming:cotton_5","farming:cotton_6","farming:cotton_7","farming:cotton_8"}, 4, {mod..":white", mod..":black"}, "farming_tools", type = t
	       })

   t = "craft"

   -- wool_crafter
   ins(quests, {
	  'wool_crafter', "Wool Crafter", "black or white wools", {mod..":white", mod..":black"}, 1, {mod..":blue", mod..":orange", mod..":red", mod..":violet", mod..":yellow"}, {"cotton_farmer", "flower_digger"}, type = t
	       })

   -- wool_crafter_lover
   ins(quests, {
	  'wool_crafter_lover', "Wool Crafter Lover", "colored wools", {mod..":white", mod..":black", mod..":blue", mod..":orange", mod..":red", mod..":violet", mod..":yellow"}, 1, {mod..":brown", mod..":cyan", mod..":dark_green", mod..":dark_grey", mod..":green", mod..":grey", mod..":magenta", mod..":pink"}, {"wool_crafter", "dye_crafter"}, type = t
	       })
else
   
   t= "dig"

   -- cotton_farmer (without dye mod)
   ins(quests, {
       'cotton_farmer', "Cotton Farmer", nil, {"farming:cotton_1","farming:cotton_2","farming:cotton_3","farming:cotton_4","farming:cotton_5","farming:cotton_6","farming:cotton_7","farming:cotton_8"}, 4, {mod..":white"}, "farming_tools", type = t
	    })
end

-- register quests
sys4_quests.registerQuests()
