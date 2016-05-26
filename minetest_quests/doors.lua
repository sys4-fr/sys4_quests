local S
if minetest.get_modpath("intllib") then
   S = intllib.Getter()
else
   S = function(s) return s end
end

-- Make local shortcuts of global functions --
local ins = table.insert
local up = sys4_quests.updateQuest

---------- Quests for doors mod ----------
local mod = "doors"

-- Get variable for register quests
local quests = sys4_quests.initQuests(mod, S)

t = "dig"

if minetest.get_modpath("vessels") then

   ins(quests, {
	  'glass_blower_lover', "Glass Blower Lover", nil, {"default:sand", "default:desert_sand"}, 1, {mod..":door_glass"}, "glass_blower", type = t
	       })
else

   ins(quests, {
	  'glass_blower', "Glass Blower", nil, {"default:sand", "default:desert_sand"}, 2, {mod..":door_glass"}, {"sand_digger", "furnace_crafter"}, type = t
	       })

end

ins(quests, {
       'steel_architect', "Steel Architect", nil, {"default:stone_with_iron"}, 1, {mod..":trapdoor_steel"}, "iron_digger_pro", type = t
	    })

t = "craft"

ins(quests, {
       'obsidian_blower', "Obsidian Blower", nil, {"default:obsidian_shard"}, 6, {mod..":door_obsidian_glass"}, "obsidian_digger", type = t
	    })

ins(quests, {
       'wood_architect_lover', "Wood Architect Lover", nil, {"default:stick"}, 2, {mod..":gate_acacia_wood_closed", mod..":gate_junglewood_closed", mod..":gate_pine_wood_closed", mod..":gate_aspen_wood_closed", mod..":gate_wood_closed"}, "wood_architect", type = t
	    })

sys4_quests.registerQuests()

up("wood_crafter_expert", nil, {mod..":door_wood", mod..":trapdoor"})

up("iron_digger_expert", nil, {mod..":door_steel"})
