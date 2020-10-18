import QtQuick 2.0
import QtQuick.Controls 2.15

import "components"
import "examples"

Item {
    width: parent.width
    height: parent.height

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
            text: "Round Controls"
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
        anchors.left: parent.left
        anchors.topMargin: 0
        anchors.leftMargin: 20
        contentWidth: parent.width - 40
        contentHeight: parent.height - header.height - footer.height
        clip: true

        GridView {
            id: controlsGrid
            anchors.fill: parent

            cellWidth: (parent.width - 10) / 2;
            cellHeight: (parent.width - 10) / 2;

            model: RoundControlsModel { id: roundControlsModel }
            delegate: Item {
                width: parent.width
                height: parent.height

                Column
                {
                    Image {
                        source: icon;
                        anchors.horizontalCenter: parent.horizontalCenter;
                        horizontalAlignment: Image.AlignHCenter
                        width: (controlsGrid.cellWidth - 25) * 0.9
                        height: (controlsGrid.cellWidth - 25) * 0.9
                    }
                    Text {
                        text: name;
                        anchors.horizontalCenter: parent.horizontalCenter;
                        horizontalAlignment: Text.AlignHCenter
                        width: controlsGrid.cellWidth
                        height: 25
                        wrapMode: Text.Wrap
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        let type = 'Round' + name.replace(/ /g,'') + 'Examples.qml';
                        console.log(type);

                        roundControlsExamplesPage.loader.source = "qrc:/examples/" + type;

                        mainLayout.currentIndex = 4;
                    }
                }
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
            id: menuImage
            width: 48
            height: 48
            anchors.verticalCenter: footer.verticalCenter
            anchors.horizontalCenter: footer.horizontalCenter

            source: "qrc:/icons/menu.png"

            MouseArea {
                anchors.fill: menuImage
                onClicked: mainLayout.currentIndex = 0;
            }
        }
    }
}
