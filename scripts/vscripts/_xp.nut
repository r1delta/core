
const XP_AT_MAX_LEVEL = 900000
const XP_POW = 1.9
const XP_ROUND_TO_NEAREST = 100
const XP_AVG_PER_MIN = 750

const DEBUG_PRINT_XP_INFO = false
const DEBUG_PRINT_UNLOCK_INFO = false
const DEBUG_TIMES_FOR_GEN = 0

enum XP_TYPE_CATEGORY
{
	KILLS,
	ASSISTS,
	EPILOGUE,
	GAMEMODE,
	CHALLENGES,
	SPECIAL,
	BURNCARDS,

	_NUM_CATEGORIES,
}

enum XP_TYPE
{
	// CANT ADD TO THIS ENUM WITHOUT UPDATING PERSISTENT DATA AND ALSO THE MENUS
	PILOT_KILL,
	NPC_KILL,
	AUTO_TITAN_KILL,
	TITAN_KILL,
	DROPSHIP_KILL,
	SPECIAL,
	ACCURACY,
	BURNCARD_USED,
	BURNCARD_STOPPED,
	BURNCARD_XP,
	BURNCARD_EARNED,
	PILOT_ASSIST,
	TITAN_ASSIST,
	EPILOGUE_GET_TO_CHOPPER,
	EPILOGUE_EVAC,
	EPILOGUE_SOLE_SURVIVOR,
	EPILOGUE_FULL_TEAM_EVAC,
	EPILOGUE_KILL,
	EPILOGUE_KILL_ALL,
	EPILOGUE_KILL_SHIP,
	MATCH_VICTORY,
	MATCH_COMPLETED,
	ROUND_WIN,
	ROUND_COMPLETE,
	NEW_PLAYER_BONUS,
	CHALLENGE,
	HARDPOINT_CAPTURE,
	HARDPOINT_ASSIST,
	HARDPOINT_NEUTRALIZE,
	HARDPOINT_KILL,
	HARDPOINT_DEFEND,
	HARDPOINT_DEFEND_KILL,
	CTF_FLAG_CAPTURE,
	CTF_FLAG_RETURN,
	CTF_FLAG_CARRIER_KILL,
	HACKING,
	FIRST_STRIKE,
	KILL_STREAK,
	REVENGE,
	SHOWSTOPPER,
	EJECT_KILL,
	VICTORY_KILL,
	NEMESIS,
	COMEBACK_KILL,
	RODEO_RAKE,
	RODEO_RIDE,
	TITANFALL
	DESTROYED_EXPLOSIVES,

	_NUM_TYPES,
}

function main()
{
	// Server and client
	Globalize( GetXP )
	Globalize( GetNextLevel )
	Globalize( GetLevelProgress )
	Globalize( GetLevelProgressStart )
	Globalize( GetLevelProgressEnd )
	Globalize( GetXPForLevel )
	Globalize( CanGenUp )
	Globalize( GenUp )
	Globalize( GetXPModifierForGen )
	Globalize( GetLastMatchXPTotal )

	// Server only
	if ( IsServer() )
	{
		Globalize( InitXP )
		Globalize( AddXP )
		Globalize( SetLevel )
		Globalize( LevelUp )
		Globalize( DevSetGen )
		if ( developer() > 0 )
		{
			// Globalize( SetLevel )
			// Globalize( LevelUp )
			// Globalize( DevSetGen )
		}
	}


	file.lvls <- {}
	file.lvls[1] <- 0
	file.lvls[2] <- 1500
	file.lvls[3] <- 3300
	file.lvls[4] <- 5800
	file.lvls[5] <- 8800
	file.lvls[6] <- 12500
	file.lvls[7] <- 16700
	file.lvls[8] <- 21500
	file.lvls[9] <- 26900
	file.lvls[10] <- 32900
	file.lvls[11] <- 39400
	file.lvls[12] <- 46500
	file.lvls[13] <- 54100
	file.lvls[14] <- 62300
	file.lvls[15] <- 71100
	file.lvls[16] <- 80300
	file.lvls[17] <- 90100
	file.lvls[18] <- 100500
	file.lvls[19] <- 111300
	file.lvls[20] <- 122700
	file.lvls[21] <- 134700
	file.lvls[22] <- 147100
	file.lvls[23] <- 160100
	file.lvls[24] <- 173600
	file.lvls[25] <- 187600
	file.lvls[26] <- 202100
	file.lvls[27] <- 217100
	file.lvls[28] <- 232600
	file.lvls[29] <- 248700
	file.lvls[30] <- 265200
	file.lvls[31] <- 282300
	file.lvls[32] <- 299800
	file.lvls[33] <- 317900
	file.lvls[34] <- 336500
	file.lvls[35] <- 356000
	file.lvls[36] <- 377000
	file.lvls[37] <- 399000
	file.lvls[38] <- 422000
	file.lvls[39] <- 446000
	file.lvls[40] <- 471000
	file.lvls[41] <- 497000
	file.lvls[42] <- 524000
	file.lvls[43] <- 552000
	file.lvls[44] <- 581000
	file.lvls[45] <- 612000
	file.lvls[46] <- 650000
	file.lvls[47] <- 695000
	file.lvls[48] <- 750000
	file.lvls[49] <- 818000
	file.lvls[50] <- 900000

	file.xp_modifier <- 1.0

	file.xp_gen_modifier <- {}
	file.xp_gen_modifier[0] <- 1.0
	file.xp_gen_modifier[1] <- 1.1
	file.xp_gen_modifier[2] <- 1.2
	file.xp_gen_modifier[3] <- 1.3
	file.xp_gen_modifier[4] <- 1.5
	file.xp_gen_modifier[5] <- 1.8
	file.xp_gen_modifier[6] <- 2.1
	file.xp_gen_modifier[7] <- 2.5
	file.xp_gen_modifier[8] <- 2.9
	file.xp_gen_modifier[9] <- 3.5

	GenerateLevels()
}

function GenerateLevels()
{
	local xpToLevel
	SetXPForLevel( 1, file.lvls[1] )

	if ( DEBUG_PRINT_XP_INFO )
		printt( "----------GENERATING LEVELS----------" )

	// Generate XP for all levels. We generate XP for one extra level over MAX_LEVEL so we know how much XP bar we can fill at MAX_LEVEL
	for ( local lvl = 2 ; lvl <= MAX_LEVEL ; lvl++ )
	{
		//xpToLevel = XP_AT_MAX_LEVEL * pow( GraphCapped( lvl, 0, MAX_LEVEL, 0.0, 1.0 ), XP_POW )
		//lvls[lvl] <- RoundToNearestMultiplier( xpToLevel, XP_ROUND_TO_NEAREST )
		Assert( lvl in file.lvls, "XP not set for level" + lvl )
		Assert( file.lvls[lvl] > file.lvls[lvl-1], "XP for level must be greater than the previous level" )
		xpToLevel = file.lvls[lvl]

		if ( DEBUG_PRINT_XP_INFO )
		{
			local totalXP = file.lvls[lvl]
			totalXP /= file.xp_gen_modifier[DEBUG_TIMES_FOR_GEN].tofloat()
			local mins = totalXP / ( XP_AVG_PER_MIN ).tofloat()
			local displayHours = floor( mins / 60.0 )
			local displayMinutes = floor( mins % 60.0 )

			local xpDelta = file.lvls[lvl] - file.lvls[lvl-1]
			xpDelta /= file.xp_gen_modifier[DEBUG_TIMES_FOR_GEN].tofloat()
			local minsDelta = xpDelta / ( XP_AVG_PER_MIN ).tofloat()
			local displayHoursDelta = floor( minsDelta / 60.0 )
			local displayMinutesDelta = floor( minsDelta % 60.0 )

			printt( lvl + " " + file.lvls[lvl] + " (+" + ( file.lvls[lvl] - file.lvls[lvl - 1] ).tostring() + ")  <-", displayHours + "h " + displayMinutes + "m", "(+" + displayHoursDelta + "h " + displayMinutesDelta + "m)" )
		}

		// Tell Code
		SetXPForLevel( lvl, file.lvls[lvl] )
	}

	if ( DEBUG_PRINT_UNLOCK_INFO )
	{
		printt( "-------------------------------------" )

		local unlockArray = []
		foreach( unlock, level in unlockLevels )
		{
			local mins = lvls[level] / ( XP_AVG_PER_MIN ).tofloat()
			local displayHours = floor( mins / 60.0 )
			local displayMinutes = floor( mins % 60.0 )

			local table = {}
			table.ref <- unlock
			table.level <- level
			table.time <- displayHours + "h " + displayMinutes + "m"

			unlockArray.append( table )
		}

		unlockArray.sort( DevPrintUnlockSort )
		foreach( table in unlockArray )
		{
			printt( table.time, "  ->  ", table.ref )
		}
	}

	if ( DEBUG_PRINT_XP_INFO || DEBUG_PRINT_UNLOCK_INFO )
		printt( "-------------------------------------" )
}

function DevPrintUnlockSort( table1, table2 )
{
	if ( table1.level > table2.level )
		return 1
	if ( table1.level < table2.level )
		return -1
	return 0
}

function InitXP( player )
{
	Assert( !IsLobby(), "Don't call InitXP in mp_lobby!" )	// Should not call InitXP in mp_lobby because we want to view our old xp progress in the game summary menu until we play another match
	if (IsLobby()) { return; }
	// Clear how much XP we earned in the previous match
	player.SetPersistentVar( "previousXP", GetXP( player ) )
	for( local i = 0 ; i < XP_TYPE._NUM_TYPES ; i++ )
	{
		player.SetPersistentVar( "xp_match[" + i + "]", 0 )
		player.SetPersistentVar( "xp_match_count[" + i + "]", 0 )
	}

	file.xp_modifier = GetCurrentPlaylistVarFloat( "xp_modifier", 1.0 )
}

function GetXP( player = null )
{
	if ( IsUI() )
		return GetPersistentVar( "xp" )
	else
	{
		Assert( player != null )
		return player.GetXP()
	}
}

if ( IsUI() )
{
	function GetLevel( _ = null )
	{
		// if ( DevEverythingUnlocked() )
		// 	return MAX_LEVEL
		return GetLevelForXP( GetPersistentVar( "xp" ) )
	}
	Globalize( GetLevel )

	function GetGen()
	{
		return GetPersistentVar( "gen" )
	}
	Globalize( GetGen )
}
else
{
	function GetLevel( player )
	{
		return player.GetLevel()
	}
	Globalize( GetLevel )
}

function DevSetGen( newGen, player )
{
	newGen -= 1 // Because internally they go from 0..9 and humans will enter 1..10

	if ( newGen < 0 )
		newGen = 0
	if( newGen > MAX_GEN )
		newGen = MAX_GEN

	SetLevel( 1, player )

	player.SetPersistentVar( "gen", newGen )
}

function GetNextLevel( player )
{
	local currentLvl = GetLevel( player )
	local nextLvl = currentLvl + 1

	if ( !(nextLvl in file.lvls) )
		nextLvl = currentLvl

	return nextLvl
}

function GetLevelProgress( player )
{
	local currentThresholdMet = file.lvls[GetLevel( player )]
	local nextThreshold = file.lvls[GetNextLevel( player )]
	local inProgressTotal = nextThreshold - currentThresholdMet
	local inProgressEarned = GetXP( player ) - currentThresholdMet

	return inProgressEarned.tofloat() / inProgressTotal.tofloat()
}

function _SetXP( player, amount, xpType = XP_TYPE.SPECIAL )
{
	amount = clamp( amount, 0, GetXPForLevel( MAX_LEVEL ) )
	local oldLevel = GetLevel( player )
	player.SetPersistentVar( "xp", amount )
	player.XPChanged()

	local newLevel = GetLevel( player )

	if ( newLevel > oldLevel )
		PlayerLeveledUp( player, newLevel )
}

function PlayerLeveledUp( player, newLevel )
{
	TryBurnCardRewardForLevel( player, newLevel )

	// Max level achievement
	if ( GetLevel( player ) == MAX_LEVEL )
	{
		player.SetPersistentVar( "ach_reachedMaxLevel", true )
	}

	local newUnlocks = GetNewUnlocks( player )
	foreach ( itemRef in newUnlocks.items )
	{
		SetNewStatus( itemRef, player )
	}

	// Put "new" status on regen button
	if ( CanGenUp( player ) )
	{
		player.SetPersistentVar( "regenShowNew", true )
	}

	if ( newLevel == unlockLevels[ "challenges"] && player.GetGen() > 0 && player.GetGen() < 9 )
		player.SetPersistentVar( "newRegenChallenges", true )

	// Show the exclaimation mark next to black market when it unlocks for the first time
	if ( player.GetGen() == 0 && newLevel == GetUnlockLevelReq( "burn_card_slot_3" ) )
		player.SetPersistentVar( "bm.newBlackMarketItems", true )

	// Everything unlocked achievement
	CheckEverythingUnlockedAchievement( player )
}

function SetLevel( newLevel, player = null )
{
	if ( newLevel < 1 )
		newLevel = 1
	else if ( newLevel > MAX_LEVEL )
		newLevel = MAX_LEVEL

	if ( player )
	{
		player.SetPersistentVar( "previousXP", player.GetPersistentVar( "xp" ) )
		_SetXP( player, GetXPForLevel( newLevel ) )
		DevClearAllNewStatus(player)
		return
	}

	local players = GetPlayerArray()
	foreach ( player in players )
	{
		_SetXP( player, GetXPForLevel( newLevel ) )
		DevClearAllNewStatus(player)
	}
}

function DevClearAllNewStatus(player)
{
	// Clear new status on everything
	local newArrays = []
	newArrays.append("newLoadoutItems")
	newArrays.append("newMods")
	newArrays.append("newChassis")
	newArrays.append("rewardChassis")
	newArrays.append("newPilotPassives")
	newArrays.append("newTitanPassives")
	newArrays.append("newTitanOS")
	newArrays.append("newUnlocks")
	newArrays.append("newTitanDecals")
	foreach( arrayName in newArrays )
	{
		for ( local i = 0 ; i < PersistenceGetArrayCount(arrayName) ; i++ )
			player.SetPersistentVar( arrayName + "[" + i + "]", false )
	}
}

function GetXPModifierForGen( gen = null )
{
	if ( IsUI() )
	{
		if ( gen == null )
			gen = GetGen()
	}
	else
		Assert( gen != null )

	return file.xp_gen_modifier[ gen ]
}

function AddXP( amount, player, xpType = XP_TYPE.SPECIAL )
{
	if ( !player.hasConnected )
		return

	local currentLvl = GetLevel( player )
	local genModifier = GetXPModifierForGen( player.GetGen() )
	local playerCurrentXP = GetXP( player )

	//printt( "ADDING XP FOR PLAYER", player )
	//printt( "    original amount:", amount )
	//printt( "    playlist xp modifier:", file.xp_modifier )
	//printt( "    gen xp modifier:", genModifier )

	amount *= file.xp_modifier
	amount *= genModifier
	amount = floor( amount + 0.5 ).tointeger()

	LogPlayerMatchStat_EarnedXP( player, amount )

	if ( PlayerProgressionAllowed( player ) )
	{
		// Add XP
		local totalXP = clamp( playerCurrentXP + amount, 0, GetXPForLevel( MAX_LEVEL ) )
		player.SetPersistentVar( "xp", totalXP )
		player.XPChanged()

		local newLevel = GetLevel( player )
		if ( newLevel > currentLvl )
			PlayerLeveledUp( player, newLevel )
	}

	if ( PlayerFullyConnected( player ) )
	{
		// Update the match xp for EOG screen usage, even if real XP wasn't given above, because we still want to show EOG accomplishments
		local oldXPVal = player.GetPersistentVar( "xp_match[" + xpType + "]" )
		player.SetPersistentVar( "xp_match[" + xpType + "]", oldXPVal + amount )
		local oldXPCount = player.GetPersistentVar( "xp_match_count[" + xpType + "]" )
		player.SetPersistentVar( "xp_match_count[" + xpType + "]", oldXPCount + 1 )
	}

	//printt( "    player total xp:", player.GetXP() )
}

function LevelUp( player = null )
{
	if ( player )
	{
		SetLevel( GetNextLevel( player ) )

		return
	}

	local players = GetPlayerArray()
	foreach ( player in players )
		SetLevel( GetNextLevel( player ) )
}

function GetLevelProgressStart( player )
{
	return file.lvls[GetLevel( player )]
}

function GetLevelProgressEnd( player )
{
	return file.lvls[GetNextLevel( player )]
}

function GetXPForLevel( level )
{
	return file.lvls[level]
}

function CanGenUp( player = null )
{
	if ( !IsUI() )
		Assert( IsValid( player ) )

	local gen = IsUI() ? GetGen() : player.GetGen()
	local xp = IsUI() ? GetPersistentVar( "xp" ) : player.GetPersistentVar( "xp" )

	if ( gen >= MAX_GEN )
		return false

	return GetLevelForXP( xp ) >= MAX_LEVEL
}

function GenUp( player )
{
	Assert( CanGenUp( player ) )
	Assert( IsServer() )
	Assert( IsValid( player ) )
	Assert( player.IsPlayer() )

	//##############################################
	// 					Reset XP
	//##############################################

	player.SetPersistentVar( "xp", 0 )
	player.SetPersistentVar( "previousXP", 0 )
	for( local i = 0 ; i < XP_TYPE._NUM_TYPES ; i++ )
	{
		player.SetPersistentVar( "xp_match[" + i + "]", 0 )
		player.SetPersistentVar( "xp_match_count[" + i + "]", 0 )
	}
	player.XPChanged()

	//##############################################
	// 				Increase Gen level
	//##############################################

	local nextGen = player.GetGen() + 1
	player.SetPersistentVar( "gen", nextGen )
	player.GenChanged()

	if ( nextGen >= 9 )
	{
		local regenForgedCertificationsUsed = player.GetPersistentVar( "miscStats.regenForgedCertificationsUsed" )
		if ( regenForgedCertificationsUsed == 0 )
			player.SetPersistentVar( "cu8achievement.ach_reachedGen10NoForgedCert", true )
	}

	//##############################################
	//				Reset Challenges
	//##############################################

	// local numChallenges = PersistenceGetEnumCount( "challenge" )
	// for ( local i = 0 ; i < numChallenges ; i++ )
	// {
	// 	player.SetPersistentVar( "challenges[" + i + "].progress", 0 )
	// 	player.SetPersistentVar( "challenges[" + i + "].previousProgress", 0 )
	// }

	// for ( local i = 0; i < MAX_TRACKED_CHALLENGES; i++ )
	// {
	// 	player.SetPersistentVar( "trackedChallengeRefs[" + i + "]", "" )
	// }

	//##############################################
	//		Reset players custom loadouts
	//##############################################

	// ResetCustomLoadouts( player )

	//##############################################
	//			Clear "New" Menu Items
	//##############################################

	// ClearAllNewItems( player )
}

function SetAllNew()
{
	local players = GetPlayerArray()

	foreach ( player in players )
	{
		local items = GetAllItemsOfType( itemType.PILOT_PRIMARY )
		foreach ( item in items )
		{
			player.SetPersistentVar( "newLoadoutItems[" + item.ref + "]", true )
		}

		local items = GetAllItemsOfType( itemType.TITAN_PRIMARY )
		foreach ( item in items )
		{
			player.SetPersistentVar( "newLoadoutItems[" + item.ref + "]", true )
		}
	}
}
Globalize( SetAllNew )


function SetNewStatus( ref, player )
{
	//printt( "SetNewStatus", ref )
	if ( ItemDefined( ref ) )
	{
		local refType = GetItemType( ref )

		switch ( refType )
		{
			case itemType.PILOT_PRIMARY:
			case itemType.PILOT_SECONDARY:
			case itemType.PILOT_SIDEARM:
			case itemType.PILOT_SPECIAL:
			case itemType.PILOT_ORDNANCE:
			case itemType.TITAN_SPECIAL:
			case itemType.TITAN_ORDNANCE:
			case itemType.TITAN_PRIMARY:
				player.SetPersistentVar( "newLoadoutItems[" + ref + "]", true )
				//printt( "newLoadoutItems[" + ref + "]" )
				break

			case itemType.TITAN_SETFILE:
				// Chassis are already unlocked when you gen up, so don't mark them as new
				if ( ref != "titan_stryder" || ref != "titan_ogre" )//HACKY
				{
					ref = "titan_ogre"//just dont want to deal with errors
				}
				if ( player.GetGen() > 0 && ( ref == "titan_stryder" || ref == "titan_ogre" ) )
					break
				player.SetPersistentVar( "newChassis[" + ref + "]", true )
				//printt( "newChassis[" + ref + "]" )
				break

			case itemType.PILOT_PASSIVE1:
			case itemType.PILOT_PASSIVE2:
				player.SetPersistentVar( "newPilotPassives[" + ref + "]", true )
				//printt( "newPilotPassives[" + ref + "]" )
				break

			case itemType.TITAN_PASSIVE1:
			case itemType.TITAN_PASSIVE2:
				player.SetPersistentVar( "newTitanPassives[" + ref + "]", true )
				//printt( "newTitanPassives[" + ref + "]" )
				break

			case itemType.TITAN_DECAL:
				player.SetPersistentVar( "newTitanDecals[" + ref + "]", true )
				break
		}
	}
	else if ( ref in combinedModData )
	{
		player.SetPersistentVar( "newMods[" + ref + "]", true )
		//printt( "newMods[" + ref + "]" )
	}
	else if ( ref in unlockLevels )
	{
		player.SetPersistentVar( "newUnlocks[" + ref + "]", true )
		//printt( "newUnlocks[" + ref + "]" )
	}
}
Globalize( SetNewStatus )


function GetNewUnlocks( player )
{
	local unlocks = {}
	unlocks[ "items" ] <- []

	// Loop through all items and see if we earned the level requirement for any of them
	local startLevel = GetLevelForXP( player.GetPersistentVar( "previousXP" ) )
	local endLevel = GetLevelForXP( player.GetPersistentVar( "xp" ) )

	if ( startLevel != endLevel )
	{
		// Loop through items
		local allItemRefs = GetAllItemRefs()
		foreach( data in allItemRefs )
		{
			local itemReq = GetItemLevelReq( data.ref, data.childRef )
			if ( itemReq > startLevel && itemReq <= endLevel )
			{
				if ( data.childRef )
					unlocks.items.append( data.ref + "_" + data.childRef )
				else
					unlocks.items.append( data.ref )
			}
		}

		// Loop through special unlocks that were set to notify
		local refCount = PersistenceGetEnumCount( "unlockRefs" )
		for ( local i = 0 ; i < refCount ; i++ )
		{
			local itemRef = PersistenceGetEnumItemNameForIndex( "unlockRefs", i )
			local itemReq = GetItemLevelReq( itemRef )

			if ( itemReq > startLevel && itemReq <= endLevel )
				unlocks.items.append( itemRef )
		}
	}

	return unlocks
}
Globalize( GetNewUnlocks )

function GetLastMatchXPTotal( player )
{
	local xp = 0

	for( local i = 0 ; i < XP_TYPE._NUM_TYPES ; i++ )
	{
		xp += player.GetPersistentVar( "xp_match[" + i + "]" )
	}

	return xp
}
