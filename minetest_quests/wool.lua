local S
if minetest.get_modpath("intllib") then
   S = intllib.Getter()
else
   S = function(s) return s end
end

-- Make local shortcuts of global functions --
local ins = table.insert
local up = sys4_quests.updateQuest

---------- Quests for wool mod ----------
local mod = "wool"

-- Get variable for register quests
local quests = sys4_quests.initQuests(mod, S)

local t = "dig"

-- cotton_farmer
ins(quests, {
       'cotton_farmer', "Cotton Farmer", nil, {"farming:cotton"}, 4, {mod..":white"}, "farming_tools", type = t
	    })

-- register quests
sys4_quests.registerQuests()
