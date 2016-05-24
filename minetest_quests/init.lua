-- Minetest Quests
-- By Sys4

-- This mod add quests based on default minetest game

local mod_sys4_quests = minetest.get_modpath("sys4_quests")
local mod_default = minetest.get_modpath("default")
local mod_farming = minetest.get_modpath("farming")
local mod_wool = minetest.get_modpath("wool")

if mod_sys4_quests then
   local current_modpath = minetest.get_modpath(minetest.get_current_modname())
   
   if mod_default then
      dofile(current_modpath.."/default.lua")
      
      if mod_farming then
	 dofile(current_modpath.."/farming.lua")
	 
	 if mod_wool then
	    dofile(current_modpath.."/wool.lua")
	 end
      end
   end
end

