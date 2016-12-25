--[[ Sys4 Quests
-- By Sys4

-- This mod provide an api that could be used by other mods for easy creation of quests.
--]]

-- intllib init
local S
if minetest.get_modpath("intllib") then
	S = intllib.Getter()
else
	S = function(s) return s end
end

-- Quests mod cutom changes
local modpath = minetest.get_modpath(minetest.get_current_modname())
dofile(modpath.."/quests_patch.lua")

-- init sys4_quests data structure
sys4_quests = {}
sys4_quests.intllib = S
sys4_quests.questGroups = {}
sys4_quests.questGroups['global'] = {order = 1, questsIndex = {}}
sys4_quests.itemGroups = {-- Todo: remove
	"tree", "wood", "flower", "dye", "wool",
	"sand", "stone", "soil", "stick", "leaves"}
sys4_quests.level = 1

-- init classes
dofile(modpath.."/item_class.lua")
dofile(modpath.."/questTree_class.lua")
--dofile(modpath.."/sys4_quests_class.lua")

-- New Waste Node
minetest.register_node(
	"sys4_quests:waste",
	{
		description = S("Waste"),
		tiles = {"waste.png"},
		is_ground_content = false,
		groups = {crumbly=2, flammable=2},
	})

-- sys4_quests functions
dofile(modpath.."/functions.lua")

local function isGroupExist(groupName)
	for name, group in pairs(sys4_quests.questGroups) do
		if name == groupName then
			return true
		end
	end
	return false
end

local function checkGroupName(groupName)
	if groupName ~= nil and groupName ~= "" and groupName ~= "global" then
		return true
	else
		return false
	end
end

local function isNodesEquivalent(nodeTargets, nodeDug)
	for _, nodeTarget in pairs(nodeTargets) do
		local groupSplit = string.split(nodeTarget, ":")
		if groupSplit[1] == "group"
			and minetest.get_item_group(nodeDug, groupSplit[2]) >= 1
		or nodeTarget == nodeDug then	return true	end
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
		else
			str = S("No craft for this item").."\n"
		end
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
			tt = tt..S("Craft recipes").." :\n"
			tt = tt..getCraftRecipes(item).."\n\n"
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

local function getFirstQuestGroup()
	for name, group in pairs(sys4_quests.questGroups) do
		if group.order == 2 then
			return name
		end
	end
	return nil
end

local function isQuestActive(questName, playern)
	return quests.active_quests[playern] and quests.active_quests[playern]["sys4_quests:"..questName]
end

local function getGroupByQuestIndex(questIndex)
		for name, group in pairs(sys4_quests.questGroups) do
		for _, index in ipairs(group.questsIndex) do
			if index == questIndex and name ~= "global" then
				return name
			end
		end
	end

	return nil
end

local function getActiveQuestGroup(playern)
	for mod, quests in pairs(sys4_quests.registeredQuests) do
		for _, quest in ipairs(quests.quests) do
			if isQuestActive(quest[1], playern) then
				return getGroupByQuestIndex(quest.index)
			end
		end
	end
	return nil
end

local function isQuestSuccessfull(questName, playern)
	return quests.successfull_quests[playern]	and quests.successfull_quests[playern]["sys4_quests:"..questName]
end

local playerList = {}

minetest.register_on_newplayer(
	function(player)
		local playern = player:get_player_name()
		local firstQuestGroup = getFirstQuestGroup()
		if firstQuestGroup == nil then
			firstQuestGroup = 'global'
		end
		playerList[playern] = {
			name = playern,
			isNew = true,
			craftMode = true,
			bookMode = false,
			activeQuestGroup = firstQuestGroup
		}

		-- give initial stuff
		if minetest.get_modpath("give_initial_stuff")
			and give_initial_stuff
			and sys4_quests.stuff
		then
			give_initial_stuff.clear()
			local stuff = sys4_quests.stuff
			for i = 1, #stuff do
				give_initial_stuff.add(stuff[i])
			end
			give_initial_stuff.give(player)
		end
	end)

minetest.register_on_joinplayer(
	function(player)
		local playern = player:get_player_name()
		if not playerList[playern] or playerList[playern] == nil then
			local activeGroup = getActiveQuestGroup(playern)
			if activeGroup == nil then
				activeGroup = 'global'
			end
			playerList[playern] = {
				name = playern,
				isNew = false,
				craftMode = true,
				bookMode = false,
				activeQuestGroup = activeGroup
			}
		end

		if (playerList[playern].isNew) then
			for mod, registeredQuests in pairs(sys4_quests.registeredQuests) do
				for _, registeredQuest in ipairs(registeredQuests.quests) do
					if (registeredQuest[7] == nil or #registeredQuest[7] == 0)
						and (getGroupByQuestIndex(registeredQuest.index) == nil
							  or getGroupByQuestIndex(registeredQuest.index) == playerList[playern].activeQuestGroup)	then
							quests.start_quest(playern, "sys4_quests:"..registeredQuest[1])
					end
				end
			end
			
			playerList[playern].isNew = false
		end
	end)


--Called when a button is pressed in player's inventory form
--Newest functions are called first
--#If function returns true, remaining functions are not called
minetest.register_on_player_receive_fields(
	function(player, formname, fields)
		minetest.chat_send_player(player:get_player_name(), "Event register_on_player_receive_fields triggered")
	end)

minetest.register_on_dignode(
	function(pos, oldnode, digger)
		if digger ~= nil then
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
		end
	end)

minetest.register_on_craft(
	function(itemstack, player, old_craft_grid, craft_inv)
		local playern = player:get_player_name()

		-- DEBUG
		minetest.chat_send_player(playern, "Event register_on_craft triggered")
		local wasteItem = "sys4_quests:waste"
		local itemstackName = itemstack:get_name()
		local itemstackCount = itemstack:get_count()

		for mod, registeredQuests in pairs(sys4_quests.registeredQuests) do
			for _, registeredQuest in ipairs(registeredQuests.quests) do
				local questType = registeredQuest.type
				local questName = registeredQuest[1]
				local items = registeredQuest[6]

--				for __, item in ipairs(items) do	
				if (item == itemstackName or isNodesEquivalent(items, itemstackName))
						and quests.successfull_quests[playern] ~= nil
						and quests.successfull_quests[playern]["sys4_quests:"..questName ] ~= nil
					then
						wasteItem = nil
					end
--				end
			end
		end

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
	core.rotate_and_place(
		itemstack, placer, pointed_thing,
		core.setting_getbool("creative_mode"),
		{invert_wall = placer:get_player_control().sneak}
	)

	return itemstack
end

local nodes = {
	minetest.registered_nodes["default:tree"],
	minetest.registered_nodes["default:jungletree"],
	minetest.registered_nodes["default:acacia_tree"],
	minetest.registered_nodes["default:pine_tree"],
	minetest.registered_nodes["default:aspen_tree"]
}

for i=1, #nodes do
	nodes[i].on_place = register_on_place
end

-- Furnace inventory take event
local furnace = minetest.registered_nodes["default:furnace"]
local old_allow_metadata_inventory_take = furnace.allow_metadata_inventory_take
local function allow_metadata_inventory_take(pos, listname, index, stack, player)
	local stackCount = old_allow_metadata_inventory_take(pos, listname, index, stack, player)
	minetest.chat_send_player(player:get_player_name(), "Furnace Event")
	if player ~= nil and listname == "dst" then
		local playern = player:get_player_name()
		for mod, registeredQuests in pairs(sys4_quests.registeredQuests) do
			for _, registeredQuest in ipairs(registeredQuests.quests) do
				local questName = registeredQuest[1]
				
				if registeredQuest.type == "cook" and isNodesEquivalent(registeredQuest[4], stack:get_name()) then
					if quests.update_quest(playern, "sys4_quests:"..questName, stackCount) then
						minetest.after(1, quests.accept_quest, playern, "sys4_quests:"..questName)
						if playerList[playern].bookMode then
							giveBook(playern, questName)
						end
					end
				end
			end
		end
	end
	return stackCount
end	
furnace.allow_metadata_inventory_take = allow_metadata_inventory_take 

minetest.register_chatcommand(
	"lcraft",
	{
		params = "[on|off]",
		description = S("Enable or not locked crafts")..".",
		func = function(name, param)
			if param == "on" then
				playerList[name].craftMode = true
				minetest.chat_send_player(name, S("Locked crafts Enabled")..".")
			else
				playerList[name].craftMode = false
				minetest.chat_send_player(name, S("Locked crafts Disabled")..".")
			end
		end
	})

minetest.register_chatcommand(
	"bookmode",
	{
		params = "[on|off]",
		description = S("Enable or not books that describe unlocked craft recipes")..".",
		func = function(name, param)
			if param == "on" then
				playerList[name].bookMode = true
				minetest.chat_send_player(name, S("Book Mode Enabled")..".")
			else
				playerList[name].bookMode = false
				minetest.chat_send_player(name, S("Book Mode Disabled")..".")
			end
		end
	})

minetest.register_chatcommand(
	"lqg",
	{
		params = "["..S("group index").."]",
		description = S("Display groups of quests or display quests of a group if group index is given as argument")..".",
		func = function(name, param)
			if param ~= "" then
				local isGroupValid = false
				for groupName, group in pairs(sys4_quests.questGroups) do
					if ""..group.order == param then
						isGroupValid = true
						minetest.chat_send_player(name, S("Legend")..":")
						minetest.chat_send_player(name, " [*] <-- "..S("Successfull quest"))
						minetest.chat_send_player(name, " [>] <-- "..S("Active quest"))
						minetest.chat_send_player(name, " [ ] <-- "..S("Not reached quest"))
						minetest.chat_send_player(name, " ")
						minetest.chat_send_player(name, S("Quests of group").." \""..groupName.."\" : ")
						for mod, registeredQuests in pairs(sys4_quests.registeredQuests) do
							local modIntllib = registeredQuests.intllib
							for _, quest in ipairs(registeredQuests.quests) do
								local qIndex = quest.index
								for __, index in ipairs(group.questsIndex) do
									if index == qIndex then
										local questState = "[ ]"
										if isQuestActive(quest[1], name) then
											questState = "[>]"
										end
										if isQuestSuccessfull(quest[1], name) then
											questState = "[*]"
										end
										
										minetest.chat_send_player(name, questState.." "..modIntllib(quest[2]).." ["..quest[1].."]".." {mod: "..mod.."}")
									end
								end
							end
						end
					end
				end

				if not isGroupValid then
					minetest.chat_send_player(name, S("Sorry, but this group doesn't exist")..".")
				end
			else
				local groups = {}
				for groupName, group in pairs(sys4_quests.questGroups) do
					groups[group.order] = groupName
					if playerList[name].activeQuestGroup == groupName then
						groups[group.order] = groupName.." <-- "..S("Active Quests Group")
					end
				end
				
				for i = 1, #groups do
					minetest.chat_send_player(name, i.." - "..groups[i])
				end
			end
		end
	})

minetest.register_chatcommand(
	"lqm",
	{
		params = "["..S("mod name").."]",
		description = S("Display mods currently loaded and supported by quests system or display quests related to given mod as argument")..".",
		func = function(name, param)
			if param ~= "" then
				local isModValid = false
				for mod, registeredQuests in pairs(sys4_quests.registeredQuests) do
					if mod == param then
						isModValid = true
						minetest.chat_send_player(name, S("Legend")..":")
						minetest.chat_send_player(name, " [*] <-- "..S("Successfull quest"))
						minetest.chat_send_player(name, " [>] <-- "..S("Active quest"))
						minetest.chat_send_player(name, " [ ] <-- "..S("Not reached quest"))
						minetest.chat_send_player(name, " <U>{mod} <-- "..S("Quest from {mod} used by mod").." "..mod)
						minetest.chat_send_player(name, " ")
						minetest.chat_send_player(name, S("Quests of mod").." \""..mod.."\" : ")
						local modIntllib = registeredQuests.intllib
						for _, quest in ipairs(registeredQuests.quests) do
							local questState = "[ ]"
							if isQuestActive(quest[1], name) then
								questState = "[>]"
							end
							if isQuestSuccessfull(quest[1], name) then
								questState = "[*]"
							end

							minetest.chat_send_player(name, questState.." "..modIntllib(quest[2]).." ["..quest[1].."]")
						end
					end
				end

				if not isModValid then
					minetest.chat_send_player(name, S("Sorry, but this mod isn't supported")..".")
				else
					-- Display quests from other mods wich use this given mod
					for mod, registeredQuests in pairs(sys4_quests.registeredQuests) do
						if mod ~= param then
							local modIntllib = registeredQuests.intllib
							for _, quest in ipairs(registeredQuests.quests) do
								local tNodes = quest[4] -- target Nodes
								local uItems = quest[6] -- Unlockable items

								local isQuestUpdated = false
								
								for i = 1, #tNodes do
									if string.split(tNodes[i], ":")[1] == param then
										isQuestUpdated = true
										break;
									end
								end

								if not isQuestUpdated then
									for i = 1, #uItems do
										if string.split(uItems[i], ":")[1] == param then
											isQuestUpdated = true
											break;
										end
									end
								end

								if isQuestUpdated then
									local questState = "[ ]"
									if isQuestActive(quest[1], name) then
										questState = "[>]"
									end
									if isQuestSuccessfull(quest[1], name) then
										questState = "[*]"
									end

									minetest.chat_send_player(name, "<U>{"..mod.."}"..questState.." "..modIntllib(quest[2]).." ["..quest[1].."]")
								end
							end
						end
					end
				end
				
			else
				for mod, registeredQuests in pairs(sys4_quests.registeredQuests) do
					minetest.chat_send_player(name, mod)
				end
			end
		end
})

minetest.register_chatcommand(
	"itemqq",
	{
		params = "<"..S("item")..">",
		description = S("Display the quest to finish which will unlock this item")..".",
		func = function(name, param)
			local isItemFound = false
			for mod, registeredQuests in pairs(sys4_quests.registeredQuests) do
				local modIntllib = registeredQuests.intllib
				for _, quest in ipairs(registeredQuests.quests) do
					for __, uItem in ipairs(quest[6]) do
						if uItem == param then
							isItemFound = true
							minetest.chat_send_player(name, S("Quest to finish for unlock").." \""..modIntllib(uItem).."\" :")

							local groupName = getGroupByQuestIndex(quest.index)
							if groupName == nil then
								groupName = "global"
							end

							local questState = ""
							if isQuestActive(quest[1], name) then
								questState = "<-- "..S("Active")
							end
							if isQuestSuccessfull(quest[1], name) then
								questState = "<-- "..S("Successfull")
							end
							
							minetest.chat_send_player(name, "  "..modIntllib(quest[2]).." ["..quest[1].."]".." {mod: "..mod.."} "..S("in group").." "..groupName.." "..questState)
							break
						end
					end
					if isItemFound then break end
				end
				if isItemFound then break end
			end
			if not isItemFound then
				minetest.chat_send_player(name, S("Sorry, but this item is not unlockable")..".")
			end
		end
	})

minetest.register_chatcommand(
	"fquest",
	{
		params = "<"..S("quest_name")..">",
		description = S("Force an active quest to be immediately finished")..".",
		func = function(name, param)
			local quest = getRegisteredQuest(param)
			local maxValue
			if quest ~= nil then
				if quest.custom_level then
					maxValue = quest[5]
				else
					maxValue = quest[5] * sys4_quests.level
				end
				
				if quests.update_quest(name, "sys4_quests:"..param, maxValue) then
					minetest.chat_send_player(name, S("The quest has been finished successfully")..".")
				else
					minetest.chat_send_player(name, S("The quest must be active to do that")..".")
				end
			else
				minetest.chat_send_player(name, S("Sorry, but this quest doesn't exist")..".")
			end
		end
	})

local function getModQuest(questName)
	for mod, registeredQuests in pairs(sys4_quests.registeredQuests) do
		for _, quest in ipairs(registeredQuests.quests) do
			if quest[1] == questName then
				return mod
			end
		end
	end
	return nil
end

minetest.register_chatcommand(
	"iquest",
	{
		params = "<"..S("quest_name")..">",
		description = S("Display info of the quest")..".",
		func = function(name, param)
			local quest = getRegisteredQuest(param)
			if quest ~= nil then
				local qMod = getModQuest(quest[1])
				local modIntllib = sys4_quests.registeredQuests[qMod].intllib
				local groupName = getGroupByQuestIndex(quest.index)
				if groupName == nil then
					groupName = "global"
				end
				minetest.chat_send_player(name, "> "..S("Index")..": "..quest.index)
				minetest.chat_send_player(name, "> "..S("Name")..": "..quest[1])
				minetest.chat_send_player(name, "> "..S("Title")..": "..modIntllib(quest[2]))
				local cDesc = quest[3]
				if cDesc == nil then cDesc = "" end
				minetest.chat_send_player(name, "> "..S("Custom Desc.")..": "..modIntllib(cDesc))
				minetest.chat_send_player(name, "> "..S("Group")..": "..groupName)
				minetest.chat_send_player(name, "> "..S("Mod")..": "..qMod)
				minetest.chat_send_player(name, "> "..S("Action Type")..": "..S(quest.type))
				minetest.chat_send_player(name, "> "..S("Target Nodes")..": "..dump(quest[4]))
				local maxLevel = quest[5] * sys4_quests.level
				if quest.custom_level then
					maxLevel = quest[5]
				end
				minetest.chat_send_player(name, "> "..S("Target count")..": "..maxLevel)
				minetest.chat_send_player(name, "> "..S("Custom Level")..": "..dump(quest.custom_level))
				minetest.chat_send_player(name, "> "..S("Parent quests")..": "..dump(quest[7]))
				
				local childQuests = {}
				for mod, registeredQuests in pairs(sys4_quests.registeredQuests) do
					for _, rQuest in ipairs(registeredQuests.quests) do
						if rQuest[7] and rQuest[7] ~= nil and type(rQuest[7]) == "string" then
							local alternQuests = string.split(rQuest[7], "|")
							for __, alternQuest in ipairs(alternQuests) do
								if alternQuest == quest[1] then
									table.insert(childQuests, rQuest[1])
								end
							end
						elseif type(rQuest[7]) == "table" then
							for __, quest_1 in ipairs(rQuest[7]) do
								local alternQuests = string.split(quest_1, "|")
								for ___, alternQuest in ipairs(alternQuests) do
									if alternQuest == quest[1] then
										table.insert(childQuests, rQuest[1])
									end
								end
							end
						end
					end
				end
				minetest.chat_send_player(name, "> "..S("Child Quests")..": "..dump(childQuests))
				
				minetest.chat_send_player(name, "> "..S("Items to unlock")..": "..dump(quest[6]))
				local questState = "Inactive"
				if isQuestActive(quest[1], name) then
					questState = "Active"
				end
				if isQuestSuccessfull(quest[1], name) then
					questState = "Successfull"
				end
				minetest.chat_send_player(name, "> "..S("State")..": "..S(questState))
			else
				minetest.chat_send_player(name, S("Sorry, but this quest doesn't exist")..".")
			end
		end
	})

minetest.register_chatcommand(
	"getcraft",
	{
		params = "<"..S("item")..">",
		description = S("Display craft recipes of this item")..".",
		func = function(name, param)
			minetest.chat_send_player(name, getCraftRecipes(param))
		end

	})

-- QuestTrees DEBUG
local function print_questTrees(str, questTrees)
	local str = str.."==> "
	local output = ""

	if questTrees then
		for i=1, #questTrees do
			output = output..str..questTrees[i]:get_quest():get_item():get_name().."\n"
			output = output..print_questTrees(str, questTrees[i]:get_quest():get_questTrees())
		end
	end

	return output
end

local function get_registeredQuestsTrees(parent)
	local questTrees = nil

	if not parent then
		for mod, registeredQuest in pairs(sys4_quests.registeredQuests) do
			for _, quest in ipairs(registeredQuest.quests) do
				if not quest[7] or #quest[7] == 0 then
					if not questTrees then questTrees = {} end
					local questTree = { name = quest[1],
											  childs = get_registeredQuestsTrees(quest[1])
					}
					table.insert(questTrees, questTree)
				end
			end
		end
	else
		for mod, registeredQuest in pairs(sys4_quests.registeredQuests) do
			for _, quest in ipairs(registeredQuest.quests) do
				if quest[7] and quest[7][1] == parent then
					if not questTrees then questTrees = {} end
					local questTree = { name = quest[1],
											  childs = get_registeredQuestsTrees(quest[1])
					}
					table.insert(questTrees, questTree)
				end
			end
		end
	end

	return questTrees
end
	
local function print_questTrees2(str, questTrees)
	local str = str.."==> "
	local output = ""

	if questTrees then
		for i, quest in ipairs(questTrees) do
			
			output = output..str..quest.name.."\n"
			output = output..print_questTrees2(str, quest.childs)
		end
	end

	return output
end

minetest.register_chatcommand(
	"questree",
	{
		params = nil,
		description = "display quests tree.",
		func = function(name, param)
			minetest.chat_send_player(name, print_questTrees("", sys4_quests.questTrees))
		end
})

minetest.register_chatcommand(
	"quest",
	{
		params = nil,
		description = "display quests tree.",
		func = function(name, param)
			local questTrees = get_registeredQuestsTrees(nil)
			minetest.chat_send_player(name, print_questTrees2("", questTrees))
		end
})

