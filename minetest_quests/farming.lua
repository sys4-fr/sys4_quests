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

----- Quests Groups -----
local dark = "Dark Age"
local farm = "Farming Age"
local stone = "Stone Age"
local metal = "Metal Age"

-- Get variable for register quests
local quests = sys4_quests.initQuests(mod, S)

-- If farming_redo
local redo = false
if farming.mod and farming.mod == "redo" then
   redo = true

   -- initial stuff
   sys4_quests.addInitialStuff("farming:cocoa_1")
end

-- update quests from default
up('book_crafter', nil, {mod..":hoe_wood"})

if redo then
   up('book_crafter', nil, {mod..":beanpole", mod..":trellis", mod..":cookie", mod..":donut"})

   -- donut_crafter
   ins(quests, {
	  'donut_crafter', "Donut Crafter", nil, {mod..":donut"}, 1, {mod..":donut_apple", mod..":donut_chocolate"}, "book_crafter", type = "craft", group = farm
	       })
end

up('stone_digger_lover', nil, {mod..":hoe_stone"})

up('iron_digger_lover', nil, {mod..":hoe_steel"})

up('bronze_crafter_lover', nil, {mod..":hoe_bronze"})

up('mese_digger_lover', nil, {mod..":hoe_mese"})

up('diamond_digger_lover', nil, {mod..":hoe_diamond"})

up('furnace_crafter', nil, {mod..":flour"})

if redo then
   up('furnace_crafter', nil, {mod..":muffin_blueberry", mod..":pumpkin_dough", mod..":rhubarb_pie"})

   if minetest.get_modpath("vessels") then
      up('furnace_crafter', nil, {mod..":drinking_cup", mod..":smoothie_raspberry"})

      -- corn_digger
      ins(quests, {
	     'corn_digger', "Corn Digger", nil, {mod..":corn_7", mod..":corn_8"}, 5, {mod..":bottle_ethanol"}, "furnace_crafter", type = "dig", group = stone
		  })
   end

   up('coal_digger', nil, {mod..":jackolantern"})
end

local t = "dig"

-- wheat_digger
ins(quests, {
       'wheat_digger', "Wheat Digger", nil, {mod..":wheat_1", mod..":wheat_2", mod..":wheat_3", mod..":wheat_4", mod..":wheat_5", mod..":wheat_6", mod..":wheat_7", mod..":wheat_8"}, 9, {mod..":straw", mod..":wheat"}, "book_crafter", type = t, group = farm
	    })

if redo then
   -- cocoa_digger
   ins(quests, {
	  'cocoa_digger', "Cocoa Digger", nil, {mod..":cocoa_1", mod..":cocoa_2", mod..":cocoa_3"}, 3, {mod..":chocolate_dark"}, nil, type = t, group = dark
	       })

   -- squash_digger
   ins(quests, {
	  'squash_digger', "Squash Digger", "pumpkins or melons", {mod..":melon_8", mod..":pumpkin_8", mod..":pumpkin"}, 1, {mod..":melon_slice", mod..":melon_8", mod..":pumpkin_slice", mod..":pumpkin"}, "book_crafter", type = t, group = farm
	       })
   
   -- unlock_gold_carrot
   ins(quests, {
	  'unlock_gold_carrot', "Unlock Gold Carrot", nil, {"default:stone_with_gold"}, 4, {mod..":carrot_gold"}, "stone_digger_pro", type = t, custom_level = true
	       })

   -- unlock_coffee
   ins(quests, {
	  'unlock_coffee', "Unlock Coffee", nil, {mod..":coffee_5"}, 1, {mod..":coffee_cup"}, "iron_digger_pro", type = t, group = metal
	       })
end

t = "place"

-- straw_builder
ins(quests, {
       'straw_builder', "Straw Builder", nil, {mod..":straw"}, 3, {"stairs:slab_straw", "stairs:stair_straw"}, "wheat_digger", type = t
	    })

-- register quests
sys4_quests.registerQuests()

