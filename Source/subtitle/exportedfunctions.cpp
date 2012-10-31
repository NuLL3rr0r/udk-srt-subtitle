#include <windows.h>
#include <utils.h>
#include "exportedfunctions.hpp"
#include "subtitleloader.hpp"

using namespace GameSubtitleLoader;

SubtitleLoader subtitleLoaderObject;

extern "C"
{
	__declspec(dllexport) UBOOL FetchSubtitle(const wchar_t *id, struct SubtitleStruct *out_subtitle)
	{
		return subtitleLoaderObject.FetchSubtitle(wstrtostr(id), out_subtitle);
	}
}

