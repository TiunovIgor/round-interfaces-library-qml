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

    property string caption: "Segment Examples"

    Component.onCompleted: {
        let count = gridLayout.getChildCount();
        let height = 0;
        for(let i = 0; i < count; i++){
            height += gridLayout.getChildAt(i).height + 10;
        }
        this.implicitHeight = height;
    }

    // Disappear clockwise - Appear anticlockwise
    SegmentCanvas {
        id: canvas_1
        width: (parent.width - 10) / 2
        height: (parent.width - 10) / 2

        onCanvasReady: {
            segment.name = "seg_1";
            segment.cx = canvas_1.width / 2;
            segment.cy = canvas_1.height / 2;
            segment.r_in = 0.5 * canvas_1.width / 2;
            segment.thickness = 0.3 * canvas_1.width / 2;
            segment.init_angle = -135;
            segment.angle = 285;
            //segment.angle = 350;
            segment.visible = true;

            /*
            segment.gradient = Qt.createQmlObject('import "../components"; SegmentGradient { type: "conic"; direction: "clockwise"; name: "segment";
                stops_string: "rgba(255, 0, 0, 0.2) 0%, rgba(0, 255, 0, 0.4) 50%, rgba(0, 0, 255, 0.6) 100%" }', this, "grad_1");
            //console.log(segment.gradient.parent);
            */

            segment.background = '#efefef';
            segment.border_opening_width = 1;
            segment.border_opening_color = '#e5004f';
            segment.border_outer_width = 1;
            segment.border_outer_color = '#22ac38';
            segment.border_inner_width = 1;
            segment.border_inner_color = '#00479d';
            segment.border_closing_width = 1;
            segment.border_closing_color = 'black';

            segment.calc();
            segment.draw();
        }
    }

    // Disappear to center - Appear from center
    SegmentCanvas {
        id: canvas_2
        width: (parent.width - 10) / 2
        height: (parent.width - 10) / 2

        onCanvasReady: {
            segment.name = "seg_2";
            segment.cx = canvas_2.width / 2;
            segment.cy = canvas_2.height / 2;
            segment.r_in = 0.5 * canvas_2.width / 2;
            segment.thickness = 0.3 * canvas_2.width / 2;
            segment.init_angle = -90;
            segment.angle = 135;
            segment.visible = true;

            segment.background = '#fcc800';

            segment.calc();
            segment.draw();
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(!canvas_2.segment.in_progress) {
                    if(canvas_2.segment.visible) { canvas_2.segment.disappear('to-center', 0.5, 0); }
                    else { canvas_2.segment.appear('from-center', 0.5, 0); }
                }
            }
        }
    }

    // Disappear to axis - Appear from axis
    SegmentCanvas {
        id: canvas_3
        width: (parent.width - 10) / 2
        height: (parent.width - 10) / 2

        onCanvasReady: {
            segment.name = "seg_3";
            segment.cx = canvas_3.width / 2;
            segment.cy = canvas_3.height / 2;
            segment.r_in = 0.5 * canvas_3.width / 2;
            segment.thickness = 0.3 * canvas_3.width / 2;
            segment.init_angle = 45;
            segment.angle = 135;
            segment.visible = true;

            segment.background = '#00a0e9';

            segment.calc();
            segment.draw();
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(!canvas_3.segment.in_progress) {
                    if(canvas_3.segment.visible) { canvas_3.segment.disappear('to-axis', 0.5, 0); }
                    else { canvas_3.segment.appear('from-axis', 0.5, 0); }
                }
            }
        }
    }

    SegmentCanvas {
        id: canvas_4
        width: (parent.width - 10) / 2
        height: (parent.width - 10) / 2

        onCanvasReady: {
            segment.name = "seg_4";
            segment.cx = canvas_4.width / 2;
            segment.cy = canvas_4.height / 2;
            segment.r_in = 0.5 * canvas_4.width / 2;
            segment.thickness = 0.3 * canvas_4.width / 2;
            segment.init_angle = 135;
            segment.angle = 135;
            segment.visible = true;

            segment.background = '#e5004f';

            segment.calc();
            segment.draw();
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(!canvas_4.segment.in_progress) {
                    if(canvas_4.segment.visible) { canvas_4.segment.disappear('clockwise', 0.5, 0); }
                    else { canvas_4.segment.appear('anticlockwise', 0.5, 0); }
                }
            }
        }
    }

    // Disappear to center - Appear from center
    SegmentCanvas {
        id: canvas_5
        width: (parent.width - 10) / 2
        height: (parent.width - 10) / 2

        onCanvasReady: {
            segment.name = "seg_5";
            segment.cx = canvas_5.width / 2;
            segment.cy = canvas_5.height / 2;
            segment.r_in = 0.5 * canvas_5.width / 2;
            segment.thickness = 0.3 * canvas_5.width / 2;
            segment.init_angle = 0;
            segment.angle = 45;
            segment.visible = true;

            segment.background = '#22ac38';

            segment.calc();
            segment.draw();
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(!canvas_5.segment.in_progress) {
                    if(canvas_5.segment.visible) { canvas_5.segment.rotate('clockwise', 45, 1.5, 0); }
                }
            }
        }
    }

    // Disappear to axis - Appear from axis
    SegmentCanvas {
        id: canvas_6
        width: (parent.width - 10) / 2
        height: (parent.width - 10) / 2

        onCanvasReady: {
            segment.name = "seg_6";
            segment.cx = canvas_6.width / 2;
            segment.cy = canvas_6.height / 2;
            segment.r_in = 0.5 * canvas_6.width / 2;
            segment.thickness = 0.3 * canvas_6.width / 2;
            segment.init_angle = -45;
            segment.angle = 270;
            segment.visible = true;

            segment.background = '#00479d';

            segment.calc();
            segment.draw();
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(!canvas_6.segment.in_progress) {
                    if(canvas_6.segment.visible) { canvas_6.segment.fadeOut(1, 0); }
                    else { canvas_6.segment.fadeIn(1, 0); }
                }
            }
        }
    }
}
