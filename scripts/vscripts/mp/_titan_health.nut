const SIGNAL_TITAN_HEALTH_REGEN = "BeginTitanHealthRegen"
const SIGNAL_TITAN_SHIELD_REGEN = "BeginTitanShieldRegen"
const TITAN_HEALTH_REGEN_DELAY_MAX				= 0.7 // 2.2

// titan health system
const TITAN_HEALTH_HISTORY_FALLOFF_START = 0 	// how many seconds until shield begins to regen

function main()
{
	level.TITAN_HEALTH_HISTORY_FALLOFF_END <- 4
	Globalize( Titan_PlayerTookDamage )
	Globalize( Titan_NPCTookDamage )
	Globalize( RecordDamageToSoul )	// called when the player takes damage

	Globalize( HasHealthRegen )
	Globalize( EnableHealthRegen )
	Globalize( DisableHealthRegen )

	Globalize( PlayerHasAutoEject )
	Globalize( DropTitanHealthCore )

	Globalize( TitanShieldRegenThink )
	Globalize( TitanShieldRegenThink_Internal )

	Globalize( ShieldModifyDamage )

	RegisterSignal( SIGNAL_TITAN_HEALTH_REGEN )
	RegisterSignal( SIGNAL_TITAN_SHIELD_REGEN )
	RegisterSignal( "Doomed" )
	file.easeFunc <- Tween_ExpoEaseOut
	// GetCurrentPlaylistName() == "Titan Wave" // GetCurrentPlaylistVarInt( "new_titan_combat", 0 )
	level.newTitanCombat <- GetCurrentPlaylistVarInt( "titan_new_health", 0 )

	//tmp
	PrecacheModel( "models/containers/container_medium_tanks_blue.mdl" )
	PrecacheEffect( "hmn_cloak_friend" )

	//if ( IsMenuLevel() )
	//	return

	AddSoulInitFunc( TitanShieldRegenThink )
}

function IsRodeoDamage( soul, damageInfo )
{
	if ( GAMETYPE == COOPERATIVE )
		return IsCoopRodeoDamage( soul, damageInfo )

	local attacker = damageInfo.GetAttacker()
	if ( !attacker.IsPlayer() )
		return false

	if ( attacker.GetTitanSoulBeingRodeoed() != soul )
		return false

	return true
}

function IsCoopRodeoDamage( soul, damageInfo )
{
	local attacker 	= damageInfo.GetAttacker()
	local rider 	= soul.GetRiderEnt()

	if ( !rider )
		return false

	if ( rider == attacker )
		return true
}

function HitRodeoBrain( soul, damageInfo )
{
	local attacker = damageInfo.GetAttacker()
	if ( GAMETYPE == COOPERATIVE && !( attacker.IsPlayer() ) )
		return IsCoopRodeoDamage( soul, damageInfo )

	return damageInfo.GetHitBox() == soul.rodeoHitBoxNumber
}

function IsRodeoBrainDamage( soul, damageInfo )//Not a good solution but works for now, ttf2 titans are..difficult.
{
	if ( !IsRodeoDamage( soul, damageInfo ) )
		return false
	
	local modded_titan = false
	switch( GetSoulTitanType( soul ) )
	{
		case "special_ogre":
		case "special_atlas":
		case "special_stryder":
			modded_titan = true
			break
		
		default:
			break
	}

	if ( !HitRodeoBrain( soul, damageInfo ) && modded_titan == false )
		return false

	return true
}


function CheckRodeoRiderHitsTitan( soul, damageInfo )
{
	if ( IsRodeoDamage( soul, damageInfo )  )
	{
		//Set Last Attack Time so warning is triggered
		soul.SetLastRodeoHitTime( Time() )

		local flags = damageInfo.GetCustomDamageType()
		flags = flags | DF_RODEO
		damageInfo.SetCustomDamageType( flags )

		if ( !HitRodeoBrain( soul, damageInfo ) )
			return

		if ( ShouldMultiplyRodeoDamage( damageInfo ) )
		{
			local ent = damageInfo.GetWeapon()
			local rodeoDamageValue

			if ( !IsValid( ent ) )  //Projectile weapons don't get this set
				ent = damageInfo.GetInflictor()

			if ( !IsValid( ent ) )
				return

			if ( !( ent instanceof CProjectile || ent instanceof CWeaponX ) )
				return

			local rodeoDamageValue = ent.GetRodeoDamage()

			if ( rodeoDamageValue )
			{
				//printt( "setting rodeo damage to: " + rodeoDamageValue )
				damageInfo.SetDamage( rodeoDamageValue )
			}

			thread UpdateDamageStateOfPanel( soul )
		}
	}
}

function ShouldMultiplyRodeoDamage( damageInfo )
{
	switch ( damageInfo.GetDamageSourceIdentifier() )
	{
		case eDamageSourceId.mp_weapon_smr:
		case eDamageSourceId.mp_titanability_smoke:
		case eDamageSourceId.super_electric_smoke_screen:
		case eDamageSourceId.super_orbital_strike :
		case eDamageSourceId.super_bomb_run :
		case eDamageSourceId.mp_weapon_orbital_laser : //No need to check for TitanOrbitalLaser since you can't be rodeoing AND using a Titan Orbital laser

			return false

		case eDamageSourceId.mp_weapon_defender :
			return true
	}

	if ( damageInfo.GetCustomDamageType() & DF_EXPLOSION )
		return false

	return true
}


function ShieldHealthUpdate( titan, damageInfo, critHit )
{
	local soul = titan.GetTitanSoul()
	if ( damageInfo.GetForceKill() )
	{
		soul.SetShieldHealth( 0 )
		return 0
	}

	if ( IsRodeoBrainDamage( soul, damageInfo ) )
	{
		local damageFlags = damageInfo.GetCustomDamageType()
		damageInfo.SetCustomDamageType( damageFlags | DF_CRITICAL )
		return 0
	}

	local damage = damageInfo.GetDamage()
	local damageType = damageInfo.GetCustomDamageType()

	local soul = titan.GetTitanSoul()
	local shieldHealth = soul.GetShieldHealth()

	if ( damage >= 99 || critHit || damageType & DF_STOPS_TITAN_REGEN )
	{
		soul.s.nextRegenTime = Time() + GetShieldRegenDelay( soul )
	}
	else
	{
		if ( soul.s.nextRegenTime <= Time() + 0.5 )
			soul.s.nextRegenTime = Time() + 0.5
	}

	local shieldDamage = 0

	if ( shieldHealth )
	{
		local damageFlags = damageInfo.GetCustomDamageType()
		damageInfo.SetCustomDamageType( damageFlags | DF_SHIELD_DAMAGE )

		shieldDamage = ShieldModifyDamage( titan, damageInfo )
	}
	else
	{
		TakeAwayFriendlyRodeoPlayerProtection( titan )
	}

	return shieldDamage
}


function PlayerOrNPCTitanTookDamage( titan, damageInfo )
{
	if ( damageInfo.GetDamageSourceIdentifier() == eDamageSourceId.suicide )
		return

	// no protection from doomed health loss
	if ( damageInfo.GetCustomDamageType() & DF_DOOMED_HEALTH_LOSS )
		return

	// no protection from things that are powerful enough to skip doomed state
	if ( damageInfo.GetCustomDamageType() & DF_SKIPS_DOOMED_STATE )
		return

	if ( IsTitanWithinBubbleShield( titan ) )
	{
		damageInfo.SetDamage( 0 )
		return
	}

	// no damage force vs titans
	damageInfo.SetDamageForce( Vector(0,0,0) )

	local soul = titan.GetTitanSoul()
	CheckRodeoRiderHitsTitan( soul, damageInfo )

	DiminishComboDamage( soul, damageInfo )
}

function DiminishComboDamage( soul, damageInfo )
{
	// blunt damage from combos
	local damage = damageInfo.GetDamage()

	// this is the total damage over the past 4 seconds, with the last 2 seconds blended out
	local recentDamage = TotalDamageOverTime_BlendedOut( soul, 1.5, 3.0 )

	// damage is ramped down based on how much damage was taken recently
	local damageMod = GraphCapped( recentDamage, 2500, 5200, 1.0, 0.1 )

	//local result = damage * damageMod
	//local percent = 100 - ( ( result / damage ) * 100 ).tointeger()
	//printt( damage + " damage reduced by " + percent + " percent" )

	damageInfo.SetDamage( damage * damageMod )
}

function Titan_NPCTookDamage( titan, damageInfo )
{
	Assert( titan.IsTitan() )
	Assert( damageInfo.GetDamage() > 0 )

	// dead entities can take damage
	if ( !IsAlive( titan ) )
		return 0

	local critHit = false
	if ( CritWeaponInDamageInfo( damageInfo ) )
		critHit = IsCriticalHit( damageInfo.GetAttacker(), titan, damageInfo.GetHitBox(), damageInfo.GetDamage(), damageInfo.GetDamageType() )

	local damageType = damageInfo.GetCustomDamageType()
	if ( critHit )
	{
		damageType = damageType | DF_CRITICAL
		damageInfo.SetCustomDamageType( damageType )
	}

	PlayerOrNPCTitanTookDamage( titan, damageInfo )
	local shieldDamage = ShieldHealthUpdate( titan, damageInfo, critHit )

	DoomedStateHealthUpdate( titan, damageInfo )

	RecordDamageToSoul( titan.GetTitanSoul(), damageInfo )

	local owner = GetPetTitanOwner( titan )
	if ( IsValid( owner ) )
	{
		AutoTitan_TryMultipleTitanCallout( titan, damageInfo )
	}

	if ( titan.GetDoomedState() )
		return 0

	if ( !HasHealthRegen( titan ) )
	 	return 0

	return shieldDamage
}



function Titan_PlayerTookDamage( player, damageInfo, attacker, critHit )
{
	Assert( player.IsTitan() )

	local becameDoomed = false
	local damage = damageInfo.GetDamage()

	if ( damage <= 0 )
		return 0

	if ( !IsAlive( player ) )
		return 0

	AdjustVelocityFromHit( player, damageInfo, attacker, damage, critHit )

	if ( damageInfo.GetDamageSourceIdentifier() == eDamageSourceId.fall )
	{
		damageInfo.SetForceKill( true )
		return
	}

	if ( player.IsDemigod() )
		EntityDemigod_TryAdjustDamageInfo( player, damageInfo )

	PlayerOrNPCTitanTookDamage( player, damageInfo )
	local shieldDamage = ShieldHealthUpdate( player, damageInfo, critHit )

	DoomedStateHealthUpdate( player, damageInfo )

	if ( player.GetDoomedState() )
	{
		if ( PlayerHasAutoEject( player ) )
		{
			//printt( "Setting damage to 0 because auto eject" )
			// dont kill auto ejecting players

			damageInfo.SetDamage( 0 )
		}
	}

	return shieldDamage
}


function IsEjectProtected( player, damageInfo )
{
	if ( damageInfo.GetForceKill() )
		return false

	local damage = damageInfo.GetDamage()
	local health = player.GetHealth()
	local titanSoul = player.GetTitanSoul()

	local ejectProtectionEndTime = (titanSoul.s.doomedStartTime + TITAN_DOOMED_EJECT_PROTECTION_TIME)
	local isLethalDamage = (health - damage <= 1)

	// killing blow not allowed within eject protection time
	if ( Time() < ejectProtectionEndTime && isLethalDamage )
		return true

	// eject was in progress before the protection time was done
	if ( titanSoul.IsEjecting() )
	{
		return true
	}

	// we started trying to eject during the protection time
	if ( Time() - player.s.ejectPressTime < TITAN_EJECT_MAX_PRESS_DELAY && player.s.ejectPressTime <= ejectProtectionEndTime )
	{
		//printt( "Protected: player.s.ejectPressTime <= ejectProtectionEndTime <= ejectProtectionEndTime", player.s.ejectPressTime, ejectProtectionEndTime )
		return true
	}

	//printt( "Not Protected:", ejectProtectionEndTime )

	return false
}

function ShouldDoomTitan( entity, damageInfo, titanSoul )
{
	local damage = damageInfo.GetDamage()
	local health = entity.GetHealth()

	if ( entity.GetDoomedState() )
		return false

	if ( damageInfo.GetForceKill() )
		return false

	if ( health - damage > 1 )
		return false

	// 크리티컬 공격이라면(약점 공격) 둠상태로 가지않고 바로 터지기때문에..
	/*if (damageInfo.GetCustomDamageType() & DF_CRITICAL)
		return false;*/
	// !ky 테스트를 위해 둠 상태 스킵 비활성화

	return !( damageInfo.GetCustomDamageType() & DF_SKIPS_DOOMED_STATE )
	//
}

function DoomedStateHealthUpdate( entity, damageInfo )
{
	if ( entity.IsPlayer() && entity.IsBuddhaMode() )
		return false

	local titanSoul = entity.GetTitanSoul()

	if ( ShouldDoomTitan( entity, damageInfo, titanSoul ) )
	{
		Soul_SetLastAttackInfo( titanSoul, damageInfo )

		// Added via AddCallback_OnTitanDoomed
		foreach ( callbackInfo in level.onTitanDoomedCallbacks )
		{
			callbackInfo.func.acall( [callbackInfo.scope, entity, damageInfo ] )
		}

		local attacker = titanSoul.lastAttackInfo.attacker
		if ( IsValid( attacker ) )
			ScoreEvent_TitanKilled( entity, attacker, damageInfo.GetInflictor(), damageInfo.GetDamageSourceIdentifier(), _GetWeaponNameFromDamageInfo( damageInfo ),damageInfo.GetCustomDamageType() )

		thread DoomedHealthThink( titanSoul, damageInfo.GetDamage() )

		local health = entity.GetHealth()
		damageInfo.SetDamage( health - 1 )

		titanSoul.s.doomedStartTime <- Time()

		//doomed state effect&sound start
		PlayFXOnEntity( TITAN_DOOMED_EFFECT, entity, "exp_torso_main" )

		if ( !( "silentDeath" in entity.s ) )
			EmitSoundOnEntity( entity, "titan_death_explode" )

		//doomed state effect&sound end

		return true
	}
	else if (entity.GetDoomedState())
	{
		// as long as we're dying but not yet ejecting, the last player to damage us gets credit
		if ( titanSoul.IsEjecting() )
			Soul_SetLastAttackInfo( titanSoul, damageInfo )

		// protect players who eject early
		if ( entity.IsPlayer() && IsEjectProtected( entity, damageInfo ) )
			damageInfo.SetDamage( 0 )

		// slight protection to prevent multiple rapid damage events from eating through doomed state health
		if ( Time() - titanSoul.s.doomedStartTime < TITAN_DOOMED_INVUL_TIME && !damageInfo.GetForceKill() )
			damageInfo.SetDamage( 0 )
	}
	else
	{
		Soul_SetLastAttackInfo( titanSoul, damageInfo )
	}

	return false
}

function PlayerHasAutoEject( player )
{
	if ( player.IsBot() )
		return false

	if ( !PlayerHasPassive( player, PAS_AUTO_EJECT ) )
		return false

	return true
}


function AdjustVelocityFromHit( player, damageInfo, attacker, damage, critHit )
{
/*
	if ( damageInfo.GetDamageCriticalHitScale() > 1.0 )
	{
		// if you can crit, you have to crit!
		if ( !critHit )
			return
	}
*/

	//printt( " " )
	//printt( "damage: " + damage )

	local damageForward = damageInfo.GetDamageForce()
	damageForward.z = 0
	//printt( "damageForward " + damageForward )

	damageForward.Norm()

	local org = damageInfo.GetDamagePosition()
	//DebugDrawLine( org, org + damageForward * 250, 255, 0, 0, true, 5.0 )

	local velocity = player.GetVelocity()
	local velForward = player.GetVelocity()
	velForward.z = 0
	velForward.Norm()

	//DebugDrawLine( org, org + velForward * 250, 0, 255, 0, true, 5.0 )

	local dot = velForward.Dot( damageForward )

	// only stop from the ~front cone
	if ( dot >= -0.5 )
		return

	local speedPercent

	switch ( damageInfo.GetDamageSourceIdentifier() )
	{
//		case eDamageSourceId.mp_titanweapon_40mm:
//			speedPercent = GraphCapped( damage, 0, 750, 1, 0 )
//			break

		case eDamageSourceId.mp_titanweapon_xo16:
			speedPercent = 0.075
			break

		default:
			speedPercent = GraphCapped( damage, 0, 2500, 0, 1.0 )

	}

	//local dif = GraphCapped( dot, -1, -0.5, 1, 0 )
	//speedPercent = speedPercent * dif + ( 1.0 - dif )

	speedPercent *= GraphCapped( dot, -1.0, -0.5, 1, 0 )

	//printt( " " )
	//printt( "Damage: " + damage )
	//printt( "dot: " + dot )
	//printt( "speedPercent: " + speedPercent )
	speedPercent = 1.0 - speedPercent
	// make the dot into a tighter range
	//dot += 0.5
	//dot *= -2.0

	//printt( "modifier: " + ( speedPercent ) )
	velocity *= ( speedPercent )
	player.SetVelocity( velocity )
}



function DoomedHealthThink( titanSoul, healthSubtract )
{
	Assert( titanSoul.lastAttackInfo.attacker, "Player entered reserve health with no attacker" )

	local soulOwner = titanSoul.GetSoulOwner()
	Assert( IsValid( soulOwner ), "Invalid owner " + soulOwner )

	//if ( soulOwner.IsNPC() )
	//	soulOwner.s.preventOwnerDamage = false

	// kill any existing health regen thread
	titanSoul.Signal( SIGNAL_TITAN_HEALTH_REGEN )
	titanSoul.Signal( SIGNAL_TITAN_SHIELD_REGEN )

	titanSoul.EndSignal( "OnDestroy" )
	titanSoul.EndSignal( "OnTitanDeath" )

	local tickRate = 0.15
	local DPS = (TITAN_DOOMED_HEALTH / TITAN_DOOMED_MAX_DURATION)

	titanSoul.EnableDoomed()

	StopCoreFromChargingWhileInDoomedState( titanSoul )

	soulOwner.SetDoomed()
	DoomTitan( soulOwner )
	soulOwner.Signal( "Doomed" )
	titanSoul.Signal( "Doomed" )

	// allow the damage to go through before resetting the health, so that we get proper damage indicators, etc...
	// this process should also be in code
	WaitEndFrame()

	// grab the soul owner again since there was a wait
	local soulOwner = titanSoul.GetSoulOwner()
	if ( !IsValid( soulOwner ) )
		return

	healthSubtract = min( healthSubtract, TITAN_DOOMED_MAX_INITIAL_LOSS_FRAC * TITAN_DOOMED_HEALTH )

	soulOwner.SetHealth( max( 1, TITAN_DOOMED_HEALTH - healthSubtract ) )
	soulOwner.SetMaxHealth( TITAN_DOOMED_HEALTH )

	local settings = GetSoulPlayerSettings( titanSoul )
	local moveSpeedScale = GetPlayerSettingsFieldForClassName( settings, "doomStateMoveSpeedScale" )

	local damageMod = 1.0
	while ( 1 )
	{
		local lastAttackInfo = titanSoul.lastAttackInfo

		local extraDeathInfo = {}
		extraDeathInfo.scriptType <- DF_TITAN_GIB | DF_NO_INDICATOR | DF_DOOMED_HEALTH_LOSS
		if ( lastAttackInfo.scriptType & DF_BURN_CARD_WEAPON )
			extraDeathInfo.scriptType = extraDeathInfo.scriptType | DF_BURN_CARD_WEAPON
		if ( lastAttackInfo.scriptType & DF_VORTEX_REFIRE )
			extraDeathInfo.scriptType = extraDeathInfo.scriptType | DF_VORTEX_REFIRE

		extraDeathInfo.damageSourceId <- lastAttackInfo.damageSourceId

		local soulOwner = titanSoul.GetSoulOwner()

		if ( soulOwner.IsPlayer() )
		{
			if ( PlayerHasPassive( soulOwner, PAS_DOOMED_TIME ) )
			{
				damageMod = 0.4
				//soulOwner.SetMoveSpeedScale( 1.2 )
			}
			else
			{
				damageMod = 1.0
				//soulOwner.SetMoveSpeedScale( moveSpeedScale )
			}

			if ( PlayerHasAutoEject( soulOwner ) )
			{
				//printt( "About to Auto Eject" )
				// do it in the loop cause player could somehow get in a titan in doomed state
				thread TitanEjectPlayer( soulOwner )
				if ( titanSoul.IsEjecting() )
				{
					 // so we don't cloak the titan during the ejection animation
					if ( GetNuclearPayload( soulOwner ) > 0 )
						wait 2.0
					else
						wait 1.0

					EnableCloak( soulOwner, 7.0 )
					return
				}
			}
		}

		local dmgAmount = DPS * tickRate * damageMod

		soulOwner.TakeDamage( dmgAmount, lastAttackInfo.attacker, lastAttackInfo.inflictor, extraDeathInfo )

		wait tickRate
	}
}

function StopCoreFromChargingWhileInDoomedState( soul )
{
	// replace if needed
}


function BeginTitanHealthRegen( titan )
{
	if ( level.newTitanCombat )
		return

	local soul = titan.GetTitanSoul()

	soul.Signal( SIGNAL_TITAN_HEALTH_REGEN )
	soul.EndSignal( SIGNAL_TITAN_HEALTH_REGEN )

	soul.EndSignal( "OnDeath" )
	soul.EndSignal( "OnDestroy" )

	wait TITAN_HEALTH_REGEN_DELAY

	local soulOwner = soul.GetSoulOwner()
	if ( !IsValid( soulOwner ) )
		return

	local soulHealth = soulOwner.GetHealth()
	local maxHealth = soulOwner.GetMaxHealth()

	if ( soulHealth == soulOwner.GetMaxHealth() )
		return

	local newHealth

	// regen to full over a static time
	// regen to full based on time to heal from 0 to full
	local healthDelta = maxHealth

	local healthPerTick = healthDelta / (TITAN_HEALTH_REGEN_TIME / HEALTH_REGEN_TICK_TIME)

	while ( IsAlive( soulOwner ) && soulOwner.GetHealth() != maxHealth )
	{
		newHealth = min( soulOwner.GetHealth() + healthPerTick, maxHealth )

		soulOwner.SetHealth( newHealth )

		wait HEALTH_REGEN_TICK_TIME

		soulOwner = soul.GetSoulOwner()
	}
}

function TitanShieldRegenThink( soul, titan )
{
	thread TitanShieldRegenThink_Internal( soul, titan )

}
function TitanShieldRegenThink_Internal( soul, titan )
{
	soul.EndSignal( "OnDestroy" )
	soul.EndSignal( "Doomed" )

	soul.s.nextRegenTime <- 0


	local lastShieldHealth = soul.GetShieldHealth()
	local shieldHealthSound = false
	local maxShield = soul.GetShieldHealthMax()
	local lastTime = Time()

	while ( true )
	{
		local titan = soul.GetTitan()
		if ( !IsValid( titan ) )
			return
		local shieldHealth = soul.GetShieldHealth()
		Assert( titan )

		if ( lastShieldHealth <= 0 && shieldHealth && titan.IsPlayer() )
		{
		 	EmitSoundOnEntityOnlyToPlayer( titan, titan, "titan_energyshield_up" )
		 	shieldHealthSound = true
		 	if ( titan.IsTitan() )
		 	{
		 		GiveFriendlyRodeoPlayerProtection( titan )
		 	}
		 	else
		 	{
		 		if ( titan.IsPlayer() )
		 		{
		 			printt( "Player was " + titan.GetPlayerSettings() )
		 		}

		 		printt( "ERROR! Expected Titan, but got " + titan )
		 	}
		}
		else if ( shieldHealthSound && shieldHealth == soul.GetShieldHealthMax() )
		{
			shieldHealthSound = false
		}
		else if ( lastShieldHealth > shieldHealth && shieldHealthSound )
		{
		 	StopSoundOnEntity( titan, "titan_energyshield_up" )
		 	shieldHealthSound = false
		}

		if ( Time() >= soul.s.nextRegenTime )
		{
			local shieldRegenRate = maxShield / (GetShieldRegenTime( soul ) / SHIELD_REGEN_TICK_TIME )
			local frameTime = max( 0.0, Time() - lastTime )
			shieldRegenRate = shieldRegenRate * frameTime / SHIELD_REGEN_TICK_TIME
			// Faster shield recharge if we have Fusion Core active ability ( Stryder Signature )
			//if ( titan.IsPlayer() && PlayerHasPassive( titan, PAS_FUSION_CORE ) )
			//	shieldRegenRate *= 1.25

			soul.SetShieldHealth( min( soul.GetShieldHealthMax(), shieldHealth + shieldRegenRate ) )
		}

		lastShieldHealth = shieldHealth
		lastTime = Time()
		wait 0
	}
}

function GetShieldRegenTime( soul )
{
	local time
	local shieldRegenTime = null

	if( shieldRegenTime == null )
	{
		shieldRegenTime = TITAN_SHIELD_REGEN_TIME
	}

	if ( SoulHasPassive( soul, PAS_SHIELD_REGEN ) )
		time = shieldRegenTime * 0.5
	else
		time = shieldRegenTime

	return time
}

function GetShieldRegenDelay( soul )
{
	local delay
	local shieldRegenDelay = TITAN_SHIELD_REGEN_DELAY

	if ( SoulHasPassive( soul, PAS_SHIELD_REGEN ) )
		delay = shieldRegenDelay - 1.0
	else
		delay = shieldRegenDelay

	return delay
}

function RecordDamageToSoul( soul, damageInfo )
{
	local damage = damageInfo.GetDamage()
	local inflictor = damageInfo.GetInflictor()
	local attacker = damageInfo.GetAttacker()

	local weapon = damageInfo.GetWeapon()
	local weaponMods
	if ( IsValid( weapon ) )
		weaponMods = weapon.GetMods()

	StoreDamageHistoryAndUpdate( soul, level.TITAN_HEALTH_HISTORY_FALLOFF_END, damage, inflictor.GetOrigin(), damageInfo.GetCustomDamageType(), damageInfo.GetDamageSourceIdentifier(), attacker, weaponMods )
}



function ModifyPlayerVelocityFromDamage( player, damageInfo, minDot, maxDot, modifiedMinDot, modifiedMaxDot )
{
	local damageForward = damageInfo.GetDamageForce()
	damageForward.Norm()
	local velForward = player.GetVelocity()
	velForward.Norm()

	local dot = velForward.Dot( damageForward )
	if ( dot < minDot )
	{
		dot = GraphCapped( dot, minDot, maxDot, modifiedMinDot, modifiedMaxDot )

		local vel = player.GetVelocity()
		vel *= dot

		player.SetVelocity( vel )

		local org = player.GetOrigin()
		DebugDrawLine( org, org + vel, 255, 0, 0, true, 15.0 )
	}
}

function TotalDamageOverTime_BlendedOut( soul, start, end )
{
	// rev 3 with damage history
	local totalAcquiredDamage = 0
	local time = Time()
	local ignoreTime = time - end
	local blendOutStarts = time - start

	for ( local i = 0; i < soul.s.recentDamageHistory.len(); i++ )
	{
		local history = soul.s.recentDamageHistory[i]

		// dont care about the history past this point
		if ( history.time < ignoreTime )
			break

		local newDamage
		if ( history.damage < 0 )
		{
			newDamage = history.damage
		}
		else
		{
			newDamage = GraphCapped( history.time, blendOutStarts, ignoreTime, history.damage, 0 )
		}

		totalAcquiredDamage += newDamage
	}

	return totalAcquiredDamage
}


function HasHealthRegen( titan )
{
	Assert( "enableHealthRegen" in titan.s )
	return titan.s.enableHealthRegen
}

function EnableHealthRegen( titan )
{
	Assert( "enableHealthRegen" in titan.s )
	titan.s.enableHealthRegen = true
}

function DisableHealthRegen( titan )
{
	Assert( "enableHealthRegen" in titan.s )
	titan.s.enableHealthRegen = false
}

function DropTitanHealthCore( entity )
{
	return
	//Assert( !IsAlive( entity ) )

	local healthCore = CreateEntity( "item_healthcore" )
	healthCore.kv.model = "models/containers/container_medium_tanks_blue.mdl"
	healthCore.kv.fadedist = 10000
	healthCore.SetOrigin( entity.GetOrigin() + Vector( 0, 0, 64 ) )
	DispatchSpawn( healthCore, true )
	healthCore.SetModel( "models/containers/container_medium_tanks_blue.mdl" )

	local soul = entity.GetTitanSoul()
	Assert( IsValid( soul ), "Soul is invalid despite GetTitanSoul() returning true for entity " + target )
	local titanType = GetSoulTitanType( soul )

	healthCore.s.healthAmount <- 0

	local titanName = Native_GetTitanNameByType(titanType)
	if ( titanName != null )
	{
		healthCore.s.healthAmount = GetPlayerSettingsFieldForClassName(titanName, "healthCore")
	}
/*
	switch ( titanType )
	{
		case "scorch":
		case "ogre":
			healthCore.s.healthAmount = 3000
			break

		case "atlas":
			healthCore.s.healthAmount = 2000
			break

		case "stryder":
			healthCore.s.healthAmount = 1000
			break
	}
*/
}

function TitanHealthDrop_Heal( player, regenFrac, regenTime )
{
	player.EndSignal( "OnDestroy" )
	player.EndSignal( "OnDeath" )
	player.EndSignal( "Doomed" )

	local lastTime = Time()
	local healthPerSecond = (player.GetMaxHealth() * regenFrac) / regenTime

	while ( regenTime > 0 )
	{
		local frameTime = max( 0.0, Time() - lastTime )
		lastTime = Time()

		local newHealth = min( player.GetMaxHealth(), player.GetHealth() + (healthPerSecond * frameTime) )
		player.SetHealth( newHealth )

		regenTime -= frameTime

		wait 0
	}
}


function AutoTitan_TryMultipleTitanCallout( titan, damageInfo )
{
	if ( GAMETYPE == COOPERATIVE )
	{
		// mortar titans just do indirect fire, not necessarily at any particular titan, so these callouts sound wrong for them
		local attacker = damageInfo.GetAttacker()
		if ( IsAlive( attacker ) && attacker.IsNPC() && attacker.IsTitan() && attacker.GetSubclass() == eSubClass.mortarTitan )
			return
	}

	local titans = GetTitansHitMeInTime( titan.GetTitanSoul(), 5 )
	local enemy = titan.GetEnemy()
	if ( IsAlive( enemy )  && enemy.IsTitan() )
	{
		titans[ enemy ] <- enemy
	}

	local count = 0
	foreach ( robot in titans )
	{
		count++
	}

	if ( count > 1 )
	{
		PlayAutoTitanConversation( titan, "autotitan", "_engaged_titans" )
		return
	}

	if ( count == 1 )
	{
		PlayAutoTitanConversation( titan, "autotitan", "_engaged_titan" )
	}
}

function ShieldModifyDamage( titan, damageInfo )
{
	local soul = titan.GetTitanSoul()
	local shieldHealth = soul.GetShieldHealth()

	local damage = damageInfo.GetDamage()

	local permanentDamageFrac = TITAN_SHIELD_PERMAMENT_DAMAGE_FRAC

	local normalizeShieldDamage = false
	local dampenDamage = false

	local damageSourceIdentifier = damageInfo.GetDamageSourceIdentifier()

	switch ( damageSourceIdentifier )
	{
		case eDamageSourceId.mp_titanweapon_shotgun:
			damage *= 1.0
			break
		case eDamageSourceId.mp_titanweapon_triple_threat:
		case eDamageSourceId.mp_titanweapon_rocket_launcher:
			damage *= 0.6
			break
		case eDamageSourceId.mp_weapon_smr:
		case eDamageSourceId.mp_weapon_mgl:
		case eDamageSourceId.mp_weapon_rocket_launcher:
			damage *= 1.5
			permanentDamageFrac = TITAN_SHIELD_PERMAMENT_DAMAGE_FRAC_PILOT
			normalizeShieldDamage = true
			break
		case eDamageSourceId.mp_weapon_defender:
			damage *= 1.7
		default:
			dampenDamage = true
			break
	}

	if ( damageInfo.GetCustomDamageType() & DF_ELECTRICAL )
	{
		if ( damageSourceIdentifier == eDamageSourceId.mp_titanweapon_xo16  )
			damage *= 1.5

		if ( damageSourceIdentifier == eDamageSourceId.mp_titanweapon_triple_threat )
			damage *= 1.5

		if ( damageSourceIdentifier == eDamageSourceId.mp_weapon_mega3 )
			damage *= 1.5
	}

	local healthFrac = GetHealthFrac( titan )

	local permanentDamage = (damage * permanentDamageFrac * healthFrac)

	local shieldDamage

	if ( damageSourceIdentifier == eDamageSourceId.titanEmpField )
	{
		shieldDamage = shieldHealth
	}
	else
	{
		if ( normalizeShieldDamage )
			shieldDamage = damage * 0.5
		else
			shieldDamage = damage

		if ( SoulHasPassive( soul, PAS_SHIELD_BOOST ) )
			shieldDamage *= SHIELD_BOOST_DAMAGE_DAMPEN
	}

	local newShieldHealth = shieldHealth - shieldDamage

	soul.SetShieldHealth( max( 0, newShieldHealth ) )

	if ( shieldHealth && newShieldHealth <= 0 )
	{
		EmitSoundOnEntity( titan, "titan_energyshield_down" )
	}

	if ( newShieldHealth < 0 )
		damageInfo.SetDamage( abs( newShieldHealth ) )
	else if( dampenDamage )
		damageInfo.SetDamage( 0 )
	else
		damageInfo.SetDamage( permanentDamage )

	return min( shieldHealth, shieldDamage )
}
