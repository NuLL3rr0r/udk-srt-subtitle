#ifndef EXPORTEDFUNCTIONS_HPP
#define EXPORTEDFUNCTIONS_HPP


#include "subtitledata.hpp"

extern "C"
{
	__declspec(dllexport) UBOOL FetchSubtitle(const wchar_t *id, struct SubtitleStruct *out_subtitle);
}


#endif /* EXPORTEDFUNCTIONS_HPP */


