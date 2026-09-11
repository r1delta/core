function main()
{
	level.soulTransferFuncs <- {}
	level.soulSettingsChangeFuncs <- {}
	level.soulInitFuncs <- {}
	level.soulDeathFuncs <- {}
	level.soulDestroyFuncs <- {}
	Globalize( CreateTitanSoul )
	Globalize( AddSoulTransferFunc )
	Globalize( AddSoulSettingsChangeFunc )
	Globalize( AddSoulInitFunc )
	Globalize( AddSoulDeathFunc )
	Globalize( AddSoulDestroyFunc )
	Globalize( Soul_SetLastAttackInfo )
	Globalize( SoulDeathDetection )
	Globalize( TitanTaken )
	Globalize( SoulBecomesOwnedByPlayer )
	Globalize( HasSoul )
	Globalize( SetStanceKneel    )
	Globalize( SetStanceKneeling )
	Globalize( SetStanceStanding )
	Globalize( SetStanceStand	 )
	Globalize( GetPlayerSettingsNumFromString )
	Globalize( GetSoulPlayerSettings )
	Globalize( IsSoul )
	Globalize( SoulDies )
	Globalize( TitanNearBubbleShield )
	Globalize( GetSoulTitanType )
	Globalize( SetCoreCharged )

	RegisterSignal( "OnSoulTransfer" )
	RegisterSignal( "OnTitanDeath" )
	RegisterSignal( "OnTitanTaken" )
	RegisterSignal( "OnPlayerHasTitanInWorld" )
	RegisterSignal( "TitanKilled" )

	if ( IsServer() )
	{
		level._titanSouls <- {}
		AddSpawnCallback( "titan_soul", SpawnTitanSoul )
	}

	RegisterSignal( "OnTitanLost" ) // sent to a player when they lose their titan, on server and client

	level.allTitanSouls <- []
	level.titanPlayerSettingsMapping <- {}
	level.titanTypeMapping <- {}

	// need to put play settings onto the npc titans
	AddTitanMapping( "titan_atlas", "atlas" )
	AddTitanMapping( "titan_atlas_bronze", "atlas" )
	AddTitanMapping( "titan_ogre", "ogre" )
	AddTitanMapping( "titan_stryder", "stryder" )
	AddTitanMapping( "titan_atlas_training", "atlas" )
	AddTitanMapping( "titan_ctt", "ogre" )
	AddTitanMapping("titan_destroyer_tier0", "destroyer")
	
	local loop_max = MasterModdedTitans.len()
	for( local E = 0; E < loop_max; E++ )
	{
		if( loop_max > 0 )
		{
			local t_a = MasterModdedTitans[ E ]
			AddTitanMapping( t_a.setfile, t_a.titan_type )
		}
	}
}

function AddTitanMapping( settings, titan )
{
	local num = level.titanPlayerSettingsMapping.len()
	level.titanPlayerSettingsMapping[ settings ] <- num
	level.titanTypeMapping[ num ] <- titan
}

function SpawnTitanSoul( soul )
{
	level._titanSouls[ soul ] <- soul
}

function IsSoul( ent )
{
	return ent instanceof CTitanSoul
}

function GetPlayerSettingsNumFromString( settings )
{
	Assert( settings in level.titanPlayerSettingsMapping, settings + " is not in level.titanPlayerSettingsMapping" )
	return level.titanPlayerSettingsMapping[ settings ]
}

function GetSoulTitanType( soul )
{
	local settingsNum = soul.GetPlayerSettingsNum()
	return level.titanTypeMapping[ settingsNum ]
}

function GetSoulPlayerSettings( soul )
{
	local settingsNum = soul.GetPlayerSettingsNum()
	foreach ( name, num in level.titanPlayerSettingsMapping )
	{
		if ( num == settingsNum )
			return name
	}

	Assert( 0, "No player settings for " + settingsNum )
}

function HasSoul( ent )
{
	return ( ent.IsNPC() || ent.IsPlayer() ) && IsValid( ent.GetTitanSoul() )
}

function AddSoulSettingsChangeFunc( func )
{
	local name = FunctionToString( func )
	level.soulSettingsChangeFuncs[ name ] <- Bind( func )
}

function AddSoulTransferFunc( func )
{
	local name = FunctionToString( func )
	level.soulTransferFuncs[ name ] <- Bind( func )
}

function AddSoulDeathFunc( func )
{
	local name = FunctionToString( func )
	level.soulDeathFuncs[ name ] <- Bind( func )
}

function AddSoulDestroyFunc( func )
{
	local name = FunctionToString( func )
	level.soulDestroyFuncs[ name ] <- Bind( func )
}

function AddSoulInitFunc( func )
{
	local name = FunctionToString( func )
	level.soulInitFuncs[ name ] <- Bind( func )
}

function CreateTitanSoul( titan )
{
	local soul = CreateEntity( "titan_soul" )
	DispatchSpawn( soul )

	soul.InitSoul( titan )
	soul.ConnectOutput( "OnDestroy", SoulDestroyOutput )

	level.allTitanSouls.append( soul )

	return soul
}

function SoulDestroyOutput( self, activator, caller, value )
{
	ArrayRemove( level.allTitanSouls, self )

	Assert( self.IsMarkedForDeletion() && self.IsValidInternal() )
	self.SoulDestroy()
}

function SoulTitanDiesOrDisconnects( soul )
{
	local titan = soul.GetTitan()
	if ( titan.IsPlayer() )
	{
		titan.EndSignal( "Disconnected" )
	}

}

function SoulDeathDetection( soul )
{
	soul.EndSignal( "OnSoulTransfer" )
	local titan = soul.GetTitan()
	Assert( titan.IsNPC(), "Must be an npc!" )

	titan.WaitSignal( "OnDeath" )
	SoulDies( soul )
}

function SoulDies( soul )
{
	level.ent.Signal( "TitanKilled" )
	if ( !IsValid( soul ) )
		return
	// presuming this titan was owned, a player lost his titan
	local lastPlayer = soul.GetBossPlayer()

	if ( IsValid( lastPlayer ) )
	{
		SetPlayerLostTitanTime( lastPlayer )
	}

	soul.Signal( "OnTitanDeath" )


	foreach ( name, func in level.soulDeathFuncs )
	{
		func( soul )
	}

	local titan = soul.GetTitan()
	if ( IsValid( titan ) )
	{
		if ( !titan.IsPlayer() && !titan.IsMarkedForDeletion() )
		{
			// players arent destroyed so don't wait for OnDestroy from them
			WaitSignalOnDeadEnt( titan, "OnDestroy" )
		}
	}

	soul.Kill()
}

function SetPlayerLostTitanTime( player )
{
	local titan = GetPlayerTitanInMap( player )
	// already has a titan available? dont change the time then
	if ( IsAlive( titan ) )
		return

	player.s.lostTitanTime = Time()
}

function TitanTaken( player, titan )
{
	local soul = titan.GetTitanSoul()

	// presuming this titan was owned by somebody else, a player lost his titan
	local lastPlayer = soul.GetBossPlayer()
	if ( IsValid( lastPlayer ) && player != lastPlayer )
	{
		SetPlayerLostTitanTime( lastPlayer )
		lastPlayer.Signal( "OnTitanLost" )
	}

	SoulBecomesOwnedByPlayer( soul, player )
	soul.Signal( "OnTitanTaken", { newOwner = player, lastOwner = lastPlayer } )
}

function SoulBecomesOwnedByPlayer( soul, player )
{
	soul.SetBossPlayer( player )

	if ( GetActiveBurnCard( player ) == "bc_core_charged" )
		SetCoreCharged( soul )

	// fix "TITAN READY" message appearing because there's a one frame lag between the player ejecting and the soul dying and reseting the titan respawn timer
	//SetTitanRespawnTimer( player, 999999 )

	//TryBecomeTitanBurnCard( player )
	    Remote.CallFunction_NonReplay(player,"ServerCallback_TitanDialogueBurnCardVO")

	player.Signal( "OnPlayerHasTitanInWorld" )
}

function SetCoreCharged( soul )
{
	if ( !( "coreCharged" in soul.s ) )
	{
		soul.SetNextCoreChargeAvailable( 0 )
		soul.s.coreCharged <- true // no reuse
	}
}

function Soul_SetLastAttackInfo( soul, damageInfo )
{
	local attacker = damageInfo.GetAttacker()
	if ( !IsValid( attacker ) )
		return

	if ( !attacker.IsPlayer() && !attacker.IsNPC() && damageInfo.GetDamageSourceIdentifier() != eDamageSourceId.floor_is_lava )
		return

	if ( attacker == soul.GetSoulOwner() )
		return

	local lastAttackInfo = {}
	lastAttackInfo.attacker <- damageInfo.GetAttacker()
	lastAttackInfo.inflictor <- damageInfo.GetInflictor()
	lastAttackInfo.time <- Time()
	lastAttackInfo.weapon <- _GetWeaponNameFromDamageInfo( damageInfo )
	lastAttackInfo.damageSourceId <- damageInfo.GetDamageSourceIdentifier()
	lastAttackInfo.scriptType <- damageInfo.GetCustomDamageType()

	soul.lastAttackInfo = lastAttackInfo
}


function SetStanceKneel( soul )
{
	soul.SetStance( STANCE_KNEEL )
//	printt( titan, "Kneel" )
}

function SetStanceKneeling( soul )
{
	soul.SetStance( STANCE_KNEELING )
//	printt( titan, "Kneeling" )
}

function SetStanceStanding( soul )
{
	soul.SetStance( STANCE_STANDING )
//	printt( titan, "Standing" )
}

function SetStanceStand( soul )
{
	soul.SetStance( STANCE_STAND )
//	printt( titan, "Stand" )
}

//Temp Hacky function. Used in determining if Titan is close enough to shield when embarking, if so, set owner of shield to Titan so planted animation doesn't make him climb on top of it
function TitanNearBubbleShield( titan )
{
	local soul = titan.GetTitanSoul()
	return IsValid( soul.bubbleShield ) && Distance( soul.bubbleShield, titan ) < 270
}
