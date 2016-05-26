-- Sys4 Quests
-- By Sys4

-- This mod provide an api that could be used by others mods for easy creation of quests.

local S
if minetest.get_modpath("intllib") then
   S = intllib.Getter()
else
   S = function(s) return s end
end

-- New Waste Node
minetest.register_node("sys4_quests:waste",
{
   description = S("Waste"),
   tiles = {"waste.png"},
   is_ground_content = false,
   groups = {crumbly=2, flammable=2},
})

sys4_quests = {}

local lastQuestIndex = 0
local level = 10

function sys4_quests.initQuests(mod, intllib)
   if not intllib or intllib == nil then
      intllib = S
   end
   
   if not sys4_quests.registeredQuests or sys4_quests.registeredQuests == nil then
      sys4_quests.registeredQuests = {}
   end

   sys4_quests.registeredQuests[mod] = {}
   sys4_quests.registeredQuests[mod].intllib = intllib
   sys4_quests.registeredQuests[mod].quests = {}
   return sys4_quests.registeredQuests[mod].quests
end

function sys4_quests.registerQuests()

   for mod, registeredQuests in pairs(sys4_quests.registeredQuests) do
      
      local modIntllib = registeredQuests.intllib

      -- init quests index
      for _, quest in pairs(registeredQuests.quests) do

	 -- Register quest
	 --print("Register quest : "..mod.." - "..quest[1])
	 --local auto = sys4_quests.hasDependencies(quest[1])
	 --print("Autoaccept next quest : "..dump(auto))

	 local maxlevel = quest[5] * level
	 if quest.custom_level then
	    maxlevel = quest[5]
	 end
	 
	 if quests.register_quest("sys4_quests:"..quest[1],
			       { title = modIntllib(quest[2]),
				 description = sys4_quests.formatDescription(quest, maxlevel, modIntllib),
				 max = maxlevel,
				 autoaccept = sys4_quests.hasDependencies(quest[1]),
				 callback = sys4_quests.nextQuest
			       })
	 then
	    lastQuestIndex = lastQuestIndex + 1
	    quest.index = lastQuestIndex
	 end
	 
      end
   end
end

function sys4_quests.intllib_by_item(item)
   print("In function intllib_by_item")
   print("Item : "..item)
   local mod = string.split(item, ":")[1]
   if mod == "stairs" then
      for questsMod, registeredQuests in pairs(sys4_quests.registeredQuests) do
	 for _, quest in ipairs(registeredQuests.quests) do
	    for __, titem in ipairs(quest[6]) do
	       if item == titem then
		  return registeredQuests.intllib
	       end
	    end
	 end
      end
   end
   return sys4_quests.registeredQuests[mod].intllib
end

function sys4_quests.formatDescription(quest, level, intllib)
   local questType = quest.type
   local targetCount = level
   local customDesc = quest[3]
   
   local str = S(questType).." "..targetCount.." "
   if customDesc ~= nil then
      str = str..intllib(customDesc).."."
   else
      local itemTarget = quest[4][1]
      local item_intllib = sys4_quests.intllib_by_item(itemTarget)
      str = str..item_intllib(itemTarget).."."
   end

   -- Print Unlocked Items
   str = str.."\n \n"..S("The end of the Quest Unlock this Items").." :\n"
   return str..sys4_quests.printUnlockedItems(quest[6])
end

function sys4_quests.printUnlockedItems(items)
   local str = ""
   for _, item in ipairs(items) do
      local itemMod = string.split(item, ":")[1]
      local intllibMod
      if itemMod == "stairs" then
	 for mod, registeredQuests in pairs(sys4_quests.registeredQuests) do
	    for _, quest in ipairs(registeredQuests.quests) do
	       for __, titem in ipairs(quest[6]) do
		  if item == titem then
		     intllibMod = registeredQuests.intllib
		  end
	       end
	    end
	 end
      else
	 intllibMod = sys4_quests.registeredQuests[itemMod].intllib
      end
      str = str.." - "..intllibMod(item).."\n"
   end

   return str
end

function sys4_quests.updateQuest(questName, targetNodes, items)
   for mod, registeredQuests in pairs(sys4_quests.registeredQuests) do
      for _, quest in ipairs(registeredQuests.quests) do
	 if questName == quest[1] then
	    if targetNodes ~= nil and type(targetNodes) == "table" then
	       for __,targetNode in ipairs(targetNodes) do
		  table.insert(quest[4], targetNode)
	       end
	    end

	    if items ~= nil and type(items) == "table" then
	       for __,item in ipairs(items) do
		  table.insert(quest[6], item)
	       end
	    
	       local questDescription = quests.registered_quests['sys4_quests:'..questName].description
	       questDescription = questDescription..sys4_quests.printUnlockedItems(items)
	       quests.registered_quests['sys4_quests:'..questName].description = questDescription
	    end
	 end
      end
   end
end

local function isQuestCompleted(quest, playern)
   local alternQuests = string.split(quest, "|")
   local isCompleted = false

   for _, alternQuest in ipairs(alternQuests) do
      if quests.successfull_quests[playern] ~= nil
	 and quests.successfull_quests[playern]["sys4_quests:"..alternQuest] ~= nil
      then
	 isCompleted = true
      end
   end

   return isCompleted
end

local function isParentQuestsCompleted(parentQuests_arg, quest, playern)
   local questCompleted = false
   local parentQuests = {}

   if parentQuests_arg and parentQuests_arg ~= nil then
      if type(parentQuests_arg) == "string" then
	 table.insert(parentQuests, parentQuests_arg)
      else
	 parentQuests = parentQuests_arg
      end
      
      for _, parentQuest in ipairs(parentQuests) do
	 local alternQuests = string.split(parentQuest, "|")
	 for _, alternQuest in ipairs(alternQuests) do
	    if alternQuest == quest then
	       questCompleted = true
	    end
	 end
      end
   end

   if questCompleted and #parentQuests > 1 then
      for _, parentQuest in ipairs(parentQuests) do
	 local alternQuests = string.split(parentQuest, "|")
	 for __, alternQuest in ipairs(alternQuests) do
	    if alternQuest ~= quest and not isQuestCompleted(parentQuest, playern) then
	       return false
	    end
	 end
      end
   end

   return questCompleted
end

function sys4_quests.hasDependencies(questName)
   for mod, registeredQuests in pairs(sys4_quests.registeredQuests) do
      for _, quest in ipairs(registeredQuests.quests) do
	 if quest[7] and quest[7] ~= nil and type(quest[7]) == "string" then
	    local alternQuests = string.split(quest[7], "|")
	    for __, alternQuest in ipairs(alternQuests) do
	       if alternQuest == questName then
		  return true
	       end
	    end
	 elseif type(quest[7]) == "table" then
	    for __, quest_1 in ipairs(quest[7]) do
	       local alternQuests = string.split(quest_1, "|")
	       for ___, alternQuest in ipairs(alternQuests) do
		  if alternQuest == questName then
		     return true
		  end
	       end
	    end
	 end
      end
   end
   return false
end

function sys4_quests.nextQuest(playername, questname)
   print("Next quest after : "..questname)
   if questname ~= "" then
      local quest = string.split(questname, ":")[2]
      if quest and quest ~= nil and quest ~= "" and sys4_quests.hasDependencies(quest) then
	 local nextquest = nil
	 for mod, registeredQuests in pairs(sys4_quests.registeredQuests) do
	    for _, registeredQuest in ipairs(registeredQuests.quests) do
	       local parentQuests = registeredQuest[7]

	       if isParentQuestsCompleted(parentQuests, quest, playername) then
		  print("Next quest selected : "..registeredQuest[1])
		  nextquest = registeredQuest.index
		  sys4_quests.setCurrentQuest(playername, nextquest)
		  minetest.after(1, function() quests.start_quest(playername, "sys4_quests:"..registeredQuest[1]) end)
	       end
	    end
	 end
      end
   end
end

function sys4_quests.setCurrentQuest(playerName, nextquest)
   if not sys4_quests.currentQuest then
      sys4_quests.currentQuest = {}
   end

   if not sys4_quests.currentQuest[playerName] then
      sys4_quests.currentQuest[playerName] = nil
   end

   sys4_quests.currentQuest[playerName] = nextquest
end

local function isNodesEquivalent(nodeTargets, nodeDug)
   for _, nodeTarget in pairs(nodeTargets) do
      if nodeTarget == nodeDug then
	 return true
      end
   end

   return false
end

local function getCraftRecipes(item)
   local str = ""
   if item ~= nil and item ~= "" then
      local craftRecipes = minetest.get_all_craft_recipes(item)

      if craftRecipes ~= nil then
	 local first = true
	 for i=1, #craftRecipes do
	    if craftRecipes[i].type == "normal" then
	       if not first then
		  str = str.."\n--- "..S("OR").." ---\n\n"
	       end
	       
	       first = false
	       local width = craftRecipes[i].width
	       local items = craftRecipes[i].items
	       local maxn = table.maxn(items)
	       local h = 0
	       local g
	       if width == 0 then
		  g = 1
		  while g*g < maxn do g = g + 1 end
		  width = maxn
	       else
		  h = math.ceil(maxn / width)
		  g = width < h and h or width
	       end
	       
	       for y=1, g do
		  str = str..y..": "
		  for x=1, width do
		     local itemIngredient = items[(y-1) * width + x]
		     if itemIngredient ~= nil then
			-- local intllib = sys4_quests.intllib_by_item(itemIngredient)
			-- str = str.."'"..intllib(itemIngredient).."' "
			str = str.."["..itemIngredient.."]  "
		     else
			str = str.."[                    ]  "
		     end
		     if x == width then
			str = str.."\n"
		     end
		  end
	       end
	    end
	 end
      end
   else
      str = S("No craft for this item").."\n"
   end
   return str   
end

local function writeBook(content, items, playern)
   local txt = ""
   
   if content and content ~= nil then
      txt = txt..content.."\n\n"
   end

   if items and items ~= nil then
      txt = txt..playern.." "..S("has unlocked these crafts").." :"

      local tt= "\n\n"
      
      for _, item in ipairs(items) do
	 
	 local intllib = sys4_quests.intllib_by_item(item)
	 
	 tt = tt..">>>> "..intllib(item).." <<<<\n\n"
	 tt = tt..S("Craft recipes :\n")
	 tt = tt..getCraftRecipes(item)
	 tt = tt.."\n----------OOOOOO----------\n\n"
      end
      txt = txt..tt.."\n"
   end

   return txt
end

local function getRegisteredQuest(questName)
   if questName and questName ~= nil then
      for mod, registeredQuests in pairs(sys4_quests.registeredQuests) do
	 for _, registeredQuest in ipairs(registeredQuests.quests) do
	    if questName == registeredQuest[1] then
	       return registeredQuest
	    end
	 end
      end
   end

   return nil
end

local function giveBook(playerName, quest)
   if playerName and playerName ~= nil and quest and quest ~= nil then
      local bookItem = ItemStack('default:book_written')
      local registeredQuest = getRegisteredQuest(quest)

      local bookData = {}
      bookData.title = "SYS4 QUESTS : "..registeredQuest[2]
      bookData.text = writeBook(nil, registeredQuest[6], playerName)
      bookData.owner = playerName

      bookItem:set_metadata(minetest.serialize(bookData))

      local receiverRef = core.get_player_by_name(playerName)
      if receiverRef == nil then return end
      receiverRef:get_inventory():add_item("main", bookItem)
   end
end

local playerList = {}

minetest.register_on_newplayer(
   function(player)
      local playern = player:get_player_name()
      playerList[playern] = {name = playern, isNew = true, craftMode = true, bookMode = false}
   end)

minetest.register_on_joinplayer(
   function(player)
      local playern = player:get_player_name()
      if not playerList[playern] or playerList[playern] == nil then
	 playerList[playern] = {name = playern, isNew = false, craftMode = true, bookMode = false}
      end

      if (playerList[playern].isNew) then
	 for mod, registeredQuests in pairs(sys4_quests.registeredQuests) do
	    for _, registeredQuest in ipairs(registeredQuests.quests) do
	       if registeredQuest[7] == nil then
		  quests.start_quest(playern, "sys4_quests:"..registeredQuest[1])
	       end
	    end
	 end
      end
   end)

minetest.register_on_dignode(
   function(pos, oldnode, digger)
      local playern = digger:get_player_name()

      for mod, registeredQuests in pairs(sys4_quests.registeredQuests) do
	 for _, registeredQuest in ipairs(registeredQuests.quests) do
	    local questName = registeredQuest[1]
	    local type = registeredQuest.type

	    if type == "dig" and isNodesEquivalent(registeredQuest[4], oldnode.name) then
	       if quests.update_quest(playern, "sys4_quests:"..questName, 1) then
		  minetest.after(1, quests.accept_quest, playern, "sys4_quests:"..questName)
		  if playerList[playern].bookMode then
		     giveBook(playern, questName)
		  end
	       end
	    end
	 end
      end
   end)

minetest.register_on_craft(
   function(itemstack, player, old_craft_grid, craft_inv)
      local playern = player:get_player_name()

      local wasteItem = "sys4_quests:waste"
      local itemstackName = itemstack:get_name()
      local itemstackCount = itemstack:get_count()

      for mod, registeredQuests in pairs(sys4_quests.registeredQuests) do
	 for _, registeredQuest in ipairs(registeredQuests.quests) do
	    local questType = registeredQuest.type
	    local questName = registeredQuest[1]
	    local items = registeredQuest[6]
	    for __, item in ipairs(items) do
	       
	       if item == itemstackName
		  and quests.successfull_quests[playern] ~= nil
		  and quests.successfull_quests[playern]["sys4_quests:"..questName ] ~= nil
	       then
		  wasteItem = nil
	       end
	    end
	 end
      end

      print("WasteItem state = "..dump(wasteItem))

      for mod, registeredQuests in pairs(sys4_quests.registeredQuests) do
	 for _, registeredQuest in ipairs(registeredQuests.quests) do
	    local questType = registeredQuest.type
	    local questName = registeredQuest[1]

	    if questType == "craft" and wasteItem == nil
	    and isNodesEquivalent(registeredQuest[4], itemstackName) then 
	       
	       if quests.update_quest(playern, "sys4_quests:"..questName, itemstackCount) then
		  minetest.after(1, quests.accept_quest, playern, "sys4_quests:"..questName)
		  if playerList[playern].bookMode then
		     giveBook(playern, questName)
		  end
	       end
	       --return nil
	    end
	 end
      end
      
      if wasteItem == nil then
	 return wasteItem
      elseif not playerList[playern].craftMode then
	 return nil
      else
	 return ItemStack(wasteItem)
      end
   end)

local function register_on_placenode(pos, node, placer)
   local playern = placer:get_player_name()

   for mod, registeredQuests in pairs(sys4_quests.registeredQuests) do
      for _, registeredQuest in ipairs(registeredQuests.quests) do
	 local questName = registeredQuest[1]
	 local type = registeredQuest.type
	 
	 if type == "place" and isNodesEquivalent(registeredQuest[4], node.name) then
	    if quests.update_quest(playern, "sys4_quests:"..questName, 1) then
	       minetest.after(1, quests.accept_quest, playern, "sys4_quests:"..questName)
	       if playerList[playern].bookMode then
		  giveBook(playern, questName)
	       end
	    end
	 end
      end
   end
end

minetest.register_on_placenode(register_on_placenode)

local function register_on_place(itemstack, placer, pointed_thing)
   local node = {}
   node.name = itemstack:get_name()
   register_on_placenode(pointed_thing, node, placer)

   -- Meme portion de code que dans la fonction core.rotate_node
   core.rotate_and_place(itemstack, placer, pointed_thing,
			 core.setting_getbool("creative_mode"),
			 {invert_wall = placer:get_player_control().sneak})

   return itemstack
end

local nodes = {
   minetest.registered_nodes["default:tree"],
   minetest.registered_nodes["default:jungletree"],
   minetest.registered_nodes["default:acacia_tree"],
   minetest.registered_nodes["default:pine_tree"],
}

for i=1, #nodes do
   nodes[i].on_place = register_on_place
end

minetest.register_chatcommand("craftmode",
{
   params = "on or off",
   description = "Enable or not locked crafts.",
   func = function(name, param)
      if param == "on" then
	 playerList[name].craftMode = true
	 minetest.chat_send_player(name, "Craft Mode Enabled.")
      else
	 playerList[name].craftMode = false
	 minetest.chat_send_player(name, "Craft Mode Disabled.")
      end
   end
})

minetest.register_chatcommand("bookmode",
{
   params = "on or off",
   description = "Enable or not books that describe unlocked craft recipes.",
   func = function(name, param)
      if param == "on" then
	 playerList[name].bookMode = true
	 minetest.chat_send_player(name, "Book Mode Enabled.")
      else
	 playerList[name].bookMode = false
	 minetest.chat_send_player(name, "Book Mode Disabled.")
      end
   end
})
