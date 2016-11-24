-- thirsty Quests
-- By Sys4

-- This mod add quests based on thirsty mod

if minetest.get_modpath("minetest_quests")
and minetest.get_modpath("thirsty") then

	-- If ethereal is detected then define the ethereal:bowl as a drinkable container
	-- and clear craft thus defined by thirsty mod.
	if minetest.get_modpath("ethereal") then
		thirsty.config.register_bowl = false
		thirsty.config.drink_from_container['ethereal:bowl'] = thirsty.config.drink_from_container['thirsty:wooden_bowl']

		minetest.override_item('ethereal:bowl', {
										  liquids_pointable = true,
										  on_use = thirsty.on_use(nil)
															 })
		if minetest.clear_craft then
			minetest.clear_craft({
											output = "thirsty:wooden_bowl",
											recipe = {
												{"group:wood", "", "group:wood"},
												{"", "group:wood", ""}
											}
										})
		else
			minetest.register_craft({
												output = "thirsty:wooden_bowl 0",
												recipe = {
													{"group:wood", "", "group:wood"},
													{"", "group:wood", ""}
												}
											})
			minetest.register_craft({
												output = "ethereal:bowl",
												recipe = {
													{"group:wood", "", "group:wood"},
													{"", "group:wood", ""}
												}
											})
		end
	end

	-- If food mod is detected then define food:bowl as a drinkable container
	if minetest.get_modpath("food") then
		thirsty.config.register_bowl = false
		thirsty.config.drink_from_container['food:bowl'] =	thirsty.config.drink_from_container['thirsty:wooden_bowl']

		minetest.override_item('food:bowl', {
										  liquids_pointable = true,
										  on_use = thirsty.on_use(nil)
														})
	end

	local S
	if minetest.get_modpath("intllib") then
		S = intllib.Getter()
	else
		S = function(s) return s end
	end

	local ins = table.insert
	local up = sys4_quests.updateQuest

	---------- Quests for thirsty mod ----------
	local mod = "thirsty"
	local quests = sys4_quests.initQuests(mod, S)

	----- Quests Groups -----
	local dark = "Dark Age"
	local wood = "Wood Age"
	local farm = "Farming Age"
	local stone = "Stone Age"
	local metal = "Metal Age"
	local middle = "Middle Age"

	-- update quests from default
	if not minetest.get_modpath("ethereal") then
		up('wood_crafter', nil, {mod..":wooden_bowl"})
	end

	up('mese_digger', nil, {mod..":water_fountain"})

	----- Quests with type="dig" -----
	local t = "dig"

	-- water_drinker
	ins(
		quests,
		{
			'water_drinker',
			"Water Drinker",
			nil,
			{"default:stone_with_iron"},
			1,
			{mod..":steel_canteen"},
			"iron_digger_pro",
			type = t,
			group = metal
		})

	t = "craft"

	-- water_drinker_lover
	ins(
		quests,
		{
			'water_drinker_lover',
			"Water Drinker Lover",
			nil,
			{"default:bronze_ingot"},
			1,
			{mod..":bronze_canteen"},
			{"water_drinker", "bronze_crafter_pro"},
			type = t
		})

	-- water_tools_crafter
	ins(
		quests,
		{
			'water_tools_crafter',
			"Water Tools Crafter",
			nil,
			{"bucket:bucket_empty"},
			1,
			{mod..":drinking_fountain"},
			"water_drinker",
			type = t,
			custom_level = true,
			group = metal
		})

	-- water_tools_crafter_lover
	ins(
		quests,
		{
			'water_tools_crafter_lover',
			"Water Tools Crafter Lover",
			nil,
			{"bucket:bucket_empty"},
			1,
			{mod..":water_extender"},
			"mese_digger",
			type = t,
			custom_level = true
		})

	-- water_tools_crafter_pro
	ins(
		quests,
		{
			'water_tools_crafter_pro',
			"Water Tools Crafter Pro",
			nil,
			{"bucket:bucket_empty"},
			1,
			{mod..":extractor"},
			{"water_tools_crafter_lover", "mese_digger_pro", "diamond_digger_pro"},
			type = t,
			custom_level = true
		})

	-- water_tools_crafter_expert
	ins(
		quests,
		{
			'water_tools_crafter_expert',
			"Water Tools Crafter Master",
			nil,
			{mod..":extractor"},
			1,
			{mod..":injector"},
			"water_tools_crafter_pro",
			type = t,
			custom_level = true
		})

	sys4_quests.registerQuests()

end
