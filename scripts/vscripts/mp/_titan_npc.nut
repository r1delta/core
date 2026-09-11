
const TITAN_USE_HOLD_PROMPT = "Hold [USE] to Pilot||Hold [USE] to Rodeo"
const TITAN_USE_PRESS_PROMPT = "Press [USE] to Pilot||Press [USE] to Rodeo"

function main()
{
	Globalize( CodeCallback_PlayerRequestClimbInNPCTitan )

	Globalize( NPCTitanNextMode )
	Globalize( NPCTitanInitModeOnPlayerRespawn )
	Globalize( SetupAutoTitan )
	Globalize( SetUpNPCTitanCurrentMode )
	Globalize( SetupNPC_TitanTitle )
	Globalize( SetModelSkinFromSettings )
	Globalize( SetPlayerPetTitan )
	Globalize( AutoTitanChangedEnemy )
	Globalize( PlayAutoTitanConversation )

	Globalize( CreateNPCTitanForPlayer )
	Globalize( CreateNPCTitanFromSettings )
	Globalize( CreateSpawnNPCTitanTemplate )
	Globalize( CreateDefaultNPCTitanTemplate )
	Globalize( SpawnNPCTitan )
	Globalize( ClientCommand_TrailerTitanDrop )
	Globalize(ApplyModelSkinToEntity)
	Globalize( SetupFollowTitan )
	Globalize( FreeAutoTitan )

	if ( GetDeveloperLevel() > 0 )
		AddClientCommandCallback( "TrailerTitanDrop", ClientCommand_TrailerTitanDrop )

	RegisterSignal( "ChangedTitanMode" )

	AddSoulDeathFunc( AutoTitanDestroyedCheck )

	Minimap_PrecacheMaterial( "vgui/HUD/threathud_titan_friendlyself" )
	Minimap_PrecacheMaterial( "vgui/HUD/threathud_titan_friendlyself_guard" )
}

function AutoTitanDestroyedCheck( soul )
{
	local titan = soul.GetTitan()

	if ( !IsValid( titan ) )
		return

	if ( "guardModePoint" in titan.s )
	{
		if ( IsValid( titan.s.guardModePoint ) )
			titan.s.guardModePoint.Kill()
	}

	local player = soul.GetBossPlayer()
	if ( !IsValid( player ) )
		return

	if ( player.GetPetTitan() == titan )
		player.SetPetTitan( null )

	if ( soul.IsEjecting() )
		return

	// has another titan?
	if ( GetPlayerTitanInMap( player ) )
		return

	if ( ( Riff_TitanAvailability() != eTitanAvailability.Default ) && ( !Riff_IsTitanAvailable( player ) ) )
		return

	thread PlayConversationToPlayer( "AutoTitanDestroyed", player )
}



//////////////////////////////////////////////////////////
function SetupNPC_TitanTitle( npcTitan, player )
{
	npcTitan.SetBossPlayer( player )

	printt("player.GetPetTitanMode() : ", player.GetPetTitanMode())

	switch ( player.GetPetTitanMode() )
	{
		case eNPCTitanMode.FOLLOW:
			npcTitan.Minimap_SetBossPlayerMaterial( "vgui/HUD/threathud_titan_friendlyself" )
			npcTitan.SetTitle("#NPC_AUTO_TITAN")
			break;

		//case eNPCTitanMode.ROAM:
			//break;

		case eNPCTitanMode.STAY:
			npcTitan.Minimap_SetBossPlayerMaterial( "vgui/HUD/threathud_titan_friendlyself_guard" )
			npcTitan.SetTitle("#NPC_AUTO_TITAN")
			break;
	}
}

function SetUpNPCTitanCurrentMode( player, mode )
{
	printt( "SetUpNPCTitanCurrentMode: ",mode )
	if( mode < eNPCTitanMode.FOLLOW || mode >= eNPCTitanMode.MODE_COUNT )
		return;

	local titan = player.GetPetTitan()
	if ( IsAlive( titan ) )
	{
		NPCTitanDisableCurrentMode( titan, player )

		printt( "SetUpNPCTitanCurrentMode: ",mode )
		player.SetPetTitanMode( mode )

		SetupNPC_TitanTitle( titan, player )
		NPCTitanEnableCurrentMode( titan, player )

		titan.Signal( "ChangedTitanMode" )
	}
}

//////////////////////////////////////////////////////////
function NPCTitanNextMode( npcTitan, player )
{
	NPCTitanDisableCurrentMode( npcTitan, player )

	local mode = player.GetPetTitanMode() + 1
	if ( mode == eNPCTitanMode.MODE_COUNT )
		mode = eNPCTitanMode.FOLLOW

	player.SetPetTitanMode( mode )
	npcTitan.Signal( "ChangedTitanMode" )

	SetupNPC_TitanTitle( npcTitan, player )
	NPCTitanEnableCurrentMode( npcTitan, player )
}

//////////////////////////////////////////////////////////
function NPCTitanDisableCurrentMode( npcTitan, player )
{
	switch ( player.GetPetTitanMode() )
	{
		case eNPCTitanMode.FOLLOW:
			npcTitan.DisableBehavior( "Follow" )
			break;

		//case eNPCTitanMode.ROAM:
		//	break;

		case eNPCTitanMode.STAY:
			npcTitan.DisableBehavior( "Assault" )
			break;
	}
}


//////////////////////////////////////////////////////////
function NPCTitanEnableCurrentMode( npcTitan, player )
{
	switch ( player.GetPetTitanMode() )
	{
		case eNPCTitanMode.FOLLOW:
			NPCTitanFollowPilotInit( npcTitan, player )
			break;

		//case eNPCTitanMode.ROAM:
		//	break;

		case eNPCTitanMode.STAY:
		{
			Assert( "guardModePoint" in npcTitan.s )
			npcTitan.s.guardModePoint.SetOrigin( npcTitan.GetOrigin() )

			local traceStart = player.EyePosition()
			local forward = player.EyeAngles().AnglesToForward()
			local traceEnd	= traceStart + ( forward * 12000 )

			local result = TraceLine( traceStart, traceEnd, player, TRACE_MASK_BLOCKLOS, TRACE_COLLISION_GROUP_NONE )

			local dir = result.endPos - npcTitan.EyePosition()

			// DebugDrawLine( result.endPos, npcTitan.EyePosition(), 255, 0, 0, true, 5 )

			local titanAngles;
			if ( dir.LengthSqr() > 100 )
				titanAngles = VectorToAngles( dir )
			else
				titanAngles = player.GetAngles()

			titanAngles.z = 0;

			npcTitan.s.guardModePoint.SetAngles( titanAngles )
			npcTitan.AssaultPointEnt( npcTitan.s.guardModePoint )
			break;
		}
	}
}


function AutoTitanChangedEnemy( titan )
{
	if ( !IsAlive( titan ) )
		return

	local enemy = titan.GetEnemy()

	if ( !IsAlive( enemy ) )
		return

	if ( !titan.CanSee( enemy ) )
		return

	local aliasPrefix, aliasSuffix
	if ( enemy.IsTitan() )
	{
		aliasPrefix = "autotitan"
		aliasSuffix = "_engaged_titan"
	}
	else
	if ( enemy.IsSoldier() )
	{
		aliasPrefix = "autotitan"
		aliasSuffix = "_engaged_grunt"
	}
	else
	if ( enemy.IsHuman() && enemy.IsPlayer() )
	{
		aliasPrefix = "autotitan"
		aliasSuffix = "_engaged_pilot"
	}

	if ( !aliasPrefix || !aliasSuffix  )
		return

	PlayAutoTitanConversation( titan, aliasPrefix, aliasSuffix )
}

function AutoTitanShouldSpeak( titan, owner, aliasSuffix )
{
	if ( IsForcedDialogueOnly ( owner ) )
		return false

	if ( "disableAutoTitanConversation" in titan.s )
	{
		return false
	}
	//Shut Auto Titans up when game isn't active anymore
	if ( GetGameState() >= eGameState.Postmatch )
	{
		return false
	}

	local owner

	if ( titan.IsPlayer() )
	{
		owner = titan
	}
	else
	{
		owner = GetPetTitanOwner( titan )
		if ( !IsValid( owner ) )
			return
	}

	if ( owner.s.autoTitanLastEngageCallout == aliasSuffix )
	{
		// just did this line, so significant time has to pass before we will use it again
		return Time() > owner.s.autoTitanLastEngageCalloutTime + 28
	}

	// this is a new line, so just make sure we haven't spoken too recently
	return Time() > owner.s.autoTitanLastEngageCalloutTime + 7
}

function PlayAutoTitanConversation( titan, aliasPrefix, aliasSuffix )
{
	local owner

	if ( titan.IsPlayer() )
	{
		owner = titan
	}
	else
	{
		owner = GetPetTitanOwner( titan )
		if ( !IsValid( owner ) )
			return
	}

	if ( !AutoTitanShouldSpeak( titan, owner, aliasSuffix ) ) //Only use the suffix since that's the distinguishing part of the alias, i.e. "engage_titans"
		return

	owner.s.autoTitanLastEngageCalloutTime = Time()
	owner.s.autoTitanLastEngageCallout = aliasSuffix //Only use the suffix since that's the distinguishing part of the alias, i.e. "engage_titans"

	local soundAlias = GenerateTitanOSAlias( owner, aliasPrefix, aliasSuffix )
	//printt( "Attempting to play AutoTitanConversation: " + soundAlias )

	local conversationID = GetConversationIndex( soundAlias )
	Remote.CallFunction_Replay( owner, "ServerCallback_PlayConversation", conversationID )
}


function SetupFollowTitan( npcTitan, player )
{
	//npcTitan.SetUsableByGroup( "" )
	SoulBecomesOwnedByPlayer( npcTitan.GetTitanSoul(), player )

	NPCTitanFollowPilotInit( npcTitan, player )
	if ( "guardModePoint" in npcTitan.s && IsValid( npcTitan.s.guardModePoint ) )
	{
		npcTitan.s.guardModePoint.Kill()
		delete npcTitan.s.guardModePoint
	}

	NPCTitanGuardModeInit( npcTitan )

	npcTitan.SetEnemyChangeCallback( "AutoTitanChangedEnemy" )

	NPCTitanEnableCurrentMode( npcTitan, player )

	if ( PlayerHasPassive( player, PAS_ENHANCED_TITAN_AI ) )
	{
		npcTitan.kv.WeaponProficiency = 4
	}

	npcTitan.GetNewEnemyFromSound( true )
	UpdateEnemyMemoryFromTeammates( npcTitan )

	SetPlayerPetTitan( player, npcTitan )

	SetupNPC_TitanTitle( npcTitan, player )

	thread TitanNPC_Think( npcTitan )

	npcTitan.UnsetUsable()
}


function FreeAutoTitan( npcTitan )
{
	if ( "guardModePoint" in npcTitan.s && IsValid( npcTitan.s.guardModePoint ) )
	{
		npcTitan.s.guardModePoint.Kill()
		//delete npcTitan.s.guardModePoint
	}

	//npcTitan.SetEnemyChangeCallback( "" )

	local bossPlayer = npcTitan.GetBossPlayer()

	if ( !IsValid( bossPlayer ) )
		return

	bossPlayer.SetPetTitan( null )

	local soul = npcTitan.GetTitanSoul()

	npcTitan.ClearBossPlayer()
	soul.ClearBossPlayer()

	npcTitan.SetTitle( "" )
	npcTitan.SetShortTitle( "" )

	npcTitan.Signal( "TitanStopsThinking" )
	npcTitan.UnsetUsable()

	thread TitanKneel( npcTitan )
}


//////////////////////////////////////////////////////////
function SetupAutoTitan( npcTitan, player )
{
	npcTitan.SetUsePrompts( "#HOLD_TO_EMBARK", "#PRESS_TO_EMBARK" )
	npcTitan.SetUsableByGroup( "owner pilot" )

	NPCTitanFollowPilotInit( npcTitan, player )
	if ( "guardModePoint" in npcTitan.s && IsValid( npcTitan.s.guardModePoint ) )
	{
		npcTitan.s.guardModePoint.Kill()
		delete npcTitan.s.guardModePoint
	}

	NPCTitanGuardModeInit( npcTitan )

	npcTitan.SetEnemyChangeCallback( "AutoTitanChangedEnemy" )

	NPCTitanEnableCurrentMode( npcTitan, player )

	if ( PlayerHasPassive( player, PAS_ENHANCED_TITAN_AI ) )
	{
		npcTitan.kv.WeaponProficiency = 4
	}

	npcTitan.GetNewEnemyFromSound( true )
	UpdateEnemyMemoryFromTeammates( npcTitan )

	SetPlayerPetTitan( player, npcTitan )

	SetupNPC_TitanTitle( npcTitan, player )
}

function SetPlayerPetTitan( player, npcTitan )
{
	if ( npcTitan == player.GetPetTitan() )
		return

	local previousOwner = GetPetTitanOwner( npcTitan )
	if ( IsValid( previousOwner ) )
	{
		previousOwner.SetPetTitan( null )
	}

	if ( IsAlive( player.GetPetTitan() ) )
	{
		// kill old pet titan
		player.GetPetTitan().Die( null, null, { scriptType = DF_INSTANT, damageSourceId = eDamageSourceId.suicide } )
	}

	player.SetPetTitan( npcTitan )
	npcTitan.SetTeam( player.GetTeam() )
	//npcTitan.SetTitle( "#NPC_AUTO_TITAN" )
}


//////////////////////////////////////////////////////////
function NPCTitanFollowPilotInit( npcTitan, player )
{
	npcTitan.InitFollowBehavior( player, AIF_TITAN_FOLLOW_PILOT )
	npcTitan.EnableBehavior( "Follow" )
}

//////////////////////////////////////////////////////////
function NPCTitanGuardModeInit( npcTitan )
{
	local point = CreateEntity( "assault_assaultpoint" )

	point.kv.allowdiversionradius = 200
	point.kv.allowdiversion = 0
	point.kv.faceAssaultPointAngles = 1
	point.kv.assaulttolerance = 120
	point.kv.nevertimeout = 1
	point.kv.strict = 1
	point.kv.forcecrouch = 0
	point.kv.spawnflags = 0
	point.kv.clearoncontact = 0
	point.kv.assaulttimeout = 3.0
	point.kv.arrivaltolerance = 350

	npcTitan.s.guardModePoint = point
}

//////////////////////////////////////////////////////////
function NPCTitanInitModeOnPlayerRespawn( player )
{
	if ( IsValid( player.GetPetTitan() ) )
	{
		local titan = player.GetPetTitan()

		switch ( player.GetPetTitanMode() )
		{
			case eNPCTitanMode.FOLLOW:
				NPCTitanFollowPilotInit( titan, player )
				break;

			default:
				// nothing to do for other modes
				break;
		}
	}
}


/*
//////////////////////////////////////////////////////////
function OnPlayerDisconnectOrTeamChange( npcTitan, player )
{
	npcTitan.EndSignal( "OnDestroy" )
	WaitSignal( player, "Disconnected", "TeamChange" )

	npcTitan.TakeDamage( npcTitan.GetMaxHealth(), null, null, { forceKill = true, melee = false, damageSourceId = eDamageSourceId.team_switch } )
}
*/


//////////////////////////////////////////////////////////
function CodeCallback_PlayerRequestClimbInNPCTitan( npcTitan, player )
{
}


//////////////////////////////////////////////////////////
function CreateSpawnNPCTitanTemplate( team, settings )
{
	local table = {}
	table.angles    <- null
	table.origin    <- null
	table.model     <- null
	table.team      <- null
	table.health    <- null
	table.maxHealth <- null
	table.noSoul    <- null
	table.settings  <- null
	table.hidden    <- null
	table.skin      <- null
	table.weapon	<- null
	table.weaponMod <- null
	table.title		<- null
	table.decal 	<- null

	

	SetModelSkinFromSettings( table, settings, team ) // Use the table-populating function
	table.team      = team
	table.settings  = settings

	return table
}

function CreateDefaultNPCTitanTemplate( team )
{
	local settings 	= null
	local table 	= CreateSpawnNPCTitanTemplate( team, settings )
	table.health 	= 5000
	table.maxHealth	= table.health
	table.weapon 	= "mp_titanweapon_xo16"

	return table
}

//////////////////////////////////////////////////////////
function CreateNPCTitanForPlayer( player, origin, angles, delayedCreation = false )
{
	local team = player.GetTeam()
	local settings = GetTitanForPlayer( player )

	Assert( settings != null, "No titan data for " + player )

	local table = 	CreateSpawnNPCTitanTemplate( team, settings )
	table.angles	<- angles
	table.origin    <- origin
	table.delayedCreation <- delayedCreation

	SetModelSkinAndHealthOnNPCTitanTable( table, settings, team )

	local npcTitan = SpawnNPCTitan( table )
	local soul = npcTitan.GetTitanSoul()


	soul.SetSoulOwner( npcTitan )
	soul.lastOwner = player
	SoulBecomesOwnedByPlayer( soul, player )
	SetupAutoTitan( npcTitan, player )

	if (!delayedCreation)
		GiveTitanWeaponsForPlayer( player, npcTitan )

	SetTitanOSForPlayer( player )
	//table.core = SetTitanCoreForPlayer( player )

	if ( !IsTrainingLevel())
		SetDecalForTitan( player )
		//SetTitanCoreForPlayer( player )

	// start a new titan building when the current titan dies
	AddSoulDeathFunc( UpdateSoulDeath )

	return npcTitan
}

function UpdateSoulDeath( soul )
{
	printt("call UpdateSoulDeath")
	local player = soul.GetBossPlayer()

	if ( !IsValid( player ) )
		return

	player.SetTitanDeployed( false )

	if( !player.IsTitan() )
		StartTitanBuildProgress( player )

	player.OnDestroyTitan()

	ClearPlayerActiveObjective( player )
}


//////////////////////////////////////////////////////////
function CreateNPCTitanFromSettings( settings, team, origin, angles, noSoul = false, hidden = false )
{
	local table = CreateSpawnNPCTitanTemplate( team, settings )
	table.angles	<- angles
	table.origin    <- origin
	table.noSoul    <- noSoul
	table.hidden    <- hidden

	SetModelSkinAndHealthOnNPCTitanTable( table, settings, team )

	local titan = SpawnNPCTitan( table )
	return titan
}

// Populates model and skin fields within a table based on settings and team
function SetModelSkinFromSettings( table, settings, team )
{
	if ( settings && GetPlayerSettingsFieldForClassName( settings, team == TEAM_MILITIA ? "bodymodel_militia" : "bodymodel_imc" ) != "" )
		table.model  = GetPlayerSettingsFieldForClassName( settings, team == TEAM_MILITIA ? "bodymodel_militia" : "bodymodel_imc" )
	else
		table.model = ATLAS_MODEL
	table.skin = team == TEAM_MILITIA ? 1 : 0

}

// Applies model and skin directly to an entity based on settings and team
function ApplyModelSkinToEntity( entity, settings, team )
{
	if ( !IsValid( entity ) ) return

	local modelName
	if ( settings )
		modelName = GetPlayerSettingsFieldForClassName( settings, team == TEAM_MILITIA ? "bodymodel_militia" : "bodymodel_imc" )

	if ( modelName && modelName != "" )
	{
		entity.SetModel( modelName )

		local skin = team == TEAM_MILITIA ? 1 : 0

		entity.SetSkin( skin )
		printt("[ApplyModelSkinToEntity] Set model '" + modelName + "' and skin '" + skin + "' for team " + team + " on entity " + entity)
	}
	else
	{
		printt("[ApplyModelSkinToEntity] Warning: Could not determine model for settings '" + settings + "' and team " + team)
	}
}


//////////////////////////////////////////////////////////
function SetModelSkinAndHealthOnNPCTitanTable( table, settings, team )
{
	SetModelSkinFromSettings( table, settings, team ) // Use the table-populating function

	table.health    = GetPlayerSettingsFieldForClassName_Health( settings )
	table.maxHealth = table.health
}


//////////////////////////////////////////////////////////
function SpawnNPCTitan( table )
{
	local angles	 = table.angles
	local origin     = table.origin
	local model      = table.model
	local team       = table.team
	local health     = table.health
	local maxHealth  = table.maxHealth
	local noSoul     = table.noSoul
	local hidden 	 = table.hidden
	local settings   = table.settings
	local skin       = table.skin
	local weapon 	 = table.weapon
	local decal      = table.decal

	if ( !settings )
		settings = "titan_atlas"

	local npcTitan

	npcTitan = CreateEntity( "npc_titan" )
	npcTitan.kv.spawnflags = 131072 | 512 | 4 // don't drop grenade, fall to ground, fade corpse
	npcTitan.kv.alwaysalert = 1
	npcTitan.kv.reactChance = 100

	if ( health == null )
	{
		health = GetPlayerSettingsFieldForClassName_Health( settings )
		maxHealth = health
	}

	npcTitan.kv.health = health
	npcTitan.kv.max_health = maxHealth
	npcTitan.kv.physdamagescale = 1.0
	npcTitan.kv.NumGrenades = 0
	npcTitan.kv.alwaysalert = 1
	npcTitan.kv.reactChance = 0
	npcTitan.kv.teamnumber = team
	npcTitan.kv.maxEnemyDist = 16000
	npcTitan.SetTeam( team )
	SetTitanAccuracyAndProficiency( npcTitan, Riff_AILethality() )

	npcTitan.SetModel( model )
	npcTitan.SetSkin( skin )

	if ( hidden	)
	{
		npcTitan.MakeInvisible()

		//npcTitan.Hide()
        //
		//// hack hide() should be enough
		//npcTitan.kv.rendermode = 3
		//npcTitan.kv.renderamt = 0
	}

	npcTitan.SetOrigin( origin )
	npcTitan.SetAngles( angles )

	npcTitan.s.spawnWithoutSoul <- false

	npcTitan.s.titanSettings <- settings
	npcTitan.s.guardModePoint <- null

	DispatchSpawn( npcTitan, true )

	npcTitan.SetAllowJump( false )	// need to setup traverse animations
	npcTitan.StayPut( true )
	npcTitan.SetAISettings( "titan" )
	npcTitan.SetEngagementDistVsStrong( 0, 4000 )

	ApplyTitanColor(npcTitan, settings)

	if (table.weapon)
	{
		if(table.weaponMod)
			npcTitan.GiveWeapon(table.weapon, table.weaponMod)
		else
			npcTitan.GiveWeapon(table.weapon)
	}

	if (table.title)
	{
		npcTitan.SetTitle( table.title )
		npcTitan.SetShortTitle( table.title )
	}

	return npcTitan
}

function SetTitanAccuracyAndProficiency( npcTitan, lethality )
{
	local accuracyMultiplier = 1.0
	local weaponProficiency = 3

	//only reduce enemy titans
	if ( GAMETYPE == COOPERATIVE && lethality != eAILethality.Default && npcTitan.GetTeam() == TEAM_IMC )
	{
		switch ( lethality )
		{
			case eAILethality.TD_Low:
				accuracyMultiplier = 0.75
				weaponProficiency = 1
				break

			case eAILethality.TD_Medium:
				accuracyMultiplier = 0.75
				weaponProficiency = 2
				break
		}
	}

	npcTitan.kv.AccuracyMultiplier = accuracyMultiplier
	npcTitan.kv.WeaponProficiency = weaponProficiency
}
Globalize( SetTitanAccuracyAndProficiency )


//////////////////////////////////////////////////////////
function TitanEyeGlow( titan )
{
	local camera_eye_color = "255 128 64 255"  //was 255 255 128 (yellow)

	//warning light
	local env_sprite = CreateEntity( "env_sprite" )
//	env_sprite.SetOrigin( rocket_pod_origin )
//	titan.GetAttachmentOrigin( titan.LookupAttachment( "CAMERA_EYE" ) )
//	titan.s.laserScanAttachPoint <- "CAMERA_EYE"
	//env_sprite.SetParent( titan, "CAMERA_EYE_FRONT" )
	env_sprite.SetParent( titan, "CAMERA_EYE" )
	env_sprite.kv.rendermode = 5
	env_sprite.kv.rendercolor = "255 128 64 255"  //orange
//	env_sprite.kv.rendercolor = camera_eye_color //bright yellow
	env_sprite.kv.model = "sprites/glow_05.vmt"
	env_sprite.kv.scale = "0.1"
	env_sprite.kv.GlowProxySize = 16.0
	env_sprite.kv.HDRColorScale = 1.0
	DispatchSpawn( env_sprite, false )
	if( !("eye_glow" in titan.s ) )
		titan.s.eye_glow <- env_sprite
	else
		titan.s.eye_glow = env_sprite
}


//////////////////////////////////////////////////////////
function TitanLaserScan_Cleanup( titan )
{
	titan.Signal( "laserscan_off" )

	foreach( thing in titan.s.laserArray )
		thing.Kill()
	foreach( thing in titan.s.laserTargetArray )
		thing.Kill()

	titan.s.laserscanSfxEmitter.Kill()
	titan.s.laserscanTargetSfxEmitter.Kill()
}


//HACK HACK HACK. For Trailer team. Do not ship!
function ClientCommand_TrailerTitanDrop( player )
{
	local spawnPoint = GetTitanReplacementPoint( player, false )
	thread DropNPCTitanForTrailer( player, spawnPoint )
	return true
}

function DropNPCTitanForTrailer( player, spawnPoint )
{
	local origin = spawnPoint.origin
	local angles
	if ( spawnPoint.angles )
		angles = spawnPoint.angles
	else
		angles = VectorToAngles( FlattenVector( player.GetViewVector() ) * -1 )	// face the player

	printt( "Dropping NPC titan at " + origin + " with angles " + angles )

	local titanDataTable = GetPlayerClassDataTable( player, "titan" )
	local settings = titanDataTable.playerSetFile

	local titan = CreateNPCTitanFromSettings( settings, player.GetTeam(), origin, angles )
	GiveTitanWeaponsForPlayer( player, titan )
	waitthread SuperHotDrop( titan, "at_hotdrop_drop_2knee_turbo_upgraded", origin, angles )
}
