-- 3d_armor quests
-- By Sys4

-- This mod add quests based on 3d_armor modpack

local mod_sys4_quests = minetest.get_modpath("sys4_quests")
local mod_3d_armor = minetest.get_modpath("3d_armor")
local mod_shields = minetest.get_modpath("shields")
local mod_3d_armor_stand = minetest.get_modpath("3d_armor_stand")

if mod_sys4_quests and mod_3d_armor then
   local current_modpath = minetest.get_modpath(minetest.get_current_modname())

   dofile(current_modpath.."/3d_armor.lua")

   if mod_shields then
      dofile(current_modpath.."/shields.lua")
   end

   if mod_3d_armor_stand then
      dofile(current_modpath.."/3d_armor_stand.lua")
   end
end
