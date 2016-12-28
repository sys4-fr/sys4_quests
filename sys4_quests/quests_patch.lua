-- Rewrite the following function of the quest mod for fix crash when playing with hidden hud.
quests.accept_quest = function (playername, questname)
	if (quests.active_quests[playername][questname]
			 and not quests.active_quests[playername][questname].finished)
	then
		if (quests.successfull_quests[playername] == nil) then
			quests.successfull_quests[playername] = {}
		end
		if (quests.successfull_quests[playername][questname] ~= nil) then
			quests.successfull_quests[playername][questname].count = quests.successfull_quests[playername][questname].count + 1
		else
			quests.successfull_quests[playername][questname] = {count = 1}
		end
		quests.active_quests[playername][questname].finished = true
		if quests.hud[playername].list ~= nil then
			for _,quest in ipairs(quests.hud[playername].list) do
				if (quest.name == questname) then
					local player = minetest.get_player_by_name(playername)
					player:hud_change(quest.id, "number", quests.colors.success)
				end
			end
		end
		quests.show_message("success", playername, "Quest completed:" .. " " .. quests.registered_quests[questname].title)
		minetest.after(3, function(playername, questname)
								quests.active_quests[playername][questname] = nil
								quests.update_hud(playername)
								end, playername, questname)
		return true -- the quest is finished, the mod can give a reward
	end
	return false -- the quest hasn't finished
end

-- Replace quests.show_message function for customize central_message sounds if the mod is present
quests.show_message = function (t, playername, text)
	if quests.hud[playername].central_message_enabled
		and minetest.get_modpath("central_message") and cmsg
	then
		local player = minetest.get_player_by_name(playername)
		if player then
			cmsg.push_message_player(player, text, quests.colors[t])
			minetest.sound_play("sys4_quests_" .. t, {to_player = playername})
		end
	end
end

