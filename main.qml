import QtQuick 2.15
import QtQuick.Controls 2.12
import QtQuick.Window 2.15
import QtWebView 1.1
import QtQuick.Layouts 1.15

import "components"

Window {
    id: mainWindow

    visible : true
    width: Screen.width
    height: Screen.height
    title: qsTr("Round Interfaces Library")

    Canvas {
        id: aCanvas
        width: 0;
        height: 0;
        visible: true;

        property var aContext

        onPaint: {
            aContext = aCanvas.getContext('2d');
        }
    }

    StackLayout {
        id: mainLayout
        anchors.fill: parent
        currentIndex: 0

        MainMenu {
            id: mainMenu
        }

        BasicElements {
            id: basicElements
        }

        BasicElementsExamplesPage {
            id: basicElementsExamplesPage
        }

        RoundControls {
            id: roundControls
        }

        RoundControlsExamplesPage {
            id: roundControlsExamplesPage
        }

        Documentation {
            id: documentation
        }

        onCurrentIndexChanged: {
            //mainMenu.alignCanvasItems();
            if(currentIndex === 5 && !documentation.initialized) {
                documentation.init();
            }
        }
    }
}
