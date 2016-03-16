-- 3d_armor Quests
-- By Sys4

-- This mod add quests based on 3d_armor and shields mod

if not minetest.get_modpath("sys4_quests")
or not minetest.get_modpath("3d_armor") then
   return
end

local S
if minetest.get_modpath("intllib") then
   S = intllib.Getter()
else
   S = function(s) return s end
end

local ins = table.insert
local up = sys4_quests.updateQuest

---------- Quests for 3d_armor mod ----------
local mod = "3d_armor"
local quests = sys4_quests.initQuests(mod, S)

----- Quests with type="dig" -----
local t = "dig"

-- cactus_digger
ins(quests, {
       'cactus_digger', "Cactus Digger", nil, {'default:cactus'}, 50, {'3d_armor:boots_cactus', '3d_armor:chestplate_cactus', '3d_armor:helmet_cactus', '3d_armor:leggings_cactus'}, 'wood_crafter', type = t
	    })

-- gold_digger
up('gold_digger', nil, {'3d_armor:boots_gold', '3d_armor:chestplate_gold', '3d_armor:helmet_gold', '3d_armor:leggings_gold'})

-- diamond_digger
up('diamond_digger', nil, {'3d_armor:boots_diamond', '3d_armor:chestplate_diamond', '3d_armor:helmet_diamond', '3d_armor:leggings_diamond'})

----- Quests with type="craft" -----
t = "craft"

-- sword_crafter
ins(quests, {
       'sword_crafter', "Sword Crafter", nil, {'default:sword_wood'}, 2, {'3d_armor:boots_wood', '3d_armor:chestplate_wood', '3d_armor:helmet_wood', '3d_armor:leggings_wood'}, 'wood_crafter', type = t
	    })

-- sword_crafter_lover
ins(quests, {
       'sword_crafter_lover', "Sword Crafter Lover", nil, {'default:sword_steel'}, 2, {'3d_armor:boots_steel', '3d_armor:chestplate_steel', '3d_armor:helmet_steel', '3d_armor:leggings_steel'}, 'iron_digger', type = t
	    })

-- sword_crafter_pro
ins(quests, {
       'sword_crafter_pro', "Sword Crafter Pro", nil, {'default:sword_bronze'}, 2, {'3d_armor:boots_bronze', '3d_armor:chestplate_bronze', '3d_armor:helmet_bronze', '3d_armor:leggings_bronze'}, 'bronze_crafter', type = t
	    })

-- ethereal_sword_crafter
if minetest.get_modpath("ethereal") then

   ins(quests, {
	  'ethereal_sword_crafter', "Ethereal Sword Crafter",  nil, {'ethereal:sword_crystal'}, 2, {'3d_armor:boots_crystal', '3d_armor:chestplate_crystal', '3d_armor:helmet_crystal', '3d_armor:leggings_crystal'}, 'crystal_crafter', type = t
	       })
end

-- Register quests
sys4_quests.registerQuests(mod)

mod = 'shields'
if minetest.get_modpath(mod) then
   sys4_quests.initQuests(mod, S)

   t = 'dig'

   -- cactus_digger UP
   up('cactus_digger', nil, {'shields:shield_cactus'})

   -- gold_digger UP
   up('gold_digger', nil, {'shields:shield_gold'})

   -- diamond_digger UP
   up('diamond_digger', nil, {'shields:shield_diamond'})

   t = "place"

   -- furnace_builder UP
   up('furnace_builder', nil, {'shields:shield_enhanced_wood', 'shields:shield_enhanced_cactus'})

   t = "craft"

   -- sword_crafter UP
   up('sword_crafter', nil, {'shields:shield_wood'})

   -- sword_crafter_lover UP
   up('sword_crafter_lover', nil, {'shields:shield_steel'})

   -- sword_crafter_pro UP
   up('sword_crafter_pro', nil, {'shields:shield_bronze'})

   if minetest.get_modpath("ethereal") then
      up('ethereal_sword_crafter', nil, {'shields:shield_crystal'})
   end
end
