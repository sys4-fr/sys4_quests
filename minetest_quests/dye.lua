local S
if minetest.get_modpath("intllib") then
   S = intllib.Getter()
else
   S = function(s) return s end
end

-- Make local shortcuts of global functions --
local ins = table.insert
local up = sys4_quests.updateQuest

---------- Quests for dye mod ----------
local mod = "dye"

-- Get variable for register quests
local quests = sys4_quests.initQuests(mod, S)

local t = "dig"

if minetest.get_modpath("flowers") then
   
   -- flower_digger
   ins(quests, {
	  'flower_digger', "Flower Digger", "flowers", {"flowers:geranium", "flowers:rose", "flowers:tulip", "flowers:violet", "flowers:dandelion_white", "flowers:dandelion_yellow"}, 1, {mod..":blue", mod..":orange", mod..":red", mod..":violet", mod..":white", mod..":yellow"}, nil, type = t
	       })

   t = "craft"

   -- dye_crafter
   ins(quests, {
	  'dye_crafter', "Dye Crafter", "colored dyes", {mod..":blue", mod..":orange", mod..":red", mod..":violet", mod..":white", mod..":yellow"}, 1, {mod..":brown", mod..":cyan", mod..":dark_green", mod..":dark_grey", mod..":green", mod..":grey", mod..":magenta", mod..":pink"}, "flower_digger", type = t
	       })
end

sys4_quests.registerQuests()

-- update default quests
up('coal_digger', nil, {mod..":black"})
