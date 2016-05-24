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
       'wheat_farmer', "Wheat Farmer", nil, {"farming:wheat_1", "farming:wheat_2", "farming:wheat_3", "farming:wheat_4", "farming:wheat_5", "farming:wheat_6", "farming:wheat_7", "farming:wheat_8"}, 4, {"farming:floor"}, "farming_tools", type = t
	    })

-- wheat_farmer_lover
ins(quests, {
       'wheat_farmer_lover', "Wheat Farmer Lover", nil, {"farming:wheat_1", "farming:wheat_2", "farming:wheat_3", "farming:wheat_4", "farming:wheat_5", "farming:wheat_6", "farming:wheat_7", "farming:wheat_8"}, 5, {"farming:straw"}, "wheat_farmer", type = t
	    })

t = "craft"

-- farming_tools
ins(quests, {
       'farming_tools', "Farming Tools", nil, {"default:wood", "default:junglewood", "default:acacia_wood", "default:pine_wood", "default:aspen_wood"}, 1, {"farming:hoe_wood"}, {"wood_crafter","sticks_crafter"}, type = t
	    })

-- straw_crafter
ins(quests, {
       'straw_crafter', "Straw Crafter", nil, {"farming:straw"}, 1, {"farming:wheat"}, "wheat_farmer_lover", type = t
	    })

-- straw_crafter_lover
ins(quests, {
       'straw_crafter_lover', "Straw Crafter Lover", nil, {"farming:straw"}, 2, {"stairs:slab_straw"}, "straw_crafter", type = t
	    })

-- straw_crafter_pro
ins(quests, {
       'straw_crafter_pro', "Straw Crafter Pro", nil, {"farming:straw"}, 3, {"stairs:stair_straw"}, "straw_crafter", type = t
	    })

-- register quests
sys4_quests.registerQuests()

-- update quests

up('stone_digger_lover', nil, {"farming:hoe_stone"})
