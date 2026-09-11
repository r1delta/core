const TITAN_HATCHCOMMANDANIMTIME = 1.5	// cooldown time between toggling the cockpit state. Will be needed when we have animations to play

const COCKPIT_JOLT_DAMAGE_MIN = 1
const COCKPIT_JOLT_DAMAGE_MAX = 200
const TITAN_STUMBLE_HEALTH_PERCENTAGE = 0.5

thisClassName <- "titan"

function main()
{
	Globalize( Titan_AddPlayer )
	Globalize( Titan_OnPlayerDeath )
	Globalize( Titan_CreateDropPod )
	Globalize( GiveTitanWeaponsForPlayer )
	Globalize( GiveTitanWeaponsForLoadoutData )
	Globalize( ClientCommand_TitanEject )
	Globalize( GiveHotDropTitanWeaponsForPlayer )
	Globalize( GiveNPCTitanTacticalAbility )
	Globalize( SetTitanOSForPlayer )
	Globalize( SetDecalForTitan )

	AddClientCommandCallback( "TitanEject", ClientCommand_TitanEject ) //
}


function TitanMoverDropPodLaunch( player, pod )
{
	pod.EndSignal( "OnDestroy" )

	pod.WaitSignal( "OnLaunch" )

	local angles = pod.GetUpVector().GetAngles()
	local offset = pod.GetUpVector() * 500

	pod.s.camera.Fire( "Enable", "!activator", 0, player )
	player.SetPlayerSettings( DEFAULT_BOT_TITAN )
	player.MinimapHide()
}

function TitanMoverDropPodImpact( player, pod )
{
	player.EndSignal( "Disconnected" )
	pod.EndSignal( "OnDestroy" )

	pod.WaitSignal( "OnImpact" )

	player.isSpawning = null

	pod.s.camera.FireNow( "Disable" )
	player.RespawnPlayer( pod )

	ScoreEvent_DropImpact( player )
}

function Titan_CreateDropPod( player )
{
	local dropPod = CreateMoverDropPod( player )

	InitTitanDropPod( dropPod )

	player.isSpawning = dropPod

	thread TitanMoverDropPodLaunch( player, dropPod )
	thread TitanMoverDropPodImpact( player, dropPod )

	return dropPod
}


function Titan_AddPlayer( player )
{
	player.playerClassData[thisClassName] <- {}
	player.s.ejectPressTime <- 0
	player.s.ejectPressCount <- 0
	player.s.lastStaggerTime <- 0
}

function GiveNPCTitanTacticalAbility( titan )
{
	local weapon = titan.GetOffhandWeapon( 1 )
	if ( weapon )
	{
		local weaponName = weapon.GetWeaponClassName()
		local abilityType = TTA_NONE

		switch ( weaponName )
		{
		//case "mp_weapon_mega5":// dunno how itll affect the game but may aswell try
		case "mp_titanweapon_vortex_shield":
			abilityType = TTA_VORTEX
			break

		case "mp_titanability_smoke":
		case "mp_weapon_mega4": //added by kwanyongjung
			abilityType = TTA_SMOKE
			break

		case "mp_titanability_bubble_shield":
			abilityType = TTA_WALL
			break

		default:
			Assert( 0, "invalid titan tactical ability " + weaponName )
			break
		}

		titan.SetTacticalAbility( weapon, abilityType )
	}
}

function GiveTitanWeaponsForPlayer( player, titan, existingTitan = false )
{
	printl( "player given ")
	if ( IsTrainingLevel() )
		return

	UpdateLastTitanLoadout( player )

	local table = player.playerClassData["titan"]

	if ( level.onOverrideLoadoutCallbacks )
		foreach ( callbackInfo in level.onOverrideLoadoutCallbacks )
			callbackInfo.func.acall( [callbackInfo.scope, player, table, true] )

	local soul = titan.GetTitanSoul()
	if ( soul )
	{
		if ( table.passive1 )
		{
			GivePassive( soul, table.passive1 )
		}
		if ( table.passive2 )
		{
			GivePassive( soul, table.passive2 )
		}
	}

	if ( player.IsBot() )
	{
		local bot_randomize_loadout = GetConVarInt( "bot_randomize_loadout" )
		if ( bot_randomize_loadout )
			RandomizeBotLoadout( table, true )
		OverrideBotLoadout( table, true )
	}

	//Existing Titan is to prevent disembark and eject from starting a burn card that's been put on deck after the Titan has been called in.

	if ( table.primaryWeapon )
		titan.GiveWeapon( table.primaryWeapon, table.primaryWeaponMods )

	if ( table.secondaryWeapon )
		titan.GiveWeapon( table.secondaryWeapon, table.secondaryWeaponMods )

	if ( table.offhandWeapons )
	{
	    local offhands = table.offhandWeapons

	    // take offhand weapons first if necessary
	    titan.TakeOffhandWeapon( 0 )
	    titan.TakeOffhandWeapon( 1 )

		//this is a lot just for these 2 passives and to not break the game again
		local tactical = offhands[1].weapon
		local ordnance = offhands[0].weapon
		local tac_mods = offhands[1].mods
		local ord_mods = offhands[0].mods
		local tac_stuff = {}
		local ord_stuff = {}
		tac_stuff.weapon <- tactical
		tac_stuff.mods <- tac_mods
		ord_stuff.weapon <- ordnance
		ord_stuff.mods <- ord_mods

		local offhand_weaponry = [ ord_stuff, tac_stuff ]

		//through the power of over-engineering: dual platform is achieved

		//printl( table.passive2 )

		local loop_max = MasterModdedTitans.len()
		for( local E = 0; E < loop_max; E++ )
		{
			if( loop_max > 0 )
			{
				local t_a = MasterModdedTitans[ E ]

				if( t_a.setfile == GetSoulPlayerSettings( soul ) )
				{
					if( t_a.weapon_overrides != null )
					{
						if( t_a.weapon_overrides.replaces_tactical == true )
							offhand_weaponry[1].weapon = TryReplacementOverride( offhand_weaponry[1].weapon, offhand_weaponry[0].weapon, t_a.weapon_overrides, 1 )
						if( t_a.weapon_overrides.replaces_ordnance == true )
							offhand_weaponry[0].weapon = TryReplacementOverride( offhand_weaponry[1].weapon, offhand_weaponry[0].weapon, t_a.weapon_overrides, 0 )
						if( t_a.weapon_overrides.replaces_primary == true )
						{
							local p_weap = titan.GetActiveWeapon().GetWeaponClassName()
							titan.TakeWeapon( p_weap )
							titan.GiveWeapon( TryReplacementOverride( null, null, t_a.weapon_overrides, 2 ) )
						}
					}
				}
			}
		}

        if ( "weapon" in offhand_weaponry[0] )
        {
			if ( !TryAssignOffhand( player, titan, offhand_weaponry, 0, "offhands_titans_offensive" ) )
				titan.GiveOffhandWeapon( offhand_weaponry[0].weapon, 0, [] )
	    }

        if ( "weapon" in offhand_weaponry[1] )
        {
			if ( !TryAssignOffhand( player, titan, offhand_weaponry, 1, "offhands_titans_defensive" ) )
				titan.GiveOffhandWeapon( offhand_weaponry[1].weapon, 1, [] )
	    }
	}

	if ( titan.IsNPC() )
		GiveNPCTitanTacticalAbility( titan )

	local soul = player.GetTitanSoul()
	if ( !IsValid( soul ) )
		soul = titan.GetTitanSoul()
	Assert( IsValid( soul ) )

	local titanType = GetSoulTitanType( soul )

	// Give Titan it's signature active ability
	titan.TakeOffhandWeapon( 2 )

	titan.GiveOffhandWeapon( "mp_titanability_fusion_core", 2 )//You COULD interject here for fully custom cores

	if ( IsValid( soul.rocketPod.model ) )
		soul.rocketPod.model.Kill()
	soul.rocketPod.model = null

	if ( IsValid( soul.chargeCannon.model ) )
		soul.chargeCannon.model.Kill()
	soul.chargeCannon.model = null

	local ordn = titan.GetOffhandWeapon( 0 ).GetWeaponClassName()
	local spec = titan.GetOffhandWeapon( 1 ).GetWeaponClassName()

	if ( CheckingMissilesOverwritten( ordn, spec ) )
	{
		CreateTitanRocketPods( soul, titan )
	}

	if ( ordn == "mp_weapon_mega4" || spec == "mp_weapon_mega4" )
		CreateChargeCannon( soul, titan )

	if (!existingTitan)
	  	thread ApplyTitanBurnCards_Threaded( titan )

	ChangeWeaponSkin( titan, titan.GetTeam() )

	if ( level.onChangeLoadoutCallbacks )
		foreach ( callbackInfo in level.onChangeLoadoutCallbacks )
			callbackInfo.func.acall( [callbackInfo.scope, player, table, true] )
}

function GiveHotDropTitanWeaponsForPlayer( player, titan )
{
	if ( IsTrainingLevel() )
		return

	local table = player.playerClassData["titan"]

	if ( table.primaryWeapon )
		titan.GiveWeapon( table.primaryWeapon, table.primaryWeaponMods )

	local soul = titan.GetTitanSoul()
	Assert( IsValid( soul ) )
	Assert( !IsValid( soul.rocketPod.model ) )
	Assert( !IsValid( soul.chargeCannon.model ) )

	local offhands = table.offhandWeapons

	titan.TakeOffhandWeapon( 0 )
	titan.TakeOffhandWeapon( 1 )

	local tactical = offhands[1].weapon
	local ordnance = offhands[0].weapon
	local tac_mods = offhands[1].mods
	local ord_mods = offhands[0].mods
	local tac_stuff = {}
	local ord_stuff = {}
	tac_stuff.weapon <- tactical
	tac_stuff.mods <- tac_mods
	ord_stuff.weapon <- ordnance
	ord_stuff.mods <- ord_mods

	local offhand_weaponry = [ ord_stuff, tac_stuff ]

	local loop_max = MasterModdedTitans.len()
	for( local E = 0; E < loop_max; E++ )
	{
		if( loop_max > 0 )
		{
			local t_a = MasterModdedTitans[ E ]

			if( t_a.setfile == GetSoulPlayerSettings( soul ) )
			{
				if( t_a.weapon_overrides != null )
				{
					if( t_a.weapon_overrides.replaces_tactical == true )
						offhand_weaponry[1].weapon = TryReplacementOverride( offhand_weaponry[1].weapon, offhand_weaponry[0].weapon, t_a.weapon_overrides, 1 )
					if( t_a.weapon_overrides.replaces_ordnance == true )
						offhand_weaponry[0].weapon = TryReplacementOverride( offhand_weaponry[1].weapon, offhand_weaponry[0].weapon, t_a.weapon_overrides, 0 )
					if( t_a.weapon_overrides.replaces_primary == true )
					{
						local p_weap = titan.GetActiveWeapon().GetWeaponClassName()
						titan.TakeWeapon( p_weap )
						titan.GiveWeapon( TryReplacementOverride( null, null, t_a.weapon_overrides, 2 ) )
					}
				}
			}
		}
	}

	titan.GiveOffhandWeapon( offhand_weaponry[0].weapon, 0, [] )
	titan.GiveOffhandWeapon( offhand_weaponry[1].weapon, 1, [] )

	wait 0.1

	local ordn = titan.GetOffhandWeapon( 0 ).GetWeaponClassName()
	local spec = titan.GetOffhandWeapon( 1 ).GetWeaponClassName()

	if ( CheckingMissilesOverwritten( ordn, spec ) )
	{
		CreateTitanRocketPods( soul, titan )
	}

	if ( ordn == "mp_weapon_mega4" || spec == "mp_weapon_mega4" )
		CreateChargeCannon( soul, titan )
	

	ChangeWeaponSkin( titan, titan.GetTeam() )
}

function GiveTitanWeaponsForLoadoutData( titan, table )
{
	titan.GiveWeapon( table.primary, [] )
	local offhands = table.offhandWeapons
	local soul = titan.GetTitanSoul()

	if ( table.secondary )
		titan.GiveWeapon( table.secondary, [] )

    titan.TakeOffhandWeapon( 0 )
    titan.TakeOffhandWeapon( 1 )

	local tactical = offhands[1].weapon
	local ordnance = offhands[0].weapon
	local tac_mods = offhands[1].mods
	local ord_mods = offhands[0].mods
	local tac_stuff = {}
	local ord_stuff = {}
	tac_stuff.weapon <- tactical
	tac_stuff.mods <- tac_mods
	ord_stuff.weapon <- ordnance
	ord_stuff.mods <- ord_mods

	local offhand_weaponry = [ ord_stuff, tac_stuff ]

		//through the power of over-engineering: dual platform is achieved

		//printl( table.passive2 )
	local loop_max = MasterModdedTitans.len()
	for( local E = 0; E < loop_max; E++ )
	{
		if( loop_max > 0 )
		{
			local t_a = MasterModdedTitans[ E ]

			if( t_a.setfile == GetSoulPlayerSettings( soul ) )
			{
				if( t_a.weapon_overrides != null )
				{
					if( t_a.weapon_overrides.replaces_tactical == true )
						offhand_weaponry[1].weapon = TryReplacementOverride( offhand_weaponry[1].weapon, offhand_weaponry[0].weapon, t_a.weapon_overrides, 1 )
					if( t_a.weapon_overrides.replaces_ordnance == true )
						offhand_weaponry[0].weapon = TryReplacementOverride( offhand_weaponry[1].weapon, offhand_weaponry[0].weapon, t_a.weapon_overrides, 0 )
					if( t_a.weapon_overrides.replaces_primary == true )
					{
						local p_weap = titan.GetActiveWeapon().GetWeaponClassName()
						titan.TakeWeapon( p_weap )
						titan.GiveWeapon( TryReplacementOverride( null, null, t_a.weapon_overrides, 2 ) )
					}
				}
			}
		}
	}

	titan.GiveOffhandWeapon( offhand_weaponry[0].weapon, 0, [] )
	titan.GiveOffhandWeapon( offhand_weaponry[1].weapon, 1, [] )
	//thought about the dual rocketpod model and had it at one point... was kinda meh with no right hand version

	ChangeWeaponSkin( titan, titan.GetTeam() )
}

function Titan_OnPlayerDeath( player, damageInfo )
{
	delete player.s.storedPilotLoadout
}


function PlayerCanEject( player )
{
	if ( !IsAlive( player ) )
		return false

	if ( !player.IsTitan() )
		return false

	if ( Riff_TitanExitIsDisabled() )
		return false

//	if ( "embarkingTitan" in player.s )
//		return false

	if ( "isDisembarking" in player.s )
		return false

	if ( Riff_TitanEjectIsDisabled() )
		return false

	if ( GameRules.GetGameMode() == CAPTURE_THE_TITAN && IsValid( level.teamFlag ) && level.teamFlag.GetBossPlayer() == player )
	 	return false

	return true
}

function ClientCommand_TitanEject( player, ejectPressCount )
{
	if ( !PlayerCanEject( player ) )
		return true

	ejectPressCount = ejectPressCount.tointeger()

	if ( ejectPressCount < 0 )
		return false

	player.s.ejectPressTime = Time()
	player.s.ejectPressCount = ejectPressCount.tointeger()

	if ( player.s.ejectPressCount < 3 )
		return true

	thread TitanEjectPlayer( player )

	return true
}

function SetTitanOSForPlayer( player )
{
	local playerClassDataTable = GetPlayerClassDataTable( player, "titan" )
	local titanLoadoutVoice = playerClassDataTable.voiceChoice
	local titanOSEnumIndex = PersistenceGetEnumIndexForItemName( "titanOS", titanLoadoutVoice )

	if ( titanOSEnumIndex == -1 )
	{
		titanOSEnumIndex = 0
	}

	player.SetVoicePackIndex ( titanOSEnumIndex )
}

function SetDecalForTitan( player )
{
    local playerClassDataTable = GetPlayerClassDataTable( player, "titan" )
    local titanLoadoutDecal

    if( ( "decal" in playerClassDataTable ) )
        titanLoadoutDecal = playerClassDataTable.decal

    local team = player.GetTeam()
    local skinIndex

    if ( titanLoadoutDecal == null )
        skinIndex = team == TEAM_MILITIA ? 1 : 0
    else
        skinIndex = GetDecalSkinForTeam( titanLoadoutDecal, team )

    if ( player.IsTitan() )
        player.SetSkin( skinIndex )
    else
    {
        local titan = player.GetPetTitan()
        if ( IsValid( titan ) )
            titan.SetSkin( skinIndex )
    }
}

function TryReplacementOverride( loadout_special, loadout_ordnance, weap_table, type )
{

	switch( type )
	{
		case 0: //ORDNANCE
			if( weap_table.ordnance_weapon_id != null && weap_table.ordnance_weapon_id != "" )
				return weap_table.ordnance_weapon_id
			return TryDualOffhandWeaponry( loadout_special, loadout_ordnance, false )
		case 1: //SPECIAL
			if( weap_table.tactical_weapon_id != null && weap_table.tactical_weapon_id != "" )
				return weap_table.tactical_weapon_id
			return TryDualOffhandWeaponry( loadout_special, loadout_ordnance, true )
		case 2: //PRIMARY
			if( weap_table.primary_weapon_id != null && weap_table.primary_weapon_id != "" )
				return weap_table.primary_weapon_id
			return "mp_titanweapon_xo16"
			
	}
}

function TryDualOffhandWeaponry( loadout_special, loadout_ordnance, replaces_tactical_instead )
{
	if( replaces_tactical_instead == true)
	{
		switch ( loadout_special )
		{
			case "mp_weapon_mega4":
				if ( loadout_ordnance == "mp_titanweapon_salvo_rockets" )
				{
					return "mp_titanweapon_shoulder_rockets"
				}
				return "mp_titanweapon_salvo_rockets"
			
			case "mp_titanweapon_vortex_shield":
				if ( loadout_ordnance == "mp_titanweapon_homing_rockets" )
				{
					return "mp_titanweapon_salvo_rockets"
				}
				return "mp_titanweapon_homing_rockets"
			
			case "mp_titanability_smoke":
				if ( loadout_ordnance == "mp_titanweapon_dumbfire_rockets" )
				{
					return "mp_titanweapon_homing_rockets"
				}
				return "mp_titanweapon_dumbfire_rockets"
			
			case "mp_titanability_bubble_shield":
				if ( loadout_ordnance == "mp_titanweapon_shoulder_rockets" )
				{
					return "mp_titanweapon_dumbfire_rockets"
				}
				return "mp_titanweapon_shoulder_rockets"
			
			default:
				if ( loadout_ordnance == "mp_titanweapon_shoulder_rockets" )
					return "mp_titanweapon_dumbfire_rockets"
				if ( loadout_ordnance == "mp_titanweapon_dumbfire_rockets" )
					return "mp_titanweapon_homing_rockets"
				if ( loadout_ordnance == "mp_titanweapon_homing_rockets" )
					return "mp_titanweapon_salvo_rockets"
				if ( loadout_ordnance == "mp_titanweapon_salvo_rockets" )
					return "mp_titanweapon_shoulder_rockets"
				return "mp_titanweapon_salvo_rockets"
		}
	}
	else
	{
		switch ( loadout_ordnance )
		{
			case "mp_titanweapon_salvo_rockets":
				if ( loadout_special == "mp_weapon_mega4" )
				{
					return "mp_titanability_bubble_shield"
				}
				return "mp_weapon_mega4"
			
			case "mp_titanweapon_homing_rockets":
				if ( loadout_special == "mp_titanweapon_vortex_shield" )
				{
					return "mp_weapon_mega4"
				}
				return "mp_titanweapon_vortex_shield"
			
			case "mp_titanweapon_dumbfire_rockets":
				if ( loadout_special == "mp_titanability_smoke" )
				{
					return "mp_titanweapon_vortex_shield"
				}
				return "mp_titanability_smoke"
			
			case "mp_titanweapon_shoulder_rockets":
				if ( loadout_special == "mp_titanability_bubble_shield" )
				{
					return "mp_titanability_smoke"
				}
				return "mp_titanability_bubble_shield"
			
			default:
				if ( loadout_ordnance == "mp_titanweapon_salvo_rockets" )
					return "mp_weapon_mega4"
				if ( loadout_ordnance == "mp_titanweapon_homing_rockets" )
					return "mp_titanweapon_vortex_shield"
				if ( loadout_ordnance == "mp_titanweapon_dumbfire_rockets" )
					return "mp_titanability_smoke"
				if ( loadout_ordnance == "mp_titanweapon_shoulder_rockets" )
					return "mp_titanability_bubble_shield"
				return "mp_titanweapon_vortex_shield"
		}
	}
}

function CheckingMissilesOverwritten( ordnance, special )
{
	if ( ordnance == "mp_titanweapon_salvo_rockets" || special == "mp_titanweapon_salvo_rockets" )
		return true
	if ( ordnance == "mp_titanweapon_dumbfire_rockets" || special == "mp_titanweapon_dumbfire_rockets" )
		return true
	if ( ordnance == "mp_titanweapon_homing_rockets" || special == "mp_titanweapon_homing_rockets" )
		return true
	if ( ordnance == "mp_titanweapon_shoulder_rockets" || special == "mp_titanweapon_shoulder_rockets" )
		return true
	
	return false
}