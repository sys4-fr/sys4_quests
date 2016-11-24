-- moreblocks Quests
-- By Sys4

-- This mod add quests based on moreblocks mod

if minetest.get_modpath("minetest_quests")
and minetest.get_modpath("moreblocks") then

	local S
	if minetest.get_modpath("intllib") then
		S = intllib.Getter()
	else
		S = function(s) return s end
	end

	local ins = table.insert
	local up = sys4_quests.updateQuest

	---------- Quests for moreblocks mod ----------
	local mod = "moreblocks"
	local quests = sys4_quests.initQuests(mod, S)

	----- Quests Groups -----
	local dark = "Dark Age"
	local wood = "Wood Age"
	local farm = "Farming Age"
	local stone = "Stone Age"
	local metal = "Metal Age"
	local middle = "Middle Age"

	-- update quests from default
	up('wood_builder', nil, {mod..":wood_tile"})

	up('stone_digger', nil, {"default:mossycobble"})
	up('furnace_crafter', nil, {"default:glass"})
	up('glass_builder', nil, {mod..":clean_glass", mod..":coal_glass"})
	up('cobble_builder', nil, {mod..":stone_tile", mod..":split_stone_tile", mod..":split_stone_tile_alt"})
	up('stone_builder', nil, {mod..":cactus_checker", mod..":circle_stone_bricks", mod..":coal_checker", mod..":coal_stone", mod..":plankstone"})
	up('brick_builder', nil, {mod..":cactus_brick", mod..":grey_bricks"})

	up('iron_digger', nil, {mod..":circular_saw", mod..":iron_glass", mod..":iron_stone"})
	up('iron_digger_lover', nil, {mod..":iron_checker"})

	up('mese_digger', nil, {mod..":trap_glass", mod..":trap_stone"})

	local t = "dig"

	-- dirt_digger
	ins(
		quests,
		{
			'dirt_digger',
			"Dirt Digger",
			nil,
			{"default:dirt", "default:dirt_with_grass", "default:dirt_with_dry_grass", "default:dirt_with_snow"},
			1,
			{"default:dirt_with_grass"},
			nil,
			type = t,
			group = dark
		})

	-- tree_digger_lover
	ins(
		quests,
		{
			'tree_digger_lover',
			"Tree Digger Lover",
			nil,
			{"default:tree", "default:jungletree"},
			7,
			{mod..":all_faces_tree", mod..":all_faces_jungle_tree"},
			nil,
			type = t,
			group = wood
		})

	-- junglegrass_digger
	ins(
		quests,
		{
			'junglegrass_digger',
			"Jungle Grass Digger",
			nil,
			{"default:junglegrass"},
			3,
			{mod..":rope", mod..":sweeper", mod..":empty_bookshelf"},
			"book_crafter",
			type = t
		})

	-- stone_digger_master
	ins(
		quests,
		{
			'stone_digger_master',
			"Stone Digger Master",
			nil,
			{"default:stone"},
			1,
			{mod..":cobble_compressed", "default:cobble"},
			"stone_digger_expert",
			type = t,
			group = stone
		})

	t = "craft"

	-- unlock_copperpatina
	ins(
		quests,
		{
			'unlock_copperpatina',
			"Unlock Copper Patina",
			nil,
			{"default:copperblock"},
			1,
			{mod..":copperpatina"},
			{"copper_digger", "iron_digger_pro"},
			type = t,
			group = metal
		})

	-- unlock_trap_glow_glass
	ins(
		quests,
		{
			'unlock_trap_glow_glass',
			"Unlock Trap Glow Glass",
			nil,
			{mod..":glow_glass"},
			1,
			{mod..":trap_glow_glass"},
			{"torch_placer", "mese_digger"},
			type = t
		})

	-- unlock_trap_super_glow_glass
	ins(
		quests,
		{
			'unlock_trap_super_glow_glass',
			"Unlock Trap Super Glow Glass",
			nil,
			{mod..":super_glow_glass"},
			1,
			{mod..":trap_super_glow_glass"},
			{"glow_glass_builder", "mese_digger"},
			type = t
		})

	t = "place"

	-- iron_stone_builder
	ins(
		quests,
		{
			'iron_stone_builder',
			"Iron Stone Builder",
			nil,
			{mod..":iron_stone"},
			1,
			{mod..":iron_stone_bricks"},
			"iron_digger",
			type = t
		})

	-- coal_stone_builder
	ins(
		quests,
		{
			'coal_stone_builder',
			"Coal Stone Builder",
			nil,
			{mod..":coal_stone"},
			1,
			{mod..":coal_stone_bricks"},
			"stone_builder",
			type = t
		})

	-- torch_placer
	ins(
		quests,
		{
			'torch_placer',
			"Torch Placer",
			nil,
			{"default:torch"},
			1,
			{mod..":glow_glass"},
			{"coal_digger", "furnace_crafter"},
			type = t
		})

	-- glow_glass_builder
	ins(
		quests,
		{
			'glow_glass_builder',
			"Glow Glass Builder",
			nil,
			{mod..":glow_glass"},
			1,
			{mod..":super_glow_glass"},
			"torch_placer",
			type = t
		})

	-- wood_tile_builder
	ins(
		quests,
		{
			'wood_tile_builder',
			"Wood Tile Builder",
			nil,
			{mod..":wood_tile"},
			1,
			{mod..":wood_tile_center", mod..":wood_tile_up", mod..":wood_tile_down", mod..":wood_tile_left", mod..":wood_tile_right", mod..":wood_tile_flipped", mod..":wood_tile_full"},
			"wood_builder",
			type = t
		})

	sys4_quests.registerQuests()
end
