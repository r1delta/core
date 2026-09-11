function main()
{
	Globalize( TitanCockpit_PlayDialog )
	Globalize( ServerCallback_TitanFallWarning )
	Globalize( ServerCallback_TitanDialogueBurnCardVO )

	file.betty <- {}
	file.betty.ALARM <- { prefix = "diag_gs_titan", suffix = "_bbalarm" }
	file.betty.MULTIADD <- { prefix = "diag_gs_titan", suffix = "_multititanengage" }
	file.betty.MULTIENGAGE <- { prefix = "diag_gs_titan", suffix = "_multititanengage_2" }
	file.betty.OUTNUMBERED <- { prefix = "diag_gs_titan", suffix = "_multititanengage" }
	file.betty.OUTNUMBERED21 <- { prefix = "diag_gs_titan", suffix = "_outnumbered2to1_1" }
	file.betty.OUTNUMBERED31 <- { prefix = "diag_gs_titan", suffix = "_outnumbered3to1_1" }
	file.betty.OUTNUMBERED41 <- { prefix = "diag_gs_titan", suffix = "_outnumbered4to1_1" }
	file.betty.EMBARK <- { prefix = "diag_gs_titan", suffix = "_embark" }
	file.betty.DISEMBARK <- { prefix = "diag_gs_titan", suffix = "_disembark" }
	file.betty.CRITICALDAMAGE <- { prefix = "diag_gs_titan", suffix = "_briefcriticaldamage" }
	file.betty.MANUAL_EJECT <- { prefix = "diag_gs_titan", suffix = "_def_manualEjectNotice_grp" }
	file.betty.AUTOEJECT <- { prefix = "diag_gs_titan", suffix = "_def_autoEjectNotice_grp" }
	file.betty.AUTOEJECTJOKE <- { prefix = "diag_gs_titan", suffix = "_def_autoEjectJoke_grp" }
	file.betty.DOOMSTATE <- { prefix = "diag_gs_titan", suffix = "_doomstate" }
	file.betty.HALFDOOMSTATE <- { prefix = "diag_gs_titan", suffix = "_halfdoomstate" }
	file.betty.RODEO_HULL <- { prefix = "diag_gs_titan", suffix = "_def_rodeowarning_1" }
	file.betty.RODEO_DISEMBARK <- { prefix = "diag_gs_titan", suffix = "_def_rodeowarning_2" }
	file.betty.RODEO_FRIENDLY_ATTACH <- { prefix = "diag_gs_titan", suffix = "_def_allyrodeoattach_1" }
	file.betty.RODEO_FRIENDLY_DETACH <- { prefix = "diag_gs_titan", suffix = "_def_allyrodeodetach_1" }
	file.betty.RODEO_RAKE <- { prefix = "diag_gs_titan", suffix = "_def_killEnemyRodeo_grp" }

	file.betty.ENEMY_PILOT_ATTACKING 			<- { prefix = "diag_gs_titan", suffix = "_def_warningEnemyPilot_19_01" } //* Warning: An enemy pilot is attacking you.
	file.betty.MULTIPLE_ENEMY_PILOTS_ATTACKING 	<- { prefix = "diag_gs_titan", suffix = "_def_warningEnemyPilotMulti_20_01" } //* Warning: Multiple enemy pilots are attacking you.
	file.betty.YOU_ELIMINATED_TARGET			<- { prefix = "diag_gs_titan", suffix = "_def_elimTarget_11_01" } //* You have eliminated your target., suffix =

	file.betty.ENEMY_TARGET_ELIMINATED			<- { prefix = "diag_gs_titan", suffix = "_def_elimTarget_11_02" } //* Your target has been eliminated.
	file.betty.ENEMY_PILOT_ELIMINATED 			<- { prefix = "diag_gs_titan", suffix = "_def_elimEnemyPilot_14_01" } //* Enemy pilot eliminated., suffix =

	file.betty.ENEMY_EJECTED					<- { prefix = "diag_gs_titan", suffix = "_def_ejectedEnemy_12_01" } //* Enemy Titan has ejected.
	file.betty.FRIENDLY_EJECTED 				<- { prefix = "diag_gs_titan", suffix = "_def_ejectedFriendly_13_01" } //* Friendly Titan has ejected.
	file.betty.FRIENDLY_TITAN_HELPING 	 		<- { prefix = "diag_gs_titan", suffix = "_def_assistedByFriendlyTitan_17_01" } //* A friendly Titan is attacking your target.
	file.betty.ENEMY_TITAN_DEAD 				<- { prefix = "diag_gs_titan", suffix = "_def_elimEnemyTitan_15_01" } //* Enemy Titan down.
	file.betty.FRIENDLY_TITAN_DEAD 				<- { prefix = "diag_gs_titan", suffix = "_def_elimFriendlyTitan_16_01" } //* Friendly Titan down.
	file.betty.PILOT_HELPING 	 				<- { prefix = "diag_gs_titan", suffix = "_def_assistedByFriendlyPilot_18_01" } //* A pilot is attacking your target.
	file.betty.FRIENDLY_RODEOING_ENEMY 			<- { prefix = "diag_gs_titan", suffix = "_def_friendlyRodeoOnEnemyTitan_21_01" } // * A friendly pilot is rodeo’ing your target.

    file.betty.CORE_ONLINE_DAMAGE <- { prefix = "diag_gs_titan", suffix = "_def_dmgCoreOnline_01_02" }
	file.betty.CORE_ONLINE_SHIELD <- { prefix = "diag_gs_titan", suffix = "_def_shieldCoreOnline_01_02" }
	file.betty.CORE_ONLINE_DASH <- { prefix = "diag_gs_titan", suffix = "_def_dashCoreOnline_01_02" }

	file.betty.CORE_ACTIVATED_DAMAGE <- { prefix = "diag_gs_titan", suffix = "_def_dmgCoreActivated_01_01" }
	file.betty.CORE_ACTIVATED_SHIELD <- { prefix = "diag_gs_titan", suffix = "_def_shieldCoreActivated_01_01" }
	file.betty.CORE_ACTIVATED_DASH <- { prefix = "diag_gs_titan", suffix = "_def_dashCoreActivated_01_01" }

	file.betty.CORE_DESC_DAMAGE <- { prefix = "diag_gs_titan", suffix = "_def_dmgCoreActivated_01_04" }
	file.betty.CORE_DESC_SHIELD <- { prefix = "diag_gs_titan", suffix = "_def_shieldCoreActivated_01_04" }
	file.betty.CORE_DESC_DASH <- { prefix = "diag_gs_titan", suffix = "_def_dashCoreActivated_01_04" }

	file.betty.CORE_EXPIRING_DAMAGE <- { prefix = "diag_gs_titan", suffix = "_def_dmgCoreExpiring_01_01" }
	file.betty.CORE_EXPIRING_SHIELD <- { prefix = "diag_gs_titan", suffix = "_def_shieldCoreExpiring_01_01" }
	file.betty.CORE_EXPIRING_DASH <- { prefix = "diag_gs_titan", suffix = "_def_dashCoreExpiring_01_01" }

	file.betty.CORE_OFFLINE_DAMAGE <- { prefix = "diag_gs_titan", suffix = "_def_dmgCoreOffline_01_01" }
	file.betty.CORE_OFFLINE_SHIELD <- { prefix = "diag_gs_titan", suffix = "_def_shieldCoreOffline_01_01" }
	file.betty.CORE_OFFLINE_DASH <- { prefix = "diag_gs_titan", suffix = "_def_dashCoreOffline_01_01" }

	file.betty.CORE_DENIED_DAMAGE <- { prefix = "diag_gs_titan", suffix = "_def_dmgCoreOffline_01_02" }
	file.betty.CORE_DENIED_SHIELD <- { prefix = "diag_gs_titan", suffix = "_def_shieldCoreOffline_01_02" }
	file.betty.CORE_DENIED_DASH <- { prefix = "diag_gs_titan", suffix = "_def_dashCoreOffline_01_02" }

	file.betty.TITANFALL_INCOMING <- { prefix = "diag_gs_titan", suffix = "_def_hostileTitanInbound_01_02" }
	file.betty.TITANFALL_DETECTED <- { prefix = "diag_gs_titan", suffix = "_def_hostileTitanInbound_01_01" }

	file.betty.BC_TITAN_40MM_M2 <- { prefix = "diag_gs_titan", suffix = "_def_amped40mm_grp" }
	file.betty.BC_TITAN_ARC_CANNON_M2 <- { prefix = "diag_gs_titan", suffix = "_def_ampedArc_grp" }
	file.betty.BC_TITAN_ROCKET_LAUNCHER_M2 <- { prefix = "diag_gs_titan", suffix = "_def_ampedMiniCluster_grp" }
	file.betty.BC_TITAN_SNIPER_M2 <- { prefix = "diag_gs_titan", suffix = "_def_ampedRailgun_grp" }
	file.betty.BC_TITAN_TRIPLE_THREAT_M2 <- { prefix = "diag_gs_titan", suffix = "_def_ampedTriple_grp" }
	file.betty.BC_TITAN_XO16_M2 <- { prefix = "diag_gs_titan", suffix = "_def_ampedXO16_grp" }
	file.betty.BC_TITAN_DUMBFIRE_MISSILE_M2 <- { prefix = "diag_gs_titan", suffix = "_def_ampedClusterMissile_grp" }
	file.betty.BC_TITAN_HOMING_ROCKETS_M2 <- { prefix = "diag_gs_titan", suffix = "_def_ampedSlaved_grp" }
	file.betty.BC_TITAN_SALVO_ROCKETS_M2 <- { prefix = "diag_gs_titan", suffix = "_def_ampedSalvo_grp" }
	file.betty.BC_TITAN_SHOULDER_ROCKETS_M2 <- { prefix = "diag_gs_titan", suffix = "_def_ampedMissileSys_grp" }
	file.betty.BC_TITAN_VORTEX_SHIELD_M2 <- { prefix = "diag_gs_titan", suffix = "_def_ampedVortexShield_grp" }
	file.betty.BC_TITAN_ELECTRIC_SMOKE_M2 <- { prefix = "diag_gs_titan", suffix = "_def_ampedElecSmoke_grp" }
	file.betty.BC_TITAN_SHIELD_WALL_M2 <- { prefix = "diag_gs_titan", suffix = "_def_ampedShieldWall_grp" }
	file.betty.BC_EXTRA_DASH <- { prefix = "diag_gs_titan", suffix = "_def_ampedDash_grp" }

	// "_def_ampedSlaved_grp" just makes them say "Titan Burn Card enabled.", so if we add any new titan burn cards in the future, use that one
	file.betty.BC_TITAN_GENERIC <- { prefix = "diag_gs_titan", suffix = "_def_ampedSlaved_grp" }
	file.betty.BC_TITAN_MELEE_M2 <- { prefix = "diag_gs_titan", suffix = "_def_ampedMelee_grp" }

	foreach ( eventName, dialogInfo in file.betty )
	{
		dialogInfo.eventType <- eventName

		if ( !GetDeveloperLevel() )
			continue

		foreach( _, titanOSVoice in  TITAN_OS_VOICE_PACK )
		{
			local soundAlias = dialogInfo.prefix + titanOSVoice + dialogInfo.suffix
			if( !DoesAliasExist( soundAlias ) )
					CodeWarning( "Alias "  + soundAlias + " does not exist!" )
		}

	}

	file.events <- {}
	file.events["missile_lock"] <- { priority = 2.0, debounce = 6.0 }
	file.events["missile_lock_acquired"] <- { priority = 2.0, debounce = 6.0 }

	file.events["core_online"] <- { priority = 2.0, debounce = 0.1 }
	file.events["core_activated"] <- { priority = 2.1, debounce = 0.1 }
	file.events["core_fired"] <- { priority = 2.15, debounce = 0.1 }
	file.events["core_expiring"] <- { priority = 2.2, debounce = 0.1 }
	file.events["core_offline"] <- { priority = 2.3, debounce = 0.1 }
	file.events["core_denied"] <- { priority = 0.1, debounce = 3.0 }

	if ( GAMETYPE == COOPERATIVE ) //Increase debounce time for coop because there are so many titans in the mode
	{
		file.events["outnumbered"] <- { priority = 3.0, debounce = 10.0 }
		file.events["multi_titan_engagement"] <- { priority = 3.0, debounce = 10.0 }
	}
	else
	{
		file.events["outnumbered"] <- { priority = 3.0, debounce = 3.0 }
		file.events["multi_titan_engagement"] <- { priority = 3.0, debounce = 6.0 }
	}

	file.events["adds"] <- { priority = 2.0, debounce = 3.0 }
	file.events["suggest_eject"] <- { priority = 5.0, debounce = 3.0, doomed = true }
	file.events["manual_eject"] <- { priority = 7.0, debounce = 0.0, doomed = true }
	file.events["damage"] <- { priority = 1.0, debounce = 3.0 }
	file.events["doomed"] <- { priority = 5.0, debounce = 0.0, doomed = true }
	file.events["autoeject"] <- { priority = 5.0, debounce = 0.0, doomed = true }
	file.events["rodeo_enemy_attach"] <- { priority = 4.0, debounce = 3.0, alwaysAnnounce = true }
	file.events["rodeo_enemy_spectre_attach"] <- { priority = 4.0, debounce = 3.0, alwaysAnnounce = true }
	file.events["rodeo_friendly_attach"] <- { priority = 0.1, debounce = 3.0 }
	file.events["rodeo_friendly_detach"] <- { priority = 0.1, debounce = 3.0 }
	file.events["rodeo_rake"] <- { priority = 4.1, debounce = 3.0 }

	file.events["embark"] <- { priority = 0.1, debounce = 3.0 }
	file.events["disembark"] <- { priority = 0.1, debounce = 3.0, doomed = true }

	file.events["titanfall_incoming"] <- { priority = 5.0, debounce = 0.1, alwaysAnnounce = true }
	file.events["titanfall_detected"] <- { priority = 5.0, debounce = 0.1, alwaysAnnounce = true }

	file.events["ENEMY_PILOT_ATTACKING"] <- { priority = 2.0, debounce = 3.0 }
	file.events["MULTIPLE_ENEMY_PILOTS_ATTACKING"] <- { priority = 2.0, debounce = 3.0 }
	file.events["YOU_ELIMINATED_TARGET"] <- { priority = 2.0, debounce = 3.0 }
	file.events["ENEMY_TARGET_ELIMINATED"] <- { priority = 2.0, debounce = 3.0 }
	file.events["ENEMY_PILOT_ELIMINATED"] <- { priority = 2.0, debounce = 3.0 }
	file.events["ENEMY_EJECTED"] <- { priority = 2.0, debounce = 3.0 }
	file.events["FRIENDLY_EJECTED"] <- { priority = 2.0, debounce = 3.0 }
	file.events["FRIENDLY_TITAN_HELPING"] <- { priority = 2.0, debounce = 3.0 }
	file.events["ENEMY_TITAN_DEAD"] <- { priority = 2.0, debounce = 3.0 }
	file.events["FRIENDLY_TITAN_DEAD"] <- { priority = 2.0, debounce = 3.0 }
	file.events["PILOT_HELPING"] <- { priority = 2.0, debounce = 3.0 }
	file.events["FRIENDLY_RODEOING_ENEMY"] <- { priority = 2.0, debounce = 3.0 }


	file.events["bc_titan_40mm_m2"] <- { priority = 0.2, debounce = 3.0 }
	file.events["bc_titan_arc_cannon_m2"] <- { priority = 0.2, debounce = 3.0 }
	file.events["bc_titan_rocket_launcher_m2"] <- { priority = 0.2, debounce = 3.0 }
	file.events["bc_titan_sniper_m2"] <- { priority = 0.2, debounce = 3.0 }
	file.events["bc_titan_triple_threat_m2"] <- { priority = 0.2, debounce = 3.0 }
	file.events["bc_titan_xo16_m2"] <- { priority = 0.2, debounce = 3.0 }
	file.events["bc_titan_dumbfire_missile_m2"] <- { priority = 0.2, debounce = 3.0 }
	file.events["bc_titan_homing_rockets_m2"] <- { priority = 0.2, debounce = 3.0 }
	file.events["bc_titan_salvo_rockets_m2"] <- { priority = 0.2, debounce = 3.0 }
	file.events["bc_titan_shoulder_rockets_m2"] <- { priority = 0.2, debounce = 3.0 }
	file.events["bc_titan_vortex_shield_m2"] <- { priority = 0.2, debounce = 3.0 }
	file.events["bc_titan_electric_smoke_m2"] <- { priority = 0.2, debounce = 3.0 }
	file.events["bc_titan_shield_wall_m2"] <- { priority = 0.2, debounce = 3.0 }
	file.events["bc_extra_dash"] <- { priority = 0.2, debounce = 3.0 }

	file.events["doomed_noeject"] <- { priority = 5.0, debounce = 0.0, doomed = true }
	file.events["bc_titan_shotgun_m2"] <- { priority = 0.2, debounce = 3.0 }
	file.events["bc_thunderbolt_m2"] <- { priority = 0.2, debounce = 3.0 }
	file.events["bc_titan_charge_cannon_m2"] <- { priority = 0.2, debounce = 3.0 }
	file.events["bc_titan_melee_m2"] <- { priority = 0.2, debounce = 3.0 }

	//Add defaults for alwaysAnnounce and doomed
	foreach( event in file.events )
	{
		if ( !("doomed" in event ) )
			event.doomed <- false

		if ( !("alwaysAnnounce" in event ) )
			event.alwaysAnnounce <- false

	}

	RegisterSignal( "TitanCockpit_PlayDialogInternal" )

	level.lastRodeoWarningAlias <- ""
	TimerInit( "Nag_SpectreRodeo", 15.0 )
}

function TitanCockpit_PlayDialogDelayed( player, delay, eventType )
{
	player.EndSignal( "OnDestroy" )
	local cockpit = player.GetCockpit()
	if ( !IsValid( cockpit ) )
		return

	cockpit.EndSignal( "OnDestroy" )
	wait delay
	TitanCockpit_PlayDialog( player, eventType )
}
Globalize( TitanCockpit_PlayDialogDelayed )

function TitanCockpit_PlayDialog( player, eventType )
{
   //printt( "TitanCockpit_PlayDialog, eventType: " + eventType  )

	if ( !ShouldPlayTitanCockpitDialogueIfPlayerIsNotTitan( player, eventType ) )
		return

	if ( !IsAlive( player ) )
		return

	if ( player != GetLocalClientPlayer() )
		return

	if ( IsWatchingKillReplay() )
		return

	if ( player != GetLocalViewPlayer() )
		return

	if ( file.events[eventType].alwaysAnnounce == false ) //events marked as alwaysAnnounce == true skip these checks.
	{
		if ( level.CurrentPriority > 0 ) //Conversation system is currently talking, don't talk over Sarah/Blisk etc
			return

		if ( IsForcedDialogueOnly( player ) )
			return

		if ( !GamePlayingOrSuddenDeath() )
			return
	}

	thread TitanCockpit_PlayDialogInternal( player, eventType )
}

function ShouldPlayTitanCockpitDialogueIfPlayerIsNotTitan( player, eventType )
{
	if ( player.IsTitan() )
		return true

	switch( eventType )
	{
		case "disembark":
		case "manual_eject":
			return true

		default:
			//printt( "Return false ShouldPlayTitanCockpitDialogueIfPlayerIsNotTitan" )
			return false
	}
}


function TitanCockpit_PlayDialogInternal( player, eventType )
{
	printl( player.s)
	if ( player.s.titanCockpitDialogActive && file.events[eventType].priority <= file.events[player.s.titanCockpitDialogActive].priority )
	{
		//printt( "Returning from TitanCockpit_PlayDialogInternal because another higher priority dialog is taking place" )
		return
	}

	if ( Time() - player.s.lastDialogTime <= file.events[eventType].debounce )
	{
		/*local timeSince = Time() - player.s.lastDialogTime
		printt( "Returning from TitanCockpit_PlayDialogInternal because debounce time for event" + eventType + " has not reached yet" )
		printt( "Debounce: " + file.events[eventType].debounce + ", Time since last dialogue: " + timeSince )*/
		return
	}

	if ( player.GetDoomedState() && !file.events[eventType].doomed )
		return

	player.Signal( "TitanCockpit_PlayDialogInternal" )
	player.EndSignal( "TitanCockpit_PlayDialogInternal" )
	player.EndSignal( "OnDestroy" )
	player.EndSignal( "OnDeath" )

	switch ( eventType )
	{
		case "missile_lock":
			player.s.titanCockpitDialogAliasList.append( file.betty.ALARM )
			player.s.titanCockpitDialogAliasList.append( file.betty.MISSILELOCK )
			break

		case "missile_lock_acquired":
			player.s.titanCockpitDialogAliasList.append( file.betty.MISSILE_LOCK_ACQUIRED )
			break

		case "core_online":
			local titanType = player.GetPlayerSettingsField( "footstep_type" )
			
			switch ( titanType )
			{
				case "atlas":
					player.s.titanCockpitDialogAliasList.append( file.betty.CORE_ONLINE_DAMAGE )
					break
				case "ogre":
					player.s.titanCockpitDialogAliasList.append( file.betty.CORE_ONLINE_SHIELD )
					break
				case "stryder":
					player.s.titanCockpitDialogAliasList.append( file.betty.CORE_ONLINE_DASH )
					break
				
				default:
					player.s.titanCockpitDialogAliasList.append( file.betty.CORE_ONLINE_DAMAGE )
					break
			}
			break

		case "core_activated":
			local titanType = player.GetPlayerSettingsField( "footstep_type" )
			
			switch ( titanType )
			{
				case "atlas":
					player.s.titanCockpitDialogAliasList.append( file.betty.CORE_ACTIVATED_DAMAGE )
					break
				case "ogre":
					player.s.titanCockpitDialogAliasList.append( file.betty.CORE_ACTIVATED_SHIELD )
					break
				case "stryder":
					player.s.titanCockpitDialogAliasList.append( file.betty.CORE_ACTIVATED_DASH )
					break
				
				default:
					player.s.titanCockpitDialogAliasList.append( file.betty.CORE_ACTIVATED_DAMAGE )
					break
			}
			break

		case "core_fired":
			local titanType = player.GetPlayerSettingsField( "footstep_type" )
			
			switch ( titanType )
			{
				case "atlas":
					player.s.titanCockpitDialogAliasList.append( file.betty.CORE_DESC_DAMAGE )
					break
				case "ogre":
					player.s.titanCockpitDialogAliasList.append( file.betty.CORE_DESC_SHIELD )
					break
				case "stryder":
					player.s.titanCockpitDialogAliasList.append( file.betty.CORE_DESC_DASH )
					break
				
				default:
					player.s.titanCockpitDialogAliasList.append( file.betty.CORE_DESC_DAMAGE )
					break
			}
			break

		case "core_expiring":
			local titanType = player.GetPlayerSettingsField( "footstep_type" )
			
			switch ( titanType )
			{
				case "atlas":
					player.s.titanCockpitDialogAliasList.append( file.betty.CORE_EXPIRING_DAMAGE )
					break
				case "ogre":
					player.s.titanCockpitDialogAliasList.append( file.betty.CORE_EXPIRING_SHIELD )
					break
				case "stryder":
					player.s.titanCockpitDialogAliasList.append( file.betty.CORE_EXPIRING_DASH )
					break
				
				default:
					player.s.titanCockpitDialogAliasList.append( file.betty.CORE_EXPIRING_DAMAGE )
					break
			}
			break

		case "core_offline":
			local titanType = player.GetPlayerSettingsField( "footstep_type" )
			
			switch ( titanType )
			{
				case "atlas":
					player.s.titanCockpitDialogAliasList.append( file.betty.CORE_OFFLINE_DAMAGE )
					break
				case "ogre":
					player.s.titanCockpitDialogAliasList.append( file.betty.CORE_OFFLINE_SHIELD )
					break
				case "stryder":
					player.s.titanCockpitDialogAliasList.append( file.betty.CORE_OFFLINE_DASH )
					break
				
				default:
					player.s.titanCockpitDialogAliasList.append( file.betty.CORE_OFFLINE_DAMAGE )
					break
			}
			break

		case "core_denied":
			local titanType = player.GetPlayerSettingsField( "footstep_type" )
			
			switch ( titanType )
			{
				case "atlas":
					player.s.titanCockpitDialogAliasList.append( file.betty.CORE_DENIED_DAMAGE )
					break
				case "ogre":
					player.s.titanCockpitDialogAliasList.append( file.betty.CORE_DENIED_SHIELD )
					break
				case "stryder":
					player.s.titanCockpitDialogAliasList.append( file.betty.CORE_DENIED_DASH )
					break
				
				default://ignore this until needed
					player.s.titanCockpitDialogAliasList.append( file.betty.CORE_DENIED_DAMAGE )
					break
			}
			break

		case "titanfall_incoming":
			player.s.titanCockpitDialogAliasList.append( file.betty.ALARM )
			player.s.titanCockpitDialogAliasList.append( file.betty.TITANFALL_INCOMING )
			break

		case "titanfall_detected":
			player.s.titanCockpitDialogAliasList.append( file.betty.ALARM )
			player.s.titanCockpitDialogAliasList.append( file.betty.TITANFALL_DETECTED )
			break

		case "outnumbered":
			player.s.titanCockpitDialogAliasList.append( file.betty.ALARM )

			local outnumberedEvent
			local numTitans = Tracker_GetNumTitans( player )

			if ( numTitans <= 2 )
				outnumberedEvent = file.betty.OUTNUMBERED21
			else if ( numTitans == 3 )
				outnumberedEvent = file.betty.OUTNUMBERED31
			else
				outnumberedEvent = file.betty.OUTNUMBERED41

			player.s.titanCockpitDialogAliasList.append( outnumberedEvent )
			break

		case "multi_titan_engagement":
			player.s.titanCockpitDialogAliasList.append( file.betty.ALARM )
			player.s.titanCockpitDialogAliasList.append( file.betty.MULTIENGAGE )
			break

		case "adds":
			player.s.titanCockpitDialogAliasList.append( file.betty.ALARM )
			player.s.titanCockpitDialogAliasList.append( file.betty.MULTIADD )
			break

		case "suggest_eject":
			player.s.titanCockpitDialogAliasList.append( file.betty.ALARM )
			player.s.titanCockpitDialogAliasList.append( file.betty.HALFDOOMSTATE )
			break

		case "doomed":
			player.s.titanCockpitDialogAliasList.append( file.betty.ALARM )
			player.s.titanCockpitDialogAliasList.append( file.betty.DOOMSTATE )
			player.s.titanCockpitDialogAliasList.append( file.betty.HALFDOOMSTATE )
			break

		case "manual_eject":
			player.s.titanCockpitDialogAliasList.append( file.betty.MANUAL_EJECT )
			break

		case "autoeject":
			player.s.titanCockpitDialogAliasList.append( file.betty.ALARM )
			//if ( RandomInt( 0, 150 ) == 0 )
			//	player.s.titanCockpitDialogAliasList.append( file.betty.AUTOEJECTJOKE )
			//else
			player.s.titanCockpitDialogAliasList.append( file.betty.AUTOEJECT )
			break

		case "rodeo_enemy_attach":
			player.s.titanCockpitDialogAliasList.append( file.betty.ALARM )
			player.s.titanCockpitDialogAliasList.append( file.betty.RODEO_HULL )
			player.s.titanCockpitDialogAliasList.append( file.betty.RODEO_DISEMBARK )
			break

		// hacky- just using it for the alarm, no cockpit VO
		case "rodeo_enemy_spectre_attach":
			player.s.titanCockpitDialogAliasList.append( file.betty.ALARM )
			break

		case "rodeo_friendly_attach":
			player.s.titanCockpitDialogAliasList.append( file.betty.RODEO_FRIENDLY_ATTACH )
			break

		case "rodeo_friendly_detach":
			player.s.titanCockpitDialogAliasList.append( file.betty.RODEO_FRIENDLY_DETACH )
			break

		case "rodeo_rake":
			player.s.titanCockpitDialogAliasList.append( file.betty.RODEO_RAKE )
			break

		case "damage":
			player.s.titanCockpitDialogAliasList.append( file.betty.ALARM )
			player.s.titanCockpitDialogAliasList.append( file.betty.CRITICALDAMAGE )
			break

		case "embark":
			player.s.titanCockpitDialogAliasList = [ file.betty.EMBARK ]
			break

		case "disembark":
			player.s.titanCockpitDialogAliasList = [ file.betty.DISEMBARK ]
			break

		case "bc_titan_40mm_m2":
			player.s.titanCockpitDialogAliasList = [ file.betty.BC_TITAN_40MM_M2 ]
			break
		case "bc_titan_arc_cannon_m2":
			player.s.titanCockpitDialogAliasList = [ file.betty.BC_TITAN_ARC_CANNON_M2 ]
			break
		case "bc_titan_rocket_launcher_m2":
			player.s.titanCockpitDialogAliasList = [ file.betty.BC_TITAN_ROCKET_LAUNCHER_M2 ]
			break
		case "bc_titan_sniper_m2":
			player.s.titanCockpitDialogAliasList = [ file.betty.BC_TITAN_SNIPER_M2 ]
			break
		case "bc_titan_triple_threat_m2":
			player.s.titanCockpitDialogAliasList = [ file.betty.BC_TITAN_TRIPLE_THREAT_M2 ]
			break
		case "bc_titan_xo16_m2":
			player.s.titanCockpitDialogAliasList = [ file.betty.BC_TITAN_XO16_M2 ]
			break
		case "bc_titan_dumbfire_missile_m2":
			player.s.titanCockpitDialogAliasList = [ file.betty. BC_TITAN_DUMBFIRE_MISSILE_M2 ]
			break
		case "bc_titan_homing_rockets_m2":
			player.s.titanCockpitDialogAliasList = [ file.betty.BC_TITAN_HOMING_ROCKETS_M2 ]
			break
		case "bc_titan_salvo_rockets_m2":
			player.s.titanCockpitDialogAliasList = [ file.betty.BC_TITAN_SALVO_ROCKETS_M2 ]
			break
		case "bc_titan_shoulder_rockets_m2":
			player.s.titanCockpitDialogAliasList = [ file.betty.BC_TITAN_SHOULDER_ROCKETS_M2 ]
			break
		case "bc_titan_vortex_shield_m2":
			player.s.titanCockpitDialogAliasList = [ file.betty.BC_TITAN_VORTEX_SHIELD_M2 ]
			break
		case "bc_titan_electric_smoke_m2":
			player.s.titanCockpitDialogAliasList = [ file.betty.BC_TITAN_ELECTRIC_SMOKE_M2 ]
			break
		case "bc_titan_shield_wall_m2":
			player.s.titanCockpitDialogAliasList = [ file.betty.BC_TITAN_SHIELD_WALL_M2 ]
			break
		case "bc_extra_dash":
			player.s.titanCockpitDialogAliasList = [ file.betty.BC_EXTRA_DASH ]
			break

		// Copy of "doomed" without HALFDOOMSTATE (eject, eject, eject)
		case "doomed_noeject":
			player.s.titanCockpitDialogAliasList.append( file.betty.ALARM )
			player.s.titanCockpitDialogAliasList.append( file.betty.DOOMSTATE )
			break

		case "bc_titan_shotgun_m2":
		case "bc_thunderbolt_m2":
		case "bc_titan_charge_cannon_m2":
			player.s.titanCockpitDialogAliasList = [ file.betty.BC_TITAN_GENERIC ]
			break

		case "bc_titan_melee_m2":
			player.s.titanCockpitDialogAliasList = [ file.betty.BC_TITAN_MELEE_M2 ]
			break

		default:
			Assert( eventType in file.betty, eventType + " is not setup for event playback" )

			// direct add if it is in both
			player.s.titanCockpitDialogAliasList = [ file.betty[ eventType ] ]
	}

	player.s.lastDialogTime = Time()

	player.s.titanCockpitDialogActive = eventType

	OnThreadEnd(
		function() : ( player )
		{
			if ( !IsConnected() ) //Temp fix for SRE on disconnecting, real fix is to get a code variable instead of using persistent variable
				return

			foreach ( dialogType, dialogInfo in player.s.titanCockpitDialogAliasList )
			{
				local soundAlias = GenerateTitanOSAlias( player, dialogInfo.prefix, dialogInfo.suffix )
				StopSoundOnEntity( player, soundAlias )
			}

			player.s.titanCockpitDialogAliasList = []
			player.s.titanCockpitDialogActive = null
		}
	)

	foreach ( dialogType, dialogInfo in player.s.titanCockpitDialogAliasList )
	{
		//printt( "dialogType: " + dialogType + ", dialogInfo: ",  PrintTable( dialogInfo ) )

		local soundAlias = GenerateTitanOSAlias( player, dialogInfo.prefix, dialogInfo.suffix )
		//printt( "Attempting to play TitanCockpit_Dialog: " + soundAlias )

		wait EmitSoundOnEntity( player, soundAlias )

		if ( !player.IsTitan() )
			break
	}

	// HACK
	if ( player.GetTeam() == TEAM_MILITIA && eventType == "rodeo_enemy_spectre_attach" )
		thread CoopTD_TrySpectreRodeoWarning()
}


function ServerCallback_TitanFallWarning( death )
{
	local player = GetLocalClientPlayer()

	if ( !player.IsTitan() )
		return

	if ( death )
		TitanCockpit_PlayDialog( player, "titanfall_incoming" )
	else
		TitanCockpit_PlayDialog( player, "titanfall_detected" )
}

function SCB_TitanDialogue( voEnum )
{
	local player = GetLocalClientPlayer()

	if ( !player.IsTitan() )
		return

	local vo
	switch ( voEnum )
	{
		case eTitanVO.RODEO_RAKE:
			// Necessary because CodeCallback_TitanRiderEntVarChanged happens before the client knows the entity is dead.
			vo = "rodeo_rake"
			break

		case eTitanVO.ENEMY_EJECTED:
			vo = "ENEMY_EJECTED"
			break

		case eTitanVO.FRIENDLY_EJECTED:
			vo = "FRIENDLY_EJECTED"
			break

		case eTitanVO.FRIENDLY_TITAN_DEAD:
			vo = "FRIENDLY_TITAN_DEAD"
			break

		case eTitanVO.ENEMY_TITAN_DEAD:
			vo = "ENEMY_TITAN_DEAD"
			break

		case eTitanVO.PILOT_HELPING:
			vo = "PILOT_HELPING"
			break

		case eTitanVO.FRIENDLY_TITAN_HELPING:
			vo = "FRIENDLY_TITAN_HELPING"
			break

		case eTitanVO.ENEMY_TARGET_ELIMINATED:
			vo = "ENEMY_TARGET_ELIMINATED"
			break

		case eTitanVO.FRIENDLY_RODEOING_ENEMY:
			vo = "FRIENDLY_RODEOING_ENEMY"
			break

		default:
			printt( "Unknown titan vo enum " + voEnum )
	}

	TitanCockpit_PlayDialog( player, vo )
}
Globalize( SCB_TitanDialogue )

function ServerCallback_TitanDialogueBurnCardVO()
{
	local player = GetLocalClientPlayer()

	if ( !player.IsTitan() )
		return

	local cardRef = GetPlayerActiveBurnCard( player )
	if ( cardRef in file.events )
	{
		if ( !( "lastBurnCardIndexThatPlayedVO" in player.s ) )
			player.s.lastBurnCardIndexThatPlayedVO <- null

		local index = GetBurnCardIndex( cardRef )
		if ( player.s.lastBurnCardIndexThatPlayedVO != index )
		{
			player.s.lastBurnCardIndexThatPlayedVO = index
			TitanCockpit_PlayDialog( player, cardRef )
		}
	}
}

function CoopTD_TrySpectreRodeoWarning()
{
	if ( !TimerCheck( "Nag_SpectreRodeo" ) )
		return

	local voAlias = "CoopTD_SpectreRodeoWarning"
	if ( voAlias == level.lastRodeoWarningAlias )
		voAlias = "CoopTD_SpectreRodeoWarning_Short"

	PlayConversationToLocalClient( voAlias )
	level.lastRodeoWarningAlias = voAlias

	TimerReset( "Nag_SpectreRodeo" )
}
Globalize( CoopTD_TrySpectreRodeoWarning )

