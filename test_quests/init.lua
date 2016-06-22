local S
if minetest.get_modpath("intllib") then
   S = intllib.Getter()
else
   S = function(s) return s end
end

-- Make local shortcuts of global functions --
local ins = table.insert
local up = sys4_quests.updateQuest

---------- Quests for default mod ----------
local mod = "default"

-- Get variable for register quests
local quests = sys4_quests.initQuests(mod, S)

----- Quests with type="dig" -----
local t = "dig"

----- Quests Groups -----
local g = "wood"
sys4_quests.addQuestGroup(g)

-- tree_digger
ins(quests, {
       'tree_digger', "Tree Digger", nil, {mod..":tree", mod..":jungletree", mod..":acacia_tree", mod..":pine_tree", mod..":aspen_tree"}, 1, {mod..":wood", mod..":junglewood", mod..":acacia_wood", mod..":pine_wood", mod..":aspen_wood"}, nil, type = t, group = g
	    })

-- papyrus_digger
ins(quests, {
       'papyrus_digger', "Papyrus Digger", nil, {mod..":papyrus"}, 3, {mod..":paper"}, nil, type = t
	    })

t = "craft"

-- paper_crafter
ins(quests, {
       'paper_crafter', "Paper Crafter", nil, {mod..":paper"}, 3, {mod..":book"}, "papyrus_digger", type = t
	    })

-- wood_crafter
ins(quests, {
       'wood_crafter', "Wood Crafter", nil, {mod..":wood", mod..":junglewood", mod..":acacia_wood", mod..":pine_wood", mod..":aspen_wood"}, 1, {mod..":stick"}, "tree_digger", type = t, group = g
	    })

g = "stick"
sys4_quests.addQuestGroup(g)

-- sticks_crafter
ins(quests, {
       'sticks_crafter', "Sticks Crafter", nil, {mod..":stick"}, 2, {mod..":shovel_wood"}, nil, type = t, group = g
	    })

sys4_quests.registerQuests()
