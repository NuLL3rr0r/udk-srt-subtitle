class GSSubtitleLoader extends Object
	DLLBind(subtitle_loader);

struct SubtitleStruct
{
	var string DeltaTimes;
	var string Dialogs;
};

dllimport final function bool FetchSubtitle(string id, out SubtitleStruct out_subtitle);


DefaultProperties
{
}

