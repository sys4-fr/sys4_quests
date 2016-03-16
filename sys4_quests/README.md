# Sys4_quests
# By Sys4

This mod provide an API for others modders who would like to make quests based on their mods.

## Minimal Exemple with Intllib support ##

-- Intllib Initialisation
local S
if minetest.get_modpath("intllib") then
   S = intllib.Getter()
else
   S = function(s) return s end
end


-- Get Variable for register your quests
local myQuests = sys4_quests.initQuests("myMod", S)

-- Setting your quests --

-- First quest : Dig 10 default:acacia_tree that will unlock craft of default:acacia_wood
table.insert(myQuests, {
		       'acacia_digger', -- Quest name
		       "Acacia Digger", -- Quest Title	
		       nil,    		-- Custom Description (not set here)
		       {'default:acacia_tree'}, -- List of target nodes for increment counter of this quest (1 target node here)
		       10,			-- Target node counter that would be reached for finish the quest
		       {'default:acacia_wood', 'default:stick', 'myMod:axe_acacia', 'myMod:sword_acacia'}, -- Unlocked items to craft when quest is finished
		       nil,		       -- Parent quest name if this quest depends on it (none here, because it's the first quest)
		       type = 'dig'	       -- Type of the quests (there is 3 existing types for now : 'dig', 'craft', 'place')

})

-- Second quest : Craft 10 acacia tools that will unlock craft of myMod:magical_wand
table.insert(myQuest, {
		      'acacia_crafter',
		      "Acacia Tools Crafter",
		      "Acacia Tools",		-- Custom Desc is set here (In game this will be displayed as this : "Craft 10 Acacia Tools")
		      {'myMod:axe_acacia', 'myMod:sword_acacia'}, -- Exemple of multiple target nodes
		      10,
		      {'myMod:magical_wand'},
		      'acacia_digger',		-- Parent quest is defined here, so that quest will be displayed only when it's parent quest will be reached.
		      type = 'craft'
})

-- You can update a previously made quest by another mod as this :
if minetest.get_modpath("minetest_quests") then
   
   sys4_quest.updateQuest('tools_crafter',		-- Name of a previously created quest
	{'myMod:axe_acacia', 'myMod:sword_acacia'},	-- Update Target Nodes/Items of this quests with your nodes/items (nil is accepted)
	{'myMod:pick_acacia'}				-- Update Unlocked Nodes/items of this quests with your nodes/items (nil is accepted)
   )

end

-- Register your quests
sys4_quests.registerQuests("myMod")  -- This instruction is not needeed if you have only updated quests of others mod than your. (Not the case here)

# With intllib support you can make this entries in your locale/<lang>.txt
# Exemple :

myMod:axe_acacia = Acacia Axe
myMod:sword_acacia = Acacia Sword
myMod:magical_wand = Magical Wand
Acacia Digger = <Your Translated String>
Acacia Tools Crafter = <Idem>
Acacia Tools = <Idem>

# Your depends.txt does contain for this exemple :
default
sys4_quests
minetest_quests?

## End of Exemple ##

For more quests example, take a look at my others quests mods as :
    - minetest_quests
    - 3d_armor_quests
    - ethereal_quests

