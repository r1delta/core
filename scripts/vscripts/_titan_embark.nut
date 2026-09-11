const FAST_EMBARK = 1
const SKIP_AHEAD_TIME = 2.0

function main()
{
	level.repeatEmbark <- 0
	level.pilotDisembarkBounds <- {}
	local end = {}
	end.up <- 50.363811
	end.forward <- 110.146927
	end.right <- 13.045869
	end.yaw <- -8.381051

	local start = {}
	start.up <- 156.750015
	start.forward <- -13.429688
	start.right <- -11.374998
	start.yaw <- 0.409042

	RefreshTitanEmbarkActions()

	level.TitanEmbarkFailsafeFunc <- null

	level.pilotDisembarkBounds.end <- end
	level.pilotDisembarkBounds.start <- start

	Globalize( PlayerCanEmbarkIntoTitan )
	Globalize( TitanIsCurrentlyEmbarkableForPlayer )
	Globalize( PlayerCanImmediatelyEmbarkTitan )
	Globalize( PlayerCanDisembarkTitan )
	Globalize( FindBestEmbark )
	Globalize( TitanCanStand )
	Globalize( PlayerCanEmbarkTitan )
	Globalize( PlayerLungesToEmbark )
	Globalize( ForcedTitanDisembark )
	Globalize( DebugEmbarkTimes )
	Globalize( IsPlayerEmbarking )
	Globalize( IsPlayerDisembarking )

	FlagInit( "Embark3rdPersonFix" )

	RegisterSignal( "OnComplete" )
	RegisterSignal( "startembark" ) // temp

	RegisterSignal( "TitanEmbarkComplete" )
	RegisterSignal( "DisembarkingTitan" )
	RegisterSignal( "player_embarks_titan" )

	Globalize( PlayerEmbarksTitan )

	if ( IsClient() )
	{
		Globalize( HideTitanEyeForEmbark )
	}
	else
	{
		// add all the embark anims with this suffix
		AddEmbarkAnims( "titan_atlas", "atlas" )
		AddEmbarkAnims( "titan_ogre", "ogre" )
		AddEmbarkAnims( "titan_stryder", "stryder" )
		AddEmbarkAnims( "titan_destroyer_tier0", "destroyer","ogre" )
		AddEmbarkAudio( "titan_atlas", "atlas" )
		AddEmbarkAudio( "titan_ogre", "ogre" )
		AddEmbarkAudio( "titan_stryder", "stryder" )
		AddEmbarkAudio("titan_destroyer_tier0", "destroyer", "ogre")
		Globalize( PlayerDisembarksTitan )

		RegisterSignal( "titanKneel" )
		RegisterSignal( "titanStand" )
		RegisterSignal( "titanEmbark" )

		AddClientCommandCallback( "TitanDisembark", ClientCommand_TitanDisembark ) //
		AddClientCommandCallback( "TitanKneel", ClientCommand_TitanKneel ) //
		AddClientCommandCallback( "TitanStand", ClientCommand_TitanStand ) //
		AddClientCommandCallback( "TitanNextMode", ClientCommand_TitanNextMode ) //
	}
	
	local loop_max = MasterModdedTitans.len()
	for( local E = 0; E < loop_max; E++ )
	{
		if( loop_max > 0 )
		{
			local t_a = MasterModdedTitans[ E ]
			switch( t_a.titan_type )
			{
				case "special_atlas":
					AddEmbarkAnims( t_a.setfile, "atlas", t_a.embark_override )
					AddEmbarkAudio( t_a.setfile, "atlas" )
				
				case "special_stryder":
					AddEmbarkAnims( t_a.setfile, "stryder", t_a.embark_override )
					AddEmbarkAudio( t_a.setfile, "stryder" )
				
				case "special_ogre":
					AddEmbarkAnims( t_a.setfile, "ogre", t_a.embark_override )
					AddEmbarkAudio( t_a.setfile, "ogre" )
			}
		}
	}
}



function AddEmbarkAnims( titan, titanType,basetitanType = "" )
{
	// anims are string-constructed from these types:
	local array =
	[
		"kneel_front",
		"kneel_behind",
		"kneel_right",
		"kneel_left",

		"stand_front",
		"stand_behind",
		"stand_airgrab",

		"above_right",
		"above_left",
		"kneel_above_right",
		"kneel_above_left",
	]


	// force consistency in animation names
	foreach ( item in array )
	{
		//printt( "Adding base " + item + " to " + titan )
		local thirdPersonAlias = "pt_mount_" + item
		local firstPersonAlias = "ptpov_mount_" + item
		local thirdPersonAnim;
		local firstPersonAnim;
		if( basetitanType != "" )
		{
			thirdPersonAnim = "pt_mount_" + basetitanType + "_" + item
			firstPersonAnim = "ptpov_mount_" + basetitanType + "_" + item
		}
		else {
			thirdPersonAnim = "pt_mount_" + titanType + "_" + item
		 	firstPersonAnim = "ptpov_mount_" + titanType + "_" + item
		}
		AddAnimAlias( titanType, thirdPersonAlias, thirdPersonAnim )
		AddAnimAlias( titanType, firstPersonAlias, firstPersonAnim )
	}
}

function AddEmbarkAudio( titan, titanType, basetitanType = "" )
{
	// audio files are string-constructed from these types:
	local array =
	[
		"Kneeling_Front",
		"Kneeling_Behind",
		"Kneeling_Right",
		"Kneeling_Left",
		"Kneeling_AboveRight",
		"Kneeling_AboveLeft",

		"Standing_Front",
		"Standing_Behind",
		"Standing_Airgrab",
		"Standing_AboveRight",
		"Standing_AboveLeft"
	]


	// force consistency in audio file names
	foreach ( item in array )
	{
		//printt( "Adding base " + item + " to " + titan )
		local thirdPersonAlias = "Embark_" + item + "_3P"
		local firstPersonAlias = "Embark_" + item + "_1P"
		local thirdPersonAnim;
		local firstPersonAnim;
		if( basetitanType != "" )
		{
			thirdPersonAnim =  basetitanType + "_Embark_" + item + "_3P"
			firstPersonAnim =  basetitanType + "_Embark_" + item + "_1P"
		}
		else
		{
		 	thirdPersonAnim =  titanType + "_Embark_" + item + "_3P"
		 	firstPersonAnim =  titanType + "_Embark_" + item + "_1P"
		}
		AddAudioAlias( titanType, thirdPersonAlias, thirdPersonAnim )
		AddAudioAlias( titanType, firstPersonAlias, firstPersonAnim )
	}
}



function RefreshTitanEmbarkActions()
{
	if ( "titanEmbarkActions" in level )
	{
		delete level.titanEmbarkActions
		delete level.titanEmbarkFarthestDistance
	}

	local groundDist = 260

	level.titanEmbarkActions <- []
	level.titanEmbarkFarthestDistance <- 0
	local action

	action =
	{
		direction = Vector( 1, 0, 0 )
		distance = groundDist
		embark = "front"
		minDot = 0.4
		priority = 1 // tried after priority 0 actions
		titanCanStandRequired = false
		//onGround = null // either
		useAnimatedRefAttachment = true
		alignFrontEnabled = true
		canSkipAhead = true

		animSet =
		{
			firstPersonKneelingAlias = "ptpov_mount_kneel_front"
			thirdPersonKneelingAlias = "pt_mount_kneel_front"
			firstPersonStandingAlias = "ptpov_mount_stand_front"
			thirdPersonStandingAlias = "pt_mount_stand_front"
			titanKneelingAnim = "at_mount_kneel_front"
			titanStandingAnim = "at_mount_stand_front"

		}

		audioSet =
		{
			firstPersonKneelingAudioAlias = "Embark_Kneeling_Front_1P"
			thirdPersonKneelingAudioAlias = "Embark_Kneeling_Front_3P"
			firstPersonStandingAudioAlias = "Embark_Standing_Front_1P"
			thirdPersonStandingAudioAlias = "Embark_Standing_Front_3P"

		}
	}
	level.titanEmbarkActions.append( action )

	action =
	{
		direction = Vector( 1, 0, 0 )
		distance = groundDist
		embark = "front"
		minDot = -1
		priority = 2 // tried after priority 1 actions
		titanCanStandRequired = false
		//onGround = null // either
		useAnimatedRefAttachment = true
		alignFrontEnabled = true
		canSkipAhead = true

		animSet =
		{
			firstPersonKneelingAlias = "ptpov_mount_kneel_front"
			thirdPersonKneelingAlias = "pt_mount_kneel_front"
			firstPersonStandingAlias = "ptpov_mount_stand_front"
			thirdPersonStandingAlias = "pt_mount_stand_front"
			titanKneelingAnim = "at_mount_kneel_front"
			titanStandingAnim = "at_mount_stand_front"
		}

		audioSet =
		{
			firstPersonKneelingAudioAlias = "Embark_Kneeling_Front_1P"
			thirdPersonKneelingAudioAlias = "Embark_Kneeling_Front_3P"
			firstPersonStandingAudioAlias = "Embark_Standing_Front_1P"
			thirdPersonStandingAudioAlias = "Embark_Standing_Front_3P"
		}
	}
	level.titanEmbarkActions.append( action )

	action =
	{
		direction = Vector( 0, 1, 0 )
		distance = groundDist
		embark = "left"
		minDot = 0.4
		priority = 1 // tried after priority 0 actions
		titanCanStandRequired = true
		useAnimatedRefAttachment = true
		alignFrontEnabled = true
		canSkipAhead = true
		//onGround = null // either

		animSet =
		{
			firstPersonKneelingAlias = "ptpov_mount_kneel_left"
			thirdPersonKneelingAlias = "pt_mount_kneel_left"
			firstPersonStandingAlias = "ptpov_mount_stand_front"
			thirdPersonStandingAlias = "pt_mount_stand_front"
			titanKneelingAnim = "at_mount_kneel_left"
			titanStandingAnim = "at_mount_stand_front"
		}

		audioSet =
		{
			firstPersonKneelingAudioAlias = "Embark_Kneeling_Left_1P"
			thirdPersonKneelingAudioAlias = "Embark_Kneeling_Left_3P"
			firstPersonStandingAudioAlias = "Embark_Standing_Front_1P"
			thirdPersonStandingAudioAlias = "Embark_Standing_Front_3P"
		}
	}
	level.titanEmbarkActions.append( action )

	action =
	{
		direction = Vector( 0, -1, 0 )
		distance = groundDist
		embark = "right"
		minDot = 0.4
		priority = 1 // tried after priority 0 actions
		titanCanStandRequired = true
		useAnimatedRefAttachment = true
		alignFrontEnabled = true
		canSkipAhead = true
		//onGround = null // either
		animSet =
		{
			firstPersonKneelingAlias = "ptpov_mount_kneel_right"
			thirdPersonKneelingAlias = "pt_mount_kneel_right"
			firstPersonStandingAlias = "ptpov_mount_stand_front"
			thirdPersonStandingAlias = "pt_mount_stand_front"
			titanKneelingAnim = "at_mount_kneel_right"
			titanStandingAnim = "at_mount_stand_front"
		}

		audioSet =
		{
			firstPersonKneelingAudioAlias = "Embark_Kneeling_Right_1P"
			thirdPersonKneelingAudioAlias = "Embark_Kneeling_Right_3P"
			firstPersonStandingAudioAlias = "Embark_Standing_Front_1P"
			thirdPersonStandingAudioAlias = "Embark_Standing_Front_3P"
		}
	}
	level.titanEmbarkActions.append( action )


	action =
	{
		direction = Vector( -1, 0, 0 )
		distance = groundDist
		embark = "behind"
		minDot = 0.4
		priority = 1 // tried after priority 0 actions
		titanCanStandRequired = true
		useAnimatedRefAttachment = true
		canSkipAhead = false
		//onGround = null // either

		animSet =
		{
			firstPersonKneelingAlias = "ptpov_mount_kneel_behind"
			thirdPersonKneelingAlias = "pt_mount_kneel_behind"
			firstPersonStandingAlias = "ptpov_mount_stand_behind"
			thirdPersonStandingAlias = "pt_mount_stand_behind"
			titanKneelingAnim = "at_mount_kneel_behind"
			titanStandingAnim = "at_mount_stand_behind"
		}

		audioSet =
		{
			firstPersonKneelingAudioAlias = "Embark_Kneeling_Behind_1P"
			thirdPersonKneelingAudioAlias = "Embark_Kneeling_Behind_3P"
			firstPersonStandingAudioAlias = "Embark_Standing_Behind_1P"
			thirdPersonStandingAudioAlias = "Embark_Standing_Behind_3P"
		}
	}
	level.titanEmbarkActions.append( action )

	action =
	{
		direction = Vector( 0, 0, 1 ) // 0 -1 1
		distance = 350
		embark = "above_close"
		minDot = 0.88
		canSkipAhead = false
		priority = 0 // priority actions are checked first

		titanCanStandRequired = true
		useAnimatedRefAttachment = true
		//onGround = false // must be in air

		animSets =
		{
			right =
			{
		 		direction = Vector( 0, -1, 0 ) // 0 -1 1
				firstPersonKneelingAlias = "ptpov_mount_kneel_above_right"
				thirdPersonKneelingAlias = "pt_mount_kneel_above_right"
				firstPersonStandingAlias = "ptpov_mount_above_right"
				thirdPersonStandingAlias = "pt_mount_above_right"
				titanKneelingAnim = "at_mount_kneel_above"
				titanStandingAnim = "at_mount_above_right"

				audioSet =   //An annoying exception to how the audioSet is organized, better this than the alternative and having to find the "best audio set"
				{
					firstPersonKneelingAudioAlias = "Embark_Kneeling_AboveRight_1P"
					thirdPersonKneelingAudioAlias = "Embark_Kneeling_AboveRight_3P"
					firstPersonStandingAudioAlias = "Embark_Standing_AboveRight_1P"
					thirdPersonStandingAudioAlias = "Embark_Standing_AboveRight_3P"
				}
			}

			left =
			{
		 		direction = Vector( 0, 1, 0 ) // 0 -1 1
				firstPersonKneelingAlias = "ptpov_mount_kneel_above_left"
				thirdPersonKneelingAlias = "pt_mount_kneel_above_left"
				firstPersonStandingAlias = "ptpov_mount_above_left"
				thirdPersonStandingAlias = "pt_mount_above_left"
				titanKneelingAnim = "at_mount_kneel_above"
				titanStandingAnim = "at_mount_above_left"

				audioSet = //An annoying exception to how the audioSet is organized, better this than the alternative and having to find the "best audio set"
				{
					firstPersonKneelingAudioAlias = "Embark_Kneeling_AboveLeft_1P"
					thirdPersonKneelingAudioAlias = "Embark_Kneeling_AboveLeft_3P"
					firstPersonStandingAudioAlias = "Embark_Standing_AboveLeft_1P"
					thirdPersonStandingAudioAlias = "Embark_Standing_AboveLeft_3P"
				}
			}
		}
	}
	level.titanEmbarkActions.append( action )

	action =
	{
		direction = Vector( 0, 0, 1 )
		distance = 275
		embark = "above_grab"
		minDot = 0.3
		titanCanStandRequired = true
		//onGround = null // false // must be in air
		useAnimatedRefAttachment = true
		//lungeCheck = true
		canSkipAhead = true

		alignFrontEnabled = true

		priority = 0 // priority actions are checked first

		animSet =
		{
			firstPersonKneelingAlias = "ptpov_mount_kneel_front"
			thirdPersonKneelingAlias = "pt_mount_kneel_front"
			titanKneelingAnim = "at_mount_kneel_front"

			firstPersonStandingAlias = "ptpov_mount_stand_airgrab"
			thirdPersonStandingAlias = "pt_mount_stand_airgrab"
			titanStandingAnim = "at_mount_stand_airgrab"
		}

		audioSet =
		{
			firstPersonKneelingAudioAlias = "Embark_Kneeling_Front_1P"
			thirdPersonKneelingAudioAlias = "Embark_Kneeling_Front_3P"
			firstPersonStandingAudioAlias = "Embark_Standing_Front_1P"
			thirdPersonStandingAudioAlias = "Embark_Standing_Front_3P"
		}
	}
	level.titanEmbarkActions.append( action )

	local autoParms =
	[
		"lungeCheck"
		"alignFrontEnabled"
	]

	foreach ( action in level.titanEmbarkActions )
	{
		if ( action.distance > level.titanEmbarkFarthestDistance )
		{
			level.titanEmbarkFarthestDistance = action.distance
		}
		foreach ( parm in autoParms )
		{
			if ( !( parm in action ) )
				action[ parm ] <- false
		}
	}
}

function DebugEmbarkTimes()
{
	local settings = [ "atlas", "ogre", "stryder", "special_atlas", "special_ogre", "special_stryder" ]

	local models = [ "models/Humans/imc_pilot/male_cq/imc_pilot_male_cq.mdl", "models/humans/pilot/female_cq/pilot_female_cq.mdl" ]
	local times = {}

	foreach ( model in models )
	{
		times[ model ] <- []
		local prop = CreatePropDynamic( model, Vector(0,0,0), Vector(0,0,0) )
		printt( "Human model: " + model )

		foreach ( setting in settings )
		{
			printt( "Titan: " + setting )
			foreach ( action in level.titanEmbarkActions )
			{
				printt( "Embark Direction: " + action.embark )
				if ( "animSet" in action )
				{
					local animation = GetAnimFromAlias( setting, action.animSet.thirdPersonKneelingAlias )
					local time = prop.GetSequenceDuration( animation )
					times[ model ].append( { time = time, animation = animation } )
			        printt( "Kneeling: " + time )

			        local animation = GetAnimFromAlias( setting, action.animSet.thirdPersonStandingAlias )
					local time = prop.GetSequenceDuration( animation )
					times[ model ].append( { time = time, animation = animation } )
			        printt( "Standing: " + time )
				}

				if ( "animSets" in action )
				{
					local animation = GetAnimFromAlias( setting, action.animSets.left.thirdPersonKneelingAlias )
					local time = prop.GetSequenceDuration( animation )
					times[ model ].append( { time = time, animation = animation } )
			        printt( "Kneeling Left: " + time )

					local animation = GetAnimFromAlias( setting, action.animSets.left.thirdPersonStandingAlias )
			        local time = prop.GetSequenceDuration( animation )
					times[ model ].append( { time = time, animation = animation } )
			        printt( "Standing Left: " + time )

					local animation = GetAnimFromAlias( setting, action.animSets.right.thirdPersonKneelingAlias )
					local time = prop.GetSequenceDuration( animation )
					times[ model ].append( { time = time, animation = animation } )
			        printt( "Kneeling Right: " + time )

					local animation = GetAnimFromAlias( setting, action.animSets.right.thirdPersonStandingAlias )
			        local time = prop.GetSequenceDuration( animation )
					times[ model ].append( { time = time, animation = animation } )
			        printt( "Standing Right: " + time )
				}

				printt( " " )
			}
		}

		prop.Kill()
	}

	printt( "Time comparison: " )
	local wrong = false
	for ( local i = 0; i < times[ models[0] ].len(); i++ )
	{
		if ( times[models[0]][i].time == times[models[1]][i].time )
		{
			printt( "MATCH: " + ( i + 1 ) + " times: " + times[models[0]][i].time + " " + times[models[1]][i].time + " " + times[models[1]][i].animation )
		}
		else
		{
			printt( "MISMATCH: " + ( i + 1 ) + " times: " + times[models[0]][i].time + " " + times[models[1]][i].time + " " + times[models[1]][i].animation )
			wrong = true
		}
	}
//	Assert( !wrong, "Times did not match between male and female, see above" )
}

if ( reloadingScripts )
{
	RefreshTitanEmbarkActions()
}

function ClientCommand_TitanKneel( player )
{
	local titan = player.GetPetTitan()
	if ( !IsAlive( titan ) )
		return true

	titan.Signal( "titanKneel" )
	titan.s.standQueued = false
	titan.s.kneelQueued = true
	return true
}

function ClientCommand_TitanStand( player )
{
	local titan = player.GetPetTitan()
	if ( !IsAlive( titan ) )
		return true

	titan.Signal( "titanStand" )
	titan.s.standQueued = true
	titan.s.kneelQueued = false
	return true
}

function ClientCommand_TitanNextMode( player )
{
	if ( !IsAlive( player ) )
		return true

	local titan = player.GetPetTitan()
	if ( IsAlive( titan ) )
		NPCTitanNextMode( titan, player )

	return true
}


function EmbarkLine( player, titan )
{
	player.EndSignal( "startembark" )
	local ref = player.LookupAttachment( "ref" )
	local hijack = titan.LookupAttachment( "hijack" )
	local origin
	for ( ;; )
	{
		origin = titan.GetAttachmentOrigin( hijack )
		DebugDrawLine( player.GetOrigin(), origin, 255, 0, 0, true, 0.15 )

		origin = player.GetAttachmentOrigin( ref )
		DebugDrawLine( player.GetOrigin(), origin, 0, 255, 0, true, 0.15 )
		wait 0
	}
}


function PlayerEmbarksTitan( player, titan, embark )
{
	if ( IsClient() ) //Looks like we're never in client anymore?
	{
		return
	}

	//player.SetOrigin( Vector(314.971405, -1826.728638, 116.031250))
	//player.SetAngles( Vector(0.000000, 133.945892, 0.000000))
	//titan.SetOrigin( Vector(284.887970, -1622.180542, 112.093750))
	//titan.SetAngles(Vector(0.000000, 112.264252, 0))

	local soul = titan.GetTitanSoul()
	local settings = GetSoulTitanType( soul )
	printt( "TitanEmbarkDebug: Player ", player.GetOrigin(), player.GetAngles(), " Titan ", titan.GetOrigin(), titan.GetAngles(), settings, GetMapName() )


	Assert( IsAlive( titan ) )
	Assert( IsAlive( player ) )

	player.SetInvulnerable()

	player.EndSignal( "OnDeath" )
	player.EndSignal( "Disconnected" )
	player.EndSignal( "TitanEjectionStarted" )
	titan.EndSignal( "OnDeath" )

	titan.Signal( "player_embarks_titan" )
	player.Signal( "player_embarks_titan" )

	// it's lazy to put this in shared code but whatever
	Stats_IncrementStat( player, "misc_stats", "titanEmbarks", 1 )

	if ( level.repeatEmbark )
	{
		player.Signal( "startembark" )
		thread EmbarkLine( player, titan )
	}
//	Assert( !InSolid( titan ), titan + " is in solid" )

	DisableCloak( player )
	ForceDeactivateSonar( player, "ForceRegularSonarDeactivate" )

	local startOrigin = titan.GetOrigin()
	local startAngles = titan.GetAngles()

	OnThreadEnd(
		function() : ( player, titan, startOrigin, startAngles )
		{
			if ( IsValid( player ) )
			{
				titan.Signal( "TitanEmbarkComplete" )

				player.SetCinematicEventFlags( player.GetCinematicEventFlags() & (~CE_FLAG_EMBARK) )
				delete player.s.embarkingTitan

				if ( level.repeatEmbark )
				{
					player.DeployWeapon()
					delete titan.s.embarkingPlayer
					return
				}

				TitanEmbark_PlayerCleanup( player )

				if ( IsAlive( player ) )
				{
					TitanEmbarkFailsafe( player, titan, startOrigin )
				}
			}

			if ( IsAlive( titan ) )
			{
				// player became the titan and took the soul, so kill the titan
				if ( IsAlive( player ) )
				{
					Assert( player.IsTitan() || player.IsDisconnected(), player + " should be a titan by now" )

					if ( !player.IsDisconnected() )
						LetTitanPlayerShootThroughBubbleShield( player )
				}

				if ( IsValid( titan.s.guardModePoint ) )
					titan.s.guardModePoint.Kill()

				if ( !IsValid( player ) || player.IsDisconnected() )
					titan.Die()
				else
					titan.Kill()
			}
		}
	)

	HideTitanEyePartial( titan )
	// track the embarking player so we can kill him if the titan dies
	titan.s.embarkingPlayer <- player
	player.s.embarkingTitan <- titan


	player.SetCinematicEventFlags( player.GetCinematicEventFlags() | CE_FLAG_EMBARK )

	waitthread PlayerEmbarksTitan_PlayerBecomesTitan( player, titan, embark )
	Remote.CallFunction_Replay( player, "ServerCallback_TitanEmbark" )
	if ( level.repeatEmbark )
		return

	TitanEmbark_PlayerCleanup( player )
}

function PlayerEmbarksTitan_PlayerBecomesTitan( player, titan, embark )
{
	// a place to store the player finish time
	local e = {}

	e.threads <- 0
	e.embarkAction <- embark.action
	e.animSet <- embark.animSet
	e.audioSet <- embark.audioSet

	e.canStand <- TitanCanStand( titan )

	// player and titan do their anims and wait for each other to finish
	thread TitanEmbark_TitanEmbarks( player, titan, e )
	waitthread TitanEmbark_PlayerEmbarks( player, titan, e )
}

function TitanEmbark_PlayerCleanup( player )
{
	player.SetSyncedEntity( null )
	player.DeployWeapon()
	player.UnforceStand()
	player.UnforceCrouch()
	//printt("Clearing invulnerable")
	player.ClearInvulnerable()
	player.ClearParent()
	//Let player jump in air after getting out if he wants to
	player.TouchGround()
	player.Anim_Stop()
}


// if killing the player as a failsafe isn't right for a certain level, use the level defined function instead (ex: training)
function SetTitanEmbarkFailsafeOverrideFunc( func )
{
	local callbackInfo = {}
	callbackInfo.func 	<- func
	callbackInfo.scope 	<- this

	level.TitanEmbarkFailsafeFunc = callbackInfo
}
Globalize( SetTitanEmbarkFailsafeOverrideFunc )


function TryTitanEmbarkFailsafeOverrideFunc( player )
{
	local callbackInfo = level.TitanEmbarkFailsafeFunc

	if ( callbackInfo )
	{
		callbackInfo = level.TitanEmbarkFailsafeFunc
		callbackInfo.func.acall( [ callbackInfo.scope, player ] )

		return true
	}

	return false
}

function TitanEmbarkFailsafe( player, titan, startOrigin )
{
	if ( !IsAlive( titan ) )
	{
		//printt( "Titan not alive, putting player back to Titan origin" )
		player.SetOrigin( startOrigin )
		if ( EntityInSolidIgnoreFriendlyNPC( player, titan ) )
		{

			if ( TryTitanEmbarkFailsafeOverrideFunc( player ) )
				return

			local soul = titan.GetTitanSoul()
			if ( IsValid( soul ) && "recentDamageHistory" in soul.s && soul.s.recentDamageHistory.len() > 0 )
			{
				local titanDamageHistory
				foreach ( damageRecord in soul.s.recentDamageHistory )
				{
					if ( damageRecord.victimIsTitan = true )
					{
						titanDamageHistory = damageRecord
						break
					}
				}
				if ( IsValid( titanDamageHistory.attackerWeakRef ) )
					player.Die( titanDamageHistory.attackerWeakRef, titanDamageHistory.attackerWeakRef, { scriptType = DF_DISSOLVE, damageSourceId = titanDamageHistory.damageSourceId } )
				else
					player.Die( level.worldspawn, level.worldspawn, { scriptType = DF_DISSOLVE, damageSourceId = eDamageSourceId.crushed } )
			}
			else
			{
				//printt( "Failsafe failed, killing player or using override func" )
				player.Die( level.worldspawn, level.worldspawn, { scriptType = DF_DISSOLVE, damageSourceId = eDamageSourceId.crushed } )
			}
		}
		return
	}

	if ( EntityInSolidIgnoreFriendlyNPC( player, titan ) )
	{
		local node = GetNearestNodeToPos( player.GetOrigin() )
		if ( node != -1 )
		{
			local nodePos = GetNodePos( node, HULL_TITAN )
			player.SetOrigin( nodePos )
			if ( !EntityInSolidIgnoreFriendlyNPC( player, titan ) )
			{
				//printt( "Closest node resulted in not in solid, returning" )
				return
			}

			local nodes = GetNeighborNodes( node, 20, HULL_TITAN ) // analysis.hull )  //Use 20 closest nodes as failsafes. Note that GetNeighborNodes() returns the original node passed in as well.
			foreach ( neighbor in nodes )
			{
				//printt( "Trying a neighbor node" )
				local nodePos = GetNodePos( neighbor, HULL_TITAN )
				player.SetOrigin( nodePos )
				if ( !EntityInSolidIgnoreFriendlyNPC( player, titan ) )
				{
					//printt( "Neighbor node worked, not in solid, returning" )
					return
				}
			}
			// TEMP; HACK HACK HACK
			UnStuck( player, startOrigin )
		}

		if ( EntityInSolid( player, titan ) )
		{
			if ( player.IsTitan() )
			{
				if ( TryTitanEmbarkFailsafeOverrideFunc( player ) )
					return

				local soul = player.GetTitanSoul()
				soul.SetShieldHealth( 0 )

				player.TakeDamage( titan.GetHealth(), null, null, { damageSourceId=eDamageSourceId.suicide } )
				return
			}
		}
	}
}

function TitanEmbark_PlayerEmbarks( player, titan, e )
{
	player.EndSignal( "OnDeath" )
	player.EndSignal( "Disconnected" )
	player.EndSignal( "TitanEjectionStarted" )
	titan.EndSignal( "OnDeath" )

	e.threads++
	OnThreadEnd(
		function() : ( player, e )
		{
			if ( IsValid( player ) )
			{
				// ensure these are cleared regardless
				player.ClearAnimViewEntity()

				if ( player.ContextAction_IsBusy() )
					player.ContextAction_ClearBusy()
			}

			e.threads--
			if ( !e.threads )
			{
				Signal( e, "OnComplete" )
			}
		}
	)

    player.ContextAction_SetBusy()

	local standing = false

	if ( e.canStand )
	{
		player.ForceStand()
		switch ( titan.GetTitanSoul().GetStance() )
		{
			case STANCE_KNEELING:
			case STANCE_KNEEL:
				break

			default:
				standing = true
				break
		}
	}
	else
	{
		player.ForceCrouch()
	}

	player.HolsterWeapon()

	local sequence = CreateFirstPersonSequence()
	sequence.attachment = "hijack"
	sequence.useAnimatedRefAttachment = e.embarkAction.useAnimatedRefAttachment

	local soul = titan.GetTitanSoul()
	local settings = GetSoulTitanType( soul )

	local hasViewCone

	local thirdPersonAudio
	local firstPersonAudio

	if(settings == "titan_destroyer")
	{
		settings = "titan_ogre"
	}

	if ( standing )
	{
		sequence.firstPersonAnim = GetAnimFromAlias( settings, e.animSet.firstPersonStandingAlias )
		sequence.thirdPersonAnim = GetAnimFromAlias( settings, e.animSet.thirdPersonStandingAlias )
		hasViewCone = false
		thirdPersonAudio = GetAudioFromAlias( settings, e.audioSet.thirdPersonStandingAudioAlias )
		firstPersonAudio = GetAudioFromAlias( settings, e.audioSet.firstPersonStandingAudioAlias )

	}
	else
	{
		sequence.firstPersonAnim = GetAnimFromAlias( settings, e.animSet.firstPersonKneelingAlias )
		sequence.thirdPersonAnim = GetAnimFromAlias( settings, e.animSet.thirdPersonKneelingAlias )
		hasViewCone = true
		thirdPersonAudio = GetAudioFromAlias( settings, e.audioSet.thirdPersonKneelingAudioAlias )
		firstPersonAudio = GetAudioFromAlias( settings, e.audioSet.firstPersonKneelingAudioAlias )
	}

	sequence.thirdPersonAnimIdle = "pt_mount_idle"

	if ( hasViewCone )
	{
		sequence.viewConeFunction = EmbarkViewCone
		thread DelayedClearViewCone( player )
	}

	//thread DelayedDisableEmbarkPlayerHud( player, sequence )

	thread FirstPersonSequence( sequence, player, titan )
	EmitDifferentSoundsOnEntityForPlayerAndWorld( firstPersonAudio, thirdPersonAudio, titan, player )

	if ( ShouldSkipAheadIntoEmbark( standing, player, titan, e ) )
	{
		local duration = player.GetSequenceDuration( sequence.thirdPersonAnim )
		player.Anim_SetInitialTime( duration - SKIP_AHEAD_TIME )
		local viewModel = player.GetFirstPersonProxy()

		if ( IsValid( viewModel ) && EntHasModelSet(viewModel) )//JFS: Defensive fix for player not having view models sometimes
			viewModel.Anim_SetInitialTime( duration - SKIP_AHEAD_TIME )
	}

	player.WaittillAnimDone()
	if ( Flag( "Embark3rdPersonFix" ) )
		wait 0.1

	player.ClearAnimViewEntity()
	PilotBecomesTitan( player, titan )

	thread PlayAnim( player, "cqb_idle_mp" )
	player.Anim_Stop()

	player.SetOrigin( titan.GetOrigin() )
	local angles = titan.GetAngles()
	angles.z = 0
	angles.x = 0
	player.SetAngles( angles )
	player.SnapEyeAngles( angles )

	// soul stuff should be from anim event
	Assert( IsServer() )
	SetStanceStand( player.GetTitanSoul() )
}

function ShouldSkipAheadIntoEmbark( standing, player, titan, e )
{
	if ( !standing )
		return false

	if ( !e.embarkAction.canSkipAhead )
		return false

	local playerEye = player.EyePosition()
	local titanOrg = titan.GetOrigin()
	local vec = playerEye - titanOrg
	vec.Norm()
	vec.z = 0
	local start = playerEye
	local end = playerEye + vec * 24

	if ( Distance( player.GetOrigin(), titan.GetOrigin() ) >= 145 )
		return false

	local mask = TRACE_MASK_PLAYERSOLID
	local result = TraceLine( start, end, [ titan, player ], mask, TRACE_COLLISION_GROUP_NONE )
	//DebugDrawLine( start, result.endPos, 0, 255, 0, true, 10.0 )
	//DebugDrawLine( result.endPos, end, 255, 0, 0, true, 10.0 )
	return result.fraction < 1.0
}

function DelayedDisableEmbarkPlayerHud( player, sequence )
{
	player.EndSignal( "OnDeath" )
	player.EndSignal( "Disconnected" )

	local duration = player.GetSequenceDuration( sequence.thirdPersonAnim )
	wait duration - 1.0
	player.SetCinematicEventFlags( player.GetCinematicEventFlags() | CE_FLAG_EMBARK )
}

function DelayedClearViewCone( player )
{
	player.EndSignal( "Disconnected" )
	player.EndSignal( "OnDeath" )
	wait 1.0
	player.PlayerCone_SetLerpTime( 0.5 )
	player.PlayerCone_FromAnim()
	player.PlayerCone_SetMinYaw( 0 )
	player.PlayerCone_SetMaxYaw( 0 )
	player.PlayerCone_SetMinPitch( 0 )
	player.PlayerCone_SetMaxPitch( 0 )
}

function EmbarkViewCone( player )
{
	player.PlayerCone_FromAnim()
	player.PlayerCone_SetMinYaw( -70 )
	player.PlayerCone_SetMaxYaw( 60 )
	player.PlayerCone_SetMinPitch( -80 )
	player.PlayerCone_SetMaxPitch( 30 )
}

function TitanEmbark_TitanEmbarks( player, titan, e )
{
	player.EndSignal( "OnDeath" )
	player.EndSignal( "Disconnected" )
	player.EndSignal( "TitanEjectionStarted" )
	titan.EndSignal( "OnDeath" )

	titan.ContextAction_SetBusy()

	e.threads++
	OnThreadEnd(
		function() : ( e, player, titan )
		{
			e.threads--
			if ( !e.threads )
			{
				Signal( e, "OnComplete" )
			}

			if ( !IsAlive( player ) && IsAlive( titan ) )
			{
				titan.Anim_Stop()
				titan.ContextAction_ClearBusy()
			}
		}
	)

	local soul = titan.GetTitanSoul()

	// dont let other players get in

	local animation
//	local waittillAnimDone
	local alignFront
	local standing = false

	if ( e.canStand )
	{
		switch ( titan.GetTitanSoul().GetStance() )
		{
			case STANCE_KNEELING:
			case STANCE_KNEEL:
				animation = e.animSet.titanKneelingAnim
				alignFront = false
				break

			default:
				animation = e.animSet.titanStandingAnim
				alignFront = true
				standing = true
				break
		}
	}
	else
	{
		animation = "at_mount_kneel_without_standing"
		alignFront = false
//		waittillAnimDone = false
	}


	//sequence.blendTime = 0.5

    //printt("This is mount animation name: " + animation )
	if ( e.embarkAction.alignFrontEnabled && alignFront )
	{
		local titanOrg = titan.GetOrigin()
		local vec = player.GetOrigin() - titanOrg
		local angles = VectorToAngles( vec )
		angles.x = 0
		angles.z = 0
		thread PlayAnimGravityClientSyncing( titan, animation, titanOrg, angles )
	}
	else
	{
		thread PlayAnimGravityClientSyncing( titan, animation )
	}

	if ( ShouldSkipAheadIntoEmbark( standing, player, titan, e ) )
	{
		local duration = titan.GetSequenceDuration( animation )
		titan.Anim_SetInitialTime( duration - SKIP_AHEAD_TIME )
	}


	// titan will become player now
	WaitForever()
}

function ClientCommand_TitanDisembark( player )
{
	if ( !PlayerCanDisembarkTitan( player ) )
		return true

	player.CockpitStartDisembark()
	Remote.CallFunction_Replay( player, "ServerCallback_TitanDisembark" )

	thread PlayerDisembarksTitan( player )

	return true
}

function ForcedTitanDisembark( player )
{
	Assert( PlayerCanDisembarkTitan( player ) )

	player.CockpitStartDisembark()
	Remote.CallFunction_Replay( player, "ServerCallback_TitanDisembark" )

	waitthread PlayerDisembarksTitan( player )
}

function PlayerCanDisembarkTitan( player )
{
	if ( !player.IsTitan() )
		return false

	if ( !IsAlive( player ) )
		return false

	if ( Riff_TitanExitIsDisabled() )
	{
		if ( IsClient() )
		{
			EmitSoundOnEntity( player, "titan_dryfire" )
			SetTimedEventNotification( 1.5, "#NOTIFY_DISEMBARK_DISABLED" )
		}
		return false
	}

	if ( IsServer() )
	{
		// client doesn't know these things
		if ( "isDisembarking" in player.s )
			return
		if ( "embarkingTitan" in player.s )
			return
		if ( player.GetParent() )
			return
	}

	if ( !HasSoul( player ) )
		return

	local soul = player.GetTitanSoul()
	if ( soul.IsEjecting() )
		return

	/*
	local angles = player.GetAngles()
	angles.x = 0
	angles.z = 0
	local origin = player.GetOrigin()
	local forward = angles.AnglesToForward()
	local right = angles.AnglesToRight()

	local startData = level.pilotDisembarkBounds.start
	local endData = level.pilotDisembarkBounds.end

	local start = origin + forward * startData.forward + right * startData.right + Vector(0,0,startData.up)
	local end = origin + forward * endData.forward + right * endData.right + Vector(0,0,endData.up)

//	TraceHull( xyz startPos, xyz endPos, xyz hullMins, xyz hullMaxs, ent ignoreEntity [or array of ignoreEnts], TRACE_MASK_* mask, TRACE_COLLISION_GROUP_* group )
	local result = TraceHull( start, end, level.traceMins[ "pilot" ], level.traceMaxs[ "pilot" ], null, player.GetPhysicsSolidMask(), TRACE_COLLISION_GROUP_NONE )
	if ( result.fraction < 1 )
	{
//		if ( IsServer() )
//			DebugDrawLine( start, end, 255, 0, 0, true, 4 )
//		else
//			DebugDrawLine( start, end, 155, 0, 0, true, 4 )
		return false
	}
	else
	{
//		if ( IsServer() )
//			DebugDrawLine( start, end, 0, 255, 0, true, 4 )
//		else
//			DebugDrawLine( start, end, 0, 155, 0, true, 4 )
	}
	*/

	local soul = player.GetTitanSoul()

	return !soul.IsEjecting()
}

function PlayerDisembarksTitan( player )
{
	local titanType = player.GetPlayerSettingsField( "footstep_type" )
	//printt( "Player disembarking with origin " + player.GetOrigin() + " and yaw " + player.GetAngles().y )

  	//player.SetOrigin( Vector(420.847626, -5214.960938, 173.789520) )
  	//player.SetAngles( Vector(0.000000, 179.572052, 0.000000 ) )

	printt( "TitanDisembarkDebug: Player ", player.GetOrigin(), player.GetAngles(), titanType, GetMapName() )

	player.EndSignal( "Disconnected" )
	player.EndSignal( "OnDeath" )
	player.Signal( "DisembarkingTitan" )

	//Assert( !InSolid( player ), player + " is in solid" )


	local e = {}
	e.titan <- null
	e.PilotCleanUpDone <- false

	e.startOrigin <- player.GetOrigin()
	//e.startAngles <- player.GetAngles()

	player.s.isDisembarking <- true
	player.SetCinematicEventFlags( player.GetCinematicEventFlags() | CE_FLAG_DISEMBARK )

	player.ContextAction_SetBusy()

	if ( "isEMPd" in player.s )
		player.UnfreezeControlsOnServer()

	OnThreadEnd(
		function() : ( player, e )
		{
			if ( IsValid( player ) )
			{
				PlayerEndsDisembark( player, e )

				local titan = e.titan
				if ( !IsValid( titan ) )
					titan = null

				//// give a player a boost out the door
			    //
                //
				if ( IsAlive( player ) )
				{
					local angles = player.EyeAngles()
					if ( IsValid( e.titan ) )
						angles = e.titan.GetAngles()

					angles.x = 0
					angles.z = 0
					local forward = angles.AnglesToForward()
					local up = angles.AnglesToUp()
					local vel = forward * 250 + up * 200
					player.SetVelocity( vel )
					//DebugDrawLine( player.GetOrigin(), player.GetOrigin() + forward * 500, 255, 0, 0, true, 5.0 )
				}
			}

			if ( IsAlive( e.titan ) )
			{
				if ( IsAlive( player ) )
				{
					thread PlayerOwnsTitanUntilSeparation( player, e.titan, 80 )
				}

				delete e.titan.s.disembarkingPlayer
				ClearInvincible( e.titan )


				//Make Titan get up immediately if he's kneeling and can stand
				//If he can't get up, well, then since the titan doesn't move when crouched he's going to be stuck...
				if ( !( "embarkingPlayer" in e.titan.s ) )
				{
					thread TitanNPC_Think( e.titan ) //titan.s.disableAutoTitanConversation is deleted inside here
				}
			}
		}
	)

	local standing = player.IsStanding()

	local titanDisembarkAnim
	if ( standing )
		titanDisembarkAnim = "at_dismount_stand"
	else
		titanDisembarkAnim = "at_dismount_crouch"

	local origin = player.GetOrigin()
	local angles = player.EyeAngles()
	angles.z = 0
	angles.x = 0

	player.SetInvulnerable()

	local titan = CreateTitanFromPlayer( player )
	e.titan = titan

	titan.s.disembarkingPlayer <- player
	titan.EndSignal( "OnDeath" )

	player.SetSyncedEntity( titan )
	titan.s.disableAutoTitanConversation <- true

	Assert( titan.IsTitan() )
	Assert( IsAlive( player ) )
	Assert( player.IsTitan() )
	//Set player to be temporarily invulnerable. Will be removed at end of animation
	//printt("Set player invulnerable")
	player.HolsterWeapon() //Holstering weapon before becoming pilot so we don't play the holster animation as a pilot. Player as Titan won't play the holster animation either since it'll be interrupted by the disembark animation
	TitanBecomesPilot( player, titan )

	local titanType = GetSoulTitanType( titan.GetTitanSoul() )
	if ( titanType == "ogre" || titanType == "special_ogre )
	{
		ShowMainTitanWeapons( titan ) //JFS: Because we hide the Titan's weapons upon kneeling for ogre
	}

	titan.s.disembarkTime <- Time() // disembark debounce

	// compound strings into these animations:
	// pt_dismount_atlas_stand
	// pt_dismount_ogre_stand
	// pt_dismount_stryder_stand
	// pt_dismount_atlas_crouch
	// pt_dismount_ogre_crouch
	// pt_dismount_stryder_crouch
	// ptpov_dismount_atlas_stand
	// ptpov_dismount_ogre_stand
	// ptpov_dismount_stryder_stand
	// ptpov_dismount_atlas_crouch
	// ptpov_dismount_ogre_crouch
	// ptpov_dismount_stryder_crouch

	local settings = player.GetPlayerSettings()

	local player3pAnim, player1pAnim
	local player3pAudio, player1pAudio
		
	if ( titanType == "special_ogre" )
	{
		titanType = "ogre"
	}
	if ( titanType == "special_atlas" )
	{
		titanType = "atlas"
	}
	if ( titanType == "special_stryder" )
	{
		titanType = "stryder"
	}
	
	if ( standing )
	{
		player3pAnim = "pt_dismount_" + titanType + "_stand"
		player1pAnim = "ptpov_dismount_" + titanType + "_stand"
		player3pAudio = titanType + "_Disembark_Standing_3P"
		player1pAudio = titanType + "_Disembark_Standing_1P"
	}
	else
	{
		player3pAnim = "pt_dismount_" + titanType + "_crouch"
		player1pAnim = "ptpov_dismount_" + titanType + "_crouch"
		player3pAudio = titanType + "_Disembark_Kneeling_3P"
		player1pAudio = titanType + "_Disembark_Kneeling_1P"
	}

	player.ForceStand()

	local sequence = CreateFirstPersonSequence()
	sequence.blendTime = 0
	sequence.teleport = true
	sequence.attachment = "hijack"
	sequence.thirdPersonAnim = player3pAnim
	sequence.firstPersonAnim = player1pAnim
	sequence.useAnimatedRefAttachment = true

	local titanSequence = CreateFirstPersonSequence()
	titanSequence.blendTime = 0
	titanSequence.thirdPersonAnim = titanDisembarkAnim
	if ( !standing )
		titanSequence.thirdPersonAnimIdle = "at_MP_embark_idle_blended"
	titanSequence.gravity = true
	titanSequence.origin = origin
	titanSequence.angles = angles


	thread FirstPersonSequence( titanSequence, titan )
	thread FirstPersonSequence( sequence, player, titan )

	EmitDifferentSoundsOnEntityForPlayerAndWorld( player1pAudio, player3pAudio, titan, player )

	thread ClearParentBeforeIntersect( player, titan, player3pAnim, e )

	if ( !standing )
	{
		SetStanceKneel( titan.GetTitanSoul() )
	}

	thread HideTitanEyePartialDelayed( titan )
	//player.Anim_EnablePlanting()

	player.WaittillAnimDone()
}


function HideTitanEyePartialDelayed( titan )
{
	titan.EndSignal( "OnDestroy" )

	wait 0 // hack: bodygroup change does not take on first frame of existence
	HideTitanEyePartial( titan )
}

function DelayedSafePlayerLocation( player, titan, startOrigin )
{
	wait 0
	wait 0
	wait 0
	if ( !IsAlive( player ) )
		return

	if ( IsPlayerInCinematic( player ) ) //JFS: Fix case where disembarking titan into evac dropship unparents player
		return

	player.ClearParent()
	player.PlayerCone_Disable()
	player.ClearViewOffsetEntity()
	player.GetFirstPersonProxy().Hide()

	if ( !IsValid( titan ) )
		titan = null
	PlayerInSolidFailsafe( player, startOrigin, titan )
}

function ClearParentBeforeIntersect( player, titan, anim, e )
{
	player.EndSignal( "OnDeath" )
	player.EndSignal( "Disconnected" )
	player.EndSignal( "OnAnimationDone" )
	player.EndSignal( "OnAnimationInterrupted" )
	local mins = player.GetBoundingMins()
	local maxs = player.GetBoundingMaxs()

	OnThreadEnd(
		function() : ( player, e )
		{
			thread DelayedSafePlayerLocation( player, e.titan, e.startOrigin )
		}
	)

	wait 0.25

	local time = Time()
	local lastOrigin = player.GetOrigin()
	for ( ;; )
	{
		if ( EntityInSolid( player, titan, 24 ) )
			break

		lastOrigin = player.GetOrigin()
		wait 0
	}

	player.SetOrigin( lastOrigin )
}

function LockedViewCone( human )
{
	human.PlayerCone_FromAnim()
	human.PlayerCone_SetMinYaw( 0 )
	human.PlayerCone_SetMaxYaw( 0 )
	human.PlayerCone_SetMinPitch( 0 )
	human.PlayerCone_SetMaxPitch( 0 )
}


function PlayerOwnsTitanUntilSeparation( player, titan, dist )
{
	titan.SetOwner( player )

	player.EndSignal( "OnDeath" )
	titan.EndSignal( "OnDeath" )
	player.EndSignal( "Disconnected" )

	OnThreadEnd(
		function () : ( player, titan )
		{
			if ( !IsValid( titan ) )
				return

			titan.SetOwner( null )
		}
	)

	// wait until player moves away
	local distSqr = dist * dist
	for ( ;; )
	{
		if ( DistanceSqr( titan.GetOrigin(), player.GetOrigin() ) > distSqr )
			break

		wait 0.5
	}
}

function OnAnimDone_TitanClosestHatch( titan, player )
{
	titan.EndSignal( "OnDeath" )
	titan.WaittillAnimDone()
	if ( IsAlive( player ) && player.GetParent() == titan )
		return

	PlayAnim( titan, "at_MP_disembark_back2idle" )
}

function PlayerEndsDisembark( player, e )
{
	thread PlayerEndsDisembarkThread( player, e )
}

function PlayerEndsDisembarkThread( player, e )
{
	player.EndSignal( "Disconnected" )
    player.EndSignal( "OnDestroy" )

	if ( e.PilotCleanUpDone )
		return

	e.PilotCleanUpDone = true

	wait 0.1

	player.ClearAnimViewEntity()
	if ( player.ContextAction_IsBusy() )
		player.ContextAction_ClearBusy()

	player.SetCinematicEventFlags( player.GetCinematicEventFlags() & (~CE_FLAG_DISEMBARK) )

	player.Show()
	TitanEmbark_PlayerCleanup( player )
	delete player.s.isDisembarking
}

function IsPlayerEmbarking( player )
{
	return ( "embarkingTitan" in player.s )
}

function IsPlayerDisembarking( player )
{
	return ( "isDisembarking" in player.s )
}

function PlayerCanEmbarkIntoTitan( player, titan )
{
	if ( !TitanIsCurrentlyEmbarkableForPlayer( player, titan ) )
		return false

	return FindBestEmbark( player, titan ) != null
}

function TitanIsCurrentlyEmbarkableForPlayer( player, titan )
{
	if ( !titan.IsEntAlive() )
		return false

	if ( player.Anim_IsActive() )
		return false

	if ( IsValid( titan.GetParent() ) )
		return false

	if ( !player.IsHuman() )
		return false

	if ( !HasSoul( titan ) )
		return false

	local soul = titan.GetTitanSoul()

	if ( titan.GetDoomedState() )
		return false

	if ( soul.IsEjecting() )
		return false

	if ( "embarkingTitan" in player.s )
		return false

	if ( "isDisembarking" in player.s )
		return false

	if ( "disembarkTime" in titan.s )
	{
		if ( Time() - titan.s.disembarkTime < 1.65 )
			return false
	}

	return true
}

function FindBestEmbark( player, titan )
{
//	if ( IsServer() )
//		printt( "finding best embark for " + player + " to " + titan )
	local playerPos = player.GetOrigin()
	local titanPos = titan.GetOrigin()

	local absTitanToPlayerDir
	if ( playerPos == titanPos )
	{
		absTitanToPlayerDir = Vector( 1, 0, 0 )
	}
	else
	{
		local angles = player.EyeAngles()
		local forward = angles.AnglesToForward()

		absTitanToPlayerDir = ( playerPos - titanPos )


		absTitanToPlayerDir.Norm()

//		not needed cause we can't get in without a legal use
//		// is the target in my fov?
//		if ( forward.Dot( absTitanToPlayerDir * -1 ) < 0.77 )
//			return null
	}


	local titanAngles = titan.GetAngles()
	titanAngles.x = 0
	if ( titan.GetTitanSoul().GetStance() >= STANCE_STANDING )
		titanAngles = titanAngles.AnglesCompose( Vector(0,-30,0) )

	local relTitanToPlayerDir = CalcRelativeVector( titanAngles, absTitanToPlayerDir )

	local bestAction = null
	local bestDot = -2
	local dist = Distance( playerPos, titanPos )
	if ( dist > level.titanEmbarkFarthestDistance )
		return null

	//if ( IsServer() )
	//	printt( "dist: " + dist )

	for ( local i = 0; i < 3; i++ )
	{
		bestAction = GetBestEmbarkAction( i, player, titan, dist, relTitanToPlayerDir )
		if ( bestAction != null )
			break
	}

	if ( bestAction == null )
		return null

	local table = {}
	table.action <- bestAction

	if ( "animSet" in bestAction )
	{
		table.animSet <- bestAction.animSet
		table.audioSet <- bestAction.audioSet
	}
	else
	{
		local bestAnimSet
		local bestAudioSet
		bestDot = -2
		Assert( "animSets" in bestAction, "Table has no animSet and no animSets!" )
		foreach ( animSet in bestAction.animSets )
		{
			local dot = relTitanToPlayerDir.Dot( animSet.direction )

			if ( dot > bestDot )
			{
				bestAnimSet = animSet
				bestAudioSet = animSet.audioSet
				bestDot = dot
			}
		}

		table.animSet <- bestAnimSet
		table.audioSet <- bestAudioSet
	}

	return table
}

function GetBestEmbarkAction( priority, player, titan, dist, relTitanToPlayerDir )
{
	local bestAction = null
	local bestDot = -2

	foreach ( action in level.titanEmbarkActions )
	{
		if ( action.priority != priority )
			continue

		if ( dist > action.distance )
		{
			//if ( IsServer() )
				//printt( "Failed: Action " + action.embark + " had dist " + action.distance + " vs actual dist " + dist )
			continue
		}

		if ( action.lungeCheck )
		{
			if ( player.PlayerLunge_IsLunging() != action.lungeCheck )
				continue
		}

		local dot = relTitanToPlayerDir.Dot( action.direction )

		if ( dot < action.minDot )
		{
			//if ( IsServer() )
				//printt( "Failed: Action " + action.embark + " had dot " + dot )
			continue
		}

		if ( action.titanCanStandRequired && !TitanCanStand( titan ) )
		{
			//if ( IsServer() )
				//printt( "Failed: Action " + action.embark + " cant stand" )
			continue
		}

		if ( dot > bestDot )
		{
			//if ( IsServer() )
				//printt( "Action " + action.embark + " had dot " + dot )
			bestAction = action
			bestDot = dot
		}
	}

	return bestAction
}






if ( IsServer() )
{
	function TitanCanStand( titan )
	{
//		printt( "        TEST CANSTAND       ")
		local maxs = titan.GetBoundingMaxs()
		local mins = titan.GetBoundingMins()

		local start = titan.GetOrigin()
		local end = titan.GetOrigin()
		local soul = titan.GetTitanSoul()
		local ignoreEnt = null

		if ( IsValid( soul.bubbleShield ) )
			ignoreEnt = soul.bubbleShield
		local mask = titan.GetPhysicsSolidMask()
		//printt( "mask has " + MaskTester( mask ) )
		local result = TraceHull( start, end, mins, maxs, ignoreEnt, mask, TRACE_COLLISION_GROUP_NONE )
		//printt( "start " + start + " end " + end )

		//DebugDrawLine( start, result.endPos, 0, 255, 0, true, 5.0 )
		//DebugDrawLine( result.endPos, end, 255, 0, 0, true, 5.0 )

		local canStand = result.fraction >= 1.0
		titan.SetCanStand( canStand )
		return canStand
	}
}
else
{
	function TitanCanStand( titan )
	{
		return titan.GetCanStand()
	}
}

function PlayerCanEmbarkTitan( player, titan )
{
	PerfStart( PerfIndexClient.PlayerCanEmbarkTitan1 )
	if ( !TitanIsCurrentlyEmbarkableForPlayer( player, titan ) )
	{
		PerfEnd( PerfIndexClient.PlayerCanEmbarkTitan1 )
		return false
	}
	PerfEnd( PerfIndexClient.PlayerCanEmbarkTitan1 )

	PerfStart( PerfIndexClient.FindBestEmbark )
	local res = FindBestEmbark( player, titan ) != null
	PerfEnd( PerfIndexClient.FindBestEmbark )

	return res
}

function PlayerCanImmediatelyEmbarkTitan( player, titan )
{
	if ( "embarkingPlayer" in titan.s )
		return null

	if ( !IsAlive( player ) || !IsAlive( titan ) )
		return null

	return FindBestEmbark( player, titan ) != null
}

function PlayerLungesToEmbark( player, ent )
{
	Assert( TitanIsCurrentlyEmbarkableForPlayer( player, ent ) )

	if ( PlayerCanImmediatelyEmbarkTitan( player, ent ) )
	{
		local embarkDirection = FindBestEmbark( player, ent )
		thread PlayerEmbarksTitan( player, ent, embarkDirection )
		return
	}

	// already lunging
	if ( player.PlayerLunge_IsLunging() )
		return

	if ( ShouldStopLunging( player, ent ) )
		return

	player.PlayerLunge_Start( ent, 3.0 )
}

function HideTitanEyeForEmbark( titan )
{
	Assert( IsClient(), "Client only" )
	if ( !IsValid( titan ) )
		return

	local player = GetLocalViewPlayer()
	if ( player.GetPetTitan() != titan )
		return

	HideTitanEye( titan )
}
