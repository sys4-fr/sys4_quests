-- shields Quests
-- By Sys4

-- This mod add quests based on shields and shields mod

local S
if minetest.get_modpath("intllib") then
   S = intllib.Getter()
else
   S = function(s) return s end
end

local ins = table.insert
local up = sys4_quests.updateQuest

---------- Quests for shields mod ----------
local mod = "shields"
local quests = sys4_quests.initQuests(mod, S)

up('cactus_protection_lover', nil, {mod..":shield_cactus"})

up('wood_protection_lover', nil, {mod..":shield_wood"})

up('steel_protection_lover', nil, {mod..":shield_steel"})

up('bronze_protection_lover', nil, {mod..":shield_bronze"})

up('gold_protection_pro', nil, {mod..":shield_gold"})

up('diamond_protection_lover', nil, {mod..":shield_diamond"})

if minetest.get_modpath("moreores_quests") then
   up('mithril_protection_lover', nil, {mod..":shield_mithril"})
end

if minetest.get_modpath("ethereal_quests") then

   up('crystal_protection_lover', nil, {mod..":shield_crystal"})
end

-- enhance cactus and wood protection
up('iron_digger_lover', nil, {mod..":shield_enhanced_wood", mod..":shield_enhanced_cactus"})
