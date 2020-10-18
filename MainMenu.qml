import QtQuick 2.15
import QtQuick.Controls 2.12
import QtQuick.Window 2.15
import QtWebView 1.1

import "components"

Item {
    id: mainMenu
    width: parent.width
    height: parent.height

    function alignCanvasItems() { canvas.alignSegments(); }

    Label {
        id: header
        width: parent.width
        height: 50
        anchors.top: parent.top
        background: Rectangle {
            anchors.fill: parent
            border.width: 1
            border.color: '#666';
            color: 'transparent';
        }
        Text {
            text: "Round Interfaces Library"
            font.family: "Open Sans"
            font.pointSize: 20
            anchors.centerIn: parent
            horizontalAlignment: Text.AlignHCenter
        }        
    }

    Item {
        id: content
        width: parent.width
        height: parent.height - 240
        anchors.top: header.bottom

        Canvas {
            id: canvas
            width: parent.width
            height: parent.height - 240
            anchors.fill: parent

            property double f: 100; // factor
            property bool in_progress: false;

            property var initialized: false;

            Segment { id: seg_1; cx: canvas.width / 2; cy: canvas.height / 2; r_in: 0.3 * canvas.f; thickness: 0.35 * canvas.f; init_angle: 15; angle: 30; visible: true
                gradient: SegmentGradient { type: 'radial'; direction: 'from-center'; stops_string: 'orange 0%, purple 100%' }
                border_color: 'black';
                Component.onCompleted: { seg_1.calc(); }
            }

            Segment { id: seg_2; cx: canvas.width / 2; cy: canvas.height / 2; r_in: 0.4 * canvas.f; thickness: 0.2 * canvas.f; init_angle: 60; angle: 60; visible: true
                gradient: SegmentGradient { type: 'radial'; direction: 'from-center'; stops_string: 'orange 0%, purple 100%' }
                border_color: 'black';
                Component.onCompleted: { seg_2.calc(); }
            }

            Segment { id: seg_3; cx: canvas.width / 2; cy: canvas.height / 2; r_in: 0.3 * canvas.f; thickness: 0.35 * canvas.f; init_angle: 135; angle: 30; visible: true
                gradient: SegmentGradient { type: 'radial'; direction: 'from-center'; stops_string: 'orange 0%, purple 100%' }
                border_color: 'black';
                Component.onCompleted: { seg_3.calc(); }
            }

            Segment { id: seg_4; cx: canvas.width / 2; cy: canvas.height / 2; r_in: 0.4 * canvas.f; thickness: 0.2 * canvas.f; init_angle: 180; angle: 60; visible: true
                gradient: SegmentGradient { type: 'radial'; direction: 'from-center'; stops_string: 'orange 0%, purple 100%' }
                border_color: 'black';
                Component.onCompleted: { seg_4.calc(); }
            }

            Segment { id: seg_5; cx: canvas.width / 2; cy: canvas.height / 2; r_in: 0.3 * canvas.f; thickness: 0.35 * canvas.f; init_angle: 255; angle: 30; visible: true
                gradient: SegmentGradient { type: 'radial'; direction: 'from-center'; stops_string: 'orange 0%, purple 100%' }
                border_color: 'black';
                Component.onCompleted: { seg_5.calc(); }
            }

            Segment { id: seg_6; cx: canvas.width / 2; cy: canvas.height / 2; r_in: 0.4 * canvas.f; thickness: 0.2 * canvas.f; init_angle: 300; angle: 60; visible: true
                gradient: SegmentGradient { type: 'radial'; direction: 'from-center'; stops_string: 'orange 0%, purple 100%' }
                border_color: 'black';
                Component.onCompleted: { seg_6.calc(); }
            }

            SegmentLevel { id: lvl_1; cx: canvas.width / 2; cy: canvas.height / 2; r_in: 0.3 * canvas.f }
            SegmentLevel { id: lvl_2; cx: canvas.width / 2; cy: canvas.height / 2; r_in: 0.3 * canvas.f }


            function drawScene() {
                canvas.context.clearRect(0, 0, canvas.width, canvas.height);
                lvl_1.draw();
                lvl_2.draw();
            }

            function alignSegments() {
                console.log('alignSegments');

                lvl_1.in_progress = false;
                lvl_2.in_progress = false;

                seg_1.in_progress = false;
                seg_2.in_progress = false;
                seg_3.in_progress = false;
                seg_4.in_progress = false;
                seg_5.in_progress = false;
                seg_6.in_progress = false;

                seg_1.init_angle = 15;
                seg_1.calc();

                seg_2.init_angle = 60;
                seg_2.calc();

                seg_3.init_angle = 135;
                seg_3.calc();

                seg_4.init_angle = 180;
                seg_4.calc();

                seg_5.init_angle = 255;
                seg_5.calc();

                seg_6.init_angle = 300;
                seg_6.calc();

                //console.log(seg_1.r_in + ' ' + seg_1.thickness + ' ' + seg_1.r_out + ' ' + seg_1.init_angle + ' ' + seg_1.angle);

                canvas.requestAnimationFrame(drawScene);
            }

            onPaint: {
                let context = getContext('2d');

                if(!initialized) {
                    if(canvas.width <= canvas.height) f = canvas.width / 2;
                    else { f = canvas.height / 2; }

                    seg_1.context = context;
                    seg_1.calc();

                    seg_2.context = context;
                    seg_2.calc();

                    seg_3.context = context;
                    seg_3.calc();

                    seg_4.context = context;
                    seg_4.calc();

                    seg_5.context = context;
                    seg_5.calc();

                    seg_6.context = context;
                    seg_6.calc();

                    seg_1.segmentChanged.connect(drawScene);
                    seg_2.segmentChanged.connect(drawScene);
                    seg_3.segmentChanged.connect(drawScene);
                    seg_4.segmentChanged.connect(drawScene);
                    seg_5.segmentChanged.connect(drawScene);
                    seg_6.segmentChanged.connect(drawScene);

                    lvl_1.context = context;
                    lvl_1.addSegment(seg_1);
                    lvl_1.addSegment(seg_3);
                    lvl_1.addSegment(seg_5);
                    lvl_1.build();

                    lvl_1.segmentLevelChanged.connect(drawScene);

                    lvl_2.context = context;
                    lvl_2.addSegment(seg_2);
                    lvl_2.addSegment(seg_4);
                    lvl_2.addSegment(seg_6);
                    lvl_2.build();

                    lvl_2.segmentLevelChanged.connect(drawScene);

                    initialized = true;

                    lvl_1.segmentLevelRotated.connect(function() {
                        console.log('rotate lvl_1');
                        lvl_2.rotate('together', 0, 'clockwise', 7, 0.5, 0);
                    });
                    lvl_2.segmentLevelRotated.connect(function() {
                        console.log('stop');
                        canvas.in_progress = false;
                    });
                }

                drawScene();
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    /*
                    if(!lvl_1.in_progress && !lvl_2.in_progress) {
                        console.log('rotate lvl_1');
                        lvl_1.rotate('one-by-one-clockwise', 0, 'clockwise', 7, 1.5, 0);
                    }
                    */
                }
            }
        }
    }

    Button {
        id: documentationButton
        width: parent.width * 0.8
        height: 50
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter
        text: "Documentation"
        font.pointSize: 15

        background: Rectangle {
            anchors.fill: parent
            border.width: 1
            border.color: 'purple'
            color: '#eee';
            /*
            gradient: Gradient  {
                orientation: Gradient.Horizontal
                GradientStop { position: 0.0; color: "purple" }
                GradientStop { position: 0.05; color: "orange" }
                GradientStop { position: 0.1; color: "#eee" }
                GradientStop { position: 1.0; color: "#eee" }
            }
            */
        }

        onClicked: mainLayout.currentIndex = 5;
    }

    Button {
        id: roundControlsButton
        width: parent.width * 0.8
        height: 50
        anchors.bottom: documentationButton.top
        anchors.bottomMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
        text: "Round Controls"
        font.pointSize: 15

        background: Rectangle {
            anchors.fill: parent
            border.width: 1
            border.color: 'purple'
            color: '#eee'
            /*
            gradient: Gradient  {
                orientation: Gradient.Horizontal
                GradientStop { position: 0.0; color: "purple" }
                GradientStop { position: 0.05; color: "orange" }
                GradientStop { position: 0.1; color: "#eee" }
                GradientStop { position: 1.0; color: "#eee" }
            }
            */
        }

        onClicked: mainLayout.currentIndex = 3;
    }

    Button {
        id: basicElementsButton
        width: parent.width * 0.8
        height: 50
        anchors.bottom: roundControlsButton.top
        anchors.bottomMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
        text: "Basic Elements"
        font.pointSize: 15

        background: Rectangle {
            anchors.fill: parent
            border.width: 1
            border.color: 'purple'
            color: '#eee'
            /*
            gradient: Gradient  {
                orientation: Gradient.Horizontal
                GradientStop { position: 0.0; color: "purple" }
                GradientStop { position: 0.05; color: "orange" }
                GradientStop { position: 0.1; color: "#eee" }
                GradientStop { position: 1.0; color: "#eee" }
            }
            */
        }

        onClicked: mainLayout.currentIndex = 1;
    }
}
