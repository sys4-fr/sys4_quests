-- farming_plus Quests
-- By Sys4

-- This mod add quests based on farming_plus mod

if minetest.get_modpath("minetest_quests")
and minetest.get_modpath("farming_plus") then

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
	local mod = "farming_plus"

	----- Quests Groups -----
	local dark = "Dark Age"

	-- Get variable for register quests
	local quests = sys4_quests.initQuests(mod, S)

	-- If farming_redo is loaded
	local redo = false
	if farming.mod and farming.mod == "redo" then
		redo = true
	end

	-- Register Aliases
	minetest.register_alias(mod..":scarecrow", "farming:scarecrow")
	minetest.register_alias(mod..":scarecrow_light", "farming:scarecrow_light")
	minetest.register_alias(mod..":pumpkin_flour", "farming:pumpkin_flour")
	minetest.register_alias(mod..":big_pumpkin", "farming:big_pumpkin")
	minetest.register_alias(mod..":pumpkin_face_light", "farming:pumpkin_face_light")

	-- initial stuff
	sys4_quests.addInitialStuff("farming_plus:cocoa_sapling")

	local t = "dig"

	-- cocoa_digger
	if redo then
		up('cocoa_digger', {mod..":cocoa"}, {mod..":cocoa_bean"})
	else
		ins(
			quests,
			{
				'cocoa_digger',
				"Cocoa Digger",
				nil,
				{mod..":cocoa"},
				1,
				{mod..":cocoa_bean"},
				nil,
				type = t,
				custom_level = true,
				group = dark
			})
	end

	up('sticks_crafter', nil, {mod..":scarecrow"})

	up('furnace_crafter', nil, {mod..":pumpkin_flour"})

	up('coal_digger', nil, {mod..":pumpkin_face_light", mod..":scarecrow_light"})

	up('iron_digger_pro', nil, {mod..":big_pumpkin"})

	sys4_quests.registerQuests()

end
