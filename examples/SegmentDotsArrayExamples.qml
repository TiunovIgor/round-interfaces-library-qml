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

    property string caption: "Segment Dots Array Examples"

    Component.onCompleted: {
        let count = gridLayout.getChildCount();
        let height = 0;
        for(let i = 0; i < count; i++){
            height += gridLayout.getChildAt(i).height + 10;
        }
        this.implicitHeight = height;
    }

    // Invert "Start with" by click
    SegmentDotsArrayCanvas {
        id: canvas_1
        width: (parent.width - 10) / 2
        height: (parent.width - 10) / 2

        onCanvasReady: {
            segmentDotsArray.name = "arr_1";
            segmentDotsArray.cx = canvas_1.width / 2;
            segmentDotsArray.cy = canvas_1.height / 2;
            segmentDotsArray.r_in = 0.5 * canvas_1.width / 2;
            segmentDotsArray.thickness = 0.3 * canvas_1.width / 2;
            segmentDotsArray.init_angle = -150;
            segmentDotsArray.angle = 120;
            segmentDotsArray.visible = true;

            segmentDotsArray.dot_radius = 4;
            segmentDotsArray.dot_background = '#e5004f';

            segmentDotsArray.build();
            segmentDotsArray.draw();
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                //console.log(canvas_1.segmentDotsArray.start_with);
                if(canvas_1.segmentDotsArray.start_with == 'dot') { canvas_1.segmentDotsArray.start_with = 'space'; }
                else { canvas_1.segmentDotsArray.start_with = 'dot'; }
                canvas_1.segmentDotsArray.build();
                canvas_1.requestAnimationFrame(canvas_1.draw);
            }
        }
    }

    // Change dot_radius by click
    SegmentDotsArrayCanvas {
        id: canvas_2
        width: (parent.width - 10) / 2
        height: (parent.width - 10) / 2

        onCanvasReady: {
            segmentDotsArray.name = "arr_2";
            segmentDotsArray.cx = canvas_2.width / 2;
            segmentDotsArray.cy = canvas_2.height / 2;
            segmentDotsArray.r_in = 0.5 * canvas_2.width / 2;
            segmentDotsArray.thickness = 0.3 * canvas_2.width / 2;
            segmentDotsArray.init_angle = -90;
            segmentDotsArray.angle = 360;
            segmentDotsArray.visible = true;

            segmentDotsArray.dot_radius = 3;
            segmentDotsArray.dots_count = 12;
            segmentDotsArray.start_with = 'space';
            segmentDotsArray.dot_background = '#fcc800';

            segmentDotsArray.build();
            segmentDotsArray.draw();
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(canvas_2.segmentDotsArray.dot_radius === 3) { canvas_2.segmentDotsArray.dot_radius = 5; }
                else { canvas_2.segmentDotsArray.dot_radius = 3; }
                canvas_2.segmentDotsArray.build();
                canvas_2.requestAnimationFrame(canvas_2.draw);
            }
        }
    }

    // Disappear-Appear One By One
    SegmentDotsArrayCanvas {
        id: canvas_3
        width: (parent.width - 10) / 2
        height: (parent.width - 10) / 2

        onCanvasReady: {
            segmentDotsArray.name = "arr_3";
            segmentDotsArray.cx = canvas_3.width / 2;
            segmentDotsArray.cy = canvas_3.height / 2;
            segmentDotsArray.r_in = 0.5 * canvas_3.width / 2;
            segmentDotsArray.thickness = 0.3 * canvas_3.width / 2;
            segmentDotsArray.init_angle = 180;
            segmentDotsArray.angle = 180;
            segmentDotsArray.visible = true;

            segmentDotsArray.dot_radius = 4;
            segmentDotsArray.dots_count = 7;
            segmentDotsArray.start_with = 'space';
            segmentDotsArray.dot_background = '#22ac38';

            segmentDotsArray.build();
            segmentDotsArray.draw();
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(!canvas_3.segmentDotsArray.in_progress) {
                    if(canvas_3.segmentDotsArray.dots_visible) { canvas_3.segmentDotsArray.disappear('one-by-one-clockwise', 0, 'to-center', 3, 0); }
                    else { canvas_3.segmentDotsArray.appear('one-by-one-anticlockwise', 0, 'from-center', 3, 0); }
                }
            }
        }
    }

    // Disappear-Appear Together
    SegmentDotsArrayCanvas {
        id: canvas_4
        width: (parent.width - 10) / 2
        height: (parent.width - 10) / 2

        onCanvasReady: {
            segmentDotsArray.name = "arr_4";
            segmentDotsArray.cx = canvas_4.width / 2;
            segmentDotsArray.cy = canvas_4.height / 2;
            segmentDotsArray.r_in = 0.5 * canvas_4.width / 2;
            segmentDotsArray.thickness = 0.3 * canvas_4.width / 2;
            segmentDotsArray.init_angle = 180;
            segmentDotsArray.angle = 180;
            segmentDotsArray.visible = true;

            segmentDotsArray.dot_radius = 4;
            segmentDotsArray.dots_count = 7;
            segmentDotsArray.start_with = 'space';
            segmentDotsArray.dot_background = '#00a0e9';

            segmentDotsArray.build();
            segmentDotsArray.draw();
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(!canvas_4.segmentDotsArray.in_progress) {
                    if(canvas_4.segmentDotsArray.dots_visible) { canvas_4.segmentDotsArray.disappear('together', 0, 'to-center', 1, 0); }
                    else { canvas_4.segmentDotsArray.appear('together', 0, 'from-center', 1, 0); }
                }
            }
        }
    }

    // Fading One By One
    SegmentDotsArrayCanvas {
        id: canvas_5
        width: (parent.width - 10) / 2
        height: (parent.width - 10) / 2

        onCanvasReady: {
            segmentDotsArray.name = "arr_5";
            segmentDotsArray.cx = canvas_5.width / 2;
            segmentDotsArray.cy = canvas_5.height / 2;
            segmentDotsArray.r_in = 0.5 * canvas_5.width / 2;
            segmentDotsArray.thickness = 0.3 * canvas_5.width / 2;
            segmentDotsArray.init_angle = 135;
            segmentDotsArray.angle = 135;
            segmentDotsArray.visible = true;

            segmentDotsArray.dot_radius = 4;
            segmentDotsArray.start_with = 'space';
            segmentDotsArray.dot_background = '#00479d';

            segmentDotsArray.build();
            segmentDotsArray.draw();
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(!canvas_5.segmentDotsArray.in_progress) {
                    if(canvas_5.segmentDotsArray.dots_visible) { canvas_5.segmentDotsArray.fadeOut('one-by-one-clockwise', 0, 3, 0); }
                    else { canvas_5.segmentDotsArray.fadeIn('one-by-one-anticlockwise', 0, 3, 0); }
                }
            }
        }
    }

    // Fading Together
    SegmentDotsArrayCanvas {
        id: canvas_6
        width: (parent.width - 10) / 2
        height: (parent.width - 10) / 2

        onCanvasReady: {
            segmentDotsArray.name = "seg_6";
            segmentDotsArray.cx = canvas_6.width / 2;
            segmentDotsArray.cy = canvas_6.height / 2;
            segmentDotsArray.r_in = 0.5 * canvas_6.width / 2;
            segmentDotsArray.thickness = 0.3 * canvas_6.width / 2;
            segmentDotsArray.init_angle = -90;
            segmentDotsArray.angle = 135;
            segmentDotsArray.visible = true;

            segmentDotsArray.dot_radius = 4;
            segmentDotsArray.start_with = 'space';
            segmentDotsArray.dot_background = '#e5004f';

            segmentDotsArray.build();
            segmentDotsArray.draw();
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(!canvas_6.segmentDotsArray.in_progress) {
                    if(canvas_6.segmentDotsArray.dots_visible) { canvas_6.segmentDotsArray.fadeOut('together', 0, 1.5, 0); }
                    else { canvas_6.segmentDotsArray.fadeIn('together', 0, 1.5, 0); }
                }
            }
        }
    }
}
