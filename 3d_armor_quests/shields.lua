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

----- Quests with type="dig" -----
local t = "dig"

up('cactus_protection_lover', nil, {mod..":shield_cactus"})

up('wood_protection_lover', nil, {mod..":shield_wood"})

up('steel_protection_lover', nil, {mod..":shield_steel"})

up('bronze_protection_lover', nil, {mod..":shield_bronze"})

up('gold_protection_lover', nil, {mod..":shield_gold"})

up('diamond_protection_lover', nil, {mod..":shield_diamond"})

-- enhance_cactus_protection
ins(quests, {
       'enhance_cactus_protection', "Enhance Cactus Protection", nil, {"default:stone_with_iron"}, 2, {mod..":shield_enhanced_cactus"}, {"cactus_protection_lover", "furnace_crafter"}, type = t
	    })

-- enhance_wood_protection
ins(quests, {
       'enhance_wood_protection', "Enhance Wood Protection", nil, {"default:stone_with_iron"}, 2, {mod..":shield_enhanced_wood"}, {"wood_protection_lover", "furnace_crafter"}, type = t
	    })

sys4_quests.registerQuests()
