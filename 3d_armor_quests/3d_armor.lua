-- 3d_armor Quests
-- By Sys4

-- This mod add quests based on 3d_armor and shields mod

local S
if minetest.get_modpath("intllib") then
	S = intllib.Getter()
else
	S = function(s) return s end
end

local ins = table.insert
local up = sys4_quests.updateQuest

---------- Quests for 3d_armor mod ----------
local mod = "3d_armor"
local quests = sys4_quests.initQuests(mod, S)

----- Quests Groups -----
local wood = "Wood Age"
local farm = "Farming Age"
local stone = "Stone Age"
local metal = "Metal Age"
local middle = "Middle Age"

----- Quests with type="dig" -----
local t = "dig"

-- cactus_digger
ins(
	quests,
	{
		'cactus_digger',
		"Cactus Digger",
		nil,
		{'default:cactus'},
		4,
		{mod..':boots_cactus'},
		nil,
		type = t,
		custom_level = true,
		group = farm
	})

-- cactus_protection
ins(
	quests,
	{
		'cactus_protection',
		"Cactus Protection",
		nil,
		{"default:cactus"},
		1,
		{mod..":helmet_cactus"},
		"cactus_digger",
		type = t,
		group = farm
	})

-- cactus_protection_lover
ins(
	quests,
	{
		'cactus_protection_lover',
		"Cactus Protection Lover",
		nil,
		{"default:cactus"},
		1,
		{mod..":leggings_cactus"},
		"cactus_protection",
		type = t,
		group = farm
	})

-- cactus_protection_pro
ins(
	quests,
	{
		'cactus_protection_pro',
		"Cactus Protection Pro",
		nil,
		{"default:cactus"},
		1,
		{mod..":chestplate_cactus"},
		"cactus_protection_lover",
		type = t,
		group = farm
	})

-- steel_protection
ins(
	quests,
	{
		'steel_protection',
		"Steel Protection",
		nil,
		{"default:stone_with_iron"},
		1,
		{mod..":helmet_steel"},
		"sword_crafter_lover",
		type = t,
		group = metal
	})

-- steel_protection_lover
ins(
	quests,
	{
		'steel_protection_lover',
		"Steel Protection Lover",
		nil,
		{"default:stone_with_iron"},
		1,
		{mod..":leggings_steel"},
		"steel_protection",
		type = t,
		group = metal
	})

-- steel_protection_pro
ins(
	quests,
	{
		'steel_protection_pro',
		"Steel Protection Pro",
		nil,
		{"default:stone_with_iron"},
		1,
		{mod..":chestplate_steel"},
		"steel_protection_lover",
		type = t,
		group = metal
	})

-- gold_protection
ins(
	quests,
	{
		'gold_protection',
		"Gold Protection",
		nil,
		{"default:stone_with_gold"},
		4,
		{mod..":boots_gold"},
		nil,
		type = t,
		custom_level = true,
		group = metal
	})

-- gold_protection_lover
ins(
	quests,
	{
		'gold_protection_lover',
		"Gold Protection Lover",
		nil,
		{"default:stone_with_gold"},
		1,
		{mod..":helmet_gold"},
		"gold_protection",
		type = t,
		group = metal
	})

-- gold_protection_pro
ins(
	quests,
	{
		'gold_protection_pro',
		"Gold Protection Pro",
		nil,
		{"default:stone_with_gold"},
		1,
		{mod..":leggings_gold"},
		"gold_protection_lover",
		type = t,
		group = metal
	})

-- gold_protection_expert
ins(
	quests,
	{
		'gold_protection_expert',
		"Gold Protection Expert",
		nil,
		{"default:stone_with_gold"},
		1,
		{mod..":chestplate_gold"},
		"gold_protection_pro",
		type = t,
		group = metal
	})

-- diamond_protection
ins(
	quests,
	{
		'diamond_protection',
		"Diamond Protection",
		nil,
		{"default:stone_with_diamond"},
		1,
		{mod..":helmet_diamond"},
		"sword_crafter_expert",
		type = t,
		group = middle
	})

-- diamond_protection_lover
ins(
	quests,
	{
		'diamond_protection_lover',
		"Diamond Protection Lover",
		nil,
		{"default:stone_with_diamond"},
		1,
		{mod..":leggings_diamond"},
		"diamond_protection",
		type = t,
		group = middle
	})

-- diamond_protection_pro
ins(
	quests,
	{
		'diamond_protection_pro',
		"Diamond Protection Pro",
		nil,
		{"default:stone_with_diamond"},
		1,
		{mod..":chestplate_diamond"},
		"diamond_protection_lover",
		type = t,
		group = middle
	})

if minetest.get_modpath("moreores") then
	-- mithril_protection
	ins(
		quests,
		{
			'mithril_protection',
			"Mithril Protection",
			nil,
			{"moreores:mineral_mithril"},
			5,
			{mod..":helmet_mithril"},
			"mithril_sword_crafter",
			type = t,
			custom_level = true,
			group = middle
		})

	-- mithril_protection_lover
	ins(
		quests,
		{
			'mithril_protection_lover',
			"Mithril Protection Lover",
			nil,
			{"moreores:mineral_mithril"},
			7,
			{mod..":leggings_mithril"},
			"mithril_protection",
			type = t,
			custom_level = true,
			group = middle
		})

	-- mithril_protection_pro
	ins(
		quests,
		{
			'mithril_protection_pro',
			"Mithril Protection Pro",
			nil,
			{"moreores:mineral_mithril"},
			8,
			{mod..":chestplate_mithril"},
			"mithril_protection_lover",
			type = t,
			custom_level = true,
			group = middle
		})

end

t = "craft"

-- sword_crafter
ins(
	quests,
	{
		'sword_crafter',
		"Sword Crafter",
		nil,
		{"default:sword_wood"},
		1,
		{mod..":boots_wood"},
		"wood_crafter",
		type = t,
		custom_level = true,
		group = wood
	})

local woods = {
	"default:wood",
	"default:junglewood",
	"default:pine_wood",
	"default:acacia_wood",
	"default:aspen_wood"
}

if minetest.get_modpath("ethereal") then
	local etherealWoods = {
		"ethereal:banana_wood",
		"ethereal:birch_wood",
		"ethereal:frost_wood",
		"ethereal:palm_wood",
		"ethereal:redwood_wood",
		"ethereal:willow_wood",
		"ethereal:yellow_wood"
	}
	for i = 1, #etherealWoods do
		ins(woods, etherealWoods[i])
	end
end

-- wood_protection
ins(
	quests,
	{
		'wood_protection',
		"Wood Protection",
		nil,
		woods,
		1,
		{mod..":helmet_wood"},
		"sword_crafter",
		type = t,
		group = wood
	})

-- wood_protection_lover
ins(
	quests,
	{
		'wood_protection_lover',
		"Wood Protection Lover",
		nil,
		woods,
		1,
		{mod..":leggings_wood"},
		"wood_protection",
		type = t,
		group = wood
	})

-- wood_protection_pro
ins(
	quests,
	{
		'wood_protection_pro',
		"Wood Protection Pro",
		nil,
		woods,
		1,
		{mod..":chestplate_wood"},
		"wood_protection_lover",
		type = t,
		group = wood
	})

-- sword_crafter_lover
ins(
	quests,
	{
		'sword_crafter_lover',
		"Sword Crafter Lover",
		nil,
		{"default:sword_steel"},
		1,
		{mod..":boots_steel"},
		"iron_digger_lover",
		type = t,
		custom_level = true,
		group = metal
	})

-- sword_crafter_pro
ins(
	quests,
	{
		'sword_crafter_pro',
		"Sword Crafter Pro",
		nil,
		{"default:sword_bronze"},
		1,
		{mod..":boots_bronze"},
		"bronze_crafter_lover",
		type = t,
		custom_level = true,
		group = metal
	})

-- bronze_protection
ins(
	quests,
	{
		'bronze_protection',
		"Bronze Protection",
		nil,
		{"default:bronze_ingot"},
		1,
		{mod..":helmet_bronze"},
		"sword_crafter_pro",
		type = t,
		group = metal
	})

-- bronze_protection_lover
ins(
	quests,
	{
		'bronze_protection_lover',
		"Bronze Protection Lover",
		nil,
		{"default:bronze_ingot"},
		1,
		{mod..":leggings_bronze"},
		"bronze_protection",
		type = t,
		group = metal
	})

-- bronze_protection_pro
ins(
	quests,
	{
		'bronze_protection_pro',
		"Bronze Protection Pro",
		nil,
		{"default:bronze_ingot"},
		1,
		{mod..":chestplate_bronze"},
		"bronze_protection_lover",
		type = t,
		group = metal
	})

-- sword_crafter_expert
ins(
	quests,
	{
		'sword_crafter_expert',
		"Sword Crafter Expert",
		nil,
		{"default:sword_diamond"},
		1,
		{mod..":boots_diamond"},
		"diamond_digger_lover",
		type = t,
		custom_level = true,
		group = middle
	})

if minetest.get_modpath("moreores") then

	-- mithril_sword_crafter
	ins(
		quests,
		{
			'mithril_sword_crafter',
			"Mithril Sword Crafter",
			nil,
			{"moreores:sword_mithril"},
			1,
			{mod..":boots_mithril"},
			"mithril_digger_lover",
			type = t,
			custom_level = true,
			group = middle
		})
end

if minetest.get_modpath("ethereal") then

	-- crystal_sword_crafter
	ins(
		quests,
		{
			'crystal_sword_crafter',
			"Crystal Sword Crafter",
			nil,
			{"ethereal:sword_crystal"},
			1,
			{mod..":boots_crystal"},
			"crystal_crafter_lover",
			type = t,
			custom_level = true,
			group = middle
		})

	-- crystal_protection
	ins(
		quests,
		{
			'crystal_protection',
			"Crystal Protection",
			nil,
			{"ethereal:crystal_ingot"},
			5,
			{mod..":helmet_crystal"},
			"crystal_sword_crafter",
			type = t,
			custom_level = true,
			group = middle
		})

	-- crystal_protection_lover
	ins(
		quests,
		{
			'crystal_protection_lover',
			"Crystal Protection Lover",
			nil,
			{"ethereal:crystal_ingot"},
			7,
			{mod..":leggings_crystal"},
			"crystal_protection",
			type = t,
			custom_level = true,
			group = middle
		})

	-- crystal_protection_pro
	ins(
		quests,
		{
			'crystal_protection_pro',
			"Crystal Protection Pro",
			nil,
			{"ethereal:crystal_ingot"},
			8,
			{mod..":chestplate_crystal"},
			"crystal_protection_lover",
			type = t,
			custom_level = true,
			group = middle
		})
end

sys4_quests.registerQuests()
