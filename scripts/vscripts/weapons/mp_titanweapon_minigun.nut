AMMO_BODYGROUP_COUNT <- 6
chargeDownSoundDuration <- 1.0

RegisterSignal( "OnDeactivate" )
const MINIGUN_COOL_DELAY = 0.5
const TITAN_SLOW_SPEED = 0.5
const MINIGUN_REGEN_RATE = 20.0 

function OnWeaponActivate( activateParams )
{
    UpdateViewmodelAmmo()
    
    // Initialize tracking variables if they don't exist
    local vars = ["lastFireTime", "overheatEndTime", "lastRegenTime", "partialAmmo"]
    foreach( v in vars ) if ( !( v in self.s ) ) self.s[v] <- 0
    
    local bools = ["overheatNotificationShown", "clientOverheatNotified", "wasOverheating"]
    foreach( b in bools ) if ( !( b in self.s ) ) self.s[b] <- false

    thread MinigunMovementThink( self )
}

function OnWeaponDeactivate( deactivateParams )
{
    self.Signal( "OnDeactivate" )

    if ( IsServer() )
    {
        local owner = self.GetWeaponOwner()
        if ( IsValid( owner ) ) owner.SetMoveSpeedScale( 1.0 )
    }

    if ( IsClient() )
    {
        local owner = self.GetWeaponOwner()
        if ( IsValid( owner ) && owner == GetLocalViewPlayer() && !owner.GetDoomedState() )
        {
            local cockpit = owner.GetCockpit()
            if ( IsValid( cockpit ) && "crosshairHealthLabel" in cockpit.s )
                cockpit.s.crosshairHealthLabel.Hide()
        }
    }
}

function MinigunMovementThink( weapon )
{
    weapon.EndSignal( "OnDestroy" )
    weapon.EndSignal( "OnDeactivate" )

    local isServer = IsServer()
    local isClient = IsClient()

    while ( true )
    {
        local owner = weapon.GetWeaponOwner()
        if ( IsValid( owner ) )
        {
            if ( isServer && !owner.IsNPC() )
                ServerMinigunLogic( weapon, owner )
            else if ( isClient && owner == GetLocalViewPlayer() )
                ClientMinigunLogic( weapon, owner )
        }
        wait 0.025
    }
}

function ServerMinigunLogic( weapon, owner )
{
    local currentTime = Time()
    local hasExtAmmo = weapon.HasMod( "extended_ammo" )
    local maxAmmo = hasExtAmmo ? 120 : 100
    local reloadTime = hasExtAmmo ? 6.0 : 5.0

    // Overheat logic
    if ( currentTime < weapon.s.overheatEndTime )
    {
        weapon.SetNextAttackAllowedTime( weapon.s.overheatEndTime )
        owner.SetMoveSpeedScale( 1.0 )

        local fillRatio = 1.0 - ((weapon.s.overheatEndTime - currentTime) / reloadTime)
        weapon.SetWeaponPrimaryClipCount( max( 0, (fillRatio * maxAmmo).tointeger() ) )
        
        if ( !weapon.s.overheatNotificationShown )
        {
            EmitSoundOnEntity( owner, "titan_dryfire" )
            weapon.s.overheatNotificationShown = true
        }
        return
    }

    // Normal operation
    weapon.s.overheatNotificationShown = false
    local isFiring = (currentTime - weapon.s.lastFireTime < 0.25)
    
    owner.SetMoveSpeedScale( isFiring ? TITAN_SLOW_SPEED : 1.0 )

    // Ammo regen logic
    if ( !isFiring )
    {
        local currentAmmo = weapon.GetWeaponPrimaryClipCount()
        if ( currentAmmo < maxAmmo && (currentTime - weapon.s.lastFireTime > MINIGUN_COOL_DELAY) )
        {
            weapon.s.partialAmmo += ((currentTime - weapon.s.lastRegenTime) * MINIGUN_REGEN_RATE)
            local ammoToAdd = weapon.s.partialAmmo.tointeger()

            if ( ammoToAdd > 0 )
            {
                weapon.SetWeaponPrimaryClipCount( min( maxAmmo, currentAmmo + ammoToAdd ) )
                weapon.s.partialAmmo -= ammoToAdd
            }
        }
        else
        {
            weapon.s.partialAmmo = 0.0
        }
    }
    weapon.s.lastRegenTime = currentTime
}

function ClientMinigunLogic( weapon, owner )
{
    local cockpit = owner.GetCockpit()
    if ( !IsValid( cockpit ) || !("crosshairHealthLabel" in cockpit.s) || owner.GetDoomedState() )
        return

    local isOverheated = (Time() < weapon.s.overheatEndTime)
    
    if ( isOverheated && !weapon.s.clientOverheatNotified )
    {
        cockpit.s.crosshairHealthLabel.SetText( "[WEAPON OVERHEATED]" )
        cockpit.s.crosshairHealthLabel.SetColor( 255, 50, 50, 255 )
        cockpit.s.crosshairHealthLabel.Show()
        weapon.s.clientOverheatNotified = true
    }
    else if ( !isOverheated && weapon.s.clientOverheatNotified )
    {
        cockpit.s.crosshairHealthLabel.Hide()
        weapon.s.clientOverheatNotified = false
    }
}

function OnWeaponPrimaryAttack( attackParams )
{
    self.s.lastFireTime = Time()
    self.FireWeaponBullet( attackParams.pos, attackParams.dir, 1, damageTypes.Electric | DF_STOPS_TITAN_REGEN )

    if ( self.GetWeaponPrimaryClipCount() <= 1 )
    {
        self.s.overheatEndTime = Time() + (self.HasMod( "extended_ammo" ) ? 6.0 : 5.0)
        if ( IsServer() )
        {
            self.SetNextAttackAllowedTime( self.s.overheatEndTime )
            self.SetWeaponPrimaryClipCount( 0 )
        }
    }
}

function OnWeaponNpcPrimaryAttack( attackParams )
{
    self.s.lastFireTime = Time()
    self.SetNextAttackAllowedTime( Time() + (1.0 / 15.0) )
    self.FireWeaponBullet( attackParams.pos, attackParams.dir, 1, damageTypes.Electric | DF_STOPS_TITAN_REGEN )
    self.SetWeaponPrimaryClipCount( 100 )

    return 1
}

function OnWeaponChargeBegin( chargeParams )
{
    StopSoundOnEntity( self, "Weapon_Titan_Sniper_WindDown" )
    if( IsClient() )
        EmitSoundOnEntityWithSeek( self, "Weapon_Titan_Sniper_WindUp", self.GetWeaponChargeTime() )
}

function OnWeaponChargeEnd( chargeParams )
{
    StopSoundOnEntity( self, "Weapon_Titan_Sniper_SustainLoop" )
    StopSoundOnEntity( self, "Weapon_Titan_Sniper_WindUp" )
}

function OnWeaponStartZoomIn() { HandleWeaponSoundZoomIn( self, "Weapon_40mm.ADS_In" ) }
function OnWeaponStartZoomOut() { HandleWeaponSoundZoomOut( self, "Weapon_40mm.ADS_Out" ) }

function OnWeaponOwnerChanged( changeParams )
{
	if ( IsClient() && changeParams.newOwner == GetLocalViewPlayer() )
		UpdateViewmodelAmmo()
}
