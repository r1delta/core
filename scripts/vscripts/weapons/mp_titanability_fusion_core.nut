//PrecacheWeaponAssets()
const EMP_BLAST_EFFECT = "P_titan_core_atlas_blast"
const EMP_BLAST_CHARGE_EFFECT = "P_titan_core_atlas_charge"
const EMP_CORE_EFFECT = "P_titan_core_atlas_blast"
const EMP_BLAST_RADIUS = 512

//PrecacheWeaponAssets()
PrecacheParticleSystem( EMP_BLAST_CHARGE_EFFECT )
PrecacheParticleSystem( EMP_BLAST_EFFECT )
PrecacheParticleSystem( EMP_CORE_EFFECT )

is_hovering	<- false

player <- self.GetWeaponOwner()

primary_before_replace <- "mp_titanweapon_xo16"
ordnance_before_replace <- "mp_titanweapon_salvo_rockets"
special_before_replace <- "mp_titanweapon_vortex_shield"
p_mods <- []
o_mods <- []
s_mods <- []

function main()
{
	Globalize( TakePlayerWeapons )
	Globalize( RegisterPreviousWeapons )
	Globalize( ReplaceTitanWeapon )
	Globalize( HoverTitanWizardry )
}

function OnWeaponPrimaryAttack( attackParams )
{
	local ownerPlayer = self.GetWeaponOwner()
	thread PlayerUsedTitanCore( ownerPlayer )
	return 1
}

function PlayerUsedTitanCore( player )
{
	// shouldn't be possible for a dead player to use core but evidence leads us to believe that it can happen.
	if ( !IsAlive( player ) )
		return
	Assert( IsValid( player ) && player.IsPlayer() && player.IsTitan() )
	local soul = player.GetTitanSoul()
	if ( !IsValid( soul.GetTitan() ) )
		return

	if ( Time() < soul.GetNextCoreChargeAvailable() || player.GetDoomedState() )
	{
		if ( Time() > soul.GetCoreChargeExpireTime() && IsClient() )
			TitanCockpit_PlayDialog( player, "core_denied" )
		return
	}

	if ( IsClient() )
	{
		thread CoreActivatedVO( player )
		return
	}

	player.EndSignal( "Disconnected" )
	soul.EndSignal( "OnDeath" )
	soul.EndSignal( "OnDestroy" )
	soul.EndSignal( "OnTitanDeath" )
	soul.EndSignal( "Doomed" )

	local marathon = PlayerHasPassive( player, PAS_MARATHON_CORE )

	local coreDuration = GetTitanCoreActiveTime( player )
	local coreWaitTime = coreDuration + TITAN_CORE_CHARGE_TIME
	soul.SetCoreChargeExpireTime( Time() + coreWaitTime )
	soul.SetNextCoreChargeAvailable( Time() + 1000 )

	local passive
	local startSoulFunc, startPlayerFunc
	local endSoulFunc, endPlayerFunc

	//MODDED

	switch ( player.GetPlayerSettingsField( "footstep_type" ) )
	{
		case "ogre":
			passive = PAS_SHIELD_BOOST
			startSoulFunc = StartShieldCore
			break

		case "atlas":
			passive = PAS_FUSION_CORE
			startSoulFunc = StartDamageCore
			endSoulFunc = EndDamageCore
			break

		case "stryder":
			passive = PAS_FUSION_CORE
			startPlayerFunc = StartDashCore
			endPlayerFunc = EndDashCore
			break
		
		/*case "missile_core":
			passive = PAS_FUSION_CORE
			startSoulFunc = StartMissileCore
			endSoulFunc = EndMissileCore
			break
		
		case "smart_core":
			passive = PAS_FUSION_CORE
			startSoulFunc = StartSmartCore
			endSoulFunc = EndSmartCore
			break
		
		case "bullet_storm":
			passive = PAS_FUSION_CORE
			startSoulFunc = StartBulletStormCore
			endSoulFunc = EndBulletStormCore
			break
		
		case "piercer_core":
			passive = PAS_FUSION_CORE
			startSoulFunc = StartPiercerCore
			endSoulFunc = EndPiercerCore
			break
		
		case "auto_burst_core":
			passive = PAS_FUSION_CORE
			startSoulFunc = StartAutoBurstCore
			endSoulFunc = EndAutoBurstCore
			break
		
		case "flight_core":
			passive = PAS_FUSION_CORE
			startSoulFunc = StartFlightCore
			endSoulFunc = EndFlightCore
			break*/
		
		default:
			passive = PAS_FUSION_CORE
			local loop_max = MasterModdedTitans.len()
			for( local E = 0; E < loop_max; E++ )
			{
				if( loop_max > 0 )
				{
					local t_a = MasterModdedTitans[ E ]

					if( t_a.setfile == GetSoulPlayerSettings( soul ) )
					{
						if( t_a.core_start != null && t_a.core_end != null )
						{
							startSoulFunc = t_a.core_start
							endSoulFunc = t_a.core_end
							printl("EEEEEEEEEEEEEEEEEEEE")
							printl( startSoulFunc )
							break
						}
					}
				}
			}
			//startSoulFunc = StartDamageCore
			//endSoulFunc = EndDamageCore
			//printl("AAAAAAAAAAAAAAAAAA")
			//break
	}

	SetCoreEffect( player, CreateChargeEffect )

	OnThreadEnd(
		function() : ( player, soul, passive, startSoulFunc, startPlayerFunc, endSoulFunc, endPlayerFunc )
		{
			if ( IsValid( soul ) )
			{
				soul.SetNextCoreChargeAvailable( Time() + TITAN_CORE_BUILD_TIME )

				if ( passive != null )
					TakePassive( soul, passive )

				if ( endSoulFunc != null )
					endSoulFunc( soul )


				if ( "coreEffect" in soul.s && IsValid( soul.s.coreEffect.ent ) )
				{
					soul.s.coreEffect.ent.Kill()
				}

				delete soul.s.coreEffect
			}

			if ( IsValid( player ) )
			{
				StopSoundOnEntity( player, EMP_BLAST_CHARGE_SOUND )
				if ( endPlayerFunc != null )
					endPlayerFunc( player )
			}
		}
	)

	local titan = soul.GetTitan()
	EmitSoundOnEntity( titan, EMP_BLAST_CHARGE_SOUND )

	wait TITAN_CORE_CHARGE_TIME

	if ( IsValid( titan ) )
		StopSoundOnEntity( titan, EMP_BLAST_CHARGE_SOUND )

	titan = soul.GetTitan()
	if ( !IsAlive( titan ) )
		return

	if ( marathon )
		EmitSoundOnEntity( titan, "Titan_CoreAbility_Sustain_Long" )
	else
		EmitSoundOnEntity( titan, "Titan_CoreAbility_Sustain" )

	PhysicsBlast( titan )
	BlastScreenShake( titan )
	//PushEverythingAway( titan )

	SetCoreEffect( titan, CreateCoreEffect )

	if ( passive != null )
		GivePassive( soul, passive )

	// Shields start charging right away
	soul.s.nextRegenTime = Time()

	if ( startSoulFunc != null && IsValid( soul ) )
		startSoulFunc( soul )

	if ( IsAlive( player ) )
	{
		if ( startPlayerFunc != null )
			startPlayerFunc( player )

		if ( player.IsTitan() )
			thread CoreColorCorrection( player, soul, coreDuration )
	}

	wait coreDuration
}

function SetCoreEffect( titan, func )
{
	Assert( IsAlive( titan ) )
	Assert( titan.IsTitan() )
	local soul = titan.GetTitanSoul()
	local chargeEffect = func( titan )
	if ( "coreEffect" in soul.s )
	{
		soul.s.coreEffect.ent.Kill()
	}
	else
	{
		soul.s.coreEffect <- null
	}

	soul.s.coreEffect = { ent = chargeEffect, func = func }
}

////////////////////////////////////////////////////////////////////////
// custom core functions
////////////////////////////////////////////////////////////////////////

//how kind of the devs to segment it.

function StartShieldCore( soul )
{
	local health = soul.GetShieldHealthMax()
	soul.SetShieldHealth( health )
}

function StartDamageCore( soul )
{
	AddToTitanDamageScaling( soul, 1.4 )
}

function EndDamageCore( soul )
{
	ClearTitanDamageScaling( soul )
}

function EndDashCore( player )
{
	player.SetDodgePowerDelayScale( 1.0 )
	player.SetPowerRegenRateScale( 1.0 )
}

function StartDashCore( player )
{
	// Dash recharges fast
	player.SetDodgePowerDelayScale( 0.05 )
	player.SetPowerRegenRateScale( 16.0 )
}
/*
function EndMissileCore( soul )
{
	local titan = soul.GetTitan()

	TakePlayerWeapons( soul, "ordnance" )
	TakePlayerWeapons( soul, "special" )

	thread ReplaceTitanWeapon( titan, ordnance_before_replace, o_mods, "ordnance" )
	thread ReplaceTitanWeapon( titan, special_before_replace, s_mods, "special" )
}

function StartMissileCore( soul )
{
	local titan = soul.GetTitan()
	RegisterPreviousWeapons( titan )
	local ordnance = titan.GetOffhandWeapon( 0 )
	local special = titan.GetOffhandWeapon( 1 )
	
	local ordnance_name = ordnance.GetWeaponClassName()
	local special_name = special.GetWeaponClassName()
	if ( ordnance_name == "mp_titanweapon_shoulder_turret" )
	{
		if( special_name == "mp_titanweapon_salvo_rockets" )
		{
			ordnance_name = "mp_titanweapon_shoulder_rockets"
		}
		else
		{
			ordnance_name = "mp_titanweapon_salvo_rockets"
		}
	}
	//switch( ordnance.GetWeaponClassName() )
	//{
		
	//}
	TakePlayerWeapons( soul, "ordnance" )
	TakePlayerWeapons( soul, "special" )

	thread ReplaceTitanWeapon( titan, ordnance_name, ["dev_mod_low_recharge"], "ordnance" )
	thread ReplaceTitanWeapon( titan, special_name, ["dev_mod_low_recharge"], "special" )
}//why tf did i make missile core again?

function EndSmartCore( soul )
{
	local titan = soul.GetTitan()
	local player = self.GetWeaponOwner()
	local weapon = titan.GetActiveWeapon().GetWeaponClassName()

	if ( weapon != null )
	{
		titan.TakeWeapon( weapon )
	}
	thread ReplaceTitanWeapon( titan, primary_before_replace, p_mods, "primary" )
}

function StartSmartCore( soul )//do i use minigun....do i use XO16? do i use... idk
{
	local titan = soul.GetTitan()
	RegisterPreviousWeapons( titan )
	local player = self.GetWeaponOwner()
	local weapon = titan.GetActiveWeapon().GetWeaponClassName()
	if ( weapon != null )
	{
		titan.TakeWeapon( weapon )
	}//one of these days a mf gonna make a smart 40mm cannon
	thread ReplaceTitanWeapon( titan, "mp_titanweapon_xo16", ["smart_core"], "primary" )

	//titan.GiveWeapon( "mp_weapon_mega3", ["smart_core"] )//super smort
	//shit, i got a calculating bitfield error, hol on. the _passives_shared doesnt include gun passives though..., not so smort now ;-;
}
*/

/*
function EndBulletStormCore( soul )
{
	local titan = soul.GetTitan()
	local player = self.GetWeaponOwner()
	local weapon = player.GetActiveWeapon().GetWeaponClassName()

	if ( weapon != null )
	{
		titan.TakeWeapon( weapon )
	}
	thread ReplaceTitanWeapon( titan, primary_before_replace, p_mods, "primary" )
}

function StartBulletStormCore( soul )//do i use minigun....do i use XO16? do i use... idk
{
	local titan = soul.GetTitan()
	RegisterPreviousWeapons( titan )
	local player = self.GetWeaponOwner()
	local weapon = player.GetActiveWeapon().GetWeaponClassName()
	if ( weapon != null )
	{
		titan.TakeWeapon( weapon )
	}
	thread ReplaceTitanWeapon( titan, "mp_titanweapon_xo16", ["bullet_storm"], "primary" )
}
*/

function EndPiercerCore( soul )
{
	local titan = soul.GetTitan()
	local player = self.GetWeaponOwner()

	TakePlayerWeapons( soul, "ordnance" )
	
	thread ReplaceTitanWeapon( titan, ordnance_before_replace, o_mods, "ordnance" )
}

function StartPiercerCore( soul )//decided they should have their shields with it since Ion is energy based.
{
	local titan = soul.GetTitan()
	RegisterPreviousWeapons( titan )
	TakePlayerWeapons( soul, "ordnance" )
	thread ReplaceTitanWeapon( titan, "mp_weapon_mega4", ["piercer_core"], "ordnance" )
}

function EndAutoBurstCore( soul )
{
	local titan = soul.GetTitan()
	TakePlayerWeapons( soul, "primary" )
	thread ReplaceTitanWeapon( titan, primary_before_replace, p_mods, "primary" )
}

function StartAutoBurstCore( soul )//do i use minigun....do i use XO16? do i use... idk
{
	local titan = soul.GetTitan()
	RegisterPreviousWeapons( titan )
	TakePlayerWeapons( soul, "primary" )
	thread ReplaceTitanWeapon( titan, "mp_titanweapon_shotgun", ["auto_burst"], "primary" )
}

function EndFlightCore( soul )
{
	is_hovering <- false
	local titan = soul.GetTitan()
	
	TakePlayerWeapons( soul, "ordnance" )
	TakePlayerWeapons( soul, "special" )

	thread ReplaceTitanWeapon( titan, ordnance_before_replace, o_mods, "ordnance" )
	thread ReplaceTitanWeapon( titan, special_before_replace, s_mods, "special" )
}

function StartFlightCore( soul )
{
	local titan = soul.GetTitan()
	RegisterPreviousWeapons( titan )
	local player = self.GetWeaponOwner()
	is_hovering <- true
	thread HoverTitanWizardry( player, soul, 650 )// hmmm might be able to replace with titan

	local player_ordnance = "mp_titanweapon_salvo_rockets"
	local player_tactical = "mp_titanweapon_shoulder_rockets"
	
	TakePlayerWeapons( soul, "ordnance" )
	TakePlayerWeapons( soul, "special" )

	thread ReplaceTitanWeapon( titan, player_ordnance, [ "mod_ordnance_core", "burn_mod_titan_salvo_rockets" ], "ordnance" )
	thread ReplaceTitanWeapon( titan, player_tactical, [ "mod_ordnance_core", "burn_mod_titan_shoulder_rockets" ], "special" )
}

function HoverTitanWizardry( player, soul, vel_z )
{
	local subtractor = 10
	local seconds_flight_ease = 0.05
	//player.kv.gravity = 0.0
	local vel = player.GetVelocity()
	vel.z = vel_z
	player.SetVelocity( vel )
	wait( seconds_flight_ease )
	//player.kv.gravity = 0.0
	if ( vel_z > 3 && is_hovering == true )
	{
		if ( vel_z < subtractor )
		{
			vel_z = 3
		}
		else
		{
			vel_z -= subtractor
		}
		HoverTitanWizardry( player, soul, vel_z )
		return
	}
	else if ( is_hovering == true ) //TitanCoreInUse( player )
	{
		HoverTitanWizardry( player, soul, vel_z )
		return
	}
	return
}

function RegisterPreviousWeapons( titan )
{
	primary_before_replace <- titan.GetActiveWeapon().GetWeaponClassName()
	ordnance_before_replace <- titan.GetOffhandWeapon( 0 ).GetWeaponClassName()
	special_before_replace <- titan.GetOffhandWeapon( 1 ).GetWeaponClassName()
	p_mods <- titan.GetActiveWeapon().GetMods()
	o_mods <- titan.GetOffhandWeapon( 0 ).GetMods() //mods
	s_mods <- titan.GetOffhandWeapon( 1 ).GetMods() //mods
}

function TakePlayerWeapons( soul, weapon_type )
{
	local titan = soul.GetTitan()
	switch ( weapon_type )
	{
		case "primary":
			local weapon = titan.GetActiveWeapon().GetWeaponClassName()

			if ( weapon != null )
			{
				titan.TakeWeapon( weapon )
			}
			return
		
		case "ordnance":
			local weapon = titan.GetOffhandWeapon( 0 )
			if ( weapon != null )
			{
				titan.TakeWeapon( weapon )
			}
			return
		
		case "special":
			local weapon = titan.GetOffhandWeapon( 1 )
			if ( weapon != null )
			{
				titan.TakeWeapon( weapon )
			}
			return
	}
}

function ReplaceTitanWeapon( titan, weapon, mods, slot_string )
{
	wait( 0.5 )//I am a wizard, who conjours magic numbers

	if ( !IsAlive( titan ) || !IsValid( titan ) || titan == null )
		return

	switch ( slot_string )
	{
		case "primary":
			if ( weapon == null )
			{
				weapon = "mp_titanweapon_xo16"
			}

			titan.GiveWeapon( weapon, mods )
			local player = self.GetWeaponOwner()
			player.SetActiveWeapon( weapon )
			return
		
		case "ordnance":
			if ( weapon == null )
			{
				weapon = "mp_titanweapon_salvo_rockets"
			}

			titan.GiveOffhandWeapon( weapon, 0, mods )
			return
		
		case "special":
			if ( weapon == null )
			{
				weapon = "mp_titanweapon_vortex_shield"
			}

			titan.GiveOffhandWeapon( weapon, 1, mods )
			return
	}
	return
}

//References
//TakeOffhandWeapon( slot_num )
//GiveOffhandWeapon( weapon, slot_num, mods )
//GetOffhandWeapon( slot_num )
//player.GetActiveWeapon()
//ReplaceActiveWeapon( name )

//EX:  titan.GetOffhandWeapon( 0 ) this is ordnance, 1 is special

////////////////////////////////////////////////////////////////////////
// core fx and color correction
////////////////////////////////////////////////////////////////////////
function CreateCoreEffect( player )
{
	Assert( player.IsTitan() )

	local chargeEffect = CreateEntity( "info_particle_system" )
	chargeEffect.kv.start_active = 1
	chargeEffect.kv.VisibilityFlags = 6 // everyone but owner
	chargeEffect.kv.effect_name = EMP_CORE_EFFECT
	chargeEffect.SetName( UniqueString() )
	chargeEffect.SetParent( player, "hijack", false, 0 )
	chargeEffect.SetOwner( player )
	DispatchSpawn( chargeEffect, false )
	return chargeEffect
}


function CreateChargeEffect( player )
{
	Assert( player.IsTitan() )

	local chargeEffect = CreateEntity( "info_particle_system" )
	chargeEffect.kv.start_active = 1
	chargeEffect.kv.VisibilityFlags = 6 // everyone but owner
	chargeEffect.kv.effect_name = EMP_BLAST_CHARGE_EFFECT
	chargeEffect.SetName( UniqueString() )
	chargeEffect.SetParent( player, "hijack", false, 0 )
	chargeEffect.SetOwner( player )
	DispatchSpawn( chargeEffect, false )
	return chargeEffect
}

function CoreColorCorrection( player, soul, duration )
{
	player.EndSignal( "OnDeath" )
	player.EndSignal( "Disconnected" )
	player.EndSignal( "TitanEjectionStarted" )
	player.EndSignal( "SettingsChanged" )
	soul.EndSignal( "Doomed" )
	soul.EndSignal( "OnDestroy" )

	local colorCorrection	= GetColorCorrectionByFileName( player, "materials/correction/overdrive1.raw" )

	if ( !colorCorrection )
		return null

	local fadeInDuration = 0.5
	local fadeOutDuration = 0.5
	local colorTime = duration
	local maxweight = 1
	local isMaster = 0

	colorCorrection.kv.fadeInDuration = fadeInDuration
	colorCorrection.kv.fadeOutDuration = fadeOutDuration
	colorCorrection.kv.maxweight = maxweight
	colorCorrection.kv.spawnflags = isMaster

	colorCorrection.Fire( "Enable" )
	colorCorrection.Fire( "Disable", "", colorTime + fadeInDuration )

	OnThreadEnd(
		function() : ( colorCorrection )
		{
			if ( !IsValid( colorCorrection ) )
				return

			colorCorrection.Fire( "Disable" )
		}
	)

	wait duration + fadeInDuration + fadeOutDuration + 1.0
}


////////////////////////////////////////////////////////////////////////
// Core-start effect functions
////////////////////////////////////////////////////////////////////////


function PhysicsBlast( titan )
{
	// Physics explosion
	local knockback = CreateEntity( "env_physexplosion" )
	knockback.kv.magnitude = 2500
	knockback.kv.radius = EMP_BLAST_RADIUS
	knockback.kv.spawnflags = 3 //11 // No Damage - Only Force, Push Players, Test LOS
	knockback.SetName( UniqueString() )
	knockback.SetOrigin( titan.GetOrigin() + Vector( 0, 0, 32 ) )
	knockback.SetTeam( titan.GetTeam() )
	DispatchSpawn( knockback, false )
	knockback.Fire( "Explode" )
	knockback.Kill( 2.0 )
}

function BlastScreenShake( titan )
{
	// Screen shake
	local amplitude = 16
	local frequency = 5.0
	local duration = 2.0
	local radius = 1500
	local shake = CreateShake( titan.GetOrigin(), amplitude, frequency, duration, radius )
	shake.SetParent( titan, "CHESTFOCUS" )
	shake.Kill( 3.0 )
}

function PushEverythingAway( titan )
{
	// Push everything away
	local pushableEnts = []
	pushableEnts.extend( GetPlayerArray() )
	pushableEnts.extend( GetNPCArray() )

	local radiusSq = EMP_BLAST_RADIUS * EMP_BLAST_RADIUS
	local dist
	local maxPushBackScale
	local upVel
	local targetVelocity
	local directionVec
	local settings

	local team = titan.GetTeam()
	local soul = titan.GetTitanSoul()

	foreach ( ent in pushableEnts )
	{
		if ( ent.GetTeam() == team )
			continue

		dist = DistanceSqr( ent.GetOrigin(), titan.GetOrigin() )
		if ( dist >= radiusSq )
			continue

		upVel = ent.IsTitan() ? 100 : 50

		if ( IsPilot( ent ) )
		{
			if ( ent.GetPetTitan() == titan )
				continue

			maxPushBackScale = 250
			if ( ent.GetTitanSoulBeingRodeoed() == soul )
			{
				ent.Signal( "RodeoOver" )
				ent.ClearParent()
			}
		}
		else if ( ent.IsTitan() )
		{
			settings = ent.GetPlayerSettings()
			maxPushBackScale = GetPlayerSettingsFieldForClassName( settings, "meleePushback" ) * TITAN_CORE_PUSHBACK_MULTIPLIER_VS_TITANS
		}
		else
		{
			maxPushBackScale = 400
		}

		if ( ent.GetTeam() == titan.GetTeam() )
			maxPushBackScale *= 0.2

		maxPushBackScale = GraphCapped( dist, 0, radiusSq, maxPushBackScale * 2.0, maxPushBackScale * 0.5 )

		directionVec = ( ent.GetOrigin() + Vector( 0, 0, upVel ) ) - titan.GetOrigin()
		directionVec.Norm()

		targetVelocity = ent.GetVelocity()
		targetVelocity += directionVec * maxPushBackScale

		//targetVelocity = ClampVerticalVelocity( targetVelocity, TITAN_MELEE_MAX_VERTICAL_PUSHBACK  )
		ent.SetVelocity( targetVelocity )
	}
}

main()
