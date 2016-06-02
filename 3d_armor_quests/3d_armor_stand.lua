-- 3d_armor_stand Quests
-- By Sys4

-- This mod add quests based on 3d_armor_stand mod

local S
if minetest.get_modpath("intllib") then
   S = intllib.Getter()
else
   S = function(s) return s end
end

local ins = table.insert
local up = sys4_quests.updateQuest

---------- Quests for 3d_armor_stand mod ----------
local mod = "3d_armor_stand"
local quests = sys4_quests.initQuests(mod, S)

----- Quests with type="dig" -----
local t = "craft"

-- armor_stand
ins(quests, {
       'armor_stand', "Unlock Armor Stand", nil, {"default:fence_wood", "default:fence_junglewood", "default:fence_acacia_wood", "default:fence_pine_wood", "default:fence_aspen_wood"}, 2, {mod..":armor_stand"}, {"wood_architect", "iron_digger_pro"}, type = t
	    })

-- armor_stand_lover
ins(quests, {
       'armor_stand_lover', "Armor Stand Crafter", nil, {mod..":armor_stand"}, 1, {mod..":locked_armor_stand"}, "armor_stand", type = t, custom_level = true
	    })

sys4_quests.registerQuests()
