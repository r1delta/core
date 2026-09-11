
const DEV_ENABLED = 1
const DEV_DISABLED = 0

::unlockLevels <- {}

const MOD_ICON_NONE = "../ui/menu/items/mod_icons/none"

function main()
{
	Globalize( InitItems )

	Globalize( ItemDefined )
	Globalize( IsRefValid )
	Globalize( SubitemDefined )

	Globalize( GetItemData )
	Globalize( GetItemType )
	Globalize( GetItemName )
	Globalize( GetItemDescription )
	Globalize( GetItemLongDescription )
	Globalize( GetItemAdditionalName )	//Used by Titans for Chassis Core
	Globalize( GetItemAdditionalDescription )	//Used by Titans for Chassis Core
	Globalize( GetItemImage )
	Globalize( GetItemAltImage )
	Globalize( GetItemIcon )
	Globalize( GetItemTeamImages )
	Globalize( GetItemCoreImage )
	Globalize( GetItemDamageStat )
	Globalize( GetSubitemDamageStat )
	Globalize( GetItemAccuracyStat )
	Globalize( GetSubitemAccuracyStat )
	Globalize( GetItemRangeStat )
	Globalize( GetSubitemRangeStat )
	Globalize( GetItemFireRateStat )
	Globalize( GetSubitemFireRateStat )
	Globalize( GetItemClipSize )
	Globalize( GetSubItemClipSizeStat )
	Globalize( GetItemSpeedStat )
	Globalize( GetItemAccelStat )
	Globalize( GetItemHealthStat )
	Globalize( GetItemDashCountStat )
	Globalize( GetItemDecalUnlockReqText )
	Globalize( GetItemDecalUnlockReqUnlockedText )
	Globalize( GetDecalHidden )
	Globalize( GetDecalSkinForTeam )
	Globalize( GetDecalUnlockData )

	Globalize( GetRefFromItem )

	Globalize( GetUnlockLevelReq )

	Globalize( GetSubitemData )
	Globalize( GetSubitemType )
	Globalize( GetSubitemName )
	Globalize( GetSubitemDescription )
	Globalize( GetSubitemLongDescription )
	Globalize( GetSubitemImage )
	Globalize( GetSubitemIcon )

	Globalize( TMPHasSubitem )

	Globalize( GetAllItemsOfType )
	Globalize( GetAllItemRefs )
	Globalize( GetAllItemAttachments )
	Globalize( GetAllItemMods )

	Globalize( GetAllRefsOfType )

	Globalize( GetItemForTypeIndex )
	Globalize( GetAttachmentForItemIndex )
	Globalize( GetModForItemIndex )

	Globalize( ItemSupportsAttachments )
	Globalize( ItemSupportsAttachment )
	Globalize( ItemAttachmentsExist )
	Globalize( ItemSupportsMods )
	Globalize( ItemSupportsMod )
	Globalize( ItemModsExist )

	Globalize( ItemTypeSupportsAttachments )
	Globalize( ItemTypeSupportsMods )

	Globalize( ItemTypeIsMod )
	Globalize( ItemTypeIsAttachment )

	Globalize( IsItemLocked )
	Globalize( GetItemDevLocked )
	Globalize( GetItemLevelReq )
	Globalize( GetItemChallengeReq )
	Globalize( DidPlayerBuyItemFromBlackMarket )

	Globalize( GetDisplayNameFromItemType )
	Globalize( GetItemTypeFromPropertyName )

	Globalize( UpdatePlayerDecalUnlocks )

	Globalize( GetDefaultAttachmentName )
	Globalize( GetDefaultAttachmentIcon )

	Globalize( CreateBlackMarketModdedItems )
	Globalize( BlackMarket_ITEMCALL )

	if ( developer() > 0 )
	{
		Globalize( PrintItemData )
		Globalize( PrintItems )
		Globalize( PrintMods )
		Globalize( PrintAttachments )
	}

	// If modifying level 1 unlocks, update the presets in scripts\vscripts\_persistentdata.nut to only include weapons that are unlocked at that time.
	unlockLevels[ "mp_weapon_smart_pistol" ]			<- 1
	unlockLevels[ "mp_weapon_rspn101" ]					<- 1
	unlockLevels[ "mp_weapon_rocket_launcher" ]			<- 1
	unlockLevels[ "mp_weapon_smr" ]						<- 1
	unlockLevels[ "mp_weapon_semipistol" ]				<- 1
	unlockLevels[ "mp_ability_cloak" ]					<- 1
	unlockLevels[ "mp_weapon_frag_grenade" ]			<- 1
	unlockLevels[ "pas_power_cell" ]					<- 1
	unlockLevels[ "pas_wall_runner" ]					<- 1
	unlockLevels[ "pas_ordnance_pack" ]					<- 1
	unlockLevels[ "pas_longer_bubble" ]					<- 1
	unlockLevels[ "pas_minimap_ai" ]					<- 1
	unlockLevels[ "mp_weapon_autopistol" ]				<- 1
	unlockLevels[ "mp_weapon_shotgun" ]					<- 1

	unlockLevels[ "mp_titanweapon_40mm" ]				<- 1
	unlockLevels[ "mp_titanweapon_xo16" ]				<- 1
	unlockLevels[ "mp_titanweapon_rocket_launcher" ]	<- 1
	unlockLevels[ "mp_titanweapon_salvo_rockets" ]		<- 1
	unlockLevels[ "mp_titanweapon_vortex_shield" ]		<- 1
	unlockLevels[ "pas_shield_regen" ]					<- 1
	unlockLevels[ "pas_auto_eject" ]					<- 1
	unlockLevels[ "pas_doomed_time" ]					<- 1
	unlockLevels[ "pas_build_up_nuclear_core" ]			<- 1
	unlockLevels[ "titan_atlas" ]						<- 1

	unlockLevels[ "mp_weapon_r97" ]						<- 6
	unlockLevels[ "mp_weapon_grenade_emp" ]				<- 7
	unlockLevels[ "mp_ability_heal" ]					<- 8
	unlockLevels[ "mp_weapon_dmr" ]						<- 9

	unlockLevels[ "mp_titanweapon_homing_rockets" ]		<- 11
	unlockLevels[ "mp_titanweapon_sniper" ]				<- 12
	unlockLevels[ "mp_titanability_smoke" ]				<- 13
	unlockLevels[ "pas_assault_reactor" ]				<- 14

	unlockLevels[ "pas_turbo_drop" ]					<- 16
	unlockLevels[ "mp_weapon_satchel" ]					<- 17
	unlockLevels[ "mp_weapon_g2" ]						<- 18
	unlockLevels[ "mp_ability_sonar" ]					<- 19

	unlockLevels[ "mp_titanweapon_arc_cannon" ]			<- 21
	unlockLevels[ "mp_weapon_mgl" ]						<- 22
	unlockLevels[ "pas_marathon_core" ]					<- 23
	unlockLevels[ "mp_titanweapon_dumbfire_rockets" ]	<- 24

	unlockLevels[ "mp_titanability_bubble_shield" ]		<- 26
	unlockLevels[ "mp_weapon_wingman" ]					<- 27
	unlockLevels[ "mp_titanweapon_triple_threat" ]		<- 28
	unlockLevels[ "mp_weapon_hemlok" ]					<- 29

	unlockLevels[ "mp_weapon_proximity_mine" ]			<- 31
	unlockLevels[ "mp_titanweapon_shoulder_rockets" ]	<- 32
	unlockLevels[ "mp_weapon_defender" ]				<- 33
	unlockLevels[ "mp_weapon_car" ]						<- 34

	unlockLevels[ "pas_run_and_gun" ]					<- 36
	unlockLevels[ "pas_dead_mans_trigger" ]				<- 37
	unlockLevels[ "pas_dash_recharge" ]					<- 38
	unlockLevels[ "mp_weapon_lmg" ]						<- 39

	unlockLevels[ "pas_titan_punch" ]					<- 41
	unlockLevels[ "pas_fast_reload" ]					<- 42
	unlockLevels[ "pas_fast_hack" ]						<- 43
	unlockLevels[ "mp_weapon_sniper" ]					<- 44

	unlockLevels[ "pas_defensive_core" ]				<- 46
	unlockLevels[ "pas_hyper_core" ]					<- 47
	unlockLevels[ "pas_stealth_movement" ]				<- 48
	unlockLevels[ "pas_enhanced_titan_ai" ]				<- 49

	unlockLevels[ "pilot_preset_loadout_1"]				<- 1
	unlockLevels[ "pilot_preset_loadout_2"]				<- 1
	unlockLevels[ "pilot_preset_loadout_3"]				<- 2

	unlockLevels[ "titan_preset_loadout_1"]				<- 1
	unlockLevels[ "titan_preset_loadout_2"]				<- 1
	unlockLevels[ "titan_preset_loadout_3"]				<- 3

	unlockLevels[ "edit_pilots"]						<- 5
	unlockLevels[ "pilot_custom_loadout_1"]				<- 5
	unlockLevels[ "pilot_custom_loadout_2"]				<- 5
	unlockLevels[ "pilot_custom_loadout_3"]				<- 5
	unlockLevels[ "pilot_custom_loadout_4"]				<- 15
	unlockLevels[ "pilot_custom_loadout_5"]				<- 30

	unlockLevels[ "pilot_custom_loadout_6"]				<- null
	unlockLevels[ "pilot_custom_loadout_7"]				<- null
	unlockLevels[ "pilot_custom_loadout_8"]				<- null
	unlockLevels[ "pilot_custom_loadout_9"]				<- null
	unlockLevels[ "pilot_custom_loadout_10"]			<- null
	unlockLevels[ "pilot_custom_loadout_11"]			<- null
	unlockLevels[ "pilot_custom_loadout_12"]			<- null
	unlockLevels[ "pilot_custom_loadout_13"]			<- null
	unlockLevels[ "pilot_custom_loadout_14"]			<- null
	unlockLevels[ "pilot_custom_loadout_15"]			<- null
	unlockLevels[ "pilot_custom_loadout_16"]			<- null
	unlockLevels[ "pilot_custom_loadout_17"]			<- null
	unlockLevels[ "pilot_custom_loadout_18"]			<- null
	unlockLevels[ "pilot_custom_loadout_19"]			<- null

	unlockLevels[ "edit_titans"]						<- 10
	unlockLevels[ "titan_custom_loadout_1"]				<- 10
	unlockLevels[ "titan_custom_loadout_2"]				<- 10
	unlockLevels[ "titan_custom_loadout_3"]				<- 10
	unlockLevels[ "titan_custom_loadout_4"]				<- 20
	unlockLevels[ "titan_custom_loadout_5"]				<- 35

	unlockLevels[ "titan_custom_loadout_6"]				<- null
	unlockLevels[ "titan_custom_loadout_7"]				<- null
	unlockLevels[ "titan_custom_loadout_8"]				<- null
	unlockLevels[ "titan_custom_loadout_9"]				<- null
	unlockLevels[ "titan_custom_loadout_10"]			<- null
	unlockLevels[ "titan_custom_loadout_11"]			<- null
	unlockLevels[ "titan_custom_loadout_12"]			<- null
	unlockLevels[ "titan_custom_loadout_13"]			<- null
	unlockLevels[ "titan_custom_loadout_14"]			<- null
	unlockLevels[ "titan_custom_loadout_15"]			<- null
	unlockLevels[ "titan_custom_loadout_16"]			<- null
	unlockLevels[ "titan_custom_loadout_17"]			<- null
	unlockLevels[ "titan_custom_loadout_18"]			<- null
	unlockLevels[ "titan_custom_loadout_19"]			<- null

	unlockLevels[ "burn_card_slot_1"]					<- 7 // burn cards unlock
	unlockLevels[ "burn_card_slot_2"]					<- 9 // second slot
	unlockLevels[ "burn_card_slot_3"]					<- 11 // 3rd slot

	unlockLevels[ "burn_card_pack_1"]					<- 25
	unlockLevels[ "burn_card_pack_2"]					<- 30
	unlockLevels[ "burn_card_pack_3"]					<- 40
	unlockLevels[ "burn_card_pack_4"]					<- 45
	unlockLevels[ "burn_card_pack_5"]					<- 50

	unlockLevels[ "challenges"]							<- 4

	unlockLevels[ "challenges_1"]						<- 4
	unlockLevels[ "challenges_2"]						<- 4
	unlockLevels[ "challenges_3"]						<- 4
	unlockLevels[ "challenges_4"]						<- 4
	unlockLevels[ "challenges_5"]						<- 4
	unlockLevels[ "challenges_6"]						<- 4
	unlockLevels[ "challenges_7"]						<- 4

	unlockLevels[ "titan_stryder"]						<- 15
	unlockLevels[ "titan_ogre"]							<- 30


	if ( IsServer() && IsMultiplayer() )
	{
		AddBurnCardLevelingPack( "burn_card_pack_1",
			[ "bc_stim_forever", "bc_stim_forever", "bc_super_stim", "bc_super_stim", "bc_fast_movespeed", "bc_shotgun_m2", "bc_defender_m2" ]
			)

		AddBurnCardLevelingPack( "burn_card_pack_2",
			[ "bc_cloak_forever", "bc_cloak_forever", "bc_super_cloak", "bc_super_cloak", "bc_rematch", "bc_minimap_scan", "bc_prox_m2" ]
			)

		AddBurnCardLevelingPack( "burn_card_pack_3",
			[ "bc_minimap", "bc_minimap", "bc_minimap_scan", "bc_minimap_scan", "bc_mgl_m2", "bc_rocket_launcher_m2", "bc_smr_m2" ]
			)

		AddBurnCardLevelingPack( "burn_card_pack_4",
			[ "bc_sonar_forever", "bc_sonar_forever", "bc_super_sonar", "bc_super_sonar", "bc_auto_sonar", "bc_dmr_m2", "bc_prox_m2" ]
			)

		AddBurnCardLevelingPack( "burn_card_pack_5",
			[ "bc_summon_atlas", "bc_summon_ogre", "bc_summon_stryder", "bc_play_spectre", "bc_play_spectre", "bc_play_spectre" ]
			)

		InitBurncardPackLevels( 0, 5 ) // number of commons and rares to include in burn card packs
	}

	unlockLevels[ "mp_titanweapon_shotgun" ]				<- 36
	unlockLevels[ "mp_weapon_mega1" ]						<- 30
	unlockLevels[ "mp_weapon_mega2" ]						<- 35
}

function InitItems()
{
	itemData <- {}
	::combinedModData <- {}
	itemsOfType <- {}
	attachmentsOfType <- {}
	modsOfType <- {}
	::allItems <- []

	local HideFromMenus = false

	if ( IsClient() )
		ClearItemTypes();

	////////////////////
	//PILOT WEAPON DATA
	////////////////////
	CreateWeaponData( itemType.PILOT_PRIMARY, 	DEV_ENABLED,	0, 		null, 	null, "mp_weapon_smart_pistol", 	"../ui/menu/items/weapon_smartpistol" )
	CreateWeaponData( itemType.PILOT_PRIMARY, 	DEV_ENABLED,	0, 		null, 	null, "mp_weapon_rspn101", 			"../ui/menu/items/weapon_rspn101" )
	CreateWeaponData( itemType.PILOT_PRIMARY, 	DEV_ENABLED,	0, 		null, 	null, "mp_weapon_r97",	 			"../ui/menu/items/weapon_r97" )
	CreateWeaponData( itemType.PILOT_PRIMARY, 	DEV_ENABLED,	0, 		null, 	null, "mp_weapon_hemlok", 			"../ui/menu/items/weapon_hemlok" )
	CreateWeaponData( itemType.PILOT_PRIMARY, 	DEV_ENABLED,	0, 		null, 	null, "mp_weapon_g2", 				"../ui/menu/items/weapon_g2" )
	CreateWeaponData( itemType.PILOT_PRIMARY, 	DEV_ENABLED,	0, 		null, 	null, "mp_weapon_shotgun", 			"../ui/menu/items/weapon_shotgun" )
	CreateWeaponData( itemType.PILOT_PRIMARY, 	DEV_ENABLED,	0, 		null, 	null, "mp_weapon_dmr",	 			"../ui/menu/items/weapon_dmr" )
	CreateWeaponData( itemType.PILOT_PRIMARY, 	DEV_ENABLED,	0, 		null, 	null, "mp_weapon_lmg",				"../ui/menu/items/weapon_lmg" )
	CreateWeaponData( itemType.PILOT_PRIMARY, 	DEV_ENABLED,	0, 		null, 	null, "mp_weapon_car",	 			"../ui/menu/items/weapon_car" )
	CreateWeaponData( itemType.PILOT_PRIMARY, 	DEV_ENABLED,	0, 		null, 	null, "mp_weapon_sniper",	 		"../ui/menu/items/weapon_sniper" )

	CreateWeaponData( itemType.PILOT_SECONDARY, DEV_ENABLED,	0, 		null, 	null, "mp_weapon_mgl", 				"../ui/menu/items/weapon_mgl" )
	CreateWeaponData( itemType.PILOT_SECONDARY, DEV_ENABLED,	0, 		null, 	null, "mp_weapon_rocket_launcher", 	"../ui/menu/items/weapon_archer" )
	CreateWeaponData( itemType.PILOT_SECONDARY, DEV_ENABLED,	0, 		null, 	null, "mp_weapon_defender", 		"../ui/menu/items/weapon_chargerifle" )
	CreateWeaponData( itemType.PILOT_SECONDARY, DEV_ENABLED,	0, 		null, 	null, "mp_weapon_smr", 				"../ui/menu/items/weapon_smr" )

	CreateWeaponData( itemType.PILOT_SIDEARM, 	DEV_ENABLED,	0, 		null, 	null, "mp_weapon_semipistol",		"../ui/menu/items/weapon_p2011" )
	CreateWeaponData( itemType.PILOT_SIDEARM, 	DEV_ENABLED,	0, 		null, 	null, "mp_weapon_autopistol",		"../ui/menu/items/weapon_autopistol" )
	CreateWeaponData( itemType.PILOT_SIDEARM, 	DEV_ENABLED,	0, 		null, 	null, "mp_weapon_wingman", 			"../ui/menu/items/weapon_wingman" )

	CreateWeaponData( itemType.PILOT_SPECIAL,	DEV_ENABLED,	0, 		null, 	null, "mp_ability_cloak", 			"../ui/menu/items/ability_icons/cloak", 		"../ui/menu/items/ability_icons/cloak" )
	CreateWeaponData( itemType.PILOT_SPECIAL,	DEV_ENABLED,	0,		null, 	null, "mp_ability_heal", 			"../ui/menu/items/ability_icons/heal", 			"../ui/menu/items/ability_icons/heal" )
	CreateWeaponData( itemType.PILOT_SPECIAL,	DEV_ENABLED,	0,		null, 	null, "mp_ability_sonar", 			"../ui/menu/items/ability_icons/sonar", 		"../ui/menu/items/ability_icons/sonar" )

	CreateWeaponData( itemType.PILOT_ORDNANCE,	DEV_ENABLED,	0, 		null, 	null, "mp_weapon_frag_grenade", 	"../ui/menu/items/weapon_frag_grenade", 		"../ui/menu/items/ability_icons/frag_grenade", 		"../ui/menu/items/weapon_frag_grenade" )
	CreateWeaponData( itemType.PILOT_ORDNANCE,	DEV_ENABLED,	0, 		null, 	null, "mp_weapon_grenade_emp", 		"../ui/menu/items/weapon_arc_grenade",			"../ui/menu/items/ability_icons/arc_grenade", 		"../ui/menu/items/weapon_arc_grenade" )
	CreateWeaponData( itemType.PILOT_ORDNANCE,	DEV_ENABLED,	0, 		null, 	null, "mp_weapon_satchel", 			"../ui/menu/items/weapon_satchel",				"../ui/menu/items/ability_icons/satchel", 			"../ui/menu/items/weapon_satchel" )
	CreateWeaponData( itemType.PILOT_ORDNANCE,	DEV_ENABLED,	0, 		null, 	null, "mp_weapon_proximity_mine", 	"../ui/menu/items/weapon_proximity_mine",		"../ui/menu/items/ability_icons/proximity_mine", 	"../ui/menu/items/weapon_proximity_mine" )

	////////////////////////
	//PILOT ATTACHMENT DATA
	////////////////////////
	CreateAttachmentData( itemType.PILOT_PRIMARY_ATTACHMENT,	DEV_ENABLED,	0, 		null, 						null, 	"mp_weapon_car",		"iron_sights",	"#MOD_IRON_SIGHTS_NAME",	"#MOD_IRON_SIGHTS_DESC",	"#MOD_IRON_SIGHTS_LONGDESC",			"../ui/menu/items/attachment_icons/iron_sights", 		"../ui/menu/items/attachment_icons/iron_sights" )
	CreateAttachmentData( itemType.PILOT_PRIMARY_ATTACHMENT,	DEV_ENABLED,	0, 		"ch_car_grunt_kills", 		2,		"mp_weapon_car",		"hcog",			"#MOD_HCOG_NAME",			"#MOD_HCOG_DESC",			"#MOD_HCOG_LONGDESC",					"../ui/menu/items/attachment_icons/hcog", 				"../ui/menu/items/attachment_icons/hcog" )
	CreateAttachmentData( itemType.PILOT_PRIMARY_ATTACHMENT,	DEV_ENABLED,	0, 		null, 						null, 	"mp_weapon_dmr",		"scope_6x",		"#MOD_SCOPE_6X_NAME",		"#MOD_SCOPE_6X_DESC",		"#MOD_SCOPE_6X_LONGDESC",				"../ui/menu/items/attachment_icons/scope_6x", 			"../ui/menu/items/attachment_icons/scope_6x" )
	CreateAttachmentData( itemType.PILOT_PRIMARY_ATTACHMENT,	DEV_ENABLED,	0, 		"ch_dmr_grunt_kills", 		0, 		"mp_weapon_dmr",		"aog",			"#MOD_AOG_NAME",			"#MOD_AOG_DESC",			"#MOD_AOG_LONGDESC",					"../ui/menu/items/attachment_icons/aog", 				"../ui/menu/items/attachment_icons/aog" )
	CreateAttachmentData( itemType.PILOT_PRIMARY_ATTACHMENT,	DEV_ENABLED,	0, 		"ch_dmr_kills",				1, 		"mp_weapon_dmr",		"scope_4x",		"#MOD_SCOPE_4X_NAME",		"#MOD_SCOPE_4X_DESC",		"#MOD_SCOPE_4X_LONGDESC",				"../ui/menu/items/attachment_icons/aog", 				"../ui/menu/items/attachment_icons/scope_4" )
	// CreateAttachmentData( itemType.PILOT_PRIMARY_ATTACHMENT,	DEV_ENABLED,	0, 		"ch_dmr_pilot_kills",		2, 		"mp_weapon_dmr",		"scope_10x",	"#MOD_SCOPE_10X_NAME",		"#MOD_SCOPE_10X_DESC",		"#MOD_SCOPE_10X_LONGDESC",				"../ui/menu/items/attachment_icons/scope_10x", 			"../ui/menu/items/attachment_icons/scope_10x" )
	// CreateAttachmentData( itemType.PILOT_PRIMARY_ATTACHMENT,	DEV_ENABLED,	0, 		"ch_dmr_kills", 			2, 		"mp_weapon_dmr",		"scope_12x",	"#MOD_SCOPE_12X_NAME",		"#MOD_SCOPE_12X_DESC",		"#MOD_SCOPE_12X_LONGDESC",				"../ui/menu/items/attachment_icons/scope_12x", 			"../ui/menu/items/attachment_icons/scope_12x" )

	CreateAttachmentData( itemType.PILOT_PRIMARY_ATTACHMENT,	DEV_ENABLED,	0, 		null, 						null, 	"mp_weapon_g2",			"iron_sights",	"#MOD_IRON_SIGHTS_NAME",	"#MOD_IRON_SIGHTS_DESC",	"#MOD_IRON_SIGHTS_LONGDESC",			"../ui/menu/items/attachment_icons/iron_sights", 		"../ui/menu/items/attachment_icons/iron_sights" )
	CreateAttachmentData( itemType.PILOT_PRIMARY_ATTACHMENT,	DEV_ENABLED,	0, 		"ch_g2_grunt_kills", 		2, 		"mp_weapon_g2",			"hcog",			"#MOD_HCOG_NAME",			"#MOD_HCOG_DESC",			"#MOD_HCOG_LONGDESC",					"../ui/menu/items/attachment_icons/hcog", 				"../ui/menu/items/attachment_icons/hcog" )
	CreateAttachmentData( itemType.PILOT_PRIMARY_ATTACHMENT,	DEV_ENABLED,	0, 		"ch_g2_grunt_kills", 		1,		"mp_weapon_g2",			"holosight",	"#MOD_HOLOSIGHT_NAME",		"#MOD_HOLOSIGHT_DESC",		"#MOD_HOLOSIGHT_LONGDESC",				"../ui/menu/items/attachment_icons/holosight", 			"../ui/menu/items/attachment_icons/holosight" )
	CreateAttachmentData( itemType.PILOT_PRIMARY_ATTACHMENT,	DEV_ENABLED,	0, 		"ch_g2_kills", 				2,		"mp_weapon_g2",			"aog",			"#MOD_AOG_NAME",			"#MOD_AOG_DESC",			"#MOD_AOG_LONGDESC",					"../ui/menu/items/attachment_icons/aog", 				"../ui/menu/items/attachment_icons/aog" )
	CreateAttachmentData( itemType.PILOT_PRIMARY_ATTACHMENT,	DEV_ENABLED,	0,		null, 						null, 	"mp_weapon_hemlok",		"iron_sights",	"#MOD_IRON_SIGHTS_NAME",	"#MOD_IRON_SIGHTS_DESC",	"#MOD_IRON_SIGHTS_LONGDESC",			"../ui/menu/items/attachment_icons/iron_sights", 		"../ui/menu/items/attachment_icons/iron_sights" )
	CreateAttachmentData( itemType.PILOT_PRIMARY_ATTACHMENT,	DEV_ENABLED,	0,		"ch_hemlok_kills", 			2, 		"mp_weapon_hemlok",		"hcog",			"#MOD_HCOG_NAME",			"#MOD_HCOG_DESC",			"#MOD_HCOG_LONGDESC",					"../ui/menu/items/attachment_icons/hcog", 				"../ui/menu/items/attachment_icons/hcog" )
	CreateAttachmentData( itemType.PILOT_PRIMARY_ATTACHMENT,	DEV_ENABLED,	0,		"ch_hemlok_grunt_kills", 	2, 		"mp_weapon_hemlok",		"holosight",	"#MOD_HOLOSIGHT_NAME",		"#MOD_HOLOSIGHT_DESC",		"#MOD_HOLOSIGHT_LONGDESC",				"../ui/menu/items/attachment_icons/holosight", 			"../ui/menu/items/attachment_icons/holosight" )
	CreateAttachmentData( itemType.PILOT_PRIMARY_ATTACHMENT,	DEV_ENABLED,	0, 		"ch_hemlok_grunt_kills", 	1, 		"mp_weapon_hemlok",		"aog",			"#MOD_AOG_NAME",			"#MOD_AOG_DESC",			"#MOD_AOG_LONGDESC",					"../ui/menu/items/attachment_icons/aog", 				"../ui/menu/items/attachment_icons/aog" )
	CreateAttachmentData( itemType.PILOT_PRIMARY_ATTACHMENT,	DEV_ENABLED,	0, 		null, 						null, 	"mp_weapon_lmg",		"iron_sights",	"#MOD_IRON_SIGHTS_NAME",	"#MOD_IRON_SIGHTS_DESC",	"#MOD_IRON_SIGHTS_LONGDESC",			"../ui/menu/items/attachment_icons/iron_sights", 		"../ui/menu/items/attachment_icons/iron_sights" )
	CreateAttachmentData( itemType.PILOT_PRIMARY_ATTACHMENT,	DEV_ENABLED,	0,		"ch_lmg_grunt_kills", 		2,		"mp_weapon_lmg",		"hcog",			"#MOD_HCOG_NAME",			"#MOD_HCOG_DESC",			"#MOD_HCOG_LONGDESC",					"../ui/menu/items/attachment_icons/hcog", 				"../ui/menu/items/attachment_icons/hcog" )
	CreateAttachmentData( itemType.PILOT_PRIMARY_ATTACHMENT,	DEV_ENABLED,	0,		"ch_lmg_grunt_kills", 		1, 		"mp_weapon_lmg",		"holosight",	"#MOD_HOLOSIGHT_NAME",		"#MOD_HOLOSIGHT_DESC",		"#MOD_HOLOSIGHT_LONGDESC",				"../ui/menu/items/attachment_icons/holosight", 			"../ui/menu/items/attachment_icons/holosight" )
	CreateAttachmentData( itemType.PILOT_PRIMARY_ATTACHMENT,	DEV_ENABLED,	0,		"ch_lmg_kills",		 		2,		"mp_weapon_lmg",		"aog",			"#MOD_AOG_NAME",			"#MOD_AOG_DESC",			"#MOD_AOG_LONGDESC",					"../ui/menu/items/attachment_icons/aog", 				"../ui/menu/items/attachment_icons/aog" )
	CreateAttachmentData( itemType.PILOT_PRIMARY_ATTACHMENT,	DEV_ENABLED,	0, 		null, 						null, 	"mp_weapon_rspn101",	"iron_sights",	"#MOD_IRON_SIGHTS_NAME",	"#MOD_IRON_SIGHTS_DESC",	"#MOD_IRON_SIGHTS_LONGDESC",			"../ui/menu/items/attachment_icons/iron_sights", 		"../ui/menu/items/attachment_icons/iron_sights" )
	CreateAttachmentData( itemType.PILOT_PRIMARY_ATTACHMENT,	DEV_ENABLED,	0, 		"ch_rspn101_grunt_kills", 	1,		"mp_weapon_rspn101",	"hcog",			"#MOD_HCOG_NAME",			"#MOD_HCOG_DESC",			"#MOD_HCOG_LONGDESC",					"../ui/menu/items/attachment_icons/hcog", 				"../ui/menu/items/attachment_icons/hcog" )
	CreateAttachmentData( itemType.PILOT_PRIMARY_ATTACHMENT,	DEV_ENABLED,	0, 		"ch_rspn101_grunt_kills", 	2,		"mp_weapon_rspn101",	"holosight",	"#MOD_HOLOSIGHT_NAME",		"#MOD_HOLOSIGHT_DESC",		"#MOD_HOLOSIGHT_LONGDESC",				"../ui/menu/items/attachment_icons/holosight", 			"../ui/menu/items/attachment_icons/holosight" )
	CreateAttachmentData( itemType.PILOT_PRIMARY_ATTACHMENT,	DEV_ENABLED,	0, 		"ch_rspn101_kills",		 	2,		"mp_weapon_rspn101",	"aog",			"#MOD_AOG_NAME",			"#MOD_AOG_DESC",			"#MOD_AOG_LONGDESC",					"../ui/menu/items/attachment_icons/aog", 				"../ui/menu/items/attachment_icons/aog" )
	CreateAttachmentData( itemType.PILOT_PRIMARY_ATTACHMENT,	DEV_ENABLED,	0, 		null, 						null, 	"mp_weapon_r97",		"iron_sights",	"#MOD_IRON_SIGHTS_NAME",	"#MOD_IRON_SIGHTS_DESC",	"#MOD_IRON_SIGHTS_LONGDESC",			"../ui/menu/items/attachment_icons/iron_sights", 		"../ui/menu/items/attachment_icons/iron_sights" )
	CreateAttachmentData( itemType.PILOT_PRIMARY_ATTACHMENT,	DEV_ENABLED,	0, 		"ch_r97_grunt_kills", 		2,		"mp_weapon_r97",		"hcog",			"#MOD_HCOG_NAME",			"#MOD_HCOG_DESC",			"#MOD_HCOG_LONGDESC",					"../ui/menu/items/attachment_icons/hcog", 				"../ui/menu/items/attachment_icons/hcog" )
	CreateAttachmentData( itemType.PILOT_PRIMARY_ATTACHMENT,	DEV_ENABLED,	0, 		null, 						null, 	"mp_weapon_sniper",		"scope_6x",		"#MOD_SCOPE_6X_NAME",		"#MOD_SCOPE_6X_DESC",		"#MOD_SCOPE_6X_LONGDESC",				"../ui/menu/items/attachment_icons/scope_6x", 			"../ui/menu/items/attachment_icons/scope_6x" )
	CreateAttachmentData( itemType.PILOT_PRIMARY_ATTACHMENT,	DEV_ENABLED,	0, 		"ch_sniper_grunt_kills", 	0, 		"mp_weapon_sniper",		"aog",			"#MOD_AOG_NAME",			"#MOD_AOG_DESC",			"#MOD_AOG_LONGDESC",					"../ui/menu/items/attachment_icons/aog", 				"../ui/menu/items/attachment_icons/aog" )
	CreateAttachmentData( itemType.PILOT_PRIMARY_ATTACHMENT,	DEV_ENABLED,	0, 		"ch_sniper_kills", 			1, 		"mp_weapon_sniper",		"scope_4x",		"#MOD_SCOPE_4X_NAME",		"#MOD_SCOPE_4X_DESC",		"#MOD_SCOPE_4X_LONGDESC",				"../ui/menu/items/attachment_icons/aog", 				"../ui/menu/items/attachment_icons/scope_4" )
	// CreateAttachmentData( itemType.PILOT_PRIMARY_ATTACHMENT,	DEV_ENABLED,	0, 		"ch_sniper_kills", 			2, 		"mp_weapon_sniper",		"scope_10x",	"#MOD_SCOPE_10X_NAME",		"#MOD_SCOPE_10X_DESC",		"#MOD_SCOPE_10X_LONGDESC",				"../ui/menu/items/attachment_icons/scope_10x", 			"../ui/menu/items/attachment_icons/scope_10x" )
	// CreateAttachmentData( itemType.PILOT_PRIMARY_ATTACHMENT,	DEV_ENABLED,	0, 		"ch_sniper_kills", 			2, 		"mp_weapon_sniper",		"scope_12x",	"#MOD_SCOPE_12X_NAME",		"#MOD_SCOPE_12X_DESC",		"#MOD_SCOPE_12X_LONGDESC",				"../ui/menu/items/attachment_icons/scope_12x", 			"../ui/menu/items/attachment_icons/scope_12x" )


	/////////////////
	//PILOT MOD DATA
	/////////////////
	CreateModData( itemType.PILOT_PRIMARY_MOD,		DEV_ENABLED,	0, 	"ch_car_pilot_kills", 				1, 		"mp_weapon_car",			"integrated_gyro",				"#MOD_INTEGRATED_GYRO_NAME",	"#MOD_INTEGRATED_GYRO_DESC",		"#MOD_INTEGRATED_GYRO_LONGDESC",		0, 10, 0, 0, 0, 		"../ui/menu/items/mod_icons/counterweight", 		"../ui/menu/items/mod_icons/counterweight" )
	CreateModData( itemType.PILOT_PRIMARY_MOD,		DEV_ENABLED,	0, 	"ch_car_spectre_kills",			 	1, 		"mp_weapon_car",			"extended_ammo",				"#MOD_EXTENDED_MAG_NAME",		"#MOD_EXTENDED_MAG_DESC",			"#MOD_EXTENDED_MAG_LONGDESC",			0, 0, 0, 0, 10, 		"../ui/menu/items/mod_icons/extended_ammo", 		"../ui/menu/items/mod_icons/extended_ammo" )
	CreateModData( itemType.PILOT_PRIMARY_MOD,		DEV_ENABLED,	0, 	"ch_car_kills", 					1, 		"mp_weapon_car",			"silencer",						"#MOD_SILENCER_NAME",			"#MOD_SILENCER_DESC",				"#MOD_SILENCER_LONGDESC",				-5, -5, -2, 0, 0, 		"../ui/menu/items/mod_icons/silencer", 				"../ui/menu/items/mod_icons/silencer" )
	CreateModData( itemType.PILOT_PRIMARY_MOD,		DEV_ENABLED,	0, 	"ch_dmr_spectre_kills", 			0, 		"mp_weapon_dmr",			"extended_ammo",				"#MOD_EXTENDED_MAG_NAME",		"#MOD_EXTENDED_MAG_DESC",			"#MOD_EXTENDED_MAG_LONGDESC",			0, 0, 0, 0, 4, 			"../ui/menu/items/mod_icons/extended_ammo", 		"../ui/menu/items/mod_icons/extended_ammo" )
	CreateModData( itemType.PILOT_PRIMARY_MOD,		DEV_ENABLED,	0, 	"ch_dmr_kills", 					0, 		"mp_weapon_dmr",			"silencer",						"#MOD_SILENCER_NAME",			"#MOD_SILENCER_DESC",				"#MOD_SILENCER_LONGDESC",				-5, -5, -2, 0, 0, 		"../ui/menu/items/mod_icons/silencer", 				"../ui/menu/items/mod_icons/silencer" )
	CreateModData( itemType.PILOT_PRIMARY_MOD,		DEV_ENABLED,	0, 	"ch_dmr_pilot_kills", 				0, 		"mp_weapon_dmr",			"stabilizer",					"#MOD_STABILIZER_NAME",			"#MOD_STABILIZER_DESC",				"#MOD_STABILIZER_LONGDESC",				0, 6, 0, 0, 0, 			"../ui/menu/items/mod_icons/stabilizer", 			"../ui/menu/items/mod_icons/stabilizer" )
	CreateModData( itemType.PILOT_PRIMARY_MOD,		DEV_ENABLED,	0, 	"ch_g2_spectre_kills", 				1, 		"mp_weapon_g2",				"extended_ammo",				"#MOD_EXTENDED_MAG_NAME",		"#MOD_EXTENDED_MAG_DESC",			"#MOD_EXTENDED_MAG_LONGDESC",			0, 0, 0, 0, 4, 			"../ui/menu/items/mod_icons/extended_ammo", 		"../ui/menu/items/mod_icons/extended_ammo" )
	CreateModData( itemType.PILOT_PRIMARY_MOD,		DEV_ENABLED,	0, 	"ch_g2_pilot_kills", 				1, 		"mp_weapon_g2",				"match_trigger",				"#MOD_MATCH_TRIGGER_NAME",		"#MOD_MATCH_TRIGGER_DESC",			"#MOD_MATCH_TRIGGER_LONGDESC",			0, -8, 0, 10, -2, 		"../ui/menu/items/mod_icons/match_trigger", 		"../ui/menu/items/mod_icons/match_trigger" )
	CreateModData( itemType.PILOT_PRIMARY_MOD,		DEV_ENABLED,	0, 	"ch_g2_kills", 						1, 		"mp_weapon_g2",				"silencer",						"#MOD_SILENCER_NAME",			"#MOD_SILENCER_DESC",				"#MOD_SILENCER_LONGDESC",				-5, -5, -2, 0, 0, 		"../ui/menu/items/mod_icons/silencer", 				"../ui/menu/items/mod_icons/silencer" )
	CreateModData( itemType.PILOT_PRIMARY_MOD,		DEV_ENABLED,	0, 	"ch_hemlok_spectre_kills", 			1, 		"mp_weapon_hemlok",			"extended_ammo",				"#MOD_EXTENDED_MAG_NAME",		"#MOD_EXTENDED_MAG_DESC",			"#MOD_EXTENDED_MAG_LONGDESC",			0, 0, 0, 0, 6, 			"../ui/menu/items/mod_icons/extended_ammo", 		"../ui/menu/items/mod_icons/extended_ammo" )
	CreateModData( itemType.PILOT_PRIMARY_MOD,		DEV_ENABLED,	0, 	"ch_hemlok_kills", 					1, 		"mp_weapon_hemlok",			"silencer",						"#MOD_SILENCER_NAME",			"#MOD_SILENCER_DESC",				"#MOD_SILENCER_LONGDESC",				-5, 0, -10, 0, 0, 		"../ui/menu/items/mod_icons/silencer", 				"../ui/menu/items/mod_icons/silencer" )
	CreateModData( itemType.PILOT_PRIMARY_MOD,		DEV_ENABLED,	0, 	"ch_hemlok_pilot_kills", 			1, 		"mp_weapon_hemlok",			"starburst",					"#MOD_STARBURST_NAME",			"#MOD_STARBURST_DESC",				"#MOD_STARBURST_LONGDESC",				0, -5, 0, 10, 1, 		"../ui/menu/items/mod_icons/starburst", 			"../ui/menu/items/mod_icons/starburst" )
	CreateModData( itemType.PILOT_PRIMARY_MOD,		DEV_ENABLED,	0, 	"ch_lmg_spectre_kills", 			1, 		"mp_weapon_lmg",			"extended_ammo",				"#MOD_EXTENDED_MAG_NAME",		"#MOD_EXTENDED_MAG_DESC",			"#MOD_EXTENDED_MAG_LONGDESC",			0, 0, 0, 0, 16, 		"../ui/menu/items/mod_icons/extended_ammo", 		"../ui/menu/items/mod_icons/extended_ammo" )
	CreateModData( itemType.PILOT_PRIMARY_MOD,		DEV_ENABLED,	0, 	"ch_lmg_pilot_kills", 				1, 		"mp_weapon_lmg",			"slammer",						"#MOD_SLAMMER_NAME",			"#MOD_SLAMMER_DESC",				"#MOD_SLAMMER_LONGDESC",				10, 0, 0, 0, 0, 		"../ui/menu/items/mod_icons/slammer", 				"../ui/menu/items/mod_icons/slammer" )
	CreateModData( itemType.PILOT_PRIMARY_MOD,		DEV_ENABLED,	0, 	"ch_r97_spectre_kills", 			1, 		"mp_weapon_r97",			"extended_ammo",				"#MOD_EXTENDED_MAG_NAME",		"#MOD_EXTENDED_AMMO_DESC",			"#MOD_EXTENDED_AMMO_LONGDESC",			0, 0, 0, 0, 10, 		"../ui/menu/items/mod_icons/extended_ammo", 		"../ui/menu/items/mod_icons/extended_ammo" )
	CreateModData( itemType.PILOT_PRIMARY_MOD,		DEV_ENABLED,	0, 	"ch_r97_pilot_kills", 				1, 		"mp_weapon_r97",			"scatterfire",					"#MOD_SCATTERFIRE_NAME",		"#MOD_SCATTERFIRE_DESC",			"#MOD_SCATTERFIRE_LONGDESC",			0, -15, 0, 10, 0, 		"../ui/menu/items/mod_icons/scatterfire", 			"../ui/menu/items/mod_icons/scatterfire" )
	CreateModData( itemType.PILOT_PRIMARY_MOD,		DEV_ENABLED,	0, 	"ch_r97_kills", 					1, 		"mp_weapon_r97",			"silencer",						"#MOD_SILENCER_NAME",			"#MOD_SILENCER_DESC",				"#MOD_SILENCER_LONGDESC",				-5, -5, -5, 0, 0, 		"../ui/menu/items/mod_icons/silencer", 				"../ui/menu/items/mod_icons/silencer" )
	CreateModData( itemType.PILOT_PRIMARY_MOD,		DEV_ENABLED,	0, 	"ch_rspn101_spectre_kills", 		1, 		"mp_weapon_rspn101",		"extended_ammo",				"#MOD_EXTENDED_MAG_NAME",		"#MOD_EXTENDED_MAG_DESC",			"#MOD_EXTENDED_MAG_LONGDESC",			0, 0, 0, 0, 6, 			"../ui/menu/items/mod_icons/extended_ammo", 		"../ui/menu/items/mod_icons/extended_ammo" )
	CreateModData( itemType.PILOT_PRIMARY_MOD,		DEV_DISABLED,	0, 	null, 								null, 	"mp_weapon_rspn101",		"recoil_compensator",			"#MOD_RECOIL_COMPENSATOR_NAME",	"#MOD_RECOIL_COMPENSATOR_DESC",		"#MOD_RECOIL_COMPENSATOR_LONGDESC",		0, 0, 0, 0, 0, 			"../ui/menu/items/mod_icons/recoil_compensator",	"../ui/menu/items/mod_icons/recoil_compensator",	HideFromMenus )
	CreateModData( itemType.PILOT_PRIMARY_MOD,		DEV_ENABLED,	0, 	"ch_rspn101_kills", 				1, 		"mp_weapon_rspn101",		"silencer",						"#MOD_SILENCER_NAME",			"#MOD_SILENCER_DESC",				"#MOD_SILENCER_LONGDESC",				-5, 0, -5, 0, 0, 		"../ui/menu/items/mod_icons/silencer", 				"../ui/menu/items/mod_icons/silencer" )
	CreateModData( itemType.PILOT_PRIMARY_MOD,		DEV_ENABLED,	0, 	"ch_shotgun_spectre_kills",			1, 		"mp_weapon_shotgun",		"extended_ammo", 				"#MOD_EXTENDED_DRUM_NAME",		"#MOD_EXTENDED_MAG_DESC",			"#MOD_EXTENDED_MAG_LONGDESC",			0, 0, 0, 0, 3, 			"../ui/menu/items/mod_icons/high_capacity_drum", 	"../ui/menu/items/mod_icons/high_capacity_drum" )
	CreateModData( itemType.PILOT_PRIMARY_MOD,		DEV_ENABLED,	0, 	"ch_shotgun_pilot_kills",			1, 		"mp_weapon_shotgun",		"spread_increase_sg",			"#MOD_SPREAD_INCREASE_SG_NAME",	"#MOD_SPREAD_INCREASE_SG_DESC",		"#MOD_SPREAD_INCREASE_SG_LONGDESC",		-10, 10, 0, 0, 0, 		"../ui/menu/items/mod_icons/leadwall", 				"../ui/menu/items/mod_icons/leadwall" )
	CreateModData( itemType.PILOT_PRIMARY_MOD,		DEV_ENABLED,	0, 	"ch_shotgun_kills", 				1, 		"mp_weapon_shotgun",		"silencer",						"#MOD_SILENCER_NAME",			"#MOD_SILENCER_DESC",				"#MOD_SILENCER_LONGDESC",				-5, 5, -5, 0, 0, 		"../ui/menu/items/mod_icons/silencer", 				"../ui/menu/items/mod_icons/silencer" )
	CreateModData( itemType.PILOT_PRIMARY_MOD,		DEV_ENABLED,	0, 	"ch_smart_pistol_pilot_kills", 		1, 		"mp_weapon_smart_pistol",	"enhanced_targeting",			"#MOD_ENHANCED_TARGETING_NAME",	"#MOD_ENHANCED_TARGETING_DESC",		"#MOD_ENHANCED_TARGETING_LONGDESC",		0, 0, 10, 5, 0, 		"../ui/menu/items/mod_icons/enhanced_targeting", 	"../ui/menu/items/mod_icons/enhanced_targeting" )
	CreateModData( itemType.PILOT_PRIMARY_MOD,		DEV_ENABLED,	0, 	"ch_smart_pistol_spectre_kills", 	2, 		"mp_weapon_smart_pistol",	"extended_ammo",				"#MOD_EXTENDED_MAG_NAME",		"#MOD_EXTENDED_MAG_DESC",			"#MOD_EXTENDED_MAG_LONGDESC",			0, 0, 0, 0, 6, 			"../ui/menu/items/mod_icons/extended_ammo", 		"../ui/menu/items/mod_icons/extended_ammo" )
	CreateModData( itemType.PILOT_PRIMARY_MOD,		DEV_ENABLED,	0, 	"ch_smart_pistol_kills", 			1, 		"mp_weapon_smart_pistol",	"silencer", 					"#MOD_SILENCER_NAME",			"#MOD_SILENCER_DESC",				"#MOD_SILENCER_LONGDESC",				-10, 0, 0, -5, 0, 		"../ui/menu/items/mod_icons/silencer", 				"../ui/menu/items/mod_icons/silencer" )
	CreateModData( itemType.PILOT_PRIMARY_MOD,		DEV_ENABLED,	0, 	"ch_sniper_spectre_kills", 			0, 		"mp_weapon_sniper",			"extended_ammo",				"#MOD_EXTENDED_MAG_NAME",		"#MOD_EXTENDED_MAG_DESC",			"#MOD_EXTENDED_MAG_LONGDESC",			0, 0, 0, 0, 1, 			"../ui/menu/items/mod_icons/extended_ammo", 		"../ui/menu/items/mod_icons/extended_ammo" )
	CreateModData( itemType.PILOT_PRIMARY_MOD,		DEV_ENABLED,	0, 	"ch_sniper_kills", 					0, 		"mp_weapon_sniper",			"silencer",						"#MOD_SILENCER_NAME",			"#MOD_SILENCER_DESC",				"#MOD_SILENCER_LONGDESC",				-10, 0, -5, 0, 0, 		"../ui/menu/items/mod_icons/silencer", 				"../ui/menu/items/mod_icons/silencer" )
	CreateModData( itemType.PILOT_PRIMARY_MOD,		DEV_ENABLED,	0, 	"ch_sniper_pilot_kills", 			0, 		"mp_weapon_sniper",			"stabilizer",					"#MOD_STABILIZER_NAME",			"#MOD_STABILIZER_DESC",				"#MOD_STABILIZER_LONGDESC",				0, 6, 0, 0, 0, 			"../ui/menu/items/mod_icons/stabilizer", 			"../ui/menu/items/mod_icons/stabilizer" )


	/////////////////////
	//BURN CARD MOD DATA
	/////////////////////

	CreateModData( itemType.PILOT_PRIMARY_MOD,		DEV_DISABLED,	0, 	null, 	null, "mp_weapon_car",				"burn_mod_car", 				"#BC_CAR_M2",				"#BC_CAR_M2_FLYOUT_DESC",				"#BC_CAR_M2_FLYOUT_DESC",				0, 0, 0, 0, 0,	 	"../ui/temp",	"../ui/temp",	HideFromMenus )
	CreateModData( itemType.PILOT_PRIMARY_MOD,		DEV_DISABLED,	0, 	null, 	null, "mp_weapon_dmr",				"burn_mod_dmr", 				"#BC_DMR_M2",				"#BC_DMR_M2_FLYOUT_DESC",				"#BC_DMR_M2_FLYOUT_DESC",				0, 0, 0, 0, 0,	 	"../ui/temp",	"../ui/temp",	HideFromMenus )
	CreateModData( itemType.PILOT_PRIMARY_MOD,		DEV_DISABLED,	0, 	null, 	null, "mp_weapon_g2",				"burn_mod_g2", 					"#BC_G2_M2",				"#BC_G2_M2_FLYOUT_DESC",				"#BC_G2_M2_FLYOUT_DESC",				0, 0, 0, 0, 0,	 	"../ui/temp",	"../ui/temp",	HideFromMenus )
	CreateModData( itemType.PILOT_PRIMARY_MOD,		DEV_DISABLED,	0, 	null, 	null, "mp_weapon_hemlok",			"burn_mod_hemlok", 				"#BC_HEMLOK_M2",			"#BC_HEMLOK_M2_FLYOUT_DESC",			"#BC_HEMLOK_M2_FLYOUT_DESC",			0, 0, 0, 0, 0,	 	"../ui/temp",	"../ui/temp",	HideFromMenus )
	CreateModData( itemType.PILOT_PRIMARY_MOD,		DEV_DISABLED,	0, 	null, 	null, "mp_weapon_lmg",				"burn_mod_lmg", 				"#BC_LMG_M2",				"#BC_LMG_M2_FLYOUT_DESC",				"#BC_LMG_M2_FLYOUT_DESC",				0, 0, 0, 0, 0,	 	"../ui/temp",	"../ui/temp",	HideFromMenus )
	CreateModData( itemType.PILOT_PRIMARY_MOD,		DEV_DISABLED,	0, 	null, 	null, "mp_weapon_r97",				"burn_mod_r97", 				"#BC_R97_M2",				"#BC_R97_M2_FLYOUT_DESC",				"#BC_R97_M2_FLYOUT_DESC",				0, 0, 0, 0, 0,	 	"../ui/temp",	"../ui/temp",	HideFromMenus )
	CreateModData( itemType.PILOT_PRIMARY_MOD,		DEV_DISABLED,	0, 	null, 	null, "mp_weapon_rspn101",			"burn_mod_rspn101", 			"#BC_RSPN101_M2",			"#BC_RSPN101_M2_FLYOUT_DESC",			"#BC_RSPN101_M2_FLYOUT_DESC",			0, 0, 0, 0, 0,	 	"../ui/temp",	"../ui/temp",	HideFromMenus )
	CreateModData( itemType.PILOT_PRIMARY_MOD,		DEV_DISABLED,	0, 	null, 	null, "mp_weapon_shotgun",			"burn_mod_shotgun", 			"#BC_SHOTGUN_M2",			"#BC_SHOTGUN_M2_FLYOUT_DESC",			"#BC_SHOTGUN_M2_FLYOUT_DESC",			0, 0, 0, 0, 0,	 	"../ui/temp",	"../ui/temp",	HideFromMenus )
	CreateModData( itemType.PILOT_PRIMARY_MOD,		DEV_DISABLED,	0, 	null, 	null, "mp_weapon_smart_pistol",		"burn_mod_smart_pistol", 		"#BC_SMART_PISTOL_M2",		"#BC_SMART_PISTOL_M2_FLYOUT_DESC",		"#BC_SMART_PISTOL_M2_FLYOUT_DESC",		0, 0, 0, 0, 0,	 	"../ui/temp",	"../ui/temp",	HideFromMenus )
	CreateModData( itemType.PILOT_PRIMARY_MOD,		DEV_DISABLED,	0, 	null, 	null, "mp_weapon_sniper",			"burn_mod_sniper", 				"#BC_SNIPER_M2",			"#BC_SNIPER_M2_FLYOUT_DESC",			"#BC_SNIPER_M2_FLYOUT_DESC",			0, 0, 0, 0, 0,	 	"../ui/temp",	"../ui/temp",	HideFromMenus )
	CreateModData( itemType.PILOT_SIDEARM_MOD,		DEV_DISABLED,	0, 	null, 	null, "mp_weapon_wingman",			"burn_mod_wingman",				"#BC_WINGMAN_M2",			"#BC_WINGMAN_M2_FLYOUT_DESC",			"#BC_WINGMAN_M2_FLYOUT_DESC",			0, 0, 0, 0, 0,	 	"../ui/temp",	"../ui/temp",	HideFromMenus )
	CreateModData( itemType.PILOT_SECONDARY_MOD,	DEV_DISABLED,	0, 	null, 	null, "mp_weapon_mgl",				"burn_mod_mgl",					"#BC_MGL_M2", 				"#BC_MGL_M2_FLYOUT_DESC",				"#BC_MGL_M2_FLYOUT_DESC",				0, 0, 0, 0, 0,	 	"../ui/temp",	"../ui/temp",	HideFromMenus )
	CreateModData( itemType.PILOT_SECONDARY_MOD,	DEV_DISABLED,	0, 	null, 	null, "mp_weapon_rocket_launcher",	"burn_mod_rocket_launcher",		"#BC_ROCKET_LAUNCHER_M2",	"#BC_ROCKET_LAUNCHER_M2_FLYOUT_DESC",	"#BC_ROCKET_LAUNCHER_M2_FLYOUT_DESC",	0, 0, 0, 0, 0,	 	"../ui/temp",	"../ui/temp",	HideFromMenus )
	CreateModData( itemType.PILOT_SECONDARY_MOD,	DEV_DISABLED,	0, 	null, 	null, "mp_weapon_smr",				"burn_mod_smr",					"#BC_SMR_M2",				"#BC_SMR_M2_FLYOUT_DESC",				"#BC_SMR_M2_FLYOUT_DESC",				0, 0, 0, 0, 0,	 	"../ui/temp",	"../ui/temp",	HideFromMenus )
	CreateModData( itemType.PILOT_SECONDARY_MOD,	DEV_DISABLED,	0, 	null, 	null, "mp_weapon_defender",			"burn_mod_defender",			"#BC_DEFENDER_M2",			"#BC_DEFENDER_M2_FLYOUT_DESC",			"#BC_DEFENDER_M2_FLYOUT_DESC",			0, 0, 0, 0, 0,	 	"../ui/temp",	"../ui/temp",	HideFromMenus )
	CreateModData( itemType.PILOT_SIDEARM_MOD,		DEV_DISABLED,	0, 	null, 	null, "mp_weapon_autopistol",		"burn_mod_autopistol",			"#BC_AUTOPISTOL_M2",		"#BC_AUTOPISTOL_M2_FLYOUT_DESC",		"#BC_AUTOPISTOL_M2_FLYOUT_DESC",		0, 0, 0, 0, 0,	 	"../ui/temp",	"../ui/temp",	HideFromMenus )
	CreateModData( itemType.PILOT_SIDEARM_MOD,		DEV_DISABLED,	0, 	null, 	null, "mp_weapon_semipistol",		"burn_mod_semipistol", 			"#BC_SEMIPISTOL_M2",		"#BC_SEMIPISTOL_M2_FLYOUT_DESC",		"#BC_SEMIPISTOL_M2_FLYOUT_DESC",		0, 0, 0, 0, 0,	 	"../ui/temp",	"../ui/temp",	HideFromMenus )
	CreateModData( itemType.PILOT_ORDNANCE_MOD,		DEV_DISABLED,	0, 	null, 	null, "mp_weapon_satchel",			"burn_mod_satchel",				"#BC_SATCHEL_M2",			"#BC_SATCHEL_M2_FLYOUT_DESC",			"#BC_SATCHEL_M2_FLYOUT_DESC",			0, 0, 0, 0, 0,	 	"../ui/temp",	"../ui/temp",	HideFromMenus )
	CreateModData( itemType.PILOT_ORDNANCE_MOD,		DEV_DISABLED,	0, 	null, 	null, "mp_weapon_frag_grenade",		"burn_mod_frag_grenade",		"#BC_FRAG_GRENADE_M2",		"#BC_FRAG_GRENADE_M2_FLYOUT_DESC",		"#BC_FRAG_GRENADE_M2_FLYOUT_DESC",		0, 0, 0, 0, 0,	 	"../ui/temp",	"../ui/temp",	HideFromMenus )
	CreateModData( itemType.PILOT_ORDNANCE_MOD,		DEV_DISABLED,	0, 	null, 	null, "mp_weapon_grenade_emp",		"burn_mod_grenade_emp",			"#BC_EMP_GRENADE_M2",		"#BC_EMP_GRENADE_M2_FLYOUT_DESC",		"#BC_EMP_GRENADE_M2_FLYOUT_DESC",		0, 0, 0, 0, 0,	 	"../ui/temp",	"../ui/temp",	HideFromMenus )
	CreateModData( itemType.PILOT_ORDNANCE_MOD,		DEV_DISABLED,	0, 	null, 	null, "mp_weapon_proximity_mine",	"burn_mod_proximity_mine",		"#BC_PROXIMITY_MINE_M2",	"#BC_PROXIMITY_MINE_M2_FLYOUT_DESC",	"#BC_PROXIMITY_MINE_M2_FLYOUT_DESC",	0, 0, 0, 0, 0,	 	"../ui/temp",	"../ui/temp",	HideFromMenus )


	/////////////////////
	//PILOT PASSIVE DATA
	/////////////////////
	CreatePassiveData( itemType.PILOT_PASSIVE1, 	DEV_ENABLED,	0,		null, 	null, "pas_power_cell",			"#GEAR_POWER_CELL",					"#GEAR_POWER_CELL_DESC",			"#GEAR_POWER_CELL_LONGDESC",			"../ui/menu/items/passive_icons/power_cell",			"../ui/menu/items/passive_icons/power_cell" )
	CreatePassiveData( itemType.PILOT_PASSIVE1, 	DEV_ENABLED,	0, 		null, 	null, "pas_run_and_gun",		"#GEAR_RUNGUN_KIT",					"#GEAR_RUNGUN_KIT_DESC",			"#GEAR_RUNGUN_KIT_LONGDESC",			"../ui/menu/items/passive_icons/run_and_gun",			"../ui/menu/items/passive_icons/run_and_gun" )
	CreatePassiveData( itemType.PILOT_PASSIVE1, 	DEV_ENABLED,	0, 		null, 	null, "pas_stealth_movement",	"#GEAR_STEALTH_KIT",				"#GEAR_STEALTH_KIT_DESC",			"#GEAR_STEALTH_KIT_LONGDESC",			"../ui/menu/items/passive_icons/stealth_movement",		"../ui/menu/items/passive_icons/stealth_movement" )
	CreatePassiveData( itemType.PILOT_PASSIVE1, 	DEV_ENABLED,	0,		null, 	null, "pas_ordnance_pack",		"#GEAR_EXPLOSIVES_PACK",			"#GEAR_EXPLOSIVES_PACK_DESC",		"#GEAR_EXPLOSIVES_PACK_LONGDESC",		"../ui/menu/items/passive_icons/ordnance_pack",			"../ui/menu/items/passive_icons/ordnance_pack" )
	CreatePassiveData( itemType.PILOT_PASSIVE1, 	DEV_ENABLED,	0,		null, 	null, "pas_wall_runner",		"#GEAR_PARKOUR_KIT",				"#GEAR_PARKOUR_KIT_DESC",			"#GEAR_PARKOUR_KIT_LONGDESC",			"../ui/menu/items/passive_icons/wall_runner", 			"../ui/menu/items/passive_icons/wall_runner" )
	CreatePassiveData( itemType.PILOT_PASSIVE1, 	DEV_ENABLED,	0, 		null, 	null, "pas_fast_reload",		"#GEAR_QUICK_RELOAD",				"#GEAR_QUICK_RELOAD_DESC",			"#GEAR_QUICK_RELOAD_LONGDESC",			"../ui/menu/items/passive_icons/fast_reload", 			"../ui/menu/items/passive_icons/fast_reload" )

	CreatePassiveData( itemType.PILOT_PASSIVE2, 	DEV_ENABLED,	0, 		null, 	null, "pas_enhanced_titan_ai",	"#GEAR_GUARDIAN_CHIP",				"#GEAR_GUARDIAN_CHIP_DESC",			"#GEAR_GUARDIAN_CHIP_LONGDESC",			"../ui/menu/items/passive_icons/enhanced_titan_ai",		"../ui/menu/items/passive_icons/enhanced_titan_ai" )
	CreatePassiveData( itemType.PILOT_PASSIVE2,		DEV_ENABLED,	0, 		null, 	null, "pas_longer_bubble",		"#GEAR_HIGH_CAP_SHIELD",			"#GEAR_HIGH_CAP_SHIELD_DESC",		"#GEAR_HIGH_CAP_SHIELD_LONGDESC",		"../ui/menu/items/passive_icons/longer_bubble",			"../ui/menu/items/passive_icons/longer_bubble" )
	CreatePassiveData( itemType.PILOT_PASSIVE2, 	DEV_ENABLED,	0, 		null, 	null, "pas_minimap_ai", 		"#GEAR_AI_DETECTION",				"#GEAR_AI_DETECTION_DESC",			"#GEAR_AI_DETECTION_LONGDESC",			"../ui/menu/items/passive_icons/minimap_ai",			"../ui/menu/items/passive_icons/minimap_ai" )
	CreatePassiveData( itemType.PILOT_PASSIVE2, 	DEV_ENABLED,	0,		null, 	null, "pas_dead_mans_trigger",	"#GEAR_DEAD_MANS_TRIGGER",			"#GEAR_DEAD_MANS_TRIGGER_DESC",		"#GEAR_DEAD_MANS_TRIGGER_LONGDESC",		"../ui/menu/items/passive_icons/dead_mans_trigger",		"../ui/menu/items/passive_icons/dead_mans_trigger" )
	CreatePassiveData( itemType.PILOT_PASSIVE2, 	DEV_ENABLED,	0,		null, 	null, "pas_turbo_drop",			"#GEAR_WARPFALL",					"#GEAR_WARPFALL_DESC",				"#GEAR_WARPFALL_LONGDESC",				"../ui/menu/items/passive_icons/turbo_drop",			"../ui/menu/items/passive_icons/turbo_drop" )
	CreatePassiveData( itemType.PILOT_PASSIVE2,		DEV_ENABLED,	0, 		null, 	null, "pas_fast_hack",			"#GEAR_ICEPICK",					"#GEAR_ICEPICK_DESC",				"#GEAR_ICEPICK_LONGDESC",				"../ui/menu/items/passive_icons/icepick",				"../ui/menu/items/passive_icons/icepick" )

	CreateGenderData( itemType.RACE, 				DEV_ENABLED,	0,		null, 	null, "race_human_male" )
	CreateGenderData( itemType.RACE,				DEV_ENABLED,	0, 		null, 	null, "race_human_female" )

	////////////////////
	//TITAN WEAPON DATA
	////////////////////
	CreateWeaponData( itemType.TITAN_PRIMARY, 		DEV_ENABLED,	0, 		null, 	null, "mp_titanweapon_xo16", 				"../ui/menu/items/titanweapon_xo16" )
	CreateWeaponData( itemType.TITAN_PRIMARY, 		DEV_ENABLED,	0, 		null, 	null, "mp_titanweapon_40mm", 				"../ui/menu/items/titanweapon_40mm" )
	CreateWeaponData( itemType.TITAN_PRIMARY, 		DEV_ENABLED,	0, 		null, 	null, "mp_titanweapon_rocket_launcher",		"../ui/menu/items/titanweapon_rocketlauncher" )
	CreateWeaponData( itemType.TITAN_PRIMARY, 		DEV_ENABLED,	0, 		null, 	null, "mp_titanweapon_sniper", 				"../ui/menu/items/titanweapon_sniper" )
	CreateWeaponData( itemType.TITAN_PRIMARY, 		DEV_ENABLED,	0, 		null, 	null, "mp_titanweapon_triple_threat",		"../ui/menu/items/titanweapon_triplethreat" )
	CreateWeaponData( itemType.TITAN_PRIMARY, 		DEV_ENABLED,	0, 		null, 	null, "mp_titanweapon_arc_cannon",			"../ui/menu/items/titanweapon_arccannon" )

	CreateWeaponData( itemType.TITAN_ORDNANCE,		DEV_ENABLED,	0,		null, 	null, "mp_titanweapon_salvo_rockets", 		"../ui/menu/items/titanweapon_salvo_rockets",			"../ui/menu/items/ability_icons/salvo_rockets",		"../ui/menu/items/titanweapon_salvo_rockets" )
	CreateWeaponData( itemType.TITAN_ORDNANCE,		DEV_ENABLED,	0,		null, 	null, "mp_titanweapon_homing_rockets", 		"../ui/menu/items/titanweapon_auto_targeting_missles",	"../ui/menu/items/ability_icons/homing_rockets",	"../ui/menu/items/titanweapon_auto_targeting_missles" )
	CreateWeaponData( itemType.TITAN_ORDNANCE,		DEV_ENABLED,	0, 		null, 	null, "mp_titanweapon_dumbfire_rockets", 	"../ui/menu/items/titanweapon_cluster_rocket",			"../ui/menu/items/ability_icons/cluster_rocket",	"../ui/menu/items/titanweapon_cluster_rocket" )
	CreateWeaponData( itemType.TITAN_ORDNANCE,		DEV_ENABLED,	0,		null, 	null, "mp_titanweapon_shoulder_rockets", 	"../ui/menu/items/titanweapon_shoulder_rockets",		"../ui/menu/items/ability_icons/shoulder_rockets", 	"../ui/menu/items/titanweapon_shoulder_rockets" )

	CreateWeaponData( itemType.TITAN_SPECIAL,		DEV_ENABLED,	0, 		null, 	null, "mp_titanweapon_vortex_shield",		"../ui/menu/items/ability_icons/vortex",			"../ui/menu/items/ability_icons/vortex" )
	CreateWeaponData( itemType.TITAN_SPECIAL,		DEV_ENABLED,	0, 		null, 	null, "mp_titanability_smoke", 				"../ui/menu/items/ability_icons/smoke",				"../ui/menu/items/ability_icons/smoke" )
	CreateWeaponData( itemType.TITAN_SPECIAL, 		DEV_ENABLED,	0,		null, 	null, "mp_titanability_bubble_shield", 		"../ui/menu/items/ability_icons/bubble_shield",		"../ui/menu/items/ability_icons/bubble_shield" )

	CreateWeaponData( itemType.NOT_LOADOUT, 		DEV_ENABLED,	0,		null, 	null, "mp_titanability_fusion_core", 		"../ui/temp" )

	/////////////////
	//TITAN MOD DATA
	/////////////////
	CreateModData( itemType.TITAN_PRIMARY_MOD,		DEV_ENABLED,	0, 	"ch_40mm_titan_kills", 				1, 		"mp_titanweapon_40mm",				"burst",				"#MOD_BURST_NAME",					"#MOD_BURST_TRIPLE_DESC",			"#MOD_BURST_TRIPLE_LONGDESC",			-20, -5, 0, 10, 9, 		"../ui/menu/items/mod_icons/burst", 				"../ui/menu/items/mod_icons/burst" )
	CreateModData( itemType.TITAN_PRIMARY_MOD,	 	DEV_ENABLED,	0, 	"ch_40mm_kills", 					1, 		"mp_titanweapon_40mm",				"extended_ammo",		"#MOD_EXTENDED_MAG_NAME",			"#MOD_EXTENDED_MAG_DESC",			"#MOD_EXTENDED_MAG_LONGDESC",			0, 0, 0, 0, 4, 		"../ui/menu/items/mod_icons/extended_ammo", 		"../ui/menu/items/mod_icons/extended_ammo" )
	CreateModData( itemType.TITAN_PRIMARY_MOD,	 	DEV_DISABLED,	0, 	null, 								null, 	"mp_titanweapon_40mm",				"fast_reload",			"#MOD_FAST_RELOAD_NAME",			"#MOD_FAST_RELOAD_DESC",			"#MOD_FAST_RELOAD_LONGDESC",			0, 0, 0, 0, 0, 		"../ui/menu/items/mod_icons/fast_reload",	 		"../ui/menu/items/mod_icons/fast_reload",	HideFromMenus)
	CreateModData( itemType.TITAN_PRIMARY_MOD,		DEV_ENABLED,	0, 	"ch_arc_cannon_titan_kills", 		1, 		"mp_titanweapon_arc_cannon",		"capacitor",			"#MOD_CAPACITOR_NAME", 				"#MOD_CAPACITOR_DESC",				"#MOD_CAPACITOR_LONGDESC",				5, 5, 0, -5, 0, 		"../ui/menu/items/mod_icons/capacitor", 			"../ui/menu/items/mod_icons/capacitor" )
	//CreateModData( itemType.TITAN_PRIMARY_MOD,	DEV_DISABLED,	0, 	null, 								null, 	"mp_titanweapon_arc_cannon",		"overcharge",			"#MOD_OVERCHARGE_NAME", 			"#MOD_OVERCHARGE_DESC",				"#MOD_OVERCHARGE_LONGDESC",				0, 0, 0, 0, 0, 		"../ui/menu/items/mod_icons/overcharge",	 		"../ui/menu/items/mod_icons/overcharge",	HideFromMenus )
	CreateModData( itemType.TITAN_PRIMARY_MOD,	 	DEV_ENABLED,	0, 	null, 								null, 	"mp_titanweapon_rocket_launcher",	"afterburners",			"#MOD_AFTERBURNERS_NAME",			"#MOD_AFTERBURNERS_DESC",			"#MOD_AFTERBURNERS_LONGDESC",			0, 0, 0, 0, 0, 		"../ui/menu/items/mod_icons/afterburners",	 		"../ui/menu/items/mod_icons/afterburners" )
	CreateModData( itemType.TITAN_PRIMARY_MOD,	 	DEV_ENABLED,	0, 	"ch_rocket_launcher_kills",		 	1, 		"mp_titanweapon_rocket_launcher",	"extended_ammo",		"#MOD_EXTENDED_MAG_NAME",			"#MOD_EXTENDED_MAG_DESC",			"#MOD_EXTENDED_MAG_LONGDESC",			0, 0, 0, 0, 1, 		"../ui/menu/items/mod_icons/extended_ammo", 		"../ui/menu/items/mod_icons/extended_ammo" )
	CreateModData( itemType.TITAN_PRIMARY_MOD,	 	DEV_ENABLED,	0, 	"ch_rocket_launcher_titan_kills", 	1, 		"mp_titanweapon_rocket_launcher",	"rapid_fire_missiles",	"#MOD_RAPID_FIRE_MISSILES_NAME",	"#MOD_RAPID_FIRE_MISSILES_DESC",	"#MOD_RAPID_FIRE_MISSILES_LONGDESC",	-30, 5, 0, 10, 13, 		"../ui/menu/items/mod_icons/rapid_fire_missiles", 	"../ui/menu/items/mod_icons/rapid_fire_missiles" )
	CreateModData( itemType.TITAN_PRIMARY_MOD,	 	DEV_ENABLED,	0, 	"ch_titan_sniper_kills", 			1, 		"mp_titanweapon_sniper",			"extended_ammo",		"#MOD_EXTENDED_MAG_NAME",			"#MOD_EXTENDED_MAG_DESC",			"#MOD_EXTENDED_MAG_LONGDESC",			0, 0, 0, 0, 1, 		"../ui/menu/items/mod_icons/extended_ammo", 		"../ui/menu/items/mod_icons/extended_ammo" )
	CreateModData( itemType.TITAN_PRIMARY_MOD,	 	DEV_DISABLED,	0, 	null, 								null, 	"mp_titanweapon_sniper",			"fast_reload",			"#MOD_FAST_RELOAD_NAME",			"#MOD_FAST_RELOAD_DESC",			"#MOD_FAST_RELOAD_LONGDESC",			0, 0, 0, 0, 0, 		"../ui/menu/items/mod_icons/fast_reload",	 		"../ui/menu/items/mod_icons/fast_reload",	HideFromMenus )
	CreateModData( itemType.TITAN_PRIMARY_MOD,	 	DEV_ENABLED,	0, 	"ch_titan_sniper_titan_kills", 		0, 		"mp_titanweapon_sniper",			"instant_shot",			"#MOD_INSTANT_SHOT_NAME",			"#MOD_INSTANT_SHOT_DESC",			"#MOD_INSTANT_SHOT_LONGDESC",			-40, 0, 0, 30, 1, 		"../ui/menu/items/mod_icons/instant_shot", 			"../ui/menu/items/mod_icons/instant_shot" )
	CreateModData( itemType.TITAN_PRIMARY_MOD,	 	DEV_DISABLED,	0, 	null, 								null, 	"mp_titanweapon_sniper",			"quick_shot",			"#MOD_QUICK_SHOT_NAME",				"#MOD_QUICK_SHOT_DESC",				"#MOD_QUICK_SHOT_LONGDESC",				0, 0, 0, 0, 0, 		"../ui/menu/items/mod_icons/quick_shot",	 		"../ui/menu/items/mod_icons/quick_shot",	HideFromMenus )
	CreateModData( itemType.TITAN_PRIMARY_MOD,	 	DEV_ENABLED,	0, 	"ch_triple_threat_kills",		 	1, 		"mp_titanweapon_triple_threat",		"extended_ammo",		"#MOD_EXTENDED_MAG_NAME",			"#MOD_EXTENDED_MAG_DESC",			"#MOD_EXTENDED_MAG_LONGDESC",			0, 0, 0, 0, 3, 		"../ui/menu/items/mod_icons/extended_ammo", 		"../ui/menu/items/mod_icons/extended_ammo" )
	CreateModData( itemType.TITAN_PRIMARY_MOD,	 	DEV_ENABLED,	0, 	"ch_triple_threat_titan_kills", 	1, 		"mp_titanweapon_triple_threat",		"mine_field",			"#MOD_MINE_FIELD_NAME",				"#MOD_MINE_FIELD_DESC",				"#MOD_MINE_FIELD_LONGDESC",				0, 10, -5, 0, 0, 		"../ui/menu/items/mod_icons/mine_field", 			"../ui/menu/items/mod_icons/mine_field" )
	CreateModData( itemType.TITAN_PRIMARY_MOD,	 	DEV_DISABLED,	0, 	null, 								null, 		"mp_titanweapon_triple_threat",		"arc_triple_threat",	"#MOD_ARC_TRIPLE_THREAT_NAME",		"#MOD_ARC_TRIPLE_THREAT_DESC",		"#MOD_ARC_TRIPLE_THREAT_LONGDESC",		0, 10, -5, 0, 0, 		"../ui/menu/items/mod_icons/mine_field", 			"../ui/menu/items/mod_icons/mine_field",	HideFromMenus  )
	CreateModData( itemType.TITAN_PRIMARY_MOD,	 	DEV_ENABLED,	0, 	"ch_xo16_titan_kills", 				1, 		"mp_titanweapon_xo16",				"accelerator",			"#MOD_ACCELERATOR_NAME",			"#MOD_ACCELERATOR_DESC",			"#MOD_ACCELERATOR_LONGDESC",			0, -15, 0, 10, 90, 		"../ui/menu/items/mod_icons/accelerator_v2", 			"../ui/menu/items/mod_icons/accelerator_v2" )
	CreateModData( itemType.TITAN_PRIMARY_MOD,	 	DEV_ENABLED,	0, 	null, 								null, 	"mp_titanweapon_xo16",				"burst",				"#MOD_BURST_NAME",					"#MOD_BURST_LONGBURST_DESC",		"#MOD_BURST_LONGBURST_LONGDESC",		0, 0, 0, 0, 0, 		"../ui/menu/items/mod_icons/burst",	 				"../ui/menu/items/mod_icons/burst" )
	CreateModData( itemType.TITAN_PRIMARY_MOD,	 	DEV_ENABLED,	0, 	"ch_xo16_kills", 					1, 		"mp_titanweapon_xo16",				"extended_ammo",		"#MOD_EXTENDED_MAG_NAME",			"#MOD_EXTENDED_AMMO_DESC",			"#MOD_EXTENDED_AMMO_LONGDESC",			0, 0, 0, 0, 30, 		"../ui/menu/items/mod_icons/extended_ammo", 		"../ui/menu/items/mod_icons/extended_ammo" )
	CreateModData( itemType.TITAN_PRIMARY_MOD,	 	DEV_DISABLED,	0, 	null, 								null, 	"mp_titanweapon_xo16",				"fast_reload",			"#MOD_FAST_RELOAD_NAME",			"#MOD_FAST_RELOAD_DESC",			"#MOD_FAST_RELOAD_LONGDESC",			0, 0, 0, 0, 0, 		"../ui/menu/items/mod_icons/fast_reload",	 		"../ui/menu/items/mod_icons/fast_reload",	HideFromMenus )

	/////////////////////
	//TITAN PASSIVE DATA
	/////////////////////
	CreatePassiveData( itemType.TITAN_PASSIVE1, 	DEV_ENABLED,	0, 	null, 	null, "pas_shield_regen", 			"#GEAR_SHIELD_REACTOR",		"#GEAR_SHIELD_REACTOR_DESC",		"#GEAR_SHIELD_REACTOR_LONGDESC",		"../ui/menu/items/passive_icons/shield_regen",				"../ui/menu/items/passive_icons/shield_regen" )
	CreatePassiveData( itemType.TITAN_PASSIVE1, 	DEV_ENABLED,	0, 	null, 	null, "pas_dash_recharge", 			"#GEAR_DASH_REACTOR",		"#GEAR_DASH_REACTOR_DESC",			"#GEAR_DASH_REACTOR_LONGDESC",			"../ui/menu/items/passive_icons/dash_recharge",				"../ui/menu/items/passive_icons/dash_recharge" )
	CreatePassiveData( itemType.TITAN_PASSIVE1, 	DEV_ENABLED,	0, 	null, 	null, "pas_assault_reactor", 		"#GEAR_ASSAULT_REACTOR",	"#GEAR_ASSAULT_REACTOR_DESC",		"#GEAR_ASSAULT_REACTOR_LONGDESC",		"../ui/menu/items/passive_icons/assault_reactor",			"../ui/menu/items/passive_icons/assault_reactor" )
	CreatePassiveData( itemType.TITAN_PASSIVE1, 	DEV_ENABLED,	0, 	null, 	null, "pas_build_up_nuclear_core", 	"#GEAR_NUCLEAR_CORE",		"#GEAR_NUCLEAR_CORE_DESC",			"#GEAR_NUCLEAR_CORE_LONGDESC",			"../ui/menu/items/passive_icons/build_up_nuclear_core",		"../ui/menu/items/passive_icons/build_up_nuclear_core" )
	CreatePassiveData( itemType.TITAN_PASSIVE1, 	DEV_ENABLED,	0, 	null, 	null, "pas_defensive_core", 		"#GEAR_DEFENSE_REACTOR",	"#GEAR_DEFENSE_REACTOR_DESC",		"#GEAR_DEFENSE_REACTOR_LONGDESC",		"../ui/menu/items/passive_icons/defensive_core",			"../ui/menu/items/passive_icons/defensive_core" )

	CreatePassiveData( itemType.TITAN_PASSIVE2, 	DEV_ENABLED,	0, 	null, 	null, "pas_hyper_core", 			"#GEAR_HYPER_CORE",			"#GEAR_HYPER_CORE_DESC",			"#GEAR_HYPER_CORE_LONGDESC",			"../ui/menu/items/passive_icons/hyper_core",				"../ui/menu/items/passive_icons/hyper_core" )
	CreatePassiveData( itemType.TITAN_PASSIVE2, 	DEV_ENABLED,	0, 	null, 	null, "pas_marathon_core", 			"#GEAR_MARATHON_CORE",		"#GEAR_MARATHON_CORE_DESC",			"#GEAR_MARATHON_CORE_LONGDESC",			"../ui/menu/items/passive_icons/marathon_core",				"../ui/menu/items/passive_icons/marathon_core" )
	CreatePassiveData( itemType.TITAN_PASSIVE2, 	DEV_ENABLED,	0, 	null, 	null, "pas_auto_eject", 			"#GEAR_AUTO_EJECT",			"#GEAR_AUTO_EJECT_DESC",			"#GEAR_AUTO_EJECT_LONGDESC",			"../ui/menu/items/passive_icons/auto_eject",				"../ui/menu/items/passive_icons/auto_eject" )
	CreatePassiveData( itemType.TITAN_PASSIVE2, 	DEV_ENABLED,	0, 	null, 	null, "pas_titan_punch", 			"#GEAR_BIG_PUNCH",			"#GEAR_BIG_PUNCH_DESC",				"#GEAR_BIG_PUNCH_LONGDESC",				"../ui/menu/items/passive_icons/titan_punch",				"../ui/menu/items/passive_icons/titan_punch" )
	CreatePassiveData( itemType.TITAN_PASSIVE2, 	DEV_ENABLED,	0, 	null, 	null, "pas_doomed_time", 			"#GEAR_SURVIVOR",			"#GEAR_SURVIVOR_DESC",				"#GEAR_SURVIVOR_LONGDESC",				"../ui/menu/items/passive_icons/doomed_time",				"../ui/menu/items/passive_icons/doomed_time" )

	/////////////////////
	//TITAN OS DATA
	/////////////////////

	CreateTitanOSVoiceData( itemType.TITAN_OS, DEV_ENABLED,	0,		null, 	null, "titanos_betty",           "#TITAN_OS_BETTY_NAME",		        null,   "#TITAN_OS_BETTY_LONGDESC",		        	"../ui/menu/voice_personality_icons/betty_voice_icon",					"../ui/menu/voice_personality_icons/betty_voice_icon" )
	CreateTitanOSVoiceData( itemType.TITAN_OS, DEV_ENABLED,	0, 		null, 	null, "titanos_femaleaudinav",   "#TITAN_OS_FEMALE_AUDI_NAV_NAME",		null,	"#TITAN_OS_FEMALE_AUDI_NAV_LONGDESC",		"../ui/menu/voice_personality_icons/lisa_voice_icon",					"../ui/menu/voice_personality_icons/lisa_voice_icon" )
	CreateTitanOSVoiceData( itemType.TITAN_OS, DEV_ENABLED,	0, 		null, 	null, "titanos_malebutler",      "#TITAN_OS_MALE_BUTLER_NAME",			null,	"#TITAN_OS_MALE_BUTLER_LONGDESC",			"../ui/menu/voice_personality_icons/jeeves_voice_icon",			    	"../ui/menu/voice_personality_icons/jeeves_voice_icon" )
	CreateTitanOSVoiceData( itemType.TITAN_OS, DEV_ENABLED,	0, 		null, 	null, "titanos_femaleassistant", "#TITAN_OS_FEMALE_ASSISTANT_NAME",		null,	"#TITAN_OS_FEMALE_ASSISTANT_LONGDESC",		"../ui/menu/voice_personality_icons/jessica_voice_icon",					"../ui/menu/voice_personality_icons/jessica_voice_icon" )
	CreateTitanOSVoiceData( itemType.TITAN_OS, DEV_ENABLED,	0, 		null, 	null, "titanos_maleintimidator", "#TITAN_OS_MALE_INTIMIDATOR_NAME",		null,	"#TITAN_OS_MALE_INTIMIDATOR_LONGDESC",		"../ui/menu/voice_personality_icons/syd_voice_icon",			    	"../ui/menu/voice_personality_icons/syd_voice_icon" )
	CreateTitanOSVoiceData( itemType.TITAN_OS, DEV_ENABLED,	0, 		null, 	null, "titanos_bettyde", 		 "#TITAN_OS_BETTYDE_NAME",				null,	"#TITAN_OS_BETTYDE_LONGDESC",				"../ui/menu/voice_personality_icons/betty_de_voice_icon",			   	"../ui/menu/voice_personality_icons/betty_de_voice_icon")
	CreateTitanOSVoiceData( itemType.TITAN_OS, DEV_ENABLED,	0, 		null, 	null, "titanos_bettyen", 		 "#TITAN_OS_BETTYEN_NAME",				null,	"#TITAN_OS_BETTYEN_LONGDESC",				"../ui/menu/voice_personality_icons/betty_en_voice_icon",			   	"../ui/menu/voice_personality_icons/betty_en_voice_icon")
	CreateTitanOSVoiceData( itemType.TITAN_OS, DEV_ENABLED,	0, 		null, 	null, "titanos_bettyes", 		 "#TITAN_OS_BETTYES_NAME",				null,	"#TITAN_OS_BETTYES_LONGDESC",				"../ui/menu/voice_personality_icons/betty_es_voice_icon",			   	"../ui/menu/voice_personality_icons/betty_es_voice_icon")
	CreateTitanOSVoiceData( itemType.TITAN_OS, DEV_ENABLED,	0, 		null, 	null, "titanos_bettyfr", 		 "#TITAN_OS_BETTYFR_NAME",				null,	"#TITAN_OS_BETTYFR_LONGDESC",				"../ui/menu/voice_personality_icons/betty_fr_voice_icon",			   	"../ui/menu/voice_personality_icons/betty_fr_voice_icon")
	CreateTitanOSVoiceData( itemType.TITAN_OS, DEV_ENABLED,	0, 		null, 	null, "titanos_bettyit", 		 "#TITAN_OS_BETTYIT_NAME",				null,	"#TITAN_OS_BETTYIT_LONGDESC",				"../ui/menu/voice_personality_icons/betty_it_voice_icon",			   	"../ui/menu/voice_personality_icons/betty_it_voice_icon")
	CreateTitanOSVoiceData( itemType.TITAN_OS, DEV_ENABLED,	0, 		null, 	null, "titanos_bettyjp", 		 "#TITAN_OS_BETTYJP_NAME",				null,	"#TITAN_OS_BETTYJP_LONGDESC",				"../ui/menu/voice_personality_icons/betty_jp_voice_icon",			   	"../ui/menu/voice_personality_icons/betty_jp_voice_icon")
	CreateTitanOSVoiceData( itemType.TITAN_OS, DEV_ENABLED,	0, 		null, 	null, "titanos_bettyru", 		 "#TITAN_OS_BETTYRU_NAME",				null,	"#TITAN_OS_BETTYRU_LONGDESC",				"../ui/menu/voice_personality_icons/betty_ru_voice_icon",			   	"../ui/menu/voice_personality_icons/betty_ru_voice_icon")


	/////////////////////
	//TITAN BURN CARD MOD DATA
	/////////////////////
	CreateModData( itemType.TITAN_PRIMARY_MOD,		DEV_DISABLED,	0, 	null, 	null, "mp_titanweapon_40mm",				"burn_mod_titan_40mm", 					"#BC_TITAN_40MM_M2",				"#BC_TITAN_40MM_M2_FLYOUT_DESC",				"#BC_TITAN_40MM_M2_FLYOUT_DESC",				0, 0, 0, 0, 0,	 	"../ui/temp",	"../ui/temp",	HideFromMenus )
	CreateModData( itemType.TITAN_PRIMARY_MOD,		DEV_DISABLED,	0, 	null, 	null, "mp_titanweapon_arc_cannon",			"burn_mod_titan_arc_cannon", 			"#BC_TITAN_ARC_CANNON_M2",			"#BC_TITAN_ARC_CANNON_M2_FLYOUT_DESC",			"#BC_TITAN_ARC_CANNON_M2_FLYOUT_DESC",			0, 0, 0, 0, 0,	 	"../ui/temp",	"../ui/temp",	HideFromMenus )
	CreateModData( itemType.TITAN_PRIMARY_MOD,		DEV_DISABLED,	0, 	null, 	null, "mp_titanweapon_rocket_launcher",		"burn_mod_titan_rocket_launcher", 		"#BC_TITAN_ROCKET_LAUNCHER_M2",		"#BC_TITAN_ROCKET_LAUNCHER_M2_FLYOUT_DESC",		"#BC_TITAN_ROCKET_LAUNCHER_M2_FLYOUT_DESC",		0, 0, 0, 0, 0,	 	"../ui/temp",	"../ui/temp",	HideFromMenus )
	CreateModData( itemType.TITAN_PRIMARY_MOD,		DEV_DISABLED,	0, 	null, 	null, "mp_titanweapon_sniper",				"burn_mod_titan_sniper", 				"#BC_TITAN_SNIPER_M2",				"#BC_TITAN_SNIPER_M2_FLYOUT_DESC",				"#BC_TITAN_SNIPER_M2_FLYOUT_DESC",				0, 0, 0, 0, 0,	 	"../ui/temp",	"../ui/temp",	HideFromMenus )
	CreateModData( itemType.TITAN_PRIMARY_MOD,		DEV_DISABLED,	0, 	null, 	null, "mp_titanweapon_triple_threat",		"burn_mod_titan_triple_threat", 		"#BC_TITAN_TRIPLE_THREAT_M2",		"#BC_TITAN_TRIPLE_THREAT_M2_FLYOUT_DESC",		"#BC_TITAN_TRIPLE_THREAT_M2_FLYOUT_DESC",		0, 0, 0, 0, 0,	 	"../ui/temp",	"../ui/temp",	HideFromMenus )
	CreateModData( itemType.TITAN_PRIMARY_MOD,		DEV_DISABLED,	0, 	null, 	null, "mp_titanweapon_xo16",				"burn_mod_titan_xo16", 					"#BC_TITAN_XO16_M2",				"#BC_TITAN_XO16_M2_FLYOUT_DESC",				"#BC_TITAN_XO16_M2_FLYOUT_DESC",				0, 0, 0, 0, 0,	 	"../ui/temp",	"../ui/temp",	HideFromMenus )
	CreateModData( itemType.TITAN_ORDNANCE_MOD,		DEV_DISABLED,	0, 	null, 	null, "mp_titanweapon_dumbfire_rockets",	"burn_mod_titan_dumbfire_rockets", 		"#BC_TITAN_DUMBFIRE_MISSILE_M2",	"#BC_TITAN_DUMBFIRE_MISSILE_M2_FLYOUT_DESC",	"#BC_TITAN_DUMBFIRE_MISSILE_M2_FLYOUT_DESC",	0, 0, 0, 0, 0,	 	"../ui/temp",	"../ui/temp",	HideFromMenus )
	CreateModData( itemType.TITAN_ORDNANCE_MOD,		DEV_DISABLED,	0, 	null, 	null, "mp_titanweapon_homing_rockets",		"burn_mod_titan_homing_rockets", 		"#BC_TITAN_HOMING_ROCKETS_M2",		"#BC_TITAN_HOMING_ROCKETS_M2_FLYOUT_DESC",		"#BC_TITAN_HOMING_ROCKETS_M2_FLYOUT_DESC",		0, 0, 0, 0, 0,	 	"../ui/temp",	"../ui/temp",	HideFromMenus )
	CreateModData( itemType.TITAN_ORDNANCE_MOD,		DEV_DISABLED,	0, 	null, 	null, "mp_titanweapon_salvo_rockets",		"burn_mod_titan_salvo_rockets", 		"#BC_TITAN_SALVO_ROCKETS_M2",		"#BC_TITAN_SALVO_ROCKETS_M2_FLYOUT_DESC",		"#BC_TITAN_SALVO_ROCKETS_M2_FLYOUT_DESC",		0, 0, 0, 0, 0,	 	"../ui/temp",	"../ui/temp",	HideFromMenus )
	CreateModData( itemType.TITAN_ORDNANCE_MOD,		DEV_DISABLED,	0, 	null, 	null, "mp_titanweapon_shoulder_rockets",	"burn_mod_titan_shoulder_rockets", 		"#BC_TITAN_SHOULDER_ROCKETS_M2",	"#BC_TITAN_SHOULDER_ROCKETS_M2_FLYOUT_DESC",	"#BC_TITAN_SHOULDER_ROCKETS_M2_FLYOUT_DESC",	0, 0, 0, 0, 0,	 	"../ui/temp",	"../ui/temp",	HideFromMenus )
	CreateModData( itemType.TITAN_SPECIAL_MOD,		DEV_DISABLED,	0, 	null, 	null, "mp_titanweapon_vortex_shield",		"burn_mod_titan_vortex_shield",			"#BC_TITAN_VORTEX_SHIELD_M2",		"#BC_TITAN_VORTEX_SHIELD_M2_FLYOUT_DESC",		"#BC_TITAN_VORTEX_SHIELD_M2_FLYOUT_DESC",		0, 0, 0, 0, 0,	 	"../ui/temp",	"../ui/temp",	HideFromMenus )
	CreateModData( itemType.TITAN_SPECIAL_MOD,		DEV_DISABLED,	0, 	null, 	null, "mp_titanability_smoke",				"burn_mod_titan_smoke",					"#BC_TITAN_ELECTRIC_SMOKE_M2", 		"#BC_TITAN_ELECTRIC_SMOKE_M2_FLYOUT_DESC",		"#BC_TITAN_ELECTRIC_SMOKE_M2_FLYOUT_DESC",		0, 0, 0, 0, 0,	 	"../ui/temp",	"../ui/temp",	HideFromMenus )
	CreateModData( itemType.TITAN_SPECIAL_MOD,		DEV_DISABLED,	0, 	null, 	null, "mp_titanability_bubble_shield",		"burn_mod_titan_bubble_shield",			"#BC_TITAN_SHIELD_WALL_M2",			"#BC_TITAN_SHIELD_WALL_M2_FLYOUT_DESC",			"#BC_TITAN_SHIELD_WALL_M2_FLYOUT_DESC",			0, 0, 0, 0, 0,	 	"../ui/temp",	"../ui/temp",	HideFromMenus )


	/////////////////////
	//EVENT PASSIVE DATA
	/////////////////////
	// these should not be needed -Mackey
	CreatePassiveData( itemType.EVENT_PASSIVE, 		DEV_ENABLED,	0, 	null, 	null, "pas_minimap_all",		"Minimap All",			"Temp Description", "Temp Long Description",	"../ui/temp",	"../ui/temp" )
	CreatePassiveData( itemType.EVENT_PASSIVE, 		DEV_ENABLED,	0, 	null, 	null, "pas_minimap_players",	"Minimap Players",		"Temp Description", "Temp Long Description",	"../ui/temp",	"../ui/temp" )

	// Put these properties in the set files, and read them when UI script can
	CreateSetFileData( itemType.PILOT_SETFILE,		DEV_ENABLED,	0, 	null, 	null, "pilot_male_br",		"Male Battle Rifle", 			"Male Battle Rifle Description",			"../ui/menu/loadouts/pilot_character_male_battle_rifle_imc",			"../ui/menu/loadouts/pilot_character_male_battle_rifle_militia" )
	CreateSetFileData( itemType.PILOT_SETFILE,		DEV_ENABLED,	0, 	null, 	null, "pilot_female_br",	"Female Battle Rifle",			"Female Battle Rifle Description",			"../ui/menu/loadouts/pilot_character_female_battle_rifle_imc",			"../ui/menu/loadouts/pilot_character_female_battle_rifle_militia" )
	CreateSetFileData( itemType.PILOT_SETFILE,		DEV_ENABLED,	0, 	null, 	null, "pilot_male_cq",		"Male Close Quarters",			"Male Close Quarters Description",			"../ui/menu/loadouts/pilot_character_male_close_quarters_imc",			"../ui/menu/loadouts/pilot_character_male_close_quarters_militia" )
	CreateSetFileData( itemType.PILOT_SETFILE,		DEV_ENABLED,	0, 	null, 	null, "pilot_female_cq",	"Female Close Quarters", 		"Female Close Quarters Description",		"../ui/menu/loadouts/pilot_character_female_close_quarters_imc",		"../ui/menu/loadouts/pilot_character_female_close_quarters_militia" )
	CreateSetFileData( itemType.PILOT_SETFILE,		DEV_ENABLED,	0, 	null, 	null, "pilot_male_dm",		"Male Designated Marksman",		"Male Designated Marksman Description",		"../ui/menu/loadouts/pilot_character_male_designated_marksman_imc",		"../ui/menu/loadouts/pilot_character_male_designated_marksman_militia" )
	CreateSetFileData( itemType.PILOT_SETFILE,		DEV_ENABLED,	0, 	null, 	null, "pilot_female_dm",	"Female Designated Marksman",	"Female Designated Marksman Description",	"../ui/menu/loadouts/pilot_character_female_designated_marksman_imc",	"../ui/menu/loadouts/pilot_character_female_designated_marksman_militia" )

	CreateSetFileData( itemType.TITAN_SETFILE,		DEV_ENABLED,	0,	null, 	null, "titan_atlas",		"#CHASSIS_ATLAS_NAME",		"#CHASSIS_ATLAS_DESCRIPTION",	"../ui/menu/loadouts/titan_chassis_atlas_imc",		"../ui/menu/loadouts/titan_chassis_atlas_mcor", 	"#CHASSIS_ATLAS_CORE_NAME", 	"#CHASSIS_ATLAS_CORE_DESCRIPTION", 		"../ui/menu/items/ability_images/chassis_page_core_atlas",  	85, 90, 76, 2	)
	CreateSetFileData( itemType.TITAN_SETFILE,		DEV_ENABLED,	0, 	null, 	null, "titan_stryder",		"#CHASSIS_STRYDER_NAME",	"#CHASSIS_STRYDER_DESCRIPTION",	"../ui/menu/loadouts/titan_chassis_stryder_imc",	"../ui/menu/loadouts/titan_chassis_stryder_mcor", 	"#CHASSIS_STRYDER_CORE_NAME",	"#CHASSIS_STRYDER_CORE_DESCRIPTION",	"../ui/menu/items/ability_images/chassis_page_core_stryder", 	100, 100, 57, 3 )
	CreateSetFileData( itemType.TITAN_SETFILE,		DEV_ENABLED,	0, 	null, 	null, "titan_ogre",			"#CHASSIS_OGRE_NAME",		"#CHASSIS_OGRE_DESCRIPTION",	"../ui/menu/loadouts/titan_chassis_ogre_imc",		"../ui/menu/loadouts/titan_chassis_ogre_mcor",		"#CHASSIS_OGRE_CORE_NAME",		"#CHASSIS_OGRE_CORE_DESCRIPTION", 		"../ui/menu/items/ability_images/chassis_page_core_ogre",  		70, 38, 100, 1 )

	/////////////////////
	// TITAN DECAL DATA
	/////////////////////

	CreateDecalData( itemType.TITAN_DECAL, "titan_decal_a_base_imc", 		"#TITAN_DECAL_BASE_IMC_NAME", 			"#TITAN_DECAL_BASE_IMC_DESC", 			"#TITAN_DECAL_BASE_IMC_REQ", 			"#TITAN_DECAL_BASE_IMC_REQUNLOCKED", 			"../models/titans/custom_decals/decal_pack_01/titan_decal_a_base_imc_menu", 		false )
	CreateDecalData( itemType.TITAN_DECAL, "titan_decal_b_base_mcor", 		"#TITAN_DECAL_BASE_MCOR_NAME", 			"#TITAN_DECAL_BASE_MCOR_DESC", 			"#TITAN_DECAL_BASE_MCOR_REQ", 			"#TITAN_DECAL_BASE_MCOR_REQUNLOCKED", 			"../models/titans/custom_decals/decal_pack_01/titan_decal_b_base_mcor_menu", 		false )
	CreateDecalData( itemType.TITAN_DECAL, "5kw_custom_decal", 				"#TITAN_DECAL_5KW_NAME", 				"#TITAN_DECAL_5KW_DESC", 				"#TITAN_DECAL_5KW_REQ",					"#TITAN_DECAL_5KW_REQUNLOCKED", 				"../models/titans/custom_decals/decal_pack_01/5kw_custom_decal_menu", 				false )
	CreateDecalData( itemType.TITAN_DECAL, "30_titan_decal", 				"#TITAN_DECAL_30_NAME", 				"#TITAN_DECAL_30_DESC", 				"#TITAN_DECAL_30_REQ",					"#TITAN_DECAL_30_REQUNLOCKED", 					"../models/titans/custom_decals/decal_pack_01/30_titan_decal_menu", 				false )
	CreateDecalData( itemType.TITAN_DECAL, "ace_custom_decal", 				"#TITAN_DECAL_ACES_NAME", 				"#TITAN_DECAL_ACES_DESC", 				"#TITAN_DECAL_ACES_REQ",				"#TITAN_DECAL_ACES_REQUNLOCKED", 				"../models/titans/custom_decals/decal_pack_01/ace_custom_decal_menu", 				false )
	CreateDecalData( itemType.TITAN_DECAL, "bomb_lit_custom_decal", 		"#TITAN_DECAL_BOMB_LIT_NAME", 			"#TITAN_DECAL_BOMB_LIT_DESC", 			"#TITAN_DECAL_BOMB_LIT_REQ", 			"#TITAN_DECAL_BOMB_LIT_REQUNLOCKED", 			"../models/titans/custom_decals/decal_pack_01/bomb_lit_custom_decal_menu", 			false )
	CreateDecalData( itemType.TITAN_DECAL, "bombs_custom_decal", 			"#TITAN_DECAL_BOMBS_NAME", 				"#TITAN_DECAL_BOMBS_DESC", 				"#TITAN_DECAL_BOMBS_REQ", 				"#TITAN_DECAL_BOMBS_REQUNLOCKED", 				"../models/titans/custom_decals/decal_pack_01/bombs_custom_decal_menu", 			false )
	CreateDecalData( itemType.TITAN_DECAL, "bullet_hash_custom_decal", 		"#TITAN_DECAL_BULLET_HASH_NAME", 		"#TITAN_DECAL_BULLET_HASH_DESC", 		"#TITAN_DECAL_BULLET_HASH_REQ", 		"#TITAN_DECAL_BULLET_HASH_REQUNLOCKED", 		"../models/titans/custom_decals/decal_pack_01/bullet_hash_custom_decal_menu", 		false )
	CreateDecalData( itemType.TITAN_DECAL, "eye_custom_decal", 				"#TITAN_DECAL_EYE_NAME", 				"#TITAN_DECAL_EYE_DESC", 				"#TITAN_DECAL_EYE_REQ", 				"#TITAN_DECAL_EYE_REQUNLOCKED", 				"../models/titans/custom_decals/decal_pack_01/eye_custom_decal_menu", 				false )

	CreateDecalData( itemType.TITAN_DECAL, "hand_custom_decal", 			"#TITAN_DECAL_HAND_NAME", 				"#TITAN_DECAL_HAND_DESC", 				"#TITAN_DECAL_HAND_REQ", 				"#TITAN_DECAL_HAND_REQUNLOCKED", 				"../models/titans/custom_decals/decal_pack_01/hand_custom_decal_menu", 				false )
	CreateDecalData( itemType.TITAN_DECAL, "pitchfork_custom_decal", 		"#TITAN_DECAL_PITCHFORK_NAME", 			"#TITAN_DECAL_PITCHFORK_DESC", 			"#TITAN_DECAL_PITCHFORK_REQ", 			"#TITAN_DECAL_PITCHFORK_REQUNLOCKED", 			"../models/titans/custom_decals/decal_pack_01/pitchfork_custom_decal_menu", 		false )
	CreateDecalData( itemType.TITAN_DECAL, "red_chevron_custom_decal", 		"#TITAN_DECAL_RED_CHEVRON_NAME", 		"#TITAN_DECAL_RED_CHEVRON_DESC", 		"#TITAN_DECAL_RED_CHEVRON_REQ", 		"#TITAN_DECAL_RED_CHEVRON_REQUNLOCKED", 		"../models/titans/custom_decals/decal_pack_01/red_chevron_custom_decal_menu", 		false )
	CreateDecalData( itemType.TITAN_DECAL, "titan_decal_4", 				"#TITAN_DECAL_4_NAME", 					"#TITAN_DECAL_4_DESC", 					"#TITAN_DECAL_4_REQ", 					"#TITAN_DECAL_4_REQUNLOCKED", 					"../models/titans/custom_decals/decal_pack_01/titan_decal_4_menu", 					false )
	CreateDecalData( itemType.TITAN_DECAL, "titan_decal_13", 				"#TITAN_DECAL_13_NAME", 				"#TITAN_DECAL_13_DESC", 				"#TITAN_DECAL_13_REQ", 					"#TITAN_DECAL_13_REQUNLOCKED", 					"../models/titans/custom_decals/decal_pack_01/titan_decal_13_menu", 				false )
	CreateDecalData( itemType.TITAN_DECAL, "titan_decal_19", 				"#TITAN_DECAL_19_NAME", 				"#TITAN_DECAL_19_DESC", 				"#TITAN_DECAL_19_REQ", 					"#TITAN_DECAL_19_REQUNLOCKED", 					"../models/titans/custom_decals/decal_pack_01/titan_decal_19_menu", 				false )
	CreateDecalData( itemType.TITAN_DECAL, "titan_decal_27", 				"#TITAN_DECAL_27_NAME", 				"#TITAN_DECAL_27_DESC", 				"#TITAN_DECAL_27_REQ", 					"#TITAN_DECAL_27_REQUNLOCKED", 					"../models/titans/custom_decals/decal_pack_01/titan_decal_27_menu", 				false )
	CreateDecalData( itemType.TITAN_DECAL, "titan_decal_ace", 				"#TITAN_DECAL_ACE_NAME", 				"#TITAN_DECAL_ACE_DESC", 				"#TITAN_DECAL_ACE_REQ", 				"#TITAN_DECAL_ACE_REQUNLOCKED", 				"../models/titans/custom_decals/decal_pack_01/titan_decal_ace_menu", 				false )
	CreateDecalData( itemType.TITAN_DECAL, "titan_decal_animalskull", 		"#TITAN_DECAL_ANIMALSKULL_NAME", 		"#TITAN_DECAL_ANIMALSKULL_DESC", 		"#TITAN_DECAL_ANIMALSKULL_REQ", 		"#TITAN_DECAL_ANIMALSKULL_REQUNLOCKED", 		"../models/titans/custom_decals/decal_pack_01/titan_decal_animalskull_menu", 		false )

	CreateDecalData( itemType.TITAN_DECAL, "titan_decal_bluestar", 			"#TITAN_DECAL_BLUESTAR_NAME", 			"#TITAN_DECAL_BLUESTAR_DESC", 			"#TITAN_DECAL_BLUESTAR_REQ",			"#TITAN_DECAL_BLUESTAR_REQUNLOCKED", 			"../models/titans/custom_decals/decal_pack_01/titan_decal_bluestar_menu", 			false )
	CreateDecalData( itemType.TITAN_DECAL, "titan_decal_brokenstar", 		"#TITAN_DECAL_BROKENSTAR_NAME", 		"#TITAN_DECAL_BROKENSTAR_DESC", 		"#TITAN_DECAL_BROKENSTAR_REQ",			"#TITAN_DECAL_BROKENSTAR_REQUNLOCKED",			"../models/titans/custom_decals/decal_pack_01/titan_decal_brokenstar_menu", 		false )
	CreateDecalData( itemType.TITAN_DECAL, "titan_decal_conejo", 			"#TITAN_DECAL_CONEJO_NAME", 			"#TITAN_DECAL_CONEJO_DESC", 			"#TITAN_DECAL_CONEJO_REQ",				"#TITAN_DECAL_CONEJO_REQUNLOCKED",				"../models/titans/custom_decals/decal_pack_01/titan_decal_conejo_menu", 			false )
	CreateDecalData( itemType.TITAN_DECAL, "titan_decal_crazybomb", 		"#TITAN_DECAL_CRAZYBOMB_NAME", 			"#TITAN_DECAL_CRAZYBOMB_DESC", 			"#TITAN_DECAL_CRAZYBOMB_REQ",			"#TITAN_DECAL_CRAZYBOMB_REQUNLOCKED",			"../models/titans/custom_decals/decal_pack_01/titan_decal_crazybomb_menu", 			false )
	CreateDecalData( itemType.TITAN_DECAL, "titan_decal_defiant", 			"#TITAN_DECAL_DEFIANT_NAME", 			"#TITAN_DECAL_DEFIANT_DESC", 			"#TITAN_DECAL_DEFIANT_REQ",				"#TITAN_DECAL_DEFIANT_REQUNLOCKED", 			"../models/titans/custom_decals/decal_pack_01/titan_decal_defiant_menu", 			false )
	CreateDecalData( itemType.TITAN_DECAL, "titan_decal_dice", 				"#TITAN_DECAL_DICE_NAME", 				"#TITAN_DECAL_DICE_DESC", 				"#TITAN_DECAL_DICE_REQ",				"#TITAN_DECAL_DICE_REQUNLOCKED",				"../models/titans/custom_decals/decal_pack_01/titan_decal_dice_menu", 				false )
	CreateDecalData( itemType.TITAN_DECAL, "titan_decal_dino", 				"#TITAN_DECAL_DINO_NAME", 				"#TITAN_DECAL_DINO_DESC", 				"#TITAN_DECAL_DINO_REQ",				"#TITAN_DECAL_DINO_REQUNLOCKED",				"../models/titans/custom_decals/decal_pack_01/titan_decal_dino_menu", 				false )
	CreateDecalData( itemType.TITAN_DECAL, "titan_decal_eagle", 			"#TITAN_DECAL_EAGLE_NAME", 				"#TITAN_DECAL_EAGLE_DESC", 				"#TITAN_DECAL_EAGLE_REQ",				"#TITAN_DECAL_EAGLE_REQUNLOCKED", 				"../models/titans/custom_decals/decal_pack_01/titan_decal_eagle_menu", 				false )
	CreateDecalData( itemType.TITAN_DECAL, "titan_decal_eagleShield", 		"#TITAN_DECAL_EAGLESHIELD_NAME", 		"#TITAN_DECAL_EAGLESHIELD_DESC", 		"#TITAN_DECAL_EAGLESHIELD_REQ",			"#TITAN_DECAL_EAGLESHIELD_REQUNLOCKED", 		"../models/titans/custom_decals/decal_pack_01/titan_decal_eagleShield_menu", 		false )

	CreateDecalData( itemType.TITAN_DECAL, "titan_decal_fa95", 				"#TITAN_DECAL_FA95_NAME", 				"#TITAN_DECAL_FA95_DESC", 				null, 									null, 											"../models/titans/custom_decals/decal_pack_01/titan_decal_fa95_menu", 				false )
	CreateDecalData( itemType.TITAN_DECAL, "titan_decal_flameskull", 		"#TITAN_DECAL_FLAMESKULL_NAME", 		"#TITAN_DECAL_FLAMESKULL_DESC", 		"#TITAN_DECAL_FLAMESKULL_REQ", 			"#TITAN_DECAL_FLAMESKULL_REQUNLOCKED", 			"../models/titans/custom_decals/decal_pack_01/titan_decal_flameskull_menu", 		false )
	CreateDecalData( itemType.TITAN_DECAL, "titan_decal_gen1", 				"#TITAN_DECAL_GEN1_NAME", 				"#TITAN_DECAL_GEN1_DESC", 				null, 									null, 											"../models/titans/custom_decals/decal_pack_01/titan_decal_gen1_menu", 				false )
	CreateDecalData( itemType.TITAN_DECAL, "titan_decal_gen2", 				"#TITAN_DECAL_GEN2_NAME", 				"#TITAN_DECAL_GEN2_DESC", 				"#TITAN_DECAL_GEN2_REQ", 				"#TITAN_DECAL_GEN2_REQUNLOCKED", 				"../models/titans/custom_decals/decal_pack_01/titan_decal_gen2_menu", 				false )
	CreateDecalData( itemType.TITAN_DECAL, "titan_decal_gen3", 				"#TITAN_DECAL_GEN3_NAME", 				"#TITAN_DECAL_GEN3_DESC", 				"#TITAN_DECAL_GEN3_REQ", 				"#TITAN_DECAL_GEN3_REQUNLOCKED", 				"../models/titans/custom_decals/decal_pack_01/titan_decal_gen3_menu", 				false )
	CreateDecalData( itemType.TITAN_DECAL, "titan_decal_gen4", 				"#TITAN_DECAL_GEN4_NAME", 				"#TITAN_DECAL_GEN4_DESC", 				"#TITAN_DECAL_GEN4_REQ", 				"#TITAN_DECAL_GEN4_REQUNLOCKED", 				"../models/titans/custom_decals/decal_pack_01/titan_decal_gen4_menu", 				false )
	CreateDecalData( itemType.TITAN_DECAL, "titan_decal_gen5", 				"#TITAN_DECAL_GEN5_NAME", 				"#TITAN_DECAL_GEN5_DESC", 				"#TITAN_DECAL_GEN5_REQ", 				"#TITAN_DECAL_GEN5_REQUNLOCKED", 				"../models/titans/custom_decals/decal_pack_01/titan_decal_gen5_menu", 				false )
	CreateDecalData( itemType.TITAN_DECAL, "titan_decal_gen6", 				"#TITAN_DECAL_GEN6_NAME", 				"#TITAN_DECAL_GEN6_DESC", 				"#TITAN_DECAL_GEN6_REQ", 				"#TITAN_DECAL_GEN6_REQUNLOCKED", 				"../models/titans/custom_decals/decal_pack_01/titan_decal_gen6_menu", 				false )
	CreateDecalData( itemType.TITAN_DECAL, "titan_decal_gen7", 				"#TITAN_DECAL_GEN7_NAME", 				"#TITAN_DECAL_GEN7_DESC", 				"#TITAN_DECAL_GEN7_REQ", 				"#TITAN_DECAL_GEN7_REQUNLOCKED", 				"../models/titans/custom_decals/decal_pack_01/titan_decal_gen7_menu", 				false )

	CreateDecalData( itemType.TITAN_DECAL, "titan_decal_gen8", 				"#TITAN_DECAL_GEN8_NAME", 				"#TITAN_DECAL_GEN8_DESC", 				"#TITAN_DECAL_GEN8_REQ", 				"#TITAN_DECAL_GEN8_REQUNLOCKED", 				"../models/titans/custom_decals/decal_pack_01/titan_decal_gen8_menu", 				false )
	CreateDecalData( itemType.TITAN_DECAL, "titan_decal_gen9", 				"#TITAN_DECAL_GEN9_NAME", 				"#TITAN_DECAL_GEN9_DESC", 				"#TITAN_DECAL_GEN9_REQ", 				"#TITAN_DECAL_GEN9_REQUNLOCKED", 				"../models/titans/custom_decals/decal_pack_01/titan_decal_gen9_menu", 				false )
	CreateDecalData( itemType.TITAN_DECAL, "titan_decal_gen10", 			"#TITAN_DECAL_GEN10_NAME", 				"#TITAN_DECAL_GEN10_DESC", 				"#TITAN_DECAL_GEN10_REQ", 				"#TITAN_DECAL_GEN10_REQUNLOCKED", 				"../models/titans/custom_decals/decal_pack_01/titan_decal_gen10_menu", 				false )
	CreateDecalData( itemType.TITAN_DECAL, "titan_decal_girly", 			"#TITAN_DECAL_GIRLY_NAME", 				"#TITAN_DECAL_GIRLY_DESC", 				"#TITAN_DECAL_GIRLY_REQ", 				"#TITAN_DECAL_GIRLY_REQUNLOCKED", 				"../models/titans/custom_decals/decal_pack_01/titan_decal_girly_menu", 				false )
	CreateDecalData( itemType.TITAN_DECAL, "titan_decal_gremlin", 			"#TITAN_DECAL_GREMLIN_NAME", 			"#TITAN_DECAL_GREMLIN_DESC", 			"#TITAN_DECAL_GREMLIN_REQ", 			"#TITAN_DECAL_GREMLIN_REQUNLOCKED", 			"../models/titans/custom_decals/decal_pack_01/titan_decal_gremlin_menu", 			false )
	CreateDecalData( itemType.TITAN_DECAL, "titan_decal_hammond", 			"#TITAN_DECAL_HAMMOND_NAME", 			"#TITAN_DECAL_HAMMOND_DESC", 			"#TITAN_DECAL_HAMMOND_REQ", 			"#TITAN_DECAL_HAMMOND_REQUNLOCKED", 			"../models/titans/custom_decals/decal_pack_01/titan_decal_hammond_menu", 			false )
	CreateDecalData( itemType.TITAN_DECAL, "titan_decal_imc_gear", 			"#TITAN_DECAL_IMC_GEAR_NAME", 			"#TITAN_DECAL_IMC_GEAR_DESC", 			"#TITAN_DECAL_IMC_GEAR_REQ", 			"#TITAN_DECAL_IMC_GEAR_REQUNLOCKED", 			"../models/titans/custom_decals/decal_pack_01/titan_decal_imc_gear_menu", 			false )
	CreateDecalData( itemType.TITAN_DECAL, "titan_decal_imc_old", 			"#TITAN_DECAL_IMC_OLD_NAME", 			"#TITAN_DECAL_IMC_OLD_DESC", 			"#TITAN_DECAL_IMC_OLD_REQ", 			"#TITAN_DECAL_IMC_OLD_REQUNLOCKED", 			"../models/titans/custom_decals/decal_pack_01/titan_decal_imc_old_menu", 			false )
	CreateDecalData( itemType.TITAN_DECAL, "titan_decal_IMC01", 			"#TITAN_DECAL_IMC01_NAME", 				"#TITAN_DECAL_IMC01_DESC", 				"#TITAN_DECAL_IMC01_REQ", 				"#TITAN_DECAL_IMC01_REQUNLOCKED", 				"../models/titans/custom_decals/decal_pack_01/titan_decal_IMC01_menu", 				false )

	CreateDecalData( itemType.TITAN_DECAL, "titan_decal_IMC02", 			"#TITAN_DECAL_IMC02_NAME", 				"#TITAN_DECAL_IMC02_DESC", 				"#TITAN_DECAL_IMC02_REQ", 				"#TITAN_DECAL_IMC02_REQUNLOCKED", 				"../models/titans/custom_decals/decal_pack_01/titan_decal_IMC02_menu", 				false )
	CreateDecalData( itemType.TITAN_DECAL, "titan_decal_IMC03", 			"#TITAN_DECAL_IMC03_NAME", 				"#TITAN_DECAL_IMC03_DESC", 				"#TITAN_DECAL_IMC03_REQ", 				"#TITAN_DECAL_IMC03_REQUNLOCKED", 				"../models/titans/custom_decals/decal_pack_01/titan_decal_IMC03_menu", 				false )
	CreateDecalData( itemType.TITAN_DECAL, "titan_decal_imctri", 			"#TITAN_DECAL_IMCTRI_NAME", 			"#TITAN_DECAL_IMCTRI_DESC", 			"#TITAN_DECAL_IMCTRI_REQ", 				"#TITAN_DECAL_IMCTRI_REQUNLOCKED", 				"../models/titans/custom_decals/decal_pack_01/titan_decal_imctri_menu", 			false )
	CreateDecalData( itemType.TITAN_DECAL, "titan_decal_killmarks", 		"#TITAN_DECAL_KILLMARKS_NAME", 			"#TITAN_DECAL_KILLMARKS_DESC", 			"#TITAN_DECAL_KILLMARKS_REQ", 			"#TITAN_DECAL_KILLMARKS_REQUNLOCKED", 			"../models/titans/custom_decals/decal_pack_01/titan_decal_killmarks_menu", 			false )
	CreateDecalData( itemType.TITAN_DECAL, "titan_decal_ksa", 				"#TITAN_DECAL_KSA_NAME", 				"#TITAN_DECAL_KSA_DESC", 				null, 									null, 											"../models/titans/custom_decals/decal_pack_01/titan_decal_ksa_menu", 				false )
	CreateDecalData( itemType.TITAN_DECAL, "titan_decal_letter01_opa", 		"#TITAN_DECAL_LETTER01_OPA_NAME", 		"#TITAN_DECAL_LETTER01_OPA_DESC", 		null, 									null, 											"../models/titans/custom_decals/decal_pack_01/titan_decal_letter01_opa_menu",  		false )
	CreateDecalData( itemType.TITAN_DECAL, "titan_decal_mcor", 				"#TITAN_DECAL_MCOR_NAME", 				"#TITAN_DECAL_MCOR_DESC", 				"#TITAN_DECAL_MCOR_REQ", 				"#TITAN_DECAL_MCOR_REQUNLOCKED", 				"../models/titans/custom_decals/decal_pack_01/titan_decal_mcor_menu", 				false )
	CreateDecalData( itemType.TITAN_DECAL, "titan_decal_militia", 			"#TITAN_DECAL_MILITIA_NAME", 			"#TITAN_DECAL_MILITIA_DESC", 			"#TITAN_DECAL_MILITIA_REQ", 			"#TITAN_DECAL_MILITIA_REQUNLOCKED", 			"../models/titans/custom_decals/decal_pack_01/titan_decal_militia_menu", 			false )
	CreateDecalData( itemType.TITAN_DECAL, "titan_decal_oldMcor", 			"#TITAN_DECAL_OLDMCOR_NAME", 			"#TITAN_DECAL_OLDMCOR_DESC", 			"#TITAN_DECAL_OLDMCOR_REQ", 			"#TITAN_DECAL_OLDMCOR_REQUNLOCKED", 			"../models/titans/custom_decals/decal_pack_01/titan_decal_oldMcor_menu", 			false )

	CreateDecalData( itemType.TITAN_DECAL, "titan_decal_redstarv", 			"#TITAN_DECAL_REDSTARV_NAME", 			"#TITAN_DECAL_REDSTARV_DESC", 			"#TITAN_DECAL_REDSTARV_REQ", 			"#TITAN_DECAL_REDSTARV_REQUNLOCKED", 			"../models/titans/custom_decals/decal_pack_01/titan_decal_redstarv_menu", 			false )
	CreateDecalData( itemType.TITAN_DECAL, "titan_decal_shield", 			"#TITAN_DECAL_SHIELD_NAME", 			"#TITAN_DECAL_SHIELD_DESC", 			"#TITAN_DECAL_SHIELD_REQ", 				"#TITAN_DECAL_SHIELD_REQUNLOCKED", 				"../models/titans/custom_decals/decal_pack_01/titan_decal_shield_menu", 			false )
	CreateDecalData( itemType.TITAN_DECAL, "titan_decal_skullwings", 		"#TITAN_DECAL_SKULLWINGS_NAME", 		"#TITAN_DECAL_SKULLWINGS_DESC", 		"#TITAN_DECAL_SKULLWINGS_REQ", 			"#TITAN_DECAL_SKULLWINGS_REQUNLOCKED", 			"../models/titans/custom_decals/decal_pack_01/titan_decal_skullwings_menu", 		false )
	CreateDecalData( itemType.TITAN_DECAL, "titan_decal_skullwingsBLK", 	"#TITAN_DECAL_SKULLWINGSBLK_NAME", 		"#TITAN_DECAL_SKULLWINGSBLK_DESC", 		"#TITAN_DECAL_SKULLWINGSBLK_REQ", 		"#TITAN_DECAL_SKULLWINGSBLK_REQUNLOCKED", 		"../models/titans/custom_decals/decal_pack_01/titan_decal_skullwingsBLK_menu", 		false )
	CreateDecalData( itemType.TITAN_DECAL, "titan_decal_st", 				"#TITAN_DECAL_ST_NAME", 				"#TITAN_DECAL_ST_DESC", 				null, 									null, 											"../models/titans/custom_decals/decal_pack_01/titan_decal_st_menu", 				false )
	CreateDecalData( itemType.TITAN_DECAL, "titan_decal_ste", 				"#TITAN_DECAL_STE_NAME", 				"#TITAN_DECAL_STE_DESC", 				null, 									null, 											"../models/titans/custom_decals/decal_pack_01/titan_decal_ste_menu", 				false )
	CreateDecalData( itemType.TITAN_DECAL, "titan_decals_stinger", 			"#TITAN_DECAL_STINGER_NAME", 			"#TITAN_DECAL_STINGER_DESC",			"#TITAN_DECAL_STINGER_REQ", 			"#TITAN_DECAL_STINGER_REQUNLOCKED", 			"../models/titans/custom_decals/decal_pack_01/titan_decals_stinger_menu", 			false )
	CreateDecalData( itemType.TITAN_DECAL, "wings_custom_decal", 			"#TITAN_DECAL_WINGS_NAME", 				"#TITAN_DECAL_WINGS_DESC", 				"#TITAN_DECAL_WINGS_REQ",				"#TITAN_DECAL_WINGS_REQUNLOCKED", 				"../models/titans/custom_decals/decal_pack_01/wings_custom_decal_menu", 			false )
	CreateDecalData( itemType.TITAN_DECAL, "titan_decal_flagrunner",		"#TITAN_DECAL_FLAGRUNNER_NAME",			"#TITAN_DECAL_FLAGRUNNER_DESC",			"#TITAN_DECAL_FLAGRUNNER_REQ",			"#TITAN_DECAL_FLAGRUNNER_REQUNLOCKED",			"../models/titans/custom_decals/decal_pack_01/titan_decal_flagrunner_menu",			false )

	CreateDecalData( itemType.TITAN_DECAL, "titan_decal_twofer",			"#TITAN_DECAL_TWOFER_NAME",				"#TITAN_DECAL_TWOFER_DESC",				"#TITAN_DECAL_TWOFER_REQ",				"#TITAN_DECAL_TWOFER_REQUNLOCKED",				"../models/titans/custom_decals/decal_pack_01/titan_decal_twofer_menu",				false )
	CreateDecalData( itemType.TITAN_DECAL, "titan_decal_100guns",			"#TITAN_DECAL_100GUNS_NAME",			"#TITAN_DECAL_100GUNS_DESC",			"#TITAN_DECAL_100GUNS_REQ",				"#TITAN_DECAL_100GUNS_REQUNLOCKED",				"../models/titans/custom_decals/decal_pack_01/titan_decal_100guns_menu",			false )
	CreateDecalData( itemType.TITAN_DECAL, "titan_decal_crest",				"#TITAN_DECAL_CREST_NAME",				"#TITAN_DECAL_CREST_DESC",				"#TITAN_DECAL_CREST_REQ",				"#TITAN_DECAL_CREST_REQUNLOCKED",				"../models/titans/custom_decals/decal_pack_01/titan_decal_crest_menu",				false )
	CreateDecalData( itemType.TITAN_DECAL, "titan_decal_titankills",		"#TITAN_DECAL_TITANKILLS_NAME",			"#TITAN_DECAL_TITANKILLS_DESC",			"#TITAN_DECAL_TITANKILLS_REQ",			"#TITAN_DECAL_TITANKILLS_REQUNLOCKED",			"../models/titans/custom_decals/decal_pack_01/titan_decal_titankills_menu",			false )
	CreateDecalData( itemType.TITAN_DECAL, "titan_decal_eagleside",			"#TITAN_DECAL_EAGLESIDE_NAME",			"#TITAN_DECAL_EAGLESIDE_DESC",			"#TITAN_DECAL_EAGLESIDE_REQ",			"#TITAN_DECAL_EAGLESIDE_REQUNLOCKED",			"../models/titans/custom_decals/decal_pack_01/titan_decal_eagleside_menu",			false )
	CreateDecalData( itemType.TITAN_DECAL, "titan_decal_chevrons",			"#TITAN_DECAL_CHEVRONS_NAME",			"#TITAN_DECAL_CHEVRONS_DESC",			"#TITAN_DECAL_CHEVRONS_REQ",			"#TITAN_DECAL_CHEVRONS_REQUNLOCKED",			"../models/titans/custom_decals/decal_pack_01/titan_decal_chevrons_menu",			false )
	CreateDecalData( itemType.TITAN_DECAL, "titan_decal_glyph",				"#TITAN_DECAL_GLYPH_NAME",				"#TITAN_DECAL_GLYPH_DESC",				"#TITAN_DECAL_GLYPH_REQ",				"#TITAN_DECAL_GLYPH_REQUNLOCKED",				"../models/titans/custom_decals/decal_pack_01/titan_decal_glyph_menu",				false )
	CreateDecalData( itemType.TITAN_DECAL, "titan_decal_triangle",			"#TITAN_DECAL_TRIANGLE_NAME",			"#TITAN_DECAL_TRIANGLE_DESC",			"#TITAN_DECAL_TRIANGLE_REQ",			"#TITAN_DECAL_TRIANGLE_REQUNLOCKED",			"../models/titans/custom_decals/decal_pack_01/titan_decal_triangle_menu",			false )
	CreateDecalData( itemType.TITAN_DECAL, "titan_decal_kodai",				"#TITAN_DECAL_KODAI_NAME",				"#TITAN_DECAL_KODAI_DESC",				"#TITAN_DECAL_KODAI_REQ",				"#TITAN_DECAL_KODAI_REQUNLOCKED",				"../models/titans/custom_decals/decal_pack_01/titan_decal_kodai_menu",				false )

	CreateDecalData( itemType.TITAN_DECAL, "titan_decal_nuke",				"#TITAN_DECAL_NUKE_NAME",				"#TITAN_DECAL_NUKE_DESC",				"#TITAN_DECAL_NUKE_REQ",				"#TITAN_DECAL_NUKE_REQUNLOCKED",				"../models/titans/custom_decals/decal_pack_01/titan_decal_nuke_menu",				false )
	CreateDecalData( itemType.TITAN_DECAL, "titan_decal_fallingbomb",		"#TITAN_DECAL_FALLINGBOMB_NAME",		"#TITAN_DECAL_FALLINGBOMB_DESC",		"#TITAN_DECAL_FALLINGBOMB_REQ",			"#TITAN_DECAL_FALLINGBOMB_REQUNLOCKED",			"../models/titans/custom_decals/decal_pack_01/titan_decal_fallingbomb_menu",		false )
	CreateDecalData( itemType.TITAN_DECAL, "titan_decal_grenade",			"#TITAN_DECAL_GRENADE_NAME",			"#TITAN_DECAL_GRENADE_DESC",			"#TITAN_DECAL_GRENADE_REQ",				"#TITAN_DECAL_GRENADE_REQUNLOCKED",				"../models/titans/custom_decals/decal_pack_01/titan_decal_grenade_menu",			false )
	CreateDecalData( itemType.TITAN_DECAL, "titan_decal_firsttofall",		"#TITAN_DECAL_FIRSTTOFALL_NAME",		"#TITAN_DECAL_FIRSTTOFALL_DESC",		"#TITAN_DECAL_FIRSTTOFALL_REQ",			"#TITAN_DECAL_FIRSTTOFALL_REQUNLOCKED",			"../models/titans/custom_decals/decal_pack_01/titan_decal_firsttofall_menu",		false )
	CreateDecalData( itemType.TITAN_DECAL, "titan_decal_pennyarcade",		"#TITAN_DECAL_PENNYARCADE_NAME",		"#TITAN_DECAL_PENNYARCADE_DESC",		"#TITAN_DECAL_PENNYARCADE_REQ",			"#TITAN_DECAL_PENNYARCADE_REQUNLOCKED",			"../models/titans/custom_decals/decal_pack_01/titan_decal_pennyarcade_menu",		false )
	CreateDecalData( itemType.TITAN_DECAL, "titan_decal_dragon",			"#TITAN_DECAL_DRAGON_NAME",				"#TITAN_DECAL_DRAGON_DESC",				"#TITAN_DECAL_DRAGON_REQ",				"#TITAN_DECAL_DRAGON_REQUNLOCKED",				"../models/titans/custom_decals/decal_pack_01/titan_decal_dragon_menu",				false )
	CreateDecalData( itemType.TITAN_DECAL, "titan_decal_respawnbird",		"#TITAN_DECAL_RESPAWNBIRD_NAME",		"#TITAN_DECAL_RESPAWNBIRD_DESC",		"#TITAN_DECAL_RESPAWNBIRD_REQ",			"#TITAN_DECAL_RESPAWNBIRD_REQUNLOCKED",			"../models/titans/custom_decals/decal_pack_01/titan_decal_respawnbird_menu",		false )
	CreateDecalData( itemType.TITAN_DECAL, "titan_decal_wonjae",			"#TITAN_DECAL_WONJAE_NAME",				"#TITAN_DECAL_WONJAE_DESC",				null,									null,											"../models/titans/custom_decals/decal_pack_01/titan_decal_wonjae_menu",				false )
	CreateDecalData( itemType.TITAN_DECAL, "titan_decal_lastimosa",			"#TITAN_DECAL_LASTIMOSA_NAME",			"#TITAN_DECAL_LASTIMOSA_DESC",			"#TITAN_DECAL_LASTIMOSA_REQ",			"#TITAN_DECAL_LASTIMOSA_REQUNLOCKED",			"../models/titans/custom_decals/decal_pack_01/titan_decal_lastimosa_menu",			false )

	CreateDecalData( itemType.TITAN_DECAL, "titan_decal_austin",			"#TITAN_DECAL_AUSTIN_NAME",				"#TITAN_DECAL_AUSTIN_DESC",				"#TITAN_DECAL_AUSTIN_REQ",				"#TITAN_DECAL_AUSTIN_REQUNLOCKED",				"../models/titans/custom_decals/decal_pack_01/titan_decal_austin_menu",				false )
	CreateDecalData( itemType.TITAN_DECAL, "titan_decal_cobra",				"#TITAN_DECAL_COBRA_NAME",				"#TITAN_DECAL_COBRA_DESC",				null,									null,											"../models/titans/custom_decals/decal_pack_01/titan_decal_cobra_menu",				false )
	CreateDecalData( itemType.TITAN_DECAL, "titan_decal_gunwing",			"#TITAN_DECAL_GUNWING_NAME",			"#TITAN_DECAL_GUNWING_DESC",			null,									null,											"../models/titans/custom_decals/decal_pack_01/titan_decal_gunwing_menu",			false )
	CreateDecalData( itemType.TITAN_DECAL, "titan_decal_hashtag",			"#TITAN_DECAL_HASHTAG_NAME",			"#TITAN_DECAL_HASHTAG_DESC",			null,									null,											"../models/titans/custom_decals/decal_pack_01/titan_decal_hashtag_menu",			false )
	CreateDecalData( itemType.TITAN_DECAL, "titan_decal_nomercy",			"#TITAN_DECAL_NOMERCY_NAME",			"#TITAN_DECAL_NOMERCY_DESC",			"#TITAN_DECAL_NOMERCY_REQ",				"#TITAN_DECAL_NOMERCY_REQUNLOCKED",				"../models/titans/custom_decals/decal_pack_01/titan_decal_nomercy_menu",			false )
	CreateDecalData( itemType.TITAN_DECAL, "titan_decal_pegasus",			"#TITAN_DECAL_PEGASUS_NAME",			"#TITAN_DECAL_PEGASUS_DESC",			null,									null,											"../models/titans/custom_decals/decal_pack_01/titan_decal_pegasus_menu",			false )
	CreateDecalData( itemType.TITAN_DECAL, "titan_decal_sword",				"#TITAN_DECAL_SWORD_NAME",				"#TITAN_DECAL_SWORD_DESC",				null,									null,											"../models/titans/custom_decals/decal_pack_01/titan_decal_sword_menu",				false )
	CreateDecalData( itemType.TITAN_DECAL, "titan_decal_gooser",			"#TITAN_DECAL_GOOSER_NAME",				"#TITAN_DECAL_GOOSER_DESC",				"#TITAN_DECAL_GOOSER_REQ",				"#TITAN_DECAL_GOOSER_REQUNLOCKED",				"../models/titans/custom_decals/decal_pack_01/titan_decal_gooser_menu",				true )
	CreateDecalData( itemType.TITAN_DECAL, "titan_decal_padoublethreat",	"#TITAN_DECAL_PADOUBLETHREAT_NAME",		"#TITAN_DECAL_PADOUBLETHREAT_DESC",		null,									null,											"../models/titans/custom_decals/decal_pack_01/titan_decal_padoublethreat_menu",		false )

	CreateDecalData( itemType.TITAN_DECAL, "titan_decals_blackmarket01",	"#TITAN_DECAL_BLACKMARKET01_NAME",		"#TITAN_DECAL_BLACKMARKET01_DESC",		"#TITAN_DECAL_BLACKMARKET_REQ",			"#TITAN_DECAL_BLACKMARKET_REQUNLOCKED",			"../models/titans/custom_decals/decal_pack_01/titan_decals_blackmarket01_menu",		false )
	CreateDecalData( itemType.TITAN_DECAL, "titan_decals_blackmarket02",	"#TITAN_DECAL_BLACKMARKET02_NAME",		"#TITAN_DECAL_BLACKMARKET02_DESC",		"#TITAN_DECAL_BLACKMARKET_REQ",			"#TITAN_DECAL_BLACKMARKET_REQUNLOCKED",			"../models/titans/custom_decals/decal_pack_01/titan_decals_blackmarket02_menu",		false )
	CreateDecalData( itemType.TITAN_DECAL, "titan_decals_blackmarket03",	"#TITAN_DECAL_BLACKMARKET03_NAME",		"#TITAN_DECAL_BLACKMARKET03_DESC",		"#TITAN_DECAL_BLACKMARKET_REQ",			"#TITAN_DECAL_BLACKMARKET_REQUNLOCKED",			"../models/titans/custom_decals/decal_pack_01/titan_decals_blackmarket03_menu",		false )
	CreateDecalData( itemType.TITAN_DECAL, "titan_decals_blackmarket04",	"#TITAN_DECAL_BLACKMARKET04_NAME",		"#TITAN_DECAL_BLACKMARKET04_DESC",		"#TITAN_DECAL_BLACKMARKET_REQ",			"#TITAN_DECAL_BLACKMARKET_REQUNLOCKED",			"../models/titans/custom_decals/decal_pack_01/titan_decals_blackmarket04_menu",		false )
	CreateDecalData( itemType.TITAN_DECAL, "titan_decals_blackmarket05",	"#TITAN_DECAL_BLACKMARKET05_NAME",		"#TITAN_DECAL_BLACKMARKET05_DESC",		"#TITAN_DECAL_BLACKMARKET_REQ",			"#TITAN_DECAL_BLACKMARKET_REQUNLOCKED",			"../models/titans/custom_decals/decal_pack_01/titan_decals_blackmarket05_menu",		false )
	CreateDecalData( itemType.TITAN_DECAL, "titan_decals_blackmarket06",	"#TITAN_DECAL_BLACKMARKET06_NAME",		"#TITAN_DECAL_BLACKMARKET06_DESC",		"#TITAN_DECAL_BLACKMARKET_REQ",			"#TITAN_DECAL_BLACKMARKET_REQUNLOCKED",			"../models/titans/custom_decals/decal_pack_01/titan_decals_blackmarket06_menu",		false )
	CreateDecalData( itemType.TITAN_DECAL, "titan_decals_blackmarket07",	"#TITAN_DECAL_BLACKMARKET07_NAME",		"#TITAN_DECAL_BLACKMARKET07_DESC",		"#TITAN_DECAL_BLACKMARKET_REQ",			"#TITAN_DECAL_BLACKMARKET_REQUNLOCKED",			"../models/titans/custom_decals/decal_pack_01/titan_decals_blackmarket07_menu",		false )
	CreateDecalData( itemType.TITAN_DECAL, "titan_decals_blackmarket08",	"#TITAN_DECAL_BLACKMARKET08_NAME",		"#TITAN_DECAL_BLACKMARKET08_DESC",		"#TITAN_DECAL_BLACKMARKET_REQ",			"#TITAN_DECAL_BLACKMARKET_REQUNLOCKED",			"../models/titans/custom_decals/decal_pack_01/titan_decals_blackmarket08_menu",		false )
	CreateDecalData( itemType.TITAN_DECAL, "titan_decal_export",			"#TITAN_DECAL_EXPORT_NAME",				"#TITAN_DECAL_EXPORT_DESC",				"#TITAN_DECAL_EXPORT_REQ",				"#TITAN_DECAL_EXPORT_REQUNLOCKED",				"../models/titans/custom_decals/decal_pack_01/titan_decal_export_menu",				false )

	CreateDecalData( itemType.TITAN_DECAL, "titan_decal_harmony",			"#TITAN_DECAL_HARMONY_NAME",			"#TITAN_DECAL_HARMONY_DESC",			"#TITAN_DECAL_HARMONY_REQ",				"#TITAN_DECAL_HARMONY_REQUNLOCKED",				"../models/titans/custom_decals/decal_pack_01/titan_decal_harmony_menu",			false )
	CreateDecalData( itemType.TITAN_DECAL, "titan_decal_haven",				"#TITAN_DECAL_HAVEN_NAME",				"#TITAN_DECAL_HAVEN_DESC",				"#TITAN_DECAL_HAVEN_REQ",				"#TITAN_DECAL_HAVEN_REQUNLOCKED",				"../models/titans/custom_decals/decal_pack_01/titan_decal_haven_menu",				false )
	CreateDecalData( itemType.TITAN_DECAL, "titan_decal_ichicat",			"#TITAN_DECAL_ICHICAT_NAME",			"#TITAN_DECAL_ICHICAT_DESC",			"#TITAN_DECAL_ICHICAT_REQ",				"#TITAN_DECAL_ICHICAT_REQUNLOCKED",				"../models/titans/custom_decals/decal_pack_01/titan_decal_ichicat_menu",			false )
	CreateDecalData( itemType.TITAN_DECAL, "titan_decal_pf",				"#TITAN_DECAL_PF_NAME",					"#TITAN_DECAL_PF_DESC",					"#TITAN_DECAL_PF_REQ",					"#TITAN_DECAL_PF_REQUNLOCKED",					"../models/titans/custom_decals/decal_pack_01/titan_decal_PF_menu",					false )
	CreateDecalData( itemType.TITAN_DECAL, "titan_decal_coop_1",			"#TITAN_DECAL_COOP_VETERAN_NAME",		"#TITAN_DECAL_COOP_VETERAN_DESC",		"#TITAN_DECAL_COOP_VETERAN_REQ",		"#TITAN_DECAL_COOP_VETERAN_REQUNLOCKED",		"../models/titans/custom_decals/decal_pack_01/titan_decals_FTveteran_menu",			false )
	CreateDecalData( itemType.TITAN_DECAL, "titan_decal_coop_2",			"#TITAN_DECAL_COOP_ELITE_NAME",			"#TITAN_DECAL_COOP_ELITE_DESC",			"#TITAN_DECAL_COOP_ELITE_REQ",			"#TITAN_DECAL_COOP_ELITE_REQUNLOCKED",			"../models/titans/custom_decals/decal_pack_01/titan_decals_FTelite_menu",			false )
	CreateDecalData( itemType.TITAN_DECAL, "titan_decals_3s_attrition",		"#TITAN_DECALS_3S_ATTRITION_NAME",		"#TITAN_DECALS_3S_ATTRITION_DESC",		"#TITAN_DECALS_3S_ATTRITION_REQ",		"#TITAN_DECALS_3S_ATTRITION_REQUNLOCKED",		"../models/titans/custom_decals/decal_pack_01/titan_decals_3S_attrition_menu",		false )
	CreateDecalData( itemType.TITAN_DECAL, "titan_decals_3s_ctf",			"#TITAN_DECALS_3S_CTF_NAME",			"#TITAN_DECALS_3S_CTF_DESC",			"#TITAN_DECALS_3S_CTF_REQ",				"#TITAN_DECALS_3S_CTF_REQUNLOCKED",				"../models/titans/custom_decals/decal_pack_01/titan_decals_3S_CTF_menu",			false )
	CreateDecalData( itemType.TITAN_DECAL, "titan_decals_3s_frontierdef",	"#TITAN_DECALS_3S_FRONTIERDEF_NAME",	"#TITAN_DECALS_3S_FRONTIERDEF_DESC",	"#TITAN_DECALS_3S_FRONTIERDEF_REQ",		"#TITAN_DECALS_3S_FRONTIERDEF_REQUNLOCKED",		"../models/titans/custom_decals/decal_pack_01/titan_decals_3S_frontierDef_menu",	false )

	CreateDecalData( itemType.TITAN_DECAL, "titan_decals_3s_hardpoint",		"#TITAN_DECALS_3S_HARDPOINT_NAME",		"#TITAN_DECALS_3S_HARDPOINT_DESC",		"#TITAN_DECALS_3S_HARDPOINT_REQ",		"#TITAN_DECALS_3S_HARDPOINT_REQUNLOCKED",		"../models/titans/custom_decals/decal_pack_01/titan_decals_3S_hardpoint_menu",		false )
	CreateDecalData( itemType.TITAN_DECAL, "titan_decals_3s_lts",			"#TITAN_DECALS_3S_LTS_NAME",			"#TITAN_DECALS_3S_LTS_DESC",			"#TITAN_DECALS_3S_LTS_REQ",				"#TITAN_DECALS_3S_LTS_REQUNLOCKED",				"../models/titans/custom_decals/decal_pack_01/titan_decals_3S_LTS_menu",			false )
	CreateDecalData( itemType.TITAN_DECAL, "titan_decals_3s_marked4death",	"#TITAN_DECALS_3S_MARKED4DEATH_NAME",	"#TITAN_DECALS_3S_MARKED4DEATH_DESC",	"#TITAN_DECALS_3S_MARKED4DEATH_REQ",	"#TITAN_DECALS_3S_MARKED4DEATH_REQUNLOCKED",	"../models/titans/custom_decals/decal_pack_01/titan_decals_3S_marked4death_menu",	false )
	CreateDecalData( itemType.TITAN_DECAL, "titan_decals_3s_pilothunter",	"#TITAN_DECALS_3S_PILOTHUNTER_NAME",	"#TITAN_DECALS_3S_PILOTHUNTER_DESC",	"#TITAN_DECALS_3S_PILOTHUNTER_REQ",		"#TITAN_DECALS_3S_PILOTHUNTER_REQUNLOCKED",		"../models/titans/custom_decals/decal_pack_01/titan_decals_3S_pilothunter_menu",	false )

	CreateR1DeltaItems()

	// Sort some items based on unlock level
	itemsOfType[itemType.PILOT_PRIMARY].sort( SortByUnlockReq )
	itemsOfType[itemType.PILOT_SECONDARY].sort( SortByUnlockReq )
	itemsOfType[itemType.PILOT_SIDEARM].sort( SortByUnlockReq )
	itemsOfType[itemType.PILOT_SPECIAL].sort( SortByUnlockReq )
	itemsOfType[itemType.PILOT_ORDNANCE].sort( SortByUnlockReq )
	itemsOfType[itemType.PILOT_PASSIVE1].sort( SortByUnlockReq )
	itemsOfType[itemType.PILOT_PASSIVE2].sort( SortByUnlockReq )
	itemsOfType[itemType.TITAN_PRIMARY].sort( SortByUnlockReq )
	itemsOfType[itemType.TITAN_ORDNANCE].sort( SortByUnlockReq )
	itemsOfType[itemType.TITAN_SPECIAL].sort( SortByUnlockReq )
	itemsOfType[itemType.TITAN_PASSIVE1].sort( SortByUnlockReq )
	itemsOfType[itemType.TITAN_PASSIVE2].sort( SortByUnlockReq )

	if ( !IsUI() )
	{
		// Non-player weapons
		PrecacheWeapon( "mp_weapon_yh803" )
		PrecacheWeapon( "mp_turretweapon_rockets" )
		PrecacheWeapon( "mp_weapon_yh803_bullet" )

		// Weapons in progress
		if ( developer() > 0 )
		{
			//PrecacheWeapon( "mp_titanweapon_shotgun" )
			PrecacheWeapon( "mp_titanweapon_sniper" )
			PrecacheWeapon( "mp_weapon_pss" )

			for ( local i = 1; i <= 10; i++ )
				PrecacheWeapon( "mp_weapon_mega" + i )
		}

		if ( IsClient() )
			PrecacheHUDMaterial( MOD_ICON_NONE )
	}
}

function CreateR1DeltaItems()
{
	local HideFromMenus = false

	// R1 Delta custom stuff
	// When you add a new item here, the game will start looking for it in _pdef.nut
	// If its a mod or attachment, the game will look for [WEAPON_NAME] + [MOD_NAME] (ex: mp_weapon_car_holosight, mp_weapon_autopistol_starburst )
	// So make sure to add it to the right category

	////////////////////
	//PILOT ATTACHMENT DATA
	////////////////////
	CreateAttachmentData( itemType.PILOT_PRIMARY_ATTACHMENT,	DEV_ENABLED,	0, 		"ch_car_grunt_kills", 		1,		"mp_weapon_car",		"holosight",	"#MOD_HOLOSIGHT_NAME",		"#MOD_HOLOSIGHT_DESC",		"#MOD_HOLOSIGHT_LONGDESC",				"../ui/menu/items/attachment_icons/holosight", 			"../ui/menu/items/attachment_icons/holosight" )
	CreateAttachmentData( itemType.PILOT_PRIMARY_ATTACHMENT,	DEV_ENABLED,	0, 		"ch_r97_grunt_kills", 		1,		"mp_weapon_r97",		"holosight",	"#MOD_HOLOSIGHT_NAME",		"#MOD_HOLOSIGHT_DESC",		"#MOD_HOLOSIGHT_LONGDESC",				"../ui/menu/items/attachment_icons/holosight", 			"../ui/menu/items/attachment_icons/holosight" )
	//CreateAttachmentData( itemType.PILOT_PRIMARY_ATTACHMENT,	DEV_ENABLED,	0, 		"ch_car_kills",		 		2,		"mp_weapon_car",		"aog",			"#MOD_AOG_NAME",			"#MOD_AOG_DESC",			"#MOD_AOG_LONGDESC",					"../ui/menu/items/attachment_icons/aog", 				"../ui/menu/items/attachment_icons/aog" )
	CreateAttachmentData( itemType.PILOT_PRIMARY_ATTACHMENT,	DEV_ENABLED,	0, 		"ch_r97_kills",		 		2,		"mp_weapon_r97",		"aog",			"#MOD_AOG_NAME",			"#MOD_AOG_DESC",			"#MOD_AOG_LONGDESC",					"../ui/menu/items/attachment_icons/aog", 				"../ui/menu/items/attachment_icons/aog" )

	////////////////////
	//PILOT MOD DATA
	////////////////////
	CreateModData( itemType.PILOT_SIDEARM_MOD,		DEV_ENABLED,	0, 	"ch_autopistol_spectre_kills", 		1, 		"mp_weapon_autopistol",		"extended_ammo",				"#MOD_EXTENDED_MAG_NAME",		"#MOD_EXTENDED_MAG_DESC",			"#MOD_EXTENDED_MAG_LONGDESC",			0, 0, 0, 0, 10, 		"../ui/menu/items/mod_icons/extended_ammo", 		"../ui/menu/items/mod_icons/extended_ammo" )
	CreateModData( itemType.PILOT_SIDEARM_MOD,		DEV_ENABLED,	0, 	"ch_autopistol_kills", 				1, 		"mp_weapon_autopistol",		"silencer",						"#MOD_SILENCER_NAME",			"#MOD_SILENCER_DESC",				"#MOD_SILENCER_LONGDESC",				-5, -5, -5, 0, 0, 		"../ui/menu/items/mod_icons/silencer", 				"../ui/menu/items/mod_icons/silencer" )
	CreateModData( itemType.PILOT_SIDEARM_MOD,		DEV_ENABLED,	0, 	"ch_autopistol_pilot_kills", 		1, 		"mp_weapon_autopistol",		"starburst",					"#MOD_STARBURST_NAME",			"#MOD_STARBURST_DESC",				"#MOD_STARBURST_AUTOPISTOL_LONGDESC",	0, -5, 0, 10, 0, 		"../ui/menu/items/mod_icons/starburst", 			"../ui/menu/items/mod_icons/starburst" )
	CreateModData( itemType.PILOT_SIDEARM_MOD,		DEV_ENABLED,	0, 	"ch_autopistol_headshots", 			1, 		"mp_weapon_autopistol",		"recoil_compensator",			"#MOD_RECOIL_COMPENSATOR_NAME",	"#MOD_RECOIL_COMPENSATOR_DESC",		"#MOD_RECOIL_COMPENSATOR_LONGDESC",		0, 10, 0, 0, 0, 			"../ui/menu/items/mod_icons/recoil_compensator_v2",	"../ui/menu/items/mod_icons/recoil_compensator_v2" )

	CreateModData( itemType.PILOT_SIDEARM_MOD,		DEV_ENABLED,	0, 	"ch_semipistol_spectre_kills", 		1, 		"mp_weapon_semipistol",		"extended_ammo",				"#MOD_EXTENDED_MAG_NAME",		"#MOD_EXTENDED_MAG_DESC",			"#MOD_EXTENDED_MAG_LONGDESC",			0, 0, 0, 0, 3, 			"../ui/menu/items/mod_icons/extended_ammo", 		"../ui/menu/items/mod_icons/extended_ammo" )
	CreateModData( itemType.PILOT_SIDEARM_MOD,		DEV_ENABLED,	0, 	"ch_semipistol_kills", 				1, 		"mp_weapon_semipistol",		"silencer",						"#MOD_SILENCER_NAME",			"#MOD_SILENCER_DESC",				"#MOD_SILENCER_LONGDESC",				-5, -5, -2, 0, 0, 		"../ui/menu/items/mod_icons/silencer", 				"../ui/menu/items/mod_icons/silencer" )
	CreateModData( itemType.PILOT_SIDEARM_MOD,		DEV_ENABLED,	0, 	"ch_semipistol_pilot_kills", 		1, 		"mp_weapon_semipistol",		"match_trigger",				"#MOD_MATCH_TRIGGER_NAME",		"#MOD_MATCH_TRIGGER_DESC",			"#MOD_MATCH_TRIGGER_LONGDESC",			0, -8, 0, 10, 0, 		"../ui/menu/items/mod_icons/match_trigger", 		"../ui/menu/items/mod_icons/match_trigger" )

	CreateModData( itemType.PILOT_SIDEARM_MOD,		DEV_ENABLED,	0, 	"ch_wingman_kills", 				1, 		"mp_weapon_wingman",		"silencer",						"#MOD_SILENCER_NAME",			"#MOD_SILENCER_DESC",				"#MOD_SILENCER_LONGDESC",				-10, 0, -5, 0, 0, 		"../ui/menu/items/mod_icons/silencer", 				"../ui/menu/items/mod_icons/silencer" )
	CreateModData( itemType.PILOT_SIDEARM_MOD,		DEV_ENABLED,	0, 	"ch_wingman_pilot_kills", 			1, 		"mp_weapon_wingman",		"explosive_rounds",				"#MOD_EXPLOSIVE_ROUNDS_NAME",	"#MOD_EXPLOSIVE_ROUNDS_DESC",		"#MOD_EXPLOSIVE_ROUNDS_DESC",			15, 0, 0, -2, 0, 		"../ui/menu/items/mod_icons/explosive_rounds", 		"../ui/menu/items/mod_icons/explosive_rounds" )

	CreateModData( itemType.PILOT_SECONDARY_MOD,	DEV_ENABLED,	0, 	"ch_smr_crits", 					1, 		"mp_weapon_smr",			"tank_buster",					"#MOD_TANK_BUSTER_NAME",		"#MOD_TANK_BUSTER_DESC",			"#MOD_TANK_BUSTER_DESC",				20, 0, 0, -10, -13, 	"../ui/menu/items/mod_icons/tank_buster",			"../ui/menu/items/mod_icons/tank_buster" )
	CreateModData( itemType.PILOT_SECONDARY_MOD,	DEV_ENABLED,	0, 	"ch_smr_titan_kills", 				1, 		"mp_weapon_smr",			"stabilized_warhead",			"#MOD_STABILIZED_WARHEAD_NAME",	"#MOD_STABILIZED_WARHEAD_DESC",		"#MOD_STABILIZED_WARHEAD_DESC",			0, 15, 0, -13, 0, 		"../ui/menu/items/mod_icons/stabilized_warhead",	"../ui/menu/items/mod_icons/stabilized_warhead" )

	CreateModData( itemType.PILOT_SECONDARY_MOD,	DEV_DISABLED,	0, 	"ch_archer_titan_kills", 			1, 		"mp_weapon_rocket_launcher","guided_missile",				"#MOD_GUIDED_MISSILE_NAME",		"#MOD_GUIDED_MISSILE_DESC",			"#MOD_GUIDED_MISSILE_DESC",				0, 0, 0, 0, 0, 			"../ui/menu/items/mod_icons/rapid_fire_missiles",	"../ui/menu/items/mod_icons/rapid_fire_missiles", HideFromMenus )

	CreateModData( itemType.PILOT_SECONDARY_MOD,	DEV_ENABLED,	0, 	"ch_mgl_titan_kills", 				1, 		"mp_weapon_mgl",			"long_fuse",					"#MOD_LONG_FUSE_NAME",			"#MOD_LONG_FUSE_DESC",				"#MOD_LONG_FUSE_DESC",					0, 0, 0, 0, 0, 			"../ui/menu/items/mod_icons/long_fuse",				"../ui/menu/items/mod_icons/long_fuse" )

	CreateWeaponData( itemType.PILOT_PRIMARY, 		DEV_ENABLED,	0, 		null, 	null, "mp_weapon_mega1", 				"../ui/menu/items/weapon_valkyrie" )
	CreateWeaponData( itemType.PILOT_SIDEARM, 		DEV_ENABLED,	0, 		null, 	null, "mp_weapon_mega2", 				"../ui/menu/items/weapon_twinbshotgun" )

	CreateWeaponData( itemType.PILOT_PRIMARY, 		DEV_DISABLED,	0, 		null, 	null, "mp_weapon_mega5", 				"../ui/menu/items/weapon_valkyrie", null, null, HideFromMenus )

	CreateAttachmentData( itemType.PILOT_PRIMARY_ATTACHMENT,	DEV_ENABLED,	0, 		null, 						null, 	"mp_weapon_mega1",		"scope_6x",		"#MOD_SCOPE_6X_NAME",		"#MOD_SCOPE_6X_DESC",		"#MOD_SCOPE_6X_LONGDESC",				"../ui/menu/items/attachment_icons/scope_6x", 			"../ui/menu/items/attachment_icons/scope_6x" )
	CreateAttachmentData( itemType.PILOT_PRIMARY_ATTACHMENT,	DEV_ENABLED,	0, 		"ch_valkyrie_grunt_kills", 	0, 		"mp_weapon_mega1",		"aog",			"#MOD_AOG_NAME",			"#MOD_AOG_DESC",			"#MOD_AOG_LONGDESC",					"../ui/menu/items/attachment_icons/aog", 				"../ui/menu/items/attachment_icons/aog" )
	CreateAttachmentData( itemType.PILOT_PRIMARY_ATTACHMENT,	DEV_ENABLED,	0, 		"ch_valkyrie_kills", 			1, 		"mp_weapon_mega1",		"scope_4x",		"#MOD_SCOPE_4X_NAME",		"#MOD_SCOPE_4X_DESC",		"#MOD_SCOPE_4X_LONGDESC",				"../ui/menu/items/attachment_icons/aog", 				"../ui/menu/items/attachment_icons/scope_4" )
	CreateModData( itemType.PILOT_PRIMARY_MOD,		DEV_ENABLED,	0, 	"ch_valkyrie_spectre_kills", 			0, 		"mp_weapon_mega1",			"extended_ammo",				"#MOD_EXTENDED_MAG_NAME",		"#MOD_EXTENDED_MAG_DESC",			"#MOD_EXTENDED_MAG_LONGDESC",			0, 0, 0, 0, 2, 			"../ui/menu/items/mod_icons/extended_ammo", 		"../ui/menu/items/mod_icons/extended_ammo" )
	CreateModData( itemType.PILOT_PRIMARY_MOD,		DEV_ENABLED,	0, 	"ch_valkyrie_kills", 					0, 		"mp_weapon_mega1",			"silencer",						"#MOD_SILENCER_NAME",			"#MOD_SILENCER_DESC",				"#MOD_SILENCER_LONGDESC",				-10, 0, -5, 0, 0, 		"../ui/menu/items/mod_icons/silencer", 				"../ui/menu/items/mod_icons/silencer" )
	CreateModData( itemType.PILOT_PRIMARY_MOD,		DEV_ENABLED,	0, 	"ch_valkyrie_pilot_kills", 				0, 		"mp_weapon_mega1",			"stabilizer",					"#MOD_STABILIZER_NAME",			"#MOD_STABILIZER_DESC",				"#MOD_STABILIZER_LONGDESC",				0, 6, 0, 0, 0, 			"../ui/menu/items/mod_icons/stabilizer", 			"../ui/menu/items/mod_icons/stabilizer" )
	CreateModData( itemType.PILOT_PRIMARY_MOD,		DEV_DISABLED,	0, 	null, 	null, "mp_weapon_mega1",			"burn_mod_valkyrie", 				"#BC_VALKYRIE_M2",			"#BC_VALKYRIE_M2_FLYOUT_DESC",			"#BC_VALKYRIE_M2_FLYOUT_DESC",			0, 0, 0, 0, 0,	 	"../ui/temp",	"../ui/temp",	HideFromMenus )

	CreateModData( itemType.PILOT_SIDEARM_MOD,		DEV_ENABLED,	0, 	"ch_twinb_pilot_kills",			1, 		"mp_weapon_mega2",		"spread_increase_sg",			"#MOD_SPREAD_INCREASE_SG_NAME",	"#MOD_SPREAD_INCREASE_SG_DESC",		"#MOD_SPREAD_INCREASE_SG_LONGDESC",		-10, 10, 0, 0, 0, 		"../ui/menu/items/mod_icons/leadwall", 				"../ui/menu/items/mod_icons/leadwall" )
	CreateModData( itemType.PILOT_SIDEARM_MOD,		DEV_ENABLED,	0, 	"ch_twinb_kills", 				1, 		"mp_weapon_mega2",		"silencer",						"#MOD_SILENCER_NAME",			"#MOD_SILENCER_DESC",				"#MOD_SILENCER_LONGDESC",				-5, 5, -5, 0, 0, 		"../ui/menu/items/mod_icons/silencer", 				"../ui/menu/items/mod_icons/silencer" )
	CreateModData( itemType.PILOT_SIDEARM_MOD,		DEV_DISABLED,	0, 	null, 	null, "mp_weapon_mega2",			"burn_mod_twinb", 			"#BC_TWINB_SHOTGUN_M2",			"#BC_TWINB_SHOTGUN_M2_FLYOUT_DESC",			"#BC_TWINB_SHOTGUN_M2_FLYOUT_DESC",			0, 0, 0, 0, 0,	 	"../ui/temp",	"../ui/temp",	HideFromMenus )

	////////////////////
	//TITAN WEAPON DATA
	////////////////////
	CreateWeaponData( itemType.TITAN_PRIMARY, 		DEV_ENABLED,	0, 		null, 	null, "mp_titanweapon_shotgun", 				"../ui/menu/items/titanweapon_shotgun" )

	// DEV_DISABLED for now, they're extremely OP
	CreateWeaponData( itemType.TITAN_PRIMARY, 		DEV_DISABLED,	0, 		null, 	null, "mp_weapon_mega3", 				"../ui/menu/items/titanweapon_minigun", null, null, HideFromMenus )
	CreateWeaponData( itemType.TITAN_SPECIAL,		DEV_ENABLED,	0, 		null, 	null, "mp_weapon_mega4", 				"../ui/menu/items/ability_icons/charge_cannon",				"../ui/menu/items/ability_icons/charge_cannon", null )

	CreateWeaponData( itemType.TITAN_ORDNANCE,		DEV_ENABLED,	0,		null, 	null, "mp_titanweapon_shoulder_turret", 	"../ui/menu/items/titanweapon_shoulder_rockets",		"HUD/coop/mini_turret_counter", 	"../ui/menu/items/titanweapon_shoulder_rockets", HideFromMenus )

	////////////////////
	//TITAN MOD DATA
	////////////////////
	CreateModData( itemType.TITAN_PRIMARY_MOD,	 	DEV_ENABLED,	0, 	"ch_triple_threat_pilot_kills",		 	1, 		"mp_titanweapon_triple_threat",		"hydraulic_launcher",		"#MOD_HYDRAULIC_LAUNCHER_NAME",			"#MOD_HYDRAULIC_LAUNCHER_DESC",			"#MOD_HYDRAULIC_LAUNCHER_DESC",			0, 0, 7, -5, 0, 		"../ui/menu/items/mod_icons/hydraulic_launcher", 		"../ui/menu/items/mod_icons/hydraulic_launcher" )
	CreateModData( itemType.TITAN_PRIMARY_MOD,	 	DEV_ENABLED,	0, 	"ch_titan_shotgun_kills", 					1, 		"mp_titanweapon_shotgun",				"extended_ammo",		"#MOD_EXTENDED_MAG_NAME",			"#MOD_EXTENDED_MAG_DESC",			"#MOD_EXTENDED_MAG_LONGDESC",			0, 0, 0, 0, 3, 		"../ui/menu/items/mod_icons/extended_ammo", 		"../ui/menu/items/mod_icons/extended_ammo" )

	CreateModData( itemType.TITAN_PRIMARY_MOD,		DEV_DISABLED,	0, 	null, 	null, "mp_titanweapon_shotgun",				"burn_mod_titan_shotgun", 					"#BC_TITAN_SHOTGUN_M2",				"#BC_TITAN_SHOTGUN_M2_FLYOUT_DESC",				"#BC_TITAN_SHOTGUN_M2_FLYOUT_DESC",				0, 0, 0, 0, 0,	 	"../ui/temp",	"../ui/temp",	HideFromMenus )
	CreateModData( itemType.TITAN_PRIMARY_MOD,		DEV_DISABLED,	0, 	null, 	null, "mp_weapon_mega3",			"burn_mod_thunderbolt", 			"#BC_TITAN_MINIGUN_M2",			"#BC_TITAN_MINIGUN_M2_FLYOUT_DESC",			"#BC_TITAN_MINIGUN_M2_FLYOUT_DESC",			0, 0, 0, 0, 0,	 	"../ui/temp",	"../ui/temp",	HideFromMenus )
	CreateModData( itemType.TITAN_SPECIAL_MOD,		DEV_DISABLED,	0, 	null, 	null, "mp_weapon_mega4",			"burn_mod_charge_cannon", 			"#BC_TITAN_CHARGE_CANNON_M2",			"#BC_TITAN_CHARGE_CANNON_M2_FLYOUT_DESC",			"#BC_TITAN_CHARGE_CANNON_M2_FLYOUT_DESC",			0, 0, 0, 0, 0,	 	"../ui/temp",	"../ui/temp",	HideFromMenus )
	CheckBlackMarketModdedTitans()//May need to globalize item arrays and tables up top if this errors out for that.
}

function CheckBlackMarketModdedTitans()
{
	local loop_max = MasterModdedTitans.len()
	for( local E = 0; E < loop_max; E++ )
	{
		if( loop_max > 0 )
		{
			local t_a = MasterModdedTitans[ E ]
			
			BlackMarket_ITEMCALL( t_a.setfile, t_a.unlock_level, t_a.print_name, t_a.print_desc, t_a.titan_img_imc, t_a.titan_img_mcor, t_a.core_name, t_a.core_desc, t_a.core_img, t_a.stat_speed, t_a.stat_accel, t_a.stat_health, t_a.stat_boost_count )
		}
	}
}

function CreateBlackMarketModdedItems( modded_titan_place )
{
	/*
	local loop_max = MasterModdedTitans.len()
	for( local E = 0; E < loop_max; E++ )
	{
		if( loop_max > 0 )
		{
			local t_a = MasterModdedTitans[ E ]
			
			BlackMarket_ITEMCALL( t_a.setfile, t_a.unlock_level, t_a.print_name, t_a.print_desc, t_a.titan_img_imc, t_a.titan_img_mcor, t_a.core_name, t_a.core_desc, t_a.core_img, t_a.stat_speed, t_a.stat_accel, t_a.stat_health, t_a.stat_boost_count )
		}
	}
	*/
	local t_a = MasterModdedTitans[ modded_titan_place ]
	printl( "ADDING NEW MODDED TITAN" )
	BlackMarket_ITEMCALL( t_a.setfile, t_a.unlock_level, t_a.print_name, t_a.print_desc, t_a.titan_img_imc, t_a.titan_img_mcor, t_a.core_name, t_a.core_desc, t_a.core_img, t_a.stat_speed, t_a.stat_accel, t_a.stat_health, t_a.stat_boost_count )

}

function BlackMarket_ITEMCALL( name, unlock_level, game_name, game_desc, titan_img_imc, titan_img_mcor, core_name, core_desc, core_img, statSpeed, statAccel, statHealth, statDash )
{
	CreateSetFileData( itemType.TITAN_SETFILE,		DEV_ENABLED,	0, 	null, 	null, name,			game_name,		game_desc,	titan_img_imc,		titan_img_mcor, 	core_name,  core_desc, 		core_img,  		statSpeed, statAccel, statHealth, statDash )
	unlockLevels[ name ]	<- unlock_level
}

function CreateWeaponData( type, dev_enabled, levelReq, challengeReq, challengeTier, ref, image, icon = null, altImage = null, displayInMenu = true )
{
	ref = ref.tolower()
	Assert( !( ref in itemData ), "ref " + ref + " being redefined!" )

	if ( !IsUI() )
	{
		//printt( "ref:" + ref )
		PrecacheWeapon( ref )

		if ( IsClient() )
		{
			PrecacheHUDMaterial( image )
			if ( icon != null )
				PrecacheHUDMaterial( icon )
			if ( altImage != null )
				PrecacheHUDMaterial( altImage )
		}
	}

	itemData[ref] <- {}
	itemData[ref].type <- type
	itemData[ref].name <- GetWeaponInfoFileKeyField_Global( ref, "printname" )
	itemData[ref].desc <- GetWeaponInfoFileKeyField_Global( ref, "description" )
	itemData[ref].longdesc <- GetWeaponInfoFileKeyField_Global( ref, "longdesc" )
	itemData[ref].statDamage <- GetWeaponInfoFileKeyField_Global( ref, "stat_damage" )
	itemData[ref].statRange <- GetWeaponInfoFileKeyField_Global( ref, "stat_range" )
	itemData[ref].statAccuracy <- GetWeaponInfoFileKeyField_Global( ref, "stat_accuracy" )
	itemData[ref].statFireRate <- GetWeaponInfoFileKeyField_Global( ref, "stat_rof" )
	itemData[ref].clipSize <- GetWeaponInfoFileKeyField_Global( ref, "ammo_clip_size" )
	itemData[ref].image <- image
	itemData[ref].icon <- icon
	itemData[ref].altImage <- altImage
	itemData[ref].ref <- ref
	itemData[ref].subitems <- {}
	itemData[ref].dev_enabled <- dev_enabled
	itemData[ref].challengeReq <- challengeReq
	itemData[ref].challengeTier <- challengeTier
	itemData[ref].displayInMenu <- displayInMenu

	if ( displayInMenu )
	{
		if ( !( type in itemsOfType ) )
			itemsOfType[type] <- []
		itemsOfType[type].append( ref )

		allItems.append( { ref = ref, childRef = null, type = type } )

		UpdateChallengeRewardItems( ref, null, type, challengeReq, challengeTier )

		// Register the item type so the "bot_loadout" console command auto-complete
		// knows about it. Client only. If this auto-complete breaks then the item
		// type enum may be desynced between .nut and C++ source code. See Glenn.
		if ( IsClient() )
			RegisterItemType( type, ref )
	}
}

function GetUnlockLevelReq( ref, defaultReq = 0 )
{
	if ( ref in unlockLevels )
		return unlockLevels[ ref ]

	return defaultReq
}

function ItemDefined( ref )
{
	if ( ref in itemData )
		return true

	return false
}

function GetItemData( ref )
{
	return itemData[ref]
}

function GetItemType( ref )
{
	return itemData[ref].type
}

function GetItemName( ref )
{
	return itemData[ref].name
}

function GetItemDescription( ref )
{
	return itemData[ref].desc
}

function GetItemLongDescription( ref )
{
	return itemData[ref].longdesc
}

function GetItemAdditionalDescription( ref )
{
	return itemData[ref].additionalDesc
}

function GetItemAdditionalName( ref )
{
	return itemData[ref].additionalName
}

function GetItemImage( ref )
{
	return itemData[ref].image
}

function GetItemAltImage( ref )
{
	return itemData[ref].altImage
}

function GetItemIcon( ref )
{
	return itemData[ref].icon
}

function GetItemTeamImages( ref )
{
	return itemData[ref].teamImages
}

function GetItemCoreImage( ref )
{
	return itemData[ref].coreImage
}

function GetItemDamageStat( ref )
{
	return itemData[ref].statDamage
}

function GetSubitemDamageStat( parentRef, childRef )
{
	Assert( parentRef in itemData )
	Assert( "subitems" in itemData[parentRef] )

	if ( !( childRef in itemData[parentRef].subitems ) )
		return null

	return itemData[parentRef].subitems[childRef].statDamage
}

function GetItemAccuracyStat( ref )
{
	return itemData[ref].statAccuracy
}

function GetSubitemAccuracyStat( parentRef, childRef )
{
	Assert( parentRef in itemData )
	Assert( "subitems" in itemData[parentRef] )

	if ( !( childRef in itemData[parentRef].subitems ) )
		return null

	return itemData[parentRef].subitems[childRef].statAccuracy
}

function GetItemRangeStat( ref )
{
	return itemData[ref].statRange
}

function GetSubitemRangeStat( parentRef, childRef )
{
	Assert( parentRef in itemData )
	Assert( "subitems" in itemData[parentRef] )

	if ( !( childRef in itemData[parentRef].subitems ) )
		return null

	return itemData[parentRef].subitems[childRef].statRange
}

function GetItemFireRateStat( ref )
{
	return itemData[ref].statFireRate
}

function GetSubitemFireRateStat( parentRef, childRef )
{
	Assert( parentRef in itemData )
	Assert( "subitems" in itemData[parentRef] )

	if ( !( childRef in itemData[parentRef].subitems ) )
		return null

	return itemData[parentRef].subitems[childRef].statFireRate
}

function GetItemClipSize( ref )
{
	return itemData[ref].clipSize
}

function GetSubItemClipSizeStat( parentRef, childRef )
{
	Assert( parentRef in itemData )
	Assert( "subitems" in itemData[parentRef] )

	if ( !( childRef in itemData[parentRef].subitems ) )
		return null

	return itemData[parentRef].subitems[childRef].statClipSize
}

function GetItemSpeedStat( ref )
{
	return itemData[ref].statSpeed
}

function GetItemAccelStat( ref )
{
	return itemData[ref].statAccel
}

function GetItemHealthStat( ref )
{
	return itemData[ref].statHealth
}

function GetItemDashCountStat( ref )
{
	return itemData[ref].statDash
}

function GetItemDecalUnlockReqText( decalRef )
{
	Assert( decalRef in itemData )
	return itemData[decalRef].unlockReqText
}

function GetDecalHidden( decalRef )
{
	Assert( decalRef in itemData )
	return itemData[decalRef].hidden
}

function GetItemDecalUnlockReqUnlockedText( decalRef )
{
	Assert( decalRef in itemData )
	return itemData[decalRef].unlockReqUnlockedText
}

function GetDecalSkinForTeam( decalRef, team )
{
	Assert( decalRef in itemData )

	if ( team == TEAM_IMC )
		return itemData[decalRef].imcSkinIndex
	else if ( team == TEAM_MILITIA )
		return itemData[decalRef].mcorSkinIndex

	Assert( 0, "Can't set decal for a titan not on IMC or MILITIA" )
}

function GetRefFromItem( item )
{
	return item.ref
}

function SubitemDefined( parentRef, childRef )
{
	Assert( parentRef in itemData )
	Assert( "subitems" in itemData[parentRef] )

	if ( childRef in itemData[parentRef].subitems )
		return true

	return false
}

function GetSubitemData( parentRef, childRef )
{
	Assert( parentRef in itemData )
	Assert( "subitems" in itemData[parentRef] )

	return itemData[parentRef].subitems[childRef]
}

function GetSubitemType( parentRef, childRef )
{
	Assert( parentRef in itemData )
	Assert( "subitems" in itemData[parentRef] )

	return itemData[parentRef].subitems[childRef].type
}

function GetSubitemName( parentRef, childRef )
{
	Assert( parentRef in itemData )
	Assert( "subitems" in itemData[parentRef] )

	return itemData[parentRef].subitems[childRef].name
}

function TMPHasSubitem( parentRef, childRef )
{
	return (childRef in itemData[parentRef].subitems)
}

function GetSubitemDescription( parentRef, childRef )
{
	Assert( parentRef in itemData )
	Assert( "subitems" in itemData[parentRef] )

	return itemData[parentRef].subitems[childRef].desc
}

function GetSubitemLongDescription( parentRef, childRef )
{
	Assert( parentRef in itemData )
	Assert( "subitems" in itemData[parentRef] )

	return itemData[parentRef].subitems[childRef].longdesc
}

function GetSubitemImage( parentRef, childRef )
{
	Assert( parentRef in itemData )
	Assert( "subitems" in itemData[parentRef] )

	return itemData[parentRef].subitems[childRef].image
}

function GetSubitemIcon( parentRef, childRef )
{
	Assert( parentRef in itemData )
	Assert( "subitems" in itemData[parentRef] )

	return itemData[parentRef].subitems[childRef].icon
}

function GetAllItemsOfType( type, parentRef = null )
{
	Assert( type == itemType.PILOT_SETFILE ||
			type == itemType.PILOT_PRIMARY ||
			type == itemType.PILOT_SECONDARY ||
			type == itemType.PILOT_SIDEARM ||
			type == itemType.PILOT_SPECIAL ||
			type == itemType.PILOT_ORDNANCE ||
			type == itemType.PILOT_ORDNANCE_MOD ||
			type == itemType.PILOT_PRIMARY_ATTACHMENT ||
			type == itemType.PILOT_PRIMARY_MOD ||
			type == itemType.PILOT_SECONDARY_MOD ||
			type == itemType.PILOT_SIDEARM_MOD ||
			type == itemType.PILOT_PASSIVE1 ||
			type == itemType.PILOT_PASSIVE2 ||
			type == itemType.TITAN_SETFILE ||
			type == itemType.TITAN_PRIMARY ||
			type == itemType.TITAN_SPECIAL ||
			type == itemType.TITAN_ORDNANCE ||
			type == itemType.TITAN_PRIMARY_MOD ||
			type == itemType.TITAN_PASSIVE1 ||
			type == itemType.TITAN_PASSIVE2 ||
			type == itemType.EVENT_PASSIVE ||
			type == itemType.TITAN_DECAL   ||
			type == itemType.TITAN_OS
		)

	local items = []
	foreach ( ref in itemsOfType[type] )
		items.append( itemData[ref] )

	return items
}

function GetAllRefsOfType( type )
{
	return itemsOfType[type]
}

function GetAllItemRefs()
{
	return allItems
}

function GetItemForTypeIndex( type, index )
{
	local typeArray = itemsOfType[type]

	Assert( index >= 0 && index < typeArray.len() )

	return typeArray[index]
}

function CreateAttachmentData( type, dev_enabled, levelReq, challengeReq, challengeTier, parentRef, childRef, name, desc, longdesc, image, icon = null, displayInMenu = true )
{
	childRef = childRef.tolower()
	parentRef = parentRef.tolower()

	Assert( ItemTypeIsAttachment( type ) )
	Assert( parentRef in itemData, "Tried creating attachment: " + childRef + " when parent weapon: " + parentRef + " doesn't exist." )
	Assert( ItemTypeSupportsAttachments( GetItemType( parentRef ) ) )
	Assert( !( childRef in itemData[parentRef].subitems ), "childRef " + childRef + " being redefined!" )

	if ( IsClient() )
	{
		PrecacheHUDMaterial( image )

		if ( icon != null )
			PrecacheHUDMaterial( icon )
	}

	local attachmentData = {}
	attachmentData.type <- type
	attachmentData.ref <- childRef
	attachmentData.parentRef <- parentRef
	attachmentData.name <- name
	attachmentData.desc <- desc
	attachmentData.longdesc <- longdesc
	attachmentData.image <- image
	attachmentData.icon <- icon
	attachmentData.dev_enabled <- dev_enabled
	attachmentData.challengeReq <- challengeReq
	attachmentData.challengeTier <- challengeTier
	attachmentData.displayInMenu <- displayInMenu

	itemData[parentRef].subitems[childRef] <- attachmentData
	combinedModData[parentRef + "_" + childRef] <- attachmentData

	if ( displayInMenu )
	{
		if ( !( parentRef in attachmentsOfType ) )
			attachmentsOfType[parentRef] <- []
		attachmentsOfType[parentRef].append( childRef )

		if ( !( type in itemsOfType ) )
			itemsOfType[type] <- []
		itemsOfType[type].append( childRef )

		allItems.append( { ref = parentRef, childRef = childRef, type = type } )

		UpdateChallengeRewardItems( parentRef, childRef, type, challengeReq, challengeTier )
	}
}

function CreateModData( type, dev_enabled, levelReq, challengeReq, challengeTier, parentRef, childRef, name, desc, longdesc, statDamage, statAccuracy, statRange, statFireRate, statClipSize, image, icon = null, displayInMenu = true )
{
	childRef = childRef.tolower()
	parentRef = parentRef.tolower()

	Assert( ItemTypeIsMod( type ) )
	Assert( parentRef in itemData, "Tried creating mod: " + childRef + " when parent weapon: " + parentRef + " doesn't exist." )
	Assert( ItemTypeSupportsMods( GetItemType( parentRef ) ) )
	Assert( !( childRef in itemData[parentRef].subitems ), "childRef " + childRef + " being redefined!" )

	if ( IsClient() )
	{
		PrecacheHUDMaterial( image )

		if ( icon != null )
			PrecacheHUDMaterial( icon )
	}

	local modData = {}
	modData.type <- type
	modData.ref <- childRef
	modData.parentRef <- parentRef
	modData.name <- name
	modData.desc <- desc
	modData.longdesc <- longdesc
	modData.statDamage <- statDamage
	modData.statRange <- statRange
	modData.statAccuracy <- statAccuracy
	modData.statFireRate <- statFireRate
	modData.statClipSize <- statClipSize
	modData.image <- image
	modData.icon <- icon
	modData.dev_enabled <- dev_enabled
	modData.challengeReq <- challengeReq
	modData.challengeTier <- challengeTier
	modData.displayInMenu <- displayInMenu

	itemData[parentRef].subitems[childRef] <- modData
	combinedModData[parentRef + "_" + childRef] <- modData

	if ( displayInMenu )
	{
		if ( !( parentRef in modsOfType ) )
			modsOfType[parentRef] <- []
		modsOfType[parentRef].append( childRef )

		if ( !( type in itemsOfType ) )
			itemsOfType[type] <- []
		itemsOfType[type].append( childRef )

		allItems.append( { ref = parentRef, childRef = childRef, type = type } )
		UpdateChallengeRewardItems( parentRef, childRef, type, challengeReq, challengeTier )
	}
	else
	{
		Assert( levelReq <= 0 )
		Assert( challengeReq == null && challengeTier == null )
	}
}


function CreateGenderData( type, dev_enabled, levelReq, challengeReq, challengeTier, ref ) // , name, desc )
{
	ref = ref.tolower()
	Assert( !( ref in itemData ), "ref " + ref + " being redefined!" )

	itemData[ref] <- {}
	itemData[ref].type <- type
	itemData[ref].ref <- ref
	itemData[ref].dev_enabled <- dev_enabled
	itemData[ref].challengeReq <- challengeReq
	itemData[ref].challengeTier <- challengeTier

	if ( !( type in itemsOfType ) )
		itemsOfType[type] <- []
	itemsOfType[type].append( ref )

	allItems.append( { ref = ref, childRef = null, type = type } )

	UpdateChallengeRewardItems( ref, null, type, challengeReq, challengeTier )
}

//Exactly like Passive right now
function CreateTitanOSVoiceData( type, dev_enabled, levelReq, challengeReq, challengeTier, ref, name , desc, longdesc, image, icon = null )
{
	if ( IsClient() )
	{
		PrecacheHUDMaterial( image )

		if ( icon != null )
			PrecacheHUDMaterial( icon )
	}

	itemData[ref] <- {}
	itemData[ref].type <- type
	itemData[ref].ref <- ref
	itemData[ref].name <- name
	itemData[ref].desc <- desc
	itemData[ref].longdesc <- longdesc
	itemData[ref].image <- image
	itemData[ref].icon <- icon
	itemData[ref].dev_enabled <- dev_enabled
	itemData[ref].challengeReq <- challengeReq
	itemData[ref].challengeTier <- challengeTier

	if ( !( type in itemsOfType ) )
		itemsOfType[type] <- []
	itemsOfType[type].append( ref )

	allItems.append( { ref = ref, childRef = null, type = type } )
	UpdateChallengeRewardItems( ref, null, type, challengeReq, challengeTier )
}

function GetAllItemAttachments( parentRef )
{
	local childRefs = []

	if ( parentRef in attachmentsOfType )
	{
		foreach ( ref in attachmentsOfType[parentRef] )
			childRefs.append( itemData[parentRef].subitems[ref] )
	}

	return childRefs
}

function GetAllItemMods( parentRef )
{
	local childRefs = []

	if ( parentRef in modsOfType )
	{
		foreach ( ref in modsOfType[parentRef] )
			childRefs.append( itemData[parentRef].subitems[ref] )
	}

	return childRefs
}

function GetAttachmentForItemIndex( itemRef, index )
{
	local typeArray = attachmentsOfType[itemRef]

	Assert( index >= 0 && index < typeArray.len() )

	return typeArray[index]
}

function GetModForItemIndex( itemRef, index )
{
	local typeArray = modsOfType[itemRef]

	Assert( index >= 0 && index < typeArray.len() )

	return typeArray[index]
}

function ItemSupportsAttachments( ref )
{
	local type = GetItemType( ref )

	if ( type == itemType.PILOT_PRIMARY )
		return true

	return false
}

function ItemAttachmentsExist( ref )
{
	local attachments = GetAllItemAttachments( ref )

	if ( attachments.len() )
		return true

	return false
}

function ItemSupportsAttachment( itemRef, childRef )
{
	local attachments = GetAllItemAttachments( itemRef )

	foreach ( entry in attachments )
	{
		if ( childRef == entry.ref )
			return true
	}

	return false
}

function ItemSupportsMods( ref )
{
	local type = GetItemType( ref )

	if ( type == itemType.PILOT_PRIMARY || type == itemType.PILOT_SECONDARY || type == itemType.PILOT_SIDEARM || type == itemType.TITAN_PRIMARY )
		return true

	return false
}

function ItemModsExist( ref )
{
	local mods = GetAllItemMods( ref )

	if ( mods.len() )
		return true

	return false
}

function ItemSupportsMod( itemRef, childRef )
{
	local mods = GetAllItemMods( itemRef )

	foreach ( entry in mods )
	{
		if ( childRef == entry.ref )
			return true
	}

	return false
}

function CreateDecalData( type, ref, name, desc, unlockReqText, unlockReqUnlockedText, image, hidden = false )
{
	ref = ref.tolower()
	Assert( !( ref in itemData ), "ref " + ref + " being redefined!" )
	Assert( PersistenceEnumValueIsValid( "titanDecals", ref ) )

	if ( IsClient() )
		PrecacheHUDMaterial( image )

	itemData[ref] <- {}
	itemData[ref].type <- type
	itemData[ref].ref <- ref
	itemData[ref].name <- name
	itemData[ref].desc <- desc
	itemData[ref].longdesc <- desc
	itemData[ref].unlockReqText <- unlockReqText
	itemData[ref].unlockReqUnlockedText <- unlockReqUnlockedText
	itemData[ref].image <- image
	itemData[ref].hidden <- hidden

	// Set the skin number for the decal for each team
	Assert( PersistenceEnumValueIsValid( "titanDecals", ref ) )
	local numDecals = PersistenceGetEnumCount( "titanDecals" )
//    local numDecals = 0
	local decalIndex = PersistenceGetEnumIndexForItemName( "titanDecals", ref )
//    local decalIndex = 0
	itemData[ref].imcSkinIndex <- 2 + decalIndex
	itemData[ref].mcorSkinIndex <- 1 + decalIndex + numDecals

	if ( !( type in itemsOfType ) )
		itemsOfType[type] <- []
	itemsOfType[type].append( ref )

	allItems.append( { ref = ref, childRef = null, type = type } )
}

function CreateSetFileData( type, dev_enabled, levelReq, challengeReq, challengeTier, ref, name, desc, imcImage, militiaImage, additionalName = null, additionalDesc = null, coreImage = null, statSpeed = null, statAccel = null, statHealth = null, statDash = null )
{
	ref = ref.tolower()
	Assert( !( ref in itemData ), "ref " + ref + " being redefined!" )

	if ( IsClient() )
	{
		PrecacheHUDMaterial( imcImage )
		PrecacheHUDMaterial( militiaImage )
		if( coreImage )
			PrecacheHUDMaterial( coreImage )
	}

	itemData[ref] <- {}
	itemData[ref].type <- type
	itemData[ref].ref <- ref
	itemData[ref].name <- name
	itemData[ref].desc <- desc
	itemData[ref].longdesc <- desc
	itemData[ref].additionalName <- additionalName
	itemData[ref].additionalDesc <- additionalDesc
	itemData[ref].teamImages <- { [TEAM_IMC] = imcImage, [TEAM_MILITIA] = militiaImage }
	itemData[ref].coreImage <- coreImage
	itemData[ref].statSpeed <- statSpeed
	itemData[ref].statAccel <- statAccel
	itemData[ref].statHealth <- statHealth
	itemData[ref].statDash <- statDash
	itemData[ref].dev_enabled <- dev_enabled
	itemData[ref].challengeReq <- challengeReq
	itemData[ref].challengeTier <- challengeTier

	if ( !( type in itemsOfType ) )
		itemsOfType[type] <- []
	itemsOfType[type].append( ref )

	allItems.append( { ref = ref, childRef = null, type = type } )
}

function CreatePassiveData( type, dev_enabled, levelReq, challengeReq, challengeTier, ref, name, desc, longdesc, image, icon = null )
{
	ref = ref.tolower()
	Assert( !( ref in itemData ), "ref " + ref + " being redefined!" )

	if ( IsClient() )
	{
		PrecacheHUDMaterial( image )

		if ( icon != null )
			PrecacheHUDMaterial( icon )
	}

	itemData[ref] <- {}
	itemData[ref].type <- type
	itemData[ref].ref <- ref
	itemData[ref].name <- name
	itemData[ref].desc <- desc
	itemData[ref].longdesc <- longdesc
	itemData[ref].image <- image
	itemData[ref].icon <- icon
	itemData[ref].dev_enabled <- dev_enabled
	itemData[ref].challengeReq <- challengeReq
	itemData[ref].challengeTier <- challengeTier

	if ( !( type in itemsOfType ) )
		itemsOfType[type] <- []
	itemsOfType[type].append( ref )

	allItems.append( { ref = ref, childRef = null, type = type } )

	UpdateChallengeRewardItems( ref, null, type, challengeReq, challengeTier )
}

function ItemTypeSupportsMods( type )
{
	if ( type == itemType.PILOT_PRIMARY ||
		 type == itemType.PILOT_SECONDARY ||
		 type == itemType.PILOT_SIDEARM ||
		 type == itemType.PILOT_ORDNANCE ||
		 type == itemType.TITAN_PRIMARY ||
		 type == itemType.TITAN_ORDNANCE ||
		 type == itemType.TITAN_SPECIAL )
		return true

	return false
}

function ItemTypeSupportsAttachments( type )
{
	if ( type == itemType.PILOT_PRIMARY )
		return true

	return false
}

function ItemTypeIsMod( type )
{
	if ( type == itemType.PILOT_PRIMARY_MOD ||
		 type == itemType.PILOT_SECONDARY_MOD ||
		 type == itemType.PILOT_SIDEARM_MOD ||
		 type == itemType.PILOT_ORDNANCE_MOD ||
		 type == itemType.TITAN_PRIMARY_MOD ||
		 type == itemType.TITAN_SPECIAL_MOD ||
		 type == itemType.TITAN_ORDNANCE_MOD )
		return true

	return false
}

function ItemTypeIsAttachment( type )
{
	if ( type == itemType.PILOT_PRIMARY_ATTACHMENT )
		return true

	return false
}


function IsRefValid( ref )
{
	if ( ItemDefined( ref ) )
		return true

	if ( ref in unlockLevels )
		return true

	if ( ref in level.challengeData )
		return true

	foreach ( itemType in itemsOfType )
	{
		foreach ( itemRef in itemType )
		{
			if ( itemRef == ref )
				return true
		}
	}

	return false
}


function IsItemLocked( ref, childRef = null, player = null )
{
	local customUnlockCondition = false
	local playerLevel = GetLevel( player )
	local levelReq = null

	if ( !ItemDefined( ref ) )
	{
		if ( DevEverythingUnlocked() || IsPlayerEverythingUnlocked( player )  )
			return false

		if ( ref in unlockLevels )
		{
			if ( ref == "burn_card_slot_1" || ref == "burn_card_slot_2" || ref == "burn_card_slot_3" )
			{
				// once you have gen'd up you dont need to level up for these
				local gen = IsUI() ? GetGen() : player.GetGen()
				if ( gen > 0 )
					return false
			}

			if ( unlockLevels[ref] == null )
				customUnlockCondition = true
			else
				return playerLevel < unlockLevels[ref]
		}
		else if ( ref in level.challengeData )
		{
			if ( level.challengeData[ref].weaponRef )
			{
				local refType = GetItemType( level.challengeData[ref].weaponRef )

				switch ( refType )
				{
					case itemType.PILOT_PRIMARY:
					case itemType.PILOT_SECONDARY:
					case itemType.PILOT_SIDEARM:
					case itemType.PILOT_SPECIAL:
					case itemType.PILOT_ORDNANCE:
					case itemType.PILOT_PASSIVE1:
					case itemType.PILOT_PASSIVE2:
						if ( IsItemLocked( "edit_pilots", null, player ) )
							return true
						break

					case itemType.TITAN_SPECIAL:
					case itemType.TITAN_ORDNANCE:
					case itemType.TITAN_PRIMARY:
					case itemType.TITAN_SETFILE:
					case itemType.TITAN_PASSIVE1:
					case itemType.TITAN_PASSIVE2:
						if ( IsItemLocked( "edit_titans", null, player ) )
							return true
						break
				}

				return IsItemLocked( level.challengeData[ref].weaponRef, null, player )
			}
		}

		if ( !customUnlockCondition )
			return false
	}

	if ( !IsUI() )
		Assert( IsValid( player ) )

	// if the main/parent item is locked then so are all subitems
	if ( childRef != null && IsItemLocked( ref, null, player ) )
		return true

	local playerLevel = GetLevel( player )
	local levelReq = GetItemLevelReq( ref, childRef )

	// Dev flag to unlock everything except what is disabled
	if ( DevEverythingUnlocked() || IsPlayerEverythingUnlocked( player ) )
		return GetItemDevLocked( ref, player, childRef )

	//###############################################
	// TITAN CHASSIS UNLOCK FROM CAMPAIGN COMPLETION
	//###############################################

	local imcCampaignComplete
	local milCampaignComplete
	local playerGen = 0
	if ( IsUI() )
	{
		imcCampaignComplete = GetPersistentVar( "campaignLevelsFinishedIMC" ) >= CAMPAIGN_LEVEL_COUNT
		milCampaignComplete = GetPersistentVar( "campaignLevelsFinishedMCOR" ) >= CAMPAIGN_LEVEL_COUNT
		playerGen = GetGen()
	}
	else
	{
		imcCampaignComplete = player.GetPersistentVar( "campaignLevelsFinishedIMC" ) >= CAMPAIGN_LEVEL_COUNT
		milCampaignComplete = player.GetPersistentVar( "campaignLevelsFinishedMCOR" ) >= CAMPAIGN_LEVEL_COUNT
		playerGen = player.GetGen()
	}

	switch ( ref )
	{
		case "titan_stryder":
			if ( playerGen > 0 || playerLevel >= levelReq )
				return false
			return !( imcCampaignComplete || milCampaignComplete )

		case "titan_ogre":
			if ( playerGen > 0 || playerLevel >= levelReq )
				return false
			return !( imcCampaignComplete && milCampaignComplete )
	}

	//###############################################
	// GAMEMODE CUSTOM SLOTS BASED ON MODE PLAY COUNT
	//###############################################

	local gameModesPlayed = {}
	local numModes = 0
	if ( !IsServer() ) {
		numModes = PersistenceGetEnumCount( "gameModesWithLoadouts" )
	}

	for( local i = 0 ; i < numModes ; i++ )
	{
		local mode = ""
	if ( !IsServer() ) {
		mode = PersistenceGetEnumItemNameForIndex( "gameModesWithLoadouts", i )
	}

		if ( IsUI() )
			gameModesPlayed[ mode ] <- GetPersistentVar( "gameStats.modesPlayed[" + mode + "]" )
		else
			gameModesPlayed[ mode ] <- player.GetPersistentVar( "gameStats.modesPlayed[" + mode + "]" )
		}

	switch ( ref )
	{
		case "pilot_custom_loadout_6":
		case "pilot_custom_loadout_7":
		case "pilot_custom_loadout_8":
		case "pilot_custom_loadout_9":
		case "pilot_custom_loadout_10":
		case "pilot_custom_loadout_11":
		case "pilot_custom_loadout_12":
		case "pilot_custom_loadout_13":
		case "pilot_custom_loadout_14":
		case "pilot_custom_loadout_15":
		case "pilot_custom_loadout_16":
		case "pilot_custom_loadout_17":
		case "pilot_custom_loadout_18":
		case "pilot_custom_loadout_19":
			if ( IsItemLocked( "edit_pilots", null, player ) )
				return true

		case "titan_custom_loadout_6":
		case "titan_custom_loadout_7":
		case "titan_custom_loadout_8":
		case "titan_custom_loadout_9":
		case "titan_custom_loadout_10":
		case "titan_custom_loadout_11":
		case "titan_custom_loadout_12":
		case "titan_custom_loadout_13":
		case "titan_custom_loadout_14":
		case "titan_custom_loadout_15":
		case "titan_custom_loadout_16":
		case "titan_custom_loadout_17":
		case "titan_custom_loadout_18":
		case "titan_custom_loadout_19":
			if ( IsItemLocked( "edit_titans", null, player ) )
				return true
	}

	switch ( ref )
	{
		case "pilot_custom_loadout_6":
		case "titan_custom_loadout_6":
			return gameModesPlayed["tdm"] < UNLOCK_GAMEMODE_SLOT_1_VALUE

		case "pilot_custom_loadout_7":
		case "titan_custom_loadout_7":
			return gameModesPlayed["tdm"] < UNLOCK_GAMEMODE_SLOT_2_VALUE

		case "pilot_custom_loadout_8":
		case "titan_custom_loadout_8":
			return gameModesPlayed["cp"] < UNLOCK_GAMEMODE_SLOT_1_VALUE

		case "pilot_custom_loadout_9":
		case "titan_custom_loadout_9":
			return gameModesPlayed["cp"] < UNLOCK_GAMEMODE_SLOT_2_VALUE

		case "pilot_custom_loadout_10":
		case "titan_custom_loadout_10":
			return gameModesPlayed["at"] < UNLOCK_GAMEMODE_SLOT_1_VALUE

		case "pilot_custom_loadout_11":
		case "titan_custom_loadout_11":
			return gameModesPlayed["at"] < UNLOCK_GAMEMODE_SLOT_2_VALUE

		case "pilot_custom_loadout_12":
		case "titan_custom_loadout_12":
			return gameModesPlayed["ctf"] < UNLOCK_GAMEMODE_SLOT_1_VALUE

		case "pilot_custom_loadout_13":
		case "titan_custom_loadout_13":
			return gameModesPlayed["ctf"] < UNLOCK_GAMEMODE_SLOT_2_VALUE

		case "pilot_custom_loadout_14":
		case "titan_custom_loadout_14":
			return gameModesPlayed["lts"] < UNLOCK_GAMEMODE_SLOT_1_VALUE

		case "pilot_custom_loadout_15":
		case "titan_custom_loadout_15":
			return gameModesPlayed["lts"] < UNLOCK_GAMEMODE_SLOT_2_VALUE

		case "pilot_custom_loadout_16":
		case "titan_custom_loadout_16":
			return gameModesPlayed["mfd"] < UNLOCK_GAMEMODE_SLOT_1_VALUE

		case "pilot_custom_loadout_17":
		case "titan_custom_loadout_17":
			return gameModesPlayed["mfd"] < UNLOCK_GAMEMODE_SLOT_2_VALUE

		case "pilot_custom_loadout_18":
		case "titan_custom_loadout_18":
			return gameModesPlayed["coop"] < UNLOCK_GAMEMODE_SLOT_1_VALUE

		case "pilot_custom_loadout_19":
		case "titan_custom_loadout_19":
			return gameModesPlayed["coop"] < UNLOCK_GAMEMODE_SLOT_2_VALUE

	}

	//########################################
	// CHECK IF LOCKED FROM LEVEL REQUIREMENT
	//########################################

	if ( levelReq > playerLevel )
		return true

	//############################################
	// DECALS HAVE SPECIAL UNLOCK REQS
	//############################################

	if ( GetItemType( ref ) == itemType.TITAN_DECAL )
		return !IsDecalUnlocked( ref, player )


	//############################################
	// TITAN OS VOICE PACKS HAS SPECIAL UNLOCK REQS
	//############################################
	if ( GetItemType( ref ) == itemType.TITAN_OS )
		return !IsTitanOSUnlocked( ref, player )

	//############################################
	// CHECK IF LOCKED FROM CHALLENGE REQUIREMENT
	//############################################

	local req = GetItemChallengeReq( ref, childRef )
	if ( req.challengeReq != null && req.challengeTier != null )
	{
		if ( !IsChallengeTierComplete( req.challengeReq, req.challengeTier, player ) )
			return true
	}

	return false
}

function GetItemDevLocked( ref, player, childRef = null )
{
	if ( !DevEverythingUnlocked() || !IsPlayerEverythingUnlocked( player )  )
		return false

	local data
	if ( childRef != null )
		data = GetSubitemData( ref, childRef )
	else
		data = GetItemData( ref )

	if ( "dev_enabled" in data )
		return !data.dev_enabled

	return !DEV_ENABLED
}

function GetItemLevelReq( ref, childRef = null )
{
	if ( childRef != null )
		return GetUnlockLevelReq( ref + "_" + childRef )
	else
		return GetUnlockLevelReq( ref )
}

function GetItemChallengeReq( ref, childRef = null )
{
	local data
	if ( childRef != null )
		data = GetSubitemData( ref, childRef )
	else
		data = GetItemData( ref )

	local retData = {}
	retData.challengeReq <- data.challengeReq
	retData.challengeTier <- data.challengeTier

	return retData
}

function DidPlayerBuyItemFromBlackMarket( ref, player )
{
	local doesRefExist =  PersistenceEnumValueIsValid( "BlackMarketUnlocks", ref )
	if ( doesRefExist == false )
		return false

	//local result = IsUI() ? GetPersistentVar( "bm.blackMarketItemUnlocks[" + ref + "]" ) : player.GetPersistentVar( "bm.blackMarketItemUnlocks[" + ref + "]" )
	//printt( "result of " + ref + " DidPlayerBuyItemFromBlackMarket:" + result )
	return IsUI() ? GetPersistentVar( "bm.blackMarketItemUnlocks[" + ref + "]" ) : player.GetPersistentVar( "bm.blackMarketItemUnlocks[" + ref + "]" )
}

function PrintItemData()
{
	PrintTable( itemData )
}

function PrintItems()
{
	PrintTable( itemsOfType )
}

function PrintMods()
{
	PrintTable( modsOfType )
}

function PrintAttachments()
{
	PrintTable( attachmentsOfType )
}

function GetDisplayNameFromItemType( type )
{
	local propertyName

	switch ( type )
	{
		case itemType.PILOT_PRIMARY:
		case itemType.TITAN_PRIMARY:
			return "#PRIMARY_WEAPON"

		case itemType.PILOT_SECONDARY:
			return "#ANTI_TITAN_WEAPON"

		case itemType.PILOT_SIDEARM:
			return "#SIDEARM"

		case itemType.PILOT_SPECIAL:
		case itemType.TITAN_SPECIAL:
			return "#SPECIAL_ABILITY"

		case itemType.PILOT_ORDNANCE:
		case itemType.TITAN_ORDNANCE:
			return "#ORDNANCE"

		case itemType.PILOT_PASSIVE1:
		case itemType.TITAN_PASSIVE1:
			return "#LOADOUT_BUTTON_PASSIVE_1"

		case itemType.PILOT_PASSIVE2:
		case itemType.TITAN_PASSIVE2:
			return "#LOADOUT_BUTTON_PASSIVE_2"

		case itemType.TITAN_OS:
			return "#LOADOUT_BUTTON_TITAN_OS"

		case itemType.PILOT_PRIMARY_ATTACHMENT:
			return "#ITEM_TYPE_WEAPON_ATTACHMENT"

		case itemType.PILOT_PRIMARY_MOD:
		case itemType.TITAN_PRIMARY_MOD:
		case itemType.PILOT_SECONDARY_MOD:
		case itemType.PILOT_SIDEARM_MOD:
			return "#ITEM_TYPE_WEAPON_MOD"

		case itemType.TITAN_SETFILE:
			return "#CHASSIS"

		default:
			Assert( "Invalid item type!" )
	}

	return propertyName
}

function GetItemTypeFromPropertyName( property, isTitanProperty )
{
	local itemTypeName

	switch ( property )
	{
		case "notLoadout":
			itemTypeName = itemType.NOT_LOADOUT
			break

		case "primary":
			if ( isTitanProperty )
				itemTypeName = itemType.TITAN_PRIMARY
			else
				itemTypeName = itemType.PILOT_PRIMARY
			break

		case "secondary":
			//if ( isTitanProperty )
			//	itemTypeName = itemType.TITAN_SECONDARY
			//else
				itemTypeName = itemType.PILOT_SECONDARY
			break

		case "sidearm":
			itemTypeName = itemType.PILOT_SIDEARM
			break

		case "special":
			if ( isTitanProperty )
				itemTypeName = itemType.TITAN_SPECIAL
			else
				itemTypeName = itemType.PILOT_SPECIAL
			break

		case "ordnance":
			if ( isTitanProperty )
				itemTypeName = itemType.TITAN_ORDNANCE
			else
				itemTypeName = itemType.PILOT_ORDNANCE
			break

		case "passive1":
			if ( isTitanProperty )
				itemTypeName = itemType.TITAN_PASSIVE1
			else
				itemTypeName = itemType.PILOT_PASSIVE1
			break

		case "passive2":
			if ( isTitanProperty )
				itemTypeName = itemType.TITAN_PASSIVE2
			else
				itemTypeName = itemType.PILOT_PASSIVE2
			break

		case "voiceChoice":
			itemTypeName = itemType.TITAN_OS
			break

		case "setFile":
			if ( isTitanProperty )
				itemTypeName = itemType.TITAN_SETFILE
			else
				itemTypeName = itemType.PILOT_SETFILE
			break

		case "primaryAttachment":
			itemTypeName = itemType.PILOT_PRIMARY_ATTACHMENT
			break

		case "primaryMod":
			if ( isTitanProperty )
				itemTypeName = itemType.TITAN_PRIMARY_MOD
			else
				itemTypeName = itemType.PILOT_PRIMARY_MOD
			break

		case "sidearmMod":
			itemTypeName = itemType.PILOT_SIDEARM_MOD
			break

		case "secondaryMod":
			//if ( isTitanProperty )
			//	itemTypeName = itemType.TITAN_SECONDARY_MOD
			//else
				itemTypeName = itemType.PILOT_SECONDARY_MOD
			break

		case "race":
			itemTypeName = itemType.RACE
			break

		case "decal":
			itemTypeName = itemType.TITAN_DECAL
			break
	}

	return itemTypeName
}

function SortByUnlockReq( ref1, ref2 )
{
	if ( GetUnlockLevelReq( ref1 ) > GetUnlockLevelReq( ref2 ) )
		return 1
	else if ( GetUnlockLevelReq( ref1 ) < GetUnlockLevelReq( ref2 ) )
		return -1
	return 0
}

function IsTitanOSUnlocked( ref, player )
{
	switch ( ref )
	{
		case "titanos_betty":
		case "titanos_malebutler":
		case "titanos_femaleaudinav":
			return true

		case "titanos_femaleassistant":
		case "titanos_maleintimidator":
		case "titanos_bettyjp":
		case "titanos_bettyde":
		case "titanos_bettyen":
		case "titanos_bettyes":
		case "titanos_bettyfr":
		case "titanos_bettyit":
		case "titanos_bettyru":
			return DidPlayerBuyItemFromBlackMarket( ref, player ) //Uncomment this when lines are ready

		default:
			Assert( false, "Unrecognized Titan OS Voice pack: " + ref )
	}
}

function IsDecalUnlocked( ref, player = null )
{
	//printt( "IsDecalUnlocked:", ref )

	ref = ref.tolower()

	local decalUnlockData = GetDecalUnlockData( ref, player )
	return decalUnlockData.unlocked
}

function GetDecalUnlockData( ref, player = null )
{
	//printt( "GetDecalUnlockData:", ref )

	if ( !IsUI() )
		Assert( IsValid( player ) )

	local playerLevel = IsUI() ? GetLevel() : GetLevel( player )
	local playerGen = IsUI() ? GetGen() : player.GetGen()

	local data = {}
	data.unlocked <- true
	data.goal <- 0
	data.progress <- 0
	data.dlcGroup <- 0

	switch( ref )
	{
		case "titan_decal_a_base_imc":
			//Win 50 matches as the IMC
			data.goal = 50
			data.progress =	StatToInt( "game_stats", "games_won_as_imc", null, player )
			break

		case "titan_decal_b_base_mcor":
			//Win 50 matches as the Militia
			data.goal = 50
			data.progress =	StatToInt( "game_stats", "games_won_as_militia", null, player )
			break

		case "5kw_custom_decal":
			//Kill 5 enemies with one Arc Cannon shot 20 times
			data.goal = 20
			data.progress =	StatToInt( "misc_stats", "arcCannonMultiKills", null, player )
			break

		case "30_titan_decal":
			//Nuclear Eject 10 times
			data.goal = 10
			data.progress =	StatToInt( "misc_stats", "timesEjectedNuclear", null, player )
			break

		case "ace_custom_decal":
			//Use 100 burn cards
			data.goal = 100
			data.progress =	StatToInt( "misc_stats", "burnCardsSpent", null, player )
			break

		case "bomb_lit_custom_decal":
			//Kill 1000 Enemies with Pilot Ordnance
			data.goal = 1000
			data.progress =	0
			local ordnanceItems = GetAllItemsOfType( itemType.PILOT_ORDNANCE )
			foreach( item in ordnanceItems )
				data.progress += StatToInt( "weapon_kill_stats", "total", item.ref, player )
			break

		case "bombs_custom_decal":
			//Kill 500 Titans with Titan Ordnance
			data.goal = 500
			data.progress =	0
			local ordnanceItems = GetAllItemsOfType( itemType.TITAN_ORDNANCE )
			foreach( item in ordnanceItems )
				data.progress += StatToInt( "weapon_kill_stats", "titansTotal", item.ref, player )
			break

		case "bullet_hash_custom_decal":
			//Kill 500 Pilots with your Pilot's primary weapon
			data.goal = 500
			data.progress =	0
			local pilotPrimaries = GetAllItemsOfType( itemType.PILOT_PRIMARY )
			foreach( item in pilotPrimaries )
				data.progress += StatToInt( "weapon_kill_stats", "pilots", item.ref, player )
			break

		case "eye_custom_decal":
			//Kill 100 ejecting Pilots
			data.goal = 100
			data.progress =	StatToInt( "kills_stats", "ejectingPilots", null, player )
			break

		case "hand_custom_decal":
			//Embark into your Titan 100 times
			data.goal = 100
			data.progress =	StatToInt( "misc_stats", "titanEmbarks", null, player )
			break

		case "pitchfork_custom_decal":
			//Kill 50 Pilots in LTS
			local statVar = GetPersistentStatVar( "game_stats", "pvp_kills_by_mode" )
			local persVar = StatStringReplace( statVar, "%gamemode%", "lts" )
			data.goal = 50
			data.progress =	IsUI() ? GetPersistentVar( persVar ) : player.GetPersistentVar( persVar )
			break

		case "red_chevron_custom_decal":
			//Kill 10 evac ships during the epilogue
			data.goal = 10
			data.progress =	StatToInt( "kills_stats", "evacShips", null, player )
			break

		case "titan_decal_4":
			//Reach Level 40
			data.goal = 40
			data.progress = playerGen > 0 ? data.goal : playerLevel
			break

		case "titan_decal_13":
			//Reach Level 13
			data.goal = 13
			data.progress = playerGen > 0 ? data.goal : playerLevel
			break

		case "titan_decal_19":
			//Reach Level 19
			data.goal = 19
			data.progress = playerGen > 0 ? data.goal : playerLevel
			break

		case "titan_decal_27":
			//Reach Level 27
			data.goal = 27
			data.progress = playerGen > 0 ? data.goal : playerLevel
			break

		case "titan_decal_ace":
			//Kill 1000 Enemies while you have a Burn card active
			data.goal = 1000
			data.progress =	StatToInt( "kills_stats", "totalWhileUsingBurnCard", null, player )
			break

		case "titan_decal_animalskull":
			//Kill 10 Fliers
			data.goal = 10
			data.progress =	StatToInt( "kills_stats", "flyers", null, player )
			break

		case "titan_decal_bluestar":
			//Be MVP on your team 50 times
			data.goal = 50
			data.progress =	StatToInt( "game_stats", "mvp_total", null, player )
			break

		case "titan_decal_brokenstar":
			//Get a 10 win streak
			data.goal = 10
			data.progress =	IsUI() ? GetPersistentVar( "highestWinStreakEver" ) : player.GetPersistentVar( "highestWinStreakEver" )
			break

		case "titan_decal_conejo":
			//As a Pilot, kill 500 enemies with explosives
			data.goal = 500
			data.progress =	0
			local pilotExplosiveItems = []
			pilotExplosiveItems.append( "mp_weapon_frag_grenade" )
			pilotExplosiveItems.append( "mp_weapon_grenade_emp" )
			pilotExplosiveItems.append( "mp_weapon_satchel" )
			pilotExplosiveItems.append( "mp_weapon_proximity_mine" )
			pilotExplosiveItems.append( "mp_weapon_mgl" )
			pilotExplosiveItems.append( "mp_weapon_rocket_launcher" )
			pilotExplosiveItems.append( "mp_weapon_smr" )
			foreach( item in pilotExplosiveItems )
				data.progress += StatToInt( "weapon_kill_stats", "total", item, player )
			break

		case "titan_decal_crazybomb":
			//Kill 250 enemies with frag grenades
			data.goal = 250
			data.progress =	StatToInt( "weapon_kill_stats", "total", "mp_weapon_frag_grenade", player )
			break

		case "titan_decal_defiant":
			//Use conscription burn cards to get 50 grunts to follow you
			data.goal = 50
			data.progress =	StatToInt( "misc_stats", "gruntsConscripted", null, player )
			break

		case "titan_decal_dice":
			//Land on an enemy Titan from an ejection 50 times
			data.goal = 50
			data.progress =	StatToInt( "misc_stats", "rodeosFromEject", null, player )
			break

		case "titan_decal_dino":
			//Play Airbase and/or Boneyard 25 times
			data.goal = 25
			data.progress =	GetTimesPlayedMap( "mp_airbase", player ) + GetTimesPlayedMap( "mp_boneyard", player )
			break

		case "titan_decal_eagle":
			//Play every mode on every map (excluding DLC maps)
			local completedData = GetAllModesAndMapsCompleteData( player )
			data.goal = completedData.required
			data.progress =	completedData.progress
			break

		case "titan_decal_eagleshield":
			//Eject from your Titan 500 Times
			data.goal = 500
			data.progress =	StatToInt( "misc_stats", "timesEjected", null, player )
			break

		case "titan_decal_fa95":
			//Unlocked immediately
			break

		case "titan_decal_flameskull":
			//Die while ejecting 10 Times
			data.goal = 10
			data.progress =	StatToInt( "deaths_stats", "whileEjecting", null, player )
			break

		case "titan_decal_gen1":
			//Reach Generation 1 (Unlocked immediately)
			data.goal = 1
			data.progress =	playerGen + 1
			break

		case "titan_decal_gen2":
			//Reach Generation 2
			data.goal = 2
			data.progress =	playerGen + 1
			break

		case "titan_decal_gen3":
			//Reach Generation 3
			data.goal = 3
			data.progress =	playerGen + 1
			break

		case "titan_decal_gen4":
			//Reach Generation 4
			data.goal = 4
			data.progress =	playerGen + 1
			break

		case "titan_decal_gen5":
			//Reach Generation 5
			data.goal = 5
			data.progress =	playerGen + 1
			break

		case "titan_decal_gen6":
			//Reach Generation 6
			data.goal = 6
			data.progress =	playerGen + 1
			break

		case "titan_decal_gen7":
			//Reach Generation 7
			data.goal = 7
			data.progress =	playerGen + 1
			break

		case "titan_decal_gen8":
			//Reach Generation 8
			data.goal = 8
			data.progress =	playerGen + 1
			break

		case "titan_decal_gen9":
			//Reach Generation 9
			data.goal = 9
			data.progress =	playerGen + 1
			break

		case "titan_decal_gen10":
			//Reach Generation 10
			data.goal = 10
			data.progress =	playerGen + 1
			break

		case "titan_decal_girly":
			// Successfully evac from a match (reach space) 25 times
			data.goal = 25
			data.progress =	StatToInt( "misc_stats", "evacsSurvived", null, player )
			break

		case "titan_decal_gremlin":
			//Kill 5 Titans with Slaved Warheads
			data.goal = 5
			data.progress =	StatToInt( "weapon_kill_stats", "titansTotal", "mp_titanweapon_homing_rockets", player )
			break

		case "titan_decal_hammond":
			//Complete Training
			local completed = IsUI() ? GetPersistentVar( "ach_completedTraining" ) : player.GetPersistentVar( "ach_completedTraining" )
			data.goal = 1
			data.progress =	completed ? 1 : 0
			break

		case "titan_decal_imc_gear":
			//Finish the IMC Campaign
			data.goal = 9
			data.progress =	IsUI() ? GetPersistentVar( "campaignLevelsFinishedIMC" ) : player.GetPersistentVar( "campaignLevelsFinishedIMC" )
			break

		case "titan_decal_imc_old":
			//Play 100 matches as the IMC
			data.goal = 100
			data.progress =	StatToInt( "game_stats", "games_completed_as_imc", null, player )
			break

		case "titan_decal_imc01":
			//Kill a Respawn team member or someone else who has unlocked this emblem
			local completed = IsUI() ? GetPersistentVar( "respawnKillInfected" ) : player.GetPersistentVar( "respawnKillInfected" )
			data.goal = 1
			data.progress = completed ? 1 : 0
			break

		case "titan_decal_imc02":
			//Hack 25 Spectres in Corporate
			local statVar = GetPersistentStatVar( "misc_stats", "spectreLeechesByMap" )
			local persVar = StatStringReplace( statVar, "%mapname%", "mp_corporate" )
			data.goal = 25
			data.progress =	IsUI() ? GetPersistentVar( persVar ) : player.GetPersistentVar( persVar )
			break

		case "titan_decal_imc03":
			//Finish in the top 3 of your team 250 times
			data.goal = 250
			data.progress =	StatToIntAllCompetitiveModesAndMaps( "game_stats", "top3OnTeam", null, player )
			break

		case "titan_decal_imctri":
			//Win every level of the IMC Campaign
			data.goal = CAMPAIGN_LEVEL_COUNT
			data.progress = 0
			for ( local i = 0 ; i < CAMPAIGN_LEVEL_COUNT ; i++ )
			{
				local won = IsUI() ? GetPersistentVar( "campaignMapWonIMC[" + i + "]" ) : player.GetPersistentVar( "campaignMapWonIMC[" + i + "]" )
				if ( won )
					data.progress++
			}
			break

		case "titan_decal_killmarks":
			//Kill 10000 Enemies
			data.goal = 10000
			data.progress = StatToInt( "kills_stats", "total", null, player )
			break

		case "titan_decal_ksa":
			//Unlocked immediately
			break

		case "titan_decal_letter01_opa":
			//Unlocked immediately
			break

		case "titan_decal_mcor":
			//Finish the Militia Campaign
			data.goal = 9
			data.progress =	IsUI() ? GetPersistentVar( "campaignLevelsFinishedMCOR" ) : player.GetPersistentVar( "campaignLevelsFinishedMCOR" )
			break

		case "titan_decal_militia":
			//Win every level of the Militia Campaign
			data.goal = CAMPAIGN_LEVEL_COUNT
			data.progress = 0
			for ( local i = 0 ; i < CAMPAIGN_LEVEL_COUNT ; i++ )
			{
				local won = IsUI() ? GetPersistentVar( "campaignMapWonMCOR[" + i + "]" ) : player.GetPersistentVar( "campaignMapWonMCOR[" + i + "]" )
				if ( won )
					data.progress++
			}
			break

		case "titan_decal_oldmcor":
			//Play 100 matches as the Militia
			data.goal = 100
			data.progress =	StatToInt( "game_stats", "games_completed_as_militia", null, player )
			break

		case "titan_decal_redstarv":
			//Kill 1000 Pilots
			data.goal = 1000
			data.progress =	StatToInt( "kills_stats", "totalPilots", null, player )
			break

		case "titan_decal_shield":
			//Kill 100 Pilots with a headshot
			data.goal = 100
			data.progress =	StatToInt( "kills_stats", "pilot_headshots_total", null, player )
			break

		case "titan_decal_skullwings":
			//Kill 1000 enemies as a Pilot
			data.goal = 1000
			data.progress =	StatToInt( "kills_stats", "asPilot", null, player )
			break

		case "titan_decal_skullwingsblk":
			//Kill 1000 enemies as a Titan
			data.goal = 1000
			data.progress =	StatToInt( "kills_stats", "asTitan_stryder", null, player )
			data.progress += StatToInt( "kills_stats", "asTitan_atlas", null, player )
			data.progress += StatToInt( "kills_stats", "asTitan_ogre", null, player )
			break

		case "titan_decal_st":
			//Unlocked immediately
			break

		case "titan_decal_ste":
			//Unlocked immediately
			break

		case "titan_decals_stinger":
			//Kill 50 Titans with the Charge Rifle
			data.goal = 50
			data.progress =	StatToInt( "weapon_kill_stats", "titansTotal", "mp_weapon_defender", player )
			break

		case "wings_custom_decal":
			//Ride 3 kilometers on ziplines
			data.goal = 3.0
			data.progress =	floor( StatToFloat( "distance_stats", "ziplining", null, player ) * 100.0 ) / 100.0
			break

		case "titan_decal_flagrunner":
			//Capture 100 flags
			data.goal = 100
			data.progress =	StatToInt( "misc_stats", "flagsCaptured", null, player )
			break

		case "titan_decal_twofer":
			//Have a 2 to 1 kill/death ratio in 20 Pilot Hunter matches
			local statVar = GetPersistentStatVar( "game_stats", "times_kd_2_to_1_pvp_by_mode" )
			local persVar = StatStringReplace( statVar, "%gamemode%", "tdm" )
			data.goal = 20
			data.progress =	IsUI() ? GetPersistentVar( persVar ) : player.GetPersistentVar( persVar )
			break

		case "titan_decal_100guns":
			//Earn 100 Attrition points in a single match 20 times
			data.goal = 20
			data.progress =	StatToInt( "game_stats", "timesScored100AttritionPoints_total", null, player )
			break

		case "titan_decal_crest":
			//Capture 100 hardpoints
			data.goal = 20
			data.progress =	StatToInt( "misc_stats", "hardpointsCaptured", null, player )
			break

		case "titan_decal_titankills":
			//Be the Last Titan Standing for your team 20 times
			data.goal = 100
			data.progress =	StatToInt( "misc_stats", "timesLastTitanRemaining", null, player )
			break

		case "titan_decal_eagleside":
			//Play every mode in Swampland
			data.goal = 5
			data.progress =	IsUI() ? GetPersistentVar( "ach_swamplandAllModes" ) : player.GetPersistentVar( "ach_swamplandAllModes" )
			data.dlcGroup = 1
			break

		case "titan_decal_chevrons":
			//Play every mode in Wargames
			data.goal = 5
			data.progress =	IsUI() ? GetPersistentVar( "ach_wargamesAllModes" ) : player.GetPersistentVar( "ach_wargamesAllModes" )
			data.dlcGroup = 1
			break

		case "titan_decal_glyph":
			//Play every mode in Runoff
			data.goal = 5
			data.progress =	IsUI() ? GetPersistentVar( "ach_runoffAllModes" ) : player.GetPersistentVar( "ach_runoffAllModes" )
			data.dlcGroup = 1
			break

		case "titan_decal_triangle":
			//Kill an enemy Titan while you're in doomed state 20 times
			data.goal = 20
			data.progress =	StatToInt( "kills_stats", "totalTitansWhileDoomed", null, player )
			break

		case "titan_decal_kodai":
			//Absorb 20 projectiles into a single vortex shield usage
			data.goal = 20
			data.progress =	IsUI() ? GetPersistentVar( "mostProjectilesCollectedInVortex" ) : player.GetPersistentVar( "mostProjectilesCollectedInVortex" )
			break

		case "titan_decal_nuke":
			//Get 100 kills using nuclear ejection
			data.goal = 100
			data.progress =	StatToInt( "kills_stats", "nuclearCore", null, player )
			break

		case "titan_decal_fallingbomb":
			//Kill 100 enemies with a Titanfall
			data.goal = 100
			data.progress =	StatToInt( "kills_stats", "titanFallKill", null, player )
			break

		case "titan_decal_grenade":
			//Get a killing spree 25 times
			data.goal = 25
			data.progress =	StatToInt( "misc_stats", "killingSprees", null, player )
			break

		case "titan_decal_firsttofall":
			//Call in your Titan first 50 times
			data.goal = 50
			data.progress =	StatToInt( "misc_stats", "titanFallsFirst", null, player )
			break

		case "titan_decal_pennyarcade":
			//Complete 10 challenges
			data.goal = 10
			data.progress =	StatToInt( "misc_stats", "challengeTiersCompleted", null, player )
			break

		case "titan_decal_dragon":
			//Complete 100 challenges
			data.goal = 100
			data.progress =	StatToInt( "misc_stats", "challengeTiersCompleted", null, player )
			break

		case "titan_decal_respawnbird":
			//Complete 250 challenges
			data.goal = 250
			data.progress =	StatToInt( "misc_stats", "challengeTiersCompleted", null, player )
			break

		case "titan_decal_wonjae":
			//Unlocked immediately
			break

		case "titan_decal_lastimosa":
			//Play Titanfall for 10 hours
			data.goal = 10
			data.progress =	StatToInt( "time_stats", "hours_total", null, player )
			break

		case "titan_decal_austin":
			//Kill 100 Pilots with your Pilot's sidearm
			data.goal = 100
			data.progress =	0
			local pilotSidearms = GetAllItemsOfType( itemType.PILOT_SIDEARM )
			foreach( item in pilotSidearms )
				data.progress += StatToInt( "weapon_kill_stats", "pilots", item.ref, player )
			break

		case "titan_decal_cobra":
			//Unlocked immediately
			break

		case "titan_decal_gunwing":
			//Unlocked immediately
			break

		case "titan_decal_hashtag":
			//Unlocked immediately
			break

		case "titan_decal_nomercy":
			//Kill 50 enemies before they reach the evac ship during epilogue
			data.goal = 50
			data.progress =	StatToInt( "kills_stats", "evacuatingEnemies", null, player )
			break

		case "titan_decal_pegasus":
			//Unlocked immediately
			break

		case "titan_decal_sword":
			//Unlocked immediately
			break

		case "titan_decal_gooser":
			//Do the Gen 5 challenge requirement 'Gooser' the hard way
			data.goal = 50
			data.progress =	StatToInt( "kills_stats", "ejectingPilots", null, player )
			// data.progress = IsUI() ? GetPersistentVar( "previousGooserProgress" ) : player.GetPersistentVar( "previousGooserProgress" )
			break

		case "titan_decal_padoublethreat":
			//Unlocked immediately
			break

		case "titan_decals_blackmarket01":
		case "titan_decals_blackmarket02":
		case "titan_decals_blackmarket03":
		case "titan_decals_blackmarket04":
		case "titan_decals_blackmarket05":
		case "titan_decals_blackmarket06":
		case "titan_decals_blackmarket07":
		case "titan_decals_blackmarket08":
			//Purchase this insignia in the Black Market
			local purchased = DidPlayerBuyItemFromBlackMarket( ref, player )
			data.goal = 1
			data.progress =	purchased ? 1 : 0
			break

		case "titan_decal_export":
			//Play every mode in Export
			data.goal = 5
			data.progress =	IsUI() ? GetPersistentVar( "dlc2achievement.ach_exportAllModes" ) : player.GetPersistentVar( "dlc2achievement.ach_exportAllModes" )
			data.dlcGroup = 2
			break

		case "titan_decal_harmony":
			//Play every mode in Dig Site
			data.goal = 5
			data.progress =	IsUI() ? GetPersistentVar( "dlc2achievement.ach_digsiteAllModes" ) : player.GetPersistentVar( "dlc2achievement.ach_digsiteAllModes" )
			data.dlcGroup = 2
			break

		case "titan_decal_haven":
			//Play every mode in Haven
			data.goal = 5
			data.progress =	IsUI() ? GetPersistentVar( "dlc2achievement.ach_havenAllModes" ) : player.GetPersistentVar( "dlc2achievement.ach_havenAllModes" )
			data.dlcGroup = 2
			break

		case "titan_decal_ichicat":
			//Complete 50 daily challenges
			data.goal = 50
			data.progress =	StatToInt( "misc_stats", "dailyChallengesCompleted", null, player )
			break

		case "titan_decal_pf":
			//Complete 10 daily challenges
			data.goal = 10
			data.progress =	StatToInt( "misc_stats", "dailyChallengesCompleted", null, player )
			break

		case "titan_decal_coop_1":
			//Win 1 coop match
			data.goal = 1
			data.progress =	StatToInt( "game_stats", "mode_won_coop", null, player )
			break

		case "titan_decal_coop_2":
			//Complete all coop challenges
			data.goal = 30
			data.progress = 0
			local refs = GetChallengesByCategory( eChallengeCategory.COOP )
			foreach( ref in refs )
			{
				local tierCount = GetChallengeTierCount( ref )
				local var = GetChallengeStorageArrayNameForRef(ref) + "[" + ref + "].progress"
				local progress = IsUI() ? GetPersistentVar( var ) : player.GetPersistentVar( var )
				//printt( ref, tierCount )
				//printt( "  progress:", progress )
				for ( local i = 0 ; i < tierCount ; i++ )
				{
					local tierGoal = GetGoalForChallengeTier( ref, i )
					//printt( "  tier", i, "goal:", tierGoal )
					if ( progress >= tierGoal )
						data.progress++
				}
			}
			//printt( "Unlock progress:", data.progress )
			break

		case "titan_decals_3s_attrition":
			data.goal = 30
			data.progress = GetTotalMapStarsForMode( ATTRITION, player )
			break

		case "titan_decals_3s_ctf":
			data.goal = 30
			data.progress = GetTotalMapStarsForMode( CAPTURE_THE_FLAG, player )
			break

		case "titan_decals_3s_frontierdef":
			data.goal = 30
			data.progress = GetTotalMapStarsForMode( COOPERATIVE, player )
			break

		case "titan_decals_3s_hardpoint":
			data.goal = 30
			data.progress = GetTotalMapStarsForMode( CAPTURE_POINT, player )
			break

		case "titan_decals_3s_lts":
			data.goal = 30
			data.progress = GetTotalMapStarsForMode( LAST_TITAN_STANDING, player )
			break

		case "titan_decals_3s_marked4death":
			data.goal = 30
			data.progress = GetTotalMapStarsForMode( MARKED_FOR_DEATH, player )
			break

		case "titan_decals_3s_pilothunter":
			data.goal = 30
			data.progress = GetTotalMapStarsForMode( TEAM_DEATHMATCH, player )
			break

		default:
			Assert( 0, "Unhandled decal unlock case" )
			break
	}

	data.unlocked = data.progress >= data.goal

	if ( data.unlocked )
		data.unlockText <- GetItemDecalUnlockReqUnlockedText( ref )
	else
		data.unlockText <- GetItemDecalUnlockReqText( ref )

	return data
}

function UpdatePlayerDecalUnlocks( player, updatePersistence = true )
{
	Assert( IsServer() )
	Assert( IsValid( player ) )
	Assert( player.IsPlayer() )

	if ( player.IsBot() )
		return

	//###########################################################
	// Store what decals were unlocked at the start of the match
	//###########################################################

	local decalItems = GetAllItemsOfType( itemType.TITAN_DECAL )
	foreach( item in decalItems )
	{
		if ( !player.GetPersistentVar( "decalsUnlocked[" + item.ref + "]" ) )
			continue

		if ( IsDecalUnlocked( item.ref, player ) )
		{
			if ( updatePersistence )
				player.SetPersistentVar( "decalsUnlocked[" + item.ref + "]", true )
			if ( IsLobby() )
				SetNewStatus( item.ref, player )
		}
	}
}

// TODO: Default "pretend" attachments shouldn't be baked into weapons.
// Because of this, we don't have real items for everything in order to make this work the right way.
// Should be a real attachment as all others and we can flag it as default in some way.
function GetDefaultAttachmentName( itemRef )
{
	Assert( GetItemType( itemRef ) == itemType.PILOT_PRIMARY )

	switch ( itemRef )
	{
		case "mp_weapon_dmr":
		case "mp_weapon_sniper":
		case "mp_weapon_mega1":
			return "#MOD_SCOPE_6X_NAME"

		default:
			return "#MOD_IRON_SIGHTS_NAME"
	}
}

function GetDefaultAttachmentIcon( itemRef )
{
	Assert( GetItemType( itemRef ) == itemType.PILOT_PRIMARY )

	switch ( itemRef )
	{
		case "mp_weapon_dmr":
		case "mp_weapon_sniper":
		case "mp_weapon_mega1":
			return "../ui/menu/items/attachment_icons/scope_6x"

		default:
			return "../ui/menu/items/attachment_icons/iron_sights"
	}
}
