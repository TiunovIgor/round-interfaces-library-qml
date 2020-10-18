QT += quick webview svg

VERSION = 1.0

CONFIG += c++11

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
        main.cpp

RESOURCES += qml.qrc \
    fonts.qrc \
    fonts.qrc \
    svg.qrc \
    svg.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

readme.files += readme.html readme.ru.html
readme.path = /assets
INSTALLS += readme

docs.files += docs/*.*
docs.path = /assets/docs
INSTALLS += docs

docs_ru.files += docs/ru/*.*
docs_ru.path = /assets/docs/ru
INSTALLS += docs_ru

docs_images.files += docs/images/*.*
docs_images.path = /assets/docs/images
INSTALLS += docs_images

sounds.files += sounds/*.*
sounds.path = /assets/sounds
INSTALLS += sounds
