import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.12
import QtMultimedia 5.15

import "../components"

GridLayout {
    id: gridLayout
    Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
    implicitWidth: parent.width

    columns: 1
    rowSpacing: 10

    property string caption: "Round Equalizer Examples"

    Component.onCompleted: {
        let count = gridLayout.getChildCount();
        let height = 0;
        for(let i = 0; i < count; i++){
            height += gridLayout.getChildAt(i).height + 10;
        }
        this.implicitHeight = height;
    }

    property var request_1
    property bool active: false

    Utilities { id: utilities; }

    function changeButtonsToPause() {
        image_1.source = 'qrc:/svg/pause-button.svg';
    }

    function changeButtonsToPlay() {
        image_1.source = 'qrc:/svg/play-button.svg';
    }

    function renderFrame_1() {
        let values = [];

        for(let i=0; i < canvas_1.segmentEqualizer.segments.length; i++) {
            values[i] = Math.random() * 1;
        }

        canvas_1.context.clearRect(0, 0, canvas_1.width, canvas_1.height);
        canvas_1.segmentEqualizer.changeValues(values);
        canvas_1.segmentEqualizer.draw();

        if(active) {
            //canvas_1.cancelRequestAnimationFrame(request_1);
            request_1 = utilities.setTimeout(function() {
                return canvas_1.requestAnimationFrame(renderFrame_1);
            }, 50);
        }
    }

    function clickButton() {
        console.log('clickButton');
        if(!active) {
            request_1 = canvas_1.requestAnimationFrame(renderFrame_1);
            //request_2 = canvas_2.requestAnimationFrame(renderFrame_2);
            changeButtonsToPause();
        }
        else {
            canvas_1.cancelRequestAnimationFrame(request_1);
            //canvas_2.cancelRequestAnimationFrame(request_2);
            changeButtonsToPlay();
        }
        active = !active;
    }

    RoundEqualizerCanvas {
        id: canvas_1
        width: parent.width
        height: parent.height

        onCanvasReady: {
            let w = canvas_1.width / 2;

            segmentEqualizer.name = "equal_1";
            segmentEqualizer.cx = canvas_1.width / 2;
            segmentEqualizer.cy = canvas_1.height / 2;
            segmentEqualizer.r_in = 0.4 * w;
            segmentEqualizer.thickness = 0.4 * w;
            segmentEqualizer.init_angle = -90;
            segmentEqualizer.angle = 360;
            segmentEqualizer.visible = true;

            segmentEqualizer.segments_count = 64;
            segmentEqualizer.proportional = true;

            segmentEqualizer.segment_gradient = Qt.createQmlObject('import "../components";
                SegmentGradient { type: "radial"; direction: "from-center"; stops_string: "orange 0%, yellow 30%, green 45%, blue 100%" }', this, "grad_1");

            segmentEqualizer.build();
            segmentEqualizer.draw();
        }

        Image {
            id: image_1
            width: 0.3 * parent.width
            height: 0.3 * parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter

            source: 'qrc:/svg/play-button.svg'

            MouseArea {
                anchors.fill: image_1
                onClicked: {
                    clickButton();
                }
            }
        }
    }
}
