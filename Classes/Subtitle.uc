class Subtitle extends Object
	dependson( SubtitleLoader );

var public string ID;
var public SubtitleStruct Data;

static function GSSubtitle Load( coerce string _subtitleID )
{
	local GSSubtitleLoader subtitleLoader;
	local GSSubtitle newSubtitle;
	local bool isParsedSuccessfully;

	newSubtitle = new class'GSSubtitle';
	newSubtitle.ID = _subtitleID;

	subtitleLoader = new class'GSFramework.GSSubtitleLoader';

	isParsedSuccessfully = subtitleLoader.FetchSubtitle( newSubtitle.ID, newSubtitle.Data );
 	if ( isParsedSuccessfully )
		`STATIC_LOG_INFO( "Subtitle '" $ _subtitleId $ "' loaded successfully!", "SubtitleLoader" );
	else
		`STATIC_LOG_ERROR( "Failed to load subtitle '" $ _subtitleId $ "'!", "SubtitleLoader" );

	return newSubtitle;
}

DefaultProperties
{
}
