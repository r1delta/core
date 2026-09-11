function main()
{
	Globalize( CodeCallback_OnRodeoAttach )
	Globalize( CodeCallback_IsValidRodeoTarget )
	Globalize( GetTitanSoulBeingRodeoed )
	Globalize( GetTitanBeingRodeoed )
	Globalize( GetPlayerRodeoing )
	Globalize( GetRodeoPackage )
	Globalize( GetFriendlyRodeoPlayer )
	Globalize( GetEnemyRodeoPlayer )
	Globalize( GiveFriendlyRodeoPlayerProtection )
	Globalize( TakeAwayFriendlyRodeoPlayerProtection )
	Globalize( GetTitanHijackOrigin )
	Globalize( GetTitanHijackAngles )
	Globalize( IsRodeoEnabled )
	Globalize( PlayerIsRodeoingTarget )
	Globalize( EnableRodeo )
	Globalize( DisableRodeo )
	Globalize( UpdateDamageStateOfPanel )
	Globalize( PlayerFallingOntoTitan )
	Globalize( ForceRodeoOver )
	Globalize( SetRodeoAnimsFromPackage )
	Globalize( DebugRodeoTimes )
	Globalize( SetDebugRodeoAnim ) // Set to force a particular rodeo anim to occur

	RegisterSignal( "RodeoStarted" )
	RegisterSignal( "RodeoOver" )
	RegisterSignal( "RodeoKilledTitan" )

	PrecacheParticleSystem( "P_impact_rodeo_damage" ) //Rodeo hit spark
	PrecacheParticleSystem( "P_rodeo_damage_1" )  //DamageState1
	PrecacheParticleSystem( "P_rodeo_damage_2" )  //DamageState2
	PrecacheParticleSystem( "P_rodeo_damage_3" )  //DamageState3

	// add movement anims
	AddAnimAlias( "ogre", "ptpov_rodeo_move_back_idle",				"ptpov_rodeo_move_ogre_back_idle" )
	AddAnimAlias( "ogre", "ptpov_rodeo_move_back_entrance",			"ptpov_rodeo_move_ogre_back_entrance" )
	AddAnimAlias( "ogre", "ptpov_rodeo_move_right_entrance",			"ptpov_rodeo_move_ogre_right_entrance" )
	AddAnimAlias( "ogre", "ptpov_rodeo_move_front_entrance",			"ptpov_rodeo_move_ogre_front_entrance" )
	AddAnimAlias( "ogre", "ptpov_rodeo_move_front_lower_entrance",	"ptpov_rodeo_move_ogre_front_lower_entrance" )
	AddAnimAlias( "ogre", "ptpov_rodeo_move_back_mid_entrance",		"ptpov_rodeo_move_ogre_back_mid_entrance" )
	AddAnimAlias( "ogre", "ptpov_rodeo_move_back_lower_entrance",		"ptpov_rodeo_move_ogre_back_lower_entrance" )
	AddAnimAlias( "ogre", "ptpov_rodeo_move_left_entrance",			"ptpov_rodeo_move_ogre_left_entrance" )
	AddAnimAlias( "ogre", "pt_rodeo_move_back_idle",				"pt_rodeo_move_ogre_back_idle" )
	AddAnimAlias( "ogre", "pt_rodeo_move_right_entrance",			"pt_rodeo_move_ogre_right_entrance" )
	AddAnimAlias( "ogre", "pt_rodeo_move_back_entrance",			"pt_rodeo_move_ogre_back_entrance" )
	AddAnimAlias( "ogre", "pt_rodeo_move_front_entrance",			"pt_rodeo_move_ogre_front_entrance" )
	AddAnimAlias( "ogre", "pt_rodeo_move_front_lower_entrance",	"pt_rodeo_move_ogre_front_lower_entrance" )
	AddAnimAlias( "ogre", "pt_rodeo_move_back_mid_entrance",		"pt_rodeo_move_ogre_back_mid_entrance" )
	AddAnimAlias( "ogre", "pt_rodeo_move_back_lower_entrance",	"pt_rodeo_move_ogre_back_lower_entrance" )
	AddAnimAlias( "ogre", "pt_rodeo_move_left_entrance",			"pt_rodeo_move_ogre_left_entrance" )

	AddAnimAlias( "atlas", "ptpov_rodeo_move_back_idle",				"ptpov_rodeo_move_atlas_back_idle" )
	AddAnimAlias( "atlas", "ptpov_rodeo_move_back_entrance",			"ptpov_rodeo_move_atlas_back_entrance" )
	AddAnimAlias( "atlas", "ptpov_rodeo_move_front_entrance",			"ptpov_rodeo_move_atlas_front_entrance" )
	AddAnimAlias( "atlas", "ptpov_rodeo_move_front_lower_entrance",	"ptpov_rodeo_move_atlas_front_lower_entrance" )
	AddAnimAlias( "atlas", "ptpov_rodeo_move_back_mid_entrance",		"ptpov_rodeo_move_atlas_back_mid_entrance" )
	AddAnimAlias( "atlas", "ptpov_rodeo_move_back_lower_entrance",	"ptpov_rodeo_move_atlas_back_lower_entrance" )
	AddAnimAlias( "atlas", "ptpov_rodeo_move_left_entrance",			"ptpov_rodeo_move_atlas_left_entrance" )
	AddAnimAlias( "atlas", "ptpov_rodeo_move_right_entrance",			"ptpov_rodeo_move_atlas_right_entrance" )
	AddAnimAlias( "atlas", "pt_rodeo_move_back_idle",				"pt_rodeo_move_atlas_back_idle" )
	AddAnimAlias( "atlas", "pt_rodeo_move_back_entrance",			"pt_rodeo_move_atlas_back_entrance" )
	AddAnimAlias( "atlas", "pt_rodeo_move_front_entrance",		"pt_rodeo_move_atlas_front_entrance" )
	AddAnimAlias( "atlas", "pt_rodeo_move_front_lower_entrance",	"pt_rodeo_move_atlas_front_lower_entrance" )
	AddAnimAlias( "atlas", "pt_rodeo_move_back_mid_entrance",		"pt_rodeo_move_atlas_back_mid_entrance" )
	AddAnimAlias( "atlas", "pt_rodeo_move_back_lower_entrance",	"pt_rodeo_move_atlas_back_lower_entrance" )
	AddAnimAlias( "atlas", "pt_rodeo_move_left_entrance",			"pt_rodeo_move_atlas_left_entrance" )	// needs update
	AddAnimAlias( "atlas", "pt_rodeo_move_right_entrance",		"pt_rodeo_move_atlas_right_entrance" )	// needs update

	AddAnimAlias( "stryder", "ptpov_rodeo_move_back_idle",			"ptpov_rodeo_move_stryder_back_idle" )
	AddAnimAlias( "stryder", "ptpov_rodeo_move_back_entrance",		"ptpov_rodeo_move_stryder_back_entrance" )
	AddAnimAlias( "stryder", "ptpov_rodeo_move_right_entrance",		"ptpov_rodeo_move_stryder_right_entrance" )
	AddAnimAlias( "stryder", "ptpov_rodeo_move_front_entrance",		"ptpov_rodeo_move_stryder_front_entrance" )
	AddAnimAlias( "stryder", "ptpov_rodeo_move_front_lower_entrance",	"ptpov_rodeo_move_stryder_front_lower_entrance" )
	AddAnimAlias( "stryder", "ptpov_rodeo_move_back_mid_entrance",	"ptpov_rodeo_move_stryder_back_mid_entrance" )
	AddAnimAlias( "stryder", "ptpov_rodeo_move_back_lower_entrance",	"ptpov_rodeo_move_stryder_back_lower_entrance" )
	AddAnimAlias( "stryder", "ptpov_rodeo_move_left_entrance",			"ptpov_rodeo_move_stryder_left_entrance" )
	AddAnimAlias( "stryder", "pt_rodeo_move_back_idle",			"pt_rodeo_move_stryder_back_idle" )
	AddAnimAlias( "stryder", "pt_rodeo_move_back_entrance",		"pt_rodeo_move_stryder_back_entrance" )
	AddAnimAlias( "stryder", "pt_rodeo_move_right_entrance",		"pt_rodeo_move_stryder_right_entrance" )
	AddAnimAlias( "stryder", "pt_rodeo_move_front_entrance",		"pt_rodeo_move_stryder_front_entrance" )
	AddAnimAlias( "stryder", "pt_rodeo_move_front_lower_entrance","pt_rodeo_move_stryder_front_lower_entrance" )
	AddAnimAlias( "stryder", "pt_rodeo_move_back_mid_entrance",	"pt_rodeo_move_stryder_back_mid_entrance" )
	AddAnimAlias( "stryder", "pt_rodeo_move_back_lower_entrance",	"pt_rodeo_move_stryder_back_lower_entrance" )
	AddAnimAlias( "stryder", "pt_rodeo_move_left_entrance",		"pt_rodeo_move_stryder_left_entrance" )

    AddAnimAlias( "destroyer", "ptpov_rodeo_move_back_idle",               "ptpov_rodeo_move_destroyer_back_idle" )
    AddAnimAlias( "destroyer", "ptpov_rodeo_move_back_entrance",          "ptpov_rodeo_move_destroyer_back_entrance" )
    AddAnimAlias( "destroyer", "ptpov_rodeo_move_right_entrance",         "ptpov_rodeo_move_destroyer_right_entrance" )
    AddAnimAlias( "destroyer", "ptpov_rodeo_move_front_entrance",         "ptpov_rodeo_move_destroyer_front_entrance" )
    AddAnimAlias( "destroyer", "ptpov_rodeo_move_front_lower_entrance",   "ptpov_rodeo_move_destroyer_front_lower_entrance" )
    AddAnimAlias( "destroyer", "ptpov_rodeo_move_back_mid_entrance",      "ptpov_rodeo_move_destroyer_back_mid_entrance" )
    AddAnimAlias( "destroyer", "ptpov_rodeo_move_back_lower_entrance",    "ptpov_rodeo_move_destroyer_back_lower_entrance" )
    AddAnimAlias( "destroyer", "ptpov_rodeo_move_left_entrance",          "ptpov_rodeo_move_destroyer_left_entrance" )

    AddAnimAlias( "destroyer", "pt_rodeo_move_back_idle",                 "pt_rodeo_move_destroyer_back_idle" )
    AddAnimAlias( "destroyer", "pt_rodeo_move_right_entrance",            "pt_rodeo_move_destroyer_right_entrance" )
    AddAnimAlias( "destroyer", "pt_rodeo_move_back_entrance",             "pt_rodeo_move_destroyer_back_entrance" )
    AddAnimAlias( "destroyer", "pt_rodeo_move_front_entrance",            "pt_rodeo_move_destroyer_front_entrance" )
    AddAnimAlias( "destroyer", "pt_rodeo_move_front_lower_entrance",      "pt_rodeo_move_destroyer_front_lower_entrance" )
    AddAnimAlias( "destroyer", "pt_rodeo_move_back_mid_entrance",         "pt_rodeo_move_destroyer_back_mid_entrance" )
    AddAnimAlias( "destroyer", "pt_rodeo_move_back_lower_entrance",       "pt_rodeo_move_destroyer_back_lower_entrance" )
    AddAnimAlias( "destroyer", "pt_rodeo_move_left_entrance",             "pt_rodeo_move_destroyer_left_entrance" )

    AddAnimAlias( "destroyer", "at_rodeo_panel_opening",                  "hatch_rodeo_panel_opening" )
    AddAnimAlias( "destroyer", "at_rodeo_panel_close_idle",               "hatch_rodeo_panel_close_idle" )
    AddAnimAlias( "destroyer", "at_Rodeo_Panel_Damage_State_0_Idle",      "hatch_Rodeo_Panel_Damage_State_0_Idle" )
    AddAnimAlias( "destroyer", "at_Rodeo_Panel_Damage_State_1_Idle",      "hatch_Rodeo_Panel_Damage_State_1_Idle" )
    AddAnimAlias( "destroyer", "at_Rodeo_Panel_Damage_State_2_Idle",      "hatch_Rodeo_Panel_Damage_State_2_Idle" )
    AddAnimAlias( "destroyer", "at_Rodeo_Panel_Damage_State_3_Idle",      "hatch_Rodeo_Panel_Damage_State_3_Idle" )
    AddAnimAlias( "destroyer", "at_Rodeo_Panel_Damage_State_4_Idle",      "hatch_Rodeo_Panel_Damage_State_final_Idle" )
    AddAnimAlias( "destroyer", "pt_rodeo_panel_fire",                     "pt_rodeo_destroyer_panel_fire" )
    AddAnimAlias( "destroyer", "pt_rodeo_panel_opening",                  "pt_rodeo_destroyer_panel_opening" )
    AddAnimAlias( "destroyer", "pt_rodeo_panel_aim_idle",                 "pt_rodeo_destroyer_panel_aim_idle_move" )
    AddAnimAlias( "destroyer", "pt_rodeo_player_side_lean",               "pt_rodeo_destroyer_player_side_lean" )
    AddAnimAlias( "destroyer", "ptpov_rodeo_panel_opening",               "ptpov_rodeo_destroyer_panel_opening" )
    AddAnimAlias( "destroyer", "ptpov_rodeo_panel_aim_idle",              "ptpov_destroyer_rodeo_panel_aim_idle" )
    AddAnimAlias( "destroyer", "ptpov_rodeo_panel_aim_idle_move",         "ptpov_destroyer_rodeo_panel_aim_idle_move" )
    AddAnimAlias( "destroyer", "ptpov_rodeo_player_side_lean_enemy",      "ptpov_Rodeo_destroyer_player_side_lean" )

		
	AddAnimAlias( "special_ogre", "ptpov_rodeo_move_back_idle",				"ptpov_rodeo_move_stryder_back_idle" )
	AddAnimAlias( "special_ogre", "ptpov_rodeo_move_back_entrance",			"ptpov_rodeo_move_ogre_back_entrance" )
	AddAnimAlias( "special_ogre", "ptpov_rodeo_move_right_entrance",			"ptpov_rodeo_move_ogre_right_entrance" )
	AddAnimAlias( "special_ogre", "ptpov_rodeo_move_front_entrance",			"ptpov_rodeo_move_ogre_front_entrance" )
	AddAnimAlias( "special_ogre", "ptpov_rodeo_move_front_lower_entrance",	"ptpov_rodeo_move_ogre_front_lower_entrance" )
	AddAnimAlias( "special_ogre", "ptpov_rodeo_move_back_mid_entrance",		"ptpov_rodeo_move_ogre_back_mid_entrance" )
	AddAnimAlias( "special_ogre", "ptpov_rodeo_move_back_lower_entrance",		"ptpov_rodeo_move_ogre_back_lower_entrance" )
	AddAnimAlias( "special_ogre", "ptpov_rodeo_move_left_entrance",			"ptpov_rodeo_move_ogre_left_entrance" )
	AddAnimAlias( "special_ogre", "pt_rodeo_move_back_idle",				"pt_rodeo_move_ogre_back_idle" )
	AddAnimAlias( "special_ogre", "pt_rodeo_move_right_entrance",			"pt_rodeo_move_ogre_right_entrance" )
	AddAnimAlias( "special_ogre", "pt_rodeo_move_back_entrance",			"pt_rodeo_move_ogre_back_entrance" )
	AddAnimAlias( "special_ogre", "pt_rodeo_move_front_entrance",			"pt_rodeo_move_ogre_front_entrance" )
	AddAnimAlias( "special_ogre", "pt_rodeo_move_front_lower_entrance",	"pt_rodeo_move_ogre_front_lower_entrance" )
	AddAnimAlias( "special_ogre", "pt_rodeo_move_back_mid_entrance",		"pt_rodeo_move_ogre_back_mid_entrance" )
	AddAnimAlias( "special_ogre", "pt_rodeo_move_back_lower_entrance",	"pt_rodeo_move_ogre_back_lower_entrance" )
	AddAnimAlias( "special_ogre", "pt_rodeo_move_left_entrance",			"pt_rodeo_move_ogre_left_entrance" )

	AddAnimAlias( "special_atlas", "ptpov_rodeo_move_back_idle",				"ptpov_rodeo_move_atlas_back_idle" )
	AddAnimAlias( "special_atlas", "ptpov_rodeo_move_back_entrance",			"ptpov_rodeo_move_atlas_back_entrance" )
	AddAnimAlias( "special_atlas", "ptpov_rodeo_move_front_entrance",			"ptpov_rodeo_move_atlas_front_entrance" )
	AddAnimAlias( "special_atlas", "ptpov_rodeo_move_front_lower_entrance",	"ptpov_rodeo_move_atlas_front_lower_entrance" )
	AddAnimAlias( "special_atlas", "ptpov_rodeo_move_back_mid_entrance",		"ptpov_rodeo_move_atlas_back_mid_entrance" )
	AddAnimAlias( "special_atlas", "ptpov_rodeo_move_back_lower_entrance",	"ptpov_rodeo_move_atlas_back_lower_entrance" )
	AddAnimAlias( "special_atlas", "ptpov_rodeo_move_left_entrance",			"ptpov_rodeo_move_atlas_left_entrance" )
	AddAnimAlias( "special_atlas", "ptpov_rodeo_move_right_entrance",			"ptpov_rodeo_move_atlas_right_entrance" )
	AddAnimAlias( "special_atlas", "pt_rodeo_move_back_idle",				"pt_rodeo_move_atlas_back_idle" )
	AddAnimAlias( "special_atlas", "pt_rodeo_move_back_entrance",			"pt_rodeo_move_atlas_back_entrance" )
	AddAnimAlias( "special_atlas", "pt_rodeo_move_front_entrance",		"pt_rodeo_move_atlas_front_entrance" )
	AddAnimAlias( "special_atlas", "pt_rodeo_move_front_lower_entrance",	"pt_rodeo_move_atlas_front_lower_entrance" )
	AddAnimAlias( "special_atlas", "pt_rodeo_move_back_mid_entrance",		"pt_rodeo_move_atlas_back_mid_entrance" )
	AddAnimAlias( "special_atlas", "pt_rodeo_move_back_lower_entrance",	"pt_rodeo_move_atlas_back_lower_entrance" )
	AddAnimAlias( "special_atlas", "pt_rodeo_move_left_entrance",			"pt_rodeo_move_atlas_left_entrance" )	// needs update
	AddAnimAlias( "special_atlas", "pt_rodeo_move_right_entrance",		"pt_rodeo_move_atlas_right_entrance" )

	AddAnimAlias( "special_stryder", "ptpov_rodeo_move_back_idle",			"ptpov_rodeo_move_stryder_back_idle" )
	AddAnimAlias( "special_stryder", "ptpov_rodeo_move_back_entrance",		"ptpov_rodeo_move_stryder_back_entrance" )
	AddAnimAlias( "special_stryder", "ptpov_rodeo_move_right_entrance",		"ptpov_rodeo_move_stryder_right_entrance" )
	AddAnimAlias( "special_stryder", "ptpov_rodeo_move_front_entrance",		"ptpov_rodeo_move_stryder_front_entrance" )
	AddAnimAlias( "special_stryder", "ptpov_rodeo_move_front_lower_entrance",	"ptpov_rodeo_move_stryder_front_lower_entrance" )
	AddAnimAlias( "special_stryder", "ptpov_rodeo_move_back_mid_entrance",	"ptpov_rodeo_move_stryder_back_mid_entrance" )
	AddAnimAlias( "special_stryder", "ptpov_rodeo_move_back_lower_entrance",	"ptpov_rodeo_move_stryder_back_lower_entrance" )
	AddAnimAlias( "special_stryder", "ptpov_rodeo_move_left_entrance",			"ptpov_rodeo_move_stryder_left_entrance" )
	AddAnimAlias( "special_stryder", "pt_rodeo_move_back_idle",			"pt_rodeo_move_stryder_back_idle" )
	AddAnimAlias( "special_stryder", "pt_rodeo_move_back_entrance",		"pt_rodeo_move_stryder_back_entrance" )
	AddAnimAlias( "special_stryder", "pt_rodeo_move_right_entrance",		"pt_rodeo_move_stryder_right_entrance" )
	AddAnimAlias( "special_stryder", "pt_rodeo_move_front_entrance",		"pt_rodeo_move_stryder_front_entrance" )
	AddAnimAlias( "special_stryder", "pt_rodeo_move_front_lower_entrance","pt_rodeo_move_stryder_front_lower_entrance" )
	AddAnimAlias( "special_stryder", "pt_rodeo_move_back_mid_entrance",	"pt_rodeo_move_stryder_back_mid_entrance" )
	AddAnimAlias( "special_stryder", "pt_rodeo_move_back_lower_entrance",	"pt_rodeo_move_stryder_back_lower_entrance" )
	AddAnimAlias( "special_stryder", "pt_rodeo_move_left_entrance",		"pt_rodeo_move_stryder_left_entrance" )
	
        // Hatch rip anims:

	AddAnimAlias( "atlas", "pt_rodeo_panel_fire", 						"pt_rodeo_panel_fire" )
	AddAnimAlias( "atlas", "at_rodeo_panel_opening", 					"hatch_rodeo_panel_opening" )
	AddAnimAlias( "atlas", "at_rodeo_panel_close_idle", 				"hatch_rodeo_panel_close_idle" )
	AddAnimAlias( "atlas", "at_Rodeo_Panel_Damage_State_0_Idle", 		"hatch_Rodeo_Panel_Damage_State_0_Idle" )
	AddAnimAlias( "atlas", "at_Rodeo_Panel_Damage_State_1_Idle", 		"hatch_Rodeo_Panel_Damage_State_1_Idle" )
	AddAnimAlias( "atlas", "at_Rodeo_Panel_Damage_State_2_Idle", 		"hatch_Rodeo_Panel_Damage_State_2_Idle" )
	AddAnimAlias( "atlas", "at_Rodeo_Panel_Damage_State_3_Idle", 		"hatch_Rodeo_Panel_Damage_State_3_Idle" )
	AddAnimAlias( "atlas", "at_Rodeo_Panel_Damage_State_4_Idle", 		"hatch_Rodeo_Panel_Damage_State_final_Idle" )
	AddAnimAlias( "atlas", "pt_rodeo_panel_opening", 					"pt_rodeo_panel_opening" )
	AddAnimAlias( "atlas", "pt_rodeo_panel_aim_idle", 				"pt_rodeo_panel_aim_idle_move" ) // just always move for now
	AddAnimAlias( "atlas", "pt_rodeo_player_side_lean", 				"pt_rodeo_player_side_lean" )
	AddAnimAlias( "atlas", "ptpov_rodeo_panel_opening", 				"ptpov_rodeo_panel_opening" )
	AddAnimAlias( "atlas", "ptpov_rodeo_panel_aim_idle", 				"ptpov_rodeo_panel_aim_idle" )
	AddAnimAlias( "atlas", "ptpov_rodeo_panel_aim_idle_move", 		"ptpov_rodeo_panel_aim_idle_move" )
	AddAnimAlias( "atlas", "ptpov_rodeo_player_side_lean_enemy", 		"ptpov_rodeo_player_side_lean" )
	
	AddAnimAlias( "ogre", "at_rodeo_panel_opening", 					"hatch_rodeo_panel_opening" )
	AddAnimAlias( "ogre", "at_rodeo_panel_close_idle", 				"hatch_rodeo_panel_close_idle" )
	AddAnimAlias( "ogre", "at_Rodeo_Panel_Damage_State_0_Idle", 		"hatch_Rodeo_Panel_Damage_State_0_Idle" )
	AddAnimAlias( "ogre", "at_Rodeo_Panel_Damage_State_1_Idle", 		"hatch_Rodeo_Panel_Damage_State_1_Idle" )
	AddAnimAlias( "ogre", "at_Rodeo_Panel_Damage_State_2_Idle", 		"hatch_Rodeo_Panel_Damage_State_2_Idle" )
	AddAnimAlias( "ogre", "at_Rodeo_Panel_Damage_State_3_Idle", 		"hatch_Rodeo_Panel_Damage_State_3_Idle" )
	AddAnimAlias( "ogre", "at_Rodeo_Panel_Damage_State_4_Idle", 		"hatch_Rodeo_Panel_Damage_State_final_Idle" )

	AddAnimAlias( "ogre", "pt_rodeo_panel_fire", 						"pt_rodeo_ogre_panel_fire" )
	AddAnimAlias( "ogre", "pt_rodeo_panel_opening", 					"pt_rodeo_ogre_panel_opening" )
	AddAnimAlias( "ogre", "pt_rodeo_panel_aim_idle", 					"pt_rodeo_ogre_panel_aim_idle_move" )
	AddAnimAlias( "ogre", "pt_rodeo_player_side_lean", 				"pt_rodeo_ogre_player_side_lean" )
	AddAnimAlias( "ogre", "ptpov_rodeo_panel_opening", 				"ptpov_rodeo_ogre_panel_opening" )
	AddAnimAlias( "ogre", "ptpov_rodeo_panel_aim_idle", 				"ptpov_ogre_rodeo_panel_aim_idle" )
	AddAnimAlias( "ogre", "ptpov_rodeo_panel_aim_idle_move", 			"ptpov_ogre_rodeo_panel_aim_idle_move" )
	AddAnimAlias( "ogre", "ptpov_rodeo_player_side_lean_enemy", 		"ptpov_Rodeo_ogre_player_side_lean" )

	AddAnimAlias( "stryder", "pt_rodeo_panel_fire", 					"pt_rodeo_stryder_panel_fire" )
	AddAnimAlias( "stryder", "at_rodeo_panel_opening", 					"hatch_rodeo_panel_opening" )
	AddAnimAlias( "stryder", "at_rodeo_panel_close_idle", 				"hatch_rodeo_panel_close_idle" )
	AddAnimAlias( "stryder", "at_Rodeo_Panel_Damage_State_0_Idle", 		"hatch_Rodeo_Panel_Damage_State_0_Idle" )
	AddAnimAlias( "stryder", "at_Rodeo_Panel_Damage_State_1_Idle", 		"hatch_Rodeo_Panel_Damage_State_1_Idle" )
	AddAnimAlias( "stryder", "at_Rodeo_Panel_Damage_State_2_Idle", 		"hatch_Rodeo_Panel_Damage_State_2_Idle" )
	AddAnimAlias( "stryder", "at_Rodeo_Panel_Damage_State_3_Idle", 		"hatch_Rodeo_Panel_Damage_State_3_Idle" )
	AddAnimAlias( "stryder", "at_Rodeo_Panel_Damage_State_4_Idle", 		"hatch_Rodeo_Panel_Damage_State_final_Idle" )
	AddAnimAlias( "stryder", "pt_rodeo_panel_opening", 					"pt_rodeo_stryder_panel_opening" )
	AddAnimAlias( "stryder", "pt_rodeo_panel_aim_idle", 					"pt_rodeo_stryder_panel_aim_idle_move" )
	AddAnimAlias( "stryder", "pt_rodeo_player_side_lean", 				"pt_rodeo_stryder_player_side_lean" )
	AddAnimAlias( "stryder", "ptpov_rodeo_panel_opening", 				"ptpov_rodeo_stryder_panel_opening" )
	AddAnimAlias( "stryder", "ptpov_rodeo_panel_aim_idle", 				"ptpov_stryder_rodeo_panel_aim_idle" )
	AddAnimAlias( "stryder", "ptpov_rodeo_panel_aim_idle_move", 			"ptpov_stryder_rodeo_panel_aim_idle_move" )
	AddAnimAlias( "stryder", "ptpov_rodeo_player_side_lean_enemy", 		"ptpov_Rodeo_stryder_player_side_lean" )

		
	AddAnimAlias( "special_atlas", "pt_rodeo_panel_fire", 						"pt_rodeo_panel_fire" )
	AddAnimAlias( "special_atlas", "at_rodeo_panel_opening", 					"hatch_rodeo_panel_opening" )
	AddAnimAlias( "special_atlas", "at_rodeo_panel_close_idle", 				"hatch_rodeo_panel_close_idle" )
	AddAnimAlias( "special_atlas", "at_Rodeo_Panel_Damage_State_0_Idle", 		"hatch_Rodeo_Panel_Damage_State_0_Idle" )
	AddAnimAlias( "special_atlas", "at_Rodeo_Panel_Damage_State_1_Idle", 		"hatch_Rodeo_Panel_Damage_State_1_Idle" )
	AddAnimAlias( "special_atlas", "at_Rodeo_Panel_Damage_State_2_Idle", 		"hatch_Rodeo_Panel_Damage_State_2_Idle" )
	AddAnimAlias( "special_atlas", "at_Rodeo_Panel_Damage_State_3_Idle", 		"hatch_Rodeo_Panel_Damage_State_3_Idle" )
	AddAnimAlias( "special_atlas", "at_Rodeo_Panel_Damage_State_4_Idle", 		"hatch_Rodeo_Panel_Damage_State_final_Idle" )
	AddAnimAlias( "special_atlas", "pt_rodeo_panel_opening", 					"pt_rodeo_panel_opening" )
	AddAnimAlias( "special_atlas", "pt_rodeo_panel_aim_idle", 				"pt_rodeo_panel_aim_idle_move" ) // just always move for now
	AddAnimAlias( "special_atlas", "pt_rodeo_player_side_lean", 				"pt_rodeo_player_side_lean" )
	AddAnimAlias( "special_atlas", "ptpov_rodeo_panel_opening", 				"ptpov_rodeo_panel_opening" )
	AddAnimAlias( "special_atlas", "ptpov_rodeo_panel_aim_idle", 				"ptpov_rodeo_panel_aim_idle" )
	AddAnimAlias( "special_atlas", "ptpov_rodeo_panel_aim_idle_move", 		"ptpov_rodeo_panel_aim_idle_move" )
	AddAnimAlias( "special_atlas", "ptpov_rodeo_player_side_lean_enemy", 		"ptpov_rodeo_player_side_lean" )

	
	AddAnimAlias( "special_ogre", "at_rodeo_panel_opening", 					"hatch_rodeo_panel_opening" )
	AddAnimAlias( "special_ogre", "at_rodeo_panel_close_idle", 				"hatch_rodeo_panel_close_idle" )
	AddAnimAlias( "special_ogre", "at_Rodeo_Panel_Damage_State_0_Idle", 		"hatch_Rodeo_Panel_Damage_State_0_Idle" )
	AddAnimAlias( "special_ogre", "at_Rodeo_Panel_Damage_State_1_Idle", 		"hatch_Rodeo_Panel_Damage_State_1_Idle" )
	AddAnimAlias( "special_ogre", "at_Rodeo_Panel_Damage_State_2_Idle", 		"hatch_Rodeo_Panel_Damage_State_2_Idle" )
	AddAnimAlias( "special_ogre", "at_Rodeo_Panel_Damage_State_3_Idle", 		"hatch_Rodeo_Panel_Damage_State_3_Idle" )
	AddAnimAlias( "special_ogre", "at_Rodeo_Panel_Damage_State_4_Idle", 		"hatch_Rodeo_Panel_Damage_State_final_Idle" )
	AddAnimAlias( "special_ogre", "pt_rodeo_panel_fire", 						"pt_rodeo_ogre_panel_fire" )
	AddAnimAlias( "special_ogre", "pt_rodeo_panel_opening", 					"pt_rodeo_ogre_panel_opening" )
	AddAnimAlias( "special_ogre", "pt_rodeo_panel_aim_idle", 					"pt_rodeo_ogre_panel_aim_idle_move" )
	AddAnimAlias( "special_ogre", "pt_rodeo_player_side_lean", 				"pt_rodeo_ogre_player_side_lean" )
	AddAnimAlias( "special_ogre", "ptpov_rodeo_panel_opening", 				"ptpov_rodeo_ogre_panel_opening" )
	AddAnimAlias( "special_ogre", "ptpov_rodeo_panel_aim_idle", 				"ptpov_ogre_rodeo_panel_aim_idle" )
	AddAnimAlias( "special_ogre", "ptpov_rodeo_panel_aim_idle_move", 			"ptpov_ogre_rodeo_panel_aim_idle_move" )
	AddAnimAlias( "special_ogre", "ptpov_rodeo_player_side_lean_enemy", 		"ptpov_Rodeo_ogre_player_side_lean" )

	AddAnimAlias( "special_stryder", "pt_rodeo_panel_fire", 					"pt_rodeo_stryder_panel_fire" )
	AddAnimAlias( "special_stryder", "at_rodeo_panel_opening", 					"hatch_rodeo_panel_opening" )
	AddAnimAlias( "special_stryder", "at_rodeo_panel_close_idle", 				"hatch_rodeo_panel_close_idle" )
	AddAnimAlias( "special_stryder", "at_Rodeo_Panel_Damage_State_0_Idle", 		"hatch_Rodeo_Panel_Damage_State_0_Idle" )
	AddAnimAlias( "special_stryder", "at_Rodeo_Panel_Damage_State_1_Idle", 		"hatch_Rodeo_Panel_Damage_State_1_Idle" )
	AddAnimAlias( "special_stryder", "at_Rodeo_Panel_Damage_State_2_Idle", 		"hatch_Rodeo_Panel_Damage_State_2_Idle" )
	AddAnimAlias( "special_stryder", "at_Rodeo_Panel_Damage_State_3_Idle", 		"hatch_Rodeo_Panel_Damage_State_3_Idle" )
	AddAnimAlias( "special_stryder", "at_Rodeo_Panel_Damage_State_4_Idle", 		"hatch_Rodeo_Panel_Damage_State_final_Idle" )
	AddAnimAlias( "special_stryder", "pt_rodeo_panel_opening", 					"pt_rodeo_stryder_panel_opening" )
	AddAnimAlias( "special_stryder", "pt_rodeo_panel_aim_idle", 					"pt_rodeo_stryder_panel_aim_idle_move" )
	AddAnimAlias( "special_stryder", "pt_rodeo_player_side_lean", 				"pt_rodeo_stryder_player_side_lean" )
	AddAnimAlias( "special_stryder", "ptpov_rodeo_panel_opening", 				"ptpov_rodeo_stryder_panel_opening" )
	AddAnimAlias( "special_stryder", "ptpov_rodeo_panel_aim_idle", 				"ptpov_stryder_rodeo_panel_aim_idle" )
	AddAnimAlias( "special_stryder", "ptpov_rodeo_panel_aim_idle_move", 			"ptpov_stryder_rodeo_panel_aim_idle_move" )
	AddAnimAlias( "special_stryder", "ptpov_rodeo_player_side_lean_enemy", 		"ptpov_Rodeo_stryder_player_side_lean" )
	
	if ( IsServer() )
	{
		AddSoulDeathFunc( SoulRodeoEnds )
		AddSoulTransferFunc( Bind( RecreateRodeoPanelDamageFX ) )
	}

	level.rodeoAnimations <-
	{
		thirdPersonAnimAlias_PanelOpen 				= VerifyAnimAlias( "pt_rodeo_panel_opening" )
		thirdPersonAnimAlias_AimIdle 				= VerifyAnimAlias( "pt_rodeo_panel_aim_idle" )
		thirdPersonAnimAlias_lean					= VerifyAnimAlias( "pt_rodeo_player_side_lean" )

		firstPersonAnimAlias_PanelOpen 				= VerifyAnimAlias( "ptpov_rodeo_panel_opening" )
		firstPersonAnimAlias_AimIdle 				= VerifyAnimAlias( "ptpov_rodeo_panel_aim_idle" )
		firstPersonAnimAlias_AimIdleMoving			= VerifyAnimAlias( "ptpov_rodeo_panel_aim_idle_move" )
		firstPersonAnimAlias_lean_enemy				= VerifyAnimAlias( "ptpov_rodeo_player_side_lean_enemy" )

		panelPersonAnimAlias_PanelOpen 				= VerifyAnimAlias( "at_rodeo_panel_opening" )
		panelPersonAnimAlias_PanelCloseIdle 		= VerifyAnimAlias( "at_rodeo_panel_close_idle" )
		panelPersonAnimAlias_DamageState0Idle		= VerifyAnimAlias( "at_Rodeo_Panel_Damage_State_0_Idle" )
		panelPersonAnimAlias_DamageState1Idle		= VerifyAnimAlias( "at_Rodeo_Panel_Damage_State_1_Idle" )
		panelPersonAnimAlias_DamageState2Idle		= VerifyAnimAlias( "at_Rodeo_Panel_Damage_State_2_Idle" )
		panelPersonAnimAlias_DamageState3Idle		= VerifyAnimAlias( "at_Rodeo_Panel_Damage_State_3_Idle" )
		panelPersonAnimAlias_DamageState4Idle		= VerifyAnimAlias( "at_Rodeo_Panel_Damage_State_4_Idle" )
	}

	enum eRodeoAnim
	{
		DUMMY
		LANDON_ABOVE
		LANDON_BACK
		CLIMBON_FRONT
		CLIMBON_BACK
		CLIMBON_BACKMID
		CLIMBON_LEFT
		CLIMBON_RIGHT
	}

	level.debugRodeoAnim <- eRodeoAnim.DUMMY

	if ( IsServer() )
	{
		AddClientCommandCallback( "HoldToRodeo", ClientCommand_HoldToRodeo )

		AddCallback_OnClientConnected( Rodeo_OnClientConnected )
	}
}

function AllowTeamRodeo( titan, trueorfalse )
{
	titan.s.npc_AllowTeamRodeo = trueorfalse
}
Globalize( AllowTeamRodeo )

function IsAllowedTeamRodeo( titan )
{
	// Only bad thing about this is that it makes the rodeo popup not show up
	// But at least it works i guess?
	if ( IsClient() )
		return false

	return titan.s.npc_AllowTeamRodeo
}

function CodeCallback_OnRodeoAttach( player, titan )
{
	local package = GetRodeoPackage( player, titan )
	if ( !package )
		return null

	local sequence = CreateFirstPersonSequence()
	sequence.attachment = "hijack"

	SetRodeoAnimsFromPackage( sequence, package )

	if ( IsServer() )
	{
		player.s.rodeoPackage <- package
	}

	return sequence
}

const HOLD_RODEO_DISABLED = 0
const HOLD_RODEO_ALL = 1
const HOLD_RODEO_FRIENDLY = 2

function CodeCallback_IsValidRodeoTarget( player, titan )
{
	if ( "isDisembarking" in player.s )
		return false

	local holdToRodeoState = HoldToRodeoState( player )

	if ( holdToRodeoState != HOLD_RODEO_DISABLED )
	{
		if ( holdToRodeoState != HOLD_RODEO_FRIENDLY || ShouldPreventFriendlyFire( titan, player ) )
		{
			if ( IsClient() )
			{
				if ( !player.s.rodeoPressed )
					return false
			}

			if ( IsServer() )
			{
				if ( !player.UseButtonPressed() )
					return false
			}
		}
	}

	return IsValidTitanRodeoTarget( player, titan )
}

function IsValidTitanRodeoTarget( player, titan )
{
	if ( !HasSoul( titan ) )
		return false

	if ( GetPlayerRodeoing( titan ) )
		return false

	if ( "hotDropPlayer" in titan.s )
		return false

	if ( IsValid( player.GetTitanSoulBeingRodeoed() ) )
		return false

	local soul = titan.GetTitanSoul()
	if ( !IsValid( soul ) )
		return false

	if ( soul.IsEjecting() )
		return false

	if ( titan.IsNPC() )
	{
		if ( titan.ContextAction_IsMeleeExecution() ) //JFS. Defensive fix because code calls SetRodeoAllowed() in code at end of rodeo, thus overriding script saying that this titan can't be rodeoed
			return false
		if ( !IsValid( soul.GetBossPlayer() ) )
		{
			if ( ShouldPreventFriendlyFire( player, titan ) && !IsAllowedTeamRodeo( titan ) )
				return false
		}
	}

	return true
}
Globalize( IsValidTitanRodeoTarget )

function FindPlayerJumponSpot( player, titan )
{
	local titanOrigin = GetTitanHijackOrigin( titan )
	local playerOrigin = player.GetOrigin()

	local dist = Distance( titanOrigin, playerOrigin )
//	DebugDrawLine( titanOrigin, playerOrigin, 255, 0, 0, true, 0.5 )
//	printt( "distance " + dist )
	if ( dist > 180 )
	{
		//printt( "Too far: " + dist )
		return false
	}

	local dot = VectorDot_PlayerToOrigin( player, titanOrigin )
//	printt( "dot " + dot )

	if ( dot < 0.5 )
	{
		//printt( "Low dot: ", dot )
		return false
	}

	return true
}
Globalize( FindPlayerJumponSpot )

function CreateRodeoPackageForJumpingOn( player, titan )
{
	local table = GetFrontRightDots( titan, player, "hijack" )
	local dotForward = table.dotForward

	local titanSoul = titan.GetTitanSoul()
	local titanType = GetSoulTitanType( titanSoul )

	local playerOrigin = player.GetOrigin()
	local titanOrigin = titan.GetOrigin()
	local fromBelow = titanOrigin.z - playerOrigin.z > -70

	local package = {}
	//printt( "dotForward " + dotForward )
//	printt( "origin z offset " + ( titanOrigin.z - playerOrigin.z ) )

	if ( fromBelow )
	{
		if ( dotForward > 0.0 )
		{
			package.thirdPersonAnim <- GetAnimFromAlias( titanType, "pt_rodeo_move_front_lower_entrance" )
			package.firstPersonAnim <- GetAnimFromAlias( titanType, "ptpov_rodeo_move_front_lower_entrance" )
			package.worldSound <- "Rodeo_" + titanType + "_Rodeo_ClimbOn_Front_Exterior"
			package.cockpitSound <- "Rodeo_" + titanType + "_Rodeo_ClimbOn_Front_Interior"
		}
		else
		{
			package.thirdPersonAnim <- GetAnimFromAlias( titanType, "pt_rodeo_move_back_lower_entrance" )
			package.firstPersonAnim <- GetAnimFromAlias( titanType, "ptpov_rodeo_move_back_lower_entrance" )
			package.worldSound <- "Rodeo_" + titanType + "_Rodeo_ClimbOn_Back_Exterior"
			package.cockpitSound <- "Rodeo_" + titanType + "_Rodeo_ClimbOn_Back_Interior"
		}
	}
	else
	if ( dotForward > 0.45 )
	{
		package.thirdPersonAnim <- GetAnimFromAlias( titanType, "pt_rodeo_move_front_lower_entrance" )
		package.firstPersonAnim <- GetAnimFromAlias( titanType, "ptpov_rodeo_move_front_lower_entrance" )
		package.worldSound <- "Rodeo_" + titanType + "_Rodeo_ClimbOn_Front_Exterior"
		package.cockpitSound <- "Rodeo_" + titanType + "_Rodeo_ClimbOn_Front_Interior"
		//printt( "FRONT" )
	}
	else
	if ( dotForward < -0.75 )
	{
		if ( fromBelow )
		{
			//printt( "REAR LOWER" )
			package.thirdPersonAnim <- GetAnimFromAlias( titanType, "pt_rodeo_move_back_lower_entrance" )
			package.firstPersonAnim <- GetAnimFromAlias( titanType, "ptpov_rodeo_move_back_lower_entrance" )
			package.worldSound <- "Rodeo_" + titanType + "_Rodeo_ClimbOn_Back_Exterior"
			package.cockpitSound <- "Rodeo_" + titanType + "_Rodeo_ClimbOn_Back_Interior"
		}
		else
		{
			//printt( "REAR MID" )
			package.thirdPersonAnim <- GetAnimFromAlias( titanType, "pt_rodeo_move_back_mid_entrance" )
			package.firstPersonAnim <- GetAnimFromAlias( titanType, "ptpov_rodeo_move_back_mid_entrance" )
			package.worldSound <- "Rodeo_" + titanType + "_Rodeo_ClimbOn_Back_Mid_Exterior"
			package.cockpitSound <- "Rodeo_" + titanType + "_Rodeo_ClimbOn_Back_Mid_Interior"
		}
	}
	else
	{
		if ( table.dotRight > 0 )
		{
			//printt( "RIGHT" )
			package.thirdPersonAnim <-	GetAnimFromAlias( titanType, "pt_rodeo_move_right_entrance" )
			package.firstPersonAnim <-	GetAnimFromAlias( titanType, "ptpov_rodeo_move_right_entrance" )
			package.worldSound <- "Rodeo_" + titanType + "_Rodeo_ClimbOn_Right_Exterior"
			package.cockpitSound <- "Rodeo_" + titanType + "_Rodeo_ClimbOn_Right_Interior"
		}
		else
		{
			//printt( "LEFT" )
			package.thirdPersonAnim <- GetAnimFromAlias( titanType, "pt_rodeo_move_left_entrance" )
			package.firstPersonAnim <- GetAnimFromAlias( titanType, "ptpov_rodeo_move_left_entrance" )
			package.worldSound <- "Rodeo_" + titanType + "_Rodeo_ClimbOn_Left_Exterior"
			package.cockpitSound <- "Rodeo_" + titanType + "_Rodeo_ClimbOn_Left_Interior"
		}
	}

	if ( package.len() == 0 )
		Assert( false, "No suitable rodeo package for player " +  player + " jumping onto titan " + titan + " with dotForward:  " + dotForward + " and dotRight: " + dotRight )

	//printt( "package.worldSound :" + package.worldSound + ", package.cockpitSound: " + package.cockpitSound )

	package.method <- RODEO_APPROACH_JUMP_ON

	return package

}

function PlayerFallingOntoTitan( player, titan )
{
	local titanOrigin = GetTitanHijackOrigin( titan )

	local verticalOffset = player.GetOrigin().z - titanOrigin.z
	if ( verticalOffset < 40 )
	{
		return false
	}

	local velocity = player.GetVelocity()
	if ( velocity.z > -120 )
		return false


	// are we looking at the titan?
	local dot = VectorDot_PlayerToOrigin( player, titanOrigin )

	if ( dot < 0.8 )
	{
//		printt( "LOOK DOT WAS " + dot )
		//DebugDrawLine( player.EyePosition(), titanOrigin, 255, 0, 0, true, 10 )
		return false
	}
	//DebugDrawLine( player.EyePosition(), titanOrigin, 0, 255, 0, true, 15 )

	velocity.Normalize()
	local dot = VectorDot_DirectionToOrigin( player, velocity, titanOrigin )

	// are we falling towards the titan?
	if ( dot < 0.8 )
	{
//		printt( "MOVE DOT WAS " + dot )
		//DebugDrawLine( player.EyePosition(), player.EyePosition() + velocity * 150, 255, 150, 0, true, 10 )
		return false
	}
	//DebugDrawLine( player.EyePosition(), player.EyePosition() + velocity * 150, 0, 255, 150, true, 15 )

	local startData = level.pilotDisembarkBounds.start
	local endData = level.pilotDisembarkBounds.end

	local start = player.GetOrigin()
	local end = titanOrigin

	// need client version
//	local result = TraceHull( start, end, player.GetPlayerMins(), player.GetPlayerMaxs(), null, TRACE_MASK_NPCSOLID_BRUSHONLY, TRACE_COLLISION_GROUP_NONE )
//	if ( result.fraction < 1 )
//		return false

	return true
}

function CreateRodeoPackageForFallingFromAbove( player, titan )
{
	local table = GetFrontRightDots( titan, player, "hijack" )

	local dotForward = table.dotForward
	local dotRight = table.dotRight

//	DebugDrawLine( titanOrg, titanOrg + titan.GetForwardVector() * 200, 255, 0, 0, true, 5 )
//	DebugDrawLine( titanOrg, titanOrg + vecToEnt * 200, 0, 255, 0, true, 5 )

	local titanSoul = titan.GetTitanSoul()
	local titanType = GetSoulTitanType( titanSoul )

	local package = {}

	if ( dotForward > 0.1  )
	{
		// landed on the front
		package.thirdPersonAnim <- GetAnimFromAlias( titanType, "pt_rodeo_move_front_entrance" )
		package.firstPersonAnim <- GetAnimFromAlias( titanType, "ptpov_rodeo_move_front_entrance" )
		package.worldSound <- "Rodeo_" + titanType + "_Rodeo_LandOn_Above_Exterior"
		package.cockpitSound <- "Rodeo_" + titanType + "_Rodeo_LandOn_Above_Interior"
	}
	else
	if ( dotForward < -0.88  )
	{
		// landed on the back
		package.thirdPersonAnim <- GetAnimFromAlias( titanType, "pt_rodeo_move_back_entrance" )
		package.firstPersonAnim <- GetAnimFromAlias( titanType, "ptpov_rodeo_move_back_entrance" )
		package.worldSound <- "Rodeo_" + titanType + "_Rodeo_LandOn_Back_Exterior"
		package.cockpitSound <- "Rodeo_" + titanType + "_Rodeo_LandOn_Back_Interior"
	}
	else
	{
		if ( dotRight < 0 )
		{
			//Reuse the same animation as climb on
			package.thirdPersonAnim <- GetAnimFromAlias( titanType, "pt_rodeo_move_left_entrance" )
			package.firstPersonAnim <- GetAnimFromAlias( titanType, "ptpov_rodeo_move_left_entrance" )
			package.worldSound <- "Rodeo_" + titanType + "_Rodeo_ClimbOn_Left_Exterior"
			package.cockpitSound <- "Rodeo_" + titanType + "_Rodeo_ClimbOn_Left_Interior"
		}
		else
		{
			//Reuse the same animation as climb on
			package.thirdPersonAnim <- GetAnimFromAlias( titanType, "pt_rodeo_move_right_entrance" )
			package.firstPersonAnim <- GetAnimFromAlias( titanType, "ptpov_rodeo_move_right_entrance" )
			package.worldSound <- "Rodeo_" + titanType + "_Rodeo_ClimbOn_Right_Exterior"
			package.cockpitSound <- "Rodeo_" + titanType + "_Rodeo_ClimbOn_Right_Interior"
		}
	}

	if ( package.len() == 0 )
		Assert( false, "No suitable rodeo package for player " +  player + " falling onto titan " + titan + " with dotForward:  " + dotForward + " and dotRight: " + dotRight )

	//printt( " worldSound: " + package.worldSound + ", cockpitSound: " + package.cockpitSound )

	package.method <- RODEO_APPROACH_FALLING_FROM_ABOVE

	return package
}

//Debug. Remove before ship
function CreateDebugRodeoPackageForTitan( titan )
{
	local titanSoul = titan.GetTitanSoul()
	local titanType = GetSoulTitanType( titanSoul )

	local package = {}

	switch ( level.debugRodeoAnim )
	{

		case( eRodeoAnim.LANDON_ABOVE ):
		{
			package.thirdPersonAnim <- GetAnimFromAlias( titanType, "pt_rodeo_move_front_entrance" )
			package.firstPersonAnim <- GetAnimFromAlias( titanType, "ptpov_rodeo_move_front_entrance" )
			package.worldSound <- "Rodeo_" + titanType + "_Rodeo_LandOn_Above_Exterior"
			package.cockpitSound <- "Rodeo_" + titanType + "_Rodeo_LandOn_Above_Interior"
			package.method <- RODEO_APPROACH_FALLING_FROM_ABOVE
			printt( "Forcing LANDON_ABOVE Rodeo Animation"  )
			break
		}

		case( eRodeoAnim.LANDON_BACK ):
		{
			package.thirdPersonAnim <- GetAnimFromAlias( titanType, "pt_rodeo_move_back_entrance" )
			package.firstPersonAnim <- GetAnimFromAlias( titanType, "ptpov_rodeo_move_back_entrance" )
			package.worldSound <- "Rodeo_" + titanType + "_Rodeo_LandOn_Back_Exterior"
			package.cockpitSound <- "Rodeo_" + titanType + "_Rodeo_LandOn_Back_Interior"
			package.method <- RODEO_APPROACH_FALLING_FROM_ABOVE
			printt( "Forcing LANDON_BACK Rodeo Animation"  )
			break
		}

		case( eRodeoAnim.CLIMBON_FRONT ):
		{
			package.thirdPersonAnim <- GetAnimFromAlias( titanType, "pt_rodeo_move_front_lower_entrance" )
			package.firstPersonAnim <- GetAnimFromAlias( titanType, "ptpov_rodeo_move_front_lower_entrance" )
			package.worldSound <- "Rodeo_" + titanType + "_Rodeo_ClimbOn_Front_Exterior"
			package.cockpitSound <- "Rodeo_" + titanType + "_Rodeo_ClimbOn_Front_Interior"
			package.method <- RODEO_APPROACH_JUMP_ON
			printt( "Forcing CLIMBON_FRONT Rodeo Animation"  )
			break
		}

		case( eRodeoAnim.CLIMBON_BACK ):
		{
			package.thirdPersonAnim <- GetAnimFromAlias( titanType, "pt_rodeo_move_back_lower_entrance" )
			package.firstPersonAnim <- GetAnimFromAlias( titanType, "ptpov_rodeo_move_back_lower_entrance" )
			package.worldSound <- "Rodeo_" + titanType + "_Rodeo_ClimbOn_Back_Exterior"
			package.cockpitSound <- "Rodeo_" + titanType + "_Rodeo_ClimbOn_Back_Interior"
			package.method <- RODEO_APPROACH_JUMP_ON
			printt( "Forcing CLIMBON_BACK Rodeo Animation"  )
			break
		}

		case( eRodeoAnim.CLIMBON_BACKMID ):
		{
			package.thirdPersonAnim <- GetAnimFromAlias( titanType, "pt_rodeo_move_back_mid_entrance" )
			package.firstPersonAnim <- GetAnimFromAlias( titanType, "ptpov_rodeo_move_back_mid_entrance" )
			package.worldSound <- "Rodeo_" + titanType + "_Rodeo_ClimbOn_Back_Mid_Exterior"
			package.cockpitSound <- "Rodeo_" + titanType + "_Rodeo_ClimbOn_Back_Mid_Interior"
			package.method <- RODEO_APPROACH_JUMP_ON
			printt( "Forcing CLIMBON_BACKMID Rodeo Animation"  )
			break
		}

		case( eRodeoAnim.CLIMBON_LEFT ):
		{
			package.thirdPersonAnim <- GetAnimFromAlias( titanType, "pt_rodeo_move_left_entrance" )
			package.firstPersonAnim <- GetAnimFromAlias( titanType, "ptpov_rodeo_move_left_entrance" )
			package.worldSound <- "Rodeo_" + titanType + "_Rodeo_ClimbOn_Left_Exterior"
			package.cockpitSound <- "Rodeo_" + titanType + "_Rodeo_ClimbOn_Left_Interior"
			package.method <- RODEO_APPROACH_JUMP_ON
			printt( "Forcing CLIMBON_LEFT Rodeo Animation"  )
			break
		}

		case( eRodeoAnim.CLIMBON_RIGHT ):
		{
			package.thirdPersonAnim <-	GetAnimFromAlias( titanType, "pt_rodeo_move_right_entrance" )
			package.firstPersonAnim <-	GetAnimFromAlias( titanType, "ptpov_rodeo_move_right_entrance" )
			package.worldSound <- "Rodeo_" + titanType + "_Rodeo_ClimbOn_Right_Exterior"
			package.cockpitSound <- "Rodeo_" + titanType + "_Rodeo_ClimbOn_Right_Interior"
			package.method <- RODEO_APPROACH_JUMP_ON
			printt( "Forcing CLIMBON_RIGHT Rodeo Animation"  )
			break
		}

		default:
		{
			Assert( false, "Unknown debugRodeoAnim: " +  level.debugRodeoAnim )

		}
	}

	return package

}

function SetDebugRodeoAnim( value )
{
	Assert( value <= eRodeoAnim.CLIMBON_RIGHT, "DebugRodeoAnim must be set to less than or equal to " +  eRodeoAnim.CLIMBON_RIGHT )
	Assert( value >= eRodeoAnim.DUMMY, "DebugRodeoAnim must be set to less than or equal to " +  eRodeoAnim.DUMMY )

	level.debugRodeoAnim = value
}

function SetRodeoAnimsFromPackage( sequence, package )
{
	sequence.thirdPersonAnim = package.thirdPersonAnim
	sequence.firstPersonAnim = package.firstPersonAnim
	sequence.worldSound <- package.worldSound
	sequence.cockpitSound <- package.cockpitSound
}

function GetRodeoPackage( player, titan )
{
	local titanOrigin = GetTitanHijackOrigin( titan )
	local playerOrigin = player.GetOrigin()
	local dist
	local isLungeTarget = titan == player.PlayerLunge_GetTarget()

	if ( isLungeTarget )
		dist = 250
	else
		dist = 180

	local distanceFromTitan = Distance( titanOrigin, playerOrigin )
	if ( distanceFromTitan > dist )
		return null

	//Debug. Remove before ship
	if ( level.debugRodeoAnim > eRodeoAnim.DUMMY )
		return CreateDebugRodeoPackageForTitan( titan )

	if ( PlayerFallingOntoTitan( player, titan ) )
		return CreateRodeoPackageForFallingFromAbove( player, titan )
	else if ( FindPlayerJumponSpot( player, titan ) )
		return CreateRodeoPackageForJumpingOn( player, titan)

	return null
}

function GetTitanHijackOrigin( titan )
{
	// can optimize this
	local hijackAttachIndex = titan.LookupAttachment( "hijack" )
	Assert( hijackAttachIndex > 0 )
	return titan.GetAttachmentOrigin( hijackAttachIndex ) + Vector(0,0,40)
}

function GetTitanHijackAngles( titan )
{
	// can optimize this
	local hijackAttachIndex = titan.LookupAttachment( "hijack" )
	Assert( hijackAttachIndex > 0 )
	return titan.GetAttachmentAngles( hijackAttachIndex )
}

function UpdateDamageStateOfPanel( soul )
{
	local titan = soul.GetTitan()
	if ( !IsAlive( titan ) )
		return
	local panel = soul.rodeoPanel

	CreateSparksInsideTitanPanel( panel )
	EmitDifferentSoundsOnEntityForPlayerAndWorld( "titan_brain_damage_1P", "titan_brain_damage_3P", panel, titan )
	if ( !panel.s.damageAnimDone )
		return

	local titanHealthRatio = titan.GetHealth().tofloat() / titan.GetMaxHealth()
	if ( titan.GetDoomedState() )
		titanHealthRatio = 0.0
	local damageStateThreshold

	if ( titanHealthRatio < RODEO_DAMAGE_STATE_4_THRESHOLD
		 && panel.s.lastDamageStateThreshold == RODEO_DAMAGE_STATE_4_THRESHOLD )
	{
		//Special case: Don't play the last anim more than once
		return
	}
	else if ( titanHealthRatio < RODEO_DAMAGE_STATE_4_THRESHOLD
		 && panel.s.lastDamageStateThreshold <= RODEO_DAMAGE_STATE_3_THRESHOLD )
	{
		damageStateThreshold = RODEO_DAMAGE_STATE_4_THRESHOLD
		if ( panel.s.lastDamageStateThreshold == RODEO_DAMAGE_STATE_3_THRESHOLD )
		{
			//printt( "Creating last damage State effect" )
			//Note: Don't have to kill this last particle system since when the Titan dies, the panel it's attached to dies,
			//and the particle system that's attached to the panel dies
			CreateDamageStateParticlesForPanel( panel, "P_rodeo_damage_3" )
		}



	}
	else if ( titanHealthRatio < RODEO_DAMAGE_STATE_3_THRESHOLD
		&& panel.s.lastDamageStateThreshold <= RODEO_DAMAGE_STATE_2_THRESHOLD )
	{
		damageStateThreshold = RODEO_DAMAGE_STATE_3_THRESHOLD
		if ( panel.s.lastDamageStateThreshold == RODEO_DAMAGE_STATE_2_THRESHOLD )
		{
			//printt( "Creating damage State3 effect" )
			CreateDamageStateParticlesForPanel( panel, "P_rodeo_damage_3" )
		}
	}

	else if ( titanHealthRatio < RODEO_DAMAGE_STATE_2_THRESHOLD
		&& panel.s.lastDamageStateThreshold <= RODEO_DAMAGE_STATE_1_THRESHOLD )
	{
		damageStateThreshold = RODEO_DAMAGE_STATE_2_THRESHOLD
		if ( panel.s.lastDamageStateThreshold == RODEO_DAMAGE_STATE_1_THRESHOLD )
		{
			//printt( "Creating damage State2 effect" )
			CreateDamageStateParticlesForPanel( panel, "P_rodeo_damage_3" )
		}
	}

	else if ( titanHealthRatio < RODEO_DAMAGE_STATE_1_THRESHOLD
		 && panel.s.lastDamageStateThreshold <= RODEO_DAMAGE_STATE_0_THRESHOLD )
	{
		damageStateThreshold = RODEO_DAMAGE_STATE_1_THRESHOLD
		if ( panel.s.lastDamageStateThreshold == RODEO_DAMAGE_STATE_0_THRESHOLD )
		{
			//printt( "Creating damage State1 effect" )
			CreateDamageStateParticlesForPanel( panel, "P_rodeo_damage_2" )
		}

	}

	else
	{
		damageStateThreshold = RODEO_DAMAGE_STATE_0_THRESHOLD
		if ( panel.s.lastDamageStateThreshold != RODEO_DAMAGE_STATE_0_THRESHOLD )
		{
			//printt( "Creating damage State0 effect" )
			CreateDamageStateParticlesForPanel( panel, "P_rodeo_damage_1" )
		}

	}

	local settings = GetSoulTitanType( soul )
	local anims = level.rodeoAnimations
	local animName
	if ( damageStateThreshold == RODEO_DAMAGE_STATE_4_THRESHOLD )
	{
		animName = GetAnimFromAlias( settings, anims.panelPersonAnimAlias_DamageState4Idle )
	}
	else if ( damageStateThreshold == RODEO_DAMAGE_STATE_3_THRESHOLD )
	{
		animName = GetAnimFromAlias( settings,anims.panelPersonAnimAlias_DamageState3Idle )
	}
	else if ( damageStateThreshold == RODEO_DAMAGE_STATE_2_THRESHOLD )
	{
		animName = GetAnimFromAlias( settings, anims.panelPersonAnimAlias_DamageState2Idle )
	}
	else if ( damageStateThreshold == RODEO_DAMAGE_STATE_1_THRESHOLD )
	{
		animName = GetAnimFromAlias( settings, anims.panelPersonAnimAlias_DamageState1Idle )
	}
	else
	{
		animName = GetAnimFromAlias( settings, anims.panelPersonAnimAlias_DamageState0Idle )
	}

	//printt( "Anim: " + animName )
	panel.s.lastDamageStateThreshold = damageStateThreshold
	panel.s.damageAnimDone = false
	panel.Anim_Play( animName )
	panel.WaittillAnimDone()
	panel.s.damageAnimDone = true

}

function CreateSparksInsideTitanPanel( panel )
{
	local impactSpark = CreateEntity( "info_particle_system" )
	impactSpark.kv.start_active = 1
	impactSpark.kv.VisibilityFlags = 7
	impactSpark.kv.effect_name = "P_impact_rodeo_damage"
	impactSpark.SetName( UniqueString() )
	impactSpark.SetParent( panel, "hatch", false, 0 )
	DispatchSpawn( impactSpark, false )
	impactSpark.Kill( 1.5 )
}

function CreateDamageStateParticlesForPanel( panel, particleSystem = "P_impact_rodeo_damage" )
{
	local impactSpark = CreateEntity( "info_particle_system" )
	impactSpark.kv.start_active = 1
	impactSpark.SetOwner( panel.GetParent() )
	impactSpark.kv.VisibilityFlags = 6 // not visible to owner
	impactSpark.kv.effect_name = particleSystem
	impactSpark.SetName( UniqueString() )
	impactSpark.SetParent( panel, "hatch", false, 0 )
	DispatchSpawn( impactSpark, false )
	if ( IsValid( panel.s.lastDamageStateParticleSystem ) )
	{
		//printt("Killing particle system: " + panel.s.lastDamageStateParticleSystem)
		panel.s.lastDamageStateParticleSystem.Kill()
	}


	panel.s.lastDamageStateParticleSystem = impactSpark
}


function RecreateRodeoPanelDamageFX( soul, titan = null, oldTitan = null )
{
	thread RecreateRodeoPanelDamageFX_threaded( soul )

}

function RecreateRodeoPanelDamageFX_threaded( soul )
{
	WaitEndFrame()
	local panel = soul.rodeoPanel

	if (! IsValid( panel ) )
		return

	local lastDamageStateParticleSystem = panel.s.lastDamageStateParticleSystem

	if ( IsValid( lastDamageStateParticleSystem ) )
		CreateDamageStateParticlesForPanel( panel, lastDamageStateParticleSystem.kv.effect_name ) //This kills the last particle system too
}
Globalize( RecreateRodeoPanelDamageFX_threaded )

function ForceRodeoOver( titan )
{
	local soul = titan.GetTitanSoul()
	if ( !IsValid( soul ) )
		return

	SoulRodeoEnds( soul )
}

function SoulRodeoEnds( soul )
{
	local human = soul.GetRiderEnt()
	if ( IsAlive( human ) )
	{
		human.Signal( "RodeoOver" )
		human.ClearParent()
	}
}

/*
function ClamberAround( human, titan)
{
	titan.EndSignal( "OnDeath" )

	human.EndSignal( "OnDeath" )
	human.EndSignal( "Disconnected" )
	human.EndSignal( "RodeoOver" )
	human.EndSignal( "RodeoKilledTitan" )

	local firstPersonProxy = human.GetFirstPersonProxy()
	Assert( firstPersonProxy )
	wait 0.5

	local titanModel = "atlas"

	OnThreadEnd(
		function () : ( human, firstPersonProxy )
		{
			if ( IsValid( firstPersonProxy ) )
			{
				firstPersonProxy.Hide()
				firstPersonProxy.RenderWithViewModels( false )
			}
		}
	)

	while (true)
	{
		wait 0
		local joystickDirection = "none"
		local xAxis = GetInput_XAxis(human)
		local yAxis = GetInput_YAxis(human)
		if ( fabs( xAxis ) > 0.5 && fabs( yAxis ) > 0.5 )
		{
			if ( fabs( xAxis ) > fabs( yAxis ) )
			{
				yAxis = 0
			}
			else
			{
				xAxis = 0
			}
		}

		if ( xAxis < -0.5 )
		{
			joystickDirection = "left"
		}
		else if ( xAxis > 0.5 )
		{
			joystickDirection = "right"
		}
		else if ( yAxis > 0.5 )
		{

			joystickDirection = "up"
		}

		//doesn't make sense to press down, so no clause for that

		if ( joystickDirection == "none")
		{
			//printt("Continuing because no direction found")
			continue
		}
		else
		{
			//printt("Direction found")
			local direction = level.clamberStartEndDirections[ human.s.attachPoint ][ joystickDirection ]
			//We actually have direction. Find out what animations to play!
			local attachPoint = human.s.attachPoint
			local table = level.allTitanClamberActions[ titanModel ][ human.s.attachPoint ][ direction ]

			local transitionAnim1p = table[ "firstPersonTransitionAnim" ]
			local transitionAnim3p = table[ "thirdPersonTransitionAnim" ]
			local poseAnim1p = table[ "firstPersonPoseAnim" ]
			local poseAnim3p = table[ "thirdPersonPoseAnim" ]

			printt ("transition1p: " + transitionAnim1p)
			printt ("transition3p: " + transitionAnim3p)
			printt ("pose1p: " + poseAnim1p)
			printt ("pose3p: " + poseAnim3p)


			//play anim, wait until it finishes
			firstPersonProxy.Anim_Play(transitionAnim1p)
			firstPersonProxy.RenderWithViewModels( true )
			firstPersonProxy.Show()

			human.Anim_Play(transitionAnim3p)
			human.SetAnimViewEntity( firstPersonProxy )

			human.PlayerCone_SetMinYaw( -50 )
			human.PlayerCone_SetMaxYaw( 10 )
			human.PlayerCone_SetMinPitch( -60 )
			human.PlayerCone_SetMaxPitch( 30 )
			human.PlayerCone_SetLerpTime( 0.5 )
			human.PlayerCone_FromAnim()

			WaitEndFrame()

			waitthread WaitTillAnimationIsDone( human, titan, transitionAnim3p )
			printt("finished waiting for clamber animation" + transitionAnim3p + " to end\n")
			//Need to wait 0, otherwise the last part of the transition Animation gets interrupted by the idle pose animation
			wait 0

			//clean up
			printt("Changing value of attachPoint from " + human.s.attachPoint + " to " + level.clamberStartEndDirections[ human.s.attachPoint ][ joystickDirection ] + "\n")
			human.s.attachPoint = level.clamberStartEndDirections[ human.s.attachPoint ][ joystickDirection ]
			firstPersonProxy.Anim_Play(poseAnim1p)
			human.Anim_Play(poseAnim3p)

			human.PlayerCone_SetMinYaw( -50 )
			human.PlayerCone_SetMaxYaw( 10 )
			human.PlayerCone_SetMinPitch( -60 )
			human.PlayerCone_SetMaxPitch( 30 )
			human.PlayerCone_SetLerpTime( 0.5 )
			human.PlayerCone_FromAnim()
		}
	}

}
*/

function GetPlayerRodeoing( titan )
{
	Assert( IsValid( titan ) )
	Assert( titan.IsTitan() )
	Assert( !titan.IsHuman() )
	Assert( HasSoul( titan ) )

	return titan.GetTitanSoul().GetRiderEnt()
}

function GetTitanSoulBeingRodeoed( player )
{
	Assert( IsValid( player ) )
	return player.GetTitanSoulBeingRodeoed()
}

function GetTitanBeingRodeoed( player )
{
	local soul = GetTitanSoulBeingRodeoed( player )
	if ( !IsValid( soul ) )
		return null

	return soul.GetTitan()
}


/*
//function meant to be used in a thread
function WaitTillAnimationIsDone( player, enemyTitan, animation )
{
	player.EndSignal( "Disconnected" )
	player.EndSignal( "OnAnimationInterrupted" )
	enemyTitan.EndSignal( "OnDeath" )

	player.WaittillAnimDone()
}
*/

function IsRodeoEnabled( titan )
{
	Assert( titan.IsTitan(), "tried calling IsRodeoEnabled on non-titan" )

	if ( "isRodeoEnabled" in titan.s )
		return titan.s.isRodeoEnabled
	else
		return true
}

function EnableRodeo( titan )
{
	Assert( titan.IsTitan(), "tried calling EnableRodeo on non-titan" )

	local titanSoul = titan.GetTitanSoul()

	Assert( IsValid ( titanSoul ) )

	titanSoul.SetRodeoAllowed() //Lets rodeo happen on them.

}

function DisableRodeo( titan )
{
	Assert( titan.IsTitan(), "tried calling DisableRodeo on non-titan" )

	local titanSoul = titan.GetTitanSoul()

	Assert( IsValid ( titanSoul ) )

	titanSoul.ClearRodeoAllowed() //Stops rodeo from happening on them.
}

function PlayerIsRodeoingTarget( player, target )
{
	if ( !player.IsPlayer() )
		return false
	if ( player.IsTitan() )
		return false
	if ( !target.IsTitan() )
		return false
	return player.GetTitanSoulBeingRodeoed() == target.GetTitanSoul()
}

function GetFriendlyRodeoPlayer( titan )
{
	local rodeoPlayer = GetPlayerRodeoing( titan )

	if ( !IsValid( rodeoPlayer ) )
		return null

	if ( !ShouldPreventFriendlyFire( rodeoPlayer, titan ) )
		return null

	return rodeoPlayer
}

function GetEnemyRodeoPlayer( titan )
{
	local rodeoPlayer = GetPlayerRodeoing( titan )

	if ( !IsValid( rodeoPlayer ) )
		return null

	if ( ShouldPreventFriendlyFire( rodeoPlayer, titan ) )
		return null

	return rodeoPlayer
}

function GiveFriendlyRodeoPlayerProtection( titan )
{
	local rodeoBuddy = GetFriendlyRodeoPlayer( titan )
	if ( IsValid( rodeoBuddy ) )
	{
		//printt( "Set rodeoBuddy PassDamageToParent true" )
		rodeoBuddy.kv.PassDamageToParent = true //rodeo player now passes damage to titan
	}

}

function TakeAwayFriendlyRodeoPlayerProtection( titan )
{
	local rodeoBuddy = GetFriendlyRodeoPlayer( titan )
	if ( IsValid( rodeoBuddy ) )
	{
		//printt( "Set rodeoBuddy PassDamageToParent false" )
		rodeoBuddy.kv.PassDamageToParent = false //rodeo player now takes full damage
	}
}

function DebugRodeoTimes()
{
	local settings = [ "atlas", "ogre", "stryder", "special_atlas", "special_ogre", "special_stryder" ]

	local models = [ "models/Humans/imc_pilot/male_cq/imc_pilot_male_cq.mdl", "models/humans/pilot/female_cq/pilot_female_cq.mdl" ]
	local times = {}

	local rodeoAnims = [
			"pt_rodeo_move_back_entrance",
			"pt_rodeo_move_right_entrance",
			"pt_rodeo_move_front_entrance",
			"pt_rodeo_move_front_lower_entrance",
			"pt_rodeo_move_back_mid_entrance",
			"pt_rodeo_move_back_lower_entrance",
			"pt_rodeo_move_left_entrance"
			]

	foreach ( model in models )
	{
		times[ model ] <- []
		local prop = CreatePropDynamic( model, Vector(0,0,0), Vector(0,0,0) )
		printt( "Human model: " + model )

		foreach ( setting in settings )
		{
			foreach ( alias in rodeoAnims )
			{
				local animation = GetAnimFromAlias( setting, alias )
		        local time = prop.GetSequenceDuration( animation )
				times[ model ].append( { time = time, animation = animation } )
		    }
		}

		prop.Kill()
	}

	printt( "Time comparison: " )
	local wrong = false
	for ( local i = 0; i < times[ models[0] ].len(); i++ )
	{
		if ( times[models[0]][i].time == times[models[1]][i].time )
		{
			printt( "   MATCH: " + ( i + 1 ) + " times: 	" + times[models[0]][i].time + "	 	" + times[models[1]][i].time + " 	" + times[models[1]][i].animation )
		}
		else
		{
			printt( "MISMATCH: " + ( i + 1 ) + " times: 	" + times[models[0]][i].time + "		 " + times[models[1]][i].time + " 	" + times[models[1]][i].animation )
		}
		if ( ( i + 1 ) % rodeoAnims.len() == 0 )
			printt( " " )
	}
	Assert( !wrong, "Times did not match between male and female, see above" )
}



/************************************************************************************************\

		SPECTRE RODEO

\************************************************************************************************/
function GetRodeoPackageSpectre( spectre, titan )
{
	local titanOrigin = GetTitanHijackOrigin( titan )
	local spectreOrigin = spectre.GetOrigin()

	if ( SpectreFallingOntoTitan( spectre, titan ) )
		return CreateRodeoPackageForFallingFromAbove( spectre, titan )
	else
		return CreateRodeoPackageForJumpingOn( spectre, titan)
}
Globalize( GetRodeoPackageSpectre )

function SpectreFallingOntoTitan( spectre, titan )
{
	local titanOrigin = GetTitanHijackOrigin( titan )

	local verticalOffset = spectre.GetOrigin().z - titanOrigin.z
	if ( verticalOffset < 40 )
		return false

	local velocity = spectre.GetVelocity()
	if ( velocity.z > -120 )
		return false

	velocity.Normalize()
	local dot = VectorDot_DirectionToOrigin( spectre, velocity, titanOrigin )

	// are we falling towards the titan?
	if ( dot < 0.8 )
		return false

	return true
}
Globalize( SpectreFallingOntoTitan )

function HoldToRodeoEnabled( player )
{
	if ( IsServer() )
	{
		return HoldToRodeoState( player ) > HOLD_RODEO_DISABLED
	}
	else if ( IsClient() )
	{
		return GetConVarInt( "cl_hold_to_rodeo_enable " ) > 0
	}

	return false
}
Globalize( HoldToRodeoEnabled )

function HoldToRodeoState( player )
{
	if ( IsServer() )
	{
		if ( !( "holdToRodeoState" in player.s ) )
			player.s.holdToRodeoState <- HOLD_RODEO_DISABLED

		return player.s.holdToRodeoState
	}
	else if ( IsClient() )
	{
		return GetConVarInt( "cl_hold_to_rodeo_enable" )
	}

	return false
}
Globalize( HoldToRodeoState )

if ( IsServer() )
{
	function Rodeo_OnClientConnected( player )
	{
		HoldToRodeoState( player )
	}

	function ClientCommand_HoldToRodeo( player, args )
	{
		local holdToRodeoState = args.tointeger()
		if ( holdToRodeoState < 0 || holdToRodeoState > 2)
			return true
	
		player.s.holdToRodeoState = holdToRodeoState
	
		return true
	}
}
