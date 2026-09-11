const ACTIVE_BURN_CARD_PREVIEW = 1
const USE_PROMPT_SIZE = 75
const DAMAGEHUD_SIZE = 512
const DAMAGEHUD_HALFSIZE = 256
const DAMAGEHUD_ALTPOS = 0
const DAMAGEHUD_INDICATOR_DURATION = 2.0
const HEALTH_BAR_ENTITY_TIME = 8.0

const STEALTH_TEAM_JUMPJET_ON = "P_jump_jet_stealth"
const STEALTH_TEAM_JUMPJET_DBL = "P_jump_jet_stealth_DBL"
const STEALTH_TEAM_JUMPJET_WR = "P_jump_jet_stealth"

const STEALTH_PENEMY_JUMPJET_ON = "P_jump_jet_stealth"
const STEALTH_PENEMY_JUMPJET_DBL = "P_jump_jet_stealth_DBL"
const STEALTH_PENEMY_JUMPJET_WR = "P_jump_jet_stealth"

const TEAM_JUMPJET_ON = "P_team_jump_jet_ON"
const TEAM_JUMPJET_RT = "P_team_jump_jet_RT"
const TEAM_JUMPJET_DBL = "P_team_jump_jet_DBL"
const TEAM_JUMPJET_WR = "P_team_jump_jet_WR"

const PENEMY_JUMPJET_ON = "P_enemy_jump_jet_ON"
const PENEMY_JUMPJET_RT = "P_enemy_jump_jet_RT"
const PENEMY_JUMPJET_DBL = "P_enemy_jump_jet_DBL"
const PENEMY_JUMPJET_WR = "P_enemy_jump_jet_WR"

const DAMAGE_ARROW_MODEL = "models/weapons/bullets/damage_arrow.mdl"

const DAMAGEHUD_GRENADE_FADEOUT_DIST = 200				// Once the player is out of the blast radius of the grenade the arrow fades out over this distance from the edge of the blast radius
const DAMAGEHUD_GRENADE_INDICATOR_SCALE_MIN = 1.0		// Min size for a grenade indicator arrow
const DAMAGEHUD_GRENADE_INDICATOR_SCALE_MAX = 3.0		// Max size for a grenade indicator arrow
const DAMAGEHUD_GRENADE_INDICATOR_ICON_SCALE_MIN = 0.8	// Min size for the grenade indicator icon
const DAMAGEHUD_GRENADE_INDICATOR_ICON_SCALE_MAX = 1.5	// Max size for the grenade indicator icon
const DAMAGEHUD_GRENADE_DEBOUNCE_TIME = 0.5
const DAMAGEHUD_DAMAGE_MIN_PILOT = 25		// Grenade indicator for pilots scales between min/max size when damage from threat scales between these mins/maxs
const DAMAGEHUD_DAMAGE_MAX_PILOT = 350
const DAMAGEHUD_DAMAGE_MIN_TITAN = 200		// Grenade indicator for titans scales between min/max size when damage from threat scales between these mins/maxs
const DAMAGEHUD_DAMAGE_MAX_TITAN = 900

const DAMAGEARROW_DURATION = 2.5

function main()
{
	Globalize( InitLoadoutReminder )
	Globalize( DirectUsePromptDraw )
	Globalize( HideLoadoutHint )
	Globalize( ShowLoadoutHint )
	Globalize( ClientCodeCallback_PlayerDidDamage )
	Globalize( ClientCodeCallback_PlayerSpawned )
	Globalize( CodeCallback_OnHudReloadScheme )
	Globalize( CodeCallback_HUDThink )
	Globalize( Player_AddPlayer )
	Globalize( Player_AddClient )
	Globalize( ShowScriptHUD )
	Globalize( HideScriptHUD )
	Globalize( StopUsePrompt )
	Globalize( DrawUsePrompt )
	Globalize( ServerCallback_PlayerConnectedOrDisconnected )
	Globalize( CodeCallback_PlayerDisconnected )
	Globalize( ServerCallback_PlayerChangedTeams )
	Globalize( ClientCodeCallback_BodyGroupChanged )
	Globalize( ClientCodeCallback_OnModelChanged )
	Globalize( ServerCallback_TitanTookDamage )
	Globalize( ServerCallback_PilotTookDamage )
	Globalize( ServerCallback_RodeoerEjectWarning )
	Globalize( OnHumanJumpJetDBL )
	Globalize( OnHumanJumpJet )
	Globalize( ServerCallback_PlayScreenFXWarpJump )
	Globalize( PlayShieldBreakEffect )
	Globalize( HandleDoomedState )
	Globalize( TitanReadyMessage )
	Globalize( CoreReadyMessage )

	Globalize( InitEntityForModel )

	Globalize( OnClientPlayerAlive )
	Globalize( OnClientPlayerDying )

	Globalize( SetHealthBarEntity )
	Globalize( GetHealthBarEntity )

	Globalize( ClientCodeCallback_DodgeStart )
	Globalize( Pressed_TitanNextMode )
	Globalize( ClientCodeCallback_OnMissileCreation )
	Globalize( CodeCallback_OnGib )
	Globalize( ShouldDrawHUD )
	Globalize( ClientPilotSpawned )
	Globalize( ClientCodeCallback_OnHealthChanged )
	Globalize( ClientCodeCallback_OnCrosshairTargetChanged )
	Globalize( GetHealthBarTargetEntity )
	Globalize( AddCallback_OnPlayerDisconnected )

	Globalize( IsPlayerEliminated )

	Globalize( ToggleGrenadeIndicators )

	Globalize( ServerCallback_GiveMatchLossProtection )

	PrecacheParticleSystem( "death_pinkmist_LG" )
	PrecacheParticleSystem( "death_pinkmist_LG_nochunk" )

	PrecacheParticleSystem( "hit_confirm_out" )
	PrecacheParticleSystem( "hit_confirm_kill" )
	PrecacheParticleSystem( "xo_spark_bolt" )

	//Jumpjets
	PrecacheParticleSystem( PENEMY_JUMPJET_ON )
	PrecacheParticleSystem( TEAM_JUMPJET_ON )
	PrecacheParticleSystem( PENEMY_JUMPJET_RT )
	PrecacheParticleSystem( TEAM_JUMPJET_RT )
	PrecacheParticleSystem( PENEMY_JUMPJET_DBL )
	PrecacheParticleSystem( TEAM_JUMPJET_DBL )
	PrecacheParticleSystem( PENEMY_JUMPJET_WR )
	PrecacheParticleSystem( TEAM_JUMPJET_WR )

	//Stealth Jumpjets
	PrecacheParticleSystem( STEALTH_PENEMY_JUMPJET_ON )
	PrecacheParticleSystem( STEALTH_TEAM_JUMPJET_ON )
	PrecacheParticleSystem( STEALTH_PENEMY_JUMPJET_DBL )
	PrecacheParticleSystem( STEALTH_TEAM_JUMPJET_DBL )
	PrecacheParticleSystem( STEALTH_PENEMY_JUMPJET_WR )
	PrecacheParticleSystem( STEALTH_TEAM_JUMPJET_WR )

	PrecacheParticleSystem( "xo_damage_exp_1" )
	PrecacheParticleSystem( "P_wpn_grenade_frag_icon" )
	PrecacheParticleSystem( "P_wpn_grenade_frag_blue_icon" )
	PrecacheParticleSystem( "P_burn_player" )

	const FLAG_FX_FRIENDLY = "P_flag_fx_friend"
	const FLAG_FX_ENEMY = "P_flag_fx_foe"

	PrecacheParticleSystem( FLAG_FX_FRIENDLY )
	PrecacheParticleSystem( FLAG_FX_ENEMY )

	RegisterSignal( "OnAnimationDone" )
	RegisterSignal( "OnAnimationInterrupted" )
	RegisterSignal( "OnModelChanged" )
	RegisterSignal( "HealthChanged" )
	RegisterSignal( "CrosshairTargetChanged" )
	RegisterSignal( "HealthBarEntityTargetChanged" )
	RegisterSignal( "DoomedTarget" )
	RegisterSignal( "CriticalHitReceived" )
	RegisterSignal( "PanelAlphaOverTime" )
	RegisterSignal( "ChangedOnDeckBurncard" )

	FlagInit( "DamageDistancePrint" )
	FlagInit( "EnableTitanModeChange" )
	level.flags[ "EnableTitanModeChange" ] = true
	level.vduOpen <- false
	level.canSpawnAsTitan <- false
	level.lastFadeParams <- { r = 0, g = 0, b = 0, a = 0, blend = false }
	level.screenFade <- null
	level.grenadeIndicatorEnabled <- true
	level.clientsLastKiller <- null

	AddCreateCallback( "player", SetupPlayerAnimEvent )
	AddCreateCallback( "player", InitSVariables )
	AddCreateCallback( "first_person_proxy", SetupFirstPersonProxyEvents )

	if ( !IsLobby() )
	{
		RegisterServerVarChangeCallback( "eliminatedPlayers", UpdateRespawnHUD )
		RegisterServerVarChangeCallback( "gameEndTime", UpdateRespawnHUD )
	}

	AddCreateCallback( "item_healthcore", CreateCallback_HealthCore )

	AddCreateCallback( "titan_soul", CreateCallback_TitanSoul )

	AddCreateCallback( "titan_cockpit", DamageArrow_CockpitInit )

	file.orbitalstrike_tracer <- PrecacheParticleSystem( "Rocket_Smoke_Large" )
        //DEBUG Remove when bug is fixed.
	file.law_missile_tracer <- PrecacheParticleSystem( "wpn_orbital_rocket_tracer" )

	file.usePrompt <- null
	level.menuHideGroups <- {}

	file.damageArrows <- []
	file.currentDamageArrow <- 0
	file.numDamageArrows <- 16
	file.damageArrowFadeDuration <- 1.0
	file.damageArrowTime <- 0.0
	file.damageArrowAngles <- Vector( 0.0, 0.0, 0.0 )
	file.damageArrowPointCenter <- Vector( 0.0, 0.0, 0.0 )

	file.grenadeArrows <- []
	file.currentGrenadeArrow <- 0
	file.numGrenadeArrows <- 16

	//PrecacheParticleSystem( SHIELD_FX )
	PrecacheParticleSystem( SHIELD_BODY_FX )
	PrecacheParticleSystem( SHIELD_BREAK_FX )

	level.spawnAsTitanSelected <- false

	level.onPlayerDisconnectedFuncs <- {}

	level.hasMatchLossProtection <- false

	RegisterConCommandTriggeredCallback( "+useAndReload", PlayerPressed_Rodeo )
	RegisterConCommandTriggeredCallback( "+use", PlayerPressed_Rodeo )

	RegisterConCommandTriggeredCallback( "-useAndReload", PlayerReleased_Rodeo )
	RegisterConCommandTriggeredCallback( "-use", PlayerReleased_Rodeo )

	AddCreateCallback( "player", ClRodeo_OnClientScriptInit )
}

function EntitiesDidLoad()
{
	if ( !IsLobby() )
		InitDamageArrows()
}

function WorldUsePrompt( player )
{
	player.EndSignal( "SettingsChanged" )
	player.EndSignal( "OnDestroy" )
	local usePromptEnt
	local rodeoPromptEnt
	for ( ;; )
	{
		usePromptEnt = GetPlayerUsePromptEnt( player )
		rodeoPromptEnt = GetTitanRodeoPromptEnt( player )

		if ( usePromptEnt != null )
			waitthread DrawWorldUsePrompt( player, usePromptEnt )
		else if ( rodeoPromptEnt != null )
			waitthread DrawTitanRodeoPrompt( player, rodeoPromptEnt )

		wait 0
	}
}

function FindEnemyRodeoParent( player )
{
	local ent = player.GetParent()
	if ( ent == null )
		return null

	if ( !ent.IsTitan() )
		return null

	if ( ent == player.GetPetTitan() )
		return null

	if ( ent.GetTeam() == player.GetTeam() )
		return null

	return ent
}

function GetPlayerUsePromptEnt( player )
{
	if ( player.GetParent() )
		return

	local usePromptEnt = player.GetUsePromptEntity()

	if ( usePromptEnt == null )
		return

	// player may be using his use prompt ent, so dont draw hint
	if ( !usePromptEnt.IsZipline() )
		return

	if ( player.IsZiplining() )
		return

	return usePromptEnt
}

function DrawWorldUsePrompt( player, entity )
{
	OnThreadEnd(
		function () : ( player, entity )
		{
			StopUsePrompt( player, entity )
		}
	)

	DrawUsePrompt( player, entity )
	Assert( entity.IsZipline() )

	for ( ;; )
	{
		if ( player.GetParent() )
			return
		if ( player.GetUsePromptEntity() != entity )
			return
		if ( player.IsZiplining() )
			return

		wait 0
	}
}

function DrawTitanRodeoPrompt( player, entity )
{
	OnThreadEnd(
		function () : ( player, entity )
		{
			StopUsePrompt( player, entity )
		}
	)

	DrawUsePrompt( player, entity )

	for ( ;; )
	{
		if ( HoldToRodeoState( player ) == 0 )
			return

		if ( player.GetParent() )
			return
		if ( player.GetUsePromptEntity() != null )
			return
		if ( player.IsZiplining() )
			return

		// Cant rodeo while wallhanging apparently
		if ( player.IsWallHanging() )
			return

		if ( !IsValidTitanRodeoPromptEnt( player, entity ) )
			return

		wait 0
	}
}

function GetTitanRodeoPromptEnt( player )
{
	local entity = null
	if ( HoldToRodeoState( player ) == 0 )
		return entity

	local titans = GetClientEntArrayBySignifier( "npc_titan" )
	foreach ( target in titans )
	{
		if ( !IsValidTitanRodeoPromptEnt( player, target ) )
			continue

		entity = target
	}

	local players = GetPlayerArray()
	foreach ( target in players )
	{
		if ( !IsValidTitanRodeoPromptEnt( player, target ) )
			continue

		entity = target
	}

	return entity
}
Globalize( GetTitanRodeoPromptEnt )

function IsValidTitanRodeoPromptEnt( player, entity )
{
	if ( !IsAlive( entity ) )
		return false

	if ( !entity.IsTitan() )
		return false

	if ( player.GetPetTitan() && entity.IsNPC() && entity == player.GetPetTitan() )
		return false

	if ( player.GetTeam() != entity.GetTeam() && HoldToRodeoState( player ) == 2 )
		return false

	if ( Distance( player.GetOrigin(), GetTitanHijackOrigin( entity ) ) > 180 )
		return false

	if ( !IsValidTitanRodeoTarget( player, entity ) )
		return false

	if ( player.IsWallHanging() )
		return false

	if ( player.IsOnGround() )
		return false

	return ( PlayerFallingOntoTitan( player, entity ) || FindPlayerJumponSpot( player, entity ) )
}
Globalize( IsValidTitanRodeoPromptEnt )

function ClientCodeCallback_PlayerSpawned( player )
{
	if ( !IsValid( player ) )
		return

	if ( !IsMenuLevel() )
		ClearCrosshairPriority( crosshairPriorityLevel.ROUND_WINNING_KILL_REPLAY )

	// this hits sometimes on replay before player has spawned
	if ( !( "healthBarEntity" in player.s ) )
		return
	// clear the health bar entity on death
	SetHealthBarEntity( player, null )

	// exists on server and client. Clear it when you respawn.
	player.s.recentDamageHistory = []

	if ( player == GetLocalViewPlayer() )
	{
		foreach ( callbackInfo in level.onLocalViewPlayerSpawnedCallbacks )
		{
			callbackInfo.func.acall( [callbackInfo.scope, player] )
		}
	}

	if ( player == GetLocalClientPlayer() )
	{
		foreach ( callbackInfo in level.onLocalClientPlayerSpawnedCallbacks )
		{
			callbackInfo.func.acall( [callbackInfo.scope, player] )
		}
	}

	if ( player.IsTitan() )
	{
		return
	}
	else
	{
		if ( player.GetPlayerClass() == level.pilotClass )
		{
			thread ClientPilotSpawned( player )
		}
	}

	UpdateTitanModeHUD( player )

	if ( !IsValid( player.GetPetTitan() ) && player.GetNextTitanRespawnAvailable() >= 0 && Time() >= player.GetNextTitanRespawnAvailable() )
	{
		thread ShowTitanSpawnHint( player )
	}
}


function ShowTitanSpawnHint( player )
{
	player.EndSignal( "OnDeath" )

	wait 1.0

	if ( IsValid( player.GetPetTitan() ) )
		return

	if ( Time() < player.GetNextTitanRespawnAvailable() )
		return

	TitanReadyMessage( player )
}

function TitanReadyMessage( player )
{
	if ( IsTrainingLevel() )
		return

	if ( !GamePlayingOrSuddenDeath() )
		return

	if ( !IsAlive( player ) )
		return

	AnnouncementMessage( player, "#HUD_TITAN_READY", "#HUD_TITAN_READY_HINT" )
}



function CoreReadyMessage( player )
{
	if ( IsTrainingLevel() )
		return

	if ( !GamePlayingOrSuddenDeath() )
		return

	if ( !IsAlive( player ) )
		return

	if ( player.GetDoomedState() )
		return

	local soul = player.GetTitanSoul()
	local titanType = player.GetPlayerSettingsField( "footstep_type" )

	switch ( titanType )
	{
		case "atlas":
			AnnouncementMessage( player, "#HUD_CORE_ONLINE_ATLAS", "#HUD_CORE_ONLINE_ATLAS_HINT" )
			break

		case "ogre":
			AnnouncementMessage( player, "#HUD_CORE_ONLINE_OGRE", "#HUD_CORE_ONLINE_OGRE_HINT" )
			break

		case "stryder":
			AnnouncementMessage( player, "#HUD_CORE_ONLINE_STRYDER", "#HUD_CORE_ONLINE_STRYDER_HINT" )
			break
		
		default:
			local loop_max = MasterModdedTitans.len()
			for( local E = 0; E < loop_max; E++ )
			{
				if( loop_max > 0 )
				{
					local t_a = MasterModdedTitans[ E ]

					if( t_a.setfile == GetSoulPlayerSettings( soul ) )
					{
						AnnouncementMessage( player, t_a.hud_core_name, t_a.hud_core_hint )
						break
					}
				}
			}
		/*
		case "smart_core":
			AnnouncementMessage( player, "Smart Core Online", "SMART XO-16 loaded and primed." )
			break

		case "missile_core":
			AnnouncementMessage( player, "Ordnance Core Online", "Route reserve power into ordnance system." )
			break
		
		case "bullet_storm":
			AnnouncementMessage( player, "Bullet Storm Online", "High-capacity XO-16 loaded and primed." )
			break
		
		case "piercer_core":
			AnnouncementMessage( player, "Piercer Cannon Online", "Auxillery Cannon cooled and calibrated." )
			break
		
		case "auto_burst_core":
			AnnouncementMessage( player, "Ripper Shotgun Online", "Automatic WYS404 ammuniton loaded." )
			break
		
		case "flight_core":
			AnnouncementMessage( player, "Flight Core Online", "Flight boosters and navigational systems calibrated." )
			break*/
	}
}


function ClientPilotSpawned( player )
{
	player.EndSignal( "SettingsChanged" )
	player.EndSignal( "OnDestroy" )
	player.EndSignal( "OnDeath" )

	if ( player == GetLocalViewPlayer() )
	{
		thread WorldUsePrompt( player )
	}
	else
	{
		thread ParentedPlayerJets( player )
	}

	for ( ;; )
	{
		if ( player.PlayerLunge_IsLunging() )
		{
			OnHumanJumpJetDBL( player )
			wait 0.1
		}

		wait 0
	}
}

function ParentedPlayerJets( player )
{
	player.EndSignal( "SettingsChanged" )
	player.EndSignal( "OnDestroy" )

	local parentEnt
	for ( ;; )
	{
		parentEnt = player.GetParent()
		if ( DisplayParentEntJumpJets( player, parentEnt ) )
		{
			waitthread ParentEntJumpJetsActive( player )
		}
		wait 0
	}
}

function DisplayParentEntJumpJets( player, parentEnt )
{
	if ( !IsAlive( parentEnt ) )
		return false

	if ( !parentEnt.IsTitan() )
		return false

	return parentEnt != player.GetPetTitan()
}

function ParentEntJumpJetsActive( player )
{
	local fxID
	local lightID
	if ( PlayerHasPassive( player, PAS_STEALTH_MOVEMENT ) ) //Has to be here as opposed to in SetupPlayerAnimEvent because players can switch classes/get the Stealth Movement Mod mid game
	{
		//printt( "Stealth Jumpjets, ParentEntJumpJetsActive" )
		if ( player.GetTeam() == GetLocalViewPlayer().GetTeam() )
		{
			fxID = GetParticleSystemIndex( STEALTH_TEAM_JUMPJET_ON )
			lightID = null
		}
		else
		{
			fxID = GetParticleSystemIndex( STEALTH_PENEMY_JUMPJET_ON )
			lightID = null
		}
	}
	else
	{
		if ( player.GetTeam() == GetLocalViewPlayer().GetTeam() )
		{
			fxID = GetParticleSystemIndex( TEAM_JUMPJET_ON )
			lightID = GetParticleSystemIndex( TEAM_JUMPJET_RT )
		}
		else
		{
			fxID = GetParticleSystemIndex( PENEMY_JUMPJET_ON )
			lightID = GetParticleSystemIndex( PENEMY_JUMPJET_RT )
		}
	}

	local attachIndexLeft = player.LookupAttachment( "vent_left" )
	local attachIndexRight = player.LookupAttachment( "vent_right" )

	if ( attachIndexLeft == 0 || attachIndexRight == 0 )
		return

	local leftJumpJet = StartParticleEffectOnEntity( player, fxID, FX_PATTACH_POINT_FOLLOW, attachIndexLeft )
	local rightJumpJet = StartParticleEffectOnEntity( player, fxID, FX_PATTACH_POINT_FOLLOW, attachIndexRight )

	local particleEffects = [ leftJumpJet, rightJumpJet ]

	local jumpJetLight

	if ( lightID )
	{
		jumpJetLight = StartParticleEffectOnEntity( player, lightID, FX_PATTACH_POINT_FOLLOW, attachIndexRight )
		particleEffects.append( jumpJetLight )

	}

	OnThreadEnd(
		function () : ( particleEffects )
		{
			foreach ( particle in particleEffects )
			{
				if ( EffectDoesExist( particle ) )
				{
					EffectStop( particle, true, true )
				}
			}
		}
	)


	local parentEnt
	for ( ;; )
	{
		parentEnt = player.GetParent()
		if ( !DisplayParentEntJumpJets( player, parentEnt ) )
			break
		wait 0
	}

}

function InitSVariables( player, isRecreate )
{
	player.s._menus <- {}
	player.s._hudMenus <- {}

	player.s._activeMenus <- []

	player.s.yMoveDir <- 0
	player.s.yMoveDirMenu <- 0
	player.s.xMoveDir <- 0
	player.s.xMoveDirMenu <- 0
	player.s.activeTraps <- {}

	player.s.wasDoomed <- false

	// exists on server and client.
	player.s.recentDamageHistory <- []

	// Rank chip dialogue
	player.s.rankChipDialogActive 		<- false
	player.s.rankChipDialogAliasList 	<- []
}

function Player_AddClient( player )
{
	// Dont remove this line. Fixes SP levels that artists still use like "model_viewer"
	if ( IsSingleplayer() )
	{
		player.SetAbilityBinding( 1, "+scriptCommand2", "-scriptCommand2" )
		player.SetAbilityBinding( 2, "+exit", "-exit" )
		player.SetAbilityBinding( 3, "+jump", "-jump" )
		player.SetAbilityBinding( 4, "+jump", "-jump" )
		player.SetAbilityBinding( 5, "+offhand2", "-offhand2" )
	}

	if ( IsMultiplayer() )
		RegisterConCommandTriggeredCallback( "+scriptCommand2", Pressed_TitanNextMode )

	Create_DamageIndicatorHUD()

	if ( !IsLobby() )
	{
		if ( IsMultiplayer() )
			player.InitHudElem( "CrosshairWeakHitIndicator" )

		player.EnableHealthChangedCallback()

		player.cv.deathTime <- 0

		if ( IsMultiplayer() )
		{
			level.screenFade = HudElement( "ScreenFade" )

			ScoreboardInitValues()
			thread CinematicIntroScreen()
		}
	}
}

function Player_AddPlayer( player )
{
	player.s.crosshairEntity <- null
	player.s.healthBarEntity <- null

	player.s.weaponUpdateData <- {}

	player.s.trackedAttackers <- {} // for titans
	player.classChanged = true
}

const AUTO_TITAN_GUARD_MODE_DIAG_PREFIX = "diag_gs_titan"
const AUTO_TITAN_GUARD_MODE_DIAG_SUFFIX = "_guard"
const AUTO_TITAN_GUARD_MODE_SOUND = "Menu_TitanAIMode_Guard"
const AUTO_TITAN_FOLLOW_MODE_DIAG_PREFIX = "diag_gs_titan"
const AUTO_TITAN_FOLLOW_MODE_DIAG_SUFFIX = "_follow"
const AUTO_TITAN_FOLLOW_MODE_SOUND = "Menu_TitanAIMode_Follow"

function Pressed_TitanNextMode( player )
{
	if ( player.IsTitan() )
		return

	if ( !IsAlive( player ) )
		return

	if ( !IsAlive( player.GetPetTitan() ) )
	{
      	printt( player.GetEntIndex(), "Requested replacement Titan from eye pos " + player.EyePosition() + " view angles " + player.EyeAngles() + " player origin " + player.GetOrigin() + " map " + GetMapName() )

		player.ClientCommand( "ReplacementTitan" ) //Send client command regardless of whether we can call the titan in or not. Server decides

		if ( player.cv.announcementActive && player.cv.announcementActive.messageText == "#HUD_TITAN_READY" )
		{
			level.ent.Signal( "AnnoucementPurge" )
		}

		//PlayMusic( "Music_FR_Militia_TitanFall1" )
		EmitSoundOnEntity( player, "titan_callin" )
		return
	}

	if ( !Flag( "EnableTitanModeChange" ) )
		return

	// cannot change modes while titan is incoming
	if ( player.GetHotDropImpactTime() )
		return

	player.ClientCommand( "TitanNextMode" )

	local newMode = player.GetPetTitanMode() + 1
	if ( newMode == eNPCTitanMode.MODE_COUNT )
		newMode = eNPCTitanMode.FOLLOW

	SetAutoTitanModeHudIndicator( player, newMode )

	local guardModeAlias = GenerateTitanOSAlias( player, AUTO_TITAN_GUARD_MODE_DIAG_PREFIX, AUTO_TITAN_GUARD_MODE_DIAG_SUFFIX )
	local followModeAlias = GenerateTitanOSAlias( player, AUTO_TITAN_FOLLOW_MODE_DIAG_PREFIX, AUTO_TITAN_FOLLOW_MODE_DIAG_SUFFIX )

	// prevent the sounds from stomping each other if button is pressed rapidly
	StopSoundOnEntity( player, guardModeAlias )
	StopSoundOnEntity( player, AUTO_TITAN_GUARD_MODE_SOUND )
	StopSoundOnEntity( player, followModeAlias )
	StopSoundOnEntity( player, AUTO_TITAN_FOLLOW_MODE_SOUND )

	if ( newMode == eNPCTitanMode.FOLLOW )
	{
		EmitSoundOnEntity( player, followModeAlias )
		EmitSoundOnEntity( player, AUTO_TITAN_FOLLOW_MODE_SOUND )
	}
	else if ( newMode == eNPCTitanMode.STAY )
	{
		EmitSoundOnEntity( player, guardModeAlias )
		EmitSoundOnEntity( player, AUTO_TITAN_GUARD_MODE_SOUND )
	}
}

function CodeCallback_OnHudReloadScheme()
{
	foreach ( elem in level.g_hudElems )
	{
		if ( elem.ownerHud != Hud )
			continue

		elem.UpdateVisibility()
	}

	level.screenFadeElement.Hide()
}

function CodeCallback_HUDThink()
{
	if ( IsLobby() )
		return

	PerfStart( PerfIndexClient.CodeCallback_HUDThink )

	local player = GetLocalViewPlayer()

	if ( !("playerScriptsInitialized" in player.s ) )
		return

	if ( !IsMenuLevel() )
	{
		if ( IsMultiplayer() )
		{
			PerfStart( PerfIndexClient.CodeCallback_HUDThink_4 )
			if ( OPERATOR_SELECTION_ENABLED && ( player.GetPlayerClass() == "dronecontroller" ) )
				OperatorSelectionThink( player )

			ScoreSplashThink()
			GameState_Think()
			PerfEnd( PerfIndexClient.CodeCallback_HUDThink_4 )

			PerfStart( PerfIndexClient.CodeCallback_HUDThink_5 )
			UpdateVoiceHUD()
			UpdateVDUVisibility( GetLocalClientPlayer() )
			DebugDrawThink( player )
			PerfEnd( PerfIndexClient.CodeCallback_HUDThink_5 )

			UpdateScreenFade()

			local clientPlayer = GetLocalClientPlayer()
			if ( !IsWatchingKillReplay() && clientPlayer.classChanged )
				ClientPlayerClassChanged( clientPlayer, clientPlayer.GetPlayerClass() )
		}

		PerfStart( PerfIndexClient.CodeCallback_HUDThink_6 )
		SmartAmmo_LockedOntoWarningHUD_Update()
		Flyout_Update()
		InfoFlyout_Update()
		PlayerWeaponFlyout( player )
		PilotLauncher_ScreenUpdate()
		PerfEnd( PerfIndexClient.CodeCallback_HUDThink_6 )

		local activeWeapon = player.GetActiveWeapon()
		if( IsValid( activeWeapon ) && activeWeapon.GetClassname() == "mp_titanweapon_arc_cannon" )
			UpdateArcCannonCrosshair( player, activeWeapon )

		//PerfStart( PerfIndexClient.UpdateCrosshair )
		//UpdateCrosshair()
		//PerfEnd( PerfIndexClient.UpdateCrosshair )
	}

	PerfEnd( PerfIndexClient.CodeCallback_HUDThink )
}

function ClientPlayerClassChanged( player, newClass )
{
	//printl( "ClientPlayerClassChanged to " + player.GetPlayerClass() )
	player.classChanged = false

	level.vduOpen = false // vdu goes away when class changes

	level.meleeHintActive = false // Clear melee message

	Assert( !IsServer() )
	Assert( newClass, "No class " )

	switch ( newClass )
	{
		case "titan":
			player.SetAbilityBinding( 1, "+offhand3", "-offhand3" )
			player.SetAbilityBinding( 2, "+exit", "-exit" )
			player.SetAbilityBinding( 3, "+dodge", "-dodge" )
			player.SetAbilityBinding( 4, "+offhand2", "-offhand2" )
			player.SetAbilityBinding( 5, "+dodge", "-dodge" )

			HideSpectatorSelectButtons( player )
			break

		case level.pilotClass:
			player.SetAbilityBinding( 1, "+scriptCommand2", "-scriptCommand2" )
			player.SetAbilityBinding( 2, "+exit", "-exit" )
			player.SetAbilityBinding( 3, "+jump", "-jump" )
			player.SetAbilityBinding( 4, "+jump", "-jump" )
			player.SetAbilityBinding( 5, "+offhand2", "-offhand2" )

			HideSpectatorSelectButtons( player )

			if ( player.cv.announcementActive && ( player.cv.announcementActive.messageText == "#HUD_CORE_ONLINE_STRYDER" ||
												   player.cv.announcementActive.messageText == "#HUD_CORE_ONLINE_ATLAS" ||
				  								   player.cv.announcementActive.messageText == "#HUD_CORE_ONLINE_OGRE" ) )
			{
				level.ent.Signal( "AnnoucementPurge" )
			}
			break

		case "spectator":
			TryShowSpectatorSelectButtons( player )
			break
	}

	PlayActionMusic()
}

function ShouldShowSpawnAsTitanHint( player )
{
	if ( !IsMultiplayer() )
		return false

	if ( Time() - player.cv.deathTime < GetRespawnButtonCamTime( player ) )
		return false

	if ( GetGameState() < eGameState.Playing )
		return false

	if ( GetGameState() == eGameState.SwitchingSides )
		return false

	return !IsPlayerEliminated( player )
}
Globalize( ShouldShowSpawnAsTitanHint )

if ( IsMultiplayer() )
{
	function ShouldDrawHUD( player )
	{
		if ( GetGameState() <= eGameState.Prematch )
			return false

		if ( IsInScoreboard( player ) )
			return false

		return true
	}

	function ShouldShowDeathHints( attacker )
	{
		if ( !GamePlayingOrSuddenDeath() )
			return false

		if ( Replay_IsEnabled() )
			return !AttackerShouldTriggerReplay( attacker )

		return true
	}
}
else
{
	function ShouldDrawHUD( player )
	{
		return true
	}

	function ShouldShowDeathHints( attacker )
	{
		return false
	}
}

function ShowScriptHUD( player )
{
	if ( !ShouldDrawHUD( player ) )
		return

	foreach ( group in level.menuHideGroups )
		group.Show()

	player.ShowHUD()
	player.SetScriptMenuOff()
}

function HideScriptHUD( player )
{
	foreach ( group in level.menuHideGroups )
		group.Hide()

	player.HideHUD()
	player.SetScriptMenuOn()
}


function ServerCallback_PlayerChangedTeams( player_eHandle, oldTeam, newTeam )
{
	local player = GetEntityFromEncodedEHandle( player_eHandle )
	if ( player == null )
		return
	Assert( oldTeam != null )
	Assert( newTeam != null )

	// Update the team icon on the hud for the player that just got autobalanced
	UpdatePlayerStatusCounts()

	local playerName = player.GetPlayerName()
	local playerNameColor = OBITUARY_COLOR_ENEMY
	local changedString = Localize( "#PLAYER_CHANGED_TEAMS_TO" )
	local teamString = Localize(newTeam == TEAM_IMC ? "#TEAM_IMC" : "#TEAM_MCOR")
	if ( newTeam == GetLocalViewPlayer().GetTeamNumber() )
	{
		playerNameColor = OBITUARY_COLOR_FRIENDLY
	}

	Obituary_Print( playerName, changedString, teamString, playerNameColor, OBITUARY_COLOR_WEAPON, playerNameColor )
	//"Switching " + player.GetPlayerName() + " from " + GetTeamStr( team1 ) + " to " + GetTeamStr( team2 )
}

function ServerCallback_PlayerConnectedOrDisconnected( player_eHandle, state )
{
	local player = GetEntityFromEncodedEHandle( player_eHandle )
	PlayerConnectedOrDisconnected( player, state, null )

	if ( !IsLobby() || !IsConnected() )
		UpdatePlayerStatusCounts()
}

function AddCallback_OnPlayerDisconnected( callbackFunc )
{
	Assert( "onPlayerDisconnectedFuncs" in level )
	Assert( type( this ) == "table", "AddCallback_OnPlayerDisconnected can only be added on a table. " + type( this ) )
	AssertParameters( callbackFunc, 1, "player" )

	local name = FunctionToString( callbackFunc )
	Assert( !( name in level.onPlayerDisconnectedFuncs ), "Already added " + name + " with AddCallback_OnPlayerDisconnected" )

	local callbackInfo = {}
	callbackInfo.name <- name
	callbackInfo.func <- callbackFunc
	callbackInfo.scope <- this

	level.onPlayerDisconnectedFuncs[ name ] <- callbackInfo
}

function CodeCallback_PlayerDisconnected( player, cachedPlayerName )
{
	PlayerConnectedOrDisconnected( player, 0, cachedPlayerName )

	if ( ShouldUpdatePlayerStatusCounts() )
		UpdatePlayerStatusCounts()

	// Added via AddCallback_OnPlayerDisconnected
	foreach ( callbackInfo in level.onPlayerDisconnectedFuncs )
	{
		callbackInfo.func.acall( [callbackInfo.scope, player] )
	}
}

function ShouldUpdatePlayerStatusCounts()
{
	if ( GetGameState() < eGameState.WaitingForPlayers )
		return false

	if ( !IsLobby() )
		return true

	if ( !IsConnected() )
		return true

	return false
}

function PlayerConnectedOrDisconnected( player, state, disconnectingPlayerName )
{
	if ( !IsMultiplayer() || IsLobby() || GetMapName() == "" ) // HACK: If you are disconnecting GetMapName() in IsLobby() will return ""
		return

	if ( !IsValid( player ) )
		return

	Assert( state == 0 || state == 1 )

	if ( !IsValid( GetLocalViewPlayer() ) )
		return

	local playerName
	if ( state == 0 )
	{
		if ( disconnectingPlayerName == null )
			return

		playerName = disconnectingPlayerName
	}
	else
		playerName = player.GetPlayerName()

	local playerNameColor = player.GetTeamNumber() == GetLocalViewPlayer().GetTeamNumber() ? OBITUARY_COLOR_FRIENDLY : OBITUARY_COLOR_ENEMY
	local connectionString = ( state == 0 ) ? "#MP_PLAYER_DISCONNECTED" : "#MP_PLAYER_CONNECTED"

	Obituary_Print( "", playerName, connectionString, playerNameColor, playerNameColor, OBITUARY_COLOR_WEAPON )
}

function ScoreboardInitValues()
{
	if ( IsTrainingLevel() )
		return

	level.teamName <- {}
	level.teamName[TEAM_IMC] <- "IMC"
	level.teamName[TEAM_MILITIA] <- "MIL"

	switch( GetLocalViewPlayer().GetTeamNumber() )
	{
		case TEAM_IMC:
			level.teamNumFriendly <- TEAM_IMC
			level.teamNumEnemy <- TEAM_MILITIA
			break
		case TEAM_MILITIA:
			level.teamNumFriendly <- TEAM_MILITIA
			level.teamNumEnemy <- TEAM_IMC
			break
		default:
			Assert( 0, "Player isn't on a team" )
	}
}

function ClientCodeCallback_PlayerDidDamage( params )
{
	local player = GetLocalViewPlayer()
	if ( !IsValid( player ) )
		return

	local victim = params.victim
	local damagePosition = params.damagePosition
	local hitBox = params.hitBox
	local damageType = params.damageType
	local damageAmount = params.damageAmount
	local damageFlags = params.damageFlags
	local hitGroup = params.hitGroup
	local weapon = params.weapon
	local distanceFromAttackOrigin = params.distanceFromAttackOrigin

	local playHitSound = true
	local attacker = GetLocalViewPlayer()
	local showCrosshairHitIndicator = true
	local hitIneffective = false
	local hitWeakpoint = false

	local isCritShot = (damageType & DF_CRITICAL) ? true : false
	local isHeadShot = (damageType & DF_HEADSHOT) ? true : false
	local isKillShot = (damageType & DF_KILLSHOT) ? true : false
	local isMelee = (damageType & DF_MELEE) ? true : false
	local isExplosion = (damageType & DF_EXPLOSION) ? true : false
	local isBullet = (damageType & DF_BULLET) ? true : false
	local isShotgun = (damageType & DF_SHOTGUN) ? true : false

	local isMaxRangeHit = (damageType & DF_MAX_RANGE) ? true : false

	local playKillSound = isKillShot
	local victimIsTitan
	local victimIsDropship

	if ( IsValid( victim ) )
	{
		// Hit indicator hud icon
		if ( isCritShot || isHeadShot )
			hitWeakpoint = true

		victimIsTitan = victim.IsTitan()
		victimIsDropship = victim.IsDropship()

		if ( ( victimIsTitan || victimIsDropship ) && !attacker.IsTitan() )
		{
			showCrosshairHitIndicator = true
			hitIneffective = !IsHitEffective( damageType )
		}
		else if ( !victimIsTitan && !attacker.IsTitan() )
		{
			if ( isBullet && isMaxRangeHit )
				hitIneffective = true
		}

		if ( hitGroup != HITGROUP_GENERIC )
			player.Signal( "UpdateSniperVGUI", { hitGroup = hitGroup } )
	}

	if ( isBullet && isMaxRangeHit )
		playHitSound = false

	if ( damageType & DF_TITAN_STEP )
	{
		playHitSound = false
		playKillSound = false
	}

	if ( isMelee )
	{
		playHitSound = false
		playKillSound = false
	}
	if ( damageType & DF_NO_INDICATOR || damageAmount <= 0 )
	{
		playHitSound = false
		playKillSound = false
		showCrosshairHitIndicator = false
	}

	if ( damageType & DF_NO_HITBEEP )
	{
		playHitSound = false
		playKillSound = false
	}

	if ( damageFlags & DAMAGEFLAG_VICTIM_HAS_VORTEX )
		showCrosshairHitIndicator = false

	local victimIsAlive = IsAlive( victim )
	if ( victimIsAlive )
	{
		if ( victimIsTitan && damageType & DF_SHIELD_DAMAGE && !victim.GetDoomedState() )
		{
			PlayShieldHitEffect( params )

			showCrosshairHitIndicator = true
		}
	}
	else
	{
		showCrosshairHitIndicator = false
	}

	params.playHitSound 				<- playHitSound
	params.playKillSound				<- playKillSound
	params.showCrosshairHitIndicator	<- showCrosshairHitIndicator
	params.hitIneffective				<- hitIneffective
	params.hitWeakpoint 				<- hitWeakpoint

	if ( showCrosshairHitIndicator )
	{
		Tracker_PlayerAttackedTarget( player, victim )

		TryShowHitIndicator( hitWeakpoint, hitIneffective )
	}
	// --- R1DELTA DAMAGE NUMBERS START ---
	if ( GetConVarInt( "delta_damage_numbers" ) == 1 && IsValid( victim ) )
	{
	    if ( showCrosshairHitIndicator && ("damagePosition" in params) && (damageAmount > 0 )) // Don't show for 0 damage
	    {
	        local isCritical = (damageType & DF_CRITICAL) != 0
	        local pos = victim.EyePosition() //("damagePosition" in params && params.damagePosition != Vector(0,0,0)) ? params.damagePosition : victim.GetWorldSpaceCenter()
	        pos.z += 10
			if (victim.IsTitan())
				pos.z += 30
	        // Pass victim.GetEntIndex() as the 7th parameter for batching
	        AddDamageNumber( damageAmount, pos.x, pos.y, pos.z, isCritical || isHeadShot || playKillSound, victim.GetEntIndex() )
	    }
	}
	// --- R1DELTA DAMAGE NUMBERS END ---

	if ( IsValid( victim ) && playKillSound )
	{
		PlayKillShotSound( attacker, victim, damageType, isHeadShot )
	}

	// Play a hit sound effect if we didn't play a kill shot sound, and other conditions are met
	if ( playHitSound )
	{
		if ( damageFlags & DAMAGEFLAG_VICTIM_INVINCIBLE )
			EmitSoundOnEntity( attacker, "Player.HitbeepInvincible" )
		else if ( damageFlags & DAMAGEFLAG_VICTIM_HAS_VORTEX )
			EmitSoundOnEntity( attacker, "Player.HitbeepVortex" )
		else if ( damageFlags & DAMAGEFLAG_VICTIM_ARMORED )
			EmitSoundOnEntity( attacker, "Player.HitbeepArmor" )
		else if ( hitWeakpoint && victimIsTitan )
			EmitSoundOnEntity( attacker, "titan_damage_crit" )
		else if ( hitWeakpoint )
			EmitSoundOnEntity( attacker, "Player.Hitbeep_crit" )
		else
			EmitSoundOnEntity( attacker, "Player.Hitbeep" )
	}

	if ( level.rankedPlayEnabled )
		TryRankedHudHighlight( player, victimIsTitan )

	foreach ( callbackInfo in level.onLocalPlayerDidDamageCallbacks )
	{
		callbackInfo.func.acall( [callbackInfo.scope, attacker, params] )
	}
}

const HITMARKER_DISABLED = 0
const HITMARKER_ALL = 1
const HITMARKER_NORMAL_ONLY = 2
const HITMARKER_SPECIAL_ONLY = 3
function TryShowHitIndicator( hitWeakpoint, hitIneffective )
{
	local hitmarkerEnabled = GetConVarInt( "delta_hud_show_hitmarkers" )
	if ( hitmarkerEnabled == HITMARKER_DISABLED )
		return

	if ( hitmarkerEnabled == HITMARKER_NORMAL_ONLY )
	{
		hitIneffective = false
		hitWeakpoint = false
	}
	else if ( hitmarkerEnabled == HITMARKER_SPECIAL_ONLY && !hitIneffective && !hitWeakpoint )
	{
		return
	}

	Crosshair_ShowHitIndicator( hitWeakpoint, hitIneffective, false )
}

function PlayKillShotSound( attacker, victim, damageType, isHeadShot )
{
	if ( victim.IsTitan() )
		return false

	if ( !( "playedKillShotSoundTime" in victim.s ) )
		victim.s.playedKillShotSoundTime <- -100

	// played a kill shot on this guy recently?
	if ( Time() - victim.s.playedKillShotSoundTime < 5 )
		return

	local soundAlias = null
	if ( damageType & DF_SHOTGUN )
	{
		if ( victim.IsSpectre() || victim.IsMarvin() )
		{
			if ( isHeadShot )
				soundAlias = "Android.Shotgun.BulletImpact_HeadShot_1P_vs_3P"
			else
				soundAlias = "Android.Shotgun.BulletImpact_KillShot_1P_vs_3P"
		}
		else
		{
			if ( isHeadShot )
				soundAlias = "Flesh.Shotgun.BulletImpact_Headshot_1P_vs_3P"
			else
				soundAlias = "Flesh.Shotgun.BulletImpact_KillShot_1P_vs_3P"
		}
	}
	else if ( damageType & damageTypes.Bullet || damageType & damageTypes.SmallArms )
	{
		if ( victim.IsSpectre() || victim.IsMarvin() )
		{
			if ( isHeadShot )
				soundAlias = "Android.Light.BulletImpact_HeadShot_1P_vs_3P"		// light ballistic vs. android head
			else
				soundAlias = "Android.BulletImpact_KillShot_1P_vs_3P"			// light ballistic vs. Spectre or Marvin
		}
		else
		{
			if ( isHeadShot )
				soundAlias = "Flesh.Light.BulletImpact_Headshot_1P_vs_3P"	// light ballistic vs. human head
			else
				soundAlias = "Flesh.BulletImpact_KillShot_1P_vs_3P"			// light ballistic vs. pilot or grunt
		}
	}
	else if ( damageType & damageTypes.LargeCaliber || damageType & DF_GIB )
	{
		if ( victim.IsSpectre() || victim.IsMarvin() )
		{
			if ( isHeadShot )
				soundAlias = "Android.Heavy.BulletImpact_HeadShot_1P_vs_3P"	// heavy ballistic vs. human head
			else
				soundAlias = "Android.Heavy.BulletImpact_KillShot_1P_vs_3P"	// heavy ballistic vs. Spectre or Marvin
		}
		else
		{
			if ( isHeadShot )
				soundAlias = "Flesh.Heavy.BulletImpact_Headshot_1P_vs_3P"	// heavy ballistic vs. human head
			else
				soundAlias = "Flesh.Heavy.BulletImpact_Killshot_1P_vs_3P"	// heavy ballistic vs. pilot or grunt
		}
	}

	if ( soundAlias == null )
		return false

	victim.s.playedKillShotSoundTime = Time()
	EmitSoundOnEntity( attacker, soundAlias )
	return true
}

function PlayerWeaponFlyout( player )
{
	if ( !WEAPON_FLYOUTS_ENABLED )
		return

	if ( IsSingleplayer() )
		return

	if ( !( "previousWeapon" in player.s ) )
		player.s.previousWeapon <- null

	if ( player.IsInThirdPersonReplay() )
		return

	// Did weapon change?
	local currentWeapon = player.GetActiveWeapon()
	if ( currentWeapon == player.s.previousWeapon )
		return false

	// Hide old flyout if there is one, when we switch to another weapon
	Flyout_Hide()

	if ( currentWeapon && ( !currentWeapon.IsWeaponOffhand() ) )
		player.s.previousWeapon = currentWeapon

	if ( !ShouldShowPlayerWeaponFlyout( player, currentWeapon ) )
		return

	// Show the flyout
	local name = currentWeapon.GetWeaponPrintName()
	local desc = currentWeapon.GetWeaponDescription()
	player.s.weaponFlyoutTimes[ name ] = Time()
	local weaponRef = currentWeapon.GetSignifierName()
	local modRefs = currentWeapon.GetMods()

	if ( !ItemDefined( weaponRef ) )
		return

// Dont enable, breaks flyout if the weapon has unknown mods
// Proper check is now done in Flyout_ShowWeapon()

//	foreach ( modRef in modRefs )
//	{
//		if ( !SubitemDefined( weaponRef, modRef ) )
//			return
//	}

	thread Flyout_ShowWeapon( weaponRef, modRefs )
}

function ShouldShowPlayerWeaponFlyout( player, weapon )
{
	if ( !GetConVarBool( "delta_hud_show_flyout" ) )
		return false

	// No weapon
	if ( !weapon )
		return false

	// MP can be dead with new weapon
	if ( !IsAlive( player ) )
		return false

	// debounce check
	local time = Time()
	local name = weapon.GetWeaponPrintName()
	if ( !( "weaponFlyoutTimes" in player.s ) )
		player.s.weaponFlyoutTimes <- {}
	if ( !( name in player.s.weaponFlyoutTimes ) )
		player.s.weaponFlyoutTimes[ name ] <- time - WEAPON_FLYOUT_DEBOUNCE_TIME
	if ( time - player.s.weaponFlyoutTimes[ name ] < WEAPON_FLYOUT_DEBOUNCE_TIME )
		return false

	if ( weapon.IsWeaponOffhand() )
		return false

	if ( player.IsWeaponDisabled() )
		return false

	if ( GetGameState() < eGameState.Playing )
		return false

	return true
}


function ClientCodeCallback_BodyGroupChanged( entity, bodyGroupIndex, oldState, newState )
{
	if ( !entity )
		return

	local modelName = entity.GetModelName()
	// Hack: sometimes the BodyGroupChanged callback happens before the ModelChanged callback... this is bad.
	if ( entity.s.lastModel != modelName )
	 	return

// moved to code
/*
	//printt( "Entity " + entity + " bodyGroupIndex " + bodyGroupIndex + " oldState " + oldState + " newState " + newState )
	if ( entity.s.damageData && DamageStates_UsesBodyGroup( entity, bodyGroupIndex ) )
		DamageStates_UpdateDamageStates( entity, bodyGroupIndex, newState, true )
*/
	// HACK this is currently the only case where we need ClientCodeCallback_BodyGroupChanged
	Assert( modelName == ATLAS_MODEL )
	ChangedAtlasFrontBodygroup( entity, bodyGroupIndex, newState, oldState )
}

function ServerCallback_TitanTookDamage( damage, x, y, z, damageType, damageSourceId, attackerEHandle, eModId, becameDoomed )
{
	// It appears to be faster here to create a new thread so other functions called can wait until the frame ends before running.
	thread ServerCallback_TitanTookDamageThread( damage, x, y, z, damageType, damageSourceId, attackerEHandle, eModId, becameDoomed )
}

function ServerCallback_TitanTookDamageThread( damage, x, y, z, damageType, damageSourceId, attackerEHandle, eModId, becameDoomed )
{
	WaitEndFrame()

	local attacker = attackerEHandle ? GetEntityFromEncodedEHandle( attackerEHandle ) : null
	local localViewPlayer = GetLocalViewPlayer()

	local cockpit = localViewPlayer.GetCockpit()

	if ( cockpit && IsTitanCockpitModelName( cockpit.GetModelName() ) )
	{
		if ( ShouldDo_TitanCockpit_DamageFeedback( attacker, localViewPlayer ) )
		{
			TitanCockpit_DamageFeedback( localViewPlayer, cockpit, damage, damageType, Vector( x, y, z ), damageSourceId )
		}
	}

	if ( damage >= DAMAGE_BREAK_MELEE_ASSIST )
	{
		// clear melee assist on big hits.
		PlayerMelee_SetAimAssistTarget( localViewPlayer, null, 0.0 )
	}

	if ( damageSourceId != eDamageSourceId.bubble_shield  ) //Don't play Betty OS dialogue if we took damage by bubble shield. We don't have appropriate dialogue for it right now. Have requested lines for it be added next time we add lines for Betty.
		Tracker_PlayerAttackedByTarget( localViewPlayer, attacker )

	local weaponMods = []
	if ( eModId != null && eModId in modNameStrings )
		weaponMods.append( modNameStrings[eModId] )

	local damageOrigin = Vector( x, y, z )
	local damageTable = StoreDamageHistoryAndUpdate( localViewPlayer, MAX_DAMAGE_HISTORY_TIME, damage, damageOrigin, damageType, damageSourceId, attacker, weaponMods )

	DamageIndicators( damageTable, true )

	if ( becameDoomed )
		DoomRecap( attacker, damageSourceId )

	if ( damageType & DF_CRITICAL )
	{
		localViewPlayer.Signal( "CriticalHitReceived" )
		EmitSoundOnEntity( localViewPlayer, "titan_damage_crit_3p_vs_1p" )
	}
}

function ServerCallback_PilotTookDamage( damage, x, y, z, damageType, damageSourceId, attackerEHandle, eModId )
{
	local attacker = attackerEHandle ? GetEntityFromEncodedEHandle( attackerEHandle ) : null
	local localViewPlayer = GetLocalViewPlayer()
	local damageOrigin = Vector( x, y, z )

	//Jolt view if player is getting meleed
	if ( damageSourceId == eDamageSourceId.human_melee )
	{
		local joltDir = ( localViewPlayer.CameraPosition() - damageOrigin )
		joltDir.Normalize()
		localViewPlayer.Jolt( joltDir * 100.0,  0.95 )
		//clear melee assist when you get meleed
		PlayerMelee_SetAimAssistTarget( localViewPlayer, null, 0.0 )
	}

	local weaponMods = []
	if ( eModId != null && eModId in modNameStrings )
		weaponMods.append( modNameStrings[eModId] )

	local damageTable = StoreDamageHistoryAndUpdate( localViewPlayer, MAX_DAMAGE_HISTORY_TIME, damage, damageOrigin, damageType, damageSourceId, attacker, weaponMods )

	DamageIndicators( damageTable, false )
}

function ShouldDo_TitanCockpit_DamageFeedback( attacker, localPlayer )
{
	if ( !IsValid( attacker ) )
		return false

	if ( attacker.IsPlayer() )
	{
		if ( attacker.GetParent() == localPlayer )
			return false

		return true
	}

	if ( attacker.IsNPC() )
	{
		if ( attacker.IsTitan() || attacker.IsTurret() )
			return true
	}

	return false
}

const DAMAGEARROW_SMALL = 0
const DAMAGEARROW_MEDIUM = 1
const DAMAGEARROW_LARGE = 2

arrowIncomingAnims <- [
	"damage_incoming_small"
	"damage_incoming"
	"damage_incoming_large"
]

arrowAnims <- [
	"damage_small"
	"damage"
	"damage_large"
]

const DAMAGEARROW_FADEANIM = "damage_fade"

function InitDamageArrows()
{
	for ( local i = 0; i < file.numDamageArrows; i++ )
	{
		local arrowData = {
			damageOrigin = Vector( 0.0, 0.0, 0.0 ),
			endTime = -99.0 + DAMAGEARROW_DURATION,
			startTime = -99.0,
			isDying = false,
			isVisible = false
		}

		local arrow = CreateClientSidePropDynamic( Vector( 0, 0, 0 ), Vector( 0, 0, 0 ), DAMAGE_ARROW_MODEL )
		arrow.SetCanCloak( false )
		arrow.SetVisibleForLocalPlayer( 0 )
		arrow.DisableDraw()

		arrowData.arrow <- arrow
		arrow.s.arrowData <- arrowData

		file.damageArrows.append( arrowData )
	}

	for ( local i = 0; i < file.numGrenadeArrows; i++ )
	{
		local arrowData = {
			origin = Vector( 0.0, 0.0, 0.0 ),
			endTime = -99.0 + DAMAGEARROW_DURATION,
			startTime = -99.0,
			isDying = false,
			isVisible = false
		}

		local arrow = CreateClientSidePropDynamic( Vector( 0, 0, 0 ), Vector( 0, 0, 0 ), DAMAGE_ARROW_MODEL )
		arrow.SetCanCloak( false )
		arrow.SetVisibleForLocalPlayer( 0 )
		arrow.DisableDraw()

		arrowData.arrow <- arrow
		arrow.s.arrowData <- arrowData

		file.grenadeArrows.append( arrowData )
	}

	local arrow = CreateClientSidePropDynamic( Vector( 0, 0, 0 ), Vector( 0, 0, 0 ), DAMAGE_ARROW_MODEL )
	file.damageArrowFadeDuration = arrow.GetSequenceDuration( DAMAGEARROW_FADEANIM ) // 0.266
	arrow.Destroy()
}

function DamageIndicators( damageTable, playerIsTitan )
{
	if ( damageTable.damageType & DF_NO_INDICATOR )
		return

	if ( !level.clientScriptInitialized )
		return

	local attacker = damageTable.attackerWeakRef
	local localViewPlayer = GetLocalViewPlayer()

	local arrowType = DAMAGEARROW_MEDIUM

	if ( IsValid( attacker ) )
	{
		if ( attacker == localViewPlayer )
			return

		if ( playerIsTitan )
		{
			if ( attacker.IsTitan() )
				arrowType = DAMAGEARROW_LARGE
			else if ( attacker.IsPlayer() )
				arrowType = DAMAGEARROW_MEDIUM
			else
				arrowType = DAMAGEARROW_SMALL
		}
		else
		{
			if ( attacker.IsPlayer() || attacker.IsTitan() )
				arrowType = DAMAGEARROW_MEDIUM
			else
				arrowType = DAMAGEARROW_SMALL
		}
	}

	if ( playerIsTitan )
	{
		local cockpit = localViewPlayer.GetCockpit()

		if ( !cockpit )
			return

		local dirToDamage = damageTable.origin - localViewPlayer.GetOrigin()
		dirToDamage.z = 0
		dirToDamage.Normalize()

		local playerViewForward = localViewPlayer.GetViewVector()
		playerViewForward.z = 0.0
		playerViewForward.Normalize()

		local damageFrontDot = dirToDamage.Dot( playerViewForward )

		if ( damageFrontDot >= 0.707107 )
			cockpit.AddToTitanHudDamageHistory( COCKPIT_PANEL_TOP, damageTable.damage )
		else if ( damageFrontDot <= -0.707107 )
			cockpit.AddToTitanHudDamageHistory( COCKPIT_PANEL_BOTTOM, damageTable.damage )
		else
		{
			local playerViewRight = localViewPlayer.GetViewRight()
			playerViewRight.z = 0.0
			playerViewRight.Normalize()

			local damageRightDot = dirToDamage.Dot( playerViewRight )

			if ( damageRightDot >= 0.707107 )
				cockpit.AddToTitanHudDamageHistory( COCKPIT_PANEL_RIGHT, damageTable.damage )
			else
				cockpit.AddToTitanHudDamageHistory( COCKPIT_PANEL_LEFT, damageTable.damage )
		}

		if ( attacker && attacker.GetParent() == localViewPlayer )
		{
			damageTable.rodeoDamage <- true
			return
		}
	}

	ShowDamageArrow( localViewPlayer, damageTable.origin, arrowType, playerIsTitan )
}

function DamageArrow_CockpitInit( cockpit, isRecreate )
{
	local localViewPlayer = GetLocalViewPlayer()

	thread UpdateDamageArrows( localViewPlayer, cockpit )
}

function ShowDamageArrow( player, damageOrigin, arrowType, playerIsTitan )
{
	local arrow = null

	arrow = file.damageArrows[ file.currentDamageArrow ].arrow

	file.currentDamageArrow++
	if ( file.currentDamageArrow >= file.numDamageArrows )
		file.currentDamageArrow = 0

	local time = Time()

	arrow.s.arrowData.damageOrigin = damageOrigin
	arrow.s.arrowData.endTime = time + DAMAGEARROW_DURATION
	arrow.s.arrowData.startTime = time
	arrow.s.arrowData.isDying = false

	if ( !arrow.s.arrowData.isVisible )
	{
		if ( playerIsTitan )
		{
			local cockpit = player.GetCockpit()
			if ( !cockpit || !IsTitanCockpitModelName( cockpit.GetModelName() ) )
				return

			arrow.s.arrowData.isVisible = true
			arrow.EnableDraw()

			arrow.DisableRenderWithViewModelsNoZoom()
			arrow.EnableRenderWithCockpit()

			arrow.SetParent( cockpit, "CAMERA_BASE" )
			arrow.SetAttachOffsetOrigin( Vector( 20.0, 0.0, -2.0 ) )
		}
		else
		{
			arrow.s.arrowData.isVisible = true
			arrow.EnableDraw()

			arrow.DisableRenderWithCockpit()
			arrow.EnableRenderWithViewModelsNoZoom()

			arrow.SetParent( player )
			arrow.SetAttachOffsetOrigin( Vector( 25.0, 0.0, -2.0 ) )
		}
	}

	arrow.Anim_NonScriptedPlay( arrowIncomingAnims[ arrowType ] )
}

function UpdateDamageArrowVars( localViewPlayer )
{
	file.damageArrowTime = Time()
	file.damageArrowAngles = localViewPlayer.EyeAngles().AnglesInverse()
	file.damageArrowPointCenter = localViewPlayer.EyePosition() + ( localViewPlayer.GetViewVector() * 20.0 )
}

function UpdateDamageArrows( localViewPlayer, cockpit )
{
	localViewPlayer.EndSignal( "OnDestroy" )
	cockpit.EndSignal( "OnDestroy" )

	OnThreadEnd(
		function() : ( localViewPlayer )
		{
			foreach ( arrowData in file.damageArrows )
			{
				if ( IsValid( arrowData.arrow ) )
				{
					arrowData.arrow.DisableDraw()
					arrowData.arrow.ClearParent()
					arrowData.isVisible = false
				}
			}
		}
	)

	local varsUpdated = false

	while ( true )
	{
		WaitEndFrame()

		varsUpdated = false

		foreach ( arrowData in file.damageArrows )
		{
			if ( !arrowData.isVisible )
			{
				continue
			}
			else if ( file.damageArrowTime >= arrowData.endTime )
			{
				arrowData.arrow.DisableDraw()
				arrowData.arrow.ClearParent()
				arrowData.isVisible = false
				continue
			}

			if ( !varsUpdated ) // only call UpdateDamageArrowVars if one or more of the file.damageArrows is visible
			{
				varsUpdated = true
				UpdateDamageArrowVars( localViewPlayer )
			}

			local vecToDamage = arrowData.damageOrigin - file.damageArrowPointCenter

			arrowData.arrow.SetAttachOffsetAngles( file.damageArrowAngles.AnglesCompose( vecToDamage.GetAngles() ) )

			if ( !arrowData.isDying && ( ( arrowData.endTime - file.damageArrowTime ) <= file.damageArrowFadeDuration ) )
			{
				arrowData.isDying = true
				arrowData.arrow.Anim_NonScriptedPlay( DAMAGEARROW_FADEANIM )
			}
		}

		wait( 0.0 )
	}
}

function ServerCallback_RodeoerEjectWarning( soulHandle, ejectTime )
{
	local soul = GetEntityFromEncodedEHandle( soulHandle )

	if ( !IsValid( soul ) )
		return

	thread TitanEjectHatchSequence( soul, ejectTime )
}

function TitanEjectHatchSequence( soul, ejectTime )
{
	soul.EndSignal( "OnSoulTransfer" )
	soul.EndSignal( "OnTitanDeath" )
	soul.EndSignal( "OnDestroy" )

	local effects = []

	OnThreadEnd(
		function() : ( effects )
		{
			foreach ( effect in effects )
			{
				if ( !EffectDoesExist( effect ) )
					continue

				EffectStop( effect, true, true )
			}
		}
	)

	local boltCount = 6

	local fxID = GetParticleSystemIndex( "xo_spark_bolt" )

	for ( local index = 0; index < boltCount; index++ )
	{
		local titan = soul.GetTitan()

		WaitEndFrame() // so OnTitanDeath/Destroy can happen

		if ( !IsAlive( titan ) )
			return

		if ( !titan.IsTitan() )
		{
			printt( "WARNING: " + titan + " is not a Titan!" )
			return
		}

		local attachID = titan.LookupAttachment( "HATCH_BOLT" + (index + 1) )
		//printt( "attachID is " + attachID )
		local boltOrgin = titan.GetAttachmentOrigin( attachID )
		local boltAngles = titan.GetAttachmentAngles( attachID )

		local launchVec = boltAngles.AnglesToForward() * 500

		CreateClientsideGib( "models/industrial/bolt_tiny01.mdl", boltOrgin, boltAngles, launchVec, Vector( 0, 0, 0 ), 3.0, 1000, 200 )
		local effect = PlayFXOnTag( titan, fxID, attachID )
		effects.append( effect )
		EmitSoundOnEntity( titan, "titan_bolt_loose" )

		wait (ejectTime / boltCount)
	}
}

function DamageIndicatorOffset( player )
{
	local origin = player.CameraPosition()
	local angles = player.CameraAngles()

	if ( DAMAGEHUD_ALTPOS )
	{
		local size = 10.0
		origin += (angles.AnglesToForward() * 6)
		origin -= angles.AnglesToRight() * (size*0.5)
		origin += (angles.AnglesToUp() * -3.5)
	}
	else
	{
		local size = 10.0
		origin += (angles.AnglesToForward() * 6)
		origin -= angles.AnglesToRight() * (size*0.5)
		origin += (angles.AnglesToUp() * -1.75)
	}

	angles = angles.AnglesCompose( Vector( 0, -90, 20 ) );

	return [origin, angles];
}

function Create_DamageIndicatorHUD()
{
	local player = GetLocalViewPlayer()
	local offset = DamageIndicatorOffset( player )
	local origin = offset[0]
	local angles = offset[1]

	local size = 10.0

	player.s.damageIndicatorHudVGUI <- CreateClientsideVGuiScreen( "vgui_damage_3d", VGUI_SCREEN_PASS_VIEWMODEL_NOZOOM, origin, angles, size, size );
	player.s.damageIndicatorHudVGUI.s.panel <- player.s.damageIndicatorHudVGUI.GetPanel()
	player.s.damageIndicatorHudVGUI.SetParent( player );
}


function TryAddDamageIndicator()
{

}


function TryAddGrenadeIndicator( grenade, weaponName )
{
	local player = GetLocalViewPlayer()

	local className = grenade.GetSignifierName()

	if ( className != "npc_grenade_frag" )
		return

	// Grenades dont hurt friendlies, but they hurt the person who created them. Don't show indicators to teammates but show them to the owner
	if ( grenade.GetTeam() == player.GetTeam() && grenade.GetOwner() != player )
		return

	switch ( weaponName )
	{
		case "mp_weapon_laser_mine":
		case "mp_weapon_smr":
		case "mp_titanweapon_40mm":
		case "mp_weapon_satchel":
		case "mp_weapon_proximity_mine":
			return
	}

	local startDelay = 0
	if ( grenade.GetOwner() == player )
		startDelay = DAMAGEHUD_GRENADE_DEBOUNCE_TIME

	if ( level.grenadeIndicatorEnabled )
	{
		//203.531 // Titan
		//64.1249 // Pilot
		local padding = player.IsTitan() ? 204.0 : 65.0
		local radius = grenade.GetDamageRadius()

		if ( !GetConVarBool( "delta_hud_grenade_style" ) )
			AddGrenadeIndicator( grenade, radius + padding, startDelay, true )
		else
			ShowGrenadeArrow( player, grenade, weaponName, radius + padding, startDelay )
	}
}

function ShowGrenadeArrow( player, grenade, weaponName, damageRadius, startDelay, requireLos = true )
{
	thread GrenadeArrowThink( player, grenade, weaponName, damageRadius, startDelay, requireLos )
}

const PLAY_GRENADE_ANIMS = 0
function GrenadeArrowThink( player, grenade, weaponName, damageRadius, startDelay, requireLos, requiredPlayerState = "any" )
{
	grenade.EndSignal( "OnDestroy" )
	player.EndSignal( "OnDeath" )

	wait startDelay

/*
	arrow = file.grenadeArrows[ file.currentGrenadeArrow ].arrow

	file.currentGrenadeArrow++
	if ( file.currentGrenadeArrow >= file.numGrenadeArrows )
		file.currentGrenadeArrow = 0
*/
	local time = Time()

	local arrowModel = "models/weapons/bullets/grenade_indicator_arrow.mdl" //GRENADE_INDICATOR_ARROW_MODEL
	local grenadeModel = "models/weapons/bullets/grenade_indicator.mdl" //GRENADE_INDICATOR_FRAG_MODEL
	local grenadeOffset = Vector( -5, 0, 0 )

	switch ( weaponName )
	{
		case "mp_titanweapon_triple_threat":
			grenadeModel = "models/weapons/bullets/grenade_indicator_tt.mdl"
			break
	}

	local arrow = CreateClientSidePropDynamic( Vector( 0, 0, 0 ), Vector( 0, 0, 0 ), arrowModel )
	local mdl = CreateClientSidePropDynamic( Vector( 0, 0, 0 ), Vector( 0, 0, 0 ), grenadeModel )

	local arrowData = {
		endTime = time + 99, //DAMAGEARROW_DURATION
		startTime = 99,
		isDying = false,
		isVisible = false
	}

	arrow.s.arrowData <- arrowData
	mdl.s.arrowData <- arrowData

	local cockpit = player.GetCockpit()
	if ( !cockpit )
		return

	cockpit.EndSignal( "OnDestroy" )

	arrow.SetParent( cockpit, "CAMERA_BASE" )
	arrow.SetAttachOffsetOrigin( Vector( 25.0, 0.0, -4.0 ) )

	mdl.SetParent( arrow, "BACK" )
	mdl.SetAttachOffsetOrigin( grenadeOffset )

	local lastVisibleTime = 0
	local shouldBeVisible = true

	local origin = Vector( 0, 0, 0 )
	local lastOrigin = Vector( 0, 0, 0 )

	OnThreadEnd(
		function() : ( player, grenade, arrow, mdl, lastOrigin )
		{
			thread GrenadeArrow_PostThink( player, grenade, arrow, mdl )
		}
	)

	local playedIncomingAnim = false

	while ( true )
	{
		time = Time()
		cockpit = player.GetCockpit()

		if ( !IsValid( grenade ) )
			origin = lastOrigin
		else
			origin = grenade.GetOrigin()

		switch ( requiredPlayerState )
		{
			case "any":
				shouldBeVisible = true
				break
			case "pilot":
				shouldBeVisible = !player.IsTitan()
				break
			case "titan":
				shouldBeVisible = player.IsTitan()
				break
			default:
				Assert( false, "Invalid player state! Allower states: 'any' 'pilot' 'titan'" )

		}

		if ( shouldBeVisible )
		{
			if ( Distance( player.GetOrigin(), origin ) > damageRadius || !cockpit )
			{
				shouldBeVisible = false
			}
			else
			{
				local tracePassed = false

				if ( requireLos )
				{
					//TraceResults result = TraceLine( origin, GetRandomOriginWithinBounds( player ), grenade, TRACE_MASK_SHOT, TRACE_COLLISION_GROUP_NONE )
					local result = TraceLine( origin, player.GetOrigin(), grenade, TRACE_MASK_SHOT, TRACE_COLLISION_GROUP_NONE )

					if ( result.fraction != 1.0 )
						result = TraceLine( origin, player.EyePosition(), grenade, TRACE_MASK_SHOT, TRACE_COLLISION_GROUP_NONE )

					if ( result.fraction == 1.0 )
						tracePassed = true
				}

				if ( requireLos && !tracePassed )
				{
					shouldBeVisible = false
				}
				else
				{
					shouldBeVisible = true
					lastVisibleTime = time
				}
			}
		}

		//TEST
		//shouldBeVisible = true

		arrow.s.arrowData.isVisible = shouldBeVisible
		mdl.s.arrowData.isVisible = shouldBeVisible

		if ( shouldBeVisible || time - lastVisibleTime < 0.25 )
		{
			arrow.EnableDraw()
			mdl.EnableDraw()

			arrow.DisableRenderWithViewModelsNoZoom()
			arrow.EnableRenderWithCockpit()
			mdl.DisableRenderWithViewModelsNoZoom()
			mdl.EnableRenderWithCockpit()

			local damageArrowAngles = player.EyeAngles().AnglesInverse()
			local vecToDamage = origin - ( player.EyePosition() + ( player.GetViewVector() * 20.0 ) )

			// reparent for embark/disembark
			if ( arrow.GetParent() == null )
				arrow.SetParent( cockpit, "CAMERA_BASE", true )

			arrow.SetAttachOffsetAngles( damageArrowAngles.AnglesCompose( vecToDamage.GetAngles() ) ) //vecToDamage.VectorToAngles()

			if ( !playedIncomingAnim )
			{
				arrow.s.arrowData.startTime = time
				arrow.s.arrowData.startTime = time

				if ( PLAY_GRENADE_ANIMS )
				{
					arrow.Anim_NonScriptedPlay( "damage_incoming" )
					mdl.Anim_NonScriptedPlay( "damage_incoming" )
				}

				playedIncomingAnim = true
			}
		}
		else
		{
			mdl.DisableDraw()
			arrow.DisableDraw()
		}

		lastOrigin = origin

		WaitFrame()
	}

}

function GrenadeArrow_PostThink( player, grenade, arrow, mdl )
{
	if ( IsAlive( player ) && PLAY_GRENADE_ANIMS )
	{
		//arrow.s.arrowData.endTime = Time() - 1
		//arrow.s.arrowData.endTime = Time() - 1

		arrow.Anim_NonScriptedPlay( DAMAGEARROW_FADEANIM )
		mdl.Anim_NonScriptedPlay( DAMAGEARROW_FADEANIM )

		wait file.damageArrowFadeDuration
	}

	if ( IsValid( arrow ) )
		arrow.Destroy()
	if ( IsValid( mdl ) )
		mdl.Destroy()

/*
	if ( !IsValid( arrow ) )
		printt( "the game" )
	else
	{
		printt( "the gamen't" )
	}
*/
}

function PlayerHudTest()
{
	local player = GetLocalViewPlayer()

	local cockpit = player.GetCockpit()
	if ( !cockpit )
		return

	thread PlayerHudTestThink( player, cockpit )
}
Globalize( PlayerHudTest )

function PlayerHudTestThink( player, cockpit )
{
	player.EndSignal( "OnDeath" )
	cockpit.EndSignal( "OnDestroy" )

	local model = CreateClientSidePropDynamicClone( player, player.GetModelName() )

	OnThreadEnd(
		function() : ( model )
		{
			model.Destroy()
		}
	)

	model.SetParent( cockpit, "CAMERA_BASE" )
	model.SetAttachOffsetOrigin( Vector( 100.0, 0.0, -4.0 ) )

	if ( player.GetTeam() == TEAM_MILITIA )
		model.SetSkin( 1 )

	model.DisableRenderWithViewModelsNoZoom()
	model.EnableRenderWithCockpit()
	model.EnableRenderAlways()

	while( true )
	{
		if ( IsValid( player) && IsAlive( player ) )
		{
			model.SetOrigin( player.GetOrigin() )
			model.SetAngles( player.GetAngles() )
		}

		WaitFrame()
	}
}

function ToggleGrenadeIndicators()
{
	level.grenadeIndicatorEnabled = !level.grenadeIndicatorEnabled
}


function CalcRelativeIndicatorDir( player, enemyPos )
{
	local dirToDamage = (enemyPos - player.GetOrigin())
	dirToDamage.z = 0
	dirToDamage.Normalize()

	local x = dirToDamage.Dot( player.GetViewRight() )
	local y = dirToDamage.Dot( player.GetViewVector() )

	return [x, y]
}

function CalcAbsoluteIndicatorDir( player, enemyPos )
{
	local eyePos = player.CameraPosition()
	local eyeAngles = player.CameraAngles()

	local planePos = (eyePos + eyeAngles.AnglesToForward() * 6.0)
	//planePos += (eyeAngles.AnglesToUp() * -3.5)

	eyeAngles = eyeAngles.AnglesCompose( Vector( -20, 0, 0 ) )

	local planeNormal = eyeAngles.AnglesToUp()
	local planeRight = eyeAngles.AnglesToRight()
	local planeForward = eyeAngles.AnglesToForward()

	local indicatorDirToEnemy = enemyPos - planePos
	indicatorDirToEnemy.Normalize()

	// this is a 3d point in space that, when projected onto the damage indicator, will be along our visual line to the enemy
	local pointNearPlaneTowardEnemy = planePos + indicatorDirToEnemy

	// project pointNearPlaneTowardEnemy onto the plane.
	local dirToPointNearPlane = pointNearPlaneTowardEnemy - eyePos

	// ray-plane intersection: solve (eyePos + dirToPointNearPlane * t - planePos) dot planeNormal = 0
	// (eyePos - planePos) dot planeNormal + dirToPointNearPlane dot planeNormal * t = 0
	// dirToPointNearPlane dot planeNormal * t = (planePos - eyePos) dot planeNormal
	// t = ((planePos - eyePos) dot planeNormal) / (dirToPointNearPlane dot planeNormal)

	local denominator = dirToPointNearPlane.Dot( planeNormal )
	Assert( denominator < 0 ) // this should be true as long as we're at least one unit from the plane; if we're not, scale down indicatorDirToEnemy when it's normalized
	local numerator = ( planePos - eyePos ).Dot( planeNormal )

	local t = numerator / denominator

	local pointOnPlane = eyePos + dirToPointNearPlane * t

	// want direction on plane from planePos to pointOnPlane
	local dirOnPlane = pointOnPlane - planePos

	//dirOnPlane.Normalize()

	local x = dirOnPlane.Dot( planeRight )
	local y = dirOnPlane.Dot( planeForward )

	return [x, y]
}

function ServerCallback_OnEntityKilled( attackerEHandle, victimEHandle, scriptDamageType, damageSourceId )
{
	local isHeadShot = scriptDamageType & DF_HEADSHOT

	local victim = GetEntityFromEncodedEHandle( victimEHandle )
	local attacker = attackerEHandle ? GetEntityFromEncodedEHandle( attackerEHandle ) : null
	local localPlayer = GetLocalClientPlayer()

	if ( GameRules.GetGameMode() == ATTRITION && IsValid( attacker ) && attacker.IsPlayer() )
	{
		local scoreVal = GetAttritionScore( attacker, victim )
		if ( scoreVal > 0 )
			level.ent.Signal( "AttritionPoints", { scoreVal = scoreVal, attacker = attacker } )
	}

	if ( !IsValid( victim ) || !IsMultiplayer() )
		return

	Signal( victim, "OnDeath" )

	if ( victim == localPlayer )
	{
		level.clientsLastKiller = attacker
		thread DeathRecap( attacker, damageSourceId )
	}

	if ( victim.GetModelName() in level.modelFXData )
		PlayDestroyFX( victim )

	if ( damageSourceId == eDamageSourceId.indoor_inferno )
	{
		if ( victim == localPlayer )
			thread PlayerFieryDeath( victim )
	}


	UpdatePlayerStatusCounts()

	if ( IsValid( attacker) && attacker.IsPlayer() )
	{
		PlayTargetEliminatedTitanVO( attacker, victim )
	}
	else if ( victim.IsPlayer() )
	{
		if( ("latestAssistTime" in victim.s) && victim.s.latestAssistTime >= Time() - MAX_NPC_KILL_STEAL_PREVENTION_TIME )
		{
			attacker = victim.s.latestAssistPlayer
			damageSourceId = victim.s.latestAssistDamageSource
		}

	}

	if( victim.IsPlayer() && victim != attacker )
	{
		if( attacker == localPlayer )
		{
			EmitSoundOnEntity( attacker, "Pilot_Killed_Indicator" )
		}
		else if ( IsValid( attacker) && attacker.IsTitan() )
		{
			local bossPlayer = attacker.GetBossPlayer()
			if( bossPlayer && bossPlayer == localPlayer )
				EmitSoundOnEntity( bossPlayer, "Pilot_Killed_Indicator" )
		}
	}

	//if it's an auto titan, the obit was already printed when doomed
	if ( ( victim.IsTitan() ) && ( !victim.IsPlayer() ) )
		return

	Obituary( attacker, "", victim, scriptDamageType, damageSourceId, isHeadShot )
}
Globalize( ServerCallback_OnEntityKilled )

function ServerCallback_OnTitanDoomed( attackerEHandle, victimEHandle, scriptDamageType, damageSourceId )
{
	//Gets run on every client whenever a titan is doomed by another player

	local isHeadShot = false
	local attacker = attackerEHandle ? GetEntityFromEncodedEHandle( attackerEHandle ) : null
	local victim = GetEntityFromEncodedEHandle( victimEHandle )

	if ( ( !IsValid( victim ) ) || ( !IsValid( attacker ) ) )
		return

	//Obit: titans get scored/obits when doomed, so we don't want to just see "Player" in the obit, we want to see "Player's Titan"
	local victimIsOwnedTitan = victim.IsPlayer()
	Obituary( attacker, "", victim, scriptDamageType, damageSourceId, isHeadShot, victimIsOwnedTitan )
}

Globalize( ServerCallback_OnTitanDoomed )


function PlayTargetEliminatedTitanVO( attacker, victim )
{
	local localPlayer = GetLocalViewPlayer()

	if ( attacker != localPlayer )
		return

	if ( !victim.IsPlayer() )
		return

	if ( victim.IsTitan() )
	{
		// a bit more delay for a titan explosion to clear
		thread TitanCockpit_PlayDialogDelayed( localPlayer, 1.3, "YOU_ELIMINATED_TARGET" )
	}
	else
	{
		thread TitanCockpit_PlayDialogDelayed( localPlayer, 0.8, "ENEMY_PILOT_ELIMINATED" )
	}
}

function ServerCallback_SetAssistInformation( damageSourceId, attackerEHandle, entityEHandle, assistTime )
{
	local entity = GetEntityFromEncodedEHandle ( entityEHandle )
	if ( !entity )
		return

	local latestAssistPlayer = GetEntityFromEncodedEHandle ( attackerEHandle )
	if( !("latestAssistPlayer" in entity.s ) )
	{
		entity.s.latestAssistPlayer <- latestAssistPlayer
		entity.s.latestAssistDamageSource <- damageSourceId
		entity.s.latestAssistTime <- assistTime
	}
	else
	{
		entity.s.latestAssistPlayer = latestAssistPlayer
		entity.s.latestAssistDamageSource = damageSourceId
		entity.s.latestAssistTime = assistTime
	}
}
Globalize( ServerCallback_SetAssistInformation )

function ClientCodeCallback_OnModelChanged( entity )
{
	// OnModelChanged gets called for each model change, but gets processed after the model has done all switches

	if ( !IsValid( entity ) )
		return;

	if ( !("creationCount" in entity.s) )
		return;

	Assert( entity instanceof C_BaseAnimating );
	InitEntityForModel( entity )

	foreach ( callbackInfo in level.onModelChangedCallbacks )
			callbackInfo.func.acall( [callbackInfo.scope, entity] )
}


function InitEntityForModel( entity )
{
	local modelName = entity.GetModelName()
	if ( modelName != entity.s.lastModel )
	{
		entity.Signal( "OnModelChanged" )

		if ( entity.s.lastModel )
		{
			// cleanup any data related to previous model
			ClearModelFXData( entity )
			ClearDamageData( entity )
		}

		if ( modelName != "?" )
		{
			if ( modelName in level.modelFXData )
			{
				foreach ( groupName, groupData in level.modelFXData[modelName].groups )
					InitModelFXGroup( entity, groupName )
			}

			//InitModelDamageData( entity )
		}

		if ( modelName == ATLAS_MODEL )
			entity.DoBodyGroupChangeScriptCallback( true, 7 )

		entity.s.lastModel = modelName
	}
}


function ClientCodeCallback_DodgeStart( player )
{
	if ( !IsValid( player ) )
		return

	if ( "isDodgeRumbling" in player.s )
		return

	local rumbleThread = function( player )
	{
		player.s.isDodgeRumbling <- true

		do
		{
			player.RumbleEffect( 2, 0, 0 )
			wait 0.1
		}
		while ( IsValid( player ) && IsAlive( player ) && player.IsDodging() )

		delete player.s.isDodgeRumbling
	}

	thread rumbleThread( player )
}

function SetupPlayerAnimEvent( player, isRecreate )
{
	if ( isRecreate )
		return

	AddAnimEvent( player, "HMN_Jump_Jet", OnHumanJumpJet )
	AddAnimEvent( player, "HMN_Jump_Jet_Left", OnHumanJumpJetLeft )
	AddAnimEvent( player, "HMN_Jump_Jet_Right", OnHumanJumpJetRight )
	AddAnimEvent( player, "HMN_Jump_Jet_DBL", OnHumanJumpJetDBL )
	AddAnimEvent( player, "HMN_Jump_Jet_WallRun_Left", OnHumanJumpJetWallRun_Left)
	AddAnimEvent( player, "HMN_Jump_Jet_WallRun_Right", OnHumanJumpJetWallRun_Right)
	AddAnimEvent( player, "WallHangAttachDataKnife", WallHangAttachDataKnife )
}

function SetupFirstPersonProxyEvents( firstPersonProxy, isRecreate )
{
	//printt( "SetupFirstPersonProxyEvents" )
	if ( isRecreate )
		return

	AddAnimEvent( firstPersonProxy, "mantle_smallmantle", OnSmallMantle)
	AddAnimEvent( firstPersonProxy, "mantle_mediummantle", OnMediumMantle)
	AddAnimEvent( firstPersonProxy, "mantle_lowmantle", OnLowMantle)
	AddAnimEvent( firstPersonProxy, "mantle_extralowmantle", OnExtraLowMantle)
}

function OnSmallMantle( firstPersonProxy )
{
	local player = GetLocalViewPlayer()

	if ( PlayerHasPassive( player, PAS_STEALTH_MOVEMENT ) )
	{
		//printt( "mantle_smallmantle, has stealth passive" )
	}
	else
	{
		//printt( "mantle_smallmantle, no stealth passive" )
		EmitSoundOnEntity( firstPersonProxy, "mantle_smallmantle" )
	}

}

function OnMediumMantle( firstPersonProxy )
{
	local player = GetLocalViewPlayer()

	if ( PlayerHasPassive( player, PAS_STEALTH_MOVEMENT ) )
	{
		//printt( "mantle_mediummantle, has stealth passive" )
	}
	else
	{
		//printt( "mantle_mediummantle, no stealth passive" )
		EmitSoundOnEntity( firstPersonProxy, "mantle_mediummantle" )
	}
}

function OnLowMantle( firstPersonProxy )
{
	local player = GetLocalViewPlayer()

	if ( PlayerHasPassive( player, PAS_STEALTH_MOVEMENT ) )
	{
		//printt( "mantle_lowmantle, has stealth passive" )
	}
	else
	{
		//printt( "mantle_lowmantle, no stealth passive" )
		EmitSoundOnEntity( firstPersonProxy, "mantle_lowmantle" )
	}
}

function OnExtraLowMantle( firstPersonProxy )
{
	local player = GetLocalViewPlayer()

	if ( PlayerHasPassive( player, PAS_STEALTH_MOVEMENT ) )
	{
		//printt( "mantle_extralowmantle, has stealth passive" )
	}
	else
	{
		//printt( "mantle_extralowmantle, no stealth passive" )
		EmitSoundOnEntity( firstPersonProxy, "mantle_extralow" )
	}
}


function CreateCallback_HealthCore( entity, isRecreate )
{
	if ( GameRules.GetGameMode() == "ctf" )
		thread FlagFXThink( entity )
}

function FlagFXThink( flag )
{
	flag.EndSignal( "OnDestroy" )

	WaitEndFrame() // returning from/entering kill replay seems to kill the effects too late in the frame?

	local player = GetLocalViewPlayer()
	local playerTeam = player.GetTeam()
	local attachID = flag.LookupAttachment( "fx_end" )

	flag.s.fxHandle <- null

	if ( playerTeam == flag.GetTeam() )
		flag.s.fxHandle = StartParticleEffectOnEntity( flag, GetParticleSystemIndex( FLAG_FX_FRIENDLY ), FX_PATTACH_POINT_FOLLOW, attachID )
	else
		flag.s.fxHandle = StartParticleEffectOnEntity( flag, GetParticleSystemIndex( FLAG_FX_ENEMY ), FX_PATTACH_POINT_FOLLOW, attachID )

	OnThreadEnd(
		function() : ( flag )
		{
			if ( !EffectDoesExist( flag.s.fxHandle ) )
				return

			EffectStop( flag.s.fxHandle, false, true )
		}
	)

	flag.WaitSignal( "OnDeath" )
}


function CreateCallback_TitanSoul( entity, isRecreate )
{
	entity.lastShieldHealth = entity.GetShieldHealth()

	local player  = entity.GetBossPlayer()
	if ( IsValid( player ) && ShouldHideBurnCardSelectionText( player ) )
	{
		HideRespawnSelect()
	}
}


function OnHumanJumpJet( player )
{
	local fxID
	local lightID

	if ( PlayerHasPassive( player, PAS_STEALTH_MOVEMENT ) ) //Has to be here as opposed to in SetupPlayerAnimEvent because players can switch classes/get the Stealth Movement Mod mid game
	{
		//printt( "Stealth Jumpjets, OnHumanJumpJet" )
		if ( player.GetTeam() == GetLocalViewPlayer().GetTeam() )
		{
			fxID = GetParticleSystemIndex( STEALTH_TEAM_JUMPJET_ON )
			lightID = null
		}
		else
		{
			fxID = GetParticleSystemIndex( STEALTH_PENEMY_JUMPJET_ON )
			lightID = null
		}
	}
	else
	{
		if ( player.GetTeam() == GetLocalViewPlayer().GetTeam() )
		{
			fxID = GetParticleSystemIndex( TEAM_JUMPJET_ON )
			lightID = GetParticleSystemIndex( TEAM_JUMPJET_RT )
		}
		else
		{
			fxID = GetParticleSystemIndex( PENEMY_JUMPJET_ON )
			lightID = GetParticleSystemIndex( PENEMY_JUMPJET_RT )
		}
	}

	local attachIndexLeft = player.LookupAttachment( "vent_left" )
	local attachIndexRight = player.LookupAttachment( "vent_right" )

	if ( attachIndexLeft == 0 || attachIndexRight == 0 )
		return

	local leftJumpJet = StartParticleEffectOnEntity( player, fxID, FX_PATTACH_POINT_FOLLOW, attachIndexLeft )
	local rightJumpJet = StartParticleEffectOnEntity( player, fxID, FX_PATTACH_POINT_FOLLOW, attachIndexRight )

	local jumpJetEffectsArray = [ leftJumpJet, rightJumpJet ]

	local jumpJetLight
	if ( lightID  )
	{
		jumpJetLight = StartParticleEffectOnEntity( player, lightID, FX_PATTACH_POINT_FOLLOW, attachIndexRight )
		jumpJetEffectsArray.append( jumpJetLight )
	}

	thread CleanUpJumpJetParticleEffect( player, jumpJetEffectsArray )
}

function OnHumanJumpJetLeft( player )
{
	local fxID
	local lightID
	if ( PlayerHasPassive( player, PAS_STEALTH_MOVEMENT ) ) //Has to be here as opposed to in SetupPlayerAnimEvent because players can switch classes/get the Stealth Movement Mod mid game
	{
		//printt( "Stealth Jumpjets, OnHumanJumpJetLeft" )
		if ( player.GetTeam() == GetLocalViewPlayer().GetTeam() )
		{
			fxID = GetParticleSystemIndex( STEALTH_TEAM_JUMPJET_ON )
		}
		else
		{
			fxID = GetParticleSystemIndex( STEALTH_PENEMY_JUMPJET_ON )
		}
	}
	else
	{
		if ( player.GetTeam() == GetLocalViewPlayer().GetTeam() )
		{
			fxID = GetParticleSystemIndex( TEAM_JUMPJET_ON )
		}
		else
		{
			fxID = GetParticleSystemIndex( PENEMY_JUMPJET_ON )
		}
	}

	local attachIndexLeft = player.LookupAttachment( "vent_left" )

	if ( attachIndexLeft == 0 )
		return

	local leftJumpJet = StartParticleEffectOnEntity( player, fxID, FX_PATTACH_POINT_FOLLOW, attachIndexLeft )
	thread CleanUpJumpJetParticleEffect( player, [ leftJumpJet ] )
}

function OnHumanJumpJetRight( player )
{

	local fxID
	local lightID
	if ( PlayerHasPassive( player, PAS_STEALTH_MOVEMENT ) ) //Has to be here as opposed to in SetupPlayerAnimEvent because players can switch classes/get the Stealth Movement Mod mid game
	{
		//printt( "Stealth Jumpjets, OnHumanJumpJetRight" )
		if ( player.GetTeam() == GetLocalViewPlayer().GetTeam() )
		{
			fxID = GetParticleSystemIndex( STEALTH_TEAM_JUMPJET_ON )
		}
		else
		{
			fxID = GetParticleSystemIndex( STEALTH_PENEMY_JUMPJET_ON )
		}
	}
	else
	{
		if ( player.GetTeam() == GetLocalViewPlayer().GetTeam() )
		{
			fxID = GetParticleSystemIndex( TEAM_JUMPJET_ON )
		}
		else
		{
			fxID = GetParticleSystemIndex( PENEMY_JUMPJET_ON )
		}
	}

	local attachIndexRight = player.LookupAttachment( "vent_right" )

	if ( attachIndexRight == 0 )
		return

	local rightJumpJet = StartParticleEffectOnEntity( player, fxID, FX_PATTACH_POINT_FOLLOW, attachIndexRight )

	thread CleanUpJumpJetParticleEffect( player, [ rightJumpJet ] )
}

function OnHumanJumpJetDBL( player )
{
	local fxID
	local lightID
	if ( PlayerHasPassive( player, PAS_STEALTH_MOVEMENT ) ) //Has to be here as opposed to in SetupPlayerAnimEvent because players can switch classes/get the Stealth Movement Mod mid game
	{
		//printt( "Stealth Jumpjets, OnHumanJumpJetDBL" )
		if ( player.GetTeam() == GetLocalViewPlayer().GetTeam() )
		{
			fxID = GetParticleSystemIndex( STEALTH_TEAM_JUMPJET_DBL )
		}
		else
		{
			fxID = GetParticleSystemIndex( STEALTH_PENEMY_JUMPJET_DBL )
		}
	}
	else
	{
		if ( player.GetTeam() == GetLocalViewPlayer().GetTeam() )
		{
			fxID = GetParticleSystemIndex( TEAM_JUMPJET_DBL )
		}
		else
		{
			fxID = GetParticleSystemIndex( PENEMY_JUMPJET_DBL )
		}
	}

	local attachIndexLeft = player.LookupAttachment( "vent_left" )
	local attachIndexRight = player.LookupAttachment( "vent_right" )

	if ( attachIndexLeft == 0 || attachIndexRight == 0 )
		return

	local leftJumpJet = StartParticleEffectOnEntity( player, fxID, FX_PATTACH_POINT_FOLLOW, attachIndexLeft )
	local rightJumpJet = StartParticleEffectOnEntity( player, fxID, FX_PATTACH_POINT_FOLLOW, attachIndexRight )

	//No need to thread this off since it is a one time effect unlike wallrun and normal jumpjet effects which are looping
	//thread CleanUpJumpJetParticleEffect( player, [ leftJumpJet, rightJumpJet ] )
}

function OnHumanJumpJetWallRun_Left( player )
{
	local fxID
	if ( PlayerHasPassive( player, PAS_STEALTH_MOVEMENT ) ) //Has to be here as opposed to in SetupPlayerAnimEvent because players can switch classes/get the Stealth Movement Mod mid game
	{
		//printt( "Stealth Jumpjets, OnHumanJumpWallRun_Left" )
		if ( player.GetTeam() == GetLocalViewPlayer().GetTeam() )
		{
			fxID = GetParticleSystemIndex( STEALTH_TEAM_JUMPJET_WR )
		}
		else
		{
			fxID = GetParticleSystemIndex( STEALTH_PENEMY_JUMPJET_WR )
		}
	}
	else
	{
		if ( player.GetTeam() == GetLocalViewPlayer().GetTeam() )
		{
			fxID = GetParticleSystemIndex( TEAM_JUMPJET_WR )
		}
		else
		{
			fxID = GetParticleSystemIndex( PENEMY_JUMPJET_WR )
		}
	}

	local attachIndexLeft = player.LookupAttachment( "vent_left_out" )

	if ( attachIndexLeft == 0 )
		return

	local leftJumpJet = StartParticleEffectOnEntity( player, fxID, FX_PATTACH_POINT_FOLLOW, attachIndexLeft )
	thread CleanUpJumpJetParticleEffect( player, [ leftJumpJet ] )
}

function OnHumanJumpJetWallRun_Right( player )
{
	local fxID
	if ( PlayerHasPassive( player, PAS_STEALTH_MOVEMENT ) ) //Has to be here as opposed to in SetupPlayerAnimEvent because players can switch classes/get the Stealth Movement Mod mid game
	{
		//printt( "Stealth Jumpjets, OnHumanJumpWallRun_Right" )
		if ( player.GetTeam() == GetLocalViewPlayer().GetTeam() )
		{
			fxID = GetParticleSystemIndex( STEALTH_TEAM_JUMPJET_WR )
		}
		else
		{
			fxID = GetParticleSystemIndex( STEALTH_PENEMY_JUMPJET_WR )
		}

	}
	else
	{
		if ( player.GetTeam() == GetLocalViewPlayer().GetTeam() )
		{
			fxID = GetParticleSystemIndex( TEAM_JUMPJET_WR )
		}
		else
		{
			fxID = GetParticleSystemIndex( PENEMY_JUMPJET_WR )
		}
	}

	local attachIndexRight = player.LookupAttachment( "vent_right_out" )

	if ( attachIndexRight == 0 )
		return

	local rightJumpJet = StartParticleEffectOnEntity( player, fxID, FX_PATTACH_POINT_FOLLOW, attachIndexRight )
	thread CleanUpJumpJetParticleEffect( player, [ rightJumpJet ] )
}

function CleanUpJumpJetParticleEffect( player, particleEffects )
{
	player.EndSignal( "OnDeath" )
	player.EndSignal( "OnDestroy" )
	//printt( "Entering CleanUpJumpJetParticleEffect" )

	OnThreadEnd
	(
		function() : ( particleEffects )
		{
			//printt( "Ending CleanUpJumpJetParticleEffect " )
			foreach( particle in particleEffects )
			{
				if ( EffectDoesExist( particle ) )
				{
					//printt( "Should be Stopping particle: " + particle )
					EffectStop( particle, true, true )
				}

			}
		}
	)

	if ( player.IsWallRunning() ) //When wallrunning player.IsOnGround() is true
	{
		for ( ;; ) //Bad since we are polling, but clWaitTillAnimDone() doesn't seem to work :/
		{
			Wait( 0.1 )
			if ( !player.IsWallRunning() )
				return
		}
	}
	else
	{
		for ( ;; ) //Bad since we are polling, but clWaitTillAnimDone() doesn't seem to work :/
		{
			Wait( 0.1 )
			if ( player.IsOnGround() )
				break
		}
	}


}

function WallHangAttachDataKnife( player )
{
	if ( !("dataknife" in player.s) || !isValid( player.s.dataknife ) )
	{
		local attachIdx = player.LookupAttachment( "l_hand" )
		if ( attachIdx == 0 ) // hack while i wait for the attachment to be fixed
			return

		local dataknife = CreateClientSidePropDynamic( player.GetAttachmentOrigin( attachIdx ), player.GetAttachmentAngles( attachIdx ), DATA_KNIFE_MODEL )
		dataknife.SetParent( player, "l_hand" )

		thread DeleteDataKnifeAfterWallHang( player, dataknife )
	}
}

function DeleteDataKnifeAfterWallHang( player, dataknife )
{
	OnThreadEnd(
		function() : ( dataknife )
		{
			if ( IsValid( dataknife ) )
				dataknife.Kill()
		}
	)

	player.EndSignal( "OnDeath" )
	player.EndSignal( "OnDestroy" )

	for ( ;; )
	{
		Wait( 0.1 )
		if ( !player.IsWallHanging() )
			break
	}
}

function IsScriptGibTarget( victim )
{
	if ( victim.GetSignifierName() == "npc_soldier" )
		return true

	if ( victim.IsPlayer() && !victim.IsTitan() )
		return true

	if ( victim.GetModelName() == FLYER_MODEL )
		return true

	return false
}

function CodeCallback_OnGib( victim, modelName, attackDir, onFire )
{
	if ( victim.IsSpectre() || victim.IsPlayer() && victim.GetPlayerSettingsField( "footstep_type" ) == "robot" )
	{
		return SpectreGibExplode( victim, modelName, attackDir, onFire )
	}

	if ( !IsScriptGibTarget( victim ) )
		return false

	attackDir.Normalize()

	local cullDist = 2048
	if ( "gibDist" in victim.s )
		cullDist = victim.s.gibDist

	local startOrigin = victim.GetWorldSpaceCenter() + (attackDir * -30)

	local origin = victim.GetOrigin() + Vector( RandomInt( 10, 20 ), RandomInt( 10, 20 ), RandomInt( 32, 64 ) )
	local angles = Vector( 0, 0, 0 )
	local flingDir = attackDir * RandomInt( 80, 200 )

	local fxID
	local isSoftenedLocale = IsSoftenedLocale()

	if ( isSoftenedLocale )
	{
		if ( victim.GetModelName() == FLYER_MODEL )
			fxID = StartParticleEffectOnEntity( victim, GetParticleSystemIndex( "death_pinkmist_LG_nochunk" ), FX_PATTACH_ABSORIGIN_FOLLOW, 0 )
		else
			fxID = StartParticleEffectOnEntity( victim, GetParticleSystemIndex( "death_pinkmist_nochunk" ), FX_PATTACH_ABSORIGIN_FOLLOW, 0 )
	}
	else
	{
		if ( victim.GetModelName() == FLYER_MODEL )
			fxID = StartParticleEffectOnEntity( victim, GetParticleSystemIndex( "death_pinkmist_LG" ), FX_PATTACH_ABSORIGIN_FOLLOW, 0 )
		else
			fxID = StartParticleEffectOnEntity( victim, GetParticleSystemIndex( "death_pinkmist" ), FX_PATTACH_ABSORIGIN_FOLLOW, 0 )
	}

	EffectSetControlPointVector( fxID, 1, flingDir )

	if ( isSoftenedLocale )
		return true

	local angularVel = Vector( 0, 0, 0 )
	local lifeTime = 10.0
	local gib = CreateClientsideGib( modelName, origin, angles, flingDir, angularVel, lifeTime, cullDist, 1024 )

	if ( !gib )
		return true

	local bgCount = gib.GetBodyGroupModelCount( 0 )
	if ( GetCPULevel() == CPU_LEVEL_MINSPEC )
		bgCount = min( bgCount, 1 )

	for ( local i = 0; i < bgCount; i++ )
	{
		origin = victim.GetOrigin() + Vector( RandomInt( 10, 20 ), RandomInt( 10, 20 ), RandomInt( 32, 64 ) )
		flingDir = attackDir * RandomInt( 200, 800 )
		gib = CreateClientsideGib( modelName, origin, angles, flingDir, angularVel, lifeTime, cullDist, 1024 )
		if ( !gib )
			continue

		gib.SetBodygroup( 0, i )
	}

	return true
}


function DropPodZoomIn( dropPod, param )
{
	thread ZoomFunc( param, 10.0, 0.25 )
}

function DropPodZoomOut( dropPod, param )
{
	thread ZoomFunc( param, 25.0, 0.25 )
}

function ZoomFunc( camera, fov, duration )
{
	local startFOV = camera.s._fov
	local startTime = Time()

	while ( camera.s._fov != fov )
	{
		local newFOV = GraphCapped( Time() - startTime, 0.0, duration, startFOV, fov )
		camera.s._fov = newFOV
		camera.SetFOV( newFOV )
		wait 0
	}
}

function DropPodFPThink( player, dropPod )
{
	RegisterSignal( "OnImpact" )

	local attachID = dropPod.LookupAttachment( "REF" )

	local origin = dropPod.GetAttachmentOrigin( attachID )

	local index = GetParticleSystemIndex( "ar_titan_droppoint" )
	local fxID = StartParticleEffectInWorldWithHandle( index, origin, Vector( 0, 0, 0 ) )
	EffectSetControlPointVector( fxID, 1, Vector( 100, 255, 100 ) )

	dropPod.WaitSignal( "OnImpact" )

	EffectStop( fxID, true, false )
}

function ClientCodeCallback_OnMissileCreation( missileEnt, weaponName, firstTime )
{
	if ( !IsValid( missileEnt ) )
		return

	//Called for all projectiles, not just missiles.
	TryAddGrenadeIndicator( missileEnt, weaponName )

	switch ( weaponName )
	{
		case "mp_weapon_satchel":
		case "mp_weapon_proximity_mine":

		// only add the effects on server-created satchels
			if ( missileEnt.IsClientCreated() )
				return

			if ( IsClient() )
			{
				local player = missileEnt.GetOwner()
				if ( player == GetLocalViewPlayer() )
				{
					player.s.activeTraps[ missileEnt ] <- weaponName
				}
			}

			missileEnt.s.grenadeEffectHandles <- []

			// blinking status light FX
			local attachID = missileEnt.LookupAttachment( "LIGHT" )
			if ( attachID <= 0 )
				attachID = missileEnt.LookupAttachment( "BLINKER" )
			Assert( attachID > 0 )
			local handle = StartParticleEffectOnEntity( missileEnt, GetParticleSystemIndex( "wpn_laser_blink" ), FX_PATTACH_POINT_FOLLOW, attachID )

			local color = ENEMY_COLOR_FX
			if ( missileEnt.GetTeam() == GetLocalViewPlayer().GetTeam() )
				color = FRIENDLY_COLOR_FX

			local colorVec = Vector( color[0], color[1], color[2] )
			EffectSetControlPointVector( handle, 1, colorVec )

			missileEnt.s.grenadeEffectHandles.append( handle )
			break

		case "mp_weapon_orbital_strike":
			// Orbital strike plays additional effect
			local trailAttachment = GetWeaponInfoFileKeyField_Global( weaponName, "projectile_trail_attachment" )
			local trailAttachmentIndex = missileEnt.LookupAttachment( trailAttachment )
			StartParticleEffectOnEntity( missileEnt, file.orbitalstrike_tracer, FX_PATTACH_POINT, trailAttachmentIndex )
			break

		case "mp_weapon_laser_mine":
			AddToLaserMines( missileEnt )
			break

		case "mp_weapon_frag_grenade":
			if ( missileEnt.GetTeam() == GetLocalViewPlayer().GetTeam() )
				thread GrenadeFXThread( missileEnt, "P_wpn_grenade_frag_icon" )
			break

		case "mp_weapon_grenade_emp":
			if ( missileEnt.GetTeam() == GetLocalViewPlayer().GetTeam() )
				thread GrenadeFXThread( missileEnt, "P_wpn_grenade_frag_blue_icon" )
			break
	}
}


function GrenadeFXThread( grenadeEnt, effectName )
{
	local effect = StartParticleEffectOnEntity( grenadeEnt, GetParticleSystemIndex( effectName ), FX_PATTACH_ABSORIGIN_FOLLOW, 0 )

	grenadeEnt.WaitSignal( "OnDestroy" )

	if ( EffectDoesExist( effect ) )
		EffectStop( effect, false, true )
}


function ServerCallback_PlayScreenFXWarpJump()
{
	local player = GetLocalViewPlayer()
	local index = GetParticleSystemIndex( SCREENFX_WARPJUMP )
	local indexD = GetParticleSystemIndex( SCREENFX_WARPJUMPDLIGHT )
	local fxID = StartParticleEffectInWorldWithHandle( index, Vector( 0,0,0 ), Vector(0,0,0 ) )

	if ( IsValid( player.GetCockpit() ) )
	{
		local fxID2 = StartParticleEffectOnEntity( player, indexD, FX_PATTACH_POINT_FOLLOW, player.GetCockpit().LookupAttachment( "CAMERA" ) )
		EffectSetIsWithCockpit( fxID2, true )
		delaythread( 2.5 ) TonemappingUpdateAfterWarpJump()
	}
}

function TonemappingUpdateAfterWarpJump()
{
	local START_DURATION = 0.2
	const TONEMAP_MAX = 5
	const TONEMAP_MIN = 400

	//SetCockpitLightingEnabled( 0, false )

	local startTime = Time()
	while( 1 )
	{
		local time = Time() - startTime
		local factor = GraphCapped( time, 0, START_DURATION, 1, 0 )
		factor = factor * factor * factor
		local toneMapScale = TONEMAP_MIN + (TONEMAP_MAX - TONEMAP_MIN) * factor
		ResetTonemapping( 0, toneMapScale )

		if ( factor == 0 )
			break;
		wait  0
	}

	local START_DURATION = 1.0
	const TONEMAP_MAX = 400//25
	const TONEMAP_MIN = 5

//	ResetTonemapping( 0, TONEMAP_MAX )

//	wait 0.2

	local startTime = Time()
	while( 1 )
	{
		local time = Time() - startTime
		local factor = GraphCapped( time, 0, START_DURATION, 1, 0 )
		factor = factor * factor * factor
		local toneMapScale = TONEMAP_MIN + (TONEMAP_MAX - TONEMAP_MIN) * factor
		ResetTonemapping( 0, toneMapScale )

		if ( factor == 0 )
			break;
		wait  0
	}
}


function StopUsePrompt( player, ent )
{
	if ( !file.usePrompt )
		return

	if ( file.usePrompt.ent != ent )
		return

	file.usePrompt.mode = "hide"
}

function DrawUsePrompt( player, ent )
{
	if ( file.usePrompt )
	{
		// prompt already exists
		file.usePrompt.mode = "draw"
		file.usePrompt.ent = ent
		return
	}

	thread UsePromptDrawForUsableEnt( ent )
}

function UsePromptDrawForUsableEnt( ent )
{
	// create the prompt
	local size = USE_PROMPT_SIZE
	local usePrompt = {}
	file.usePrompt = usePrompt

	OnThreadEnd(
		function () : ()
		{
			InfoFlyout_Hide()
			file.usePrompt = null
		}
	)

	local player = GetLocalViewPlayer()
	if ( !IsAlive( player ) )
		return
	player.EndSignal( "OnDeath" )

	usePrompt.mode <- "draw"
	usePrompt.size <- size
	usePrompt.ent <- ent
	ent.EndSignal( "OnDeath" )

	local msg = ent.IsTitan() ? "#HINT_RODEO_ALT" : "#RIDE"

	InfoFlyout_TitleShow( "#USE_KEY_BINDING", msg, ent, "HATCH_HEAD" )
	//InfoFlyout_IconShow( "HUD/loadout/xbutton", msg, ent, "HATCH_HEAD" )

	for ( ;; )
	{
		if ( !ShouldDrawUsePrompt( usePrompt ) )
			break

		wait 0
	}
}

function DirectUsePromptDraw( player, ent )
{
	if ( !IsAlive( player ) )
		return
	player.EndSignal( "OnDeath" )
	ent.EndSignal( "OnDeath" )

	// create the prompt
	local size = USE_PROMPT_SIZE
	local usePrompt = {}
	file.usePrompt = usePrompt

	OnThreadEnd(
		function () : ()
		{
			InfoFlyout_Hide()
			file.usePrompt = null
		}
	)

	usePrompt.mode <- "draw"
	usePrompt.size <- size
	usePrompt.ent <- ent

	local msg = "Hijack"

	InfoFlyout_IconShow( "HUD/loadout/xbutton", msg, ent, "HATCH_HEAD" )

	for ( ;; )
	{
		if ( player.GetParent() != ent )
			break

		if ( player.GetTeam() == ent.GetTeam() )
			break

		wait 0
	}
}

function ShouldDrawUsePrompt( usePrompt )
{
	local player = GetLocalViewPlayer()
	if ( player.GetParent() )
		return false
	if ( !IsAlive( usePrompt.ent ) )
		return false

	// currently it is titan only
	if ( !usePrompt.ent.IsTitan() && !usePrompt.ent.IsZipline() )
		return false

	return usePrompt.mode == "draw"
}


function ShoulDrawDamageData( damageData )
{
	if ( !( "scale" in damageData ) ) // Only damage that should be indicated has scale added
		return false

	if ( "rodeoDamage" in damageData )
		return false

	return true
}

function ShowLoadoutHint( player )
{
	file.changeLoadoutBackground.Show()
	file.changeLoadoutText.Show()
}

function HideLoadoutHint( player )
{
	file.changeLoadoutBackground.Hide()
	file.changeLoadoutText.Hide()
}

function InitLoadoutReminder()
{
	file.changeLoadoutBackground <- HudElement( "changeLoadoutBackground" )
	file.changeLoadoutText <- HudElement( "changeLoadoutText" )
	file.changeLoadoutText.EnableKeyBindingIcons()
	file.changeLoadoutBackground.Hide()
	file.changeLoadoutText.Hide()

	file.HudBurnCard_OnDeckCard <- {}
	local hudElement = HudElement( "HudBurnCard_OnDeckCard" )
	CreateBurnCardPanel( file.HudBurnCard_OnDeckCard, hudElement )

	file.HudBurnCard_OnDeckCard.selectButton <- HudElement( "HudBurnCard_OnDeckCard_Select" )
	file.HudBurnCard_OnDeckCard.selectButton.EnableKeyBindingIcons()

//	file.HudBurnCard_Reminder <- HudElement( "HudBurnCard_Reminder" )

	HideBurnCardOnDeckCard()

	InitBurnCardSelector()

}

function GetBurnCardOnDeckOrActive( player )
{
	local slot = GetPlayerBurnCardOnDeckIndex( player )
	if ( slot != null )
	{
		local cardRef = GetPlayerActiveBurnCardSlotContents( player, slot )
		if ( cardRef != null )
		{
			return { cardRef = cardRef, msg = "#BC_ON_DECK", r = 255, g = 205, b = 35, a = 255, active = false }
		}
	}

	if ( ACTIVE_BURN_CARD_PREVIEW && !IsWatchingKillReplay() )
	{
		// not trying to draw on deck preview, so draw the active card if there is one active
		local cardRef = GetPlayerActiveBurnCard( player )

		if ( cardRef != null )
		{
			return { cardRef = cardRef, msg = "#BC_ACTIVE_SLOT", r = 55, g = 205, b = 55, a = 255, active = true }
		}
	}

	return null
}
Globalize( GetBurnCardOnDeckOrActive )

function UpdateBurnCardOnDeckOrActiveCard( table = null )
{
	if ( table )
	{
		UpdateBurnCardOnDeckOrActivePreviewText( table.cardRef, table.msg, table.r, table.g, table.b, table.a )
		return
	}
	else
	{
		// Sets the look of the card to empty, no card is selected for use
		file.HudBurnCard_OnDeckCard.title.Show()
		file.HudBurnCard_OnDeckCard.title.SetText( "#BURNCARD" )

		file.HudBurnCard_OnDeckCard.title.SetColor( 255, 255, 255, 32 )
		file.HudBurnCard_OnDeckCard.BurnCardMid_BottomText.Hide()

		file.HudBurnCard_OnDeckCard.image.SetAlpha( 0 )
		file.HudBurnCard_OnDeckCard.image.SetImage( "burncards/burncard_mid_icon_template")

		file.HudBurnCard_OnDeckCard.background.SetImage( "burncards/burncard_mid_blank")
		HideBurnCard( file.HudBurnCard_OnDeckCard )
	}
}
Globalize( UpdateBurnCardOnDeckOrActiveCard )

function UpdateBurnCardOnDeckOrActivePreviewText( cardRef, msg, r, g, b, a )
{
	// set card
	SetBurnCardToCard( file.HudBurnCard_OnDeckCard, true, cardRef )
	file.HudBurnCard_OnDeckCard.BurnCardMid_BottomText.Show()
	file.HudBurnCard_OnDeckCard.BurnCardMid_BottomText.SetText( msg )
	file.HudBurnCard_OnDeckCard.BurnCardMid_BottomText.SetColor( r, g, b, a )
}

function ServerCallback_UpdateOnDeckIndex()
{
	local player = GetLocalClientPlayer()
	if ( IsValid( player ) )
	{
		UpdateAndShowBurnCardOnDeckOrActive( player )
		UpdateAndShowBurnCardSelectors( player )
		UpdateBurnCardPrematchButtonText( player )
		player.Signal( "ChangedOnDeckBurncard" )
	}
}
Globalize( ServerCallback_UpdateOnDeckIndex )

function HideBurnCardOnDeckCard()
{
	HideBurnCard( file.HudBurnCard_OnDeckCard )
	file.HudBurnCard_OnDeckCard.panel.Hide()
	file.HudBurnCard_OnDeckCard.selectButton.Hide()
}
Globalize( HideBurnCardOnDeckCard )

function ShowBurnCardOnDeckCard()
{
	local elemTable = file.HudBurnCard_OnDeckCard
	ShowBurnCard( elemTable )

	if ( !elemTable.panel.IsVisible() )
	{
		if ( level.nv.gameState != eGameState.Prematch )
		{
			elemTable.panel.SetPinSibling( "OnDeckCard_RespawnSelect_Anchor" )
			elemTable.selectButton.Show()
			HideBurnCardOnDeckCard()
			return
		}
		else
		{
			elemTable.panel.SetPinSibling( "OnDeckCard_Prematch_Anchor" )
		}

		elemTable.panel.Show()
	}

	local player = GetLocalClientPlayer()
	local cardTable = GetBurnCardOnDeckOrActive( player )
	local shouldHideBurnCardSelectionText = ShouldHideBurnCardSelectionText( player )

	if ( shouldHideBurnCardSelectionText )
	{
		elemTable.selectButton.SetText( "" )
	}
	else if ( cardTable )
	{
		if ( cardTable.active )
			elemTable.selectButton.SetText( "" )
		else
			elemTable.selectButton.SetText( "#BURNCARD_CHANGE" )
	}
	else
	{
		elemTable.selectButton.SetText( "#BURNCARD_SELECT" )
	}

	if ( cardTable )
	{
		elemTable.background.Show()
	}
	else
	{
		elemTable.background.Show()
		elemTable.title.Show()
		elemTable.image.Show()
		elemTable.image.SetAlpha( 255 )
		SetBurnCardToCard( elemTable, true, "bc_auto_refill" )

		if ( shouldHideBurnCardSelectionText )
			HideBurnCard( elemTable )


		//elemTable.reminder.Show()
//		elemTable.background.Hide()
	}
}
Globalize( ShowBurnCardOnDeckCard )

function SlideBurnCardIn( player )
{
	player.EndSignal( "OnDestroy" )
	local panel = file.HudBurnCard_OnDeckCard.panel
	panel.SetPanelAlpha( 0 )
	local pos = panel.GetBasePos()
	panel.SetPos( pos[0] + 1020, pos[1] )

	OnThreadEnd(
		function() : ( panel, pos )
		{
			panel.MoveOverTime( pos[0], pos[1], 0.5, INTERPOLATOR_DEACCEL )

			thread SetPanelAlphaOverTime( panel, 255, 0.5 )
		}
	)

	player.EndSignal( "ChangedOnDeckBurncard" )
	wait 0.8
}
Globalize( SlideBurnCardIn )

function SetPanelAlphaOverTime( panel, alpha, duration )
{
	Signal( panel, "PanelAlphaOverTime" )
	EndSignal( panel, "PanelAlphaOverTime" )
	EndSignal( panel, "OnDestroy" )

	local startTime = Time()
	local endTime = startTime + duration
	local startAlpha = panel.GetPanelAlpha()

	while( Time() <= endTime )
	{
		local a = GraphCapped( Time(), startTime, endTime, startAlpha, alpha )
		panel.SetPanelAlpha( a )
		wait 0
	}

	panel.SetPanelAlpha( alpha )
}


function UpdateAndShowBurnCardOnDeckOrActive( player )
{
	local table = GetBurnCardOnDeckOrActive( player )
	UpdateBurnCardOnDeckOrActiveCard( table )

	if ( ShouldShowOnDeckCard( player, table ) )
		ShowBurnCardOnDeckCard()
	else
		HideBurnCardOnDeckCard()
}
Globalize( UpdateAndShowBurnCardOnDeckOrActive )

function ShouldShowOnDeckCard( player, cardOnDeck )
{
	local inPrematch = level.nv.gameState == eGameState.Prematch

	if ( IsAlive( player ) && !IsWatchingKillReplay() && !inPrematch )
		return false

	if ( inPrematch && !cardOnDeck )
		return false

	return true
}

function HandleDoomedState( player, titan )
{
	if ( !("wasDoomed" in titan.s) )
		titan.s.wasDoomed <- false

	local isDoomed = titan.GetDoomedState()
	if ( isDoomed && !titan.s.wasDoomed )
	{
		titan.Signal( "Doomed" )

		if ( titan == GetHealthBarEntity( player ) )
			player.Signal( "DoomedTarget" )

		//Attrition score splash in lower left needs to handle doomed titans, not just killed enemies
		if ( GameRules.GetGameMode() == ATTRITION )
			level.ent.Signal( "AttritionPoints", { scoreVal = ATTRITION_SCORE_TITAN, attacker = player } )
	}

	titan.s.wasDoomed = titan.GetDoomedState()
}


function ClientCodeCallback_OnHealthChanged( entity, oldHealth, newHealth )
{
	if ( IsLobby() )
		return;

	local player = GetLocalViewPlayer()
	if ( !IsValid( player ) )
		return

	if ( !IsValid( entity ) )
		return

	if ( entity.IsTitan() )
		HandleDoomedState( player, entity )

	if ( entity == GetHealthBarEntity( player ) && !IsAlive( entity ) )
		SetHealthBarEntity( player, null )

	entity.Signal( "HealthChanged" )
}

function ClientCodeCallback_OnCrosshairTargetChanged( player, oldTarget, newTarget )
{
	if ( IsLobby() )
		return;

	if ( !IsValid( player ) )
		return

	local entity = HealthBarOverlayHUD_GetEntity( player, newTarget )

	player.s.crosshairEntity = entity

	player.Signal( "CrosshairTargetChanged", { oldTarget = oldTarget, newTarget = newTarget } )

	if ( !IsValid( entity ) )
	{
		thread ClearHealthBarEntityAfterDelay( player )
	}
	else
	{
		if( ShouldShowHealthBarOnEntity( entity ) )
			SetHealthBarEntity( player, entity )
	}
}

function GetHealthBarEntity( player )
{
	if ( !IsValid( player.s.healthBarEntity ) )
		return null

	return player.s.healthBarEntity
}


function SetHealthBarEntity( player, entity )
{
	if ( entity )
		entity.EnableHealthChangedCallback()

	local info = { oldEntity = GetHealthBarEntity( player ), newEntity = entity }

	player.s.healthBarEntity = entity
	player.Signal( "HealthBarEntityTargetChanged", info )

	if ( IsValid( entity ) )
		thread ClearHealthBarEntityOnDestroy( player, entity )
}


function ClearHealthBarEntityAfterDelay( player )
{
	player.EndSignal( "HealthBarEntityTargetChanged" )

	wait HEALTH_BAR_ENTITY_TIME

	SetHealthBarEntity( player, null )
}


function ClearHealthBarEntityOnDestroy( player, entity )
{
	player.EndSignal( "HealthBarEntityTargetChanged" )

	OnThreadEnd(
		function() : ( player, entity )
		{
			if ( IsValid( entity ) )
				return

			if ( entity == player.s.healthBarEntity )
				SetHealthBarEntity( player, null )
		}
	)

	entity.WaitSignal( "OnDestroy" )
}


function HealthBarOverlayHUD_GetEntity( player, entity )
{
	if ( !IsAlive( entity ) )
		return null

	if ( entity == player )
		return null

	if ( IsMultiplayer() )
	{
		if ( HEALTH_BARS_ENEMIES_ONLY && !( IsEnemyTeam( player, entity ) ) )
			return null
	}

	// Only select titans, or ents that are in the allow list
	local entType = entity.GetSignifierName()
	if ( !entity.IsTitan() && !( entType in PLAYER_HEALTH_BAR_CLASSNAMES ) )
		return null

	if ( entity.IsTitan() )
	{
		if ( !HasSoul( entity ) )
			return null

		if ( entity.GetTitanSoul().GetInvalidHealthBarEnt() )
			return null
	}

	if ( IsShoulderTurret( entity ) )
		return null

	return entity
}


function GetHealthBarTargetEntity( player )
{
	if ( !COCKPIT_HEALTHBARS )
		return null

	local titanBeingRodeoed = GetTitanBeingRodeoed( player )
	if ( IsValid( titanBeingRodeoed ) && titanBeingRodeoed.GetTeam() != player.GetTeam() )
		return titanBeingRodeoed

	if ( !IsAlive( GetHealthBarEntity( player ) ) )
		return null

	if ( !GetHealthBarEntity( player ).IsTitan() )
		return null

	return player.s.healthBarEntity
}


function IsEnemyTeam( firstEntity, secondEntity )
{
	if ( ( firstEntity.GetTeamNumber() == TEAM_MILITIA ) && ( secondEntity.GetTeamNumber() == TEAM_IMC ) )
		return true
	if ( ( secondEntity.GetTeamNumber() == TEAM_MILITIA ) && ( firstEntity.GetTeamNumber() == TEAM_IMC ) )
		return true
	return false
}

SHIELD_BREAK_FX <- "P_xo_armor_break_CP"
function PlayShieldBreakEffect( soul )
{
	local titan = soul.GetTitan()
	if ( !titan || !titan.IsTitan() )
		return

	local shieldHealthFrac = GetShieldHealthFrac( titan )

	shieldBreakFX <- GetParticleSystemIndex( SHIELD_BREAK_FX )
	local attachID = titan.LookupAttachment( "exp_torso_main" )

	local shieldFXHandle = StartParticleEffectOnEntity( titan, shieldBreakFX, FX_PATTACH_POINT_FOLLOW, attachID )
	EffectSetControlPointVector( shieldFXHandle, 1, GetShieldEffectCurrentColor( 1 - shieldHealthFrac ) )
}

//SHIELD_FX <- "P_xo_armor_impact"
SHIELD_BODY_FX <- "P_xo_armor_body_CP"
function PlayShieldHitEffect( params )
{
	local player = GetLocalViewPlayer()
	local victim = params.victim
	local damagePosition = params.damagePosition
	local hitBox = params.hitBox
	local damageType = params.damageType
	local damageAmount = params.damageAmount
	local damageFlags = params.damageFlags
	local hitGroup = params.hitGroup
	local weapon = params.weapon
	local distanceFromAttackOrigin = params.distanceFromAttackOrigin

	//shieldFX <- GetParticleSystemIndex( SHIELD_FX )
	//StartParticleEffectInWorld( shieldFX, damagePosition, player.GetViewVector() * -1 )

	local shieldHealthFrac = GetShieldHealthFrac( victim )

	shieldbodyFX <- GetParticleSystemIndex( SHIELD_BODY_FX )
	local attachID = victim.LookupAttachment( "exp_torso_main" )

	local shieldFXHandle = StartParticleEffectOnEntity( victim, shieldbodyFX, FX_PATTACH_POINT_FOLLOW, attachID )

	if ( victim.IsTitan() && victim.IsPlayer() && PlayerHasPassive( victim, PAS_SHIELD_BOOST ) )
		EffectSetControlPointVector( shieldFXHandle, 1, Vector( SHIELD_BOOST_R, SHIELD_BOOST_G, SHIELD_BOOST_B ) )
	else
		EffectSetControlPointVector( shieldFXHandle, 1, GetShieldEffectCurrentColor( 1 - shieldHealthFrac ) )
}

SHIELD_COLOR_CHARGE_FULL	<- { r = 115, g = 247, b = 255 }	// blue
SHIELD_COLOR_CHARGE_MED		<- { r = 200, g = 128, b = 80 } // orange
SHIELD_COLOR_CHARGE_EMPTY 	<- { r = 200, g = 80, b = 80 } // red

const SHIELD_COLOR_CROSSOVERFRAC_FULL2MED	= 0.75  // from zero to this fraction, fade between full and medium charge colors
const SHIELD_COLOR_CROSSOVERFRAC_MED2EMPTY	= 0.95  // from "full2med" to this fraction, fade between medium and empty charge colors

function GetShieldEffectCurrentColor( shieldHealthFrac )
{
	local color1 = SHIELD_COLOR_CHARGE_FULL
	local color2 = SHIELD_COLOR_CHARGE_MED
	local color3 = SHIELD_COLOR_CHARGE_EMPTY

	local crossover1 = SHIELD_COLOR_CROSSOVERFRAC_FULL2MED  // from zero to this fraction, fade between color1 and color2
	local crossover2 = SHIELD_COLOR_CROSSOVERFRAC_MED2EMPTY  // from crossover1 to this fraction, fade between color2 and color3

	local colorVec = Vector( 0, 0, 0 )
	// 0 = full charge, 1 = no charge remaining
	if ( shieldHealthFrac < crossover1 )
	{
		colorVec.x = Graph( shieldHealthFrac, 0, crossover1, color1.r, color2.r )
		colorVec.y = Graph( shieldHealthFrac, 0, crossover1, color1.g, color2.g )
		colorVec.z = Graph( shieldHealthFrac, 0, crossover1, color1.b, color2.b )
	}
	else if ( shieldHealthFrac < crossover2 )
	{
		colorVec.x = Graph( shieldHealthFrac, crossover1, crossover2, color2.r, color3.r )
		colorVec.y = Graph( shieldHealthFrac, crossover1, crossover2, color2.g, color3.g )
		colorVec.z = Graph( shieldHealthFrac, crossover1, crossover2, color2.b, color3.b )
	}
	else
	{
		// for the last bit of overload timer, keep it max danger color
		colorVec.x = color3.r
		colorVec.y = color3.g
		colorVec.z = color3.b
	}

	return colorVec
}


function UpdateRespawnHUD()
{
	if ( IsWatchingKillReplay() )
		return

	local player = GetLocalClientPlayer()
	ShowRespawnSelect( player )
}

RegisterSignal( "OnClientPlayerAlive" )
function OnClientPlayerAlive( player )
{
	player.Signal( "OnClientPlayerAlive" ) // TEMP; this should not be necessary, but IsWatchingKillReplay is wrong
	player.EndSignal( "OnClientPlayerAlive" )

	SmartGlass_SetGameStateProperty( SMARTGLASS_PROP_ISALIVE, "1" )
	SmartGlass_SendEvent( "playerAlive", "", "", "" )

	local player = GetLocalClientPlayer()
	UpdateClientHudVisibility( player )

	if ( IsWatchingKillReplay() )
		return

	if ( GetGameState() < eGameState.Playing )
		return

	HideRespawnSelect()

	if ( player.cv.hud.s.lastEventNotificationText == "#REVIVE_BLEED_OUT" )
	{
		ClearEventNotification()
	}
}


RegisterSignal( "OnClientPlayerDying" )
function OnClientPlayerDying( player )
{
	player.Signal( "OnClientPlayerDying" ) // TEMP; this should not be necessary, but IsWatchingKillReplay is wrong
	player.EndSignal( "OnClientPlayerDying" )

	if ( GetGameState() != eGameState.SwitchingSides && GetGameState() != eGameState.WinnerDetermined )
	{
		SmartGlass_SetGameStateProperty( SMARTGLASS_PROP_ISALIVE, "0" )
		SmartGlass_SendEvent( "playerDead", "", "", "" )
	}

	local player = GetLocalClientPlayer()
	UpdateClientHudVisibility( player )

	if ( IsWatchingKillReplay() )
		return

	player.cv.deathTime = Time()

	ShowRespawnSelect( player )
	ResetAndShowMinimap( player )

	level.nextSelectBurnCardTime = Time() + 0.6 // debounce for having just died

	thread DeathCamCheck( player )
}

function DeathCamCheck( player )
{
	wait GetRespawnButtonCamTime( player )
	ShowRespawnSelect( player )
}


function IsPlayerEliminated( player )
{
	local shiftIndex = player.GetEntIndex() - 1
	local elimMask = (1 << shiftIndex)

	return ( level.nv.eliminatedPlayers & elimMask )
}

function PlayerFieryDeath( player )
{
	player.EndSignal( "OnDestroy" )
	player.EndSignal( "OnClientPlayerAlive" )
	player.EndSignal( "OnSpectatorMode" )

	local offset = Vector( 0, 0, 0 )
	if ( player.IsTitan() )
		offset = Vector( 0, 0, 96 )

	local scriptRef = CreatePropDynamic( "models/dev/empty_model.mdl", player.GetOrigin() + offset, player.GetAngles() )
	scriptRef.SetParent( player )

	local fxHandle = StartParticleEffectOnEntity( scriptRef, GetParticleSystemIndex( "P_burn_player" ), FX_PATTACH_ABSORIGIN_FOLLOW, -1 )

	OnThreadEnd(
		function () : ( fxHandle, scriptRef )
		{
				EffectStop( fxHandle, false, false )
				if ( IsValid( scriptRef ) )
					scriptRef.Destroy()
		}
	)
	WaitForever()
}

function UpdateScreenFade()
{
	local fadeParams = GetFadeParams()

	if ( !fadeParams.a && level.lastFadeParams.a )
	{
		level.screenFade.Hide()
	}
	else if ( level.lastFadeParams.a )
	{
		level.screenFade.Show()
		level.screenFade.SetColor( fadeParams.r, fadeParams.g, fadeParams.b, fadeParams.a )
	}

	level.lastFadeParams = fadeParams
}

function ServerCallback_GiveMatchLossProtection()
{
	level.hasMatchLossProtection = true
}

function ClRodeo_OnClientScriptInit( player, isRecreate )
{
	if ( isRecreate )
		return

	player.ClientCommand( "HoldToRodeo " + HoldToRodeoState( player ) )

	if ( !( "rodeoPressed" in player.s ) )
	{
		player.s.rodeoPressed <- false
	}
}
Globalize( ClRodeo_OnClientScriptInit )

function PlayerPressed_Rodeo( player )
{
	if ( !IsAlive( player ) )
		return

	player.s.rodeoPressed = true
}

function PlayerReleased_Rodeo( player )
{
	if ( !IsAlive( player ) )
		return

	player.s.rodeoPressed = false
}
