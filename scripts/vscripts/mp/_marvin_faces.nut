function main()
{
	Globalize( MarvinFace )
	Globalize( MarvinThinksAwhile )
	Globalize( MarvinFaceExists )
	Globalize( SetMarvinBodyType )
	Globalize( MarvinSetFace )

	RegisterSignal( "StopThinking" )

	AddSpawnCallback( "npc_marvin", MarvinSpawnCallback )

	SetupMarvinFaces()
}

function SetupMarvinFaces()
{
	// setup marvin face mappings
	level.marvinFaces <- {}
	level.marvinFaces[ MARVIN_TYPE_WORKER ] <-
	{
		none = 0
		happy = 1
		sad = 2
		angry = 3
		think1 = 4
		think2 = 5
		question = 6
	}

	// Use the yellow worker marvin skins since shooters are from SP and shooter value = 0 which is LevelEd's default.
	// Real shooter skins are 7-13.  If we want real skins, we can add them here and adjust the marvin spawn points per level.
	level.marvinFaces[ MARVIN_TYPE_SHOOTER ] <-
	{
		none = 0
		happy = 1
		sad = 2
		angry = 3
		think1 = 4
		think2 = 5
		question = 6
	}

	level.marvinFaces[ MARVIN_TYPE_FIREFIGHTER ] <-
	{
		none = 14
		happy = 15
		sad = 16
		angry = 17
		think1 = 18
		think2 = 19
		question = 20
	}

	// No idea what this type of marvin is...legacy stuff. Just make them yellow.
	level.marvinFaces[ MARVIN_TYPE_MARVINONE ] <-
	{
		none = 0
		happy = 1
		sad = 2
		angry = 3
		think1 = 4
		think2 = 5
		question = 6
	}

// Nothing uses this except debug statements that are commented out
/*
	level.marvinFaceNames <- {}
	// invert map for tests
	foreach ( key, val in level.marvinFace )
	{
		level.marvinFaceNames[ val ] <- key
	}
*/
}

function MarvinFace( marvin )
{
	thread MarvinFaceThink( marvin )
}

function MarvinFaceThink( marvin )
{
	//printl( "Setting up marvin face for " + marvin )
	for ( ;; )
	{
		waitthread MarvinUndamagedFacePicker( marvin )

//		printl( "damaged " + marvin )
		if ( !IsAlive( marvin ) )
			break

		waitthread MarvinWounded( marvin )

		if ( !IsAlive( marvin ) )
			break
	}

	if ( IsValid_ThisFrame( marvin ) )
		MarvinSetFace( marvin, "none" )
}

function MarvinWounded( marvin )
{
	marvin.EndSignal( "OnDeath" )
	MarvinSetFace( marvin, "sad" )
	wait 2.3
	waitthread MarvinThinksAwhile( marvin, RandomFloat( 2, 4 ) )
}

function EntSignals( ent, signal )
{
	if ( IsValid_ThisFrame( ent ) )
		ent.Signal( signal )
}

function MarvinThinksAwhile( marvin, time )
{
	marvin.EndSignal( "StopThinking" )
	delaythread( time ) EntSignals( marvin, "StopThinking" )

	// think for a bit
	for ( ;; )
	{
		MarvinSetFace( marvin, "think1" )
		wait 0.4
		MarvinSetFace( marvin, "think2" )
		wait 0.4
	}
}

function MarvinUndamagedFacePicker( marvin )
{
	marvin.EndSignal( "OnDeath" )
	marvin.EndSignal( "OnDamaged" )
	local i

	for ( ;; )
	{
		if ( !marvin.GetEnemy() )
		{
			MarvinSetFace( marvin, "happy" )
			marvin.WaitSignal( "OnFoundEnemy" )
		}

		waitthread MarvinThinksAwhile( marvin, RandomFloat( 2, 4 ) )

		if ( marvin.GetEnemy() )
		{
			MarvinSetFace( marvin, "angry" )
			marvin.WaitSignal( "OnLostEnemy" )
		}
	}
}

function MarvinSetFace( self, face )
{
//	printl( self + " got face " + face )
	Assert( MarvinFaceExists( self, face ), "No face " + face + " in level.marvinFace" )

	//prin( "Changing " + self + " face from " + level.marvinFaceNames[ skin ] + " to " + face )
	self.SetSkin( GetMarvinFace( self, face ) )
	self.Signal( "StopThinking" )
}

function MarvinFaceExists( npc_marvin, face )
{
	local marvinType = GetMarvinBodyType( npc_marvin )

	if ( marvinType in level.marvinFaces )
		return true

//	return ( face in level.marvinFaces[ marvinType ] )
}

function GetMarvinFace( npc_marvin, face )
{
	local marvinType = GetMarvinBodyType( npc_marvin )

	Assert( MarvinFaceExists( npc_marvin, face ), "No face " + face + " in level.marvinFace" )

	local faceID = level.marvinFaces[ marvinType ][ face ]

	return faceID
}

function SetMarvinBodyType( npc_marvin )
{
	if( "bodytype" in npc_marvin.s )
	{
		Assert( npc_marvin.s.bodytype >= MARVIN_TYPE_SHOOTER && npc_marvin.s.bodytype <= MARVIN_TYPE_FIREFIGHTER, "Specified invalid body type index " + npc_marvin.s.bodytype + " for info_spawnpoint_marvin " + spawnpoint + ", Use values from 0-2 instead." )

		switch( npc_marvin.s.bodytype )
		{
			case MARVIN_TYPE_FIREFIGHTER:
				local index = npc_marvin.FindBodyGroup( "firefighter" )
				local state = 1
				npc_marvin.SetBodygroup( index, state )
				break
		}
	}
}

function GetMarvinBodyType( npc_marvin )
{
	local bodyType = MARVIN_TYPE_WORKER

	if( "bodytype" in npc_marvin.s )
		bodyType = npc_marvin.s.bodytype

	return bodyType
}

function MarvinSpawnCallback( npc_marvin )
{
	SetMarvinBodyType( npc_marvin )
	npc_marvin.SetDeathNotifications( true ) //Primarily so we can do HandleDeathPackage for Marvins. Can just add a deathcallback if this is too expensive
}
