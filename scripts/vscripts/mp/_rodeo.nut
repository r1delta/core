const FAST_HACK_MULTIPLIER = 0.7

IncludeFile( "_rodeo_shared" )

function main()
{
	Globalize( CodeCallback_StartRodeo )
	Globalize( CodeCallback_EmbarkTitan )

	RegisterSignal( "LandedOnTitan" )

	level.coopRodeoGraceTime <- 90 //1m 30s
	//IncludeFile("Yoshi's_TitanCreator")
	//setUp( 1 )
}

function ForceWeaponSwitchForRodeo( player )
{
	//Bad case: if we have 2 anti-personnel weapons and the first one is out of ammo, we won't switch to the second one
	local antiPersonnelWeapon = GetPilotAntiPersonnelWeapon( player )
	local secondaryWeapon = GetPilotSideArmWeapon( player )
	local antiPersonnelWeaponName
	local secondaryWeaponName

	if ( IsValid( antiPersonnelWeapon ) )
	{
		antiPersonnelWeaponName = antiPersonnelWeapon.GetClassname()
		if ( antiPersonnelWeapon.HasModDefined("slammer") && antiPersonnelWeapon.HasMod( "slammer" ) )
		{
				player.SetActiveWeapon( antiPersonnelWeaponName )
				return
		}
	}

	if ( IsValid( secondaryWeapon ) )
	{
		secondaryWeaponName = secondaryWeapon.GetClassname()
		if ( secondaryWeapon.HasModDefined("slammer") && secondaryWeapon.HasMod( "slammer" ) )
		{
				player.SetActiveWeapon( secondaryWeaponName )
				return
		}
	}

	if ( antiPersonnelWeaponName )
	{
		if ( player.GetWeaponAmmoStockpile( antiPersonnelWeapon ) != 0 || player.GetWeaponAmmoLoaded( antiPersonnelWeapon ) != 0 ) //GetWeaponAmmoStockpile only returns the amount of ammo in magazines the player is carrying.
		{
			player.SetActiveWeapon( antiPersonnelWeaponName )
			return
		}
	}

	if ( secondaryWeaponName )
		player.SetActiveWeapon( secondaryWeaponName )
}

function GetRodeoDot( player, titan )
{
	local titanOrigin = GetTitanHijackOrigin( titan )
	local org = player.EyePosition()
	local vec = org - titanOrigin

	if ( vec.z < 0 )
		return null

	local dist = vec.Length()

	// too far away?
	if ( dist > RODEO_ASSIST_DIST )
		return null

	vec.Norm()

	if ( dist <= 220 )
	{
		// not moving the right direction?
		local dot
		local vel = player.GetVelocity()
		if ( vel.Length() > 80 )
		{
			vel.Norm()
			dot = vel.Dot( vec )
			if ( dot > 0.2 )
				return null
		}

		return -1.0
	}

//	// not moving the right direction?
//	local dot
//	local vel = player.GetVelocity()
//	if ( vel.Length() > 80 )
//	{
//		vel.Norm()
//		dot = vel.Dot( vec )
//		if ( dot > 0.2 )
//			return null
//	}

	local dot = vec.Dot( Vector(0,0,1 ) )
	//printt( "dot " + dot + " dist " + dist )
	if ( dist < 1000 )
	{
		// not above enough?
		if ( dot < 0.42 )
			return null
	}
	else
	{
		// not above enough?
		if ( dot < 0.6 )
			return null
	}

	local ang = player.EyeAngles()
	local forward = ang.AnglesToForward()

	dot = vec.Dot( forward )

	return dot < -0.83
}

function HumanJumpsOffTitan( human, soul, e )
{
	// ejected
	if ( human.GetVelocity().z > 800 )
	{
		return
	}

	human.s.lastRodeoTime = Time() // used to stop you from re-auto-rodeo'ing
	local titan = soul.GetTitan()
	if ( !IsValid( titan ) )
	{
		PlayerInSolidFailsafe( human, human.GetOrigin(), titan )
		return
	}

	printtodiag( Time() + ": HumanJumpsOffTitan(): human = " + human + ", titan = " + titan + "\n" )

	// move the player into the titan if he would be in solid
	MoveToLegalSolidFromTitan( human, titan )

	EmitDifferentSoundsOnEntityForPlayerAndWorld( "Rodeo_Jump_Off_Interior", "Rodeo_Jump_Off", human, titan )

	local angles = human.EyeAngles() // human.GetViewVector()
	angles.x = 0
	angles.z = 0
	local forward =  angles.AnglesToForward()
	local right =  angles.AnglesToRight()


	// map the player's controls to his angles, and add that velocity
	local xAxis = GetInput_XAxis( human )
	local yAxis = GetInput_YAxis( human )

	local velocity
	if ( fabs( xAxis ) < 0.2 && fabs( yAxis ) < 0.2 )
	{
		// no press = back press
		velocity = Vector(0,0,0)
	}
	else
	{
		local directionVec = Vector(0,0,0)
		directionVec += right * xAxis
		directionVec += forward * yAxis

		local directionAngles = VectorToAngles( directionVec )
		local directionForward = directionAngles.AnglesToForward()

		local vel
		if ( e.zapped )
		{
			vel = 630
			directionForward.z = 1.0
			directionForward.Norm()
		}
		else
		{
			vel = 350
		}

		velocity = directionForward * vel
	}

	velocity += Vector(0,0,490 )

	human.SetVelocity( velocity )

	PlayerInSolidFailsafe( human, human.GetOrigin(), titan )
}

function HumanRodeoViewCone( human, titanType )
{
	human.PlayerCone_FromAnim()

	local titanName = Native_GetTitanNameByType(titanType)
	if ( titanName != null )
	{
		human.PlayerCone_SetMinYaw( GetPlayerSettingsFieldForClassName(titanName, "RodeoViewCone_MinYaw") )
		human.PlayerCone_SetMaxYaw( GetPlayerSettingsFieldForClassName(titanName, "RodeoViewCone_MaxYaw") )
		human.PlayerCone_SetMinPitch( GetPlayerSettingsFieldForClassName(titanName, "RodeoViewCone_MinPitch") )
		human.PlayerCone_SetMaxPitch( GetPlayerSettingsFieldForClassName(titanName, "RodeoViewCone_MaxPitch") )
	}

	switch ( titanType )
	{
		//case "special_atlas":
		case "atlas":
			human.PlayerCone_SetMinYaw( -140 )
			human.PlayerCone_SetMaxYaw( 35 )
			human.PlayerCone_SetMinPitch( -60 )
			human.PlayerCone_SetMaxPitch( 40 )
			break

		//case "special_ogre":
		case "ogre":
			human.PlayerCone_SetMinYaw( -110 )
			human.PlayerCone_SetMaxYaw( 70 )
			human.PlayerCone_SetMinPitch( -60 )
			human.PlayerCone_SetMaxPitch( 40 )
			break

		case "special_stryder":
		case "special_atlas":
		case "special_ogre":
			human.PlayerCone_SetMinYaw( -100 )
			human.PlayerCone_SetMaxYaw( 100 )
			human.PlayerCone_SetMinPitch( -40 )
			human.PlayerCone_SetMaxPitch( 40 )
			break

		case "stryder":
			human.PlayerCone_SetMinYaw( -100 )
			human.PlayerCone_SetMaxYaw( 60 )
			human.PlayerCone_SetMinPitch( -35 )
			human.PlayerCone_SetMaxPitch( 35 )
			break

		case "slammer": //Who tf is slammer??? -Yoshi
			human.PlayerCone_SetMinYaw( -100 )
			human.PlayerCone_SetMaxYaw( 60 )
			human.PlayerCone_SetMinPitch( -35 )
			human.PlayerCone_SetMaxPitch( 35 )
			break
	}
}

function MoveToLegalSolidFromTitan( mover, titan )
{
	printtodiag( Time() + ": MoveToLegalSolidFromTitan(): mover = " + mover + ", titan = " + titan + "\n" )

	Assert( mover.IsPlayer() )

	local attachment = BMT_RodeoOverride( titan )//titan.LookupAttachment( "hijack" )
	//if ( GetSoulTitanType( titan.GetTitanSoul() ) == "special_ogre" )//modded
		//attachIndex = titan.LookupAttachment( "chestfocus" )//chestfocus
	
	local attachIndex = titan.LookupAttachment( attachment )

	local start = titan.GetAttachmentOrigin( attachIndex )
	local end = mover.GetOrigin()

	local result = TraceHull( start, end, mover.GetPlayerMins(), mover.GetPlayerMaxs(), titan, TRACE_MASK_PLAYERSOLID_BRUSHONLY, TRACE_COLLISION_GROUP_PLAYER )

	//PrintTable( result )

	if ( result.startSolid )
	{
		// in solid the whole time, teleport to the titan's origin
		//printt( "MoveToLegalSolidFromTitan: startSolid, move pilot to Titan origin" )
		mover.SetAbsOrigin( titan.GetOrigin() ) //Note that we might actually end up in clip that is non-solid to Titans, but solid to pilots. This checked for later in PlayerInSolidFailsafe
		return

	}

	local traceResult = result.fraction
	if ( traceResult >= 1.0 )
	{
		//printt( "Didn't hit solid, exiting" )
		return
	}


	local desiredPoint = LerpVector( start, end, result.fractionLeftSolid )
	mover.SetAbsOrigin( desiredPoint )

	//printt( "MoveToLegalSolidFromTitan, setting to desiredPoint: " + desiredPoint )
}
Globalize( MoveToLegalSolidFromTitan )

function OpenViewCone( player )
{
	player.PlayerCone_FromAnim()
	player.PlayerCone_SetMinYaw( -179 )
	player.PlayerCone_SetMaxYaw( 181 )
	player.PlayerCone_SetMinPitch( -60 )
	player.PlayerCone_SetMaxPitch( 60 )
}

function PlayerBeginsRodeo( player, rodeoPackage, titan )
{
	Assert( player.GetParent() == null )
	player.PlayerLunge_End()

	Assert( IsValid( player ) )
	Assert( IsValid( titan ) )
	Assert( titan.IsTitan() )
	Assert( !player.IsTitan() )

	// hide name of the pilot while he is rodeoing
	player.SetNameVisibleToFriendly( false )
	player.SetNameVisibleToEnemy( false )

	local soul = titan.GetTitanSoul()
	local sameTeam = player.GetTeam() == titan.GetTeam()
	local playerWasEjecting = player.pilotEjecting // have to store this off here because the "RodeoStarted" signal below ends eject, so it will be too late to check it in actual rodeo function

	local e = {}
	e.zapped <- false

	if ( playerWasEjecting )
		Stats_IncrementStat( player, "misc_stats", "rodeosFromEject", 1 )

	player.Signal( "RodeoStarted" )

	// Added via AddCallback_OnRodeoStarted
	foreach ( callbackInfo in level.onRodeoStartedCallbacks )
	{
		callbackInfo.func.acall( [callbackInfo.scope, player ] )
	}

	OnThreadEnd(
		function () : ( player, soul, e, sameTeam )
		{

			//Clear the rodeo alert
			if ( IsValid( soul ) )
			{
				soul.SetRiderEnt( null )
				soul.SetLastRodeoHitTime( 0 ) //Clear rodeo warning
			}

			if ( IsValid( player ) )
			{
				player.Signal( "RodeoOver" )

				// Added via AddCallback_OnRodeoEnded
				foreach ( callbackInfo in level.onRodeoEndedCallbacks )
				{
					callbackInfo.func.acall( [callbackInfo.scope, player ] )
				}

				player.rodeoDisabledTime = Time() + 1.25

				if ( IsFFABased() )
				{
					player.SetNameVisibleToFriendly( false )
					player.SetNameVisibleToEnemy( false )
				}
				else
				{
					player.SetNameVisibleToFriendly( true )
					player.SetNameVisibleToEnemy( true )
				}

				player.ClearAnimViewEntity()

				// blend out the clear anim view entity
				player.SetAnimViewEntityLerpInTime( 0.4 )

				player.ClearParent()
				player.Anim_Stop()
				player.SetOneHandedWeaponUsageOff()
				player.SetTitanSoulBeingRodeoed( null )
				player.UnforceStand()
				player.kv.PassDamageToParent = false

				Assert( IsValid( player.s.rodeoPackage, "Rodeo Package is not valid at end of PlayerBeginsRodeo!" ) )
				local package = player.s.rodeoPackage
				StopSoundOnEntity( player, package.cockpitSound )
				StopSoundOnEntity( player, package.worldSound )

				if ( IsAlive( player ) && IsValid( soul ) )
				{
					thread HumanJumpsOffTitan( player, soul, e )
				}

				if ( Rodeo_IsAttached( player ) )
				{
					Rodeo_Detach( player )
				}
			}
		}
	)

	soul.EndSignal( "OnTitanDeath" )
	soul.EndSignal( "OnDestroy" )

	player.EndSignal( "OnDeath" )
	player.EndSignal( "Disconnected" )
	player.EndSignal( "RodeoOver" )

	local jumpDetect = {}
	EndSignal( jumpDetect, "OnDeath" )
	thread PlayerJumpsOffDetect( player, jumpDetect )

	soul.SetRiderEnt( player )

	local titanType = GetSoulTitanType( soul )

	if ( titanType == "special_stryder" || titanType == "special_atlas" || titanType == "special_ogre" )
		titanType = "stryder"

	player.SetTitanSoulBeingRodeoed( soul )
	player.ForceStand()

	player.HolsterWeapon()
	player.SetOneHandedWeaponUsageOn()
	if ( soul.GetShieldHealth() > 0 )
		GiveFriendlyRodeoPlayerProtection( titan )

	player.TouchGround() // so you can double jump off

	Assert( IsValid( soul ) )
	local doHatchRip = !soul.rodeoPanel.s.opened && ( !sameTeam && ( Rodeo_GetStabilizeView() < 2 ) )

	waitthread PlayerLerpsIntoTitanRodeo( player, soul.GetTitan(), rodeoPackage, false, playerWasEjecting )
	if ( !IsValid( soul ) || !IsAlive( soul.GetTitan() ) )
		return

	if ( !sameTeam )
	{
		PlayConversationToPlayer( "RodeoConnect", player )
		//ForceWeaponSwitchForRodeo( player )

		TitanVO_AlertTitansTargetingThisTitanOfRodeo( player, soul )
	}

	if ( doHatchRip )
	{
		waitthread PlayerRipsOpenTitanHatch( player, soul, e )
	}
	else
	{
		//go straight into idle animations
		local anims = level.rodeoAnimations

		local sequence = CreateFirstPersonSequence()
		sequence.thirdPersonAnimIdle 	= GetAnimFromAlias( titanType, anims.thirdPersonAnimAlias_AimIdle )
		sequence.firstPersonAnimIdle 	= GetAnimFromAlias( titanType, anims.firstPersonAnimAlias_AimIdle )
		sequence.useAnimatedRefAttachment  = true

		thread FirstPersonSequence( sequence, player, soul.GetTitan() )
	}

	if ( sameTeam || ( Rodeo_GetStabilizeView() > 1 ) )
	{
		player.GetFirstPersonProxy().Hide()
		OpenViewCone( player )
	}
	else
	{
		HumanRodeoViewCone( player, titanType )
	}

	// look! he rodeoed!
	thread AIChatter( "aichat_rodeo_cheer", player.GetTeam(), player.GetOrigin() )

	Rodeo_OnFinishClimbOnAnimation( player ) // This is to let code know the player has finished climbing on the rodeo and ready to fire

	player.DeployWeapon()

	local playlist 	= GetCurrentPlaylistName().tolower()
	local name 		= player.GetPlayerName().tolower()

	waitthread RodeoPlayerRidesTitan( player, soul, sameTeam )

	WaitForever()
}

function PlayerJumpsOffDetect( player, table )
{
	player.EndSignal( "OnDeath" )
	player.EndSignal( "Disconnected" )
	player.EndSignal( "RodeoOver" )

	wait 0.6 // debounce so you dont accihop
	WaitButtonPressed( player, "jump" )
	Signal( table, "OnDeath" )
}

function PlayerLerpsIntoTitanRodeo( player, titan, package, doHatchRip = false, playerWasEjecting = false )
{
	printtodiag( Time() + ": PlayerLerpsIntoTitanRodeo(): " + player + "\n" )

	player.EndSignal( "OnDeath" )
	player.EndSignal( "Disconnected" )
	local soul = titan.GetTitanSoul()
	soul.EndSignal( "OnTitanDeath" )
	soul.EndSignal( "OnDestroy" )

	OnThreadEnd(
		function() : ( player )
		{
			if ( IsValid( player ) )
				DeleteAnimEvent( player, "rodeo_screen_shake", RodeoScreenShake )
		}
	)
	AddAnimEvent( player, "rodeo_screen_shake", RodeoScreenShake )

	local sequence = CreateFirstPersonSequence()
	sequence.attachment = BMT_RodeoOverride( titan )


	switch ( package.method )
	{
		case RODEO_APPROACH_FALLING_FROM_ABOVE:
			SetRodeoAnimsFromPackage( sequence, package )

			local animStartPos = player.Anim_GetStartForRefEntity( sequence.thirdPersonAnim, titan, sequence.attachment )//modded the attachment here
		//	printt( "distance " + Distance( player.GetOrigin(), animStartPos.origin ) )
			local dist = Distance( player.GetOrigin(), animStartPos.origin )
			local velocity = player.GetVelocity().Length()
			local fallTime = dist / velocity
			fallTime *= 0.95

			sequence.blendTime = clamp( fallTime, 0.4, 1 )

			break

		case RODEO_APPROACH_JUMP_ON:
			SetRodeoAnimsFromPackage( sequence, package )

			sequence.blendTime = 0.6

			break

		default:
			Assert( 0, "Unhandled rodeo method " + method )
	}

	if ( !PlayerHasPassive( player, PAS_STEALTH_MOVEMENT ) )
		EmitDifferentSoundsOnEntityForPlayerAndWorld( sequence.cockpitSound, sequence.worldSound, player, titan )
//	local blendTime = GraphCapped( velocity, 150, 700, 0.85, 0.15 )
//	local unitsPerSecond = dist / velocity
//	sequence.blendTime = Graph( unitsPerSecond, 0.1, 0.7, 0.05, 0.20 )
//	printt( "animation " + sequence.thirdPersonAnim )
//	printt( "dist: " + dist )
//	printt( "velocity: " + velocity )
//	printt( "fallTime: " + fallTime )
//	local distance = GetAnimStart(
//	printt( "blendtime " + sequence.blendTime  )
	//sequence.blendTime *= 2.4
	//sequence.blendTime = 0.1
// mackey

	if ( !( player in soul.rodeoRiderTracker ) )
	{
		soul.rodeoRiderTracker[ player ] <- true
		if ( titan.GetTeam() == player.GetTeam() )
		{
			AddPlayerScore( player, "HitchRide" )
			AddPlayerScore( titan, "GiveRide" )
		}
		else
		{
			AddPlayerScore( player, "RodeoEnemyTitan" )
		}
	}

	local time = player.GetSequenceDuration( sequence.thirdPersonAnim )

	thread FirstPersonSequence( sequence, player, titan )
	wait time
}

function PlayerRipsOpenTitanHatch( player, soul, e )
{
	printtodiag( Time() + ": PlayerRipsOpenTitanHatch(): " + player + "\n" )

	local titanType = GetSoulTitanType( soul )
	local hatchRipSoundInterior = "Rodeo_" + titanType + "_Hatch_Ripoff_Interior"
	local hatchRipSoundExterior = "Rodeo_" + titanType + "_Hatch_Ripoff_Exterior"

	OnThreadEnd(
		function() : ( player, soul, hatchRipSoundInterior, hatchRipSoundExterior )
		{
			if ( !IsValid( soul ) )
				return

			local rodeoPanel = soul.rodeoPanel

			if ( !IsValid( rodeoPanel ) )
				return

			DeleteAnimEvent( rodeoPanel, "rodeo_panel_open", RodeoPanelIsOpen )

			if ( !rodeoPanel.s.opened )
			{
				//printt( "Stopping anim on rodeo panel" )
				local titanType = GetSoulTitanType( soul )
				local anims = level.rodeoAnimations

				rodeoPanel.Anim_Stop()
				rodeoPanel.Anim_Play( GetAnimFromAlias( titanType, anims.panelPersonAnimAlias_PanelCloseIdle ) )

				if ( !IsValid( player ) )
					return

				StopSoundOnEntity( player, hatchRipSoundInterior )
				StopSoundOnEntity( player, hatchRipSoundExterior )
			}

		}
	)
	local titanType = GetSoulTitanType( soul )
	local anims = level.rodeoAnimations

	if ( titanType == "special_stryder" || titanType == "special_atlas" || titanType == "special_ogre" )
		titanType = "stryder"

	local sequence = CreateFirstPersonSequence()
	sequence.attachment = BMT_RodeoOverride( soul.GetTitan() )

	sequence.thirdPersonAnim 		= GetAnimFromAlias( titanType, anims.thirdPersonAnimAlias_PanelOpen )
	sequence.thirdPersonAnimIdle 	= GetAnimFromAlias( titanType, anims.thirdPersonAnimAlias_AimIdle )
	sequence.firstPersonAnim 		= GetAnimFromAlias( titanType, anims.firstPersonAnimAlias_PanelOpen )
	sequence.firstPersonAnimIdle 	= GetAnimFromAlias( titanType, anims.firstPersonAnimAlias_AimIdle )

	e.soul <- soul
	e.rodeoPlayer <- player
	local rodeoPanel = soul.rodeoPanel
	AddAnimEvent( rodeoPanel, "rodeo_panel_open", RodeoPanelIsOpen, e )

	rodeoPanel.Anim_Play( GetAnimFromAlias( titanType, anims.panelPersonAnimAlias_PanelOpen ) )

	local titan = soul.GetTitan()
	if ( !IsValid( titan ) )
		return

	EmitDifferentSoundsOnEntityForPlayerAndWorld( hatchRipSoundInterior, hatchRipSoundExterior, player, titan ) //Play sound on player instead of panel
	FirstPersonSequence( sequence, player, titan )
}


function RodeoPanelIsOpen( panel, e )
{
	panel.s.opened = true
	e.soul.SetLastRodeoHitTime( Time() ) //Make warning always trigger now when panel is ripped

}

function RodeoPlayerRidesTitan( player, soul, sameTeam )
{
	if ( sameTeam )
	{
		for ( ;; )
		{
			WaitEndFrame() // Fix subtle timing issue when auto titans are rodeoed to death
			local titan = soul.GetTitan()
			if ( !IsValid( titan ) )
				return

			if ( !titan.IsPlayer() )  //Handle the case where this is an NPC Titan: Wait until a player gets in and in the process kills the NPC titan
			{
				titan.WaitSignal( "OnDeath" )
				continue
			}

			titan.WaitSignal( "DisembarkingTitan" )
		}
	}

	for ( ;; )
	{
		WaitEndFrame() // Fix subtle timing issue when auto titans are rodeoed to death
		local titan = soul.GetTitan()
		if ( !IsValid( titan ) )
			return

		if ( !titan.IsPlayer() )  //Handle the case where this is an NPC Titan: Wait until a player gets in and in the process kills the NPC titan
		{
			titan.WaitSignal( "OnDeath" )
			continue
		}

		titan.WaitSignal( "DisembarkingTitan" )
		//wait 0.3
		//waitthread RodeoPlayerSeesDisembark( player, soul )
	}
}

function RodeoScreenShake( human )
{
//	wait 0.4

	// SKHW: I am disabling this because the actual shake looks like a bug. Should add proper, good-looking screenshake.
	// Remote.CallFunction_Replay( human, "ServerCallback_RodeoScreenShake" )
}

function RodeoPlayerSeesDisembark( human, soul )
{
	Assert( IsValid( soul ) )
	soul.EndSignal( "OnDestroy" )
	local anims = level.rodeoAnimations

	local titanType = GetSoulTitanType( soul )
	local sequence = CreateFirstPersonSequence()

	if ( titanType == "special_stryder" || titanType == "special_atlas" || titanType == "special_ogre" )
		titanType = "stryder"

	sequence.blendTime = 0
	sequence.attachment = BMT_RodeoOverride( soul.GetTitan() )

	sequence.thirdPersonAnim 		= GetAnimFromAlias( titanType, anims.thirdPersonAnimAlias_lean )
	sequence.thirdPersonAnimIdle 	= GetAnimFromAlias( titanType, anims.thirdPersonAnimAlias_AimIdle )
	sequence.firstPersonAnim 		= GetAnimFromAlias( titanType, anims.firstPersonAnimAlias_lean_enemy )


	sequence.firstPersonAnimIdle = GetAnimFromAlias( titanType, anims.firstPersonAnimAlias_AimIdle )
	sequence.firstPersonAnimIdle 	= GetAnimFromAlias( titanType, anims.firstPersonAnimAlias_AimIdle )

	//printt( "duration " + human.GetSequenceDuration( sequence.thirdPersonAnim ) )
	waitthread FirstPersonSequence( sequence, human, soul )

	HumanRodeoViewCone( human, titanType )
}

function UpdateKnifeAttachment( knife, titan )
{
	knife.ClearParent()
	local attach = titan.LookupAttachment( "hatch_panel" )
	local origin = titan.GetAttachmentOrigin( attach )
	local angles = titan.GetAttachmentAngles( attach )

//	angles = angles.AnglesCompose( Vector(300,220,130) )
	angles = angles.AnglesCompose( Vector(190,-120,60) )
	local forward = angles.AnglesToForward()
	local up = angles.AnglesToUp()
	local right = angles.AnglesToRight()

	angles = angles.AnglesCompose( Vector(-20,0,0) )

	origin += right * 6
	origin += up * 10
	origin += forward * -10
	knife.SetOrigin( origin )
	knife.SetAngles( angles )

	knife.SetParent( titan, "hatch_panel", true, 0.0 )
}


function CodeCallback_EmbarkTitan( player, titan )
{
	if ( titan == player.PlayerLunge_GetTarget() )
	{
		if ( PlayerCanImmediatelyEmbarkTitan( player, titan ) )
		{
			local embarkDirection = FindBestEmbark( player, titan )
			thread PlayerEmbarksTitan( player, titan, embarkDirection )
		}
	}
}

function CodeCallback_StartRodeo( player, titan )
{
	if ( !IsMultiplayer() )
		return

	//if ( IsMenuLevel() )
	//	return

	Assert( "rodeoPackage" in player.s )

	if ( GetBugReproNum() == 7205 )
	{
		thread RodeoTest( player, titan )
	}
	else
	{
		thread PlayerBeginsRodeo( player, player.s.rodeoPackage, titan )
	}
}

function RodeoTest( player, titan )
{
	player.SetParent( titan, "RODEO", false, 1 )
	wait 5
	player.ClearParent()
	Rodeo_Detach( player )
}


/************************************************************************************************\

		SPECTRE RODEO

\************************************************************************************************/
const SPECTRE_RODEO_MAX_DIST_SQR = 202500 // 450 sqrd
const SPECTRE_RODEO_MIN_DIST_SQR = 40000 // 200 sqrd
function CanSpectreRodeo( spectre, titan )
{
	local distanceFromTitan = DistanceSqr( titan.GetOrigin(), spectre.GetOrigin() )
	if ( distanceFromTitan > SPECTRE_RODEO_MAX_DIST_SQR )
		return false

	if ( distanceFromTitan < SPECTRE_RODEO_MIN_DIST_SQR )
		return false

	local soul = titan.GetTitanSoul()

	if ( soul.GetRiderEnt() )
		return false

	if ( !spectre.IsInterruptable() )
		return false

	if ( GetElapsedNPCRodeoTime( soul ) < level.coopRodeoGraceTime )
		return false

	if ( spectre.GetParent() != null )
		return false

	if ( !IsFacingEnemy( titan, spectre, 30 ) )
		return false

	return true
}
Globalize( CanSpectreRodeo )


function SetCoopRodeoGracePeriod( time )
{
	level.coopRodeoGraceTime = time
}
Globalize( SetCoopRodeoGracePeriod )


function GetElapsedNPCRodeoTime( soul )
{
	Assert( IsSoul( soul ) )
	if ( !( "lastNPCRodeo" in soul.s ) )
		soul.s.lastNPCRodeo <- -level.coopRodeoGraceTime

	local elapsedRodeoTime = Time() - soul.s.lastNPCRodeo
	return elapsedRodeoTime
}

function SetLastNPCRodeoTime( soul )
{
	Assert( IsSoul( soul ) )
	if ( !( "lastNPCRodeo" in soul.s ) )
		soul.s.lastNPCRodeo <- -level.coopRodeoGraceTime

	soul.s.lastNPCRodeo = Time()
}

function SpectreRodeo( spectre, titan )
{
	local package = GetRodeoPackageSpectre( spectre, titan )
	Assert ( package != null )
	printl(titan)
	SpectreBeginsRodeo( spectre, package, titan )
}
Globalize( SpectreRodeo )


function SpectreBeginsRodeo( spectre, rodeoPackage, titan )
{
	Assert( spectre.GetParent() == null )

	Assert( IsValid( spectre ) )
	Assert( IsValid( titan ) )
	Assert( titan.IsTitan() )
	Assert( spectre.IsSpectre() )

	local soul = titan.GetTitanSoul()
	local sameTeam = spectre.GetTeam() == titan.GetTeam()

	if ( sameTeam )
	{
		// hide name of the pilot while he is rodeoing
		spectre.SetNameVisibleToFriendly( false )
		spectre.SetNameVisibleToEnemy( false )
	}

	local e = {}
	e.zapped <- false

	spectre.Signal( "RodeoStarted" )

	OnThreadEnd(
		function () : ( spectre, soul, e, sameTeam, rodeoPackage )
		{

			//Clear the rodeo alert
			if ( IsValid( soul ) )
			{
				soul.SetRiderEnt( null )
				soul.SetLastRodeoHitTime( 0 ) //Clear rodeo warning
			}

			if ( IsValid( spectre ) )
			{
				spectre.Signal( "RodeoOver" )

				//spectre.rodeoDisabledTime = Time() + 1.25

				// show name of the pilot again
				spectre.SetNameVisibleToFriendly( true )
				spectre.SetNameVisibleToEnemy( true )

				spectre.ClearParent()
				spectre.Anim_Stop()

				spectre.ClearAttackAnim()
				spectre.ClearIdleAnim()
				EnableLeeching( spectre )
				spectre.DoRodeoAttack( false )
				spectre.UseSequenceBounds( false )
				spectre.RagdollImmediate( false )
				spectre.SetEfficientMode( false )
				spectre.SetSensing( true )

				StopSoundOnEntity( spectre, rodeoPackage.cockpitSound )
				StopSoundOnEntity( spectre, rodeoPackage.worldSound )
			}
		}
	)

	soul.EndSignal( "OnTitanDeath" )
	soul.EndSignal( "OnDestroy" )

	spectre.EndSignal( "OnDeath" )
	spectre.EndSignal( "OnDestroy" )
	spectre.EndSignal( "RodeoOver" )

	soul.SetRiderEnt( spectre )
	SetLastNPCRodeoTime( soul )

	local titanType = GetSoulTitanType( soul )

	spectre.GetActiveWeapon().Hide()
	DisableRockets( spectre )
	spectre.SetEfficientMode( true )
	spectre.SetSensing( false )
	spectre.RagdollImmediate( true )
	spectre.UseSequenceBounds( true )
	DisableLeeching( spectre )

	Assert( IsValid( soul ) )
	local doHatchRip = !soul.rodeoPanel.s.opened && ( !sameTeam && ( Rodeo_GetStabilizeView() < 2 ) )

	waitthread SpectreLerpsIntoTitanRodeo( spectre, soul, rodeoPackage )
	if ( !IsValid( soul ) || !IsAlive( soul.GetTitan() ) )
		return

	if ( !sameTeam )
		TitanVO_AlertTitansTargetingThisTitanOfRodeo( spectre, soul )

	SetForceDrawWhileParented( spectre, false )

	if ( doHatchRip )
	{
		waitthread SpectreRipsOpenTitanHatch( spectre, soul, e )
	}

	local attackAnim = GetAnimFromAlias( titanType, "pt_rodeo_panel_fire" )
	spectre.SetAttackAnim( attackAnim )

	local thirdPersonAnimIdle = GetAnimFromAlias( titanType, "pt_rodeo_panel_aim_idle" )
	spectre.SetIdleAnim( thirdPersonAnimIdle )

	spectre.DoRodeoAttack( true )
	spectre.GetActiveWeapon().Show()

	WaitForever()
}

function SpectreLerpsIntoTitanRodeo( spectre, soul, package )
{
	spectre.EndSignal( "OnDeath" )
	spectre.EndSignal( "OnDestroy" )
	soul.EndSignal( "OnTitanDeath" )
	soul.EndSignal( "OnDestroy" )
	soul.GetTitan().EndSignal( "Disconnected" )

	local attachment 	= BMT_RodeoOverride( soul.GetTitan() )

	local blendTime 	= null
	local jumpFirst 	= false

	switch ( package.method )
	{
		case RODEO_APPROACH_FALLING_FROM_ABOVE:
			local animStartPos = spectre.Anim_GetStartForRefEntity( package.thirdPersonAnim, soul.GetTitan(), attachment )
			local dist = Distance( spectre.GetOrigin(), animStartPos.origin )
			local velocity = spectre.GetVelocity().Length()
			local fallTime = dist / velocity
			fallTime *= 0.95
			blendTime = clamp( fallTime, 0.4, 1 )
			break

		case RODEO_APPROACH_JUMP_ON:
			jumpFirst = true
			blendTime = 0.6
			break

		default:
			Assert( 0, "Unhandled rodeo method " + method )
	}

	EmitDifferentSoundsOnEntityForPlayerAndWorld( package.cockpitSound, package.worldSound, spectre, soul.GetTitan() )

	if ( jumpFirst )
	{
		local jumpAnim = "sp_traverse_across_512"
		local jumpTime = spectre.GetSequenceDuration( jumpAnim ) * 0.70
		local parentBlend = blendTime + ( jumpTime * 0.75 )

		local vec = soul.GetTitan().GetOrigin() - spectre.GetOrigin()
		local angles = VectorToAngles( vec )
		spectre.SetAngles( angles )
		local parent_string = BMT_RodeoOverride( soul.GetTitan() )

		spectre.SetParent( soul.GetTitan(), parent_string, false, parentBlend )
		spectre.Anim_ScriptedPlay( jumpAnim )
		SetForceDrawWhileParented( spectre, true )

		wait jumpTime - 0.2
		spectre.ClearParent()
		spectre.Signal( "LandedOnTitan" )

		//regrab the package because of new position
		package = GetRodeoPackageSpectre( spectre, soul.GetTitan() )
	}

	local time = spectre.GetSequenceDuration( package.thirdPersonAnim )
	spectre.SetParent( soul.GetTitan(), attachment, false, blendTime )
	thread PlayAnim( spectre, package.thirdPersonAnim, soul.GetTitan(), attachment, blendTime )
	wait time

	spectre.MarkAsNonMovingAttachment()
}

function SpectreRipsOpenTitanHatch( spectre, soul, e )
{
	local titanType = GetSoulTitanType( soul )

	if ( titanType == "special_stryder" || titanType == "special_atlas" || titanType == "special_ogre" )
		titanType = "stryder"

	local hatchRipSoundInterior = "Rodeo_" + titanType + "_Hatch_Ripoff_Interior"
	local hatchRipSoundExterior = "Rodeo_" + titanType + "_Hatch_Ripoff_Exterior"

	OnThreadEnd(
		function() : ( spectre, soul, hatchRipSoundInterior, hatchRipSoundExterior )
		{
			if ( !IsValid( soul ) )
				return

			local rodeoPanel = soul.rodeoPanel

			if ( !IsValid( rodeoPanel ) )
				return

			DeleteAnimEvent( rodeoPanel, "rodeo_panel_open", RodeoPanelIsOpen )

			if ( !rodeoPanel.s.opened )
			{
				//printt( "Stopping anim on rodeo panel" )
				local titanType = GetSoulTitanType( soul )
				local anims = level.rodeoAnimations

				rodeoPanel.Anim_Stop()
				rodeoPanel.Anim_Play( GetAnimFromAlias( titanType, anims.panelPersonAnimAlias_PanelCloseIdle ) )

				if ( !IsValid( spectre ) )
					return

				StopSoundOnEntity( spectre, hatchRipSoundInterior )
				StopSoundOnEntity( spectre, hatchRipSoundExterior )
			}

		}
	)
	local titanType = GetSoulTitanType( soul )
	local anims = level.rodeoAnimations


	local attachment = BMT_RodeoOverride( soul.GetTitan() )

	local thirdPersonAnim 		= GetAnimFromAlias( titanType, anims.thirdPersonAnimAlias_PanelOpen )

	e.soul <- soul
	e.rodeoPlayer <- spectre
	local rodeoPanel = soul.rodeoPanel
	AddAnimEvent( rodeoPanel, "rodeo_panel_open", RodeoPanelIsOpen, e )

	rodeoPanel.Anim_Play( GetAnimFromAlias( titanType, anims.panelPersonAnimAlias_PanelOpen ) )

	local titan = soul.GetTitan()
	if ( !IsValid( titan ) )
		return

	EmitDifferentSoundsOnEntityForPlayerAndWorld( hatchRipSoundInterior, hatchRipSoundExterior, spectre, titan ) //Play sound on spectre instead of panel
	PlayAnim( spectre, thirdPersonAnim, titan, attachment )
}

function BMT_RodeoOverride( titan )
{
	local soul = titan.GetTitanSoul()
	local loop_max = MasterModdedTitans.len()
	for( local E = 0; E < loop_max; E++ )
	{
		if( loop_max > 0 )
		{
			local t_a = MasterModdedTitans[ E ]
			local setting = GetSoulPlayerSettings( soul )
			if( setting == t_a.setfile )
			{
				if( t_a.rodeo_ref_override != "" )
					return t_a.rodeo_ref_override
			}
		}
	}

	return "hijack"
}
