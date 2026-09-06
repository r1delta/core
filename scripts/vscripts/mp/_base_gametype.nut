//********************************************************************************************
//	Base Gametype
//********************************************************************************************
const DEATH_CHAT_DELAY = 0.3
IncludeScript("_persistentdata")
::botSettings <- DEFAULT_BOT_TITAN

function main()
{
	FlagInit( "APlayerHasSpawned" )
	FlagInit( "PilotBot" )

	FlagInit( "CinematicEnding" )

	if ( !reloadingScripts )
	{
		level.gameTypeText <- null
		weaponStrip <- null
		music_ambient_generic <- null
		level.classTypeText <- null
		level.publicMessage <- null

		// player wave spawning
		level.waveSpawnTime <- {
			[TEAM_IMC] = 0,
			[TEAM_MILITIA] = 0
		}

		level.waveSpawnByDropship <- false

		level.pilotRespawnDelay <- 0

		// table of functions that get called whenever a player or npc is killed
		level.onPlayerOrNPCKilledCallbacks <- {}
		level.onNPCKilledCallbacks <- {}
		level.onLeechedCustomCallbackFunc <- {}
		level.onWeaponAttackCallbacks <- {} // these run whenever a weapon is fired

	    level.hardpoints <- []

	    // [LJS] 하드포인트 일정시간마다 랜덤하게 활성화
	    //level.hardpoint_lastEnableTime <- null

	    // [LJS] rushPoint
	    //level.rushpoints <- []

		level.titanAlwaysAvailableForTeam <- [ 0, 0, 0, 0 ]
		level.forcePilotSpawnPointForTeam <- {}
		level.forcePilotSpawnPointForTeam[ 0 ] <- null
		level.forcePilotSpawnPointForTeam[ TEAM_MILITIA ] <- null
		level.forcePilotSpawnPointForTeam[ TEAM_IMC ] <- null

		level.forcedToSpawnTogether <- {} // players on this team are forced to spawn together

		level.titanVOTitanDeadDistSqr <- 2000 * 2000

		level.missingPlayersTimeout <- null

		level.shouldPlayerBeEliminatedFuncTable <- null
    	level.lastForceSwitchTime <- {} // Track last force switch time per player

		level.customPlayerEliminatedMessage <- null

		CreateTeamColorControlPoints()

		AddClientCommandCallback( "CC_SelectRespawn", ClientCommand_SelectRespawn ) //
 		AddClientCommandCallback( "CC_RespawnPlayer", ClientCommand_RespawnPlayer ) //

		AddClientCommandCallback( "PrivateMatchEndMatch", ClientCommand_PrivateMatchEndMatch )

		AddClientCommandCallback( "SwitchMe", ClientCommand_SwitchMe )
		AddClientCommandCallback( "switchme", ClientCommand_SwitchMe )

		AddCallback_GameStateEnter( eGameState.Playing, GameStart_AutoBalanceCooldown )

		MarkTeamsAsBalanced_Off()

		level.altTitanBuildTimer <- GetCurrentPlaylistVarInt( "alt_titan_build_timer", 0 ) ? true : false

		thread OutOfBoundsSetup()

		level.waveSpawnCustomDropshipAnim <- null
		level.waveSpawnCustomPlayerIdleAnim <- []
		level.waveSpawnCustomPlayerJumpAnim <- []
		level.waveSpawnCustomSpawnPoints <- {}
		level.waveSpawnCustomSpawnPoints[ TEAM_MILITIA ] <- []
		level.waveSpawnCustomSpawnPoints[ TEAM_IMC ] <- []
	}

	RegisterSignal( "TitanAvailable" )
	RegisterSignal( "OnDamageNotify" )
	RegisterSignal( "OnRespawned" )
	RegisterSignal( "ChoseToSpawnAsTitan" )
	RegisterSignal( "OutOfBounds" )
	RegisterSignal( "BackInBounds" )
	RegisterSignal( "PlayerKilled" )
	RegisterSignal( "RespawnMe" )
	RegisterSignal( "SpawnClassChanged" )
	RegisterSignal( "SimulateGameScore" )
	RegisterSignal( "ObserverThread" )
	RegisterSignal( "TitanSpawnRetryLifecycleInvalid" )
	FlagInit( "Zipline_Spawning" )
}

function UsingAltTitanBuildTimer()
{
	return level.altTitanBuildTimer
}

function CreateTeamColorControlPoints()
{
	Assert( !( "fx_CP_color_enemy" in level ) )
	Assert( !( "fx_CP_color_friendly" in level ) )

	local enemy = null
	enemy = CreateEntity( "info_placement_helper" )
	enemy.SetName( UniqueString( "teamColorControlPoint_enemy" ) )
	enemy.kv.start_active = 1
	DispatchSpawn( enemy )

	enemy.SetOrigin( Vector( ENEMY_COLOR_FX[0], ENEMY_COLOR_FX[1], ENEMY_COLOR_FX[2] ) )
	level.fx_CP_color_enemy <- enemy

	local friendly = null
	friendly = CreateEntity( "info_placement_helper" )
	friendly.SetName( UniqueString( "teamColorControlPoint_friendly" ) )
	friendly.kv.start_active = 1
	DispatchSpawn( friendly )

	friendly.SetOrigin( Vector( FRIENDLY_COLOR_FX[0], FRIENDLY_COLOR_FX[1], FRIENDLY_COLOR_FX[2] ) )
	level.fx_CP_color_friendly <- friendly
}

function ObserveOverride( player )
{
	return false
}


function CodeCallback_OnPrecache()
{
	Assert( GAMETYPE in GAMETYPE_TEXT )
	weaponStrip = CreateEntity( "player_weaponstrip" )
	DispatchSpawn( weaponStrip, false )

	PrecacheEntity( "npc_marvin" )
	PrecacheEntity( "npc_soldier" )
	PrecacheEntity( "npc_dropship", null, DROPSHIP_MODEL )

	PrecacheModel( CTF_FLAG_BASE_MODEL )
	PrecacheModel( CTF_FLAG_MODEL )

	if ( GameRules.GetGameMode()  == COOPERATIVE )
		CoopPrecache()

	if( GameRules.GetGameMode()  == BIG_BROTHER )
	{
		PrecacheModel( MODEL_MEGA_TURRET )
	}

	//Scavenger ore models. Need to precache here instead of in gamemode scripts for vpk builds
	//Removing for build

	// The rest of these models werent shipped!
	// TODO: create new ones?
	level.scavengerSmallRocks <- [
		"models/rocks/single_rock_01.mdl"
		//"models/rocks/rock_01_sandstone.mdl"
		//"models/rocks/rock_02_sandstone.mdl"
		//"models/rocks/rock_03_sandstone.mdl"
		//"models/rocks/single_rock_02.mdl"
		//"models/rocks/single_rock_03.mdl"
		//"models/rocks/single_rock_04.mdl"
	]

	level.scavengerLargeRocks <- [
		"models/rocks/single_rock_01.mdl"
		//"models/rocks/rock_boulder_large_01.mdl"
		//"models/rocks/sandstone_rock01.mdl"
		//"models/rocks/sandstone_rock02.mdl"
		//"models/rocks/sandstone_rock03.mdl"
		//"models/rocks/sandstone_rock04.mdl"
		//"models/rocks/sandstone_rock05.mdl"
	]

	foreach ( model in level.scavengerSmallRocks )
	{
		PrecacheModel( model )
	}

	foreach ( model in level.scavengerLargeRocks )
	{
		PrecacheModel( model )
	}

	const SOLDIER_SOUND_PAIN = "npc_grunt_pain"

	//if ( !IsMenuLevel() )
	{
		InitGameState()
		if ( GetCinematicMode() == 2 )
			SetGameState( eGameState.WaitingForCustomStart )
		else
			SetGameState( eGameState.WaitingForPlayers )
	}

	level.ui.disableDev = IsMatchmakingServer()
}

// HACK we want these to live in the different included files but that messes up X1 VPK building
function CoopPrecache()
{
	// Coop PreCaches can't be inside a conditional include file so I moved them here - Roger
	PrecacheModel( MODEL_GEN_TOWER )
	PrecacheModel( MODEL_GEN_TOWER_RINGS )
	PrecacheModel( MODEL_MEGA_TURRET )
	PrecacheModel( MODEL_CONTROL_PANEL )
	PrecacheModel( CLOAKED_DRONE_MODEL )
	PrecacheModel( TEAM_IMC_CAPTAIN_MDL )
	PrecacheModel( LOADOUT_CRATE_MODEL )
	PrecacheModel( SUICIDE_SPECTRE_MODEL )
    PrecacheModel( "models/dev/empty_model.mdl" )
    PrecacheModel( LAPTOP_MODEL_SMALL )

	PrecacheParticleSystem( FX_GEN_HARVESTER_BEAM )
    PrecacheParticleSystem( FX_GEN_HEALTH_LOW )
	PrecacheParticleSystem( FX_SPECTRE_BUBBLESHIELD )
	PrecacheParticleSystem( FX_HARVESTER_SHIELD )
	PrecacheParticleSystem( FX_HARVESTER_SHIELD_BREAK )
	PrecacheParticleSystem( FX_SPECTRE_GOING_CRITICAL_1 )
	PrecacheParticleSystem( FX_SPECTRE_EXPLOSION )
	PrecacheParticleSystem( FX_SPECTRE_DEACTIVATING )
	PrecacheParticleSystem( FX_SPECTRE_DEACTIVATED_SPARKS )
	PrecacheParticleSystem( FX_DRONE_CLOAK_BEAM )
	PrecacheParticleSystem( FX_EMP_FIELD )
	PrecacheParticleSystem( "P_drone_dam_smoke" )
    PrecacheParticleSystem( "P_drone_exp_md" )

    //a search of these two effects finds zero results anywhere in script, but the precache is needed to fix Bug 75964
    PrecacheParticleSystem( "P_burn_full" )
    PrecacheParticleSystem( "health_burn_bg_black" )
}


function AddFlinch( attackedEnt, damageInfo )
{
	Assert( IsValid_ThisFrame( attackedEnt ) )

	if ( !( "nextFlinchTime" in attackedEnt.s ) )
		attackedEnt.s.nextFlinchTime <- 0

	if ( Time() < attackedEnt.s.nextFlinchTime )
		return

	attackedEnt.s.nextFlinchTime = Time() + RandomFloat( 2.0, 4.0 )

	local damageAngles = damageInfo.GetDamageForce().GetAngles()
	local entAngles = attackedEnt.EyeAngles()

	local damageYaw = (damageAngles.y + 180) - entAngles.y

	damageYaw = AngleNormalize( damageYaw )

	if ( damageYaw < 0 )
		damageYaw += 360

	if ( damageYaw < 45 )
		damageInfo.SetFlinchDirection( FLINCH_DIRECTION_BACKWARDS );
	else if ( damageYaw < 135 )
		damageInfo.SetFlinchDirection( FLINCH_DIRECTION_RIGHT );
	else if ( damageYaw < 225 )
		damageInfo.SetFlinchDirection( FLINCH_DIRECTION_FORWARDS );
	else if ( damageYaw < 315 )
		damageInfo.SetFlinchDirection( FLINCH_DIRECTION_LEFT );
	else
		damageInfo.SetFlinchDirection( FLINCH_DIRECTION_BACKWARDS );
}


function ScriptCallback_ShouldEntTakeDamage( ent, damageInfo )
{
	if ( HasGameStateProtection( ent ) )
	{
		return false // can't die in current gamestate
	}

	if ( "invulnerable" in ent && ent.IsInvulnerable() )
	{
		return false
	}

	local attacker = damageInfo.GetAttacker()

	if ( !attacker )
	{
		return false
	}

	local damageSourceID = damageInfo.GetDamageSourceIdentifier()
	local suicideSpectreDamage = ( damageSourceID == eDamageSourceId.suicideSpectre || damageSourceID == eDamageSourceId.suicideSpectreAoE )
	local attackerOwnsEnt = attacker == ent || ent.GetOwner() == attacker || ent.GetBossPlayer() == attacker

	if ( attackerOwnsEnt && ( "preventOwnerDamage" in ent.s ) && ent.s.preventOwnerDamage == true && !( damageInfo.GetCustomDamageType() & DF_DOOMED_HEALTH_LOSS ) )
	{
		return false
	}

	if ( damageSourceID != eDamageSourceId.switchback_trap && !suicideSpectreDamage && !attackerOwnsEnt && ShouldPreventFriendlyFire( ent, attacker ) )
	{
		return false
	}

	if ( ent.IsTitan() )
	{
		if ( damageInfo.GetCustomDamageType() & DF_NO_TITAN_DMG )
			return false

		if ( IsTitanWithinBubbleShield( ent ) )
			return false
	}


	if ( "ignoreFootstepDamage" in ent.s && ent.s.ignoreFootstepDamage == true )
	{
		if ( damageInfo.GetDamageType() == DMG_CLUB )
			return false
	}

	if ( IsInSkit( attacker ) && IsInSkit( ent ) )
	{
		return false
	}

	if ( ent.IsPlayer() )
	{
		return ShouldPlayerTakeDamage( ent, damageInfo )
	}

	return true
}

function ShouldPlayerTakeDamage( player, damageInfo )
{
	if ( player.IsGodMode() )
		return false

	if ( player.IsInvulnerable() )
		return false


	if ( player.IsTitan() )
	{
		return true
	}
	else
	{
		//Rodeo cases
		local titanSoul = GetTitanSoulBeingRodeoed( player )
		if ( IsValid( titanSoul ) )
		{
			local titan = titanSoul.GetTitan()
			//Stop being stepped on by the guy you are rodeoing
			if ( IsTitanCrushDamage( damageInfo ) && ( titan == damageInfo.GetAttacker() ) )
				return false
			else return true
		}
		else
			return true
	}
}


// called from _codecallbacks_shared
function MPCallback_DamageEntity( ent, damageInfo )
{
	local attacker = damageInfo.GetAttacker()

	//ModifyDamageInfoForOverdrive( ent, damageInfo )

	UpdateLastDamageTime( ent )

	if ( "OnEntityTakeDamage" in ent.s )
		ent.s.OnEntityTakeDamage( ent, damageInfo )

	AddFlinch( ent, damageInfo )

	UpdateAttackerInfo( ent, attacker, damageInfo.GetDamage() )
}

function HandlePainSounds( ent, damageInfo )
{
	if ( ent.IsPlayer() )
		return

	//printl( "health " + ent.GetHealth() )
	//printl( "damage " + damageInfo.GetDamage() )

	//exit if the thing is dead
	if ( ent.GetHealth() < damageInfo.GetDamage() )
		return

	switch ( ent.GetClassname() )
	{
		case "npc_soldier":
		{
			//printl( "----------------------------PlayPainSounds_Soldier" )
			EmitSoundOnEntity( ent, SOLDIER_SOUND_PAIN )
			break
		}
	}
}

function HandleLocationBasedDamage( ent, damageInfo )
{
	// Don't allow non-players to get headshots or any other location bonuses
	local attacker = damageInfo.GetAttacker()
	if ( !IsValid( attacker ) || !attacker.IsPlayer() )
		return

	local debugPrints = false
	local hitGroup = damageInfo.GetHitGroup()

	if ( debugPrints )
	{
		printt( "---------------------" )
		printt( "LOCATION BASED DAMAGE" )
		printt( "HIDGROUP ID:", hitGroup )
		if ( hitGroup == HITGROUP_GENERIC )
			printt( "HITGROUP: HITGROUP_GENERIC" )
		else if ( hitGroup == HITGROUP_HEAD )
			printt( "HITGROUP: HITGROUP_HEAD" )
		else if ( hitGroup == HITGROUP_CHEST )
			printt( "HITGROUP: HITGROUP_CHEST" )
		else if ( hitGroup == HITGROUP_STOMACH )
			printt( "HITGROUP: HITGROUP_STOMACH" )
		else if ( hitGroup == HITGROUP_LEFTARM )
			printt( "HITGROUP: HITGROUP_LEFTARM" )
		else if ( hitGroup == HITGROUP_RIGHTARM )
			printt( "HITGROUP: HITGROUP_RIGHTARM" )
		else if ( hitGroup == HITGROUP_LEFTLEG )
			printt( "HITGROUP: HITGROUP_LEFTLEG" )
		else if ( hitGroup == HITGROUP_RIGHTLEG )
			printt( "HITGROUP: HITGROUP_RIGHTLEG" )
		else if ( hitGroup == HITGROUP_GEAR )
			printt( "HITGROUP: HITGROUP_GEAR" )
		else
			printt( "HITGROUP: UNKNOWN" )
	}

	local damageTypes = damageInfo.GetCustomDamageType()
	if ( IsValidHeadShot( damageInfo, ent ) )
		damageInfo.SetCustomDamageType( damageTypes | DF_HEADSHOT )

	local damageMult_location = 1.0

	local damageScaleEnt = damageInfo.GetWeapon()
	if ( !damageScaleEnt && (damageInfo.GetInflictor() instanceof CProjectile) )
		damageScaleEnt = damageInfo.GetInflictor()

	if ( ent.IsTitan() )
	{
		damageMult_location = GetCriticalScaler( ent, damageInfo, attacker )
	}
	else if ( UseLocationDamageScale( damageScaleEnt ) )
	{
		if ( !(damageInfo.GetCustomDamageType() & DF_EXPLOSION ) )
		{
			if ( hitGroup == HITGROUP_HEAD && !IsValidHeadShot( damageInfo, ent ) )
				hitGroup = HITGROUP_CHEST

			if ( ent.IsNPC() && hitGroup == HITGROUP_HEAD )
				damageMult_location = LOCATION_DAMAGE_MOD_HEADSHOT_NPC
			else
				damageMult_location = GetLocationDamageScale( damageScaleEnt, hitGroup )
		}
	}

	if ( debugPrints )
	{
		printt( "Multiplier:", damageMult_location )
		printt( "---------------------" )
	}

	// modify damage value based on where we hit
	damageInfo.SetDamage( damageInfo.GetDamage() * damageMult_location )
}

function PlayerDamageFeedback( ent, damageInfo )
{
//	printt( "player damage feedback for " + ent )
	local attacker = damageInfo.GetAttacker()
	if ( !attacker.IsPlayer() )
		return

	local customDamageType = damageInfo.GetCustomDamageType()

	if ( IsMaxRangeShot( damageInfo ) )
		customDamageType = customDamageType | DF_MAX_RANGE

	if ( ent.GetHealth() - damageInfo.GetDamage() <= 0 )
		customDamageType = customDamageType | DF_KILLSHOT

	if ( ent.IsPlayer() && ent.IsTitan() && damageInfo.GetInflictor() )
	{
		local punchAmount = CalcTitanViewPunch( ent, damageInfo )
		ent.ViewPunch( damageInfo.GetInflictor().GetWorldSpaceCenter(), punchAmount, 0.0, 0.0 )
	}

	attacker.NotifyDidDamage( ent, damageInfo.GetHitBox(), damageInfo.GetDamagePosition(), customDamageType, damageInfo.GetDamage(), damageInfo.GetDamageFlags(), damageInfo.GetHitGroup(), damageInfo.GetWeapon(), damageInfo.GetDistFromAttackOrigin() )
}


function UpdateLastDamageTime( ent )
{
	if ( !( "lastDamageTime" in ent.s ) )
		ent.s.lastDamageTime <- 0
	ent.s.lastDamageTime = Time()
}


function UpdateAttackerInfo( ent, attacker, damage )
{
	local attackerPlayer = GetPlayerFromEntity( attacker )
	if ( !attackerPlayer )
		return

	// cannot be your own last attacker
	if ( attackerPlayer == ent )
		return

	if ( !damage || damage <= 0 )
		return

	if ( !("attackerInfo" in ent.s) )
		ent.s.attackerInfo <- {}
	else if ( ent.GetHealth() == ent.GetMaxHealth() )
		ent.s.attackerInfo.clear()

	if ( !(attackerPlayer.weakref() in ent.s.attackerInfo ) )
		ent.s.attackerInfo[attackerPlayer.weakref()] <- 0

	ent.s.attackerInfo[attackerPlayer.weakref()] += damage

	if ( !("lastAttacker" in ent.s) )
		ent.s.lastAttacker <- null

	ent.s.lastAttacker = attackerPlayer
}


function AIReportKill( entity, attacker )
{
	if ( entity.IsTitan() )
	{
		if ( entity.IsPlayer() )
		{
			thread ReportDeath( "ally_eject_fail", entity.GetTeam(), entity.GetOrigin() )
		}
		else
		{
			thread ReportDeath( "ally_titan_down", entity.GetTeam(), entity.GetOrigin() )
		}

		if ( attacker.IsSpectre() )
		{
			thread SpectreReportDeath( "spectre_gs_gruntkillstitan_02_1", attacker )
			return
		}

		if ( attacker.IsSoldier() )
		{
			// saw a titan die
			thread ReportDeathAI( "aichat_killed_enemy_titan", attacker )
		}
		else
		{
			// saw a titan die
			thread ReportDeath( "aichat_death_enemy_titan", attacker.GetTeam(), entity.GetOrigin() )
		}

		return
	}

	if ( entity.IsSpectre() )
	{
		local squadName = entity.Get( "squadname" )
		if ( squadName != "" )
		{
			local squad = GetNPCArrayBySquad( squadName )
			if ( squad.len() == 1 )
			{
				thread SpectreReportDeath( "spectre_gs_squaddeplete_01_1", squad[ 0 ]  )
			}
			else if ( squad.len() > 0  )
			{
				local reportingSpectre = squad[ RandomInt( 0, squad.len() ) ]
				thread SpectreReportDeath( "spectre_gs_allygrundown_05_1", reportingSpectre )
			}
		}

		return

	}

	if ( entity.IsSoldier() )
	{
		local squadName = entity.Get( "squadname" )
		if ( squadName != "" )
		{
			local squad = GetNPCArrayBySquad( squadName )
			if ( squad.len() == 1 )
			{
				// remaining guy freaks out
				PlaySquadConversationToAll( "aichat_squad_deplete", squad[0] )
			}
		}

		thread ReportDeath( "aichat_death_friendly_grunt", entity.GetTeam(), entity.GetOrigin() )

		if ( attacker.IsSoldier() )
		{
			thread ReportDeathAI( "killed_enemy_grunt", attacker )
		}

		return
	}

	if ( entity.IsPlayer() )
	{
		thread ReportDeath( "ally_pilot_down", entity.GetTeam(), entity.GetOrigin() )
		return
	}
}


function GetAttackerPlayerOrBossPlayer( attacker )
{
	if ( !IsValid( attacker ) )
		return null
	if ( attacker.IsPlayer() )
		return attacker

	// maybe my boss is a player?
	local bossPlayer = attacker.GetBossPlayer()
	if ( !IsValid( bossPlayer ) )
		return null
	if ( bossPlayer.IsPlayer() )
		return bossPlayer

	return null
}

function GetAttackerOrLastAttacker( entity, damageInfo )
{
	local attacker = damageInfo.GetAttacker()

	if ( !IsValid( attacker ) )
	{
		if ( !( "lastAttacker" in entity.s ) )
			return null

		if ( !IsValid( entity.s.lastAttacker ) )
			return null

		return entity.s.lastAttacker
	}

	if ( attacker == entity )
	{
		// suicide
		if ( GetLastAttacker( entity ) )
			return GetLastAttacker( entity )

		local attackerInfo = GetLatestAssistingPlayerInfo( entity )
		if ( attackerInfo.player != null )
			attacker = attackerInfo.player
	}

	if ( !attacker.IsPlayer() && !attacker.IsNPC() )
	{
		if ( GetLastAttacker( entity ) )
			return GetLastAttacker( entity )

		return attacker
	}

	return attacker
}


function GetLastAttacker( entity )
{
	if ( entity.IsTitan() && IsValid( entity.GetTitanSoul() ) ) // JFS: second check is defensive
	{
		local soul = entity.GetTitanSoul()
		if ( soul.lastAttackInfo && "attacker" in soul.lastAttackInfo && IsValid( soul.lastAttackInfo.attacker ) )
			return soul.lastAttackInfo.attacker
	}

	if ( !( "lastAttacker" in entity.s ) )
		return null

	if ( !IsValid( entity.s.lastAttacker ) )
		return null

	return entity.s.lastAttacker
}


function PlayerOrNPCKilledByEnemy( entity, damageInfo )
{
	ReportDevStat_Death( entity, damageInfo )

	local attacker = GetAttackerOrLastAttacker( entity, damageInfo )
	if ( !IsValid( attacker ) )
		return false

	local gameState = GetGameState() // save this off in case it changes during scoring


	Assert( IsValid( attacker ) )

	if ( entity.IsPlayer() )
	{
		LogPlayerMatchStat_Death( entity )

		if ( attacker.IsPlayer() && (attacker != entity) )
			LogPlayerMatchStat_KilledAPilot( attacker )
	}

	if ( entity.IsNPC() && !IsValidNPCTarget( entity ) )
		return

	attacker.Signal( "OnKilledEnemy" )

	if ( !attacker.IsPlayer() )
	{
		local newAttacker = GetPlayerFromEntity( attacker )
		if ( IsValid( newAttacker ) )
			attacker = newAttacker
	}

	AIReportKill( entity, attacker )

	if ( entity.IsTitan() )
	{
		if ( IsValid( entity.GetTitanSoul() ) )
		{
			local lastOwner = entity.GetTitanSoul().lastOwner;

			if ( !ShouldPreventFriendlyFire( entity, attacker ) )
			{
				if ( IsValid(lastOwner) && lastOwner.IsPlayer() )
				{
					lastOwner.SetTitanDeployed( false )
					StartTitanBuildProgress( lastOwner )
					//TitanCustomRule_Update(player, 0)
				}
			}
		}
	}


	// AddCallback_PlayerOrNPCKilled
	foreach ( callbackInfo in level.onPlayerOrNPCKilledCallbacks )
	{
		callbackInfo.func.acall( [callbackInfo.scope, entity, attacker, damageInfo] )
	}

	local damageSourceID = damageInfo.GetDamageSourceIdentifier()
	if ( entity.IsTitan() )
	{
		thread TitanVO_DelayedTitanDown( entity )
	}

	if ( !attacker.IsPlayer() )
	{
		// This gets the last player that did damage to the entity so that we can give him the kill
		local attackerInfo = GetLatestAssistingPlayerInfo( entity )
		attacker = attackerInfo.player

		if ( !attacker )
		{
			if ( entity.IsTitan() )
				printt( "Titan " + entity + " out of bounds?" )

			return true
		}

		// Hack - attacker history isn't on client to calculate if a player should get credit for a kill when AI steals the final killing shot while a player is damaging them.
		local playerArray = GetPlayerArray()
		foreach ( player in playerArray )
		{
			Remote.CallFunction_Replay( player, "ServerCallback_SetAssistInformation", attackerInfo.damageSourceId, attacker.GetEncodedEHandle(), entity.GetEncodedEHandle(), attackerInfo.assistTime )
		}
	}

	if ( entity.IsPlayer() && attacker.IsPlayer() )
	{
		if ( entity.GetPersistentVar( "respawnKillInfected" ) && !attacker.GetPersistentVar( "respawnKillInfected" ) )
			attacker.SetPersistentVar( "respawnKillInfected", true )
	}

	// ???: Why are we running score related functions before checking for friendly fire? Answer: Because they all check team internally
	if ( entity.IsPlayer() || (entity.IsTitan() && GAMETYPE == TITAN_BRAWL_AUTO) )
	{
		ScoreEvent_PlayerKilled( entity, attacker, damageInfo )
	}
	else if ( entity.IsTitan() && entity.IsNPC() && GAMETYPE != TITAN_BRAWL_AUTO )
	{
		if ( !entity.GetDoomedState() )
			ScoreEvent_TitanKilled( entity, attacker, damageInfo.GetInflictor(), damageSourceID, _GetWeaponNameFromDamageInfo( damageInfo ), damageInfo.GetCustomDamageType() )
	}
	else
	{
		ScoreEvent_NPCKilled( entity, attacker, damageInfo )
	}

	if ( ShouldPreventFriendlyFire( entity, attacker ) )
	{
		return false
	}

	if ( !GamePlayingOrSuddenDeath() )
		return true

	if ( entity.IsPlayer() ) //Should fix this: You don't get klll credit on the scoreboard for Pilot kills after eGameState.Playing/SuddenDeath, but if the player was killed as a Titan you get Titan score credit on the scoreboard. Intent is that neither of them get scoreboard credit.
	{
		attacker.SetKillCount( attacker.GetKillCount() + 1 )
	}
	else
	{
		if( !entity.IsMarvin() && !entity.IsTitan() )
			attacker.SetNPCKillCount( attacker.GetNPCKillCount() + 1 )
	}

	return true
}

// used to calculate build time credit in special casees. Cloak Drones and Suicide Spectres use it for now.
function CalculateBuildTimeCredit( attacker, target, damage, health, maxHealth, playlistVarStr, defaultCredit )
{
	local titanSpawnDelay = GetTitanBuildTime( attacker )
	local timerCredit = 0

	health = max( 0, health )	// health should never be less then 0
	if ( titanSpawnDelay && IsAlive( target ) )
	{
		timerCredit = GetCurrentPlaylistVarFloat( playlistVarStr, defaultCredit )

		local dealtDamage = min( health, damage )
		timerCredit = timerCredit * (dealtDamage / maxHealth.tofloat())
	}

	return timerCredit
}


g_deathMode <- OBS_MODE_DEATHCAM

function PostDeathThread( player, damageInfo )
{
	local timeOfDeath = Time()
	player.s.postDeathThreadStartTime = Time()

	if ( IsFirstToDieAfterWaveSpawn( player, timeOfDeath ) )
	{
		switch( GetWaveSpawnType() )
		{
			case eWaveSpawnType.FIXED_INTERVAL:
				local cycles = Time() / WAVE_SPAWN_INTERVAL
				local nextWaveSpawnTime = ( cycles.tointeger() + 1 ) * WAVE_SPAWN_INTERVAL
				SetWaveSpawnTime( player.GetTeam(), nextWaveSpawnTime )
				break
			case eWaveSpawnType.PLAYER_DEATH:
				SetWaveSpawnTime( player.GetTeam(), timeOfDeath + WAVE_SPAWN_INTERVAL )
				break
			case eWaveSpawnType.MANUAL:
			default:
				break
		}

		if ( level.waveSpawnByDropship == true )
			thread CreateWaveSpawnDropship( player.GetTeam() )
	}

	Assert( IsValid( player ), "Not a valid player" )
	player.EndSignal( "Disconnected" )
	player.EndSignal( "OnDestroy" )
	player.EndSignal( "OnRespawned" )

	player.s.deathOrigin = player.GetOrigin()
	player.s.deathAngles = player.GetAngles()

	player.s.inPostDeath = true
	player.s.respawnSelectionDone = false

	player.cloakedForever = false
	player.stimmedForever = false
	player.SetNoTarget( false )
	player.SetNoTargetSmartAmmo( false )
	player.ClearExtraWeaponMods()

	OnThreadEnd( function() : ( player )
				{
					if ( !IsValid( player ) )
						return

					player.s.inPostDeath = false
					player.SetPredictionEnabled( true )
				}
	)

	local attacker = damageInfo.GetAttacker()
	local methodOfDeath = damageInfo.GetDamageSourceIdentifier()
	local attackerViewIndex = attacker.GetIndexForEntity()

	local timeSinceAttackerSpawned = attacker.GetTimeSinceSpawning()

	player.SetPredictionEnabled( false )
	player.Signal( "RodeoOver" )
	player.ClearParent()
	player.StartObserverMode( g_deathMode )

	if ( ShouldSetObserverTarget( attacker ) )
		player.SetObserverTarget( attacker )
	else
		player.SetObserverTarget( null )

	local replayTime = CalculateLengthOfKillReplay( player, methodOfDeath )
	player.watchingKillreplayEndTime = Time() + replayTime

	local shouldDoReplay = ShouldDoReplay( player, attacker, replayTime )

	local replayTracker = {}
	replayTracker.validTime <- null
	if ( shouldDoReplay )
	{
		// tracks if we need to cut off the replay early due to attacker becoming invalid
		thread TrackDestroyTimeForReplay( attacker, replayTracker )
	}

	player.s.wantsRespawn = false

	local damageSource = damageInfo.GetDamageSourceIdentifier()

	if ( damageSource == eDamageSourceId.fall || ( damageSource == eDamageSourceId.submerged && GetMapName() == "mp_sandtrap" ) ) //HACK special casing mp_sandtrap here, different functionality was desired
	{
		local viewOrigin
		local viewAngles

		viewOrigin = player.GetOrigin()
		viewAngles = (player.GetVelocity() * -1).GetAngles()

		player.SetObserverModeStaticPosition( viewOrigin )
		player.SetObserverModeStaticAngles( viewAngles )

		player.StartObserverMode( OBS_MODE_STATIC_LOCKED )
		player.SetObserverTarget( null )
	}
	else
	{
	 	if ( PlayerMustRevive( player )	)
	 	{
	 		wait REVIVE_DEATH_TIME
	 		player.SetPredictionEnabled( true )
			thread PlayerRevivesOrBleedsOut( player )
			return
	 	}
	}

	wait 0.1 // give the gamestate a chance to change if it's going to
	if ( player.IsBot() )
	{
		wait 1.0
	}
	else
	{
		waitthread WaitForKillReplayOrTimeExpires( player, attackerViewIndex, timeSinceAttackerSpawned, timeOfDeath, shouldDoReplay )
	}

	// recalculate this time in case the gamestate changed
	player.watchingKillreplayEndTime = Time() + CalculateLengthOfKillReplay( player, methodOfDeath )

	local beforeTime = GetKillReplayBeforeTime( player, methodOfDeath )

	// killreplay kill replay / 빅브라더패널 폭파로 인한 사망시 리플레이 안함.
	if ( !player.s.wantsRespawn )
	{
		if ( Replay_IsEnabled() && shouldDoReplay )
		{
			local startKillReplayTime = Time()
			waitthread PlayerWatchesKillReplay( player, attacker, attackerViewIndex, timeSinceAttackerSpawned, timeOfDeath, beforeTime, replayTracker, true)
			local killReplayTimePassed = Time() - startKillReplayTime
			local forcedKillReplayTimeRemaining = RESPAWN_BUTTON_BUFFER - killReplayTimePassed
			if ( forcedKillReplayTimeRemaining > 0 )
				wait forcedKillReplayTimeRemaining

			if ( IsValid( player ) )
			{
				// moved outside PlayerWatchesKillReplay because time can pass between onthreadend and resumption of following thread.
				player.ClearReplayDelay()
				player.ClearViewEntity()
			}
		}

		thread ScreenFadeIfNecessary( player )
	}

	// dont have a way to end signal on player going from disconnected to gone
	if ( !IsValid( player ) )
		return


	// standard delay to this point is ~7.5 seconds
	WaitForRespawnDelay( player, timeOfDeath )

	// dont have a way to end signal on player going from disconnected to gone
	if ( !IsValid( player ) )
		return

	player.SetPredictionEnabled( true )

	// things like wave based spawning can respawn the player before this thread is done
	if ( IsAlive( player ) )
		return

	if ( player.isSpawning )
		return

	player.BecomeRagdoll(Vector(0, 0, 0))

	local rematchOrigin
	local cardIndex = GetPlayerBurnCardOnDeckIndex( player )
	local cardRef = player.GetPersistentVar( _GetActiveBurnCardsPersDataPrefix() + "[" + cardIndex + "].cardRef" )
	if (cardRef == "bc_rematch")
	{
		if ( IsValid( attacker ) && methodOfDeath == eDamageSourceId.titan_execution )
			rematchOrigin = attacker.GetOrigin()
		else
			rematchOrigin = player.GetOrigin()

		if(IsValid(player)) {
			// don't bother showing message if you killed yourself
			if( attacker != player && attacker.IsPlayer() )
				MessageToPlayer( attacker, eEventNotifications.BurnCardRematch, player, null )
		}
	}


	if( player.IsBot() && GetConVarBool( "bot_kick_on_death" ) )
	{
		wait 5.0
		// 봇은 죽으면 kick
		local kickCmd = "kick " + player.GetPlayerName()
		ServerCommand( kickCmd )
	}
	else
	{
		DecideRespawnPlayer( player, rematchOrigin )
	}
}

function ShouldSetObserverTarget( attacker )
{
	if ( !IsAlive( attacker ) )
		return false

   	if ( IsPlayer( attacker ) && attacker.IsObserver() )
   		return false

    return true
}

function WaitForRespawnDelay( player, timeOfDeath )
{
	if ( ShouldWaitForNextWaveSpawn( player ) )
	{
		local team = player.GetTeam()
		local waveSpawnTime = level.waveSpawnTime[ team ]
		local respawnDelay = waveSpawnTime - Time()

		if ( !IsPlayerEliminated( player ) )
			MessageToPlayer( player, eEventNotifications.YouWillRespawnIn, null, Time() + respawnDelay )

		// no spectating if the wait time is less then 3 seconds.
		if ( respawnDelay < 3 )
			wait respawnDelay
	}
	else if ( GetPilotRespawnDelay( player ) > 3.0 )
	{
		// this is the old stuff. not quite sure how to combine them in a good way.

		local respawnDelay = GetPilotRespawnDelay( player )
		local waitedTime = Time() - timeOfDeath

		if ( waitedTime < respawnDelay )
		{
			if ( !IsPlayerEliminated( player ) )
				MessageToPlayer( player, eEventNotifications.YouWillRespawnIn, null, Time() + (respawnDelay - waitedTime) )
			printt( "waiting", respawnDelay - waitedTime )
			wait respawnDelay - waitedTime
		}
	}
}

// TODO: replace level.pilotRespawnDelay with a better setup
function GetPilotRespawnDelay( player )
{
	if ( level.pilotRespawnDelay )
		return level.pilotRespawnDelay
	else
		return GetCurrentPlaylistVarFloat( "respawn_delay", 0 )
}


function IsFirstToDieAfterWaveSpawn( player, timeOfDeath )
{
	local team = player.GetTeam()
	local waveSpawnTime = level.waveSpawnTime[ team ]

	if ( GetWaveSpawnType() == eWaveSpawnType.DISABLED )
		return false

	// don't do wave spawning if we are not playing
	if ( !GamePlayingOrSuddenDeath() )
		return false

	// are we within the grace period of a last wave spawn
	if ( Time() < waveSpawnTime + WAVE_SPAWN_GRACE_PERIOD )
	{
		// printt( "we where within the grace period of a wave spawn" )
		return false
	}

	if ( timeOfDeath > waveSpawnTime )
		return true

	return false
}

function WaitForKillReplayOrTimeExpires( player, attackerViewIndex, timeSinceAttackerSpawned, timeOfDeath, shouldDoReplay )
{
	local waitTime = GetDeathCamTime( player ) - 0.4
	wait 0.3 // button press debounce

	if ( waitTime > 0 )
		wait waitTime

	if ( !shouldDoReplay )
		waitthread PlayerWatchesDeathCam( player, attackerViewIndex, timeSinceAttackerSpawned, timeOfDeath )
}

function ScreenFadeIfNecessary( player )
{
	//Note: Think this is no longer necessary because all the screen fades are handled elsewhere. Look to removing this for R2. - Chin
	player.EndSignal( "Disconnected" )
	player.EndSignal( "OnDestroy" )

	local gameState = GetGameState()
	local doFade = false

	if ( IsSwitchSidesBased() && gameState == eGameState.SwitchingSides )
		doFade = true

	if ( IsRoundBased() )
	{
		if ( gameState == eGameState.WinnerDetermined && ShouldClearPlayersInWinnerDetermined() ) //Don't let players see ClearPlayers() happening and players getting killed
			doFade = true

		if ( gameState == eGameState.SwitchingSides )
			doFade = true
	}

	if ( !doFade )
		return

	// the first ones fail.. I don't know why.
	ScreenFade( player, 0, 1, 1, 255, 0.5, 1.0, 0x0002 | 0x0008 )
	wait 0

	if ( GetGameState() < eGameState.Playing )
		return

	ScreenFade( player, 1, 0, 1, 255, 0.5, 1.0, 0x0002 | 0x0008 )
	wait 0

	if ( GetGameState() <= eGameState.SuddenDeath )
		return

	ScreenFade( player, 1, 1, 1, 255, 0.5, 1.0, 0x0002 | 0x0008 )
}

function CalculateLengthOfKillReplay( player, methodOfDeath ) //Meant to be called on the same frame player dies
{
	return GetDeathCamTime( player ) + GetKillReplayBeforeTime( player, methodOfDeath ) + GetKillReplayAfterTime( player )
}

function GetKillReplayBeforeTime( player, methodOfDeath )
{
	if ( !GamePlayingOrSuddenDeath() )
	{
		return KILL_REPLAY_LENGTH_SHORT
	}

	local titanKillReplayTime = KILL_REPLAY_TITAN_REPLAY_LENGTH
	local pilotKillReplayTime = KILL_REPLAY_PILOT_REPLAY_LENGTH

	switch ( methodOfDeath )
	{
		case eDamageSourceId.titan_execution:
			return titanKillReplayTime + 3.0

		case eDamageSourceId.switchback_trap:
			if ( player.IsTitan() )
				return titanKillReplayTime + 6.0
			else
				return pilotKillReplayTime + 8.0
	}


	if ( player.IsTitan() )
		return titanKillReplayTime

	// titan recently?
	if ( Time() - player.lastTitanTime < 5.0 )
		return titanKillReplayTime

	return pilotKillReplayTime
}


function TrackDestroyTimeForReplay( attacker, replayTracker )
{
	local startTime = Time()
	// tracks the time until the attacker becomes invalid
	EndSignal( replayTracker, "OnDestroy" )

	OnThreadEnd(
		function () : ( replayTracker, startTime )
		{
			replayTracker.validTime = Time() - startTime
		}
	)

	local signal
	if ( attacker.IsPlayer() )
		signal = "Disconnected"
	else
		signal = "OnDestroy"

	if ( IsAlive( attacker ) )
		attacker.WaitSignal( signal )
	else
		WaitSignalOnDeadEnt( attacker, signal )
}

function PlayerWatchesDeathCam( player, attackerViewIndex, timeSinceAttackerSpawned, timeOfDeath )
{
	player.EndSignal( "RespawnMe" )
	local timeBeforeKill = 3.0
	local timeAfterKill = 3.0

	if ( timeBeforeKill > timeSinceAttackerSpawned )
		timeBeforeKill = timeSinceAttackerSpawned

	local viewPoint = FindViewPoint( player )
	if ( viewPoint && GetGameState() != eGameState.Epilogue )
	{
		player.SetObserverModeStaticPosition( viewPoint.GetOrigin() )
		player.SetObserverModeStaticAngles( viewPoint.GetAngles() )
	}


	local replayDelay = timeBeforeKill + ( Time() - timeOfDeath )
	wait timeBeforeKill + timeAfterKill
}

function PlayerWatchesKillReplay( player, attacker, attackerViewIndex, timeSinceAttackerSpawned, timeOfDeath, beforeTime, replayTracker, checkMinTime)
{
	OnThreadEnd(
		function () : ( player, replayTracker )
		{
			Signal( replayTracker, "OnDestroy" )
		}
	)

	player.EndSignal( "RespawnMe" )

	player.s.timeBeforeKill = beforeTime
	local timeAfterKill = GetKillReplayAfterTime( player )

	if ( player.s.timeBeforeKill > timeSinceAttackerSpawned )
		player.s.timeBeforeKill = timeSinceAttackerSpawned

	player.SetViewIndex( attackerViewIndex )
	local replayDelay = player.s.timeBeforeKill + ( Time() - timeOfDeath )
	if ( replayDelay < 0 )
		return

	player.SetKillReplayDelay(replayDelay, checkMinTime)

	wait player.s.timeBeforeKill

	if (player.s.addTimeBeforeKill)
	{
		local addTime = player.s.addTimeBeforeKill
		player.s.addTimeBeforeKill = 0
		wait addTime
	}

	if ( replayTracker.validTime != null && replayTracker.validTime < timeAfterKill )
	{
		local waitTime = replayTracker.validTime - 0.1 // cut off just before ent becomes invalid in the past
		if ( waitTime > 0 )
			wait waitTime
	}
	else
	{
		wait timeAfterKill
	}
}

function ClientCommand_SelectRespawn( player, index = null )
{
	if ( IsAlive( player ) )
		return true

	if ( index == null )
		return true

	local index = index.tointeger()
	local previousSpawnClass = player.IsSpawnAsTitan()

	switch ( index )
	{
		case 1:
			player.SetSpawnAsTitan( true )
			break
		case 2:
			player.SetSpawnAsTitan( false )
			break
	}

	if ( player.IsSpawnAsTitan() != previousSpawnClass )
		player.Signal( "SpawnClassChanged" )

	return true
}

function ClientCommand_RespawnPlayer( player, opParm )
{
	if ( IsAlive( player ) )
		return true

	if ( opParm.find( "burncard" ) != null )
	{
		//local burnCard = opParm.tointeger()
		//SetPlayerBurnCardSlotToActivate( player, burnCard )
		return true
	}

	local previousSpawnClass = player.IsSpawnAsTitan()
	if ( opParm == "Titan" )
	{
		player.SetSpawnAsTitan( true )
	}
	else if ( opParm == "Pilot" )
	{
		player.SetSpawnAsTitan( false )
	}

	if ( player.IsSpawnAsTitan() != previousSpawnClass )
		player.Signal( "SpawnClassChanged" )

	local deathTime = GetRespawnButtonCamTime( player ) - 0.1
	if ( Time() > player.s.postDeathThreadStartTime + deathTime )
	{
		player.s.respawnSelectionDone = true
		player.Signal( "RespawnMe" )
	}

	return true
}



function CodeCallback_OnPlayerKilled( player, damageInfo )
{
	Remote.CallFunction_NonReplay( player, "ServerCallback_YouDied" )

	// Nexon clears the objective when doing this because they used the objective system
	// To show people how to deploy their titan etc
	// We dont use any of that, so getting rid of this

	// [LJS] hud 에 탈출 알람 or 타이탄 알람 삭제.
	//ClearPlayerActiveObjective( player )

	local team = player.GetTeam()
	Assert( player.GetTeam() > TEAM_SPECTATOR )
	GameTeams.lastTeamKilled = team

	local damageSourceId = damageInfo.GetDamageSourceIdentifier()

	if ( player.IsTitan() )
	{
		if ( !player.GetDoomedState() )
		{
			// Added via AddCallback_OnTitanDoomed
			foreach ( callbackInfo in level.onTitanDoomedCallbacks )
			{
				callbackInfo.func.acall( [callbackInfo.scope, player, damageInfo] )
			}
		}
	}
	else
	{
		if ( damageSourceId != eDamageSourceId.round_end )
			CreateNoSpawnArea(GetOtherTeam(player.GetTeam()), player.GetOrigin(), DEATHCAM_TIME + 0.5, 256 )
	}

	if ( ShouldPlayerBeEliminated( player ) )
		SetPlayerEliminated( player )

	local attacker = damageInfo.GetAttacker()
	TitanVO_AlertTitansIfTargetWasKilled( player, attacker )

	if ( HasSoul( player ) )
		thread SoulDies( player.GetTitanSoul() )

	if ( PlayerHasPassive( player, PAS_DEAD_MANS_TRIGGER ) )
		DetonateAllPlantedExplosives( player )

	if ( damageSourceId != eDamageSourceId.round_end )
	{
		// Don't give players scoreboard deaths after the match is over
		if ( GamePlayingOrSuddenDeath() )
			player.SetDeathCount( player.GetDeathCount() + 1 )

		if ( PlayerOrNPCKilledByEnemy( player, damageInfo ) )
		{
			player.s.lastDeathTime = Time()
			// killed by an enemy
			if ( IsAlive( attacker ) )
			{
				// I killed him!
				thread AIChat_KilledPilot( attacker )
			}
		}
	}

	thread PostDeathThread( player, damageInfo )

	player.OnDeathAsClass( damageInfo )

	level.ent.Signal( "PlayerKilled" )

	if ( damageSourceId == eDamageSourceId.titan_fall )
		PlayDeathFromTitanFallSounds( player )

	// Added via AddCallback_OnPlayerKilled
	foreach ( callbackInfo in level.onPlayerKilledCallbacks )
	{
		callbackInfo.func.acall( [callbackInfo.scope, player, damageInfo] )
	}
}

function CodeCallback_OnWeaponAttack(player,weapon,weaponName,ammoUsed) {
	foreach ( callbackFunc in level.onWeaponAttackCallbacks )
	{
		callbackFunc.func.acall( [callbackFunc.scope, player, weapon, weaponName, ammoUsed ] )
	}
}

function ShouldPlayerBeEliminated( player )
{
	if ( IsPilotEliminationBased() )
	{
		local shouldPlayerBeEliminatedFuncTable = level.shouldPlayerBeEliminatedFuncTable
		if ( shouldPlayerBeEliminatedFuncTable != null )
			return shouldPlayerBeEliminatedFuncTable.func.acall( [shouldPlayerBeEliminatedFuncTable.scope, player] )

		if ( player.s.respawnCount )
			return true

		if ( GameTime.PlayingTime() >= ELIM_FIRST_SPAWN_GRACE_PERIOD )
			return true
	}

	return false
}

function AIChatter( alias, team, origin )
{
	local ai = GetNearbyFriendlyAI( origin, team )

	if ( ai.len() > 0 )
	{
		PlaySquadConversationToAll( alias, ai[0] )
	}
}

function ReportDeath( alias, team, origin )
{
	wait DEATH_CHAT_DELAY
	local ai = GetNearbyFriendlyAI( origin, team )

	foreach ( guy in ai )
	{
		if ( IsAlive( guy ) )
		{
			PlaySquadConversationToAll( alias, guy )
			return
		}
	}
}

function ReportDeathAI( alias, guy )
{
	wait DEATH_CHAT_DELAY

	if ( IsAlive( guy ) )
	{
		PlaySquadConversationToAll( alias, guy )
	}
}

function AIChat_KilledPilot( attacker )
{
	wait DEATH_CHAT_DELAY
	if ( !IsAlive( attacker ) )
		return

	if ( attacker.IsSoldier() )
		PlaySquadConversationToAll( "aichat_killed_pilot", attacker )
	else if ( attacker.IsSpectre() )
		PlaySpectreChatterToAll( "spectre_gs_killenemypilot_01_1" , attacker )
}

function SpectreReportDeath( alias, spectre )
{
	wait DEATH_CHAT_DELAY
	if ( !IsAlive( spectre ) )
		return

	PlaySpectreChatterToAll( alias, spectre )
}

function PlayerShouldObserve( player, alreadyObserving = false )
{
	if ( ShouldWaitForNextWaveSpawn( player, alreadyObserving ) )
		return true

	if ( IsPlayerEliminated( player ) )
		return true

	if ( GetGameState() > eGameState.Epilogue )
		return true

	if ( Flag( "CinematicEnding" ) )
		return true

	local respawn_delay = GetCurrentPlaylistVarInt("riff_respawn_delay", 0)

	// 첫번째 스폰이후에는 riff_respawn_delay 시간만큼 delay후에 리스폰하도록 한다.
	if (player.s.respawnCount > 0 && (Time() - player.s.postDeathThreadStartTime) < respawn_delay)
		return true

	//if ( IsRoundBased() && GetGameState() > eGameState.SuddenDeath  ) //TODO: Should make this work again so you don't spawn after a round has been won. Probably need to do a check on RoundScoreLimit_Complete, since we need to spawn in epilogue.
	//	return true

	return false
}

function ShouldWaitForNextWaveSpawn( player, alreadyObserving = false )
{
	Assert( player.IsPlayer() )

	if ( GetWaveSpawnType() == eWaveSpawnType.DISABLED )
		return false

	// don't do wave spawning if we are not playing
	if ( !GamePlayingOrSuddenDeath() )
		return false

	// don't do wave spawn at the start of the match
	if ( GameTime.PlayingTime() < START_SPAWN_GRACE_PERIOD )
		return false

	local team = player.GetTeam()
	local waveSpawnTime = level.waveSpawnTime[ team ]

	// if time is past the end of the wave spawn there is nothing to wait for.
	if ( Time() > waveSpawnTime )
		return false

	if ( !ShouldSpawnAsTitan( player ) )
	{
		if ( level.waveSpawnByDropship == true && alreadyObserving == true && player.s.respawnSelectionDone == true )
		{
			local dropshipSpawnTime = waveSpawnTime - GetWaveSpawnWindowTimeDropshipSpawn()
			local dropshipGoneTime = waveSpawnTime - GetWaveSpawnWindowTimeDropshipGone()

			// if we are within the window where the player can enter a dropship return false
			if ( Time() > dropshipSpawnTime && Time() < dropshipGoneTime && WaveDropshipSpawnIsJoinable( team ) )
				return false
		}
	}
	else if ( player.s.respawnSelectionDone == true )
	{
		// if we selected to spawn as a titan stop observing and spawn immediately.
		return false
	}

	return true
}

function GetWaveSpawnWindowTimeDropshipGone()
{
	return 3.0 // if there is more then 3 seconds left before the wavespawn is over it's still not too late to get added to the dropship
}

function GetWaveSpawnWindowTimeDropshipSpawn()
{
	local customAnim = GetWaveSpawnCustomDropshipAnim()
	if ( customAnim )
		return GetAnimEventTime( DROPSHIP_MODEL, customAnim, "dropship_deploy" ) //basically as long as your before the deploying notetrack - it's still a good time respawn
	else
		return 9.0 // rough time the dropship drop off takes
}

function GetWaveSpawnCustomDropshipAnim()
{
	return level.waveSpawnCustomDropshipAnim
}

function SetWaveSpawnCustomDropshipAnim( anim )
{
	level.waveSpawnCustomDropshipAnim = anim
}

function GetWaveSpawnCustomPlayerRideAnimIdle( index )
{
	if ( index in level.waveSpawnCustomPlayerIdleAnim )
		return level.waveSpawnCustomPlayerIdleAnim[ index ]
	return null
}

function AddWaveSpawnCustomPlayerRideAnimIdle( idleAnims )
{
	level.waveSpawnCustomPlayerIdleAnim.append( idleAnims )
}

function GetWaveSpawnCustomPlayerRideAnimJump( index )
{
	if ( index in level.waveSpawnCustomPlayerJumpAnim )
		return level.waveSpawnCustomPlayerJumpAnim[ index ]
	return null
}

function AddWaveSpawnCustomPlayerRideAnimJump( jumpAnims )
{
	level.waveSpawnCustomPlayerJumpAnim.append( jumpAnims )
}

function GetWaveSpawnCustomSpawnPoints( team )
{
	return level.waveSpawnCustomSpawnPoints[ team ]
}

function AddWaveSpawnCustomSpawnPoint( team, origin, angles )
{
	local spawnPoint = CreateScriptRef( origin, angles )
	level.waveSpawnCustomSpawnPoints[ team ].append( spawnPoint )
}

function PlayerCanWaveSpawn( player )
{
	if ( !GetClassicMPMode() )
		return false

	if ( ShouldSpawnAsTitan( player ) )
		return false

	if ( GetWaveSpawnType() == eWaveSpawnType.DISABLED )
		return false

	// don't do wave spawning if we are not playing
	if ( !GamePlayingOrSuddenDeath() )
		return false

	// don't do wave spawn at the start of the match
	if ( GameTime.PlayingTime() < START_SPAWN_GRACE_PERIOD )
		return false

	// if it's to late to join in progress we shouldn't wave spawn by dropship
	local team = player.GetTeam()
	local lastJoinInProgressTime = level.waveSpawnTime[ team ] - GetWaveSpawnWindowTimeDropshipGone()
	if ( Time() >= lastJoinInProgressTime )
		return false

	return level.waveSpawnByDropship
}

function EnableWaveSpawnByDropship( bool )
{
	level.waveSpawnByDropship = bool
}

function SetWaveSpawnTime( team, spawnTime )
{
	Assert( team == TEAM_IMC || team == TEAM_MILITIA )

	if ( spawnTime != level.waveSpawnTime[ team ] )
	{
		level.waveSpawnTime[ team ] = spawnTime
	}
}

function ForceWaveSpawn( team )
{
	Assert( team == TEAM_IMC || team == TEAM_MILITIA )

	local playerArray = GetPlayerArrayOfTeam( team )
	foreach( player in playerArray )
	{
		if ( IsValid( player ) && !IsAlive( player ) )
			MessageToPlayer( player, eEventNotifications.Clear )
	}

	level.waveSpawnTime[ team ] = Time()
}

function EnsureSafeSpawnRetryTokens( player )
{
	if ( !( "safeSpawnRetryToken" in player.s ) )
		player.s.safeSpawnRetryToken <- null
	if ( !( "titanSpawnRetryToken" in player.s ) )
		player.s.titanSpawnRetryToken <- null
}


function PlayerOwnsSpawnRetryToken( player, token )
{
	if ( !IsValid( player ) || token == null )
		return false

	EnsureSafeSpawnRetryTokens( player )
	return player.s.safeSpawnRetryToken == token || player.s.titanSpawnRetryToken == token
}


function PlayerHasSpawnRetryReservation( player )
{
	EnsureSafeSpawnRetryTokens( player )
	return player.s.safeSpawnRetryToken != null || player.s.titanSpawnRetryToken != null
}


function SpawnRetryGameStateIsValid()
{
	switch ( GetGameState() )
	{
		case eGameState.WaitingForPlayers:
		case eGameState.PickLoadout:
		case eGameState.Prematch:
		case eGameState.Playing:
		case eGameState.SuddenDeath:
			return true
	}

	return false
}


function DeadPlayerSpawnRetryLifecycleIsValid( player )
{
	if ( !IsValid( player ) || !player.hasConnected || IsAlive( player ) )
		return false

	if ( !SpawnRetryGameStateIsValid() )
		return false

	return !PlayerShouldObserve( player ) && !IsPlayerInCinematic( player )
}

function DeadPlayerCanResumeSpawnDispatch( player )
{
	return IsValid( player )
		&& player.hasConnected
		&& !IsAlive( player )
		&& SpawnRetryGameStateIsValid()
}


function CreateSpawnRetryRequest( player )
{
	return {
		spawnAsTitan = ShouldSpawnAsTitan( player ),
		selectedTitanClass = player.IsBot() ? null : player.IsSpawnAsTitan()
	}
}


function SpawnRetryRequestClassChanged( player, request )
{
	if ( request == null || !IsValid( player ) || player.IsBot() )
		return false

	return player.IsSpawnAsTitan() != request.selectedTitanClass
}


function PlayerTitanSpawnLifecycleIsValid( player, token, allowAlive, simulationToken = null )
{
	if ( !PlayerOwnsSpawnRetryToken( player, token ) || !player.hasConnected )
		return false

	if ( !SpawnRetryGameStateIsValid() )
		return false

	if ( allowAlive )
	{
		if ( simulationToken == null
			|| !( "simulationSpawnRetryToken" in player.s )
			|| player.s.simulationSpawnRetryToken != simulationToken
			|| !IsAlive( player ) )
		{
			return false
		}

		if ( PlayerShouldObserve( player ) )
			return false

		if ( IsPlayerInCinematic( player )
			&& ( !( "playersWatchingIntro" in level ) || !ArrayContains( level.playersWatchingIntro, player ) ) )
		{
			return false
		}

		return true
	}

	return DeadPlayerSpawnRetryLifecycleIsValid( player )
}


function PlayerCanContinueSpawnRetry( player, token, request, allowAlive = false, simulationToken = null )
{
	if ( !PlayerTitanSpawnLifecycleIsValid( player, token, allowAlive, simulationToken ) )
		return false

	if ( !allowAlive && SpawnRetryRequestClassChanged( player, request ) )
		return false

	if ( player.isSpawning
		&& ( !( "titanSpawnRetryToken" in player.s ) || player.s.titanSpawnRetryToken != token ) )
	{
		return false
	}

	return true
}


function TitanSpawnRetryLifecycleWatch( player, token, request, allowAlive, simulationToken )
{
	player.EndSignal( "Disconnected" )

	while ( PlayerOwnsSpawnRetryToken( player, token ) )
	{
		wait 0.1

		if ( PlayerCanContinueSpawnRetry( player, token, request, allowAlive, simulationToken ) )
			continue

		if ( IsValid( player ) && PlayerOwnsSpawnRetryToken( player, token ) )
			player.Signal( "TitanSpawnRetryLifecycleInvalid" )
		return
	}
}


function ReserveTitanSpawnRetry( player )
{
	if ( !IsValid( player ) )
		return null

	EnsureSafeSpawnRetryTokens( player )
	if ( PlayerHasSpawnRetryReservation( player ) )
		return null

	local token = UniqueString( "titan_spawn_retry" )
	player.s.titanSpawnRetryToken = token
	return token
}


function QueueRespawnAfterNoSafeSpawnpoint( player, rematchOrigin, spawnDataIndex, request )
{
	if ( !IsValid( player ) )
		return

	EnsureSafeSpawnRetryTokens( player )
	if ( PlayerHasSpawnRetryReservation( player ) )
		return

	local token = UniqueString( "safe_spawn_retry" )
	player.s.safeSpawnRetryToken = token
	thread RespawnAfterNoSafeSpawnpoint( player, rematchOrigin, token, spawnDataIndex, request )
}


function RespawnAfterNoSafeSpawnpoint( player, rematchOrigin, token, spawnDataIndex, request )
{
	player.EndSignal( "Disconnected" )
	player.EndSignal( "OnRespawned" )
	player.EndSignal( "SpawnClassChanged" )

	OnThreadEnd(
		function() : ( player, rematchOrigin, token, request )
		{
			local ownedToken = IsValid( player )
				&& "safeSpawnRetryToken" in player.s
				&& player.s.safeSpawnRetryToken == token
			if ( !ownedToken )
				return

			player.s.safeSpawnRetryToken = null
			if ( DeadPlayerCanResumeSpawnDispatch( player )
				&& ( SpawnRetryRequestClassChanged( player, request )
					|| PlayerShouldObserve( player )
					|| IsPlayerInCinematic( player ) ) )
			{
				thread DecideRespawnPlayer( player, rematchOrigin )
			}
		}
	)

	while ( PlayerCanContinueSpawnRetry( player, token, request ) )
	{
		wait 0.1

		if ( !PlayerCanContinueSpawnRetry( player, token, request ) )
			return

		if ( RespawnTitanPilot( player, rematchOrigin, token, spawnDataIndex, request ) )
			return
	}
}


function DecideRespawnPlayer( player, rematchOrigin = null )
{
	Assert( IsValid( player ), player + " is invalid!!" )
	Assert( !IsAlive( player ), player + " is already alive" )

	if ( PlayerHasSpawnRetryReservation( player ) )
		return false

	if ( !player.hasConnected )
	{
		printt( "DecideRespawnPlayer", player, "player.hasConnected was false" )
		return
	}

	if ( PlayerShouldObserve( player ) )
	{
		// printt( "are we observing?" )
		if ( IsPlayerEliminated( player ) && GetGameState() == eGameState.Playing )
		{
			// Can also be replaced with a custom function if people need it
			if ( level.customPlayerEliminatedMessage )
				SendHudMessage( player, level.customPlayerEliminatedMessage, -1, 0.4, 255, 255, 255, 255, 1.0, 6.0, 1.0 )
			else
				SendHudMessage( player, "#GAMEMODE_RESPAWN_NEXT_ROUND", -1, 0.4, 255, 255, 255, 255, 1.0, 6.0, 1.0 )
		}

		thread ObserverThread( player )
		return
	}

	if ( IsPlayerInCinematic( player ) )
	{
		printt( "DecideRespawnPlayer", player, "IsPlayerInCinematic was true" )
		return
	}

	if ( GetClassicMPMode() )
	{
		printt( "DecideRespawnPlayer using GetClassicMPMode() " )
		// if we're in the intro, spawn the player in a special way
		if ( ClassicMP_TryPlayerIntroSpawn( player ) )
		{
			printt( "DecideRespawnPlayer", player, "ClassicMP_TryPlayerIntroSpawn was true" )
			return
		}
	}

	if ( GAMETYPE == COOPERATIVE && CanSpawnIntoWaveSpawnDropship( player ) )
	{
		printt( "DecideRespawnPlayer CanSpawnIntoWaveSpawnDropship stuff was true")
		thread DoWaveSpawnByDropship( player )
		return
	}

	if ( IsValid( player.isSpawning ) )
	{
		printt( "DecideRespawnPlayer", player, "IsValid( player.isSpawning ) was true" )
		return
	}

	return RespawnTitanPilot( player, rematchOrigin )

	// if ( GetGameState() <= eGameState.Prematch ) // Once we've gotten to here, any special spawning logic like cinematic spawn and classic MP spawn have already completed if applicable. Freeze controls if in prematch because we don't want players running around in prematch. Controls will be unfrozen when gamestate switches to playing
	// {
	// 	printt( "freezing controls!" )
	// 	player.FreezeControlsOnServer( true )
	// }

}


function ClassicMP_TryPlayerIntroSpawn( player )
{
	Assert( GetClassicMPMode() )

	if ( !ClassicMP_CanUseIntroStartSpawn() )
		return false

	Assert( level.classicMP_introPlayerSpawnFunc != null, "No Classic MP intro player spawn function set! We at least expect the default dropship intro." )

	return ClassicMP_CallIntroPlayerSpawnFunc( player )
}

const MAX_ACTIVITY_DISABLED = 0
const MAX_ACTIVITY_PILOTS = 1
const MAX_ACTIVITY_TITANS = 2
const MAX_ACTIVITY_PILOTS_AND_TITANS = 3
const MAX_ACTIVITY_CONGER_MODE = 4

function GetPilotBotFlag()
{
	// IMPORTANT: Please call this consistently instead of Flag( "PilotBot" )
	// Force titan or pilot bots according to max activity mode if it is enabled.
	// Otherwise, leave the "pilotBot" flag alone and do what the game mode wants.
	local max_activity_mode = GetConVarInt( "max_activity_mode" )
	if ( max_activity_mode == MAX_ACTIVITY_PILOTS || max_activity_mode == MAX_ACTIVITY_PILOTS_AND_TITANS )
		return true
	else if ( max_activity_mode == MAX_ACTIVITY_TITANS )
		return false
	else if ( max_activity_mode == MAX_ACTIVITY_CONGER_MODE )
		return rand() % 2 != 0    // conger mode: 50/50 pilot and titan bots!
	else
		return Flag( "PilotBot" )
}

function ShouldSpawnAsTitan( player )
{
	// IMPORTANT: This needs to be the first check or max activity mode breaks
	if ( player.IsBot() )
		return !GetPilotBotFlag()

	if ( Riff_SpawnAsTitan() != eSpawnAsTitan.Default )
	{
		return Riff_ShouldSpawnAsTitan( player )
	}

	if ( GetGameState() < eGameState.Playing )
		return false

	local replayEndTime = player.watchingKillreplayEndTime - Time()
	local bufferTime = 0
	if ( replayEndTime > 0 )
	{
		bufferTime = replayEndTime
	}

	if ( !IsReplacementTitanAvailable( player, bufferTime ) )
		return false

	return player.IsSpawnAsTitan()
}


function RespawnOperator( player )
{
	local spawnPoint = FindSpawnPoint( player )
	if ( !spawnPoint )
	{
		QueueRespawnAfterNoSafeSpawnpoint( player, null, null, CreateSpawnRetryRequest( player ) )
		return false
	}

	player.SetPlayerSettings( "dronecontroller" )

	DroneController_OnPlayerSpawn( player )
	return true
}

function SetupPostLoaderPlayer( player )
{
	FlagSet( "APlayerHasSpawned" )
}

function RespawnTitanPilot( player, rematchOrigin = null, retryToken = null, spawnDataIndex = null, request = null )
{
	if ( request == null )
		request = CreateSpawnRetryRequest( player )

	if ( retryToken != null )
	{
		if ( !PlayerCanContinueSpawnRetry( player, retryToken, request ) )
			return false
	}
	else if ( !PlayerCanSpawn( player ) )
	{
		return false
	}

	SetupPostLoaderPlayer( player )

	//if ( IsLobby() )
	//	return false

	if ( retryToken == null && request.spawnAsTitan )
	{
		printt( "ShouldSpawnAsTitan" )
		// clear respawn countdown message
		if ( GetWaveSpawnType() != eWaveSpawnType.DISABLED && level.waveSpawnByDropship == true )
			MessageToPlayer( player, eEventNotifications.Clear )

		local titanSpawnToken = ReserveTitanSpawnRetry( player )
		if ( titanSpawnToken == null )
			return false

		thread TitanPlayerHotDropsIntoLevel( player, rematchOrigin, titanSpawnToken, false, null, request )
		return true
	}

	local spawnPoint

	if ( !player.IsBot() )
	{
		printt( "!player.IsBot()" )

		// Keep one telemetry record for this logical respawn across retries.
		if ( spawnDataIndex == null )
			spawnDataIndex = RecordSpawnData( player )
		ResetSpawnData( spawnDataIndex )

		PerfStart( PerfIndexServer.RespawnTitanPilot )

		if ( ShouldStartSpawn( player ) )
		{
			printt( "ShouldStartSpawn( player )" )
			spawnPoint = FindStartSpawnPoint( player, false, spawnDataIndex )
		}
		else
		{
			spawnPoint = FindSpawnPoint( player, false, spawnDataIndex )
		}

		PerfEnd( PerfIndexServer.RespawnTitanPilot )

		if ( !spawnPoint )
		{
			StoreSpawnData( spawnPoint, spawnDataIndex )
			QueueRespawnAfterNoSafeSpawnpoint( player, rematchOrigin, spawnDataIndex, request )
			return false
		}

		foreach ( team, _ in level.forcedToSpawnTogether )
		{
			if ( team != player.GetTeam() )
				continue

			if ( level.forcePilotSpawnPointForTeam[ team ] )
			{
				spawnPoint = level.forcePilotSpawnPointForTeam[ team ]
			}
			else
			{
				if ( team == TEAM_MILITIA )
				{
					thread ForcePilotSpawnPointForTeam( team, spawnPoint )
				}
				else
				{
					printt( "Possible issue?" )
				}
			}
		}

		if( rematchOrigin != null )
		{
			spawnPoint =  rematchOrigin
		}


		// stop recording spawn data
		StoreSpawnData( spawnPoint, spawnDataIndex )
	}

	if ( retryToken != null && !PlayerCanContinueSpawnRetry( player, retryToken, request ) )
		return false

	if ( IsAlive( player ) )
	{
		printt( "This happened one time, in retail." )
		return
	}

	local pilotDataTable = GetPlayerClassDataTable( player, level.pilotClass )
	local pilotSettings = pilotDataTable.playerSetFile
	player.SetPlayerSettings( pilotSettings )
	player.SetPlayerPilotSettings( pilotSettings )

	player.RespawnPlayer( spawnPoint ) // This will kill the thread
	printt( player.GetPlayerSettings() )
	printt( player.GetPlayerPilotSettings() )

	// make sure this hasn't changed without being updated
	Assert( VectorCompare( player.GetBoundingMins(), level.traceMins[ "pilot" ] ) )
	Assert( VectorCompare( player.GetBoundingMaxs(), level.traceMaxs[ "pilot" ] ) )
}

function SpawnPlayerForCinematic( player )
{
	player.SetPlayerSettings( "pilot_male_fastest" )

	printt( "Are we hitting this instead?" )

	player.DisableWeaponViewModel() //Want to disable player's gun but not hide it in 3rd person

	local spawnPoint = CreateScriptRef()
	local slot	= GetPlayerSlot( player )
	spawnPoint.SetOrigin( slot.GetOrigin() )
	spawnPoint.SetAngles( slot.GetAngles() )

	thread CinematicSpawnCleanup( spawnPoint )

	player.RespawnPlayer( spawnPoint )
}

function CinematicSpawnCleanup( spawnPoint )
{
	wait 0.2

	spawnPoint.Kill()
}

function ForcePilotSpawnPointForTeam( team, spawnPoint )
{
	level.forcePilotSpawnPointForTeam[ team ] = spawnPoint
	wait 5.0
	level.forcePilotSpawnPointForTeam[ team ] = null
}



function ShouldStartSpawn( player )
{
	if ( Riff_FloorIsLava() )
		return false

	if ( Flag( "ForceStartSpawn" ) )
		return true

	if ( Flag( "IgnoreStartSpawn" ) )
		return false

	if ( GetGameState() <= eGameState.Prematch )
		return true

	if ( player.s.respawnCount )
		return false

	return GameTime.PlayingTime() < START_SPAWN_GRACE_PERIOD
}


function TitanPlayerHotDropsIntoLevel( player, rematchOrigin = null, token = null, allowIntroAlive = false, simulationToken = null, request = null )
{
	printl( "TitanPlayerHotDropsIntoLevel" )

	player.EndSignal( "Disconnected" )
	player.EndSignal( "TitanSpawnRetryLifecycleInvalid" )
	if ( allowIntroAlive )
		player.EndSignal( "OnDeath" )
	else
		player.EndSignal( "SpawnClassChanged" )

	if ( token == null )
		token = ReserveTitanSpawnRetry( player )
	if ( token == null )
		return false

	if ( !allowIntroAlive && request == null )
		request = CreateSpawnRetryRequest( player )

	local reservation = {
		spawnPoint = null,
		camera = null,
		titan = null,
		titanCommitted = false
	}
	OnThreadEnd(
		function() : ( player, rematchOrigin, token, request, allowIntroAlive, reservation )
		{
			if ( IsValid( reservation.camera ) )
			{
				if ( IsValid( player ) )
					reservation.camera.FireNow( "Disable", "!activator", 0, player )
				reservation.camera.Kill()
			}

			if ( !reservation.titanCommitted && IsValid( reservation.titan ) )
				reservation.titan.Kill()

			local reservedSpawnPoint = reservation.spawnPoint
			if ( IsValid( reservedSpawnPoint )
				&& "titanSpawnReservationToken" in reservedSpawnPoint.s
				&& reservedSpawnPoint.s.titanSpawnReservationToken == token )
			{
				reservedSpawnPoint.s.titanSpawnReservationToken = null
				reservedSpawnPoint.s.inUse = false
			}

			local ownedToken = IsValid( player )
				&& "titanSpawnRetryToken" in player.s
				&& player.s.titanSpawnRetryToken == token
			if ( !ownedToken )
				return

			player.ClearSpawnPoint()
			player.isSpawning = null
			player.s.titanSpawnRetryToken = null

			if ( !allowIntroAlive
				&& !reservation.titanCommitted
				&& DeadPlayerCanResumeSpawnDispatch( player ) )
			{
				thread DecideRespawnPlayer( player, rematchOrigin )
			}
		}
	)

	thread TitanSpawnRetryLifecycleWatch( player, token, request, allowIntroAlive, simulationToken )

	if ( !PlayerCanContinueSpawnRetry( player, token, request, allowIntroAlive, simulationToken ) )
		return false

	player.Signal( "ChoseToSpawnAsTitan" )
	player.SetPlayerSettings( "spectator" )

	// Keep one telemetry record for this logical titan spawn across retries.
	local spawnDataIndex = RecordSpawnData( player )

	local spawnPoint
	while ( true )
	{
		if ( !PlayerCanContinueSpawnRetry( player, token, request, allowIntroAlive, simulationToken ) )
			return false

		ResetSpawnData( spawnDataIndex )
		local startSpawn = ShouldStartSpawn( player )

		if ( startSpawn )
		{
			spawnPoint = FindStartSpawnPoint( player, true, spawnDataIndex )
		}
		else if ( rematchOrigin && Riff_TitanExitIsDisabled() )
		{
			spawnPoint = FindClosestSpawnPoint( player, rematchOrigin, true, spawnDataIndex )
		}
		else
		{
			spawnPoint = FindSpawnPoint( player, true, spawnDataIndex )
		}


		if ( !spawnPoint )
		{
			if ( !PlayerCanContinueSpawnRetry( player, token, request, allowIntroAlive, simulationToken ) )
				return false
			wait 0.1
			continue
		}

	if ( !PlayerCanContinueSpawnRetry( player, token, request, allowIntroAlive, simulationToken ) )
		return false

	reservation.spawnPoint = spawnPoint
	if ( !( "titanSpawnReservationToken" in spawnPoint.s ) )
		spawnPoint.s.titanSpawnReservationToken <- null
	spawnPoint.s.titanSpawnReservationToken = token
	spawnPoint.s.inUse = true
	player.ReserveSpawnPoint( spawnPoint )
	player.isSpawning = spawnPoint

	if ( !PlayerCanContinueSpawnRetry( player, token, request, allowIntroAlive, simulationToken )
		|| spawnPoint.s.titanSpawnReservationToken != token )
	{
		return false
	}

	// stop recording the spawn data
	StoreSpawnData( spawnPoint, spawnDataIndex )

	Assert( spawnPoint, "No spawn point?!" )

	printl( "spawn point: " + spawnPoint )

	// first spawn is as a Titan
		//dropPod = Titan_HotDrop( player )
	local origin = spawnPoint.GetOrigin()
	local angles = spawnPoint.GetAngles()

	if ( angles == null )
	{
		// defensive fix for super rare phone home bug
		angles = Vector(0,0,0)
	}

	local titanDataTable = GetPlayerClassDataTable( player, "titan" )
	local titanSettings = titanDataTable.playerSetFile

	local animation = "at_hotdrop_01" //  "at_hotdrop_drop_2knee_turbo" // at_hotdrop_01"

	local model = GetPlayerSettingsFieldForClassName( titanSettings, player.GetTeam() == TEAM_MILITIA ? "bodymodel_militia" : "bodymodel_imc" )
	local warpAttach = GetAttachmentAtTimeFromModel( model, animation, "offset", origin, angles, 0 )
	PlayFX( TURBO_WARP_FX, warpAttach.position, warpAttach.angle )

	local camOffset = Vector( 44, -64, 520 )
	local camOrg = warpAttach.position + camOffset
	local camYaw = angles.y + 10
	camYaw %= 360
	local camAng = Vector( 90, camYaw, 0 )

	local delayedCreation = true

	local camera = CreateTitanDropCamera( camOrg, camAng )
	reservation.camera = camera
	camera.Fire( "Enable", "!activator", 0, player )

	if ( delayedCreation )
		wait 0.1
	if ( !PlayerCanContinueSpawnRetry( player, token, request, allowIntroAlive, simulationToken ) )
		return false
		if ( !( "titanSpawnReservationToken" in spawnPoint.s )
			|| spawnPoint.s.titanSpawnReservationToken != token
			|| !IsReservedSpawnpointValid( spawnPoint, player.GetTeam(), player ) )
		{
			if ( IsValid( camera ) )
			{
				camera.FireNow( "Disable", "!activator", 0, player )
				camera.Kill()
			}
			reservation.camera = null

			if ( "titanSpawnReservationToken" in spawnPoint.s
				&& spawnPoint.s.titanSpawnReservationToken == token )
			{
				spawnPoint.s.titanSpawnReservationToken = null
				spawnPoint.s.inUse = false
			}

			player.ClearSpawnPoint()
			player.isSpawning = null
			reservation.spawnPoint = null
			spawnPoint = null
			continue
		}

	local titan = CreateNPCTitanForPlayer( player, origin, angles, delayedCreation )
	reservation.titan = titan
	if ( IsValid( camera ) )
	{
		// camera can be invalid for a moment when server shuts down
		camera.SetOrigin( titan.GetOrigin() + camOffset )
		camera.SetParent( titan )
	}
	player.isSpawning = titan

	titan.s.disableAutoTitanConversation <- true //No Chatter

	titan.EndSignal( "OnDeath" ) // defensive; ideally we'll detect what is deleting a titan during hot drop and stop that from happing.
	waitthread TitanHotDrop( titan, animation, origin, angles, player, delayedCreation )
	if ( IsValid( camera ) )
	{
		// camera can be invalid for a moment when server shuts down
		camera.FireNow( "Disable", "!activator", 0, player )
		camera.Kill()
	}
	reservation.camera = null
	if ( !PlayerCanContinueSpawnRetry( player, token, request, allowIntroAlive, simulationToken ) )
		return false

	if ( player.IsBot() )
		Wallrun_EnforceWeaponDefaults( player )

	local pilotDataTable = GetPlayerClassDataTable( player, level.pilotClass )
	local pilotSettings = pilotDataTable.playerSetFile

	TakeAllWeapons( titan )
	GiveTitanWeaponsForPlayer( player, titan )

	player.SetPlayerSettings( pilotSettings )

	// classic MP custom intros might spawn the player earlier in LTS mode
	if ( !IsAlive( player ) )
		player.RespawnPlayer( titan )

	PilotBecomesTitan( player, titan )
	reservation.titanCommitted = true
	TitanDeployed( player )

	titanDataTable = GetPlayerClassDataTable( player, "titan" ) //Check again because players can switch loadouts in mid hotdrop
	local newTitanSettings = titanDataTable.playerSetFile
	if ( newTitanSettings != titanSettings )
		player.SetPlayerSettings( newTitanSettings )
	titan.Kill()

	Remote.CallFunction_Replay( player, "ServerCallback_TitanCockpitBoot" )
	player.CockpitStartBoot()

	// save post drop spawn data
	PostDropSpawnData( player, spawnDataIndex )

	if ( player.IsBot() )
	{
		local botCaller = GetPlayerArray()[0]
		local spot = GetTitanReplacementPoint(botCaller)
		local origin = spot.origin
		local dir =  botCaller.GetOrigin() - origin
		local angles = dir.GetAngles()//Vector(0,0,0)

		printt("Angle: ", angles)

		player.SetOrigin( origin )
		player.SetAngles( angles )

	}
		break
	}
}

function CreateTitanDropCamera( origin, angles )
{
	local viewControl = CreateEntity( "point_viewcontrol" )
	viewControl.kv.spawnflags = 56 // infinite hold time, snap to goal angles, make player non-solid

	viewControl.SetOrigin( origin )
	viewControl.SetAngles( angles )
	DispatchSpawn( viewControl, false )

	return viewControl
}

function CreateDropPodViewController( pod )
{
	local viewControl = CreateEntity( "point_viewcontrol" )
	viewControl.kv.spawnflags = 56 // infinite hold time, snap to goal angles, make player non-solid

	viewControl.SetOrigin( pod.GetOrigin() + Vector( 44, -64, 520 ) )
	local yaw = pod.GetAngles().y
	viewControl.SetAngles( Vector( 90, yaw + 10, 0 ) )
	DispatchSpawn( viewControl, false )

	viewControl.SetParent( pod )

	return viewControl
}


function ClearEntInUseOnDestroy( dropPoint, dropPod )
{
	dropPod.WaitSignal( "OnDestroy" )
	dropPoint.s.inUse = false
}

function TryGameModeAnnouncement( player )
{
	player.EndSignal( "OnDestroy" )
	player.EndSignal( "Disconnected" )

	if ( player.IsBot() )
		return

	if ( IsTrainingLevel() )
		return

	if ( Flag( "CinematicIntro" ) )
			FlagWait( "IntroDone" )

	while ( HasCinematicFlag( player, CE_FLAG_INTRO ) )
		player.WaitSignal( "CE_FLAGS_CHANGED" )

	if ( GetClassicMPMode() )
	{
		while ( HasCinematicFlag( player, CE_FLAG_CLASSIC_MP_SPAWNING ) )
			player.WaitSignal( "CE_FLAGS_CHANGED" )
	}


	if ( GetGameState() <= eGameState.Playing )
	{
		local attackingTeam = level.nv.attackingTeam

		if ( attackingTeam != null ) //asymmetric game mode announcement
		{
			Assert( GameMode_IsDefined( GAMETYPE ) ) //Only game modes that use new style of script should be using this
			//Assert( GameMode_GetGameModeAttackAnnouncement( GAMETYPE ) != null )
			//Assert( GameMode_GetGameModeDefendAnnouncement( GAMETYPE ) != null )

			if ( player.GetTeam() == attackingTeam )
				PlayConversationToPlayer( GameMode_GetGameModeAttackAnnouncement( GAMETYPE ), player )
			else
				PlayConversationToPlayer( GameMode_GetGameModeDefendAnnouncement( GAMETYPE ), player )
		}
		else
		{
			PlayConversationToPlayer( GetGameModeAnnouncement(), player ) //Symmetric game mode announcement
		}
	}

	if( GAMETYPE != BIG_BROTHER )
	{
		Remote.CallFunction_NonReplay( player, "ServerCallback_GameModeAnnouncement" )
	}

	player.s.hasDoneTryGameModeAnnouncement = true
}


function CodeCallback_OnPlayerRespawned( player )
{
	Remote.CallFunction_NonReplay( player, "ServerCallback_YouRespawned" )

	GameTeams.teamSpawnCounts[ player.GetTeam() ]++
	player.s.respawnCount++
	player.s.respawnTime = Time()
	player.s.lastAttacker = null

	if (!player.s.hasDoneTryGameModeAnnouncement)
		thread TryGameModeAnnouncement( player )

	if ( GameRules.GetGameMode()  == CAPTURE_POINT )
	{
		if ( player.s.respawnCount == 1 )
			player.s.lastHardPointActivityTime = Time() //Only set this on the first spawn
	}

	GameStateControlCheck( player )

	player.SpawnAsClass()

	player.Signal( "OnRespawned" )

	foreach ( action in level.SpawnAsClassActions )
	{
		local args = [ action.args, player, player.GetPlayerClass() ]
		action.func.acall( args )
	}

	// Added via AddCallback_OnPlayerRespawned
	foreach ( callbackInfo in level.onPlayerRespawnedCallbacks )
	{
		callbackInfo.func.acall( [callbackInfo.scope, player] )
	}

	NPCTitanInitModeOnPlayerRespawn( player )

	if ( "spectreSquad" in player.s )
		SpectreSquadFollowPlayer( player, player.s.spectreSquad )

	thread ReportDevStat_Spawn( player )

	thread LoadoutChangeGracePeriodThink( player )

	// --- Autobalance on Respawn ---
	// Force Militia team in Cooperative mode
	if ( GameRules.GetGameMode() == COOPERATIVE )
	{
		if ( player.GetTeam() != TEAM_MILITIA )
		{
			printt( "Forcing player " + player.GetPlayerName() + " back to Militia on respawn in Cooperative mode." )
			player.SetTeam( TEAM_MILITIA )
			NotifyClientsOfTeamChange( player, GetOtherTeam(TEAM_MILITIA), TEAM_MILITIA, true ) // Notify clients about the team change
		}
	}
	// Standard autobalance for other modes
	else if ( GetConVarBool( "delta_autoBalanceTeams" ) )
	{
		AutoBalancePlayer( player )
	}
	// --- End Autobalance on Respawn ---
}

// TODO: dont use this yet, its still missing a lot of checks for if the player is still alive and doing something
function AutoBalancePlayer_Delayed( player, delay, manual = false, forceSwitch = false )
{
	player.EndSignal( "OnDeath" )
	player.EndSignal( "OnDestroy" )

	MessageToPlayer( player, eEventNotifications.YouWillBeAutobalanced, null, Time() + delay )
	wait delay

	if ( IsValid( player ) )
		AutoBalancePlayer( player, forceSwitch )
}

// manualSwitch is basically just the *old* forceswitch
// The *NEW* forceSwitch is meant to be a dev thing, so we dont need to wait the 15 seconds
// Every time we want to switch teams when testing something
function AutoBalancePlayer( player, manualSwitch = false, forceSwitch = false )
{
	if ( !ShouldAutoBalancePlayer( player, manualSwitch, forceSwitch ) )
		return

	local currentTeam = player.GetTeam()
	local otherTeam = GetOtherTeam( currentTeam )
	local currentTeamCount = GetTeamPlayerCount( currentTeam )
	local otherTeamCount = GetTeamPlayerCount( otherTeam )
	local totalPlayers = currentTeamCount + otherTeamCount
	local targetPerTeam = ceil( totalPlayers / 2.0 )

	local isTitan = player.IsTitan()

	// Check if current team is over target and other team is under target
	// TODO: potentially check the players KDR and autobalance them if its too crazy?
	if ( manualSwitch || forceSwitch || ( currentTeamCount > targetPerTeam && otherTeamCount < targetPerTeam ) )
	{
		printt( "AutoBalancing player " + player.GetPlayerName() + " from team " + currentTeam + " to team " + otherTeam )

		// For things like dropping the CTF flag before switching teams
		foreach ( callbackInfo in level.onPreAutoBalanceCallbacks )
		{
			callbackInfo.func.acall( [ callbackInfo.scope, player, currentTeam, otherTeam ] )
		}

		// If the player is rodeoing someone, friendly or not, kick them out
		if ( GetTitanSoulBeingRodeoed( player ) != null )
			player.Signal( "RodeoOver" )

		local playerSoul = player.GetTitanSoul()
		if ( isTitan && IsValid( playerSoul ) )
		{
			local rodeoEnt = GetPlayerRodeoing( player )

			// If someone is rodeoing that player, kick them out too
			// Should also works with Spectres
			if ( rodeoEnt != null )
				rodeoEnt.Signal( "RodeoOver" )
		}

		// Store pet titan before switching
		local petTitan = player.GetPetTitan()

		// Switch player team
		player.TrueTeamSwitch()
		local newTeam = player.GetTeam() // Get the new team after switching
		if ( manualSwitch )
        {
			printt( "AutoBalancePlayer: Doing manual team switch for player " + player.GetPlayerName() )
            level.lastForceSwitchTime[player.GetUID()] <- Time()
        }
		// Switch pet titan team if it exists
		if ( IsValid( petTitan ) && IsAlive( petTitan ) )
		{
			printt( "AutoBalancing pet titan for player " + player.GetPlayerName() + " to team " + newTeam )
			petTitan.SetTeam( newTeam )
			// Update titan's title and minimap icon for the new team context
			SetupNPC_TitanTitle( petTitan, player )
			// Ensure the titan's model/skin reflects the new team if necessary (though usually handled by SetupNPC_TitanTitle or initial spawn)
			local soul = petTitan.GetTitanSoul()
			if ( IsValid( soul ) )
			{
				local settings = GetSoulPlayerSettings(soul)
				ApplyModelSkinToEntity( petTitan, settings, newTeam ) // Use the entity-applying function
				ChangeWeaponSkin( petTitan, newTeam )

				if ( IsValid( soul.chargeCannon.model ) )
					soul.chargeCannon.model.SetTeam( newTeam )

				local rodeoEnt = GetPlayerRodeoing( petTitan )

				if ( rodeoEnt != null )
					rodeoEnt.Signal( "RodeoOver" )
			}
		}

		local neededClass = level.pilotClass
		if ( isTitan )
			neededClass = "titan"

		// Update player model based on new team
		local classDataTable = GetPlayerClassDataTable( player, neededClass )
		local classSettings = classDataTable.playerSetFile

		if ( !isTitan && GetPlayerActiveBurnCard( player ) == "bc_play_spectre" )
			classSettings = GetMapName() == "mp_corporate" ? "pilot_spectre_corporate" : "pilot_spectre"

		if ( classSettings && IsAlive( player ) )
		{
			SetPlayerSetFile( player, classSettings )

			local modelFieldName = "bodymodel_imc"
			if ( newTeam == TEAM_MILITIA )
				modelFieldName = "bodymodel_militia"

			local correctModelName = GetPlayerSettingsFieldForClassName( classSettings, modelFieldName )
			if ( correctModelName != null && correctModelName != "" )
			{
				printt( "Autobalance: Setting model for player " + player + " (New Team: " + newTeam + ") using " + modelFieldName + " from " + classSettings + " -> " + correctModelName )

				ChangeWeaponSkin( player, newTeam )
				if ( isTitan && IsValid( playerSoul ) )
				{
					if ( IsValid( playerSoul.chargeCannon.model ) )
						playerSoul.chargeCannon.model.SetTeam( newTeam )
				}
			}

			// Fix rodeo viewmodel not changing skin
			local viewModel = player.GetFirstPersonProxy()
			if ( viewModel )
				viewModel.SetSkin( player.GetSkin() )
		}

		NotifyClientsOfTeamChange( player, currentTeam, newTeam, ( manualSwitch || forceSwitch ) ) // Notify clients about the team change

		local ai = GetNPCArrayByClass( "npc_soldier" )
		ai.extend( GetNPCArrayByClass( "npc_spectre" ) )

		foreach( npc in ai )
		{
			// Swap hacked Spectres and conscripted grunts
			if ( npc.GetBossPlayer() == player )
				npc.SetTeam( newTeam )

			// Only these two NPCs use the overhead teammate indicator
			local eHandle = npc.GetEncodedEHandle()
			Remote.CallFunction_Replay( player, "ServerCallback_UpdateOverheadIconForNPC", eHandle )
		}

		local turrets = GetNPCArrayByClass( "npc_turret_mega" )
		turrets.extend( GetNPCArrayByClass( "npc_turret_mega_bb" ) )
		turrets.extend( GetNPCArrayByClass( "npc_turret_sentry" ) )

		foreach ( npc in turrets )
		{
			// Swap hacked turrets
			if ( npc.GetBossPlayer() != player )
				continue

			switch( npc.GetClassname() )
			{
				case "npc_turret_sentry":
					npc.SetTeam( newTeam )
					npc.SetSkin( player.GetSkin() )
					break

				case "npc_tureet_mega_bb":
					BBTurretChangeTeam( npc, newTeam )

					local terminal = npc.GetControlPanel()
					if ( terminal )
						terminal.SetTeam( newTeam )
					
					break

				default:
					TurretChangeTeam( npc, newTeam )

					local terminal = npc.GetControlPanel()
					if ( terminal )
						terminal.SetTeam( newTeam )

					break
			}
		}

		foreach ( callbackInfo in level.onPostAutoBalanceCallbacks )
		{
			callbackInfo.func.acall( [ callbackInfo.scope, player, currentTeam, newTeam ] )
		}
	}
}

function ShouldAutoBalancePlayer( player, manualSwitch, forceSwitch = false )
{
	if ( !GamePlayingOrSuddenDeath() )
		return false

	if ( GameRules.GetGameMode() == COOPERATIVE )
		return false

	if ( GameRules.GetGameMode() == WINGMAN_LAST_TITAN_STANDING )
		return false

	if ( IsFFABased() )
		return false

	if ( player.s.respawnCount < 1 )
		return false

	// Cant be executing or hacking
	if ( player.ContextAction_IsMeleeExecution() || player.ContextAction_IsLeeching() )
		return false

	// Prevent the player controlling the titan in ctt from changing teams
	// level.teamFlag = the titans soul
	if ( GameRules.GetGameMode() == CAPTURE_THE_TITAN && IsValid( level.teamFlag ) && level.teamFlag.GetBossPlayer() == player )
		return false

	// Cant be evacing
	if ( player in level.playersOnDropship )
		return false

	if ( !manualSwitch && !forceSwitch )
	{
		// Game is about to end anyways
		if ( GetMatchProgress() >= 90 )
			return false
	}
	else if ( manualSwitch && !forceSwitch )
    {
        local playerUID = player.GetUID()
        if ( playerUID in level.lastForceSwitchTime )
        {
			local autobalanceCooldown = 15.0

            local timeSinceLastSwitch = Time() - level.lastForceSwitchTime[playerUID]
            if ( timeSinceLastSwitch < autobalanceCooldown )
            {	                
				local timeRemaining = ceil( autobalanceCooldown - timeSinceLastSwitch )
                printt( "Force switch on cooldown for player " + player.GetPlayerName() + " - " + (autobalanceCooldown - timeSinceLastSwitch) + " seconds remaining" )
				// MessageToPlayer( player, eEventNotifications.AutoBalanceCooldown, null, timeRemaining )
				// send a hud text message instead of event notification
				SendHudMessage( player, "You can switch teams again in " + timeRemaining + " seconds", -1, 0.4, 255, 255, 255, 255, 1.0, 2.0, 1.0 )
				return false
            }
        }
    }

	return true
}

function GameStart_AutoBalanceCooldown()
{
	foreach( player in GetPlayerArray() )
	{
		level.lastForceSwitchTime[ player.GetUID() ] <- Time()
	}
}

function ClientCommand_SwitchMe( player, ... )
{
	if ( GetConVarBool( "sv_cheats" ) && vargc > 0 && vargv[0].tointeger() == 1 )
		AutoBalancePlayer( player, false, true )
	else
		AutoBalancePlayer( player, true )
}

function GetEmbarkPlayer( titan )
{
	if ( "embarkingPlayer" in titan.s )
		return titan.s.embarkingPlayer

	return null
}

function GetDisembarkPlayer( titan )
{
	if ( "disembarkingPlayer" in titan.s )
		return titan.s.disembarkingPlayer

	return null
}


function GetEmbarkDisembarkPlayer( titan )
{
	local result = GetEmbarkPlayer( titan )

	if ( IsValid( result ) )
		return result

	result = GetDisembarkPlayer( titan )
	if ( IsValid( result ) )
		return result

	return null
}

function CodeCallback_OnNPCKilled( npc, damageInfo )
{
	if ( npc.IsTitan() )
	{
		// if a player is getting in, kill him too
		local player = GetEmbarkPlayer( npc )
		if ( IsAlive( player ) )
		{
			// kill the embarking player
			//printt( "Killed embarking player" )
			KillFromInfo( player, damageInfo )
		}

		if ( !npc.GetDoomedState() )
		{
			// Added via AddCallback_OnTitanDoomed
			foreach ( callbackInfo in level.onTitanDoomedCallbacks )
			{
				callbackInfo.func.acall( [callbackInfo.scope, npc, damageInfo] )
			}
		}
	}


	// AddCallback_NPCKilled
	foreach ( callbackInfo in level.onNPCKilledCallbacks )
	{
		callbackInfo.func.acall( [callbackInfo.scope, npc, damageInfo.GetAttacker(), damageInfo] )
	}

	PlayerOrNPCKilledByEnemy( npc, damageInfo )
}

function CodeCallback_OnEntityDestroyed( entity )
{
	print( "OnEntityDestroyed " + entity.entindex() + "\n" )

	if ( "onEntityDestroyedCallbacks" in entity.s )
		foreach ( callbackInfo in entity.s.onEntityDestroyedCallbacks )
			callbackInfo.func.acall( [callbackInfo.scope, entity] )
}

function AddEntityDestroyedCallback( entity, callbackFunc )
{
	Assert( type( this ) == "table", "AddEntityDestroyedCallback can only be added on a table. " + type( this ) )
	AssertParameters( callbackFunc, 1, "entity" )

	if ( !( "onEntityDestroyedCallbacks" in entity.s ) )
		entity.s.onEntityDestroyedCallbacks <- []

	local callbackInfo = {}
	callbackInfo.func <- callbackFunc
	callbackInfo.scope <- this

	entity.s.onEntityDestroyedCallbacks.append( callbackInfo )

	// set this or else the ent won't run CodeCallback_OnEntityDestroyed at all
	entity.SetDoDestroyCallback( true )
}

function CodeCallback_WeaponFireInCloak( player )
{
	if ( !WeaponCancelsCloak( player.GetActiveWeapon() ) )
		return

	if ( player.IsTitan() )  // Fix timing issue with auto-eject cloak and firing your weapon as a Titan cancelling it.  This assumes we never want cloaked titans!
		return

	if ( player.cloakedForever )
	{
		player.SetCloakFlicker( 1.0, 2.0 )
		return
	}

	// Check if we are allowed some cloaked shots based on ability selection
	if ( player.s.cloakedShotsAllowed > 0 )
	{
		player.s.cloakedShotsAllowed--
		return
	}

	DisableCloak( player, 0.5 )
}


function CodeCallback_OnClientConnectionStarted( player )
{
	// not a real player?
	if ( player.GetPlayerName() == "Replay" )
		return

	// 이미 종료되는 매치인 경우 다시 연결 끊는다.
	if( GetGameState() >= eGameState.Postmatch)
	{
		//player.ForceLeaveMatch_Native()
		return
	}

	player.SetName( "player" + player.entindex() )

	player.s = {}
	player.s.attackerInfo <- {}
	player.s.lastAttacker <- null
	player.s.lastFullHealthTime <- Time()
	player.s.clientScriptInitialized <- player.IsBot()
	player.s.inPostDeath <- null
	player.s.lastDetectedTime <- 0
	player.s.respawnCount <- 0
	player.s.respawnTime <- 0
	player.s.eliminated <- false
	player.s.lostTitanTime <- 0
	player.s.rodeoEnabled <- true
	player.s.cinematicSlot <- null
	player.s.lastRodeoTime <- 0 // used to stop you from re-auto-rodeo'ing
	player.s.lastDeathTime <- 0
	player.s.postDeathThreadStartTime <- 0
	player.s.cloakedShotsAllowed <- 0
	player.s.lastDamageTime <- 0
	player.s.lastHealUseEndTime <- 0
	player.s.lastHealResetTime <- 0
	player.s.wantsRespawn <- false

	player.s.startDashMeleeTime <- 0
	player.s.respawnSelectionDone <- true  // this gets set to false in postdeaththread but we need it to be true when connecting
	player.s.waveSpawnProtection <- false

	player.s.nextStatUpdateFunc <- null
	player.s.statUpdateTimes <- {}
	player.s.statUpdateTimes[ "distance" ] <- Time()
	player.s.statUpdateTimes[ "timePlayed" ] <- Time()
	player.s.statUpdateTimes[ "weaponUsageTime" ] <- Time()
	player.s.statUpdateTimes[ "wallrun" ] <- Time()

	player.s.stats_wallrunTime <- 0
	player.s.stats_wallhangTime <- 0
	player.s.stats_airTime <- 0
	player.s.stats_offGroundStreakTime <- 0

	player.s.replacementDropInProgress <- false

	player.s.deathOrigin <- null
	player.s.deathAngles <- null
	player.s.inGracePeriod <- null

	// should I just add these when playing coop?
	player.s.usedLoadoutCrate <- false
	player.s.restockAmmoTime <- 0
	player.s.restockAmmoCrate <- null

	player.s.autoTitanLastEngageCalloutTime <- 0
	player.s.autoTitanLastEngageCallout <- null
	player.s.lastAIConversationTime <- {} // when was a conversation last played?

	player.s.updatedPersistenceOnDisconnect <- false

	player.s.hasMatchLossProtection <- false

	player.s.timeBeforeKill <- 0
	player.s.addTimeBeforeKill <- 0

	player.s.hasDoneTryGameModeAnnouncement <- false

	player.s.lastNagTime <- 0

	player.s.nextFlagTouchTime <- 0

	Assert( !player._entityVars )
	InitEntityVars( player )

	if ( !IsMatchmakingServer() && IsTrainingLevel() )
		player.SetTeam( TEAM_MILITIA )

	// exists on server and client
	player.s.recentDamageHistory <- []

	if ( "ScriptCallback_OnClientConnecting" in getroottable() )
		ScriptCallback_OnClientConnecting( player )

	// Handle team assignment for connecting player
	// Force Militia team in Cooperative mode
	if ( GameRules.GetGameMode() == COOPERATIVE )
	{
		player.SetTeam( TEAM_MILITIA )
	}

	// Added via AddCallback_OnClientConnecting
	foreach ( callbackInfo in level.onClientConnectingCallbacks )
	{
		callbackInfo.func.acall( [callbackInfo.scope, player] )
	}

	AddTrackRef( player )

	printl( "Player connect started: " + player )

	local results = {}
	results.player <- player
	level.ent.Signal( "PlayerDidSpawn", results )

	thread HealthRegenThink( player )
	thread TrackLastFullHealthTime( player )

	SetPlayerToDefaultViewPoint( player )
}


function SetPlayerToDefaultViewPoint( player )
{
	local viewPoint = FindViewPoint( player )

	//if ( level.isTestmap && !viewPoint )
	//	return

	//if( level.isTestmap )		// 테스트 맵일 경우에도 체크하지 않는다.
	//	return

	Assert( viewPoint )

	player.SetOrigin( viewPoint.GetOrigin() )
	local viewTarget = GetEnt( viewPoint.kv.target )

	player.SetObserverModeStaticPosition( viewPoint.GetOrigin() )

	if ( viewTarget )
		player.SetObserverModeStaticAngles( (viewTarget.GetOrigin() - viewPoint.GetOrigin()).GetAngles() )
	else
		player.SetObserverModeStaticAngles( viewPoint.GetAngles() )

	player.StartObserverMode( OBS_MODE_STATIC_LOCKED )
	player.SetObserverTarget( null )
}


function FindViewPoint( player )
{
	local team = player.GetTeam()
	local missingGameTypeID = "0"	// if you don't select a gametype when you place the info_intermission it will return "0"
	local gametype = GAMETYPE.tolower()

	if ( gametype in level.viewPointData )
	{
		if ( team in level.viewPointData[ gametype ] )
			return Random( level.viewPointData[ gametype ][ team ] )
		else if ( TEAM_UNASSIGNED in level.viewPointData[ gametype ] )
			return Random( level.viewPointData[ gametype ][ TEAM_UNASSIGNED ] )
	}

	if ( missingGameTypeID in level.viewPointData )
	{
		if ( team in level.viewPointData[ missingGameTypeID ] )
			return Random( level.viewPointData[ missingGameTypeID ][ team ] )
		else if ( TEAM_UNASSIGNED in level.viewPointData[ missingGameTypeID ] )
			return Random( level.viewPointData[ missingGameTypeID ][ TEAM_UNASSIGNED ] )
	}

	return null
}


// need "you will change class next time" message
function OnPlayerCloseClassMenu( player )
{
	if ( GetGameState() <= eGameState.Prematch )
		return

	if ( player.IsEntAlive() )
		return

	if ( player.s.inPostDeath )
		return

	if ( IsValid( player.isSpawning ) )
		return

	thread DecideRespawnPlayer( player )	// there is a wait that happens later when using rematch burncard in Frontier Defense.
}


// playerconnected
function CodeCallback_OnClientConnectionCompleted( player )
{
	// 이미 종료되는 매치인 경우 다시 연결 끊는다.
	if( GetGameState() >= eGameState.Postmatch)
	{
		//player.ForceLeaveMatch_Native()
		return
	}

	player.connectTime = Time()
	player.hasConnected = true

    if ( GetGameState() <= eGameState.WaitingForPlayers )
		MuteSFX( player, 0.0 )
	MuteAll( player, 0.0 )
	UnMuteAll( player )

	MeleeInit( player )
	ZiplineInit( player )
	player.s.lastFastTime <- 0

	InitPassives( player )

	InitPersistentData( player )
	InitPlayerStats( player )
	InitPlayerChallenges( player )
	UpdatePlayerDecalUnlocks( player, false )
	ValidateCustomLoadouts( player )

	if ( !player.IsBot() && !IsTrainingLevel() )
	{
		// LoadOut Setting
		// UpdateLoadouts( player )
		local pilotIndex = player.GetPersistentVar("pilotSpawnLoadout.index")
		local pilotIsCustom = player.GetPersistentVar("pilotSpawnLoadout.isCustom")

		local titanIndex = player.GetPersistentVar("titanSpawnLoadout.index")
		local titanIsCustom = player.GetPersistentVar("titanSpawnLoadout.isCustom")

		SetPilotLoadout( player, pilotIsCustom, pilotIndex )
		SetTitanLoadout( player, titanIsCustom, titanIndex )

	}
	else
	{
		SetBotTitanLoadout( player )
		SetBotPilotLoadout( player )
	}

	UpdateMinimapStatus( player )
	UpdateMinimapStatusToOtherPlayers( player )

	player.s.activeSatchels		<- []
	player.s.activeProximityMines 	<- []
	player.s.activeLaserMines	<- []
	player.s.activeTripleThreatMines	<- []

	// 타이탄 빌드룰 초기화
	InitTitanBuildRule( player )
	ResetTitanBuildCompleteCondition( player )

	if( GetGameState() == eGameState.Playing )
	{
		StartTitanBuildProgress( player )
	}

	if ( Flag( "CinematicIntro" ) && GetGameState() <= eGameState.Prematch )
	{
		thread TryAddPlayerToCinematic( player )
	}
	else
	{
		if ( player.IsBot() )
		{
			local pilotBot = GetPilotBotFlag();
			if ( !pilotBot )
			{
				player.playerClassData["titan"].playerSetFile = botSettings

				if ( !botSettings )
				{
					/*local rInt = RandomInt( Native_GetTitanCount() )
					local titanName = Native_GetTitanName(rInt)
					player.playerClassData["titan"].playerSetFile = titanName
					*/

					local rInt = RandomInt( 3 )

					if ( rInt == 0 )
						player.playerClassData["titan"].playerSetFile = "titan_ogre"
					else if ( rInt == 1 )
						player.playerClassData["titan"].playerSetFile = "titan_atlas"
					else if ( rInt == 2 )
						player.playerClassData["titan"].playerSetFile = "titan_stryder"
					// else
						// player.playerClassData["titan"].playerSetFile = "titan_slammer"

				}
			}

			// Added via AddCallback_OnClientConnected
			foreach ( callbackInfo in level.onClientConnectedCallbacks )
			{
				callbackInfo.func.acall( [callbackInfo.scope, player] )
			}

			// below here is NOT BOT ONLY, but only randomly. Should fix to be consistent for bots.
			MinimapPlayerConnected( player )

			DecideRespawnPlayer( player )

			local botCaller = GetPlayerArray()[0]
			local spot = GetTitanReplacementPoint(botCaller)
			local origin = spot.origin
			local dir =  botCaller.GetOrigin() - origin
			local angles = dir.GetAngles()//Vector(0,0,0)

			player.SetOrigin( origin )
			player.SetAngles( angles )
			return
		}

		if ( ShouldPlayerBeEliminated( player ) )
			SetPlayerEliminated( player )
		else if ( GetGameState() == eGameState.SwitchingSides )
			SetPlayerEliminated( player )
	}

	// below here is NOT BOT ONLY, but only randomly. Should fix to be consistent for bots.
	MinimapPlayerConnected( player )

	InitLeeching( player )

	CheckForEmptyTeamVictory()

	NotifyClientsOfConnection( player, 1 )

	DebugSendClientFrontline( player )

	PlayCurrentTeamMusicEventsOnPlayer( player )
	SetCurrentTeamObjectiveForPlayer( player )

	SaveDateLoggedIn( player )
	FinishClientScriptInitialization( player )

	if ( ShouldPlayerHaveLossProtection( player ) )
	{
		player.s.hasMatchLossProtection = true
		Remote.CallFunction_NonReplay( player, "ServerCallback_GiveMatchLossProtection" )
	}

	UpdateBadRepPresent()

	// Added via AddCallback_OnClientConnected
	foreach ( callbackInfo in level.onClientConnectedCallbacks )
	{
		callbackInfo.func.acall( [callbackInfo.scope, player] )
	}

	if ( Flag( "CinematicIntro" ) && GetGameState() <= eGameState.Prematch )
		return

	if ( GetGameState() == eGameState.Playing || GetGameState() == eGameState.Prematch || GetGameState() == eGameState.SuddenDeath )
		DecideRespawnPlayer( player )
	else if ( Flag( "CinematicEnding" ) )
		DecideRespawnPlayer( player )
}

function ShouldPlayerHaveLossProtection( player )
{
	if ( level.nv.matchProgress < 50 )
		return false

	local team = player.GetTeam()
	local otherTeam = GetOtherTeam( team )
	local teamScore = IsRoundBased() ? GameRules.GetTeamScore2( team ) : GameRules.GetTeamScore( team )
	local otherTeamScore = IsRoundBased() ? GameRules.GetTeamScore2( otherTeam ) : GameRules.GetTeamScore( otherTeam )

	if ( teamScore < otherTeamScore )
		return true

	return false
}

// This server will recieve this command from the client once they have loaded/run all of their scripts
// Any client hud initialization should be done here
function FinishClientScriptInitialization( player )
{
	printt( "Player client script initialization complete: " + player );

	player.s.clientScriptInitialized = true

	SyncServerVars( player )
	SyncEntityVars( player )
	SyncUIVars( player )

	thread GiveClientCinematicEventStateFunctions( player )
	Remote.CallFunction_Replay( player, "ServerCallback_ClientInitComplete" )
}

function GiveClientCinematicEventStateFunctions( player )
{
	player.EndSignal( "Disconnected" )

	local numcalls = 0
	foreach ( indexName, _array in level.cinematicEventStateFuncs )
	{
		local eventState = indexName
		foreach ( index, funcName in _array )
		{
			local handle = GetClientFunctionHandle( funcName )
			Remote.CallFunction_Replay( player, "ServerCallback_AddCinematicEventClientFunc", eventState, handle )

			//wait 0.1 between every 3 calls
			numcalls++
			if ( numcalls % 3 )
				wait 0.1
		}
	}
	Remote.CallFunction_Replay( player, "ServerCallback_CinematicFuncInitComplete" )
}

function UpdatePersistenceOnDisconnect( player )
{
	if ( player.s.updatedPersistenceOnDisconnect )
		return

	FinalPlayerUpdate( player )

	player.s.updatedPersistenceOnDisconnect = true
}

function CodeCallback_OnClientSendingPersistenceToNewServer( player )
{
	printt( "match CodeCallback_OnClientSendingPersistenceToNewServer():", player.GetPlayerName() )

	if ( !player.hasConnected )
		return

	UpdatePersistenceOnDisconnect( player )
}

function CodeCallback_OnClientDisconnected( player )
{
	if ( IsMatchmakingServer() && GetGameState() < eGameState.Postmatch )
		thread WaitForDisconnectCompleted( player )

	if ( !player.hasConnected )
		return

	// Added via AddCallback_OnClientDisconnected
	foreach ( callbackInfo in level.onClientDisconnectingCallbacks )
		callbackInfo.func.acall( [callbackInfo.scope, player] )

	UpdatePersistenceOnDisconnect( player )

	player.Disconnected()
	player.CleanupMPClasses()
}

function FinalPlayerUpdate( player )
{
	// every player runs this either after match/evac, or when they disconnect

	// in case you disconnect during final scoreboard
	if ( "ranFinalPlayerUpdate" in player.s )
		return
	player.s.ranFinalPlayerUpdate <- true

	SaveScoreForMapStars( player )
}

function WaitForDisconnectCompleted( player )
{
	if ( IsValid( player ) )
		player.WaitSignal( "Disconnected" )

	while ( IsValid( player ) )
		wait 0

	UpdateBadRepPresent()

	CheckForEmptyTeamVictory()
}

function NotifyClientsOfConnection( player, state )
{
	local playerEHandle = player.GetEncodedEHandle()
	local players = GetPlayerArray()
	foreach( ent in players )
	{
		if ( ent != player )
			Remote.CallFunction_Replay( ent, "ServerCallback_PlayerConnectedOrDisconnected", playerEHandle, state )
	}
}

function NotifyClientsOfTeamChange( player, oldTeam, newTeam, wasManual )
{
	local playerEHandle = player.GetEncodedEHandle()
	local players = GetPlayerArray()
	foreach( ent in players )
	{
		//if ( ent != player )
		Remote.CallFunction_Replay( ent, "ServerCallback_PlayerChangedTeams", playerEHandle, oldTeam, newTeam )

		local message = null

		if ( player != ent )
		{
			if ( ent.GetTeam() == oldTeam )
			{
				if ( wasManual )
					message = eEventNotifications.TeammateSwitchedTeams
				else
					message = eEventNotifications.TeammateAutobalanced
			}
			else if ( ent.GetTeam() == newTeam )
			{
				if ( wasManual )
					message = eEventNotifications.EnemySwitchedTeams
				else
					message = eEventNotifications.EnemyAutobalanced
			}
		}
		else
		{
			if ( wasManual )
				message = eEventNotifications.YouSwitchedTeams
			else
				message = eEventNotifications.YouWereAutobalanced
		}

		MessageToPlayer( ent, message, null, null )
	}
}


function IsValidNPCTarget( entity )
{
	switch ( entity.GetClassname() )
	{
		case "npc_marvin":
		case "npc_soldier":
		case "npc_spectre":
		case "npc_titan":
		case "npc_turret_sentry":
		case "npc_turret_mega":
		case "npc_turret_mega_bb":
		case "npc_dropship":
			return true
	}

	return false
}


function ObserverThread( player )
{
	player.EndSignal( "Disconnected" )
	player.EndSignal( "OnRespawned" )

	player.Signal( "ObserverThread" )
	player.EndSignal( "ObserverThread" )

	thread ObserverEntities( player )

	local alreadyObserving = true
	while ( GamePlayingOrSuddenDeath() )
	{
		if ( !PlayerShouldObserve( player, alreadyObserving ) )
		{
			if ( PlayerCanWaveSpawn( player ) )
			{
				if ( PlayerCanSpawn( player ) )
					thread DoWaveSpawnByDropship( player )
				return
			}

			if ( PlayerCanSpawn( player ) )
				DecideRespawnPlayer( player )
			return
		}
		wait 0.25
	}
}


function ObserverEntities( player )
{
	if ( level.observerFunc )
	{
		level.observerFunc.func.acall( [level.observerFunc.scope, player] )
		return
	}

	if ( player.GetObserverMode() == OBS_MODE_CHASE )
		return

	SetPlayerToDefaultViewPoint( player )

	player.StartObserverMode( OBS_MODE_CHASE );
	player.SetObserverTarget( null ) // makes code look for a player to chase
}

// This doesnt even do anything as far as i can tell
/*
if ( !reloadingScripts )
{
	level.megaMaps <- {}
	level.megaMaps[ "mp_weapon_mega2" ] <- "mp_titanweapon_40mm"
	level.megaMaps[ "mp_weapon_mega3" ] <- "mp_titanweapon_arc_cannon"
	level.megaMaps[ "mp_weapon_mega4" ] <- "mp_titanweapon_rocket_launcher"
	level.megaMaps[ "mp_weapon_mega5" ] <- "mp_titanweapon_shotgun"
	level.megaMaps[ "mp_weapon_mega6" ] <- "mp_titanweapon_sniper"
	level.megaMaps[ "mp_weapon_mega7" ] <- "mp_titanweapon_triple_threat"
	level.megaMaps[ "mp_weapon_mega8" ] <- "mp_titanweapon_xo16"
	level.megaMaps[ "mp_weapon_mega10" ] <- "mp_titanweapon_vortex_shield"

	// crazy damage edition

	level.megaMaps[ "mp_weapon_mega11" ] <- "mp_titanweapon_xo16"
	level.megaMaps[ "mp_weapon_mega12" ] <- "mp_titanweapon_sniper"
	level.megaMaps[ "mp_weapon_mega13" ] <- "mp_titanweapon_shotgun"
	level.megaMaps[ "mp_weapon_mega14" ] <- "mp_titanweapon_rocket_launcher"
	level.megaMaps[ "mp_weapon_mega15" ] <- "mp_titanweapon_arc_cannon"
	level.megaMaps[ "mp_weapon_mega16" ] <- "mp_titanweapon_40mm"
}
*/

function CodeCallback_GetWeaponDamageSourceId( weapon )
{
	local classname = weapon.GetClassname()

	//Assert( classname in getconsttable().eDamageSourceId, classname + " not added to eDamageSourceId enum" )
	//if ( classname in level.megaMaps )
	//{
	//	classname = level.megaMaps[ classname ]
	//}
	local damageSourceInt = getconsttable().eDamageSourceId[ classname ]

	Assert( damageSourceInt in damageSourceStrings, classname + " not added to damageSourceStrings table" )

	return damageSourceInt
}



function CheckForEmptyTeamVictory()
{
	if ( IsFFABased() )
		return

	if ( IsTrainingLevel() )
		return
	if ( GetDeveloperLevel() )
		return
	if ( IsPrivateMatch() )
		return
	if ( GAMETYPE == COOPERATIVE )
		return
	if (GetCurrentPlaylistName() == CAMPAIGN)
		return

	if ( !IsRoundBased() && (GetGameState() >= eGameState.WinnerDetermined) )
		return
	if ( IsRoundBased() && level.nv.gameEndTime )
		return

	if (GetConVarBool("delta_allow_empty_server"))
		return

	if ( GamePlayingOrSuddenDeath() && (GameTime.PlayingTime() >= START_SPAWN_GRACE_PERIOD) )
	{
		// if the other team drops completely
		local defaultWinner = TEAM_UNASSIGNED
		if ( GetTeamPlayerCount( TEAM_MILITIA ) == 0 )
			defaultWinner = TEAM_IMC
		else if ( GetTeamPlayerCount( TEAM_IMC ) == 0 )
			defaultWinner = TEAM_MILITIA

		if ( defaultWinner != TEAM_UNASSIGNED && (level.missingPlayersTimeout == null) )
			level.missingPlayersTimeout = Time() + 20.0 // force the match to end in 20 seconds
		else if ( defaultWinner == TEAM_UNASSIGNED )
			level.missingPlayersTimeout = null

		if ( (defaultWinner != TEAM_UNASSIGNED) && (level.missingPlayersTimeout < Time())  )
		{
			SetWinner( defaultWinner )
			return
		}
	}

	if ( GetMatchProgress() >= 75 )
	{
		level.missingPlayersTimeout = Time() // force the match to end
		return
	}
}

function OutOfBoundsSetup()
{
	if ( !IsMultiplayer() )
		return

	// wait for triggers to spawn
	wait 1

	local triggers = GetEntArrayByClass_Expensive( "trigger_out_of_bounds" )
	foreach( trigger in triggers )
	{
		trigger.ConnectOutput( "OnStartTouch", EntityOutOfBounds )
		trigger.ConnectOutput( "OnEndTouch", EntityBackInBounds )
	}

	AddCallback_GameStateEnter( eGameState.Postmatch, OutOfBoundsDisable )
}

function OutOfBoundsDisable()
{
	local triggers = GetEntArrayByClass_Expensive( "trigger_out_of_bounds" )
	foreach( trigger in triggers )
	{
		trigger.DisconnectOutput( "OnStartTouch", EntityOutOfBounds )
		trigger.DisconnectOutput( "OnEndTouch", EntityBackInBounds )
	}
}

function EntityOutOfBounds( trigger, entity, caller, value )
{
	//printt( "ENTITY", entity, "IS OUT OF BOUNDS ON TRIGGER", trigger )

	if ( !IsValidOutOfBoundsEntity( entity ) )
		return

	//printt( "Valid Out OfBounds Entity, EntityOutOfBounds" )

	if ( !( "outOfBoundsTriggersTouched" in entity.s ) )
		entity.s.outOfBoundsTriggersTouched <- 0
	if ( !( "timeBackInBound" in entity.s ) )
		entity.s.timeBackInBound <- max( 0, Time() - OUT_OF_BOUNDS_DECAY_TIME ) //don't allow negative time
	if ( !( "timeLeftBeforeDyingFromOutOfBounds" in entity.s ) )
		entity.s.timeLeftBeforeDyingFromOutOfBounds <- OUT_OF_BOUNDS_TIME_LIMIT

	entity.s.outOfBoundsTriggersTouched++

	Assert( entity.s.outOfBoundsTriggersTouched > 0 )

	// Already touching another trigger
	if ( entity.s.outOfBoundsTriggersTouched == 1 )
	{
		local decayTime = max( 0, Time() - entity.s.timeBackInBound - OUT_OF_BOUNDS_DECAY_DELAY )
		local outOfBoundsTimeRegained = decayTime * ( OUT_OF_BOUNDS_TIME_LIMIT.tofloat() / OUT_OF_BOUNDS_DECAY_TIME.tofloat() )
		local deadTime = clamp( entity.s.timeLeftBeforeDyingFromOutOfBounds + outOfBoundsTimeRegained, 0.0, OUT_OF_BOUNDS_TIME_LIMIT )

		//printt( "Decay Time: " + decayTime + ", outOfBoundsTimeRegained:" + outOfBoundsTimeRegained + ", timeLeftBeforeDyingFromOutOfBounds: " + entity.s.timeLeftBeforeDyingFromOutOfBounds + ", deadTime: " + deadTime  )

		entity.s.timeLeftBeforeDyingFromOutOfBounds = deadTime

		entity.SetOutOfBoundsDeadTime( Time() + deadTime )

		thread KillEntityOutOfBounds( entity )
	}

	//printt( "entity.GetOutOfBoundsDeadTime():", entity.GetOutOfBoundsDeadTime() )
}

function EntityBackInBounds( trigger, entity, caller, value )
{
	//printt( "ENTITY", entity, "IS BACK IN BOUNDS OF TRIGGER", trigger )

	if ( !IsValidOutOfBoundsEntity( entity ) )
		return

	//printt( "Valid Out OfBounds Entity, EntityBackInBounds" )

	if ( !( "outOfBoundsTriggersTouched" in entity.s ) )
		entity.s.outOfBoundsTriggersTouched <- 0
	else
		entity.s.outOfBoundsTriggersTouched--

	if ( entity.s.outOfBoundsTriggersTouched < 0 ) //JFS, defensive fix. Restore the assert if needed
		entity.s.outOfBoundsTriggersTouched = 0

	//Assert( entity.s.outOfBoundsTriggersTouched >= 0 )

	if ( entity.s.outOfBoundsTriggersTouched == 0 )
	{
		if ( !( "timeBackInBound" in entity.s ) ) //Can go back in bounds as a valid entity even though we were invalid on the way out of bounds
			entity.s.timeBackInBound <- 0
		else
			entity.s.timeBackInBound = Time()
		//printt( "EntityBackInBounds, timeBackInBound: " + entity.s.timeBackInBound )

		if ( !( "timeLeftBeforeDyingFromOutOfBounds" in entity.s ) )
			entity.s.timeLeftBeforeDyingFromOutOfBounds <- OUT_OF_BOUNDS_TIME_LIMIT //Can go back in bounds as a valid entity even though we were invalid on the way out of bounds
		else
			entity.s.timeLeftBeforeDyingFromOutOfBounds = max( 0, entity.GetOutOfBoundsDeadTime() - Time() )
		//printt( "EntityBackInBounds, timeLeftBeforeDyingFromOutOfBounds: " + entity.s.timeLeftBeforeDyingFromOutOfBounds )

		entity.SetOutOfBoundsDeadTime( 0 )
		entity.Signal( "BackInBounds" )
	}
}

function KillEntityOutOfBounds( entity )
{
	if ( GetGameState() < eGameState.Playing )
		return

	Assert( entity.GetOutOfBoundsDeadTime() != 0 )
	Assert( Time() <= entity.GetOutOfBoundsDeadTime() )

	entity.EndSignal( "OnDeath" )
	entity.Signal( "OutOfBounds" )
	entity.EndSignal( "OutOfBounds" )
	entity.EndSignal( "BackInBounds" )

	OnThreadEnd(
		function() : ( entity )
		{
			if ( IsValid( entity ) && !IsAlive( entity ) )
			{
				Assert( "outOfBoundsTriggersTouched" in entity.s )
					entity.s.outOfBoundsTriggersTouched = 0

				entity.SetOutOfBoundsDeadTime( 0 )
			}
		}
	)

	wait entity.GetOutOfBoundsDeadTime() - Time()

	if ( !IsValidOutOfBoundsEntity( entity ) )
		return

	if ( entity.GetOutOfBoundsDeadTime() == 0 )
		return

	entity.Die( level.worldspawn, level.worldspawn, { scriptType = DF_INSTANT, damageSourceId = eDamageSourceId.outOfBounds } )

}

function IsValidOutOfBoundsEntity( ent )
{
	if ( !IsValid( ent ) )
		return false

	if ( !IsAlive( ent ) )
		return false

	if ( ent.IsPlayer() )
	{
		if ( ent.IsNoclipping() && !ent.Anim_IsActive() ) //Need to check for Anim_IsActive because PlayAnim() calls will set IsNoclipping() to true. This caused a bug with ejecting out of a OutOfBounds trigger
			return false

		if ( IsPlayerInCinematic( ent ) )
			return false

		local parentEnt = ent.GetParent()
		if ( IsValid( parentEnt ) && parentEnt.IsDropship() )
			return false

		return true
	}


	if ( ent.IsNPC() && ent.IsTitan() )
		return true

	return false
}

function SimulateGameScore( speedMultiplier = 2 )
{
	level.ent.Signal( "SimulateGameScore" )
	level.ent.EndSignal( "SimulateGameScore" )

	if ( speedMultiplier == 0 )
	{
		 printl( "Simulated Game Scoring disabled" )
		 return
	}

	while ( GetGameState() != eGameState.Playing )
	{
		wait 1
	}

	printl( "Simulated Game Scoring x" + speedMultiplier + " started" )

	scoreLimit <- GetScoreLimit_FromPlaylist().tointeger()
	matchTimeLimitSeconds <- ( GetTimeLimit_ForGameMode() * 60.0 ).tofloat()
	local averageToUse = ( scoreLimit / matchTimeLimitSeconds ) * speedMultiplier
	local tickRate = 10.0

	while ( GetGameState() == eGameState.Playing )
	{
		// random team
		local scoringTeam = CoinFlip() ? TEAM_MILITIA : TEAM_IMC
		local scoreToAdd = floor( ( averageToUse * tickRate ) + 0.5 )

		// maybe there's a multikill event
		if ( scoreToAdd )
		{
			if ( RandomInt( 100 ) < 10 )
			{
				local multiplier = RandomInt( 1, 5 )
				Assert( multiplier != 0 )
				scoreToAdd *= multiplier
			}

			GameScore.AddTeamScore( scoringTeam, scoreToAdd )
		}

		wait tickRate
	}
}

function PlayerCanSpawn( player, spawnToken = null )
{
	if ( IsAlive( player ) )
		return false

	if ( player.isSpawning )
		return false

	EnsureSafeSpawnRetryTokens( player )
	if ( player.s.safeSpawnRetryToken != null && player.s.safeSpawnRetryToken != spawnToken )
		return false
	if ( player.s.titanSpawnRetryToken != null && player.s.titanSpawnRetryToken != spawnToken )
		return false

	return true
}


function SetPlayerEliminated( player )
{
	Assert( player.entindex() < 32 )
	local shiftIndex = player.entindex() - 1
	local elimMask = (1 << shiftIndex)

	level.nv.eliminatedPlayers = level.nv.eliminatedPlayers | elimMask
	player.s.eliminated = true
}


function ClearPlayerEliminated( player )
{
	Assert( player.entindex() < 32 )
	local shiftIndex = player.entindex() - 1
	local elimMask = (1 << shiftIndex)

	level.nv.eliminatedPlayers = level.nv.eliminatedPlayers & (~elimMask)
	player.s.eliminated = false
}


function IsPlayerEliminated( player )
{
	return player.s.eliminated
}

function IsTeamEliminated( team )
{
	local players = GetPlayerArrayOfTeam( team )

	foreach ( player in players )
	{
		if ( IsPlayerEliminated( player ) != true )
			return false
	}

	return true
}

function SetShouldPlayerBeEliminatedFunc( callbackFunc )
{
	AssertParameters( callbackFunc, 1, "player" )

	local name = FunctionToString( callbackFunc )
	local callbackInfo = {}
	callbackInfo.name <- name
	callbackInfo.func <- callbackFunc
	callbackInfo.scope <- this

	level.shouldPlayerBeEliminatedFuncTable = callbackInfo
}

function ClearShouldPlayerBeEliminatedFunc()
{
	level.shouldPlayerBeEliminatedFuncTable = null
}

function ShouldShowLossProtectionOnEOG( player )
{
	if ( player.s.hasMatchLossProtection != true )
		return false

	if ( player.GetTeam() == GetWinningTeam() )
		return false

	return true
}


function ClientCommand_PrivateMatchEndMatch( player, ... )
{
	if ( !IsPrivateMatch() )
		return true

	if ( GetPartyLeader( player ) != player )
		return true

	level.privateMatchForcedEnd = true

	if ( !GamePlayingOrSuddenDeath() )
	{
		GameRules_EndMatch()
		return
	}

	local winningTeam = TEAM_UNASSIGNED
	local winningPlayer = null
	if ( IsFFABased() )
	{
		winningPlayer = GetWinningPlayer()
	}
	else if ( !IsRoundBased() )
	{
		local militiaScore = GameRules.GetTeamScore( TEAM_MILITIA )
		local imcScore = GameRules.GetTeamScore( TEAM_IMC )

		if ( imcScore > militiaScore )
			winningTeam = TEAM_IMC
		else if ( imcScore < militiaScore )
			winningTeam = TEAM_MILITIA
	}

	SetWinLossReasons( "#GAMEMODE_HOST_ENDED_MATCH", "#GAMEMODE_HOST_ENDED_MATCH" )
	SetWinner( winningTeam, winningPlayer )
	return true
}

function SaveScoreForMapStars( player )
{
	Assert( IsValid( player ) )
	Assert( IsPlayer( player ) )
	if ( IsPrivateMatch() && !IsDelta() )
		return

	if ( player.IsBot() )
		return

	local mapName = GetMapName()
	if ( !PersistenceEnumValueIsValid( "maps", mapName ) )
		return

	local modeName = GameRules.GetGameMode()
	if ( !PersistenceEnumValueIsValid( "gameModesWithStars", modeName ) )
		return

	local score = 0
	switch( modeName )
	{
		case TEAM_DEATHMATCH:
		case PILOT_SKIRMISH:
			score = player.GetKillCount()
			break

		case CAPTURE_POINT:
		case ATTRITION:
		case CAPTURE_THE_FLAG:
		case MARKED_FOR_DEATH:
		case CAPTURE_THE_FLAG_PRO:
		case SCAVENGER:
		case TITAN_MFD:
		case TITAN_MFD_PRO:
			score = player.GetAssaultScore()
			break

		case LAST_TITAN_STANDING:
		case TITAN_BRAWL:
			score = player.GetTitanKillCount()
			break

		case COOPERATIVE:
			score = level.nv.TDCurrentTeamScore
			break

		default:
			Assert( 0, "Unhandled mode in SaveScoreForMapStars()" )
			return
	}

	local bestScore = player.GetPersistentVar( "mapStars[" + GetMapName() + "].bestScore[" + GameRules.GetGameMode() + "]" )

	if (score > bestScore)
	{
		player.SetPersistentVar( "mapStars[" + GetMapName() + "].previousBestScore[" + GameRules.GetGameMode() + "]", bestScore )
		player.SetPersistentVar( "mapStars[" + GetMapName() + "].bestScore[" + GameRules.GetGameMode() + "]", score )
	}
}


main()


