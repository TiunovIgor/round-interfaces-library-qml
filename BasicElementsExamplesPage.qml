import QtQuick 2.0
import QtQuick.Controls 2.1
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.12

import "components"

Item {
    id: page

    width: parent.width
    height: parent.height

    property alias loader: examplesLoader
    property alias caption: headerText.text

    Label {
        id: header
        width: parent.width
        height: 50
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        background: Rectangle {
            anchors.fill: parent
            border.width: 1
            border.color: '#666';
            color: 'transparent';
        }
        Text {
            id: headerText
            font.family: "Open Sans"
            font.pointSize: 20
            anchors.centerIn: parent
            horizontalAlignment: Text.AlignHCenter
        }
    }

    Flickable {
        id: flick
        width: parent.width - 40
        height: parent.height - header.height - footer.height
        anchors.top: header.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 0
        contentWidth: parent.width - 40
        clip: true

        Loader {
            id: examplesLoader
            anchors.fill: parent
            anchors.top: flick.top
            anchors.topMargin: 20
            anchors.bottomMargin: 20
            width: flick.width

            onLoaded: {
                caption = item.caption
                flick.contentHeight = item.implicitHeight + 40
            }
        }

        ScrollBar.vertical: ScrollBar { }
    }

    Item {
        id: footer
        width: parent.width
        height: 50
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter

        Rectangle {
            width: parent.width
            height: parent.height
            anchors.fill: parent
            border.width: 1
            border.color: '#666';
            color: '#eee';
        }

        Image {
            id: backImage
            width: 48
            height: 48
            anchors.verticalCenter: footer.verticalCenter
            anchors.left: footer.left

            source: "qrc:/icons/back.png"

            MouseArea {
                anchors.fill: backImage
                onClicked: {
                    mainLayout.currentIndex = 1;
                }
            }
        }
    }
}
