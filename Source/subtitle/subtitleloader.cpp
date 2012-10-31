#include <codecvt>
#include <fstream>
#include <locale>
#include <shlobj.h>
#include <windows.h>
#include <boost/algorithm/string.hpp>
#include <boost/filesystem/exception.hpp>
#include <boost/filesystem/operations.hpp>
#include <boost/filesystem/path.hpp>
#include <boost/format.hpp>
#include <boost/lexical_cast.hpp>
#include <system.hpp>
#include "subtitleloader.hpp"

using namespace std;
using namespace boost;
using namespace GameSubtitleLoader;

namespace FS = boost::filesystem;

SubtitleLoader::SubtitleLoader()
{
	//Log::Initialize("SubtitleLoader");

	m_subtitlesDirectoryPath = System::GetGameFolderPath(System::EGameFolder_Subtitles);
	if (!algorithm::ends_with(m_subtitlesDirectoryPath, System::DirectorySeparatorChar()))
		m_subtitlesDirectoryPath += System::DirectorySeparatorChar();

	//NOTICE("SubtitleLoader Initialized!");
}

SubtitleLoader::~SubtitleLoader()
{
}

bool SubtitleLoader::FetchSubtitle(const string &id, struct SubtitleStruct *out_subtitle)
{
	const string subtitleFilePath((format("%1%%2%.srt") % m_subtitlesDirectoryPath % id).str());

	wstring deltaTimes;
	wstring dialogs;

	if (FS::exists(subtitleFilePath)) {
		const std::codecvt_utf8<wchar_t> *converter = new std::codecvt_utf8<wchar_t>;
	    const std::locale utf8Locale = std::locale(std::locale::empty(), converter);

		wifstream file(subtitleFilePath);
		file.imbue(utf8Locale);

		if (file.is_open()) {
			bool insertedFirstDeltaElement = false;
			bool insertedFirstDialogElement = false;
			bool foundId = false;
			bool foundTime = false;
			bool foundDialog = false;

			float lastEndTotal = 0.0f;

			while (file.good()) {
				wstring line;
				getline(file, line);

				wstring trimmedLine = algorithm::trim_copy(line);

				if (!foundId) {
					if (trimmedLine.size() != 0) {
						try {
							int id = lexical_cast<int>(trimmedLine);
							foundId = true;
							continue;
						}
						catch(...) {
							//MessageBoxA(0, (format("Parse Error for '%1%' !!") % subtitleFilePath).str().c_str(), "Parse Error", MB_OK);
							//ERR((format("Parse Error for '%1%' !!") % subtitleFilePath).str());
							return false;
						}
					}
				} else {
					if (!foundTime) {
						vector<string> times;
						iter_split(times, trimmedLine, first_finder("-->"));
						if (times.size() == 2) {
							float delta = 0.0f;
							try {
								string startTime = algorithm::trim_copy(times[0]);
								string endTime = algorithm::trim_copy(times[1]);

								float h1 = lexical_cast<float>(startTime.substr(0, 2)) * 3600.0f;
								float m1 = lexical_cast<float>(startTime.substr(3, 2)) * 60.0f;
								float s1 = lexical_cast<float>(startTime.substr(6, 2));
								float ms1 = lexical_cast<float>("0." + startTime.substr(9, 3));

								float h2 = lexical_cast<float>(endTime.substr(0, 2)) * 3600.0f;
								float m2 = lexical_cast<float>(endTime.substr(3, 2)) * 60.0f;
								float s2 = lexical_cast<float>(endTime.substr(6, 2));
								float ms2 = lexical_cast<float>("0." + endTime.substr(9, 3));

								float total1 = h1 + m1 + s1 + ms1;
								float total2 = h2 + m2 + s2 + ms2;

								delta = total2 - total1;

								if (!insertedFirstDeltaElement && total1 > 0.0f) {
									deltaTimes = lexical_cast<wstring>(total1);
									dialogs = L"";
									insertedFirstDeltaElement = true;
									insertedFirstDialogElement = true;
								} else {
									deltaTimes += L"|" + lexical_cast<wstring>(total1 - lastEndTotal);
									dialogs += L"|";
								}

								lastEndTotal = total2;
								if (lastEndTotal <= 0.0f )
									lastEndTotal = 0.1f;
							}
							catch(...) {
								//MessageBoxA(0, (format("Parse Error for '%1%' !!") % subtitleFilePath).str().c_str(), "Parse Error", MB_OK);
								//ERR((format("Parse Error for '%1%' !!") % subtitleFilePath).str());
								return false;
							}

							if (insertedFirstDeltaElement)
								deltaTimes += wstring(L"|");
							else
								insertedFirstDeltaElement = true;

							deltaTimes += lexical_cast<wstring>(delta);
							foundTime = true;
						} else {
							//MessageBoxA(0, (format("Parse Error for '%1%' !!") % subtitleFilePath).str().c_str(), "Parse Error", MB_OK);
							//ERR((format("Parse Error for '%1%' !!") % subtitleFilePath).str());
							return false;
						}
					} else {
						if (!foundDialog) {
							if (insertedFirstDialogElement)
								dialogs += wstring(L"|");
							else
								insertedFirstDialogElement = true;

							dialogs += trimmedLine;
							foundDialog = true;
						} else {
							if (trimmedLine.size() != 0) {
								dialogs += (L"\n" + trimmedLine);
							} else {
								foundDialog = false;
								foundTime = false;
								foundId = false;
							}
						}
					}
				}
			}
			file.close();
		} else {
			//MessageBoxA(0, (format("Unable to open subtitle file '%1%' !!") % subtitleFilePath).str().c_str(), "IO Error", MB_OK);
			//ERR((format("IO Error: Unable to open subtitle file '%1%' !!") % subtitleFilePath).str());
			return false;
		}
	} else {
		//MessageBoxA(0, (format("Subtitle file '%1%' not found !!") % subtitleFilePath).str().c_str(), "IO Error", MB_OK);
		//ERR((format("IO Error: Subtitle file '%1%' not found !!") % subtitleFilePath).str());
		return false;
	}

	out_subtitle->DeltaTimes = deltaTimes;
	out_subtitle->Dialogs = dialogs;

	//NOTICE((format("Subtitle file '%1%', loaded successfully.") % subtitleFilePath).str());

	return true;
}


