TITAN_EJECT_SCREECH	<- "titan_eject_screech"
TITAN_DECAY_LIMIT	<- 0.35 // should be the same as the frac that flames start.

const TITAN_NUCLEAR_CORE_FX_3P = "P_xo_exp_nuke_3P"
const TITAN_NUCLEAR_CORE_FX_1P = "P_xo_exp_nuke_1P"
const TITAN_NUCLEAR_CORE_NUKE_FX = "P_xo_nuke_warn_flare"

RegisterSignal( "RocketPodStateUpdate" )
RegisterSignal( "ChargeCannonStateUpdate" )

enum eCockpitState
{
	Disabled = 0
	Enabled = 1
	NULL = 3
	Open = 5
	Close = 7
	Eject = 9
}

function main()
{
	level._titanCrushables <- {}

	level.rocketPodWeapons <- {}
	level.rocketPodWeapons[ "mp_titanweapon_shoulder_rockets" ] <- true
	level.rocketPodWeapons[ "mp_titanweapon_dumbfire_rockets" ] <- true
	level.rocketPodWeapons[ "mp_titanweapon_salvo_rockets" ] <- true
	level.rocketPodWeapons[ "mp_titanweapon_homing_rockets" ]	<- true

	RegisterSignal( "TitanBeingEntered" )
	RegisterSignal( "TitanEntered" )
	RegisterSignal( "TitanExit" )
	RegisterSignal( "TitanExitComplete" )
	RegisterSignal( "TitanDecay" )
	RegisterSignal( "TitanEjectionStarted" )
	RegisterSignal( "EjectLand" )

	level.hatchModels <- {}
	level.hatchModels[ ATLAS_MODEL ] <- ATLAS_HATCH_PANEL
	level.hatchModels[ STRYDER_MODEL ] <- STRYDER_HATCH_PANEL
	level.hatchModels[ OGRE_MODEL ] <- OGRE_HATCH_PANEL
	level.hatchModels[ "models/titans/destroyer/destroyer_titan.mdl" ] <- "models/titans/destroyer/destroyer_titan_hatch_panel.mdl"

	level.rodeoHitBoxNumber <- {}
	level.rodeoHitBoxNumber[ ATLAS_MODEL ] <- 34
	level.rodeoHitBoxNumber[ STRYDER_MODEL ] <- 50
	level.rodeoHitBoxNumber[ OGRE_MODEL ] <- 41
	level.rodeoHitBoxNumber[ "models/titans/destroyer/destroyer_titan.mdl" ] <- 30

	
	local loop_max = MasterModdedTitans.len()
	for( local E = 0; E < loop_max; E++ )
	{
		if( loop_max > 0 )
		{
			local bmt_model = MasterModdedTitans[ E ]
			level.hatchModels[ bmt_model.titan_model ] <- bmt_model.hatch_model
			level.rodeoHitBoxNumber[ bmt_model.titan_model ] <- bmt_model.rodeo_hitbox_number
		}
	}


	Globalize( CodeCallback_PlayerInTitanCockpit )

	Globalize( AddPanelToTitan )
	Globalize( UpdateTitanPanel	)
	Globalize( SetRodeoHitBoxNumberOnSoul ) //Globalized for soul init
	Globalize( TitanEjectPlayer )
	Globalize( CreateTitanRocketPods )
	Globalize( Titan_CreatePhysicsModelsFromParentedModels )
	Globalize( TitanStagger )
	Globalize( DoesWeaponHaveRocketPods )
	Globalize( GetNextRocketPodFiringInfo )
	Globalize( HideTitanEye )
	Globalize( ShowTitanEye )
	Globalize ( GetRocketPodModel )
	Globalize( TransferShoulderTurret )
	Globalize( TransferShoulderTurret_threaded )
	Globalize( LoadoutContainsRocketPodWeapon )

	Globalize( CreateChargeCannon )
	Globalize( LoadoutContainsChargeCannon )

	AddSoulInitFunc( Titan_ShoulderTurretInit )
	AddSoulInitFunc( AddPanelToTitan )
	AddSoulInitFunc( SetRodeoHitBoxNumberOnSoul )
	AddSoulTransferFunc( TransferShoulderTurret )
	AddSoulTransferFunc( SmartAmmo_TransferMissileLockons )
	AddSoulSettingsChangeFunc( UpdateTitanPanel )
	AddSoulSettingsChangeFunc( SetRodeoHitBoxNumberOnSoul )

	AddSoulDeathFunc( Titan_RodeoPanelCleanup )
	AddSoulDeathFunc( Titan_RocketPodsCleanup )
	AddSoulDeathFunc( Titan_ShoulderTurretCleanup )
	AddSoulDeathFunc( Titan_ChargeCannonCleanup )

	local table = {}
	table.attachment <- "pod_l"
	table.open <- "open"
	table.openIdle <- "idle_open"
	table.close <- "close"
	table.closeIdle <- "idle_closed"
	table.frontToBack <- "front_to_back"
	table.backToFront <- "back_to_front"
	table.backIdle <- "idle_back"
	file.rocketPodAnims <- table

	local table = {}
	table.attachment <- "pod_r"
	table.open <- "open"
	table.openIdle <- "idle_open"
	table.close <- "close"
	table.closeIdle <- "idle_closed"
	table.fire <- "fire"
	file.chargeCannonAnims <- table


	file.titanVOEjectNotifyDist <- 2000 * 2000

	if ( IsServer() )
	{
		PrecacheParticleSystem( TITAN_NUCLEAR_CORE_FX_3P )
		PrecacheParticleSystem( TITAN_NUCLEAR_CORE_FX_1P )
		PrecacheParticleSystem( TITAN_NUCLEAR_CORE_NUKE_FX )

		Globalize( HideTitanEyePartial )

		foreach ( model in level.hatchModels )
		{
			PrecacheModel( model )
		}

		PrecacheModel( ROCKET_POD_MODEL_ATLAS_LEFT )
		PrecacheModel( ROCKET_POD_MODEL_OGRE_LEFT )
		PrecacheModel( ROCKET_POD_MODEL_STRYDER_LEFT )
		PrecacheModel( "models/titans/destroyer/destroyer_titan_hatch_panel.mdl" )
		PrecacheModel( "models/industrial/bolt_tiny01.mdl" )

		PrecacheModel( SHOULDER_CHARGE_CANNON_MODEL )
	}
	else
	{
		Globalize( ShowTitanEyeDelayed )
	}
}

function Titan_RodeoPanelCleanup( soul )
{
	if ( IsValid( soul.rodeoPanel ) )
		soul.rodeoPanel.Kill()
}

function Titan_RocketPodsCleanup( soul )
{
	Titan_CreatePhysicsModelsFromParentedModels( soul.rocketPod.model, soul )
}

function Titan_ShoulderTurretCleanup( soul )
{
	Titan_CreatePhysicsModelsFromParentedModels( soul.shoulderTurret.model, soul )
}

function Titan_ChargeCannonCleanup( soul )
{
	Titan_CreatePhysicsModelsFromParentedModels( soul.chargeCannon.model, soul, true )
}

//Can't just do this by default for all children on the Titan since they need to have physics properties defined
function Titan_CreatePhysicsModelsFromParentedModels( parentedModel, soul, createProp = false )
{
	if ( !IsValid ( parentedModel ) )
		return

	// Make it not solid so ejection doesn't get caught up on it
	parentedModel.NotSolid()

	if ( createProp )
	{
		// Stop any running animations
		parentedModel.Anim_Stop()

		// Spawn a physics version of the models
		local prop_physics = CreateEntity( "prop_physics" )
		prop_physics.SetName( UniqueString( "parentedModel" ) )
		prop_physics.kv.model = parentedModel.GetModelName()
		prop_physics.kv.skin = parentedModel.GetSkin()
		prop_physics.kv.spawnflags = 4 // debris nocollide
		prop_physics.kv.fadedist = -1
		prop_physics.kv.physdamagescale = 0.1
		prop_physics.kv.inertiaScale = 1.0
		prop_physics.kv.renderamt = 255
		prop_physics.kv.rendercolor = "255 255 255"
		prop_physics.SetOrigin( parentedModel.GetOrigin() )
		prop_physics.SetAngles( parentedModel.GetAngles() )
		DispatchSpawn( prop_physics, false )
		//prop_physics.SetAngularVelocity( 0,0,0 )
		//prop_physics.SetVelocity( Vector( 0,0,0) )
		prop_physics.Kill( 11.0 )

		if ( soul.chargeCannon.model && parentedModel == soul.chargeCannon.model )
		{
			prop_physics.SetBodygroup( 0, 1 ) // Enable destroyed charge cannon bodygroup


			if ( parentedModel.GetBodyGroupState( 1 ) == 1 ) // Enable destroyed tier2 bodygroup
				prop_physics.SetBodygroup( 1, 2 )
		}
	}

	// Hide pod model, and delete it. We have to hide it first because it doesn't get deleted right away for some reason
	parentedModel.Hide()
	parentedModel.Kill()
}

function CodeCallback_PlayerInTitanCockpit( titan, player )
{
	// clear the damage history when you enter a titan
	player.s.recentDamageHistory <- []

	if ( IsServer() )
	{
//		player.SetUsableByGroup( "enemies" ) // rodeo'able
		//player.SetUsable()
		//player.SetUsePrompts( "Hold [USE] to rodeo.", "Hold [USE] to rodeo." )
		//player.SetUsePrompts( " ", " " )

		TitanTaken( player, titan )
		titan.GetTitanSoul().lastOwner = player

		if ( IsMultiplayer() )
		{
			Remote.CallFunction_Replay( player, "ServerCallback_TitanCockpitBoot" )
			player.CockpitStartBoot()
		}

		Signal( level.ent, "TitanEntered", { player=player } )
		Signal( player, "TitanEntered" )
	}

	if ( IsClient() )
	{
		Signal( player, "TitanEntered" )
	}
}

function SetRodeoHitBoxNumberOnSoul( soul, titan = null )
{
	if ( !titan )
		titan =  soul.GetTitan()
	if ( !IsValid( titan ) )
		return

	local titanModel = titan.GetModelName()
	Assert( titanModel in level.rodeoHitBoxNumber )

	soul.rodeoHitBoxNumber = level.rodeoHitBoxNumber[ titanModel ]
}

function AddPanelToTitan( soul, titan )
{
	local titanModel = titan.GetModelName()
	if ( !( titanModel in level.hatchModels ) )
		return

	local model = level.hatchModels[ titanModel ]

	local rodeoPanel = CreatePropDynamic( model, null, null )

	rodeoPanel.NotSolid()
	rodeoPanel.SetParent( titan, "hatch_panel" )
	rodeoPanel.Anim_Play( "hatch_rodeo_panel_close_idle" )
	rodeoPanel.s.opened <- false
	rodeoPanel.s.lastDamageStateThreshold <- 1.1
	rodeoPanel.s.lastDamageStateParticleSystem <- null
	rodeoPanel.s.damageAnimDone <- true
	rodeoPanel.SetTeam( titan.GetTeam() )
	rodeoPanel.MarkAsNonMovingAttachment()
	rodeoPanel.RemoveFromSpatialPartition()
	rodeoPanel.SetSkin( titan.GetSkin() )

	soul.rodeoPanel = rodeoPanel
}

function Titan_ShoulderTurretInit( soul, titan )
{
	local table = {}
	table.attachment <- "pod_l"
	table.rightAttachment <- "pod_r"
	table.open <- "deploy"
	table.openIdle <- "deploy_idle"
	table.close <- "undeploy"
	table.closeIdle <- "idle"

	soul.shoulderTurret.anims = table
}

function UpdateTitanPanel( soul )
{
	local titan = soul.GetTitan()
	if ( !IsAlive( titan ) )
		return

	local titanModel = titan.GetModelName()
	if ( !( titanModel in level.hatchModels ) )
		return

	local model = level.hatchModels[ titanModel ]

	soul.rodeoPanel.SetModel( model )
	soul.rodeoPanel.SetSkin( titan.GetSkin() )

	if ( soul.rodeoPanel.s.opened )
		soul.rodeoPanel.Anim_Play( "hatch_rodeo_panel_open_idle" )
	else
		soul.rodeoPanel.Anim_Play( "hatch_rodeo_panel_close_idle" )
}



function TransferShoulderTurret( soul, titan = null, oldTitan = null )
{
	thread TransferShoulderTurret_threaded( soul, titan, oldTitan )
}


function TransferShoulderTurret_threaded( soul, titan = null, oldTitan = null )
{
	WaitEndFrame()

	if ( !IsValid( soul ) || !IsValid( titan ) )
		return

	local player = soul.GetBossPlayer()
	if ( !IsValid( player ) )
		return

	if ( !LoadoutContainsShoulderTurretWeapon( player ))
	{
		if ( IsValid( soul.shoulderTurret.model ) )
		{
			soul.shoulderTurret.model.Destroy()
			soul.shoulderTurret.model = null
		}
		return
	}

	if ( soul.IsEjecting() )
		return

	if ( !soul.shoulderTurret.model )
	{
		local shoulderTurret = CreateShoulderTurret( SENTRY_TURRET_MODEL )

		shoulderTurret.kv.PassDamageToParent = true
		shoulderTurret.kv.CollisionGroup = 21	// COLLISION_GROUP_BLOCK_WEAPONS
		shoulderTurret.SetTeam( titan.GetTeam() )
		soul.shoulderTurret.model = shoulderTurret
		shoulderTurret.DisableTurret()

		shoulderTurret.SetParent( titan, soul.shoulderTurret.anims.attachment, false )
		shoulderTurret.SetBossPlayer( player )
	}
	else
	{
		Assert( IsValid_ThisFrame( oldTitan ) )
		soul.shoulderTurret.model.ClearParent()
		soul.shoulderTurret.model.SetParent( titan, soul.shoulderTurret.anims.attachment, false )
	}
}


function CreateShoulderTurret( turretModel )
{
	local npc_turret_sentry = CreateEntity( "npc_turret_sentry" )
	npc_turret_sentry.kv.spawnflags = 0
	npc_turret_sentry.SetName( UniqueString( "turret_shoulder" ) )
	npc_turret_sentry.kv.model = turretModel
	npc_turret_sentry.kv.solid = 8 // 0 = no collision, 2 = bounding box, 6 = use vPhysics, 8 = hitboxes only
	npc_turret_sentry.kv.additionalequipment = "mp_weapon_yh803_bullet"
	npc_turret_sentry.kv.AccuracyMultiplier = 1.0
	npc_turret_sentry.kv.WeaponProficiency = 4
	npc_turret_sentry.kv.fadedist = -1
	npc_turret_sentry.s.skipTurretFX <- true
	npc_turret_sentry.s.isShoulderTurret <- true
	npc_turret_sentry.SetAISettings( "turret_shoulder" )

	DispatchSpawn( npc_turret_sentry )

	npc_turret_sentry.SetTitle( " " )
	npc_turret_sentry.SetShortTitle( " " ) //hack to stop the bossplayername from drawing through code
	npc_turret_sentry.SetInvulnerable()

	return npc_turret_sentry
}

function CreateTitanRocketPods( soul, titan = null, oldTitan = null )
{
	if ( !IsValid( soul ) || !IsValid( titan ) )
		return

	Assert( soul.rocketPod.model == null )

	local rocketPod

	local titanType = GetSoulTitanType( soul )
	local leftModelName = GetRocketPodModel( titanType )

	if (leftModelName.len() == 0)
		return

	local team = titan.GetTeam()
	rocketPod = CreatePropDynamic( leftModelName, null, null, 8 )
	rocketPod.kv.PassDamageToParent = true
	rocketPod.kv.CollisionGroup = 21	// COLLISION_GROUP_BLOCK_WEAPONS
	rocketPod.SetTeam( team )
	rocketPod.MarkAsNonMovingAttachment();
	soul.rocketPod.model = rocketPod	

	thread RocketPodThink( soul, titan, rocketPod )

	rocketPod.SetParent( titan, file.rocketPodAnims.attachment, false )
	SetSkinForTeam( rocketPod, team )
	SetVisibleEntitiesInConeQueriableEnabled( rocketPod, true )
}

function GetRocketPodModel( playerSettings )
{
	switch( playerSettings )
	{
		case "special_stryder":
		case "stryder":
			return ROCKET_POD_MODEL_STRYDER_LEFT

		case "special_ogre":
		case "ogre":
			return ROCKET_POD_MODEL_OGRE_LEFT
		//case "destroyer":
			//return ROCKET_POD_MODEL_DESTROYER_LEFT
		
		case "special_atlas":
		case "atlas":
		default:
			return ROCKET_POD_MODEL_ATLAS_LEFT

	}

}

function RocketPodThink( soul, titan, leftRocketPod )
{
	leftRocketPod.EndSignal( "OnDestroy" )
	Assert( IsServer() )
	Assert( IsValid( soul ) )
	Assert( IsSoul( soul ) )
	soul.EndSignal( "OnDestroy" )

	local oldState = -1
	local state = eRocketPodState.loaded

	for ( ;; )
	{
		wait 0

		/**************************************/
		/* SEE IF WE HAVE A ROCKET POD WEAPON */
		/**************************************/

		local owner = soul.GetSoulOwner()
		if ( !IsValid( owner ) )
			continue
		if ( !owner.IsPlayer() && !owner.IsNPC() )
			continue

		local weapon = GetRocketPodWeapon( owner )
		if ( weapon == null )
			continue

		if (  !IsValid( leftRocketPod ) )
			continue

		/********************************************/
		/*  FIGURE OUT WHAT STATE PODS SHOULD BE IN */
		/********************************************/

		if ( !weapon.IsReadyToFire() || weapon.IsReloading() )
		{
			// Rockets are unavailable or reloading. Fold pods down.
			state = eRocketPodState.reloading
		}
		else if ( weapon.SmartAmmo_IsEnabled() && !SmartAmmo_CanWeaponBeFired( weapon ) )
		{
			// Weapon is not reloading but it's waiting on a lock. Pods up, doors closed.
			state = eRocketPodState.loaded
		}
		else
		{
			// Weapon can be fired. Pods up and doors open.
			state = eRocketPodState.ready
		}

		/******************************************/
		/*  UPDATE PODS TO MATCH THE WEAPON STATE */
		/******************************************/

		if ( state == oldState )
			continue

		//printt( "-----------------------------------" )
		//printt( "TITAN ROCKET POD STATE CHANGED TO", oldState, "->", state )

		soul.Signal( "RocketPodStateUpdate" )

		switch( state )
		{
			case eRocketPodState.reloading:
				thread RocketPodReload( soul, oldState )
				break

			case eRocketPodState.loaded:
				thread RocketPodLoaded( soul, oldState )
				break

			case eRocketPodState.ready:
				thread RocketPodReady( soul, oldState )
				break

			default:
				Assert(0)
				break
		}

		oldState = state

		//printt( "-----------------------------------" )
	}
}

function RocketPodReload( soul, oldState )
{
	soul.EndSignal( "RocketPodStateUpdate" )
	soul.EndSignal( "OnDestroy" )

	local model_l = soul.rocketPod.model
	model_l.EndSignal( "OnDestroy" )

	if ( oldState == -1 )
	{
		//printt( "jump right to reloading idle" )
		/*model_l.Anim_Play( anims_l.backIdle )
		model_r.Anim_Play( anims_r.backIdle )*/
	}
	else if ( oldState == eRocketPodState.loaded )
	{
		//printt( "fold pod down, then play reload idle" )
		/*model_l.Anim_Play( anims_l.frontToBack )
		model_r.Anim_Play( anims_r.frontToBack )

		model_r.WaitSignal( "OnAnimationDone" )

		model_l.Anim_Play( anims_l.backIdle )
		model_r.Anim_Play( anims_r.backIdle )*/
	}
	else if ( oldState == eRocketPodState.ready )
	{
		//printt( "close doors, fold pod down, then play down idle" )
		PlayRocketPodAnim( "close", soul )
		model_l.WaitSignal( "OnAnimationDone" )

		/*model_l.Anim_Play( anims_l.frontToBack )
		model_r.Anim_Play( anims_r.frontToBack )
		model_r.WaitSignal( "OnAnimationDone" )

		model_l.Anim_Play( anims_l.backIdle )
		model_r.Anim_Play( anims_r.backIdle )*/
	}
	else
		Assert( 0 )
}

function RocketPodLoaded( soul, oldState )
{
	soul.EndSignal( "RocketPodStateUpdate" )
	soul.EndSignal( "OnDestroy" )

	local model_l = soul.rocketPod.model
	model_l.EndSignal( "OnDestroy" )

	if ( oldState == -1 )
	{
		//printt( "jump right to forward idle" )
		PlayRocketPodAnim( "closeIdle", soul )
	}
	else if ( oldState == eRocketPodState.reloading )
	{
		/*model_l.Anim_Play( anims_l.backToFront )
		model_r.Anim_Play( anims_r.backToFront )

		model_r.WaitSignal( "OnAnimationDone" )*/
		PlayRocketPodAnim( "closeIdle", soul )
	}
	else if ( oldState == eRocketPodState.ready )
	{
		//printt( "close doors, then play close idle" )
		PlayRocketPodAnim( "close", soul )
		model_l.WaitSignal( "OnAnimationDone" )
		PlayRocketPodAnim( "closeIdle", soul )
	}
	else
		Assert( 0 )
}

function RocketPodReady( soul, oldState )
{
	soul.EndSignal( "RocketPodStateUpdate" )
	soul.EndSignal( "OnDestroy" )
	soul.EndSignal( "OnTitanDeath" )

	local model_l = soul.rocketPod.model
	model_l.EndSignal( "OnDestroy" )

	if ( oldState == -1 )
	{
		PlayRocketPodAnim( "openIdle", soul )
		//printt( "jump right to ready idle" )
	}
	else if ( oldState == eRocketPodState.loaded )
	{
		//printt( "open doors, then play open idle" )
		PlayRocketPodAnim( "open", soul )

		model_l.WaitSignal( "OnAnimationDone" )
		WaitEndFrame() // wait for OnTitanDeath signal
		PlayRocketPodAnim("openIdle", soul)
	}
	else if ( oldState == eRocketPodState.reloading )
	{
		//printt( "fold pod up, then play open idle" )
		/*model_l.Anim_Play( anims_l.backToFront )
		model_r.Anim_Play( anims_r.backToFront )
		model_r.WaitSignal( "OnAnimationDone" )*/
		PlayRocketPodAnim("open", soul)
		model_l.WaitSignal( "OnAnimationDone" )
		WaitEndFrame() // wait for OnTitanDeath signal
		PlayRocketPodAnim("openIdle", soul)
	}
	else
		Assert( 0 )
}

function PlayRocketPodAnim( animationString, soul )
{
	local anims = file.rocketPodAnims
	local model = soul.rocketPod.model
	model.Anim_Play( anims[animationString] )
}

function CreateChargeCannon( soul, titan = null, oldTitan = null )
{
	if ( !IsValid( soul ) || !IsValid( titan ) )
		return

	Assert( soul.chargeCannon.model == null )

	local chargeCannon

	local team = titan.GetTeam()
	chargeCannon = CreatePropDynamic( SHOULDER_CHARGE_CANNON_MODEL, null, null, 8 )
	chargeCannon.kv.PassDamageToParent = true
	chargeCannon.kv.CollisionGroup = 21	// COLLISION_GROUP_BLOCK_WEAPONS
	chargeCannon.SetTeam( team )
	chargeCannon.MarkAsNonMovingAttachment()
	soul.chargeCannon.model = chargeCannon	

	// TODO: needs anims
	thread ChargeCannonThink( soul, titan, chargeCannon )

	chargeCannon.SetParent( titan, file.chargeCannonAnims.attachment, false )
	SetSkinForTeam( chargeCannon, team )
	SetVisibleEntitiesInConeQueriableEnabled( chargeCannon, true )
}

function ChargeCannonThink( soul, titan, chargeCannon )
{
	chargeCannon.EndSignal( "OnDestroy" )
	Assert( IsServer() )
	Assert( IsValid( soul ) )
	Assert( IsSoul( soul ) )
	soul.EndSignal( "OnDestroy" )

	local oldState = -1
	local state = eChargeCannonState.ready

	for ( ;; )
	{
		wait 0

		/**************************************/
		/* SEE IF WE HAVE A CHARGE CANNON */
		/**************************************/

		local owner = soul.GetSoulOwner()
		if ( !IsValid( owner ) )
			continue
		if ( !owner.IsPlayer() && !owner.IsNPC() )
			continue

		local weapon = GetChargeCannonWeapon( owner )
		if ( weapon == null )
			continue

		if ( !IsValid( chargeCannon ) )
			continue

		if ( weapon.HasMod( "burn_mod_charge_cannon" ) )
			chargeCannon.SetBodygroup( 1, 1 ) // Enable tier2 bodygroup

		/********************************************/
		/*  FIGURE OUT WHAT STATE PODS SHOULD BE IN */
		/********************************************/
		if ( weapon.GetWeaponPrimaryClipCount() < 1 )
		{
			// Cannon is unavailable or reloading.
			state = eChargeCannonState.reloading
		}
		else
		{
			// Cannon can be fired.
			state = eChargeCannonState.ready
		}

		/******************************************/
		/*  UPDATE PODS TO MATCH THE WEAPON STATE */
		/******************************************/

		if ( state == oldState )
			continue

		//printt( "-----------------------------------" )
		//printt( "TITAN CHARGE CANNON STATE CHANGED TO", oldState, "->", state )

		soul.Signal( "ChargeCannonStateUpdate" )

		// These animations dont play properly for some reason
		/*
		switch( state )
		{
			case eChargeCannonState.reloading:
				thread ChargeCannonReload( soul, oldState )
				break

			case eChargeCannonState.ready:
				thread ChargeCannonReady( soul, oldState )
				break

			default:
				//Assert(0)
				break
		}
		*/

		oldState = state

		//printt( "-----------------------------------" )
	}
}

function ChargeCannonReload( soul, oldState )
{
	soul.EndSignal( "ChargeCannonStateUpdate" )
	soul.EndSignal( "OnDestroy" )

	local model_l = soul.chargeCannon.model
	model_l.EndSignal( "OnDestroy" )

	if ( oldState == -1 )
	{
		//printt( "jump right to reloading idle" )
		/*model_l.Anim_Play( anims_l.backIdle )
		model_r.Anim_Play( anims_r.backIdle )*/
	}
	else if ( oldState == eChargeCannonState.ready )
	{
		//printt( "close doors, fold pod down, then play down idle" )
		PlayChargeCannonAnim( "fire", soul )
		model_l.WaitSignal( "OnAnimationDone" )
		WaitEndFrame() // wait for OnTitanDeath signal

		PlayChargeCannonAnim( "close", soul )
		model_l.WaitSignal( "OnAnimationDone" )
		WaitEndFrame() // wait for OnTitanDeath signal

		PlayChargeCannonAnim( "closeIdle", soul )

		/*model_l.Anim_Play( anims_l.frontToBack )
		model_r.Anim_Play( anims_r.frontToBack )
		model_r.WaitSignal( "OnAnimationDone" )

		model_l.Anim_Play( anims_l.backIdle )
		model_r.Anim_Play( anims_r.backIdle )*/
	}
	else
		Assert( 0 )
}

function ChargeCannonReady( soul, oldState )
{
	soul.EndSignal( "ChargeCannonStateUpdate" )
	soul.EndSignal( "OnDestroy" )
	soul.EndSignal( "OnTitanDeath" )

	local model_l = soul.chargeCannon.model
	model_l.EndSignal( "OnDestroy" )

	if ( oldState == -1 )
	{
		PlayChargeCannonAnim( "openIdle", soul )
		//printt( "jump right to ready idle" )
	}
	else if ( oldState == eChargeCannonState.reloading )
	{
		//printt( "fold pod up, then play open idle" )
		/*model_l.Anim_Play( anims_l.backToFront )
		model_r.Anim_Play( anims_r.backToFront )
		model_r.WaitSignal( "OnAnimationDone" )*/
		PlayChargeCannonAnim( "open", soul )
		model_l.WaitSignal( "OnAnimationDone" )
		WaitEndFrame() // wait for OnTitanDeath signal

		PlayChargeCannonAnim( "openIdle", soul )
	}
	else
		Assert( 0 )
}

function PlayChargeCannonAnim( animationString, soul )
{
	printt( "playing animation: " + animationString )

	local anims = file.chargeCannonAnims
	local model = soul.chargeCannon.model
	model.Anim_Play( anims[animationString] )
}
Globalize( PlayChargeCannonAnim )

function NPC_GetNuclearPayload( npc )
{
	if ( !( "nuclearCore" in npc.s ) )
		return 0
	else
		return npc.s.nuclearCore
}
Globalize( NPC_GetNuclearPayload )


function NPC_SetNuclearPayload( npc, doSet )
{
	if ( doSet && !( "nuclearCore" in npc.s ) )
		npc.s.nuclearCore <- 4  // this is an npc nuke. regular nuke; super nuke = 3 (see GetNuclearPayload)
	else if ( !doSet && "nuclearCore" in npc.s )
		delete npc.s.nuclearCore
}
Globalize( NPC_SetNuclearPayload )


/*
open
openIdle
close
closeIdle
frontToBack
backToFront
backIdle
*/

const TITAN_PLAYEREJECT_DELAY = 0.4
const TITAN_PLAYEREJECT_DURATION = 0.8 // long enough foranimation
const MAX_EJECT_LATENCY_COMPENSATION = 0.4

function TitanEjectPlayer( ejectTitan, instant = false )
{
	Assert( ejectTitan.IsTitan() )
	Assert( IsAlive( ejectTitan ), "Ejecting titan expected to be alive. IsPlayer? " + ejectTitan.IsPlayer() + " ent: " + ejectTitan )

	if ( ejectTitan.ContextAction_IsActive() )
		return

	local soul = ejectTitan.GetTitanSoul()

	if ( soul.IsEjecting() )
		return

	if ( "isDisembarking" in ejectTitan.s )
		return

	local e = {}
	e.titan <- ejectTitan
	e.team <- ejectTitan.GetTeam()

	e.player <- null
	local ejectTitanIsPlayer = false
	if ( ejectTitan.IsPlayer() )
	{
		e.player = ejectTitan
		ejectTitanIsPlayer = true
	}

	e.nukeFX <- []
	e.attacker <- ( "attacker" in soul.lastAttackInfo ) ? soul.lastAttackInfo.attacker : null
	e.inflictor <- ( "inflictor" in soul.lastAttackInfo ) ? soul.lastAttackInfo.inflictor : null
	e.damageSourceId <- ( "damageSourceId" in soul.lastAttackInfo ) ? soul.lastAttackInfo.damageSourceId : -1
	e.damageTypes <- soul.lastAttackInfo.scriptType

	local nuclearPayload = 0
	if ( ejectTitanIsPlayer )
		nuclearPayload = GetNuclearPayload( ejectTitan )
	else
		nuclearPayload = NPC_GetNuclearPayload( ejectTitan )

	e.nuclearPayload <- nuclearPayload

	if ( e.nuclearPayload )
	{
		e.needToClearNukeFX <- false
		e.nukeFXInfoTarget <- CreateEntity( "info_target" )
	}

	// this type should probably already be set/determinable by lastAttackInfo
	local rodeoPilot = soul.GetRiderEnt()
	if ( IsValid( rodeoPilot ) && rodeoPilot == e.attacker )
		e.damageSourceId = eDamageSourceId.rodeo_forced_titan_eject

	
	if ( ejectTitanIsPlayer ) {
        	local cardRef = GetPlayerActiveBurnCard( e.player )
        	if ( cardRef != null ) {
            	local lastsUntil = GetBurnCardLastsUntil( cardRef )
            	if ( lastsUntil == BC_NEXTTITANDROP ) {
                	StopActiveBurnCard( e.player )
            	}
        	}
    }

	ejectTitan.Signal( "TitanEjectionStarted" )
	ejectTitan.EndSignal( "Disconnected" )
	ejectTitan.EndSignal( "OnDeath" )

	OnThreadEnd(
		function() : ( e, ejectTitan )
		{
			if ( IsAlive( ejectTitan ) )
			{
				thread ClearEjectInvulnerability( ejectTitan )
			}
			else if ( IsValid( ejectTitan ) )
			{
				ejectTitan.ClearInvulnerable()
			}

			local titan = e.titan

			if ( e.nuclearPayload )
			{
				if ( e.needToClearNukeFX )
				{
					if ( IsAlive( titan ) )
					{
						//Nuclear eject sequence got interrupted early, probably because Pilot died
						Assert( titan.IsTitan() )
						thread NuclearCoreExplosion( titan.GetOrigin(), e )
					}
					else
					{
						//Nuclear eject fired, needs to be cleaned up
						ClearNuclearBlueSunEffect( e )
					}
				}
				//Nuclear core handles cleaning up the left over titan by itself, so just return out early
				return
			}

			if ( !IsAlive( titan ) )
				return

			Assert( titan.IsTitan() )
			Assert( titan.GetTitanSoul().IsEjecting() )
			titan.Die( e.attacker, e.inflictor, { scriptType = damageTypes.TitanEjectExplosion | e.damageTypes, damageSourceId = e.damageSourceId } )
		}
	)

	if ("onTitanEjectCallbacks" in level ) {
		// Fire OnTitanEject callbacks before soul destruction
		foreach ( callbackInfo in level.onTitanEjectCallbacks )
		{
			callbackInfo.func.acall( [callbackInfo.scope, e.player, soul ] )
		}
	}

	soul.SetEjecting( true )
	ejectTitan.SetInvulnerable()  //Give both player and ejectTitan temporary invulnerability in the course of ejecting. Player invulnerability gets cleared in ClearEjectInvulnerability

	if ( ejectTitanIsPlayer )
	{
		UpdatePlayerStat( e.player, "misc_stats", "timesEjected",1.0 )
		if ( nuclearPayload )
			UpdatePlayerStat( e.player, "misc_stats", "timesEjectedNuclear",1.0 )
	}

	if ( !ejectTitan.ContextAction_IsBusy() )
		ejectTitan.ContextAction_SetBusy()

	local ejectDuration // = TITAN_PLAYEREJECT_DURATION

	local standing = true
	if ( ejectTitanIsPlayer )
		standing = e.player.IsStanding()
	else
		standing = soul.GetStance() == STANCE_STAND

	local titanEjectAnimPlayer, titanEjectAnimTitan
	if ( standing )
	{
		if ( nuclearPayload )
		{
			titanEjectAnimPlayer = "at_nuclear_eject_standing"
			titanEjectAnimTitan = "at_nuclear_eject_standing_idle"
		}
		else
		{
			titanEjectAnimPlayer = "at_MP_eject_stand_start"
			titanEjectAnimTitan = "at_MP_eject_stand_end"
		}
	}
	else
	{
		titanEjectAnimPlayer = "at_MP_eject_crouch_idle"
		titanEjectAnimTitan = "at_MP_eject_crouch_start"
	}

	if ( nuclearPayload )
		ejectDuration = TITAN_PLAYEREJECT_DURATION * 2.0
	else
		ejectDuration = TITAN_PLAYEREJECT_DURATION

//	ejectDuration = ejectTitan.GetSequenceDuration( titanEjectAnimPlayer )

	if ( nuclearPayload )
	{
		local players = GetPlayerArray()
		//local amplitude 	= 1.0
		local frequency 	= 40
		local duration = 8.5
		local origin = ejectTitan.GetOrigin()

		foreach ( guy in players )
		{
			if ( guy == e.player )
				continue

			if ( !IsAlive( guy ) )
				continue

			local dist = Distance( guy.GetOrigin(), origin )
			local result = Graph( dist, 1000, 2000, 5.0, 0.0 )
			Remote.CallFunction_Replay( guy, "ServerCallback_ScreenShake", result, frequency, duration )
		}

		e.needToClearNukeFX = true
		e.nukeFXInfoTarget.SetParent( ejectTitan, "CHESTFOCUS" ) //Play FX and sound on entity since we need something that lasts across the player titan -> pilot transition
		e.nukeFX.append( PlayFXOnEntity( TITAN_NUCLEAR_CORE_NUKE_FX, e.nukeFXInfoTarget ) )
		e.nukeFX.append( e.nukeFXInfoTarget )
		//ejectDuration += 0.5

		EmitSoundOnEntity( e.nukeFXInfoTarget, "titan_nuclear_death_charge" )
	}

	local rodeoPlayer = GetPlayerRodeoing( ejectTitan )
	if ( rodeoPlayer && rodeoPlayer.IsPlayer() )
		Remote.CallFunction_Replay( rodeoPlayer, "ServerCallback_RodeoerEjectWarning", ejectTitan.GetTitanSoul().GetEncodedEHandle(), TITAN_PLAYEREJECT_DELAY + ejectDuration )

	if ( ejectTitanIsPlayer )
		e.player.CockpitStartEject()

	local blendDelay = 0.15
	local origin = ejectTitan.GetOrigin()
	local angles = ejectTitan.EyeAngles()

	if ( !instant )
	{
		local hasAutoEject = false
		if ( ejectTitanIsPlayer )
		{
			hasAutoEject = PlayerHasAutoEject( e.player )

			EmitSoundOnEntityOnlyToPlayer( e.player, e.player, TITAN_EJECT_SCREECH )
			Remote.CallFunction_Replay( e.player, "ServerCallback_EjectConfirmed" )
		}

		if ( ejectTitanIsPlayer )
			EmitSoundAtPositionExceptToPlayer( ejectTitan.GetOrigin(), e.player, "Titan_Eject_Servos_3P" )
		else
			EmitSoundAtPosition( ejectTitan.GetOrigin(), "Titan_Eject_Servos_3P" )

		if ( !ejectTitan.IsTitan() )
		{
			// must be a titan, something bad has happened
			KillStuckPlayer( ejectTitan )
			return
		}

		if ( hasAutoEject )
		{
			printtodiag( " * Eject: " + ejectTitan.IsTitan() + " " + ejectTitan.GetModelName() + "\n" )
			// doesn't take control of the player
			ejectTitan.Anim_Play( titanEjectAnimPlayer )
		}
		else
		{
			thread PlayAnim( ejectTitan, titanEjectAnimPlayer, origin, angles, 0 )
		}

		wait blendDelay  // wait for ejectTitan to blend into disembark pose

	    Assert( ejectDuration > MAX_EJECT_LATENCY_COMPENSATION )
	    wait ejectDuration - MAX_EJECT_LATENCY_COMPENSATION

	    if ( ejectTitanIsPlayer )
	    {
		    // subtract player latency so that the client gets the eject at the same time they finish the animation
		    local latency = e.player.GetLatency()
		    local waitduration = MAX_EJECT_LATENCY_COMPENSATION - min( latency, MAX_EJECT_LATENCY_COMPENSATION )
		    //printt( "Eject: compensating for " + latency + " seconds of latency; wait " + waitduration )
		    wait waitduration
		}
	}

	// Defensive fix for if player becomes a spectator between initiating eject and now
	if ( ejectTitanIsPlayer && e.player.GetPlayerSettings() == "spectator" )
		return

	if ( ejectTitan.GetTitanSoul() == null )
		return

	local titan = null

	if ( ejectTitanIsPlayer )
		EmitSoundAtPositionExceptToPlayer( ejectTitan.GetOrigin(), e.player, "Titan_Eject_PilotLaunch_3P" )
	else
		EmitSoundAtPosition( ejectTitan.GetOrigin(), "Titan_Eject_PilotLaunch_3P" )

	if ( ejectTitanIsPlayer )
	{
		titan = CreateTitanFromPlayer( e.player )
		TitanBecomesPilot( ejectTitan, titan )
	}
	else
	{
		// the titan is an AI
		titan = ejectTitan
	}

	local titanOrigin = titan.GetOrigin()

	// HACKY, surprised there isn't a wrapper for this yet
	if ( !( "disableAutoTitanConversation" in titan.s ) )
		titan.s.disableAutoTitanConversation <- true // no auto titan chatter

	titan.SetInvulnerable() //Titan dies at the end of eject sequence by script

	if ( e.nuclearPayload )
	{
		e.nukeFXInfoTarget.SetParent( titan, "CHESTFOCUS" )
	}

	local isInDeepWater = ( "isInDeepWater" in ejectTitan.s && ejectTitan.s.isInDeepWater )

	if ( e.nuclearPayload || isInDeepWater )
	{
		thread TitanNonSolidTemp( titan )
	}

	ejectTitan.Anim_Stop()
	e.titan = titan

	if ( ejectTitan.ContextAction_IsBusy() )
		ejectTitan.ContextAction_ClearBusy()

	local sequence = CreateFirstPersonSequence()
	sequence.thirdPersonAnim = titanEjectAnimTitan
	sequence.teleport = true
	thread FirstPersonSequence( sequence, titan )

	local killplayer = false
	if ( ejectTitanIsPlayer )
	{
		thread TempAirControl( e.player )

		killplayer = PlayerInSolidFailsafe( e.player, origin, titan )
	}

	local ejectAngles = titan.GetAngles()
	ejectAngles.x = 270
	//ejectAngles.x = RandomInt( 263, 277 ) //5 degrees back of straight up was 245

	local speed = RandomInt( 1500, 1700 ) //was 1000
	if ( nuclearPayload )
		speed += 400

	if ( isInDeepWater )
		speed += 1000

	local rider = soul.GetRiderEnt()
	if ( IsAlive( rider ) && rider.GetParent() == titan )
	{
		thread TemporarilyNonSolidPlayer( rider )

		if ( ejectTitanIsPlayer )
			thread TemporarilyNonSolidPlayer( e.player )

		local lookDown = !IsAlive( ejectTitan ) || !ShouldPreventFriendlyFire( rider, ejectTitan )
		if ( rider.IsPlayer() )
			ThrowRiderIntoAir( rider, titanOrigin, titan, ejectAngles, speed, lookDown )
		else
			rider.Die( titan, titan, { force = Vector( 0.4, 0.2, 0.3 ), scriptType = DF_SPECTRE_GIB, damageSourceId = eDamageSourceId.titan_explosion } )

		wait 0.05
	}

	if ( ejectTitanIsPlayer && !killplayer )
	{
		ejectAngles = ejectAngles.AnglesCompose( Vector(-5,0,0) )

		local velocity = ejectAngles.AnglesToForward() * speed
		e.player.SetOrigin( e.player.GetOrigin() )
		e.player.SetVelocity( velocity )

		local player_look_angles = titan.GetAngles()
		player_look_angles.x = 80  //was 35
		if ( !IsAlive( rider ) )
			e.player.SetAngles( player_look_angles )

		thread EjectFlightTracker( e.player )
	}

	if ( ejectTitanIsPlayer && IsAlive( rider ) && IsAlive( e.player ) && !ShouldPreventFriendlyFire( rider, e.player ) )
		thread LookAtEachOther( rider, e.player )

	if ( ejectTitanIsPlayer )
		TitanEjectVO( e.player, titanOrigin )

	wait 0.15

	local explosionOrigin = titanOrigin + Vector( 0, 0, 200 )

	if ( nuclearPayload )
	{
		thread NuclearCoreExplosion( explosionOrigin, e )
	}
	else
	{
		//Regular explosion from eject
		local env_explosion = CreateEntity( "env_explosion" )

		env_explosion.kv.iMagnitude 			= 1 // or it wont function
		env_explosion.kv.iMagnitudeHeavyArmor 	= 1800
		env_explosion.kv.iRadiusOverride 		= 300
		env_explosion.kv.iInnerRadius 			= 100

		env_explosion.kv.fireballsprite = "sprites/zerogxplode.spr"
		env_explosion.kv.rendermode = 5   //additive
		env_explosion.kv.damageSourceId = eDamageSourceId.titan_explosion
		// No Fireball
		// No Smoke
		// No Decal
		// No Sparks
		// No Sound
		// No Fireball Smoke
		// No particles
		// No DLights
		// Do NOT damage owner entity
		env_explosion.kv.spawnflags = 132988
		env_explosion.SetOrigin( explosionOrigin )
		env_explosion.SetTeam( e.team )
		if ( IsValid( ejectTitan ) )
			env_explosion.SetOwner( ejectTitan )
		DispatchSpawn( env_explosion, false )
		env_explosion.Fire( "Explode" )
		env_explosion.Kill( 1.5 )

		local shake = CreateEntity( "env_shake" )
		shake.SetOrigin( titanOrigin )
		shake.kv.amplitude = 12  //1-16
		shake.kv.duration = 1
		shake.kv.frequency = 100 //.001 - 255
		shake.kv.radius = 1000
		shake.kv.spawnflags = 4 //in air
		DispatchSpawn( shake, false )
		shake.Fire( "StartShake" )
		shake.Kill( 1 )
	}

	if ( IsValid( titan ) )
	{
		HideTitanEye( titan )
		if ( titan.ContextAction_IsBusy() )
			titan.ContextAction_ClearBusy()
	}
}

function TitanEjectVO( player, titanOrigin )
{
	local titans = GetAllTitans()
	local voEnum


	foreach ( titan in titans )
	{
		if ( !titan.IsPlayer() )
			continue
		if ( titan == player )
			continue

		if ( ShouldPreventFriendlyFire( player, titan ) )
		{
			if ( DistanceSqr( titanOrigin, titan.GetOrigin() ) > file.titanVOEjectNotifyDist )
				continue

			voEnum = eTitanVO.FRIENDLY_EJECTED
		}
		else
		{
			if ( !ShouldCalloutEjection( player, titanOrigin, titan ) )
				continue

			voEnum = eTitanVO.ENEMY_EJECTED
		}


		Remote.CallFunction_Replay( titan, "SCB_TitanDialogue", voEnum )
	}
}

function ShouldCalloutEjection( player, titanOrigin, titan )
{
	if ( DistanceSqr( titanOrigin, titan.GetOrigin() ) < file.titanVOEjectNotifyDist )
		return true

	// have they hit each other recently? To catch LTS sniper war ejections
	if ( WasRecentlyHitByEntity( player, titan, 6.0 ) )
		return true

	if ( WasRecentlyHitByEntity( titan, player, 6.0 ) )
		return true

	return false
}


function TemporarilyNonSolidPlayer( rider )
{
	rider.EndSignal( "OnDestroy" )
	rider.EndSignal( "OnDeath" )
	rider.EndSignal( "Disconnected" )

	OnThreadEnd(
		function () : ( rider )
		{
			if ( IsValid( rider ) )
			{
				rider.Solid()
			}
		}
	)

	rider.NotSolid()
	wait 1.5
}


function TitanNonSolidTemp( titan )
{
	if ( !EntityInSolid( titan ) )
		return

	local collisionGroup = titan.kv.CollisionGroup

	//CollisionGroup 21 is listed as "COLLISION_GROUP_BLOCK_WEAPONS ". Blocks bullets, projectiles but not players and not AI
	titan.kv.CollisionGroup = 21

	titan.EndSignal( "OnDeath" )
	titan.EndSignal( "OnDestroy" )

	while( EntityInSolid( titan ) )
	{
		wait 0.1
	}

	titan.kv.collisionGroup = collisionGroup

}

function NuclearCoreExplosion( origin, e )
{
	local titan =  e.titan

	titan.EndSignal( "OnDeath" )
	titan.EndSignal( "OnDestroy" )

	e.needToClearNukeFX = false //This thread and NuclearCoreExplosionChainReaction now take responsibility for clearing the FX

	OnThreadEnd(
		function() : ( e )
		{
			ClearNuclearBlueSunEffect( e )
		}
	)
	wait 1.3
	Assert( IsValid( titan ) )
	titan.s.silentDeath <- true  //Don't play normal titan_death_explode in _deathpackage since we're playing titan_nuclear_death_explode

	EmitSoundAtPosition( origin, "titan_nuclear_death_explode" )

	titan.s.noLongerCountsForLTS <- true

	thread NuclearCoreExplosionChainReaction( origin, e )
	if ( IsAlive( titan ) )
		titan.Die( e.attacker, e.inflictor, { scriptType = DF_EXPLOSION, damageType = DMG_REMOVENORAGDOLL, damageSourceId = e.damageSourceId } )

}

function PlayerInSolidFailsafe( player, origin, refEnt = null )
{
	Assert( player.IsPlayer() )
	if ( !EntityInSolid( player, refEnt ) )
	{
		//printt( "Player not in solid, return false" )
		return false
	}

	local node = GetNearestNodeToPos( origin )
	local killplayer = false
	if ( node == -1 )
	{
		//printt( "No nearest node to player, killing player" )
		killplayer = true
	}
	else
	{
		if ( IsSpectreNode( node ) && IsValid( refEnt ) && GetMapName() == "mp_corporate" ) //SUPER HACKY! Fixing bug 62852
		{
			//printt( "Special case fix for corporate" )
			node = GetNearestNodeToPos( refEnt.GetOrigin() )

			if ( node == -1 )
				KillStuckPlayer( player )
		}

		local nodePos = GetNodePos( node, HULL_HUMAN )
		//printt( "Node : " + node + " nodepos: " + nodePos  )
		local result = TraceHull( nodePos, origin, player.GetPlayerMins(), player.GetPlayerMaxs(), null, TRACE_MASK_PLAYERSOLID_BRUSHONLY, TRACE_COLLISION_GROUP_PLAYER )

		origin = result.endPos
		player.SetOrigin( origin )
		//printt( "Setting player to origin: " + origin )

		/*if ( EntityInSolid( player, refEnt )  )
		{
			//printt( "Put player in solid." ) //Could kill player after this, but there are cases where EntityInSolid returns true when it shouldn't, e.g. right up against a ceiling

		}*/

		if ( result.fraction == 0 )
			killplayer = true
	}

	if ( killplayer )
		KillStuckPlayer( player )

	return killplayer
}
Globalize( PlayerInSolidFailsafe )

function KillStuckPlayer( player )
{
	if ( IsAlive( player ) )
		player.Die( level.worldspawn, level.worldspawn, { scriptType = DF_DISSOLVE, damageSourceId = eDamageSourceId.crushed } )
}

function ClearNuclearBlueSunEffect( e )
{
	foreach ( fx in e.nukeFX )
	{
		if ( IsValid( fx ) )
			fx.Kill()
	}
	e.nukeFX.clear()
	e.needToClearNukeFX = false
}

function NuclearCoreExplosionChainReaction( origin, e )
{
	local explosions
	local explosionDist
	local time
	local IsNPC

	local titanDamage 		= 2500
	local nonTitanDamage 	= 75

	switch ( e.nuclearPayload )
	{
		case 4:
			// npc nuke: the idea is to be the same as the regular nuke - but with less explosion calls
			explosions = 3.0
			explosionDist = 500
			time = 1.5//1 is the regular nuke time - but we won'tbe adding an extra explosion and we want 3 explosions over 1s. This will mathematically give us that.
			IsNPC = true

			local fraction 	= 10.0 / explosions //10 is the regular nuke number
			titanDamage 	= titanDamage * fraction
			nonTitanDamage 	= nonTitanDamage * fraction
			break

		case 3:
			// super nuke: PAS_NUCLEAR_CORE + PAS_BUILD_UP_NUCLEAR_CORE
			explosions = 20.0
			explosionDist = 600
			time = 1.7
			IsNPC = false
			break

		case 2:
			// super nuke: PAS_NUCLEAR_CORE
			explosions = 15.0
			explosionDist = 550
			time = 1.4
			IsNPC = false
			break

		case 1:
			// regular nuke: PAS_BUILD_UP_NUCLEAR_CORE
			explosions = 10.0
			explosionDist = 500
			time = 1.0
			IsNPC = false
			break

		default:
			Assert( 0, "e.nuclearPayload value: " + e.nuclearPayload + " not accounted for." )
			break
	}

	local waitPerExplosion = time / explosions

	ClearNuclearBlueSunEffect( e )

	if ( IsValid( e.player ) )
	{
		thread __CreateFxInternal( TITAN_NUCLEAR_CORE_FX_1P, null, null, origin, Vector(0,RandomInt(360),0), C_PLAYFX_SINGLE, null, 1, e.player )
		thread __CreateFxInternal( TITAN_NUCLEAR_CORE_FX_3P, null, null, origin, Vector(0,RandomInt(360),0), C_PLAYFX_SINGLE, null, 6, e.player )
	}
	else
	{
		PlayFX( TITAN_NUCLEAR_CORE_FX_3P, origin, Vector(0,RandomInt(360),0) )
	}

	// one extra explosion that does damage to physics entities at smaller radius
	if( !IsNPC )
		explosions += 1

	for ( local i = 0; i < explosions; i++ )
	{
		local explosionOwner = null
		if ( IsValid( e.player ) )
			explosionOwner = e.player
		else if ( IsValid( e.titan ) )
			explosionOwner = e.titan
		//HACK:: EXPLOSION DOESN'T KILL CREDIT TO A PLAYER FOR OTHER AI
		local explosionTeam = e.team
		if ( GAMETYPE == COOPERATIVE && IsValid( e.titan ) && IsNukeTitan( e.titan ) && e.titan.s.nukeTitanDamagesOtherTitans )
			explosionTeam = TEAM_EXPLODING

		if ( i == 0 && !IsNPC )
			RadiusDamage( origin, 0, 75, 500, explosionDist, explosionOwner, eDamageSourceId.nuclear_core, false, true, explosionTeam, 0 )
		else
			RadiusDamage( origin, titanDamage, nonTitanDamage, 750, explosionDist, explosionOwner, eDamageSourceId.nuclear_core, true, true, explosionTeam, DF_SKIPS_DOOMED_STATE )

		wait waitPerExplosion
	}
}

function ClearEjectInvulnerability( player )
{
	if ( !IsValid( player ) )
		return

	player.EndSignal( "Disconnected" )
	player.EndSignal( "OnDeath" )

	OnThreadEnd(
		function () : (player)
		{
			if ( IsValid( player ) )
				player.ClearInvulnerable()
		}
	)

	wait 0.35
}

function EjectFlightTracker( player )
{
	player.EndSignal( "Disconnected" )
	player.EndSignal( "OnDeath" )
	player.EndSignal( "EjectLand" )
	player.EndSignal( "RodeoStarted" )

	OnThreadEnd(
		function () : (player)
		{
			player.pilotEjecting = false
			player.pilotEjectEndTime = Time()
		}
	)

	player.pilotEjecting = true
	player.pilotEjectStartTime = Time()

	wait 0.1
	for ( ;; )
	{
		if ( player.IsOnGround() )
			player.Signal("EjectLand")

		wait 0.1
	}

}

function TempAirControl( player )
{
	player.EndSignal( "OnDeath" )
	player.EndSignal( "Disconnected" )

	player.kv.airSpeed = 300
	player.kv.airAcceleration = 1200 // 500

	wait 1.5

	player.kv.airSpeed = 160

	wait 3.5

	player.kv.airSpeed = player.GetPlayerSettingsField( "airSpeed" )
	player.kv.airAcceleration = player.GetPlayerSettingsField( "airAcceleration" )
}

function TitanStagger( titan, damageInfo )
{
	if ( !IsAlive( titan ) )
		return false

	if ( !IsPlayer( titan ) )
		return false

	if ( Time() - titan.s.lastStaggerTime < 1.0 )
		return false

	if ( titan.GetTitanSoul().GetShieldHealth() )
		return false

	if ( damageInfo.GetDamage() < 1000 )
		return false

	switch ( damageInfo.GetDamageSourceIdentifier() )
	{
		case eDamageSourceId.mp_titanweapon_arc_cannon:
		case eDamageSourceId.titanEmpField:
		case eDamageSourceId.mp_titanweapon_40mm:
		case eDamageSourceId.mp_weapon_rocket_launcher:
		case eDamageSourceId.mp_titanweapon_sniper:
//		case eDamageSourceId.titan_melee:
		case eDamageSourceId.mp_titanweapon_shoulder_rockets:
		case eDamageSourceId.mp_titanweapon_homing_rockets:
		case eDamageSourceId.mp_titanweapon_dumbfire_rockets:
		case eDamageSourceId.mp_titanweapon_salvo_rockets:
		case eDamageSourceId.mp_titanweapon_shotgun:
		case eDamageSourceId.mp_weapon_mega4:
//		case eDamageSourceId.rodeo_caber:
			titan.SetStaggering()
			titan.s.lastStaggerTime = Time()
			return true

		default:
			return false
	}
}

function LoadoutContainsRocketPodWeapon( player )
{
	Assert( IsValid( player ) )
	local table = GetPlayerClassDataTable( player, "titan" )
	foreach ( offhand in table.offhandWeapons )
	{
		if ( DoesWeaponHaveRocketPods( offhand.weapon ) )
			return true
	}
	return false
}

function LoadoutContainsShoulderTurretWeapon( player )
{
	Assert( IsValid( player ) )
	local table = GetPlayerClassDataTable( player, "titan" )
	foreach ( offhand in table.offhandWeapons )
	{
		local weapon = offhand.weapon
		local weaponName = offhand.weapon

		if ( type( weapon ) != "string" )
			weaponName = weapon.GetClassname()

		if ( weaponName == "mp_titanweapon_shoulder_turret" )
			return true
	}
	return false
}

function LoadoutContainsChargeCannon( player )
{
	Assert( IsValid( player ) )
	local table = GetPlayerClassDataTable( player, "titan" )
	foreach ( offhand in table.offhandWeapons )
	{
		local weapon = offhand.weapon
		local weaponName = offhand.weapon

		if ( type( weapon ) != "string" )
			weaponName = weapon.GetClassname()

		if ( weaponName == WEAPON_CHARGE_CANNON_NAME )
			return true
	}
	return false
}

function GetRocketPodWeapon( entity )
{
	Assert( IsValid( entity ) )
	local offhandWeapons = entity.GetOffhandWeapons()
	foreach( offhand in offhandWeapons )
	{
		if ( DoesWeaponHaveRocketPods( offhand ) )
			return offhand
	}
	return null
}

function DoesWeaponHaveRocketPods( weapon )
{
	if ( type( weapon ) != "string" )
		weapon = weapon.GetClassname()
	return ( weapon in level.rocketPodWeapons )
}

function GetNextRocketPodFiringInfo( weapon, attackParams )
{
	// Client launch offsets. Forward, Right, Up
	local clientLaunchLeftRocketPodOffset = Vector( 0, -20, 10 )

	Assert( IsValid( weapon ) )
	local returnData = {}
	returnData.podModel <- null
	returnData.tagPos <- attackParams.pos
	returnData.tagName <- "muzzle_flash"

	local owner = weapon.GetWeaponOwner()
	if ( !IsValid( owner ) )
		return returnData
	if ( !owner.IsTitan() )
		return returnData
	if ( !HasSoul( owner ) )
		return returnData

	local soul = owner.GetTitanSoul()
	if ( !IsValid( soul ) )
		return returnData

	if ( IsServer() || !owner.IsPlayer() )
	{
		local podModel = soul.rocketPod.model
		if ( IsValid( podModel ) )
			returnData.podModel = podModel
	}

	returnData.tagPos = owner.OffsetPositionFromView( attackParams.pos, clientLaunchLeftRocketPodOffset )

	return returnData
}

function ShouldCreateRightPod( player )
{
	local offhandWeapons = player.playerClassData[ "titan" ].offhandWeapons
	foreach ( entry in offhandWeapons )
	{
		if( "mp_titanweapon_shoulder_rockets" == entry )
			return true
	}

	return false
}

function GetChargeCannonWeapon( entity )
{
	Assert( IsValid( entity ) )
	local offhandWeapons = entity.GetOffhandWeapons()
	foreach( offhand in offhandWeapons )
	{
		local weaponName

		if ( type( offhand ) != "string" )
			weaponName = offhand.GetClassname()

		if ( weaponName == WEAPON_CHARGE_CANNON_NAME )
			return offhand
	}
	return null
}

if ( IsServer() )
{
	function HideTitanEye( titan )
	{
		if ( !IsValid( titan ) )
			return

		local index = titan.FindBodyGroup( "hatcheye" )
		if ( index <= 0 )
			return

		// hide eye fully
		titan.SetBodygroup( index, 2 )
	}

	function HideTitanEyePartial( titan )
	{
		if ( !IsValid( titan ) )
			return

		local index = titan.FindBodyGroup( "hatcheye" )
		if ( index <= 0 )
			return

		// hide eye partially
		titan.SetBodygroup( index, 1 )
	}

	function ShowTitanEye( titan )
	{
		if ( !IsValid( titan ) )
			return

		local index = titan.FindBodyGroup( "hatcheye" )
		if ( index <= 0 )
			return

		local soul = titan.GetTitanSoul()
		// hide the eye
		titan.SetBodygroup( index, 0 )
	}

}
else
{
	function HideTitanEyeForever( titan )
	{
		if ( !IsValid( titan ) )
			return

		local index = titan.FindBodyGroup( "hatcheye" )
		if ( index <= 0 )
			return

		local soul = titan.GetTitanSoul() //JFS defensive fix
		if ( !IsValid( soul ) )
			return

		soul.titanEyeVisibility = EYE_HIDDEN_FOREVER
		// hide the eye
		titan.SetBodygroup( index, 2 )
		//printt( "hide the eye, state 1" )
	}
	Globalize( HideTitanEyeForever )

	function HideTitanEye( titan )
	{
		if ( !IsValid( titan ) )
			return

		if ( !titan.GetTitanSoul() )
			return;

		local index = titan.FindBodyGroup( "hatcheye" )
		if ( index <= 0 )
			return

		local soul = titan.GetTitanSoul() //JFS Defensive fix
		if ( !IsValid( soul ) )
			return

		if ( soul.titanEyeVisibility < EYE_HIDDEN )
			soul.titanEyeVisibility = EYE_HIDDEN

		// hide eye fully
		titan.SetBodygroup( index, 2 )
	}

	function ShowTitanEyeDelayed( soul, time )
	{
		soul.EndSignal( "OnDestroy" )
		wait time

		if ( !soul.HasValidTitan() )
			return

		local titan = soul.GetTitan()
		if ( IsValid( titan ) )
			ShowTitanEye( titan )
	}

	function ShowTitanEye( titan )
	{
		if ( !IsAlive( titan ) )
			return

		local soul = titan.GetTitanSoul()
		if ( !IsValid( soul ) )
			return

		if ( soul.titanEyeVisibility == EYE_HIDDEN_FOREVER )
			return

		local index = titan.FindBodyGroup( "hatcheye" )
		if ( index <= 0 )
			return

		soul.titanEyeVisibility = EYE_VISIBLE
		// hide the eye
		titan.SetBodygroup( index, 0 )
	}
}


function ThrowRiderIntoAir( rider, titanOrigin, titan, ejectAnglesSource, speed, lookDown )
{
	printtodiag( Time() + ": ThrowRiderIntoAir(): rider = " + rider + ", titan = " + titan + "\n" )

	local ejectAngles = VectorCopy( ejectAnglesSource )
//	ejectAngles = ejectAngles.AnglesCompose( Vector(7,0,0) )
	ejectAngles = ejectAngles.AnglesCompose( Vector(5,0,0) )
	local riderVelocity = ejectAngles.AnglesToForward() * speed
	riderVelocity *= 0.95

	if ( lookDown )
	{
		local riderAngles = rider.GetAngles()
		riderAngles.x = 80
		rider.SetAngles( riderAngles )
	}

	rider.Signal( "RodeoOver" )
	rider.ClearParent()
	rider.SetVelocity( riderVelocity )
	rider.SetOrigin( rider.GetOrigin() + Vector(0,0,100) )
	MoveToLegalSolidFromTitan( rider, titan )
	PlayerInSolidFailsafe( rider, titanOrigin, titan )
}

function LookAtEachOther( rider, player )
{
	rider.EndSignal( "OnDeath" )
	player.EndSignal( "OnDeath" )
	rider.EndSignal( "Disconnected" )
	player.EndSignal( "Disconnected" )
	local endTime = Time() + 0.45
	for ( ;; )
	{
		local org1 = rider.GetOrigin()
		local org2 = player.GetOrigin()
		local vec1 = org2 - org1
		local angles1 = vec1.GetAngles()
		local vec2 = org1 - org2
		local angles2 = vec2.GetAngles()

		angles1.x = 0
		angles2.x = 0
		if ( rider.GetParent() == null )
			rider.SetAngles( angles1 )
		if ( player.GetParent() == null )
			player.SetAngles( angles2 )

		if ( Time() >= endTime )
			return
		wait 0
	}
}
