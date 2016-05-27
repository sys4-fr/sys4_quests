-- 3d_armor Quests
-- By Sys4

-- This mod add quests based on 3d_armor and shields mod

if not minetest.get_modpath("sys4_quests")
and not minetest.get_modpath("3d_armor") then
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
       'cactus_digger', "Cactus Digger", nil, {'default:cactus'}, 4, {mod..':boots_cactus'}, nil, type = t, custom_level = true
	    })

-- cactus_protection
ins(quests, {
       'cactus_protection', "Cactus Protection", nil, {"default:cactus"}, 1, {mod..":helmet_cactus"}, "cactus_digger", type = t
	    })

-- cactus_protection_lover
ins(quests, {
       'cactus_protection_lover', "Cactus Protection Lover", nil, {"default:cactus"}, 1, {mod..":leggings_cactus"}, "cactus_protection", type = t
	    })

-- cactus_protection_pro
ins(quests, {
       'cactus_protection_pro', "Cactus Protection Pro", nil, {"default:cactus"}, 1, {mod..":chestplate_cactus"}, "cactus_protection_lover", type = t
	    })

-- steel_protection
ins(quests, {
       'steel_protection', "Steel Protection", nil, {"default:stone_with_iron"}, 1, {mod..":helmet_steel"}, "sword_crafter_lover", type = t
	    })

-- steel_protection_lover
ins(quests, {
       'steel_protection_lover', "Steel Protection Lover", nil, {"default:stone_with_iron"}, 1, {mod..":leggings_steel"}, "steel_protection", type = t
	    })

-- steel_protection_pro
ins(quests, {
       'steel_protection_pro', "Steel Protection Pro", nil, {"default:stone_with_iron"}, 1, {mod..":chestplate_steel"}, "steel_protection_lover", type = t
	    })

-- gold_protection
ins(quests, {
       'gold_protection', "Gold Protection", nil, {"default:stone_with_gold"}, 1, {mod..":helmet_gold"}, "sword_crafter_expert", type = t
	    })

-- gold_protection_lover
ins(quests, {
       'gold_protection_lover', "Gold Protection Lover", nil, {"default:stone_with_gold"}, 1, {mod..":leggings_gold"}, "gold_protection", type = t
	    })

-- gold_protection_pro
ins(quests, {
       'gold_protection_pro', "Gold Protection Pro", nil, {"default:stone_with_gold"}, 1, {mod..":chestplate_gold"}, "gold_protection_lover", type = t
	    })

-- diamond_protection
ins(quests, {
       'diamond_protection', "Diamond Protection", nil, {"default:stone_with_diamond"}, 1, {mod..":helmet_diamond"}, "sword_crafter_master", type = t
	    })

-- diamond_protection_lover
ins(quests, {
       'diamond_protection_lover', "Diamond Protection Lover", nil, {"default:stone_with_diamond"}, 1, {mod..":leggings_diamond"}, "diamond_protection", type = t
	    })

-- diamond_protection_pro
ins(quests, {
       'diamond_protection_pro', "Diamond Protection Pro", nil, {"default:stone_with_diamond"}, 1, {mod..":chestplate_diamond"}, "diamond_protection_lover", type = t
	    })

t = "craft"

-- sword_crafter
ins(quests, {
       'sword_crafter', "Sword Crafter", nil, {"default:sword_wood"}, 2, {mod..":boots_wood"}, "wood_crafter_lover", type = t, custom_level = true
	    })

-- wood_protection
ins(quests, {
       'wood_protection', "Wood Protection", nil, {"default:wood", "default:junglewood", "default:pine_wood", "default:acacia_wood", "default:aspen_wood"}, 1, {mod..":helmet_wood"}, "sword_crafter", type = t
	    })

-- wood_protection_lover
ins(quests, {
       'wood_protection_lover', "Wood Protection Lover", nil, {"default:wood", "default:junglewood", "default:pine_wood", "default:acacia_wood", "default:aspen_wood"}, 1, {mod..":leggings_wood"}, "wood_protection", type = t
	    })

-- wood_protection_pro
ins(quests, {
       'wood_protection_pro', "Wood Protection Pro", nil, {"default:wood", "default:junglewood", "default:pine_wood", "default:acacia_wood", "default:aspen_wood"}, 1, {mod..":chestplate_wood"}, "wood_protection_lover", type = t
	    })

-- sword_crafter_lover
ins(quests, {
       'sword_crafter_lover', "Sword Crafter Lover", nil, {"default:sword_steel"}, 2, {mod..":boots_steel"}, "iron_digger_lover", type = t, custom_level = true
	    })

-- sword_crafter_pro
ins(quests, {
       'sword_crafter_pro', "Sword Crafter Pro", nil, {"default:sword_bronze"}, 2, {mod..":boots_bronze"}, "bronze_crafter_lover", type = t, custom_level = true
	    })

-- bronze_protection
ins(quests, {
       'bronze_protection', "Bronze Protection", nil, {"default:bronze_ingot"}, 1, {mod..":helmet_bronze"}, "sword_crafter_pro", type = t
	    })

-- bronze_protection_lover
ins(quests, {
       'bronze_protection_lover', "Bronze Protection Lover", nil, {"default:bronze_ingot"}, 1, {mod..":leggings_bronze"}, "bronze_protection", type = t
	    })

-- bronze_protection_pro
ins(quests, {
       'bronze_protection_pro', "Bronze Protection Pro", nil, {"default:bronze_ingot"}, 1, {mod..":chestplate_bronze"}, "bronze_protection_lover", type = t
	    })

-- sword_crafter_expert
ins(quests, {
       'sword_crafter_expert', "Sword Crafter Expert", nil, {"default:sword_mese"}, 2, {mod..":boots_gold"}, "mese_digger_lover", type = t
	    })

-- sword_crafter_master
ins(quests, {
       'sword_crafter_master', "Sword Crafter Master", nil, {"default:sword_diamond"}, 2, {mod..":boots_diamond"}, "diamond_digger_lover", type = t
	    })

sys4_quests.registerQuests()
