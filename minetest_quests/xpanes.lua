local S
if minetest.get_modpath("intllib") then
   S = intllib.Getter()
else
   S = function(s) return s end
end

-- Make local shortcuts of global functions --
local ins = table.insert
local up = sys4_quests.updateQuest

---------- Quests for xpanes mod ----------
local mod = "xpanes"

-- Get variable for register quests
local quests = sys4_quests.initQuests(mod, S)

t = "dig"

if minetest.get_modpath("doors") and minetest.get_modpath("vessels") then
   
   up('glass_blower_lover', nil, {mod..":pane"})
   
elseif minetest.get_modpath("vessels") then

   ins(quests, {
	  'glass_blower_lover', "Glass Blower Lover", nil, {"default:sand", "default:desert_sand"}, 1, {mod..":pane"}, "glass_blower", type = t
	       })

   sys4_quests.registerQuests()
   
elseif minetest.get_modpath("doors") then
   up('glass_blower', nil, {mod..":pane"})
   
else

   ins(quests, {
	  'glass_blower', "Glass Blower", nil, {"default:sand", "default:desert_sand"}, 6, {mod..":pane"}, {"sand_digger", "furnace_crafter"}, type = t
	       })
   
   sys4_quests.registerQuests()
end

up('iron_digger_expert', nil, {mod..":bar"})
