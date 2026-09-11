if ( IsServer() )
{
	RAGDOLL_IMPACT_TABLE_IDX <- PrecacheImpactEffectTable( "ragdoll_human" )
}

function main()
{
	local table =
	{
		attackerOriginFunc = GetEyeOrigin
		targetOriginFunc = GetEyeOrigin
		array = []
		meleeThreadShared = Bind( MeleeThread_TitanVsTitan )
	}
	level.allMeleeActions[ "titan" ][ "titan" ] <- table

	local action =
	{
		enabled = true
		direction = Vector( 1, 0, 0 ),
		distance = TITAN_EXECUTION_RANGE
	}
	AddMeleeAction( "titan", "titan", action )

}

function MeleeThread_TitanVsTitan( actions, action, attacker, target )
{
	// function off for reload scripts
	MeleeThread_TitanVsTitan_Internal( actions, action, attacker, target )
}

function MeleeThread_TitanVsTitan_Internal( actions, action, attacker, target )
{
	Assert( target.IsTitan(), target + " is not Titan target" )
	Assert( attacker.IsPlayer() && attacker.IsTitan(), attacker + " is not Titan attacker" )

	OnThreadEnd(
		function() : ( attacker, target )
		{
			if ( IsValid( attacker ) )
			{
				attacker.PlayerMelee_SetState( PLAYER_MELEE_STATE_NONE )
			}
		}
	)

	if ( IsServer() )
	{
		printt( "Player", attacker, "attempting to melee", target, "TitanVsTitanMelee" )
	}

	if ( attacker.ContextAction_IsActive() || target.ContextAction_IsActive() )
	{
		printt("Either attacker or target already in ContextAction! Exiting Titan Vs Titan melee attempt")
		return
	}

	if ( attacker.IsPlayer() == true && TitanCoreInUse( attacker ) )
	{
		printl("Player Core in use: preventing game error.")
		attacker.PlayerMelee_SetState( PLAYER_MELEE_STATE_NONE )
		attacker.DeployWeapon()
		return
	}

	local func

	if ( !IsAlive( attacker ) )
		return

	if ( !IsAlive( target ) )
		return


	// should rename TitanType
	local titanType = GetSoulTitanType(attacker.GetTitanSoul())

	if ( target.IsNPC() )
	{
		func = MeleeThread_AtlasVsTitanNPC
	}
	else
	{
		switch ( titanType )
		{
			case "atlas":
				func = MeleeThread_AtlasVsTitan
				break

			case "stryder":
				func = MeleeThread_StryderVsTitan
				break

			case "ogre":
				// func = MeleeThread_StryderVsTitan
				func = MeleeThread_OgreVsTitan
				break
			
			default:
				local execution_type = Random( [ "atlas", "ogre", "stryder" ] )

				switch( execution_type )
				{
					case "atlas":
						func = MeleeThread_AtlasVsTitan
						break
					
					case "ogre":
						func = MeleeThread_OgreVsTitan
						break
					
					case "stryder":
						func = MeleeThread_StryderVsTitan
						break
					
					default:
						func = MeleeThread_AtlasVsTitan
						break
				}
		}
	}

	if ( !func )
		return

	attacker.PlayerMelee_ExecutionStartAttacker( 0 )
	target.PlayerMelee_ExecutionStartTarget( attacker )

	waitthread func( actions, action, attacker, target )
}



function TitanMeleeRestoreTarget( target, e )
{
	target.ClearParent()
	target.Anim_Stop()
	target.ClearAnimViewEntity()

	if ( !target.IsNPC() )
	{
		target.EnableWeaponViewModel()
		UnStuck( target, e.startOrigin )
	}
}

function MeleeThread_AtlasVsTitanNPC( actions, action, attacker, target )
{
	if ( !IsAlive( attacker ) )
		return

	if ( !IsAlive( target ) )
		return


	Assert( target.IsNPC(), "NPC ONLY" )
	local attackerAnimation1p = "atpov_melee_sync_frontkill_autotitan"
	local attackerAnimation3p = "at_melee_sync_frontkill_autotitan"
	local targetAnimation3p = "at_melee_sync_frontdeath_autotitan"

	target.Signal( "TitanStopsThinking" ) // in future, need to make titan scripted anims co-exist better and not require gotcha stuff like this -Mackey

	local e = {}
	e.attackerViewBody <- null

	e.attackerStartOrg <- attacker.GetOrigin()

	local ref = CreateMeleeScriptMoverBetweenEnts( attacker, target )

	local attackerSequence = CreateFirstPersonSequence()
	attackerSequence.blendTime = 0.25
	attackerSequence.attachment = "ref"

	local targetSequence = clone attackerSequence

	attackerSequence.thirdPersonAnim = attackerAnimation3p
	// attackerSequence.thirdPersonAnimIdle = "at_melee_sync_frontkill_end_idle"

	attackerSequence.firstPersonAnim = attackerAnimation1p
	targetSequence.thirdPersonAnim = targetAnimation3p
	targetSequence.blendTime = 0.25

	target.s.meleeExecutionAttacker <- attacker

	// attacker.SetInvulnerable()
	target.SetInvulnerable()    //HACK: Have to SetInvulnerable first before attacker holsters weapon, because if the attacker is vortexing, holster will release bullets caught and kill off the victim if low enough health
	if ( ShouldHolsterWeaponForMelee( attacker ) )
		attacker.HolsterWeapon()

	local attackerViewBody

	// needs shortened verions
	EmitDifferentSoundsOnEntityForPlayerAndWorld( "Titan_1p_Sync_Melee_vs_AutoTitan", "Titan_3p_Sync_Melee_vs_AutoTitan", attacker, attacker )

	local soul = target.GetTitanSoul()
	soul.SetInvalidHealthBarEnt( true )

	if ( !( "isRodeoEnabled" in target.s ) )
		target.s.isRodeoEnabled <- null
	target.s.isRodeoEnabled = false
	AddAnimEvent( target, "rider_rodeo_over", ForceRodeoOver  )

	target.SetInvulnerable() //Setting target of execution as invulnerable to prevent them dying mid-way
	HideTitanEyePartial( target )

	OnThreadEnd(
		function() : ( ref, attacker, target, e  )
		{
			if ( IsValid( ref ) )
			{
				if ( IsValid( attacker ) )
					attacker.ClearParent()

				if ( IsValid( target ) )
					target.ClearParent()

				AssertNoPlayerChildren( ref )
				ref.Kill()
			}

			if ( IsValid( attacker ) )
			{
				attacker.ClearInvulnerable()
				attacker.UnforceStand()
				attacker.ClearParent()
				attacker.ClearAnimViewEntity()
				attacker.DeployWeapon()
				attacker.PlayerMelee_ExecutionEndAttacker()

				if ( IsAlive( attacker ) )
				{
					// if we got into solid, teleport back to safe place
					UnStuck( attacker, e.attackerStartOrg )
				}
			}

			if ( IsValid( target ) )
			{
				target.PlayerMelee_ExecutionEndTarget()

				if ( IsAlive( target ) )
				{
					local attack = attacker
					if ( !IsValid( attack ) )
						attack = null

					target.Die( attack, attack, { scriptType = 0, damageSourceId = eDamageSourceId.titan_melee } )
				}
				if ( "meleeExecutionAttacker" in target.s )
				{
					delete target.s.meleeExecutionAttacker
				}
			}
		}
	)

	thread FirstPersonSequence( targetSequence, target, ref )
	waitthread FirstPersonSequence( attackerSequence, attacker, ref )

	//wait ( 50.0 / 30.0 ) // 37 frames in
}


function MeleeThread_StryderVsTitan( actions, action, attacker, target )
{
	local e = {}
	e.gib <- true
	e.attackerAnimation1p <- "strypov_melee_sync_frontkill"
	e.attackerAnimation3p <- "stry_melee_sync_frontkill"
	e.targetAnimation3p <- "stry_melee_sync_frontdeath"
	e.targetPilotAnimationForAttacker <- "pt_stry_melee_sync_front_pilotkill_1st"
	e.targetPilotAnimationForObserver <- "pt_stry_melee_sync_front_pilotkill_3rd"
	e.targetPilotAnimationForObserver1st <- "ptpov_stry_tvtmelee_targetdeath"
	e.TitanSpecific1pSyncMeleeSound <- "Stryder_1p_Sync_Melee"
	e.TitanSpecific3pSyncMeleeSound <- "Stryder_3p_Sync_Melee"

	MeleeThread_TitanRipsPilot( e, actions, action, attacker, target )
}

function MeleeThread_AtlasVsTitan( actions, action, attacker, target )
{
	local e = {}
	e.gib <- false
	e.attackerAnimation1p <- "atpov_melee_sync_frontkill"
	e.attackerAnimation3p <- "at_melee_sync_frontkill"
	e.targetAnimation3p <- "at_melee_sync_frontdeath"
	e.targetPilotAnimationForAttacker <- "pt_melee_sync_front_pilotkill_1st"
	e.targetPilotAnimationForObserver <- "pt_melee_sync_front_pilotkill_3rd"
	e.targetPilotAnimationForObserver1st <- "ptpov_tvtmelee_targetdeath"
	e.TitanSpecific1pSyncMeleeSound <- "Atlas_1p_Sync_Melee"
	e.TitanSpecific3pSyncMeleeSound <- "Atlas_3p_Sync_Melee"

	MeleeThread_TitanRipsPilot( e, actions, action, attacker, target )
}

function MeleeThread_TitanRipsPilot( e, actions, action, attacker, target )
{
	e.attackerViewBody <- null
	e.target <- target
	e.attacker <- attacker

	e.attackerStartOrg <- attacker.GetOrigin()

	local ref = CreateMeleeScriptMoverBetweenEnts( attacker, target )

	local attackerSequence = CreateFirstPersonSequence()
	attackerSequence.blendTime = 0.25
	attackerSequence.attachment = "ref"

	local targetSequence = clone attackerSequence

	attackerSequence.thirdPersonAnim = e.attackerAnimation3p
	// attackerSequence.thirdPersonAnimIdle = "at_melee_sync_frontkill_end_idle"

	attackerSequence.firstPersonAnim = e.attackerAnimation1p
	targetSequence.thirdPersonAnim = e.targetAnimation3p
	targetSequence.blendTime = 0.25

	target.s.meleeExecutionAttacker <- attacker

	// attacker.SetInvulnerable()
	target.SetInvulnerable()    //HACK: Have to SetInvulnerable first before attacker holsters weapon, because if the attacker is vortexing, holster will release bullets caught and kill off the victim if low enough health
	if ( ShouldHolsterWeaponForMelee( attacker ) )
		attacker.HolsterWeapon()

	if ( !target.IsNPC() )
		target.DisableWeaponViewModel()

	local attackerViewBody

	EmitDifferentSoundsOnEntityForPlayerAndWorld( e.TitanSpecific1pSyncMeleeSound, e.TitanSpecific3pSyncMeleeSound, attacker, attacker )

    local attackerViewBody = Wallrun_CreateCopyOfPilotModel( target ) //attackerViewBody is the model of the pilot getting ripped out of the cockpit
	attackerViewBody.SetOrigin( ref.GetOrigin() )
	e.attackerViewBody = attackerViewBody
	attackerViewBody.SetOwner( attacker )
	attackerViewBody.kv.VisibilityFlags = 1 //owner only
	attackerViewBody.SetRagdollImpactFX( RAGDOLL_IMPACT_TABLE_IDX )
	attackerViewBody.SetContinueAnimatingAfterRagdoll( true )

	local attackerBodySequence = CreateFirstPersonSequence()
	attackerBodySequence.attachment = "ref"
	attackerBodySequence.teleport = true
	attackerBodySequence.thirdPersonAnim = e.targetPilotAnimationForAttacker

	local targetBodySequence = CreateFirstPersonSequence()
	targetBodySequence.attachment = "ref"
	targetBodySequence.blendTime = 0.25
	targetBodySequence.thirdPersonAnim = e.targetPilotAnimationForObserver
	targetBodySequence.firstPersonAnim = e.targetPilotAnimationForObserver1st


	local soul = target.GetTitanSoul()
	soul.SetInvalidHealthBarEnt( true )

	e.oldPlayerSettings <- target.s.storedPlayerSettings
	target.s.storedPlayerSettings = "pilot_titan_cockpit" // needs to be per titan
	local targetTitan = CreateTitanFromPlayer( target ) //TargetTitan is the NPC Titan that is created temporarily during execution

//	if ( !( "isRodeoEnabled" in targetTitan.s ) )
//		targetTitan.s.isRodeoEnabled <- null

	targetTitan.s.isRodeoEnabled <- false

	if ( GameRules.GetGameMode() == CAPTURE_THE_FLAG && PlayerHasEnemyFlag( target ) )
	{
		ReturnFlagFromPlayer( target, attacker )
	}

	if ( GameRules.GetGameMode() == CAPTURE_THE_FLAG_PRO && PlayerHasEnemyFlag( target ) )
	{
		ReturnFlagFromPlayer( target, attacker )
	}

	TitanBecomesPilot( target, targetTitan )

	local soul = targetTitan.GetTitanSoul()
	Assert( soul )
	soul.ClearRodeoAllowed()

	AddAnimEvent( targetTitan, "rider_rodeo_over", ForceRodeoOver  )

	targetTitan.SetOwner( target )
	targetTitan.kv.VisibilityFlags = 6 //owner cant see
	targetTitan.SetInvulnerable() //Setting target of execution as invulnerable to prevent them dying mid-way
	HideTitanEyePartial( targetTitan )
	targetTitan.s.noLongerCountsForLTS <- true

	target.SetOwner( attacker )
	target.kv.VisibilityFlags = 6 //owner cant see
	targetTitan.PlayerMelee_ExecutionStartTarget( attacker )
	e.targetTitan <- targetTitan
	if ( GameRules.GetGameMode() == ATTRITION )
		e.gaveTitanAttritionPoints <- false

	OnThreadEnd(
		function() : ( ref, attacker, target, targetTitan, e  )
		{
			if ( IsValid( ref ) )
			{
				if ( IsValid( attacker ) )
				{
					printtodiag( Time() + ": MeleeThread_TitanRipsPilot: OnThreadEnd: Attacker is " + attacker + "\n" )
					if ( attacker.IsPlayer() )
					{
						printtodiag( Time() + ": MeleeThread_TitanRipsPilot: OnThreadEnd: Attacker player name is: " + attacker.GetPlayerName() + "\n"  )
					}
					attacker.ClearParent()
				}
				else
				{
					printtodiag( Time() + ": MeleeThread_TitanRipsPilot: OnThreadEnd: Attacker is not valid. Going to TryClearParent().\n"  )
					TryClearParent( attacker )
				}

				if ( IsValid( target ) )
				{
					printtodiag( Time() + ": MeleeThread_TitanRipsPilot: OnThreadEnd: Target is " + target + "\n"  )
					if ( target.IsPlayer() )
					{
						printtodiag( Time() + ": MeleeThread_TitanRipsPilot: OnThreadEnd: Target player name is: " + target.GetPlayerName() + "\n"  )
					}
					target.ClearParent()
				}
				else
				{
					printtodiag( Time() + ": MeleeThread_TitanRipsPilot: OnThreadEnd: Target is not valid. Going to TryClearParent().\n"  )
					TryClearParent( target )
				}

				AssertNoPlayerChildren( ref )
				ref.Kill()
			}

			if ( IsValid( attacker ) )
			{
				attacker.UnforceStand()
				attacker.ClearParent()
				attacker.ClearAnimViewEntity()
				attacker.DeployWeapon()
				attacker.PlayerMelee_ExecutionEndAttacker()

				if ( IsAlive( attacker ) )
				{
					// if we got into solid, teleport back to safe place
					UnStuck( attacker, e.attackerStartOrg )
				}
			}

			if ( IsValid( target ) )
			{
				target.PlayerMelee_ExecutionEndTarget()
				if ( HasAnimEvent( target, "pink_mist" ) )
					DeleteAnimEvent( target, "pink_mist", MeleePinkMist )

				if ( IsAlive( e.target ) )
					MeleePinkMist( null, e )
			}

			if ( IsValid( e.attackerViewBody ) )
				e.attackerViewBody.Kill()

			if ( IsValid( target ) )
			{
				if ( "meleeExecutionAttacker" in target.s )
					delete target.s.meleeExecutionAttacker
			}
		}
	)

	waitthread TitanSyncedMeleeAnimationsPlay( attackerBodySequence, attackerViewBody, ref, targetBodySequence, target, attackerSequence, attacker, targetSequence, targetTitan, e )
}

function TitanSyncedMeleeAnimationsPlay( attackerBodySequence, attackerViewBody, ref, targetBodySequence, target, attackerSequence, attacker, targetSequence, targetTitan, e )
{
	e.thrown <- false
	OnThreadEnd (
		function () : ( targetTitan, target, attacker, e )
		{
			// insure visibility
			if ( IsValid( targetTitan ) )
				targetTitan.kv.VisibilityFlags = 7 // owner can see

			if ( !IsAlive( attacker ) )
			{
				attacker.Anim_Stop()

				if ( !e.thrown && IsAlive( target ) )
				{
					target.Anim_Stop()
					target.SetOwner( null )
					target.GetFirstPersonProxy().Anim_Stop()
					target.ClearAnimViewEntity()
					target.kv.VisibilityFlags = 7 // all can see
					target.SetPlayerSettings( e.oldPlayerSettings )
				}
			}
		}
	)

	attacker.EndSignal( "Disconnected" )
	attacker.EndSignal( "OnDeath" )
	target.EndSignal( "Disconnected" )
//	target.EndSignal( "OnDeath" )

	targetTitan.Anim_AdvanceCycleEveryFrame( true )

	thread FirstPersonSequence( attackerBodySequence, attackerViewBody, ref )
	thread FirstPersonSequence( targetBodySequence, target, ref )
	thread FirstPersonSequence( attackerSequence, attacker, ref )
	thread FirstPersonSequence( targetSequence, targetTitan, ref )
	local duration = attacker.GetSequenceDuration( attackerSequence.thirdPersonAnim )

	if ( e.targetAnimation3p == "at_melee_sync_frontdeath" )
	{
		thread MeleeThrowIntoWallSplat( attacker, target, e )
	}
	else
	{
		AddAnimEvent( target, "pink_mist", MeleePinkMist, e )
	}

	local timer
	local titanType = GetSoulTitanType(attacker.GetTitanSoul())

	if ( titanType != null )
	{
		local titanDataTable = GetPlayerClassDataTable( attacker, "titan" )
		local titanSettings = titanDataTable.playerSetFile
		timer = GetPlayerSettingsFieldForClassName(titanSettings, "MeleeAnimationsTimer")
	}

	timer = 3.0

	wait timer

	// first the victim cant see his titan, as a pilot, and then he can
	targetTitan.SetNextThinkNow()
	targetTitan.kv.VisibilityFlags = 7 // owner can see
	targetTitan.SetNextThinkNow()
	wait duration - timer
}

function MeleePinkMist( _, e ) //first parameter isn't used, but function signature is like this because it's being called from an anim event
{
	local target = e.target

	if ( !IsAlive( target ) )
		return
	local gibModel = GetGibModel( target )
	local vec = e.attackerViewBody.GetOrigin() - e.attacker.GetOrigin()
	vec.Norm()
	e.attackerViewBody.Gib( gibModel, vec, false )

	// [LJS]원래 코드. 스트라이더가 타이탄 gib 시 파일럿 혈흔.
	e.attackerViewBody.Dissolve( ENTITY_DISSOLVE_PINKMIST, Vector( 0, 0, 0 ), 0 )
	// 워게임 형식으로 변경.
	e.attackerViewBody.Dissolve( ENTITY_DISSOLVE_NORMAL, Vector( 0, 0, 0 ), 0 )

	if ( IsValid( e.attacker ) )
	{
		target.Die( e.attacker, e.attacker, { damageSourceId = eDamageSourceId.titan_execution, scriptType = DF_GIB } )
	}
	else
	{
		target.Die( e.target, target, { damageSourceId = eDamageSourceId.titan_execution, scriptType = DF_GIB } )
	}

	target.ClearAnimViewEntity()

	target.ClearInvulnerable()
}

function MeleeThrowIntoWallSplat( attacker, target, e )
{
	OnThreadEnd(
		function () : ( target, e )
		{
			if ( IsValid( target ) )
			{
				TitanMeleeRestoreTarget( target, e )
				target.ClearInvulnerable()
			}
		}
	)

	target.EndSignal( "OnDeath" )
	target.EndSignal( "Disconnected" )

	e.startOrigin <- target.GetOrigin()
	wait 2.8
	e.thrown = true


	// attacker got killed? saved!
	if ( !IsAlive( attacker ) )
		return

	local angles = attacker.GetAngles()
	angles = angles.AnglesCompose( Vector( -15, 0, 0 ) )
	local forward = angles.AnglesToForward()

	local endPos
	for ( ;; )
	{
		if ( !target.Anim_IsActive() )
			break

		local org = target.GetOrigin()
		if ( IsAlive( attacker ) )
		{
			local titanPilotTrace = TraceLine( attacker.EyePosition(), org, attacker )

			if ( titanPilotTrace.fraction < 1.0 )
			{
				endPos = titanPilotTrace.endPos
				break
			}
		}


		local result = TraceLine( org, org + forward * 200 )
		if ( result.fraction < 1.0 )
		{
			wait result.fraction * 0.06
			break
		}

		wait 0
	}

	if ( endPos )
	{
		target.SetOrigin( endPos )
	}

	Assert( IsAlive( target ) )

	target.ClearInvulnerable()

	target.BecomeRagdoll( Vector(0,0,0) )

	wait 0 // ragdoll take hold!
	EmitSoundOnEntity( target, "Titan_Victim_Wall_Splat" )

	if ( e.gib )
	{
		local force = Vector(0,0,0)
		if ( IsAlive( attacker ) )
		{
			local vec = target.GetOrigin() - attacker.GetOrigin()
			vec.Norm()
			force = vec
		}
		target.Die( attacker, attacker, { scriptType = DF_GIB | DF_KILLSHOT, force = force, damageSourceId = eDamageSourceId.titan_execution } )
	}
	else
	{
		target.Die( attacker, attacker, { scriptType = DF_KILLSHOT, damageSourceId = eDamageSourceId.titan_execution } )
	}
}


function MeleeAnimThrow( attacker, target, throwDuration )
{
	attacker.EndSignal( "OnDeath" )
	target.EndSignal( "OnDeath" )
	target.EndSignal( "Disconnected" )
	wait throwDuration - 0.2

	local angles = attacker.GetAngles()
	local forward = angles.AnglesToForward()
	target.ClearParent()
	target.SetVelocity( forward * 500 )


	target.Die( attacker, attacker, { scriptType = DF_KILLSHOT, damageSourceId = eDamageSourceId.titan_melee } )
	return
	//target.BecomeRagdoll( forward )

	local endTime = Time() + 5.0
	for ( ;; )
	{
		if ( Time() > endTime )
			break
		local org = target.GetOrigin()
		local result = TraceLine( org, org + forward * 200 )
		if ( result.fraction >= 1.0 )
		{
			wait 0
			continue
		}

		wait result.fraction * 0.15
		break
	}

//	wait 0.5
	// target could die before this point, but is always dead after
	target.Die( attacker, attacker, { scriptType = DF_KILLSHOT, damageSourceId = eDamageSourceId.titan_melee } )
}



// ogre vs titan melee
function MeleeThread_OgreVsTitan( actions, action, attacker, target )
{
	local attackerAnimation1p = "ogpov_melee_armrip_attacker"
	local attackerAnimation3p = "og_melee_armrip_attacker"
	local targetAnimation1p = "ogpov_melee_armrip_victim"
	local targetAnimation3p = "og_melee_armrip_victim"

	local e = {}
	e.attackerStartOrg <- attacker.GetOrigin()
	e.lostArm <- false
	e.targetStartOrg <- target.GetOrigin()

	local ref = CreateMeleeScriptMoverBetweenEnts( target, attacker )

	local attackerSequence = CreateFirstPersonSequence()
	attackerSequence.blendTime = 0.25
	attackerSequence.attachment = "ref"

	local targetSequence = clone attackerSequence
	printt( "MeleeThread_OgreVsTitan" )
	attackerSequence.thirdPersonAnim = attackerAnimation3p
	attackerSequence.firstPersonAnim = attackerAnimation1p
	targetSequence.firstPersonAnim = targetAnimation1p
	targetSequence.thirdPersonAnim = targetAnimation3p
	targetSequence.blendTime = 0.25

	target.s.meleeExecutionAttacker <- attacker
	if ( ShouldHolsterWeaponForMelee( attacker ) )
		attacker.HolsterWeapon()

	if ( !target.IsNPC() )
		target.DisableWeaponViewModel()

	// attacker.SetInvulnerable()
	target.SetInvulnerable()

	local soul = target.GetTitanSoul()
	soul.SetInvalidHealthBarEnt( true )

	if ( !( "isRodeoEnabled" in target.s ) )
		target.s.isRodeoEnabled <- null

	target.s.isRodeoEnabled = false

	OnThreadEnd(
		function() : ( ref, attacker, target, e  )
		{
			if ( IsValid( ref ) )
			{
				if ( IsValid( attacker ) )
					attacker.ClearParent()

				if ( IsValid( target ) )
					target.ClearParent()

				AssertNoPlayerChildren( ref )
				ref.Kill()
			}

			if ( IsValid( attacker ) )
			{
				attacker.UnforceStand()
				attacker.ClearParent()
				attacker.ClearAnimViewEntity()
				attacker.DeployWeapon()
				attacker.PlayerMelee_ExecutionEndAttacker()

				if ( IsAlive( attacker ) )
				{
					// if we got into solid, teleport back to safe place
					UnStuck( attacker, e.attackerStartOrg )
				}
			}

			if ( IsValid( target ) )
			{
				delete target.s.isRodeoEnabled
				DeleteAnimEvent( target, "lost_arm", TitanLostArm )

				if ( "meleeExecutionAttacker" in target.s )
					delete target.s.meleeExecutionAttacker

				target.ClearParent()
				target.ClearInvulnerable()
				target.ClearAnimViewEntity()
				target.EnableWeaponViewModel()
				target.PlayerMelee_ExecutionEndTarget()

				if ( e.lostArm && IsAlive( target ) )
				{
					target.Die( attacker, attacker, { scriptType = DF_KILLSHOT, damageSourceId = eDamageSourceId.titan_melee } )
					return
				}
				else
				if ( !target.IsNPC() )
				{
					UnStuck( target, e.targetStartOrg )
				}
			}
		}
	)

	attacker.EndSignal( "Disconnected" )
	attacker.EndSignal( "OnDeath" )

	EmitDifferentSoundsOnEntityForPlayerAndWorld( "Ogre_1p_Sync_Melee", "Ogre_3p_Sync_Melee", attacker, attacker )

	AddAnimEvent( target, "lost_arm", TitanLostArm, e )


	thread FirstPersonSequence( targetSequence, target, ref )
	waitthread FirstPersonSequence( attackerSequence, attacker, ref )
}

function TitanLostArm( titan, e )
{
	e.lostArm = true
}
