import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Window 2.15
import QtWebView 1.1

import "components"

Item {
    property bool initialized: false

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
            text: "Documentation"
            font.family: "Open Sans"
            font.pointSize: 20
            anchors.centerIn: parent
            horizontalAlignment: Text.AlignHCenter
        }
    }

    function init() {
        documentationView.url = "file:///android_asset/readme.html";
        initialized = true;
    }

    WebView {
        id: documentationView
        width: parent.width
        height: parent.height - 100

        anchors.top: header.bottom

        function replaceUrlWithSource(url) {
            console.log('replaceUrlWithSource: ' + url);
            let path = url.toString();
            if(path === 'file:///android_asset/examples/segment-examples.html') return 'qrc:/examples/SegmentExamples.qml';
            if(path === 'file:///android_asset/examples/segment-grid-examples.html') return 'qrc:/examples/SegmentGridExamples.qml';
            if(path === 'file:///android_asset/examples/segment-spiral-examples.html') return 'qrc:/examples/SegmentSpiralExamples.qml';
            if(path === 'file:///android_asset/examples/segment-level-examples.html') return 'qrc:/examples/SegmentLevelExamples.qml';
            if(path === 'file:///android_asset/examples/segment-array-examples.html') return 'qrc:/examples/SegmentArrayExamples.qml';
            if(path === 'file:///android_asset/examples/segment-dot-examples.html') return 'qrc:/examples/SegmentDotExamples.qml';
            if(path === 'file:///android_asset/examples/segment-dots-array-examples.html') return 'qrc:/examples/SegmentDotsArrayExamples.qml';
            if(path === 'file:///android_asset/examples/segment-scale-examples.html') return 'qrc:/examples/SegmentScaleExamples.qml';

            if(path === 'file:///android_asset/examples/round-progress-bar-examples.html') return 'qrc:/examples/RoundProgressBarExamples.qml';
            if(path === 'file:///android_asset/examples/round-gauge-examples.html') return 'qrc:/examples/RoundGaugeExamples.qml';
            if(path === 'file:///android_asset/examples/round-timer-examples.html') return 'qrc:/examples/RoundTimerExamples.qml';
            if(path === 'file:///android_asset/examples/round-volume-control-examples.html') return 'qrc:/examples/RoundVolumeControlExamples.qml';
            if(path === 'file:///android_asset/examples/round-captcha-examples.html') return 'qrc:/examples/RoundCaptchaExamples.qml';
            if(path === 'file:///android_asset/examples/round-chart-examples.html') return 'qrc:/examples/RoundChartExamples.qml';
            if(path === 'file:///android_asset/examples/round-equalizer-examples.html') return 'qrc:/examples/RoundEqualizerExamples.qml';
            if(path === 'file:///android_asset/examples/round-radar-examples.html') return 'qrc:/examples/RoundRadarExamples.qml';
        }

        onLoadingChanged: {
            if(loadRequest.status == WebView.LoadSucceededStatus) {
                if(documentationView.canGoBack) { backImage.visible = true; }
                else { backImage.visible = false; }
            }

            if(loadRequest.status == WebView.LoadFailedStatus) {
                let source = replaceUrlWithSource(url);
                console.log(source);

                if(source === undefined) {
                    documentationView.url = "file:///android_asset/readme.html";
                }
                else {
                    if(source.indexOf('Round') > -1) {
                        roundControlsExamplesPage.loader.source = source;
                        documentationView.goBack();
                        mainLayout.currentIndex = 4;
                    }
                    else {
                        basicElementsExamplesPage.loader.source = source;
                        mainLayout.currentIndex = 2;
                        documentationView.goBack();
                    }
                }
            }
        }
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

        Image {
            id: backImage
            width: 48
            height: 48
            anchors.verticalCenter: footer.verticalCenter
            anchors.left: footer.left
            visible: false

            source: "qrc:/icons/back.png"

            MouseArea {
                anchors.fill: backImage
                onClicked: documentationView.goBack();
            }
        }

        Image {
            id: reloadImage
            width: 48
            height: 48
            anchors.verticalCenter: footer.verticalCenter
            anchors.right: footer.right

            source: "qrc:/icons/update.png"

            MouseArea {
                anchors.fill: reloadImage
                onClicked: documentationView.reload();
            }
        }
    }
}
