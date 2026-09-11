//PrecacheWeaponAssets()
const GROUNDED_UPDATE_SPEED = 0.05
const HOVER_FORCE_MINIMUM = 3
//( INIT / SUBR ) * C.U.S = height gained roughly
FORCE_INIT	<- 350
FORCE_SUBTR	<- 10
is_hovering	<- false
init_hovered <- false
intend_hover <- false
CUR_FORCE	<- 0

hover_loop_active <- false

//current_owner <- null


function OnWeaponActivate( activateParams )
{
	//current_owner <- self.GetWeaponOwner()
	//thread HoverThink( player )
	FORCE_INIT	<- self.GetWeaponModSetting( "damage_near_distance" )
	FORCE_SUBTR	<- self.GetWeaponModSetting( "damage_far_distance" )

	//SetLoopingWeaponSound_1p3p( "Weapon.XO16_fire_first", "Weapon.XO16_fire_loop", "Weapon.XO16_fire_last",
								//"Weapon.XO16_fire_first_3P", "Weapon.XO16_fire_loop_3P", "Weapon.XO16_fire_last_3P" )
}

function OnWeaponDeactivate( deactivateParams )
{
	hover_loop_active <- false
	//self.StopWeaponSound( "titan_dash_close" ) // idk about sound honestly
	self.StopWeaponSound( "Vortex_Shield_Loop" )
	//HoverToggle( false )
	intend_hover <- false
}

function OnWeaponChargeBegin( chargeParams ) //OnWeaponPrimaryAttack( attackParams )
{
	//HoverToggle( true )
	//local player = self.GetWeaponOwner()
	//thread HoverThink( player )
	//if ( self.GetWeaponChargeFraction() < 1 )
		//self.EmitWeaponSound( "titan_dash_close" )
	self.EmitWeaponSound( "Vortex_Shield_Loop" ) //Vortex_Shield_Loop shieldwall_loop
	if ( IsClient() )
	{
		return
	}
	if ( hover_loop_active == false )
	{
		hover_loop_active <- true
		thread HoverThink()
	}
	intend_hover <- true

	//if ( player.IsOnGround() && is_hovering == false )
	//{
	//	init_hovered <- false
	//}
	/*if ( intend_hover == true && player.IsTitan() )
	{
		is_hovering <- true
		if ( init_hovered == false )
		{
			init_hovered <- true
			HoverTitanWizardry( player, FORCE_INIT )
			return
		}
		else if ( is_hovering == true )
		{
			HoverTitanWizardry( player, CUR_FORCE )
			return
		}
	}
	else
	{
		is_hovering <- false
	}
	return*/
}

function OnWeaponChargeEnd( chargeParams )
{
	intend_hover <- false
	//self.StopWeaponSound( "titan_dash_close" ) // idk about sound honestly
	self.StopWeaponSound( "Vortex_Shield_Loop" )
	//self.EmitWeaponSound( "Vortex_Shield_Empty" )
	return
}

/*function HoverToggle( is_active ) //OnWeaponPrimaryAttack( attackParams )
{
	intend_hover <- is_active
}*/

function HoverThink()
{
	Assert( IsServer() )

	if ( hover_loop_active == false )
		return
	
	if ( !IsValid( self.GetWeaponOwner() ) )
		return

	local player = self.GetWeaponOwner()

	if ( player == null || !IsValid( player ))
		return

	if ( player.IsOnGround() && is_hovering == false )
	{
		init_hovered <- false
	}
	
	if ( intend_hover == true && player.IsTitan() )
	{
		is_hovering <- true
		if ( init_hovered == false )
		{
			init_hovered <- true
			HoverTitanWizardry( player, FORCE_INIT )
			wait( GROUNDED_UPDATE_SPEED )
			HoverThink()
			return
		}
		else if ( is_hovering == true )
		{
			HoverTitanWizardry( player, CUR_FORCE )
			wait( GROUNDED_UPDATE_SPEED )
			HoverThink()
			return
		}
	}
	else
	{
		is_hovering <- false
	}
	wait( GROUNDED_UPDATE_SPEED )
	if ( hover_loop_active == false )
		return
	HoverThink()
	return
}

function HoverTitanWizardry( player, vel_z )//actually why call player if this IS the player?
{
	Assert( IsServer() )
	local vel = player.GetVelocity()
	vel.z = vel_z
	player.SetVelocity( vel )
	if ( vel_z > HOVER_FORCE_MINIMUM && is_hovering == true )
	{
		if ( vel_z < FORCE_SUBTR )
		{
			vel_z = HOVER_FORCE_MINIMUM
		}
		else
		{
			vel_z -= FORCE_SUBTR
		}
		CUR_FORCE <- vel_z
		return
	}
	else if ( is_hovering == true ) //TitanCoreInUse( player )
	{
		CUR_FORCE <- vel_z
		return
	}
	return
}

function OnWeaponOwnerChanged( changeParams )
{
	intend_hover <- false
	//current_owner <- self.GetWeaponOwner()
}

/*function HoverTitanWizardry( player, vel_z )
{
	local seconds_flight_ease = 0.05
	local vel = player.GetVelocity()
	vel.z = vel_z
	player.SetVelocity( vel )
	wait( seconds_flight_ease )
	if ( vel_z > 1 && is_hovering == true )
	{
		if ( vel_z < FORCE_SUBTR )
		{
			vel_z = 1
		}
		else
		{
			vel_z -= FORCE_SUBTR
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
}*/

function CooldownBarFracFunc()
{
	if ( IsValid( self ) )
	{
		return 1.0 - ( self.GetWeaponChargeFraction() * 1.0 )
	}
	return 0
}