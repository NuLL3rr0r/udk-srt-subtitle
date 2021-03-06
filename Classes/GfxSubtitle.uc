class GfxSubtitle extends GfxMoviePlayer;

///////////////////////////////////////////////////////////////////////////////
// = PreProcessor Directives =
///////////////////////////////////////////////////////////////////////////////



///////////////////////////////////////////////////////////////////////////////
// = Constants =
///////////////////////////////////////////////////////////////////////////////



///////////////////////////////////////////////////////////////////////////////
// = Properties =
///////////////////////////////////////////////////////////////////////////////



///////////////////////////////////////////////////////////////////////////////
// = Fields =
///////////////////////////////////////////////////////////////////////////////



///////////////////////////////////////////////////////////////////////////////
// = Delegates =
///////////////////////////////////////////////////////////////////////////////

delegate OnSubTitleRaised( string id, string text );
delegate OnSubTitleTimedOut( string id, string text );
delegate OnSubtitlePlayingStarted( string id );
delegate OnSubtitlePlayingInterrupted( string id );
delegate OnSubtitlePlayingFinished( string id );


///////////////////////////////////////////////////////////////////////////////
// = Forward Declerations =
///////////////////////////////////////////////////////////////////////////////



///////////////////////////////////////////////////////////////////////////////
// = Event Handlers =
///////////////////////////////////////////////////////////////////////////////

function OnUiSubTitleRaised( string id, string text )
{
	if( OnSubTitleRaised != none )
		OnSubTitleRaised( id, text );
}

function OnUiSubTitleTimedOut( string id, string text )
{
	if( OnSubTitleTimedOut != none )
		OnSubTitleTimedOut( id, text );
}

function OnUiSubtitlePlayingStarted( string id )
{
	if( OnSubtitlePlayingStarted != none )
		OnSubtitlePlayingStarted( id );
}

function OnUiSubtitlePlayingInterrupted( string id )
{
	if( OnSubtitlePlayingInterrupted != none )
		OnSubtitlePlayingInterrupted( id );
}

function OnUiSubtitlePlayingFinished( string id )
{
	if( OnSubtitlePlayingFinished != none )
		OnSubtitlePlayingFinished( id );
}


///////////////////////////////////////////////////////////////////////////////
// = Public Methods =
///////////////////////////////////////////////////////////////////////////////



///////////////////////////////////////////////////////////////////////////////
// = ActionScript Methods =
//////////////////////////////////////////////////////////////////////////////

function AS_Clear()
{
	local ASValue p;
	local array<ASValue> params;
	p.Type = AS_Null;
	params[0] = p;
	GetFlashObject().Invoke( "Clear", params );
}

function AS_FillSubtitlesData( string id, string deltaTimes, string dialogs )
{
	local ASValue p;
	local array<ASValue> params;

	p.Type = AS_String;
	p.s = id;
	params[0] = p;

	p.Type = AS_String;
	p.s = deltaTimes;
	params[1] = p;

	p.Type = AS_String;
	p.s = dialogs;
	params[2] = p;

	GetFlashObject().Invoke( "FillSubtitlesData", params );
}

function AS_PlaySubtitles()
{
	local ASValue p;
	local array<ASValue> params;
	p.Type = AS_Null;
	params[0] = p;
	GetFlashObject().Invoke( "PlaySubtitles", params );
}


///////////////////////////////////////////////////////////////////////////////
// = Protected Methods =
///////////////////////////////////////////////////////////////////////////////



///////////////////////////////////////////////////////////////////////////////
// = Private Methods =
///////////////////////////////////////////////////////////////////////////////



///////////////////////////////////////////////////////////////////////////////
// = Interface Implementation =
///////////////////////////////////////////////////////////////////////////////



///////////////////////////////////////////////////////////////////////////////
// = Base Class Overrides =
///////////////////////////////////////////////////////////////////////////////



///////////////////////////////////////////////////////////////////////////////
// = Debug Methods =
///////////////////////////////////////////////////////////////////////////////



///////////////////////////////////////////////////////////////////////////////
// = State Definitions =
///////////////////////////////////////////////////////////////////////////////



///////////////////////////////////////////////////////////////////////////////
// Default Values
///////////////////////////////////////////////////////////////////////////////

DefaultProperties
{
	MovieInfo = SwfMovie'gs_subtitle.gs_subtitle'
}

