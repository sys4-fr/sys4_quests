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

up('iron_digger_pro', nil, {mod..":armor_stand", mod..":locked_armor_stand"})


