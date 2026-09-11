const MAX_ACTIVE_TRAPS_DISPLAYED = 5
const VGUI_CLOSED = 0
const VGUI_CLOSING = 1
const VGUI_OPEN = 2
const VGUI_OPENING = 3

const USE_AUTO_TEXT = 1
const NEW_TARGET_HEALTHBARS = true
const SHIELD_R = 176
const SHIELD_G = 227
const SHIELD_B = 227

const TEAM_ICON_IMC = "../ui/scoreboard_imc_logo"
PrecacheHUDMaterial( TEAM_ICON_IMC )

const TEAM_ICON_MILITIA = "../ui/scoreboard_mcorp_logo"
PrecacheHUDMaterial( TEAM_ICON_MILITIA )


PrecacheHUDMaterial( "HUD/ctf_base_freindly" )
PrecacheHUDMaterial( "HUD/ctf_flag_friendly_held" )
PrecacheHUDMaterial( "HUD/ctf_flag_friendly_away" )
PrecacheHUDMaterial( "HUD/ctf_base_enemy" )
PrecacheHUDMaterial( "HUD/ctf_flag_enemy_away" )
PrecacheHUDMaterial( "HUD/ctf_flag_enemy_held" )
PrecacheHUDMaterial( "HUD/ctf_flag_friendly_notext" )
PrecacheHUDMaterial( "HUD/ctf_flag_enemy_notext" )
PrecacheHUDMaterial( "HUD/ctf_flag_friendly_missing" )
PrecacheHUDMaterial( "HUD/ctf_flag_friendly_minimap" )
PrecacheHUDMaterial( "HUD/ctf_flag_enemy_minimap" )
PrecacheHUDMaterial( "HUD/overhead_shieldbar_burn_card_indicator" )
PrecacheHUDMaterial( "../ui/icon_status_burncard_friendly" )
PrecacheHUDMaterial( "../ui/icon_status_burncard_enemy" )
PrecacheHUDMaterial( "HUD/riding_icon_enemy" )
PrecacheHUDMaterial( "HUD/riding_icon_friendly" )

function main()
{
	Globalize( InitChatHUD )

	if ( IsMenuLevel() )
		return

	Globalize( MainHud_AddPlayer )
	Globalize( MainHud_AddClient )
	Globalize( HideFriendlyIndicatorAndCrosshairNames )
	Globalize( ShowFriendlyIndicatorAndCrosshairNames )
	Globalize( Create_PilotHud )
	Globalize( MainHud_Outro )
	Globalize( SetCrosshairPriorityState )
	Globalize( ClearCrosshairPriority )
	Globalize( UpdateMainHudVisibility )
	Globalize( ServerCallback_Announcement )
	Globalize( ServerCallback_GameModeAnnouncement )
	Globalize( UpdateShieldHealth )
	Globalize( ClientCodeCallback_OnSelectedWeaponChanged )
	Globalize( ClientCodeCallback_ControllerModeChanged )
	Globalize( ClientCodeCallback_XPChanged )
	Globalize( UpdateMainHudFromCEFlags )
	Globalize( UpdatePlayerStatusCounts )
	Globalize( ServerCallback_MinimapPulse )
	Globalize( MinimapPulse )
	Globalize( HideGameProgressScoreboard_ForPlayer )
	Globalize( ShowGameProgressScoreboard_ForPlayer )
	Globalize( UpdateTitanShieldColor )
	Globalize( ScoreBarsTitanCountThink )
	Globalize( Create_CommonHudElements )
	Globalize( UpdateCoreFX )
	Globalize( InitCrosshair )
	Globalize( ServerCallback_UpdateBurnCardTitle )
	Globalize( AlertThink )
	Globalize( GetOffhandProgressSource )
	Globalize( UpdateClientHudVisibility )
	Globalize( UpdateScoreInfo )

	//level.scoreBars <- VisGroup( "scoreBars" )

	RegisterSignal( "UpdateTitanCounts" )
	RegisterSignal( "MainHud_TurnOn" )
	RegisterSignal( "MainHud_TurnOff" )
	RegisterSignal( "UpdateWeapons" )
	RegisterSignal( "ResetWeapons" )
	RegisterSignal( "UpdateShieldBar" )
	RegisterSignal( "UpdateTargetShieldHealth" )
	RegisterSignal( "TargetHealthBarsUpdate" )
	RegisterSignal( "PlayerUsedAbility" )
	RegisterSignal( "UpdateTitanBuildBar" )
	RegisterSignal( "UsedOrdnance" )
	RegisterSignal( "ControllerModeChanged" )
	RegisterSignal( "ActivateTitanCore" )
	RegisterSignal( "AttritionPoints" )
	RegisterSignal( "AttritionPopup" )
	RegisterSignal( "UpdateLastTitanStanding" )
	RegisterSignal( "SuddenDeathHUDThink" )

	AddCreateCallback( "titan_cockpit", CockpitHudInit )
	AddCreateCallback( "npc_titan", SignalUpdatePlayerStatusCounts )

	AddKillReplayStartedCallback( UpdateClientHudVisibilityCallback )
	AddKillReplayEndedCallback( UpdateClientHudVisibilityCallback )

	RegisterServerVarChangeCallback( "gameState", UpdateMainHudFromGameState )
	RegisterServerVarChangeCallback( "gameState", UpdateScoreInfo )
	RegisterServerVarChangeCallback( "gameEndTime", UpdateScoreInfo )
	RegisterServerVarChangeCallback( "roundEndTime", UpdateScoreInfo )
	RegisterServerVarChangeCallback( "minimapState", UpdateMinimapVisibility )
	RegisterServerVarChangeCallback( "gameState", VarChangedCallback_GameStateChanged )

	RegisterServerVarChangeCallback( "secondsTitanCheckTime", UpdateLastTitanStanding )

	AddCinematicEventFlagChangedCallback( CE_FLAG_EMBARK, CinematicEventFlagChanged )
	AddCinematicEventFlagChangedCallback( CE_FLAG_DISEMBARK, CinematicEventFlagChanged )
	AddCinematicEventFlagChangedCallback( CE_FLAG_INTRO, CinematicEventFlagChanged )
	AddCinematicEventFlagChangedCallback( CE_FLAG_CLASSIC_MP_SPAWNING, CinematicEventFlagChanged )
	AddCinematicEventFlagChangedCallback( CE_FLAG_EOG_STAT_DISPLAY, CinematicEventFlagChanged )
	//AddCinematicEventFlagChangedCallback( CE_FLAG_PERMANENT_HIDEHUD, CinematicEventFlagChanged )

	RegisterConCommandTriggeredCallback( "weaponSelectOrdnance", SwitchedToOrdnance )

	if ( !reloadingScripts )
	{
		level.showScoreboard 	<- true
		level.showXPBar 		<- true
	}

	level.customMinimapZoom 		<- null

	file.crosshairPriorityLevel <- {}
	file.crosshairPriorityOrder <- []

	file.gameModeAnnounced <- false  // Set when the game mode announcement plays so we know it happened at least once
}



function SwitchedToOrdnance( player )
{
	if ( player.IsTitan() )
		return

	if ( player.GetActiveWeapon() == player.GetOrdnanceWeapon() )
		return

	player.cv.ordnanceUseCount++

	player.Signal( "UsedOrdnance" )
}


function MainHud_AddClient( player )
{
	player.cv.announcementActive <- false
	player.cv.announcementQueue <- []
	player.cv.antiTitanHintNextShowTime <- 0
	player.cv.ordnanceUseCount <- 0

	player.cv.burnCardAnnouncementActive <- false
	player.cv.burnCardAnnouncementQueue <- []

	player.cv.startingXP <- GetXP( player )
	player.cv.lastLevel <- GetLevel( player )

	g_targetOverheadHealthBar <- Hud.HudElement( "TargetOverheadHealthBar" )
	g_targetOverheadDoomedHealthBar <- Hud.HudElement( "TargetOverheadDoomedHealthBar" )
	g_targetOverheadShieldHealthBar <- Hud.HudElement( "TargetOverheadShieldHealthBar" )

	thread ClientHudInit( player )
}


function MainHud_AddPlayer( player )
{
	InitCrosshair()
}


function CockpitHudInit( cockpit, isRecreate )
{
	Assert( !isRecreate )

	local player = GetLocalViewPlayer()

	ClearDpadButtons( player )

	if ( IsHumanCockpitModelName( cockpit.GetModelName() ) )
	{
		thread PilotMainHud( cockpit, player )
		cockpit.SetCaptureScreenBeforeViewmodels( true )
	}
	else if ( IsTitanCockpitModelName( cockpit.GetModelName() ) )
	{
		thread TitanMainHud( cockpit, player )
		cockpit.SetCaptureScreenBeforeViewmodels( false )
	}
	else
	{
		cockpit.SetCaptureScreenBeforeViewmodels( false )
	}

	// Enable this when code has added support for a global vgui layer
	//thread GlobalMainHud( player )
}


function PilotMainHud( cockpit, player )
{
	local mainVGUI = Create_PilotHud( cockpit, player )
	cockpit.s.mainVGUI <- mainVGUI
	local panel = mainVGUI.s.panel

	local warpSettings = mainVGUI.s.warpSettings
	panel.WarpGlobalSettings( warpSettings.xWarp, 0, warpSettings.yWarp, 0, warpSettings.viewDist )
	panel.WarpEnable()
	mainVGUI.s.enabledState <- VGUI_CLOSED
	HideFriendlyIndicatorAndCrosshairNames()

	MainHud_InitAspectRatio( cockpit, player, false )

	MainHud_InitTargetHealthBars( cockpit, player )

	cockpit.s.coreFXHandle <- null

	local scoreGroup = HudElementGroup( "scoreboardProgress" )
	if ( GameRules.GetGameMode() == "cp" )
		OnHardpointCockpitCreated( cockpit, panel, scoreGroup )

	MainHud_InitScoreBars( mainVGUI, player, scoreGroup )

	if ( player == GetLocalClientPlayer() && PlayerPlayingRanked( player ) && !IsWatchingKillReplay() )
	{
		local rankedPanel = scoreGroup.CreateElement( "RankedHud", panel )
		InitRankedPanel( mainVGUI.s.scoreboardProgressBars, scoreGroup, rankedPanel, cockpit )
	}

	MainHud_InitEpilogue( mainVGUI, player )
	MainHud_InitObjective( mainVGUI, player )
	MainHud_InitDPAD( cockpit, player )
	MainHud_InitWeapons( cockpit, player )
	MainHud_InitXPBar( cockpit, player )
	//MainHud_InitAnnouncement( mainVGUI, player )
	MainHud_InitMinimap( mainVGUI, player )
	MainHUD_InitLockedOntoWarning( mainVGUI, player )

	local antiTitanHint = panel.HudElement( "AntiTitanHint" )
	antiTitanHint.EnableKeyBindingIcons()
	mainVGUI.s.antiTitanHint <- antiTitanHint

	local _vguiElem
	_vguiElem = panel.HudElement( "TitanBar" )
	_vguiElem.SetBarProgressRemap( 0.0, 1.0, 0.05, 0.88 )
	mainVGUI.s.titanBar <- _vguiElem

	_vguiElem = panel.HudElement( "TitanBarLabel" )
	mainVGUI.s.titanBarLabel <- _vguiElem

	_vguiElem = panel.HudElement( "TitanBarLeftIcon" )
	mainVGUI.s.titanBarLeftIcon <- _vguiElem

	_vguiElem = panel.HudElement( "TitanBarLeftRight" )
	mainVGUI.s.titanBarRightIcon <- _vguiElem

	_vguiElem = panel.HudElement( "RodeoAlertIcon" )
	mainVGUI.s.rodeoAlertIcon <- _vguiElem

	_vguiElem = panel.HudElement( "RodeoAlertLabel" )
	mainVGUI.s.rodeoAlertLabel <- _vguiElem

	local antiRodeoHint = panel.HudElement( "AntiRodeoHint" )
	antiRodeoHint.EnableKeyBindingIcons()
	mainVGUI.s.antiRodeoHint <- antiRodeoHint


	local titanBarEarnedLabelAnchor = panel.HudElement( "TitanBarEarnedLabelAnchor" )
	mainVGUI.s.titanBarEarnedLabelAnchor <- titanBarEarnedLabelAnchor

	local titanBarEarnedLabel = panel.HudElement( "TitanBarEarnedLabel" )
	mainVGUI.s.titanBarEarnedLabel <- titanBarEarnedLabel

	local titanBarEarnedIcon = panel.HudElement( "TitanBarEarnedIcon" )
	mainVGUI.s.titanBarEarnedIcon <- titanBarEarnedIcon

	local pilotBackgroundGroup = HudElementGroup( "pilotBackgroundGroup" )
	pilotBackgroundGroup.CreateElement( "dpadIconBG", panel )
	pilotBackgroundGroup.CreateElement( "dpadSideBG", panel )
	pilotBackgroundGroup.CreateElement( "dpadSide", panel )
	//pilotBackgroundGroup.CreateElement( "Offhand0BG", panel )
	//pilotBackgroundGroup.CreateElement( "Offhand1BG", panel )

	mainVGUI.s.dpadIconBGOutline <- panel.HudElement( "dpadIconBG_Tutorial_Outline" )

	if ( IsWatchingKillReplay() )
		pilotBackgroundGroup.Hide()

	thread EMPThink( cockpit, player )
	thread TargetHealthBarsThink( cockpit, player )
	thread TitanBuildBarThink( cockpit, player )
	thread WeaponsUpdateThink( cockpit, player )
	thread RodeoRideThink( cockpit, player )

	UpdateMainHudVisibility( player )
	if ( player == GetLocalClientPlayer() )
		UpdateVDUVisibility( player )
	UpdateTitanModeHUD( player )

	SonarActiveChanged( player )

	if ( player == GetLocalClientPlayer() )
	{
		delaythread( 1.0 ) AnnouncementProcessQueue( player )
		delaythread( 1.0 ) BurnCardAnnouncementProcessQueue( player )
	}

	PlayBurnCardEffects( player )

	UpdateScoreInfo()

	foreach ( callbackInfo in level.pilotHudCallbacks )
		callbackInfo.func.acall( [callbackInfo.scope, cockpit, player] )

	cockpit.WaitSignal( "OnDestroy" )

	mainVGUI.Destroy()
}

function TitanMainHud( cockpit, player )
{
	local bindings = GetTitanBindings()
	if ( RegisterTitanBindings( player, bindings ) )
	{
		OnThreadEnd(
			function () : ( cockpit, bindings )
			{
				cockpit.s.mainVGUI.Destroy()
				DeregisterTitanBindings( bindings )
			}
		)
	}
	else
	{
		OnThreadEnd(
			function () : ( cockpit )
			{
				cockpit.s.mainVGUI.Destroy()
			}
		)
	}

	local mainVGUI = Create_TitanHud( cockpit, player )
	cockpit.s.mainVGUI <- mainVGUI
	local panel = mainVGUI.s.panel

	cockpit.EndSignal( "OnDestroy" )
	player.EndSignal( "OnDestroy" )

	local warpSettings = mainVGUI.s.warpSettings
	panel.WarpGlobalSettings( warpSettings.xWarp, 0, warpSettings.yWarp, 0, warpSettings.viewDist )
	panel.WarpEnable()
	mainVGUI.s.enabledState <- VGUI_CLOSED
	cockpit.s.coreFXHandle <- null

	MainHud_InitAspectRatio( cockpit, player, true )

	local _vguiElem

	_vguiElem = panel.HudElement( "HealthBar" )
	_vguiElem.SetBarProgressSourceEntity( player )
	_vguiElem.SetBarProgressSource( ProgressSource.PROGRESS_SOURCE_ENTITY_HEALTH )
	_vguiElem.SetBarProgressRemap( 0.0, 1.0, 0.05625, 1.0 )
	mainVGUI.s.healthBar <- _vguiElem

	_vguiElem = panel.HudElement( "ShieldBar" )
	mainVGUI.s.shieldBar <- _vguiElem
	_vguiElem.SetColor( SHIELD_R, SHIELD_G, SHIELD_B, 255 )

	mainVGUI.s.shieldBar.SetBarProgress( 1.0 )

	_vguiElem = panel.HudElement( "HazardStripTop" )
	mainVGUI.s.hazardBarTop <- _vguiElem

	_vguiElem = panel.HudElement( "HazardStripBottom" )
	mainVGUI.s.hazardBarBottom <- _vguiElem

	local _vguiElem = panel.HudElement( "DoomedHealthBar" )
	_vguiElem.SetBarProgressSourceEntity( player )
	_vguiElem.SetBarProgressSource( ProgressSource.PROGRESS_SOURCE_ENTITY_HEALTH )
	_vguiElem.SetBarProgressDirection( 1 )
	_vguiElem.SetBarProgressRemap( 1.0, 0.0, 0.0, 1.0 )
	mainVGUI.s.doomedHealthBar <- _vguiElem

	_vguiElem = panel.HudElement( "RodeoAlertIcon" )
	mainVGUI.s.rodeoAlertIcon <- _vguiElem

	_vguiElem = panel.HudElement( "RodeoAlertLabel" )
	mainVGUI.s.rodeoAlertLabel <- _vguiElem

	local antiRodeoHint = panel.HudElement( "AntiRodeoHint" )
	antiRodeoHint.EnableKeyBindingIcons()
	mainVGUI.s.antiRodeoHint <- antiRodeoHint

	MainHud_InitTargetHealthBars( cockpit, player )

	local scoreGroup = HudElementGroup( "scoreboardProgress" )
	if ( GameRules.GetGameMode() == "cp" )
		OnHardpointCockpitCreated( cockpit, panel, scoreGroup )

	MainHud_InitScoreBars( mainVGUI, player, scoreGroup )

	if ( player == GetLocalClientPlayer() && PlayerPlayingRanked( player ) && !IsWatchingKillReplay() )
	{
		local rankedPanel = scoreGroup.CreateElement( "RankedHud", panel )
		InitRankedPanel( mainVGUI.s.scoreboardProgressBars, scoreGroup, rankedPanel, cockpit )
	}

	MainHud_InitEpilogue( mainVGUI, player )
	MainHud_InitObjective( mainVGUI, player )
	MainHud_InitDPAD( cockpit, player )
	MainHud_InitWeapons( cockpit, player )
	MainHud_InitXPBar( cockpit, player )
	TitanHud_InitEjectHint( cockpit, player )
	//MainHud_InitAnnouncement( mainVGUI, player )
	MainHud_InitMinimap( mainVGUI, player )
	MainHUD_InitLockedOntoWarning( mainVGUI, player )

	local _vguiElem
	_vguiElem = panel.HudElement( "CoreBar" )
	_vguiElem.Hide()
	mainVGUI.s.coreBar <- _vguiElem

	_vguiElem = panel.HudElement( "TitanBar" )
	_vguiElem.SetBarProgressRemap( 0.0, 1.0, 0.05, 0.88 )
	mainVGUI.s.titanBar <- _vguiElem

	_vguiElem = panel.HudElement( "TitanBarLabel" )
	mainVGUI.s.titanBarLabel <- _vguiElem

	_vguiElem = panel.HudElement( "TitanBarLeftIcon" )
	mainVGUI.s.titanBarLeftIcon <- _vguiElem

	_vguiElem = panel.HudElement( "TitanBarLeftRight" )
	mainVGUI.s.titanBarRightIcon <- _vguiElem

	local titanBarEarnedLabelAnchor = panel.HudElement( "TitanBarEarnedLabelAnchor" )
	mainVGUI.s.titanBarEarnedLabelAnchor <- titanBarEarnedLabelAnchor

	local titanBarEarnedLabel = panel.HudElement( "TitanBarEarnedLabel" )
	mainVGUI.s.titanBarEarnedLabel <- titanBarEarnedLabel

	local titanBarEarnedIcon = panel.HudElement( "TitanBarEarnedIcon" )
	mainVGUI.s.titanBarEarnedIcon <- titanBarEarnedIcon
	mainVGUI.s.titanBarEarnedIcon.SetImage( GetCoreIcon( player ) )

	local titanBackgroundGroup = HudElementGroup( "titanBackgroundGroup" )
	titanBackgroundGroup.CreateElement( "dpadIconBG", panel )
	titanBackgroundGroup.CreateElement( "dpadSideBG", panel )
	titanBackgroundGroup.CreateElement( "dpadSide", panel )
	//titanBackgroundGroup.CreateElement( "Offhand0BG", panel )
	//titanBackgroundGroup.CreateElement( "Offhand1BG", panel )

	mainVGUI.s.dpadIconBGOutline <- panel.HudElement( "dpadIconBG_Tutorial_Outline" )

	if ( IsWatchingKillReplay() )
		titanBackgroundGroup.Hide()

	thread TitanHealthBarsThink( cockpit, player )
	thread TitanShieldBarThink( cockpit, player )
	thread TitanBuildBarThink( cockpit, player )

	local settings = player.GetPlayerSettings()
	Assert( player.IsTitan() || settings == "pilot_titan_cockpit", "player has titan settings but is not a titan" )

	thread TargetHealthBarsThink( cockpit, player )
	thread RodeoAlertThink( cockpit, player )
	thread WeaponsUpdateThink( cockpit, player )

	UpdateCoreFX( player )
	PlayBurnCardEffects( player )

	// delay hud display until cockpit boot sequence completes
	//while ( IsValid( cockpit ) && TitanCockpit_IsBooting( cockpit ) )
	//	wait 0

	if ( IsValid( cockpit ) )
	{
		level.EMP_vguis.append( mainVGUI )

		if ( player == GetLocalClientPlayer() )
		{
			delaythread( 1.0 ) AnnouncementProcessQueue( player )
			delaythread( 1.0 ) BurnCardAnnouncementProcessQueue( player )
		}

		UpdateMainHudVisibility( player )
		UpdateTitanModeHUD( player )
		if ( player == GetLocalClientPlayer() )
			UpdateVDUVisibility( player )

		SonarActiveChanged( player )

		UpdateScoreInfo()

		foreach ( callbackInfo in level.titanHudCallbacks )
			callbackInfo.func.acall( [callbackInfo.scope, cockpit, player] )

		WaitForever()
	}
}

const VGUI_TITAN_NOSAFE_X = 0.15
const VGUI_TITAN_NOSAFE_Y = 0.075
const VGUI_PILOT_NOSAFE_X = 0.10
const VGUI_PILOT_NOSAFE_Y = 0.10

function MainHud_InitAspectRatio( cockpit, player, isTitan )
{
	local vgui = cockpit.GetMainVGUI()
	local panel = vgui.GetPanel()

	vgui.s.screen <- HudElement( "Screen", panel )
	vgui.s.safeArea <- HudElement( "SafeArea", panel )
	vgui.s.safeAreaCenter <- HudElement( "SafeAreaCenter", panel )

	local safeWidth = vgui.s.safeArea.GetWidth()
	local safeWidthCenter = vgui.s.safeAreaCenter.GetWidth()

	if ( level.safeAreaScale != 1.0 )
	{
		if ( isTitan )
		{
			vgui.s.safeArea.SetBaseSize( vgui.s.screen.GetWidth() - (vgui.s.screen.GetWidth() * VGUI_TITAN_NOSAFE_X), vgui.s.screen.GetHeight() - (vgui.s.screen.GetHeight() * VGUI_TITAN_NOSAFE_Y) )
			vgui.s.safeAreaCenter.SetBaseSize( vgui.s.screen.GetWidth() - (vgui.s.screen.GetWidth() * VGUI_TITAN_NOSAFE_X), vgui.s.screen.GetHeight() - (vgui.s.screen.GetHeight() * VGUI_TITAN_NOSAFE_Y) )
		}
		else
		{
			vgui.s.safeArea.SetBaseSize( vgui.s.screen.GetWidth() - (vgui.s.screen.GetWidth() * VGUI_PILOT_NOSAFE_X), vgui.s.screen.GetHeight() - (vgui.s.screen.GetHeight() * VGUI_PILOT_NOSAFE_Y) )
			vgui.s.safeAreaCenter.SetBaseSize( vgui.s.screen.GetWidth() - (vgui.s.screen.GetWidth() * VGUI_PILOT_NOSAFE_X), vgui.s.screen.GetHeight() - (vgui.s.screen.GetHeight() * (VGUI_PILOT_NOSAFE_Y * 0.5)) )
		}
	}

	vgui.s.safeArea.SetScaleX( level.aspectRatioScale )
	vgui.s.safeAreaCenter.SetScaleX( level.aspectRatioScale )
}


function WeaponsUpdateThink( cockpit, player )
{
	cockpit.EndSignal( "OnDestroy" )
	player.EndSignal( "OnDestroy" )

	for ( ;; )
	{
		MainHud_UpdateWeapons( cockpit, player )
		WaitSignalTimeout( player, 0.5, "UpdateWeapons" )
	}
}

function MainHud_InitTargetHealthBars( cockpit, player )
{
	local panel = Hud

	local targetHealthBar = g_targetOverheadHealthBar
	local targetHealthBarBurnCardIndicator = cockpit.s.mainVGUI.s.panel.HudElement( "TargetHealthBarBurnCardIndicator" )
	local targetHealthBarSubClass = cockpit.s.mainVGUI.s.panel.HudElement( "TargetHealthBarSubClass" )
	local targetShieldHealthBar = g_targetOverheadShieldHealthBar
	local targetDoomedHealthBar = g_targetOverheadDoomedHealthBar

	local targetSmallConnectingLine = cockpit.s.mainVGUI.s.panel.HudElement( "TargetSmall_ConnectingLine" )
	cockpit.s.mainVGUI.s.targetSmallConnectingLine <- targetSmallConnectingLine

	if ( NEW_TARGET_HEALTHBARS )
	{
		targetHealthBar = cockpit.s.mainVGUI.s.panel.HudElement( "TargetHealthBarSmall" )
		targetShieldHealthBar = cockpit.s.mainVGUI.s.panel.HudElement( "TargetShieldBarSmall" )
		targetShieldHealthBar.SetColor( SHIELD_R, SHIELD_G, SHIELD_B, 255 )
		targetDoomedHealthBar = cockpit.s.mainVGUI.s.panel.HudElement( "TargetDoomedHealthBarSmall" )
	}

	targetHealthBar.SetBarProgressSourceEntity( null )
	targetHealthBar.SetBarProgressSource( ProgressSource.PROGRESS_SOURCE_ENTITY_HEALTH )
	targetHealthBar.SetBarProgressRemap( 0.0, 1.0, 0.06, 0.97 )
	targetHealthBar.Hide()
	cockpit.s.mainVGUI.s.targetHealthBar <- targetHealthBar
	cockpit.s.mainVGUI.s.targetHealthBarBurnCardIndicator   <- targetHealthBarBurnCardIndicator
	cockpit.s.mainVGUI.s.targetHealthBarSubClass   <- targetHealthBarSubClass
	cockpit.s.mainVGUI.s.targetShieldHealthBar <- targetShieldHealthBar

	targetDoomedHealthBar.SetBarProgressSourceEntity( null )
	targetDoomedHealthBar.SetBarProgressSource( ProgressSource.PROGRESS_SOURCE_ENTITY_HEALTH )
	targetDoomedHealthBar.SetBarProgressDirection( 1 )
	targetDoomedHealthBar.SetBarProgressRemap( 1.0, 0.0, 0.0, 1.0 )
	targetDoomedHealthBar.Hide()
	cockpit.s.mainVGUI.s.targetDoomedHealthBar <- targetDoomedHealthBar
}



function TitanHealthBarsThink( cockpit, player )
{
	cockpit.EndSignal( "OnDestroy" )
	player.EndSignal( "OnDestroy" )

	if ( !player.GetDoomedState() )
	{
		cockpit.s.mainVGUI.s.healthBar.Show()
		cockpit.s.mainVGUI.s.shieldBar.Show()
		cockpit.s.mainVGUI.s.doomedHealthBar.Hide()

		while ( !player.GetDoomedState() )
		{
			WaitSignal( player, "Doomed", "CriticalHitReceived" )

			cockpit.s.mainVGUI.s.healthBar.SetColor( 255, 128, 128, 255 )
			cockpit.s.mainVGUI.s.healthBar.ColorOverTime( 255, 255, 255, 255, 0.25, INTERPOLATOR_PULSE )
		}
	}

	cockpit.s.mainVGUI.s.healthBar.Hide()
	cockpit.s.mainVGUI.s.shieldBar.Hide()
	cockpit.s.mainVGUI.s.doomedHealthBar.Show()
}


function TitanShieldBarThink( cockpit, player )
{
	cockpit.EndSignal( "OnDestroy" )
	player.EndSignal( "OnDestroy" )

	thread TitanShieldBarPulseThink( cockpit, player )

	local prevShields = GetShieldHealthFrac( player )

	for ( ;; )
	{
		local shieldFrac = GetShieldHealthFrac( player )

		if ( shieldFrac == 0 && prevShields )
		{
			TitanCockpit_PlayDialog( player, "damage" )
		}

		prevShields = shieldFrac

		cockpit.s.mainVGUI.s.shieldBar.SetBarProgress( shieldFrac )

		player.WaitSignal( "UpdateShieldBar" )
	}
}


function UpdateCoreFX( player )
{
	if ( player != GetLocalViewPlayer() )
		return

	UpdateTitanShieldColor( player )
	UpdateDashBarColor( player )

	local cockpit = player.GetCockpit()
	if ( !cockpit )
		return

	if ( cockpit.s.coreFXHandle && EffectDoesExist( cockpit.s.coreFXHandle ) )
	{
		EffectStop( cockpit.s.coreFXHandle, false, true ) // stop particles, play end cap
	}

	if ( PlayerHasPassive( player, PAS_SHIELD_BOOST ) || PlayerHasPassive( player, PAS_FUSION_CORE ) )
	{
		thread PlayCockpitSparkFX( cockpit, "FX_TL_PANEL" )
		thread PlayCockpitSparkFX( cockpit, "FX_TR_PANEL" )
		cockpit.s.coreFXHandle = StartParticleEffectOnEntity( cockpit, GetParticleSystemIndex( "P_core_DMG_boost_screen" ), FX_PATTACH_ABSORIGIN_FOLLOW, -1 )
	}
}


function FadeColorCorrectionOverTime( colorCorrection, duration, player )
{
	player.EndSignal( "OnDestroy" )
	player.EndSignal( "SettingsChanged" )
	level.ent.EndSignal( "KillReplayStarted" )
	level.ent.EndSignal( "KillReplayEnded" )

	OnThreadEnd(
		function() : ( colorCorrection )
		{
			ColorCorrection_SetWeight( colorCorrection, 0.0 )
		}
	)

	local startTime = Time()
	local endTime = startTime + duration
	while ( Time() < endTime )
	{
		ColorCorrection_SetWeight( level.coreColorCorrection, GraphCapped( Time(), startTime, endTime, 1.0, 0.0 ) )
		wait 0
	}
}


function UpdateTitanShieldColor( player )
{
	local viewPlayer = GetLocalViewPlayer()

	// changed the bar for the view player?
	local localShieldBar = viewPlayer == player

	if ( !localShieldBar )
	{
		// if we aren't changing the bar for our target, then we can't see the bar, so out
		if ( player != GetHealthBarEntity( viewPlayer ) )
			return
	}

	if ( localShieldBar )
	{
		// its a titan only passive. Pilot doesn't even have shield bar anyway.
		if ( !viewPlayer.IsTitan() )
			return
	}

	local cockpit = viewPlayer.GetCockpit()
	if ( !IsValid( cockpit ) )
		return

	local mainVGUI = cockpit.GetMainVGUI()
	if ( !mainVGUI )
		return

	local shieldBar
	if ( localShieldBar )
	{
		shieldBar = cockpit.s.mainVGUI.s.shieldBar
	}
	else
	{
		shieldBar = cockpit.s.mainVGUI.s.targetShieldHealthBar
	}

	local r, g, b

	if ( PlayerHasPassive( player, PAS_SHIELD_BOOST ) )
	{
		r = SHIELD_BOOST_R
		g = SHIELD_BOOST_G
		b = SHIELD_BOOST_B
	}
	else
	{
		r = SHIELD_R
		g = SHIELD_G
		b = SHIELD_B
	}

	shieldBar.ColorOverTime( r, g, b, 255, 0.5, INTERPOLATOR_DEACCEL )
}

function UpdateDashBarColor( player )
{
	if ( !IsValid( player ) )
		return

	if ( !IsAlive( player ) )
		return

	local soul = player.GetTitanSoul()
	if ( IsValid( soul ) && GetSoulTitanType( soul ) != "stryder" )
		return

	// its a titan only passive. Pilot doesn't even have dash bar anyway.
	if ( !player.IsTitan() )
		return

	local cockpit = player.GetCockpit()
	if ( !IsValid( cockpit ) )
		return

	local mainVGUI = cockpit.GetMainVGUI()
	if ( !mainVGUI )
		return

	local dashBar = cockpit.s.dashBar
	local dashBarFG = cockpit.s.dashBarFG

	local col = dashBar.GetBaseColor()
	local col_FG = dashBarFG.GetBaseColor()
	local alpha = dashBar.GetBaseAlpha()
	local alpha_FG = dashBarFG.GetBaseAlpha()

	if ( PlayerHasPassive( player, PAS_FUSION_CORE ) )
	{
		col = [ SHIELD_BOOST_R, SHIELD_BOOST_G, SHIELD_BOOST_B ]
		col_FG = [ SHIELD_BOOST_R, SHIELD_BOOST_G, SHIELD_BOOST_B ]
	}

	dashBar.ColorOverTime( col[0], col[1], col[2], alpha, 0.5, INTERPOLATOR_DEACCEL )
	dashBarFG.ColorOverTime( col_FG[0], col_FG[1], col_FG[2], alpha_FG, 0.5, INTERPOLATOR_DEACCEL )
}
Globalize( UpdateDashBarColor )

// TMP.. there are more efficient ways to do this like HudAnimations.txt... but they take too long to setup right now
function TitanShieldBarPulseThink( cockpit, player )
{
	cockpit.EndSignal( "OnDestroy" )
	player.EndSignal( "OnDestroy" )

	const PULSE_DELAY = 0.6
	for ( ;; )
	{
		wait PULSE_DELAY

		local shieldFrac = GetShieldHealthFrac( player )

		if ( shieldFrac <= 0 )
		{
			cockpit.s.mainVGUI.s.healthBar.SetColor( 255, 128, 128, 255 )
			cockpit.s.mainVGUI.s.healthBar.ColorOverTime( 255, 255, 255, 255, PULSE_DELAY, INTERPOLATOR_PULSE )

			cockpit.s.mainVGUI.s.hazardBarBottom.Show()
			cockpit.s.mainVGUI.s.hazardBarBottom.SetColor( 32, 32, 32, 255 )
			cockpit.s.mainVGUI.s.hazardBarBottom.ColorOverTime( 128, 128, 128, 255, PULSE_DELAY, INTERPOLATOR_PULSE )

			cockpit.s.mainVGUI.s.hazardBarTop.Show()
			cockpit.s.mainVGUI.s.hazardBarTop.SetColor( 32, 32, 32, 255 )
			cockpit.s.mainVGUI.s.hazardBarTop.ColorOverTime( 128, 128, 128, 255, PULSE_DELAY, INTERPOLATOR_PULSE )
		}
		else
		{
			cockpit.s.mainVGUI.s.healthBar.SetColor( 255, 255, 255, 255 )

			cockpit.s.mainVGUI.s.hazardBarBottom.Hide()
			cockpit.s.mainVGUI.s.hazardBarTop.Hide()
		}
	}
}


function UsedOrdnanceThink( cockpit, player )
{
	cockpit.EndSignal( "OnDestroy" )
	player.EndSignal( "OnDestroy" )

	for ( ;; )
	{
		player.WaitSignal( "UsedOrdnance" )

		cockpit.s.mainVGUI.s.panel.RunAnimationScript( "FadeAnitTitanHintInstant" )
	}
}

function ShowAntiTitanHint( cockpit, player, entity )
{
	if ( player != GetLocalClientPlayer() )
		return

	if ( !entity.IsTitan() )
		return

	if ( player.cv.ordnanceUseCount > 4 )
		return

	if ( Time() < player.cv.antiTitanHintNextShowTime )
		return

	if ( player.GetActiveWeapon() == player.GetOrdnanceWeapon() )
		return

	if( PlayerIsRodeoingTarget( player, entity ) )
		return

	cockpit.s.mainVGUI.s.antiTitanHint.Show()
	cockpit.s.mainVGUI.s.panel.RunAnimationScript( "FadeAntiTitanHint" )

	if ( !player.cv.ordnanceUseCount )
		player.cv.antiTitanHintNextShowTime = Time() + 30.0
	else
		player.cv.antiTitanHintNextShowTime = Time() + 120.0
}


function RodeoAlertThink( cockpit, player )
{
	cockpit.EndSignal( "OnDestroy" )
	player.EndSignal( "OnDestroy" )

	OnThreadEnd(
		function() : ()
		{
			if ( GAMETYPE == CAPTURE_THE_FLAG || GAMETYPE == CAPTURE_THE_FLAG_PRO )
			{
				local clientPlayer = GetLocalClientPlayer()

				if ( !IsValid( clientPlayer ) || !clientPlayer.cv )
					return

				if ( clientPlayer.cv.hud.s.lastEventNotificationText != "#GAMEMODE_RODEO_PILOT_HAS_THE_ENEMY_FLAG" )
					return

				ClearEventNotification()
			}
		}
	)

	for ( ;; )
	{
		local results = WaitSignal( player, "UpdateRodeoAlert" )

		local soul = player.GetTitanSoul()
		local rider = IsValid( soul ) ? soul.GetRiderEnt() : null

		if ( IsValid( rider ) )
		{
			cockpit.s.mainVGUI.s.rodeoAlertIcon.Show()
			cockpit.s.mainVGUI.s.rodeoAlertLabel.Show()

			if ( ShouldPreventFriendlyFire( rider, player ) )
			{
				cockpit.s.mainVGUI.s.rodeoAlertIcon.SetImage( "HUD/rodeo_icon_friendly" )
				cockpit.s.mainVGUI.s.rodeoAlertLabel.SetText( "#HUD_RODEO_RIDER_FRIENDLY", rider.GetPlayerName() )
				cockpit.s.mainVGUI.s.rodeoAlertLabel.SetColor( 61, 211, 255, 200 )
				cockpit.s.mainVGUI.s.antiRodeoHint.Hide()

				if ( ( GAMETYPE == CAPTURE_THE_FLAG || GAMETYPE == CAPTURE_THE_FLAG_PRO ) && PlayerHasEnemyFlag( rider ) )
					SetEventNotification( "#GAMEMODE_RODEO_PILOT_HAS_THE_ENEMY_FLAG" )
			}
			else
			{
				cockpit.s.mainVGUI.s.rodeoAlertIcon.SetImage( "HUD/rodeo_icon_enemy" )
				if ( rider.IsPlayer() )
					cockpit.s.mainVGUI.s.rodeoAlertLabel.SetText( "#HUD_RODEO_RIDER_ENEMY", rider.GetPlayerName() )
				else
					cockpit.s.mainVGUI.s.rodeoAlertLabel.SetText( "#HUD_RODEO_RIDER_ENEMY_SPECTRE" )
				cockpit.s.mainVGUI.s.rodeoAlertLabel.SetColor( 255, 128, 0, 200 )
				cockpit.s.mainVGUI.s.antiRodeoHint.Show()
			}
		}
		else
		{
			cockpit.s.mainVGUI.s.rodeoAlertIcon.Hide()
			cockpit.s.mainVGUI.s.rodeoAlertLabel.Hide()
			cockpit.s.mainVGUI.s.antiRodeoHint.Hide()

			if ( GAMETYPE == CAPTURE_THE_FLAG || GAMETYPE == CAPTURE_THE_FLAG_PRO )
			{
				if ( player != GetLocalClientPlayer() || !player.cv )
					continue

				if ( player.cv.hud.s.lastEventNotificationText != "#GAMEMODE_RODEO_PILOT_HAS_THE_ENEMY_FLAG" )
					continue

				ClearEventNotification()
			}
		}
	}
}

function RodeoRideThink( cockpit, player )
{
	cockpit.EndSignal( "OnDestroy" )
	player.EndSignal( "OnDestroy" )

	for ( ;; )
	{
		local results = WaitSignal( player, "UpdateRodeoAlert" )

		if ( !DidUpdateRodeoRideNameAndIcon( cockpit, player ) )
		{
			cockpit.s.mainVGUI.s.rodeoAlertIcon.Hide()
			cockpit.s.mainVGUI.s.rodeoAlertLabel.Hide()
			cockpit.s.mainVGUI.s.antiRodeoHint.Hide()
		}
	}
}

function DidUpdateRodeoRideNameAndIcon( cockpit, player )
{
	local soul = player.GetTitanSoulBeingRodeoed()
	if ( !IsValid( soul ) )
		return false

	local titan = soul.GetTitan()
	local name = GetTitanName( soul, titan )

	if ( name == null )
		return false

	cockpit.s.mainVGUI.s.rodeoAlertIcon.Show()
	cockpit.s.mainVGUI.s.rodeoAlertLabel.Show()

	if ( titan.GetTeam() == player.GetTeam() )
	{
		cockpit.s.mainVGUI.s.rodeoAlertIcon.SetImage( "HUD/riding_icon_friendly" )
		cockpit.s.mainVGUI.s.rodeoAlertLabel.SetText( "#HUD_RODEO_RIDER_FRIENDLY", name )
		cockpit.s.mainVGUI.s.rodeoAlertLabel.SetColor( 61, 211, 255, 200 )
	}
	else
	{
		cockpit.s.mainVGUI.s.rodeoAlertIcon.SetImage( "HUD/riding_icon_enemy" )
		cockpit.s.mainVGUI.s.rodeoAlertLabel.SetText( "#HUD_RODEO_RIDER_ENEMY", name )
		cockpit.s.mainVGUI.s.rodeoAlertLabel.SetColor( 255, 128, 0, 200 )
	}

	return true
}

function GetTitanName( soul, titan )
{
	if ( titan.IsPlayer() )
		return titan.GetPlayerName()

	if ( IsValid( titan.GetBossPlayer() ) )
		return titan.GetBossPlayerName()
}



function TargetHealthBarsThink( cockpit, player )
{
	cockpit.EndSignal( "OnDestroy" )
	player.EndSignal( "OnDestroy" )

	thread TargetHealthBarsVis( cockpit, player )
	thread UsedOrdnanceThink( cockpit, player )

	if ( NEW_TARGET_HEALTHBARS )
		thread ConnectingLineThink( cockpit, player )

	local isTitan = IsTitanCockpitModelName( cockpit.GetModelName() )

	for ( ;; )
	{
		local results = WaitSignal( player, "HealthBarEntityTargetChanged", "DoomedTarget", "UpdateTargetShieldHealth", "TargetHealthBarsUpdate" )

		player.Signal( "UpdateShieldBar" )

		local targetHealthBarEntity = GetHealthBarEntity( player )

		switch ( results.signal )
		{
			case "HealthBarEntityTargetChanged":
				if ( !isTitan && targetHealthBarEntity && GetConVarBool( "delta_hud_show_AT_hint" ) )
					ShowAntiTitanHint( cockpit, player, targetHealthBarEntity  )
				break
			case "DoomedTarget":
				break
			case "UpdateTargetShieldHealth":
				break
			case "TargetHealthBarsUpdate":
				break
		}

		TargetHealthBarsUpdate( cockpit, player, targetHealthBarEntity )
	}
}

function ConnectingLineThink( cockpit, player )
{
	cockpit.EndSignal( "OnDestroy" )
	player.EndSignal( "OnDestroy" )

	local connectingLine = cockpit.s.mainVGUI.s.targetSmallConnectingLine
	local startPos = cockpit.s.mainVGUI.s.targetHealthBar

	local screenSize = Hud.GetScreenSize()

	for ( ;; )
	{
		local targetHealthBarEntity = GetHealthBarEntity( player )

		if ( targetHealthBarEntity && cockpit.s.hasLOS )
		{
			local endX = startPos.GetAbsX()
			local endY = startPos.GetAbsY()

			local linkOrigin

			if ( IsValid( player.GetTitanSoulBeingRodeoed() ) && player.GetTitanSoulBeingRodeoed() == targetHealthBarEntity.GetTitanSoul() )
			{
				local attachID = targetHealthBarEntity.LookupAttachment( "HATCH_PANEL" )
				linkOrigin = targetHealthBarEntity.GetAttachmentOrigin( attachID )
			}
			else
			{
				local wOrigin = targetHealthBarEntity.GetWorldSpaceCenter()
				local halfZ = wOrigin.z - targetHealthBarEntity.GetOrigin().z
				linkOrigin = wOrigin + Vector( 0, 0, halfZ + 16 )
			}

			local vecToTarget = (linkOrigin - player.EyePosition())
			vecToTarget.Normalize()
			local dot = player.GetViewVector().Dot( vecToTarget )

			local screenPos = cockpit.s.mainVGUI.s.panel.ToScreenSpaceClamped( linkOrigin )
			screenPos = cockpit.s.mainVGUI.s.panel.ClipScreenPositionToBox( screenPos[0], screenPos[1], 0, screenSize[0], 0, screenSize[1] )

			local startX = screenPos[0].tofloat()
			local startY = screenPos[1].tofloat()

			// calculate the angle of the connecting line
			local offsetX = endX - startX
			local offsetY = endY - startY
			local angle = ( atan( offsetX / offsetY ) * ( 180 / PI ) )

			// Calculate how long the connecting line should be
			local length = sqrt( offsetX * offsetX + offsetY * offsetY )

			//length = min( length, 400 )

			// Calculate where the line should be positioned
			local posX = endX - ( length / 2.0 ) - ( offsetX / 2.0 )
			local posY = endY - ( offsetY / 2.0 )

			posX = clamp( posX, -32768, 32768 )
			posY = clamp( posY, -32768, 32768 )

			if ( posY <= 174 )
				angle += 180

			// Position the diagonal connecting line
			connectingLine.SetWidth( length )
			connectingLine.SetPos( posX, posY )
			connectingLine.SetRotation( angle + 90.0 )
			if ( targetHealthBarEntity.IsTitan() && DoesTitanHaveActiveTitanBurnCard( targetHealthBarEntity ) )
			{
				connectingLine.SetColor( BURN_CARD_WEAPON_HUD_COLOR )
				connectingLine.SetAlpha( GraphCapped( dot, 0.8, 0.4, 255, 20 ) )
			}
			else
			{
				connectingLine.ReturnToBaseColor()
				connectingLine.SetAlpha( GraphCapped( dot, 0.8, 0.75, 50, 20 ) )
			}

			connectingLine.Show()

		}
		else
		{
			connectingLine.Hide()
		}
		wait 0
	}
}


function TitanBuildAnchorThink( cockpit, player )
{
	cockpit.EndSignal( "OnDestroy" )
	player.EndSignal( "OnDestroy" )

	local screenSize = Hud.GetScreenSize()

	for ( ;; )
	{
		local crosshairPos = player.GetCrosshairPos()

		local xPos = clamp( screenSize[0] * crosshairPos[0], -16000, 16000 )
		local yPos = clamp( screenSize[1] * crosshairPos[1], -16000, 16000 )

		cockpit.s.mainVGUI.s.titanBarEarnedLabelAnchor.SetPos( xPos, yPos )

		wait 0
	}
}


function TitanBuildBarThink( cockpit, player )
{
	if ( IsTrainingLevel() ) // do not show the "READY" hud element on training
		return
	cockpit.EndSignal( "OnDestroy" )
	player.EndSignal( "OnDestroy" )

	local isTitanCockpit = IsTitanCockpitModelName( cockpit.GetModelName() )
	local soul
	local lastRespawnAvailable
	if ( isTitanCockpit )
	{
		// bail out if we're getting ripped out of the cockpit
		if ( !player.IsTitan() )
			return

		if ( !IsAlive( player ) )
			return

		lastRespawnAvailable = player.GetNextTitanRespawnAvailable()
		soul = player.GetTitanSoul()
		soul.EndSignal( "OnDestroy" )
	}
	else
	{
		lastRespawnAvailable = player.GetNextTitanRespawnAvailable()
	}

	local lastTimeDiff = 0

	local lastEarnedDisplayTime = 0

	thread TitanBuildAnchorThink( cockpit, player )

	for ( ;; )
	{
		if ( IsAlive( player.GetPetTitan() ) || IsWatchingKillReplay() )
		{
			cockpit.s.mainVGUI.s.titanBar.Hide()
			cockpit.s.mainVGUI.s.titanBarLabel.Hide()
			cockpit.s.mainVGUI.s.titanBarEarnedLabel.Hide()
			cockpit.s.mainVGUI.s.titanBarEarnedIcon.Hide()
			cockpit.s.mainVGUI.s.titanBarLeftIcon.Hide()
			cockpit.s.mainVGUI.s.titanBarRightIcon.Hide()

			player.WaitSignal( "UpdateTitanBuildBar" )
			continue
		}

		local totalTime
		local remainingTime

		local buildingIcon
		local readyIcon

		if ( !isTitanCockpit )
		{
			totalTime = player.GetTitanBuildTime()
			remainingTime = player.GetNextTitanRespawnAvailable() - Time()

			buildingIcon = GetTitanBuildingIcon( player )
			readyIcon = GetTitanReadyIcon( player )
		}
		else
		{
			totalTime = GetCurrentPlaylistVarInt( "titan_core_build_time", TITAN_CORE_BUILD_TIME )
			remainingTime = soul.GetNextCoreChargeAvailable() - Time()

			buildingIcon = GetCoreBuildingIcon( player )
			readyIcon = GetCoreIcon( player )
		}

		totalTime = max( totalTime, 1 )

		local progressFrac = 1 - (remainingTime / totalTime)

		cockpit.s.mainVGUI.s.titanBar.SetBarProgressOverTime( 1 - (remainingTime / totalTime), 1.0, remainingTime )

		local timeDiff
		if ( !isTitanCockpit )
			timeDiff = lastRespawnAvailable - player.GetNextTitanRespawnAvailable()
		else
			timeDiff = lastRespawnAvailable - soul.GetNextCoreChargeAvailable()

		if ( timeDiff > 0 && progressFrac > 0.02 && progressFrac < 1.0 && timeDiff < 9999 )
		{
			if ( Time() - lastEarnedDisplayTime < 3.0 )
				timeDiff += lastTimeDiff

			if ( timeDiff > 1.0 && GetConVarBool( "delta_hud_show_titan_earnings" ) )
			{
				cockpit.s.mainVGUI.s.titanBarEarnedLabel.Show()
				cockpit.s.mainVGUI.s.titanBarEarnedLabel.SetColor( 173, 226, 255, 255 )
				cockpit.s.mainVGUI.s.titanBarEarnedLabel.FadeOverTimeDelayed( 0, 1.0, 1.0 )

				cockpit.s.mainVGUI.s.titanBarEarnedLabel.SetText( "#HUD_TIME_EARNED", format( "%d", timeDiff ) )

				cockpit.s.mainVGUI.s.titanBarEarnedIcon.SetImage( buildingIcon )
				cockpit.s.mainVGUI.s.titanBarEarnedIcon.Show()
				cockpit.s.mainVGUI.s.titanBarEarnedIcon.SetColor( 255, 255, 255, 255 )
				cockpit.s.mainVGUI.s.titanBarEarnedIcon.ColorOverTimeDelayed( 0, 0, 0, 255, 1.0, 1.0 )
			}

			lastEarnedDisplayTime = Time()
			lastTimeDiff = timeDiff
		}
		else if ( progressFrac >= 1.0 && timeDiff && GetConVarBool( "delta_hud_show_titan_earnings" ) )
		{
			cockpit.s.mainVGUI.s.titanBarEarnedLabel.Show()
			cockpit.s.mainVGUI.s.titanBarEarnedLabel.SetColor( 173, 226, 255, 255 )
			cockpit.s.mainVGUI.s.titanBarEarnedLabel.FadeOverTimeDelayed( 0, 1.0, 1.0 )

			cockpit.s.mainVGUI.s.titanBarEarnedLabel.SetText( "#HUD_READY" )

			cockpit.s.mainVGUI.s.titanBarEarnedIcon.SetImage( readyIcon )
			cockpit.s.mainVGUI.s.titanBarEarnedIcon.Show()
			cockpit.s.mainVGUI.s.titanBarEarnedIcon.SetColor( 255, 255, 255, 255 )
			cockpit.s.mainVGUI.s.titanBarEarnedIcon.ColorOverTimeDelayed( 0, 0, 0, 255, 1.0, 1.0 )
		}

		if ( !isTitanCockpit )
			lastRespawnAvailable = player.GetNextTitanRespawnAvailable()
		else
			lastRespawnAvailable = soul.GetNextCoreChargeAvailable()

		if ( ShouldHideTitanBar( player ) )
		{
			cockpit.s.mainVGUI.s.titanBar.Hide()
			cockpit.s.mainVGUI.s.titanBarLabel.Hide()
			cockpit.s.mainVGUI.s.titanBarEarnedLabel.Hide()
			cockpit.s.mainVGUI.s.titanBarEarnedIcon.Hide()
			cockpit.s.mainVGUI.s.titanBarLeftIcon.Hide()
			cockpit.s.mainVGUI.s.titanBarRightIcon.Hide()
		}
		else
		{
			if ( remainingTime < 0 )
			{
				if ( isTitanCockpit )
					cockpit.s.mainVGUI.s.titanBarLabel.SetText( "#HUD_TITAN_CORE_READY" )
				else
					cockpit.s.mainVGUI.s.titanBarLabel.SetText( "#HUD_TITAN_READY" )
				cockpit.s.mainVGUI.s.titanBarLabel.SetColor( 255, 255, 255, 255 )
			}
			else
			{
				if ( isTitanCockpit )
					cockpit.s.mainVGUI.s.titanBarLabel.SetText( "#HUD_TITAN_CORE_CHARGING" )
				else
					cockpit.s.mainVGUI.s.titanBarLabel.SetText( "#HUD_TITAN_BUILDING" )
				cockpit.s.mainVGUI.s.titanBarLabel.SetColor( 192, 192, 192, 255 )
			}
		}

		player.WaitSignal( "UpdateTitanBuildBar" )
	}
}

function ShouldHideTitanBar( player )
{
	if ( !player.IsTitan() )
		return false

	if ( !TITAN_CORE_ENABLED )
		return true

	if ( player.GetDoomedState() )
		return true

	return false

}


function EMPThink( cockpit, player )
{
	cockpit.EndSignal( "OnDestroy" )
	player.EndSignal( "OnDestroy" )

	cockpit.s.empScreenFX <- HudElement( "EMPScreenFX", cockpit.s.mainVGUI.s.panel )

	for ( ;; )
	{
		local results = player.WaitSignal( "EMPScreenFX" )

		cockpit.s.empScreenFX.Show()
		cockpit.s.empScreenFX.SetAlpha( results.maxValue * 255 )
		cockpit.s.empScreenFX.FadeOverTimeDelayed( 0, results.fadeTime, results.duration )
		//cockpit.s.empScreenFX.SetOrigin( Vector( 0, 0, 0 ) )
		//cockpit.s.empScreenFX.SetFOVFade( deg_cos( 45 ), deg_cos( 15 ), 0, 1 )
	}
}


function RodeoHealthUpdateThink( cockpit, player, target )
{
	cockpit.EndSignal( "OnDestroy" )
	player.EndSignal( "OnDestroy" )
	player.EndSignal( "HealthBarEntityTargetChanged" )

	local soul = target.GetTitanSoul()
	soul.EndSignal( "OnDestroy" )

	cockpit.s.mainVGUI.s.targetHealthBar.SetEntity( null, Vector( 0, 0, 0 ), 0.5, 1.0 )
	cockpit.s.mainVGUI.s.targetShieldHealthBar.SetEntity( null, Vector( 0, 0, 0 ), 0.5, 1.0 )
	cockpit.s.mainVGUI.s.targetHealthBarBurnCardIndicator.SetEntity( null, Vector( 0, 0, 0 ), 0.5, 1.0 )
	cockpit.s.mainVGUI.s.targetHealthBarSubClass.SetEntity( null, Vector( 0, 0, 0 ), 0.5, 1.0 )
	cockpit.s.mainVGUI.s.targetDoomedHealthBar.SetEntity( null, Vector( 0, 0, 0 ), 0.5, 1.0 )

	local attachID = target.LookupAttachment( "HATCH_PANEL" )

	while ( target && player.GetTitanSoulBeingRodeoed() == soul )
	{
		local origin = target.GetAttachmentOrigin( attachID )

		cockpit.s.mainVGUI.s.targetHealthBar.SetOrigin( origin )
		cockpit.s.mainVGUI.s.targetShieldHealthBar.SetOrigin( origin )
		cockpit.s.mainVGUI.s.targetDoomedHealthBar.SetOrigin( origin )
		cockpit.s.mainVGUI.s.targetHealthBarBurnCardIndicator.SetOrigin( origin )
		cockpit.s.mainVGUI.s.targetHealthBarSubClass.SetOrigin( origin )
		wait 0
	}
}

function DrawTargetHealthBar( targetHealthBarEntity, cockpit )
{
	if ( !targetHealthBarEntity )
		return false

	return NEW_TARGET_HEALTHBARS || cockpit.s.hasLOS
}

function TargetHealthBarsUpdate( cockpit, player, targetHealthBarEntity )
{
	local mainVGUI = cockpit.GetMainVGUI()
	if ( !DrawTargetHealthBar( targetHealthBarEntity, cockpit ) )
	{
		mainVGUI.s.targetHealthBar.Hide()
		mainVGUI.s.targetHealthBarBurnCardIndicator.Hide()
		mainVGUI.s.targetHealthBarSubClass.Hide()
		mainVGUI.s.targetShieldHealthBar.Hide()
		mainVGUI.s.targetDoomedHealthBar.Hide()
		return
	}

	mainVGUI.s.targetHealthBar.SetBarProgressSourceEntity( targetHealthBarEntity )

	if ( !targetHealthBarEntity.IsTitan() )
	{
		mainVGUI.s.targetHealthBar.SetColor( 255, 255, 255, 255 )
		mainVGUI.s.targetHealthBar.Show()
		mainVGUI.s.targetDoomedHealthBar.Hide()
		mainVGUI.s.targetHealthBarBurnCardIndicator.Hide()
		mainVGUI.s.targetHealthBarSubClass.Hide()

		local shieldFrac = GetShieldHealthFrac( targetHealthBarEntity )

		if ( !shieldFrac )
		{
			mainVGUI.s.targetShieldHealthBar.Hide()
		}
		else
		{
			mainVGUI.s.targetShieldHealthBar.Show()
			mainVGUI.s.targetShieldHealthBar.SetBarProgress( shieldFrac )
			mainVGUI.s.targetHealthBar.SetColor( 160, 160, 160, 255 )
		}

		return
	}

	mainVGUI.s.targetDoomedHealthBar.SetBarProgressSourceEntity( targetHealthBarEntity )

	if ( targetHealthBarEntity.GetDoomedState() )
	{
		mainVGUI.s.targetHealthBar.Hide()
		mainVGUI.s.targetDoomedHealthBar.Show()
	}
	else
	{
		mainVGUI.s.targetHealthBar.Show()
		mainVGUI.s.targetDoomedHealthBar.Hide()
	}

	if ( DoesTitanHaveActiveTitanBurnCard( targetHealthBarEntity ) )
	{
		mainVGUI.s.targetHealthBarBurnCardIndicator.SetImage( "HUD/overhead_shieldbar_burn_card_indicator" )
		mainVGUI.s.targetHealthBarBurnCardIndicator.Show()
	}
	else
		mainVGUI.s.targetHealthBarBurnCardIndicator.Hide()

	if ( IsValid( targetHealthBarEntity ) && GAMETYPE == COOPERATIVE )
	{
		local image = GetTitanSubclassHudIcon( targetHealthBarEntity )
		mainVGUI.s.targetHealthBarSubClass.SetImage( image )
		mainVGUI.s.targetHealthBarSubClass.Show()
	}
	else
		mainVGUI.s.targetHealthBarSubClass.Hide()

	local shieldFrac = GetShieldHealthFrac( targetHealthBarEntity )

	if ( shieldFrac )
	{
		mainVGUI.s.targetShieldHealthBar.Show()
		mainVGUI.s.targetShieldHealthBar.SetBarProgress( shieldFrac )
		mainVGUI.s.targetHealthBar.SetColor( 160, 160, 160, 255 )

		if ( targetHealthBarEntity.IsPlayer() && PlayerHasPassive( targetHealthBarEntity, PAS_SHIELD_BOOST ) )
		{
			mainVGUI.s.targetShieldHealthBar.SetColor( SHIELD_BOOST_R, SHIELD_BOOST_G, SHIELD_BOOST_B, 255 )
		}
		else
		{
			mainVGUI.s.targetShieldHealthBar.SetColor( SHIELD_R, SHIELD_G, SHIELD_B, 255 )
		}
	}
	else
	{
		mainVGUI.s.targetShieldHealthBar.Hide()
		mainVGUI.s.targetHealthBar.SetColor( 255, 255, 255, 255 )
	}
}


function TargetHealthBarsVis( cockpit, player )
{
	cockpit.EndSignal( "OnDestroy" )
	player.EndSignal( "OnDestroy" )

	local hadLOS = false

	cockpit.s.hasLOS <- false

	for ( ;; )
	{
		local targetHealthBarEntity = GetHealthBarEntity( player )

		if ( IsValid( targetHealthBarEntity ) )
		{
			local traceID = DeferredTraceLine( player.EyePosition(), targetHealthBarEntity.GetWorldSpaceCenter(), player, TRACE_MASK_SOLID_BRUSHONLY | TRACE_MASK_WATER, TRACE_COLLISION_GROUP_NONE )
			wait 0
			if ( !IsDeferredTraceValid( traceID ) )
				continue

			local result = GetDeferredTraceResult( traceID )

			local hasLOS = result.fraction >= 0.99

			cockpit.s.hasLOS = hasLOS

			if ( hasLOS != hadLOS )
			{
				player.Signal( "TargetHealthBarsUpdate" )
			}

			hadLOS = hasLOS
		}

		wait 0.25
	}
}


function Create_PilotHud( cockpit, player )
{
	local width = 852 / 2
	local height = 480 / 2

	local size = [width, height]

	local attachment = "CAMERA_BASE"
	local attachId = cockpit.LookupAttachment( attachment )
	local origin = Vector( 0, 0, 0 )
	local angles = Vector( 0, 0, 0 )

	origin += angles.AnglesToForward() * 208
	origin += angles.AnglesToRight() * (-width / 2)
	origin += angles.AnglesToUp() * (-height / 2)

	angles = angles.AnglesCompose( Vector( 0, -90, 90 ) )

	local vgui = CreateClientsideVGuiScreen( "vgui_fullscreen_pilot", VGUI_SCREEN_PASS_HUD, origin, angles, size[0], size[1] )
	vgui.s.panel <- vgui.GetPanel()
	vgui.s.baseSize <- size
	vgui.s.baseOrigin <- origin

	vgui.SetParent( cockpit, attachment )
	vgui.SetAttachOffsetOrigin( origin )
	vgui.SetAttachOffsetAngles( angles )

	local panel = vgui.GetPanel()

	Create_CommonHudElements( cockpit, player, vgui, panel )

	vgui.s.warpSettings <- {
		xWarp = 45
		xScale = 1.3
		yWarp = 30
		yScale = 1.1
		viewDist = 1.0
	}

	local warpSettings = vgui.s.warpSettings

	return vgui
}


function Create_TitanHud( cockpit, player )
{
	local width = 46.00
	local height = width / 1.7665

	local attachment = "CAMERA_BASE"
	local origin = Vector( 0, 0, 0 )
	local angles = Vector( 0, 0, 0 )

	origin += angles.AnglesToForward() * 22
	origin += angles.AnglesToRight() * (-width / 2)
	origin += angles.AnglesToUp() * (-height / 2)

	angles = angles.AnglesCompose( Vector( 0, -90, 90 ) )

	local vgui = CreateClientsideVGuiScreen( "vgui_fullscreen_titan", VGUI_SCREEN_PASS_HUD, origin, angles, width, height );
	vgui.s.panel <- vgui.GetPanel()
	vgui.s.baseSize <- [width, height]
	vgui.s.baseOrigin <- origin

	vgui.SetParent( cockpit, attachment )
	vgui.SetAttachOffsetOrigin( origin )
	vgui.SetAttachOffsetAngles( angles )

	local panel = vgui.GetPanel()

	Create_CommonHudElements( cockpit, player, vgui, panel )

	vgui.s.warpSettings <- {
		xWarp = 42
		xScale = 1.22
		yWarp = 30
		yScale = 0.96
		viewDist = 1.0
	}

	return vgui
}

function Create_CommonHudElements( cockpit, player, vgui, panel )
{
	local VDU_ScreenGroup = HudElementGroup( "VDU_Screen" )
	vgui.s.VDU_Screen <- VDU_ScreenGroup.CreateElement( "VDU_CockpitScreen", panel )
	vgui.s.VDU_BG <- VDU_ScreenGroup.CreateElement( "VDU_BG", panel )
	vgui.s.VDU_FG <- VDU_ScreenGroup.CreateElement( "VDU_FG", panel )
	vgui.s.VDU_Static <- VDU_ScreenGroup.CreateElement( "VDU_CockpitStatic", panel )
	vgui.s.vduOpen <- false

	vgui.s.VDU_ScreenGroup <- VDU_ScreenGroup

//	vgui.s.burnCardElem <- CreateBurnCardHudElements( "BurnCard", panel )
}

function ServerCallback_MinimapPulse( eHandle )
{
	if ( level.showingFullscreenMap == true )
		return

	local player = GetEntityFromEncodedEHandle( eHandle )
	thread MinimapPulse( player )
}

function MinimapPulse( player )
{
	if ( player != GetLocalViewPlayer()	)
		return

	local cockpit = player.GetCockpit()
	if ( !IsValid( cockpit ) )
		return
	if ( !( "mainVGUI" in cockpit.s ) )
		return

	cockpit.EndSignal( "OnDestroy" )
	player.EndSignal( "OnDestroy" )
	local fadeTime = 0.55

	cockpit.s.mainVGUI.s.minimapOverlay.Show()
	EmitSoundOnEntity( player, "radarpulse_on"  )
	for ( local i = 0; i < 5; ++i  )
	{
	cockpit.s.mainVGUI.s.minimapOverlay.SetColor( 130, 180, 200, 40 )
	cockpit.s.mainVGUI.s.minimapOverlay.FadeOverTime( 0, fadeTime, INTERPOLATOR_ACCEL )
	wait fadeTime
	}

	cockpit.s.mainVGUI.s.minimapOverlay.Hide()
}

/*function Create_GlobalHud( player )
{
	local width = 852 / 2
	local height = 480 / 2

	local origin = Vector( 0, 0, 0 )
	local angles = Vector( 0, 0, 0 )

	origin += angles.AnglesToForward() * 208
	origin += angles.AnglesToRight() * (-width / 2)
	origin += angles.AnglesToUp() * (-height / 2)

	angles = angles.AnglesCompose( Vector( 0, -90, 90 ) )

	local vgui = CreateClientsideVGuiScreen( "vgui_fullscreen_global", VGUI_SCREEN_PASS_HUD, origin, angles, width, height )
	vgui.s.panel <- vgui.GetPanel()

	vgui.SetParent( player )
	vgui.SetAttachOffsetOrigin( origin )
	vgui.SetAttachOffsetAngles( angles )

	vgui.s.warpSettings <- {
		xWarp = 45
		xScale = 1.3
		yWarp = 30
		yScale = 1.1
		viewDist = 1.0
	}

	local warpSettings = vgui.s.warpSettings

	vgui.s.panel.WarpGlobalSettings( warpSettings.xWarp, warpSettings.xScale, warpSettings.yWarp, warpSettings.yScale, warpSettings.viewDist )
	vgui.s.panel.WarpEnable()

	return vgui
}*/


function MainHud_InitDPAD( cockpit, player )
{
	local panel = cockpit.s.mainVGUI.GetPanel()

	cockpit.s.dpadIcon <- HudElement( "dpadIcon", panel )
	cockpit.s.dpadIcons <- {}
	cockpit.s.dpadIcons[BUTTON_DPAD_UP] 		<- HudElement( "dpadUpIcon", panel )
	cockpit.s.dpadIcons[BUTTON_DPAD_DOWN] 		<- HudElement( "dpadDownIcon", panel )
	cockpit.s.dpadIcons[BUTTON_DPAD_LEFT] 		<- HudElement( "dpadLeftIcon", panel )
	cockpit.s.dpadIcons[BUTTON_DPAD_RIGHT] 		<- HudElement( "dpadRightIcon", panel )

	cockpit.s.dpadBGs <- {}
	cockpit.s.dpadBGs[BUTTON_DPAD_UP] 			<- null
	cockpit.s.dpadBGs[BUTTON_DPAD_DOWN] 		<- HudElement( "dpadDownIconBG", panel )
	cockpit.s.dpadBGs[BUTTON_DPAD_LEFT] 		<- null
	cockpit.s.dpadBGs[BUTTON_DPAD_RIGHT] 		<- null

	cockpit.s.dpadProgressBars <- {}
	cockpit.s.dpadProgressBars[BUTTON_DPAD_UP]		<- null
	cockpit.s.dpadProgressBars[BUTTON_DPAD_DOWN]	<- HudElement( "dpadDownIconProgressBar", panel )
	cockpit.s.dpadProgressBars[BUTTON_DPAD_LEFT]	<- null
	cockpit.s.dpadProgressBars[BUTTON_DPAD_RIGHT]	<- null

	cockpit.s.dpadIcon.Show()

	// cockpit.s.dpadIcons[BUTTON_DPAD_UP].Show()
	// cockpit.s.dpadIcons[BUTTON_DPAD_DOWN].Show()
	// cockpit.s.dpadIcons[BUTTON_DPAD_LEFT].Show()
	// cockpit.s.dpadIcons[BUTTON_DPAD_RIGHT].Show()

	cockpit.s.dpadDescs <- {}
	cockpit.s.dpadDescs[BUTTON_DPAD_UP] 		<- HudElement( "dpadUpDesc", panel )
	cockpit.s.dpadDescs[BUTTON_DPAD_DOWN] 		<- HudElement( "dpadDownDesc", panel )
	cockpit.s.dpadDescs[BUTTON_DPAD_LEFT] 		<- HudElement( "dpadLeftDesc", panel )
	cockpit.s.dpadDescs[BUTTON_DPAD_RIGHT] 		<- HudElement( "dpadRightDesc", panel )

	cockpit.s.dpadTitles <- {}
	cockpit.s.dpadTitles[BUTTON_DPAD_UP] 		<- HudElement( "dpadUpTitle", panel )
	cockpit.s.dpadTitles[BUTTON_DPAD_DOWN] 		<- HudElement( "dpadDownTitle", panel )
	cockpit.s.dpadTitles[BUTTON_DPAD_LEFT] 		<- HudElement( "dpadLeftTitle", panel )
	cockpit.s.dpadTitles[BUTTON_DPAD_RIGHT] 	<- HudElement( "dpadRightTitle", panel )

	cockpit.s.dpadAlerts <- {}
	cockpit.s.dpadAlerts[BUTTON_DPAD_UP] 		<- HudElement( "dpadUpIconAlert", panel )
	cockpit.s.dpadAlerts[BUTTON_DPAD_DOWN] 		<- HudElement( "dpadDownIconAlert", panel )
	cockpit.s.dpadAlerts[BUTTON_DPAD_LEFT] 		<- HudElement( "dpadLeftIconAlert", panel )
	cockpit.s.dpadAlerts[BUTTON_DPAD_RIGHT] 	<- HudElement( "dpadRightIconAlert", panel )

	cockpit.s.dpadHints <- {}
	cockpit.s.dpadHints[BUTTON_DPAD_UP] 		<- HudElement( "dpadUpIconHint", panel )
	cockpit.s.dpadHints[BUTTON_DPAD_DOWN] 		<- HudElement( "dpadDownIconHint", panel )
	cockpit.s.dpadHints[BUTTON_DPAD_LEFT] 		<- HudElement( "dpadLeftIconHint", panel )
	cockpit.s.dpadHints[BUTTON_DPAD_RIGHT] 		<- HudElement( "dpadRightIconHint", panel )

	foreach ( elem in cockpit.s.dpadHints )
	{
		elem.EnableKeyBindingIcons()
	}

	if ( IsWatchingKillReplay() )
	{
		// add elements to a group so that I can hide them when needed
		cockpit.s.dpadGroup <- HudElementGroup( "dpad" )

		cockpit.s.dpadGroup.AddElement( cockpit.s.dpadIcon )
		cockpit.s.dpadGroup.AddElement( cockpit.s.dpadBGs[BUTTON_DPAD_DOWN] )
		cockpit.s.dpadGroup.AddElement( cockpit.s.dpadProgressBars[BUTTON_DPAD_DOWN] )

		foreach( elem in cockpit.s.dpadIcons )
			cockpit.s.dpadGroup.AddElement( elem )
		foreach( elem in cockpit.s.dpadDescs )
			cockpit.s.dpadGroup.AddElement( elem )
		foreach( elem in cockpit.s.dpadTitles )
			cockpit.s.dpadGroup.AddElement( elem )
		foreach( elem in cockpit.s.dpadAlerts )
			cockpit.s.dpadGroup.AddElement( elem )
		foreach( elem in cockpit.s.dpadHints )
			cockpit.s.dpadGroup.AddElement( elem )

		cockpit.s.dpadGroup.Hide()
	}

	UpdateDpadIcons( player )
}


function InitOffhandWeaponHud( cockpit, player, offhandIndex )
{
	local panel = cockpit.s.mainVGUI.GetPanel()

	local weapon
	weapon = player.GetOffhandWeapon( offhandIndex )

	if ( !weapon )
	{
		cockpit.s.offhandHud[offhandIndex].icon.SetImage( "HUD/empty" )
		cockpit.s.offhandHud[offhandIndex].alert.SetImage( "HUD/empty" )
		return
	}
	local hudIcon = weapon.GetWeaponInfoFileKeyField( "hud_icon" )
	if ( hudIcon )
	{
		cockpit.s.offhandHud[offhandIndex].icon.SetImage( hudIcon )
		cockpit.s.offhandHud[offhandIndex].alert.SetImage( hudIcon )
		//Hack - Checking for specific weapon because hudIcon isn't a modifiable setting and the weapon doesn't call on weapon active to set useHudIconCharges. Feature Request sent regarding this
		//if ( "useHudIconCharges" in weapon.s || ( weapon.HasModDefined( "burn_mod_titan_bubble_shield" ) && weapon.HasMod( "burn_mod_titan_bubble_shield" ) ) )
		//{
		//	local ammo = player.GetWeaponAmmoLoaded( weapon )
		//	cockpit.s.offhandHud[offhandIndex].icon.SetImage( hudIcon + "_charge_" + ammo )
		//}
	}


	cockpit.s.offhandHud[offhandIndex].icon.Show()
	cockpit.s.offhandHud[offhandIndex].hint.Show()

	local fracDraw = GetOffhandProgressSource( weapon )

	if ( !fracDraw )
	{
		cockpit.s.offhandHud[offhandIndex].showBar = false
		cockpit.s.offhandHud[offhandIndex].bar.Hide()
		cockpit.s.offhandHud[offhandIndex].count.Show()
		if ( offhandIndex == 0 )
			cockpit.s.offhandHud[offhandIndex].count.SetAutoText( "", HATT_OFFHAND_WEAPON_AMMO_0, 0 )
		else
			cockpit.s.offhandHud[offhandIndex].count.SetAutoText( "", HATT_OFFHAND_WEAPON_AMMO_1, 0 )

		cockpit.s.offhandHud[offhandIndex].bar.SetBarProgressRemap( 0.0, 1.0, 1.0, 0.0 )
	}
	else
	{
		cockpit.s.offhandHud[offhandIndex].showBar = true

		//Hack - Need a new Progress source that checks against Burst Fire Delay or need to make WEAPON_READY_TO_FIRE_FRACTION take that into account.
		local weaponClassname = weapon.GetClassname()
		if ( weaponClassname == "mp_titanweapon_homing_rockets" )
		{
			cockpit.s.offhandHud[offhandIndex].bar.SetBarProgressSource( ProgressSource.PROGRESS_SOURCE_SCRIPTED )
			cockpit.s.offhandHud[offhandIndex].bar.SetBarProgressRemap( 0.0, 1.0, 0.0, 1.0 )
			local nextAttackAllowedTime = weapon.GetNextAttackAllowedTime()
			if( nextAttackAllowedTime > 0 )
			{
				local totalTime = weapon.GetWeaponModSetting( "burst_fire_delay" )
				local remainingTime = weapon.GetNextAttackAllowedTime() - Time()
				local currentTime = totalTime - remainingTime
				cockpit.s.offhandHud[offhandIndex].bar.SetBarProgressAndRate( GraphCapped( currentTime, 0, totalTime, 0, 1.0 ), 1 / totalTime  )
			}
			else
			{
				cockpit.s.offhandHud[offhandIndex].bar.SetBarProgress( 1.0 )
			}
		}
		else
		{
			if( !( "nextChargeTime" in weapon.s ) )
			{
				cockpit.s.offhandHud[offhandIndex].bar.SetBarProgressSource( fracDraw )
				cockpit.s.offhandHud[offhandIndex].bar.SetBarProgressSourceEntity( weapon )
				cockpit.s.offhandHud[offhandIndex].bar.SetBarProgressRemap( 0.0, 1.0, 1.0, 0.0 )
			}
		}

		cockpit.s.offhandHud[offhandIndex].bar.Show()
		cockpit.s.offhandHud[offhandIndex].count.Hide()
	}
}

function GetOffhandProgressSource( weapon )
{
	switch ( weapon.GetWeaponInfoFileKeyField( "fire_mode" ) )
	{
		case "offhand_hybrid":
		case "offhand":
			local chargeTime = weapon.GetWeaponModSetting( "charge_time" )
			if ( chargeTime )
				return ProgressSource.PROGRESS_SOURCE_WEAPON_CHARGE_FRACTION
			break
		case "offhand_instant":
			local chargeTime = weapon.GetWeaponModSetting( "charge_time" )
			if ( chargeTime )
				return ProgressSource.PROGRESS_SOURCE_WEAPON_CHARGE_FRACTION
			else
				return ProgressSource.PROGRESS_SOURCE_WEAPON_READY_TO_FIRE_FRACTION
			break
		default:
			return ProgressSource.PROGRESS_SOURCE_WEAPON_READY_TO_FIRE_FRACTION
			break
	}
}


function MainHud_InitWeapons( cockpit, player )
{
	local panel = cockpit.s.mainVGUI.GetPanel()

	// elements group that can be hidden while in kill replay
	local vgui = cockpit.GetMainVGUI()
	cockpit.s.weaponsGroup <- HudElementGroup( "weapons" )

	cockpit.s.weaponName 		<- HudElement( "weaponLabel", panel )
	cockpit.s.weaponAmmoCount 	<- HudElement( "weaponAmmoCount", panel )
	cockpit.s.weaponAmmoBar 	<- HudElement( "weaponAmmoBar", panel )
	cockpit.s.weaponMagsLabel	<- HudElement( "weaponMagLabel", panel )
	cockpit.s.chargeAmmoBar 	<- HudElement( "chargeAmmoBar", panel )
	cockpit.s.chargeAmmoBar.Hide()
	cockpit.s.chargeAmmoBar.SetBarProgressSource( ProgressSource.PROGRESS_SOURCE_WEAPON_CHARGE_FRACTION )
	player.s.arcChargeBar 	<- HudElement( "ArcCannonChargeBar" )
	player.s.arcChargeBar.Hide()
	player.s.arcChargeBar.SetBarProgressSource( ProgressSource.PROGRESS_SOURCE_WEAPON_CHARGE_FRACTION )

	cockpit.s.weaponMags		<- {}
	cockpit.s.weaponMags[0]		<- HudElement( "weaponAmmoMag", panel )

	cockpit.s.weaponsGroup.AddElement( cockpit.s.weaponName )
	cockpit.s.weaponsGroup.AddElement( cockpit.s.weaponAmmoCount )
	cockpit.s.weaponsGroup.AddElement( cockpit.s.weaponAmmoBar )
	cockpit.s.weaponsGroup.AddElement( cockpit.s.weaponMagsLabel )
	cockpit.s.weaponsGroup.AddElement( cockpit.s.chargeAmmoBar )
	cockpit.s.weaponsGroup.AddElement( player.s.arcChargeBar )
	cockpit.s.weaponsGroup.AddElement( cockpit.s.weaponMags[0] )

	cockpit.s.activeTraps			<- {}
	cockpit.s.activeTraps[0]		<- HudElement( "activeTrap0", panel )
	cockpit.s.activeTraps[1]		<- HudElement( "activeTrap1", panel )
	cockpit.s.activeTraps[2]		<- HudElement( "activeTrap2", panel )
	cockpit.s.activeTraps[3]		<- HudElement( "activeTrap3", panel )
	cockpit.s.activeTraps[4]		<- HudElement( "activeTrap4", panel )

	foreach ( trap in cockpit.s.activeTraps )
	{
		trap.Hide()
		cockpit.s.weaponsGroup.AddElement( trap )
	}

	cockpit.s.burnCardIcon				<- HudElement( "inGameBurnCardIcon", panel )
	cockpit.s.burnCardIcon.SetColor( BURN_CARD_WEAPON_HUD_COLOR[0], BURN_CARD_WEAPON_HUD_COLOR[1], BURN_CARD_WEAPON_HUD_COLOR[2] )
	cockpit.s.burnCardIconShadow		<- HudElement( "inGameBurnCardIconShadow", panel )
	cockpit.s.burnCardTitle				<- HudElement( "inGameBurnCard_label", panel )
	cockpit.s.burnCardTitle.SetColor( BURN_CARD_WEAPON_HUD_COLOR[0], BURN_CARD_WEAPON_HUD_COLOR[1], BURN_CARD_WEAPON_HUD_COLOR[2] )

	cockpit.s.burnCard2Icon				<- HudElement( "inGameBurnCard2Icon", panel )
	cockpit.s.burnCard2Icon.SetColor( BURN_CARD_WEAPON_HUD_COLOR[0], BURN_CARD_WEAPON_HUD_COLOR[1], BURN_CARD_WEAPON_HUD_COLOR[2] )
	cockpit.s.burnCard2IconShadow		<- HudElement( "inGameBurnCardIcon2Shadow", panel )
	cockpit.s.burnCard2Title			<- HudElement( "inGameBurnCard2_label", panel )
	cockpit.s.burnCard2Title.SetColor( BURN_CARD_WEAPON_HUD_COLOR[0], BURN_CARD_WEAPON_HUD_COLOR[1], BURN_CARD_WEAPON_HUD_COLOR[2] )

	cockpit.s.weaponsGroup.AddElement( cockpit.s.burnCardIcon )
	cockpit.s.weaponsGroup.AddElement( cockpit.s.burnCardIconShadow )
	cockpit.s.weaponsGroup.AddElement( cockpit.s.burnCardTitle )

	cockpit.s.weaponsGroup.AddElement( cockpit.s.burnCard2Icon )
	cockpit.s.weaponsGroup.AddElement( cockpit.s.burnCard2IconShadow )
	cockpit.s.weaponsGroup.AddElement( cockpit.s.burnCard2Title )

	local cardRef = GetPlayerActiveBurnCard( player )
	if ( cardRef != null )
	{
		local icon = GetBurnCardHudIcon( cardRef )
		local title = GetBurnCardTitle( cardRef )
		cockpit.s.burnCardIcon.SetImage( icon )
		cockpit.s.burnCardIcon.Show()
		cockpit.s.burnCardIconShadow.SetImage( icon )
		cockpit.s.burnCardIconShadow.Show()

		cockpit.s.burnCardTitle.SetText( title )
		cockpit.s.burnCardTitle.Show()
	}

	cockpit.s.weaponName.SetAutoText( "#HudAutoText_ActiveWeaponName", HATT_ACTIVE_WEAPON_SHORT_NAME, 0 )
	cockpit.s.weaponAmmoCount.SetAutoText( "", HATT_ACTIVE_WEAPON_CLIP_AMMO, 0 )
	cockpit.s.weaponMagsLabel.SetAutoText( "", HATT_ACTIVE_WEAPON_MAGAZINE_COUNT, 0 )
	cockpit.s.weaponAmmoBar.SetBarProgressSource( ProgressSource.PROGRESS_SOURCE_WEAPON_CLIP_AMMO_FRACTION )

	cockpit.s.offhandHud <- {}

	cockpit.s.offhandHud[OFFHAND_LEFT] <- {}
	cockpit.s.offhandHud[OFFHAND_LEFT].icon 	<- HudElement( "Offhand" + OFFHAND_LEFT + "Icon", panel )
	cockpit.s.offhandHud[OFFHAND_LEFT].alert 	<- HudElement( "Offhand" + OFFHAND_LEFT + "Alert", panel )
	cockpit.s.offhandHud[OFFHAND_LEFT].hint 	<- HudElement( "Offhand" + OFFHAND_LEFT + "Hint", panel )
	cockpit.s.offhandHud[OFFHAND_LEFT].hint.EnableKeyBindingIcons()
	cockpit.s.offhandHud[OFFHAND_LEFT].bar 		<- HudElement( "Offhand" + OFFHAND_LEFT + "Bar", panel )
	cockpit.s.offhandHud[OFFHAND_LEFT].bar.SetBarProgress( 1.0 ) //Start off as full instead of empty so we don't play weapon ready sound by mistake
	UpdateAmmoChargesBarSegments( player.GetOffhandWeapon( OFFHAND_LEFT ), cockpit.s.offhandHud[OFFHAND_LEFT].bar, player )
	cockpit.s.offhandHud[OFFHAND_LEFT].count 	<- HudElement( "Offhand" + OFFHAND_LEFT + "Count", panel )
	cockpit.s.offhandHud[OFFHAND_LEFT].bg 		<- HudElement( "Offhand" + OFFHAND_LEFT + "BG", panel )
	cockpit.s.offhandHud[OFFHAND_LEFT].name 	<- null
	cockpit.s.offhandHud[OFFHAND_LEFT].showBar <- false
	cockpit.s.offhandHud[OFFHAND_LEFT].hasBurnWeapon <- false


	cockpit.s.offhandHud[OFFHAND_RIGHT] <- {}
	cockpit.s.offhandHud[OFFHAND_RIGHT].icon 	<- HudElement( "Offhand" + OFFHAND_RIGHT + "Icon", panel )
	cockpit.s.offhandHud[OFFHAND_RIGHT].alert 	<- HudElement( "Offhand" + OFFHAND_RIGHT + "Alert", panel )
	cockpit.s.offhandHud[OFFHAND_RIGHT].hint 	<- HudElement( "Offhand" + OFFHAND_RIGHT + "Hint", panel )
	cockpit.s.offhandHud[OFFHAND_RIGHT].hint.EnableKeyBindingIcons()
	cockpit.s.offhandHud[OFFHAND_RIGHT].hint.s.lastPulseTime <- Time()
	cockpit.s.offhandHud[OFFHAND_RIGHT].bar 	<- HudElement( "Offhand" + OFFHAND_RIGHT + "Bar", panel )
	cockpit.s.offhandHud[OFFHAND_RIGHT].bar.SetBarProgress( 1.0 )  //Start off as full instead of empty so we don't play weapon ready sound by mistake
	UpdateAmmoChargesBarSegments( player.GetOffhandWeapon( OFFHAND_RIGHT ), cockpit.s.offhandHud[OFFHAND_RIGHT].bar, player )
	cockpit.s.offhandHud[OFFHAND_RIGHT].count 	<- HudElement( "Offhand" + OFFHAND_RIGHT + "Count", panel )
	cockpit.s.offhandHud[OFFHAND_RIGHT].bg 		<- HudElement( "Offhand" + OFFHAND_RIGHT + "BG", panel )
	cockpit.s.offhandHud[OFFHAND_RIGHT].name 	<- null
	cockpit.s.offhandHud[OFFHAND_RIGHT].showBar <- false
	cockpit.s.offhandHud[OFFHAND_RIGHT].hasBurnWeapon <- false


	// training helpers
	cockpit.s.offhandHud[ OFFHAND_LEFT ].outline <- HudElement( "Offhand1_Tutorial_Outline", panel )
	cockpit.s.offhandHud[ OFFHAND_RIGHT ].outline <- HudElement( "Offhand0_Tutorial_Outline", panel )

	foreach( array in cockpit.s.offhandHud )
	{
		foreach( elem in array )
		{
			if ( elem != null && type( elem ) != "bool" )
				cockpit.s.weaponsGroup.AddElement( elem )
		}
	}

	if ( IsWatchingKillReplay() )
		cockpit.s.weaponsGroup.Hide()

	//if ( player.IsTitan() )
		thread AlertThink( cockpit, player )

	thread WeaponsThink( cockpit, player )

	MainHud_UpdateWeapons( cockpit, player )
}

function UpdateAmmoChargesBarSegments( offhandWeapon, bar, player )
{
	local width = bar.GetWidth()
	//We need a moddable code weapon setting or OnWeaponActivate working for Offhand Weapons to write a more generic test
	if ( offhandWeapon && offhandWeapon.HasModDefined( "burn_mod_titan_bubble_shield" ) && offhandWeapon.HasMod( "burn_mod_titan_bubble_shield" ) )
	{
			local ammo = player.GetWeaponAmmoLoaded( offhandWeapon )
			local segments = 2
			local gap = 6
			local segmentWidth = (width - (( segments - 1) * gap)) / segments
			bar.SetBarSegmentInfo( gap, segmentWidth )
			if ( "nextChargeTime" in offhandWeapon.s )
			{
				local rechargeTime = SHIELD_WALL_CHARGE_TIME
				local remainingTime = offhandWeapon.s.nextChargeTime - Time()
				local currentTime = rechargeTime - remainingTime
				bar.SetBarProgressSource( ProgressSource.PROGRESS_SOURCE_SCRIPTED )
				bar.SetBarProgressRemap( 0.0, 1.0, 0.0, 1.0 )
				bar.SetBarProgressAndRate( GraphCapped( currentTime + rechargeTime * ammo, 0, rechargeTime * SHIELD_WALL_MAX_CHARGES, 0, 1.0 ), 1 / ( rechargeTime * SHIELD_WALL_MAX_CHARGES )  )
			}
	}
	else
	{
		bar.SetBarSegmentInfo( 0, width )
	}
}

Globalize( UpdateAmmoChargesBarSegments )


function MainHud_UpdateWeapons( cockpit, player )
{
	if ( player != GetLocalViewPlayer() || IsWatchingKillReplay() )
		return

	UpdateOffhandHUD( cockpit, player, OFFHAND_LEFT )
	UpdateOffhandHUD( cockpit, player, OFFHAND_RIGHT )

	if ( player.IsTitan() )
		return

	local weapon = player.GetOrdnanceWeapon()

	if ( weapon && weapon.GetWeaponInfoFileKeyField( "hud_icon" ) )
	{
		SetDpadIcon( player, BUTTON_DPAD_LEFT, weapon.GetWeaponInfoFileKeyField( "hud_icon" ) )
		SetDpadTitle( player, BUTTON_DPAD_LEFT, "" )
		SetDpadDesc( player, BUTTON_DPAD_LEFT, weapon.GetWeaponPrintName() )

		ShowDpadIcon( player, BUTTON_DPAD_LEFT )
	}
	else
	{
		HideDpadIcon( player, BUTTON_DPAD_LEFT )
	}
}

function ServerCallback_UpdateBurnCardTitle()
{
	local player = GetLocalViewPlayer()
	local cockpit = player.GetCockpit()
	if ( IsValid( cockpit ) )
	{
		local cardRef = GetPlayerActiveBurnCard( player )
		if ( cardRef != null )
		{
			local icon = GetBurnCardHudIcon( cardRef )
			local title = GetBurnCardTitle( cardRef )
			cockpit.s.burnCardIcon.SetImage( icon )
			cockpit.s.burnCardIcon.Show()
			cockpit.s.burnCardIconShadow.SetImage( icon )
			cockpit.s.burnCardIconShadow.Show()

			cockpit.s.burnCardTitle.SetText( title )
			cockpit.s.burnCardTitle.Show()
		}
	}
}

function RedrawActiveTraps( player, cockpit )
{
	Assert( player == GetLocalViewPlayer() )
	Assert( cockpit == player.GetCockpit() )
	Assert( IsValid( player ) )
	Assert( IsValid( cockpit ) )

	foreach ( trap in cockpit.s.activeTraps )
	{
		trap.Hide()
	}

	local count = 0
	foreach ( trap, weaponName in clone player.s.activeTraps )
	{
		if ( !IsValid( trap ) )
		{
			delete player.s.activeTraps[ trap ]
			continue
		}

		local image
		switch ( weaponName )
		{
			case "mp_weapon_satchel":
				image = "hud/dpad_satchel"
				break
			case "mp_weapon_proximity_mine":
				image = "hud/dpad_proximity_mine"
				break
		}

		Assert( image != null )
		cockpit.s.activeTraps[count].SetImage( image )

		cockpit.s.activeTraps[count].Show()
		count++
		if ( count >= MAX_ACTIVE_TRAPS_DISPLAYED )
			break
	}
}


function UpdateOffhandHUD( cockpit, player, index )
{
	local offhandWeapon = player.GetOffhandWeapon( index )
	if ( !IsValid ( offhandWeapon ) )
	{
		cockpit.s.offhandHud[index].icon.Hide()
		cockpit.s.offhandHud[index].hint.Hide()
		cockpit.s.offhandHud[index].bg.Hide()
		cockpit.s.offhandHud[index].bar.Hide()
		return
	}

	cockpit.s.offhandHud[index].hasBurnWeapon = false
	local weaponMods = offhandWeapon.GetMods()
	foreach ( mod in weaponMods )
	{
		if ( mod in level.burnCardWeaponModList )
		{
			cockpit.s.offhandHud[index].hasBurnWeapon = true
			break
		}
	}


	if ( cockpit.s.offhandHud[index].hasBurnWeapon )
		cockpit.s.offhandHud[index].bar.SetColor( BURN_CARD_WEAPON_HUD_COLOR[0], BURN_CARD_WEAPON_HUD_COLOR[1], BURN_CARD_WEAPON_HUD_COLOR[2], BURN_CARD_WEAPON_HUD_COLOR[3] )
	else
		cockpit.s.offhandHud[index].bar.ReturnToBaseColor()

	cockpit.s.offhandHud[index].icon.Show()
	cockpit.s.offhandHud[index].hint.Show()
	cockpit.s.offhandHud[index].bg.Show()
	if ( cockpit.s.offhandHud[index].showBar )
		cockpit.s.offhandHud[index].bar.Show()

	local classname = offhandWeapon.GetClassname()
	if ( classname != cockpit.s.offhandHud[index].name )
	{
		cockpit.s.offhandHud[index].name = offhandWeapon.GetClassname()
		player.Signal( "UpdateWeapons" )
	}

	//if ( "useHudIconCharges" in offhandWeapon.s && offhandWeapon.s.useHudIconCharges )
	//{
	//	local ammo = player.GetWeaponAmmoLoaded( offhandWeapon )
	//	cockpit.s.offhandHud[index].icon.SetImage( "HUD/dpad_bubble_shield_charge_" + ammo )
	//}

	if ( index != OFFHAND_RIGHT )
		return

	RedrawActiveTraps( player, cockpit )

	//TODO: Clean this up when this when throwing a projectile prevents you from swapping.
	if ( classname == "mp_weapon_satchel" )
	{
		if ( player.GetWeaponAmmoLoaded( offhandWeapon ) == 0 && GetActiveTrapsOfClassname( player, "mp_weapon_satchel" ).len() > 0 )
		{
			cockpit.s.offhandHud[OFFHAND_RIGHT].icon.SetImage( "HUD/dpad_satchel_activate" )
			cockpit.s.offhandHud[OFFHAND_RIGHT].hint.SetText( "#USE_KEY_BINDING" )
			local currentTime = Time()
			local timeSinceLastPulse = currentTime - cockpit.s.offhandHud[OFFHAND_RIGHT].hint.s.lastPulseTime
			if ( timeSinceLastPulse > 1.5 )
			{
				cockpit.s.offhandHud[OFFHAND_RIGHT].hint.SetPulsate( 0.1, 0.95, 12 )
				cockpit.s.offhandHud[OFFHAND_RIGHT].hint.s.lastPulseTime = currentTime
			}
			else if ( timeSinceLastPulse > 0.75 )
			{
				cockpit.s.offhandHud[OFFHAND_RIGHT].hint.ClearPulsate()
			}
		}
		else
		{
			cockpit.s.offhandHud[OFFHAND_RIGHT].hint.ClearPulsate()
			cockpit.s.offhandHud[OFFHAND_RIGHT].icon.SetImage( "HUD/dpad_satchel" )
			cockpit.s.offhandHud[OFFHAND_RIGHT].hint.SetText( "#OFFHAND1_KEY_BINDING" )
		}
	}
	else
	{
		cockpit.s.offhandHud[OFFHAND_RIGHT].hint.ClearPulsate()
		cockpit.s.offhandHud[OFFHAND_RIGHT].hint.SetText( "#OFFHAND1_KEY_BINDING" )
	}
}

function GetActiveTrapsOfClassname( player, classname )
{
	// .len() > 0 )"activeSatchelCount" in player.s && player.s.activeSatchelCount > 0)
	local array = []
	foreach ( trap, name in clone player.s.activeTraps )
	{
		if ( !IsValid( trap ) )
		{
			delete player.s.activeTraps[ trap ]
			continue
		}

		if ( name == classname )
			array.append( trap )
	}
	return array
}

function MainHud_InitAnnouncement( vgui, player )
{
	local panel = vgui.GetPanel()

	vgui.s.announcementAnchor <- HudElement( "AnnouncementAnchor", panel )
	vgui.s.announcementText <- HudElement( "Announcement", panel )
	vgui.s.announcementTextBG <- HudElement( "AnnouncementBG", panel )
	vgui.s.announcementSubText <- HudElement( "AnnouncementSubText", panel )
	vgui.s.announcementSubText.EnableKeyBindingIcons()
	vgui.s.announcementSubText2 <- HudElement( "AnnouncementSubText2", panel )
	vgui.s.AnnouncementSubText2Large <- HudElement( "AnnouncementSubText2Large", panel )
	vgui.s.AnnouncementSubText2LargeBG <- HudElement( "AnnouncementSubText2LargeBG", panel )
	vgui.s.announcementScan <- HudElement( "AnnouncementScan", panel )
	vgui.s.announcementIcon <- HudElement( "AnnouncementIcon", panel )
	vgui.s.announcementIconLabel <- HudElement( "AnnouncementIconLabel", panel )

	vgui.s.announcementLeftIcon <- HudElement( "AnnouncementLeftIcon", panel )
	vgui.s.announcementRightIcon <- HudElement( "AnnouncementRightIcon", panel )
	vgui.s.announcementLeftText <- HudElement( "AnnouncementLeftText", panel )
	vgui.s.announcementRightText <- HudElement( "AnnouncementRightText", panel )

	vgui.s.eventNotification <- HudElement( "EventNotification", panel )
	vgui.s.lastEventNotificationText <- ""
}


function MainHud_InitMinimap( vgui, player )
{
	local panel = vgui.GetPanel()

	vgui.s.minimapGroup <- HudElementGroup( "minimap" )
	vgui.s.minimapGroup.CreateElement( "Minimap", panel )
	vgui.s.minimapGroup.CreateElement( "MinimapBG", panel )
	vgui.s.minimapGroup.CreateElement( "MinimapFG", panel )
	vgui.s.minimapGroup.CreateElement( "MinimapCompass", panel )

	local overlay = vgui.s.minimapGroup.CreateElement( "MinimapOverlay", panel )
	vgui.s.minimapOverlay <- overlay

	if ( IsWatchingKillReplay() || level.showingFullscreenMap )
		vgui.s.minimapGroup.Hide()

	if ( Riff_MinimapState() != eMinimapState.Default )
	{
		if ( Riff_MinimapState() == eMinimapState.Hidden )
			vgui.s.minimapGroup.Hide()
	}

	vgui.s.minimapOverlay.Hide()
}

function MainHUD_InitLockedOntoWarning( vgui, player )
{
	local panel = vgui.GetPanel()

	vgui.s.LockonDetector_CenterBox <- HudElement( "LockonDetector_CenterBox", panel )
	vgui.s.LockonDetector_CenterBox_Label <- HudElement( "LockonDetector_CenterBox_Label", panel )
	vgui.s.LockonDetector_ArrowForward <- HudElement( "LockonDetector_ArrowForward", panel )
	vgui.s.LockonDetector_ArrowBack <- HudElement( "LockonDetector_ArrowBack", panel )
	vgui.s.LockonDetector_ArrowLeft <- HudElement( "LockonDetector_ArrowLeft", panel )
	vgui.s.LockonDetector_ArrowRight <- HudElement( "LockonDetector_ArrowRight", panel )
}


function UpdateMinimapVisibility()
{
	local player = GetLocalClientPlayer()

	local cockpit = player.GetCockpit()
	if ( !cockpit )
		return

	local mainVGUI = cockpit.GetMainVGUI()
	if ( !mainVGUI )
		return

	if ( IsWatchingKillReplay() )
	{
		mainVGUI.s.minimapGroup.Hide()
		return
	}

	if ( Riff_MinimapState() != eMinimapState.Default )
	{
		if ( Riff_MinimapState() == eMinimapState.Hidden )
		{
			mainVGUI.s.minimapGroup.Hide()
			return
		}
	}

	mainVGUI.s.minimapGroup.Show()
	mainVGUI.s.minimapOverlay.Hide()
}


function MainHud_InitScoreBars( vgui, player, scoreGroup )
{
	local scoreboardProgressBars = {}
	vgui.s.scoreboardProgressBars <- scoreboardProgressBars

	vgui.s.scoreboardTeam <- player.GetTeam() // Store initial team
	local panel = vgui.GetPanel()

	scoreboardProgressBars.GameInfoBG 			<- scoreGroup.CreateElement( "GameInfoBG", panel )
	scoreboardProgressBars.GameInfoFG 			<- scoreGroup.CreateElement( "GameInfoFG", panel )
	scoreboardProgressBars.ScoresBG 			<- scoreGroup.CreateElement( "ScoresBG", panel )
	scoreboardProgressBars.ScoresFG 			<- scoreGroup.CreateElement( "ScoresFG", panel )
	scoreboardProgressBars.GameModeLabel		<- scoreGroup.CreateElement( "GameModeLabel", panel )


	local gameMode = GameRules.GetGameMode()
	scoreboardProgressBars.GameModeLabel.SetText( GAMETYPE_TEXT[gameMode] )

	local friendlyTeam = player.GetTeam()
	local enemyTeam = friendlyTeam == TEAM_IMC ? TEAM_MILITIA : TEAM_IMC

	if ( IsRoundBased() )
	{
		level.scoreLimit[TEAM_IMC] <- IsMultiplayer() ? GetRoundScoreLimit_FromPlaylist() : 0
		level.scoreLimit[TEAM_MILITIA] <- IsMultiplayer() ? GetRoundScoreLimit_FromPlaylist() : 0
	}
	else
	{
		level.scoreLimit[TEAM_IMC] <- IsMultiplayer() ? GetScoreLimit_FromPlaylist() : 0
		level.scoreLimit[TEAM_MILITIA] <- IsMultiplayer() ? GetScoreLimit_FromPlaylist() : 0
	}

	scoreboardProgressBars.ScoresFriendly 		<- scoreGroup.CreateElement( "ScoresFriendly", panel )
	scoreboardProgressBars.ScoresFriendly.SetBarProgressSourceEntity( player )
	scoreboardProgressBars.ScoresFriendly.SetBarProgressSource( ProgressSource.PROGRESS_SOURCE_FRIENDLY_TEAM_SCORE )
	scoreboardProgressBars.ScoresFriendly.SetBarProgressRemap( 0, level.scoreLimit[friendlyTeam], 0.011, 0.96 )
	scoreboardProgressBars.Friendly_Number 	<- scoreGroup.CreateElement( "ScoresLabelFriendly", panel )
	scoreboardProgressBars.Friendly_Number.SetAutoText( "", HATT_FRIENDLY_TEAM_SCORE, 0 )
	scoreboardProgressBars.Friendly_Team 	<- scoreGroup.CreateElement( "ScoresTeamLabelFriendly", panel )
	scoreboardProgressBars.Friendly_Team.SetAutoText( "", HATT_FRIENDLY_TEAM_NAME, 0 )

	scoreboardProgressBars.ScoresEnemy 		<- scoreGroup.CreateElement( "ScoresEnemy", panel )
	scoreboardProgressBars.ScoresEnemy.SetBarProgressSourceEntity( player )
	scoreboardProgressBars.ScoresEnemy.SetBarProgressSource( ProgressSource.PROGRESS_SOURCE_ENEMY_TEAM_SCORE )
	scoreboardProgressBars.ScoresEnemy.SetBarProgressRemap( 0, level.scoreLimit[enemyTeam], 0.011, 0.96 )
	scoreboardProgressBars.Enemy_Number 		<- scoreGroup.CreateElement( "ScoresLabelEnemy", panel )
	scoreboardProgressBars.Enemy_Number.SetAutoText( "", HATT_ENEMY_TEAM_SCORE, 0 )
	scoreboardProgressBars.Enemy_Team 		<- scoreGroup.CreateElement( "ScoresTeamLabelEnemy", panel )
	scoreboardProgressBars.Enemy_Team.SetAutoText( "", HATT_ENEMY_TEAM_NAME, 0 )

	scoreboardProgressBars.GameInfo_Label 	<- scoreGroup.CreateElement( "GameInfoLabel", panel )
	scoreboardProgressBars.GameInfo_Icon 	<- scoreGroup.CreateElement( "GameInfoTeamIcon", panel )

	if ( friendlyTeam == TEAM_IMC )
		scoreboardProgressBars.GameInfo_Icon.SetImage( TEAM_ICON_IMC )
	else
		scoreboardProgressBars.GameInfo_Icon.SetImage( TEAM_ICON_MILITIA )

	//scoreboardProgressBars.ScoreObjectiveText 	<- scoreGroup.CreateElement( "ScoreObjectiveText", panel )
	//scoreboardProgressBars.ScoreObjectiveSubText <- scoreGroup.CreateElement( "ScoreObjectiveSubText", panel )

	//scoreboardProgressBars.ScoreObjectiveText.Hide()
	//scoreboardProgressBars.ScoreObjectiveSubText.Hide()

	local gameMode = GameRules.GetGameMode()
	switch ( gameMode )
	{
		case CAPTURE_THE_FLAG:
		case CAPTURE_THE_FLAG_PRO:
			vgui.s.friendlyFlag <- scoreGroup.CreateElement( "FriendlyFlag", panel )
			vgui.s.enemyFlag <- scoreGroup.CreateElement( "EnemyFlag", panel )

			vgui.s.friendlyFlagLabel <- scoreGroup.CreateElement( "FriendlyFlagLabel", panel )
			vgui.s.enemyFlagLabel <- scoreGroup.CreateElement( "EnemyFlagLabel", panel )

			thread CaptureTheFlagThink( vgui, player )
			break

		case ATTRITION:
			scoreboardProgressBars.ScorePopupLabel 		<- scoreGroup.CreateElement( "ScorePopupLabel", panel )
			thread AttritionThink( vgui )
			break

		case EXFILTRATION:
			thread ExfiltrationThink( vgui, player )
			break

		case MARKED_FOR_DEATH:
		case MARKED_FOR_DEATH_PRO:
		case TITAN_MFD:
		case TITAN_MFD_PRO:
			thread MarkedForDeathHudThink( vgui, player, scoreGroup )
			break
	}

	thread TitanEliminationThink( vgui, player )

	thread RoundScoreThink( vgui, player )

	vgui.s.scoreboardProgressGroup <- scoreGroup

	scoreboardProgressBars.GameInfoBG.Show()
	scoreboardProgressBars.ScoresBG.Show()
	scoreboardProgressBars.Friendly_Number.Show()
	scoreboardProgressBars.Enemy_Number.Show()
	scoreboardProgressBars.GameInfo_Label.Show()

	scoreboardProgressBars.FriendlyTitanCount <- scoreGroup.CreateElement( "FriendlyTitanCount", panel )
	scoreboardProgressBars.EnemyTitanCount <- scoreGroup.CreateElement( "EnemyTitanCount", panel )
	scoreboardProgressBars.FriendlyTitanReadyCount <- scoreGroup.CreateElement( "FriendlyTitanReadyCount", panel )
	scoreboardProgressBars.FriendlyBurnTitanCount <- scoreGroup.CreateElement( "FriendlyBurnTitanCount", panel )
	scoreboardProgressBars.EnemyBurnTitanCount <- scoreGroup.CreateElement( "EnemyBurnTitanCount", panel )

	local endTime = GetScoreEndTime()
	if ( endTime > 0 )
		scoreboardProgressBars.GameInfo_Label.SetAutoText( "", HATT_COUNTDOWN_TIME, endTime )
	else
		scoreboardProgressBars.GameInfo_Label.SetText( "#HUD_BLANK_TIME" )

	local scoreboardArrays = {}
	vgui.s.scoreboardArrays <- scoreboardArrays

	if ( GAMETYPE == COOPERATIVE )//coop only uses player status for friendly, and regular titan count for enemy
	{
		//ToDo: Eventually turn it on for normal Titan count too. Need to make sure "Titan ready but not called in yet" icon doesn't get hidden by this element
		scoreboardProgressBars.Player_Status_BG <- scoreGroup.CreateElement( "Player_Status_BG", panel )
		scoreboardProgressBars.Player_Status_BG.Show()

		CreatePlayerStatusElementsFriendly( scoreboardArrays, scoreGroup, panel )

		thread ScoreBarsCoopPlayerStatusThink( vgui, player, scoreboardArrays.FriendlyPlayerStatusCount, scoreboardArrays.FriendlyPlayerStatusBurnCardBG, scoreboardProgressBars.EnemyTitanCount, scoreboardProgressBars.EnemyBurnTitanCount )
	}
	else if ( ShouldUsePlayerStatusCount() ) //Can't just do PilotEliminationBased check here because it isn't set when first connecting
	{
		//ToDo: Eventually turn it on for normal Titan count too. Need to make sure "Titan ready but not called in yet" icon doesn't get hidden by this element
		scoreboardProgressBars.Player_Status_BG <- scoreGroup.CreateElement( "Player_Status_BG", panel )
		scoreboardProgressBars.Player_Status_BG.Show()

		CreatePlayerStatusElementsFriendly( scoreboardArrays, scoreGroup, panel )
		CreatePlayerStatusElementsEnemy( scoreboardArrays, scoreGroup, panel )

		thread ScoreBarsPlayerStatusThink( vgui, player, scoreboardArrays.FriendlyPlayerStatusCount, scoreboardArrays.EnemyPlayerStatusCount, scoreboardArrays.FriendlyPlayerStatusBurnCardBG,  scoreboardArrays.EnemyPlayerStatusBurnCardBG )
	}
	else
	{
		scoreboardProgressBars.Player_Status_BG <- scoreGroup.CreateElement( "Player_Status_BG", panel )
		scoreboardProgressBars.Player_Status_BG.Show()
		thread ScoreBarsTitanCountThink( vgui, player, scoreboardProgressBars.FriendlyTitanCount, scoreboardProgressBars.FriendlyTitanReadyCount, scoreboardProgressBars.EnemyTitanCount, scoreboardProgressBars.FriendlyBurnTitanCount, scoreboardProgressBars.EnemyBurnTitanCount )
	}

	if ( IsWatchingKillReplay() || !level.showScoreboard )
		vgui.s.scoreboardProgressGroup.Hide()

	UpdatePlayerStatusCounts()

	if ( IsSuddenDeathGameMode() )
		thread SuddenDeathHUDThink( vgui, player )
}

function CreatePlayerStatusElementsFriendly( scoreboardArrays, scoreGroup, panel )
{
	scoreboardArrays.FriendlyPlayerStatusCount <- array( 8 )
	scoreboardArrays.FriendlyPlayerStatusBurnCardBG <- array( 8 )

	for( local i = 0; i < 8; ++i )
	{
		scoreboardArrays.FriendlyPlayerStatusCount[ i ] = scoreGroup.CreateElement( "Friendly_Player_Status_" + i, panel )
		scoreboardArrays.FriendlyPlayerStatusBurnCardBG[ i ] = scoreGroup.CreateElement( "Friendly_Player_Status_" + i + "_Burncard_BG", panel )
	}
}

function CreatePlayerStatusElementsEnemy( scoreboardArrays, scoreGroup, panel )
{
	scoreboardArrays.EnemyPlayerStatusCount <- array( 8 )
	scoreboardArrays.EnemyPlayerStatusBurnCardBG <- array( 8 )

	for( local i = 0; i < 8; ++i )
	{
		scoreboardArrays.EnemyPlayerStatusCount[ i ] = scoreGroup.CreateElement( "Enemy_Player_Status_" + i, panel )
		scoreboardArrays.EnemyPlayerStatusBurnCardBG[ i ] = scoreGroup.CreateElement( "Enemy_Player_Status_" + i + "_Burncard_BG", panel )
	}
}

function ScoreBarsCoopPlayerStatusThink( vgui, player, friendlyPlayerStatusElem, friendlyPlayerStatusBurnCardBGElem, enemyTitanCountElem, enemyTitanCountBurnElem )
{
	local friendlyTeam = player.GetTeam()
	local enemyTeam = friendlyTeam == TEAM_IMC ? TEAM_MILITIA : TEAM_IMC

	vgui.EndSignal( "OnDestroy" )
	player.EndSignal( "OnDestroy" )
	while( true )
	{
		WaitSignal( level.ent, "UpdatePlayerStatusCounts", "UpdateTitanCounts" )
		if ( !IsValid( player ) )
			return;
		// Check for team change before updating counts based on potentially stale team perspective
		if ( player.GetTeam() != vgui.s.scoreboardTeam )
		{
			vgui.s.scoreboardTeam = player.GetTeam()
			UpdateScoreboardTeamProperties( vgui, player )
			// Update local team variables after properties have been reset
			friendlyTeam = player.GetTeam()
			enemyTeam = friendlyTeam == TEAM_IMC ? TEAM_MILITIA : TEAM_IMC
		}

		if ( IsWatchingKillReplay() || !level.showScoreboard ) //Don't update visibility if the scoreboardgroup should be hidden
			continue

		local enemyTitans = GetNPCArrayEx( "npc_titan", enemyTeam, Vector(0,0,0), -1 )
		enemyTitanCountElem.SetBarProgress( enemyTitans.len() / 8.0 )

		UpdatePlayerStatusForTeam( friendlyTeam, friendlyPlayerStatusElem, friendlyPlayerStatusBurnCardBGElem, "../ui/icon_status_titan_friendly", "../ui/icon_status_pilot_friendly", "../ui/icon_status_burncard_friendly", "hud/coop/icon_status_dead" )
	}
}

function SuddenDeathHUDThink( vgui, player )
{
	Signal( player, "SuddenDeathHUDThink" )
	player.EndSignal( "SuddenDeathHUDThink" )
	vgui.EndSignal( "OnDestroy" )

	while ( GetGameState() != eGameState.SuddenDeath )
		WaitSignal( player, "GameStateChanged" )

	EndSignal( player, "GameStateChanged" )

	local scoreElems = vgui.s.scoreboardProgressBars

	OnThreadEnd(
		function() : ( scoreElems, player )
		{
			if ( !IsValid( scoreElems ) )
				return

			scoreElems.GameInfo_Label.SetColor( 255, 255, 255, 255 )

			local restoredGameModeLabelText = GAMETYPE_TEXT[ GameRules.GetGameMode() ]
			scoreElems.GameModeLabel.SetText( restoredGameModeLabelText )

			if ( player == GetLocalClientPlayer() )
			{
				local scoreElemsClient = player.cv.clientHud.s.mainVGUI.s.scoreboardProgressGroup.elements
				scoreElemsClient.GameModeLabel.SetText( restoredGameModeLabelText )
			}
		}
	)

	local gameModeLabelText = ""

	switch ( GAMETYPE )
	{
		case CAPTURE_THE_FLAG:
			gameModeLabelText = "#GAMEMODE_CAPTURE_THE_FLAG_SUDDEN_DEATH"
			break

		case TEAM_DEATHMATCH:
			gameModeLabelText = "#GAMEMODE_PILOT_HUNTER_SUDDEN_DEATH"
			break

		default:
			gameModeLabelText = GAMETYPE_TEXT[ GameRules.GetGameMode() ]
	}

	scoreElems.GameModeLabel.SetText( gameModeLabelText )

	if ( player == GetLocalClientPlayer() )
	{
		local scoreElemsClient = player.cv.clientHud.s.mainVGUI.s.scoreboardProgressGroup.elements
		scoreElemsClient.GameModeLabel.SetText( gameModeLabelText )
	}

	local startTime = Time()
	local pulseFrac = 0.0

	while ( true )
	{
		pulseFrac = Graph( GetPulseFrac( 1.0, startTime ), 0.0, 1.0, 0.05, 1.0 )
		scoreElems.GameInfo_Label.SetColor( 255, 255, 255, 255 * pulseFrac )

		wait( 0.0 )
	}
}

function ShouldUsePlayerStatusCount()
{
	switch ( GameRules.GetGameMode() )
	{
		case LAST_TITAN_STANDING:
		case WINGMAN_LAST_TITAN_STANDING:
		case MARKED_FOR_DEATH_PRO:
		case CAPTURE_THE_FLAG_PRO:
		case TITAN_MFD_PRO:
			return true

		default:
			return false
	}
}
Globalize( ShouldUsePlayerStatusCount )


function UpdateScoreboardTeamProperties( vgui, player )
{
	local scoreboardProgressBars = vgui.s.scoreboardProgressBars
	local friendlyTeam = player.GetTeam()
	local enemyTeam = friendlyTeam == TEAM_IMC ? TEAM_MILITIA : TEAM_IMC

	// Update score limits based on current round/game state
	local scoreLimitFriendly, scoreLimitEnemy
	if ( IsRoundBased() )
	{
		scoreLimitFriendly = IsMultiplayer() ? GetRoundScoreLimit_FromPlaylist() : 0
		scoreLimitEnemy = IsMultiplayer() ? GetRoundScoreLimit_FromPlaylist() : 0
	}
	else
	{
		scoreLimitFriendly = IsMultiplayer() ? GetScoreLimit_FromPlaylist() : 0
		scoreLimitEnemy = IsMultiplayer() ? GetScoreLimit_FromPlaylist() : 0
	}
	// Ensure level.scoreLimit is updated if other parts of the HUD rely on it directly
	level.scoreLimit[friendlyTeam] = scoreLimitFriendly
	level.scoreLimit[enemyTeam] = scoreLimitEnemy

	// Update Friendly Score Bar
	scoreboardProgressBars.ScoresFriendly.SetBarProgressSource( ProgressSource.PROGRESS_SOURCE_FRIENDLY_TEAM_SCORE )
	scoreboardProgressBars.ScoresFriendly.SetBarProgressRemap( 0, scoreLimitFriendly, 0.011, 0.96 )
	scoreboardProgressBars.Friendly_Number.SetAutoText( "", HATT_FRIENDLY_TEAM_SCORE, 0 )
	scoreboardProgressBars.Friendly_Team.SetAutoText( "", HATT_FRIENDLY_TEAM_NAME, 0 )

	// Update Enemy Score Bar
	scoreboardProgressBars.ScoresEnemy.SetBarProgressSource( ProgressSource.PROGRESS_SOURCE_ENEMY_TEAM_SCORE )
	scoreboardProgressBars.ScoresEnemy.SetBarProgressRemap( 0, scoreLimitEnemy, 0.011, 0.96 )
	scoreboardProgressBars.Enemy_Number.SetAutoText( "", HATT_ENEMY_TEAM_SCORE, 0 )
	scoreboardProgressBars.Enemy_Team.SetAutoText( "", HATT_ENEMY_TEAM_NAME, 0 )

	// Update Team Icon
	if ( friendlyTeam == TEAM_IMC )
		scoreboardProgressBars.GameInfo_Icon.SetImage( TEAM_ICON_IMC )
	else
		scoreboardProgressBars.GameInfo_Icon.SetImage( TEAM_ICON_MILITIA )

	// Re-trigger player status/titan count updates to use new team context immediately
	// This ensures the counts/icons associated with the bars also update team perspective
	UpdatePlayerStatusCounts()
}


function GetScoreEndTime()
{
	local endTime

	if ( IsRoundBased() )
		endTime = level.nv.roundEndTime
	else
		endTime = level.nv.gameEndTime

	return endTime
}


function MainHud_InitEpilogue( vgui, player )
{
	local panel = vgui.GetPanel()
	local epilogueGroup = HudElementGroup( "epilogue" )

	epilogueGroup.CreateElement( "EpilogueText", panel )
	epilogueGroup.CreateElement( "EpilogueBarShapeLeft", panel )
	epilogueGroup.CreateElement( "EpilogueBarBGShapeLeft", panel )
	epilogueGroup.CreateElement( "EpilogueBarShapeRight", panel )
	epilogueGroup.CreateElement( "EpilogueBarBGShapeRight", panel )

	epilogueGroup.Hide() //Hide it all the time for now. Testing to see if we need the epilogue bar at all

	vgui.s.epilogue <- epilogueGroup
}


function WeaponsThink( cockpit, player )
{
	cockpit.EndSignal( "OnDestroy" )
	player.EndSignal( "OnDestroy" )

	//arcChargeBar is not being cleared with the rest of the HUD elements because it's in a different res file. This is to prevent it from swaying as the Titan moves around.
	OnThreadEnd(
		function() : ( cockpit, player )
		{
			if( IsValid( player ) )
				player.s.arcChargeBar.Hide()
		}
	)

	for ( ;; )
	{
		WaitSignal( player, "UpdateWeapons", "ResetWeapons" )

		if ( IsWatchingKillReplay() )
			continue

		if ( "weapon" in player.s.weaponUpdateData )
		{
			cockpit.s.chargeAmmoBar.SetBarProgressSourceEntity( player.s.weaponUpdateData.weapon )
			cockpit.s.chargeAmmoBar.SetBarProgressRemap( player.s.weaponUpdateData.a, player.s.weaponUpdateData.b, 1.0, 0.0 )
			player.s.arcChargeBar.SetBarProgressSourceEntity( player.s.weaponUpdateData.weapon )
			player.s.arcChargeBar.SetBarProgressRemap( player.s.weaponUpdateData.a, player.s.weaponUpdateData.b, 0.7166, 0.2833 )
			local weaponClassname = player.s.weaponUpdateData.weapon.GetClassname()
			if (  weaponClassname == "mp_titanweapon_arc_cannon" )
				player.s.arcChargeBar.Show()
			else
				player.s.arcChargeBar.Hide()
			cockpit.s.chargeAmmoBar.Show()
			cockpit.s.weaponAmmoBar.Hide()
		}
		else
		{
			player.s.arcChargeBar.Hide()
			cockpit.s.chargeAmmoBar.Hide()
			cockpit.s.weaponAmmoBar.Show()
			if ( player.IsTitan() )
			{
				cockpit.s.weaponMags[0].Hide()
				cockpit.s.weaponMagsLabel.Hide()
			}
			else
			{
				cockpit.s.weaponMags[0].Show()
				cockpit.s.weaponMagsLabel.Show()
			}
			cockpit.s.weaponAmmoCount.Show()
		}

		InitOffhandWeaponHud( cockpit, player, OFFHAND_LEFT )
		InitOffhandWeaponHud( cockpit, player, OFFHAND_RIGHT )
	}
}

function ClientCodeCallback_OnSelectedWeaponChanged( selectedWeapon )
{
	if ( !IsValid( selectedWeapon ) )
		return

	local player = GetLocalViewPlayer()
	if ( !IsValid( player ) )
		return

	local cockpit = player.GetCockpit()
	switch ( selectedWeapon.GetClassname() )
	{
		case "mp_titanweapon_arc_cannon":
			DisplayChargeAmmoBar( selectedWeapon, player, GetArcCannonChargeFraction( selectedWeapon ), 0, cockpit )
			break
		case "mp_weapon_defender":
		case "mp_weapon_mega4": //display charge cannon gauge by kwanyongjung 161026
			DisplayChargeAmmoBar( selectedWeapon, player, 1, 0, cockpit )
			break

		case "mp_titanweapon_vortex_shield":
			DisplayChargeAmmoBar( selectedWeapon, player, 0, 1.0, cockpit )
			break

		case "mp_titanweapon_triple_threat":
			if ( selectedWeapon.HasMod("hydraulic_launcher") )
				DisplayChargeAmmoBar( selectedWeapon, player, 1.0, 0 )
			else
				HideChargeAmmoBar( selectedWeapon, player )
			break

		case "mp_weapon_mega3":
			DisplayChargeAmmoBar( selectedWeapon, player, 1, 0, cockpit )
//			HideWeaponAmmoUI( cockpit )
			break

		default:
			HideChargeAmmoBar( selectedWeapon, player )
			break
	}

	if ( IsValid( cockpit ) )
	{
		local weaponMods = selectedWeapon.GetMods()
		local burnModText = null
		foreach ( mod in weaponMods )
		{
			if ( mod in level.burnCardWeaponModList )
			{
				burnModText = level.burnCardWeaponModList[ mod ]
				break
			}
		}

		if ( burnModText )
		{
			//cockpit.s.weaponName.SetText( burnModText )
			cockpit.s.weaponName.SetColor( BURN_CARD_WEAPON_HUD_COLOR[0], BURN_CARD_WEAPON_HUD_COLOR[1], BURN_CARD_WEAPON_HUD_COLOR[2], 255 )
		}
		else
		{
			//cockpit.s.weaponName.SetAutoText( "#HudAutoText_ActiveWeaponName", HATT_ACTIVE_WEAPON_NAME, 0 )
			cockpit.s.weaponName.ReturnToBaseColor()
		}
	}


	player.Signal( "UpdateWeapons" )
}


function AlertThink( cockpit, player )
{
	cockpit.EndSignal( "OnDestroy" )
	player.EndSignal( "OnDestroy" )

	local lastOffhandProgress = [ 1.0, 1.0 ]
	local specialReadySound = IsTitanCockpitModelName( cockpit.GetModelName() ) ? "titan_shield_ready" : "Pilot_SpecialAbility_Replenished"

	for ( ;; )
	{
		if ( IsWatchingKillReplay() || GetGameState() < eGameState.Playing )
		{
			wait 0.1
			continue
		}

		foreach ( index, lastProgressFrac in lastOffhandProgress )
		{
			local offhandProgress = cockpit.s.offhandHud[index].bar.GetBarProgress()
			local offhand = player.GetOffhandWeapon( index )

			if ( offhandProgress >= 0.99 && lastProgressFrac < 0.99 )
			{
				if ( index == 0 )
					EmitSoundOnEntity( player, "titan_rocket_ready" )
				else
					EmitSoundOnEntity( player, specialReadySound )

				cockpit.s.offhandHud[index].icon.ReturnToBaseColor()
				cockpit.s.offhandHud[index].icon.SetAlpha( 255 )
				cockpit.s.offhandHud[index].bar.SetAlpha( 255 )
				cockpit.s.offhandHud[index].hint.SetAlpha( 255 )

				if ( offhand && player.GetWeaponAmmoLoaded( offhand ) )
					thread AlertOffhandIcon( cockpit, player, index )
			}
			else if ( offhandProgress < 0.99 )
			{
				if ( offhand && ( !offhand.IsReadyToFire() || player.GetWeaponAmmoLoaded( offhand ) == 0 ) )
				{
					cockpit.s.offhandHud[index].icon.SetColor( 128, 128, 128, 255 )
					cockpit.s.offhandHud[index].bar.SetAlpha( 64 )
					cockpit.s.offhandHud[index].hint.SetAlpha( 64 )
				}
				else
				{
					cockpit.s.offhandHud[index].icon.ReturnToBaseColor()
					if ( cockpit.s.offhandHud[index].hasBurnWeapon )
						cockpit.s.offhandHud[index].bar.SetColor( BURN_CARD_WEAPON_HUD_COLOR[0], BURN_CARD_WEAPON_HUD_COLOR[1], BURN_CARD_WEAPON_HUD_COLOR[2], BURN_CARD_WEAPON_HUD_COLOR[3] )
					else
						cockpit.s.offhandHud[index].bar.ReturnToBaseColor()
					cockpit.s.offhandHud[index].hint.ReturnToBaseColor()
				}
			}

			lastOffhandProgress[index] = offhandProgress
		}

		wait 0.1
	}
}


const ALERT_ICON_ANIMRATE = 0.35
const ALERT_ICON_SCALE = 3.0
function AlertOffhandIcon( cockpit, player, iconIndex, numPings = 3, numCycles = 1 )
{
	cockpit.EndSignal( "OnDestroy" )
	player.EndSignal( "OnDestroy" )

	local alertIcon = cockpit.s.offhandHud[iconIndex].alert
	local offhandIcon = cockpit.s.offhandHud[iconIndex].icon

	alertIcon.Show()

	for ( local cycleId = 0; cycleId < numCycles; cycleId++ )
	{
		for ( local i = 0; i < numPings; i++ )
		{
			alertIcon.ReturnToBaseSize()
			alertIcon.ReturnToBaseColor()
			alertIcon.ScaleOverTime( ALERT_ICON_SCALE, ALERT_ICON_SCALE, ALERT_ICON_ANIMRATE, INTERPOLATOR_DEACCEL )
			alertIcon.ColorOverTime( 0, 0, 0, 0, ALERT_ICON_ANIMRATE, INTERPOLATOR_DEACCEL )

			offhandIcon.SetColor( 0, 0, 0, 0 )
			offhandIcon.ColorOverTime( 255, 255, 255, 255, ALERT_ICON_ANIMRATE, INTERPOLATOR_DEACCEL )

			wait ALERT_ICON_ANIMRATE + 0.1
		}
	}

	alertIcon.Hide()
}



function CaptureTheFlagThink( vgui, player )
{
	vgui.EndSignal( "OnDestroy" )

	if ( vgui instanceof C_VGuiScreen )
		player.EndSignal( "OnDestroy" )

	vgui.s.friendlyFlag.Show()
	vgui.s.enemyFlag.Show()
	vgui.s.friendlyFlagLabel.Show()
	vgui.s.enemyFlagLabel.Show()

	while ( GetGameState() < eGameState.Epilogue )
	{
		if ( "friendlyFlagState" in player.s )
		{
			// add checks for ctf pro where only 1 flag is present
			switch ( player.s.friendlyFlagState )
			{
				case eFlagState.None:
					vgui.s.friendlyFlagLabel.SetText( "" )
					vgui.s.friendlyFlag.Hide()
					break
				case eFlagState.Home:
					vgui.s.friendlyFlagLabel.SetText( "#GAMEMODE_FLAG_HOME" )
					break
				case eFlagState.Held:
					vgui.s.friendlyFlagLabel.SetText( player.s.friendlyFlagCarrierName )
					break
				case eFlagState.Away:
					vgui.s.friendlyFlagLabel.SetText( "#GAMEMODE_FLAG_DROPPED" )
					break
			}

			switch ( player.s.enemyFlagState )
			{
				case eFlagState.None:
					vgui.s.enemyFlagLabel.SetText( "" )
					vgui.s.enemyFlag.Hide()
					break
				case eFlagState.Home:
					vgui.s.enemyFlagLabel.SetText( "#GAMEMODE_FLAG_HOME" )
					break
				case eFlagState.Held:
					vgui.s.enemyFlagLabel.SetText( player.s.enemyFlagCarrierName )
					break
				case eFlagState.Away:
					vgui.s.enemyFlagLabel.SetText( "#GAMEMODE_FLAG_DROPPED" )
					break
			}
		}

		level.ent.WaitSignal( "FlagUpdate" )

		WaitEndFrame()
	}

	vgui.s.friendlyFlag.Hide()
	vgui.s.enemyFlag.Hide()
	vgui.s.friendlyFlagLabel.Hide()
	vgui.s.enemyFlagLabel.Hide()
}

PrecacheHUDMaterial( "HUD/capture_point_status_orange_a" )
PrecacheHUDMaterial( "HUD/capture_point_status_orange_b" )
PrecacheHUDMaterial( "HUD/capture_point_status_orange_c" )
PrecacheHUDMaterial( "HUD/capture_point_status_blue_a" )
PrecacheHUDMaterial( "HUD/capture_point_status_blue_b" )
PrecacheHUDMaterial( "HUD/capture_point_status_blue_c" )
PrecacheHUDMaterial( "HUD/capture_point_status_grey_a" )
PrecacheHUDMaterial( "HUD/capture_point_status_grey_b" )
PrecacheHUDMaterial( "HUD/capture_point_status_grey_c" )
PrecacheHUDMaterial( "hud/dpad_satchel_activate" )



function SignalUpdatePlayerStatusCounts( titan, isRecreate )
{
	if ( !level.ent )
		return

	UpdatePlayerStatusCounts()
}

function UpdatePlayerStatusCounts()
{
	level.ent.Signal( "UpdatePlayerStatusCounts" ) //For Pilot Elimination based modes
	level.ent.Signal( "UpdateTitanCounts" ) //For all modes
}

function ScoreBarsPlayerStatusThink( vgui, player, friendlyPlayerStatusElem, enemyPlayerStatusElem, friendlyPlayerStatusBurnCardBGElem, enemyPlayerStatusBurnCardBGElem )
{
	local friendlyTeam = player.GetTeam()
	local enemyTeam = friendlyTeam == TEAM_IMC ? TEAM_MILITIA : TEAM_IMC

	vgui.EndSignal( "OnDestroy" )
	player.EndSignal("OnDestroy")
	while( true )
	{
		level.ent.WaitSignal( "UpdatePlayerStatusCounts" )
		if ( !IsValid( player ) )
			return;
		// Check for team change before updating counts based on potentially stale team perspective
		if ( player.GetTeam() != vgui.s.scoreboardTeam )
		{
			vgui.s.scoreboardTeam = player.GetTeam()
			UpdateScoreboardTeamProperties( vgui, player )
			// Update local team variables after properties have been reset
			friendlyTeam = player.GetTeam()
			enemyTeam = friendlyTeam == TEAM_IMC ? TEAM_MILITIA : TEAM_IMC
		}

		if ( IsWatchingKillReplay() || !level.showScoreboard ) //Don't update visibility if the scoreboardgroup should be hidden
			continue

		UpdatePlayerStatusForTeam( friendlyTeam, friendlyPlayerStatusElem, friendlyPlayerStatusBurnCardBGElem, "../ui/icon_status_titan_friendly", "../ui/icon_status_pilot_friendly", "../ui/icon_status_burncard_friendly", "../ui/icon_status_dead" )
		UpdatePlayerStatusForTeam( enemyTeam, enemyPlayerStatusElem, enemyPlayerStatusBurnCardBGElem,"../ui/icon_status_titan_enemy", "../ui/icon_status_pilot_enemy", "../ui/icon_status_burncard_enemy", "../ui/icon_status_dead" )
	}

}

function UpdatePlayerStatusForTeam( team, teamStatusElem, burnCardStatusElem, titanImage, pilotImage, burncCardImage, deadImage )
{
	local teamPlayers = GetPlayerArrayOfTeam( team )
	local teamResultTable = CountPlayerStatusTypes( teamPlayers )

	local index
	local lowerBound = 0
	local upperBound =  teamResultTable.titanWithBurnCard

	/*for( index = lowerBound; index < upperBound; ++index  )
	{
		teamStatusElem[ index ].Show()
		teamStatusElem[ index ].SetImage( "../ui/icon_status_alive_with_titan" )
	}*/

	for( index = lowerBound; index < upperBound; ++index  )
	{
		teamStatusElem[ index ].Show()
		teamStatusElem[ index ].SetImage( titanImage )
		burnCardStatusElem[ index ].Show()
	}

	lowerBound = upperBound
	upperBound += teamResultTable.titan

	for( index = lowerBound; index < upperBound; ++index  )
	{
		teamStatusElem[ index ].Show()
		teamStatusElem[ index ].SetImage( titanImage )
		burnCardStatusElem[ index ].Hide()
	}

	lowerBound = upperBound
	upperBound += teamResultTable.pilotWithBurnCard

	for( index = lowerBound; index < upperBound; ++index  )
	{
		teamStatusElem[ index ].Show()
		teamStatusElem[ index ].SetImage( pilotImage )
		burnCardStatusElem[ index ].Show()
	}

	lowerBound = upperBound
	upperBound += teamResultTable.pilot

	for( index = lowerBound; index < upperBound; ++index  )
	{
		teamStatusElem[ index ].Show()
		teamStatusElem[ index ].SetImage( pilotImage )
		burnCardStatusElem[ index ].Hide()
	}

	lowerBound = upperBound
	upperBound += teamResultTable.dead

	for( index = lowerBound; index < upperBound; ++index  )
	{
		teamStatusElem[ index ].Show()
		teamStatusElem[ index ].SetImage( deadImage )
		burnCardStatusElem[ index ].Hide()
	}

	for( index = upperBound; index < 8; ++index  ) //Assume we'll never have more than 8 players!
	{
		teamStatusElem[ index ].Hide()
		burnCardStatusElem[ index ].Hide()
	}

}

function CountPlayerStatusTypes( teamPlayers )
{
	//TODO: Add burn card counts as needed
	local resultTable = {
		dead = 0,
		pilot = 0,
		titan = 0,
		titanWithBurnCard = 0,
		pilotWithBurnCard = 0
	}

	foreach ( player in teamPlayers )
	{
		local playerPetTitan = player.GetPetTitan()
		if ( !IsAlive( player ) )
		{
			if ( IsAlive( playerPetTitan ) )
				IncrementTitanStatusTypesCount( resultTable, player )
			else if ( GAMETYPE == COOPERATIVE )
				IncrementDeadStatusTypesCount( resultTable, player )
			else
				continue
		}
		else
		{
			if ( player.IsTitan() )
				IncrementTitanStatusTypesCount( resultTable, player )
			else if ( IsAlive( playerPetTitan ) )
				IncrementTitanStatusTypesCount( resultTable, player )
			else if ( GAMETYPE == COOPERATIVE && player.GetParent() && player.GetParent().GetClassname() == "npc_dropship" )
				IncrementDeadStatusTypesCount( resultTable, player )
			else
				IncrementPilotStatusTypesCount( resultTable, player )
		}

	}
	//PrintTable( resultTable )
	return resultTable
}

function IncrementDeadStatusTypesCount( resultTable, player )
{
	resultTable.dead++
}

function IncrementPilotStatusTypesCount( resultTable, player )
{
	if ( DoesPlayerHaveActiveNonTitanBurnCard( player ) == true )
		resultTable.pilotWithBurnCard++
	else
		resultTable.pilot++
}

function IncrementTitanStatusTypesCount( resultTable, titan )
{
	if ( DoesTitanHaveActiveTitanBurnCard( titan ) == true )
		resultTable.titanWithBurnCard++
	else
		resultTable.titan++

}

function ScoreBarsTitanCountThink( vgui, player, friendlyTitanCountElem, friendlyTitanReadyCountElem, enemyTitanCountElem, friendlyTitanCountBurnElem, enemyTitanCountBurnElem )
{
	local friendlyTeam = player.GetTeam()
	local enemyTeam = friendlyTeam == TEAM_IMC ? TEAM_MILITIA : TEAM_IMC

	vgui.EndSignal( "OnDestroy" )
	player.EndSignal( "OnDestroy" )

	for ( ;; )
	{
		level.ent.WaitSignal( "UpdateTitanCounts" )
		if ( !IsValid( player ) )
			return;
		// Check for team change before updating counts based on potentially stale team perspective
		if ( player.GetTeam() != vgui.s.scoreboardTeam )
		{
			vgui.s.scoreboardTeam = player.GetTeam()
			UpdateScoreboardTeamProperties( vgui, player )
			// Update local team variables after properties have been reset
			friendlyTeam = player.GetTeam()
			enemyTeam = friendlyTeam == TEAM_IMC ? TEAM_MILITIA : TEAM_IMC
		}

		local friendlyTitans = GetPlayerTitansOnTeam( friendlyTeam )
		local friendlyTitanCount = friendlyTitans.len()
		local friendlyBurnTitanCount = GetBurnTitanCount( friendlyTitans )
		local friendlyTitanReadyCount = GetPlayerTitansReadyOnTeam( friendlyTeam ).len()

		friendlyTitanCountElem.SetBarProgress( friendlyTitanCount / 8.0 )
		friendlyTitanCountBurnElem.SetBarProgress( friendlyBurnTitanCount / 8.0 )
		friendlyTitanReadyCountElem.SetBarProgress( (friendlyTitanCount + friendlyTitanReadyCount) / 8.0 )

		local enemyTitans = GetPlayerTitansOnTeam( enemyTeam )
		local enemyTitanCount = enemyTitans.len()
		local enemyBurnTitanCount = GetBurnTitanCount( enemyTitans )

		enemyTitanCountElem.SetBarProgress( enemyTitanCount / 8.0 )
		enemyTitanCountBurnElem.SetBarProgress( enemyBurnTitanCount / 8.0 )
	}
}

function GetBurnTitanCount( titanArray )
{
	local count = 0
	foreach ( titan in titanArray )
	{
		if ( DoesTitanHaveActiveTitanBurnCard( titan ) )
			count++
	}
	return count
}

function RoundScoreThink( vgui, player )
{
	vgui.EndSignal( "OnDestroy" )

	FlagWait( "EntitiesDidLoad" ) //Have to do this because the nv that determines if RoundBased or not might not get set yet

	local friendlyTeam = player.GetTeam()
	local enemyTeam = friendlyTeam == TEAM_IMC ? TEAM_MILITIA : TEAM_IMC

	local isRoundBased = IsRoundBased()
	local isMultiplayer = IsMultiplayer()
	local roundScoreLimit = GetRoundScoreLimit_FromPlaylist()
	local scoreLimit = GetScoreLimit_FromPlaylist()

	if ( isRoundBased )
	{
		level.scoreLimit[TEAM_IMC] <- isMultiplayer ? roundScoreLimit : 0
		level.scoreLimit[TEAM_MILITIA] <- isMultiplayer ? roundScoreLimit : 0
	}
	else
	{
		level.scoreLimit[TEAM_IMC] <- isMultiplayer ? scoreLimit : 0
		level.scoreLimit[TEAM_MILITIA] <- isMultiplayer ? scoreLimit : 0
	}

	local scoreboardProgressBars = vgui.s.scoreboardProgressBars

	while ( true )
	{
		if ( isRoundBased )
		{
			scoreboardProgressBars.Friendly_Number.SetAutoText( "", HATT_FRIENDLY_TEAM_ROUND_SCORE, 0 )
			scoreboardProgressBars.Enemy_Number.SetAutoText( "", HATT_ENEMY_TEAM_ROUND_SCORE, 0 )
		}

		scoreboardProgressBars.ScoresFriendly.SetBarProgressRemap( 0, level.scoreLimit[friendlyTeam], 0.011, 0.96 )
		scoreboardProgressBars.ScoresEnemy.SetBarProgressRemap( 0, level.scoreLimit[enemyTeam], 0.011, 0.96 )
		wait 1.0
	}
}


function UpdateShieldHealth( soul )
{
	local player = GetLocalViewPlayer()

	if ( soul == player.GetTitanSoul() )
	{
		player.Signal( "UpdateShieldBar" )
		return
	}

	if ( GetHealthBarEntity( player ) && soul == GetHealthBarEntity( player ).GetTitanSoul() )
		player.Signal( "UpdateTargetShieldHealth" )
}


function ShouldMainHudBeVisible( player )
{
	if ( IsInScoreboard( player ) )
		return false

	local ceFlags = player.GetCinematicEventFlags()

	if ( ceFlags & CE_FLAG_EMBARK )
		return false

	if ( ceFlags & CE_FLAG_DISEMBARK )
		return false

	if ( ceFlags & CE_FLAG_INTRO )
		return false

	if ( ceFlags & CE_FLAG_CLASSIC_MP_SPAWNING )
		return false

	if ( ceFlags & CE_FLAG_EOG_STAT_DISPLAY )
		return false

	//if ( ceFlags & CE_FLAG_PERMANENT_HIDEHUD )
		//return false

	local gameState = GetGameState()

	if ( gameState < eGameState.Playing )
		return false

	if ( gameState > eGameState.Epilogue )
		return false

	return true
}


function UpdateMainHudFromCEFlags( player )
{
	UpdateMainHudVisibility( player )
}

function UpdateMainHudFromGameState()
{
	local player = GetLocalViewPlayer()
	UpdateMainHudVisibility( player, 1.0 )
}


function UpdateMainHudVisibility( player, duration = null )
{
	local ceFlags = player.GetCinematicEventFlags()
	local shouldBeVisible = ShouldMainHudBeVisible( player )

	if ( shouldBeVisible )
		ShowFriendlyIndicatorAndCrosshairNames()
	else
		HideFriendlyIndicatorAndCrosshairNames()

	local cockpit = player.GetCockpit()
	if ( !cockpit )
		return

	local mainVGUI = cockpit.GetMainVGUI()
	if ( !mainVGUI )
		return

	local isVisible = (mainVGUI.s.enabledState == VGUI_OPEN) || (mainVGUI.s.enabledState == VGUI_OPENING)

	if ( isVisible && !shouldBeVisible )
	{
		local warpSettings = mainVGUI.s.warpSettings
		if ( duration == null )
		{
			duration = 0.0
			if ( ceFlags & CE_FLAG_EMBARK )
				duration = 1.0
			else if ( ceFlags & CE_FLAG_DISEMBARK )
				duration = 0.0
		}

		thread MainHud_TurnOff( mainVGUI, duration, warpSettings.xWarp, warpSettings.xScale, warpSettings.yWarp, warpSettings.yScale, warpSettings.viewDist )
	}
	else if ( !isVisible && shouldBeVisible )
	{
		//printt( "turn on" )
		local warpSettings = mainVGUI.s.warpSettings

		if ( duration == null )
			duration = 1.0

		thread MainHud_TurnOn( mainVGUI, duration, warpSettings.xWarp, warpSettings.xScale, warpSettings.yWarp, warpSettings.yScale, warpSettings.viewDist )
	}
}

function UpdateScoreInfo()
{
	local player = GetLocalClientPlayer()

	if ( !player.cv )
		return

	UpdateVGUIScoreInfo( player.cv.clientHud.s.mainVGUI )

	local cockpit = player.GetCockpit()
	if ( !cockpit )
		return

	local mainVGUI = cockpit.GetMainVGUI()
	if ( !mainVGUI )
		return

	UpdateVGUIScoreInfo( mainVGUI )
}


function UpdateVGUIScoreInfo( vgui )
{
	if ( GAMETYPE == COOPERATIVE )
		return // for coop we are handling the time display in cl_coop_hud.nut

	local endTime = GetScoreEndTime()

	if ( !("scoreboardProgressBars" in vgui.s) )
		return

	local scoreElems = vgui.s.scoreboardProgressBars
	if ( endTime > 0 )
	{
		scoreElems.GameInfo_Label.SetAutoText( "", HATT_COUNTDOWN_TIME, endTime )

		// BE CAREFUL MERGING THIS FILE. MULTIPLE MERGE ERRORS HAVE REMOVED
		// THE LINE BELOW. REMOVING THIS LINE BREAKS SMARTGLASS!!!
		SmartGlass_StartCountdown( "round", endTime )
	}
	else
	{
		scoreElems.GameInfo_Label.SetText( "#HUD_BLANK_TIME" )

		// BE CAREFUL MERGING THIS FILE. MULTIPLE MERGE ERRORS HAVE REMOVED
		// THE LINE BELOW. REMOVING THIS LINE BREAKS SMARTGLASS!!!
		SmartGlass_StopCountdown( "round" )
	}
}


function MainHud_TurnOn( vgui, duration, xWarp, xScale, yWarp, yScale, viewDist )
{
	vgui.EndSignal( "OnDestroy" )

	vgui.Signal( "MainHud_TurnOn" )
	vgui.EndSignal( "MainHud_TurnOn" )
	vgui.EndSignal( "MainHud_TurnOff" )

	if ( vgui.s.enabledState == VGUI_OPEN || vgui.s.enabledState == VGUI_OPENING )
		return

	vgui.s.enabledState = VGUI_OPENING

	//vgui.s.panel.WarpGlobalSettings( xWarp, xScale, yWarp, yScale, viewDist )

	if ( !IsWatchingKillReplay() )
	{
		vgui.s.panel.WarpGlobalSettings( xWarp, 0, yWarp, 0, viewDist )
		//vgui.SetSize( vgui.s.baseSize[0] * 0.001, vgui.s.baseSize[1] * 0.001 )

		local xTimeScale = 0
		local yTimeScale = 0

		local scale = 0
		local startTime = Time()

		while ( yTimeScale < 1.0 )
		{
			xTimeScale = Anim_EaseIn( GraphCapped( Time() - startTime, 0.0, duration / 2, 0.0, 1.0 ) )
			yTimeScale = Anim_EaseIn( GraphCapped( Time() - startTime, duration / 4, duration, 0.01, 1.0 ) )

			//local scaledSize = Vector( vgui.s.baseSize[0] * xTimeScale, vgui.s.baseSize[1] * yTimeScale, 0 )
			//vgui.SetAttachOffsetOrigin( vgui.s.baseOrigin )
			//vgui.SetSize( scaledSize.x, scaleSize.y )
			vgui.s.panel.WarpGlobalSettings( xWarp, xScale * xTimeScale, yWarp, yScale * yTimeScale, viewDist )
			wait 0
		}
	}

	//vgui.SetSize( vgui.s.baseSize[0], vgui.s.baseSize[1] )
	vgui.s.panel.WarpGlobalSettings( xWarp, xScale, yWarp, yScale, viewDist )
	vgui.s.enabledState = VGUI_OPEN
}


function MainHud_TurnOff( vgui, duration, xWarp, xScale, yWarp, yScale, viewDist )
{
	vgui.EndSignal( "OnDestroy" )

	vgui.Signal( "MainHud_TurnOff" )
	vgui.EndSignal( "MainHud_TurnOff" )
	vgui.EndSignal( "MainHud_TurnOn" )

	if ( vgui.s.enabledState == VGUI_CLOSED || vgui.s.enabledState == VGUI_CLOSING )
		return

	vgui.s.enabledState = VGUI_CLOSING

	vgui.s.panel.WarpGlobalSettings( xWarp, xScale, yWarp, yScale, viewDist )
	//vgui.SetSize( vgui.s.baseSize[0], vgui.s.baseSize[1] )

	local xTimeScale = 1.0
	local yTimeScale = 1.0

	local scale = 0
	local startTime = Time()

	while ( xTimeScale > 0.0 )
	{
		xTimeScale = Anim_EaseOut( GraphCapped( Time() - startTime, duration * 0.1, duration, 1.0, 0.0 ) )
		yTimeScale = Anim_EaseOut( GraphCapped( Time() - startTime, 0.0, duration * 0.5, 1.0, 0.01 ) )

		//vgui.SetSize( vgui.s.baseSize[0] * xTimeScale, vgui.s.baseSize[1] * yTimeScale )
		vgui.s.panel.WarpGlobalSettings( xWarp, xScale * xTimeScale, yWarp, yScale * yTimeScale, viewDist )
		wait 0
	}

	//vgui.SetSize( vgui.s.baseSize[0] * 0.001, vgui.s.baseSize[1] * 0.001 )
	vgui.s.panel.WarpGlobalSettings( xWarp, 0, yWarp, 0, viewDist )

	vgui.s.enabledState = VGUI_CLOSED
}


function HideFriendlyIndicatorAndCrosshairNames()
{
	local player = GetLocalViewPlayer()
	player.HideCrosshairNames()
	if ( IsMultiplayer() && GameRules.GetGameMode() == "cp" || GameRules.GetGameMode() == "uplink" )
		HideHardpointIcons( player )
}

function ShowFriendlyIndicatorAndCrosshairNames()
{
	//Show crosshair names and blue friendly indicators
	local player = GetLocalViewPlayer()
	player.UnhideCrosshairNames()
	if ( IsMultiplayer() && GameRules.GetGameMode() == "cp" || GameRules.GetGameMode() == "uplink" )
		ShowHardpointIcons( player )
}

function MainHud_Outro( winningTeam )
{
	local player = GetLocalClientPlayer()
	//Test getting rid of the epilogue bar temporarily
	/*player.cv.clientHud.s.mainVGUI.s.epilogue.SetAlpha( 0 )
	player.cv.clientHud.s.mainVGUI.s.epilogue.Show()
	player.cv.clientHud.s.mainVGUI.s.epilogue.FadeOverTime( 255, 1.5 )

	local cockpit = player.GetCockpit()
	if ( cockpit )
	{
		local mainVGUI = cockpit.GetMainVGUI()
		if ( mainVGUI )
		{
			mainVGUI.s.epilogue.SetAlpha( 0 )
			mainVGUI.s.epilogue.Show()
			mainVGUI.s.epilogue.FadeOverTime( 255, 1.5 )
		}
	}*/

	//hide the scoreboard before showing the hud
	HideGameProgressScoreboard_ForPlayer( player )
}

function HideGameProgressScoreboard_ForPlayer( player )
{
	if ( !IsTrainingLevel() )
		return

	if ( player == GetLocalClientPlayer() )
		player.cv.clientHud.s.mainVGUI.s.scoreboardProgressGroup.Hide()

	local cockpit = player.GetCockpit()
	if ( !cockpit )
		return

	local mainVGUI = cockpit.GetMainVGUI()
	if ( !mainVGUI )
		return

	mainVGUI.s.scoreboardProgressGroup.Hide()
}

function ShowGameProgressScoreboard_ForPlayer( player )
{
	if ( player == GetLocalClientPlayer() )
		player.cv.clientHud.s.mainVGUI.s.scoreboardProgressGroup.Show()

	local cockpit = player.GetCockpit()
	if ( !cockpit )
		return

	local mainVGUI = cockpit.GetMainVGUI()
	if ( !mainVGUI )
		return

	mainVGUI.s.scoreboardProgressGroup.Show()
}

function InitCrosshair()
{
	// The number of priority levels should not get huge. Will depend on how many different places in script want control at the same time.
	// All menus for example should show and clear from one place to avoid unneccessary priority levels.
	file.crosshairPriorityOrder.append( crosshairPriorityLevel.ROUND_WINNING_KILL_REPLAY )
	file.crosshairPriorityOrder.append( crosshairPriorityLevel.MENU )
	file.crosshairPriorityOrder.append( crosshairPriorityLevel.PREMATCH )
	file.crosshairPriorityOrder.append( crosshairPriorityLevel.TITANHUD )
	file.crosshairPriorityOrder.append( crosshairPriorityLevel.DEFAULT )

	foreach ( priority in file.crosshairPriorityOrder )
		file.crosshairPriorityLevel[priority] <- null

	// Fallback default
	file.crosshairPriorityLevel[crosshairPriorityLevel.DEFAULT] = CROSSHAIR_STATE_SHOW_ALL
	UpdateCrosshairState()
}

function SetCrosshairPriorityState( priority, state )
{
	Assert( priority != crosshairPriorityLevel.DEFAULT, "Default crosshair state priority level should never be changed." )

	file.crosshairPriorityLevel[priority] = state

	UpdateCrosshairState()
}

function UpdateCrosshairState()
{
	foreach ( priority in file.crosshairPriorityOrder )
	{
		if ( priority in file.crosshairPriorityLevel && file.crosshairPriorityLevel[priority] != null )
		{
			Crosshair_SetState( file.crosshairPriorityLevel[priority] )
			return
		}
	}
}

function ClearCrosshairPriority( priority )
{
	Assert( priority != crosshairPriorityLevel.DEFAULT, "Default crosshair state priority level should never be cleared." )

	if ( priority in file.crosshairPriorityLevel )
		file.crosshairPriorityLevel[priority] = null

	UpdateCrosshairState()
}

function MainHud_InitXPBar( cockpit, player )
{
	if ( player != GetLocalClientPlayer() )
		return

	cockpit.s.xpBar <- {}

	if ( player.cv.startingXP == 0 && player.cv.lastLevel == 1 )
    {
        player.cv.startingXP = GetXP( player ) 
        player.cv.lastLevel = GetLevel( player )
    }

	local xpBarGroup = HudElementGroup( "xpBarGroup" )
	local panel = cockpit.s.mainVGUI.GetPanel()

	local progressStart = GetLevelProgressStart( player )
	local progressEnd = GetLevelProgressEnd( player )
	local progressCurrent = GetXP( player )
	local lvl = GetLevelForXP( progressCurrent )

	cockpit.s.xpBar.pastFill <- xpBarGroup.CreateElement( "XPBarPastFill", panel )
	if ( lvl == player.cv.lastLevel )
	{
		cockpit.s.xpBar.pastFill.SetBarProgressRemap( progressStart, progressEnd, 0, 1 )
		cockpit.s.xpBar.pastFill.SetBarProgress( player.cv.startingXP )
		cockpit.s.xpBar.pastFill.Show()
	}
	else
	{
		cockpit.s.xpBar.pastFill.Hide()
	}

	cockpit.s.xpBar.fill <- xpBarGroup.CreateElement( "XPBarFill", panel )
	cockpit.s.xpBar.fill.SetBarProgressRemap( progressStart, progressEnd, 0, 1 )
	cockpit.s.xpBar.fill.SetBarProgress( progressCurrent )
	cockpit.s.xpBar.fill.Show()

	cockpit.s.xpBarGroup <- xpBarGroup

	if ( ShouldShowXPBar( player ) )
		cockpit.s.xpBarGroup.Show()
	else
		cockpit.s.xpBarGroup.Hide()
}

if ( IsLobby() )
{
	function ClientCodeCallback_XPChanged( player )
	{
	}
}
else
{
	function ClientCodeCallback_XPChanged( player )
	{
		//Defensive fix temporarily. Code probably shouldn't just pass us null. Remove when bug 37216 is resolved.
		if ( !IsValid( player ) )
			return

		if ( player != GetLocalClientPlayer() )
			return

		if ( player != GetViewEntity() ) //Check for ViewEntity for edge case where you watch a kill replay being killed by an AI.
			return

		if ( IsWatchingKillReplay() && IsReplayRoundWinning() ) //In RoundWinningKillReplay you can be watching yourself during a kill replay. Theoretically means you can not see an XP level up message if you earn enough XP during the round winning kill replay, but since the round's ended that shouldn't ever be true.
			return

		local cockpit = player.GetCockpit()

		if ( !IsValid( cockpit ) )
			return

		if ( !level.showXPBar )
			return

		local lvl = GetLevel( player )
		if ( lvl > MAX_LEVEL )
			return

		
		if ( lvl != player.cv.lastLevel )
		{
			cockpit.s.xpBar.pastFill.Hide()
			if ( lvl == MAX_LEVEL || IsNonDeltaPrivateMatch() ) //!PlayerProgressionAllowed( player )
				cockpit.s.xpBarGroup.Hide()

			cockpit.s.xpBar.fill.SetBarProgressRemap( GetLevelProgressStart( player ), GetLevelProgressEnd( player ), 0, 1 )

			if ( GetConVarBool( "delta_hud_show_levelup" ) )
			{
				local optionalTextArgs = [ lvl ]

				local announcement = CAnnouncement( "#HUD_LEVEL_N" )
				announcement.SetSubText( "#HUD_LEVEL_CONGRATULATIONS" )
				announcement.SetTitleColor( [255, 190, 0] )
				announcement.SetOptionalTextArgsArray( optionalTextArgs )
				announcement.SetPurge( true )
				announcement.SetPriority( 100 )
				announcement.SetSoundAlias( "UI_InGame_LevelUp" )
				//announcement.SetIcon( "HUD/quest/bg_circle" )
				//announcement.SetIconText( "" + lvl )
				AnnouncementFromClass( player, announcement )
			}

			player.cv.lastLevel = lvl
		}

		cockpit.s.xpBar.fill.SetBarProgress( GetXP( player ) )
	}
}

function ShouldShowXPBar( player )
{
	if ( !level.showXPBar )
		return false

	if ( !GetConVarBool( "delta_hud_show_xpbar" ) )
		return false

	if ( IsWatchingKillReplay() )
		return false

	if ( GetLevel( player ) >= MAX_LEVEL )
		return false

	if ( IsNonDeltaPrivateMatch() )
		return false

	return true
}

function ServerCallback_Announcement( titleStringID, subTextStringID )
{
	local player = GetLocalViewPlayer()

	local subTextString = ""
	if ( subTextStringID )
		subTextString = GetStringFromID( subTextStringID )

	local announcement = CAnnouncement( GetStringFromID( titleStringID ) )
	announcement.SetSubText( subTextString )
	announcement.SetHideOnDeath( false )

	AnnouncementFromClass( player, announcement )
}

function ServerCallback_GameModeAnnouncement()
{
	local player = GetLocalClientPlayer()
	local gameMode = GameRules.GetGameMode()

	local team = player.GetTeam()

	local totalDuration = 0.0

	local announcement

	if ( GetGameState() == eGameState.Epilogue )
	{
		// never gets hit??
		announcement = CAnnouncement( "#GAMEMODE_EPILOGUE" )
	}
	else
	{
		announcement = CAnnouncement( GAMETYPE_TEXT[gameMode] )
		announcement.SetIcon( GAMETYPE_ICON[gameMode] )
		announcement.SetSubText( GAMETYPE_DESC[gameMode] )

		if ( GameMode_IsDefined( gameMode ) )
		{
			announcement.SetSubText( GameMode_GetMatchStartDesc( gameMode ) )

			if ( GameMode_GetAttackDesc( gameMode ) != "" && team == level.nv.attackingTeam )
				announcement.SetSubText( GameMode_GetAttackDesc( gameMode ) )

			if ( GameMode_GetDefendDesc( gameMode ) != "" && team != level.nv.attackingTeam )
				announcement.SetSubText( GameMode_GetDefendDesc( gameMode ) )
		}
	}

	local numRiffs = UpdateSubText2ForRiffs( announcement )
	local announcementDuration = announcement.GetDuration() + numRiffs
	announcementDuration = min( announcementDuration, 3.0 ) //Max of 3.0 seconds mainly for ranked play's sake so its announcement at least shows up. Not ideal... Not also that 3 seconds is currently the default minimum

	announcement.SetDuration( announcementDuration )
	totalDuration += announcementDuration

	if ( gameMode == "tt" ) // TEMP; make this a general system
		announcement.SetSubText2( "#GAMEMODE_TITAN_TAG_BONUS" )

	AnnouncementFromClass( player, announcement ) // TODO: team specific goals

	switch ( gameMode )
	{
		case BIG_BROTHER:
			local msg

			// this mode needs an additional announcement
			if ( team == level.nv.attackingTeam )
				msg = "#GAMEMODE_BIG_BROTHER_ATTACK"
			else
				msg = "#GAMEMODE_BIG_BROTHER_DEFEND"

			announcement = CAnnouncement( msg )
			announcementDuration = 5.0
		 	announcement.SetDuration( announcementDuration )
		 	totalDuration += announcementDuration
		 	AnnouncementFromClass( player, announcement ) // TODO: team specific goals
			break

		case HEIST:
			local msg

			// this mode needs an additional announcement
			if ( team == level.nv.attackingTeam )
				msg = "#GAMEMODE_HEIST_ATTACK"
			else
				msg = "#GAMEMODE_HEIST_DEFEND"

			announcement = CAnnouncement( msg )
			announcementDuration = 5.0
		 	announcement.SetDuration( announcementDuration )
		 	totalDuration += announcementDuration
		 	AnnouncementFromClass( player, announcement ) // TODO: team specific goals
			break

		/*case MARKED_FOR_DEATH_PRO:
			if ( !TargetsMarkedImmediately() )
				return

			if( player == GetMarked( player.GetTeam() ) )
				thread DelayMarkedForDeathProReminder()
			else
				thread DelayMarkedForDeathProTargetsMarked()
			break*/
	}

	if ( level.hasMatchLossProtection )
	{
		announcementDuration = 2.0
		totalDuration += announcementDuration
		delaythread( announcementDuration) SetTimedEventNotification( 6.0, "#LATE_JOIN_NO_LOSS" )
	}

	if (  Riff_FloorIsLava() )
	{
		announcementDuration = 10.0
		totalDuration += announcementDuration
		//printt( "Total duration delayed for lava announcement: " + totalDuration )
		delaythread( totalDuration ) PlayConversationToLocalClient( "floor_is_lava_announcement" )
	}

	if ( level.nv.titanExitEnabled != eTitanExitEnabled.Default )
	{
		switch ( level.nv.titanExitEnabled )
		{
			case eTitanExitEnabled.Never:
				announcementDuration = 5.0
				totalDuration += announcementDuration
				delaythread( totalDuration ) PlayConversationToLocalClient( "NoDisembark" )
				break

			case eTitanExitEnabled.DisembarkOnly:
				announcementDuration = 5.0
				totalDuration += announcementDuration
				delaythread( totalDuration ) PlayConversationToLocalClient( "NoEject" )
				break
		}
	}

	file.gameModeAnnounced = true
}

function ShouldPlayRankAnnouncement( player )
{
	if ( !MatchSupportsRankedPlay() )
		return false

	if ( !PlayerPlayingRanked( player ) )
		return false

	if ( TooLateForRanked() )
		return false

	// Don't enable at epilogue or later
	local gameState = GetGameState()
	if ( gameState >= eGameState.Epilogue )
		return false

	return true
}

function UpdateSubText2ForRiffs( announcement )
{
	local riffTexts = []

	if ( IsPilotEliminationBased() )
		riffTexts.append( "#GAMESTATE_NO_RESPAWNING" )

	if (  Riff_FloorIsLava() )
		riffTexts.append( "#GAMEMODE_FLOOR_IS_LAVA_SUBTEXT2" )

	if ( level.nv.minimapState == eMinimapState.Hidden )
		riffTexts.append( "#GAMESTATE_NO_MINIMAP" )

	if ( level.nv.ammoLimit == eAmmoLimit.Limited )
		riffTexts.append( "#GAMESTATE_LIMITED_AMMUNITION" )

	if ( level.nv.titanAvailability != eTitanAvailability.Default )
	{
		switch ( level.nv.titanAvailability )
		{
			case eTitanAvailability.Always:
				riffTexts.append( "#GAMESTATE_UNLIMITED_TITANS" )
				break
			case eTitanAvailability.Once:
				riffTexts.append( "#GAMESTATE_ONE_TITAN" )
				break
			case eTitanAvailability.Never:
				riffTexts.append( "#GAMESTATE_NO_TITANS" )
				break
		}
	}

	if ( level.nv.allowNPCs != eAllowNPCs.Default )
	{
		switch ( level.nv.allowNPCs )
		{
			case eAllowNPCs.None:
				riffTexts.append( "#GAMESTATE_NO_MINIONS" )
				break

			case eAllowNPCs.GruntOnly:
				riffTexts.append( "#GAMESTATE_GRUNTS_ONLY" )
				break

			case eAllowNPCs.SpectreOnly:
				riffTexts.append( "#GAMESTATE_SPECTRES_ONLY" )
				break
		}
	}

	local pilotHealth = GetCurrentPlaylistVarInt( "pilot_health", 0 )
	if ( pilotHealth != 0 && pilotHealth < 200 )
		riffTexts.append( "#GAMESTATE_LOW_PILOT_HEALTH" )
	else if ( pilotHealth > 200 )
		riffTexts.append( "#GAMESTATE_HIGH_PILOT_HEALTH" )

	if ( level.nv.titanExitEnabled != eTitanExitEnabled.Default )
	{
		switch ( level.nv.titanExitEnabled )
		{
			case eTitanExitEnabled.Never:
				riffTexts.append( "#GAMESTATE_NO_EJECT" )
				//riffTexts.append( "#GAMESTATE_NO_DISEMBARK" )
				break

			case eTitanExitEnabled.DisembarkOnly:
				riffTexts.append( "#GAMESTATE_NO_EJECT" )
				break
		}
	}

	switch ( riffTexts.len() )
	{
		case 1:
			announcement.SetSubText2( riffTexts[0] )
			break
		case 2:
			announcement.SetSubText2( "#GAMEMODE_ANNOUNCEMENT_SUBTEXT_2", riffTexts[0], riffTexts[1] )
			break
		case 3:
			announcement.SetSubText2( "#GAMEMODE_ANNOUNCEMENT_SUBTEXT_3", riffTexts[0], riffTexts[1], riffTexts[2] )
			break
		case 4:
			announcement.SetSubText2( "#GAMEMODE_ANNOUNCEMENT_SUBTEXT_4", riffTexts[0], riffTexts[1], riffTexts[2], riffTexts[3] )
			break
		case 5:
			announcement.SetSubText2( "#GAMEMODE_ANNOUNCEMENT_SUBTEXT_5", riffTexts[0], riffTexts[1], riffTexts[2], riffTexts[3], riffTexts[4] )
			break

		default:
			announcement.SetSubText2( "", "" )
			return 0
	}

	return riffTexts.len()
}

function ClientCodeCallback_ControllerModeChanged( controllerModeEnabled )
{
	local player = GetLocalClientPlayer()
	if ( IsValid( player ) )
		player.Signal( "ControllerModeChanged" )
}


function DrawTitanCoreMeter( player, coreBar, coreTimeRemaining )
{
	Assert( player.IsTitan() )
	local soul = player.GetTitanSoul()

	if ( soul && Time() < soul.GetCoreChargeExpireTime() )
	{
		local titanType = GetSoulTitanType( soul )
		local expireTime = soul.GetCoreChargeExpireTime()
		local activeTime = GetTitanCoreActiveTime( player )
		local chargeTime = TITAN_CORE_CHARGE_TIME

		local totalTime = activeTime + chargeTime
		local startTime = expireTime - totalTime

		// charging
		if ( Time() <= expireTime - activeTime )
		{
			coreBar.SetColor( 255, 120, 120, 255 )

			local progress = GraphCapped( Time(), startTime, startTime + chargeTime, 0.0, 1.0 )
			local remainingTime = (startTime + chargeTime) - Time()

			coreBar.SetBarProgressOverTime( progress, 1.0, remainingTime )
		}
		else //active
		{
			coreBar.SetColor( SHIELD_BOOST_R, SHIELD_BOOST_G, SHIELD_BOOST_B, 255 )

			local progress = GraphCapped( Time(), startTime + chargeTime, expireTime, 0.0, 1.0 )
			local remainingTime = expireTime - Time()

			coreBar.SetBarProgressOverTime( 1 - progress, 0.0, remainingTime )
		}

		coreBar.Show()
	}
	else
	{
		coreBar.Hide()
	}

	wait 0.5

	return


	/*
	if ( coreTimeRemaining > TITAN_CORE_ACTIVE_TIME - 2.0 )
	{
		coreBar.SetColor( 200, 0, 0, 255 )
		// bar fades in
		coreBar.SetScale( 1.0, 0 )
		coreBar.Show()

		coreBar.ScaleOverTime( 1.0, 1.0, 0.5, INTERPOLATOR_DEACCEL )

		coreBar.SetBarProgress( 0.0 )

		wait 0.4

		coreBar.SetBarProgressOverTime( 0.0, 1.0, 0.5 )
		wait 0.5
		coreBar.ColorOverTime( 205, 255, 205, 255, 0.4, INTERPOLATOR_DEACCEL )
		wait 0.3
	}
	*/

	local r, g, b

	if ( titanType == "ogre" )
	{
		r = 255
		g = 235
		b = 155
	}
	else
	{
		r = 205
		g = 255
		b = 205
	}

	coreBar.Show()
	local coreDuration = GetTitanCoreActiveTime( player )

	if ( coreTimeRemaining > coreDuration - 2.0 )
	{
		coreBar.SetColor( 255, 120, 120, 255 )
		// bar fades in
		coreBar.SetScale( 1.0, 0 )

		coreBar.ScaleOverTime( 1.0, 1.0, 0.5, INTERPOLATOR_DEACCEL )

		coreBar.SetBarProgress( 0.0 )

		local barGrowTime = 0.4
		wait barGrowTime

		local warmupTime = TITAN_CORE_CHARGE_TIME - barGrowTime
		coreBar.SetBarProgressOverTime( 0.0, 1.0, warmupTime )
		wait warmupTime
		coreBar.ColorOverTime( r, g, b, 255, 0.5, INTERPOLATOR_DEACCEL )
	}
	else
	{
		coreBar.SetScale( 1.0, 1.0 )
		coreBar.SetColor( r, g, b, 255 )
	}

	coreTimeRemaining = GetTitanCoreTimeRemaining( player )
	if ( coreTimeRemaining == null )
		return

	local endTime = Time() + coreTimeRemaining

	coreBar.SetBarProgressOverTime( 1.0, 0.0, coreTimeRemaining )
	wait coreTimeRemaining

	coreBar.ScaleOverTime( 1.0, 0.0, 0.5, INTERPOLATOR_DEACCEL )
	wait 0.5
}

function ClientHudInit( player )
{
	Assert( player == GetLocalClientPlayer() )

	player.cv.clientHud <- HudElement( "ClientHud" )
	player.cv.clientHud.s.mainVGUI <- CNotAVGUI( player.cv.clientHud )
	player.cv.hud <- CNotAVGUI( Hud )

	// Attempt to fix 55322 - this wait does not seem needed anymore based on testing
	//while ( !("playerScriptsInitialized" in player.s) )
	//	wait 0

	MainHud_InitAnnouncement( player.cv.hud, player )

	local mainVGUI = player.cv.clientHud.s.mainVGUI

	local scoreGroup = HudElementGroup( "scoreboardProgress" )
	thread MainHud_InitScoreBars( mainVGUI, player, scoreGroup )
	thread MainHud_InitEpilogue( mainVGUI, player )
	thread MainHud_InitObjective( mainVGUI, player )

	if ( PlayerPlayingRanked( player ) )
	{
		local rankedHud = HudElement( "RankedHud", player.cv.clientHud )
		InitRankedPanel( mainVGUI.s.scoreboardProgressBars, scoreGroup, rankedHud )
	}

	foreach ( callbackInfo in level.mainHudCallbacks )
		callbackInfo.func.acall( [callbackInfo.scope, mainVGUI, player] )

	UpdateClientHudVisibility( player )
}

function CinematicEventFlagChanged( player )
{
	if ( player == GetLocalClientPlayer() )
		UpdateClientHudVisibility( player )
}

function UpdateClientHudVisibilityCallback()
{
	UpdateClientHudVisibility( GetLocalClientPlayer() )
}

function UpdateClientHudVisibility( player )
{
	Assert( player == GetLocalClientPlayer() )

	if ( player == null || !IsValid( player ) )
		return

	if ( ShouldClientHudBeVisible( player ) )
		player.cv.clientHud.Show()
	else
		player.cv.clientHud.Hide()
}

function ShouldClientHudBeVisible( player )
{
	if ( !ShouldMainHudBeVisible( player ) )
		return false

	if ( GetGameState() < eGameState.Playing )
		return false

	if ( IsWatchingKillReplay() )
		return false

	if ( IsAlive( player ) )
		return false

	return true
}

function VarChangedCallback_GameStateChanged()
{
	UpdateClientHudVisibility( GetLocalClientPlayer() )
}

function AttritionThink( vgui )
{
	vgui.EndSignal( "OnDestroy" )

	local sigTable
	local scoreVal
	local lastScoreTime = 0

	for ( ;; )
	{
		sigTable = level.ent.WaitSignal( "AttritionPoints" )

		local player = GetLocalClientPlayer()

		if ( sigTable.attacker != player )
			continue

		if ( Time() - lastScoreTime < 3.0 )
			scoreVal += sigTable.scoreVal
		else
			scoreVal = sigTable.scoreVal
		lastScoreTime = Time()

		local label = vgui.s.scoreboardProgressBars.ScorePopupLabel
		label.SetText( "#ATTRITION_POINT_POPUP", scoreVal )
		thread AttritionScorePopup( vgui, label )
	}
}

function AttritionScorePopup( vgui, label )
{
	EndSignal( vgui, "OnDestroy" )
	Signal( label, "AttritionPopup" )
	EndSignal( label, "AttritionPopup" )

	local basePos = label.GetBasePos()

	label.ReturnToBasePos()
	label.ReturnToBaseColor()
	label.Show()
	wait 1.0
	label.MoveOverTime( basePos[0], basePos[1] - 30, 0.3, INTERPOLATOR_ACCEL )
	label.FadeOverTime( 0, 0.3 )
	wait 0.3
	label.Hide()
}


function UpdateLastTitanStanding()
{
	GetLocalClientPlayer().Signal( "UpdateLastTitanStanding" )
}

function TitanEliminationThink( vgui, player )
{
	vgui.EndSignal( "OnDestroy" )
	player.EndSignal( "OnDestroy" )

	if ( player != GetLocalClientPlayer() )
		return

	OnThreadEnd(
		function() : ( player )
		{
			if ( !IsValid( player ) )
				return

			if ( player.cv.hud.s.lastEventNotificationText == "#GAMEMODE_CALLINTITAN_COUNTDOWN" )
				ClearEventNotification()
		}
	)

	while ( true )
	{
		if ( Riff_EliminationMode() == eEliminationMode.Titans )
		{
			if ( IsAlive( player ) && GamePlayingOrSuddenDeath() && level.nv.secondsTitanCheckTime > Time() && !player.IsTitan() && !IsValid( player.GetPetTitan() ) && player.GetNextTitanRespawnAvailable() >= 0 )
			{
				SetTimedEventNotificationHATT( level.nv.secondsTitanCheckTime - Time(), "#GAMEMODE_CALLINTITAN_COUNTDOWN", HATT_GAME_COUNTDOWN_SECONDS_MILLISECONDS, level.nv.secondsTitanCheckTime )
			}
			else if ( player.cv.hud.s.lastEventNotificationText == "#GAMEMODE_CALLINTITAN_COUNTDOWN" )
			{
				ClearEventNotification()
			}
		}
		else if ( Riff_EliminationMode() == eEliminationMode.Pilots )
		{

		}

		WaitSignal( player, "UpdateLastTitanStanding", "PetTitanChanged", "OnDeath" )
	}
}



function ExfiltrationThink( vgui, player )
{
	vgui.EndSignal( "OnDestroy" )
	player.EndSignal( "OnDestroy" )

	while ( true )
	{
		//vgui.s.scoreboardProgressBars.ScoreObjectiveSubText.Hide()

//		if ( level.nv.secondsTitanCheckTime > Time() )
//		{
//			vgui.s.scoreboardProgressBars.ScoreObjectiveText.Show()
//			vgui.s.scoreboardProgressBars.ScoreObjectiveText.SetAutoText( "#HUDAUTOTEXT_EVAC_COORDS", HATT_GAME_COUNTDOWN_SECONDS_MILLISECONDS, level.nv.secondsTitanCheckTime )
//			vgui.s.scoreboardProgressBars.ScoreObjectiveText.EnableAutoText()
//		}
//		else
//		{
//			vgui.s.scoreboardProgressBars.ScoreObjectiveText.Hide()
//		}

		player.WaitSignal( "UpdateLastTitanStanding" )
	}
}

function InitChatHUD()
{
	local chat = HudElement( "IngameTextChat" )

	if ( IsLobby() )
	{
		chat.Hide()
		return
	}

	ToggleChatVisibility()

	local screenSize = Hud.GetScreenSize()
	local resMultiplier = screenSize[1] / 480.0
	local width = 280
	local height = 100

	if ( GameRules.GetGameMode() == "cp" )
		height = 77
	else if ( GameRules.GetGameMode() == "ctf" )
		height = 65

	chat.SetSize( width * resMultiplier, height * resMultiplier )
}

function ToggleChatVisibility()
{
	local chat = HudElement( "IngameTextChat" )

	if ( GetConVarBool( "delta_hud_show_chat" ) )
		chat.Show()
	else
		chat.Hide()

	printt( "toggled chat")
}
Globalize( ToggleChatVisibility )

function GetCustomMinimapZoom()
{
	return level.customMinimapZoom
}
Globalize( GetCustomMinimapZoom )

function SetCustomMinimapZoom( value )
{
	level.customMinimapZoom = value
	SetMinimapZoomOverride( level.customMinimapZoom )
}
Globalize( SetCustomMinimapZoom )

function ToggleCockpitElementsVisibility()
{
	if ( IsLobby() )
		return

	local player = GetLocalClientPlayer()
	if ( !IsValid( player ) )
		return

	local cockpit = player.GetCockpit()
	if ( !IsValid( cockpit ) )
		return

	if ( ShouldShowXPBar( player ) )
		cockpit.s.xpBarGroup.Show()
	else
		cockpit.s.xpBarGroup.Hide()
}
Globalize( ToggleCockpitElementsVisibility )