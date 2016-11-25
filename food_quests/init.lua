-- food Quests
-- By Sys4

-- This mod add quests based on food mod

if minetest.get_modpath("minetest_quests")
and minetest.get_modpath("food") then

	local S
	if minetest.get_modpath("intllib") then
		S = intllib.Getter()
	else
		S = function(s) return s end
	end

	local ins = table.insert
	local up = sys4_quests.updateQuest

	local mod = "food"
	local quests = sys4_quests.initQuests(mod, S)

	-- is farming redo loaded ?
	local farming_redo = false
	if farming.mod and farming.mod == "redo" then
		farming_redo = true
	end

	-- is farming_plus loaded ?
	local farming_p = false
	if minetest.get_modpath("farming_plus") then
		farming_p = true
	end

	-- is ethereal loaded ?
	local ethereal_mod = false
	if minetest.get_modpath("ethereal") then
		ethereal_mod = true
	end

	-- is mobs_animal loaded ?
	local mobs_a = false
	if minetest.get_modpath("mobs_animal") then
		mobs_a = true
	end

	-- is food mod only loaded without ethereal, farming and farming_redo ?
	local food_only = true
	if ethereal_mod or farming_p or farming_redo then
		food_only = false
	end

	local stone = "Stone Age"
	local metal = "Metal Age"

	local t = "dig"

	-- cooker
	local ingredients = {"default:apple", "default:cactus", "nyancat:nyancat_rainbow"}
	local cooked_food = {mod..":apple_juice", mod..":cactus_juice", mod..":orange_juice", mod..":rainbow_juice"}

	if ethereal_mod then
		ins(ingredients, "ethereal:orange")
	end

	if ethereal_mod and not farming_redo and not farming_p then
		ins(cooked_food, mod..":potato")
		ins(cooked_food, mod..":carrot")
		ins(cooked_food, mod..":cocoa")
		if not mobs_a then
			ins(cooked_food, mod..":egg")
			ins(cooked_food, mod..":meat_raw")
		end
		ins(cooked_food, mod..":sugar")
		ins(cooked_food, mod..":tomato")
	end
	
	if farming_redo and not ethereal_mod and not farming_p then
		ins(cooked_food, mod..":orange")
	end
	
	if farming_p then
		ins(ingredients, "farming_plus:orange_item")
	end

	if food_only then
		ins(cooked_food, mod..":orange")
		ins(cooked_food, mod..":potato")
		ins(cooked_food, mod..":carrot")
		ins(cooked_food, mod..":cocoa")
		if not mobs_a then
			ins(cooked_food, mod..":egg")
			ins(cooked_food, mod..":meat_raw")
		end
		ins(cooked_food, mod..":sugar")
		ins(cooked_food, mod..":tomato")
	end

	ins(
		quests,
		{
			'cooker',
			"Become a cooker",
			"basic food ingredients (apples, cactus, oranges, ...)",
			ingredients,
			1,
			cooked_food,
			"furnace_crafter",
			type = t,
			group = stone
		})

	-- cooker_lover
	t = "craft"
	local ingredients2 = {}
	for _,i in ipairs(cooked_food) do
		ins(ingredients2, i)
	end

	ins(ingredients2, "farming:flour")

	if ethereal_mod then
		ins(ingredients2, "ethereal:banana_dough")
		ins(ingredients2, "ethereal:hearty_stew")
		ins(ingredients2, "ethereal:mushroom_soup")
		ins(ingredients2, "ethereal:sashimi")
	end

	if farming_redo then
		ins(ingredients2, "farming:chocolate_dark")
		ins(ingredients2, "farming:cookie")
		ins(ingredients2, "farming:donut")
		ins(ingredients2, "farming:donut_apple")
		ins(ingredients2, "farming:donut_chocolate")
		ins(ingredients2, "farming:muffin_blueberry")
		ins(ingredients2, "farming:pumpkin_dough")
		ins(ingredients2, "farming:rhubarb_pie")
		ins(ingredients2, "farming:smoothie_raspberry")
	end

	if farming_p then
		minetest.register_alias("farming_plus:pumpkin_flour", "farming:pumpkin_flour")
		ins(ingredients2, "farming_plus:pumpkin_flour")
	end

	cooked_food = {
		mod..":cakemix_plain",
		mod..":cakemix_carrot",
		mod..":cakemix_choco",
		mod..":chocolate_powder",
		mod..":pasta"
	}

	ins(
		quests,
		{
			'cooker_lover',
			"Cooker Lover",
			"juices, ingredients or already known cooked meals",
			ingredients2,
			1,
			cooked_food,
			"cooker",
			type = t,
			group = stone
		})

	-- cooker_pro
	local ingredients3 = {}
	for _,i in ipairs(cooked_food) do
		ins(ingredients3, i)
	end

	ins(ingredients3, mod..":butter")
	ins(ingredients3, mod..":cheese")
	ins(ingredients3, mod..":milk_chocolate")
	cooked_food = {mod..":pasta_bake_raw", mod..":soup_chicken_raw", mod..":soup_tomato_raw"}

	ins(
		quests,
		{
			'cooker_pro',
			"Cooker Pro",
			"elaborate ingredients or cooked meals",
			ingredients3,
			1,
			cooked_food,
			"iron_digger_pro",
			type = t,
			group = metal
		})

	-- Update quests --

	up('clay_digger', nil, {mod..":bowl"})

	if not mobs_a then
		up('iron_digger_pro', nil, {mod..":milk"})
	end

	up('iron_digger_pro', nil, {mod..":butter", mod..":cheese", mod..":milk_chocolate"})

	sys4_quests.registerQuests()

	-- Optional food_sweet quests --
	if minetest.get_modpath("food_sweet") then
		mod = "food_sweet"
		quests = sys4_quests.initQuests(mod, S)

		up('cooker', nil, {mod..":walnut"})
		up('iron_digger_pro', nil, {mod..":lemon"})

		if food_only then
			up('cooker', nil, {mod..":blueberry", mod..":rhubarb"})
			up('iron_digger_pro', nil, {mod..":strawberry"})
		elseif not farming_redo then
			up('cooker', nil, {mod..":blueberry"})
		elseif not ethereal_mod and not farming_p then
			up('iron_digger_pro', nil, {mod..":strawberry"})
		elseif not farming_redo and not farming_p then
			up('cooker', nil, {mod..":blueberry", mod..":rhubarb"})
		end

		local food_t = {
			mod..":cakemix_walnut_coffee",
			mod..":crumble_rhubarb_raw",
			mod..":cupcake_mix",
			mod..":muffin_blueberry_mix"
		}

		up('cooker_lover', {mod..":walnut"}, food_t)

		local ingredients_t = {}
		for _,i in ipairs(food_t) do
			ins(ingredients_t, i)
		end
		ins(ingredients_t, mod..":lemon")

		up('cooker_pro', ingredients_t, {
				mod..":cake_wedding",
				mod..":cakemix_cheese",
				mod..":cakemix_cheese_blueberry",
				mod..":cakemix_triple_choco",
				mod..":cupcake_choco_mix",
				mod..":cupcake_fairy",
				mod..":cupcake_lemon", mod..":muffin_choco_mix"}
		)

	end
end
