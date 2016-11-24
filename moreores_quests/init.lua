-- moreores Quests
-- By Sys4

-- This mod add quests based on moreores mod

if minetest.get_modpath("minetest_quests")
and minetest.get_modpath("moreores") then

	local S
	if minetest.get_modpath("intllib") then
		S = intllib.Getter()
	else
		S = function(s) return s end
	end

	local ins = table.insert
	local up = sys4_quests.updateQuest

	---------- Quests for moreores mod ----------
	local mod = "moreores"
	local quests = sys4_quests.initQuests(mod, S)

	----- Quests Groups -----
	local metal = "Metal Age"
	local middle = "Middle Age"

	----- Quests with type="dig" -----
	local t = "dig"

	-- tin_digger
	ins(
		quests,
		{
			'tin_digger',
			"Tin Digger",
			nil,
			{mod..":mineral_tin"},
			9,
			{mod..":tin_block", mod..":tin_ingot"},
			nil,
			type = t,
			group = metal
		})

	-- silver_digger
	ins(
		quests,
		{
			'silver_digger',
			"Silver Digger",
			nil,
			{mod..":mineral_silver"},
			1,
			{mod..":shovel_silver"},
			nil,
			type = t,
			group = metal
		})

	-- silver_digger_lover
	ins(
		quests,
		{
			'silver_digger_lover',
			"Silver Digger Lover",
			nil,
			{mod..":mineral_silver"},
			1,
			{mod..":sword_silver", mod..":hoe_silver"},
			"silver_digger",
			type = t,
			group = metal
		})

	-- silver_digger_pro
	ins(
		quests,
		{
			'silver_digger_pro',
			"Silver Digger Pro",
			nil,
			{mod..":mineral_silver"},
			1,
			{mod..":axe_silver", mod..":pick_silver"},
			"silver_digger_lover",
			type = t,
			group = metal
		})

	-- silver_digger_expert
	ins(
		quests,
		{
			'silver_digger_expert',
			"Silver Digger Expert",
			nil,
			{mod..":mineral_silver"},
			6,
			{mod..":silver_block", mod..":silver_ingot"},
			"silver_digger_pro",
			type = t,
			group = metal
		})

	-- mithril_digger
	ins(
		quests,
		{
			'mithril_digger',
			"Mithril Digger",
			nil,
			{mod..":mineral_mithril"},
			1,
			{mod..":shovel_mithril"},
			nil,
			type = t,
			custom_level = true,
			group = middle
		})

	-- mithril_digger_lover
	ins(
		quests,
		{
			'mithril_digger_lover',
			"Mithril Digger Lover",
			nil,
			{mod..":mineral_mithril"},
			2,
			{mod..":sword_mithril", mod..":hoe_mithril"},
			"mithril_digger",
			type = t,
			custom_level = true,
			group = middle
		})

	-- mithril_digger_pro
	ins(
		quests,
		{
			'mithril_digger_pro',
			"Mithril Digger Pro",
			nil,
			{mod..":mineral_mithril"},
			3,
			{mod..":axe_mithril", mod..":pick_mithril"},
			"mithril_digger_lover",
			type = t,
			custom_level = true,
			group = middle
		})

	-- mithril_digger_expert
	ins(
		quests,
		{
			'mithril_digger_expert',
			"Mithril Digger Expert",
			nil,
			{mod..":mineral_mithril"},
			9,
			{mod..":mithril_block", mod..":mithril_ingot"},
			"mithril_digger_pro",
			type = t,
			custom_level = true,
			group = middle
		})

	-- unlock_copper_rail
	ins(
		quests,
		{
			'unlock_copper_rail',
			"Unlock Copper Rail",
			nil,
			{"default:stone_with_copper"},
			6,
			{mod..":copper_rail"},
			nil,
			type = t,
			group = metal
		})

	sys4_quests.registerQuests()
end
