QT += quick multimedia multimediawidgets dbus xml core
CONFIG += c++17
DBUS_INTERFACES += Dbus/climate.xml
# The following define makes your compiler emit warnings if you use
# any Qt feature that has been marked deprecated (the exact warnings
# depend on your compiler). Refer to the documentation for the
# deprecated API to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        App/Climate/climatemodel.cpp \
        App/Media/player.cpp \
        App/Media/playlistmodel.cpp \
        applicationitem.cpp \
        applicationsmodel.cpp \
        climate.cpp \
        main.cpp \
        xmlreader.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    App/Climate/climatemodel.h \
    App/Media/player.h \
    App/Media/playlistmodel.h \
    applicationitem.h \
    applicationsmodel.h \
    climate.h \
    xmlreader.h

LIBS += -ltag

DISTFILES += \
    Dbus/climate.xml \
    applications.xml

# Sao chép thư mục Musics vào thư mục build
copy_music.commands = $(COPY_DIR) $$PWD/Musics $$OUT_PWD
first.depends = $(first) copy_music
QMAKE_EXTRA_TARGETS += first copy_music
