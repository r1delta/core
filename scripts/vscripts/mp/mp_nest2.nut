
function main()
{
	if ( reloadingScripts )
		return
}

function EntitiesDidLoad()
{
	Nest2_CreateSpawnpoints()
	Nest2_CreateCollisionBlockers()

	if ( EvacEnabled() )
		Nest2_EvacSetup()

	GM_SetObserverFunc( ObserverFunc )
	BBPanelCamSetup()
}

function Nest2_CreateSpawnpoints()
{
	// P7 [TODO] - Maybe fill these later with some generic spawns
	//	  [TODO2] - Is it necessary? Some modes already fills up these and I have no idea why yet.
	local NEST2_GENERIC_PILOT_SPAWNSTART_MILITIA = [
		{ origin = Vector( 3141, 3204, 176 ), angles = Vector( 0, -77, 0 ) },
		{ origin = Vector( 2764.96, 3174.21, 176.031 ), angles = Vector( 0, -84.4777, 0 ) },
		{ origin = Vector( 2564.25, 3128.28, 186.657 ), angles = Vector( 0, -77.2176, 0 ) },
		{ origin = Vector( 3079.23, 3130.63, 176.031 ), angles = Vector( 0, -93.0576, 0 ) },
		{ origin = Vector( 3531.1, 3043.02, 50.0313 ), angles = Vector( 0, -119.898, 0 ) },
	]
	local NEST2_GENERIC_PILOT_SPAWNSTART_IMC = [
		//{ origin = Vector( -3705, 179, 336 ), angles = Vector( 0, 6, 0 ) }
		{ origin = Vector( -39.436, -3274.24, 136.031 ), angles = Vector( 0, 89.1924, 0 ) },
		{ origin = Vector( 242.494, -3370.37, 136.031 ), angles = Vector( 0, 104.922, 0 ) },
		{ origin = Vector( 456.191, -3334.33, -1.96875 ), angles = Vector( 0, 105.362, 0 ) },
		{ origin = Vector( -406.324, -3385.17, 0.03125 ), angles = Vector( 0, 92.932, 0 ) },
		{ origin = Vector( -829.142, -2975.24, -1.96875 ), angles = Vector( 0, 56.082, 0 ) },
	]
	// Generic pilot spawns sponsored by xFrann - 45 spawns more or less idk
	local NEST2_GENERIC_PILOT_SPAWN = [
		{ origin = Vector( -3705, 179, 336 ), angles = Vector( 0, 6, 0 ) },
		{ origin = Vector( -3703, 52, 336 ), angles = Vector( 0, 2, 0 ) },
		{ origin = Vector( -3696, -153, 336 ), angles = Vector( 0, 8, 0 ) },
		{ origin = Vector( -3771, -109, 336 ), angles = Vector( 0, -2, 0 ) },
		{ origin = Vector( -3768, 38, 336 ), angles = Vector( 0, -0, 0 ) },
		{ origin = Vector( -3755, 178, 336 ), angles = Vector( 0, -6, 0 ) },
		{ origin = Vector( -2413, -753, 336 ), angles = Vector( 0, -138, 0 ) },
		{ origin = Vector( -2995, -938, 176 ), angles = Vector( 0, 0, 0 ) },
		{ origin = Vector( -3341, -953, 176 ), angles = Vector( 0, 42, 0 ) },
		{ origin = Vector( -3517, -869, 176 ), angles = Vector( 0, 69, 0 ) },
		{ origin = Vector( -3683, -562, 176 ), angles = Vector( 0, 1, 0 ) },
		{ origin = Vector( -3256, -704, 0 ), angles = Vector( 0, 100, 0 ) },
		{ origin = Vector( -1796, -823, 336 ), angles = Vector( 0, -156, 0 ) },
		{ origin = Vector( -1777, -920, 336 ), angles = Vector( 0, 145, 0 ) },
		{ origin = Vector( -1938, -861, 336 ), angles = Vector( 0, -177, 0 ) },
		{ origin = Vector( -1916, -1050, 336 ), angles = Vector( 0, 128, 0 ) },
		{ origin = Vector( -1697, -1470, 208 ), angles = Vector( 0, 176, 0 ) },
		{ origin = Vector( -1951, -1205, 336 ), angles = Vector( 0, 178, 0 ) },
		{ origin = Vector( 2411, 447, 288 ), angles = Vector( 0, -55, 0 ) },
		{ origin = Vector( 2557, 440, 288 ), angles = Vector( 0, -89, 0 ) },
		{ origin = Vector( 2580, 1048, 0 ), angles = Vector( 0, -30, 0 ) },
		{ origin = Vector( 2565, 878, 0 ), angles = Vector( 0, -36, 0 ) },
		{ origin = Vector( 2352, 711, 0 ), angles = Vector( 0, -21, 0 ) },
		{ origin = Vector( 2234, 566, 0 ), angles = Vector( 0, -85, 0 ) },
		{ origin = Vector( 1603, -128, 368 ), angles = Vector( 0, -74, 0 ) },
		{ origin = Vector( 1615, -387, 288 ), angles = Vector( 0, -59, 0 ) },
		{ origin = Vector( 1638, -564, 288 ), angles = Vector( 0, 2, 0 ) },
		{ origin = Vector( 1718, -921, 288 ), angles = Vector( 0, -5, 0 ) },
		{ origin = Vector( 1800, -1109, 0 ), angles = Vector( 0, 42, 0 ) },
		{ origin = Vector( 1642, -1562, 152 ), angles = Vector( 0, 39, 0 ) },
		{ origin = Vector( -203, 2826, 192 ), angles = Vector( 0, -96, 0 ) },
		{ origin = Vector( -101, 2690, 192 ), angles = Vector( 0, -112, 0 ) },
		{ origin = Vector( -1252, 1518, -63 ), angles = Vector( 0, 156, 0 ) },
		{ origin = Vector( -1236, 1696, -63 ), angles = Vector( 0, 163, 0 ) },
		{ origin = Vector( -2176, 2332, -191 ), angles = Vector( 0, -56, 0 ) },
		{ origin = Vector( -2166, 2181, -191 ), angles = Vector( 0, -2, 0 ) },
		{ origin = Vector( -1982, 2188, -191 ), angles = Vector( 0, -18, 0 ) },
		{ origin = Vector( -1633, 1990, -191 ), angles = Vector( 0, 94, 0 ) },
		{ origin = Vector( -1778, 1951, -191 ), angles = Vector( 0, 122, 0 ) },
		{ origin = Vector( -1220, -2255, 288 ), angles = Vector( 0, 20, 0 ) },
		{ origin = Vector( 1265, 2829, 128 ), angles = Vector( 0, -87, 0 ) },
		{ origin = Vector( 1711, 2839, 128 ), angles = Vector( 0, -125, 0 ) },
		{ origin = Vector( 1685, 2567, 128 ), angles = Vector( 0, -158, 0 ) },
		{ origin = Vector( 1698, 2353, 128 ), angles = Vector( 0, 161, 0 ) },
		{ origin = Vector( 1690, 1983, 272 ), angles = Vector( 0, 127, 0 ) },
	]

	// CTF spawns sponsored by xFrann :D
	local NEST2_CTF_PILOT_SPAWNSTART_MILITIA = [
		{ origin = Vector( 3141, 3204, 176 ), angles = Vector( 0, -77, 0 )}
		{ origin = Vector( 2967, 3218, 176 ), angles = Vector( 0, -91, 0 )}
		{ origin = Vector( 2795, 3233, 176 ), angles = Vector( 0, -93, 0 )}
		{ origin = Vector( 2737, 3438, 176 ), angles = Vector( 0, -88, 0 )}
		{ origin = Vector( 2906, 3438, 176 ), angles = Vector( 0, -86, 0 )}
		{ origin = Vector( 2999, 3430, 176 ), angles = Vector( 0, -88, 0 )}
	]
	local NEST2_CTF_PILOT_SPAWNSTART_IMC = [
		{ origin = Vector( -3705, 179, 336 ), angles = Vector( 0, 6, 0 )}
		{ origin = Vector( -3703, 52, 336 ), angles = Vector( 0, 2, 0 )}
		{ origin = Vector( -3696, -153, 336 ), angles = Vector( 0, 8, 0 )}
		{ origin = Vector( -3771, -109, 336 ), angles = Vector( 0, -2, 0 )}
		{ origin = Vector( -3768, 38, 336 ), angles = Vector( 0, -1, 0 )}
		{ origin = Vector( -3755, 178, 336 ), angles = Vector( 0, -7, 0 )}
	]
	local NEST2_CTF_PILOT_SPAWN_MILITIA = [
		// near base
		{ origin = Vector( 2411, 447, 288 ), angles = Vector( 0, -55, 0 )}
		{ origin = Vector( 2557, 440, 288 ), angles = Vector( 0, -89, 0 )}
		{ origin = Vector( 2580, 1048, 0 ), angles = Vector( 0, -30, 0 )}
		{ origin = Vector( 2565, 878, 0 ), angles = Vector( 0, -36, 0 )}
		{ origin = Vector( 2352, 711, 0 ), angles = Vector( 0, -21, 0 )}
		{ origin = Vector( 2234, 566, 0 ), angles = Vector( 0, -85, 0 )}
		// base - right side
		{ origin = Vector( 3526, 1328, 192 ), angles = Vector( 0, 178, 0 )}
		{ origin = Vector( 3776, 1291, 191 ), angles = Vector( 0, 119, 0 )}
		{ origin = Vector( 2573, 1348, 0 ), angles = Vector( 0, 52, 0 )}
		{ origin = Vector( 2514, 1453, 1 ), angles = Vector( 0, 40, 0 )}
		{ origin = Vector( 1939, 2044, -89 ), angles = Vector( 0, -74, 0 )}
		{ origin = Vector( 1879, 1945, -107 ), angles = Vector( 0, -74, 0 )}
		// base - left side
		{ origin = Vector( 1603, -128, 368 ), angles = Vector( 0, -74, 0 )}
		{ origin = Vector( 1615, -387, 288 ), angles = Vector( 0, -59, 0 )}
		{ origin = Vector( 1638, -564, 288 ), angles = Vector( 0, 2, 0 )}
		{ origin = Vector( 1718, -921, 288 ), angles = Vector( 0, -5, 0 )}
		{ origin = Vector( 1800, -1109, 0 ), angles = Vector( 0, 42, 0 )}
		{ origin = Vector( 1642, -1562, 152 ), angles = Vector( 0, 39, 0 )}
	]
	local NEST2_CTF_PILOT_SPAWN_IMC = [
		// near base
		{ origin = Vector( -2413, -753, 336 ), angles = Vector( 0, -138, 0 )}
		{ origin = Vector( -2995, -938, 176 ), angles = Vector( 0, 1, 0 )}
		{ origin = Vector( -3341, -953, 176 ), angles = Vector( 0, 42, 0 )}
		{ origin = Vector( -3517, -869, 176 ), angles = Vector( 0, 69, 0 )}
		{ origin = Vector( -3683, -562, 176 ), angles = Vector( 0, 1, 0 )}
		{ origin = Vector( -3256, -704, 0 ), angles = Vector( 0, 100, 0 )}
		// base - right side
		{ origin = Vector( -1796, -823, 336 ), angles = Vector( 0, -156, 0 )}
		{ origin = Vector( -1777, -920, 336 ), angles = Vector( 0, 145, 0 )}
		{ origin = Vector( -1938, -861, 336 ), angles = Vector( 0, -177, 0 )}
		{ origin = Vector( -1916, -1050, 336 ), angles = Vector( 0, 128, 0 )}
		{ origin = Vector( -1697, -1470, 208 ), angles = Vector( 0, 176, 0 )}
		{ origin = Vector( -1951, -1205, 336 ), angles = Vector( 0, 178, 0 )}
		// base - left side
		{ origin = Vector( -3431, 291, 16 ), angles = Vector( 0, -59, 0 )}
		{ origin = Vector( 3446, 846, 206 ), angles = Vector( 0, 21, 0 )}
		{ origin = Vector( -3437, 476, 336 ), angles = Vector( 0, -89, 0 )}
		{ origin = Vector( -2087, 339, 0 ), angles = Vector( 0, -83, 0 )}
		{ origin = Vector( -1929, 337, 0 ), angles = Vector( 0, -75, 0 )}
		{ origin = Vector( -1829, 393, 0 ), angles = Vector( 0, -71, 0 )}
	]
	local NEST2_CTF_TITAN_SPAWN = [
		// imc - left side
		{ origin = Vector( -2741, 2039, -59 ), angles = Vector( 0, -12, 0 ) },
		{ origin = Vector( -2734, 2577, -63 ), angles = Vector( 0, -48, 0 ) },
		{ origin = Vector( -2634, 3043, -63 ), angles = Vector( 0, -52, 0 ) },
		{ origin = Vector( -2255, 3342, -65 ), angles = Vector( 0, -85, 0 ) },
		{ origin = Vector( -1553, 3381, -61 ), angles = Vector( 0, -114, 0 ) },
		{ origin = Vector( -1303, 2328, -59 ), angles = Vector( 0, -92, 0 ) },
		// imc - right side
		{ origin = Vector( -2539, -2275, 0 ), angles = Vector( 0, 19, 0 ) },
		{ origin = Vector( -2582, -2810, -1 ), angles = Vector( 0, 39, 0 ) },
		{ origin = Vector( -2665, -3420, 2 ), angles = Vector( 0, -1, 0 ) },
		{ origin = Vector( -2138, -3704, 2 ), angles = Vector( 0, 76, 0 ) },
		{ origin = Vector( -1695, -3662, 4 ), angles = Vector( 0, 94, 0 ) },
		{ origin = Vector( -1142, -3525, 16 ), angles = Vector( 0, 123, 0 ) },
		// militia - left side
		{ origin = Vector( 3669, -1229, 8 ), angles = Vector( 0, 144, 0 ) },
		{ origin = Vector( 3346, -1592, 8 ), angles = Vector( 0, 142, 0 ) },
		{ origin = Vector( 3134, -1899, 8 ), angles = Vector( 0, 129, 0 ) },
		{ origin = Vector( 3118, -2343, 8 ), angles = Vector( 0, 123, 0 ) },
		{ origin = Vector( 3254, -3001, 8 ), angles = Vector( 0, 107, 0 ) },
		{ origin = Vector( 3384, -3364, 8 ), angles = Vector( 0, 122, 0 ) },
		// militia - right side
		{ origin = Vector( 2871, 2279, 50 ), angles = Vector( 0, -126, 0 ) },
		{ origin = Vector( 3405, 2412, 50 ), angles = Vector( 0, -139, 0 ) },
		{ origin = Vector( 3450, 2744, 50 ), angles = Vector( 0, -138, 0 ) },
		{ origin = Vector( 3595, 3153, 50 ), angles = Vector( 0, -127, 0 ) },
		{ origin = Vector( 3155, 3214, 176 ), angles = Vector( 0, -96, 0 ) },
		{ origin = Vector( 2718, 3277, 176 ), angles = Vector( 0, -101, 0 ) },
	]

	// Titan spawns
	//local NEST2_TITAN_SPAWNSTART_MILITIA = []
	//local NEST2_TITAN_SPAWNSTART_IMC = []
	// Generic titan spawns sponsored by xFrann
	local NEST2_GENERIC_TITAN_SPAWN = [
		{ origin = Vector( -2741, 2039, -59 ), angles = Vector( 0, -12, 0 ) },
		{ origin = Vector( -2734, 2577, -63 ), angles = Vector( 0, -48, 0 ) },
		{ origin = Vector( -2634, 3043, -63 ), angles = Vector( 0, -52, 0 ) },
		{ origin = Vector( -2255, 3342, -65 ), angles = Vector( 0, -85, 0 ) },
		{ origin = Vector( -1553, 3381, -61 ), angles = Vector( 0, -114, 0 ) },
		{ origin = Vector( -1303, 2328, -59 ), angles = Vector( 0, -92, 0 ) },
		{ origin = Vector( -2539, -2275, 0 ), angles = Vector( 0, 19, 0 ) },
		{ origin = Vector( -2582, -2810, -1 ), angles = Vector( 0, 39, 0 ) },
		{ origin = Vector( -2665, -3420, 2 ), angles = Vector( 0, -1, 0 ) },
		{ origin = Vector( -2138, -3704, 2 ), angles = Vector( 0, 76, 0 ) },
		{ origin = Vector( -1695, -3662, 4 ), angles = Vector( 0, 94, 0 ) },
		{ origin = Vector( -1142, -3525, 16 ), angles = Vector( 0, 123, 0 ) },
		{ origin = Vector( 3669, -1229, 8 ), angles = Vector( 0, 144, 0 ) },
		{ origin = Vector( 3346, -1592, 8 ), angles = Vector( 0, 142, 0 ) },
		{ origin = Vector( 3134, -1899, 8 ), angles = Vector( 0, 129, 0 ) },
		{ origin = Vector( 3118, -2343, 8 ), angles = Vector( 0, 123, 0 ) },
		{ origin = Vector( 3254, -3001, 8 ), angles = Vector( 0, 107, 0 ) },
		{ origin = Vector( 3384, -3364, 8 ), angles = Vector( 0, 122, 0 ) },
		{ origin = Vector( 2871, 2279, 50 ), angles = Vector( 0, -126, 0 ) },
		{ origin = Vector( 3405, 2412, 50 ), angles = Vector( 0, -139, 0 ) },
		{ origin = Vector( 3450, 2744, 50 ), angles = Vector( 0, -138, 0 ) },
		{ origin = Vector( 3595, 3153, 50 ), angles = Vector( 0, -127, 0 ) },
		{ origin = Vector( 3155, 3214, 176 ), angles = Vector( 0, -96, 0 ) },
		{ origin = Vector( 2718, 3277, 176 ), angles = Vector( 0, -101, 0 ) },
		{ origin = Vector( 112, 1952, -191 ), angles = Vector( 0, -175, 0 ) },
	]

	local NEST2_GENERIC_DROPPOD_SPAWN = [
		{ origin = Vector( -673.623, -1412.29, 0.03125 ), angles = Vector( 0, 75.0139, 0 ) },
		{ origin = Vector( -727.578, -253.802, 12.0313 ), angles = Vector( 0, 25.1548, 0 ) },
		{ origin = Vector( -7.7491, 91.5279, 0.03125 ), angles = Vector( 0, -109.497, 0 ) },
		{ origin = Vector( 2020.45, 1823.17, -94.1221 ), angles = Vector( 0, -170.78, 0 ) },
		{ origin = Vector( 3504.53, 705.637, -10.9681 ), angles = Vector( 0, 170.062, 0 ) },
		{ origin = Vector( 3205.43, -88.1618, 8.03125 ), angles = Vector( 0, -155.398, 0 ) },
		{ origin = Vector( 3138.02, -2273.79, 8.03125 ), angles = Vector( 0, 109.229, 0 ) },
		{ origin = Vector( 1981.47, -2159.31, -223.969 ), angles = Vector( 0, 149.788, 0 ) },
		{ origin = Vector( 840.004, -3207.2, 0.03125 ), angles = Vector( 0, 129.362, 0 ) },
		{ origin = Vector( 673.246, -3780.59, -1.96875 ), angles = Vector( 0, 116.382, 0 ) },
		{ origin = Vector( -1501.43, -3747.24, 2.03205 ), angles = Vector( 0, 99.2442, 0 ) },
		{ origin = Vector( -1772.85, -3569.95, 0.03125 ), angles = Vector( 0, 94.4043, 0 ) },
		{ origin = Vector( -1597.2, 3525.52, -65.9688 ), angles = Vector( 0, -65.7223, 0 ) },
		{ origin = Vector( -2175.48, 3333.25, -65.9688 ), angles = Vector( 0, -20.8422, 0 ) },
	]

	level.NEST2_GENERIC_DROPPOD_SPAWN <- NEST2_GENERIC_DROPPOD_SPAWN

	local NEST2_DROPPOD_SPAWN_MILITIA = [
		{ origin = Vector( 2697.06, 2344.49, 50.0313 ), angles = Vector( 0, -67.6571, 0 ) },
		{ origin = Vector( 3005.62, 2279.1, 50.0313 ), angles = Vector( 0, -92.4071, 0 ) },
		{ origin = Vector( 3466.49, 2812.1, 50.0313 ), angles = Vector( 0, -115.037, 0 ) },
		{ origin = Vector( 2184.3, 1805.94, -68.8908 ), angles = Vector( 0, -47.9101, 0 ) },
		{ origin = Vector( 2266.88, 3292.64, 128.031 ), angles = Vector( 0, -51.6151, 0 ) },
	]

	local NEST2_DROPPOD_SPAWN_IMC = [
		{ origin = Vector( -701.153, -3909.8, 16.0313 ), angles = Vector( 0, 67.7912, 0 ) },
		{ origin = Vector( -50.3674, -3818.78, 3.03125 ), angles = Vector( 0, 31.1612, 0 ) },
		{ origin = Vector( 744.242, -3062.71, 26.5026 ), angles = Vector( 0, 93.4213, 0 ) },
		{ origin = Vector( -622.826, -2509.79, 2.85157 ), angles = Vector( 0, 89.1149, 0 ) },
		{ origin = Vector( -1677.74, -3153.56, 0.03125 ), angles = Vector( 0, 106.935, 0 ) },
	]

	local NEST2_CTF_DROPPOD_SPAWN_IMC = [
		{ origin = Vector( -2627.51, -1717.51, 0.03125 ), angles = Vector( 0, -64.0753, 0 ) },
		{ origin = Vector( -2350.17, -1705.78, -6.58115 ), angles = Vector( 0, -84.0954, 0 ) },
		{ origin = Vector( -2359.96, -2083.77, -5.96875 ), angles = Vector( 0, -72.1053, 0 ) },
		{ origin = Vector( -2808.57, 2036.17, -63.9688 ), angles = Vector( 0, -34.996, 0 ) },
		{ origin = Vector( -3055.6, 2807.91, -67.9688 ), angles = Vector( 0, -12.2261, 0 ) },
		{ origin = Vector( -2525.43, 2418.38, -63.9688 ), angles = Vector( 0, 98.7638, 0 ) },
	]

	switch(GameRules.GetGameMode()) {
		case CAPTURE_THE_FLAG:
		case CAPTURE_THE_FLAG_PRO:
		case SCAVENGER:
			// P7: [CTF] Fix flag spawns
			//	   Flags on this map were on the air so... we need to create new ones
			// Flags
			// IMC: -2924.667480, -772.578552, 336.031250
			// MILITIA: 2432.482666, 126.611160, 288.031250
			CreateFlagSpawnPoint( Vector( -2924, -772, 336 ), Vector(0, 0, 0), TEAM_IMC, "info_spawnpoint_flag_1" )
			CreateFlagSpawnPoint( Vector( 2432, 126, 288 ), Vector(0, 0, 0), TEAM_MILITIA, "info_spawnpoint_flag_2" )
			// CTF spawn setup
			// First we delete previous pilot start spawns for this mode as we have our own
			foreach(ent in GetEntArrayByClass_Expensive("info_spawnpoint_human_start")) {
				printt("Destroyed ", ent.GetName(), " - unwanted spawn for this mode.")
				ent.Destroy()
			}
			// then we do the thing
			CreatePilotStartSpawnPointFromArray(NEST2_CTF_PILOT_SPAWNSTART_MILITIA, TEAM_MILITIA)
			CreatePilotStartSpawnPointFromArray(NEST2_CTF_PILOT_SPAWNSTART_IMC, TEAM_IMC)
			// P7 [TODO?] Maybe merge these loops later since they're all to unassigned teams anyway, check previous comment
			CreatePilotSpawnPointFromArray(NEST2_CTF_PILOT_SPAWN_MILITIA, TEAM_UNASSIGNED)
			CreatePilotSpawnPointFromArray(NEST2_CTF_PILOT_SPAWN_IMC, TEAM_UNASSIGNED)
			// new titan spawns for ctf
			CreateTitanPilotSpawnPointFromArray(NEST2_CTF_TITAN_SPAWN, TEAM_UNASSIGNED)

			CreateDropPodStartSpawnPointFromArray( NEST2_CTF_DROPPOD_SPAWN_IMC, TEAM_IMC )
			break
		default:
			// Generic pilot spawnpoints for the rest of gamemodes that might require them
			CreatePilotStartSpawnPointFromArray(NEST2_GENERIC_PILOT_SPAWNSTART_MILITIA, TEAM_MILITIA)
			CreatePilotStartSpawnPointFromArray(NEST2_GENERIC_PILOT_SPAWNSTART_IMC, TEAM_IMC)
			CreatePilotSpawnPointFromArray(NEST2_GENERIC_PILOT_SPAWN, TEAM_UNASSIGNED)

			CreateDropPodStartSpawnPointFromArray( NEST2_DROPPOD_SPAWN_IMC, TEAM_IMC )
			break
	}
	// Titan spawn setup
	CreateTitanPilotSpawnPointFromArray(NEST2_GENERIC_TITAN_SPAWN, TEAM_UNASSIGNED)

	CreateDropPodSpawnPointFromArray( NEST2_DROPPOD_SPAWN_IMC, TEAM_IMC )
	CreateDropPodStartSpawnPointFromArray( NEST2_DROPPOD_SPAWN_MILITIA, TEAM_MILITIA )
	CreateDropPodSpawnPointFromArray( NEST2_DROPPOD_SPAWN_MILITIA, TEAM_MILITIA )

	CreateDropPodSpawnPointFromArray( NEST2_GENERIC_DROPPOD_SPAWN, TEAM_UNASSIGNED )
}

function Nest2_CreateCollisionBlockers()
{
	// So it doesnt get in the way of evacing players
	local oob8 = GetEnt( "trigger_out_of_bounds_8" )
	oob8.SetOrigin( Vector( 3849, 1104, -1304 ) )

	local container = "models/imc_base/cargo_container_imc_01_red.mdl"
	local fence = "models/imc_base/chain_link_imc_01.mdl"
	local shield = "models/imc_base/garage_blast_shield_imc_01.mdl"

	// New red container on the side of the ramp on the militia spawn
	// The ramp has its bottom blocked by an invisible wall, and it looks fully enterable
	// So its better to block it entirely with a prop
	local milSpawn1 = CreatePropDynamic( container, Vector( 3400, 2914, 50 ), Vector( 0, 90, 0 ), 6 )

	// Panels on the side of the first evac spot. You can see them coming from IMC spawn
	// They look like they have collision, but actually dont lol
	local evac1Panels1 = CreatePropDynamic( container, Vector( 2711.16, -2262.53, -169.636 ), Vector( 0, 90, 0 ), 6 )
	local evac1Panels2 = CreatePropDynamic( container, Vector( 2711.16, -2342.53, -169.636 ), Vector( 0, 90, 0 ), 6 )
	local evac1Panels3 = CreatePropDynamic( container, Vector( 2711.16, -2422.53, -169.636 ), Vector( 0, 90, 0 ), 6 )
	local evac1Panels4 = CreatePropDynamic( container, Vector( 2711.16, -2502.53, -169.636 ), Vector( 0, 90, 0 ), 6 )
	local evac1Panels5 = CreatePropDynamic( container, Vector( 2711.16, -2552.53, -169.636 ), Vector( 0, 90, 0 ), 6 )
	evac1Panels1.MakeInvisible()
	evac1Panels2.MakeInvisible()
	evac1Panels3.MakeInvisible()
	evac1Panels4.MakeInvisible()
	evac1Panels5.MakeInvisible()

	// Platform for evac spot 3, near militia spawn
	// Bad clipping, can somewhat clip into be panels and be semi invisible
	// Also lets you touch an out of bounds trigger
	local evac3Platform1 = CreatePropDynamic( container, Vector( 3796, 1975.47, 44.0313 ), null, 6 )
	local evac3Platform2 = CreatePropDynamic( container, Vector( 3676, 1975.47, 44.0313 ), null, 6 )
	local evac3Platform3 = CreatePropDynamic( container, Vector( 3556, 1975.47, 44.0313 ), null, 6 )
	local evac3Platform4 = CreatePropDynamic( container, Vector( 3436, 1975.47, 44.0313 ), null, 6 ) // Not sure about this one
	evac3Platform1.MakeInvisible()
	evac3Platform2.MakeInvisible()
	evac3Platform3.MakeInvisible()
	evac3Platform4.MakeInvisible()

	// Mid building with the chain link fences, can get kicked off wallrun
	local midBuilding1 = CreatePropDynamic( fence, Vector( 55.3401, -161.595, 43.0313 ), null, 6 )
	local midBuilding2 = CreatePropDynamic( fence, Vector( 55.3401, -286.595, 43.0313 ), null, 6 )
	local midBuilding3 = CreatePropDynamic( fence, Vector( 55.3401, -411.595, 43.0313 ), null, 6 )
	local midBuilding4 = CreatePropDynamic( fence, Vector( 55.3401, -536.595, 43.0313 ), null, 6 )
	midBuilding1.MakeInvisible()
	midBuilding2.MakeInvisible()
	midBuilding3.MakeInvisible()
	midBuilding4.MakeInvisible()

	// Mid prison cells on the walls, WILL get kicked off wallrun
	// Collision is still kinda weird due to the shape of these props
	local midWall1 = CreatePropDynamic( shield, Vector( -156.235, 835.66, 390.152 ), Vector( 0, 90, 0 ), 6 )
	local midWall2 = CreatePropDynamic( shield, Vector( -156.235, 835.66, 510.152 ), Vector( 0, 90, 0 ), 6 )
	local midWall3 = CreatePropDynamic( shield, Vector( -156.235, 835.66, 630.152 ), Vector( 0, 90, 0 ), 6 )
	local midWall4 = CreatePropDynamic( shield, Vector( -900.248, 99.5108, 421.748 ), null, 6 )
	local midWall5 = CreatePropDynamic( shield, Vector( -900.248, 99.5108, 541.748 ), null, 6 )
	local midWall6 = CreatePropDynamic( shield, Vector( -900.248, 99.5108, 661.748 ), null, 6 )
	local midWall7 = CreatePropDynamic( shield, Vector( -900.248, -404.418, 421.748 ), null, 6 )
	local midWall8 = CreatePropDynamic( shield, Vector( -900.248, -404.418, 541.748 ), null, 6 )
	local midWall9 = CreatePropDynamic( shield, Vector( -900.248, -404.418, 661.748 ), null, 6 )
	midWall1.MakeInvisible()
	midWall2.MakeInvisible()
	midWall3.MakeInvisible()
	midWall4.MakeInvisible()
	midWall5.MakeInvisible()
	midWall6.MakeInvisible()
	midWall7.MakeInvisible()
	midWall8.MakeInvisible()
	midWall9.MakeInvisible()

	// These dont have collision when on TEAM_UNASSIGNED for some reason
	local turretCollision
	foreach ( turret in GetEntArrayByClass_Expensive( "npc_turret_mega_bb" ) )
	{
		turretCollision = CreatePropDynamic( "models/turrets/turret_imc_lrg.mdl", turret.GetOrigin(), turret.GetAngles(), 6 )
		turretCollision.MakeInvisible()
	}
}

function Nest2_EvacSetup()
{
	local verticalAnims = Evac_CreateAnimPackage( "dropship_VTOL_evac_start", "dropship_VTOL_evac_idle", "dropship_VTOL_evac_end" )

	local locationNode1 = CreateInfoTarget( Vector( 3695.69, -4577.89, -12.6243 ), Vector( 0, 0, 0 ), "evac_location1" )
	local locationNode2 = CreateInfoTarget( Vector( 140.533, -2854.89, 319.991 ), Vector( 0, -90, 0 ), "evac_location2" )
	local locationNode3 = CreateInfoTarget( Vector( 3419.84, 908.497, 371.647 ), Vector( 0, -90, 0 ), "evac_location3" )
	local locationNode4 = CreateInfoTarget( Vector( -1891.79, 3041.32, 272.946 ), Vector( 0, 90, 0 ), "evac_location4" )

	local spectatorNode1 = CreateInfoTarget( Vector( 2105.43, -2248.05, 579.907 ), Vector( 16.7823, -40.6, 0 ), "spec_cam1", locationNode1.GetName() )
	local spectatorNode2 = CreateInfoTarget( Vector( -796.967, -3269.23, 530.653 ), Vector( 31.7428, 41.26, 0 ), "spec_cam2", locationNode2.GetName() )
	local spectatorNode3 = CreateInfoTarget( Vector( 2458.85, 524.449, 688.262 ), Vector( 31.0828, 39.3098, 0 ), "spec_cam3", locationNode3.GetName() )
	local spectatorNode4 = CreateInfoTarget( Vector( -2770.36, 1627.29, 698.897 ), Vector( 33.7227, 31.6098, 0 ), "spec_cam4", locationNode4.GetName() )

	Evac_AddLocation( "evac_location1", spectatorNode1.GetOrigin(), spectatorNode1.GetAngles() )
	Evac_AddLocation( "evac_location2", spectatorNode2.GetOrigin(), spectatorNode2.GetAngles() )
	Evac_AddLocation( "evac_location3", spectatorNode3.GetOrigin(), spectatorNode3.GetAngles() )
	Evac_AddLocation( "evac_location4", spectatorNode4.GetOrigin(), spectatorNode4.GetAngles(), verticalAnims )

	// Garbage, need a better spot
	local spacenode = CreateInfoTarget( Vector( -8515.06, -12795.5, -9496.63 ), Vector( 6.16003, 52.4097, 0 ), "end_spacenode" )
	Evac_SetSpaceNode( spacenode )

	Evac_SetupDefaultVDUs()
}

function BBPanelCamSetup()
{
    PrintFunc()
	//local spectatorNode1 = GetEnt( "panel_cam1" )
	//local spectatorNode2 = GetEnt( "panel_cam2" )

	level.DeathCamEnt1 <- GetEnt( "panel_cam1" )
	level.DeathCamEnt2 <- GetEnt( "panel_cam2" )

	level.DeathCamOutSide_A <- GetEnt( "panel_cam10" )
	level.DeathCamOutSide_B <- GetEnt( "panel_cam20" )

	printt( "DeathCamEnt1 = ", level.DeathCamEnt1)
	printt( "DeathCamEnt2 = ", level.DeathCamEnt2)
}

function ObserverFunc( player )
{
	printt( "player: ", player.GetName() )

	// Reenable this when big brother gets added back

//	if( IsBigBrotherPanelHacked() && IsMyTeamElimination( player ) )
//	{
//		local HackedPanelIndex = GetHackedBBPanelIndex()
//
//		Assert( HackedPanelIndex != 0 )
//
//		local deathCam
//		if( GetHackedBBPanelIndex() == 1 )
//		{
//			deathCam = level.DeathCamEnt1
//		}
//		else
//		{
//			deathCam = level.DeathCamEnt2
//		}
//
//		// player 및 같은 팀 플레이어의 옵저버 모드를 바꿈.
//		local playerArray = GetPlayerArrayOfTeam( player.GetTeam() )
//		foreach ( guy in playerArray )
//		{
//			guy.SetObserverModeStaticPosition( deathCam.GetOrigin() )
//			guy.SetObserverModeStaticAngles( deathCam.GetAngles() )
//
//			guy.StartObserverMode( OBS_MODE_STATIC_LOCKED )
//			guy.SetObserverTarget( null )
//
//			// SpectatorSelectButton Hide.
//			Remote.CallFunction_NonReplay( guy, "ServerCallback_HideSpectatorSelectButtons" )
//		}
//
//		
//		player.SetObserverModeStaticPosition( deathCam.GetOrigin() )
//		player.SetObserverModeStaticAngles( deathCam.GetAngles() )
//
//		player.StartObserverMode( OBS_MODE_STATIC_LOCKED )
//		player.SetObserverTarget( null )
//		
//	}
//	else

	
	//player.SetObserverModeStaticPosition( level.ExtractLocations[ level.SelectedExtractLocationIndex ].spectatorPos )
	//player.SetObserverModeStaticAngles( level.ExtractLocations[ level.SelectedExtractLocationIndex ].spectatorAng )
	
	//player.StartObserverMode( OBS_MODE_CHASE )
	//player.SetObserverTarget( null )
	return
	
}

function EvacObserverFunc( player )
{
	player.SetObserverModeStaticPosition( level.ExtractLocations[ level.SelectedExtractLocationIndex ].spectatorPos )
	player.SetObserverModeStaticAngles( level.ExtractLocations[ level.SelectedExtractLocationIndex ].spectatorAng )

	player.StartObserverMode( OBS_MODE_CHASE )
	player.SetObserverTarget( null )
	
}
main()