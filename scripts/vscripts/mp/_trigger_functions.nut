function main()
{
	Globalize( InitFlagMaskTriggers )
	Globalize( TriggerInit )
	Globalize( AddToFlagTriggers )
	
	AddPostEntityLoadCallback( Bind( InitFlagMaskTriggers ) )

	level._flagTriggers <- {} // triggers that can be enabled/disabled via flag

	AddSpawnCallback( "trigger_multiple", 		TriggerInit )
	AddSpawnCallback( "trigger_once", 			TriggerInit )
	AddSpawnCallback( "trigger_spawn", 			TriggerSpawn )
	AddSpawnCallback( "trigger_flag_set", 		TriggerFlagSetThink )
	AddSpawnCallback( "trigger_flag_clear", 	TriggerFlagClearThink )
	AddSpawnCallback( "trigger_door", 			TriggerDoorSetup )


	AddSpawnCallback( "trigger_flag_set"               , AddToFlagTriggers )
	AddSpawnCallback( "trigger_flag_clear"             , AddToFlagTriggers )
	AddSpawnCallback( "trigger_multiple"               , AddToFlagTriggers )
	AddSpawnCallback( "trigger_startpoint"             , AddToFlagTriggers )
	AddSpawnCallback( "trigger_spawn"                  , AddToFlagTriggers )
	AddSpawnCallback( "trigger_once"                   , AddToFlagTriggers )
	AddSpawnCallback( "trigger_player_flashlight_zone" , AddToFlagTriggers )
	AddSpawnCallback( "trigger_player_flashlight_on"   , AddToFlagTriggers )
	AddSpawnCallback( "trigger_player_flashlight_off"  , AddToFlagTriggers )
	AddSpawnCallback( "trigger_door"				   , AddToFlagTriggers )

	AddSpawnCallback( "trigger_weaponless", 				TriggerWeaponless )	

	if ( !IsMultiplayer() )
	{
		AddSpawnCallback( "trigger_startpoint", 				TriggerStartPoint )
		AddSpawnCallback( "trigger_player_flashlight_zone", 	TriggerPlayerFlashlight )
		AddSpawnCallback( "trigger_player_flashlight_on", 		TriggerPlayerFlashlight )
		AddSpawnCallback( "trigger_player_flashlight_off", 		TriggerPlayerFlashlight )
		//AddSpawnCallback( "trigger_weaponless", 				TriggerWeaponless )		
	}
}

function AddKeyPairFunctionality( trigger )
{
	local funcs = {}
	funcs[ "scr_flagSet" ] <- TriggerFlagSet
	funcs[ "scr_flagClear" ] <- TriggerFlagClear
//	funcs[ "titan_window_melee" ] <- TriggerWindowMelee

	foreach ( key, func in funcs )
	{
		if ( trigger.HasKey( key ) )
		{
			thread func( trigger, trigger.kv[ key ] )
		}
	}
}

function AddToFlagTriggers( self )
{
	level._flagTriggers[ self ] <- self
}

function GetFlagTriggers()
{
	foreach ( guy in clone level._flagTriggers )
	{
		if ( IsValid_ThisFrame( guy ) )
			continue

		delete level._flagTriggers[ guy ]
	}

	return level._flagTriggers
}


function AddKeyPairFunctionToClass( funcs, classname )
{
	local triggers = GetEntArrayByClass_Expensive( classname )
	
	foreach ( trigger in triggers )
	{
		foreach ( key, func in funcs )
		{
			if ( trigger.HasKey( key ) )
			{
				thread func( trigger, trigger.kv[ key ] )
			}
		}	
	}	
}

function TrigerChangesFlagOnTrigger( trigger, flagString, func )
{
	trigger.EndSignal( "OnDestroy" )
	
	local flags = GetFlagsFromString( trigger, flagString )
	
	for ( ;; )
	{
		trigger.WaitSignal( "OnTrigger" )

		foreach ( flag in flags )
		{
			func( flag )
		}
	}
}

function TriggerFlagSet( trigger, flagString )
{
	thread TrigerChangesFlagOnTrigger( trigger, flagString, FlagSet )
}

function TriggerFlagClear( trigger, flagString )
{
	thread TrigerChangesFlagOnTrigger( trigger, flagString, FlagClear )
}


function TriggerFlagSetThink( trigger )
{
	TriggerInit( trigger )
	Assert( trigger.HasKey( "scr_flag" ), trigger.GetClassname() + " at " + trigger.GetOrigin() + " has no scr_flag field" )
	thread TrigerChangesFlagOnTrigger( trigger, trigger.kv.scr_flag, FlagSet )
}

function TriggerFlagClearThink( trigger )
{
	TriggerInit( trigger )
	Assert( trigger.HasKey( "scr_flag" ), trigger.GetClassname() + " at " + trigger.GetOrigin() + " has no scr_flag field" )
	thread TrigerChangesFlagOnTrigger( trigger, trigger.kv.scr_flag, FlagClear )
}

function TriggerInit( trigger )
{
	InitFlagsFromTrigger( trigger )
	AddKeyPairFunctionality( trigger )
}

function TriggerDoorSetup( trigger )
{
	TriggerInit( trigger )
	local doorName = ConnectTriggerToDoor( trigger )
	thread TriggerDoorThink( trigger, doorName )
}

function TriggerDoorThink( trigger, doorName )
{
	trigger.EndSignal( "OnDestroy" )

	while( true )
	{
		if ( !trigger.IsTouched() )
			trigger.WaitSignal( "OnStartTouch" )

		OpenDoors( doorName )
		wait 1;

		if ( trigger.IsTouched() )
			trigger.WaitSignal( "OnEndTouchAll" )

		CloseDoors( doorName )
		wait 1
	}
}

function TriggerWeaponless( trigger )
{
	TriggerInit( trigger )

	trigger.ConnectOutput( "OnStartTouch", TryDisablePlayerWeapon )
	trigger.ConnectOutput( "OnEndTouch", TryEnablePlayerWeapon )

	//thread TriggerWeaponlessThink( trigger )
}

function TriggerWeaponlessThink( trigger )
{
	trigger.EndSignal( "OnDestroy" )
	for ( ;; )
	{
		trigger.WaitSignal( "OnTrigger" )

		if ( !IsAlive( level.player ) )
			return

		if ( !( "ignoreDisableWeapon" in level.player.s ) )
			level.player.HolsterWeapon()
			
		trigger.WaitSignal( "OnEndTouchAll" )
		
		if ( !IsAlive( level.player ) )
			return

		if ( !( "ignoreDisableWeapon" in level.player.s ) )
			level.player.DeployWeapon()
	}
}

function TriggerSpawn( trigger )
{
	TriggerInit( trigger )
	thread TriggerSpawnThink( trigger )
}

function TriggerSpawnThink( trigger )
{
	printt( "Spawned trigger " + trigger )
	trigger.EndSignal( "OnDestroy" )
	
	local target = trigger.GetTarget()
	Assert( target != "", "TriggerSpawn at " + trigger.GetOrigin() + " has no target" )

	local targets = GetEntArrayByName_Expensive( target )
	
	trigger.WaitSignal( "OnTrigger" )

	foreach ( target in targets )
	{
		if ( IsValid_ThisFrame( target ) )
			SpawnFromTemplate( target )
	}
}

function GetFlagRelatedKeys()
{
	local check = []
	
	check.append( "scr_flagTrueAll" )
	check.append( "scr_flagTrueAny" )
	check.append( "scr_flagFalseAll" )
	check.append( "scr_flagFalseAny" )
	check.append( "scr_flag" )
	check.append( "scr_flagSet" )
	check.append( "scr_flagClear" )
	
	return check
}

function InitFlagMaskTriggers()
{
	local triggers = GetFlagTriggers()
	local check = GetFlagRelatedKeys()
	local flags
	local allTriggersWithFlags = {}
	
	foreach ( trigger in triggers )
	{
		if ( trigger.HasKey( "scr_flagTrueAll" ) )
		{
			Assert( !trigger.HasKey( "scr_flagTrueAny" ), "Trigger at " + trigger.GetOrigin() + " has flag all and flag any" )
		}
		else
		if ( trigger.HasKey( "scr_flagTrueAny" ) )
		{
			Assert( !trigger.HasKey( "scr_flagTrueAll" ), "Trigger at " + trigger.GetOrigin() + " has flag all and flag any" )
		}

		if ( trigger.HasKey( "scr_flagFalseAll" ) )
		{
			Assert( !trigger.HasKey( "scr_flagFalseAny" ), "Trigger at " + trigger.GetOrigin() + " has flag all and flag any" )
		}
		else
		if ( trigger.HasKey( "scr_flagFalseAny" ) )
		{
			Assert( !trigger.HasKey( "scr_flagFalseAll" ), "Trigger at " + trigger.GetOrigin() + " has flag all and flag any" )
		}

		foreach ( field in check )
		{
			if ( trigger.HasKey( field ) )
			{
				allTriggersWithFlags[ trigger ] <- true
				flags = GetFlagsFromField( trigger, field )

				foreach ( flag in flags )
				{
					if ( !( flag in level.triggersWithFlags ) )
						level.triggersWithFlags[ flag ] <- {}

					// store the triggers associated with this flag
					level.triggersWithFlags[ flag ][ trigger ] <- true
					
					// init the flag so these flags an be used in hammer more easily
					FlagInit( flag )
				}
			}
		}
	}

	foreach ( trigger, _ in allTriggersWithFlags )
	{
		SetTriggerEnableFromFlag( trigger )
	}
}

function InitFlagsFromTrigger( trigger )
{
	local check = GetFlagRelatedKeys()
	local flags

	foreach ( field in check )
	{
		if ( !trigger.HasKey( field ) )
			continue
		flags = GetFlagsFromField( trigger, field )

		foreach ( flag in flags )
		{
			// init the flag so these flags an be used in hammer more easily
			FlagInit( flag )
		}
	}
}

function TryDisablePlayerWeapon( trigger, entity, caller, value )
{
	if ( !entity.IsPlayer() )
		return

	if ( !IsAlive( entity ) )
		return

	if ( !( "ignoreDisableWeapon" in entity.s ) )
		entity.HolsterWeapon()	
}

function TryEnablePlayerWeapon( trigger, entity, caller, value )
{
	if ( !entity.IsPlayer() )
		return

	if ( !IsAlive( entity ) )
		return

	if ( entity.ContextAction_IsMeleeExecution() )
		return

	if ( !( "ignoreDisableWeapon" in entity.s ) )
		entity.DeployWeapon()
}
