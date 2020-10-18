import QtQuick 2.12
import QtQuick.Controls 2.1
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.12

import "../components"

GridLayout {
    id: gridLayout
    Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
    implicitWidth: parent.width

    columns: 2
    rowSpacing: 10

    property string caption: "Segment Spiral Examples"

    Component.onCompleted: {
        let count = gridLayout.getChildCount();
        let height = 0;
        for(let i = 0; i < count; i++){
            height += gridLayout.getChildAt(i).height + 10;
        }
        this.implicitHeight = height;
    }

    // Disappear anticlockwise - Appear clockwise
    SegmentSpiralCanvas {
        id: canvas_1
        width: (parent.width - 10) / 2
        height: (parent.width - 10) / 2

        onCanvasReady: {
            segmentSpiral.name = "spiral_1";
            segmentSpiral.cx = canvas_1.width / 2;
            segmentSpiral.cy = canvas_1.height / 2;
            segmentSpiral.r_in = 0.7 * canvas_1.width / 2;
            segmentSpiral.thickness = 0.2 * canvas_1.width / 2;
            segmentSpiral.init_angle = -135;
            segmentSpiral.angle = 90;
            segmentSpiral.visible = true;

            segmentSpiral.position = 'inner';
            segmentSpiral.direction = 'clockwise';
            segmentSpiral.background = '#00479d';

            segmentSpiral.calc();
            segmentSpiral.draw();
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(!canvas_1.segmentSpiral.in_progress) {
                    if(canvas_1.segmentSpiral.visible) { canvas_1.segmentSpiral.disappear('anticlockwise', 0.5, 0); }
                    else { canvas_1.segmentSpiral.appear('clockwise', 0.5, 0); }
                }
            }
        }
    }

    // Disappear to center - Appear from center
    SegmentSpiralCanvas {
        id: canvas_2
        width: (parent.width - 10) / 2
        height: (parent.width - 10) / 2

        onCanvasReady: {
            segmentSpiral.name = "spiral_2";
            segmentSpiral.cx = canvas_2.width / 2;
            segmentSpiral.cy = canvas_2.height / 2;
            segmentSpiral.r_in = 0.7 * canvas_2.width / 2;
            segmentSpiral.thickness = 0.2 * canvas_2.width / 2;
            segmentSpiral.init_angle = -135;
            segmentSpiral.angle = 90;
            segmentSpiral.visible = true;

            segmentSpiral.position = 'inner';
            segmentSpiral.direction = 'anticlockwise';
            segmentSpiral.background = '#e5004f';

            segmentSpiral.calc();
            segmentSpiral.draw();
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(!canvas_2.segmentSpiral.in_progress) {
                    if(canvas_2.segmentSpiral.visible) { canvas_2.segmentSpiral.disappear('to-center', 0.5, 0); }
                    else { canvas_2.segmentSpiral.appear('from-center', 0.5, 0); }
                }
            }
        }
    }

    // FadeOut - FadeIn
    SegmentSpiralCanvas {
        id: canvas_3
        width: (parent.width - 10) / 2
        height: (parent.width - 10) / 2

        onCanvasReady: {
            segmentSpiral.name = "spiral_3";
            segmentSpiral.cx = canvas_3.width / 2;
            segmentSpiral.cy = canvas_3.height / 2;
            segmentSpiral.r_in = 0.7 * canvas_3.width / 2;
            segmentSpiral.thickness = 0.2 * canvas_3.width / 2;
            segmentSpiral.init_angle = -135;
            segmentSpiral.angle = 90;
            segmentSpiral.visible = true;

            segmentSpiral.position = 'outer';
            segmentSpiral.direction = 'clockwise';
            segmentSpiral.background = '#22ac38';

            segmentSpiral.calc();
            segmentSpiral.draw();
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(!canvas_3.segmentSpiral.in_progress) {
                    if(canvas_3.segmentSpiral.visible) { canvas_3.segmentSpiral.disappear('from-center', 1, 0); }
                    else { canvas_3.segmentSpiral.appear('to-center', 1, 0); }
                }
            }
        }
    }

    // FadeOut - FadeIn
    SegmentSpiralCanvas {
        id: canvas_4
        width: (parent.width - 10) / 2
        height: (parent.width - 10) / 2

        onCanvasReady: {
            segmentSpiral.name = "spiral_4";
            segmentSpiral.cx = canvas_4.width / 2;
            segmentSpiral.cy = canvas_4.height / 2;
            segmentSpiral.r_in = 0.7 * canvas_4.width / 2;
            segmentSpiral.thickness = 0.2 * canvas_4.width / 2;
            segmentSpiral.init_angle = -135;
            segmentSpiral.angle = 90;
            segmentSpiral.visible = true;

            segmentSpiral.position = 'outer';
            segmentSpiral.direction = 'anticlockwise';
            segmentSpiral.background = '#fcc800';

            segmentSpiral.calc();
            segmentSpiral.draw();
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(!canvas_4.segmentSpiral.in_progress) {
                    if(canvas_4.segmentSpiral.visible) { canvas_4.segmentSpiral.disappear('clockwise', 1, 0); }
                    else { canvas_4.segmentSpiral.appear('anticlockwise', 1, 0); }
                }
            }
        }
    }

    // FadeOut - FadeIn
    SegmentSpiralCanvas {
        id: canvas_5
        width: (parent.width - 10) / 2
        height: (parent.width - 10) / 2

        onCanvasReady: {
            segmentSpiral.name = "spiral_5";
            segmentSpiral.cx = canvas_5.width / 2;
            segmentSpiral.cy = canvas_5.height / 2;
            segmentSpiral.r_in = 0.4 * canvas_5.width / 2;
            segmentSpiral.thickness = 0.2 * canvas_5.width / 2;
            segmentSpiral.init_angle = -120;
            segmentSpiral.angle = 60;
            segmentSpiral.visible = true;

            segmentSpiral.position = 'inner';
            segmentSpiral.direction = 'clockwise';
            segmentSpiral.background = '#00a0e9';

            segmentSpiral.calc();
            segmentSpiral.draw();
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(!canvas_5.segmentSpiral.in_progress) {
                    canvas_5.segmentSpiral.rotate('clockwise', 360, 0.5, 0);
                }
            }
        }
    }

    // FadeOut - FadeIn
    SegmentSpiralCanvas {
        id: canvas_6
        width: (parent.width - 10) / 2
        height: (parent.width - 10) / 2

        onCanvasReady: {
            segmentSpiral.name = "spiral_6";
            segmentSpiral.cx = canvas_6.width / 2;
            segmentSpiral.cy = canvas_6.height / 2;
            segmentSpiral.r_in = 0.5 * canvas_6.width / 2;
            segmentSpiral.thickness = 0.3 * canvas_6.width / 2;
            segmentSpiral.init_angle = 135;
            segmentSpiral.angle = 270;
            segmentSpiral.visible = true;

            segmentSpiral.position = 'inner';
            segmentSpiral.direction = 'clockwise';
            segmentSpiral.gradient = Qt.createQmlObject('import "../components";
                SegmentGradient { type: "radial"; direction: "from-center"; stops_string: "#22ac38 0%, #00479d 100%" }', this, "grad_6");

            segmentSpiral.calc();
            segmentSpiral.draw();
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(!canvas_6.segmentSpiral.in_progress) {
                    if(canvas_6.segmentSpiral.visible) { canvas_6.segmentSpiral.fadeOut(1, 0); }
                    else { canvas_6.segmentSpiral.fadeIn(1, 0); }
                }
            }
        }
    }
}
