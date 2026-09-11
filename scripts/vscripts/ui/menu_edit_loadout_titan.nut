
function main()
{
	Globalize( InitEditTitanLoadoutMenu )
	Globalize( OnOpenEditTitanLoadoutMenu )
	Globalize( OnCloseEditTitanLoadoutMenu )
	Globalize( OnNavigateBackEditTitanLoadoutMenu )
	Globalize( GetTitanLoadoutRenameText )
	Globalize( SetTitanLoadoutName )
	Globalize( SelectTitanLoadoutRenameText )
}

function InitEditTitanLoadoutMenu()
{
	file.menu <- GetMenu( "EditTitanLoadoutMenu" )
	local menu = file.menu

	uiGlobal.navigateBackCallbacks[ menu ] <- Bind( OnNavigateBackEditTitanLoadoutMenu )

	local buttons = GetElementsByClassname( menu, "TitanSetFileClass" )
	buttons.extend( GetElementsByClassname( menu, "TitanPrimaryClass" ) )
	buttons.extend( GetElementsByClassname( menu, "TitanSpecialClass" ) )
	buttons.extend( GetElementsByClassname( menu, "TitanOrdnanceClass" ) )
	buttons.extend( GetElementsByClassname( menu, "TitanPassiveClass" ) )
	buttons.extend( GetElementsByClassname( menu, "TitanDecalClass" ) )
	buttons.extend( GetElementsByClassname( menu, "TitanOSClass" ) )

	foreach ( button in buttons )
	{
		button.SetParentMenu( menu )
		button.AddEventHandler( UIE_CLICK, OnEditTitanSlotButton_Activate )
	}

	file.menuTitle <- menu.GetChild( "MenuTitle" )
	file.renameEditBox <- menu.GetChild( "RenameEditBox" )
	file.cancellingRename <- false
	file.menuClosing <- false

	AddEventHandlerToButton( menu, "RenameEditBox", UIE_LOSE_FOCUS, Bind( OnRenameEditBox_LostFocus ) )
}

function OnOpenEditTitanLoadoutMenu()
{
	local menu = file.menu

	AddMenuElementsByClassname( menu, TITAN_CHASSIS_IMAGE )
	AddMenuElementsByClassname( menu, TITAN_PRIMARY_IMAGE )
	AddMenuElementsByClassname( menu, TITAN_SPECIAL_IMAGE )
	AddMenuElementsByClassname( menu, TITAN_ORDNANCE_IMAGE )
	AddMenuElementsByClassname( menu, TITAN_DECAL_IMAGE )

	AddMenuElementsByClassname( menu, TITAN_CHASSIS_NAME )
	AddMenuElementsByClassname( menu, TITAN_CORE_NAME )
	AddMenuElementsByClassname( menu, TITAN_PRIMARY_NAME )
	AddMenuElementsByClassname( menu, TITAN_SPECIAL_NAME )
	AddMenuElementsByClassname( menu, TITAN_ORDNANCE_NAME )
	AddMenuElementsByClassname( menu, TITAN_PRIMARY_MOD_NAME )
	AddMenuElementsByClassname( menu, TITAN_PASSIVE1_NAME )
	AddMenuElementsByClassname( menu, TITAN_PASSIVE2_NAME )

	AddMenuElementsByClassname( menu, TITAN_PRIMARY_MOD_ICON )
	AddMenuElementsByClassname( menu, TITAN_SPECIAL_ICON )
	AddMenuElementsByClassname( menu, TITAN_ORDNANCE_ICON )
	AddMenuElementsByClassname( menu, TITAN_PASSIVE1_ICON )
	AddMenuElementsByClassname( menu, TITAN_PASSIVE2_ICON )

	AddMenuElementsByClassname( menu, TITAN_PRIMARY_DESC )
	AddMenuElementsByClassname( menu, TITAN_SPECIAL_DESC )
	AddMenuElementsByClassname( menu, TITAN_ORDNANCE_DESC )
	AddMenuElementsByClassname( menu, TITAN_PASSIVE1_DESC )
	AddMenuElementsByClassname( menu, TITAN_PASSIVE2_DESC )
	AddMenuElementsByClassname( menu, TITAN_OS_VOICE_IMAGE )

	local loadout = UI_GetCustomTitanLoadout( menu.loadoutIDBeingEdited )
	local loadoutName = GetLoadoutName( loadout )

	file.menuTitle.SetUTF8Text( loadoutName )
	file.renameEditBox.SetUTF8Text( loadoutName )
	file.menuClosing = false

	UpdateTitanLoadoutElems( menu, loadout )
	UpdateEditTitanLoadoutNewStatus()

	////////////////////////////////////////////////////////////////////// BME

	local isCustom = GetPersistentVar( "titanSpawnLoadout.isCustom" )
	local selectedIndex = GetPersistentVar( "titanSpawnLoadout.index" )

	if (IsFullyConnected() && GetActiveLevel() != "mp_lobby")
	{
		RegisterTitanLoadoutsIngameEditCallbacks()
		if (isCustom && menu.loadoutIDBeingEdited == selectedIndex)
		{
			// we are in-game and we just edited our currently selected loadout, change it to something else and back to refresh

			if (selectedIndex != 0) ClientCommand( "SetCustomTitanLoadout 0" )
			if (selectedIndex == 0) ClientCommand( "SetCustomTitanLoadout 1" )
			ClientCommand( "InGameMenuClosed" )

			ClientCommand( "SetCustomTitanLoadout " + selectedIndex )
			ClientCommand( "InGameMenuClosed" )
		}
	}
}

function OnCloseEditTitanLoadoutMenu()
{
	file.menuClosing = true
}

function OnNavigateBackEditTitanLoadoutMenu()
{
	local menu = file.menu

	////////////////////////////////////////////////////////////////////// BME
	local isCustom = GetPersistentVar( "titanSpawnLoadout.isCustom" )
	local selectedIndex = GetPersistentVar( "titanSpawnLoadout.index" )

	if (IsFullyConnected() && GetActiveLevel() != "mp_lobby")
	{
		RegisterTitanLoadoutsIngameEditCallbacks()
		if (isCustom && menu.loadoutIDBeingEdited == selectedIndex)
		{
			// we are in-game and we just edited our currently selected loadout, change it to something else and back to refresh

			if (selectedIndex != 0) ClientCommand( "SetCustomTitanLoadout 0" )
			if (selectedIndex == 0) ClientCommand( "SetCustomTitanLoadout 1" )
			ClientCommand( "InGameMenuClosed" )

			ClientCommand( "SetCustomTitanLoadout " + selectedIndex )
			ClientCommand( "InGameMenuClosed" )
		}
	}
	//////////////////////////////////////////////////////////////////////

	if ( !Durango_IsDurango() && GetFocus() == file.renameEditBox )
	{
		file.cancellingRename = true
		FocusDefault( menu )

		return
}

	if ( uiGlobal.activeMenu == menu )
		CloseTopMenu()
}

function UpdateEditTitanLoadoutNewStatus()
{
	local menu = file.menu
	local buttons

	buttons = GetElementsByClassname( menu, "TitanSetFileClass" )
	foreach( button in buttons )
	{
		button.SetNew( HasAnyNewItem( itemType.TITAN_SETFILE ) )
	}

	buttons = GetElementsByClassname( menu, "TitanPrimaryClass" )
	foreach( button in buttons )
	{
		button.SetNew( HasAnyNewItem( itemType.TITAN_PRIMARY ) )
	}

	buttons = GetElementsByClassname( menu, "TitanSpecialClass" )
	foreach( button in buttons )
	{
		button.SetNew( HasAnyNewItem( itemType.TITAN_SPECIAL ) )
	}

	buttons = GetElementsByClassname( menu, "TitanOrdnanceClass" )
	foreach( button in buttons )
	{
		button.SetNew( HasAnyNewItem( itemType.TITAN_ORDNANCE ) )
	}

	buttons = GetElementsByClassname( menu, "TitanPassiveClass" )
	foreach( button in buttons )
	{
		local buttonID = button.GetScriptID().tointeger()

		if ( buttonID == 4 )
			button.SetNew( HasAnyNewItem( itemType.TITAN_PASSIVE1 ) )
		else if ( buttonID == 5 )
			button.SetNew( HasAnyNewItem( itemType.TITAN_PASSIVE2 ) )
	}

	buttons = GetElementsByClassname( menu, "TitanDecalClass" )
	foreach( button in buttons )
	{
		button.SetNew( HasAnyNewItem( itemType.TITAN_DECAL ) )
	}
}


function OnEditTitanSlotButton_Activate( button )
{
	local buttonID = button.GetScriptID().tointeger()
	uiGlobal.loadoutTypeBeingEdited = "titan"

	switch ( buttonID )
	{
		case 0:
			uiGlobal.itemTypeBeingEdited = itemType.TITAN_SETFILE
			OpenSubmenu( GetMenu( "TitanSelectMenuTTP" ) )
			break

		case 1:
			uiGlobal.itemTypeBeingEdited = itemType.TITAN_PRIMARY
			OpenSubmenu( GetMenu( "WeaponSelectMenu" ) )
			break

		case 2:
			uiGlobal.itemTypeBeingEdited = itemType.TITAN_SPECIAL
			OpenSubmenu( GetMenu( "AbilitySelectMenu" ) )
			break

		case 3:
			uiGlobal.itemTypeBeingEdited = itemType.TITAN_ORDNANCE
			OpenSubmenu( GetMenu( "AbilitySelectMenu" ) )
			break

		case 4:
			uiGlobal.itemTypeBeingEdited = itemType.TITAN_PASSIVE1
			OpenSubmenu( GetMenu( "PassiveSelectMenu" ) )
			break

		case 5:
			uiGlobal.itemTypeBeingEdited = itemType.TITAN_PASSIVE2
			OpenSubmenu( GetMenu( "PassiveSelectMenu" ) )
			break

		case 6:
			uiGlobal.itemTypeBeingEdited = itemType.TITAN_DECAL
			OpenSubmenu( GetMenu( "DecalSelectMenu" ), false )
			break

		case 7:
		    uiGlobal.itemTypeBeingEdited = itemType.TITAN_OS
			OpenSubmenu( GetMenu( "TitanOSSelectMenu" ) )
			break

		default:
			break
	}
}


function OnRenameEditBox_LostFocus( elem )
{
	if ( file.menuClosing )
		return

	local menu = file.menu
	local oldName = GetLoadoutName( UI_GetCustomTitanLoadout( menu.loadoutIDBeingEdited ) )
	local newName = GetTitanLoadoutRenameText()

	// If all whitespace entered reset to previous name
	newName = strip( newName )
	if ( newName == "" || file.cancellingRename )
		newName = oldName

	file.cancellingRename = false

	SetTitanLoadoutName( newName )

	if ( newName != oldName )
		EmitUISound( "Menu.Accept" )
}


function GetTitanLoadoutRenameText()
{
	return file.renameEditBox.GetTextEntryUTF8Text()
}


function SetTitanLoadoutName( name )
{
	local menu = file.menu

	if ( LoadoutNameIsToken( name ) )
		name = TranslateTokenToUTF8( name )

	name = strip(name)
	if (name == "")
		return

	file.menuTitle.SetUTF8Text( name )
	file.renameEditBox.SetUTF8Text( name )

	if ( IsConnected() )
		UI_SetLoadoutProperty( "titan", menu.loadoutIDBeingEdited, "name", name )
}


function SelectTitanLoadoutRenameText()
{
	file.renameEditBox.SelectAll()
}