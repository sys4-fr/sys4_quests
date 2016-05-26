local S
if minetest.get_modpath("intllib") then
   S = intllib.Getter()
else
   S = function(s) return s end
end

-- Make local shortcuts of global functions --
local ins = table.insert
local up = sys4_quests.updateQuest

---------- Quests for vessels mod ----------
local mod = "vessels"

-- Get variable for register quests
local quests = sys4_quests.initQuests(mod, S)

t = "dig"

ins(quests, {
       'glass_blower', "Glass Blower", nil, {"default:sand", "default:desert_sand"}, 1, {mod..":glass_bottle"}, {"sand_digger", "furnace_crafter"}, type = t
	    })

if minetest.get_modpath("doors") or minetest.get_modpath("xpanes") then
   
   ins(quests, {
	  'glass_blower_pro', "Glass Blower Pro", nil, {"default:sand", "default:desert_sand"}, 1, {mod..":drinking_glass"}, "glass_blower_lover", type = t
	       })
else

   ins(quests, {
	  'glass_blower_lover', "Glass Blower Lover", nil, {"default:sand", "default:desert_sand"}, 2, {mod..":drinking_glass"}, "glass_blower", type = t
	       })
end

ins(quests, {
       'steel_blower', "Steel Blower", nil, {"default:stone_with_iron"}, 2, {mod..":steel_bottle"}, "iron_digger_pro", type = t
	    })

t = "craft"

ins(quests, {
       'vessels_crafter', "Vessels Crafter", "vessels items", {mod..":glass_bottle", mod..":steel_bottle", mod..":drinking_glass"}, 3, {mod..":shelf"}, {"glass_blower", "wood_crafter_expert"}, type = t
	    })

sys4_quests.registerQuests()
