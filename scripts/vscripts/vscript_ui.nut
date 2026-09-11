// Events for handlers
// UIE_CLICK
// UIE_GET_FOCUS
// UIE_LOSE_FOCUS

const MAINMENU_MUSIC_DELAY = 4.0

function IncludeScript( name, scope = null )
{
	if ( scope == null )
	{
		scope = this;
	}
	return ::DoIncludeScript( name, scope );
}

VPKNotifyFile( "media/intro_captions.txt" )

IncludeScript( "_utility_ui" )
IncludeScript( "_utility_shared_all" )
IncludeScript( "_settings" ) // UI script doesn't need everything in this, reorganize
IncludeScript( "_ui_vars" )
IncludeFile( "_persistentdata" )
IncludeFile( "_items" )
IncludeFile( "_playlist" )
IncludeFile( "_ranked_shared" )

IncludeFile( "_passives_shared" )
IncludeFile( "_burncards_shared" )
IncludeFile( "menu/_burncards_menu" )
IncludeFile( "_black_market_shared" )
IncludeFile( "_challenges_shared")
IncludeScript( "_loadouts" )
IncludeFile( "_stats_shared" )
IncludeFile( "_challenges_content")
IncludeFile( "_xp" )
IncludeFile( "ui/_footer" )
IncludeScript( "ui/menu_dev" )

IncludeScript( "ui/_loadout_shared" )
IncludeFile( "ui/menu_image_walk_through" )
IncludeFile( "ui/menu_main" )
IncludeFile( "ui/menu_serverbrowser" )
IncludeFile( "ui/menu_addons")
IncludeFile( "ui/menu_hud_settings" )
IncludeFile( "ui/menu_hud_settings_r1d" )
IncludeFile( "ui/menu_vote" )
IncludeFile( "ui/menu_vote_target" )
IncludeFile( "ui/menu_options" )
IncludeFile( "ui/menu_black_market_main" )
IncludeFile( "ui/menu_black_market" )
IncludeFile( "ui/ui_black_market_perish" )
IncludeFile( "ui/ui_ranked" )
IncludeScript( "ui/menu_loadout_pilot" )
IncludeScript( "ui/menu_loadout_titan" )
IncludeFile( "ui/menu_loadout_pickcard" )
IncludeFile( "ui/menu_burncards_ingame" )
IncludeFile( "ui/menu_edit_loadout_pilot" )
IncludeFile( "ui/menu_edit_loadout_titan" )
IncludeFile( "ui/menu_lobby" )
IncludeFile( "ui/menu_ingame" )
IncludeFile( "ui/menu_ranked_play" )
IncludeFile( "ui/menu_ranked_invite" )
IncludeFile( "ui/menu_ranked_tiers" )
IncludeFile( "ui/menu_ranked_seasons" )
IncludeScript( "ui/menu_stats_utility" )
IncludeScript( "ui/menu_stats" )
IncludeScript( "ui/menu_stats_overview" )
IncludeScript( "ui/menu_stats_kills" )
IncludeScript( "ui/menu_stats_time" )
IncludeScript( "ui/menu_stats_distance" )
IncludeScript( "ui/menu_stats_weapons" )
IncludeScript( "ui/menu_stats_levels" )
IncludeScript( "ui/menu_stats_misc" )
IncludeFile( "ui/menu_gamepad_controls" )
IncludeFile( "ui/menu_gamepad_layout" )
IncludeScript( "ui/menu_challenges" )
IncludeFile( "ui/menu_classic" )
IncludeFile( "ui/menu_party_coop" )
IncludeFile( "ui/menu_party_coopcustom" )
IncludeScript( "ui/menu_dialog" )
IncludeFile( "ui/_menu_utility" )
IncludeFile( "ui/menu_eog_xp" )
IncludeFile( "ui/menu_eog_coins" )
IncludeFile( "ui/menu_eog_mapstars" )
IncludeFile( "ui/menu_eog_challenges" )
IncludeFile( "ui/menu_eog_unlocks" )
IncludeFile( "ui/menu_eog_coop" )
IncludeFile( "ui/menu_eog_scoreboard" )
IncludeFile( "ui/menu_eog_ranked" )
IncludeFile( "ui/menu_advanced_video_settings" )
IncludeFile( "ui/menu_mouse_keyboard_controls" )
IncludeFile( "ui/menu_mouse_keyboard_bindings" )
IncludeFile( "ui/menu_audio_settings" )
IncludeFile( "ui/menu_intro" )
IncludeFile( "ui/menu_generation_respawn" )
IncludeFile( "ui/menu_advocate_letter" )
IncludeFile( "ui/menu_credits" )
IncludeFile( "ui/menu_map_select" )
IncludeFile( "ui/menu_mode_select" )
IncludeFile( "ui/menu_mode_variants" )
IncludeFile( "ui/menu_ranked_mode_info" )
IncludeScript( "_pdef_client" )

IncludeScript( "_vote_shared_all" )

function main()
{
	uiGlobal <- {}
	uiGlobal.menus <- {}
	uiGlobal.allMenus <- []
	uiGlobal.menuStack <- []
	uiGlobal.loadingLevel <- null
	uiGlobal.loadedLevel <- null
	uiGlobal.previousLevel <- null
	uiGlobal.previousPlaylist <- null
	uiGlobal.activeMenu <- null
	uiGlobal.activeDialog <- null
	uiGlobal.preDialogFocus <- null
	uiGlobal.eventHandlersAdded <- false
	uiGlobal.itemsInitialized <- false
	uiGlobal.matchmaking <- false
	uiGlobal.dialogCloseCallback <- null
	uiGlobal.navigateBackCallbacks <- {}
	uiGlobal.signalDummy <- {}
	uiGlobal.forceDialogChoice <- false
	uiGlobal.dialogInputEnableTime <- null
	uiGlobal.loadoutSelectionFinished <- false
	uiGlobal.lobbyMenusLeftOpen <- false
	uiGlobal.weaponStatListType <- null
	uiGlobal.blackMarketItemType <- null
	uiGlobal.EOGAutoAdvance <- true
	uiGlobal.playerOpenedEOG <- false
	uiGlobal.playingMusic <- false
	uiGlobal.viewedGameSummary <- true
	uiGlobal.installComplete <- true
	uiGlobal.toggleLoadoutGameModeButtonRegistered <- false
	uiGlobal.gamemodeLoadoutBeingEdited <- "at"
	uiGlobal.currentEditLoadoutMenuName <- null
	uiGlobal.EOGChallengeFilter <- null
	uiGlobal.matchLobbyBackgroundIndex <- -1
	uiGlobal.showingEULA <- false
	uiGlobal.mainMenuFocus <- null
	uiGlobal.eogCoopFocusedButton <- null
	uiGlobal.eogCoopSelectedButton <- null
	uiGlobal.eogScoreboardFocusedButton <- null
	uiGlobal.eogNavigationButtonsRegistered <- false
	uiGlobal.eogCoopQuickMatchButtonRegistered <- false
	uiGlobal.starsPanelVisible <- false
	uiGlobal.ui_ChallengeProgress <- {}
	uiGlobal.doTraining <- false
	uiGlobal.setServerPublicNextPrivateLobby <- false
	uiGlobal.selectedVote <- -1

	RegisterSignal( "LevelShutdown" )
	RegisterSignal( "CleanupInGameMenus" )
	RegisterSignal( "OnCloseLobbyMenu" )
	RegisterSignal( "OnCancelConnect" )
	RegisterSignal( "PlayVideoEnded" )
	RegisterSignal( "ActiveMenuChanged" )
	RegisterSignal( "LevelFinishedLoading")

	if ( Durango_IsDurango() )
		thread UpdateInstallStatus()

	InitGamepadConfigs()
	InitPresetLoadouts()
	InitEmptyCustomLoadouts()
	InitMenus()
	InitFooterButtons()

	SmartGlass_SetGameState( "MainMenu" )
	SmartGlass_SetScriptVersion( 1 )


	//RegisterButtonPressedCallback( BUTTON_SHOULDER_LEFT, ButtonCallback_MenuShoulderLeft )
	//RegisterButtonPressedCallback( BUTTON_SHOULDER_RIGHT, ButtonCallback_MenuShoulderRight )
}

function UpdateInstallStatus()
{
	uiGlobal.installComplete = Durango_IsGameFullyInstalled()

	while( !uiGlobal.installComplete )
	{
		wait 1
		uiGlobal.installComplete = Durango_IsGameFullyInstalled()
	}
}

function DebugOpenEOG( page )
{
	level.EOG_DEBUG = true
	if ( page == 1 )
		AdvanceMenu( GetMenu( "EOG_XP" ) )
	else if ( page == 2 )
		AdvanceMenu( GetMenu( "EOG_Unlocks" ) )
	else if ( page == 3 )
		AdvanceMenu( GetMenu( "EOG_Challenges" ) )
	else if ( page == 4 )
		AdvanceMenu( GetMenu( "EOG_Scoreboard" ) )
	else if ( page == 5 )
		AdvanceMenu( GetMenu( "EOG_Ranked" ) )
	else if ( page == 6 )
		AdvanceMenu( GetMenu( "EOG_Coop" ) )
}

// TODO: Put open menus on the stack
function AdvanceMenu( menu, replaceCurrent = false, enableBlur = true, doReplaceCurrentPop = true )
{
	//foreach ( index, men in uiGlobal.menuStack )
	//{
	//	if ( men != null )
	//		printt( "menu index " + index + " is named " + men.GetName() )
	//}

	if ( uiGlobal.activeMenu )
	{
		// Don't open the same menu again if it's already open
		if ( uiGlobal.activeMenu == menu )
		{
			printt( "attempted to reopen active menu", menu.GetName() )
			return
		}

		SetBlurEnabled( false )
		if ( replaceCurrent )
		{
			CloseMenuWrapper( uiGlobal.activeMenu )

			// Done to prevent some random obscure bug due to buttoncallbacks
			if ( doReplaceCurrentPop )
				uiGlobal.menuStack.pop()

			printt( "above closed for", menu.GetName(), "to open" )
		}
		else
		{
			CloseMenu( uiGlobal.activeMenu )
			if ( menu )
				printt( uiGlobal.activeMenu.GetName(), "menu closed (AdvanceMenu) for", menu.GetName(), "to open" )
			else
				printt( uiGlobal.activeMenu.GetName(), "menu closed (AdvanceMenu) for", menu, "to open" )

			foreach ( index, openMenu in uiGlobal.menuStack )
			{
				if ( openMenu )
					printt( "\t", index, openMenu.GetName() )
				else
					printt( "\t", index, openMenu )
			}
		}
	}

	uiGlobal.menuStack.push( menu )
	uiGlobal.activeMenu = menu

	if ( uiGlobal.activeMenu )
	{
		if ( enableBlur )
		SetBlurEnabled( true )
		OpenMenuWrapper( uiGlobal.activeMenu, true )
	}

	Signal( uiGlobal.signalDummy, "ActiveMenuChanged" )
}

function OpenSubmenu( menu, updateMenuPos = true )
{
	Assert( menu )
	Assert( menu.GetType() == "submenu" )

	if ( uiGlobal.activeMenu )
	{
		// Don't open the same menu again if it's already open
		if ( uiGlobal.activeMenu == menu )
			return

		SaveFocusedItemForReopen( uiGlobal.activeMenu )
	}

	local submenuPos = GetFocus().GetAbsPos()

	uiGlobal.menuStack.push( menu )
	uiGlobal.activeMenu = menu

	OpenMenuWrapper( uiGlobal.activeMenu, true )

	if ( updateMenuPos )
	{
		if ( menu != GetMenu( "TitanOSSelectMenu" ) )
			uiGlobal.activeMenu.SetPos( 0, submenuPos[1] )
	}

	Signal( uiGlobal.signalDummy, "ActiveMenuChanged" )
}

function CloseSubmenu( openStackMenu = true )
{
	if ( !uiGlobal.activeMenu )
		return

	if ( uiGlobal.activeMenu.GetType() != "submenu" )
		return

	CloseMenuWrapper( uiGlobal.activeMenu )
	uiGlobal.menuStack.pop()

	if ( uiGlobal.menuStack.len() )
	{
		uiGlobal.activeMenu = uiGlobal.menuStack.top()

		// This runs any OnOpen function for the menu and sets focus, but doesn't actually open the menu because it is already open
		if ( openStackMenu )
			OpenMenuWrapper( uiGlobal.activeMenu, false )
	}
	else
		uiGlobal.activeMenu = null

	Signal( uiGlobal.signalDummy, "ActiveMenuChanged" )
}

function CloseTopMenu()
{
	if ( uiGlobal.activeMenu )
	{
		SetBlurEnabled( false )
		CloseMenuWrapper( uiGlobal.activeMenu )
	}

	uiGlobal.menuStack.pop()
	if ( uiGlobal.menuStack.len() )
		uiGlobal.activeMenu = uiGlobal.menuStack.top()
	else
		uiGlobal.activeMenu = null

	if ( uiGlobal.activeMenu )
	{
		OpenMenuWrapper( uiGlobal.activeMenu, false )
		SetBlurEnabled( true )
	}

	Signal( uiGlobal.signalDummy, "ActiveMenuChanged" )
}

function CloseAllMenus()
{
	if ( uiGlobal.activeDialog )
		CloseDialog( true )

	if ( uiGlobal.activeMenu )
	{
		SetBlurEnabled( false )
		CloseMenuWrapper( uiGlobal.activeMenu )
	}

	uiGlobal.menuStack = []
	uiGlobal.activeMenu = null

	Signal( uiGlobal.signalDummy, "ActiveMenuChanged" )
}

function CloseAllInGameMenus()
{
	if ( uiGlobal.activeDialog )
		CloseDialog( true )

	if ( uiGlobal.activeMenu )
	{
		if ( uiGlobal.activeMenu.GetType() == "submenu" )
			CloseSubmenu( false )

		SetBlurEnabled( false )
		CloseMenuWrapper( uiGlobal.activeMenu )
	}

	// We close the menus until we reach the null menu that was placed in the stack when a level was loaded.
	while ( uiGlobal.menuStack.len() && uiGlobal.menuStack.top() )
		uiGlobal.menuStack.pop()

	if ( uiGlobal.menuStack.len() )
		uiGlobal.activeMenu = uiGlobal.menuStack.top()
	else
		uiGlobal.activeMenu = null

	if ( uiGlobal.activeMenu )
	{
		OpenMenuWrapper( uiGlobal.activeMenu, false )
		SetBlurEnabled( true )
	}

	Signal( uiGlobal.signalDummy, "ActiveMenuChanged" )

	if ( IsConnected() && !IsLobby() )
		ClientCommand( "InGameMenuClosed" )
	}

function PrintMenuStack()
{
	foreach ( menu in uiGlobal.menuStack )
	{
		if ( menu )
			printt( menu.GetName() )
		else
			printt( "null" )
	}
}

function UICodeCallback_ActivateMenus()
{
	//local tempName = uiGlobal.activeMenu != null ? uiGlobal.activeMenu.GetName() : "null"
	//printt( "UICodeCallback_ActivateMenus called, uiGlobal.activeMenu: " + tempName )

	if ( IsConnected() )
		return

	if ( uiGlobal.matchmaking )
		CloseDialog( true )

	if ( uiGlobal.lobbyMenusLeftOpen )
	{
		uiGlobal.lobbyMenusLeftOpen = false
		CleanupInGameMenus()
	}

	if ( uiGlobal.activeDialog )
		CloseDialog( true )

	if ( uiGlobal.activeMenu == null || InGameMenusInMenuStack() || uiGlobal.activeMenu != GetMenu( "MainMenu" ) )
	{
		CloseAllMenus()
		AdvanceMenu( GetMenu( "MainMenu" ) )
	}

	PlayMusic()

	if ( Durango_IsDurango() )
	{
		SmartGlass_SetGameState( "MainMenu" )
		Durango_LeaveParty()
	}
}

function InGameMenusInMenuStack()
{
	foreach ( menu in uiGlobal.menuStack )
	{
		if ( menu == GetMenu( "InGameMenu" ) )
			return true
	}

	return false
}

function UICodeCallback_ToggleInGameMenu()
{
	local activeLevel = GetActiveLevel()

	// defensive shipping hack, null shouldn't be possible but with demo playback it somehow can be
	if ( activeLevel == "" || activeLevel == null )
	{
		printl( "activeLevel is \"" + activeLevel + "\" in UICodeCallback_ToggleInGameMenu(); ignoring" )
		return
	}

	if ( uiGlobal.activeDialog != null || activeLevel == "mp_lobby" )
		return

	if ( uiGlobal.activeMenu == null )
	{
		if ( IsLevelMultiplayer( activeLevel ) && !IsTrainingLevel() )
			AdvanceMenu( GetMenu( "InGameMenu" ) )
		else
			AdvanceMenu( GetMenu( "InGameSPMenu" ) )
	}
	else
	{
		if ( !uiGlobal.loadoutSelectionFinished )
			return

		CloseAllInGameMenus()
	}
}

function UICodeCallback_LevelLoadingStarted( levelname )
{
	printt( "UICodeCallback_LevelLoadingStarted: " + levelname )

	if ( uiGlobal.matchmaking )
		CloseDialog( false )

	if ( uiGlobal.showingEULA && uiGlobal.activeDialog == GetMenu( "ChoiceDialog" ) )
		CloseDialog()

	//printt( "UICodeCallback_LevelLoadingStarted: " + levelname )

	uiGlobal.loadingLevel = levelname

	StopMusic()

	if ( uiGlobal.playingIntro )
		Signal( uiGlobal.signalDummy, "PlayVideoEnded" )

	if ( uiGlobal.playingCredits )
		Signal( uiGlobal.signalDummy, "PlayingCreditsDone" )

	if ( levelname == "mp_lobby" )
	{
		if ( uiGlobal.loadedLevel == "mp_lobby" )
		{
			// lobbyMenusLeftOpen might still be false if we're getting LevelLoadingStarted before the previous level's LevelShutdown.
			if ( !uiGlobal.lobbyMenusLeftOpen )
				ExitLobbyLeaveMenusOpen()
		}
	}
	else if ( levelname == "mp_npe" && IsTrainingMode() )
	{
		if ( !GetTrainingHasEverBeenStartedUI() )
		{
			printt( "setting training has been started" )
			SetTrainingHasEverBeenStarted()
			SetPlayerTrainingResumeChoice( eTrainingModules.BEDROOM )
		}
	}
	else if ( levelname != "" )
	{
		SmartGlass_SetGameState( "Loading" )
		if ( IsConnected() )
			SmartGlass_SetGlobalProperty( SMARTGLASS_PROP_PLAYERTEAM, TeamIDToSmartGlassString( GetTeam() ) )

		if ( uiGlobal.lobbyMenusLeftOpen )
		{
			uiGlobal.lobbyMenusLeftOpen = false
			CleanupInGameMenus()
		}
	}

	// Return true to show load screen, false to not show load screen.
	if ( uiGlobal.lobbyMenusLeftOpen )
		return false

	return true
}

function UICodeCallback_UpdateLoadingLevelName( levelname )
{
	printt( "UICodeCallback_UpdateLoadingLevelName: " + levelname )

	if ( uiGlobal.lobbyMenusLeftOpen && levelname != "mp_lobby" )
	{
		uiGlobal.lobbyMenusLeftOpen = false
		CleanupInGameMenus()
	}

	// Return true to show load screen, false to not show load screen.
	if ( uiGlobal.lobbyMenusLeftOpen )
		return false
	SendDiscordUI(levelname)
	return true
}

function UICodeCallback_LevelLoadingFinished( error )
{
	printt( "UICodeCallback_LevelLoadingFinished: " + uiGlobal.loadingLevel + " (" + error + ")" )

	if ( uiGlobal.lobbyMenusLeftOpen )
	{
		uiGlobal.lobbyMenusLeftOpen = false

		printt( "uiGlobal.lobbyMenusLeftOpen:" )
		printt( " Active dialog: " + uiGlobal.activeDialog )
		if ( uiGlobal.activeDialog )
			printt( " Active dialog name: " + uiGlobal.activeDialog.GetName() )

		Assert( uiGlobal.activeDialog == GetMenu( "LobbyTransition" ) )
		if ( error )
			CleanupInGameMenus()
		else
			CloseDialog()


		if ( uiGlobal.activeMenu == GetMenu( "CoopPartyCustomMenu" ) )
			CloseTopMenu()
		if ( uiGlobal.activeMenu == GetMenu( "CoopPartyMenu" ) )
			CloseTopMenu()
		// Close these menus if they were open
		if ( uiGlobal.activeMenu == GetMenu( "ClassicMenu" ) ||
				uiGlobal.activeMenu == GetMenu( "MapsMenu" ) ||
				uiGlobal.activeMenu == GetMenu( "ModesMenu" ) ||
				uiGlobal.activeMenu == GetMenu( "MatchSettingsMenu" ) )
		{
			CloseTopMenu()
		}
	}

	if ( !IsLobby() )
		InitRankGracePeriodEndTime()

	if( uiGlobal.setServerPublicNextPrivateLobby )
	{
		uiGlobal.setServerPublicNextPrivateLobby <- false
		ClientCommand( "hide_server 0" )
	}

	uiGlobal.loadingLevel = null
	Signal( uiGlobal.signalDummy, "LevelFinishedLoading" )
	if ( IsConnected() )
		SmartGlass_SetGlobalProperty( SMARTGLASS_PROP_PLAYERTEAM, TeamIDToSmartGlassString( GetTeam() ) )
}

function UICodeCallback_LevelInit( levelname )
{
	Assert( IsConnected() )

	StopVideo()

	uiGlobal.loadedLevel = levelname
	uiGlobal.viewedGameSummary = false

	printt( "UICodeCallback_LevelInit: " + uiGlobal.loadedLevel )

	if ( IsConnected() )
		SmartGlass_SetGlobalProperty( SMARTGLASS_PROP_PLAYERTEAM, TeamIDToSmartGlassString( GetTeam() ) )

	if ( !uiGlobal.itemsInitialized && IsLevelMultiplayer( levelname ) )
	{
		InitItems()
		uiGlobal.itemsInitialized <- true
		InitStatsTables()
		CreateChallenges()
	}

	if ( uiGlobal.matchmaking )
		CloseDialog( false )

	if ( uiGlobal.lobbyMenusLeftOpen )
	{
		if ( levelname == "mp_lobby" )
		{
			// We just came from mp_lobby, so don't reopen the menus.
			// We'll close them when the level load is finished.
			return
		}

		uiGlobal.lobbyMenusLeftOpen = false
		CleanupInGameMenus()
	}

	Assert( uiGlobal.activeMenu != null || uiGlobal.menuStack.len() == 0 )

	AdvanceMenu( null )

	if ( IsLevelMultiplayer( levelname ) )
	{
		InitLoadouts()
		UI_GetAllChallengesProgress()
		InitEOGMenus()

		local isLobby = (levelname == "mp_lobby")

		if ( !isLobby )
			SmartGlass_SetGameState( "Playing" )

	    local gameModeString = GetConVarString( "mp_gamemode" )
	    if ( gameModeString == null || gameModeString == "" )
	    	gameModeString = "<null>"

		if ( isLobby )
		{
		    AdvanceMenu( GetMenu( "LobbyMenu" ) )

		    if ( ShouldJumpToCoopPartyMenu() )
		    {
		    	AdvanceMenu( GetMenu( "ClassicMenu" ) )
		    	AdvanceMenu( GetMenu( "CoopPartyMenu" ) )
		    }

			if ( ShouldShowEOGSummary() )
				ShowEOGSummary()
	    }
	    else if ( !GetCinematicMode() && !IsTrainingLevel() )
	    {
		    ClearLoadoutSelectionFinished()
			printt("Hello WORLD HIhihihi")
		    if ( ShouldShowBurnCardMenu() )
		    	AdvanceMenu( GetMenu( "BurnCards_pickcard" ) )

			if ( gameModeString != PILOT_SKIRMISH && gameModeString != GUN_GAME ) //JFS. For R2 maybe try checking against Riff settings to see if Titans are disabled or not.
				AdvanceMenu( GetMenu( "TitanLoadoutsMenu" ) )

			if ( !IsTitanOnlyMode() && gameModeString != GUN_GAME )
				AdvanceMenu( GetMenu( "PilotLoadoutsMenu" ) )
	    }
	    else
	    {
		    SetLoadoutSelectionFinished()
	    }

		local gameModeId
		if ( isLobby && ( gameModeString == VARIETY_PACK || gameModeString == "all_mini" ) )
			gameModeId = gameModesStringToIdMap[CAMPAIGN]
		else
		{
			Assert( gameModeString in gameModesStringToIdMap, "'" + gameModeString + "' must exist in gameModesStringToIdMap table" )
			gameModeId = gameModesStringToIdMap[gameModeString]
		}

	    local mapId = eMaps.invalid
	    if ( levelname in getconsttable().eMaps )
	    {
	    	mapId = getconsttable().eMaps[ levelname ]
	    }
	    else
	    {
	    	if ( !ScriptExists( "test/" + levelname + ".nut" ) )
		    	CodeWarning( "No map named '" + levelname + "' exists in eMaps, all shipping maps should be in this enum" )
	    }

	    local difficultyLevelId = 0
	    local roundId = 0

	    if ( isLobby )
	    	Durango_OnLobbySessionStart( gameModeId, difficultyLevelId )
	    else
	    	Durango_OnMultiplayerRoundStart( gameModeId, mapId, difficultyLevelId, roundId, GetCinematicMode() )
	}

	uiGlobal.previousLevel = uiGlobal.loadedLevel
	uiGlobal.previousPlaylist = GetCurrentPlaylistName()
}

function SetLoadoutSelectionFinished()
{
	uiGlobal.loadoutSelectionFinished = true

	ClientCommand( "InGameMenuClosed" )
}

function ClearLoadoutSelectionFinished()
{
	uiGlobal.loadoutSelectionFinished = false

	ClientCommand( "InGameMenuOpened" )
}

function CleanupInGameMenus()
{
	Signal( uiGlobal.signalDummy, "CleanupInGameMenus" )

	CloseAllInGameMenus()
	Assert( uiGlobal.activeMenu == null )
	if ( uiGlobal.menuStack.len() )
		CloseTopMenu()
}

function ExitLobbyLeaveMenusOpen()
{
	Assert( !uiGlobal.lobbyMenusLeftOpen )
	uiGlobal.lobbyMenusLeftOpen = true
	if ( uiGlobal.activeDialog )
		CloseDialog()
	OpenDialog_ForceChoice( GetMenu( "LobbyTransition" ), "#MATCHMAKING_TITLE_CONNECTING" )
	Assert( uiGlobal.activeDialog == GetMenu( "LobbyTransition" ) )
}

function UICodeCallback_LevelShutdown()
{
	Signal( uiGlobal.signalDummy, "LevelShutdown" )

	printt( "UICodeCallback_LevelShutdown: " + uiGlobal.loadedLevel )

	StopVideo()

	if ( uiGlobal.loadedLevel == "mp_lobby" )
	{
		// Don't close the menus yet. If the next level is mp_lobby, we'll want to have them still open.
		// If it's not, we'll shortly get a LevelInit callback and close them.
		if ( !uiGlobal.lobbyMenusLeftOpen )
			ExitLobbyLeaveMenusOpen()
	}
	else
	{
		// Avoid closing lobby menus in a rare case where UICodeCallback_LevelShutdown is called a second time.
		if ( !(uiGlobal.lobbyMenusLeftOpen && uiGlobal.loadedLevel == null) )
			CleanupInGameMenus()
	}

	uiGlobal.loadedLevel = null
}

function UICodeCallback_NavigateBack()
{
	if ( uiGlobal.activeDialog )
	{
		if ( !uiGlobal.forceDialogChoice )
		{
			if ( "navBackFunc" in uiGlobal.activeDialog.s && uiGlobal.activeDialog.s.navBackFunc != null )
				uiGlobal.activeDialog.s.navBackFunc.call( this )

			CloseDialog( true )
		}
	}
	else if ( uiGlobal.activeMenu )
	{
		if ( uiGlobal.activeMenu.GetType() == "default" )
		{
		    if ( uiGlobal.activeMenu == GetMenu( "MainMenu" ) )
		    {
		    	if ( Durango_IsDurango() )
		    		Durango_ShowAccountPicker()

		    	return
		    }
		    else if ( uiGlobal.activeMenu == GetMenu( "IntroMenu" ) || uiGlobal.activeMenu == GetMenu( "CreditsMenu" ) )
		    {
			    return
		    }
		    else if ( uiGlobal.activeMenu == GetMenu( "Generation_Respawn" ) )
			{
				OnCloseGenerationRespawnMenu()
				return
			}
			else if ( uiGlobal.activeMenu == GetMenu( "LobbyMenu" ) )
		    {
			    LeaveDialog()
		    }
		    else if ( uiGlobal.activeMenu == GetMenu( "AdvancedVideoSettingsMenu" ) )
		    {
	    		if ( uiGlobal.videoSettingsChanged )
	    			NavigateBackApplyVideoSettingsDialog()
				else
					CloseTopMenu()
		    }
		    else if ( uiGlobal.activeMenu == GetMenu( "MatchSettingsMenu" ) )
		    {
	    		if ( !NavigateBackApplyMatchSettingsDialog() )
					CloseTopMenu()
		    }
		    else if ( uiGlobal.activeMenu == GetMenu( "MouseKeyboardBindingsMenu" ) )
		    {
		    	if ( KeyBindings_NeedApply( uiGlobal.activeMenu ) )
	    			NavigateBackApplyKeyBindingsDialog()
	    		else
	    			CloseTopMenu()
			}
			else if ( uiGlobal.activeMenu == GetMenu( "CoopPartyMenu" ) )
			{
				LeaveDialog()
			}
		    else
		    {
			    if ( uiGlobal.activeMenu in uiGlobal.navigateBackCallbacks )
			    {
				    if ( !uiGlobal.navigateBackCallbacks[ uiGlobal.activeMenu ]() )
					    return
			    }

				if ( "navBackFunc" in uiGlobal.activeMenu.s )
				{
					uiGlobal.activeMenu.s.navBackFunc.acall( [ uiGlobal.activeMenu.s.scope ] )
					printt( "Called navBackFunc for:", uiGlobal.activeMenu.GetName() )
					return
				}

			    CloseTopMenu()
		    }
	    }
		else if ( uiGlobal.activeMenu.GetType() == "submenu" )
		{
			uiGlobal.activeMenu.NavigateBack()
		}
	}
}

function AddMenu( blockName, resourceFile, displayName = null )
{
	uiGlobal.menus[blockName] <- CreateMenu( blockName, resourceFile )
	uiGlobal.menus[blockName].SetName( blockName )

	if ( displayName )
		uiGlobal.menus[blockName].SetDisplayName( displayName )
	else
		uiGlobal.menus[blockName].SetDisplayName( blockName )

	uiGlobal.allMenus.append( uiGlobal.menus[blockName ] )
}

function AddMenu_Named( blockName, menuName, resourceFile )
{
	uiGlobal.menus[menuName] <- CreateMenu( blockName, resourceFile )
	uiGlobal.menus[menuName].SetName( menuName )

	uiGlobal.allMenus.append( uiGlobal.menus[menuName ] )
}
function AddMenu_WithCreateFunc( blockName, resourceFile, createMenuFunc )
{
	uiGlobal.menus[blockName] <- createMenuFunc( blockName, resourceFile )
	uiGlobal.menus[blockName].SetName( blockName )

	uiGlobal.allMenus.append( uiGlobal.menus[blockName ] )
}

function AddSubmenu( blockName, resourceFile )
{
	uiGlobal.menus[blockName] <- CreateMenu( blockName, resourceFile )
	uiGlobal.menus[blockName].SetName( blockName )
	uiGlobal.menus[blockName].SetType( "submenu" )

	uiGlobal.menus[blockName].s.newFocusRef <- null

	uiGlobal.allMenus.append( uiGlobal.menus[blockName ] )
}

function GetMenu( menuName )
{
	return uiGlobal.menus[menuName]
}

function UICodeCallback_ControllerModeChanged( controllerModeEnabled )
{
	//printt( "CONTROLLER! " + controllerModeEnabled + ", " + IsControllerModeActive() )

	local menu = uiGlobal.activeMenu
	if ( !menu )
		return

	if ( "inputModeChangedFunc" in menu.s )
	{
		menu.s.inputModeChangedFunc.acall( [ menu.s.scope ] )
		printt( "Called inputModeChangedFunc for:", menu.GetName() )
		return
	}
}

function UICodeCallback_OnVideoOver()
{
	SetIntroViewed( true )

	Signal( uiGlobal.signalDummy, "PlayVideoEnded" )
}

function UICodeCallback_TryCloseDialog()
{
	if ( !uiGlobal.activeDialog )
		return true

	if ( uiGlobal.forceDialogChoice )
		return false

	if ( uiGlobal.lobbyMenusLeftOpen )
		return false

	CloseDialog( true )
	Assert( !uiGlobal.activeDialog )
	return true
}

function ClientCodeCallback_DurangoKeyboardClosed()
{
	switch ( uiGlobal.activeMenu )
	{
		case GetMenu( "EditPilotLoadoutMenu" ):
			SetPilotLoadoutName( GetPilotLoadoutRenameText() )
			SelectPilotLoadoutRenameText()
			EmitUISound( "Menu.Accept" ) // No callback when cancelled so for now assume name was changed
			break

		case GetMenu( "EditTitanLoadoutMenu" ):
			SetTitanLoadoutName( GetTitanLoadoutRenameText() )
			SelectTitanLoadoutRenameText()
			EmitUISound( "Menu.Accept" ) // No callback when cancelled so for now assume name was changed
			break

		default:
			break
	}

	switch ( uiGlobal.activeDialog )
	{
		case GetMenu( "HashtagDialog" ):
			EmitUISound( "Menu.Accept" ) // No callback when cancelled so for now assume name was changed
			break

		default:
			break
	}
}

function InitGamepadConfigs()
{
	uiGlobal.buttonConfigs <- [ { orthodox = "gamepad_button_layout_default.cfg", southpaw = "gamepad_button_layout_default_southpaw.cfg" } ]
	uiGlobal.buttonConfigs.append( { orthodox = "gamepad_button_layout_bumper_jumper.cfg", southpaw = "gamepad_button_layout_bumper_jumper_southpaw.cfg" } )
	uiGlobal.buttonConfigs.append( { orthodox = "gamepad_button_layout_bumper_jumper_alt.cfg", southpaw = "gamepad_button_layout_bumper_jumper_alt_southpaw.cfg" } )
	uiGlobal.buttonConfigs.append( { orthodox = "gamepad_button_layout_pogo_stick.cfg", southpaw = "gamepad_button_layout_pogo_stick_southpaw.cfg" } )
	uiGlobal.buttonConfigs.append( { orthodox = "gamepad_button_layout_button_kicker.cfg", southpaw = "gamepad_button_layout_button_kicker_southpaw.cfg" } )
	uiGlobal.buttonConfigs.append( { orthodox = "gamepad_button_layout_circle.cfg", southpaw = "gamepad_button_layout_circle_southpaw.cfg" } )

	uiGlobal.stickConfigs <- []
	uiGlobal.stickConfigs.append( "gamepad_stick_layout_default.cfg" )
	uiGlobal.stickConfigs.append( "gamepad_stick_layout_southpaw.cfg" )
	uiGlobal.stickConfigs.append( "gamepad_stick_layout_legacy.cfg" )
	uiGlobal.stickConfigs.append( "gamepad_stick_layout_legacy_southpaw.cfg" )

	foreach ( key, val in uiGlobal.buttonConfigs )
	{
		VPKNotifyFile( "cfg/" + val.orthodox )
		VPKNotifyFile( "cfg/" + val.southpaw )
	}

	foreach ( key, val in uiGlobal.stickConfigs )
		VPKNotifyFile( "cfg/" + val )

	ExecCurrentGamepadButtonConfig()
	ExecCurrentGamepadStickConfig()
}

function InitMenus()
{
	AddMenu( "MainMenu", "resource/ui/menus/main.menu", "#MAIN" )
	AddMenu( "IntroMenu", "resource/ui/menus/intro.menu" )
	AddMenu( "GamepadLayoutMenu", "resource/ui/menus/gamepadlayout.menu" )
	AddMenu( "LobbyMenu", "resource/ui/menus/lobby.menu", "#LOBBY" )
	AddMenu( "ClassicMenu", "resource/ui/menus/classic.menu", "#PLAYLISTS" )
	AddMenu( "CoopPartyMenu", "resource/ui/menus/party_coop.menu", "#GAMEMODE_COOP" )
	AddMenu( "CoopPartyCustomMenu", "resource/ui/menus/party_coopcustom.menu", "#COOP_CREATEAMATCH" )
	AddMenu( "EditPilotLoadoutMenu", "resource/ui/menus/editpilotloadout.menu" )
	AddMenu( "EditTitanLoadoutMenu", "resource/ui/menus/edittitanloadout.menu" )

	AddMenu( "MapsMenu", "resource/ui/menus/map_select.menu" )
	AddMenu( "ModesMenu", "resource/ui/menus/mode_select.menu" )
	AddMenu( "MatchSettingsMenu", "resource/ui/menus/match_settings.menu" )
	AddMenu( "ServerBrowserMenu", "resource/ui/menus/server_browser.menu", "#FIND_MATCH" )
	AddMenu( "Addons", "resource/ui/menus/addons.menu", "ADDONS" )
	AddMenu( "HudSettingsMenu", "resource/ui/menus/hudsettings.menu", "#HUD_SETTINGS" )
	AddMenu( "HudSettingsR1DMenu", "resource/ui/menus/hudsettings_r1d.menu", "#HUD_SETTINGS_R1D" )
	AddMenu( "VoteMenu", "resource/ui/menus/vote.menu", "#START_VOTE" )
	AddMenu( "VoteTargetMenu", "resource/ui/menus/votetarget.menu", "#VOTETYPE_TARGET" )

	AddMenu( "BlackMarketMenu", "resource/ui/menus/blackMarket.menu", "#SHOP_TITLE" )
	AddMenu( "BlackMarketMainMenu", "resource/ui/menus/blackMarket_main.menu", "#SHOP_TITLE" )

	level.BtnBlackMarket <- GetMenu( "LobbyMenu" ).GetChild( "BtnBlackMarket" )

	AddMenu( "OptionsMenu", "resource/ui/menus/options.menu", "#OPTIONS" )
	AddMenu( "MouseKeyboardControlsMenu", "resource/ui/menus/mousekeyboardcontrols.menu", "#CONTROLS" )
	AddMenu( "GamepadControlsMenu", "resource/ui/menus/gamepadcontrols.menu", "#CONTROLS" )
	AddMenu_WithCreateFunc( "MouseKeyboardBindingsMenu", "resource/ui/menus/mousekeyboardbindings.menu", CreateKeyBindingMenu )
	AddMenu( "AudioSettingsMenu", "resource/ui/menus/audio.menu", "#AUDIO" )
	AddMenu_WithCreateFunc( "AdvancedVideoSettingsMenu", "resource/ui/menus/advancedvideosettings.menu", CreateVideoOptionsMenu )

	AddMenu( "EditPilotLoadoutsMenu", "resource/ui/menus/editpilotloadouts.menu", "#MENU_EDIT_PILOT_LOADOUTS" )
	AddMenu( "EditTitanLoadoutsMenu", "resource/ui/menus/edittitanloadouts.menu", "#MENU_EDIT_TITAN_LOADOUTS" )
	AddMenu( "BurnCards_pickcard", "resource/ui/menus/burncards_pickcard.menu" )
	AddMenu( "BurnCards_InGame", "resource/ui/menus/burncards_ingame.menu" )
	AddMenu( "BurnCards_filters", "resource/ui/menus/burncards_filters.menu" )
	level.BtnEditBurnCards <- GetMenu( "LobbyMenu" ).GetChild( "BtnEditBurnCards" )


	// AddMenu( "BurnCards_OpenNewCards", "resource/ui/menus/burncards_opennewcards.menu" )

	AddMenu( "InGameMenu", "resource/ui/menus/ingame.menu", "#GAME" )
	AddMenu( "InGameSPMenu", "resource/ui/menus/ingamesp.menu", "#GAME" )
	AddMenu( "ChoiceDialog", "resource/ui/menus/choicedialog.menu" )
	AddMenu( "DirectConnectDialog", "resource/ui/menus/directconnectdialog.menu" )
	AddMenu( "EnterPasswordDialog", "resource/ui/menus/enterpassworddialog.menu" )
	AddMenu( "AuthDialog", "resource/ui/menus/authdialog.menu" )
	AddMenu( "UsernameDialog", "resource/ui/menus/usernamedialog.menu" )
	AddMenu_Named( "ChoiceDialog", "TrainingDialog", "resource/ui/menus/choicedialog.menu" )
	AddMenu( "ChoiceDialog2", "resource/ui/menus/choicedialog2.menu" )
	AddMenu( "ConfirmDialog", "resource/ui/menus/confirmdialog.menu" )
	AddMenu( "RankedSeasonEndDialog", "resource/ui/menus/ranked_season_end_dialog.menu")
	AddMenu( "PlaylistAnnounceDialog", "resource/ui/menus/playlist_announce_dialog.menu")
	AddMenu( "DataCenterDialog", "resource/ui/menus/datacenterdialog.menu" )
	AddMenu( "HashtagDialog", "resource/ui/menus/hashtagdialog.menu" )
	AddMenu( "LobbyTransition", "resource/ui/menus/lobbytransition.menu" )
	AddMenu( "PilotLoadoutsMenu", "resource/ui/menus/pilotloadouts.menu" )
	AddMenu( "TitanLoadoutsMenu", "resource/ui/menus/titanloadouts.menu" )
	AddMenu( "RankedPlayMenu", "resource/ui/menus/rankedplay.menu", "#RANKED_MENU_TITLE" )
	AddSubmenu( "RankedInviteMenu", "resource/ui/menus/ranked_invite.menu" )
	AddSubmenu( "ModeVariantCTFMenu", "resource/ui/menus/mode_variant_ctf.menu" )
	AddSubmenu( "ModeVariantMFDMenu", "resource/ui/menus/mode_variant_mfd.menu" )
	AddSubmenu( "ModeVariantLTSMenu", "resource/ui/menus/mode_variant_lts.menu" )
	AddSubmenu( "ModeVariantPilotMenu", "resource/ui/menus/mode_variant_pilot.menu" )
	AddSubmenu( "ModeVariantFFAMenu", "resource/ui/menus/mode_variant_ffa.menu" )
	AddMenu( "RankedModesMenu", "resource/ui/menus/ranked_modes.menu" )
	AddMenu( "RankedTiersMenu", "resource/ui/menus/rankedtiers.menu", "#RANKED_PLAY_RANKS_BUTTON" )
	AddMenu( "RankedSeasonsMenu", "resource/ui/menus/rankedseasons.menu", "#RANKED_PLAY_SEASONS_BUTTON" )
	AddMenu( "ViewStatsMenu", "resource/ui/menus/viewstats.menu", "#PERSONAL_STATS" )
	AddMenu( "ViewStats_Overview_Menu", "resource/ui/menus/viewstats_overview.menu" )
	AddMenu( "ViewStats_Kills_Menu", "resource/ui/menus/viewstats_kills.menu" )
	AddMenu( "ViewStats_Time_Menu", "resource/ui/menus/viewstats_time.menu" )
	AddMenu( "ViewStats_Distance_Menu", "resource/ui/menus/viewstats_distance.menu" )
	AddMenu( "ViewStats_Weapons_Menu", "resource/ui/menus/viewstats_weapons.menu" )
	AddMenu( "ViewStats_Levels_Menu", "resource/ui/menus/viewstats_levels.menu" )
	AddMenu( "ViewStats_Misc_Menu", "resource/ui/menus/viewstats_misc.menu" )
	AddMenu( "ChallengesMenu", "resource/ui/menus/challenges.menu" )
	AddMenu( "EOG_XP", "resource/ui/menus/eog_xp.menu" )
	AddMenu( "EOG_Coins", "resource/ui/menus/eog_coins.menu" )
	AddMenu( "EOG_MapStars", "resource/ui/menus/eog_mapstars.menu" )
	AddMenu( "EOG_Challenges", "resource/ui/menus/eog_challenges.menu" )
	AddMenu( "EOG_Coop", "resource/ui/menus/eog_coop.menu" )
	AddMenu( "EOG_Unlocks", "resource/ui/menus/eog_unlocks.menu" )
	AddMenu( "EOG_Scoreboard", "resource/ui/menus/eog_scoreboard.menu" )
	AddMenu( "EOG_Ranked", "resource/ui/menus/eog_ranked.menu" )
	AddMenu( "Generation_Respawn", "resource/ui/menus/generation_respawn.menu" )
	AddMenu( "Advocate_Letter", "resource/ui/menus/advocate_letter.menu" )
	AddSubmenu( "ImageWalkThroughMenu", "resource/ui/menus/image_walk_through.menu" )
	AddSubmenu( "WeaponSelectMenu", "resource/ui/menus/weaponselect.menu" )
	AddSubmenu( "AbilitySelectMenu", "resource/ui/menus/abilityselect.menu" )
	AddSubmenu( "PassiveSelectMenu", "resource/ui/menus/passiveselect.menu" )
	AddSubmenu( "TitanOSSelectMenu", "resource/ui/menus/titanosselect.menu" )
	AddSubmenu( "TitanSelectMenuTTP", "resource/ui/menus/titanselectTTP.menu" )//other menu if disabled had issues
	AddSubmenu( "DecalSelectMenu", "resource/ui/menus/decalselect.menu" )
	if( developer() == 1 )
	{
		AddMenu( "DevMenu", "resource/ui/menus/dev.menu", "Dev" )
		AddMenu( "DevLevelMenu", "resource/ui/menus/devlevel.menu", "Level Commands" )
	}
	AddMenu( "CreditsMenu", "resource/ui/menus/credits.menu", "#CREDITS" )

	// Main
	InitMainMenu( GetMenu( "MainMenu" ) )

	InitServerBrowserMenu( GetMenu( "ServerBrowserMenu" ) )

	InitAddonsMenu( GetMenu( "Addons" ) )

	InitHudSettingsMenu( GetMenu( "HudSettingsMenu" ) )
	InitHudSettingsR1DMenu( GetMenu( "HudSettingsR1DMenu" ) )
	InitVoteMenu( GetMenu( "VoteMenu" ) )
	InitVoteTargetMenu( GetMenu( "VoteTargetMenu" ) )

	// Intro
	InitIntroMenu( GetMenu( "IntroMenu" ) )

	// Options
	InitOptionsMenu( GetMenu( "OptionsMenu" ) )

	// Credits
	InitCreditsMenu( GetMenu( "CreditsMenu" ) )

	// Mouse Keyboard Controls
	InitMouseKeyboardControlsMenu( GetMenu( "MouseKeyboardControlsMenu" ) )

	// Gamepad Controls
	InitGamepadControlsMenu( GetMenu( "GamepadControlsMenu" ) )

	// Audio Settings
	InitAudioSettingsMenu( GetMenu( "AudioSettingsMenu" ) )

	// Advanced Video Settings
	InitAdvancedVideoSettingsMenu( GetMenu( "AdvancedVideoSettingsMenu" ) )

	// Gamepad Layout
	InitGamepadLayoutMenu( GetMenu( "GamepadLayoutMenu" ) ) // TODO: Add a general init method for menu class, assuming we don't actually use these global button vars. Most aren't but some may be.

	// Mouse/Keyboard bindings
	InitMouseKeyboardMenu( GetMenu( "MouseKeyboardBindingsMenu" ) )

	// Play Titanfall
	InitClassicMenu( GetMenu( "ClassicMenu" ) )

	// Fireteam Coop
	InitCoopPartyMenu( GetMenu( "CoopPartyMenu" ) )
	InitCoopPartyCustomMenu( GetMenu( "CoopPartyCustomMenu" ) )

	// Private Match
	InitMapsMenu()
	InitModesMenu( GetMenu( "ModesMenu" ) )
	InitModeVariantMenus()
	InitMatchSettingsMenu( GetMenu( "MatchSettingsMenu" ) )

	InitAdvocateLetterMenu()

	// Lobby
	InitLobbyMenu( GetMenu( "LobbyMenu" ) )

	// Edit Pilot Loadout
	InitEditPilotLoadoutMenu()

	// Edit Titan Loadout
	InitEditTitanLoadoutMenu()

	// Ranked
	InitRankedModesMenu( GetMenu( "RankedModesMenu" ) )
	InitRankedPlayMenu()
	InitRankedInviteMenu()
	InitImageWalkThroughMenu()

	InitMenuInGame( GetMenu( "InGameMenu" ) )

	// Select Weapon
	local menu = GetMenu( "WeaponSelectMenu" )
	AddEventHandlerToButtonClass( menu, "PageClass", UIE_GET_FOCUS, OnPageItemButton_Focused )
	AddEventHandlerToButtonClass( menu, "PageClass", UIE_CLICK, OnPageItemButton_Activate )
	AddEventHandlerToButtonClass( menu, "PageClass", UIE_LOSE_FOCUS, OnPageItemButton_LostFocus )

	// Select Ability
	local menu = GetMenu( "AbilitySelectMenu" )
	AddEventHandlerToButtonClass( menu, "AbilitySelectClass", UIE_GET_FOCUS, OnAbilitySelectButton_Focused )
	AddEventHandlerToButtonClass( menu, "AbilitySelectClass", UIE_CLICK, OnAbilityOrPassiveSelectButton_Activate )
	AddEventHandlerToButtonClass( menu, "AbilitySelectClass", UIE_LOSE_FOCUS, OnAbilitySelectButton_LostFocus )

	// Select Passive
	local menu = GetMenu( "PassiveSelectMenu" )
	AddEventHandlerToButtonClass( menu, "PassiveSelectClass", UIE_GET_FOCUS, OnPassiveSelectButton_Focused )
	AddEventHandlerToButtonClass( menu, "PassiveSelectClass", UIE_CLICK, OnAbilityOrPassiveSelectButton_Activate )
	AddEventHandlerToButtonClass( menu, "PassiveSelectClass", UIE_LOSE_FOCUS, OnPassiveSelectButton_LostFocus )

	// Select Titan
	local menu = GetMenu( "TitanSelectMenuTTP" )
	AddEventHandlerToButtonClass( menu, "TitanSelectClass", UIE_GET_FOCUS, OnTitanSelectButton_Focused )
	AddEventHandlerToButtonClass( menu, "TitanSelectClass", UIE_CLICK, OnTitanSelectButton_Activate )
	AddEventHandlerToButtonClass( menu, "TitanSelectClass", UIE_LOSE_FOCUS, OnTitanSelectButton_LostFocus )

	// Select Decal
	local menu = GetMenu( "DecalSelectMenu" )
	AddEventHandlerToButtonClass( menu, "DecalSelectClass", UIE_GET_FOCUS, OnDecalSelectButton_Focused )
	AddEventHandlerToButtonClass( menu, "DecalSelectClass", UIE_CLICK, OnDecalSelectButton_Activate )
	AddEventHandlerToButtonClass( menu, "DecalSelectClass", UIE_LOSE_FOCUS, OnDecalSelectButton_LostFocus )
	AddEventHandlerToButtonClass( menu, "TitanDecalScrollUpClass", UIE_CLICK, OnDecalButtonsScrollUp )
	AddEventHandlerToButtonClass( menu, "TitanDecalScrollDownClass", UIE_CLICK, OnDecalButtonsScrollDown )

	// Select TitanOS
	local menu = GetMenu( "TitanOSSelectMenu" )
	AddEventHandlerToButtonClass( menu, "TitanOSSelectClass", UIE_GET_FOCUS, OnTitanOSSelectButton_Focused )
	AddEventHandlerToButtonClass( menu, "TitanOSSelectClass", UIE_CLICK, OnTitanOSSelectButton_Activate )
	AddEventHandlerToButtonClass( menu, "TitanOSSelectClass", UIE_LOSE_FOCUS, OnTitanOSSelectButton_LostFocus )

	// In Game
	local menu = GetMenu( "InGameMenu" )
	AddEventHandlerToButtonClass( menu, "PilotLoadoutButtonClass", UIE_CLICK, AdvanceMenuEventHandler( GetMenu( "PilotLoadoutsMenu" ) ) )
	AddEventHandlerToButtonClass( menu, "TitanLoadoutButtonClass", UIE_CLICK, AdvanceMenuEventHandler( GetMenu( "TitanLoadoutsMenu" ) ) )
	AddEventHandlerToButtonClass( menu, "OptionsButtonClass", UIE_CLICK, AdvanceMenuEventHandler( GetMenu( "OptionsMenu" ) ) )
	AddEventHandlerToButtonClass( menu, "LeaveGameButtonClass", UIE_CLICK, OnLeaveGameButton_Activate )
	AddEventHandlerToButtonClass( menu, "EndGameButtonClass", UIE_CLICK, OnEndGameButton_Activate )
	AddEventHandlerToButtonClass( menu, "BurnCardMenuButtonClass", UIE_CLICK, AdvanceMenuEventHandler( GetMenu( "BurnCards_pickcard" ) ) )
	AddEventHandlerToButtonClass( menu, "RankedButtonClass", UIE_CLICK, OnRankToggleButton_Activate )

	if ( GetDeveloperLevel() )
	{
		AddEventHandlerToButtonClass( menu, "DevButtonClass", UIE_CLICK, AdvanceMenuEventHandler( GetMenu( "DevMenu" ) ) )

		local buttons = GetElementsByClassname( menu, "DevButtonClass" )
		foreach ( button in buttons )
			button.Show()
	}

	AddEventHandlerToButtonClass( menu, "ServerBrowserButtonClass", UIE_CLICK, AdvanceMenuEventHandler( GetMenu( "ServerBrowserMenu" ) ) )
	AddEventHandlerToButtonClass( menu, "VoteButtonClass", UIE_CLICK, AdvanceMenuEventHandler( GetMenu( "VoteMenu" ) ) )
	AddEventHandlerToButtonClass( menu, "VoteTargetButtonClass", UIE_CLICK, AdvanceMenuEventHandler( GetMenu( "VoteTargetMenu" ) ) )

	// In Game SP
	local menu = GetMenu( "InGameSPMenu" )
	AddEventHandlerToButtonClass( menu, "OptionsButtonClass", UIE_CLICK, AdvanceMenuEventHandler( GetMenu( "OptionsMenu" ) ) )
	AddEventHandlerToButtonClass( menu, "LeaveGameButtonClass", UIE_CLICK, OnLeaveGameButton_Activate )

	if ( GetDeveloperLevel() )
	{
		AddEventHandlerToButtonClass( menu, "DevButtonClass", UIE_CLICK, AdvanceMenuEventHandler( GetMenu( "DevMenu" ) ) )

		local buttons = GetElementsByClassname( menu, "DevButtonClass" )
		foreach ( button in buttons )
			button.Show()
	}

	// Stats Menus
	local menu = GetMenu( "ViewStatsMenu" )
	AddEventHandlerToButtonClass( menu, "BtnOverview", UIE_CLICK, AdvanceMenuEventHandler( GetMenu( "ViewStats_Overview_Menu" ) ) )
	AddEventHandlerToButtonClass( menu, "BtnKills", UIE_CLICK, AdvanceMenuEventHandler( GetMenu( "ViewStats_Kills_Menu" ) ) )
	AddEventHandlerToButtonClass( menu, "BtnTime", UIE_CLICK, AdvanceMenuEventHandler( GetMenu( "ViewStats_Time_Menu" ) ) )
	AddEventHandlerToButtonClass( menu, "BtnDistance", UIE_CLICK, AdvanceMenuEventHandler( GetMenu( "ViewStats_Distance_Menu" ) ) )
	AddEventHandlerToButtonClass( menu, "BtnPilotWeapons", UIE_CLICK, WeaponPilotStatsMenuHandler )
	AddEventHandlerToButtonClass( menu, "BtnTitanWeapons", UIE_CLICK, WeaponTitanStatsMenuHandler )
	AddEventHandlerToButtonClass( menu, "BtnLevels", UIE_CLICK, AdvanceMenuEventHandler( GetMenu( "ViewStats_Levels_Menu" ) ) )
	AddEventHandlerToButtonClass( menu, "BtnMisc", UIE_CLICK, AdvanceMenuEventHandler( GetMenu( "ViewStats_Misc_Menu" ) ) )

	// Black Market
	local menu = GetMenu( "BlackMarketMainMenu" )
	InitBlackMarketMainMenu( menu )
	AddEventHandlerToButtonClass( menu, "BtnBurnCardPacks", UIE_CLICK, BlackMarketBurnCardPacksMenuHandler )
	AddEventHandlerToButtonClass( menu, "BtnPerishables", UIE_CLICK, BlackMarketSoloBurnCardMenuHandler )
	AddEventHandlerToButtonClass( menu, "BtnTitanDecals", UIE_CLICK, BlackMarketTitanDecalsMenuHandler )
	AddEventHandlerToButtonClass( menu, "BtnTitanOSVoices", UIE_CLICK, BlackMarketTitanOSVoicesMenuHandler )
	AddEventHandlerToButtonClass( menu, "BtnChallengeSkips", UIE_CLICK, BlackMarketChallengeSkipMenuHandler )
	AddEventHandlerToButtonClass( menu, "BtnBurnCardUpgrade", UIE_CLICK, BlackMarketUpgradeBurnCardMenuHandler )
	// Regen
	local menu = GetMenu( "Generation_Respawn" )
	AddEventHandlerToButtonClass( menu, "GenerationRespawnButtonClass", UIE_CLICK, OnRegenButtonClick )

	// Dev
	if ( GetDeveloperLevel() )
	{
		local menu = GetMenu( "DevMenu" )
		AddEventHandlerToButtonClass( menu, "DevLevelMenuButtonClass", UIE_CLICK, AdvanceMenuEventHandler( GetMenu( "DevLevelMenu" ) ) )
		AddEventHandlerToButtonClass( menu, "DevButtonClass", UIE_CLICK, OnDevButton_Activate )

		// Dev Level
		local menu = GetMenu( "DevLevelMenu" )
		AddEventHandlerToButtonClass( menu, "DevLevelButtonClass", UIE_CLICK, OnDevLevelButton_Activate )
	}

	// Dialogs
	InitDialogMenu( GetMenu( "ConfirmDialog" ) )
	InitDialogMenu( GetMenu( "RankedSeasonEndDialog" ) )
	InitDialogMenu( GetMenu( "PlaylistAnnounceDialog" ) )
	InitChoiceDialogMenu( GetMenu( "ChoiceDialog" ) )
	InitChoiceDialog2Menu( GetMenu( "ChoiceDialog2" ) )
	InitChoiceDialogMenu( GetMenu( "TrainingDialog" ) )
	InitDataCenterDialogMenu( GetMenu( "DataCenterDialog" ) )
	InitHashtagDialogMenu( GetMenu( "HashtagDialog" ) )

	foreach ( menu in uiGlobal.allMenus )
	{
		AddOldPCFooterButtonHandlers( menu )
		InitFocusFade( menu )
	}

	//thread ToggleButtonStates( swchLookInvert )
	InitChallengesMenu()
}

function AdvanceMenuEventHandler( menu )
{
	return function( item ) : ( menu )
	{
		if ( item.IsLocked() )
			return

		AdvanceMenu( menu )
	}
}

function ReplaceMenuEventHandler( menu )
{
	return function( item ) : ( menu )
	{
		AdvanceMenu( menu, true )
	}
}

function ReplaceMenuEventHandlerNoPop( menu )
{
	return function( item ) : ( menu )
	{
		AdvanceMenu( menu, true, true, false )
	}
}

function BlackMarketBurnCardPacksMenuHandler(...)
{
	uiGlobal.blackMarketItemType = eShopItemType.BURNCARD_PACK
	AdvanceMenu( GetMenu( "BlackMarketMenu" ) )
}

function BlackMarketSoloBurnCardMenuHandler(...)
{
	uiGlobal.blackMarketItemType = eShopItemType.PERISHABLE
	AdvanceMenu( GetMenu( "BlackMarketMenu" ) )
}

function BlackMarketTitanOSVoicesMenuHandler(...)
{
	uiGlobal.blackMarketItemType = eShopItemType.TITAN_OS_VOICE_PACK
	AdvanceMenu( GetMenu( "BlackMarketMenu" ) )
}

function BlackMarketTitanDecalsMenuHandler(...)
{
	uiGlobal.blackMarketItemType = eShopItemType.TITAN_DECAL
	AdvanceMenu( GetMenu( "BlackMarketMenu" ) )
}

function BlackMarketChallengeSkipMenuHandler(...)
{
	uiGlobal.blackMarketItemType = eShopItemType.CHALLENGE_SKIP
	AdvanceMenu( GetMenu( "BlackMarketMenu" ) )
}

function BlackMarketUpgradeBurnCardMenuHandler(...)
{
	uiGlobal.blackMarketItemType = eShopItemType.BURNCARD_UPGRADE
	AdvanceMenu( GetMenu( "BlackMarketMenu" ) )
}

function WeaponPilotStatsMenuHandler(...)
{
	uiGlobal.weaponStatListType = "pilot"
	AdvanceMenu( GetMenu( "ViewStats_Weapons_Menu" ) )
}

function WeaponTitanStatsMenuHandler(...)
{
	uiGlobal.weaponStatListType = "titan"
	AdvanceMenu( GetMenu( "ViewStats_Weapons_Menu" ) )
}

function EOGReplaceMenuEventHandler( menu )
{
	return function( item ) : ( menu )
	{
		uiGlobal.EOGAutoAdvance = false
		AdvanceMenu( menu, true )
	}
}

function OnLeaveGameButton_Activate( button )
{
	if ( IsTrainingLevel() )
	{
		local desc 			= "#MENU_TRAINING_SKIPTOEND_CONFIRM_DESC"
		local confirmText 	= "#MENU_TRAINING_SKIPTOEND_BUTTONTEXT"
		if ( level.ui.trainingModule < 0 )
		{
			desc 			= "#MENU_SKIP_TRAINING_CONFIRM_DESC"
			confirmText 	= "#MENU_SKIP_TRAINING_BUTTONTEXT"
		}

		local buttonData = []
		buttonData.append( { name = confirmText, func = ConfirmSkipTraining } )
		buttonData.append( { name = "#CANCEL", func = null } )

		local dialogData = {}
		dialogData.header <- "#MENU_SKIP_TRAINING_CONFIRM_HEADER"
		dialogData.detailsMessage <- desc
		dialogData.buttonData <- buttonData

		OpenChoiceDialog( dialogData )
	}
	else
	{
		LeaveDialog()
	}
}

function OnEndGameButton_Activate( button )
{
	if ( !IsPrivateMatch() )
		return

	if ( !AmIPartyLeader() )
		return

	local desc 			= "#END_MATCH_CONFIRM_DESC"
	local confirmText 	= "#END_MATCH_YES"

	local buttonData = []
	buttonData.append( { name = confirmText, func = ConfirmEndMatch } )
	buttonData.append( { name = "#CANCEL", func = null } )

	local dialogData = {}
	dialogData.header <- "#END_MATCH"
	dialogData.detailsMessage <- desc
	dialogData.buttonData <- buttonData

	OpenChoiceDialog( dialogData )
}

function ConfirmEndMatch()
{
	CloseDialog()
	CloseTopMenu()
	ClientCommand( "PrivateMatchEndMatch" )
}

function ConfirmSkipTraining()
{
	CloseDialog()
	CloseTopMenu()
	ClientCommand( "leaveTraining" )
}

function OnRankToggleButton_Activate( button )
{
	SetRankedButtonEnabledText( button )

	ClientCommand( "SetPlayRankedOnInGame" )
}

function AddOldPCFooterButtonHandlers( menu )
{
	local buttons = GetElementsByClassname( menu, "PCBackButtonClass" )
	menu.s.pcBackButtons <- buttons
	foreach ( button in buttons )
		button.AddEventHandler( UIE_CLICK, PCBackButton_Activate )
}

function PCBackButton_Activate( button )
{
	UICodeCallback_NavigateBack()
}

function PCSwitchTeamsButton_Activate( button )
{
	ClientCommand( "PrivateMatchSwitchTeams" )
}

function InitFocusFade( menu )
{
	local elements = GetElementsByClassname( menu, "FocusFadeClass" )
	local button

	foreach ( element in elements )
	{
		button = element.GetParent()
		button.s.focusFade <- element
		button.AddEventHandler( UIE_LOSE_FOCUS, FocusFade )
	}
}

function FocusFade( button )
{
	button.s.focusFade.SetAlpha( 255 )
	button.s.focusFade.FadeOverTime( 0, 0.3 )
}

function ToggleButtonStates( button )
{
	for ( ;; )
	{
		button.SetEnabled( true )
		wait 1
		button.SetSelected( true )
		wait 1
		button.SetLocked( true )
		wait 1
		button.SetNew( true )
		wait 1
		button.SetNew( false )
		wait 1
		button.SetLocked( false )
		wait 1
		button.SetSelected( false )
		wait 1
		button.SetEnabled( false )
		wait 1
	}
}

function AddMenuElementsByClassname( menu, classname )
{
	local elements = GetElementsByClassname( menu, classname )

	if ( !(classname in menu.classElements) )
		menu.classElements[classname] <- []

	menu.classElements[classname].extend( elements )
}

function AppendElementsByClassname( menu, classname, Array )
{
	local elements = GetElementsByClassname( menu, classname )
	foreach ( element in elements )
		Array.append( element )
}

function FocusDefault( menu )
{
	if ( menu == GetMenu( "LobbyMenu" ) )
	{
		local buttons = []
		buttons.append( menu.GetChild( "BigPlayButton1" ) )
		buttons.append( menu.GetChild( "StartMatchButton" ) )

		foreach ( button in buttons )
		{
			if ( button.IsEnabled() )
			{
				button.SetFocused()
				break
			}
			else
				menu.GetChild( "BtnEditPilotLoadouts" ).SetFocused()
		}
	}
	else
	{
		FocusDefaultMenuItem( menu )
	}
}

function GetCurrentBreadCrumbs()
{
	local menuStack = clone uiGlobal.menuStack
	if ( menuStack.len() && menuStack.top() )
	menuStack.pop()

	local textArray = []
	while ( menuStack.len() && menuStack.top() )
	{
		local menu = menuStack.pop()
		textArray.append( menu.GetDisplayName() )
	}

	textArray.reverse()

	return textArray
}

function SetMenuBreadCrumbs( menu, textArray )
{
	local elements = GetElementsByClassname( menu, "BreadCrumbsClass" )
	local num = textArray.len()

	foreach ( element in elements )
	{
		if ( num == 0 )
			element.SetText( "" )
		else if ( num == 1 )
			element.SetText( "#MENU_BREADCRUMBS_1", textArray[0] )
		else if ( num == 2 )
			element.SetText( "#MENU_BREADCRUMBS_2", textArray[0], textArray[1] )
		else if ( num == 3 )
			element.SetText( "#MENU_BREADCRUMBS_3", textArray[0], textArray[1], textArray[2] )
		else if ( num == 4 )
			element.SetText( "#MENU_BREADCRUMBS_4", textArray[0], textArray[1], textArray[2], textArray[3] )
		else if ( num == 5 )
			element.SetText( "#MENU_BREADCRUMBS_5", textArray[0], textArray[1], textArray[2], textArray[3], textArray[4] )
		else
			Assert( "Update breadcrumbs to support more than 5!!!" )
	}
}

function SetMenuBackground( menu )
{
	local elements = GetElementsByClassname( menu, "BackgroundImageClass" )

	if ( !IsConnected() || !IsLobby() )
	{
		foreach ( element in elements )
			element.Hide()

		return
	}

	local image = GetLobbyBackgroundImage()

	foreach ( element in elements )
	{
		element.SetImage( image )
		element.Show()
	}
}

// TODO: Get a real on open event from code?
function OpenMenuWrapper( menu, focusDefault )
{
	OpenMenu( menu )
	printt( menu.GetName(), "menu opened" )

	if ( focusDefault )
		FocusDefault( menu )

	// TODO: These shouldn't actually be needed for dialogs
	SetMenuBackground( menu )
	SetMenuBreadCrumbs( menu, GetCurrentBreadCrumbs() )

	local menuName = menu.GetName()

	switch ( menuName )
	{
		case "MainMenu":
			thread OnOpenMainMenu()
			break

		case "LobbyMenu":
			OnOpenLobbyMenu()
			break

		case "InGameMenu":
			OnOpenInGameMenu()
			break

		case "InGameSPMenu":
			OnOpenInGameSPMenu()
			break

		case "PilotLoadoutsMenu":
			OnOpenPilotLoadoutsMenu( menu )
			break

		case "TitanLoadoutsMenu":
			OnOpenTitanLoadoutsMenu( menu )
			break

		case "EditPilotLoadoutsMenu":
			OnOpenEditPilotLoadoutsMenu( menu )
			break

		case "EditTitanLoadoutsMenu":
			OnOpenEditTitanLoadoutsMenu( menu )
			break

		case "EditPilotLoadoutMenu":
			OnOpenEditPilotLoadoutMenu()
			break

		case "EditTitanLoadoutMenu":
			OnOpenEditTitanLoadoutMenu()
			break

		case "WeaponSelectMenu":
			OnOpenWeaponSelectMenu()
			break

		case "BurnCards_pickcard":
			OnOpenMenu_BurnCardsPickCard()
			break

		case "BurnCards_filters":
			OnOpenMenu_BurnCardsFilters()
			break

		case "AbilitySelectMenu":
			OnOpenAbilitySelectMenu()
			break

		case "PassiveSelectMenu":
			OnOpenPassiveSelectMenu()
			break

		case "ImageWalkThroughMenu":
			OnOpenImageWalkThroughMenu()
			break

		case "TitanOSSelectMenu":
			OnOpenTitanOSSelectMenu()
			break

		case "TitanSelectMenuTTP":
			OnOpenTitanSelectMenu()
			break

		case "DecalSelectMenu":
			OnOpenDecalSelectMenu()
			break

		case "DevMenu":
			OnOpenDevMenu()
			break

		case "RankedInviteMenu":
			OnOpenRankedInviteMenu()
			break

		case "ModeVariantCTFMenu":
			OnOpenModeVariantMenu( "ModeVariantCTFMenu" )
			break

		case "ModeVariantMFDMenu":
			OnOpenModeVariantMenu( "ModeVariantMFDMenu" )
			break

		case "ModeVariantLTSMenu":
			OnOpenModeVariantMenu( "ModeVariantLTSMenu" )
			break

		case "ModeVariantPilotMenu":
			OnOpenModeVariantMenu( "ModeVariantPilotMenu" )
			break

		case "ModeVariantFFAMenu":
			OnOpenModeVariantMenu( "ModeVariantFFAMenu" )
			break

		case "RankedPlayMenu":
			OnOpenRankedPlayMenu()
			break

		case "RankedTiersMenu":
			OnOpenRankedTiersMenu()
			break

		case "RankedSeasonsMenu":
			OnOpenRankedSeasonsMenu()
			break

		case "ViewStatsMenu":
			OnOpenViewStats()
			break

		case "ViewStats_Overview_Menu":
			OnOpenViewStatsOverview()
			break

		case "ViewStats_Kills_Menu":
			OnOpenViewStatsKills()
			break

		case "ViewStats_Time_Menu":
			OnOpenViewStatsTime()
			break

		case "ViewStats_Distance_Menu":
			OnOpenViewStatsDistance()
			break

		case "ViewStats_Weapons_Menu":
			OnOpenViewStatsWeapons()
			break

		case "ViewStats_Levels_Menu":
			OnOpenViewStatsLevels()
			break

		case "ViewStats_Misc_Menu":
			OnOpenViewStatsMisc()
			break

		case "ChallengesMenu":
			OnOpenViewChallenges()
			break

		case "EOG_XP":
			thread OnOpenEOG_XP()
			break

		case "EOG_Coins":
			thread OnOpenEOG_Coins()
			break

		case "EOG_MapStars":
			thread OnOpenEOG_MapStars()
			break

		case "EOG_Challenges":
			thread OnOpenEOG_Challenges()
			break

		case "EOG_Unlocks":
			thread OnOpenEOG_Unlocks()
			break

		case "EOG_Coop":
			thread OnOpenEOG_Coop()
			break

		case "EOG_Scoreboard":
			thread OnOpenEOG_Scoreboard()
			break

		case "EOG_Ranked":
			thread OnOpenEOG_Ranked()
			break

		case "MouseKeyboardBindingsMenu":
			OnOpenKeyboardBindingsMenu( menu )
			break

		case "AdvancedVideoSettingsMenu":
			OnOpenAdvancedVideoSettingsMenu( menu )
			break

		case "Generation_Respawn":
			thread OnOpen_Generation_Respawn()
			break

		case "Advocate_Letter":
			thread OnOpen_Advocate_Letter()
			break

		case "OptionsMenu":
			OnOpenOptionsMenu( menu )
			break

		case "MapsMenu":
			OnOpenMapsMenu()
			break

		case "CoopPartyMenu":
			OnOpenCoopPartyMenu( menu )
			break;

		case "CoopPartyCustomMenu":
			OnOpenCoopPartyCustomMenu( menu )
			break;

		case "ModesMenu":
			OnOpenModesMenu()
			break

		case "MatchSettingsMenu":
			OnOpenMatchSettingsMenu()
			break

		case "RankedModesMenu":
			OnOpenRankedModesMenu()
			break

		case "ClassicMenu":
			OnOpenClassicMenu()
			break

		case "ServerBrowserMenu":
			OnOpenServerBrowserMenu( menu );
			break;

		default:
			if ( "openFunc" in menu.s )
			{
				menu.s.openFunc.acall( [ menu.s.scope ] )
				printt( "Called openFunc for:", menu.GetName() )
			}
			break
	}
}

function CloseMenuWrapper( menu )
{
	CloseMenu( menu )
	printt( menu.GetName(), "menu closed (CloseMenuWrapper)" )
	foreach ( index, openMenu in uiGlobal.menuStack )
	{
		if ( openMenu )
			printt( "\t", index, openMenu.GetName() )
		else
			printt( "\t", index, openMenu )
	}

	local menuName = menu.GetName()

	switch ( menuName )
	{
		case "LobbyMenu":
			OnCloseLobbyMenu()
			Signal( uiGlobal.signalDummy, "OnCloseLobbyMenu" )
			break

		case "InGameMenu":
			OnCloseInGameMenu()
			break

		case "EOG_XP":
			OnCloseEOG_XP()
			break

		case "EOG_Coins":
			OnCloseEOG_Coins()
			break

		case "EOG_MapStars":
			if ( developer() > 0 )
				DumpStack()
			OnCloseEOG_MapStars()
			break

		case "EOG_Challenges":
			OnCloseEOG_Challenges()
			break

		case "EOG_Unlocks":
			OnCloseEOG_Unlocks()
			break

		case "EOG_Coop":
			OnCloseEOG_Coop()
			break

		case "EOG_Scoreboard":
			OnCloseEOG_Scoreboard()
			break

		case "EOG_Ranked":
			OnCloseEOG_Ranked()
			break

		case "ViewStats_Weapons_Menu":
			OnCloseViewStatsWeapons()
			break

		case "ViewStats_Levels_Menu":
			OnCloseViewStatsLevels()
			break

		case "BurnCards_pickcard":
			OnCloseMenu_BurnCardPickCard()
			break

		case "TitanSelectMenuTTP":
			OnCloseTitanSelectMenu()
			break

		case "ChallengesMenu":
			OnCloseViewChallenges()
			break

		case "MouseKeyboardBindingsMenu":
			OnCloseKeyboardBindingsMenu( menu )
			break

		case "AdvancedVideoSettingsMenu":
			OnCloseAdvancedVideoSettingsMenu( menu )
			break



		case "Generation_Respawn":
			OnClose_Generation_Respawn()
			break

		case "ImageWalkThroughMenu":
			OnCloseImageWalkThroughMenu()
			break

		case "RankedInviteMenu":
			OnCloseRankedInviteMenu()
			break

		case "ModeVariantCTFMenu":
		case "ModeVariantMFDMenu":
		case "ModeVariantLTSMenu":
		case "ModeVariantPilotMenu":
		case "ModeVariantFFAMenu":
			OnCloseModeVariantMenus()
			break

		case "RankedPlayMenu":
			OnCloseRankedPlayMenu()
			break

		case "Advocate_Letter":
			OnClose_Advocate_Letter()
			break

		case "OptionsMenu":
			OnCloseOptionsMenu()
			break

		case "MapsMenu":
			OnCloseMapsMenu()
			break

		case "ModesMenu":
			OnCloseModesMenu()
			break

		case "MatchSettingsMenu":
			OnCloseMatchSettingsMenu()
			break

		case "EditPilotLoadoutsMenu":
			OnCloseEditPilotLoadoutsMenu()
			break

		case "EditTitanLoadoutsMenu":
			OnCloseEditTitanLoadoutsMenu()
			break

		case "EditPilotLoadoutMenu":
			OnCloseEditPilotLoadoutMenu()
			break

		case "EditTitanLoadoutMenu":
			OnCloseEditTitanLoadoutMenu()
			break

		case "DecalSelectMenu":
			OnCloseDecalSelectMenu()
			break

		// COOP - used by the change loadout crate script
		case "PilotLoadoutsMenu":
			OnClosePilotLoadoutsMenu()
			break

		case "RankedModesMenu":
			OnCloseRankedModesMenu()
			break

		case "RankedSeasonsMenu":
			OnCloseRankedSeasonsMenu()
			break

		case "CoopPartyMenu":
			OnCloseCoopPartyMenu( menu )
			break

		case "CoopPartyCustomMenu":
			OnCloseCoopPartyCustomMenu( menu )
			break

		case "ServerBrowserMenu":
			OnCloseServerBrowserMenu( menu );
			break;

		default:
			if ( "closeFunc" in menu.s )
			{
				menu.s.closeFunc.acall( [ menu.s.scope ] )
				printt( "Called closeFunc for:", menu.GetName() )
			}
			break
	}
}

function GetPropertyNameFromItemType( type )
{
	local propertyName

	switch ( type )
	{
		case itemType.NOT_LOADOUT:
			propertyName = "notLoadout"
			break

		case itemType.PILOT_PRIMARY:
		case itemType.TITAN_PRIMARY:
			propertyName = "primary"
			break

		case itemType.PILOT_SECONDARY:
			propertyName = "secondary"
			break

		case itemType.PILOT_SIDEARM:
			propertyName = "sidearm"
			break

		case itemType.PILOT_SPECIAL:
		case itemType.TITAN_SPECIAL:
			propertyName = "special"
			break

		case itemType.PILOT_ORDNANCE:
		case itemType.TITAN_ORDNANCE:
			propertyName = "ordnance"
			break

		case itemType.PILOT_PASSIVE1:
			propertyName = "passive1"
			break

		case itemType.PILOT_PASSIVE2:
			propertyName = "passive2"
			break

		case itemType.TITAN_PASSIVE1:
			propertyName = "passive1"
			break

		case itemType.TITAN_PASSIVE2:
			propertyName = "passive2"
			break

		case itemType.TITAN_OS:
			propertyName = "voiceChoice"
			break

		case itemType.TITAN_SETFILE:
			propertyName = "setFile"
			break

		case itemType.PILOT_PRIMARY_ATTACHMENT:
			propertyName = "primaryAttachment"
			break

		case itemType.PILOT_PRIMARY_MOD:
		case itemType.TITAN_PRIMARY_MOD:
			propertyName = "primaryMod"
			break

		case itemType.PILOT_SIDEARM_MOD:
			propertyName = "sidearmMod"
			break

		case itemType.PILOT_SECONDARY_MOD:
			propertyName = "secondaryMod"
			break

		case itemType.RACE:
			propertyName = "race"
			break

		case itemType.TITAN_DECAL:
			propertyName = "decal"
			break

		default:
			Assert( "Invalid item type!" )
	}

	return propertyName
}

function GetLocalizedNameFromItemType( type )
{
	local propertyName

	switch ( type )
	{
		case itemType.PILOT_PRIMARY:
			return "#ITEM_TYPE_PILOT_PRIMARY"

		case itemType.TITAN_PRIMARY:
			return "#ITEM_TYPE_TITAN_PRIMARY"

		case itemType.PILOT_SECONDARY:
			return "#ITEM_TYPE_PILOT_SECONDARY"

		case itemType.PILOT_SIDEARM:
			return "#ITEM_TYPE_PILOT_SIDEARM"

		case itemType.PILOT_SPECIAL:
			return "#ITEM_TYPE_PILOT_SPECIAL"

		case itemType.TITAN_SPECIAL:
			return "#ITEM_TYPE_TITAN_SPECIAL"

		case itemType.PILOT_ORDNANCE:
			return "#ITEM_TYPE_PILOT_ORDNANCE"

		case itemType.TITAN_ORDNANCE:
			return "#ITEM_TYPE_TITAN_ORDNANCE"

		case itemType.PILOT_PASSIVE1:
		case itemType.PILOT_PASSIVE2:
			return "#ITEM_TYPE_PILOT_PASSIVE"

		case itemType.TITAN_PASSIVE1:
		case itemType.TITAN_PASSIVE2:
			return "#ITEM_TYPE_TITAN_PASSIVE"

		case itemType.PILOT_PRIMARY_ATTACHMENT:
			return "#ITEM_TYPE_WEAPON_ATTACHMENT"

		case itemType.PILOT_PRIMARY_MOD:
		case itemType.PILOT_SECONDARY_MOD:
		case itemType.PILOT_SIDEARM_MOD:
		case itemType.TITAN_PRIMARY_MOD:
			return "#ITEM_TYPE_WEAPON_MOD"

		case itemType.RACE:
			return "#GENDER"

		case itemType.TITAN_DECAL:
			return "#ITEM_TYPE_TITAN_DECAL"

		default:
			Assert( "Invalid item type!" )
	}

	return propertyName
}

function IsLevelMultiplayer( levelname )
{
	return levelname.find( "mp_" ) == 0
}

function AddEventHandlerToButton( menu, buttonName, event, func )
{
	local button = menu.GetChild( buttonName )
	button.AddEventHandler( event, func )
	button.SetParentMenu( menu )
}

function AddEventHandlerToButtonClass( menu, classname, event, func )
{
	local buttons = GetElementsByClassname( menu, classname )

	foreach ( button in buttons )
	{
		//printt( "button name:", button.GetName() )
		button.AddEventHandler( event, func )
		button.SetParentMenu( menu )
	}
}

function OnOpenInGameSPMenu()
{
	Assert( IsConnected() )

	local leaveGameButtons = GetElementsByClassname( GetMenu( "InGameSPMenu" ), "LeaveGameButtonClass" )
	if ( IsTrainingLevel() )
	{
	    foreach ( leaveGameButton in leaveGameButtons )
	    {
	    	local alias = "#MENU_SKIP_TO_TRAINING_END"
	    	if ( level.ui.trainingModule < 0 )
		    	alias = "#MENU_SKIP_TRAINING"

		    leaveGameButton.SetText( alias )
	    }
	}
	else
	{
	    foreach ( leaveGameButton in leaveGameButtons )
	    {
		    leaveGameButton.SetText( "#LEAVE_GAME" )
	    }
	}
}

function ButtonCallback_MenuShoulderRight( player )
{
	printt( "r left" )
}

function ButtonCallback_MenuShoulderLeft( player )
{
	printt( "s left" )
}

function OnSmartGlassCommand( commandName, arg0, arg1, arg2 )
{
	// we have received a command from a SmartGlass device
}

// Added slight delay to main menu music to work around a hitch caused when the game first starts up
function PlayMusicAfterDelay()
{
	wait MAINMENU_MUSIC_DELAY
	if ( uiGlobal.playingMusic )
		EmitUISound( "MainMenu_Music" )
}

function PlayMusic()
{
	if ( !uiGlobal.playingMusic && !uiGlobal.playingIntro && !uiGlobal.playingCredits )
	{
		//printt( "PlayMusic() called. Playing: MainMenu_Music. uiGlobal.playingMusic:", uiGlobal.playingMusic, "uiGlobal.playingIntro:", uiGlobal.playingIntro, "uiGlobal.playingCredits:", uiGlobal.playingCredits )
		uiGlobal.playingMusic = true
		thread PlayMusicAfterDelay()
	}
	else
	{
		//printt( "PlayMusic() called, but doing nothing. uiGlobal.playingMusic:", uiGlobal.playingMusic, "uiGlobal.playingIntro:", uiGlobal.playingIntro, "uiGlobal.playingCredits:", uiGlobal.playingCredits )
	}
}

function StopMusic()
{
	printt( "StopMusic() called. Stopping: MainMenu_Music" )
	StopUISound( "MainMenu_Music" )
	uiGlobal.playingMusic = false
}


function PopulateNewUnlockTables()
{
	uiGlobal.newMeta <- {}

	/*
	uiGlobal.newMeta["pilot_custom_loadout_1"] 				<- { parentRef = null, newCount = 0, isNew = false, persArrayName = "newUnlocks" }
	uiGlobal.newMeta["pilot_custom_loadout_1"].isNew = GetPersistentVar( "newUnlocks[pilot_custom_loadout_1]" )
	uiGlobal.newMeta["pilot_custom_loadout_1"].isNew = uiGlobal.newMeta["pilot_custom_loadout_1"].isNew ? 1 : 0

	uiGlobal.newMeta["titan_custom_loadout_1"] 				<- { parentRef = null, newCount = 0, isNew = false, persArrayName = "newUnlocks" }
	uiGlobal.newMeta["titan_custom_loadout_1"].isNew = GetPersistentVar( "newUnlocks[titan_custom_loadout_1]" )
	uiGlobal.newMeta["titan_custom_loadout_1"].isNew = uiGlobal.newMeta["titan_custom_loadout_1"].isNew ? 1 : 0
	*/
	PopulateNewUnlockTable( uiGlobal.newMeta, "newUnlocks", "unlockRefs" )

	uiGlobal.newMeta[itemType.PILOT_PRIMARY] 				<- { parentRef = "edit_pilots", newCount = 0, isNew = false, persArrayName = null }
	uiGlobal.newMeta[itemType.PILOT_SECONDARY] 				<- { parentRef = "edit_pilots", newCount = 0, isNew = false, persArrayName = null }
	uiGlobal.newMeta[itemType.PILOT_SIDEARM] 				<- { parentRef = "edit_pilots", newCount = 0, isNew = false, persArrayName = null }
	uiGlobal.newMeta[itemType.PILOT_SPECIAL] 				<- { parentRef = "edit_pilots", newCount = 0, isNew = false, persArrayName = null }
	uiGlobal.newMeta[itemType.PILOT_ORDNANCE] 				<- { parentRef = "edit_pilots", newCount = 0, isNew = false, persArrayName = null }
	uiGlobal.newMeta[itemType.PILOT_PASSIVE1] 				<- { parentRef = "edit_pilots", newCount = 0, isNew = false, persArrayName = null }
	uiGlobal.newMeta[itemType.PILOT_PASSIVE2] 				<- { parentRef = "edit_pilots", newCount = 0, isNew = false, persArrayName = null }

	uiGlobal.newMeta[itemType.TITAN_PRIMARY] 				<- { parentRef = "edit_titans", newCount = 0, isNew = false, persArrayName = null }
	uiGlobal.newMeta[itemType.TITAN_SPECIAL] 				<- { parentRef = "edit_titans", newCount = 0, isNew = false, persArrayName = null }
	uiGlobal.newMeta[itemType.TITAN_ORDNANCE] 				<- { parentRef = "edit_titans", newCount = 0, isNew = false, persArrayName = null }
	uiGlobal.newMeta[itemType.TITAN_SETFILE] 				<- { parentRef = "edit_titans", newCount = 0, isNew = false, persArrayName = null }
	uiGlobal.newMeta[itemType.TITAN_PASSIVE1] 				<- { parentRef = "edit_titans", newCount = 0, isNew = false, persArrayName = null }
	uiGlobal.newMeta[itemType.TITAN_PASSIVE2] 				<- { parentRef = "edit_titans", newCount = 0, isNew = false, persArrayName = null }
	uiGlobal.newMeta[itemType.TITAN_DECAL] 					<- { parentRef = "edit_titans", newCount = 0, isNew = false, persArrayName = null }
	uiGlobal.newMeta[itemType.TITAN_OS] 				    <- { parentRef = "edit_titans", newCount = 0, isNew = false, persArrayName = null }

	PopulateNewUnlockTable( uiGlobal.newMeta, "newLoadoutItems", "loadoutItems" )
	PopulateNewUnlockTable( uiGlobal.newMeta, "newChassis", "titanSetFile" )
	PopulateNewUnlockTable( uiGlobal.newMeta, "newPilotPassives", "pilotPassive" )
	PopulateNewUnlockTable( uiGlobal.newMeta, "newTitanPassives", "titanPassive" )
	PopulateNewUnlockTable( uiGlobal.newMeta, "newMods", "modsCombined" )
	PopulateNewUnlockTable( uiGlobal.newMeta, "newTitanDecals", "titanDecals" )
	PopulateNewUnlockTable( uiGlobal.newMeta, "newTitanOS", "titanOS" )
}

function GetNewItemParentData( newItemData )
{
	if ( !newItemData.parentRef )
		return null

	return uiGlobal.newMeta[ newItemData.parentRef ]
}

function PopulateNewUnlockTable( newUnlockTable, arrayName, enumName )
{
	local numNewLoadoutItems = PersistenceGetEnumCount( enumName )
	for ( local index = 0; index < numNewLoadoutItems; index++ )
	{
		local ref = PersistenceGetEnumItemNameForIndex( enumName, index )

		if ( ref == "" || ref == null )
			continue

		Assert( !(ref in newUnlockTable), "ref already defined " + ref )

		local isNew = GetPersistentVar( arrayName + "[" + ref+ "]" )

		newUnlockTable[ ref ] <- {}
		newUnlockTable[ ref ].isNew <- isNew
		newUnlockTable[ ref ].newCount <- isNew ? 1 : 0
		newUnlockTable[ ref ].persArrayName <- arrayName

		// combined weapon/mod refs are not defined as individual items in _items
		if ( !ItemDefined( ref ) )
		{
			if ( (ref in combinedModData) )
			{
				newUnlockTable[ ref ].parentRef <- combinedModData[ref].parentRef
			}
			else if ( ref in unlockLevels )
			{
				if ( ref.find( "pilot_custom" ) == 0 )
					newUnlockTable[ ref ].parentRef <- "edit_pilots"
				else if ( ref.find( "titan_custom" ) == 0 )
					newUnlockTable[ ref ].parentRef <- "edit_titans"
				else
					newUnlockTable[ ref ].parentRef <- null
			}
			else
			{
				Assert( ref in uiGlobal.newGeneric, "Unclassified ref: " + ref )
			}
		}
		else
		{
			newUnlockTable[ ref ].parentRef <- GetItemType( ref )
		}

		if ( newUnlockTable[ ref ].newCount )
		{
			local parentNewData = GetNewItemParentData( newUnlockTable[ ref ] )
			while ( parentNewData )
			{
				parentNewData.newCount++
				parentNewData = GetNewItemParentData( parentNewData )
			}
		}
	}
}


function ClearRefNew( ref )
{
	if ( !("newMeta" in uiGlobal) )
		return
	if ( !uiGlobal.newMeta[ref].isNew )
		return

	// seems defensive, but if the server goes away it does so before the menu item loses focus
	if ( !IsConnected() )
		return

	ClientCommand( "ClearNewStatus " + ref )

	uiGlobal.newMeta[ref].isNew = false
	uiGlobal.newMeta[ref].newCount--
	Assert( uiGlobal.newMeta[ref].newCount >= 0 )

	local parentNewData = GetNewItemParentData( uiGlobal.newMeta[ref] )
	while ( parentNewData )
	{
		parentNewData.newCount--
		parentNewData = GetNewItemParentData( parentNewData )
	}
}


function HasAnyNewItem( refType, parentRef = null )
{
	if (!("newMeta" in uiGlobal))
		return false
	return (uiGlobal.newMeta[refType].newCount > 0)
}

function DeepClone( data )
{
	if ( type( data ) == "table" )
	{
		local newTable = {}
		foreach( key, value in data )
		{
			newTable[ key ] <- DeepClone( value )
		}
		return newTable
	}
	else if ( type( data ) == "array" )
	{
		local newArray = []
		for( local i = 0; i < data.len(); i++ )
		{
			newArray.append( DeepClone( data[ i ] ) )
		}
		return newArray
	}
	else
	{
		return data
	}
}


// dump the stack trace to the console
function DumpStack( offset = 1 )
{
	for ( local i = offset; i < 20; i++ )
	{
		if ( !( "src" in getstackinfos(i) ) )
			break
		printl( i + " File : " + getstackinfos(i)["src"] + " [" + getstackinfos(i)["line"] + "]\n    Function : " + getstackinfos(i)["func"] + "() " )
	}
}

function ShowEOGSummary()
{
	uiGlobal.EOGAutoAdvance = true
	uiGlobal.playerOpenedEOG = false
	AdvanceMenu( GetMenu( "EOG_XP" ) )
	uiGlobal.viewedGameSummary = true
}

function ShouldShowBurnCardMenu()
{
	if ( GetActiveBurnCards().len() <= 0 )
		return false

	if ( GetConVarString( "mp_gamemode" ) == GUN_GAME )
		return false

	if ( GetGen() > 0 )
		return true

	if ( UsingAlternateBurnCardPersistence() )
		return true

	return GetLevel() >= GetUnlockLevelReq( "burn_card_slot_1" )
}

function SeasonEndDialogClosed(...)
{
	CloseDialog()
	if ( IsConnected() )
		ClientCommand( "SeasonEndDialogClosed" )
}

function SetupButton( button, description )
{
	button.s.description <- description
	button.AddEventHandler( UIE_GET_FOCUS, ShowButtonDescription )
}
Globalize( SetupButton )

function SetupButtonText( button, buttonText, description )
{
	button.SetText( buttonText )
	button.s.description <- description
	button.AddEventHandler( UIE_GET_FOCUS, ShowButtonDescription )
}
Globalize( SetupButtonText )

function ShowButtonDescription( button )
{
	SetElementsTextByClassname( uiGlobal.activeMenu, "MenuItemDescriptionClass", button.s.description )
}

function GetMapName()
{
	return GetActiveLevel()
}
Globalize( GetMapName )

function AddMenuEventHandler( menu, event, func )
{
	local eventFuncName

	if ( event == eUIEvent.MENU_OPEN )
		eventFuncName = "openFunc"
	else if ( event == eUIEvent.MENU_CLOSE )
		eventFuncName = "closeFunc"
	else if ( event == eUIEvent.MENU_NAVIGATE_BACK )
		eventFuncName = "navBackFunc"
	else if ( event == eUIEvent.MENU_INPUT_MODE_CHANGED )
		eventFuncName = "inputModeChangedFunc"
	else
	{
		Assert( false, "Unsupported event passed to AddMenuEventHandler" )
		return
	}

	if ( "scope" in menu.s )
		Assert( menu.s.scope == this, "Menu event handlers must share a scope" )
	else
		menu.s.scope <- this

	if ( eventFuncName in menu.s )
	{
		Assert( menu.s[ eventFuncName ] == func, "Menu already has a different handler for this event" )
		return
	}

	menu.s[ eventFuncName ] <- func
}

thread main()
