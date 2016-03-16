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
local level = 1

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

function sys4_quests.registerQuests(mod)
   local modIntllib = sys4_quests.registeredQuests[mod].intllib

   -- init quests index
   for _, quest in pairs(sys4_quests.registeredQuests[mod].quests) do
      lastQuestIndex = lastQuestIndex + 1
      quest.index = lastQuestIndex
   end

   -- Register quests
   for _, quest in pairs(sys4_quests.registeredQuests[mod].quests) do
      
      -- Register quest
      quests.register_quest("sys4_quests:"..quest[1],
			    { title = modIntllib(quest[2]),
			      description = sys4_quests.formatDescription(quest, level, modIntllib),
			      max = quest[5] * level,
			      autoaccept = sys4_quests.hasDependencies(quest[1]),
			      callback = sys4_quests.nextQuest
			    })
      
   end
end

function sys4_quests.intllib_by_item(item)
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
   local targetCount = quest[5] * level
   local customDesc = quest[3]
   
   local str = S(questType).." "..targetCount.." "
   if customDesc ~= nil then
      str = str..intllib(customDesc)
   else
      local itemTarget = quest[4][1]
      local item_intllib = sys4_quests.intllib_by_item(itemTarget)
      str = str..item_intllib(itemTarget)
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
   for questsName, registeredQuests in pairs(sys4_quests.registeredQuests) do
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

function sys4_quests.hasDependencies(questName)
   for questsName, registeredQuests in pairs(sys4_quests.registeredQuests) do
      for _, quest in ipairs(registeredQuests.quests) do
	 if quest[7] and quest[7] ~= nil and quest[7] == questName then
	    return true
	 end
      end
   end

   return false
end

function sys4_quests.nextQuest(playername, questname)
   if questname ~= "" then
      local quest = string.split(questname, ":")[2]
      if quest and quest ~= nil and quest ~= "" and sys4_quests.hasDependencies(quest) then
	 local nextquest = nil
	 for questsName, registeredQuests in pairs(sys4_quests.registeredQuests) do
	    for _, registeredQuest in ipairs(registeredQuests.quests) do
	       local parentQuest = registeredQuest[7]

	       if parentQuest and parentQuest ~= nil and parentQuest == quest then
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

local isNewPlayer = false
minetest.register_on_newplayer(
   function(player)
      isNewPlayer = true
   end)

minetest.register_on_joinplayer(
   function(player)
      local playern = player:get_player_name()
      if (isNewPlayer) then
	 for questsName, registeredQuests in pairs(sys4_quests.registeredQuests) do
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

      for questsName, registeredQuests in pairs(sys4_quests.registeredQuests) do
	 for _, registeredQuest in ipairs(registeredQuests.quests) do
	    local questName = registeredQuest[1]
	    local type = registeredQuest.type

	    if type == "dig" and isNodesEquivalent(registeredQuest[4], oldnode.name) then
	       if quests.update_quest(playern, "sys4_quests:"..questName, 1) then
		  minetest.after(1, quests.accept_quest, playern, "sys4_quests:"..questName)
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

      for questsName, registeredQuests in pairs(sys4_quests.registeredQuests) do
	 for _, registeredQuest in ipairs(registeredQuests.quests) do
	    local questType = registeredQuest.type
	    local questName = registeredQuest[1]
	    local items = registeredQuest[6]

	    for __, item in ipairs(items) do
 
	       if item == itemstackName
		  and quests.successfull_quests[playern] ~= nil
	       and quests.successfull_quests[playern]["sys4_quests:"..questName ] ~= nil then
		  wasteItem = nil
	       end
	    end
	 end
      end

      for questsName, registeredQuests in pairs(sys4_quests.registeredQuests) do
	 for _, registeredQuest in ipairs(registeredQuests.quests) do
	    local questType = registeredQuest.type
	    local questName = registeredQuest[1]

	    if questType == "craft" and wasteItem == nil
	    and isNodesEquivalent(registeredQuest[4], itemstackName) then 
	       
	       if quests.update_quest(playern, "sys4_quests:"..questName, itemstackCount) then
		  minetest.after(1, quests.accept_quest, playern, "sys4_quests:"..questName)
	       end
	       return nil
	    end
	 end
      end
      
      if wasteItem == nil then
	 return wasteItem
      else
	 return ItemStack(wasteItem)
      end
   end)

local function register_on_placenode(pos, node, placer)
   local playern = placer:get_player_name()

   for questsName, registeredQuests in pairs(sys4_quests.registeredQuests) do
      for _, registeredQuest in ipairs(registeredQuests.quests) do
	 local questName = registeredQuest[1]
	 local type = registeredQuest.type
	 
	 if type == "place" and isNodesEquivalent(registeredQuest[4], node.name) then
	    if quests.update_quest(playern, "sys4_quests:"..questName, 1) then
	       minetest.after(1, quests.accept_quest, playern, "sys4_quests:"..questName)
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
