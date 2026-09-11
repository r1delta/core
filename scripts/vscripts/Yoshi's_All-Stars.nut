// For Modded Titans
//const LEGION_MODEL = "models/titans/heavy/titan_heavy_deadbolt.mdl"

function CustomTitansScripts()
{
	ExpectedCustomScripts.append("AS_create_legion")
	ExpectedCustomScripts.append("AS_create_scorch")
	ExpectedCustomScripts.append("AS_create_tone")
	ExpectedCustomScripts.append("AS_create_ion")
	ExpectedCustomScripts.append("AS_create_ronin")
	ExpectedCustomScripts.append("AS_create_northstar")
}

function main()
{
	Globalize( MasterTitanCreation )
	CustomTitansScripts()

	local loop_max = ExpectedCustomScripts.len()
	for( local E = 0; E < loop_max; E++ )
	{
		if( loop_max > 0 )
		{
			local script = ExpectedCustomScripts[ E ]

			if ( ScriptExists( script ) )
				IncludeFile( script )
			else
				ExpectedCustomScripts.remove(script)
				
		}
	}
	/*
	if ( ScriptExists( TD_scriptName ) )

	IncludeFile("AS_create_legion")
	IncludeFile("AS_create_scorch")
	IncludeFile("AS_create_tone")
	IncludeFile("AS_create_ion")
	IncludeFile("AS_create_ronin")
	IncludeFile("AS_create_northstar")
	*/
	//add_setfile_persistance()
}

function MasterTitanCreation( file, type, emb_ove, unl_lv, p_name, p_desc, t_img_imc, t_img_mcor, c_name, c_desc, c_img, s_s, s_a, s_h, s_b, ref_rodeo, titan_mdl, hatch_mdl, rodeo_num, coop_img, weap_overrides, hud_c_name, hud_c_hint, custom_core_start, custom_core_end )
{
	//local modded_titan_table = {}

	printl( file )

	local loop_max = MasterModdedTitans.len()
	for( local E = 0; E < loop_max; E++ )
	{
		if( loop_max > 0 )
		{
			local t_a = MasterModdedTitans[ E ]

			if( t_a.setfile == file )
				return
			
		}
	}

	local titan_array_name = {}//a
	
	titan_array_name.setfile <- file//b
	titan_array_name.titan_type <- type //c
	titan_array_name.embark_override <- emb_ove //d

	titan_array_name.unlock_level <- unl_lv //e
	titan_array_name.print_name <- p_name // f
	titan_array_name.print_desc <- p_desc // g
	titan_array_name.titan_img_imc <- t_img_imc // h
	titan_array_name.titan_img_mcor <- t_img_mcor // i

	titan_array_name.core_name <- c_name // j
	titan_array_name.core_desc <- c_desc // k
	titan_array_name.core_img <- c_img // l

	titan_array_name.stat_speed <- s_s // m
	titan_array_name.stat_accel <- s_a // n
	titan_array_name.stat_health <- s_h // o
	titan_array_name.stat_boost_count <- s_b // p

	titan_array_name.rodeo_ref_override <- ref_rodeo // q

	titan_array_name.titan_model <- titan_mdl // r
	titan_array_name.hatch_model <- hatch_mdl // s
	titan_array_name.rodeo_hitbox_number <- rodeo_num // t
	titan_array_name.coop_img <- coop_img // u

	titan_array_name.weapon_overrides <- weap_overrides // v

	titan_array_name.hud_core_name <- hud_c_name // w
	titan_array_name.hud_core_hint <- hud_c_hint // x
	titan_array_name.core_start <- custom_core_start // y
	titan_array_name.core_end <- custom_core_end // z

	MasterModdedTitans.append(titan_array_name)

	//printt( titan_array_name )
	
	//::Titans_Enum_Placement <- ::Titans_Enum_Placement + 1
	//printl(::Titans_Enum_Placement)
	
	//add_setfile_persistance2( file, ::Titans_Enum_Placement )
	//CreateBlackMarketModdedItems( Titans_Enum_Placement - BASE_TITAN_COUNT )
}
//holy shit i have the entire alphabet

main()

/*
	setfile, # self explanatory
	type, # basically either special_ogre, special_atlas, or special_stryder
	emb_ove, # embark override. REQUIRED
	unl_lv, # unlock level
	p_name, # ui only
	p_desc, # ui only
	t_img_imc, # ui only
	t_img_mcor, # ui only
	c_name, # ui only
	c_desc, # ui only
	c_img, # ui only
	stat_speed, # ui only
	stat_acceleration, # ui only
	stat_health amount, # ui only
	stat_boost count, # ui only
	rodeo reference override, # can leave as just "hijack" for default

	titan model, # titan model
	hatch model, # rodeo hatch
	rodeo hitbox number, # the weakpoint for when rodeoing. ttf2 titans dont have it by default ;-;
	co_op img, # frontier defense player img
	offhand override # for replacing either tactical ( true ) or ordnance ( false )
*/