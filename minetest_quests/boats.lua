local S
if minetest.get_modpath("intllib") then
   S = intllib.Getter()
else
   S = function(s) return s end
end

-- Make local shortcuts of global functions --
local ins = table.insert
local up = sys4_quests.updateQuest

---------- Quests for boats mod ----------
local mod = "boats"

-- Get variable for register quests
local quests = sys4_quests.initQuests(mod, S)

t = "craft"

ins(quests, {
       'wood_crafter_semi_expert', "Wood Crafter semi-Expert", nil, {"default:wood", "defaul:junglewood", "default:pine_wood", "default:acacia_wood", "default:aspen_wood"}, 2, {mod..":boat"}, "wood_crafter_pro", type = t
    })

sys4_quests.registerQuests()
