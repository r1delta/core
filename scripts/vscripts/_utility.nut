//=========================================================
//	_utility
//
//=========================================================


Print <- printl

function PrintPlaylists()
{
	printt( "=== PLAYLIST NAMES: ===" )

	local count = GetPlaylistCount()
	for ( local i = 0; i < count; i++ )
	{
		printt( "--", GetPlaylistName( i ) )
	}
}

if ( !( "CodeGetMapName" in getroottable() ) )
{
//	traceTimer <- {}
//	traceTimer.time <- -1
//	traceTimer.count <- 0

	// Just wrap the functions once, if this script is re-run.
	CodeGetMapName <- GetMapName
	function ScriptGetMapName()
	{
		local name = CodeGetMapName().tolower()
		if ( name == "wbase" )
			name = "worker_base"

		return name
	}
	GetMapName <- ScriptGetMapName


	CodeDebugDrawBox <- DebugDrawBox
	function ScriptDebugDrawBox( origin, min = Vector(-4,-4,-4), max = Vector(4,4,4), r = 255, g = 255, b = 100, alpha = 255, time = 0.2 )
	{
		CodeDebugDrawBox( origin, min, max, r, g, b, alpha, time )
	//	printl( "box at " + origin + " " + min + " " + max + " " + time )
	}
	DebugDrawBox <- ScriptDebugDrawBox

	CodeDispatchSpawn <- DispatchSpawn
	function ScriptDispatchSpawn( ent, loadScripts = false )
	{
		return CodeDispatchSpawn( ent, loadScripts )
	}
	DispatchSpawn <- ScriptDispatchSpawn


	__TraceLine <- TraceLine
	function TraceLine( start, end, ignoreEnt = null, solidMask = TRACE_MASK_NPCSOLID_BRUSHONLY, collisionMask = TRACE_COLLISION_GROUP_NONE )
	{
//		printt( "TraceLine" )
//		DumpStack()
		PerfStart( PerfIndexServer.TraceLine )
		local result = __TraceLine( start, end, ignoreEnt, solidMask, collisionMask )
		PerfEnd( PerfIndexServer.TraceLine )

		return result
//		return TraceLineWrapper( start, end, ignoreEnt, solidMask, collisionMask )
	}

/*
	__TraceHull <- TraceHull
	function TraceHull( startPos, endPos, hullMins, hullMaxs, ignoreEntity, mask, group )
	{
		printt( "TraceHull" )
		DumpStack()
		return __TraceHull( startPos, endPos, hullMins, hullMaxs, ignoreEntity, mask, group )
	}

	__TraceHullSimple <- TraceHullSimple
	function TraceHullSimple( Vector1, Vector2, Vector3, Vector4, handle )
	{
		printt( "TraceHullSimple" )
		DumpStack()
		return __TraceHullSimple( Vector1, Vector2, Vector3, Vector4, handle )
	}

	__TraceLineSimple <- TraceLineSimple
	function TraceLineSimple( Vector1, Vector2, handle )
	{
		printt( "TraceLineSimple" )
		DumpStack()
		return __TraceLineSimple( Vector1, Vector2, handle )
	}
	*/
}

/*
function TraceLineWrapper( start, end, ignoreEnt, solidMask, collisionMask )
{
	//result.fraction
	//result.endpos
	local time = Time().tointeger()
	if ( time > traceTimer.time )
	{
		traceTimer.time = time
		printt( "Traces: " + traceTimer.count )
		traceTimer.count = 0
	}
	//DebugDrawLine( start + Vector(0,0,1*traceTimer.count ), end, 255, 255, 255, true, 1 )
	//DebugDrawText( start + Vector(0,0,6*traceTimer.count ), traceTimer.count + "", false, 1 )
	traceTimer.count++
	return __TraceLine( start, end, ignoreEnt, solidMask, collisionMask )
}
*/

function IsSingleplayer()
{
	return !IsMultiplayer()
}

function CreateEntity( name )
{
//	if ( name == "npc_titan" )
//	{
//		DumpStack(3)
//	}
//	if ( name == "info_particle_system" )
//	{
//		printl( " " )
//		DumpStack(3)
//	}
	return Entities.CreateByClassname( name )
}

function AddOwnedEntity( owner, entity )
{
	Assert( owner )
	Assert( "ownedEntities" in owner.s, "No ownedEntities on " + owner + " .s" )
	owner.s.ownedEntities.append( entity )
}


function CreateOwnedEntity( name, target = null )
{
	if ( target == null )
		target = self

	local entity = CreateEntity( name )

	AddOwnedEntity( target, entity )
	return entity
}

// used from the console to quick-test fields
function setnpcfields( key, val )
{
	local npcs = GetNPCArrayByClass( "npc_soldier" )
	foreach ( npc in npcs )
	{
		npc.kv[ key ] = val
	}
}


function SpawnFromTemplate( template )
{
	//printt( "Spawning from " + template )
	if ( type( template ) == "string" )
	{
		template = GetEnt( template )
	}
	Assert( template, "You passed NULL to SpawnFromTemplate. That entity is GONE!" )
	Assert( template.GetName() != "", "Template has no name" )
	Assert( HasUniqueName( template ), "Multiple point templates with the same name " + template.GetName() )

	local ents = Entities.CreateByPointTemplates( template.GetName() )
	//printt( "Spawned " + ents.len() + " ents" )

	return ents
}

function WaitAllDead( guys )
{
	if ( !guys.len() )
		return

	// Spawn an entity that can give us a local space to wait/signal
	local ent = CreateScriptRef()

	// track how many AI are left
	ent.s.count <- 0

	OnThreadEnd(
		// this is in case the calling thread ends.
		function() : ( ent )
		{
			if ( IsValid_ThisFrame( ent ) )
				ent.Kill()
		}
	)

	// this internal function keeps track of each guy
	// when the last guy dies, kill the local entity.
	local func =
		function( guy, ent )
		{
			ent.EndSignal( "OnDestroy" )

			ent.s.count++
			guy.WaitSignal( "OnDeath" )
			ent.s.count--

			if ( !ent.s.count )
			{
				// if all the AI are dead, we're done
				ent.Kill()
			}
		}

	foreach ( guy in guys )
	{
		if ( !IsAlive( guy ) )
			continue

		thread func( guy, ent )
	}

	ent.WaitSignal( "OnDestroy" )
}

function WaitAnySignalOnAllEnts( guys, signalArray )
{
	if ( !guys.len() )
		return

	local singalTable = { count = 0 }

	// this internal function keeps track of each guy
	// when the last guy gets a valid signal the function will return
	local func =
		function( guy, signalArray, singalTable )
		{
			OnThreadEnd(
				function() : ( singalTable )
				{
					singalTable.count--
					if ( singalTable.count <= 0 )
						Signal( singalTable, "waitOver" )
				}
			)

			singalTable.count++

			guy.EndSignal( "OnDestroy" )
			foreach( signal in signalArray )
				guy.EndSignal( signal )

			WaitForever()

		}

	foreach ( guy in guys )
	{
		if ( !IsAlive( guy ) )
			continue

		thread func( guy, signalArray, singalTable )
	}

	WaitSignal( singalTable, "waitOver" )
}


function SetRebreatherMaskVisible( ent, setVisible )
{
	local modelname = ent.GetModelName()

	local maskIdx = ent.FindBodyGroup( "mask" )
	if ( maskIdx == -1 )
		return

	local visibleIdx = 1
	if ( !setVisible )
		visibleIdx = 0

	ent.SetBodygroup( maskIdx, visibleIdx )
}

function EntHasSpawnflag( ent, spawnflagHexVal )
{
	return ( ent.kv.spawnflags.tointeger() & spawnflagHexVal )
}


function FollowAssaultChain( guy, targTN, tolerance = 32, cancelSignal = null )
{
	Assert( targTN != null && targTN != "", "No assault target specified for " + guy )

	OnThreadEnd(
		function () : ( guy )
		{
			if ( IsValid_ThisFrame( guy ) )
				guy.DisableBehavior( "Assault" )
		}
	)

	if ( cancelSignal != null )
	{
		level.ent.EndSignal( cancelSignal )
		guy.EndSignal( cancelSignal )
	}

	local assaultTarg = null

	while( targTN != null )
	{
		local runToTarget = true

		if ( targTN != "" )
		{
			assaultTarg = GetEnt( targTN )
			Assert( assaultTarg != null, "Couldn't find a target entity with targetname " + targTN )
		}
		else
			break

		//printl( guy + " assaulting " + assaultTarg )
		guy.AssaultPoint( GroundPos( assaultTarg ), tolerance )
		WaitSignal( guy, "OnFinishedAssault" )

		targTN = assaultTarg.GetTarget()
	}
}


function CreateScriptMover( owner = null, origin = null, angles = null )
{
	if ( owner == null)
	{
		local script_mover = CreateEntity( "script_mover" )
		script_mover.kv.solid = 0
		script_mover.kv.model = "models/dev/empty_model.mdl"
		script_mover.kv.SpawnAsPhysicsMover = 0
		if ( origin )
			script_mover.SetOrigin( origin)
		if ( angles )
			script_mover.SetAngles( angles )

		DispatchSpawn( script_mover )
		return script_mover
	}

	// Used by function CBaseEntity::ParentToMover()
	local script_mover = CreateEntity( "script_mover" )
	script_mover.kv.solid = 0
	script_mover.kv.model = "models/dev/empty_model.mdl"
	script_mover.kv.SpawnAsPhysicsMover = 0
	script_mover.SetOrigin( owner.GetOrigin() )
	script_mover.SetAngles( owner.GetAngles() )
	DispatchSpawn( script_mover )
	script_mover.Hide()

	script_mover.SetOwner( owner )
	return script_mover
}


EntTracker <- 0

// useful for finding out what ents are in a level. Should only be used for debugging.
function TotalEnts( hidden = false )
{
	local entities = []

	local reps = 0
	EntTracker++

	local entity = Entities.FindInSphere( null, Vector( 0,0,0 ), 90000 )
	local name
	for ( ;; )
	{
		if ( entity == null )
			break

		entities.append( entity )

		name = entity.GetName()
		if ( !( "storedID" in entity.s ) )
		{
			entity.s.storedID <- EntTracker
			if ( !hidden )
			{
				if ( name == "" )
				printl( "* New ent (" + entity.s.storedID + "): " + entity )
				else
					printl( "*New ent (" + entity.s.storedID + "): " + entity + " \"" + entity.GetName() + "\"" )
			}
		}
		else
		{
			if ( !hidden )
			{
				if ( name == "" )
				printl( "Old ent (" + entity.s.storedID + "): " + entity )
				else
					printl( "Old ent (" + entity.s.storedID + "): " + entity + " \"" + entity.GetName() + "\"" )
			}
		}

		entity = Entities.FindInSphere( entity, Vector( 0,0,0 ), 90000 )
	}

	if ( !hidden )
		printl( "Total entities " + entities.len() )
	return entities.len()
}

te <- TotalEnts

/*
CodePrintl <- printl
function ScriptPrintl( msg )
{
	for ( local i = 1; i < 20; i++ )
	{
		if ( !( "src" in getstackinfos(i) ) )
			break
		print( i + " File : " + getstackinfos(i)["src"] + " [" + getstackinfos(i)["line"] + "]\n    Function : " + getstackinfos(i)["func"] + "()\n " )
	}

	CodePrxintl( msg )
}
printl <- ScriptPrintl
*/

function RandomIntRange( min, max )
{
	return CodeRandomInt( min, max - 1 )
}



function AssertThreadTop( msg = "Is not thread top!" )
{
	Assert( getstackinfos(3) == null, msg )
}

function ThisFunc()
{
	return getstackinfos(2)[ "func" ]
}

if ( !IsMultiplayer() )
{
	function GetEntArray( name )
	{
		print( "WARNING: GetEntArray is depricated. Use appropriate code version" )

		Assert( type( name ) == "string" )
		Assert( name != "player", "Use GetPlayerArray" )

		local entities = []

		local entity = Entities.FindByName( null, name )
		for ( ;; )
		{
			if ( entity == null )
				break

			entities.append( entity )

			entity = Entities.FindByName( entity, name )
		}

		entity = Entities.FindByClassname( null, name )
		for ( ;; )
		{
			if ( entity == null )
				break

			entities.append( entity )

			entity = Entities.FindByClassname( entity, name )
		}

		return entities
	}

	function GetEntArrayByClassname( classname )
	{
		print( "WARNING: GetEntArrayByClassname is depricated. Use appropriate code version" )
		Assert( type( classname ) == "string" )

		// Wrapping calls for players until old usage is updated to GetPlayerArray()
		if ( classname == "player" )
			return GetPlayerArray()

		local entities = []

		local entity = Entities.FindByClassname( null, classname )
		for ( ;; )
		{
			if ( entity == null )
				break

			entities.append( entity )

			entity = Entities.FindByClassname( entity, classname )
		}
		return entities
	}


	function GetEntArrayWithin( name, origin, distance )
	{
		print( "WARNING: GetEntArrayWithin is depricated. Use appropriate code version" )
		assert( type( name ) == "string" )

		local entities = []

		local entity = Entities.FindByNameWithin( null, name, origin, distance )
		for ( ;; )
		{
			if ( entity == null )
				break

			entities.append( entity )

			entity = Entities.FindByNameWithin( entity, name, origin, distance )
		}

		entity = Entities.FindByClassnameWithin( null, name, origin, distance )
		for ( ;; )
		{
			if ( entity == null )
				break

			entities.append( entity )

			entity = Entities.FindByClassnameWithin( entity, name, origin, distance )
		}

		return entities
	}
}


function GetEntByIndex( index )
{
	// should only be used from console
	Assert( index != null, "No index!" )
	Assert( index >= 0, "Index must be greater than or equal to 0" )
	local entity = Entities.First()

	while ( entity )
	{
		if ( entity.entindex() == index )
			return entity
		entity = Entities.Next( entity )
	}

	return null
}

function GetEnt( name )
{
	Assert( type( name ) == "string", "GetEnt: Ent name " + name + " is not a string" )

	local entity = Entities.FindByName( null, name )
	if ( entity == null )
	{
		entity = Entities.FindByClassname( null, name )
		Assert( Entities.FindByClassname( entity, name ) == null, "Tried to GetEnt but there were multiple entities with that name" )
	}
	else
	{
		Assert( Entities.FindByName( entity, name ) == null, "Tried to GetEnt but there were multiple entities with name " + name )
	}

	return entity
}


function AddToNameList( ent, name )
{
	if ( !( name in level._nameList ) )
	{
		level._nameList[ name ] <- []
	}

	level._nameList[ name ].append( ent )
}


function IsValueInArray( table, value )
{
	foreach( item in table )
	{
		if ( item == value )
			return true
	}
	return false
}

function IsEntInScriptManagedEntArray( managedArrayId, compareEnt )
{
	local entArray = GetScriptManagedEntArray( managedArrayId )
	foreach( ent in entArray )
	{
		if ( ent == compareEnt )
			return true
	}

	return false
}


function FlattenVector( vector )
{
	Assert( typeof vector == "Vector" )

	local vector2D = Vector( vector.x, vector.y, 0 )
	vector2D.Norm()
	return vector2D
}

function FlattenAngles( angles )
{
	Assert( typeof angles == "Vector" )

	return Vector( 0,angles.y,0 )
}


function ArrayCopy( arr )
{
	Assert( type( arr ) == "array" )

	return clone arr
}
RegisterFunctionDesc( "ArrayCopy", "Just use clone." )

function ArrayAppend( array1, array2 )
{
	array1.extend( array2 )
}
ArrayCombine <- ArrayAppend
RegisterFunctionDesc( "ArrayCopy", "Just use .extend." )
RegisterFunctionDesc( "ArrayCombine", "Just use .extend." )

function ArrayWithinCenter( ents, start, range )
{
	local array = []
	for ( local i = 0; i < ents.len(); i++ )
	{
		if ( Distance( start, ents[i].GetWorldSpaceCenter() ) > range )
			continue

		array.append( ents[i] )
	}

	return array
}

function GetCenter( ents )
{
	Assert( type( ents ) == "array" || type( ents ) == "table" )

	local total = Vector()

	foreach ( ent in ents )
	{
		total += ent.GetOrigin()
	}

	total.x /= ents.len()
	total.y /= ents.len()
	total.z /= ents.len()

	return total
}

function TableRemoveInvalid( table )
{
	Assert( type( table ) == "table" )

	local deleteKey = []

	foreach ( key, value in table )
	{
		if ( !IsValid_ThisFrame( key ) )
			deleteKey.append( key )

		if ( !IsValid_ThisFrame( value ) )
			deleteKey.append( key )
	}

	foreach ( key in deleteKey )
	{
		// in this search, two things could end up on the same key
		if ( key in table )
			delete table[ key ]
	}
}

function TableRemoveInvalidByValue( table )
{
	Assert( type( table ) == "table" )

	local deleteKey = []

	foreach ( key, value in table )
	{
		if ( !IsValid_ThisFrame( value ) )
			deleteKey.append( key )
	}

	foreach ( key in deleteKey )
	{
		delete table[ key ]
	}
}

function TableRemoveDeadByKey( table )
{
	Assert( type( table ) == "table" )

	local deleteKey = []

	foreach ( key, value in table )
	{
		if ( !IsAlive( key ) )
			deleteKey.append( key )
	}

	foreach ( key in deleteKey )
	{
		delete table[ key ]
	}
}

function TableRemoveDeadByValue( table )
{
	Assert( type( table ) == "table" )

	local deleteKey = []

	foreach ( key, value in table )
	{
		if ( !IsAlive( value ) )
			deleteKey.append( key )
	}

	foreach ( key in deleteKey )
	{
		delete table[ key ]
	}
}


function ArrayDump( array )
{
	for ( local i = 0; i < array.len(); i++ )
	{
		printl( "index " + i + " is: " + array[i] )
	}
}


function DotCompareLargest( a, b )
{
	if ( a.dot < b.dot )
		return 1
	else if ( a.dot > b.dot )
		return -1

	return 0
}


function DotCompareSmallest( a, b )
{
	if ( a.dot > b.dot )
		return 1
	else if ( a.dot < b.dot )
		return -1

	return 0
}

function ArrayDotResults( array, entity )
{
	Assert( type( array ) == "array" )
	local allResults = []

	foreach ( ent in array )
	{
		local results = {}

		// returns vectordot from viewEnt to targetEnt
		//VectorDot_EntToEnt( viewEnt, targetEnt )

		results.dot <- VectorDot_EntToEnt( entity, ent )
		results.ent <- ent
		allResults.append( results )
	}

	return allResults
}


// Return an array of entities ordered from closest to furthest from the facing of the entity
function ArrayClosestToView( array, entity )
{
	Assert( type( array ) == "array" )
	local allResults = ArrayDotResults( array, entity )

	allResults.sort( DotCompareLargest )

	local returnEntities = []

	foreach ( index, result in allResults )
	{
		//printl( "Results are " + result.dot )
		returnEntities.insert( index, result.ent )
	}

	// the actual distances aren't returned
	return returnEntities
}


function SpawnRefEnt( ent )
{
	printl( "Ent model " + ent.kv.model )
	local attach = ent.LookupAttachment( "ref" )
	local origin = ent.GetAttachmentOrigin( attach )
	local angles = ent.GetAttachmentAngles( attach )

	local ref = CreateEntity( "prop_dynamic" )
	//ref.kv.SpawnAsPhysicsMover = 0
	ref.kv.model = "models/dev/empty_model.mdl"
	DispatchSpawn( ref )

	ref.SetOrigin( origin )
	ref.SetAngles( angles )
	ref.Hide()
	return ref
}

function CreateScriptRef( origin = null, angles = null )
{
	local ent = CreateEntity( "script_ref" )
	DispatchSpawn( ent )

	if ( origin )
		ent.SetOrigin( origin )
	if ( angles )
		ent.SetAngles( angles )

	return ent
}

function CreateScriptRefMinimap( origin, angles )
{
	local ent = CreateEntity( "script_ref_minimap" )
	DispatchSpawn( ent )

	ent.SetOrigin( origin )
	ent.SetAngles( angles )

	ent.kv.spawnflags = 3

	return ent
}

function exists( tbl, val )
{
	Assert( type( val ) == "string", "Type " + val + " is not a string" )
	Assert( type( tbl ) == "table", "Type " + tbl + " is not a table" )

	if ( !(val in tbl) )
		return false

	return tbl[ val ] != null
}



function KillMyScriptedSequences()
{
	// delete scripted sequence entities that are controlling me
	local name = self.GetName()
	local sequences = GetEntArrayByClass_Expensive( "scripted_sequence" )
	foreach ( ent in sequences )
	{
		if ( ent.kv.m_iszEntity == name )
		{
			EntFireByHandle( ent, "CancelSequence", "", 0, null, null )
			ent.Kill()
		}
	}
}

function ScriptedSequenceEnd()
{
	// clean up the scripted sequence, but give it time to wrap stuff up
	caller.Kill( 0.05 )
	//printl( "killing sequence in 0.25, time " + Time() )
}

function VectorToAngles( vec )
{
	local yaw = atan2( vec.y, vec.x ) * 180 / PI

	local len2d = vec.Length2D();
	local pitch = atan2( vec.z, len2d ) * -180 / PI

	return Vector( pitch, yaw, 0.0 )
}

function HasUniqueName( self )
{
	local name = self.GetName()
	if ( name == "" )
		return false

	if ( !( name in level._nameList ) )
		return true

	return level._nameList[ name ].len() == 1
}

// return all living soldiers
function GetAllSoldiers()
{
	return GetNPCArrayByClass( "npc_soldier" )
}
RegisterFunctionDesc( "GetAllSoldiers", "Get all living soldiers." )

function IsMyClassnameOrTargetname( npcName )
{
	if ( self.GetClassname() == npcName )
	{
		return true
	}

	if ( self.GetName().find( npcName ) != null )
	{
		return true
	}

	return false
}

// called internally by other _utility functions
function GetAI_mover( origin, endfunc )
{
	//local scripted_sequence = CreateEntity( "scripted_sequence" )
	//scripted_sequence.kv.m_fMoveTo = 1
	//scripted_sequence.SetOrigin( origin )
	//DispatchSpawn( scripted_sequence, false )
	//scripted_sequence.kv.m_iszPlay = "blahblah"

	local scripted_sequence = CreateEntity( "scripted_sequence" )
	scripted_sequence.SetName( "Scripted_sequence" + UniqueString() )
	scripted_sequence.SetOrigin( origin )
	scripted_sequence.kv.m_iszEntity = self.GetName()
	//scripted_sequence.kv.m_iszPlay = "mv_idle_weld"
	//scripted_sequence.kv.m_bLoopActionSequence = 1
	//scripted_sequence.kv.model = "models/robots/marvin/marvin.mdl"
	scripted_sequence.kv.spawnflags = 4176 // start on spawn, override ai, allow death

	scripted_sequence.AddOutput( "OnEndSequence", scripted_sequence, "kill" )


	local org1 = self.GetOrigin() + Vector(0,0,32)
	local org2 = origin + Vector(0,0,32)
	DebugDrawLine( org1, org2, 100, 100, 100, true, 5 )
	DebugDrawBox( org1, Vector(-8,-8,-8), Vector(8,8,8), 255, 255, 0, 1, 6 )
	DebugDrawBox( org2, Vector(-8,-8,-8), Vector(8,8,8), 255, 255, 0, 1, 6 )

	if ( endfunc != null )
	{
		// is there a function to run after getting there?
		scripted_sequence.ConnectOutputTarget( "OnEndSequence", endfunc, self )
	}

	return scripted_sequence
}



// walk to a spot, with an optional function
function ai_WalkTo( origin, endfunc = null )
{
	local scripted_sequence = GetAI_mover( origin, endfunc )
	scripted_sequence.kv.m_fMoveTo = 1
	DispatchSpawn( scripted_sequence, false )
}

// run to a spot, with an optional function
function ai_RunTo( origin, endfunc = null )
{
	local scripted_sequence = GetAI_mover( origin, endfunc )
	scripted_sequence.kv.m_fMoveTo = 2
	DispatchSpawn( scripted_sequence, false )
}



function create_AiScriptedSchedule( guy )
{
	if ( exists( guy.s, "goalEnt" ) )
	{
		return
	}

	// spawn the goal ent if it doesn't already exist
	local goalEnt = CreateEntity( "aiscripted_schedule" )
	goalEnt.constructor()

	local guyname = guy.GetName()
	goalEnt.__KeyValueFromString( "m_iszEntity", guyname ) // the name of the AI this goalent controls

	DispatchSpawn( goalEnt, false )

	guy.s.goalEnt <- goalEnt.weakref()
}

function ai_GoToEnt( guy, ent, moveTime, not_commandable )
{
	Assert( guy != null, "Did not pass an AI" )
	Assert( ent != null, "Did not pass an ent" )
	Assert( moveTime != null, "Did not pass a movetime" )

	// make sure the AI has an entity to control his goal
	create_AiScriptedSchedule( guy )

	Assert( exists( guy.s, "goalEnt" ) )

	// set some settings on it
//	guy.s.goalEnt.__KeyValueFromInt( "schedule", 5 ) // Run Goal Path
//	guy.s.goalEnt.__KeyValueFromInt( "spawnflags", 4 ) // repeatable
//	guy.s.goalEnt.__KeyValueFromInt( "interruptability", 0 )	 // general interuptability

	guy.s.goalEnt.__KeyValueFromInt( "forcestate", 3 ) // Run Goal Path
	guy.s.goalEnt.__KeyValueFromInt( "schedule", 5 ) // Run Goal Path
	guy.s.goalEnt.__KeyValueFromInt( "spawnflags", 4 ) // repeatable
	guy.s.goalEnt.__KeyValueFromInt( "interruptability", 2 )	 // general interuptability

	local origin = ent.GetOrigin()
	DebugDrawBox( origin, Vector(-8,-8,-8), Vector(8,8,8), 255, 255, 0, 1, 6 )

	//	DebugDrawText( origin, "" + num, false, 6 )
	//	DebugDrawText( friendly.GetOrigin(), "" + num, false, 6 )

	// set the entity to be the goal of this AI's goalent
	guy.s.goalEnt.__KeyValueFromString( "goalent", ent.GetName() )

	// so he stops following me and goes to the nodes
	// this probably should be done by adding/setting the flag properly
	// this is to set NOT_COMMANDABLE on a citizen
	if ( not_commandable )
		guy.__KeyValueFromInt( "spawnflags", 5242884 )

	// make the AI stop being a member of the player squad, if he is
	EntFireByHandle( guy, "SetSquad", "", moveTime, null, null )

	// start the schedule
	EntFireByHandle( guy.s.goalEnt, "StartSchedule", "", moveTime, null, null )

	// delete the entity
	//EntFireByHandle( guy.s.goalEnt, "Kill", "", moveTime, null, null )
	//guy.s.goalEnt.Destroy()
	guy.s.goalEnt = null

}


function ArrayGetRandomElement( arr )
{
	return Random( arr )
}

function TableRandomIndex( table )
{
	Assert( type( table ) == "table", "Not a table" )

	local array = []

	foreach ( index, _ in table )
	{
		array.append( index )
	}

	return Random( array )
}


function BranchSet( branch )
{
	local ent = GetEnt( branch )
	Assert( ent != null, "Couldn't find logic_branch with name " + branch )
	Assert( ent.GetClassname() == "logic_branch", "Expected logic_branch but found " + ent.GetClassname() )

	BranchSetOnEnt( ent )
//	Assert( Branch( branch ), "Branch did not set" )
}

// This is called on an actual logic_branch entity.
function BranchSetOnEnt( ent )
{
//	printl( "Setting branch " + ent.GetName() )

	EntFireByHandle( ent, "SetValueTest", "1", 0, null, null )
	ent.Set( "InitialValue", "1" )
}

// Creates this branch if it doesn't exist already
function BranchCreate( branch )
{
	local ent = GetEnt( branch )
	if ( ent != null )
	{
		Assert( ent.GetClassname() == "logic_branch", "Expected logic_branch but found " + ent.GetClassname() )
		return
	}

	local logic_branch = CreateEntity( "logic_branch" )
	logic_branch.SetName( branch )
	DispatchSpawn( logic_branch, false )
	logic_branch.s.scripted <- true
}

function BranchClear( branch )
{
	local ent = GetEnt( branch )
	Assert( ent != null, "Couldn't find logic_branch with name " + branch )
	Assert( ent.GetClassname() == "logic_branch", "Expected logic_branch but found " + ent.GetClassname() )

	EntFireByHandle( ent, "SetValueTest", "0", 0, null, null )
	ent.Set( "InitialValue", "0" )
//	Assert( !Branch( branch ), "Branch did not clear" )
}


// should improve this
function YawDifference( yaw1, yaw2 )
{
	Assert( yaw1 >= 0 )
	Assert( yaw1 <= 360 )
	Assert( yaw2 >= 0 )
	Assert( yaw2 <= 360 )

	local diff = abs( yaw1 - yaw2 )

	if ( diff > 180 )
	    return 360 - diff
	else
	    return diff
}



function TrackIsTouching( ent )
{
	return // now uses IsTouching

	//ent.s.touching <- {}
	//ent.ConnectOutput( "OnStartTouch", TrackIsTouching_OnStartTouch )
	//ent.ConnectOutput( "OnEndTouch", TrackIsTouching_OnEndTouch )
}

function TrackIsTouching_OnStartTouch( self, activator, caller, value )
{
	if ( activator )
	{
		self.s.touching[ activator ] <- true
	}
}

function TrackIsTouching_OnEndTouch( self, activator, caller, value )
{
	if ( activator )
	{
		if ( activator in self.s.touching )
		{
			delete self.s.touching[ activator ]
		}
	}
}

function Branch( branch )
{
	local ent = GetEnt( branch )
	Assert( ent != null, "Couldn't find logic_branch with name " + branch )
	Assert( ent.GetClassname() == "logic_branch", "Expected logic_branch but found " + ent.GetClassname() )

	local branch_value = ent.Get( "InitialValue" ) == "1"
	return branch_value // initial also means current, apparently
}

function NPC_NoTarget( self )
{
	self.SetNoTarget( true )
	self.SetNoTargetSmartAmmo( true )
}

function GetTraceEnd( start, end, frac )
{
	local vec = end - start
	vec *= frac
	return start + vec
}


function FillEntitySpawnPositions( origin, angles, classname, origins, forwardVecs, ignoreEnt = null )
{
	// origins and forwardVecs gets filled with the results


	Assert( classname in level.traceMins, "Must add classname " + classname + " to OnPostSpawn() FindMinsMaxs" )

	local spawnOrigin = origin + Vector( 0, 0, TRACE_HEIGHT_OFFSET )
	local spawnAngles = Vector( 0, angles.y, 0 )
	local spawnForward = spawnAngles.AnglesToForward()
	local spawnRight = spawnAngles.AnglesToRight()

	local marvinTraceVecs = [
		((spawnForward * TRACE_DIST_OFFSET) + (spawnRight * TRACE_DIST_OFFSET)),
		((spawnForward * -TRACE_DIST_OFFSET) + (spawnRight * TRACE_DIST_OFFSET)),
		((spawnForward * TRACE_DIST_OFFSET) + (spawnRight * -TRACE_DIST_OFFSET)),
		((spawnForward * -TRACE_DIST_OFFSET) + (spawnRight * -TRACE_DIST_OFFSET))
	]

	foreach ( index, traceVec in  marvinTraceVecs )
	{
		traceVec.Normalize()

		local marvinOrg = spawnOrigin + traceVec * TRACE_LENGTH
		local distFromSpawnOrigin = (TRACE_LENGTH * TraceHullSimple( spawnOrigin, marvinOrg, level.traceMins[ classname ], level.traceMaxs[ classname ], ignoreEnt ))

		if ( distFromSpawnOrigin < TRACE_MIN_LENGTH )
			continue

		marvinOrg = spawnOrigin + (traceVec * distFromSpawnOrigin)

		marvinOrg.z -= (TRACE_HEIGHT_OFFSET * TraceHullSimple( marvinOrg, marvinOrg - Vector(0,0,TRACE_HEIGHT_OFFSET), level.traceMins[ classname ], level.traceMaxs[ classname ], ignoreEnt ))
		origins.append( marvinOrg )
		forwardVecs.append( traceVec )
	}
}

function DrawTag( ent, tag )
{
	if ( IsAlive( ent ) )
		ent.EndSignal( "OnDeath" )
	else
		ent.EndSignal( "OnDestroy" )

	local scale = 10

	for ( ;; )
	{
		local attachIndex = ent.LookupAttachment( tag )
		local origin = ent.GetAttachmentOrigin( attachIndex )
		local angles = ent.GetAttachmentAngles( attachIndex )

		local forward = angles.AnglesToForward()
		local up = angles.AnglesToUp()
		local right = angles.AnglesToRight()


		DebugDrawLine( origin, origin + forward * scale, 	255, 0, 0, true, 0.1 )
		DebugDrawLine( origin, origin + right * scale, 		0, 255, 0, true, 0.1 )
		DebugDrawLine( origin, origin + up * scale, 		0, 0, 255, true, 0.1 )
		DebugDrawText( origin, tag, true, 0.1 )
		wait 0
	}
}

function DrawOrg( ent )
{
	if ( IsAlive( ent ) )
		ent.EndSignal( "OnDeath" )
	else
		ent.EndSignal( "OnDestroy" )

	local scale = 1000

	for ( ;; )
	{
		if ( !IsValid( ent ) )
			return

		local origin = ent.GetOrigin()
		local angles = ent.GetAngles()
		local forward = angles.AnglesToForward()
		local up = angles.AnglesToUp()
		local right = angles.AnglesToRight()


		DebugDrawLine( origin, origin + forward * scale, 	255, 0, 0, true, 0.1 )
		DebugDrawLine( origin, origin + right * scale, 		0, 255, 0, true, 0.1 )
		DebugDrawLine( origin, origin + up * scale, 		0, 0, 255, true, 0.1 )
		DebugDrawText( origin, "origin", true, 0.1 )
		wait 0
	}
}



function DrawAttachment( pod, attachment, time = 0.1, color = null )
{
	local attachIndex = pod.LookupAttachment( attachment )
	local origin = pod.GetAttachmentOrigin( attachIndex )
	local angles = pod.GetAttachmentAngles( attachIndex )

	local forward = angles.AnglesToForward()
	local up = angles.AnglesToUp()
	local right = angles.AnglesToRight() * -1

	local scale = 10

	if ( color == null )
	{
		DebugDrawLine( origin, origin + forward * scale, 	255, 0, 0, true, time )
		DebugDrawLine( origin, origin + right * scale, 		0, 255, 0, true, time )
		DebugDrawLine( origin, origin + up * scale, 		0, 0, 255, true, time )
	}
	else
	{
		DebugDrawLine( origin, origin + forward * scale, 	color[0], color[1], color[2], true, time )
		DebugDrawLine( origin, origin + right * scale, 		color[0], color[1], color[2], true, time )
		DebugDrawLine( origin, origin + up * scale, 		color[0], color[1], color[2], true, time )
	}
}

function DrawAttachmentForever( pod, attachment )
{
	pod.EndSignal( "OnDestroy" )
	for ( ;; )
	{
		DrawAttachment( pod, attachment )
		wait 0
	}
}

function DrawEntityOrigin( ent, time = 0.1, color = null )
{
	local origin = ent.GetOrigin()
	local angles = ent.GetAngles()
	local forward = angles.AnglesToForward()
	local right = angles.AnglesToRight()
	local up = angles.AnglesToUp()

	local scale = 10

	if ( color == null )
	{
		DebugDrawLine( origin, origin + forward * scale, 	0, 255, 0, true, time )
		DebugDrawLine( origin, origin + up * scale, 		255, 0, 0, true, time )
		DebugDrawLine( origin, origin + right * scale, 		0, 0, 255, true, time )
	}
	else
	{
		DebugDrawLine( origin, origin + forward * scale, 	color[0], color[1], color[2], true, time )
		DebugDrawLine( origin, origin + up * scale, 		color[0], color[1], color[2], true, time )
		DebugDrawLine( origin, origin + right * scale, 		color[0], color[1], color[2], true, time )
	}
}

function DrawOrigin( origin, time = 0.1, color = null )
{

	local forward = Vector( 1, 0, 0 )
	local right = Vector( 0, 1, 0 )
	local up = Vector( 0, 0, 1 )

	local scale = 10

	if ( color == null )
	{
		DebugDrawLine( origin, origin + forward * scale, 	0, 255, 0, true, time )
		DebugDrawLine( origin, origin + up * scale, 		255, 0, 0, true, time )
		DebugDrawLine( origin, origin + right * scale, 		0, 0, 255, true, time )
	}
	else
	{
		DebugDrawLine( origin, origin + forward * scale, 	color[0], color[1], color[2], true, time )
		DebugDrawLine( origin, origin + up * scale, 		color[0], color[1], color[2], true, time )
		DebugDrawLine( origin, origin + right * scale, 		color[0], color[1], color[2], true, time )
	}
}

function BranchExists( branch )
{
	local ent = GetEnt( branch )
	if ( ent == null )
		return false

	Assert( ent.GetClassname() == "logic_branch", "Expected logic_branch but found " + ent.GetClassname() )
	return true
}


function ForceDeath()
{
	EntFireByHandle( self, "sethealth", "0", 0, null, null )
	self.BecomeRagdoll( Vector( 0, 0, 0 ) )
}


function _RunThink( thinkGuid )
{
	if ( activator.thinkGuid != thinkGuid )
		return

	activator.thinkFunc.call( activator.GetScriptScope() )
}

// Functions are currently defined in _threads so that they exist for usage during RegisterClass
RegisterFunctionDesc( "RegisterFunctionDesc", "Adds this function to the \"script_help\" function list.  Return type is optional (defaults to void)" )
RegisterFunctionDesc( "RegisterClassFunctionDesc", "Adds this class func to the \"script_help\" func list.  Return type is optional (defaults to void)" )


function LoadedMain()
{
	if ( "LoadedMain" in level )
		return true

	level.LoadedMain <- true

	return false
}

function Warning( msg )
{
	printl( "*** WARNING ***" )
	printl( msg )
	DumpStack()
	printl( "*** WARNING ***" )
}

function GiveWeapon( weapon, autoSwitch = false )
{
	local player = GetLocalViewPlayer()
	if ( IsValid_ThisFrame( player ) )
	{
		player.GiveWeapon( weapon )
		if ( autoSwitch )
			player.SetActiveWeapon( weapon )
	}
}



function FoundEntInStack( ent, infos )
{
	foreach ( loc in infos.locals )
	{
		if ( loc == ent )
		{
			return true
		}
	}

	return false
}

function TimeOut( time )
{
	local table = {}
	EndSignal( table, "OnDeath" )
	delaythread( time ) Signal( table, "OnDeath" )
}

// thread debugger, finds an ent in one of the locals of a thread. work in progress
function ThreadHunt( ent )
{
	local threadsList = threads.GetThreads()
	foreach ( threadId, threadObj in threadsList )
	{
		local infos
		local level = 0
		local foundEnt = false
		for ( ;; )
		{
			infos = threadObj.getstackinfos( level )
			if ( !infos )
				break

			if ( FoundEntInStack( ent, infos ) )
			{
				foundEnt = true
				break
			}

			level++
		}

		if ( foundEnt )
		{
			printl( "Found in " + threadId )
			level = 0

			for ( ;; )
			{
				infos = threadObj.getstackinfos( level )
				if ( !infos )
					break

				if ( FoundEntInStack( ent, infos ) )
				{
					printl(  infos.func + ":" + infos.line + "	 (" + infos.src + ")" )
				}

				level++
			}


			printl( "" )
		}
	}
	/*
	return

	local done = {}
	local doc = getroottable().threads.g_statsThreadList

	local cap = 3000
	local total = 0
	for ( ;; )
	{
		cap--
		if ( !cap )
			return

		if ( !doc )
			return

		if ( !( doc.co in done ) )
		{
			total++
			printt( total, doc.co )

			foreach ( stack in doc.debug_stack )
			{
				foreach ( loc in stack.locals )
				{
					if ( loc == ent )
					{
						printt( "Found " + ent + " in " + doc.debug_desc )
					}
				}
			}

			done[ doc.co ] <- doc.debug_desc
		}
		else
		{
			printt( "DUPE ", doc.co )
		}

		doc = doc.debug_next
	}
	*/
}



function SwitchToWeapon( weapon )
{
	local player = GetLocalViewPlayer()
	if ( IsValid_ThisFrame( player ) )
	{
		player.SetActiveWeapon( weapon )
	}
}

function GetActiveWeaponClass( player )
{
	local weaponclass = null
	local weapon = player.GetActiveWeapon()

	if ( weapon != null )
	{
		weaponclass = weapon.GetClassname()
	}

	return weaponclass
}

function GetFraction( value, min, max )
{
	return ( value - min ) / ( max - min )
}

function GetFractionClamped( value, min, max )
{
	local frac = GetFraction( value, min, max )
	return clamp( frac, 0.0, 1.0 )
}

function GetValueFromFraction( value, value_min, value_max, return_min, return_max )
{
	local frac = GetFractionClamped( value.tofloat(), value_min.tofloat(), value_max.tofloat() )
	local retVal = return_min.tofloat() + ( ( return_max.tofloat() - return_min.tofloat() ) * frac )
	return clamp( retVal, return_min, return_max )
}

function VectorCompare( vec1, vec2 )
{
	if ( vec1.x != vec2.x )
		return false
	if ( vec1.y != vec2.y )
		return false
	return vec1.z == vec2.z
}

// returns vectordot from viewEnt to targetEnt
function VectorDot_EntToEnt( viewEnt, targetEnt )
{
	local maxs = targetEnt.GetBoundingMaxs()
	local mins = targetEnt.GetBoundingMins()
	maxs += mins
	maxs.x *= 0.5
	maxs.y *= 0.5
	maxs.z *= 0.5
	local targetOrg = targetEnt.GetOrigin() + maxs

	local maxs = viewEnt.GetBoundingMaxs()
	local mins = viewEnt.GetBoundingMins()
	maxs += mins
	maxs.x *= 0.5
	maxs.y *= 0.5
	maxs.z *= 0.5
	local viewOrg = viewEnt.GetOrigin() + maxs


//	DebugDrawLine( targetOrg, viewOrg, 255, 255, 255, true, 0.5 )
	local vecToEnt = ( targetOrg - viewOrg )
	vecToEnt.Norm()

	local dotVal = vecToEnt.Dot( viewEnt.GetForwardVector() )
	return dotVal
}


function InsideBoundingbox( attacker, entity )
{
	// returns true if the attacker is aiming inside the boundingbox of an entity.
	// this is not 100% but works well enouigh for humans

	if ( attacker == null )
		attacker = GetPlayer()

	local boundingMaxs = entity.GetBoundingMaxs()
	local boundingMins = entity.GetBoundingMins()

	local center = entity.GetCenter()
	local topRight = OffsetOrigin( entity, boundingMaxs, FlattenAngles( attacker.GetAngles() ) )
	local lowerLeft = OffsetOrigin( entity, boundingMins, FlattenAngles( attacker.GetAngles() ) )

	local forward = attacker.GetViewVector()
	local right = attacker.GetRightVector()
	local up = attacker.GetUpVector()

	local topRightVector = topRight - attacker.EyePosition()
	local lowerLeftVector = lowerLeft - attacker.EyePosition()
	topRightVector.Norm()
	lowerLeftVector.Norm()

	local topRightDotF = forward.Dot( topRightVector )
	local topRightDotR = right.Dot( topRightVector )
	local topRightDotU = up.Dot( topRightVector )

	local lowerLeftDotF = forward.Dot( lowerLeftVector )
	local lowerLeftDotR = right.Dot( lowerLeftVector )
	local lowerLeftDotU = up.Dot( lowerLeftVector )

	// up and down
	local inside  = ( topRightDotU < 0 ) != ( lowerLeftDotU < 0 )
	// left and right
	local inside  = inside && ( ( topRightDotR < 0 ) != ( lowerLeftDotR < 0 ) )

	return inside
}

function OffsetOrigin( entity, offset, angles = null )
{
	if ( angles == null )
		angles = entity.GetAngles()

	local dist = offset.Norm()
	local offsetAngles = offset.GetAngles()
	local newAngles = offsetAngles + angles
	local vector = newAngles.AnglesToForward()
	local offsetOrigin = entity.GetOrigin() + vector * dist
	return offsetOrigin
}

// shouldIgniteFunc = a function you can specify to evaluate each ent to see if it should be ignited
function IgniteEntsNearPoint( entName, ignitepos, igniteradius, shouldIgniteFunc = null )
{
	local localents = GetEntArrayWithin( entName, ignitepos, igniteradius )

	foreach ( ent in localents )
	{
		if ( !( "ignited" in ent.scope() ) )
		{
			if ( shouldIgniteFunc != null && !shouldIgniteFunc( ent ) )
			{
				continue
			}

			//printl( "igniting npc " + ent )
			ent.scope().ignited <- true
			ent.Fire( "Ignite" )
		}
	}
}

function DrawStar( origin, size, time = 1, throughWorld = false )
{
	local e = CreateEntity( "logic_script" )
	DispatchSpawn( e, true )
	local forward
	for ( local i = 0; i < 50; i++ )
	{
		e.SetAngles( Vector( RandomInt( 360 ), RandomInt( 360 ), RandomInt( 360 ) ) )
		local forward = e.GetForwardVector()
		DebugDrawLine( origin, origin + forward * size, RandomInt( 255 ), RandomInt( 255 ), RandomInt( 255 ), throughWorld, time )
	}

	e.Kill()
}

function AddScene( guy, AnimScene, Animation )
{
	if ( !( "AnimScenes" in guy.s ) )
	{
		guy.s.AnimScenes <- {}
	}

	guy.s.AnimScenes[AnimScene] <- Animation
}

function GetAnimPack( guy, scene, scene_entity )
{
//	guyProp <- GetEnt( guy.GetName() + "_prop" )

	local pack = {}
	local ref = CreateEntity( "prop_dynamic" )

	local model = guy.Get( "model" )
	ref.SetModel( model )


	Assert( "AnimScenes" in guy.s, "Did not AddScene " + scene + " to " + guy )
	ref.Set( "DefaultAnim", guy.s.AnimScenes[scene] )

	local attachIndex = ref.LookupAttachment( "ORIGIN" )

	DispatchSpawn( ref, false )

	local localSceneOffset = ref.GetAttachmentOrigin( attachIndex )
	local localSceneAngles = ref.GetAttachmentAngles( attachIndex )

	local worldSceneOrigin = scene_entity.GetOrigin()
	local worldSceneAngles = scene_entity.GetAngles()

	local worldGuyYaw = worldSceneAngles.y - localSceneAngles.y

	local rotCos = cos( worldGuyYaw * 3.14159 / 180.0 )
	local rotSin = sin( worldGuyYaw * 3.14159 / 180.0 )

	local worldSpaceOffsetToSceneOrigin = Vector( 0, 0, 0 )

	worldSpaceOffsetToSceneOrigin.x = localSceneOffset.x * rotCos - localSceneOffset.y * rotSin
	worldSpaceOffsetToSceneOrigin.y = localSceneOffset.y * rotCos + localSceneOffset.x * rotSin
	worldSpaceOffsetToSceneOrigin.z = localSceneOffset.z

	pack.origin <- worldSceneOrigin - worldSpaceOffsetToSceneOrigin
	pack.angles <- Vector( 0, worldGuyYaw, 0 )
	pack.scene <- scene
	pack.guy <- guy

	ref.Destroy()
	return pack
}

function PlayAnimPack( pack, sceneName )
{
	local guy = pack.guy

	local animator = CreateEntity( "scripted_sequence" )
	animator.Set( "m_fMoveTo", 2 ) // 2 is run, 4 is instant
	animator.Set( "spawnflags", 4208 ) // 112 )
	animator.Set( "m_iszEntity", guy.GetName() )
	Assert( "AnimScenes" in guy.s, "Did not AddScene " + pack.scene + " to " + guy )
	animator.Set( "m_iszPlay", guy.s.AnimScenes[pack.scene] )

//	printl( "Scene " + pack.scene )

	if ( "anim_init" in guy.GetScriptScope() )
	{
		guy.GetScriptScope().anim_init( animator )
	}

	if ( sceneName )
		animator.SetName( sceneName )
	else
		animator.SetName( UniqueString() )


	animator.SetOrigin( pack.origin )
	animator.SetAngles( pack.angles )

	animator.AddOutput( "OnEndSequence", "!self", "Kill" )

	DispatchSpawn( animator, false )
	return animator
}

function PlayAnimScene( players, sceneEnt, scene )
{
	if ( type( players ) == "array" )
	{
		local animPacks = {}

		foreach ( guy in players )
		{
			local name = guy.GetName()
			printl( "added pack " + name )
			Assert( !( name in animPacks ), "Multiple entities with the same name told to do a scene together" )

			animPacks[name] <- GetAnimPack( guy, scene, sceneEnt )
		}

		local sceneName = UniqueString() // so they animate together

		foreach ( pack in animPacks )
		{
			printl( "fired pack " + pack.guy.GetName() )
			PlayAnimPack( pack, sceneName )
		}
	}
	else
	{
		local pack = GetAnimPack( guy, scene, sceneEnt )
		PlayAnimPack( pack )
	}
}

function SpawnFunctionExists( classname, func )
{

	if ( classname in level.SpawnActions )
	{
		foreach ( store in level.SpawnActions[ classname ] )
		{
			if ( store.type == "function" )
			{
				if ( store.func == func )
				{
					return true
				}
			}

			if ( store.type == "callback" )
			{
				if ( store.func == func )
				{
					return true
				}
			}
		}
	}

	return false
}

function IncludeClassScript( classname, scriptName )
{
	Assert( "SpawnActions" in level )
	if ( !( classname in level.SpawnActions ) )
	{
		level.SpawnActions[ classname ] <- []
	}

	local table = {}
	table.type <- "script"
	table.script <- scriptName
	level.SpawnActions[ classname ].append( table )
}

/*
function PrecacheModel( modelName )
{
	if ( modelName in level.precached.models )
		return

	level.precached.models.modelName <- true

	local temp = CreateEntity( "prop_dynamic" )
	temp.Set( "model", modelName )
	DispatchSpawn( temp, false )
	Assert( IsValid_ThisFrame( temp ), "Failed to precache " + modelName +  " as a prop_dynamic which means that it may ned to be a prop_physics. Use PrecacheModelPhysics() instead." )
	temp.Destroy()
}

function PrecacheModelPhysics( modelName )
{
	if ( modelName in level.precached.modelPhysics )
		return

	level.precached.modelPhysics.modelName <- true

	local temp = CreateEntity( "prop_physics" )
	temp.Set( "model", modelName )
	DispatchSpawn( temp, false )
	Assert( IsValid_ThisFrame( temp ), "Failed to precache " + modelName +  " as a prop_physics which means that it may ned to be a prop_dynamic. Use PrecacheModel() instead." )
	temp.Destroy()
}
*/

function PrecacheModelPhysics( modelName )
{
	PrecacheModel( modelName )
}


function PrecacheEffectScript( scriptName )
{
	if ( scriptName in level.precached.scripts )
		return

	level.precached.scripts.scriptName <- true

	local temp = CreateEntity( "env_effectscript" )
	temp.Set( "scriptfile", scriptName )
	DispatchSpawn( temp, false )
	temp.Destroy()
}

function PrecacheEffect( name )
{
	if ( name in level.precached.effects )
		return

	local warningParticle = CreateEntity( "info_particle_system" )
	warningParticle.kv.effect_name = name
	warningParticle.kv.start_active = 0
	DispatchSpawn( warningParticle, true )
	warningParticle.Destroy()
}

function PrecacheEntity( entName, vScript = null, model = null )
{
	if ( entName in level.precached.entities )
		return

	level.precached.entities.entName <- true

	local tempEnt = CreateEntity( entName )
	if ( vScript )
		tempEnt.kv.vscripts = vScript

	if ( model )
	{
		tempEnt.kv.model = model
	}

	tempEnt.kv.spawnflags = 8 // SF_NPC_ALLOW_SPAWN_SOLID

	DispatchSpawn( tempEnt, vScript != null )
	tempEnt.Destroy()
}

function PrecacheSprite( spriteName )
{
	if ( spriteName in level.precached.sprites )
		return

	level.precached.sprites.spriteName <- true

	local sprite = CreateEntity( "env_sprite_oriented" )
	sprite.kv.model = spriteName
	sprite.kv.spawnflags = 1
	DispatchSpawn( sprite, false )
	sprite.Destroy()
}

function GetFixupSuffix( targetname )
{
	local offset = targetname.find( "&" )

	return offset ? targetname.slice( offset ) : ""
}

function GetFixupPrefix( targetname )
{
	local offset = targetname.find( "&" )

	return offset ? targetname.slice( 0, offset ) : targetname
}

function GetInstancePrefix( targetname )
{
	local tokens = split( targetname, "-" )

	if ( tokens.len() == 1 )
		return ""

	return tokens[0]
}

function GetInstanceSuffix( targetname )
{
	local tokens = split( targetname, "-" )

	if ( tokens.len() == 1 )
		return ""

	return GetFixupPrefix( tokens[1] )
}

function DistToPlayer()
{
	local player = GetPlayer()
	Assert( player != null, "Tried to get dist to player before there was a player" )

	local start = self.GetOrigin()
	local end = player.GetOrigin()

	local dist = ( start - end ).Length()

	return dist

}

function IsPlayer( entity )
{
	Assert( "IsPlayer" in entity, "Entity of classname " + entity.GetClassname() + " doesn't have .IsPlayer()" )
	return entity.IsPlayer()
}

function IsNPC( entity )
{
	return entity.IsNPC()
}

function SetHudText( hudelem, displaystring )
{
	hudelem.Fire( "SetText", displaystring )
	hudelem.Fire( "Display", "", 0.05 )
}

function SetHudColor( hudelem, displaycolor )
{
	hudelem.Fire( "SetTextColor", displaycolor )
}

function CreatePointMessage( msg, origin, displayRadius = 512 )
{
	Assert( msg != null )
	Assert( origin != null )

	local point_message = CreateEntity( "point_message" )
	point_message.SetOrigin( origin )
	point_message.kv.message = msg
	point_message.kv.radius = displayRadius

	DispatchSpawn( point_message, false )

	return point_message
}

function CreateGameText( msg, xPos, yPos, channel, color = "255 255 255", fadein = 2, fadeout = 0.5, holdtime = 2 )
{
	local game_text = CreateEntity( "game_text" )

	game_text.SetName( "gt" + UniqueString()  )
	game_text.kv.message = msg
	game_text.kv.x = xPos
	game_text.kv.y = yPos
	game_text.kv.channel = channel
	game_text.kv.color = color
	game_text.kv.color2 = "240 110 0"  // doesn't appear to do anything atm, not supporting in params
	game_text.kv.fadein = fadein
	game_text.kv.fadeout = fadeout
	game_text.kv.holdtime = holdtime
	game_text.kv.fxtime = "0.25"

	DispatchSpawn( game_text, false )

	return game_text
}

function CreateGameUI( freezePlayer = false )
{
	local game_ui = CreateEntity( "game_ui" )
	game_ui.SetName( "CreatedByUtility" + UniqueString() )

	if ( freezePlayer )
		game_ui.kv.spawnflags = 112

	game_ui.kv.FieldOfView = -1.0
	DispatchSpawn( game_ui, false )

	game_ui.Fire( "Activate", "", 0, self, null )

	return game_ui
}

// pass the origin where the player's feet would be
// tests a player sized box for any collision and returns true only if it's clear
function PlayerCanTeleportHere( player, testOrg )
{
	local playerheight = 64
	local playerwidth = 32
	local pwhalf = playerwidth / 2
	local pwhalf_nega = pwhalf * -1

	local hullCorner1 = Vector( pwhalf_nega, pwhalf_nega, 0 )
	local hullCorner2 = Vector( pwhalf, pwhalf, playerheight )

	local result = TraceHullSimple( testOrg, testOrg, hullCorner1, hullCorner2, player )
	//printl( "hull test: " + result + " pos: " + testOrg )

  if ( result == 1 )
  	return true

  return false
}

function GiveItem( player, itemname, upgradeName = null )
{
	player.scope().PlayerLoadoutGiveItem( player, itemname, upgradeName )
}

//self is player
function SetRecommendedLoadout( player, ... )
{
	// for now we can't decide whether we want SetRecommendedLoadout to overwrite what the player already has, to add to it if he has a free slot, or to
	// not do anything if he has even a partial loadout.  So for now...we're disabling it. Done by MO at ZIED's request

	// once we do figure out what we want it to do - player_loadout.nut needs to change a bit handle it
	return

	//CJD: This doesn't check if the player has unlocked the weapon yet.
	// Setting a recommended weapon that is NOT yet unlocked will let the player still select that weapon

	local args = []
	for ( local i = 0; i< vargc; i++ )
		args.append( vargv[i] )

	foreach ( i, weaponindex in args )
		player.scope().SetLoadoutRegistryExternal( weaponindex, true )
}

function SetDefaultLoadout( player, ... )
{
	local args = []
	for ( local i = 0; i< vargc; i++ )
		args.append( vargv[i] )

	thread __SetDefaultLoadout( player, args )
}

function __SetDefaultLoadout( player, args )
{
	wait 1

	player.scope().ClearLoadout()

	foreach ( i, weaponindex in args )
		player.scope().SetLoadoutRegistryExternal( weaponindex )

	SetPlayerPersistentData( player, "loadoutRegistry", player.s.loadoutRegistry )
}

function CarryOverPersistentLoadout( player )
{
	player.scope().initPlayerRegistry()
	player.scope().giveRegisteredLoadout()
}

function Tokenize( str, token )
{
	return ( split( str, token ) )
}

function printautos()
{
	if ( this.rawin( "self" ) )
		printl( "self:      " + self )

	printl( "activator: " + activator)
	printl( "caller:    " + caller)

	if ( this.rawin( "value" ) )
		printl( "value:     " + value)
}

function VectorToString( vector )
{
	return (vector.x + " " + vector.y + " " + vector.z)
}

enum eAttach
{
	No
	ViewAndTeleport
	View
	Teleport
	ThirdPersonView
}


function LoadDiamond()
{
    Print( " " )
    Print( " " )
    Print( " " )

    // Draw a diamond of a random size and phase (of the moon) so it is easy to separate sections of logs.
    local random_spread = RandomInt( 4, 7 )
    local random_fullness = RandomFloat( 0, 2 )
    local compare_func
    local msg

    if ( RandomFloat( 0, 1 ) > 0.5 )
    {
	    compare_func = function( a, b )
	    {
		    return a <= b
	    }
    }
    else
    {
	    compare_func = function( a, b )
	    {
		    return a >= b
	    }
    }

    function Int( some_float )
    {
	    local val = 0
	    while ( some_float > 1 )
	    {
		    some_float--
		    val++
	    }
	    return val
    }

    for ( local i = 0; i <= random_spread - 2; i++ )
    {
	    msg = ""

	    for ( local p = 0; p <= random_spread - i; p++ )
	    {
		    msg = msg + " "
	    }

	    for ( local p = 0; p <= i * 2; p++ )
	    {
		    if ( p == i * 2 || p == 0 )
		    {
			    msg = msg + "*"
		    }
		    else
		    {
			    local an_int = ( i * random_fullness ).tointeger()

			    if ( compare_func( p, an_int ) )
				    msg = msg + "*"
			    else
				    msg = msg + " "
		    }
	    }

	    Print( msg )
    }

    for ( local i = random_spread - 1; i >= 0; i-- )
    {
	    msg = ""

	    for ( local p = 0; p <= random_spread - i; p++ )
	    {
		    msg = msg + " "
	    }


	    for ( local p = 0; p <= i * 2; p++ )
	    {
		    if ( p == i * 2 || p == 0 )
		    {
			    msg = msg + "*"
		    }
		    else
		    {
			    if ( compare_func( p, ( i * random_fullness ).tointeger() ) )
			    {
				    msg = msg + "*"
			    }
			    else
			    {
				    msg = msg + " "
			    }
		    }
	    }

	    Print( msg )
    }

    Print( " " )
    Print( " " )
    Print( " " )
}

function ClassConnectOutput( outputName, outputFunc, targetEnt )
{
	Assert( type( outputName ) == "string" )
	Assert( type( outputFunc ) == "function" )

	local funcName = UniqueString() + outputName
	targetEnt.scope()[funcName] <- outputFunc.bindenv( this )
	targetEnt.ConnectOutput( outputName, funcName )
}


function SetDifficulty( skillLevel, delay = 0 )
{
	local assertMsg = "You can only set difficulty between 1 - 3"
	Assert( skillLevel > 0, assertMsg )
	Assert( skillLevel < 4, assertMsg )
	local skillNumberString = "skill " + skillLevel.tostring()

	_cc.Fire( "Command", skillNumberString, delay )

}

function GivePlayerAbility( player, abilityname )
{
	Assert( IsPlayer( player ) )

	player.scope()._GivePlayerAbility( abilityname )
}

function TakePlayerAbility( player, abilityname )
{
	Assert( IsPlayer( player ) )

	player.scope()._TakePlayerAbility( abilityname )
}

function PlayerHasAbility( player, abilityname )
{
	Assert( IsPlayer( player ) )

	return player.scope()._PlayerHasAbility( abilityname )
}

function RestockPlayerAmmo( player = null )
{
	local players = []
	if ( IsAlive( player ) )
		players.append( player )
	else
		players = GetLivingPlayers()

	foreach( player in players )
	{
		local weapon = player.GetOffhandWeapon( 0 )
		local clipCount = player.GetWeaponAmmoMaxLoaded( weapon )
		if ( clipCount )
			weapon.SetWeaponPrimaryClipCount( clipCount )

		player.RefillAllAmmo()
	}
}

function AttachLightSprite( ent, lightcolor = "255 0 0", scale = 0.5 )
{
	if ( "lightsprite" in ent.s )
		Assert( ent.s.lightsprite == null, "Couldn't attach a light sprite to " + ent + " because one had already been attached: " + ent.s.lightsprite )

	Assert( type( lightcolor ) == "string", "RGB light color value needs to be set up in a string, like this example: \"255 0 0\"" )

	// attach a light so we can see it
	local env_sprite = CreateEntity( "env_sprite" )
	env_sprite.SetName( UniqueString( "molotov_sprite" ) )
	env_sprite.kv.rendermode = 5
	env_sprite.kv.rendercolor = lightcolor
	env_sprite.kv.renderamt = 255
	env_sprite.kv.framerate = "10.0"
	env_sprite.kv.model = "sprites/glow_05.vmt"
	env_sprite.kv.scale = scale.tostring()
	env_sprite.kv.spawnflags = 1
	env_sprite.kv.GlowProxySize = 16.0
	env_sprite.kv.HDRColorScale = 1.0
	env_sprite.SetOrigin( ent.GetOrigin() )
	env_sprite.SetParent( ent )
	DispatchSpawn( env_sprite, false )
	env_sprite.Fire( "ShowSprite" )

	ent.s.lightsprite <- env_sprite
}

function AddPostEntityLoadCallback( callback, binder = true )
{
	if ( binder )
		_PostEntityLoadCallbacks.append( callback.bindenv( this ) )
	else
		_PostEntityLoadCallbacks.append( callback )
}


function AddClientCommandCallback( commandString, callbackFunc )
{
	Assert( !(commandString in _ClientCommandCallbacks), "Command string " + commandString + " already exists in callbacks" )

	_ClientCommandCallbacks[commandString] <- callbackFunc.bindenv( this )
}


function AddSpawnCallback( classname, callbackFunc )
{
	Assert( "SpawnActions" in level )
	if ( !( classname in level.SpawnActions ) )
	{
		level.SpawnActions[ classname ] <- []
	}

	local args = [ this ]
	for ( local i = 0; i< vargc; i++ )
		args.append( vargv[i] )

	local store = {}
	store.func <- callbackFunc
	store.args <- args

	store.type <- "callback"

	level.SpawnActions[ classname ].append( store )
}

function AddNPCSpawnCallback( callbackFunc )
{
	level._npcSpawnCallbacks.append( callbackFunc )
}


function AddSpawnFunctionWithArgArray( classname, func, args )
{
	Assert( "SpawnActions" in level )
	if ( !( classname in level.SpawnActions ) )
	{
		level.SpawnActions[ classname ] <- []
	}

	local store = {}
	store.func <- func
	store.args <- args

	store.type <- "function"

	level.SpawnActions[ classname ].append( store )
}

function AddSpawnFunction( classname, func, ... )
{
	local args = []
	for ( local i = 0; i < vargc; i++ )
		args.append( vargv[i] )

	AddSpawnFunctionWithArgArray( classname, func, args )
}

function AddCallback_OnRodeoStarted( callbackFunc )
{
	Assert( "onRodeoStartedCallbacks" in level )
	Assert( type( this ) == "table", "AddCallback_OnRodeoStarted can only be added on a table. " + type( this ) )
	AssertParameters( callbackFunc, 1, "player" )

	local name = FunctionToString( callbackFunc )
	Assert( !( name in level.onRodeoStartedCallbacks ), "Already added " + name + " with AddCallback_OnRodeoStarted" )

	local callbackInfo = {}
	callbackInfo.name <- name
	callbackInfo.func <- callbackFunc
	callbackInfo.scope <- this

	level.onRodeoStartedCallbacks[name] <- callbackInfo
}

function AddCallback_OnRodeoEnded( callbackFunc )
{
	Assert( "onRodeoEndedCallbacks" in level )
	Assert( type( this ) == "table", "AddCallback_OnRodeoEnded can only be added on a table. " + type( this ) )
	AssertParameters( callbackFunc, 1, "player" )

	local name = FunctionToString( callbackFunc )
	Assert( !( name in level.onRodeoEndedCallbacks ), "Already added " + name + " with AddCallback_OnRodeoEnded" )

	local callbackInfo = {}
	callbackInfo.name <- name
	callbackInfo.func <- callbackFunc
	callbackInfo.scope <- this

	level.onRodeoEndedCallbacks[name] <- callbackInfo
}

// defaultWinner: if it's a tie, return this value
function GetCurrentWinner( defaultWinner = TEAM_MILITIA )
{
	local imcScore = GameRules.GetTeamScore( TEAM_IMC )
	local militiaScore = GameRules.GetTeamScore( TEAM_MILITIA )

	local currentWinner = defaultWinner

	if ( militiaScore > imcScore )
		currentWinner = TEAM_MILITIA
	else if ( imcScore > militiaScore )
		currentWinner = TEAM_IMC

	return currentWinner
}


function GM_SetTimelimitCompleteFunc( callbackFunc )
{
	// functions in this table run when gamestate changes to Playing
	Assert( "timelimitCompleteFunc" in level )
	Assert( level.timelimitCompleteFunc == null, "GM_SetTimelimitCompleteFunc has already been set: " + level.timelimitCompleteFunc.name )
	Assert( type( this ) == "table", "GM_SetTimelimitCompleteFunc can only be added on a table. " + type( this ) )
	AssertParameters( callbackFunc, 0, "" )

	local name = FunctionToString( callbackFunc )

	local callbackInfo = {}
	callbackInfo.name <- name
	callbackInfo.func <- callbackFunc
	callbackInfo.scope <- this

	level.timelimitCompleteFunc = callbackInfo
}


function GM_AddStartRoundFunc( callbackFunc )
{
	// functions in this table run when gamestate changes to Playing
	Assert( "startRoundFuncTable" in level )
	Assert( type( this ) == "table", "GM_AddStartRoundFunc can only be added on a table. " + type( this ) )
	AssertParameters( callbackFunc, 0, "" )

	local name = FunctionToString( callbackFunc )
	Assert( !( name in level.startRoundFuncTable ), "Already added " + name + " with GM_AddStartRoundFunc" )

	local callbackInfo = {}
	callbackInfo.name <- name
	callbackInfo.func <- callbackFunc
	callbackInfo.scope <- this

	level.startRoundFuncTable[name] <- callbackInfo
}

function GM_AddPreMatchFunc( callbackFunc )
{
	// functions in this table run when gamestate changes to prematch
	Assert( "preMatchFuncTable" in level )
	Assert( type( this ) == "table", "GM_AddPreMatchFunc can only be added on a table. " + type( this ) )
	AssertParameters( callbackFunc, 0, "" )

	local name = FunctionToString( callbackFunc )
	Assert( !( name in level.preMatchFuncTable ), "Already added " + name + " with GM_AddPreMatchFunc" )

	local callbackInfo = {}
	callbackInfo.name <- name
	callbackInfo.func <- callbackFunc
	callbackInfo.scope <- this

	level.preMatchFuncTable[name] <- callbackInfo
}

function AddCallback_GameStateEnter( gameState, callbackFunc )
{
	Assert( "gameStateFunctions" in level )
	Assert( type( this ) == "table", "AddCallback_GameStateEnter can only be added on a table. " + type( this ) )
	AssertParameters( callbackFunc, 0, "" )
	Assert( gameState < level.gameStateFunctions.len() )

	local name = FunctionToString( callbackFunc )
	Assert( !( name in level.gameStateFunctions[gameState] ), "Already added " + name + " with AddCallback_GameStateEnter" )

	local callbackInfo = {}
	callbackInfo.name <- name
	callbackInfo.func <- callbackFunc
	callbackInfo.scope <- this

	level.gameStateFunctions[gameState][name] <- callbackInfo
}

function GM_AddEndRoundFunc( callbackFunc )
{
	// functions in this table run when gamestate changes to WinnerDetermined
	Assert( "endRoundFuncTable" in level )
	Assert( type( this ) == "table", "GM_AddEndRoundFunc can only be added on a table. " + type( this ) )
	AssertParameters( callbackFunc, 0, "" )

	local name = FunctionToString( callbackFunc )
	Assert( !( name in level.endRoundFuncTable ), "Already added " + name + " with GM_AddEndRoundFunc" )

	local callbackInfo = {}
	callbackInfo.name <- name
	callbackInfo.func <- callbackFunc
	callbackInfo.scope <- this

	level.endRoundFuncTable[name] <- callbackInfo
}

function GM_SetObserverFunc( callbackFunc )
{
	Assert( "observerFunc" in level )
	Assert( type( this ) == "table", "GM_SetObserverFunc can only be added on a table. " + type( this ) )
	AssertParameters( callbackFunc, 1, "player" )

	local name = FunctionToString( callbackFunc )

	local callbackInfo = {}
	callbackInfo.name <- name
	callbackInfo.func <- callbackFunc
	callbackInfo.scope <- this

	level.observerFunc = callbackInfo
}

function GM_AddPlayingThinkFunc( callbackFunc )
{
	Assert( "playingThinkFuncTable" in level )
	Assert( type( this ) == "table", "GM_AddPlayingThinkFunc can only be added on a table. " + type( this ) )
	AssertParameters( callbackFunc, 0, "" )

	local name = FunctionToString( callbackFunc )
	Assert( !( name in level.playingThinkFuncTable ), "Already added " + name + " with GM_AddPlayingThinkFunc" )

	local callbackInfo = {}
	callbackInfo.name <- name
	callbackInfo.func <- callbackFunc
	callbackInfo.scope <- this

	level.playingThinkFuncTable[name] <- callbackInfo
}

function GM_SetMatchProgressAnnounceFunc( callbackFunc )
{
	Assert( "matchProgressAnnounceFunc" in level )
	Assert( type( this ) == "table", "GM_MatchProgressAnnounceFunc can only be added on a table. " + type( this ) )
	AssertParameters( callbackFunc, 1, "progression" )

	local name = FunctionToString( callbackFunc )

	local callbackInfo = {}
	callbackInfo.name <- name
	callbackInfo.func <- callbackFunc
	callbackInfo.scope <- this

	level.matchProgressAnnounceFunc = callbackInfo
}

function FakePlayerAwareness( npc, endSig = null )
{
	npc.EndSignal( "OnDeath" )

	if ( endSig != null )
		level.ent.EndSignal( endSig )

	local minLostTime = 0.5
	local maxLostTime = 1.5

	npc.Fire( "UpdateEnemyMemory", "!player" )

	while ( IsValid_ThisFrame( npc ) )
	{
		npc.Fire( "UpdateEnemyMemory", "!player" )
		Wait( 1 )
		//npc.WaitSignal( "OnLostPlayer" )
		//Wait( RandomFloat( minLostTime, maxLostTime ) )

		//printl( "revealing player position" )
		//npc.Fire( "UpdateEnemyMemory", "!player" )
	}
}

function GetAiRelationshipEntityName( entity )
{
	Assert( IsValid( entity ), "ai_relationship endpoint is invalid" )

	local name = entity.GetName()
	if ( name != "" && GetEntArrayByName_Expensive( name ).len() == 1 )
		return name

	name = UniqueString( "ai_relationship_endpoint" )
	entity.SetName( name )
	return name
}

function createAiRelationship( subject, target, disposition = "D_HT", rank = 0, reciprocal = 1 )
{
	local dispositionList = { D_HT = 1, D_FR = 2, D_LI = 3, D_NU = 4 };
	Assert( disposition in dispositionList, "disposition must be D_HT, D_FR, D_LI or D_NU" )

	local ai_relationship = CreateEntity( "ai_relationship" )
	ai_relationship.SetName( UniqueString( "ai_relationship" ) )
	ai_relationship.Set( "subject", GetAiRelationshipEntityName( subject ) )
	ai_relationship.Set( "target", GetAiRelationshipEntityName( target ) )
	ai_relationship.Set( "disposition", dispositionList[ disposition ] )
	ai_relationship.Set( "StartActive", 1 )
	ai_relationship.Set( "rank", rank )
	ai_relationship.Set( "reciprocal", reciprocal )
	DispatchSpawn( ai_relationship, false )

	return ai_relationship
}

function CreateOperatorTargetBeam( owner = null )
{
	local name = "OperatorTargetReticle"

	// if there is a self with a name, add the name to our name
	if ( owner && owner.IsValidInternal() )
	{
		local addon = owner.GetName()
		if ( addon != "" )
			name += "_" + addon
	}

	local warningParticle = CreateEntity( "info_particle_system" )
	warningParticle.SetName( name )
	warningParticle.kv.effect_name = "operator_target_base" // "ar_operator_target" // operator_target_base" // "ar_operator_target" // "ar_droppod_impact"
	warningParticle.kv.vscripts = "entities/operator_target_beam.nut"
	if ( owner && owner.IsValidInternal() )
	{
		warningParticle.SetOwner( owner )
		warningParticle.kv.VisibilityFlags = 1
		warningParticle.kv.TeamNumber = owner.GetTeam()
	}
	DispatchSpawn( warningParticle, true )

	return warningParticle

}

// Get an absolute offset poistion to an entity even if it's been rotated in world space
function GetEntPosPlusOffset( ent, offsetX, offsetY, offsetZ )
{
	local entAngles = ent.GetAngles()
	local entOrg = ent.GetOrigin()

	local right = entAngles.AnglesToRight()
	right.Norm()
	local pos = entOrg + ( right * offsetY )

	local forward = entAngles.AnglesToForward()
	forward.Norm()
	pos = pos + ( forward * offsetX )

	local up = entAngles.AnglesToUp()
	up.Norm()
	pos = pos + ( up * offsetZ )

	return pos
}

function EmitSoundToTeamPlayers( alias, teamID )
{
	local players = GetPlayerArrayOfTeam( teamID )

	foreach ( player in players )
	{
		EmitSoundOnEntityOnlyToPlayer( player, player, alias )
	}
}

function EmitDifferentSoundsAtPositionForPlayerAndWorld( soundForPlayer, soundForWorld, position, player )
{
	if ( IsValid( player ) && player.IsPlayer() )
	{
		EmitSoundAtPositionExceptToPlayer( position, player, soundForWorld )
		EmitSoundAtPositionOnlyToPlayer( position, player, soundForPlayer )
	}
	else
	{
		EmitSoundAtPosition( position, soundForWorld )
	}

}


function EmitDifferentSoundsOnEntityForPlayerAndWorld( soundForPlayer, soundForWorld, soundEnt, player )
{
	if ( IsValid( player ) && player.IsPlayer() )
	{
		EmitSoundOnEntityExceptToPlayerNotPredicted( soundEnt, player, soundForWorld )
		EmitSoundOnEntityOnlyToPlayer( soundEnt, player, soundForPlayer )
	}
	else
	{
		EmitSoundOnEntity( soundEnt, soundForWorld )
	}

}

function EmitSoundOnEntityExceptToOther( soundEnt, other, alias )
{
	if ( other.IsPlayer() )
	{
		EmitSoundOnEntityExceptToPlayer( soundEnt, other, alias )
	}
	else
	{
		EmitSoundOnEntity( soundEnt, alias )
	}
}

function DissolveEnt( ent, delay = 0 )
{
	level.podDissolver.Fire( "Dissolve", ent.GetName(), delay )
}


// Drop an entity to the ground by tracing straight down from its z-axis
function DropToGround( ent, offset = 0 )
{
	local targetOrigin = GroundPos( ent )
	ent.SetOrigin( targetOrigin + Vector( 0, 0, offset ) )
}

function OriginToGround( origin )
{
	local endOrigin = origin - Vector( 0, 0, 20000 )
	local traceResult = TraceLine( origin, endOrigin, [], TRACE_MASK_NPCWORLDSTATIC, TRACE_COLLISION_GROUP_NONE )

	return traceResult.endPos
}

function GroundPos( ent )
{
	local startOrigin = ent.GetOrigin() + Vector(0,0,1)
	local endOrigin = startOrigin - Vector( 0, 0, 20000 )
	local traceResult = TraceLine( startOrigin, endOrigin, [], TRACE_MASK_NPCWORLDSTATIC, TRACE_COLLISION_GROUP_NONE )

	return traceResult.endPos
}

// ---------------------------------------------------------------------
// Make a player spawnpoint active so the player will respawn there when he dies.
// Pass the unique name (string) of the instance (instances/interactive/player_spawn_point.vmf)
// Optional parameter to pass the actual entity name within the instance
// ---------------------------------------------------------------------
function PlayerSpawnpointMakeActive( spawnPointName, playFx = true, spawnPoint = null )
{
	local player = GetPlayer()
	Assert( player != null, "Can't make a player spawnpoint before the player has spawned." )
	Assert( "spawnPointActive" in player.s, "player.s.spawnPointActive hasn't been defined yet. Need to call this script after spawnpoints have been set up." )

	local activeSpawnPoint = null

	if ( spawnPointName == "" )
	{
		Assert( spawnPoint != null, "Cannot use NULL as a player spawnpoint" )
		Assert( PlayerSpawnpointIsValid( spawnPoint ), "Cannot call PlayerSpawnpointMakeActive() on the entity at " + spawnPoint.GetOrigin() + ". It is not a valid spawnpoint." )
		activeSpawnPoint = spawnPoint
	}
	else
	{
		activeSpawnPoint = PlayerSpawnPointGetEntFromInstance( spawnPointName )
	}

	//printl( "player spawnpoint at " + activeSpawnPoint.GetOrigin() + " with the name " + activeSpawnPoint.GetName() + " has been made the active spawnPoint" )
	Assert( activeSpawnPoint != null )
	player.s.spawnPointActive = activeSpawnPoint
	player.s.spawnPointTeleportProxy.SetOrigin( activeSpawnPoint.GetOrigin() )
	player.s.spawnPointTeleportProxy.SetAngles( activeSpawnPoint.GetAngles() )


	if ( playFx == true )
	{
		//Sound, text, fx for checkpoint
		local game_text = CreateEntity( "game_text" )
		game_text.SetName( "test" )
		game_text.kv.message = "Checkpoint Reached"
		game_text.kv.x = "-1"
		game_text.kv.y = "0.35"
		game_text.kv.effect = 2
		game_text.kv.color = "255 164 89"
		game_text.kv.color2 = "240 108 0"
		game_text.kv.fadein = "0.05"
		game_text.kv.fadeout = "0.5"
		game_text.kv.holdtime = "2"
		game_text.kv.fxtime = "0.25"
		game_text.kv.channel = 4
		DispatchSpawn( game_text, false )

		game_text.Fire( "Display" )
		game_text.Fire( "Kill", "", 5 )

		local ambient_generic = CreateEntity( "ambient_generic" )
		// Play everywhere
		// Start Silent
		// Is NOT Looped
		ambient_generic.kv.spawnflags = 49
		ambient_generic.SetName( "xxx" )
		ambient_generic.kv.message = "weapons/player_slammer_fire5.wav"
		ambient_generic.kv.health = 10
		ambient_generic.kv.pitch = 100
		ambient_generic.kv.pitchstart = 100
		ambient_generic.kv.radius = "1250"
		DispatchSpawn( ambient_generic, false )

		ambient_generic.Fire( "PlaySound" )
		ambient_generic.Fire( "Kill", "", 4)
	}
}

// ---------------------------------------------------------------------
// Get the spawnpoint entity within the instance (instances/interactive/player_spawn_point.vmf)
// ---------------------------------------------------------------------
function PlayerSpawnPointGetEntFromInstance( instanceName )
{
	local spawnPoints = GetEntArray( "PlayerSpawnpoint-" + instanceName )
	Assert( spawnPoints.len() > 0, "There is no player spawnpoint within an instance named " + instanceName )
	Assert( spawnPoints.len() < 2, "There are multiple player_spawn_point.vmf instances named " + instanceName + ". Use unique instance names." )
	local spawnPoint = spawnPoints[ 0 ]

	return spawnPoint
}

// ---------------------------------------------------------------------
// Determine if an entity is a valid player spawnpoint
// ---------------------------------------------------------------------
function PlayerSpawnpointIsValid( ent )
{
	if ( ent.GetClassname() != "prop_dynamic" )
		return false
	if ( ent.kv.model != "models/humans/pete/mri_male.mdl" )
		return false

	return true
}

/*
	script thread Repeat( function() : () { printl( Time() ) 	}	)


	Example usage of repeat:

	thread Repeat(
		function() : ( pod )
		{
			DrawAttachment( pod, "ATTACH", 0.2 )
		}
	)
*/
function Repeat( func, time = null )
{
	local timed = false
	local endTime

	if ( time )
	{
		timed = true
		endTime = Time() + time
	}

	for ( ;; )
	{
		if ( timed )
		{
			if ( Time() > endTime )
				break;
		}

		func()

		wait 0.05
	}
}

function RandomOffset( dist )
{
	local forward
	local angles = Vector( 0,0,0 )
	angles.x = RandomFloat( 0, 360 )
	angles.y = RandomFloat( 0, 360 )
	angles.z = RandomFloat( 0, 360 )

	forward = angles.AnglesToForward()
	return forward * dist
}

// ---------------------------------------------------------------------
// Make an NPC or the player invincible (true/false)
//	(_npc.nut intercepts incoming damage and negates it if the ent is tagged as invincible)
// ---------------------------------------------------------------------
function MakeInvincible( ent )
{
	Assert( IsValid_ThisFrame( ent ), "Tried to make invalid " + ent + " invincible" )
	Assert( ent.IsNPC() || IsPlayer( ent ), "MakeInvincible() can only be called on NPCs and the player" )
	Assert( IsAlive( ent ), "Tried to make dead ent " + ent + " invincible" )

	ent.SetInvulnerable()
}

function ClearInvincible( ent )
{
	Assert( IsValid_ThisFrame( ent ), "Tried to clear invalid " + ent + " invincible" )

	ent.ClearInvulnerable()
}

function IsInvincible( ent )
{
	return ent.IsInvulnerable()
}

//-------------------------------------
// Teleport an entity (teleporter) to an entity's org and angles (ent)
//--------------------------------------
function TeleportToEnt( teleporter, ent )
{
	Assert( teleporter != null, "Unable to teleport null entity" )
	Assert( ent != null, "Unable to teleport to a null entity" )
	teleporter.SetOrigin( ent.GetOrigin() )
	teleporter.SetAngles( ent.GetAngles() )

}

function IsCapturePointTurret( turret )
{
	if ( GetMapName() != "mp_fracture" )
		return false

	return GAMETYPE == CAPTURE_POINT
}

//-------------------------------------
// Returns an array of chained (targeted) entities
//--------------------------------------
function GetEntityChain( startEntity )
{
	Assert( startEntity != null, "tried to GetEntityChain on a null entity" )
	local entityChain = []
	entityChain.append( startEntity )
	local nextEnt = startEntity

	while ( 1 )
	{
		//printl( nextEnt.GetTarget() )
		if ( nextEnt.GetTarget() == "" )
			break

		local currEnts = GetEntArray( nextEnt.GetTarget() )
		Assert( currEnts.len() > 0, "Next node target not found with targetname " + nextEnt.GetTarget() )
		Assert ( currEnts.len() == 1, "Found more than one target for targetname " + nextEnt.GetTarget() )

		local currEnt = currEnts[ 0 ]
		Assert( currEnt, "Chain petered out for entity " + startEntity )
		Assert( currEnt != nextEnt, "Entity chain node " + currEnt + " targets itself!" )

		if ( currEnt == startEntity )
		{
			//printl( "Called GetEntityChain() on a looped entity chain that targets itself. Returning all ents up to loop end" )
			break
		}

		entityChain.append( currEnt )
		nextEnt = currEnt
	}

	return entityChain
}

//-------------------------------------
// Returns the last entity in an array of chained (targeted) entities
//--------------------------------------
function GetChainEnd( startEntity )
{
	Assert( startEntity != null, "tried to GetChainEnd on a null entity" )

	local chainEnd = startEntity

	while( chainEnd.GetTarget() != "" )
		chainEnd = GetEnt( chainEnd.GetTarget() )

	return chainEnd
}

//-----------------------------------------------------------
// CreateShake() - create and fire an env_shake at a specified origin
// - returns the shake in case you want to parent it
//------------------------------------------------------------

function CreateShake( org, amplitude = 16, frequency = 150, duration = 1.5, radius = 2048 )
{
	local env_shake = CreateEntity( "env_shake" )
	env_shake.kv.amplitude = amplitude
	env_shake.kv.radius = radius
	env_shake.kv.duration = duration
	env_shake.kv.frequency = frequency

	DispatchSpawn( env_shake, false )

	env_shake.SetOrigin( org )

	env_shake.Fire( "StartShake" )
	env_shake.Fire( "Kill", "", ( duration + 1 ) )

	return env_shake
}

//-------------------------------------
// CreatePhysExplosion - physExplosion...small, medium or large
//--------------------------------------
function CreatePhysExplosion( org, radius, size, flags = 1, dealsDamage = true )
{
	local magnitude
	if ( dealsDamage )
	{
		if ( size == "small" )
			magnitude = "100"
		else if ( size == "medium" )
			magnitude = "250"
		if ( size == "large" )
			magnitude = "500"
		if ( size == "huge" )
			magnitude = "10000"
	}
	else
	{
		magnitude = 1 // 0 does default magnitude
	}

	local env_physexplosion = CreateEntity( "env_physexplosion" )
	env_physexplosion.kv.spawnflags = flags // default 1 = No Damage - Only Force
	env_physexplosion.kv.magnitude = magnitude
	env_physexplosion.kv.radius = radius.tostring()
	env_physexplosion.SetOrigin( org )
	env_physexplosion.kv.scriptDamageType = damageTypes.Explosive
	DispatchSpawn( env_physexplosion, false )

	env_physexplosion.Fire( "Explode" )
	env_physexplosion.Fire( "Kill", "", 2 )
}

//-----------------------------------------------------------
// CreateExplosionNoDamage() - create and fire a no-damage explosion at a specified origin
// - returns the entity in case you want to parent it
//------------------------------------------------------------
function CreateExplosionNoDamage( org, magnitude = 256 )
{
	local env_explosion = CreateEntity( "env_explosion" )
	env_explosion.kv.spawnflags = 1 // No Damage
	env_explosion.kv.iMagnitude = 500
	env_explosion.kv.fireballsprite = "sprites/zerogxplode.spr"
	env_explosion.kv.rendermode = 5
	DispatchSpawn( env_explosion )

	env_explosion.Fire( "Explode" )
	env_explosion.Fire( "Kill", "", 2 )

	return env_explosion
}

//------------------------------------------------------------
// CreateExplosion() - create and fire an explosion at a specified origin. Optionally specify owner, delay, sound alias
// - returns the entity in case you want to parent it
//------------------------------------------------------------
function CreateExplosion( origin, magnitude, magnitudeHeavyArmor, innerRadius, outerRadius, owner = null, delay = 0, soundAlias = null, eDamageSourceId = -1, selfDamage = true, customFxTable = null, skipsDoomedState = false )
{
	local env_explosion = CreateEntity( "env_explosion" )

	local flags = 0
	if ( soundAlias )
		flags += SF_ENVEXPLOSION_NOSOUND  // no built-in env_explosion sound
	if ( !selfDamage )
		flags += SF_ENVEXPLOSION_NO_DAMAGEOWNER // No Damage Owner

	if ( customFxTable != null )
	{
		env_explosion.kv.impact_effect_table = customFxTable
		flags += SF_ENVEXPLOSION_NODECAL // No Decal
	}
	env_explosion.kv.spawnflags = flags
	env_explosion.SetOrigin( origin )
	env_explosion.kv.iMagnitude = magnitude
	env_explosion.kv.iMagnitudeHeavyArmor = magnitudeHeavyArmor
	env_explosion.kv.iInnerRadius = innerRadius
	env_explosion.kv.iRadiusOverride = outerRadius
	env_explosion.kv.fireballsprite = "sprites/zerogxplode.spr"
	env_explosion.kv.rendermode = 5

	local damageFlags = damageTypes.Explosive
	if ( skipsDoomedState )
		damageFlags = damageFlags | DF_SKIPS_DOOMED_STATE

	env_explosion.kv.scriptDamageType = damageFlags

	if ( IsValid_ThisFrame( owner ) )
	{
		local myTeam = owner.GetTeam()
		env_explosion.SetTeam( myTeam )
		env_explosion.SetOwner( owner )
	}

	DispatchSpawn( env_explosion, false )

	env_explosion.kv.damageSourceId = eDamageSourceId

		env_explosion.Fire( "Explode", "", delay, owner )
		env_explosion.Kill( delay + 5 )

	if ( soundAlias )
	{
		EmitSoundOnEntity( env_explosion, soundAlias )

		/* TEMP keeping for future testing until code examines
		local emitter = CreateEntity( "info_target" )
		DispatchSpawn( emitter )
		EmitSoundOnEntity( emitter, soundAlias )
		emitter.Kill( 5 )
		*/
	}

	return env_explosion
}

function RadiusDamage( origin, titanDamage, nonTitanDamage, radiusFalloffMax, radiusFullDamage, owner, damageSourceID, aliveOnly, selfDamage, team, scriptFlags )
{
	// Repeatable
	// No Fireball
	// No Smoke
	// No Decal
	// No Sparks
	// No Sound
	// No Fireball Smoke
	// No particles
	// No DLights

	local flags = 1918
	if ( aliveOnly )
		flags = flags | SF_ENVEXPLOSION_ALIVE_ONLY
	if ( !selfDamage )
		flags = flags | SF_ENVEXPLOSION_NO_DAMAGEOWNER

	local env_explosion = CreateEntity( "env_explosion" )

	env_explosion.kv.spawnflags = flags
	env_explosion.SetOrigin( origin )
	env_explosion.kv.iMagnitude 		= nonTitanDamage
	env_explosion.kv.iMagnitudeHeavyArmor = titanDamage
	env_explosion.kv.iRadiusOverride 	= radiusFalloffMax
	env_explosion.kv.iInnerRadius 		= radiusFullDamage
	env_explosion.kv.rendermode = 5

	if ( scriptFlags != null )
		env_explosion.kv.scriptDamageType = scriptFlags

	if ( IsValid( owner ) )
	{
		for ( ;; )
		{
			local newOwner = owner.GetOwner()
			if ( !IsValid( newOwner ) )
				break

			owner = newOwner
		}

		env_explosion.SetOwner( owner )
		env_explosion.SetTeam( owner.GetTeam() )
	}
	else
	{
		if ( team != null )
		{
			env_explosion.SetTeam( team )
		}
	}

	DispatchSpawn( env_explosion, false )

	env_explosion.kv.damageSourceId = damageSourceID

	//env_explosion.FireNow( "Explode" )
	env_explosion.Fire( "Explode" )
	env_explosion.Kill( 5 )

	return env_explosion
}

//------------------------------------------------------------
// PopcornExplosionBurst() - does a "popcorn airburst" explosion effect over time around the origin. Total distance is based on popRangeBase
// - returns the entity in case you want to parent it
//------------------------------------------------------------
function PopcornExplosionBurst( origin, damage, damageHeavyArmor, innerRadius, outerRadius, owner = null, soundAlias = null, selfDamage = true, popcornInfo = null, customFxTable = null )
{
	// first explosion always happens where you fired
	local eDamageSource = popcornInfo.damageSourceId
	local numBursts = popcornInfo.count
	local popRangeBase = popcornInfo.range
	local popDelayBase = popcornInfo.delay
	local popDelayRandRange = popcornInfo.offset
	local useNormal = false
	if( ( "normal" in popcornInfo ) && popcornInfo.normal != null )
		useNormal = true

	CreateExplosion( origin, damage, damageHeavyArmor, innerRadius, outerRadius, owner, 0.0, soundAlias, eDamageSource, selfDamage, customFxTable )

	local counter = 1  // already did the first one
	local randVec = null
	local randRangeMod = null
	local popRange = null
	local popVec = null
	//local popTraceVec = null
	local popOri = origin
	local popDelay = null
	local colTrace

	local burstDelay = CLUSTER_ROCKET_DURATION / (numBursts / CLUSTER_ROCKET_BURST_GROUP_SIZE)

	while( counter <= numBursts )
	{
		if ( useNormal )
			randVec = RandomVecInDome( popcornInfo.normal )
		else
			randVec = Vector( RandomFloat( -1, 1 ), RandomFloat( -1, 1 ), RandomFloat( -1, 1 ) )
		randRangeMod = ( RandomFloat( 0, 1 ) )
		popRange = popRangeBase * randRangeMod
		popVec = randVec * popRange
		popOri = origin + popVec
		//popTraceVec = randVec * popRange * 0.85
		popDelay = popDelayBase + RandomFloat( -popDelayRandRange, popDelayRandRange )

		colTrace = TraceLineSimple( origin, popOri, null )

		if ( TraceLineSimple( origin, popOri, null ) < 1 )
		{
			popVec = popVec * colTrace
			popOri = origin + popVec
		}

		//thread DrawTracerOverTime( origin, popTraceVec, popDelay/5 )//the modified time gets the traces to look kindof the way i want
		CreateExplosion( popOri, damage, damageHeavyArmor, innerRadius, outerRadius, owner, popDelay, soundAlias, eDamageSource, selfDamage, customFxTable )

		counter++
		if( counter % CLUSTER_ROCKET_BURST_GROUP_SIZE == 0 )
		{
			wait burstDelay
		}
	}
}


function DrawTracerOverTime( origin, vector, time )
{
	local frac = null
	local x = null
	local y = null
	local timeFrac = null
	local lastInterval = 0
	local interval = 0

	local counter = 1.0

	while ( counter <= 10 )
	{
		frac = counter / 10
		x = 1 - frac
		y = x * x * x * x
		frac = 1 - y
		timeFrac = time * frac
		interval = timeFrac - lastInterval
		lastInterval = timeFrac

		DebugDrawLine( origin, origin + vector * frac, 255, 255, 150, false, interval + 0.05 )
		Wait( interval )

		counter++
	}
}

//-----------------------------------------------------------
// CreatePropDynamic( model ) - create a generic prop_dynamic with default properties
//------------------------------------------------------------
function CreatePropDynamic( model, origin = null, angles = null, solidType = 0, fadeDist = -1 )
{
	local prop_dynamic = CreateEntity( "prop_dynamic" )
	prop_dynamic.kv.model = model
	prop_dynamic.kv.fadedist = fadeDist
	prop_dynamic.kv.renderamt = 255
	prop_dynamic.kv.rendercolor = "255 255 255"
	prop_dynamic.kv.solid = solidType // 0 = no collision, 2 = bounding box, 6 = use vPhysics, 8 = hitboxes only
	prop_dynamic.kv.MinAnimTime = 5
	prop_dynamic.kv.MaxAnimTime = 10
	if ( origin )
	{
		// hack: Setting origin twice. SetOrigin needs to happen before DispatchSpawn, otherwise the prop may not touch triggers
		prop_dynamic.SetOrigin( origin )
		if ( angles )
			prop_dynamic.SetAngles( angles )
	}
	DispatchSpawn( prop_dynamic )
	if ( origin )
	{
		// hack: Setting origin twice. SetOrigin needs to happen after DispatchSpawn, otherwise origin is snapped to nearest whole unit
		prop_dynamic.SetOrigin( origin )
		if ( angles )
			prop_dynamic.SetAngles( angles )
	}

	return prop_dynamic
}


//-----------------------------------------------------------
// CreatePropPhysics( model ) - create a generic prop_physics with default properties
//------------------------------------------------------------
function CreatePropPhysics( model, origin = null, angles = null )
{
	local prop_physics = CreateEntity( "prop_physics" )
	prop_physics.kv.model = model
	prop_physics.kv.spawnflags = 0
	prop_physics.kv.fadedist = -1
	prop_physics.kv.physdamagescale = 0.1
	prop_physics.kv.inertiaScale = 1.0
	prop_physics.kv.renderamt = 255
	prop_physics.kv.rendercolor = "255 255 255"
	prop_physics.SetTeam( TEAM_BOTH )	// need to have a team other then 0 or it won't take impact damage

	if ( origin )
	{
		prop_physics.SetOrigin( origin )
		if ( angles )
			prop_physics.SetAngles( angles )
	}

	DispatchSpawn( prop_physics, true )

	return prop_physics
}

//-----------------------------------------------------------
// CreateAssaultPoint() - create a generic assault_assaultpoint with default properties
//------------------------------------------------------------
function CreateAssaultPoint()
{
	local assault_assaultpoint = CreateEntity( "assault_assaultpoint" )
	assault_assaultpoint.kv.assaulttimeout = 3.0
	assault_assaultpoint.kv.assaulttolerance = 36
	assault_assaultpoint.kv.spawnflags = 2	// don't check origin in solid, assault point will be moved later
	DispatchSpawn( assault_assaultpoint )

	return assault_assaultpoint
}

//-----------------------------------------------------------
// SpawnBullseye() - creates a npc_bullseye and attaches it to a past ent
//------------------------------------------------------------
function SpawnBullseye( team, ent = null )
{
	bullseye <- CreateEntity( "npc_bullseye" )
	bullseye.SetName( UniqueString( "bullseye" ) )
	bullseye.kv.rendercolor = "255 255 255"
	bullseye.kv.renderamt = 0
	bullseye.kv.health = 9999
	bullseye.kv.max_health = -1
	bullseye.kv.spawnflags = 516
	bullseye.kv.FieldOfView = 0.5
	bullseye.kv.FieldOfViewAlert = 0.2
	bullseye.kv.AccuracyMultiplier = 1.0
	bullseye.kv.reactChance = 100
	bullseye.kv.physdamagescale = 1.0
	bullseye.kv.WeaponProficiency = 3
	bullseye.kv.minangle = "360"
	DispatchSpawn( bullseye, false )

	bullseye.SetTeam( team )

	if ( ent )
	{
		local bounds = ent.GetBoundingMaxs()
		bullseye.SetOrigin( ent.GetOrigin() + Vector( 0, 0, bounds.z * 0.5 ) )
		bullseye.SetParent( ent )
	}

	return bullseye
}

//-----------------------------------------------------------
// DebugPrint( msg ) - set level.debugprint <- true when you want to see your prints
//------------------------------------------------------------
function DebugPrint( msg )
{
	if ( !( "debugprint" in level ) )
		return
	printl( msg )
}

function CenterPrint( ... )
{
	local msg = ""
	for ( local i = 0; i < vargc; i++ )
		msg = ( msg + " " + vargv[ i ] )

	local words = vargc
	if ( words < 1 )
		words = 1

	local delay = GraphCapped( words, 2, 8, 2.1, 3.5 )

	local ent = CreateGameText( msg, "-1", "0.5", 10, "255 255 255", 0.25, 0.25, delay )
	ent.Fire( "Display" )
	ent.Kill( delay )
}
RegisterFunctionDesc( "CenterPrint", "Print to the screen" )


function IsValidPlayer( player )
{
	if ( !IsValid( player ) )
		return false

	if ( !player.IsPlayer() )
		return false

	return !player.IsDisconnected()
}
/****************************************************************************************************\
/*
|*											PLAY FX
\*
\****************************************************************************************************/
const C_PLAYFX_SINGLE 	= 0
const C_PLAYFX_MULTIPLE = 1
const C_PLAYFX_LOOP 	= 2

function PlayFX( effect, org, optionalAng = null, overrideAngle = null)
{
	return __CreateFxInternal( effect, null, null, org, optionalAng, C_PLAYFX_SINGLE, null, null, null, overrideAngle )
}

function PlayFXWithControlPoint( effect, org, cpoint1, visibilityFlagOverride = null, visibilityFlagEntOverride = null, overrideAngle = null, _type = C_PLAYFX_SINGLE )
{
	return __CreateFxInternal( effect, null, null, org, null, _type, cpoint1, visibilityFlagOverride, visibilityFlagEntOverride, overrideAngle)
}

function PlayFXOnEntity( effect, ent, optionalTag = null, optionalTranslation = null, optionalRotation = null, visibilityFlagOverride = null, visibilityFlagEntOverride = null, overrideAngle = null )
{
	return __CreateFxInternal( effect, ent, optionalTag, optionalTranslation, optionalRotation, C_PLAYFX_SINGLE, null,  visibilityFlagOverride, visibilityFlagEntOverride, overrideAngle )
}

function ClientStylePlayFXOnEntity( effect, ent, tag, duration = 2.0 )
{
	local name = ent.GetName()
	ent.SetName( UniqueString() ) // hack because you can only specify control points by name
	// hack this is also not quite right because we can't specify the attachment type on the server... should be trivial to add in code:
	// change DEFINE_FIELD( m_parentAttachmentType, FIELD_INTEGER ), to DEFINE_KEYFIELD( m_parentAttachmentType, FIELD_INTEGER, "attachmentType" ),
	local result = __CreateFxInternal( effect, ent, tag, null, null, C_PLAYFX_SINGLE, ent, 6, ent )
	result.Fire( "Kill", "", duration )
	ent.SetName( name )

	return result
}

function PlayFXMultiple( effect, org, optionalAng = null )
{
	return __CreateFxInternal( effect, null, null, org, optionalAng, C_PLAYFX_MULTIPLE )
}

function PlayFXOnEntityMultiple( effect, ent, optionalTag = null, optionalTranslation = null, optionalRotation = null )
{
	return __CreateFxInternal( effect, ent, optionalTag, optionalTranslation, optionalRotation, C_PLAYFX_MULTIPLE )
}

function PlayLoopFX( effect, org, optionalAng = null )
{
	return __CreateFxInternal( effect, null, null, org, optionalAng, C_PLAYFX_LOOP )
}

function PlayLoopFXOnEntity( effect, ent, optionalTag = null, optionalTranslation = null, optionalRotation = null, visibilityFlagOverride = null, visibilityFlagEntOverride = null )
{
	return __CreateFxInternal( effect, ent, optionalTag, optionalTranslation, optionalRotation, C_PLAYFX_LOOP, null, visibilityFlagOverride, visibilityFlagEntOverride )
}

function __CreateFxInternal( effect, ent, optionalTag, optionalTranslation, optionalRotation, _type, cpointEnt1 = null, visibilityFlagOverride = null, visibilityFlagEntOverride = null, overrideAngle = null )
{
	local FX = CreateEntity( "info_particle_system" )
	FX.kv.effect_name = effect
	if( visibilityFlagOverride != null )
		FX.kv.VisibilityFlags = visibilityFlagOverride
	else
		FX.kv.VisibilityFlags = 7
	FX.kv.start_active = 1
	FX.s._type <- _type

	local coreOrg
	local coreAng

	//are we attaching to an ent?
	if ( ent )
	{
		//are we attaching to a tag on an ent
		if ( optionalTag )
		{
			local attachID = ent.LookupAttachment( optionalTag )
			coreOrg = ent.GetAttachmentOrigin( attachID )
			coreAng = ent.GetAttachmentAngles( attachID )
		}
		else
		{
			optionalTag = ""
			coreOrg = ent.GetOrigin()
			coreAng = ent.GetAngles()
		}
	}
	//if not we're just playing in space
	else
	{
		optionalTag = ""
		coreOrg = Vector( 0,0,0 )
		coreAng = Vector( 0,0,0 )
	}

	if ( optionalTranslation )
	{
		if ( ent )
			coreOrg = PositionOffsetFromEnt( ent, optionalTranslation.x, optionalTranslation.y, optionalTranslation.z )
		else
			coreOrg = coreOrg + optionalTranslation
	}

	if ( coreOrg )
	{
		ClampToWorldspace( coreOrg )
		FX.SetOrigin( coreOrg )
	}

	if ( overrideAngle )
		FX.SetAngles( overrideAngle )
	else if ( optionalRotation )
		FX.SetAngles( coreAng + optionalRotation )
	else
		FX.SetAngles( coreAng )

	if ( ent )
	{
		if ( !ent.IsMarkedForDeletion() ) // TODO: This is a hack for shipping. The real solution is to spawn the FX before deleting the parent entity.
		{
			FX.SetParent( ent, optionalTag, true )
		}
	}

	if ( visibilityFlagEntOverride != null )
	{
		FX.SetOwner( visibilityFlagEntOverride )
	}

	if ( cpointEnt1 )
		FX.kv.cpoint1 = cpointEnt1.GetName()

	DispatchSpawn( FX )
	thread __DeleteFxInternal( FX )

	//FX.SetName( "FX_" + effect )
	return FX
}

function __DeleteFxInternal( FX )
{
	//if it loops or is multiple then don't delete internally
	if ( FX.s._type == C_PLAYFX_MULTIPLE )
		return
	if ( FX.s._type == C_PLAYFX_LOOP )
		return

	wait 30//no way to know when an effect is over
	if ( !IsValid_ThisFrame( FX ) )
		return
	FX.ClearParent()
	FX.Destroy()
}

function StartFX( FX )
{
	Assert( FX.s._type == C_PLAYFX_LOOP, "Tried to use StartFX() on effect that is not LOOPING" )

	FX.Fire( "Start" )
}

function StopFX( FX )
{
	Assert( FX.s._type == C_PLAYFX_LOOP, "Tried to use StopFX() on effect that is not LOOPING" )
	FX.Fire( "Stop" )
}

// SRS- FX says some particles use operators that need "DestroyImmediately" instead of just "Stop"
function StopFX_DestroyImmediately( FX )
{
	Assert( FX.s._type == C_PLAYFX_LOOP, "Tried to use StopFX_DestroyImmediately() on effect that is not LOOPING" )
	FX.Fire( "DestroyImmediately" )
}

function ReplayFX( FX )
{
	Assert( FX.s._type == C_PLAYFX_MULTIPLE, "Tried to use ReplayFX() on effect that is not MULTIPLE" )
	//thread it because there is a wait 0 inside the function
	thread __ReplayFXInternal( FX )
}

function __ReplayFXInternal( FX )
{
	//for non-looping fx, we must stop first before we can fire again
	FX.Fire( "Stop" )
	//we can't start in the same frame, wait 0 skips 1 false
	//it should be noted that "wait 0" doesn't work with a timescale above 1
	wait 0
	//may have died since the last frame
	if ( IsValid_ThisFrame( FX ) )
		FX.Fire( "Start" )
}
/****************************************************************************************************\
|*											end play fx
\****************************************************************************************************/

function CreateScriptObjective( ... )
{
	// stub for old objective system
}

function GetPreAnim( self )
{
	local preanim
	if ( self.IsTitan() )
	{
		if ( self.IsStanding() )
			preanim = "atpov_preanim_stand"
		else
			preanim = "atpov_preanim_crouch"
	}
	else
	{
		if ( self.IsStanding() )
			preanim = "ptpov_preanim_stand"
		else
			preanim = "ptpov_preanim_crouch"
	}

	return preanim
}

//UnStuck( target, e.targetStartPos )

function GetPostAnim( self )
{
	local postanim
	if ( self.IsTitan() )
	{
		if ( self.IsStanding() )
			postanim = "atpov_postanim_stand"
		else
			postanim = "atpov_postanim_crouch"
	}
	else
	{
		if ( self.IsStanding() )
			postanim = "ptpov_postanim_stand"
		else
			postanim = "ptpov_postanim_crouch"
	}

	return postanim
}

function RestartLevel()
{
	local entity = CreateEntity( "point_clientcommand" )
	DispatchSpawn( entity )
	entity.Fire( "Command", "restart" )
}

function GetDamageTableFromInfo( damageInfo )
{
	local table = {}
	table.damageSourceId <- damageInfo.GetDamageSourceIdentifier()
	table.origin <- damageInfo.GetDamagePosition()
	table.force <- damageInfo.GetDamageForce()
	table.scriptType <- damageInfo.GetCustomDamageType()

	return table
}

function EntityInSolid( entity, ignoreEnt = null, buffer = 0 ) //TODO:  This function returns true for a player standing inside a friendly grunt. It also returns true if you are right up against a ceiling.Needs fixing for next game
{
	Assert( IsValid( entity ) )
	local solidMask
	local mins
	local maxs
	local collisionGroup
	local ignoreEnts = []

	ignoreEnts.append( entity )

	if ( IsValid( ignoreEnt ) )
	{
		ignoreEnts.append( ignoreEnt )
	}

	if ( entity.IsTitan() )
		solidMask = TRACE_MASK_TITANSOLID
	else if ( entity.IsPlayer() )
		solidMask = TRACE_MASK_PLAYERSOLID
	else
		solidMask = TRACE_MASK_NPCSOLID

	if ( entity.IsPlayer() )
	{
		mins = entity.GetPlayerMins()
		maxs = entity.GetPlayerMaxs()
		collisionGroup = TRACE_COLLISION_GROUP_PLAYER
	}
	else
	{
		Assert( entity.IsNPC() )
		mins = entity.GetBoundingMins()
		maxs = entity.GetBoundingMaxs()
		collisionGroup = TRACE_COLLISION_GROUP_NONE
	}

	if ( buffer > 0 )
	{
		mins.x -= buffer
		mins.y -= buffer
		maxs.x += buffer
		maxs.y += buffer
	}

	// if we got into solid, teleport back to safe place
	local currentOrigin = entity.GetOrigin()
	local result = TraceHull( currentOrigin, currentOrigin + Vector(0,0,1), mins, maxs, ignoreEnts, solidMask, collisionGroup )
	//PrintTable( result )
	//DrawArrow( result.endPos, Vector(0,0,0), 5, 150 )
	if ( result.startSolid )
		return true

	return result.fraction < 1.0 // TODO: Probably not needed according to Jiesang. Fix after ship.
}

function EntityInSolidIgnoreFriendlyNPC( entity, ignoreEnt = null, buffer = 0 ) //JFS: Only used in TitanEmbarkFailsafe for now to guard against friendly NPC showing up as solid
{
	Assert( IsValid( entity ) )
	local solidMask
	local mins
	local maxs
	local collisionGroup
	local ignoreEnts = []

	ignoreEnts.append( entity )

	if ( IsValid( ignoreEnt ) )
	{
		ignoreEnts.append( ignoreEnt )
	}

	if ( entity.IsTitan() )
		solidMask = TRACE_MASK_TITANSOLID
	else if ( entity.IsPlayer() )
		solidMask = TRACE_MASK_PLAYERSOLID
	else
		solidMask = TRACE_MASK_NPCSOLID

	if ( entity.IsPlayer() )
	{
		mins = entity.GetPlayerMins()
		maxs = entity.GetPlayerMaxs()
		collisionGroup = TRACE_COLLISION_GROUP_PLAYER
	}
	else
	{
		Assert( entity.IsNPC() )
		mins = entity.GetBoundingMins()
		maxs = entity.GetBoundingMaxs()
		collisionGroup = TRACE_COLLISION_GROUP_NONE
	}

	if ( buffer > 0 )
	{
		mins.x -= buffer
		mins.y -= buffer
		maxs.x += buffer
		maxs.y += buffer
	}

	// if we got into solid, teleport back to safe place
	local currentOrigin = entity.GetOrigin()
	local result = TraceHull( currentOrigin, currentOrigin + Vector(0,0,1), mins, maxs, ignoreEnts, solidMask, collisionGroup )
	//DrawArrow( result.endPos, Vector(0,0,0), 5, 150 )
	//PrintTable( result )
	local hitEnt = result.hitEnt

	if ( IsFriendlyGruntOrSpectre( hitEnt, entity ) )
		return false

	if ( result.startSolid )
		return true

	return result.fraction < 1.0 // TODO: Probably not needed according to Jiesang. Fix after ship.
}

function EntityInSpecifiedEnt( entity, specifiedEnt, buffer = 0 )
{
	Assert( IsValid( entity ) )
	Assert( IsValid( specifiedEnt ) )
	local solidMask
	local mins
	local maxs
	local collisionGroup

	if ( entity.IsTitan() )
		solidMask = TRACE_MASK_TITANSOLID
	else if ( entity.IsPlayer() )
		solidMask = TRACE_MASK_PLAYERSOLID
	else
		solidMask = TRACE_MASK_NPCSOLID

	if ( entity.IsPlayer() )
	{
		mins = entity.GetPlayerMins()
		maxs = entity.GetPlayerMaxs()
		collisionGroup = TRACE_COLLISION_GROUP_PLAYER
	}
	else
	{
		Assert( entity.IsNPC() )
		mins = entity.GetBoundingMins()
		maxs = entity.GetBoundingMaxs()
		collisionGroup = TRACE_COLLISION_GROUP_NONE
	}

	if ( buffer > 0 )
	{
		mins.x -= buffer
		mins.y -= buffer
		maxs.x += buffer
		maxs.y += buffer
	}

	// if we got into solid, teleport back to safe place
	local currentOrigin = entity.GetOrigin()
	local result = TraceHull( currentOrigin, currentOrigin + Vector(0,0,1), mins, maxs, null, solidMask, collisionGroup )
	//PrintTable( result )
	//DrawArrow( result.endPos, Vector(0,0,0), 5, 150 )
	if ( result.startSolid == false )
		return false

	return result.hitEnt == specifiedEnt
}

function IsFriendlyGruntOrSpectre( hitEnt, testEnt )
{
	if ( !IsValid( hitEnt ) )
		return false

	if ( !IsNPC( hitEnt ) )
		return false

	if ( !ShouldPreventFriendlyFire( hitEnt, testEnt ) )
		return false

	if ( hitEnt.IsSpectre() )
		return true

	if ( hitEnt.IsSoldier() )
		return true

	return false
}

function UnStuck( entity, startOrigin, ignoreEnt = null )
{
	Assert( IsValid( entity ) )
	local solidMask
	local mins
	local maxs
	local ignoreEnts = []

	ignoreEnts.append( entity )

	if ( IsValid( ignoreEnt ) )
	{
		ignoreEnts.append( ignoreEnt )
	}

	if ( entity.IsPlayer() )
	{
		// solidMask = TRACE_MASK_PLAYERSOLID_BRUSHONLY
		solidMask = TRACE_MASK_PLAYERSOLID
		mins = entity.GetPlayerMins()
		maxs = entity.GetPlayerMaxs()
	}
	else
	{
		Assert( entity.IsNPC() )
		// solidMask = TRACE_MASK_NPCSOLID_BRUSHONLY
		solidMask = TRACE_MASK_NPCSOLID
		mins = entity.GetBoundingMins()
		maxs = entity.GetBoundingMaxs()
	}

	if ( entity.IsTitan() )
		solidMask = solidMask | TRACE_MASK_TITANSOLID

	// if we got into solid, teleport back to safe place
	local currentOrigin = entity.GetOrigin()
	local result = TraceHull( currentOrigin, currentOrigin, mins, maxs, ignoreEnts, solidMask, TRACE_COLLISION_GROUP_PLAYER )

	local inSolid = result.fraction < 1.0

	result = TraceLine( currentOrigin + Vector( 0, 0, 1 ), startOrigin + Vector( 0, 0, 1 ), ignoreEnts, solidMask, TRACE_COLLISION_GROUP_PLAYER )

	if ( result.fraction < 1.0 || inSolid )
		entity.SetOrigin( startOrigin )
}

function LimitedUnStuck( entity, startOrigin, ignoreEnt = null )
{
	if ( EntityInSolid( entity, ignoreEnt ) )
		entity.SetOrigin( startOrigin )
}

function OrgInSolidForEntity( entity, startOrigin )
{
	Assert( IsValid( entity ) )
	local solidMask
	local mins
	local maxs
	local ignoreEnts = []

	ignoreEnts.append( entity )

	if ( entity.IsPlayer() )
	{
//		solidMask = TRACE_MASK_PLAYERSOLID_BRUSHONLY
		solidMask = TRACE_MASK_PLAYERSOLID
		mins = entity.GetPlayerMins()
		maxs = entity.GetPlayerMaxs()
	}
	else
	{
		Assert( entity.IsNPC() )
		//solidMask = TRACE_MASK_NPCSOLID_BRUSHONLY
		solidMask = TRACE_MASK_NPCSOLID
		mins = entity.GetBoundingMins()
		maxs = entity.GetBoundingMaxs()
	}

	// if we got into solid, teleport back to safe place
	local currentOrigin = entity.GetOrigin()
	local solidMask = CONTENTS_TITANCLIP | TRACE_MASK_NPCWORLDSTATIC
	local result = TraceHull( currentOrigin, currentOrigin + Vector(0,0,1), mins, maxs, ignoreEnts, solidMask, TRACE_COLLISION_GROUP_NONE )
	//DrawArrow( result.endPos, Vector(0,0,0), 5, 150 )

	if ( result.startSolid )
		return true
	return result.fraction < 1.0
}

function DrawBox( org, mins, maxs, r, g, b, throughSolid, time )
{
	local forward = Vector(0,1,0)
	local right = Vector(1,0,0)
	local up = Vector(0,0,1)

	local orgs = []
	AddDrawBoxPoint( orgs, forward * mins.x, right * mins.y, up * mins.z )
	AddDrawBoxPoint( orgs, forward * -mins.x, right * mins.y, up * mins.z )
	AddDrawBoxPoint( orgs, forward * mins.x, right * -mins.y, up * mins.z )
	AddDrawBoxPoint( orgs, forward * -mins.x, right * -mins.y, up * mins.z )

	AddDrawBoxPoint( orgs, forward * maxs.x, right * maxs.y, up * maxs.z )
	AddDrawBoxPoint( orgs, forward * -maxs.x, right * maxs.y, up * maxs.z )
	AddDrawBoxPoint( orgs, forward * maxs.x, right * -maxs.y, up * maxs.z )
	AddDrawBoxPoint( orgs, forward * -maxs.x, right * -maxs.y, up * maxs.z )


	local player = GetPlayerArray()[0]
	local eyepos = player.EyePosition()
	foreach ( sourceOrg in orgs )
	{
		foreach ( destOrg in orgs )
		{
			DebugDrawLine( org + sourceOrg, org + destOrg, r, g, b, throughSolid, time )
			DebugDrawLine( eyepos, org + sourceOrg, r, g, b, throughSolid, time )
			//printt( "draw from " + ( org + sourceOrg ) + " to " + ( org + destOrg ) )
		}
	}
}

function AddDrawBoxPoint( orgs, x, y, z )
{
	local vec = x + y + z
	orgs.append( vec )
}


function KillFromInfo( ent, damageInfo )
{
	local attacker = damageInfo.GetAttacker()
	local weapon = damageInfo.GetWeapon()
	local amount = damageInfo.GetDamage()
	if ( !weapon )
		weapon = attacker

	local table = GetDamageTableFromInfo( damageInfo )
	table.forceKill <- true

	ent.TakeDamage( 9999, attacker, weapon, table )
}

function TakeDamageFromInfo( ent, damageInfo )
{
	local attacker = damageInfo.GetAttacker()
	local weapon = damageInfo.GetWeapon()
	local amount = damageInfo.GetDamage()
	if ( !weapon )
		weapon = attacker

	local table = GetDamageTableFromInfo( damageInfo )

	ent.TakeDamage( amount, attacker, weapon, table )
}

function GetPlayerTitanInMap( player )
{
	// first try to return the player's actual titan
	if ( player.IsTitan() )
	{
		return player
	}

	local petTitan = player.GetPetTitan()
	if ( IsValid( petTitan ) && IsAlive( petTitan ) )
		return petTitan

	return null
}


function GetPlayerTitanFromSouls( player )
{
	// returns the first owned titan found
	local souls = GetTitanSoulArray()
	foreach ( soul in souls )
	{
		if ( !IsValid( soul ) )
			continue

		if ( soul.GetBossPlayer() != player )
			continue

		if ( !IsAlive( soul.GetTitan() ) )
			continue

		return soul.GetTitan()
	}

	return null
}

function GetAllFriendlyTitans( team )
{
	local titans = []
	local souls = GetTitanSoulArray()
	foreach ( soul in souls )
	{
		if ( soul.GetTeam() == team )
			continue

		if ( !IsValid( soul ) )
			continue

		if ( !IsAlive( soul.GetTitan() ) )
			continue

		titans.append( soul.GetTitan() )
	}

	return titans
}

function DisableTitanShield( titan )
{
	local soul = titan.GetTitanSoul()

	soul.SetShieldHealth( 0 )
	soul.SetShieldHealthMax( 0 )
}

function DebugDrawCircleOnTag( ent, tag, radius, r, g, b, time )
{
	thread _DebugThreadDrawCircleOnTag( ent, tag, radius, r, g, b, time )
}

function DebugDrawSphereOnTag( ent, tag, radius, r, g, b, time )
{
	local degrees 	= 45

	for( local i = 0; i < 8; i++ )
	{
		thread _DebugThreadDrawCircleOnTag( ent, tag, radius, r, g, b, time, Vector( 0, 0, degrees * i ) )
		thread _DebugThreadDrawCircleOnTag( ent, tag, radius, r, g, b, time, Vector( degrees * i, 0, 0 ) )
	}
}

function _DebugThreadDrawCircleOnTag( ent, tag, radius, r, g, b, time, anglesDelta = Vector( 0,0,0 ) )
{
	ent.EndSignal( "OnDeath" )

	local attachIdx = ent.LookupAttachment( tag )
	Assert( attachIdx != null )
	local interval = 0.1

	while( time > 0 )
	{
		if ( !IsValid( ent ) )
			return

		local origin = ent.GetAttachmentOrigin( attachIdx )
		local angles = ent.GetAttachmentAngles( attachIdx ) + anglesDelta

		DebugDrawCircle( origin, angles, radius, r, g, b, interval )

		wait interval
		time -= interval
	}
}

function SetVelocityTowardsEntity( entToMove, targetEnt, speed )
{
	Assert( typeof speed == "float" || typeof speed == "integer" )
	Assert( speed > 0 )
	Assert( IsValid( entToMove ) )
	Assert( IsValid ( targetEnt ) )

	local direction = ( targetEnt.GetWorldSpaceCenter() - entToMove.GetOrigin() )
	direction.Norm()
	direction *= speed
	entToMove.SetVelocity( direction )
}

function SetVelocityTowardsEntityTag( entToMove, targetEnt, targetTag, speed )
{
	Assert( typeof speed == "float" || typeof speed == "integer" )
	Assert( speed > 0 )
	Assert( IsValid( entToMove ) )
	Assert( IsValid ( targetEnt ) )

	local attachID = targetEnt.LookupAttachment( targetTag )
	local attachOrigin = targetEnt.GetAttachmentOrigin( attachID )

	local direction = ( attachOrigin - entToMove.GetOrigin() )
	direction.Norm()
	direction *= speed
	entToMove.SetVelocity( direction )
}

function AddSavedLocation( refName, pos, ang = 0 )
{
	if ( !( "storedLocations" in level ) )
		level.storedLocations <- {}
	else
		Assert( !( refName in level.storedLocations ), "Saved location named " + refName + " already exists" )

	level.storedLocations[ refName ] <- {}
	level.storedLocations[ refName ].refName <- refName
	level.storedLocations[ refName ].origin <- pos

	local angVec = ang
	if ( typeof( ang ) != "Vector" )
		angVec = Vector( 0, ang, 0 )

	level.storedLocations[ refName ].angles <- angVec
}

function GetSavedLocation( refName )
{
	Assert( ( "storedLocations" in level ), "No saved locations have been set up for this level" )
	Assert( ( refName in level.storedLocations ), "Couldn't find saved location named " + refName )

	return level.storedLocations[ refName ]
}

function GetSavedLocationOrigin( refName )
{
	return GetSavedLocation( refName ).origin
}

function GetSavedLocationAngles( refName )
{
	return GetSavedLocation( refName ).angles
}

function TraceBug()
{
	local start = Vector(129.619629, 5944.646484, -143.899994)
	local end = Vector(872.933228, 5945.314941, 7829.651855)

	local mins = Vector( -65, -65, 0 )
	local maxs = Vector( 65, 65, 240 )
	local result = TraceHull( start, end, mins, maxs, null, TRACE_MASK_SOLID, TRACE_COLLISION_GROUP_NONE )
	DebugDrawLine( start, result.endPos, 0, 255, 0, true, 5.0 )
	DebugDrawLine( result.endPos, end, 255, 0, 0, true, 5.0 )

	start.x += 10
	start.y += 10

	end.x += 10
	end.y += 10
	local result = TraceLine( start, end )
	DebugDrawLine( start, result.endPos, 0, 255, 0, true, 5.0 )
	DebugDrawLine( result.endPos, end, 255, 0, 0, true, 5.0 )
}

function AddSavedDropEvent( refName, drop )
{
	if ( !( "storedDropEvents" in level ) )
		level.storedDropEvents <- {}
	else
		Assert( !( refName in level.storedDropEvents ), "Saved DropEvent named " + refName + " already exists" )

	level.storedDropEvents[ refName ] <- drop
}

function GetSavedDropEvent( refName )
{
	Assert( ( "storedDropEvents" in level ), "No saved DropEvents have been set up for this level" )
	Assert( ( refName in level.storedDropEvents ), "Couldn't find saved DropEvent named " + refName )

	return level.storedDropEvents[ refName ]
}

function EntityDemigod_TryAdjustDamageInfo( ent, damageInfo )
{
	local bottomLimit = 5
	if ( ent.GetHealth() <= bottomLimit )
		ent.SetHealth( bottomLimit + 1 )

	local dmg = damageInfo.GetDamage()
	local health = ent.GetHealth()

	if ( health - dmg <= bottomLimit )
	{
		local newdmg = dmg - ( abs( health - dmg ) + bottomLimit )
		damageInfo.SetDamage( newdmg )
		//printt( "setting damage to ", newdmg )
	}
}

function GetNameFromDamageSourceID( id )
{
	if ( id in damageSourceIdToString )
		return damageSourceIdToString[id]

	return null
}

function DebugDamageInfo( ent, damageInfo )
{
	printt( "damage to " + ent + ": " + damageInfo.GetDamage() )
	local damageType = damageInfo.GetCustomDamageType()
	printt( "explosive: " + ( damageType & DF_EXPLOSION ) )
	printt( "bullet: " + ( damageType & DF_BULLET ) )
	printt( "gib: " + ( damageType & DF_GIB ) )

	local dampos = damageInfo.GetDamagePosition()
	local org = damageInfo.GetInflictor().GetOrigin()
	DebugDrawLine( dampos, org, 255, 0, 0, true, 10.0 )
	DebugDrawLine( org, ent.GetOrigin(), 255, 255, 0, true, 10.0 )
}

function rodeodebug()
{
	// console command for forcing rodeo amongst 2 players
	thread makerodeothread()
}

function makerodeothread()
{
	local players = GetPlayerArray()
	local titanorg
	local titan, pilot

	for ( local i = players.len() - 1; i >= 0; i-- )
	{
		local player = players[i]

		if ( player.IsTitan() )
		{
			titan = player
		}
		else
		{
			pilot = player
		}
	}

	if ( !titan )
	{
		for ( local i = players.len() - 1; i >= 0; i-- )
		{
			local player = players[i]

			if ( !player.IsTitan() )
			{
				player.SetPlayerSettings( "titan_atlas" )
				titan = player
				break
			}
		}
	}
	else
	if ( !pilot )
	{
		for ( local i = players.len() - 1; i >= 0; i-- )
		{
			local player = players[i]

			if ( player.IsTitan() )
			{
				thread TitanEjectPlayer( player )
				wait 1.5
				pilot = player
				break
			}
		}
	}

	for ( local i = players.len() - 1; i >= 0; i-- )
	{
		local player = players[i]

		if ( player.IsTitan() )
		{
			titanorg = player.GetOrigin()
		}
	}

	if ( !titanorg )
		return

	for ( local i = players.len() - 1; i >= 0; i-- )
	{
		local player = players[i]

		if ( !player.IsTitan() )
		{
			local angles = titan.GetAngles()
			local forward = angles.AnglesToForward()
			titanorg += forward * -100
			titanorg.z += 500
			angles.x = 30
			player.SetAngles( angles )
			player.SetOrigin( titanorg )
			player.SetVelocity( Vector(0,0,0) )
			break
		}
	}

}


function RandomVecInDome( vector )
{
	local angles = VectorToAngles( vector )
	local forward = angles.AnglesToForward()
	local right = angles.AnglesToRight()
	local up = angles.AnglesToUp()

	local offsetRight = RandomFloat( -1, 1 )
	local offsetUp = RandomFloat( -1, 1 )
	local offsetForward = RandomFloat( 0, 1 )

	local endPos = Vector( 0, 0, 0 )
	endPos += forward * offsetForward
	endPos += up * offsetUp
	endPos += right * offsetRight
	endPos.Norm()

	return endPos
}

function GetAnimEventTime( modelname, anim, event )
{
	local dummy = CreatePropDynamic( modelname )
	dummy.Hide()

	local duration 	= dummy.GetSequenceDuration( anim )
	local frac 		= dummy.GetScriptedAnimEventCycleFrac( anim, event )

	dummy.Kill()

	if ( frac == -1 )
		return duration

	return duration * frac
}

//eventually remove the original - scary to add this assert for the shipped game though
function GetAnimEventTimeR2( modelname, anim, event )
{
	local dummy = CreatePropDynamic( modelname )
	dummy.Hide()

	local duration 	= dummy.GetSequenceDuration( anim )
	local frac 		= dummy.GetScriptedAnimEventCycleFrac( anim, event )

	dummy.Kill()

	Assert( frac > 0.0, "event: " + event + " doesn't exist in animation: " + anim )
	Assert( frac < 1.0, "event: " + event + " doesn't exist in animation: " + anim )

	return duration * frac
}

function GetDropshipDeployTime( ref, anim )
{
	return GetAnimEventTime( ref.GetModelName(), anim, "dropship_deploy" )
}

function CloakDudesCustom( fadein, duration, fadeout )
{
	local dudes = GetNPCArrayByClass( "npc_soldier" )

	foreach ( dude in dudes )
	{
		dude.SetCloakDuration( fadein, duration, fadeout )
	}
}

function CloakDudes( duration )
{
	local fadein = 1
	local fadeout = 2

	CloakDudesCustom( fadein, duration - fadein, fadeout );
}

function SetDeathFuncName( npc, functionNameString )
{
	Assert( npc.kv.deathScriptFuncName == "", "deathScriptFuncName was already set" )
	npc.kv.deathScriptFuncName = functionNameString
}
RegisterFunctionDesc( "SetDeathFuncName", "Sets the name of a function that runs when the NPC dies." )

function ClearDeathFuncName( npc )
{
	npc.kv.deathScriptFuncName = ""
}
RegisterFunctionDesc( "ClearDeathFuncName", "Clears the script death function." )

function PushSunLightAngles( x, y, z )
{
	local clight = GetEnt( "env_cascade_light" )
	Assert( clight )

	clight.PushAngles( x, y, z )
}

function PopSunLightAngles()
{
	local clight = GetEnt( "env_cascade_light" )
	Assert( clight )

	clight.PopAngles()
}

function GetPilotAntiPersonnelWeapon( player )
{
	local weaponsArray = player.GetMainWeapons()
	foreach( weapon in weaponsArray )
	{
			if ( weapon.GetWeaponInfoFileKeyField( "is_sidearm" ) == 1 )
				continue

			if ( weapon.GetWeaponInfoFileKeyField( "is_anti_titan" ) == 1 )
				continue

			return weapon
	}

	return null
}

function GetPilotSideArmWeapon( player )
{
	local weaponsArray = player.GetMainWeapons()
	foreach( weapon in weaponsArray )
	{
			if ( weapon.GetWeaponInfoFileKeyField( "is_sidearm" ) == 1 )
				return weapon
	}

	return null
}

function GetPilotAntiTitanWeapon( player )
{
	local weaponsArray = player.GetMainWeapons()
	foreach( weapon in weaponsArray )
	{
			if ( weapon.GetWeaponInfoFileKeyField( "is_anti_titan" ) == 1 )
				return weapon
	}

	return null
}

function ScreenFadeToBlack( player, fadeTime = 1.7, holdTime = 0.0 )
{
	Assert( IsValid( player ) )

	ScreenFade( player, 0, 0, 1, 255, fadeTime, holdTime, 0x0002 | 0x0010 )
}


function ScreenFadeFromBlack( player, fadeTime = 2.0, holdTime = 2.0 )
{
	Assert( IsValid( player ) )

	ScreenFade( player, 0, 1, 0, 255, fadeTime, holdTime, 0x0001 | 0x0010 )
}








const DEBUG_LINE = 0

function CreateIncomingEffect( targetPos, radius, team )
{
	local friendlyEffectName
	local enemyEffectName

	if ( radius >= 768 )
	{
		friendlyEffectName = "ar_rocket_strike_large_friend"
		enemyEffectName = "ar_rocket_strike_large_foe"
	}
	else
	{
		friendlyEffectName = "ar_rocket_strike_small_friend"
		enemyEffectName = "ar_rocket_strike_small_foe"
	}

	return CreateMultiTeamEffect( targetPos, Vector( 0,0,0 ), friendlyEffectName, enemyEffectName, team )

}

function CreateMultiTeamEffect( origin, angles, friendlyEffectName, enemyEffectName, team )
{
	local multiTeamEffect = {}

	local friendlyEffect = CreateFriendlyOnlyEffect( origin, angles, friendlyEffectName, team )
	local enemyEffect = CreateEnemyOnlyEffect( origin, angles, enemyEffectName, team )

	multiTeamEffect.friendly <- friendlyEffect
	multiTeamEffect.enemy <- enemyEffect

	return multiTeamEffect
}

function CreateFriendlyOnlyEffect( origin, angles, friendlyEffectName, team )
{
	local friendlyEffect = CreateEntity( "info_particle_system" )
	friendlyEffect.SetOrigin( origin )
	friendlyEffect.SetAngles( angles )
	friendlyEffect.kv.effect_name = friendlyEffectName
	friendlyEffect.kv.start_active = 1
	friendlyEffect.kv.TeamNum = team
	friendlyEffect.kv.VisibilityFlags = 2 // ENTITY_VISIBLE_TO_FRIENDLY
	DispatchSpawn( friendlyEffect )

	return friendlyEffect
}

function CreateEnemyOnlyEffect( origin, angles, enemyEffectName, team )
{
	local enemyEffect = CreateEntity( "info_particle_system" )
	enemyEffect.SetOrigin( origin )
	enemyEffect.SetAngles( angles )
	enemyEffect.kv.effect_name = enemyEffectName
	enemyEffect.kv.start_active = 1
	enemyEffect.kv.TeamNum = team
	enemyEffect.kv.VisibilityFlags = 4 // ENTITY_VISIBLE_TO_ENEMY
	DispatchSpawn( enemyEffect )

	return enemyEffect
}

function DestroyIncomingEffect( incomingEffect )
{
	DestroyMultiTeamEffect( incomingEffect )
}

function DestroyMultiTeamEffect( multiTeamEffect )
{
	multiTeamEffect.friendly.Destroy()
	multiTeamEffect.enemy.Destroy()
}


function FoundDropSpot( e, offsetFraction )
{
//	printt( "testing " + offsetFraction )
	local offsetx = RandomFloat( e.mins.x, e.maxs.x )
	local offsety = RandomFloat( e.mins.y, e.maxs.y )

	offsetx *= offsetFraction
	offsety *= offsetFraction

	local dropOrigin = e.origin + e.forward * offsety
	dropOrigin += e.right * offsetx

	local dropVec = Vector( 0,0,-e.dropHeight)
	local end = dropOrigin + dropVec
	local result = TraceHull( dropOrigin, end, e.analysis.mins, e.analysis.maxs, null, TRACE_MASK_NPCWORLDSTATIC, TRACE_COLLISION_GROUP_NONE )

	if ( DEBUG_LINE )
	{
		DebugDrawLine( dropOrigin, dropOrigin + dropVec, 0, 255, 0, true, 5 )
		DebugDrawLine( result.endPos + Vector(1,1,1), end + Vector(1,1,1), 255, 0, 0, true, 5 )
	}

	// hit ground?
	if ( result.fraction >= 1.0 )
		return false

	foreach ( dropspot in e.dropTable.dropspots )
	{
		// too close to an existing dropspot?
		if ( Distance( dropspot.origin, result.endPos ) < e.analysis.maxs.x * 1.5 )
			return false
	}

	// too close to ship?
	if ( abs( result.endPos.z - dropOrigin.z ) < 800 )
		return false

	// analyize the potential impact point
	if ( !FlatSurfaceFromTrace( dropOrigin, result, e.analysis.mins, e.analysis.maxs ) )
		return false

	local yaw = GetYaw( e.origin, dropOrigin )
	local angles = Vector( 0, yaw, 0 )
	local forward = angles.AnglesToForward()
	local right = angles.AnglesToRight()

	// hit geo on the way down?
	local legalFlightPath = IsLegalFlightPath( e.analysis, result.endPos, forward, right )
	if ( !legalFlightPath )
		return false

	local table = {}
	table.origin <- result.endPos
	table.angles <- angles
	return table
}

function GetYaw( org1, org2 )
{
	local vec = org2 - org1
	local angles = VectorToAngles( vec )
	return angles.y
}

function FlatSurfaceFromNormal( normal )
{
	return VectorDotToUp( normal ) > 0.9
}

function FlatSurfaceFromOrigin( start, end, mins, maxs )
{
	local MAX_OFFSET = 50
	local dropHeight = start.z - end.z
	dropHeight += MAX_OFFSET
	Assert( dropHeight > 0, "End is above start" )
	local dropVec = Vector( 0,0, -dropHeight )
	for ( local i = 0; i < 4; i++ )
	{
		local x
		local y
		switch ( i )
		{
			case 0:
				x = mins.x
				y = mins.y
				break
			case 1:
				x = maxs.x
				y = mins.y
				break
			case 2:
				x = maxs.x
				y = maxs.y
				break
			case 3:
				x = mins.x
				y = maxs.y
				break
		}

		local org = start + Vector( x, y, 0 )
		local end = org + dropVec
		local result = TraceLine( org, end, null, TRACE_MASK_NPCWORLDSTATIC, TRACE_COLLISION_GROUP_NONE )

		// trace didn't hit
		if ( result.fraction >= 1.0 )
		{
			if ( DEBUG_LINE )
				DebugDrawLine( org, end, 0, 0, 255, true, 5 )
			return false
		}

		// too much distance from desired height?
		if ( abs( result.endPos.z - end.z ) > MAX_OFFSET )
		{
			if ( DEBUG_LINE )
				DebugDrawLine( org, end, 0, 255, 255, true, 5 )
			return false
		}
	}

	return true
}

function FlatSurfaceFromTrace( dropOrigin, result, mins, maxs )
{
	if ( !FlatSurfaceFromNormal( result.surfaceNormal ) )
		return false

	return FlatSurfaceFromOrigin( dropOrigin, result.endPos, mins, maxs )
}


function CreateEscortTitan( team, settings, origin, angles, model )
{
	local table = CreateSpawnNPCTitanTemplate( team, settings )
	table.angles	= angles
	table.origin    = origin
	table.health	= 5000
	table.maxHealth	= table.health
	table.weapon = "mp_titanweapon_xo16"
	table.title = "Escort"

	return SpawnNPCTitan( table )
}

function DieIfBossDisconnects( ent, player )
{
	Assert( IsNewThread(), "Must be threaded off" )
	Assert( ent.GetBossPlayer() == player )
	Assert( !player.IsDisconnected() )
	player.EndSignal( "Disconnected" )

	OnThreadEnd(
		function() : ( ent, player )
		{
			if ( IsAlive( ent ) )
				ent.Die( player, player, {} )
		}
	)

	ent.WaitSignal("OnDeath")
}

function HideName( ent )
{
	ent.SetNameVisibleToFriendly( false )
	ent.SetNameVisibleToEnemy( false )
	ent.SetNameVisibleToNeutral( false )
	ent.SetNameVisibleToOwner( false )
}

function HideNameToAllExceptOwner( ent )
{
	ent.SetNameVisibleToFriendly( false )
	ent.SetNameVisibleToEnemy( false )
	ent.SetNameVisibleToNeutral( false )
}

function ShowName( ent )
{
	ent.SetNameVisibleToFriendly( true )
	ent.SetNameVisibleToEnemy( true )
	ent.SetNameVisibleToNeutral( true )
	ent.SetNameVisibleToOwner( true )
}

function SimpleCanSeeEntity( ent, canSeeEntity )
{
	//NPC CanSee function only returns true if the entity is in the sight cone. This behaves more like player CanSee.
	local traceOrigin = ent.GetWorldSpaceCenter()
	if ( ent.GetClassname() == "player" )
	{
		traceOrigin = ent.EyePosition()
	}
	else
	{
		local eyeIndex = ent.LookupAttachment( "eyes" )
		if ( eyeIndex )
			traceOrigin = ent.GetAttachmentOrigin( eyeIndex )
	}

	local trace = TraceLine( traceOrigin, canSeeEntity.GetOrigin(), null, TRACE_MASK_NPCWORLDSTATIC, TRACE_COLLISION_GROUP_NONE )
	if ( trace.hitEnt != level.worldspawn )
		return true

	return false
}

// DEV function to toggle player view between the skybox and the real world.
function ToggleSkyboxView( scale = 0.001 )
{
	local player = GetEntByIndex( 1 )
	if ( !( "skyboxView" in player.s ) )
		player.s.skyboxView <- false

	local skyOrigin = GetEnt( "skybox_cam_level" ).GetOrigin()

	if ( !player.s.skyboxView )
	{
		if ( !player.IsNoclipping() )
		{
			ClientCommand( player, "noclip" )
			wait( 0.25 )
		}

		ClientCommand( player, "sv_noclipspeed 0.1" )
		player.s.skyboxView = true
		local offset = player.GetOrigin()
		offset *= scale

		player.SetOrigin( skyOrigin + offset - Vector( 0, 0, 60.0 - ( 60.0 * scale ) ) )
	}
	else
	{
		ClientCommand( player, "sv_noclipspeed 5" )
		player.s.skyboxView = false
		local offset = player.GetOrigin() - skyOrigin + Vector( 0, 0, 60.0 - ( 60.0 * scale ) )
		offset *= 1.0 / scale

		ClampToWorldspace( offset )

		player.SetOrigin( offset )
	}
}

function EMP_SlowPlayer( player, scale, duration )
{
	Assert( IsValid( player ) )

	player.EndSignal( "OnEMPPilotHit" )
	player.EndSignal( "OnDeath" )
	player.EndSignal( "Doomed" )
	player.EndSignal( "Disconnected" )

	player.SetMoveSpeedScale( scale )

	wait duration

	player.SetMoveSpeedScale( 1.0 )
}

function EmitSoundOnEntityToTeamExceptPlayer( ent, sound, team, excludePlayer )
{
	local players = GetPlayerArrayOfTeam( team )

	foreach ( player in players )
	{
		if ( player == excludePlayer )
			continue

		EmitSoundOnEntityOnlyToPlayer( ent, player, sound )
	}
}
function EmitSoundOnEntityToOpponents( ent, sound )
{
	foreach ( player in GetPlayerArray() )
	{
		if ( ShouldPreventFriendlyFire( ent, player ) )
			continue

		EmitSoundOnEntityOnlyToPlayer( ent, player, sound )
	}
}




function DamageRange( value, headShotMultiplier, health = 200 )
{
	printt( "Damage Range: ", value, headShotMultiplier )
	local playerHealth = health

	local bodyShot = value.tofloat()
	local headShot = value.tofloat() * headShotMultiplier.tofloat()

	local maxHeadshots = 0

	local simHealth = playerHealth
	while ( simHealth > 0 )
	{
		simHealth = (simHealth.tofloat() - headShot).tointeger()
		maxHeadshots++
	}

	printt( "HeadShots:    BodyShots:     Total:" )

	local simHealth = playerHealth
	local numHeadshots = 0
	while ( numHeadshots < maxHeadshots )
	{
		local simHealth = playerHealth
		for ( local hsIdx = 0; hsIdx < numHeadshots; hsIdx++ )
		{
			simHealth = (simHealth.tofloat() - headShot).tointeger()
		}

		local numBodyShots = 0
		while ( simHealth > 0 )
		{
			simHealth = (simHealth.tofloat() - bodyShot).tointeger()
			numBodyShots++
		}
		printt( format( "%i             %i              %i", numHeadshots, numBodyShots, numHeadshots + numBodyShots ) )
		numHeadshots++
	}

	printt( format( "%i             %i              %i", numHeadshots, 0, numHeadshots ) )
}


function GetWeaponDPS( vsTitan = false)
{
	local player = ppp()

	local weapon = player.GetActiveWeapon()

	local fire_rate = weapon.GetWeaponInfoFileKeyField( "fire_rate" )
	local burst_fire_count = weapon.GetWeaponInfoFileKeyField( "burst_fire_count" )
	local burst_fire_delay = weapon.GetWeaponInfoFileKeyField( "burst_fire_delay" )

	local damage_near_value = weapon.GetWeaponInfoFileKeyField( "damage_near_value" )
	local damage_far_value = weapon.GetWeaponInfoFileKeyField( "damage_far_value" )

	if ( vsTitan )
	{
		damage_near_value = weapon.GetWeaponInfoFileKeyField( "damage_near_value_titanarmor" )
		damage_far_value = weapon.GetWeaponInfoFileKeyField( "damage_far_value_titanarmor" )
	}

	if ( burst_fire_count )
	{
		local timePerShot = 1 / fire_rate
		local timePerBurst = (timePerShot * burst_fire_count) + burst_fire_delay
		local burstPerSecond = 1 / timePerBurst

		printt( timePerBurst )

		printt( "DPS Near", (burstPerSecond * burst_fire_count) * damage_near_value )
		printt( "DPS Far ", (burstPerSecond * burst_fire_count) * damage_far_value )
	}
	else
	{
		printt( "DPS Near", fire_rate * damage_near_value )
		printt( "DPS Far ", fire_rate * damage_far_value )
	}
}


function GetTTK( weaponRef )
{
	local fire_rate = GetWeaponInfoFileKeyField_Global( weaponRef, "fire_rate" ).tofloat()
	local burst_fire_count = GetWeaponInfoFileKeyField_Global( weaponRef, "burst_fire_count" )
	if ( burst_fire_count != null )
		burst_fire_count = burst_fire_count.tofloat()

	local burst_fire_delay = GetWeaponInfoFileKeyField_Global( weaponRef, "burst_fire_delay" )
	if ( burst_fire_delay != null )
		burst_fire_delay = burst_fire_delay.tofloat()

	local damage_near_value = GetWeaponInfoFileKeyField_Global( weaponRef, "damage_near_value" ).tointeger()
	local damage_far_value = GetWeaponInfoFileKeyField_Global( weaponRef, "damage_far_value" ).tointeger()

	local nearBodyShots = ceil( 200.0 / damage_near_value ) - 1
	local farBodyShots = ceil( 200.0 / damage_far_value ) - 1

	local delayAdd = 0
	if ( burst_fire_count && burst_fire_count < nearBodyShots )
		delayAdd += burst_fire_delay

	printt( "TTK Near", (nearBodyShots * (1 / fire_rate)) + delayAdd, " (" + (nearBodyShots + 1) + ")" )


	delayAdd = 0
	if ( burst_fire_count && burst_fire_count < farBodyShots )
		delayAdd += burst_fire_delay

	printt( "TTK Far ", (farBodyShots * (1 / fire_rate)) + delayAdd, " (" + (farBodyShots + 1) + ")" )
}


function GetChallengeXP()
{
	//local allChallenges = GetLocalChallengeTable()
	local allChallenges = level.challengeData
	local totalChallengeXP = 0
	local totalKillXP = 0

	printt( "Challenge XP Linked To Item Unlocks" )
	printt( "-----------------------------------" )

	foreach( challengeRef, val in allChallenges )
	{
		local cumulativeXP = 0

		local tiers = GetChallengeTierCount( challengeRef )

		local itemRewardTier = 0
		local xpRewards = [0, 0, 0, 0, 0, 0, 0, 0]

		for ( local tier = 0; tier < tiers; tier++ )
		{
			local xpReward = level.challengeXPRewardsForTier[ tier ]
			xpRewards[tier] = xpReward

			local itemReward = GetItemRewardForChallengeTier( challengeRef, tier )

			if ( !itemReward )
				continue

			itemRewardTier = tier
		}

		if ( !itemRewardTier )
			continue

		for ( local tier = 0; tier <= itemRewardTier; tier++ )
		{
			totalChallengeXP += xpRewards[tier]

			if ( tier < itemRewardTier )
				continue

			if ( level.challengeData[ challengeRef ].linkedStat.category != "weapon_kill_stats" )
				continue

			local pointValue = 0

			switch ( level.challengeData[ challengeRef ].linkedStat.alias )
			{
				case "pilots":
					pointValue = 100
					break
				case "grunts":
					pointValue = 10
					break
				case "spectres":
					pointValue = 25
					break
				case "total":
					// pilot   titan    npc
					// 242     64       855     1161
					// 100     200      18
					// 24200   12800    15390   52390
					pointValue = 45
					break
				case "titansTotal":
					pointValue = 200
					break
			}

			local numKills = level.challengeData[ challengeRef ].tierGoals[tier]
			local killXP = numKills * pointValue

			totalKillXP += killXP
			printt( challengeRef, killXP, numKills, level.challengeData[ challengeRef ].linkedStat.alias )
		}
	}

	printt( "Challenge Reward XP: ", totalChallengeXP )
	printt( "Challenge Kill XP: ", totalKillXP )
	printt( "Total Challenge XP: ", totalChallengeXP + totalKillXP )
	printt( "Max Level XP:", GetXPForLevel( MAX_LEVEL ), "(" + MAX_LEVEL + ")" )
}

const MUTESFXFADEIN 	= 5.0
const MUTESFXFADEOUT 	= 2.0
const MUTEALLFADEIN 	= 8.0
const MUTEALLFADEOUT 	= 2.0
function MuteSFX( player, time = MUTESFXFADEIN )
{
	Assert( IsPlayer( player ) )

	EmitSoundOnEntityOnlyToPlayerWithFadeIn( player, player, "FADE_OUT_ALL_BUT_MUSIC", time )
}

function UnMuteSFX( player, time = MUTESFXFADEOUT )
{
	Assert( IsPlayer( player ) )

	FadeOutSoundOnEntity( player, "FADE_OUT_ALL_BUT_MUSIC", time )
}

function MuteAll( player, time = MUTEALLFADEIN )
{
	Assert( IsPlayer( player ) )

	if ( "MuteAll" in player.s )
		return
	player.s.MuteAll <- 1

//	printt( "MuteAll", player, time )

	EmitSoundOnEntityOnlyToPlayerWithFadeIn( player, player, "FADE_OUT_ALL", time )
}

function UnMuteAll( player, time = MUTEALLFADEOUT )
{
	Assert( IsPlayer( player ) )

	if ( !( "MuteAll" in player.s ) )
		return
	delete player.s.MuteAll

//	printt( "UnMuteAll", player, time )

	FadeOutSoundOnEntity( player, "FADE_OUT_ALL", time )
}

function AllPlayersMuteAll( time = MUTEALLFADEIN )
{
	local players = GetPlayerArray()

	foreach ( player in players )
		MuteAll( player, time )
}

function AllPlayersUnMuteAll( time = MUTEALLFADEOUT )
{
	local players = GetPlayerArray()

	foreach ( player in players )
		UnMuteAll( player, time )
}

function AllPlayersMuteSFX( time = MUTESFXFADEIN )
{
	local players = GetPlayerArray()

	foreach ( player in players )
		MuteSFX( player, time )
}

function AllPlayersUnMuteSFX( time = MUTESFXFADEOUT )
{
	local players = GetPlayerArray()

	foreach ( player in players )
		UnMuteSFX( player, time )
}

function CheckEverythingUnlockedAchievement( player )
{
	Assert( IsServer() )

	if ( !IsValid( player ) || !player.IsPlayer() )
		return
	if ( player.IsBot() )
		return

	if ( player.GetPersistentVar( "ach_unlockEverything" ) )
		return

	foreach( item in allItems )
	{
		if ( item.type == itemType.TITAN_DECAL )
			continue

		if ( IsItemLocked( item.ref, item.childRef, player ) )
			return
	}

	player.SetPersistentVar( "ach_unlockEverything", true )
}

function GetWeaponModsFromDamageInfo( damageInfo )
{
	local weapon = damageInfo.GetWeapon()
	local inflictor = damageInfo.GetInflictor()
	local damageType = damageInfo.GetCustomDamageType()

	if ( IsValid( weapon ) )
	{
		return weapon.GetMods()
	}
	else if ( IsValid( inflictor ) )
	{
		if( "weaponMods" in inflictor.s && inflictor.s.weaponMods )
			return inflictor.s.weaponMods
		else if( inflictor.IsProjectile() )
			return inflictor.GetMods()
		else if ( damageType & DF_EXPLOSION && inflictor.IsPlayer() && IsValid( inflictor.GetActiveWeapon() ) )
			return inflictor.GetActiveWeapon().GetMods()
		//Hack - Splash damage doesn't pass mod weapon through. This only works under the assumption that offhand weapons don't have mods.
	}
	return []
}

function IsEvacDropship( ent )
{
	if ( !EvacEnabled() )
		return false

	return ent == level.dropship
}

function GetBurnCardWeaponTable( player, table, titan = null )
{
	OnPlayerSpawnedTryActivateBurnCard( player, table, titan )
	local cardRef = GetPlayerActiveBurnCard( player )
	local burnCardWeaponTable = null
	if ( cardRef )
	{
		if ( ShouldBurnCardGiveWeapon( cardRef, table, titan ) )
			burnCardWeaponTable = GetBurnCardWeapon( cardRef )
	}
	return burnCardWeaponTable
}


function TakeAmmoFromPlayer( player )
{
	local mainWeapons = player.GetMainWeapons()
	local offhandWeapons = player.GetOffhandWeapons()

	foreach ( weapon in mainWeapons )
	{
		weapon.SetWeaponPrimaryAmmoCount( 0 )
		weapon.SetWeaponPrimaryClipCount( 0 )
		printt( weapon )
	}

	foreach ( weapon in offhandWeapons )
	{
		weapon.SetWeaponPrimaryAmmoCount( 0 )
		weapon.SetWeaponPrimaryClipCount( 0 )
		printt( weapon )
	}
}


function NearFlagSpawnPoint( dropPoint )
{
	if ( "flagSpawnPoint" in level && IsValid( level.flagSpawnPoint ) )
	{
		local fspOrigin = level.flagSpawnPoint.GetOrigin()
		if ( Distance( fspOrigin, dropPoint ) < SAFE_TITANFALL_DISTANCE_CTF )
			return true
	}

	if ( "flagReturnPoint" in level && IsValid( level.flagReturnPoint ) )
	{
		local fspOrigin = level.flagReturnPoint.GetOrigin()
		if ( Distance( fspOrigin, dropPoint ) < SAFE_TITANFALL_DISTANCE_CTF )
			return true
	}

	if ( "flagSpawnPoints" in level )
	{
		foreach ( flagSpawnPoint in level.flagSpawnPoints )
		{
			if ( !IsValid( flagSpawnPoint ) )
				continue
			local fspOrigin = flagSpawnPoint.GetOrigin()
			if ( Distance( fspOrigin, dropPoint ) < SAFE_TITANFALL_DISTANCE_CTF )
				return true
		}
	}

	return false
}

function UpdateDailyVar( player, persistentVar )
{
	Assert( IsValid( player ) )
	Assert( IsPlayer( player ) )

	local savedTimeStamp = player.GetPersistentVar( persistentVar )
	local savedDay = Daily_GetDay( savedTimeStamp )
	local currentDay = Daily_GetDay()

	if ( savedDay < currentDay )
		player.SetPersistentVar( persistentVar, Daily_GetCurrentTime() )

	return savedDay < currentDay
}

function RandomizeBotLoadout( table, isTitan = false )
{
	local items
	local ref
	local refType

	// Primary
	refType = isTitan ? itemType.TITAN_PRIMARY : itemType.PILOT_PRIMARY
	items = GetAllItemsOfType( refType )
	ref = items[ rand() % items.len() ].ref
	table.primaryWeapon = ref
	table.primaryWeaponMods = []

	// Secondary
	if ( !isTitan )
	{
		refType = itemType.PILOT_SECONDARY
		items = GetAllItemsOfType( refType )
		ref = items[ rand() % items.len() ].ref
		table.secondaryWeapon = ref

		refType = itemType.PILOT_SIDEARM
		items = GetAllItemsOfType( refType )
		ref = items[ rand() % items.len() ].ref
		table.sidearmWeapon = ref
	}

	// Offhand/Ordnance
	refType = isTitan ? itemType.TITAN_ORDNANCE : itemType.PILOT_ORDNANCE
	items = GetAllItemsOfType( refType )
	ref = items[ rand() % items.len() ].ref
	table.offhandWeapons[0].weapon = ref
	table.offhandWeapons[0].mods = []

	// Special
	refType = isTitan ? itemType.TITAN_SPECIAL : itemType.PILOT_SPECIAL
	items = GetAllItemsOfType( refType )
	ref = items[ rand() % items.len() ].ref
	table.offhandWeapons[1].weapon = ref
	table.offhandWeapons[1].mods = []

	// Setfile
	refType = isTitan ? itemType.TITAN_SETFILE : itemType.PILOT_SETFILE
	items = GetAllItemsOfType( refType )
	ref = items[ rand() % items.len() ].ref
	table.playerSetFile = ref
}

function FindItemByName( type, itemName )
{
	local items = GetAllItemsOfType( type )
	foreach( item in items )
	{
		if ( item.ref == itemName )
		{
			return item
		}
	}
	return null
}

function OverrideBotLoadout( table, isTitan = false )
{
	if ( !isTitan )
	{
		// Pilot loadout overrides

		local bot_force_pilot_primary = GetConVarString( "bot_force_pilot_primary" )
		local bot_force_pilot_secondary = GetConVarString( "bot_force_pilot_secondary" )
		local bot_force_pilot_sidearm = GetConVarString( "bot_force_pilot_sidearm" )
		local bot_force_pilot_ordnance = GetConVarString( "bot_force_pilot_ordnance" )
		local bot_force_pilot_ability = GetConVarString( "bot_force_pilot_ability" )

		// Primary
		if ( FindItemByName( itemType.PILOT_PRIMARY, bot_force_pilot_primary ) )
		{
			table.primaryWeapon = bot_force_pilot_primary
			table.primaryWeaponMods = []
		}

		// Secondary
		if ( FindItemByName( itemType.PILOT_SECONDARY, bot_force_pilot_secondary ) )
			table.secondaryWeapon = bot_force_pilot_secondary

		// Sidearm
		if ( FindItemByName( itemType.PILOT_SIDEARM, bot_force_pilot_sidearm ) )
			table.sidearmWeapon = bot_force_pilot_sidearm

		// Ordnance/Offhand
		if ( FindItemByName( itemType.PILOT_ORDNANCE, bot_force_pilot_ordnance ) )
		{
			table.offhandWeapons[0].weapon = bot_force_pilot_ordnance
			table.offhandWeapons[0].mods = []
		}

		// Ability/Special
		if ( FindItemByName( itemType.PILOT_SPECIAL, bot_force_pilot_ability ) )
		{
			table.offhandWeapons[1].weapon = bot_force_pilot_ability
			table.offhandWeapons[1].mods = []
		}
	}
	else
	{
		// Titan loadout overrides

		local bot_force_titan_primary = GetConVarString( "bot_force_titan_primary" )
		local bot_force_titan_ordnance = GetConVarString( "bot_force_titan_ordnance" )
		local bot_force_titan_ability = GetConVarString( "bot_force_titan_ability" )

		// Primary
		if ( FindItemByName( itemType.TITAN_PRIMARY, bot_force_titan_primary ) )
		{
			table.primaryWeapon = bot_force_titan_primary
			table.primaryWeaponMods = []
		}

		// Ordnance/Offhand
		if ( FindItemByName( itemType.TITAN_ORDNANCE, bot_force_titan_ordnance ) )
		{
			table.offhandWeapons[0].weapon = bot_force_titan_ordnance
			table.offhandWeapons[0].mods = []
		}

		// Ability/Special
		if ( FindItemByName( itemType.TITAN_SPECIAL, bot_force_titan_ability ) )
		{
			table.offhandWeapons[1].weapon = bot_force_titan_ability
			table.offhandWeapons[1].mods = []
		}
	}
}

// for dev coop testing
function Coop_KillAllEnemies_MenuCall()
{
	if ( GameRules.GetGameMode() != COOPERATIVE )
		return

	Coop_KillAllEnemies()
}

function Coop_SetGeneratorGodMode_MenuCall()
{
	if ( GameRules.GetGameMode() != COOPERATIVE )
		return

	local doSet = true
	if ( Flag( "GeneratorGodMode" ) )
		doSet = false

	Coop_SetGeneratorGodMode( doSet )
}

function Coop_KillGenerator_MenuCall()
{
	if ( GameRules.GetGameMode() != COOPERATIVE )
		return

	Coop_DamageGenerator( 75000 )
}

function SaveDatePlayed( player )
{
	Assert( IsServer() )
	Assert( IsValid( player ) )
	Assert( IsPlayer( player ) )

	player.SetPersistentVar( "lastTimePlayed", Daily_GetCurrentTime() )
	if ( PlayerPlayingRanked( player ) )
		UpdateGemDecayTime( player )
}

function UpdateGemDecayTime( player )
{
	player.SetPersistentVar( "ranked.nextGemDecayTime", Daily_GetCurrentTime() + GetRankedDecayRate() )
}

function SaveDateLoggedIn( player )
{
	Assert( IsServer() )
	Assert( IsValid( player ) )
	Assert( IsPlayer( player ) )

	player.SetPersistentVar( "lastTimeLoggedIn", Daily_GetCurrentTime() )
}

function GetDaysInactive( player )
{
	return _GetDaysSinceVar( player, "lastTimePlayed" )
}

function GetDaysSinceLastLogin( player )
{
	return _GetDaysSinceVar( player, "lastTimeLoggedIn" )
}

function _GetDaysSinceVar( player, var )
{
	Assert( IsServer() )
	Assert( IsValid( player ) )
	Assert( IsPlayer( player ) )

	local storedTime = player.GetPersistentVar( var )
	local currentTime = Daily_GetCurrentTime()

	if ( storedTime <= 0 || currentTime <= storedTime )
		return 0

	local secondsElapsed = (currentTime - storedTime)

	return ( secondsElapsed / SECONDS_PER_DAY.tofloat() )
}

function CreateNewSpawnPoint( className, origin, angles )
{
	if ( !( "scriptCreatedSpawnPoints" in level ) )
		level.scriptCreatedSpawnPoints <- []

	if ( !( "scriptCreatedSpawnPointsIndex" in level ) )
		level.scriptCreatedSpawnPointsIndex <- -1

	local spawnpoint = CreateEntity( className )
	spawnpoint.SetOrigin( origin )
	spawnpoint.SetAngles( angles )
	DispatchSpawn( spawnpoint )

	level.scriptCreatedSpawnPoints.append( spawnpoint )
}

function TestSpawnPoint()
{
	if ( level.scriptCreatedSpawnPointsIndex < 0 )
		level.scriptCreatedSpawnPointsIndex = level.scriptCreatedSpawnPoints.len() - 1
	if ( level.scriptCreatedSpawnPointsIndex >= level.scriptCreatedSpawnPoints.len() )
		level.scriptCreatedSpawnPointsIndex = 0

	local spawnpoint = level.scriptCreatedSpawnPoints[ level.scriptCreatedSpawnPointsIndex ]

	GetPlayerArray()[ 0 ].SetOrigin( spawnpoint.GetOrigin() )
	GetPlayerArray()[ 0 ].SetAngles( spawnpoint.GetAngles() )

	printt( "Viewing spawnpoint " + ( level.scriptCreatedSpawnPointsIndex + 1 ) + "/" + level.scriptCreatedSpawnPoints.len() + " at org " + spawnpoint.GetOrigin() + " ang " + spawnpoint.GetAngles() )
}

function TestNextScriptSpawnPoint()
{
	level.scriptCreatedSpawnPointsIndex++
	TestSpawnPoint()
}

function TestPreviousScriptSpawnPoint()
{
	level.scriptCreatedSpawnPointsIndex--
	TestSpawnPoint()
}

function MoveSpawn( targetName, origin, angles )
{
	local ent = GetEnt( targetName )
	ent.SetOrigin( origin )
	ent.SetAngles( angles )
}

function DevGiveMapStars()
{
	if ( developer() <= 0 )
		return

	local player = GetPlayerArray()[0]
	local scoreReqs = GetStarScoreRequirements( "tdm", "mp_fracture" )
	player.SetPersistentVar( "mapStars[" + GetMapName() + "].previousBestScore[" + GameRules.GetGameMode() + "]", scoreReqs[0] )
	player.SetPersistentVar( "mapStars[" + GetMapName() + "].bestScore[" + GameRules.GetGameMode() + "]", scoreReqs[2] + 1 )
}


function DevCompleteDailies()
{
	// if ( developer() <= 0 )
	// 	return

	local player = GetPlayerArray()[0]
	local challengeRefs = GetPlayersStoredDailyChallenges( player )
	foreach( ref in challengeRefs )
	{
		printt( "completing daily challenge", ref )

		Assert( ref in level.challengeData )
		Assert( "linkedStat" in level.challengeData[ref] )

		local linkedStat = level.challengeData[ ref ].linkedStat
		local challengeGoal = GetGoalForChallengeTier( ref, 0 )
		printt( "goal", challengeGoal )
		printt( "linkedStat", linkedStat.category, linkedStat.alias )
		UpdatePlayerWeaponStat( player, linkedStat.category, linkedStat.alias, linkedStat.weapon, challengeGoal )
	}
}


function CheckMapStarAchievements( player )
{
	// Vars we increment to set achievements below
	local coopMapsWith2StarsOrMore = 0
	local threeStarsAwarded = 0
	local totalStarsEarned = 0

	// Loop through all the modes and maps and get the star counts
	local modeCount = PersistenceGetEnumCount( "gameModesWithStars" )
	local mapCount = PersistenceGetEnumCount( "maps" )
	local modeName
	local mapName
	local scoreReqs
	for ( local mode = 0 ; mode < modeCount ; mode++ )
	{
		modeName = PersistenceGetEnumItemNameForIndex( "gameModesWithStars", mode )
		//printt( modeName )
		for ( local map = 0 ; map < mapCount ; map++ )
		{
			mapName = PersistenceGetEnumItemNameForIndex( "maps", map )

			local starCount = GetStarsForScores( mapName, modeName, player ).now
			//printt( "    ", mapName )
			//printt( "        ", starCount )

			totalStarsEarned += starCount

			if ( modeName == COOPERATIVE && starCount >= 2 )
				coopMapsWith2StarsOrMore++

			if ( starCount >= 3 )
				threeStarsAwarded++
		}
	}

	// Earn at least 2 stars on 15 differnt maps in Frontier Defense
	player.SetPersistentVar( "cu8achievement.ach_twoStarCoopMaps", coopMapsWith2StarsOrMore )

	// Earn 3 Stars in a single map and mode
	if ( threeStarsAwarded > 0 )
		player.SetPersistentVar( "cu8achievement.ach_threeStarsAwarded", true )

	// Earn a Total of 50 Stars
	player.SetPersistentVar( "cu8achievement.ach_totalStarsEarned", totalStarsEarned )
}

function CheckTitanVoiceAchievement( player )
{
	local numVoices = PersistenceGetEnumCount( "titanOS" )
	local numVoicesUnlocked = 0
	local ref
	for ( local i = 0 ; i < numVoices ; i++ )
	{
		ref = PersistenceGetEnumItemNameForIndex( "titanOS", i )
		//printt( "ref:", ref )
		if ( !IsItemLocked( ref, null, player ) )
		{
			//printt( "  unlocked!" )
			numVoicesUnlocked++
		}
	}
	//printt( "Num unlocked:", numVoicesUnlocked )
	player.SetPersistentVar( "cu8achievement.ach_titanVoicePacksUnlocked", numVoicesUnlocked )
}

function CheckTitanDecalAchievement( player )
{
	local numDecals = PersistenceGetEnumCount( "titanDecals" )
	local numDecalsUnlocked = 0
	local ref
	for ( local i = 1 ; i < numDecals ; i++ )
	{
		ref = PersistenceGetEnumItemNameForIndex( "titanDecals", i )
		//printt( "ref:", ref )
		if ( !IsItemLocked( ref, null, player ) )
		{
			//printt( "  unlocked!" )
			numDecalsUnlocked++
		}
	}
	//printt( "Num unlocked:", numDecalsUnlocked )
	player.SetPersistentVar( "cu8achievement.ach_titanInsigniasUnlocked", numDecalsUnlocked )
}

function CheckDailyChallengeAchievement( player )
{
	if ( player.GetPersistentVar( "cu8achievement.ach_allDailyChallengesForDay" ) == true )
		return

	local maxRefs = PersistenceGetArrayCount( "activeDailyChallenges" )
	local todaysDailiesComplete = 0
	local today = Daily_GetDay()
	for ( local i = 0 ; i < maxRefs ; i++ )
	{
		local day = player.GetPersistentVar( "activeDailyChallenges[" + i + "].day" )
		if ( day != today )
			continue

		local ref = player.GetPersistentVar( "activeDailyChallenges[" + i + "].ref" )
		if ( !IsChallengeComplete( ref, player ) )
			continue

		todaysDailiesComplete++
	}

	if ( todaysDailiesComplete >= 3 )
		player.SetPersistentVar( "cu8achievement.ach_allDailyChallengesForDay", true )
}

// New implementation of GetPlayerSettingsFieldForClassName with debug prints
function GetPlayerSettingsFieldForClassName(className, field)
{
    // printt("[GetPlayerSettingsFieldForClassName] Called with className='" + className + "', field='" + field + "'");

    // Handle "bodymodel_imc" lookup unchanged
    if (field == "bodymodel_imc")
    {
        local originalValue = OldPlayerSettingsFieldForClassName(className, "bodymodel_imc");
        // printt("[GetPlayerSettingsFieldForClassName] Returning original 'bodymodel_imc': '" + originalValue + "'");
        return originalValue;
    }
    // Handle "bodymodel_militia" by modifying the "bodymodel_imc" value
    else if (field == "bodymodel_militia")
    {
        // Retrieve the original "bodymodel_imc" value
        local originalModel = OldPlayerSettingsFieldForClassName(className, "bodymodel_imc");

        // Check if the original model was successfully retrieved
        if (!originalModel)
        {
            return null;
        }

        // Replace all instances of "imc_" with "mcor_"
        local modifiedModel = StringReplaceAll(originalModel, "imc_", "mcor_");

		if ( StringContains( modifiedModel, "mcor_spectre" ) )
        	modifiedModel = StringReplaceAll(originalModel, "mcor_spectre", "mcor_spectre_assault"); // fix Militia spectres

        return modifiedModel;
    }
    // For all other fields, delegate to the original function unchanged
    else
    {
        local originalValue = OldPlayerSettingsFieldForClassName(className, field);
        // printt("[GetPlayerSettingsFieldForClassName] Returning original '" + field + "': '" + originalValue + "'");
        return originalValue;
    }
}
function IsCoopMatch() {
	return GetConVarInt("sv_lobbytype") == 1 && GetCurrentPlaylistName() == "coop"
}

// This runs when the player is 100% about to get auto-balanced, but before that actually happens
// So, for example, if the player is carrying the CTF flag, they drop it *before* changing teams and completely messing up the flag entity
function AddCallback_OnPreAutoBalancePlayer( callbackFunc )
{
	Assert( "onPreAutoBalanceCallbacks" in level )
	Assert( type( this ) == "table", "AddCallback_OnPreAutoBalancePlayer can only be added on a table. " + type( this ) )
	AssertParameters( callbackFunc, 3, "player, currentTeam, otherTeam" )

	local callbackInfo = {}
	callbackInfo.func <- callbackFunc
	callbackInfo.scope <- this

	level.onPreAutoBalanceCallbacks.append( callbackInfo )
}

// Runs *after* the player is auto-balanced
function AddCallback_OnPostAutoBalancePlayer( callbackFunc )
{
	Assert( "onPostAutoBalanceCallbacks" in level )
	Assert( type( this ) == "table", "AddCallback_OnPostAutoBalancePlayer can only be added on a table. " + type( this ) )
	AssertParameters( callbackFunc, 3, "player, oldTeam, newTeam" )

	local callbackInfo = {}
	callbackInfo.func <- callbackFunc
	callbackInfo.scope <- this

	level.onPostAutoBalanceCallbacks.append( callbackInfo )
}

function SetSignalDelayed( entity, signal, delay )
{
	entity.EndSignal( signal ) // so that if we call this again with the same signal on the same ent we won't get multiple signal events.

	wait delay
	if ( IsValid( entity ) )
		Signal( entity, signal )
}

function SetWeaponSkinForTeam( weapon, team )
{
	if ( team == TEAM_MILITIA )
		weapon.SetWeaponSkin( 1 )
	else
		weapon.SetWeaponSkin( 0 )
}

function ChangeWeaponSkin( entity, team )
{
	local name = entity.IsPlayer() ? entity.GetPlayerName() : entity.GetName()
	printt( "ChangeWeaponSkin: Setting team skins for entity: " + name )

	if ( HasSoul( entity ) )
	{
		local soul = entity.GetTitanSoul()

		local leftRocketPod = soul.rocketPod.model
		if ( IsValid( leftRocketPod ) )
		{
			//printt( "Setting team for left rocket pod" )
			SetSkinForTeam( leftRocketPod, team )
		}

		local shouldTurret = soul.shoulderTurret.model
		if ( IsValid( shouldTurret ) )
		{
			//printt( "Setting team for shoulder turret" )
			SetSkinForTeam( shouldTurret, team )
		}

		local chargeCannon = soul.chargeCannon.model
		if ( IsValid( chargeCannon ) )
		{
			//printt( "Setting team for shoulder turret" )
			SetSkinForTeam( chargeCannon, team )
		}
	}

	local weaponsArray = entity.GetMainWeapons()
	weaponsArray.extend( entity.GetOffhandWeapons() )

	foreach( weapon in weaponsArray )
	{
		if ( weapon )
		{
			SetWeaponSkinForTeam( weapon, team )
		}
	}
}

function AddCallback_OnWeaponAttack( callbackFunc )
{
    Assert( "onWeaponAttackCallbacks" in level )
	Assert( type( this ) == "table", "AddCallback_OnWeaponAttack can only be added on a table. " + type( this ) )

	local name = FunctionToString( callbackFunc )
    Assert( !( name in level.onWeaponAttackCallbacks ), "Already added " + name + " with AddCallback_OnPlayerRespawned" )

	local callbackInfo = {}
	callbackInfo.name <- name
	callbackInfo.func <- callbackFunc
	callbackInfo.scope <- this

	level.onWeaponAttackCallbacks[name] <- callbackInfo
}

function SetPlayerSetFile( player, classSettings )
{
	if ( !IsValid( player ) )
		return

	if ( !IsAlive( player ) )
		return

	player.SetPlayerSettings( classSettings )

	local team = player.GetTeam()
	local isTitan = player.IsTitan()
	if ( !isTitan )
		player.SetPlayerPilotSettings( classSettings )

	local modelFieldName = "bodymodel_imc"
	if ( team == TEAM_MILITIA )
		modelFieldName = "bodymodel_militia"

	local correctModelName = GetPlayerSettingsFieldForClassName( classSettings, modelFieldName )
	if ( correctModelName != null && correctModelName != "" )
	{
		player.SetModel( correctModelName )

		local skin = 0 // Assuming non-female models use skin 0 regardless of team, adjust if needed
		if ( classSettings.find( "female" ) != null || isTitan )
			skin = team == TEAM_MILITIA ? 1 : 0

		player.SetSkin( skin )

		RandomizeHead( player )
	}
	else
	{
		printt( "WARNING - Could not determine correct model name for player " + player + " using playerSetFile '" + classSettings + "' and field '" + modelFieldName + "'" )
	}
}

// Based on: https://github.com/p2r3/ppmod/blob/f4dc3f80a0ee0bc60bbd672a7667d72702bdbb44/ppmod.nut#L2080
// DO NOT use CreateBrush to create collision blockers, theyre not predicted properly
function CreateBrush( origin, angles, size, type = "func_brush", name = "" )
{
	if ( size.x < 0.0 || size.y < 0.0 || size.z < 0.0 )
		throw "brush: Size must be positive on all axis"

	local brush = CreateEntity( type )

	if ( name != "" )
		brush.SetName( name )
	else
		brush.SetName( UniqueString( type ) )

	if ( origin )
	{
		// hack: Setting origin twice. SetOrigin needs to happen before DispatchSpawn, otherwise the prop may not touch triggers
		brush.SetOrigin( origin )
		if ( angles )
			brush.SetAngles( angles )
	}
	DispatchSpawn( brush )
	if ( origin )
	{
		// hack: Setting origin twice. SetOrigin needs to happen after DispatchSpawn, otherwise origin is snapped to nearest whole unit
		brush.SetOrigin( origin )
		if ( angles )
			brush.SetAngles( angles )
	}

	// Make the brush solid and rotatable
	brush.SetValueForKey( "Solid", 3 )
	// Scale the bounding box of the brush, centered on its origin
	brush.SetSize( Vector() - size, size )

	brush.s.size <- size

	if ( !( "scriptCreatedBrushes" in level ) )
		level.scriptCreatedBrushes <- []

	level.scriptCreatedBrushes.append( brush )
	brush.ConnectOutput( "OnDestroy", RemoveScriptBrush )

	//DebugDrawBox( origin, Vector() - size, size, 255, 0, 0, 1, 6 )

	return brush
}

function CreateTrigger( origin, angles, size, type = "trigger_multiple", name = "" )
{
	local trigger = CreateBrush( origin, angles, size, type )

	// Make the trigger non-solid
	trigger.SetValueForKey( "CollisionGroup", 21 )
	// Turn on activation by clients by default
	trigger.SetValueForKey( "SpawnFlags", 1 )

	EntFireByHandle( trigger, "Enable", "", 0.0, null, null )

	// If this is a trigger_once, make it disappear upon activation
	if ( type == "trigger_once" )
		trigger.AddOutput( "OnStartTouch", "!self", "Kill" )

	return trigger
}

function CreateTriggerOutOfBounds( origin, angles, size, name = "" )
{
	local trigger = CreateTrigger( origin, angles, size, "trigger_out_of_bounds", name )
	trigger.ConnectOutput( "OnStartTouch", EntityOutOfBounds )
	trigger.ConnectOutput( "OnEndTouch", EntityBackInBounds )

	return trigger
}

// damageSource can be either: "fall" "splat" "burn" or "submerged" <- this doesnt seem to work properly
function CreateTriggerHurt( origin, angles, size, damage = 0, damageSource = "", name = "" )
{
	local trigger = CreateTrigger( origin, angles, size, "trigger_hurt", name )
	trigger.SetValueForKey( "damage", damage )
	trigger.SetValueForKey( "damageSourceName", damageSource )

	InitDamageTriggers( trigger )

	return trigger
}

function CreateTriggerCapturePoint( origin, angles, size, name = "" )
{
	local trigger = CreateTrigger( origin, angles, size, "trigger_capture_point", name )
	return trigger
}

function CreateTriggerIndoors( origin, angles, size, name = "" )
{
	local trigger = CreateTrigger( origin, angles, size, "trigger_indoor_area", name )
	return trigger
}

function RemoveScriptBrush( trigger, entity, caller, value )
{
	ArrayRemove( level.scriptCreatedBrushes, trigger )
}

function ShowScriptCreatedBrushes( duration = 5.0 )
{
	if ( !( "scriptCreatedBrushes" in level ) )
		return

	foreach( brush in level.scriptCreatedBrushes )
	{
		DebugDrawBox( brush.GetOrigin(), Vector() - brush.s.size, brush.s.size, 255, 0, 0, 1, duration )
	}
}
