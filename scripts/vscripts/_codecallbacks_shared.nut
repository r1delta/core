//=====================================================================================
//
//=====================================================================================

RegisterSignal( "OnAnimationDone" )
RegisterSignal( "OnAnimationInterrupted" )
RegisterSignal( "SettingsChanged" )
RegisterSignal( "OnPrimaryAttack" )
RegisterSignal( "OnSpectatorMode" )
RegisterSignal( "OnPlayerUse" )

function CodeCallback_AnimationDone( entity )
{
	Signal( entity, "OnAnimationDone" )
}

function CodeCallback_AnimationInterrupted( entity )
{
	Signal( entity, "OnAnimationInterrupted" )
}

// better to not define these than just return true. Otherwise code will call these function for no reason

// SERVER AND CLIENT
if ( IsMultiplayer() )
{
	function CodeCallback_CanUseEntity( player, ent )
	{
		// so weird
		if ( ent == player )
			return

		if ( player.IsTitan() )
		{
			return !ent.IsTitan()
		}

		if ( ent.IsTitan() )
		{
			return PlayerCanEmbarkTitan( player, ent )
		}

		if ( ent.IsNPC() )
		{
			// not titan NPCs are not usable
			if ( !( ent.IsTitan() || ent.IsTurret() ) )
				return false

			// player titan can't use NPCs
			if ( player.IsTitan() )
				return false
		}

		// custom overwritable usefunction
		return ent.useFunction( player, ent )
	}
}
else
{
	// SERVER AND CLIENT
	function CodeCallback_CanUseEntity( player, ent )
	{
		if ( ent.IsNPC() )
		{
			// not titan NPCs are not usable
			if ( !( ent.IsTitan() || ent.IsTurret() ) )
				return false

			// player titan can't use NPCs
			if ( player.IsTitan() )
				return false
		}

		return true
	}
}

function CodeCallback_CanUseZipline( player, zipline, ziplineClosestPoint )
{
	if ( !player.IsHuman() )
		return false

	return true
}

function CodeCallback_PlayerClassChanged( player )
{
	if ( !IsMultiplayer() )
		return

	if ( !IsValid( player ) )
		return

	if ( IsLobby() )
		return

	player.Signal( "SettingsChanged" )
	local newClass = player.GetPlayerClass()

	if ( IsClient() )
	{
		player.classChanged = true
		// Force titan to cast shadows in first person
		//player.ForceShadowVisible( newClass == "titan" );

		UpdateSmartGlassPlayerClass( player )

		if ( newClass == level.pilotClass )
		{
			thread ClientPilotSpawned( player )
		}

		if ( level.ent ) // temp workaround to unbreak game
			UpdatePlayerStatusCounts()

		local localPlayer = GetLocalViewPlayer()
		if ( player != localPlayer )
		{
			// first check should not be necessary, but I don't have time to figure out why it's broken
			if ( "healthBarEntity" in localPlayer.s && player == GetHealthBarEntity( localPlayer ) && !player.IsTitan() )
				SetHealthBarEntity( localPlayer, null )
		}

		/*if ( IsWatchingKillReplay() )
			UpdateKillReplayIconPosition()*/

		if ( ShouldHideBurnCardSelectionText( player ) )
		{
			player.Signal( "OnSpectatorMode" )
			if ( GetWaveSpawnType() == eWaveSpawnType.DISABLED )
			{
				HideRespawnSelect()
				ShowBurnCardSelectors()
			}
		}

	}
	else
	{
		player.kv.renderColor = "255 255 255 255"
		player.UpdateMoveSpeedScale()

		InitDamageStates( player )
	}

	switch ( newClass )
	{
		case "titan":
			break
	}

	//if ( IsClient() && !player.IsTitan() )
	//	HideRodeoAlert()

	if ( IsServer() )
		UpdatePlayerMinimapMaterials( player )
}


if ( IsMultiplayer() )
{
	function CodeCallback_OnUseEntity( player, ent )
	{
		if ( ent.IsTitan() )
		{
			Assert( !player.IsTitan() )
			return PlayerLungesToEmbark( player, ent )
		}

		else if ( ent.IsTurret() )
		{
			local results = {}
			results.activator <- player
			Signal( ent, "OnPlayerUse", results )
		}

		// return true to tell code to run its code to use the entity
		return true
	}
}
else
{
	function CodeCallback_OnUseEntity( player, ent )
	{
		return !IsClient()
	}
}




if ( !reloadingScripts )
{
	level.unusableByTitan <- {}
	level.unusableByTitan[ "prop_control_panel" ] <- true
}

function IsUsableByTitan( player, ent )
{
	local classname
	if ( IsServer() )
		classname = ent.GetClassname()
	else
		classname = ent.GetSignifierName()

	if ( player.IsTitan() && classname in level.unusableByTitan )
		return false
	else
		return true
}

function ShouldStopLunging( player, target )
{
	if ( !IsAlive( player )  )
		return true

	if ( !IsAlive( target ) )
		return true

	if ( !target.IsTitan() )
		return true

	// ejecting?
	return target.GetTitanSoul().IsEjecting()
}

function CodeCallback_Lunge( player, playerForwardDir, playerVelocity )
{
	local target = player.PlayerLunge_GetTarget()
	if ( ShouldStopLunging( player, target ) )
	{
		player.PlayerLunge_End()
		return playerVelocity
	}

	if ( ShouldPreventFriendlyFire( target, player ) )
	{
		local targetPos = GetTitanHijackOrigin( target )
		local angles = GetTitanHijackAngles( target )
		local forward = angles.AnglesToForward()
		targetPos += forward * 40

		//DebugDrawLine( player.GetOrigin(), targetPos, 255, 0, 0, true, 0.2 )
		local vec = targetPos - player.GetOrigin()
		local dist = vec.Length()
		if ( dist > RODEO_ASSIST_DIST )
		{
			player.PlayerLunge_End()
			return player.GetVelocity()
		}

		local speed = GetLungeSpeed( player, dist )
	//	printt( "speed " + speed )
		vec.Norm()
		vec *= speed
		local vel = player.GetVelocity() * 0.9 + vec * 0.1

		return vel
	}
	else
	{
		local targetPos = GetTitanHijackOrigin( target )
		local vec = targetPos - player.GetOrigin()
		local dist = vec.Length()
		if ( dist > RODEO_ASSIST_DIST )
		{
			player.PlayerLunge_End()
			return player.GetVelocity()
		}


		local speed = GetLungeSpeed( player, dist )
	//	printt( "speed " + speed )
		vec.Norm()
		vec *= speed
		local vel = player.GetVelocity() * 0.96 + vec * 0.04

		return vel
	}
}

function GetLungeSpeed( player, dist )
{
	local max = 1440
	local speed
	if ( dist >= 1000 )
		speed = 480 // GraphCapped( dist, 750, 2000, 2400, 150 )
	else
	if ( dist >= 750 )
		speed = GraphCapped( dist, 750, 1000, max, 480 )
	else
		speed = GraphCapped( dist, 200, 750, 680, max )

	return speed
}

function CodeCallback_OnUseReleased( player )
{
	if ( player.PlayerLunge_IsLunging() )
	{
		// stop assist
		player.PlayerLunge_End()
	}
}

function UpdateSmartGlassPlayerClass( player )
{
	if ( !IsValid( player ) )
		return

	if ( player != GetLocalClientPlayer() )
		return

	if ( GetGameState() == eGameState.WinnerDetermined )
		return

	if ( GetGameState() == eGameState.SwitchingSides && GameRules.GetGameMode() == LAST_TITAN_STANDING )
		return

	if ( GetGameState() == eGameState.SwitchingSides && GameRules.GetGameMode() == WINGMAN_LAST_TITAN_STANDING )
		return

	local smartGlassClass = null
	if ( player.IsTitan() && HasSoul( player ) )
	{
		local soul = player.GetTitanSoul()
		Assert( IsValid( soul ), "Soul is invalid despite HasSoul returning true for entity " + player )
		local titanType = GetSoulTitanType( soul )
		switch ( titanType )
		{
			case "special_ogre":
				smartGlassClass = "ogre"
			case "special_atlas":
				smartGlassClass = "atlas"
			case "special_stryder":
				smartGlassClass = "stryder"
			case "stryder":
			case "atlas":
			case "ogre":
				smartGlassClass = titanType
				break
			default:
				Assert( 0, "No valid titanType" )
				break
		}
	}
	else
	{
		smartGlassClass = "pilot"
	}
	Assert( smartGlassClass != null )

	SmartGlass_SendEvent( "playerClassChange", smartGlassClass, "", "" )
	SmartGlass_SetGameStateProperty( SMARTGLASS_PROP_PLAYERCLASS, smartGlassClass )
}
