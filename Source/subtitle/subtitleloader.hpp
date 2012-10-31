#ifndef SUBTITLELOADER
#define SUBTITLELOADER


#include <string>
#include "subtitledata.hpp"

namespace GameSubtitleLoader {
    class SubtitleLoader;
}

class GameSubtitleLoader::SubtitleLoader
{
private:
	std::string m_subtitlesDirectoryPath;

public:
	SubtitleLoader();
    ~SubtitleLoader();

public:
	bool FetchSubtitle(const std::string &id, struct SubtitleStruct *out_subtitle);
};


#endif /* SUBTITLELOADER */

