function main()
{
	Globalize( TitanNPC_Think )
	Globalize( TitanNPC_PostHotDrop_Think )
	Globalize( TitanStandUp )
	Globalize( TitanKneel )
	Globalize( GetBubbleShieldDuration )
	Globalize( ShowMainTitanWeapons )

	FlagInit( "DisableTitanKneelingEmbark" )

	RegisterSignal( "TitanStopsThinking" )
	RegisterSignal( "RodeoRiderChanged" )
}

function GetBubbleShieldDuration( player )
{
	if ( PlayerHasPassive( player, PAS_ENHANCED_TITAN_AI ) )
		return 0
	else if ( PlayerHasPassive( player, PAS_LONGER_BUBBLE ) )
		return EMBARK_TIMEOUT += 10
	else
		return EMBARK_TIMEOUT
}

function TitanNPC_PostHotDrop_Think( titan )
{
	Assert( IsAlive( titan ) )

	titan.Signal( "TitanStopsThinking" )
	titan.EndSignal( "OnDeath" )
	titan.EndSignal( "TitanStopsThinking" )
	titan.EndSignal( "ContextAction_SetBusy" )

	local bossPlayer = titan.GetBossPlayer()
	if ( !bossPlayer )
	{
		return
	}

	OnThreadEnd(
		function () : ( titan )
		{
			if ( IsAlive( titan ) )
				thread TitanNPC_Think( titan )
		}
	)

	titan.EndSignal( "ChangedTitanMode" )

	local player = titan.GetBossPlayer()
	local timeout = GetBubbleShieldDuration( player )

	wait timeout

	SetUpNPCTitanCurrentMode( player, eNPCTitanMode.FOLLOW )

	wait SHIELD_FADE_ARBITRARY_DELAY + SHIELD_FADE_ENDCAP_DELAY

	if( !IsTrainingLevel() )
		thread SetPlayerActiveObjectiveWithTime( player, "Titan_Status_Auto", 5.0 )
}

function TitanNPC_Think( titan )
{
	local soul = titan.GetTitanSoul()

	if ( soul.capturable )
	{
		// capturable titan just kneels
		thread TitanKneel( titan )
		return
	}

	Assert( IsAlive( titan ) )
	if ( !titan.GetDoomedState() )
	{
		// server doesn't actually track if the eye was destroyed, so eye will reappear in some cases
		ShowTitanEye( titan ) // by now we are in a pose where eye should be shown
	}

	TitanCanStand( titan ) // sets the var
	if ( !titan.GetBossPlayer() )
	{
		titan.Signal( "TitanStopsThinking" )
		return
	}

	if( !IsTrainingLevel() )
		thread SetPlayerActiveObjectiveWithTime( titan.GetBossPlayer(), "Titan_Status_Auto", 5.0 )

	if ( "disableAutoTitanConversation" in titan.s ) //At this point the Titan has stood up and is ready to talk
		delete titan.s.disableAutoTitanConversation

	titan.EndSignal( "TitanStopsThinking" )
	titan.EndSignal( "OnDeath" )
	titan.EndSignal( "player_embarks_titan" )

	// kneel in certain circumstances
	for ( ;; )
	{
		if ( !ChangedStance( titan ) )
			waitthread TitanWaitsToChangeStance( titan )
	}
}

function ChangedStance( titan )
{
	if ( GetEmbarkDisembarkPlayer( titan ) )
		return false

	// in a scripted sequence?
	if ( IsValid( titan.GetParent() ) )
		return false

	local soul = titan.GetTitanSoul()
	if ( soul.GetStance() > STANCE_KNEELING )
	{
		if ( TitanShouldKneel( titan ) )
		{
			//waitthread PlayAnimGravity( titan, "at_MP_stand2knee_straight" )
			waitthread KneelToShowRider( titan )
			thread PlayAnim( titan, "at_MP_embark_idle_blended" )
			SetStanceKneel( soul )
			return true
		}
	}
	else
	{
		if ( !TitanShouldKneel( titan ) && TitanCanStand( titan ) )
		{
			waitthread TitanStandUp( titan )
			return true
		}
	}

	return false
}

function TitanShouldKneel( titan )
{
	local soul = titan.GetTitanSoul()
	local rider = soul.GetRiderEnt()

	if ( soul.capturable )
		return true

	if ( !IsAlive( rider ) )
		return false

	return rider.GetTeam() != titan.GetTeam()
}

function TitanWaitsToChangeStance( titan )
{
	local soul = titan.GetTitanSoul()
	soul.WaitSignal( "RodeoRiderChanged" )
}


function TitanStandUp( titan )
{
	local soul = titan.GetTitanSoul()
	// stand up
	titan.s.standQueued = false
	ShowMainTitanWeapons( titan )
	titan.Anim_Stop()
	waitthread PlayAnimGravity( titan, "at_hotdrop_quickstand" )
	Assert( soul == titan.GetTitanSoul() )
	SetStanceStand( soul )
}


function TitanKneel( titan )
{
	titan.EndSignal( "TitanStopsThinking" )
	titan.EndSignal( "OnDeath" )
	Assert( IsAlive( titan ) )
	local soul = titan.GetTitanSoul()

	waitthread KneelToShowRider( titan )
	HideTitanEyePartial( titan )

	thread PlayAnim( titan, "at_MP_embark_idle_blended" )
	SetStanceKneel( soul )
}



function TitanWaittillShouldStand( titan )
{
	//Don't wait if player is dead - titan should just stand up immediately
	local player = titan.GetBossPlayer()
	if ( !IsAlive( player ) )
		return

	player.EndSignal( "OnDeath" )

	for ( ;; )
	{
		if ( TitanCanStand( titan ) )
			break

		wait 5
	}
	if ( titan.s.standQueued )
		return

	titan.WaitSignal( "titanStand" )
}

function KneelToShowRider( titan )
{
	local soul = titan.GetTitanSoul()
	local player = soul.GetBossPlayer()
	local animation
	local yawDif

	//if ( IsAlive( player ) )
	//{
	//	local table = GetFrontRightDots( titan, player )
    //
	//	local dotForward = table.dotForward
	//	local dotRight = table.dotRight
    //
	////	DebugDrawLine( titanOrg, titanOrg + titan.GetForwardVector() * 200, 255, 0, 0, true, 5 )
	////	DebugDrawLine( titanOrg, titanOrg + vecToEnt * 200, 0, 255, 0, true, 5 )
    //
	//	if ( dotForward > 0.88 )
	//	{
	//		animation = "at_MP_stand2knee_L90"
	//		yawDif = 0
	//	}
	//	else
	//	if ( dotForward < -0.88 )
	//	{
	//		animation = "at_MP_stand2knee_R90"
	//		yawDif = 180
	//	}
	//	else
	//	if ( dotRight > 0 )
	//	{
	//		animation = "at_MP_stand2knee_straight"
	//		yawDif = 90
	//	}
	//	else
	//	{
	//		animation = "at_MP_stand2knee_180"
	//		yawDif = -90
	//	}
	//}
	//else
	{
		animation = "at_MP_stand2knee_straight"
		yawDif = 0
	}

	thread HideOgreMainWeaponFromEnemies( titan )

	if ( !IsAlive( player ) )
	{
		waitthread PlayAnimGravity( titan, animation )
		return
	}

	local titanOrg = titan.GetOrigin()
	local playerOrg = player.GetOrigin()

	local vec = playerOrg - titanOrg
	vec.z = 0

	local angles = VectorToAngles( vec )

	angles.y += yawDif

	local angles = titan.GetAngles()

	titan.Anim_ScriptedPlayWithRefPoint( animation, titanOrg, angles, 0.5 )
	titan.Anim_EnablePlanting()



	titan.WaittillAnimDone()
}

function HideOgreMainWeaponFromEnemies( titan )
{
	titan.EndSignal( "OnDeath" )
	titan.EndSignal( "OnDestroy" )

	wait 1.0

	local soul = titan.GetTitanSoul()

	Assert( IsValid( soul ) )

	local rider = soul.GetRiderEnt()

	local titanType = GetSoulTitanType( soul )
	if ( titanType == "ogre" || titanType == "special_ogre" )
	{
		if ( IsAlive( rider ) && rider.GetTeam() != titan.GetTeam() )
		{
			HideMainWeaponsFromEnemies( titan )
		}
	}

}

function HideMainWeaponsFromEnemies( titan )
{
	local weapons = titan.GetMainWeapons()
	foreach ( weapon in weapons )
	{
		weapon.kv.visibilityFlags = 2
	}
}

function ShowMainTitanWeapons( titan )
{
	local weapons = titan.GetMainWeapons()
	foreach ( weapon in weapons )
	{
		weapon.kv.visibilityFlags = 7
	}
}
