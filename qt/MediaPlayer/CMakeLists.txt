cmake_minimum_required(VERSION 3.16)

project(MediaPlayer VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)
find_package(Qt6 REQUIRED COMPONENTS LinguistTools)

# qt_standard_project_setup(REQUIRES 6.5 I18N_TRANSLATED_LANGUAGES en_US)
qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(appMediaPlayer
    main.cpp
)

qt_add_qml_module(appMediaPlayer
    URI MediaPlayer
    VERSION 1.0
    QML_FILES
        Main.qml SwitchButton.qml ButtonControl.qml

    RESOURCES
    assets/icons/android-chrome-192x192.png
    assets/icons/android-chrome-512x512.png
    assets/icons/apple-touch-icon.png
    assets/icons/favicon-16x16.png
    assets/icons/favicon-32x32.png
    assets/icons/favicon.ico
    assets/icons/site.webmanifest

    # Ảnh media player
    assets/img/background.png
    assets/img/Bui-Anh-Tuan.png
    assets/img/center_point.png
    assets/img/Ha-Anh-Tuan.png
    assets/img/hold.png
    assets/img/hold-next.png
    assets/img/hold-pause.png
    assets/img/hold-play.png
    assets/img/hold-prev.png
    assets/img/Hongkong1.png
    assets/img/music.png
    assets/img/next.png
    assets/img/pause.png
    assets/img/pho-khong-mua.png
    assets/img/play.png
    assets/img/playing.png
    assets/img/playlist.png
    assets/img/playlist_item.png
    assets/img/point.png
    assets/img/prev.png
    assets/img/progress_bar.png
    assets/img/progress_bar_bg.png
    assets/img/repeat.png
    assets/img/repeat1_hold.png
    assets/img/shuffle.png
    assets/img/shuffle-1.png
    assets/img/title.png
    assets/img/USB-Music.png
    assets/img/angle-left-solid.png
    assets/img/bars-solid.png
    assets/img/vietnam.png
    assets/img/united-states.png

    # Files Âm nhạc
    # assets/musics/Chuyen-Cua-Mua-Dong-Ha-Anh-Tuan.mp3
    # assets/musics/Hongkong1-Official-Version-Nguyen-Trong-Tai-San-Ji-Double-X.mp3
    # assets/musics/Pho-Khong-Mua-Duong-Truong-Giang-ft-Bui-Anh-Tuan.mp3

    # Files đa ngôn ngữ
    translations/lang_en_US.qm
    translations/lang_vi_VN.qm
    SOURCES LanguageManager.h LanguageManager.cpp
)

# Cấu hình dịch
# qt_add_translations(appMediaPlayer
#     TS_FILE_BASE qml
#     TS_FILE_DIR i18n
#     RESOURCE_PREFIX qt/qml/appMediaPlayer/i18n
#     LRELEASE_OPTIONS -idbased
# )

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appMediaPlayer PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appMediaPlayer
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appMediaPlayer
    PRIVATE Qt6::Quick
)

include(GNUInstallDirs)
install(TARGETS appMediaPlayer
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
