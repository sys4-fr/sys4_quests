local S
if minetest.get_modpath("intllib") then
   S = intllib.Getter()
else
   S = function(s) return s end
end

-- Make local shortcuts of global functions --
local ins = table.insert
local up = sys4_quests.updateQuest

---------- Quests for farming mod ----------
local mod = "farming"

-- Get variable for register quests
local quests = sys4_quests.initQuests(mod, S)

local t = "dig"

-- wheat_farmer
ins(quests, {
       'wheat_farmer', "Wheat Farmer", nil, {mod..":wheat_1", mod..":wheat_2", mod..":wheat_3", mod..":wheat_4", mod..":wheat_5", mod..":wheat_6", mod..":wheat_7", mod..":wheat_8"}, 4, {mod..":floor"}, "farming_tools", type = t
	    })

-- wheat_farmer_lover
ins(quests, {
       'wheat_farmer_lover', "Wheat Farmer Lover", nil, {mod..":wheat_1", mod..":wheat_2", mod..":wheat_3", mod..":wheat_4", mod..":wheat_5", mod..":wheat_6", mod..":wheat_7", mod..":wheat_8"}, 5, {mod..":straw"}, "wheat_farmer", type = t
	    })

t = "craft"

-- farming_tools
ins(quests, {
       'farming_tools', "Farming Tools", nil, {"default:wood", "default:junglewood", "default:acacia_wood", "default:pine_wood", "default:aspen_wood"}, 1, {mod..":hoe_wood"}, {"wood_crafter","sticks_crafter"}, type = t
	    })

-- straw_crafter
ins(quests, {
       'straw_crafter', "Straw Crafter", nil, {mod..":straw"}, 1, {mod..":wheat"}, "wheat_farmer_lover", type = t
	    })

-- straw_crafter_lover
ins(quests, {
       'straw_crafter_lover', "Straw Crafter Lover", nil, {mod..":straw"}, 2, {"stairs:slab_straw"}, "straw_crafter", type = t
	    })

-- straw_crafter_pro
ins(quests, {
       'straw_crafter_pro', "Straw Crafter Pro", nil, {mod..":straw"}, 3, {"stairs:stair_straw"}, "straw_crafter_lover", type = t
	    })

-- register quests
sys4_quests.registerQuests()

-- update quests from default

up('stone_digger_lover', nil, {mod..":hoe_stone"})

up('iron_digger_lover', nil, {mod..":hoe_steel"})

up('bronze_crafter_lover', nil, {mod..":hoe_bronze"})

up('mese_digger_lover', nil, {mod..":hoe_mese"})

up('diamond_digger_lover', nil, {mod..":hoe_diamond"})
