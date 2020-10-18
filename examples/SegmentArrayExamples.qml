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

    property string caption: "Segment Array Examples"

    Component.onCompleted: {
        let count = gridLayout.getChildCount();
        let height = 0;
        for(let i = 0; i < count; i++) {
            height += gridLayout.getChildAt(i).height + 10;
        }
        this.implicitHeight = height;
    }

    // Invert "Start with" by click
    SegmentArrayCanvas {
        id: canvas_1
        width: (parent.width - 10) / 2
        height: (parent.width - 10) / 2

        onCanvasReady: {
            segmentArray.name = "arr_1";
            segmentArray.cx = canvas_1.width / 2;
            segmentArray.cy = canvas_1.height / 2;
            segmentArray.r_in = 0.5 * canvas_1.width / 2;
            segmentArray.thickness = 0.3 * canvas_1.width / 2;
            segmentArray.init_angle = -150;
            segmentArray.angle = 120;
            segmentArray.visible = true;

            segmentArray.segment_background = '#e5004f';

            segmentArray.build();
            segmentArray.draw();
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                console.log(canvas_1.segmentArray.start_with);
                if(canvas_1.segmentArray.start_with == 'segment') { canvas_1.segmentArray.start_with = 'space'; }
                else { canvas_1.segmentArray.start_with = 'segment'; }
                canvas_1.segmentArray.build();
                canvas_1.requestAnimationFrame(canvas_1.draw);
            }
        }
    }

    // Change position of segments by click
    SegmentArrayCanvas {
        id: canvas_2
        width: (parent.width - 10) / 2
        height: (parent.width - 10) / 2

        onCanvasReady: {
            segmentArray.name = "arr_2";
            segmentArray.cx = canvas_2.width / 2;
            segmentArray.cy = canvas_2.height / 2;
            segmentArray.r_in = 0.5 * canvas_2.width / 2;
            segmentArray.thickness = 0.3 * canvas_2.width / 2;
            segmentArray.init_angle = -90;
            segmentArray.angle = 360;
            segmentArray.visible = true;

            segmentArray.segments_count = 12;
            segmentArray.start_with = 'space';
            segmentArray.segment_background = '#fcc800';

            segmentArray.build();
            segmentArray.draw();
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(canvas_2.segmentArray.segment_position === 'inner') { canvas_2.segmentArray.segment_position = 'middle'; }
                else if(canvas_2.segmentArray.segment_position === 'middle') { canvas_2.segmentArray.segment_position = 'outer'; }
                else { canvas_2.segmentArray.segment_position = 'inner'; };
                canvas_2.segmentArray.build();
                canvas_2.requestAnimationFrame(canvas_2.draw);
            }
        }
    }

    // Disappear-Appear One By One
    SegmentArrayCanvas {
        id: canvas_3
        width: (parent.width - 10) / 2
        height: (parent.width - 10) / 2

        onCanvasReady: {
            segmentArray.name = "seg_3";
            segmentArray.cx = canvas_3.width / 2;
            segmentArray.cy = canvas_3.height / 2;
            segmentArray.r_in = 0.5 * canvas_3.width / 2;
            segmentArray.thickness = 0.3 * canvas_3.width / 2;
            segmentArray.init_angle = 180;
            segmentArray.angle = 180;
            segmentArray.visible = true;

            segmentArray.segments_count = 7;
            segmentArray.start_with = 'space';
            segmentArray.segment_background = '#22ac38';

            segmentArray.build();
            segmentArray.draw();
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(!canvas_3.segmentArray.in_progress) {
                    if(canvas_3.segmentArray.segments_visible) { canvas_3.segmentArray.disappear('one-by-one-clockwise', 0, 'to-axis', 3, 0); }
                    else { canvas_3.segmentArray.appear('one-by-one-anticlockwise', 0, 'from-axis', 3, 0); }
                }
            }
        }
    }

    // Disappear-Appear Together
    SegmentArrayCanvas {
        id: canvas_4
        width: (parent.width - 10) / 2
        height: (parent.width - 10) / 2

        onCanvasReady: {
            segmentArray.name = "arr_4";
            segmentArray.cx = canvas_4.width / 2;
            segmentArray.cy = canvas_4.height / 2;
            segmentArray.r_in = 0.5 * canvas_4.width / 2;
            segmentArray.thickness = 0.3 * canvas_4.width / 2;
            segmentArray.init_angle = 180;
            segmentArray.angle = 180;
            segmentArray.visible = true;

            segmentArray.segments_count = 7;
            segmentArray.start_with = 'space';
            segmentArray.segment_background = '#00a0e9';

            segmentArray.build();
            segmentArray.draw();
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(!canvas_4.segmentArray.in_progress) {
                    if(canvas_4.segmentArray.segments_visible) { canvas_4.segmentArray.disappear('together', 0, 'clockwise', 1, 0); }
                    else { canvas_4.segmentArray.appear('together', 0, 'anticlockwise', 1, 0); }
                }
            }
        }
    }

    // Fading One By One
    SegmentArrayCanvas {
        id: canvas_5
        width: (parent.width - 10) / 2
        height: (parent.width - 10) / 2

        onCanvasReady: {
            segmentArray.name = "arr_5";
            segmentArray.cx = canvas_5.width / 2;
            segmentArray.cy = canvas_5.height / 2;
            segmentArray.r_in = 0.5 * canvas_5.width / 2;
            segmentArray.thickness = 0.3 * canvas_5.width / 2;
            segmentArray.init_angle = 135;
            segmentArray.angle = 135;
            segmentArray.visible = true;

            segmentArray.start_with = 'space';
            segmentArray.segment_background = '#00479d';

            segmentArray.build();
            segmentArray.draw();
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(!canvas_5.segmentArray.in_progress) {
                    if(canvas_5.segmentArray.segments_visible) { canvas_5.segmentArray.fadeOut('one-by-one-clockwise', 0, 3, 0); }
                    else { canvas_5.segmentArray.fadeIn('one-by-one-anticlockwise', 0, 3, 0); }
                }
            }
        }
    }

    // Fading Together
    SegmentArrayCanvas {
        id: canvas_6
        width: (parent.width - 10) / 2
        height: (parent.width - 10) / 2

        onCanvasReady: {
            segmentArray.name = "seg_6";
            segmentArray.cx = canvas_6.width / 2;
            segmentArray.cy = canvas_6.height / 2;
            segmentArray.r_in = 0.5 * canvas_6.width / 2;
            segmentArray.thickness = 0.3 * canvas_6.width / 2;
            segmentArray.init_angle = -90;
            segmentArray.angle = 135;
            segmentArray.visible = true;

            segmentArray.start_with = 'space';
            segmentArray.segment_background = '#e5004f';

            segmentArray.build();
            segmentArray.draw();
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(!canvas_6.segmentArray.in_progress) {
                    if(canvas_6.segmentArray.segments_visible) { canvas_6.segmentArray.fadeOut('together', 0, 1.5, 0); }
                    else { canvas_6.segmentArray.fadeIn('together', 0, 1.5, 0); }
                }
            }
        }
    }
}
