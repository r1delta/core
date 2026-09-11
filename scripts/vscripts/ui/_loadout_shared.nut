
const DECAL_MENU_DECALS_PER_ROW = 9
const DECAL_MENU_VISIBLE_ROWS = 6
const DECAL_MENU_SCROLL_SPEED = 0.15

lockedChallengePanel <- {}
numDecalRowsOffScreen <- null

titanOsVoiceSelectionSuffix <- [ "_outnumbered2to1_1", "_def_dmgCoreOnline_01_02", "_def_rodeowarning_1", "_def_elimEnemyPilot_14_01", "_embark", "_disembark"  ] //Note: These are all dependent on having "diag_gs_titan" as the front part of the alias

function InitLoadouts()
{
	thread InitCustomLoadouts()

	if ( !uiGlobal.eventHandlersAdded )
	{
		InitPilotLoadoutsMenu( GetMenu( "PilotLoadoutsMenu" ) )
		InitTitanLoadoutsMenu( GetMenu( "TitanLoadoutsMenu" ) )

		InitEditPilotLoadoutsMenu( GetMenu( "EditPilotLoadoutsMenu" ) )
		InitEditTitanLoadoutsMenu( GetMenu( "EditTitanLoadoutsMenu" ) )
		InitPickCardMenu( GetMenu( "BurnCards_pickcard" ) )
		InitBurnCardInGameMenu( GetMenu( "BurnCards_InGame" ) )

		uiGlobal.eventHandlersAdded <- true
	}

	uiGlobal.loadoutBeingEdited <- null
	uiGlobal.loadoutTypeBeingEdited <- null
	uiGlobal.itemBeingEdited <- null
	uiGlobal.itemTypeBeingEdited <- null
	uiGlobal.subitemBeingEdited <- null
	uiGlobal.subitemTypeBeingEdited <- null
	uiGlobal.parentItemBeingEdited <- null
	uiGlobal.decalScrollState <- 0

	local menu = GetMenu( "WeaponSelectMenu" )
	local panel = GetElementsByClassname( menu, "ChallengeLockPanel" )[0]
	lockedChallengePanel.name <- panel.GetChild( "Name" )
	lockedChallengePanel.desc <- panel.GetChild( "Description" )
	lockedChallengePanel.icon <- panel.GetChild( "Icon" )
	lockedChallengePanel.progress <- panel.GetChild( "Progress" )
	lockedChallengePanel.bar <- panel.GetChild( "BarFillPrevious" )
	lockedChallengePanel.barShadow <- panel.GetChild( "BarFillShadow" )

	RegisterSignal( "PlayOSVoiceRandomSample" )
}

function UpdateDecalButtons( buttons, items, currentItem, focusSelected )
{
	numDecalRowsOffScreen = ceil( ( items.len() - DECAL_MENU_DECALS_PER_ROW * DECAL_MENU_VISIBLE_ROWS ) / DECAL_MENU_DECALS_PER_ROW.tofloat() )
	Assert( numDecalRowsOffScreen >= 0 )

	foreach ( button in buttons )
	{
		local buttonID = button.GetScriptID().tointeger()
		if ( buttonID < 0 )
		{
			button.SetNew( false )
			continue
		}

		if ( buttonID >= items.len() )
		{
			if ( button.IsFocused() )
				focusSelected = true

			button.s.ref <- null
			button.SetNew( false )
			button.SetEnabled( false )
			button.SetLocked( false )
			button.SetSelected( false )
			button.Hide()
		}
	}

	local buttonHasFocus = false
	local firstButton = null
	foreach ( button in buttons )
	{
		local buttonID = button.GetScriptID().tointeger()
		if ( buttonID < 0 )
			continue

		if ( buttonID == 0 )
			firstButton = button

		if ( buttonID < items.len() )
		{
			local item = items[buttonID]

			button.SetEnabled( true )
			button.Show()

			local isLocked = IsItemLocked( item.ref )
			button.SetLocked( isLocked )

			button.s.ref <- item.ref

			local decalImage = GetItemImage( item.ref )

			local buttonImage = button.GetChild( "DecalNormal" )
			buttonImage.SetImage( decalImage )
			buttonImage.SetAlpha( isLocked ? 100 : 255 )

			button.SetNew( HasAnyNewItem( button.s.ref ) )

			if ( item.ref == currentItem )
			{
				button.SetSelected( true )
				if ( focusSelected )
				{
					button.SetFocused()
					buttonHasFocus = true
				}
			}
			else
			{
				button.SetSelected( false )
			}
		}
	}

	if ( !buttonHasFocus && firstButton != null )
		firstButton.SetFocused()
}

function OnDecalButtonsScrollUp(...)
{
	uiGlobal.decalScrollState--
	if ( uiGlobal.decalScrollState < 0 )
		uiGlobal.decalScrollState = 0

	DecalButtonsScrollUpdate()
}

function OnDecalButtonsScrollDown(...)
{
	Assert( numDecalRowsOffScreen != null )
	uiGlobal.decalScrollState++
	if ( uiGlobal.decalScrollState > numDecalRowsOffScreen )
		uiGlobal.decalScrollState = numDecalRowsOffScreen

	DecalButtonsScrollUpdate()
}

function DecalButtonsScrollUpdate()
{
	Assert( numDecalRowsOffScreen != null )
	local menu = GetMenu( "DecalSelectMenu" )
	local buttons = GetElementsByClassname( menu, "DecalSelectClass" )
	local basePos = buttons[0].GetBasePos()
	local offset = ( (buttons[0].GetHeight() + 3.0) - (numDecalRowsOffScreen * GetContentScaleFactor( menu )[0]) ) * uiGlobal.decalScrollState

	buttons[0].MoveOverTime( basePos[0], basePos[1] - offset, DECAL_MENU_SCROLL_SPEED )
}

function PrepareLoadoutSubmenuButtons( buttons, buttonIndexOffset, items, currentItem, parentItem, focusSelected )
{
	//printt( "PREPARE LOADOUT BUTTONS: " + currentItem + "; focus selected " + focusSelected + " buttonIndexOffset: " + buttonIndexOffset )

	// Disable buttons first because otherwise disabling the currently active button will cause code to set a new focus to get set which interferes with script setting it
	foreach ( button in buttons )
	{
		local buttonID = button.GetScriptID().tointeger() + buttonIndexOffset
		if ( buttonID < 0 )
		{
			button.SetNew( false )
			continue
		}

		if ( buttonID >= items.len() )
		{
			if ( button.IsFocused() )
				focusSelected = true

			button.s.ref <- null
			button.SetNew( false )
			button.SetText( "" )
			button.SetEnabled( false )
			button.SetLocked( false )
			button.SetSelected( false )
		}
	}

	foreach ( button in buttons )
	{
		local buttonID = button.GetScriptID().tointeger() + buttonIndexOffset
		if ( buttonID < 0 )
			continue

		if ( buttonID < items.len() )
		{
			local item = items[buttonID]
			local isLocked
			if ( parentItem )
				isLocked = IsItemLocked( parentItem, item.ref )
			else
				isLocked = IsItemLocked( item.ref )

			button.SetText( item.name )
			button.SetEnabled( true )
			button.SetLocked( isLocked )

			if ( ItemTypeIsAttachment( item.type ) || ItemTypeIsMod( item.type ) )
				button.s.ref <- item.parentRef + "_" + item.ref
			else
				button.s.ref <- item.ref

			button.SetNew( HasAnyNewItem( button.s.ref ) )

			if ( item.ref == currentItem )
			{
				button.SetSelected( true )
				if ( focusSelected )
					button.SetFocused()
			}
			else
			{
				button.SetSelected( false )
			}
		}
	}
}

function OnOpenWeaponSelectMenu()
{
	Assert( uiGlobal.itemTypeBeingEdited != null )
	Assert( uiGlobal.loadoutBeingEdited != null )

	local currentWeapon = uiGlobal.loadoutBeingEdited[ GetPropertyNameFromItemType( uiGlobal.itemTypeBeingEdited ) ]
	uiGlobal.itemBeingEdited = currentWeapon

	local menu = GetMenu( "WeaponSelectMenu" )

	ClearAttachmentAndModElements( menu )

	ChangePage( "weapons" )
}

function ClearAttachmentAndModElements( menu )
{
	// Clear attachment and mod elements

	local elements = GetElementsByClassname( menu, "WeaponAttachmentClass" )
	foreach ( element in elements )
		element.Hide()

	local elements = GetElementsByClassname( menu, "WeaponModClass" )
	foreach ( element in elements )
		element.Hide()
}

function ShowAttachmentElements( menu )
{
	local elements = GetElementsByClassname( menu, "WeaponAttachmentClass" )
	foreach ( element in elements )
		element.Show()
}

function ShowModElements( menu )
{
	local elements = GetElementsByClassname( menu, "WeaponModClass" )
	foreach ( element in elements )
		element.Show()
}

function OnOpenAbilitySelectMenu()
{
	Assert( uiGlobal.itemTypeBeingEdited != null )
	Assert( uiGlobal.loadoutBeingEdited != null )

	local menu = GetMenu( "AbilitySelectMenu" )
	local buttons = GetElementsByClassname( menu, "AbilitySelectClass" )
	local abilities = GetAllItemsOfType( uiGlobal.itemTypeBeingEdited )
	local currentAbility = uiGlobal.loadoutBeingEdited[ GetPropertyNameFromItemType( uiGlobal.itemTypeBeingEdited ) ]

	local elements = GetElementsByClassname( menu, "AbilityTypeClass" )
	foreach ( element in elements )
		element.SetText( GetDisplayNameFromItemType( uiGlobal.itemTypeBeingEdited ) )

	PrepareLoadoutSubmenuButtons( buttons, 0, abilities, currentAbility, null, true )
}

function OnOpenPassiveSelectMenu()
{
	Assert( uiGlobal.itemTypeBeingEdited != null )
	Assert( uiGlobal.loadoutBeingEdited != null )

	local menu = GetMenu( "PassiveSelectMenu" )
	local buttons = GetElementsByClassname( menu, "PassiveSelectClass" )
	local passives = GetAllItemsOfType( uiGlobal.itemTypeBeingEdited )
	local currentPassive = uiGlobal.loadoutBeingEdited[ GetPropertyNameFromItemType( uiGlobal.itemTypeBeingEdited ) ]

	local elements = GetElementsByClassname( menu, "PassiveTypeClass" )
	foreach ( element in elements )
		element.SetText( GetDisplayNameFromItemType( uiGlobal.itemTypeBeingEdited ) )

	PrepareLoadoutSubmenuButtons( buttons, 0, passives, currentPassive, null, true )
}

function OnOpenTitanOSSelectMenu()
{
	Assert( uiGlobal.itemTypeBeingEdited != null )
	Assert( uiGlobal.loadoutBeingEdited != null )

	local menu = GetMenu( "TitanOSSelectMenu" )
	local buttons = GetElementsByClassname( menu, "TitanOSSelectClass" )
	local passives = GetAllItemsOfType( uiGlobal.itemTypeBeingEdited )
	local currentPassive = uiGlobal.loadoutBeingEdited[ GetPropertyNameFromItemType( uiGlobal.itemTypeBeingEdited ) ]

	local elements = GetElementsByClassname( menu, "TitanOSTypeClass" )
	foreach ( element in elements )
		element.SetText( GetDisplayNameFromItemType( uiGlobal.itemTypeBeingEdited ) )

	PrepareLoadoutSubmenuButtons( buttons, 0, passives, currentPassive, null, true )
}

function OnOpenTitanSelectMenu()
{
	Assert( uiGlobal.itemTypeBeingEdited != null )

	local menu = GetMenu( "TitanSelectMenuTTP" )
	local buttons = GetElementsByClassname( menu, "TitanSelectClass" )
	local titans = GetAllItemsOfType( uiGlobal.itemTypeBeingEdited )
	local currentTitan = uiGlobal.loadoutBeingEdited[ GetPropertyNameFromItemType( uiGlobal.itemTypeBeingEdited ) ]

	local menuTitle = menu.GetChild( "LblInfoPanelItemType" )
	menuTitle.SetText( GetDisplayNameFromItemType( uiGlobal.itemTypeBeingEdited ) )

	PrepareLoadoutSubmenuButtons( buttons, 0, titans, currentTitan, null, true )

	local bgMenu = GetMenu( "EditTitanLoadoutMenu" )
	local elements = GetElementsByClassname( bgMenu, "TitanChassisImage" )
	foreach ( element in elements )
		element.Hide()
}

function OnCloseTitanSelectMenu()
{
	local bgMenu = GetMenu( "EditTitanLoadoutMenu" )
	local elements = GetElementsByClassname( bgMenu, "TitanChassisImage" )
	foreach ( element in elements )
		element.Show()
}

function OnOpenDecalSelectMenu()
{
	Assert( uiGlobal.itemTypeBeingEdited != null )
	Assert( uiGlobal.loadoutBeingEdited != null )

	local menu = GetMenu( "DecalSelectMenu" )

	local buttons = GetElementsByClassname( menu, "DecalSelectClass" )
	buttons[0].ReturnToBasePos()
	local unsortedDecals = GetAllItemsOfType( uiGlobal.itemTypeBeingEdited )
	local currentDecal = uiGlobal.loadoutBeingEdited[ GetPropertyNameFromItemType( uiGlobal.itemTypeBeingEdited ) ]

	// Sort the decals for the menu
	local unlockedDecals = []
	local lockedDecals = []
	foreach( decal in unsortedDecals )
	{
		if ( IsItemLocked( decal.ref ) )
		{
			if ( !GetDecalHidden( decal.ref ) )
				lockedDecals.append( decal )
		}
		else
			unlockedDecals.append( decal )
	}
	local sortedDecals = []
	sortedDecals.extend( unlockedDecals )
	sortedDecals.extend( lockedDecals )

	//chad - temp for testing ( makes decals not resort based on unlock )
	//sortedDecals = unsortedDecals

	UpdateDecalButtons( buttons, sortedDecals, currentDecal, true )

	RegisterButtonPressedCallback( MOUSE_WHEEL_UP, OnDecalButtonsScrollUp )
	RegisterButtonPressedCallback( MOUSE_WHEEL_DOWN, OnDecalButtonsScrollDown )
}

function OnCloseDecalSelectMenu()
{
	DeregisterButtonPressedCallback( MOUSE_WHEEL_UP, OnDecalButtonsScrollUp )
	DeregisterButtonPressedCallback( MOUSE_WHEEL_DOWN, OnDecalButtonsScrollDown )
}

function OnPageItemButton_Activate( button )
{
	Assert( uiGlobal.activeMenu.HasPages() )
	Assert( uiGlobal.itemTypeBeingEdited != null )
	Assert( uiGlobal.loadoutTypeBeingEdited == "pilot" || uiGlobal.loadoutTypeBeingEdited == "titan" )

	if ( button.IsLocked() )
		return

	local buttonID = button.GetScriptID().tointeger()
	local page = uiGlobal.activeMenu.GetPage()
	local ref

	if ( "ref" in button.s )
		ClearRefNew( button.s.ref )

	if ( page == "attachments" || page == "mods" )
	{
		if ( page == "mods" && buttonID == 0 )
		{
			ref = null // player selected none
		}
		else
		{
			if ( page == "attachments" )
				ref = GetAttachmentForItemIndex( uiGlobal.parentItemBeingEdited, buttonID )
			else
				ref = GetModForItemIndex( uiGlobal.parentItemBeingEdited, buttonID - 1 )
		}
	}
	else
	{
		ref = GetItemForTypeIndex( uiGlobal.itemTypeBeingEdited, buttonID )
	}

	local menu
	if ( uiGlobal.loadoutTypeBeingEdited == "pilot" )
		menu = GetMenu( "EditPilotLoadoutMenu" )
	else
		menu = GetMenu( "EditTitanLoadoutMenu" )

	local loadoutSlotBeingEdited = menu.loadoutIDBeingEdited
	local page = uiGlobal.activeMenu.GetPage()

	if ( page == "weapons" )
	{
		local clearSubitems = false
		if ( uiGlobal.itemBeingEdited != ref ) // Changed parent weapon
			clearSubitems = true

		uiGlobal.itemBeingEdited = ref
		uiGlobal.parentItemBeingEdited = ref
		uiGlobal.subitemBeingEdited = null

		local itemPropertyName = GetPropertyNameFromItemType( uiGlobal.itemTypeBeingEdited )
		UI_SetLoadoutProperty( uiGlobal.loadoutTypeBeingEdited, loadoutSlotBeingEdited, itemPropertyName, ref )

		if ( clearSubitems )
		{
			if ( ItemSupportsAttachments( uiGlobal.parentItemBeingEdited ) )
			{
				local attachmentPropertyName = GetPropertyNameFromItemType( GetItemType( uiGlobal.parentItemBeingEdited ) ) + "Attachment"
				UI_SetLoadoutProperty( uiGlobal.loadoutTypeBeingEdited, loadoutSlotBeingEdited, attachmentPropertyName, null )
			}

			if ( ItemSupportsMods( uiGlobal.parentItemBeingEdited ) )
			{
				local modPropertyName = GetPropertyNameFromItemType( GetItemType( uiGlobal.parentItemBeingEdited ) ) + "Mod"
				UI_SetLoadoutProperty( uiGlobal.loadoutTypeBeingEdited, loadoutSlotBeingEdited, modPropertyName, null )
			}
		}

		if ( ItemAttachmentsExist( uiGlobal.parentItemBeingEdited ) )
			ChangePage( "attachments" )
		else if ( ItemModsExist( uiGlobal.parentItemBeingEdited ) )
			ChangePage( "mods" )
		else
			CloseSubmenu()
	}
	else if ( page == "attachments" )
	{
		uiGlobal.subitemBeingEdited = ref

		local attachmentPropertyName = GetPropertyNameFromItemType( GetItemType( uiGlobal.parentItemBeingEdited ) ) + "Attachment"
		UI_SetLoadoutProperty( uiGlobal.loadoutTypeBeingEdited, loadoutSlotBeingEdited, attachmentPropertyName, ref )

		if ( ItemModsExist( uiGlobal.parentItemBeingEdited ) )
			ChangePage( "mods" )
		else
			CloseSubmenu()
	}
	else if ( page == "mods" )
	{
		uiGlobal.subitemBeingEdited = ref

		local modPropertyName = GetPropertyNameFromItemType( GetItemType( uiGlobal.parentItemBeingEdited ) ) + "Mod"
		UI_SetLoadoutProperty( uiGlobal.loadoutTypeBeingEdited, loadoutSlotBeingEdited, modPropertyName, ref )

		CloseSubmenu()
	}
}

function OnAbilityOrPassiveSelectButton_Activate( button )
{
	if ( button.IsLocked() )
		return

	Assert( uiGlobal.itemTypeBeingEdited != null )
	Assert( uiGlobal.loadoutTypeBeingEdited == "pilot" || uiGlobal.loadoutTypeBeingEdited == "titan" )

	local buttonID = button.GetScriptID().tointeger()
	local ref = GetItemForTypeIndex( uiGlobal.itemTypeBeingEdited, buttonID )

	local menu
	if ( uiGlobal.loadoutTypeBeingEdited == "pilot" )
		menu = GetMenu( "EditPilotLoadoutMenu" )
	else
		menu = GetMenu( "EditTitanLoadoutMenu" )

	local loadoutSlotBeingEdited = menu.loadoutIDBeingEdited
	local itemPropertyName = GetPropertyNameFromItemType( uiGlobal.itemTypeBeingEdited )

	UI_SetLoadoutProperty( uiGlobal.loadoutTypeBeingEdited, loadoutSlotBeingEdited, itemPropertyName, ref )
	ClearRefNew( ref )

	CloseSubmenu()
}

function OnTitanOSSelectButton_Focused( button )
{
	Assert( uiGlobal.itemTypeBeingEdited != null )

	local menu = GetMenu( "TitanOSSelectMenu" )
	local buttonID = button.GetScriptID().tointeger()
	local voiceChoices = GetAllItemsOfType( uiGlobal.itemTypeBeingEdited )
	local voiceChoice = voiceChoices[ buttonID ]
	local voiceChoiceRef = GetRefFromItem( voiceChoice )

	UpdateLockElements( menu, button, "titanos", voiceChoiceRef )

	local elements = GetElementsByClassname( menu, "TitanOSNameClass" )
	foreach ( element in elements )
		SetTextFromItemName( element, voiceChoiceRef )

	local elements = GetElementsByClassname( menu, "TitanOSDescClass" )
	foreach ( element in elements )
		SetTextFromItemLongDescription( element, voiceChoiceRef )

	local elements = GetElementsByClassname( menu, "TitanOSIconClass" )
	foreach ( element in elements )
		SetImageFromItemIcon( element, voiceChoiceRef )

	thread PlayOSVoiceRandomSample( voiceChoiceRef )


}

function PlayOSVoiceRandomSample( voiceChoiceRef )
{
	Signal( uiGlobal.signalDummy, "PlayOSVoiceRandomSample" )
	EndSignal( uiGlobal.signalDummy, "PlayOSVoiceRandomSample" )
	local soundAliasTable = {} //Need to make a table instead of a free variable because if you pass in free variable into OnThreadEnd it will take the value of free variable at OnThreadEnd declaration
	soundAliasTable.soundAlias <- null

	OnThreadEnd(
		function() : ( soundAliasTable )
		{
			//printt( "uiGlobal.signalDummy.soundAlias : " + uiGlobal.signalDummy.soundAlias )
			if ( soundAliasTable.soundAlias )
				StopUISound( soundAliasTable.soundAlias )
		}
	)

	wait 0.5 //Slight debounce time

	local randomIndex = RandomInt( 0, titanOsVoiceSelectionSuffix.len() )
	local pastRandomIndex = -1

	for ( local i = 0; i < 3; ++i ) //Make it only play 3 times instead of looping forever
	{
		while( pastRandomIndex == randomIndex ) //Keep rerolling until we don't get the same as before
		{
			randomIndex = RandomInt( 0, titanOsVoiceSelectionSuffix.len() )
		}

		//printt( "playing new random sound" )

		pastRandomIndex = randomIndex

		soundAliasTable.soundAlias = "diag_gs_titan" + TITAN_OS_VOICE_PACK[ voiceChoiceRef ] + titanOsVoiceSelectionSuffix[ randomIndex ] //String concatenation :/

		local duration = EmitUISound( soundAliasTable.soundAlias )

		wait duration + 5.0
	}
}

function OnTitanOSSelectButton_LostFocus( button )
{
	Assert( uiGlobal.itemTypeBeingEdited != null )

	Signal( uiGlobal.signalDummy, "PlayOSVoiceRandomSample" ) //Kills sound played in PlayOSVoiceRandomSample

	local menu = GetMenu( "TitanOSSelectMenu" )
	local buttonID = button.GetScriptID().tointeger()
	local voiceChoices = GetAllItemsOfType( uiGlobal.itemTypeBeingEdited )
	local voice = voiceChoices[ buttonID ]
	local voiceRef = GetRefFromItem( voice )

	ClearRefNew( voiceRef )
	UpdateNewElements( button, voiceRef )
}

function OnTitanOSSelectButton_Activate( button )
{
	if ( button.IsLocked() )
		return

	Assert( uiGlobal.itemTypeBeingEdited != null )
	Assert( uiGlobal.loadoutTypeBeingEdited == "titan" )

	local buttonID = button.GetScriptID().tointeger()
	local ref = GetItemForTypeIndex( uiGlobal.itemTypeBeingEdited, buttonID )

	printt( "ButtonID: " + buttonID )

	local menu = GetMenu( "EditTitanLoadoutMenu" )

	local loadoutSlotBeingEdited = menu.loadoutIDBeingEdited
	local itemPropertyName = GetPropertyNameFromItemType( uiGlobal.itemTypeBeingEdited )

	printt( "loadoutIDBeingEdited: " + loadoutSlotBeingEdited )
	printt( "itemPropertyName: " + itemPropertyName )
	printt( "ref: " + ref )

	UI_SetLoadoutProperty( uiGlobal.loadoutTypeBeingEdited, loadoutSlotBeingEdited, itemPropertyName, ref )
	ClearRefNew( ref )

	CloseSubmenu()
}

function OnTitanSelectButton_Activate( button )
{
	if ( button.IsLocked() )
		return

	Assert( uiGlobal.itemTypeBeingEdited != null )
	Assert( uiGlobal.loadoutTypeBeingEdited == "pilot" || uiGlobal.loadoutTypeBeingEdited == "titan" )

	local buttonID = button.GetScriptID().tointeger()
	local ref = GetItemForTypeIndex( uiGlobal.itemTypeBeingEdited, buttonID )

	local menu
	if ( uiGlobal.loadoutTypeBeingEdited == "pilot" )
		menu = GetMenu( "EditPilotLoadoutMenu" )
	else
		menu = GetMenu( "EditTitanLoadoutMenu" )

	local loadoutSlotBeingEdited = menu.loadoutIDBeingEdited
	local itemPropertyName = GetPropertyNameFromItemType( uiGlobal.itemTypeBeingEdited )

	UI_SetLoadoutProperty( uiGlobal.loadoutTypeBeingEdited, loadoutSlotBeingEdited, itemPropertyName, ref )
	ClearRefNew( ref )

	CloseSubmenu()
}

function UpdateTitleAndBreadcrumbs( menu, pageName )
{
	if ( pageName == "weapons" )
	{
		local elements = GetElementsByClassname( menu, "PageTitleClass" )
		foreach ( element in elements )
		{
			switch ( uiGlobal.itemTypeBeingEdited )
			{
				case itemType.PILOT_PRIMARY:
				case itemType.TITAN_PRIMARY:
					element.SetText( "#PRIMARY_WEAPON" )
					break
				case itemType.PILOT_SIDEARM:
					element.SetText( "#SIDEARM" )
					break
				case itemType.PILOT_SECONDARY:
					element.SetText( "#ANTI_TITAN_WEAPON" )
					break

				default:
			}
		}

		local elements = GetElementsByClassname( menu, "PageTitleBreadcrumbClass" )
		foreach ( element in elements )
			element.SetText( "" )
	}
	else if ( pageName == "attachments" )
	{
		local parentItem = uiGlobal.parentItemBeingEdited

		local elements = GetElementsByClassname( menu, "PageTitleClass" )
		foreach ( element in elements )
			element.SetText( "#ITEM_TYPE_WEAPON_ATTACHMENT" )

		local elements = GetElementsByClassname( menu, "PageTitleBreadcrumbClass" )
		foreach ( element in elements )
			element.SetText( "#MENU_BREADCRUMBS_1", GetItemName( parentItem ) )
	}
	else if ( pageName == "mods" )
	{
		local parentItem = uiGlobal.parentItemBeingEdited

		local elements = GetElementsByClassname( menu, "PageTitleClass" )
		foreach ( element in elements )
			element.SetText( "#ITEM_TYPE_WEAPON_MOD" )

		local subItem = uiGlobal.subitemBeingEdited

		if ( ItemSupportsAttachments( parentItem ) && subItem )
		{
			local subItemText = GetSubitemName( parentItem, subItem )

			local elements = GetElementsByClassname( menu, "PageTitleBreadcrumbClass" )
			foreach ( element in elements )
				element.SetText( "#MENU_BREADCRUMBS_2", GetItemName( parentItem ), subItemText )
		}
		else
		{
			local elements = GetElementsByClassname( menu, "PageTitleBreadcrumbClass" )
			foreach ( element in elements )
				element.SetText( "#MENU_BREADCRUMBS_1", GetItemName( parentItem ) )
		}
	}
}


function ChangePage( pageName )
{
	Assert( uiGlobal.loadoutBeingEdited != null )
	Assert( uiGlobal.itemTypeBeingEdited != null )

	local menu = GetMenu( "WeaponSelectMenu" )
	local buttons = GetElementsByClassname( menu, "PageClass" )
	local menuTitle = menu.GetChild( "LblInfoPanelItemType" )
	local items
	local parentItem
	local parentItemType
	local currentItem
	local buttonOffset = -1

	if ( pageName == "weapons" )
	{
		Assert( uiGlobal.itemTypeBeingEdited )

		menuTitle.SetText( GetDisplayNameFromItemType( uiGlobal.itemTypeBeingEdited ) )
		items = GetAllItemsOfType( uiGlobal.itemTypeBeingEdited )
		currentItem = uiGlobal.loadoutBeingEdited[ GetPropertyNameFromItemType( uiGlobal.itemTypeBeingEdited ) ]
		buttonOffset = 0

		ClearAttachmentAndModElements( menu )
		UpdateTitleAndBreadcrumbs( menu, pageName )
	}
	else if ( pageName == "attachments" )
	{
		parentItem = uiGlobal.parentItemBeingEdited
		parentItemType = GetItemType( parentItem )

		Assert( parentItemType == itemType.PILOT_PRIMARY )
		uiGlobal.subitemTypeBeingEdited = itemType.PILOT_PRIMARY_ATTACHMENT

		menuTitle.SetText( GetDisplayNameFromItemType( uiGlobal.subitemTypeBeingEdited ) )
		items = GetAllItemAttachments( parentItem )
		currentItem = uiGlobal.loadoutBeingEdited[ GetPropertyNameFromItemType( uiGlobal.subitemTypeBeingEdited ) ]
		buttonOffset = 0

		ClearAttachmentAndModElements( menu )
		ShowAttachmentElements( menu )
		UpdateTitleAndBreadcrumbs( menu, pageName )
	}
	else
	{
		Assert( pageName == "mods" )

		parentItem = uiGlobal.parentItemBeingEdited
		parentItemType = GetItemType( parentItem )

		if ( parentItemType == itemType.PILOT_PRIMARY )
		{
			uiGlobal.subitemTypeBeingEdited = itemType.PILOT_PRIMARY_MOD
		}
		else
		{
			Assert( parentItemType == itemType.TITAN_PRIMARY )
			uiGlobal.subitemTypeBeingEdited = itemType.TITAN_PRIMARY_MOD
		}

		menuTitle.SetText( GetDisplayNameFromItemType( uiGlobal.subitemTypeBeingEdited ) )
		items = GetAllItemMods( parentItem )
		currentItem = uiGlobal.loadoutBeingEdited[ GetPropertyNameFromItemType( uiGlobal.subitemTypeBeingEdited ) ]

		ShowModElements( menu )
		UpdateTitleAndBreadcrumbs( menu, pageName )
	}

	//printt( "currentItem:", currentItem )
	Assert( buttons[0].GetScriptID().tointeger() == 0 )
	if ( buttonOffset != 0 )
	{
		buttons[0].SetText( "#MOD_SELECT_STOCK" )
		buttons[0].SetEnabled( true )
		buttons[0].SetLocked( false )
	}

	if ( currentItem == null )
	{
		buttons[0].SetSelected( true )
		if ( IsControllerModeActive() )
			buttons[0].SetFocused()
	}
	else
	{
		buttons[0].SetSelected( false )
	}

	local focusSelected = IsControllerModeActive() // with mouse, don't focus the selected item, or it makes it difficult to change focus to the thing the mouse is already under

	PrepareLoadoutSubmenuButtons( buttons, buttonOffset, items, currentItem, parentItem, focusSelected )

	// Show hover for item we are editing
	UpdatePageHover( menu, pageName )

	menu.SetPage( pageName )

	UpdatePage()
}


function UpdatePageHover( menu, pageName )
{
	local hoverElems = {}
	hoverElems[ "weapons" ] <- GetElementsByClassname( menu, "WeaponBackgroundHoverClass" )[0]
	hoverElems[ "attachments" ] <- GetElementsByClassname( menu, "AttachmentBackgroundHoverClass" )[0]
	hoverElems[ "mods" ] <- GetElementsByClassname( menu, "ModBackgroundHoverClass" )[0]

	foreach( name, elem in hoverElems )
		name == pageName ? elem.Show() : elem.Hide()
}

function UpdatePage()
{
	Assert( uiGlobal.loadoutBeingEdited != null )
	Assert( uiGlobal.itemTypeBeingEdited != null )

	local menu = GetMenu( "WeaponSelectMenu" )
	local buttons = GetElementsByClassname( menu, "PageClass" )
	local items
	local parentItem
	local parentItemType
	local currentItem
	local buttonOffset = -1

	local pageName = menu.GetPage()

	if ( pageName == "weapons" )
	{
		items = GetAllItemsOfType( uiGlobal.itemTypeBeingEdited )
		buttonOffset = 0
		currentItem = uiGlobal.loadoutBeingEdited[ GetPropertyNameFromItemType( uiGlobal.itemTypeBeingEdited ) ]
	}
	else if ( pageName == "attachments" )
	{
		parentItem = uiGlobal.parentItemBeingEdited

		items = GetAllItemAttachments( parentItem )
		currentItem = uiGlobal.loadoutBeingEdited[ GetPropertyNameFromItemType( uiGlobal.subitemTypeBeingEdited ) ]
		buttonOffset = 0
	}
	else
	{
		Assert( pageName == "mods" )

		parentItem = uiGlobal.parentItemBeingEdited

		items = GetAllItemMods( parentItem )
		currentItem = uiGlobal.loadoutBeingEdited[ GetPropertyNameFromItemType( uiGlobal.subitemTypeBeingEdited ) ]
	}

	//printt( "PREPARE LOADOUT BUTTONS: " + currentItem + "; focus selected " + focusSelected )
	foreach ( button in buttons )
	{
		local buttonID = button.GetScriptID().tointeger() + buttonOffset

		if ( button.IsFocused() )
			OnPageItemButton_Focused( button )

		if ( buttonID < 0 )
			continue

		if ( buttonID < items.len() )
		{
			local item = items[buttonID]

			if ( ItemTypeIsAttachment( item.type ) || ItemTypeIsMod( item.type ) )
			{
				button.SetNew( HasAnyNewItem( item.parentRef + "_" + item.ref ) )
			}
			else
			{
				button.SetNew( HasAnyNewItem( item.ref ) )
			}
		}
		else
		{
			button.SetNew( false )
		}
	}
}


function OnPageItemButton_LostFocus( button )
{
	local menu = GetMenu( "WeaponSelectMenu" )
	local buttonID = button.GetScriptID().tointeger()

	if ( !menu.s.newFocusRef )
		return

	ClearRefNew( menu.s.newFocusRef )
	UpdatePage()

	menu.s.newFocusRef = null
}



function OnPageItemButton_Focused( button )
{
	local menu = GetMenu( "WeaponSelectMenu" )
	local buttonID = button.GetScriptID().tointeger()

	if ( menu.HasPages() )
	{
		local page = menu.GetPage()

		if ( page == "weapons" )
		{
			Assert( uiGlobal.itemTypeBeingEdited != null )

			local weapons = GetAllItemsOfType( uiGlobal.itemTypeBeingEdited )

			if ( buttonID >= weapons.len() )
				return

			local weapon = weapons[buttonID]
			local weaponRef = GetRefFromItem( weapon )

			menu.s.newFocusRef = weaponRef
			UpdateLockElements( menu, button, page, weaponRef )

			local elements = GetElementsByClassname( menu, "WeaponNameClass" )
			foreach ( element in elements )
				SetTextFromItemName( element, weaponRef )

			local elements = GetElementsByClassname( menu, "ItemDescClass" )
			foreach ( element in elements )
				SetTextFromItemLongDescription( element, weaponRef )

			local elements = GetElementsByClassname( menu, "WeaponImageClass" )
			foreach ( element in elements )
				SetImageFromItemImage( element, weaponRef )


			local elements = GetElementsByClassname( menu, "DamageBarClass" )
			foreach ( element in elements )
				SetBarFromItemDamageStat( element, weaponRef )

			local elements = GetElementsByClassname( menu, "AccuracyBarClass" )
			foreach ( element in elements )
				SetBarFromItemAccuracyStat( element, weaponRef )

			local elements = GetElementsByClassname( menu, "RangeBarClass" )
			foreach ( element in elements )
				SetBarFromItemRangeStat( element, weaponRef )

			local elements = GetElementsByClassname( menu, "FireRateBarClass" )
			foreach ( element in elements )
				SetBarFromItemFireRateStat( element, weaponRef )

			local elements = GetElementsByClassname( menu, "ClipSizeClass" )
			foreach ( element in elements )
				SetTextFromItemClipSize( element, weaponRef )

			local elements = GetElementsByClassname( menu, "ClipSizeModClass" )
			foreach ( element in elements )
				element.SetText("")
		}
		else if ( page == "attachments" )
		{
			Assert( uiGlobal.itemBeingEdited != null )

			local attachmentRef

			local attachments = GetAllItemAttachments( uiGlobal.itemBeingEdited )

			if ( buttonID >= attachments.len() )
				return

			local attachment = attachments[buttonID]
			attachmentRef = GetRefFromItem( attachment )

			if ( attachmentRef )
				menu.s.newFocusRef = uiGlobal.itemBeingEdited + "_" + attachmentRef
			else
				menu.s.newFocusRef = null

			UpdateLockElements( menu, button, page, uiGlobal.itemBeingEdited, attachmentRef )

			local elements = GetElementsByClassname( menu, "AttachmentNameClass" )
			foreach ( element in elements )
				SetTextFromSubitemName( element, uiGlobal.itemBeingEdited, attachmentRef )

			local elements = GetElementsByClassname( menu, "ItemDescClass" )
			foreach ( element in elements )
				SetTextFromSubitemLongDescription( element, uiGlobal.itemBeingEdited, attachmentRef )

			local elements = GetElementsByClassname( menu, "AttachmentIconClass" )
			foreach ( element in elements )
				SetImageFromSubitemIcon( element, uiGlobal.itemBeingEdited, attachmentRef )
		}
		else if ( page == "mods" )
		{
			Assert( uiGlobal.itemBeingEdited != null )

			local modRef

			if ( buttonID == 0 )
			{
				modRef = null
			}
			else
			{
				local mods = GetAllItemMods( uiGlobal.itemBeingEdited )

				if ( buttonID > mods.len() )
					return

				local mod = mods[ buttonID - 1 ]
				modRef = GetRefFromItem( mod )
			}

			if ( modRef )
				menu.s.newFocusRef = uiGlobal.itemBeingEdited + "_" + modRef
			else
				menu.s.newFocusRef = null

			UpdateLockElements( menu, button, page, uiGlobal.itemBeingEdited, modRef )

			local elements = GetElementsByClassname( menu, "ModNameClass" )
			foreach ( element in elements )
				SetTextFromSubitemName( element, uiGlobal.itemBeingEdited, modRef, "#MOD_SELECT_STOCK" )

			local elements = GetElementsByClassname( menu, "ItemDescClass" )
			foreach ( element in elements )
				SetTextFromSubitemLongDescription( element, uiGlobal.itemBeingEdited, modRef, "#MOD_STOCK_DESC" )

			local elements = GetElementsByClassname( menu, "ModIconClass" )
			foreach ( element in elements )
				SetImageFromSubitemIcon( element, uiGlobal.itemBeingEdited, modRef, MOD_ICON_NONE )

			local elements = GetElementsByClassname( menu, "DamageBarClass" )
			foreach ( element in elements )
				SetBarFromItemDamageStat( element, uiGlobal.itemBeingEdited, modRef )

			local elements = GetElementsByClassname( menu, "AccuracyBarClass" )
			foreach ( element in elements )
				SetBarFromItemAccuracyStat( element, uiGlobal.itemBeingEdited, modRef )

			local elements = GetElementsByClassname( menu, "RangeBarClass" )
			foreach ( element in elements )
				SetBarFromItemRangeStat( element, uiGlobal.itemBeingEdited, modRef )

			local elements = GetElementsByClassname( menu, "FireRateBarClass" )
			foreach ( element in elements )
				SetBarFromItemFireRateStat( element, uiGlobal.itemBeingEdited, modRef )

			local elements = GetElementsByClassname( menu, "ClipSizeClass" )
			foreach ( element in elements )
				SetTextFromItemClipSize( element, uiGlobal.itemBeingEdited )

			local elements = GetElementsByClassname( menu, "ClipSizeModClass" )
			foreach ( element in elements )
				SetTextFromSubItemClipSize( element, uiGlobal.itemBeingEdited, modRef )
		}
	}
}

function OnAbilitySelectButton_Focused( button )
{
	Assert( uiGlobal.itemTypeBeingEdited != null )

	local menu = GetMenu( "AbilitySelectMenu" )
	local buttonID = button.GetScriptID().tointeger()
	local abilities = GetAllItemsOfType( uiGlobal.itemTypeBeingEdited )
	local ability = abilities[buttonID]
	local abilityRef = GetRefFromItem( ability )

	UpdateLockElements( menu, button, "ability", abilityRef )

	local elements = GetElementsByClassname( menu, "AbilityNameClass" )
	foreach ( element in elements )
		SetTextFromItemName( element, abilityRef )

	local elements = GetElementsByClassname( menu, "AbilityDescClass" )
	foreach ( element in elements )
		SetTextFromItemLongDescription( element, abilityRef )

	local elements = GetElementsByClassname( menu, "AbilityIconClass" )
	foreach ( element in elements )
		SetImageFromItemIcon( element, abilityRef )
}


function OnAbilitySelectButton_LostFocus( button )
{
	Assert( uiGlobal.itemTypeBeingEdited != null )

	local menu = GetMenu( "AbilitySelectMenu" )
	local buttonID = button.GetScriptID().tointeger()
	local abilities = GetAllItemsOfType( uiGlobal.itemTypeBeingEdited )
	local ability = abilities[buttonID]
	local abilityRef = GetRefFromItem( ability )

	ClearRefNew( abilityRef )
	UpdateNewElements( button, abilityRef )
}


function OnPassiveSelectButton_Focused( button )
{
	Assert( uiGlobal.itemTypeBeingEdited != null )

	local menu = GetMenu( "PassiveSelectMenu" )
	local buttonID = button.GetScriptID().tointeger()
	local passives = GetAllItemsOfType( uiGlobal.itemTypeBeingEdited )
	local passive = passives[buttonID]
	local passiveRef = GetRefFromItem( passive )

	UpdateLockElements( menu, button, "passive", passiveRef )

	local elements = GetElementsByClassname( menu, "PassiveNameClass" )
	foreach ( element in elements )
		SetTextFromItemName( element, passiveRef )

	local elements = GetElementsByClassname( menu, "PassiveDescClass" )
	foreach ( element in elements )
		SetTextFromItemLongDescription( element, passiveRef )

	local elements = GetElementsByClassname( menu, "PassiveIconClass" )
	foreach ( element in elements )
		SetImageFromItemIcon( element, passiveRef )
}

function OnPassiveSelectButton_LostFocus( button )
{
	Assert( uiGlobal.itemTypeBeingEdited != null )

	local menu = GetMenu( "PassiveSelectMenu" )
	local buttonID = button.GetScriptID().tointeger()
	local passives = GetAllItemsOfType( uiGlobal.itemTypeBeingEdited )
	local passive = passives[buttonID]
	local passiveRef = GetRefFromItem( passive )

	ClearRefNew( passiveRef )
	UpdateNewElements( button, passiveRef )
}

function OnTitanSelectButton_Focused( button )
{
	Assert( uiGlobal.itemTypeBeingEdited != null )

	local menu = GetMenu( "TitanSelectMenuTTP" )
	local buttonID = button.GetScriptID().tointeger()
	local setFiles = GetAllItemsOfType( uiGlobal.itemTypeBeingEdited )
	local setFile = setFiles[buttonID]
	local setFileRef = GetRefFromItem( setFile )

	UpdateLockElements( menu, button, "setFile", setFileRef )

	local elements = GetElementsByClassname( menu, "TitanNameClass" )
	foreach ( element in elements )
		SetTextFromItemName( element, setFileRef )

	local elements = GetElementsByClassname( menu, "TitanDescClass" )
	foreach ( element in elements )
		SetTextFromItemLongDescription( element, setFileRef )

	local elements = GetElementsByClassname( menu, "AdditionalNameBarClass" )
	foreach ( element in elements )
		SetTextFromItemAdditionalName( element, setFileRef )

	local elements = GetElementsByClassname( menu, "TitanAdditionalDescClass" )
	foreach ( element in elements )
		SetTextFromItemAdditionalDescription( element, setFileRef )

	local elements = GetElementsByClassname( menu, "TitanImageClass" )
	foreach ( element in elements )
		SetImageFromItemTeamImages( element, setFileRef, GetTeam() )

	local elements = GetElementsByClassname( menu, "CoreImageClass" )
	foreach ( element in elements )
		SetImageFromItemCoreImage( element, setFileRef )

	local elements = GetElementsByClassname( menu, "SpeedBarClass" )
	foreach ( element in elements )
		SetBarFromItemSpeedStat( element, setFileRef )

	local elements = GetElementsByClassname( menu, "AccelBarClass" )
	foreach ( element in elements )
		SetBarFromItemAccelStat( element, setFileRef )

	local elements = GetElementsByClassname( menu, "HealthBarClass" )
	foreach ( element in elements )
		SetBarFromItemHealthStat( element, setFileRef )

	local elements = GetElementsByClassname( menu, "DashCountClass" )
	foreach ( element in elements )
		SetTextFromItemDashCount( element, setFileRef )
}



function OnTitanSelectButton_LostFocus( button )
{
	Assert( uiGlobal.itemTypeBeingEdited != null )

	local menu = GetMenu( "TitanSelectMenuTTP" )
	local buttonID = button.GetScriptID().tointeger()
	local setFiles = GetAllItemsOfType( uiGlobal.itemTypeBeingEdited )
	local setFile = setFiles[buttonID]
	local setFileRef = GetRefFromItem( setFile )

	ClearRefNew( setFileRef )
	UpdateNewElements( button, setFileRef )
}

function OnDecalSelectButton_Activate( button )
{
	if ( button.IsLocked() )
		return

	Assert( uiGlobal.itemTypeBeingEdited != null )
	Assert( uiGlobal.loadoutTypeBeingEdited == "titan" )
	Assert( "ref" in button.s )
	Assert( button.s.ref != null )

	local buttonID = button.GetScriptID().tointeger()
	local decalRef = button.s.ref

	local menu = GetMenu( "EditTitanLoadoutMenu" )

	local loadoutSlotBeingEdited = menu.loadoutIDBeingEdited
	local itemPropertyName = GetPropertyNameFromItemType( uiGlobal.itemTypeBeingEdited )

	UI_SetLoadoutProperty( uiGlobal.loadoutTypeBeingEdited, loadoutSlotBeingEdited, itemPropertyName, decalRef )
	ClearRefNew( decalRef )

	CloseSubmenu()
}

function OnDecalSelectButton_Focused( button )
{
	Assert( uiGlobal.itemTypeBeingEdited != null )
	Assert( "ref" in button.s )
	Assert( button.s.ref != null )
	Assert( numDecalRowsOffScreen != null )

	local menu = GetMenu( "DecalSelectMenu" )
	local buttonID = button.GetScriptID().tointeger()
	local decalRef = button.s.ref

	// Update window scrolling if we highlight a decal not in view
	local row = buttonID / DECAL_MENU_DECALS_PER_ROW
	local numberOfDecals = GetAllRefsOfType( itemType.TITAN_DECAL ).len()
	local maxRows = floor( ( numberOfDecals + DECAL_MENU_DECALS_PER_ROW - 1 ) / DECAL_MENU_DECALS_PER_ROW )
	local minScrollState = clamp( row - (DECAL_MENU_VISIBLE_ROWS - 1), 0, numDecalRowsOffScreen )
	local maxScrollState = clamp( row, 0, numDecalRowsOffScreen )
	if ( uiGlobal.decalScrollState < minScrollState )
		uiGlobal.decalScrollState = minScrollState
	if ( uiGlobal.decalScrollState > maxScrollState )
		uiGlobal.decalScrollState = maxScrollState
	DecalButtonsScrollUpdate()

	local elements = GetElementsByClassname( menu, "DecalNameClass" )
	foreach ( element in elements )
		SetTextFromItemName( element, decalRef )

	local elements = GetElementsByClassname( menu, "DecalDescClass" )
	foreach ( element in elements )
		SetTextFromItemLongDescription( element, decalRef )

	local elements = GetElementsByClassname( menu, "DecalIconClass" )
	foreach ( element in elements )
		SetImageFromItemImage( element, decalRef )

	local unlockData = GetDecalUnlockData( decalRef )

	// unlock header, requirements, and progress
	local headerText = unlockData.unlocked ? "#DECAL_UNLOCK_REQUIREMENT_UNLOCKED_HEADER" : "#DECAL_UNLOCK_REQUIREMENT_HEADER"
	local headerElements = GetElementsByClassname( menu, "DecalReqHeaderClass" )
	local reqTextElements = GetElementsByClassname( menu, "DecalReqClass" )
	local progressElements = GetElementsByClassname( menu, "DecalProgressClass" )
	foreach ( element in headerElements )
	{
		if ( unlockData.unlockText != null )
		{
			element.SetText( headerText )
			element.Show()
		}
		else
			element.Hide()
	}
	foreach ( element in reqTextElements )
	{
		if ( unlockData.unlockText != null )
		{
			element.SetText( unlockData.unlockText, unlockData.goal )
			element.Show()
		}
		else
			element.Hide()
	}
	foreach ( element in progressElements )
	{
		if ( unlockData.unlockText != null && !unlockData.unlocked && !PersistenceEnumValueIsValid( "BlackMarketUnlocks", button.s.ref ) )
		{
			element.SetText( "#DECAL_UNLOCK_PROGRESS_WITH_PERCENTAGE", unlockData.progress, unlockData.goal, GetPercent( unlockData.progress, unlockData.goal, 0 ) )
			element.Show()
		}
		else
			element.Hide()
	}

	local lockLabel = GetElementsByClassname( menu, "LblDLCRequired" )[0]
	if ( IsDLCMapGroupEnabledForLocalPlayer( unlockData.dlcGroup ) )
		lockLabel.Hide()
	else
		lockLabel.Show()
}

function OnDecalSelectButton_LostFocus( button )
{
	Assert( uiGlobal.itemTypeBeingEdited != null )

	local menu = GetMenu( "DecalSelectMenu" )
	if ( !( "ref" in button.s ) || button.s.ref == null )
		return

	ClearRefNew( button.s.ref )

	UpdateNewElements( button, button.s.ref )
}

function UpdateLockElements( menu, button, page, ref, childRef = null )
{
	// Defaults for item unlocked
	local lockElements = GetElementsByClassname( menu, "ItemLockedClass" )
	foreach ( element in lockElements )
		element.Hide()

	if ( page == "setFile" )
	{
		local titanImage = GetElem( menu, "TitanImageClass" )
		local lockedLabel = GetElem( menu, "LblChassisLockedText" )
		lockedLabel.Hide()
		titanImage.SetAlpha( 255 )
		if ( button.IsLocked() )
		{
			if ( ref == "titan_stryder" )
				lockedLabel.SetText( "#CHASSIS_LOCKED_TEXT_STRYDER", unlockLevels[ "titan_stryder"] )
			else if ( ref == "titan_ogre" )
				lockedLabel.SetText( "#CHASSIS_LOCKED_TEXT_OGRE", unlockLevels[ "titan_ogre"] )
			else if( MasterModdedTitans.len() > 0 )
			{
				local loop_max = MasterModdedTitans.len()
				for( local E = 0; E < loop_max; E++ )
				{
					if( loop_max > 0 )
					{
						local t_a = MasterModdedTitans[ E ]
						
						if ( ref == t_a.setfile )
							lockedLabel.SetText( "#CHASSIS_LOCKED_TEXT_OGRE", unlockLevels[ t_a.setfile ] )
					}
				}
			}
			else
				Assert( 0, "Unhandled setfile unlock case" )
			lockedLabel.Show()
			titanImage.SetAlpha( 150 )
		}
		return
	}

	local lockLabel = null
	local itemImage = null
	switch( page )
	{
		case "weapons":
			lockLabel = GetElementsByClassname( menu, "LblWeaponLocked" )[0]
			itemImage = GetElementsByClassname( menu, "WeaponImageClass" )[0]
			break
		case "attachments":
			lockLabel = GetElementsByClassname( menu, "LblAttachmentLocked" )[0]
			itemImage = GetElementsByClassname( menu, "AttachmentIconClass" )[0]
			break
		case "mods":
			lockLabel = GetElementsByClassname( menu, "LblModLocked" )[0]
			itemImage = GetElementsByClassname( menu, "ModIconClass" )[0]
			break
		case "ability":
			lockLabel = GetElementsByClassname( menu, "LblAbilityLocked" )[0]
			itemImage = GetElementsByClassname( menu, "AbilityIconClass" )[0]
			break
		case "passive":
			lockLabel = GetElementsByClassname( menu, "LblPassiveLocked" )[0]
			itemImage = GetElementsByClassname( menu, "PassiveIconClass" )[0]
			break
		case "titanos":
			lockLabel = GetElementsByClassname( menu, "LblTitanOSLocked" )[0]
			itemImage = GetElementsByClassname( menu, "TitanOSIconClass" )[0]
			break
	}
	Assert( lockLabel != null, "no unlock label on current menu" )
	Assert( itemImage != null, "no item image" )
	itemImage.SetAlpha( 255 )

	if ( button.IsLocked() )
	{
		local levelReq = GetItemLevelReq( ref, childRef )
		local challengeReq = GetItemChallengeReq( ref, childRef )

		itemImage.SetAlpha( 200 )

		if ( GetItemDevLocked( ref, childRef ) )
		{
			lockLabel.SetText( "Disabled" )
			lockLabel.Show()
		}
		else if ( levelReq > 0 )
		{
			lockLabel.SetText( "#LOUADOUT_UNLOCK_REQUIREMENT_LEVEL", levelReq )
			lockLabel.Show()
		}
		else if ( challengeReq.challengeReq != null && challengeReq.challengeTier != null )
		{
			lockLabel.SetText( "#LOUADOUT_UNLOCK_REQUIREMENT_CHALLENGE" )
			lockLabel.Show()

			// Challenge Name
			PutChallengeNameOnLabel( lockedChallengePanel.name, challengeReq.challengeReq, challengeReq.challengeTier )

			// Challenge Desc
			local challengeDesc = GetChallengeDescription( challengeReq.challengeReq )
			local challengeReqGoal = GetGoalForChallengeTier( challengeReq.challengeReq, challengeReq.challengeTier )
			if ( challengeDesc.len() == 1 )
				lockedChallengePanel.desc.SetText( challengeDesc[0], challengeReqGoal )
			else
				lockedChallengePanel.desc.SetText( challengeDesc[0], challengeReqGoal, challengeDesc[1] )

			// Challenge Icon
			local icon = GetChallengeIcon( challengeReq.challengeReq )
			lockedChallengePanel.icon.SetImage( icon )

			// Challenge Progress Text
			local progress = GetCurrentChallengeProgress( challengeReq.challengeReq )
			lockedChallengePanel.progress.SetText( "#CHALLENGE_POPUP_PROGRESS_STRING", floor(progress), challengeReqGoal )

			// Challenge Progress Bar
			local frac = clamp( progress / challengeReqGoal, 0.0, 1.0 )
			lockedChallengePanel.bar.SetScaleX( frac )
			lockedChallengePanel.barShadow.SetScaleX( frac )

			// Show challenge info panel
			local elements = GetElementsByClassname( menu, "ChallengeLockInfo" )
			foreach ( element in elements )
				element.Show()
		}
		else if ( DidPlayerBuyItemFromBlackMarket( ref, null ) == false )
		{
			lockLabel.SetText( "#LOADOUT_UNLOCK_REQUIREMENT_BLACK_MARKET_PURCHASE" )
			lockLabel.Show()
		}
		else if ( ref == "titanos_femaleassistant" ||  ref == "titanos_maleintimidator" ) //Temp disabled for now until we get the lines!
		{
			lockLabel.SetText( "Disabled For Dev Test" )
			lockLabel.Show()
		}
		else
		{
			Assert( 0, "Unhandled type of weapon lock" )
		}
	}
}

function UpdateNewElements( button, ref )
{
	button.SetNew( HasAnyNewItem( ref ) )
}

function UI_SetLoadoutProperty( loadoutType, loadoutIndex, propertyName, value )
{
	Assert( loadoutType == "pilot" || loadoutType == "titan" )

	// Update local custom loadout tables
	local loadout
	if ( loadoutType == "pilot" )
		loadout = UI_GetCustomPilotLoadout( loadoutIndex )
	else
		loadout = UI_GetCustomTitanLoadout( loadoutIndex )

	loadout[ propertyName ] = value

	if ( value == null )
		value = "null"

	ClientCommand( "SetLoadoutProperty " + loadoutType + " " + loadoutIndex + " " + propertyName + " " + value )
}

function GetLoadoutGamemode()
{
	local gameMode

	if ( uiGlobal.loadedLevel == "mp_lobby" || uiGlobal.loadedLevel == "" || uiGlobal.loadedLevel == null )
	{
		gameMode = uiGlobal.gamemodeLoadoutBeingEdited
		if ( level.ui.nextMapModeComboIndex != null )
			gameMode = GetCurrentPlaylistGamemodeByIndex( level.ui.nextMapModeComboIndex )
	}
	else
	{
		gameMode = GetConVarString( "mp_gamemode" )
		if ( gameMode == null || gameMode == "" )
			gameMode = uiGlobal.gamemodeLoadoutBeingEdited
	}

	return gameMode
}

function UpdateGamemodeLoadoutHeader( menu )
{
	local gameMode = GetLoadoutGamemode()

	local gametypeLoadoutHeaders = GetElementsByClassname( menu, "GametypeLoadoutHeader" )
	local cat2Labels = GetElementsByClassname( menu, "LblCommonLoadoutSubheaderText2" )
	if ( !PersistenceEnumValueIsValid( "gameModesWithLoadouts", gameMode ) )
	{
		foreach( elem in gametypeLoadoutHeaders )
			elem.Hide()


		foreach( label in cat2Labels )
			label.Hide()
	}
	else
	{
		foreach( elem in gametypeLoadoutHeaders )
			elem.Show()

		foreach( label in cat2Labels )
			label.SetText( GAMETYPE_TEXT[ gameMode ] )
	}
}

function HideGamemodeLoadouts( menu )
{
	local elems = GetElementsByClassname( menu, "GametypeLoadoutHeader" )
	foreach( elem in elems )
		elem.Hide()
}

function ShowCustomLoadoutHeader( menu )
{
	local elems = GetElementsByClassname( menu, "CustomLoadoutHeader" )
	foreach( elem in elems )
		elem.Show()
}

function HideCustomLoadoutHeader( menu )
{
	local elems = GetElementsByClassname( menu, "CustomLoadoutHeader" )
	foreach( elem in elems )
		elem.Hide()
}

function ToggleLoadoutGamemode( button )
{
	if ( !IsFullyConnected() )
		return

	local menuName = ""
	if ( uiGlobal.activeMenu != null )
		menuName = uiGlobal.activeMenu.GetName()
	if ( menuName != "EditPilotLoadoutsMenu" && menuName != "EditTitanLoadoutsMenu" )
		return

	// Go to the next game mode in the enum
	local numModes = PersistenceGetEnumCount( "gameModesWithLoadouts" )
	local currentIndex = PersistenceGetEnumIndexForItemName( "gameModesWithLoadouts", uiGlobal.gamemodeLoadoutBeingEdited )

	currentIndex++
	if ( currentIndex >= numModes )
		currentIndex = 0

	uiGlobal.gamemodeLoadoutBeingEdited = PersistenceGetEnumItemNameForIndex( "gameModesWithLoadouts", currentIndex )

	local menu = GetMenu( uiGlobal.currentEditLoadoutMenuName )
	switch( uiGlobal.currentEditLoadoutMenuName )
	{
		case "EditPilotLoadoutsMenu":
			OnOpenEditPilotLoadoutsMenu( menu )
			break

		case "EditTitanLoadoutsMenu":
			OnOpenEditTitanLoadoutsMenu( menu )
			break
	}

	// Put focus on the first game mode loadout slot
	if ( IsControllerModeActive() )
	{
		EmitUISound( "Menu.Accept" )

		local buttons = GetElementsByClassname( menu, "SelectLoadoutButtonClass" )
		foreach( button in buttons )
		{
			if ( button.GetScriptID().tointeger() == NUM_CUSTOM_LOADOUTS )
			{
				button.SetFocused()

				switch( uiGlobal.currentEditLoadoutMenuName )
				{
					case "EditPilotLoadoutsMenu":
						OnPilotLoadoutButton_Focused( button )
						break

					case "EditTitanLoadoutsMenu":
						OnTitanLoadoutButton_Focused( button )
						break
				}

				break
			}
		}
	}
}