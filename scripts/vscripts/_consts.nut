const PERSISTENCE_INIT_VERSION = 22

const RANDOMIZE_BOT_LOADOUT	= 1

const BASE_TITAN_COUNT = 5 //Adds 3 for titans and 1 to make a valid array placement
::MasterModdedTitans <- [] //the big, centralized table array thing -YtH
::Titans_Enum_Placement <- 3

const TESTCONST = 99
const TEAM_ANY = -1
const TEAM_INVALID = -1
const TEAM_UNASSIGNED = 0
const TEAM_SPECTATOR = 1 //used for clients who connect as spectators through private match. Players won't show up in GetPlayerArray() functions.
const TEAM_IMC = 2
const TEAM_MILITIA = 3
const TEAM_BOTH = 4
const TEAM_COUNT = 5
const TEAM_EXPLODING = 6 //used on explosions to indicate hit everything

const CAMPAIGN_LEVEL_COUNT = 9
const MATCHES_BEFORE_NEW_OPPONENTS = 3

const MAX_GAME_HISTORY = 20 // Matches code

const NON_RARES_PER_RARE = 12

const MAX_LEVEL = 50
const MAX_RANK = 24

const MAX_GEN = 9

const CPU_LEVEL_MINSPEC = 0
const CPU_LEVEL_DURANGO = 1
const CPU_LEVEL_HIGHEND = 2

//default to give for connecting players.  This might have to be changed to something else as right now it's controlling the "good" intro for fracture.
const CONNECT_TIME_DEFAULT = 23

const OUT_OF_BOUNDS_TIME_LIMIT = 10
const OUT_OF_BOUNDS_DECAY_TIME = 15
const OUT_OF_BOUNDS_DECAY_DELAY = 1

const TEAM_DEATHMATCH = "tdm"
const PILOT_SKIRMISH = "ps"
const CAPTURE_POINT = "cp"
const ELIMINATION = "elim"
const ATDM = "atdm"
const ATTRITION = "at"
const CAPTURE_THE_FLAG = "ctf"
const CAMPAIGN = "campaign_carousel"
const CAPTURE_THE_FLAG_PRO = "ctfp"
const BIG_BROTHER = "bb"
const COOPERATIVE = "coop"
const MARKED_FOR_DEATH = "mfd"
const MARKED_FOR_DEATH_PRO = "mfdp"
const HEIST = "heist"
const CAPTURE_THE_TITAN = "ctt"
const UPLINK = "uplink"
const LAST_TITAN_STANDING = "lts"
const WINGMAN_LAST_TITAN_STANDING = "wlts"
const EXFILTRATION = "exfil"
const TITAN_TAG = "tt"
const SCAVENGER = "scv"
const TITAN_ESCORT = "te"
const VARIETY_PACK = "all"
const DEADLY_GROUND = "lava"
const DEVTEST = "devtest"
const FFA = "ffa"
const TITAN_BRAWL = "ttdm"
const TITAN_BRAWL_AUTO = "ttdm_auto"
const TITAN_MFD = "tmfd"
const TITAN_MFD_PRO = "tmfdp"
const GUN_GAME = "gg"

const MAX_TRACKED_CHALLENGES = 3

LOCALPLAYER_NAME_COLOR 	<- [ 210, 170, 0 ]

// for HUD elements
FRIENDLY_COLOR 			<- [ 81, 130, 151 ]
ENEMY_COLOR 			<- [ 197, 103, 47 ]

// for particle color control points
FRIENDLY_COLOR_FX 		<- [ 67, 87, 233 ]
ENEMY_COLOR_FX 			<- [ 233, 67, 67 ]

FRIENDLY_CROSSHAIR_COLOR <- [88, 213, 249, 255]
ENEMY_CROSSHAIR_COLOR <- [220, 40, 40, 180] //252, 130, 21, 255 (ORANGE)
TEAM_IMC_COLOR <- [81, 130, 151] // deprecated
TEAM_MILITIA_COLOR <- [197, 103, 47] // deprecated

BURN_CARD_WEAPON_HUD_COLOR <- [ 246, 134, 40, 255 ]
const BURN_CARD_WEAPON_HUD_COLOR_STRING = "246, 134, 40, 255"
const BURN_CARD_WEAPON_HUD_GLOW_STRING = "220 44 12 255"

//const BURN_CARD_WEAPON_HUD_COLOR_STRING = "47, 206, 62, 255"
//const BURN_CARD_WEAPON_HUD_GLOW_STRING = "44 220 12 255"

const SQUAD_SIZE = 4				// max size for a droppod squad

enum eCodeDialogueID
{
	MAN_DOWN		// 0
	SALUTE			// 1
	ENEMY_CONTACT	// 2
	RUN_FROM_ENEMY	// 3
	RELOADING		// 4
	MOVE_TO_ASSAULT	// 5
	MOVE_TO_SQUAD_LEADER // 6
	FAN_OUT			// 7
	DIALOGUE_COUNT
}

enum eTitanVO
{
	RODEO_RAKE
	ENEMY_EJECTED
	FRIENDLY_EJECTED
	FRIENDLY_TITAN_DEAD
	ENEMY_TITAN_DEAD
	ENEMY_TARGET_ELIMINATED
	FRIENDLY_TITAN_HELPING
	PILOT_HELPING
	FRIENDLY_RODEOING_ENEMY
}

// if we havent hurt the target recently then forget about it
const CURRENT_TARGET_FORGET_TIME = 8

enum scoreEventType
{
	DEFAULT = 0
	ASSAULT = 1
	DEFENSE = 2
	GAMEMODE = 3
}

const BLINKING_BLUE_LIGHT_PARTICLE = "blue_light_large_blink"

enum eNPCTitanMode
{
	WAIT  = 0
	FOLLOW = 1
	STAY = 2
	//ROAM = 2

	MODE_COUNT = 3
}

enum eSubClass
{
	NONE //always the first one!

	empTitan
	mortarTitan
	nukeTitan

	suicideSpectre
	sniperSpectre

	bubbleShieldGrunt
	bubbleShieldSpectre

	LAST_INDEX //always the last one!
}

const MAX_BULLET_PER_SHOT = 35

//--------------------------------------------------
// 				CONTROL PANELS
//--------------------------------------------------

const ELIMINATION_FUSE_TIME = 45

enum ePanelState
{
	ENABLED,
	DISABLED,
}

enum crosshairPriorityLevel
{
	ROUND_WINNING_KILL_REPLAY,
	MENU,
	PREMATCH,
	TITANHUD,
	DEFAULT
}

enum eSpectreSpawnStyle
{
	MORE_FOR_ENEMY_TITANS
	MAP_PROGRESSION
}


const USE_TIME_INFINITE = -1
//--------------------------------------------------
// 				MODELS
//--------------------------------------------------
//Pilot models:
const MILITIA_MALE_BR 	= "models/Humans/mcor_pilot/male_br/mcor_pilot_male_br.mdl"
const IMC_MALE_BR 		= "models/Humans/imc_pilot/male_br/imc_pilot_male_br.mdl"
const MILITIA_MALE_CQ 	= "models/Humans/mcor_pilot/male_cq/mcor_pilot_male_cq.mdl"
const IMC_MALE_CQ 		= "models/humans/imc_pilot/male_cq/imc_pilot_male_cq.mdl"
const MILITIA_MALE_DM 	= "models/Humans/mcor_pilot/male_dm/mcor_pilot_male_dm.mdl"
const IMC_MALE_DM 		= "models/humans/imc_pilot/male_dm/imc_pilot_male_dm.mdl"
const DEFAULT_VIEW_MODEL = "models/weapons/arms/pov_imc_pilot_male_br.mdl"

const MILITIA_FEMALE_BR = "models/humans/pilot/female_br/pilot_female_br.mdl"
const IMC_FEMALE_BR 	= "models/humans/pilot/female_br/pilot_female_br.mdl"
const MILITIA_FEMALE_CQ = "models/humans/pilot/female_cq/pilot_female_cq.mdl"
const IMC_FEMALE_CQ 	= "models/humans/pilot/female_cq/pilot_female_cq.mdl"
const MILITIA_FEMALE_DM = "models/humans/pilot/female_dm/pilot_female_dm.mdl"
const IMC_FEMALE_DM 	= "models/humans/pilot/female_dm/pilot_female_dm.mdl"

const PILOT_SPECTRE_CORPORATE = "models/Robots/spectre/spectre_corporate_pilot.mdl"

//militia hero models
const MAC_MODEL = "models/humans/mcor_hero/macallan/mcor_hero_macallan.mdl"
const SARAH_MODEL = "models/humans/mcor_hero/sarah/mcor_hero_sarah.mdl"
const BISH_MODEL ="models/humans/mcor_hero/bish/mcor_hero_bish.mdl"
const BARKER_MODEL = "models/humans/mcor_hero/officer/mcor_hero_officer.mdl"

//imc villian models:
const GRAVES_MODEL = "models/humans/imc_villain/graves/imc_villain_graves.mdl"
const SPYGLASS_MODEL = "models/humans/imc_villain/spyglass/imc_villain_spyglass.mdl"
const BLISK_MODEL = "models/humans/imc_villain/blisk/imc_villain_blisk.mdl"

// ai models
const TEAM_IMC_GRUNT_MDL = "models/humans/imc_grunt/battle_rifle/imc_grunt_battle_rifle.mdl"
const TEAM_IMC_ROCKET_GRUNT_MDL = "models/humans/imc_grunt/anti_titan/imc_grunt_anti_titan.mdl"
const TEAM_IMC_CAPTAIN_MDL = "models/humans/imc_grunt/captain/imc_grunt_captain.mdl"
const TEAM_MILITIA_GRUNT_MDL = "models/humans/mcor_grunt/battle_rifle/mcor_grunt_battle_rifle.mdl"
const TEAM_MILITIA_ROCKET_GRUNT_MDL = "models/humans/mcor_grunt/anti_titan/mcor_grunt_anti_titan.mdl"
const TEAM_MILITIA_CAPTAIN_MDL = "models/humans/mcor_grunt/captain/mcor_grunt_captain.mdl"
const TEAM_MILITIA_DRONE_MDL = "models/humans/mcor_grunt/battle_rifle/mcor_grunt_br_less_jnts.mdl"
const TEAM_MILITIA_ROCKET_DRONE_MDL = "models/humans/mcor_grunt/anti_titan/mcor_grunt_at_less_jnts.mdl"
const MARVIN_NO_JIGGLE_MODEL = "models/robots/marvin/marvin_no_jiggle.mdl"
const MARVIN_MODEL = "models/robots/marvin/marvin.mdl"

const CASE_MODEL = "models/containers/pelican_case_large_drabGreen_reducedSize.mdl"
const LAPTOP_MODEL 	= "models/communication/terminal_usable_imc_02.mdl"

const CL_HIGHLIGHT_ARROW_X = 0.85
const CL_HIGHLIGHT_ARROW_Y = 0.80
const CL_HIGHLIGHT_ICON_X = 0.80
const CL_HIGHLIGHT_ICON_Y = 0.75
const CL_HIGHLIGHT_LABEL_X = 0.80
const CL_HIGHLIGHT_LABEL_Y = 0.75

const MFD_COUNTDOWN_TIME = 5
const MFDP_COUNTDOWN_TIME = 3
const MFD_BETWEEN_MARKS_TIME = 7
const MFD_ESCORT_RADIUS = 700
const MFD_ROUNDS_SKIPPED_AFTER_BEING_MARKED = 2
const MFD_MINIMAP_FRIENDLY_MATERIAL = "vgui/HUD/minimap_mfd_friendly"
const MFD_MINIMAP_PENDING_MARK_FRIENDLY_MATERIAL = "vgui/HUD/minimap_mfd_pre_friendly"
const MFD_MINIMAP_ENEMY_MATERIAL = "vgui/HUD/minimap_mfd_enemy"
const MFD_PRO_KILL_ANNOUNCEMENT_WAIT = 0.12

const DROPSHIP_VERTICAL = "dropship_flyer_attack_vertical_successful"
const DROPSHIP_STRAFE = "gd_goblin_zipline_strafe"
const DROPSHIP_FLYER_ATTACK_ANIM = "dropship_flyer_attack"
const DROPSHIP_FLYER_ATTACK_ANIM_VERTICAL = "dropship_flyer_attack_vertical"
const DROPSHIP_DROP_ANIM = "gd_goblin_zipline_strafe"
const DROPPOD_MODEL = "models/vehicle/droppod_fireteam/droppod_fireteam.mdl"
const DROPPOD_DROP_ANIM = "pod_testpath"
const DROPSHIP_MODEL = "models/vehicle/goblin_dropship/goblin_dropship.mdl"
const DROPSHIP_HERO_MODEL = "models/vehicle/goblin_dropship/goblin_dropship_hero.mdl"
const DROPSHIP_HERO_PLATFORM = "models/vehicle/goblin_dropship/dropship_hero_platform_r.mdl"

const CROW_MODEL = "models/vehicle/crow_dropship/crow_dropship.mdl"
const CROW_HERO_MODEL = "models/vehicle/crow_dropship/crow_dropship_hero.mdl"

//const BOMBER_MODEL = "models/vehicle/imc_bomber/bomber.mdl"
//const BOMBER_BOMB_MODEL = "models/IMC_base/bomb_imc_01.mdl"
const REDEYE_MODEL = "models/vehicle/redeye/redeye2.mdl"
const ATLAS_MODEL = "models/titans/atlas/atlas_titan.mdl"
const OGRE_MODEL = "models/titans/ogre/ogre_titan.mdl"
const STRYDER_MODEL = "models/titans/stryder/stryder_titan.mdl"
const IMC_SPECTRE_MODEL = "models/Robots/spectre/imc_spectre.mdl"
const MILITIA_SPECTRE_MODEL = "models/Robots/spectre/mcor_spectre_assault.mdl"
const NEUTRAL_SPECTRE_MODEL = "models/Robots/spectre/spectre_corporate.mdl"
const SENTRY_TURRET_MODEL = "models/weapons/sentry_turret/sentry_turret.mdl"

const HOTDROP_TURBO_ANIM = "at_hotdrop_drop_2knee_turbo"

const TURRET_ENTITY = "npc_turret_sentry"
const TURRET_WEAPON_BULLETS = "mp_weapon_yh803_bullet"
const TURRET_WEAPON_ROCKETS = "mp_turretweapon_rockets"

//rocket pod models:
const ROCKET_POD_MODEL_ATLAS_LEFT = "models/Weapons/titan_rocket_pod/titan_rocket_pod_atlas_L.mdl"
const ROCKET_POD_MODEL_STRYDER_LEFT = "models/Titans/stryder/stryder_titan_l_rocket_pod.mdl"
const ROCKET_POD_MODEL_OGRE_LEFT = "models/Titans/ogre/ogre_titan_L_rocket_pod.mdl"

//------------------------
// MAP STARS
//------------------------

const MAP_STARS_IMAGE_EMPTY = "../ui/menu/lobby/map_star_empty"
const MAP_STARS_IMAGE_FULL = "../ui/menu/lobby/map_star_full"
const MAX_STAR_COUNT	= 3

//------------------------
// WEAPON & MODS
//------------------------

const SHIELD_WALL_CHARGE_TIME = 15.0
const SHIELD_WALL_MAX_CHARGES = 2


//  mp_weapon_smr
const TANK_MISSILE_DELAY = 1.5
const TANK_MISSILE_VELOCITY = 1800
const DEFAULT_WARNING_SFX = "Weapon_R1_LaserMine.ArmedBeep"
const FORCE_SONAR_DEACTIVATE = "SonarDeactivate"
const BURN_CARD_SATCHEL_BURST_COUNT = 10
const BURN_CARD_SATCHEL_BURST_RANGE = 250

//------------------------
// Passives
//------------------------

//------------------------
// GUNSHIP
//------------------------

const STRATON_MODEL	= "models/vehicle/straton/straton_imc_gunship_01.mdl"
const HORNET_MODEL 	= "models/vehicle/hornet/hornet_fighter.mdl"
const CARRIER_MODEL = "models/vehicle/imc_carrier/vehicle_imc_carrier.mdl"
const FX_GUNSHIP_THRUSTERS = "veh_gunship_jet_full"
const FX_GUNSHIP_THRUSTERS_HEAT = "veh_gunship_jet_full_refract"
const FX_GUNSHIP_ACL_LIGHT_GREEN = "acl_light_green"
const FX_GUNSHIP_ACL_LIGHT_RED = "acl_light_red"
const FX_GUNSHIP_ACL_LIGHT_WHITE = "acl_light_white"
const FX_GUNSHIP_CRASHING_SMOKETRAIL = "veh_gunship_DMG_smoketrail"
const FX_GUNSHIP_CRASHING_FIREBALL = "fire_jet_01_flame"
const FX_GUNSHIP_CRASH_IMPACT = "P_impact_exp_bomber"
const FX_GUNSHIP_CRASH_EXPLOSION = "droppod_impact_black"
const FX_GUNSHIP_CRASH_EXPLOSION_ENTRANCE = "veh_gunship_warp_FULL"
const FX_GUNSHIP_CRASH_EXPLOSION_EXIT = "veh_gunship_warp_OUT_FULL"
const SOUND_GUNSHIP_CRASH_IMPACT = "ambient/machines/wall_crash1.wav"
const SOUND_GUNSHIP_GOING_DOWN_SWEETENER = "br/events/crash_sweetener.wav"
const SOUND_GUNSHIP_GOING_DOWN_LOOP = "npc/combine_gunship/gunship_crashing1.wav"
const SOUND_GUNSHIP_CRASH_ALARM_LOOP = "npc/attack_helicopter/aheli_damaged_alarm1.wav"
const GUNSHIP_DEFAULT_AIRSPEED = 3000

const STRATON_FLIGHT_ANIM = "st_gunship_dogfight_C"
const HORNET_FLIGHT_ANIM = "ht_gunship_dogfight_C"
const STRATON_DOGFIGHT_ANIM1 = "st_Dogfight_Target_1"
const STRATON_DOGFIGHT_ANIM2 = "st_Dogfight_Target_2"
const STRATON_DOGFIGHT_ANIM3 = "st_Dogfight_Target_3"
const STRATON_DOGFIGHT_ANIM1_PERSUER = "st_Dogfight_Persuer_1"
const STRATON_DOGFIGHT_ANIM2_PERSUER = "st_Dogfight_Persuer_2"
const STRATON_DOGFIGHT_ANIM3_PERSUER = "st_Dogfight_Persuer_3"
const STRATON_ATTACK_FULL = "st_AngelCity_IMC_Win_Full"

const FLYER_MODEL = "models/creatures/flyer/flyer_a.mdl"
const FLYER_MODEL_STATIC = "models/creatures/flyer/flyer_static_flying.mdl"
const FLYER_500X_MODEL = "models/creatures/flyer/flyer_a_500x.mdl"
const FLYER_1000X_MODEL = "models/creatures/flyer/flyer_a_1000x.mdl"


//--------------------------------------------------
// 				TURRETS
//--------------------------------------------------

const MEGA_TURRET_REPAIR_TIME	= 30
const LIGHT_TURRET_REPAIR_TIME	= 30


// Titan soul
const EMBARKABLE_NEVER	 	= 0 // cant embark
const EMBARKABLE_INFRONT	= 1 // can embark if in dot
const EMBARKABLE_ANY		= 2	// can embark from any direction
const EMBARKABLE_ANY_PLAYER	= 3	// can embark by anybody


// LEECHING
const DATA_KNIFE_MODEL = "models/weapons/data_knife/v_data_knife.mdl"

// grenade weapon models
const GRENADE_MODEL = "models/weapons/grenades/m20_f_grenade.mdl"
const GRENADE_MODEL_LARGE = "models/weapons/bullets/triple_threat_projectile.mdl"
const BOMB_PLANT_MODEL = "models/weapons/satchel_charge/satchel_charge.mdl"
const SATCHEL_CHARGE_MODEL = "models/weapons/at_satchel_charge/at_satchel_charge.mdl"
const PROX_MINE_MODEL = "models/weapons/caber_shot/caber_shot_thrown.mdl"

// shared values for cluster rocket explosions
const CLUSTER_ROCKET_BURST_COUNT 		= 20 //number of bursts
const CLUSTER_ROCKET_BURST_COUNT_BURN	= 32 //number of bursts with burn card
const CLUSTER_ROCKET_BURST_COUNT_MOD	= 10 //Concentrated Payload has the higher initial damage but reduced duration of the secondary explosions.
const CLUSTER_ROCKET_BURST_DELAY 		= 0.5 //time before the popcors burst off +/- some randomness
const CLUSTER_ROCKET_BURST_OFFSET 		= 0.3 // how much + & - the delay to set off the explosions
const CLUSTER_ROCKET_BURST_RANGE 		= 250 //range of the bursts
const CLUSTER_ROCKET_BURST_GROUP_SIZE 	= 5 //number of explosions before a delay
const CLUSTER_ROCKET_BASE_FIRERATE 		= 0.1 //setting manually to avoid having the call the get function every frame
const CLUSTER_ROCKET_DURATION 			= 5.0 //duration of the bursts
const CLUSTER_ROCKET_DURATION_BURN 		= 7.0 //duration of the bursts with burn card
const CLUSTER_ROCKET_FX_TABLE 			= "exp_rocket_cluster_secondary"

// the amount of damage needed to break melee assist
const DAMAGE_BREAK_MELEE_ASSIST = 1400

// the amount of time melee assist breaks for
const DAMAGE_BREAK_MELEE_TIME = 1.2

const TITAN_FOOTSTEP_DAMAGE 		= 350
const TITAN_FOOTSTEP_DAMAGE_WAIT	= 1.0  // min seconds after initial footstep damage to wait before doing more damage


const REVIVE_BLEED_OUT_TIME = 60
const REVIVE_TIME_TO_REVIVE = 4
const REVIVE_DIST_OUTER = 80
const REVIVE_DIST_INNER = 40
const REVIVE_DEATH_TIME = 4

// ----------------------------
//  LEVEL SCRIPT SHARED CONSTS
// ----------------------------
// mp_trainer - DEPRECATED
enum eTrainerClientFuncs
{
	TrainerStart,
	EnableTitanModeChange,
	EnableTitanEject,
	EnableTitanDisembark,
	DisableTitanDisembark,
	EnableTitanModeHUD,
	BeginFadeToBlack
}

// mp_npe
enum eTrainingButtonPrompts
{
	START_SIM,
	LOOK,
	MOVE,
	MOVEFORWARD,
	SPRINT,
	JUMP,
	LONGJUMP,
	MANTLE,
	WALLRUN,
	WALLRUN_EXTEND,
	WALLRUN_DETACH,
	DOUBLEJUMP,
	DOUBLEJUMP_FAR,
	CLOAK,
	MELEE,
	WEAPONSWITCH,
	RELOAD,
	FIREPRIMARY,
	ADS,
	FIREGRENADE,
	WEAPONSWITCH_AT,
	PILOT_HEALTH,
	MOSHPIT_KILLGUYS,
	MOSHPIT_KILLTITAN,
	CALL_TITAN,
	ENTER_TITAN,
	TITAN_DASH,
	DASH_LEFT,
	DASH_RIGHT,
	DASH_FORWARD,
	DASH_BACK,
	DASH_THREAT_HELP,
	TITAN_VORTEX,
	TITAN_VORTEX_NAG,
	TITAN_VORTEX_STARTINGLINE,
	VORTEX_REFIRE,
	TITAN_DISEMBARK,
	MOVE_TO_CONTROL_ROOM,
	DATA_KNIFE,
	TITAN_AI_MODE,
	TITAN_OFFHAND_OFFENSIVE,
	TITAN_MOSH_PIT_SURVIVE,
	TITAN_SHIELDS,
	TITAN_HEALTH,
	EJECT_INIT,
	EJECT_CONFIRM,
}

enum eRankEnabledModes
{
	TOO_LATE
	NOT_ENOUGH_PEOPLE
	ALLOWED_DURING_PERSONAL_GRACE_PERIOD
}

// IDs zero and above dictate training progression.
// we can change the order of this list around to change the order in which we train stuff
enum eTrainingModules
{
	TEST 		= -3,
	BEDROOM_END = -2,
	BEDROOM 	= -1,

	// PILOT
	JUMP,
	WALLRUN,
	WALLRUN_PLAYGROUND,
	DOUBLEJUMP,
	DOUBLEJUMP_PLAYGROUND,
	CLOAK,
	BASIC_COMBAT,
	FIRINGRANGE,
	FIRINGRANGE_GRENADES,
	MOSH_PIT,

	// TITAN
	TITAN_DASH,
	TITAN_VORTEX,
	TITAN_PET,
	TITAN_MOSH_PIT
}

// mp_npe dev variables, here so we can share between server and client script
const NPE_DEV_TEST 				= false  	// if set to false none of the other dev variables here will work
const NPE_START_MODULE 			= 11		// the module ID to start on
const NPE_DEV_SHOW_INTROSCREEN 	= true		// show introscreens between modules? Turn off to make transitions faster
const NPE_DEV_RETURN_TO_LOBBY 	= false 	// return to lobby after level finishes?

// mp_outpost_207
enum eOutpostCannonTargets
{
	CAPITAL_SHIP,
	DECOY_SHIP
}

// mp_harmony_mines
enum eDiggerState
{
	SPIN,
	TWITCH
}

//mp o2
const O2_EPILOGUE_DURATION = 51.5  // Custom duration set to match with the story VDU's and player nuking

// ----------------------
//  TITAN HUD
// ----------------------

const OFFHAND_HUD_COLOR_FULL	= "180 246 85"	// green
const OFFHAND_HUD_COLOR_EMPTY	= "200 80 80"	// red

const EJECT_FADE_TIME = 2.0 // time for eject interface to fade out


//-----------------------------------------------------
// PROGRESS BAR
//-----------------------------------------------------

const PROGRESS_BAR_FULL = "49 188 204 255"
const PROGRESS_BAR_EMPTY = "229 86 23 255"



// DONT CHANGE THESE NAMES, THEY ARE USED BY TOOLS CODE
// YOU CAN CHANGE THE ORDER, BUT DONT CHANGE THE NAMES!!
enum eDevStats
{
	DEATH,
	SPAWN,
	ROUND_END,	//Chad ToDo: - should be renamed as now it just contains player win/loss data, the new MATCH_END stat is the new match end data
	MATCH_END,
	MOVE,
	FPS,
	ENGAGEMENT,
	BURN_CARD_EARNED
}
const DEVSTATS_VERSION		= 3	// DONT CHANGE THIS UNLESS YOUR NAME IS CHAD G
const DEVSTATS_SEPARATOR	= ";"

const NUM_GAMES_TRACK_KDRATIO = 10
const NUM_GAMES_TRACK_WINLOSS_HISTORY = 10

//-----------------------------------------------------
// FLYERS
//-----------------------------------------------------

const CONSTFLYERHEALTH		= 100
const CONSTFLYERHEALTHZERO	= 100000
//const FX_FLYERDEATH 		= "blood_flyer_death_01" -> taking out temporarily, robot deleting old fx

//XWING FLYER CREATION OPTIONS
enum eFlyerType
{
	Real
	Cheap
	Static
	CheapMix
	SwarmMix
	Cheap500x
	Cheap1000x
}

enum eFlyerPathScale
{
	x1
	x500
	x1000
}

// types of ways drop calls can be used
enum eDropStyle
{
	NEAREST
	NEAREST_YAW 			// the node nearest the specified origin that fits the supplied yaw
	DROPSHIP		// in front of the owner, pointed towards the owner, with fallback alternatives
	ASSAULT_ENTITY	// in front of the entity, pointed towards the entity, with fallback alternatives. Similar to DROPSHIP style, except no player owner assumed.
	FORCED				// force to spawn at the specified location
	NEAREST_YAW_FALLBACK           // nearest node and yaw, with wider search area
	FROM_SET_DISTANCE				// spawn at a set distance
	HOTDROP
	DOGFIGHTER
	ZIPLINE_NPC				// starts at the origin and works it's way out in four directions, with fallback
	RANDOM_FROM_YAW		// spawn at a random node that meets the yaw requirement
	FLYER_PICKUP		// same as ZIPLINE_NPC just a more suitable name, starts at the origin and works it's way out in four directions, with fallback
}

// nps states for capturepoint
enum eNPCStateCP
{
	NONE
	SPREAD_OUT
	CONVERGE
	AT_POINT
	AT_TERMINAL
	SITTING_DOWN
	STANDING_UP
	USING_TERMINAL
	MOVING_TO_TERMINAL
}

enum eCapPointPilotScoring
{
	GRADUAL_RISE
	REWARD_MORE_PLAYERS
}

enum eCapPointAIScoring
{
	PLAYERS_CAP_AI
	CONTEST_ALWAYS
}

//-----------------------------------------------------
// FIGHTER SHIPS
//-----------------------------------------------------
enum eFighterAngles
{
	TARGET_ANGLES, 	// use angles of attachments or offsets
	FACE_ORIGIN, 	// plays facing towards origin of target entity being attacked
	FACE_ORIGIN_2D,	// plays facing towards origin of target entity being attacked, ignore z
	FIXED_ANGLES,	// fixed angles
	FIXED_POINT		// fixed source position
	FIXED_POINT_2D	// fixed source position, ignore z
}

//-----------------------------------------------------
// _ANIM.NUT and _CL_ANIM.NUT
//-----------------------------------------------------

//Max Time spent after death before respawning again is DEATHCAM_TIME + KILL_REPLAY_TITAN_REPLAY_LENGTH + KILL_REPLAY_AFTER_KILL_TIME, which == 12.3
const DEATHCAM_TIME = 1.8
const KILL_REPLAY_PILOT_REPLAY_LENGTH = 4.6
const KILL_REPLAY_TITAN_REPLAY_LENGTH = 6.8//7.8
const KILL_REPLAY_AFTER_KILL_TIME = 3.0

const DEATHCAM_TIME_SHORT = 1.0
const KILL_REPLAY_LENGTH_SHORT = 4.0
const KILL_REPLAY_AFTER_KILL_TIME_SHORT = 1.0
const RESPAWN_BUTTON_BUFFER = 1.0

const DEFAULT_SCRIPTED_ANIMATION_BLEND_TIME = 0.2
const DEFAULT_SCRIPTED_ARRIVAL_DISTANCE 	= 16

const WINGMAN_MODEL = "models/weapons/b3wing/v_b3wing_rodeo.mdl"
const VORTEX_PAIN = 0 // vortex causes pain to rodeo'er

const ATLAS_HATCH_PANEL = "models/titans/atlas/atlas_titan_hatch_panel.mdl"
const STRYDER_HATCH_PANEL = "models/titans/stryder/stryder_titan_hatch_panel.mdl"
const OGRE_HATCH_PANEL = "models/titans/ogre/ogre_titan_hatch_panel.mdl"

const RODEO_APPROACH_FALLING_FROM_ABOVE = 0
const RODEO_APPROACH_JUMP_ON = 1
const RODEO_REAL_WEAPON = 0

// titan eye

const EYE_VISIBLE           = 0
const EYE_HIDDEN			= 1
const EYE_HIDDEN_FOREVER    = 2


const SAFE_TITANFALL_DISTANCE = 125
const SAFE_TITANFALL_DISTANCE_CTF = 270

const NUM_CUSTOM_LOADOUTS	= 5
const NUM_GAMEMODE_LOADOUTS	= 2

const UNLOCK_GAMEMODE_SLOT_1_VALUE = 5
const UNLOCK_GAMEMODE_SLOT_2_VALUE = 10

//-----------------------------------------------------
// EMP GRENADES
//-----------------------------------------------------

const EMP_GRENADE_FREEZE_CONTROLS_DURATION 	= 2.0
const EMP_GRENADE_SCREEN_EFFECTS_DURATION 	= 3.0
const EMP_GRENADE_PILOT_SCREEN_EFFECTS_DURATION_MIN = 1.5 // duration of emp screen effects when you're at the edge of the damage radius
const EMP_GRENADE_PILOT_SCREEN_EFFECTS_DURATION_MAX = 2.0 // duration of emp screen effects when you're at the center of the explosion
const EMP_GRENADE_PILOT_SCREEN_EFFECTS_FADE = 2.0
const EMP_GRENADE_PILOT_SCREEN_EFFECTS_MIN = 0.15
const EMP_GRENADE_PILOT_SCREEN_EFFECTS_MAX = 0.4

const EMP_GRENADE_SLOW_SCALE_MIN = 0.85
const EMP_GRENADE_SLOW_SCALE_MAX = 0.6
const EMP_GRENADE_SLOW_DURATION_MIN = 1.5
const EMP_GRENADE_SLOW_DURATION_MAX = 4.0

const EMBARK_TIMEOUT = 10 // how long you have to reach your titan before it stands up and bubble shield starts to fade

const EMP_GRENADE_PILOT_DAMAGE_MAX = 125 // EMP damage vs pilots will never be above this amount
const EMP_GRENADE_PILOT_DAMAGE_MIN = 70	// EMP damage vs pilots will never be below this amount
const PROX_MINE_PILOT_DAMAGE_MAX = 125 // Prox Mine damage vs pilots will never be above this amount
const PROX_MINE_PILOT_DAMAGE_MIN = 70	// Prox Mine damage vs pilots will never be below this amount

const EMP_IMPARED_SOUND = "EMP_VisualImpair"


 // increment integer when ain node format changes. Forces new ain file on maps
const AIN_REV = 19


const SCREENFX_WARPJUMP = "P_warpjump_FP"
const SCREENFX_WARPJUMPDLIGHT = "warpjump_CH_dlight"


// dialogue
const VOICE_COUNT = 4
const TEST_ALL_ALIASES = false


//--------------------------------------------------
// 				ARMOR TYPES
//--------------------------------------------------

const ARMOR_TYPE_HEAVY = 1
const ARMOR_TYPE_NORMAL = 0

const SKYBOXLEVEL	= "skybox_cam_level"
const SKYBOXSPACE 	= "skybox_cam_intro"

const CLOUDCOVERFXTIME = 6.5
const WARPINFXTIME = 2.7
//--------------------------------------------------
// 				FLEET SHIPS CORRECT SCALES
//--------------------------------------------------
const FLEET_MCOR_REDEYE 				= "models/vehicle/redeye/redeye2.mdl"
const FLEET_MCOR_REDEYE_1000X 			= "models/vehicle/redeye/redeye_skybox_1000scale.mdl"
const FLEET_MCOR_REDEYE_1000X_CLUSTERA	= "models/vehicle/space_cluster/redeye_space_clustera1000x.mdl"
const FLEET_MCOR_REDEYE_1000X_CLUSTERB	= "models/vehicle/space_cluster/redeye_space_clusterb1000x.mdl"
const FLEET_MCOR_REDEYE_1000X_CLUSTERC	= "models/vehicle/space_cluster/redeye_space_clusterc1000x.mdl"

const FLEET_MCOR_BIRMINGHAM 				= "models/vehicle/capital_ship_birmingham/birmingham_fleetscale.mdl"
const FLEET_MCOR_BIRMINGHAM_1000X 			= "models/vehicle/capital_ship_birmingham/birmingham_fleetscale_1000x.mdl"
const FLEET_MCOR_BIRMINGHAM_1000X_CLUSTERA 	= "models/vehicle/space_cluster/birmingham_space_clustera1000x.mdl"

const FLEET_MCOR_ANNAPOLIS 				= "models/vehicle/capital_ship_annapolis/annapolis_fleetscale.mdl"
const FLEET_MCOR_ANNAPOLIS_1000X 		= "models/vehicle/capital_ship_annapolis/annapolis_fleetscale_1000x.mdl"

const FLEET_MCOR_CROW_1000X_CLUSTERA	= "models/vehicle/space_cluster/crow_space_clustera1000x.mdl"
const FLEET_MCOR_CROW_1000X_CLUSTERB	= "models/vehicle/space_cluster/crow_space_clusterb1000x.mdl"

const FLEET_CAPITAL_SHIP_ARGO			= "models/vehicle/capital_ship_argo/capital_ship_argo.mdl"
const FLEET_CAPITAL_SHIP_ARGO_1000X		= "models/vehicle/capital_ship_argo/capital_ship_argo_1000x.mdl"

const FLEET_IMC_CARRIER					= "models/vehicle/imc_carrier/vehicle_imc_carrier.mdl"
const FLEET_IMC_CARRIER_1000X 			= "models/vehicle/imc_carrier/vehicle_imc_carrier_1000x.mdl"
const FLEET_IMC_CARRIER_1000X_CLUSTERA 	= "models/vehicle/space_cluster/imc_carrier_space_clustera_1000x.mdl"
const FLEET_IMC_CARRIER_1000X_CLUSTERB 	= "models/vehicle/space_cluster/imc_carrier_space_clusterb_1000x.mdl"
const FLEET_IMC_CARRIER_1000X_CLUSTERC 	= "models/vehicle/space_cluster/imc_carrier_space_clusterc_1000x.mdl"

const FLEET_IMC_WALLACE_1000x			= "models/vehicle/capital_ship_wallace/capital_ship_wallace_1000x.mdl"
const FLEET_IMC_WALLACE_1000X_CLUSTERA 	= "models/vehicle/space_cluster/ship_wallace_clustera_1000x.mdl"
const FLEET_IMC_WALLACE_1000X_CLUSTERB 	= "models/vehicle/space_cluster/ship_wallace_clusterb_1000x.mdl"
const FLEET_IMC_WALLACE_1000X_CLUSTERC 	= "models/vehicle/space_cluster/ship_wallace_clusterc_1000x.mdl"

const FLEET_IMC_GOBLIN_1000X 			= "models/vehicle/goblin_dropship/goblin_dropship_fleetscale_1000x.mdl"

//--------------------------------------------------
// 				MP_ANGEL_CITY CINEMATICS
//--------------------------------------------------

const HORNET_MISSILE_MODEL = "models/weapons/bullets/rocket_missile.mdl"
const SEARCH_DRONE_MODEL = "models/robots/agp/agp_hemlok_large.mdl"
const EFFECT_HORNET_MISSILE_TRAIL = "Rocket_Smoke_Large"
const EFFECT_HORNET_MISSILE_EXPLOSION = "P_impact_exp_XLG_concrete"
const HORNET_MISSILE_SFX_LOOP = "Weapon_ARL.Projectile"
const HORNET_MISSILE_SFX_IMPACT = "Default.Rocket_Explosion_3P_vs_3P"
const SKYBOX_REDEYE = "models/vehicle/redeye/redeye_skybox_1000scale.mdl"
const SKYBOX_BIRMINGHAM = "models/vehicle/capital_ship_Birmingham/birmingham_space1000x.mdl"
const CAPSHIP_BIRM_MODEL = "models/vehicle/capital_ship_birmingham/birmingham.mdl"
const CAPSHIP_ANNA_MODEL = "models/vehicle/capital_ship_annapolis/annapolis.mdl"
const FX_HORNET_DEATH =  "P_veh_exp_hornet_HS"


//--------------------------------------------------
// 				MP_FRACTURE CINEMATICS
//--------------------------------------------------

const SKYBOX_REFUEL_SPRITE_MODEL = "models/vistas/fracture_se_fuel.mdl"
const SKYBOX_REFUEL_SHIP_MODEL = "models/vehicle/redeye/redeye_background_01_LO.mdl"
const SKYBOX_ARMADA_SHIP_MODEL_REDEYE = "models/vehicle/redeye/redeye_background_01_LO.mdl"
const SKYBOX_ARMADA_SHIP_MODEL_BERMINGHAM = "models/vehicle/capital_ship_Birmingham/birmingham_space.mdl"

const MATCH_PROGRESS_RED_EYE_AND_ARMADA = 1
const MATCH_PROGRESS_AIR_ZINGERS = 4
const MATCH_PROGRESS_REFUEL_GOBLINS = 8

//--------------------------------------------------
// 				INTRO SKYSCALE SETTINGS
//--------------------------------------------------
const SKYSCALE_SPACE			= 0.0
const SKYSCALE_DEFAULT			= 1.0
const SKYSCALE_FRACTURE_WARP	= 0.25
const SKYSCALE_FRACTURE_DOOROPEN_ACTOR = 0.5
const SKYSCALE_FRACTURE_DOOROPEN_PLAYER = 0.33
const SKYSCALE_FRACTURE_IMC_ACTOR	= 0.5
const SKYSCALE_FRACTURE_IMC_SHIP	= 0.5
const SKYSCALE_FRACTURE_IMC_PLAYER	= 0.5

const SKYSCALE_COLONY_IMC_ACTOR		= 0.85
const SKYSCALE_COLONY_IMC_SHIP		= 0.7
const SKYSCALE_COLONY_IMC_PLAYER	= 0.7
const SKYSCALE_COLONY_MCOR_ACTOR	= 0.65
const SKYSCALE_COLONY_MCOR_SHIP		= 0.65
const SKYSCALE_COLONY_MCOR_PLAYER	= 0.65

const SKYSCALE_RELIC_IMC_ACTOR		= 0.9
const SKYSCALE_RELIC_IMC_SHIP		= 0.5
const SKYSCALE_RELIC_IMC_PLAYER		= 0.85
const SKYSCALE_RELIC_MCOR_ACTOR		= 0.5
const SKYSCALE_RELIC_MCOR_SHIP		= 0.5
const SKYSCALE_RELIC_MCOR_PLAYER	= 0.5

const SKYSCALE_OUTPOST_IMC_ACTOR	= 0.4
const SKYSCALE_OUTPOST_IMC_SHIP		= 0.4
const SKYSCALE_OUTPOST_IMC_PLAYER	= 0.4
const SKYSCALE_OUTPOST_DOOROPEN_IMC_ACTOR	= 0.9
const SKYSCALE_OUTPOST_DOOROPEN_IMC_SHIP	= 0.8
const SKYSCALE_OUTPOST_DOOROPEN_IMC_PLAYER	= 0.9
const SKYSCALE_OUTPOST_MCOR_ACTOR	= 0.5
const SKYSCALE_OUTPOST_MCOR_SHIP	= 0.4
const SKYSCALE_OUTPOST_MCOR_PLAYER	= 0.4
const SKYSCALE_OUTPOST_DOOROPEN_MCOR_ACTOR	= 1.0
const SKYSCALE_OUTPOST_DOOROPEN_MCOR_SHIP	= 0.8
const SKYSCALE_OUTPOST_DOOROPEN_MCOR_PLAYER	= 0.6

const SKYSCALE_BONEYARD_MCOR_ACTOR	= 0.5
const SKYSCALE_BONEYARD_MCOR_SHIP	= 0.6
const SKYSCALE_BONEYARD_MCOR_PLAYER	= 0.5
const SKYSCALE_BONEYARD_DOOROPEN_MCOR_ACTOR	= 0.85
const SKYSCALE_BONEYARD_DOOROPEN_MCOR_SHIP	= 1.0
const SKYSCALE_BONEYARD_DOOROPEN_MCOR_PLAYER= 0.8
const SKYSCALE_BONEYARD_IMC_ACTOR	= 0.5
const SKYSCALE_BONEYARD_IMC_SHIP	= 0.35
const SKYSCALE_BONEYARD_IMC_PLAYER	= 0.5
const SKYSCALE_BONEYARD_DOOROPEN_IMC_ACTOR	= 0.8
const SKYSCALE_BONEYARD_DOOROPEN_IMC_SHIP	= 1.0
const SKYSCALE_BONEYARD_DOOROPEN_IMC_PLAYER	= 0.8

const SKYSCALE_AIRBASE_MCOR_ACTOR	= 0.95
const SKYSCALE_AIRBASE_MCOR_SHIP	= 0.95
const SKYSCALE_AIRBASE_MCOR_PLAYER	= 0.95

const SKYSCALE_O2_MCOR_ACTOR		= 0.4
const SKYSCALE_O2_MCOR_SHIP			= 0.4
const SKYSCALE_O2_MCOR_PLAYER		= 0.4
const SKYSCALE_O2_DOOROPEN_MCOR_ACTOR		= 1.0
const SKYSCALE_O2_DOOROPEN_MCOR_SHIP		= 1.1
const SKYSCALE_O2_DOOROPEN_MCOR_PLAYER		= 0.9

const IMC_TRANSITION_TIME 				= 18.0
const IMC_ENTER_ATMOS_FX_TIME			= 4.0
const SKYSCALE_O2_FIRE_BUILDUP_TIME		= 14 //IMC_TRANSITION_TIME - IMC_ENTER_ATMOS_FX_TIME
const SKYSCALE_EJECT_TIME				= 1.0

const SKYSCALE_O2_DOORCLOSE_IMC_ACTOR	= 0.65
const SKYSCALE_O2_DOORCLOSE_IMC_SHIP	= 0.85
const SKYSCALE_O2_DOORCLOSE_IMC_PLAYER	= 0.65
const SKYSCALE_O2_EJECT_IMC_ACTOR		= 0.8
const SKYSCALE_O2_EJECT_IMC_SHIP		= 1.25//0.85
const SKYSCALE_O2_EJECT_IMC_PLAYER		= 0.8
const SKYSCALE_O2_FIRE_IMC_ACTOR		= 2.2
const SKYSCALE_O2_FIRE_IMC_SHIP			= 2.5
const SKYSCALE_O2_FIRE_IMC_PLAYER		= 2.2
const SKYSCALE_O2_IMC_ACTOR				= 0.55
const SKYSCALE_O2_IMC_SHIP				= 1.0
const SKYSCALE_O2_IMC_PLAYER			= 0.55


const SKYSCALE_CORPORATE_IMC_ACTOR	= 0.4
const SKYSCALE_CORPORATE_IMC_SHIP	= 0.4
const SKYSCALE_CORPORATE_IMC_PLAYER	= 0.4
const SKYSCALE_CORPORATE_DOOROPEN_IMC_ACTOR	= 0.9
const SKYSCALE_CORPORATE_DOOROPEN_IMC_SHIP	= 0.8
const SKYSCALE_CORPORATE_DOOROPEN_IMC_PLAYER= 0.9
const SKYSCALE_CORPORATE_MCOR_ACTOR	= 1.0
const SKYSCALE_CORPORATE_MCOR_SHIP	= 2.0
const SKYSCALE_CORPORATE_MCOR_PLAYER= 1.0

const SKYSCALE_CLASSIC_SHIP			= 0.7
const SKYSCALE_CLASSIC_PLAYER		= 0.9
const SKYSCALE_CLASSIC_ACTOR		= 0.9

//--------------------------------------------------
// 				MP_AIRBASE CINEMATICS
//--------------------------------------------------

const STRATON_SKYBOX_MODEL = "models/vehicle/straton/straton_imc_gunship_01_1000x.mdl"
const STRATON_MODEL = "models/vehicle/straton/straton_imc_gunship_01.mdl"
const BOMBER_MODEL = "models/vehicle/imc_bomber/bomber.mdl"
const GOBLIN_MODEL = "models/vehicle/goblin_dropship/goblin_dropship.mdl"
const RADAR_A_MODEL = "models/IMC_base/radar_a.mdl"
const RADAR_B_MODEL = "models/IMC_base/radar_b.mdl"
const RADAR_C_MODEL = "models/IMC_base/radar_c.mdl"
const RADAR_D_MODEL = "models/IMC_base/radar_d.mdl"
const RADAR_E_MODEL = "models/IMC_base/radar_e.mdl"
const RADAR_F_MODEL = "models/IMC_base/radar_f.mdl"
const RADAR_G_MODEL = "models/IMC_base/radar_g.mdl"
const RADAR_H_MODEL = "models/IMC_base/radar_h.mdl"
const RADAR_I_MODEL = "models/IMC_base/radar_i.mdl"
const RADAR_A_SKYBOX_MODEL = "models/IMC_base/radar_a_skybox.mdl"
const RADAR_B_SKYBOX_MODEL = "models/IMC_base/radar_b_skybox.mdl"
const RADAR_C_SKYBOX_MODEL = "models/IMC_base/radar_c_skybox.mdl"
const RADAR_D_SKYBOX_MODEL = "models/IMC_base/radar_d_skybox.mdl"
const RADAR_E_SKYBOX_MODEL = "models/IMC_base/radar_e_skybox.mdl"
const RADAR_F_SKYBOX_MODEL = "models/IMC_base/radar_f_skybox.mdl"
const RADAR_G_SKYBOX_MODEL = "models/IMC_base/radar_g_skybox.mdl"
const RADAR_H_SKYBOX_MODEL = "models/IMC_base/radar_h_skybox.mdl"
const RADAR_I_SKYBOX_MODEL = "models/IMC_base/radar_i_skybox.mdl"
const STRATON_SKYBOX_PARKED_MODEL = "models/vistas/straton_single01.mdl"
const BOMBER_SKYBOX_PARKED_MODEL = "models/vistas/bomber_single01.mdl"
const GOBLIN_DROPSHIP_MODEL = "models/vehicle/goblin_dropship/goblin_dropship.mdl"

//--------------------------------------------------
// 				CLASSIC_MP
//--------------------------------------------------

const CLASSIC_MP_DROPSHIP_IDLE_ANIM_TIME	= 5.0 //Time it takes from black team logo screen till end of animation idle animation. Past this time players will spawn on the ground
const CLASSIC_MP_SKYSHOW_DOGFIGHTS_DELAY	= 75.0 //Time it takes after EntitiesDidLoad before we start a skyshow of straton/hornet dogfights
const MIN_PICK_LOADOUT_TIME					= 5.0


//--------------------------------------------------
// 				PLAYER ABILITIES
//--------------------------------------------------

const ABILITY_TRAP_DETECTOR_DISTANCE 				= 2000
const ABILITY_TRAP_DETECTOR_TITANONLY 				= true
const ABILITY_HIGHLY_LETHAL_CRITICAL_MULTIPLIER 	= 1.1
const ABILITY_CLOAKED_SHOT_NUM_ALLOWED_SHOTS		= 1
const ABILITY_ENHANCED_CLOAK_ADDITIONAL_CLOAK_TIME 	= 3.0
const ABILITY_ENHANCED_CLOAK_RECHARGE_RATE_MOD 		= 0.85

//--------------------------------------------------
// 				PERFORMANCE
//--------------------------------------------------

// Performance
enum PerfIndexClient
{
	str1,
	PlayerCanEmbarkTitan1,
	PlayerCanEmbarkTitan2,
	FindBestEmbark,
	FindUserEvent,

	RunThreadsFrame,
	HudElementUpdate,
	HudElemUpdateLoop,
	CodeCallback_PreClientThreads,
	CodeCallback_HUDThink,
	CodeCallback_HUDThink_1,
	CodeCallback_HUDThink_2,
	CodeCallback_HUDThink_3,
	CodeCallback_HUDThink_4,
	CodeCallback_HUDThink_5,
	CodeCallback_HUDThink_6,
	FriendIconsTrace_Update,
	FriendIconsHUD_Update,
	HealthBarOverlayHUD_Update,
	UpdateCrosshair,
	SmartAmmo_UpdateHUD,
	OnEntityCreation,
	OnEntityDestroy,
	DamageIndicator,
	GrenadeIndicator,
	PilotThreatHud_Update,
	UpdateThreatIcons,
	UpdateDamageStates,
	UpdateEscalationDpadIcons,
	UpdateTitanModeHUD,
	Fracture_AATracers_1,
	Fracture_AATracers_2,
	Fracture_RefuelShips,
	ClusterShipsFireRocketsThink,
	CreateIndividualShipsFromCluster,
}

enum PerfIndexServer
{
	str1,
	PlayerCanEmbarkTitan1,
	PlayerCanEmbarkTitan2,
	FindBestEmbark,
	FindUserEvent,

	GetSpawnPointForStyle,
	CB_FindLeechTarget,
	CB_OnServerAnimEvent,
	CB_ClientCommand,
	ReportDevStat_Death,
	TraceLine,
	GetZiplineForPlayer,
	RespawnTitanPilot,
	NoSpawnAreaCheck,
	AIChatter,

	PersistentStatTracking,
	AirtimeChecks,
}

const PROMO_SCORE_ADVANCE_REQ = 50 // points required for promo win

const RANKED_GEM_PROGRESSION_ENABLED = true
const RANKED_RECALC_TIMESLICE = 1.8
const RANKED_PLAY = "ranked"

const RANKED_SPONSORSHIPS_START_VALUE = 5
const RANKED_SPONSORSHIPS_MAX_VALUE = 5
const RANKED_SPONSORSHIPS_DAYS_TILL_INVITE = 1
const RANKED_SPONSORSHIPS_INVITES_ADDED = 3

enum eRankedContributionType
{
	ASSAULT_PLUS_DEFENSE
	ASSAULT
	DEFENSE
	CTF_FLAG_ASSISTS
	CTF_FLAG_RETURNS
	CTF_FLAG_CAPTURES
	CTF_FLAG_CARRIER_KILLS
	DAMAGED_TITAN
	DAMAGED_PILOT
	DAMAGED_SPECTRE
	DAMAGED_GRUNT
	KILLS_TITAN
	KILLS_PILOT
	TDM_PILOT_KILLS
	TDM_PILOT_ASSISTS
	LOSS_PILOT_DEATH
	LOSS_TITAN_DEATH
	MarkedSurvival
	MarkedKilledMarked
	MarkedOutlastedEnemyMarked
	MarkedTargetKilled
	MarkedEscort
	LTS_PILOT_KILL
	TOTAL
}

const RANKED_TIER_COUNT 	= 5
const RANKED_DIVISION_COUNT = 5

const RANKED_DECAY_GEMS_LOST_PER_DAY = 1
const RANKED_INVALID_SEASON = -12345
const RANKED_SEASON_OFFSET = 539	// THIS NEEDS TO BE UPDATED AS SOON AS WE KNOW WHEN RANKED PLAY WILL SHIP SO THE FIRST PUBLIC SEASON IS SEASON 1, NOT > 1
const RANKED_SEASONS_PER_MONTH = 1

RANKED_SPLASH_COLORS_MAIN <- [ 139, 195, 98 ]
RANKED_SPLASH_COLORS_GLOW <- [ 34, 90, 65, 255 ]

const RANKED_SPLASH_COLORS_MAIN_STRING = "164 229 117 255"
const RANKED_SPLASH_COLORS_GLOW_STRING = "34 90 65 255"

const SharedPerfIndexStart = 100

enum PerfIndexShared
{
	RunThread,
	SmartAmmo_UpdateTargets,
	StringToColors,
	GetVortexSphereCurrentColor,
	CB_IsLeechable,
}

const EMP_BLAST_CHARGE_SOUND = "Titan_CoreAbility_Activate"
const EMP_BLAST_CHARGE_EFFECT = "P_titan_core_atlas_charge"

const TITAN_CORE_ACTIVE_TIME = 12.6
const TITAN_CORE_MARATHON_CORE_MULTIPLIER = 1.42
const TITAN_CORE_FIRST_BUILD_TIME = 200
const TITAN_CORE_BUILD_TIME = 200
const TITAN_CORE_CHARGE_TIME = 2.45
const TITAN_CORE_TIC_RATE = 3.8

const SHIELD_BOOST_R = 255
const SHIELD_BOOST_G = 225
const SHIELD_BOOST_B = 100

const SHIELD_BOOST_DAMAGE_DAMPEN = 0.5 // how much does ogre core protect shields?


const EVAC_OBJECTIVE_WAIT = 3.0
const EVAC_SHIP_ARRIVE_WAIT = 40.0
const EVAC_SHIP_IDLE_TIME = 12.0
const EVAC_BUFFER_TIME = 8.0 //Buffer time meant to cover the various waits we do in places in the evac script based on different gaem modes etc
const EVAC_SHIP_DAMAGE_MULTIPLIER_AGAINST_NUCLEAR_CORE = 0.5 //Multiply damage done against evac ship from nuclear core
const EVAC_SHIP_SHIELD_REGEN_TIME = 2.0 //Multiply damage done against evac ship from nuclear core
const EVAC_SHIP_SHIELD_REGEN_DELAY = 6.0 //Multiply damage done against evac ship from nuclear core


const EVAL_PASSENGER_INVULNERABILITY = true

enum ProgressSource
{
	PROGRESS_SOURCE_SCRIPTED,
	PROGRESS_SOURCE_ENTITY_HEALTH,
	PROGRESS_SOURCE_PLAYER_SUIT_POWER,
	PROGRESS_SOURCE_FRIENDLY_TEAM_SCORE,
	PROGRESS_SOURCE_ENEMY_TEAM_SCORE,
	PROGRESS_SOURCE_WEAPON_CHARGE_FRACTION,
	PROGRESS_SOURCE_WEAPON_READY_TO_FIRE_FRACTION,
	PROGRESS_SOURCE_WEAPON_CLIP_AMMO_FRACTION,
	PROGRESS_SOURCE_WEAPON_REMAINING_AMMO_FRACTION,

	PROGRESS_SOURCE_COUNT
};

const HOTDROP_IMPACT_FX_TABLE = "droppod_impact"

const FX_COLD_BREATH = "P_hmn_breath_cold_st"

// cinematic event flags; server controlled cinematics should set/clear these when active
const CE_FLAG_TITAN_SYNC_MELEE		= 0x0001
const CE_FLAG_INTRO					= 0x0002
const CE_FLAG_OUTRO					= 0x0004
const CE_FLAG_EMBARK				= 0x0008
const CE_FLAG_DISEMBARK				= 0x0010
const CE_FLAG_TITAN_HOT_DROP		= 0x0020
const CE_FLAG_CLASSIC_MP_SPAWNING	= 0x0040
const CE_FLAG_SONAR_PING			= 0x0080
const CE_FLAG_SONAR_ACTIVE			= 0x0100
const CE_FLAG_WAVE_SPAWNING			= 0x0200
const CE_FLAG_EOG_STAT_DISPLAY		= 0x0400

const CE_FLAG_PERMANENT_HIDEHUD		= 0x0800

const TITAN_DAMAGE_STAGE_FULL = 1.0
const TITAN_DAMAGE_STAGE_1 = 0.75
const TITAN_DAMAGE_STAGE_2 = 0.5
const TITAN_DAMAGE_STAGE_3 = 0.25
const TITAN_DAMAGE_STAGE_DOOMED = 0.0

const ABILITY_STIM_SPEED_MOD = 1.35
const ABILITY_STIM_REGEN_DELAY = 3.0
const ABILITY_STIM_REGEN_MOD = 2.0

const CONTENTS_EMPTY					= 0		// No contents
const CONTENTS_SOLID					= 0x00000001		// an eye is never valid in a solid
const CONTENTS_WINDOW					= 0x00000002		// translucent, but not watery (glass)
const CONTENTS_AUX						= 0x00000004
const CONTENTS_GRATE					= 0x00000008		// alpha-tested "grate" textures.  Bullets/sight pass through, but solids don't
const CONTENTS_SLIME					= 0x00000010
const CONTENTS_WATER					= 0x00000020
const CONTENTS_WINDOW_NOCOLLIDE			= 0x00000040
const CONTENTS_OPAQUE					= 0x00000080	// things that cannot be seen through (may be non-solid though)
const CONTENTS_TESTFOGVOLUME			= 0x00000100
const CONTENTS_UNUSED					= 0x00000200
const CONTENTS_BLOCKLIGHT				= 0x00000400
const CONTENTS_TEAM1					= 0x00000800	// per team contents used to differentiate collisions
const CONTENTS_TEAM2					= 0x00001000	// between players and objects on different teams
const CONTENTS_IGNORE_NODRAW_OPAQUE		= 0x00002000
const CONTENTS_MOVEABLE					= 0x00004000
const CONTENTS_PLAYERCLIP				= 0x00010000		// blocks human players
const CONTENTS_MONSTERCLIP				= 0x00020000
const CONTENTS_BRUSH_PAINT				= 0x00040000
const CONTENTS_BLOCKLOS					= 0x00080000		// block AI line of sight
const CONTENTS_NOCLIMB					= 0x00100000
const CONTENTS_TITANCLIP				= 0x00200000		// blocks titan players
const CONTENTS_BULLETCLIP				= 0x00400000
const CONTENTS_UNUSED5					= 0x00800000
const CONTENTS_ORIGIN					= 0x01000000		// removed before bsping an entity
const CONTENTS_MONSTER					= 0x02000000		// should never be on a brush, only in game
const CONTENTS_DEBRIS					= 0x04000000
const CONTENTS_DETAIL					= 0x08000000		// brushes to be added after vis leafs
const CONTENTS_TRANSLUCENT				= 0x10000000		// auto set if any surface has trans
const CONTENTS_LADDER					= 0x20000000
const CONTENTS_HITBOX					= 0x40000000		// use accurate hitboxes on trace

const SONAR_PULSE_DURATION = 0.65
const SONAR_PULSE_DELAY = 0.75
const SONAR_PULSE_SPEED = 2000
const SONAR_PULSE_RANGE_MAX = 2000
const SONAR_PULSE_SPEED_DMR = 3500
const SONAR_PULSE_RANGE_MAX_DMR = 3500


const TITAN_HEALTHDROP_REGENFRAC	= 0.3
const TITAN_HEALTHDROP_REGENTIME	= 5.0
const TITAN_HEALTHDROP_TIMEOUT		= 30.0

const MAX_WEAPON_FIRE_ID	= 4

const OFFHAND_EQUIPMENT		= 2
const OFFHAND_LEFT			= 1
const OFFHAND_RIGHT			= 0

const SHIELD_REGEN_TICK_TIME 					= 0.1
const HARVESTER_BEAM_TICK_TIME					= 1.0
const TITAN_SHIELD_HEALTH						= 2250
const TITAN_SHIELD_REGEN_DELAY					= 6.0
const TITAN_SHIELD_REGEN_TIME					= 2.0
const TITAN_SHIELD_PERMAMENT_DAMAGE_FRAC		= 0.25
const TITAN_SHIELD_PERMAMENT_DAMAGE_FRAC_PILOT	= 0.50

// vdu static. Maybe have a client only _consts?
const STATIC_RANDOM = 0
const STATIC_HEAVY = 1
const STATIC_LIGHT = 2

const TURBO_WARP_FX = "P_warp_in_atlas"
const TURBO_WARP_COMPANY = "hotdrop_hld_warp"

const SATCHEL_DETONATE_DELAY = 0.0

//Match Progress.
const MATCH_PROGRESS_EARLY = 30
const MATCH_PROGRESS_MID = 60
const MATCH_PROGRESS_LATE = 90
const MATCH_PROGRESS_OVER_NO_ANNOUNCEMENT = 120
MATCH_PROGRESS_THRESHOLDS <- [ MATCH_PROGRESS_EARLY, MATCH_PROGRESS_MID, MATCH_PROGRESS_LATE, MATCH_PROGRESS_OVER_NO_ANNOUNCEMENT ]

// IMPORTANT: Please add new items types to the *bottom* of this enum list!
// This enum is mirrored in C++ so deleting, inserting before or rearranging
// existing item types will break C++ code. Adding new items to the end will not!
enum itemType
{
	PILOT_SETFILE,
	PILOT_PRIMARY,
	PILOT_SECONDARY,
	PILOT_SIDEARM,
	PILOT_SPECIAL,
	PILOT_ORDNANCE,
	PILOT_ORDNANCE_MOD,
	PILOT_PRIMARY_ATTACHMENT,
	PILOT_PRIMARY_MOD,
	PILOT_SECONDARY_MOD,
	PILOT_SIDEARM_MOD,
	PILOT_PASSIVE1,
	PILOT_PASSIVE2,
	TITAN_SETFILE,
	TITAN_PRIMARY,
	TITAN_SPECIAL,
	TITAN_ORDNANCE,
	TITAN_PRIMARY_MOD,
	TITAN_SPECIAL_MOD,
	TITAN_ORDNANCE_MOD,
	TITAN_PASSIVE1,
	TITAN_PASSIVE2,
	TITAN_OS,
	EVENT_PASSIVE,
	RACE,
	NOT_LOADOUT,
	TITAN_DECAL
}

//server passives. Client has the var so it can create burn cards etc. but doesn't know which server passives the player has.
::SFLAG_DOUBLE_XP			<- 0x00001
::SFLAG_FAST_BUILD1 		<- 0x00002
::SFLAG_HUNTER_GRUNT 		<- 0x00004
::SFLAG_HUNTER_SPECTRE		<- 0x00008
::SFLAG_HUNTER_PILOT 		<- 0x00010
::SFLAG_HUNTER_TITAN 		<- 0x00020
::SFLAG_FAST_BUILD2 		<- 0x00040
::SFLAG_BC_FAST_MOVESPEED	<- 0x00080
::SFLAG_STIM_OFFHAND		<- 0x00100
::SFLAG_SPECTRE_VIRUS		<- 0x00200
::SFLAG_INSTANT_HACK		<- 0x00400
::SFLAG_BC_EXPLOSIVE_PUNCH	<- 0x00800
::SFLAG_BC_DASH_CAPACITY	<- 0x01000
::SFLAG_COOP_ORDNANCE_CAPACITY_1 	<- 0x02000
//::SFLAG_					<- 0x04000
//::SFLAG_					<- 0x08000
//::SFLAG_					<- 0x10000
//::SFLAG_					<- 0x20000
//::SFLAG_					<- 0x40000
//::SFLAG_					<- 0x80000
//::SFLAG_					<- 0x100000
//::SFLAG_					<- 0x200000
//::SFLAG_					<- 0x400000
//::SFLAG_					<- 0x800000
//::SFLAG_					<- 0x1000000
//::SFLAG_					<- 0x2000000
//::SFLAG_					<- 0x4000000
//::SFLAG_					<- 0x8000000
//::SFLAG_					<- 0x10000000
//::SFLAG_					<- 0x20000000
//::SFLAG_					<- 0x40000000
//::SFLAG_					<- 0x80000000


const RACE_HUMAN_FEMALE = "race_human_female"

const BURN_CARD_MAP_LOOT_DROP = 0
const BURNCARD_WARNING_COUNT = 5

const MAX_BURN_CARD_PACKS_EVER = 50
const BURNCARD_INDEX_EMPTY = -1
// burn card groups
const BCGROUP_SPEED 	= 0
const BCGROUP_STEALTH	= 1
const BCGROUP_INTEL		= 2
const BCGROUP_BONUS 	= 3
const BCGROUP_NPC 		= 4
const BCGROUP_WEAPON 	= 5
const BCGROUP_MISC 		= 6
const BCGROUP_DICE 		= 7
const BC_GROUPINGS		= 8

const BURNCARDS_PER_PACK = 7

const BURNCARD_PACK_PER_XP = 8000.0
const BURNCARD_COMMON = 0
const BURNCARD_RARE = 2
const CARDS_PER_PAGE = 12.0
const CARDS_PER_ROW = 6.0

const BURN_CARD_WARMUP_TIME = 3.0
const INGAME_BURN_CARDS = 3
const MAX_BURN_CARDS = 72
const MAX_UNOPENED_BURNCARDS = 25
const MAX_UNOPENED_EXCHANGED_BURNCARDS = 6
const MAX_MAILED_CARDS = 30
const MAX_UNOPENED_PACKS = 99

const PILE_DECK = 0
const PILE_ACTIVE = 1
const PILE_NEW = 2
//const PILE_MAIL = 1

//const NEW_CARD_DELIVERY_PACK 				= 0x00001
//const NEW_CARD_DELIVERY_CARDS				= 0x00002
//const NEW_CARD_DELIVERY_EXCHANGE 			= 0x00004
//const NEW_CARD_DELIVERY_FULL	 			= 0x00008
//const NEW_CARD_DELIVERY_REQUEST_EXCHANGE 	= 0x00010
//const NEW_CARD_DELIVERY_NEW_SLOT		 	= 0x00020


const READING_NONE = -1
const READING_IN_PROGRESS 			= 0
const READING_WAITING_TO_CONTINUE 	= 1
const READING_DONE					= 2


const BURNCARD_REWARD_VAL_1 =  80  // 40
const BURNCARD_REWARD_VAL_2 = 140  //100
const BURNCARD_REWARD_VAL_3 = 260  //160

const BURNCARD_STORY_PROGRESS_NONE 		= 0
const BURNCARD_STORY_PROGRESS_INTRO 	= 1
//const BURNCARD_STORY_PROGRESS_HINT 		= 2
//const BURNCARD_STORY_PROGRESS_3CARDS	= 3
//const BURNCARD_STORY_PROGRESS_MORECARDS	= 4
const BURNCARD_STORY_PROGRESS_COMPLETE	= 5

const BURNCARD_FAST_MOVESPEED = 1.20
const BURNCARD_AUTO_SONAR_INTERVAL = 6.5
const BURNCARD_AUTO_SONAR_IMAGE_DURATION = 1.5

const RODEO_ASSIST_DIST = 1000

enum eTitanAvailability
{
	Default,
	Always,
	Once,
	Never,
	Custom,

	LastTitanAvailability
}

enum eSpawnAsTitan
{
	Default,
	Always,
	Once,
	Never,

	LastSpawnAsTitan
}

enum eWaveSpawnType
{
	DISABLED,				// not used
	FIXED_INTERVAL,			// spawn every 30 seconds (depending on WAVE_SPAWN_INTERVAL)
	PLAYER_DEATH,			// spawn 30 seconds after the first player to die in a new wave. (per team)
	MANUAL					// set the spawn time manually
}

enum eAllowNPCs
{
	Default,
	None,
	GruntOnly,
	SpectreOnly,

	LastAllowNPCs
}

enum eAILethality
{
	Default,
	High,
	VeryHigh,

	TD_Low,		//even Lower weapon proficiency than TD_Medium, laxer on fast players. standard titan health, increased generator health
	TD_Medium,	//Lower weapon proficiency than TD_High, same modifier against fast players. standard titan health, increased generator health
	TD_High,	//tower defense standard... same settings as high, but not more health for spectres

	LastAILethality
}

const TD_LOW_SCALAR_SPECTREHEALTH 		= 0.66 	//at low, spectre health is reduced by .66
const TD_MED_SCALAR_SPECTREHEALTH 		= 0.83 	//at med, spectre health is reduced by .83

const TD_MED_SCALAR_TITANHEALTH			= 1.25 	//at med, titan health is increased by 1.25
const TD_LOW_SCALAR_TITANHEALTH			= 1.10 	//at low, titan health is increased by 1.10

const TD_LOW_SCALAR_GENERATOR_DMG	 	= 0.75 	//at low, the generator takes 25% less damage from everything

const TD_MED_SUICIDE_TITANDMG 			= 2000	//at med, the amount of damage to titans
const TD_MED_SUICIDE_PILOTDMG 			= 300	//at med, the amount of damage to pilots

const TD_LOW_SUICIDE_TITANDMG 			= 1600	//at low, the amount of damage to titans
const TD_LOW_SUICIDE_PILOTDMG 			= 200	//at low, the amount of damage to pilots

enum eFloorIsLava
{
	Default,
	Enabled,
	Disabled,

	LastFloorIsLava
}

enum eMinimapState
{
	Default,
	Hidden,

	LastMinimapState
}

enum eOSPState
{
	Default,
	PistolsOnly,
	FromTitanOnly,
	FirstSpawnOnly,

	LastOSPState
}

enum eAmmoLimit
{
	Default,
	Limited,
	None,

	LastAmmoLimit
}

enum eEliminationMode
{
	Default,
	Pilots,
	Titans,
	PilotsTitans,

	LastEliminationMode
}

enum eTitanExitEnabled
{
	Default,
	Never,
	DisembarkOnly,

	LastTitanExit
}

/*
	pistols only
	loadout from titan only (pistols only implied)
	loadout on first spawn only (pistols only implied)
*/

enum eFlagState
{
	None,
	Home,
	Held,
	Away,
}

const COUNT_ENABLED = 1
const BURN_CARD_COUNT_MAX = 99

g_weaponEffects <- {}

const CLOAK_INCLUDE_FADE_IN_TIME = true
const CLOAK_EXCLUDE_FADE_IN_TIME = false

const MARVIN_TYPE_SHOOTER      = 0
const MARVIN_TYPE_WORKER       = 1
const MARVIN_TYPE_MARVINONE    = 2
const MARVIN_TYPE_FIREFIGHTER  = 3

enum eLobbyType
{
	SOLO,
	PARTY_LEADER,
	PARTY_MEMBER,
	MATCH,
	PRIVATE_MATCH
}

enum mainMenuState
{
	ERROR,
	SIGNING_IN,
	SIGNED_IN,
	SIGNED_OUT
}

// Don't remove items from this list once the game is in production
// Xbox live analytics needs the numbers for each map to stay the same
// Only add new entries to the bottom of the list
enum eMaps
{
	invalid = -1,
	mp_lobby,
	mp_fracture,
	mp_nexus,
	mp_overlook,
	mp_airbase,
	mp_outpost_207,
	mp_corporate,
	mp_boneyard,
	mp_runoff,
	mp_angel_city,
	mp_lagoon,
	mp_o2,
	mp_scorch,
	mp_smugglers_cove,
	mp_rise,
	mp_relic,
	mp_colony,
	mp_training_ground,
	mp_npe,
	mp_wargames,
	mp_swampland,
	mp_harmony_mines,
	mp_haven,
	mp_switchback,
	mp_zone_18,
	mp_backwater,
	mp_sandtrap,
	mp_box,
	mp_nest2,
	mp_mia
}

enum ePrivateMatchMaps
{
	mp_fracture,
	mp_nexus,
	mp_overlook,
	mp_airbase,
	mp_outpost_207,
	mp_corporate,
	mp_boneyard,
	mp_angel_city,
	mp_lagoon,
	mp_o2,
	mp_smugglers_cove,
	mp_rise,
	mp_relic,
	mp_colony,
	mp_training_ground,
	mp_runoff,
	mp_swampland,
	mp_wargames,
	mp_harmony_mines,
	mp_haven,
	mp_switchback,
	mp_backwater,
	mp_sandtrap,
	mp_zone_18,
	mp_box,
	mp_nest2,
	mp_mia,
	mp_npe
}

enum ePrivateMatchModes
{
	at,
	coop,
	campaign_carousel,
	cp,
	ctf,
	lts,
	wlts,
	tdm,
	mfd,
	mfdp,
	ps,
	scv,
	ttdm,
	tmfd,
	tmfdp,
	all,
	all_mini,
	ctt,
	ffa,
	gg
}



enum eEventNotifications
{
	Clear,
	PlayerHasEnemyFlag,
	PlayerCapturedEnemyFlag,
	PlayerReturnedEnemyFlag,
	PlayerDroppedEnemyFlag,
	PlayerHasFriendlyFlag,
	PlayerCapturedFriendlyFlag,
	PlayerReturnedFriendlyFlag,
	PlayerDroppedFriendlyFlag,
	ReturnedFriendlyFlag,
	ReturnedEnemyFlag,
	YouHaveTheEnemyFlag,
	YouCapturedTheEnemyFlag,
	YouDroppedTheEnemyFlag,
	YouReturnedFriendlyFlag,
	YouWillRespawnNextRound,
	BurnCardRematch,
	MarkedForDeathWaitingForMarkedToSpawn,
	MarkedForDeathMarkedDisconnected,
	MarkedForDeathYouWillBeMarkedNext,
	MarkedForDeathCountdownToNextMarked,
	MarkedForDeathKill,
	BeingRevived,
	WipedOut,
	NeedRevive,
	YouHaveTheTitan,
	FriendlyPlayerHasTheTitan,
	EnemyPlayerHasTheTitan,
	YouWillRespawnIn,
	CoopTDStart,
	CoopTDWave,
	CoopTDWon,
	CoopTDWaveLost,
	CoopTDLost,
	CoopTDWaveRestart,
	CoopAmmoRefilled,
	TurretAvailable,
	MaxTurretsPlaced,
	CoopPlayerConnected,
	CoopPlayerDisconnected,
	CoopDifficultyUp,
	CoopDifficultyDown,
	PlayerHasTheTitan,
	PlayerDestroyedTheTitan,
	PlayerCapturedTheTitan,
	PlayerLeftTheTitan,
	PlayerFirstStrike,
	RoundWinningKillReplayCancelled,
	TeammateAutobalanced,
	EnemyAutobalanced,
	YouWereAutobalanced,
	YouWillBeAutobalanced,
	MarkedForDeathMarkedAutobalanced,
	AutoBalanceCooldown,
	UplinkLocatingNextPanel,
	TeammateSwitchedTeams,
	EnemySwitchedTeams,
	YouSwitchedTeams,
}

enum ePrivateMatchStartState
{
	NOT_READY,
	READY,
	STARTING,
}

enum eCampaignFinishedNum
{
	NONE,
	FIRSTTIME,
	NUMEROUS
}

enum eCampaignReward
{
	REWARD_NONE,
	REWARD_STRYDER,
	REWARD_OGRE
}

//--------------------------------------------------
// 				SMART GLASS
//--------------------------------------------------

const SMARTGLASS_PROP_PLAYERTEAM 	= "team"
const SMARTGLASS_PROP_PLAYERCLASS 	= "playerClass"
const SMARTGLASS_PROP_PLAYLIST 		= "playlist"
const SMARTGLASS_PROP_GAMETYPE 		= "gameType"
const SMARTGLASS_PROP_GAMEMODE		= "gameMode"
const SMARTGLASS_PROP_NEXTLEVEL		= "nextLevel"
const SMARTGLASS_PROP_ISALIVE		= "isAlive"
const SMARTGLASS_PROP_LASTKILLED	= "lastKilled"
const SMARTGLASS_PROP_LASTKILLEDBY	= "lastKilledBy"


const TITANFALL_INNER_RADIUS = 90
const TITANFALL_OUTER_RADIUS = 120

const TITANHOTDROP_DISABLE_ENEMY_TITANFALL_RADIUS = 250


// mp_o2
const FIRST_WARNING_PROGRESS  = 27
const SECOND_WARNING_PROGRESS = 54
const THIRD_WARNING_PROGRESS  = 76
const O2_DEV_DISABLE_HARDPOINT_FX	= false
const O2_DEV_DISABLE_SKYSHOW 		= false


const SCOREBOARD_MATERIAL_FRIENDLY_PLAYER_EVEN = "../ui/menu/scoreboard/friendly_player"
const SCOREBOARD_MATERIAL_FRIENDLY_PLAYER_ODD = "../ui/menu/scoreboard/friendly_player_dots"
const SCOREBOARD_MATERIAL_FRIENDLY_SLOT = "../ui/menu/scoreboard/friendly_slot"
const SCOREBOARD_MATERIAL_ENEMY_PLAYER_EVEN = "../ui/menu/scoreboard/enemy_player"
const SCOREBOARD_MATERIAL_ENEMY_PLAYER_ODD = "../ui/menu/scoreboard/enemy_player_dots"
const SCOREBOARD_MATERIAL_ENEMY_SLOT = "../ui/menu/scoreboard/enemy_slot"
const SCOREBOARD_MATERIAL_MIC_INACTIVE = "../ui/menu/scoreboard/sb_icon_voip_default"
const SCOREBOARD_MATERIAL_MIC_ACTIVE = "../ui/menu/scoreboard/sb_icon_voip_talk"
const SCOREBOARD_MATERIAL_MIC_MUTED = "../ui/menu/scoreboard/sb_icon_voip_mute"
const SCOREBOARD_MATERIAL_MIC_PARTYCHAT = "../ui/menu/scoreboard/sb_icon_voip_party_talk"
const SCOREBOARD_MATERIAL_STATUS_DEAD = "../ui/icon_status_dead"
const SCOREBOARD_MATERIAL_STATUS_TITAN = "../ui/icon_status_titan"
const SCOREBOARD_MATERIAL_STATUS_PILOT = "../ui/icon_status_pilot"

const SCOREBOARD_MATERIAL_STATUS_ALIVE_WITH_PET = "../ui/icon_status_alive_with_titan"
const SCOREBOARD_MATERIAL_STATUS_DEAD_WITH_PET = "../ui/icon_status_dead_with_titan"
const SCOREBOARD_MATERIAL_STATUS_EVAC = "../ui/icon_status_evac"

//The reason for the dual icons is that the enemy background is too similar to the Burn Card orange, so we darken it a little bit to make the image pop.
const SCOREBOARD_MATERIAL_STATUS_TITAN_BURN 						= "../ui/icon_status_titan_burn"
const SCOREBOARD_MATERIAL_STATUS_TITAN_BURN_ENEMY 					= "../ui/icon_status_titan_burn"
const SCOREBOARD_MATERIAL_STATUS_PILOT_BURN 						= "../ui/icon_status_pilot_burn"
const SCOREBOARD_MATERIAL_STATUS_PILOT_BURN_ENEMY					= "../ui/icon_status_pilot_burn"
const SCOREBOARD_MATERIAL_STATUS_ALIVE_WITH_PET_PILOT_BURN 			= "../ui/icon_status_alive_with_titan_pilot_burn"
const SCOREBOARD_MATERIAL_STATUS_ALIVE_WITH_PET_PILOT_BURN_ENEMY 	= "../ui/icon_status_alive_with_titan_pilot_burn"
const SCOREBOARD_MATERIAL_STATUS_ALIVE_WITH_PET_TITAN_BURN 			= "../ui/icon_status_alive_with_titan_titan_burn"
const SCOREBOARD_MATERIAL_STATUS_ALIVE_WITH_PET_TITAN_BURN_ENEMY	= "../ui/icon_status_alive_with_titan_titan_burn"
const SCOREBOARD_MATERIAL_STATUS_DEAD_WITH_PET_BURN 				= "../ui/icon_status_dead_with_titan_burn"
const SCOREBOARD_MATERIAL_STATUS_DEAD_WITH_PET_BURN_ENEMY			= "../ui/icon_status_dead_with_titan_burn"

const SCOREBOARD_MATERIAL_CONNECTION_QUALITY_1 = "../ui/menu/scoreboard/connection_quality_1"
const SCOREBOARD_MATERIAL_CONNECTION_QUALITY_2 = "../ui/menu/scoreboard/connection_quality_2"
const SCOREBOARD_MATERIAL_CONNECTION_QUALITY_3 = "../ui/menu/scoreboard/connection_quality_3"
const SCOREBOARD_MATERIAL_CONNECTION_QUALITY_4 = "../ui/menu/scoreboard/connection_quality_4"
const SCOREBOARD_MATERIAL_CONNECTION_QUALITY_5 = "../ui/menu/scoreboard/connection_quality_5"
const SCOREBOARD_MATERIAL_PILOT_KILLS = "../ui/menu/scoreboard/sb_icon_pilot_kills"
const SCOREBOARD_MATERIAL_TITAN_KILLS = "../ui/menu/scoreboard/sb_icon_titan_kills"
const SCOREBOARD_MATERIAL_NPC_KILLS = "../ui/menu/scoreboard/sb_icon_npc_kills"
const SCOREBOARD_MATERIAL_ASSISTS = "../ui/menu/scoreboard/sb_icon_assists"
const SCOREBOARD_MATERIAL_DEATHS = "../ui/menu/scoreboard/sb_icon_deaths"
const SCOREBOARD_MATERIAL_SCORE = "../ui/menu/scoreboard/sb_icon_score"
const SCOREBOARD_MATERIAL_HARDPOINT = "../ui/menu/scoreboard/sb_icon_hardpoint"
const SCOREBOARD_MATERIAL_ASSAULT = "../ui/menu/scoreboard/sb_icon_assault"
const SCOREBOARD_MATERIAL_DEFENSE = "../ui/menu/scoreboard/sb_icon_defense"
const SCOREBOARD_MATERIAL_FLAG_RETURN = "../ui/menu/scoreboard/sb_icon_flag_return"
const SCOREBOARD_MATERIAL_FLAG_CAPTURE = "../ui/menu/scoreboard/sb_icon_flag_capture"
const SCOREBOARD_MATERIAL_MARKED_FOR_DEATH_TARGET_KILLS = "../ui/menu/scoreboard/sb_icon_marked_for_death"
const SCOREBOARD_MATERIAL_VICTORY_CONTRIBUTION = "../ui/menu/scoreboard/sb_icon_victory_contribution"

const SCOREBOARD_MATERIAL_PROMO = "../ui/menu/rank_icons/promo"

//--------------------------------------------------
// 				COOP / TOWER DEFENSE
//--------------------------------------------------
enum eMissionType
{
	BOUNTY			// 0
	TOWERDEFENSE	// 1
	SCAVENGERHUNT	// 2

	// must be last
	MISSION_COUNT
}

enum eCoopAIType
{
	empTitan
	nukeTitan
	mortarTitan
	titan
	cloakedDrone
	suicideSpectre
	sniperSpectre
	spectre
	grunt
	bubbleShieldGrunt
	bubbleShieldSpectre
}

const COOP_ENEMY_POINT_VALUE_TITAN						= 5
const COOP_ENEMY_POINT_VALUE_NUKE_TITAN					= 5
const COOP_ENEMY_POINT_VALUE_MORTAR_TITAN				= 5
const COOP_ENEMY_POINT_VALUE_EMP_TITAN					= 5
const COOP_ENEMY_POINT_VALUE_SUICIDE_SPECTRE			= 1
const COOP_ENEMY_POINT_VALUE_SNIPER_SPECTRE				= 1
const COOP_ENEMY_POINT_VALUE_SPECTRE					= 1
const COOP_ENEMY_POINT_VALUE_BUBBLE_SHIELD_SPECTRE		= 1
const COOP_ENEMY_POINT_VALUE_BUBBLE_SHIELD_GRUNT		= 1
const COOP_ENEMY_POINT_VALUE_CLOAKED_DRONE				= 1
const COOP_ENEMY_POINT_VALUE_GRUNT						= 1

enum eCoopTeamScoreEvents
{
	wave_complete
	final_wave_complete
	harvester_health
	first_try
	difficulty_bonus
	star_reward
	retry_bonus
	retries_bonus
	enemies_killed
	flawless_wave
}

const GAME_WINNER_DETERMINED_RETRY_WAIT_COOP 		= 12.0  // time between failure and retry

const WAVESPAWN_PROTECTION_TIME					= 3.0

const COOP_NEWENEMY_ANNOUNCE_CARD_SCALE_OUT 	= 1.0
const COOP_NEWENEMY_ANNOUNCE_CARD_SCALE_IN 		= 1.0
const COOP_NEWENEMY_ANNOUNCE_MAX_CARDS 			= 6  // max cards displayed onscreen at once
const COOP_NEWENEMY_ANNOUNCE_CARD_FOCUS_TIME 	= 8.0
const COOP_NEWENEMY_ANNOUNCE_CARD_MOVE_TIME 	= 0.1  // how long it takes for the cards slide in and out
const COOP_NEWENEMY_ANNOUNCE_HEADER_DELAY 		= 0.65  // how soon after the header displays will the first enemy card display
const COOP_NEWENEMY_ANNOUNCE_CARD_ADD_DELAY 	= 0.4  // how long to wait between adding cards to the onscreen list
const COOP_NEWENEMY_ANNOUNCE_CARD_REMOVE_DELAY 	= 0.1  // how long to wait between removing cards from the onscreen list

// DEPRECATED this should be controlled with playlist variable
const COOP_MAX_PLAYER_COUNT				= 4
const COOP_RESTARTS						= 2
const COOP_RESTARTS_MP_RISE 			= 1

const COOP_SENTRY_TURRET_MAX_COUNT_PET		= 3	// don't try to set it to more then 3
const COOP_SENTRY_TURRET_MAX_COUNT_INV		= 3
const COOP_TURRET_TOTAL_KILLS_TO_LEVEL_UP	= 10
const COOP_TURRET_TITAN_KILLS_TO_LEVEL_UP	= 1

const TD_GENERATOR_HEALTH				= 30000.0
const TD_GENERATOR_SHIELD_HEALTH		= 3000.0
const GENERATOR_SHIELD_REGEN_DELAY		= 10.0
const GENERATOR_SHIELD_REGEN_TIME		= 10.0

// message splash SFX stomps our VO
const COOP_POST_HUDSPLASH_VO_WAIT 		= 1.7
const COOP_POST_HUDSPLASH_VO_WAIT_LONG 	= 3.6  // one of the sounds is louder for longer

const COOP_POST_MATCH_SCREEN_FADE_DURATION = 3.0

const GENERATOR_DAMAGE_STREAK_TIMEOUT 					= 10.0  // NPCs have to damage the generator within this amount of time to keep a "damage streak" alive

const GENERATOR_THREAT_WARN_STREAKDMG_GLOBAL 			= 10000
const GENERATOR_THREAT_WARN_DIST_TITAN 					= 2500
const GENERATOR_THREAT_WARN_STREAKDMG_MORTAR_TITANS 	= 4000  // these types of AI have to do much damage in a streak to trigger a warning
const GENERATOR_THREAT_WARN_STREAKDMG_SUICIDE_SPECTRES 	= 1500  // (150 dmg per suicide explosion)
const GENERATOR_THREAT_WARN_DIST_INFANTRY 				= 1500
const GENERATOR_THREAT_WARN_NUM_REQ_INFANTRY 			= 16

const COOP_TURRET_ACCURACY_MULTIPLIER	= 2.0	// 1.0 old
const COOP_TURRET_HEALTH				= 1000	// 1200 old

const MODEL_GEN_TOWER 					= "models/props/generator_coop/generator_coop.mdl"
const MODEL_GEN_TOWER_RINGS 			= "models/props/generator_coop/generator_coop_rings_animated.mdl"
const MODEL_MEGA_TURRET					= "models/turrets/turret_imc_lrg.mdl"
const MODEL_CONTROL_PANEL				= "models/communication/terminal_usable_imc_01.mdl"
const MODEL_BIGBROTHER_PANEL			= "models/communication/terminal_usable_dem_01.mdl"
const LOADOUT_CRATE_MODEL				= "models/containers/pelican_case_ammobox.mdl"
const MODEL_BUBBLESHIELD_SPECTRE		= "models/Robots/spectre/spectre_corporate.mdl"
const SUICIDE_SPECTRE_MODEL				= "models/Robots/spectre/spectre_corporate.mdl"
const SNIPER_SPECTRE_MODEL				= "models/Robots/spectre/spectre_corporate.mdl"
const CLOAKED_DRONE_MODEL				= "models/robots/agp/agp_hemlok_larger.mdl"
const LAPTOP_MODEL_SMALL 				= "models/communication/terminal_usable_airbase.mdl"

const FX_GEN_HARVESTER_BEAM				= "P_harvester_beam"
const FX_GEN_HEALTH_LOW 				= "P_harvester_damaged_1"
const FX_HARVESTER_SHIELD				= "P_coop_harvester_CP"
const FX_HARVESTER_SHIELD_BREAK			= "P_coop_harvester_break_CP"
const FX_SPECTRE_BUBBLESHIELD 			= "P_spectre_shield_hld"
const FX_SPECTRE_GOING_CRITICAL_1		= "P_spectre_suicide_warn"
const FX_SPECTRE_EXPLOSION				= "P_spectre_suicide"	//"xo_exp_death" is over the top
const FX_SPECTRE_DEACTIVATING			= "titan_doom_state_sparks_1"
const FX_SPECTRE_DEACTIVATED_SPARKS		= "weld_spark_01_sparksfly"
const FX_DRONE_CLOAK_BEAM 				= "P_drone_cloak_beam"
const FX_EMP_FIELD						= "P_xo_emp_field"

const TIME_BETWEEN_OBJ					= 10
const TIME_BEFORE_CHECKPOINT_RESTART	= 1
const TIME_BEFORE_OBJECTIVE_RESTART		= 6

const MINION_BUBBLE_SHIELD_RADIUS		= 230
const MINION_BUBBLE_SHIELD_RADIUS_SQR	= 51984		//228 * 228 ... we give some slack for floating point error

const COOPMINIMAPSCALE					= 1.65
const MINIMAP_LOADOUT_CRATE_SCALE		= 0.075
const COOP_MAX_ACTIVE_TITANS			= 10
const COOP_MAX_ACTIVE_CLOAKED_DRONES	= 3

// Generator damage callback sometimes tweaks AI weapon damage numbers to be better for coop
const GENERATOR_DAMAGE_NUKE_CORE_MULTIPLIER		= 5.0
const GENERATOR_DAMAGE_MORTAR_ROCKET_MULTIPLIER	= 0.8 // increased the value since we now only fire 7 missiles per mortar

//titan tactical ability slots
const TAC_ABILITY_VORTEX 	= 1
const TAC_ABILITY_WALL		= 2
const TAC_ABILITY_SMOKE		= 3
const TAC_ABILITY_RAILGUN	= 4

const SCOREBOARD_MATERIAL_COOP_TITAN 			= "HUD/coop/coop_titan"
const SCOREBOARD_MATERIAL_COOP_EMP_TITAN		= "HUD/coop/coop_emp_titan_square"
const SCOREBOARD_MATERIAL_COOP_MORTAR_TITAN	 	= "HUD/coop/coop_mortar_titan_square"
const SCOREBOARD_MATERIAL_COOP_NUKE_TITAN 		= "HUD/coop/coop_nuke_titan_square"
const SCOREBOARD_MATERIAL_COOP_CLOAK_DRONE 		= "../ui/td_wave_icon_cloaked_drone"
const SCOREBOARD_MATERIAL_COOP_SUICIDE_SPECTRE 	= "HUD/coop/wave_icon_suicide"
const SCOREBOARD_MATERIAL_COOP_SNIPER_SPECTRE 	= "HUD/coop/wave_icon_sniper"
const SCOREBOARD_MATERIAL_COOP_SPECTRE 			= "HUD/coop/wave_icon_spectre"
const SCOREBOARD_MATERIAL_COOP_GRUNT	 		= "HUD/coop/wave_icon_grunt"

const SCOREBOARD_MATERIAL_COOP_BACKGROUND		= "../ui/menu/coop_menu_assets/coop_scoreboard_back"
const SCOREBOARD_MATERIAL_COOP_INFO_BOX 		= "../ui/menu/coop_menu_assets/coop_scoreboard_info_box"
const SCOREBOARD_MATERIAL_COOP_STARS	 		= "../ui/menu/lobby/map_star_small"
const SCOREBOARD_MATERIAL_COOP_STARS_EMPTY 		= "../ui/menu/lobby/map_star_empty_small"

const SCOREBOARD_MATERIAL_COOP_PLAYER_NUMBER_1		= "hud/coop/scoreboard_coop_p1"
const SCOREBOARD_MATERIAL_COOP_PLAYER_NUMBER_2 		= "hud/coop/scoreboard_coop_p2"
const SCOREBOARD_MATERIAL_COOP_PLAYER_NUMBER_3	 	= "hud/coop/scoreboard_coop_p3"
const SCOREBOARD_MATERIAL_COOP_PLAYER_NUMBER_4 		= "hud/coop/scoreboard_coop_p4"

//TEAM SCORE VALUES
const COOP_WAVE_COMPLETED_BONUS				= 100
const COOP_FINAL_WAVE_COMPLETED_BONUS		= 150 //Give a bit of an extra bonus for winning.
const COOP_MAX_HARVESTER_HEALTH_BONUS		= 200 //Scales down to 0 depending on remaining generator health.
const COOP_FIRST_TRY_BONUS					= 100 //Clear a wave without using retries.
const COOP_DIFFICULTY_BONUS					= 100 //Complete on Harder Difficulty.
const COOP_RETRY_BONUS						= 200 //Complete with one retry remaining.
const COOP_RETRIES_BONUS					= 400 //Complete with more than one retry remaining.
const COOP_FLAWLESS_WAVE_BONUS				= 50  //Complete a wave without the Harvester taking damage that wave.
const COOP_STAR_NOTIFICATION_SOUND_FIRST			= "UI_InGame_StarEarned_First"
const COOP_STAR_NOTIFICATION_SOUND_SECOND			= "UI_InGame_StarEarned_Second"
const COOP_STAR_NOTIFICATION_SOUND_THIRD			= "UI_InGame_StarEarned_Third"
const COOP_STAR_NOTIFICATION_SOUND_FAILURE			= "UI_InGame_StarEarned_Empty"

//COOP END OF GAME VALUES
const COOP_VICTORY_ANNOUNCEMENT_LENGTH					= 13.0
const COOP_DEFEAT_ANNOUNCEMENT_LENGTH					= 13.0
const COOP_EOG_TIME_BETWEEN_ANNOUNCEMENT_AND_STARS		= 8.0
const COOP_EOG_STAR_DISPLAY_TIME						= 5.0
const COOP_STAR_DISPLAY_INTERVAL						= 1.0
const GAME_WINNER_DETERMINED_GAME_OVER_WAIT_COOP 		= 28.0
const HARVESTER_GRAPH_DATA_POINTS						= 20 	// Number of plot points on Harvester Health Graph

const SPECTRE_MAX_SIGHT_DIST = 3000

const ARC_TITAN_EMP_FIELD_RADIUS 			= 330
const ARC_TITAN_EMP_FIELD_RADIUS_SQR 		= 108900 //pow( 330, 2 )
const ARC_TITAN_EMP_FIELD_INNER_RADIUS 		= 150
const ARC_TITAN_EMP_FIELD_INNER_RADIUS_SQR	= 22500 //pow( 150, 2 )

const COOP_EOG_MAX_DAMAGE_SOURCES						= 4


//--------------------------------------------------
// 				COLOR CORRECTION
//--------------------------------------------------

const ELECTRIC_SMOKESCREEN_DAMAGE_COLORCORRECTION = "materials/correction/player_electric_damage.raw"
const DMR_SONAR_SCOPE_COLOR_CORRECTION = "materials/correction/mp_ability_sonar_dmr.raw"


//--------------------------------------------------
// 				BLACK MARKET
//--------------------------------------------------
const CURRENCY_COIN_WALLET_MIN 			= 0
const CURRENCY_COIN_WALLET_MAX 			= 999999
const CURRENCY_COIN_WALLET_START_AMOUNT = 10000
const MAX_XP_TO_COINS_AMOUNT 			= 5000
const COIN_REWARD_SELL_COMMON 			= 100
const COIN_REWARD_SELL_RARE 			= 400
const COIN_REWARD_MATCH_COMPLETION      = 500
const COIN_REWARD_MATCH_VICTORY         = 250
const COIN_REWARD_FIRST_WIN_OF_DAY      = 1000
const COIN_REWARD_DAILY_CHALLENGE		= 500
const COST_BC_MATCHLONG_UPGRADE			= 3000

enum eShopResponseType
{
	FAIL_UNKNOWN_ERROR,
	FAIL_NOT_ENOUGH_COINS,
	FAIL_BURN_CARDS_FULL,
	FAIL_ITEM_LEVEL_LOCKED,
	FAIL_ALREADY_UNLOCKED,
	FAIL_PRIVATE_MATCH,
	SUCCESS_PERISHABLE,
	SUCCESS,
}

enum eCoinRewardCategory
{
	MATCH_COMPLETION,
	MATCH_VICTORY,
	DAILIES,
	MISC,

	_NUM_CATEGORIES,
}

enum eCoinRewardType
{
	// CANT ADD TO THIS ENUM WITHOUT UPDATING PERSISTENT DATA AND ALSO THE MENUS
	MATCH_COMPLETION,
	MATCH_VICTORY,
	FIRST_WIN_OF_DAY,
	DAILY_CHALLENGE,
	DISCARD,
	MAX_LEVEL_CONVERSION,

	_NUM_TYPES,
}

enum eShopItemType
{
	PERISHABLE,
	BURNCARD_PACK,
	TITAN_OS_VOICE_PACK,
	TITAN_DECAL,
	CHALLENGE_SKIP,
	BURNCARD_UPGRADE,
}

//--------------------------------------------------
// 					CHALLENGES
//--------------------------------------------------

enum eChallengeCategory
{
	ROOT,				// Only used by challenges menu

	GENERAL,
	TIME,
	DISTANCE,
	KILLS,
	MOBILITY_KILLS,
	MELEE_KILLS,

	TITAN_PRIMARY,		// Only used by challenges menu

	WEAPON_40MM,
	WEAPON_XO16,
	WEAPON_TITAN_SNIPER,
	WEAPON_ARC_CANNON,
	WEAPON_ROCKET_LAUNCHER,
	WEAPON_TRIPLE_THREAT,
	WEAPON_TITAN_SHOTGUN,
	WEAPON_THUNDERBOLT,

	TITAN_ORDNANCE,

	WEAPON_SALVO_ROCKETS,
	WEAPON_HOMING_ROCKETS,
	WEAPON_DUMBFIRE_ROCKETS,
	WEAPON_SHOULDER_ROCKETS,

	PILOT_PRIMARY,		// Only used by challenges menu

	WEAPON_SMART_PISTOL,
	WEAPON_SHOTGUN,
	WEAPON_R97,
	WEAPON_CAR,
	WEAPON_LMG,
	WEAPON_RSPN101,
	WEAPON_HEMLOK,
	WEAPON_G2,
	WEAPON_DMR,
	WEAPON_SNIPER,
	WEAPON_VALKYRIE,

	PILOT_SECONDARY,	// Only used by challenges menu

	WEAPON_SMR,
	WEAPON_MGL,
	WEAPON_ARCHER,
	WEAPON_DEFENDER,

	PILOT_SIDEARM,		// Only used by challenges menu

	WEAPON_AUTOPISTOL,
	WEAPON_SEMIPISTOL
	WEAPON_WINGMAN,
	WEAPON_TWINB,

	PILOT_ORDNANCE,

	WEAPON_FRAG_GRENADE,
	WEAPON_EMP_GRENADE,
	WEAPON_PROXIMITY_MINE,
	WEAPON_SATCHEL,

	COOP,
	REGEN_REQUIREMENTS,
	DAILY,

	CATEGORY_COUNT,
}

campaignMaps <- {}
campaignMaps[ "mp_fracture" ] 		<- 0
campaignMaps[ "mp_colony" ] 		<- 1
campaignMaps[ "mp_relic" ] 			<- 2
campaignMaps[ "mp_angel_city" ] 	<- 3
campaignMaps[ "mp_outpost_207" ]	<- 4
campaignMaps[ "mp_boneyard" ] 		<- 5
campaignMaps[ "mp_airbase" ] 		<- 6
campaignMaps[ "mp_o2" ] 			<- 7
campaignMaps[ "mp_corporate" ] 		<- 8

//--------------------------------------------------
// 				DAILIES / TIME FUNCTIONS
//--------------------------------------------------

const SECONDS_PER_DAY				= 86400
const SECONDS_PER_HOUR				= 3600
const SECONDS_PER_MINUTE			= 60
const DAILY_RESET_TIME_ZONE_OFFSET	= -10 	// subtract 10 hours to UTC time. This will cause dailies to reset at 3am PST(-8) / 6am EST(-5)






pmSettingsMap <- {}

pmSettingsMap["pm_score_limit"] <- {}
pmSettingsMap["pm_score_limit"]["at"] <- [
	200,
	250,
	300,
	350,
	400,
	500,
	750,
	1000,
]
pmSettingsMap["pm_score_limit"]["ctf"] <- [
	3,
	4,
	5,
	6,
	7,
	8,
	9,
	10,
]
pmSettingsMap["pm_score_limit"]["lts"] <- [
	2,
	3,
	4,
	5,
	6,
	7,
	8,
	9,
]
pmSettingsMap["pm_score_limit"]["wlts"] <- [
	2,
	3,
	4,
	5,
	6,
	7,
	8,
	9,
]
pmSettingsMap["pm_score_limit"]["tdm"] <- [
	10,
	20,
	30,
	40,
	50,
	60,
	75,
	100,
]
pmSettingsMap["pm_score_limit"]["ps"] <- [
	10,
	20,
	30,
	40,
	50,
	60,
	75,
	100,
]
pmSettingsMap["pm_score_limit"]["cp"] <- [
	150,
	200,
	250,
	300,
	350,
	400,
	500,
	750,
]
pmSettingsMap["pm_score_limit"]["mfd"] <- [
	1,
	3,
	5,
	7,
	10,
	20,
	30,
	50,
]
pmSettingsMap["pm_score_limit"]["mfdp"] <- [
	1,
	3,
	5,
	7,
	10,
	20,
	30,
	50,
]
pmSettingsMap["pm_score_limit"]["coop"] <- [
        150,
        200,
        250,
        300,
        350,
        400,
        500,
        750,
]
pmSettingsMap["pm_score_limit"]["scv"] <- [
	10,
	20,
	30,
	40,
	50,
	60,
	75,
	100,
]
pmSettingsMap["pm_score_limit"]["ttdm"] <- [
	10,
	20,
	30,
	40,
	50,
	60,
	75,
	100,
]
pmSettingsMap["pm_score_limit"]["tmfd"] <- [
	1,
	3,
	5,
	7,
	10,
	20,
	30,
	50,
]
pmSettingsMap["pm_score_limit"]["tmfdp"] <- [
	1,
	3,
	5,
	7,
	10,
	20,
	30,
	50,
]
pmSettingsMap["pm_score_limit"]["campaign_carousel"] <- [0]
pmSettingsMap["pm_score_limit"]["all"] <- [0]
pmSettingsMap["pm_score_limit"]["all_mini"] <- [0]
pmSettingsMap["pm_score_limit"]["ctt"] <- [
	10,
	15,
	20,
	25,
	30,
	40,
	50,
	75,
]
pmSettingsMap["pm_score_limit"]["ffa"] <- [
	10,
	20,
	30,
	40,
	45,
	50,
	75,
	100,
]
pmSettingsMap["pm_score_limit"]["gg"] <- [
	10,
	15,
	20,
]

pmSettingsMap["pm_pilot_health"] <- [
	0,
	100,
	300,
]

pmSettingsMap["pm_pilot_ammo"] <- [
	0,
	1,
	2,
]

pmSettingsMap["pm_pilot_minimap"] <- [
	0,
	1,
]

pmSettingsMap["pm_titan_shields"] <- [
	0, // default
	-1, // disabled
	1125,
	4500,
]

pmSettingsMap["pm_ai_type"] <- [
	0, // default
	1,
	2,
	3,
]

pmSettingsMap["pm_ai_lethality"] <- [
	0, // default
	1,
	2,
]

pmSettingsMap["pm_burn_cards"] <- [
	0,
	1,
	2,
	3,
	4,
	5,
	6,
	7,
	8,
	9,
	10,
]

playlistVarMap <- {}
// Pilot
playlistVarMap["pm_score_limit"] 	<- ""
playlistVarMap["pm_time_limit"] 	<- ""
playlistVarMap["pm_pilot_health"] 	<- "pilot_health"
playlistVarMap["pm_pilot_ammo"] 	<- "riff_ammo_limit"
playlistVarMap["pm_pilot_minimap"] 	<- "riff_minimap_state"
playlistVarMap["pm_pilot_respawn_delay"] 	<- "respawn_delay"
playlistVarMap["pm_titan_build"] 	<- "titan_build_time"
playlistVarMap["pm_titan_rebuild"] 	<- "titan_rebuild_time"
playlistVarMap["pm_titan_shields"] 	<- "titan_shield_health"
playlistVarMap["pm_ai_type"] 		<- "riff_allow_npcs"
playlistVarMap["pm_ai_lethality"] 	<- "riff_ai_lethality"
playlistVarMap["pm_burn_cards"] 	<- "burn_cards_set"
playlistVarMap["riff_floorislava"] 	<- "riff_floorislava"
/*
playlistVarMap["pilot_health"] 			<- "pm_pilot_health"
playlistVarMap["riff_ammo_limit"] 		<- "pm_pilot_ammo"
playlistVarMap["riff_minimap_state"] 	<- "pm_pilot_minimap"
playlistVarMap["titan_build_time"] 		<- "pm_titan_build"
playlistVarMap["titan_rebuild_time"] 	<- "pm_titan_rebuild"
playlistVarMap["titan_shield_health"] 	<- "pm_titan_shields"
playlistVarMap["riff_allow_npcs"] 		<- "pm_ai_type"
playlistVarMap["riff_ai_lethality"] 	<- "pm_ai_lethality"
*/

// 				Titan OS Voice packs
//--------------------------------------------------

//Table that maps the enum titanOS (Defined in persistent data) to the string modifier used in constructing the appropriate sound alias
TITAN_OS_VOICE_PACK <- {
	titanos_betty = "",
	titanos_malebutler = "Butler",
	titanos_femaleaudinav = "NavEuro",
	titanos_femaleassistant = "Breathy",
	titanos_maleintimidator = "Prototype",
	titanos_bettyde = 	"bettyDE"
	titanos_bettyen = 	"bettyEN"
	titanos_bettyes = 	"bettyES"
	titanos_bettyfr = 	"bettyFR"
	titanos_bettyit = 	"bettyIT"
	titanos_bettyjp = 	"bettyJP"
	titanos_bettyru = 	"bettyRU"
}

enum eMusicPieceID
{
	LOBBY_EARLY_CAMPAIGN,
	LOBBY_MID_CAMPAIGN,
	LOBBY_LATE_CAMPAIGN,
	LEVEL_INTRO,
	LEVEL_WIN,
	LEVEL_LOSS,
	LEVEL_DRAW,
	LEVEL_SUDDEN_DEATH,
	LEVEL_CINEMATIC_1,
	LEVEL_CINEMATIC_2,
	LEVEL_CINEMATIC_3,
	LEVEL_CINEMATIC_4,
	TITAN_ACTION_LOW_1,
	TITAN_ACTION_LOW_2,
	TITAN_ACTION_HIGH_1,
	TITAN_ACTION_HIGH_2,
	PILOT_ACTION_LOW_1,
	PILOT_ACTION_LOW_2,
	PILOT_ACTION_HIGH_1,
	PILOT_ACTION_HIGH_2,
	GAMEMODE_1,
	GAMEMODE_2,
	COOP_OPENING,
	COOP_GAMEWON,
	COOP_GAMELOST,
	COOP_WAVEWON,
	COOP_WAVELOST,
	COOP_WAITINGFORWAVE,
	COOP_WAITINGFORFIRSTWAVE,
	COOP_WAITINGFORFINALWAVE,
	COOP_ACTIONMUSIC_LOW,
	COOP_ACTIONMUSIC_MED,
	COOP_ACTIONMUSIC_HIGH,
	COOP_FINALWAVE_BEGIN,
	ROUND_BASED_GAME_WON,
	ROUND_BASED_GAME_LOST
}

enum eEOGRankPage
{
	ALL_PLAYERS,
	MY_TEAM,
	ENEMY_TEAM
}

enum eTitanBuildEvent
{
	invalid = -1,
	INIT,
	RESET_COMPLETE_CONDITION,
	GET_COMPLETE_CONDITION,
	START,
	STOP,
	REMAIN,
	END_CHECK,
	ADD_BUILD_ADVENTAGE,
	DECREMENT_BUILD_CONDITION,
	FORCE_BUILD_COMPLETE,
	ADD_BUILD_POINT,

	_count_
}

enum eTitanBuildRule
{
	invalid  	= -1,
	RULE_TIME,
	RULE_TIME_ATDM,
	RULE_POINT,

	_count_
}

const TITAN_DOOMED_EFFECT = "xo_exp_doomed"
//const TITAN_DOOMED_EFFECT = "xo_exp_death_doom"

// TODO: move to a const from code
const R1DELTA_PATCH_HEADER = "^CDEBFF00Welcome to ^f4433600R1Delta^CDEBFF00!"

// for SendMenu function
enum eMenuType
{
	MSG = 0,
	MENU = 1,
	TEXT = 2,
	ENTRY = 3
}

enum eVoteType
{
	kickPlayer, //0
	mapChange, //1
	nextMap, //2
	nextMode, //3
	teamScramble, //4
	toggleAlltalk, //5
	restartMatch, //6
	serverCustom, //7

	voteTargetInfo,
	voteYes,
	voteNo,
}

const SHOULDER_CHARGE_CANNON_MODEL = "models/weapons/titan_destroyer_railgun/w_destro_railgun_shoulder.mdl"
enum eChargeCannonState
{
	reloading
	ready
	last_eChargeCannonState
}

const WEAPON_VALKYRIE_NAME = "mp_weapon_mega1"
const WEAPON_TWINB_NAME = "mp_weapon_mega2"
const WEAPON_THUNDERBOLT_NAME = "mp_weapon_mega3"
const WEAPON_CHARGE_CANNON_NAME = "mp_weapon_mega4"
const WEAPON_THROWING_KNIFE_NAME = "mp_weapon_mega5"

enum eUIEvent
{
	MENU_OPEN,
	MENU_CLOSE,
	MENU_NAVIGATE_BACK,
	MENU_INPUT_MODE_CHANGED
}

// Just for script stuff
const R1D_SCRIPT_MAX_COOP_PLAYERS = 20
