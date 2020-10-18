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

    property string caption: "Segment Scale Examples"

    Component.onCompleted: {
        let count = gridLayout.getChildCount();
        let height = 0;
        for(let i = 0; i < count; i++){
            height += gridLayout.getChildAt(i).height + 10;
        }
        this.implicitHeight = height;
    }

    // Change mark_position by click
    SegmentScaleCanvas {
        id: canvas_1
        width: (parent.width - 10) / 2
        height: (parent.width - 10) / 2

        onCanvasReady: {
            segmentScale.name = "scale_1";
            segmentScale.cx = canvas_1.width / 2;
            segmentScale.cy = canvas_1.height / 2;
            segmentScale.r_in = 0.5 * canvas_1.width / 2;
            segmentScale.thickness = 0.3 * canvas_1.width / 2;
            segmentScale.init_angle = -90;
            segmentScale.angle = 135;
            segmentScale.visible = true;

            segmentScale.levels = [
                        { 'divisions_count' : 6, 'mark_length' : 17, 'mark_width' : 2, 'mark_color' : 'black' },
                        { 'divisions_count' : 5, 'mark_length' : 10, 'mark_width' : 1, 'mark_color' : 'black' },
                        //{ 'divisions_count' : 5, 'mark_length' : 5, 'mark_width' : 0.5, 'mark_color' : 'black' }
            ];
            segmentScale.mark_position = 'inner';

            segmentScale.build();
            segmentScale.draw();
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                //console.log(canvas_1.segmentScale.mark_position);
                if(!canvas_1.segmentScale.in_progress) {
                    if(canvas_1.segmentScale.mark_position === 'inner') { canvas_1.segmentScale.mark_position = 'middle'; }
                    else if(canvas_1.segmentScale.mark_position === 'middle') { canvas_1.segmentScale.mark_position = 'outer'; }
                    else { canvas_1.segmentScale.mark_position = 'inner'; };
                    canvas_1.segmentScale.build();
                    canvas_1.requestAnimationFrame(canvas_1.draw);
                }
            }
        }
    }

    // Disappear-Appear Together
    SegmentScaleCanvas {
        id: canvas_2
        width: (parent.width - 10) / 2
        height: (parent.width - 10) / 2

        onCanvasReady: {
            segmentScale.name = "scale_2";
            segmentScale.cx = canvas_2.width / 2;
            segmentScale.cy = canvas_2.height / 2;
            segmentScale.r_in = 0.5 * canvas_2.width / 2;
            segmentScale.thickness = 0.3 * canvas_2.width / 2;
            segmentScale.init_angle = -90;
            segmentScale.angle = 135;
            segmentScale.visible = true;

            segmentScale.levels = [
                        { 'divisions_count' : 6, 'mark_length' : 17, 'mark_width' : 2, 'mark_color' : 'black' },
                        { 'divisions_count' : 5, 'mark_length' : 10, 'mark_width' : 1, 'mark_color' : 'black' },
                        //{ 'divisions_count' : 5, 'mark_length' : 5, 'mark_width' : 0.5, 'mark_color' : 'black' }
            ];
            segmentScale.mark_position = 'outer';
            segmentScale.background = '#fcc800';

            segmentScale.build();
            segmentScale.draw();
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(!canvas_2.segmentScale.in_progress) {
                    if(canvas_2.segmentScale.marks_visible) { canvas_2.segmentScale.disappear('together', 0, 'from-center', 0.5, 0); }
                    else { canvas_2.segmentScale.appear('together', 0, 'to-center', 0.5, 0); }
                }
            }
        }
    }

    // Fading Together
    SegmentScaleCanvas {
        id: canvas_3
        width: (parent.width - 10) / 2
        height: (parent.width - 10) / 2

        onCanvasReady: {
            segmentScale.name = "scale_3";
            segmentScale.cx = canvas_3.width / 2;
            segmentScale.cy = canvas_3.height / 2;
            segmentScale.r_in = 0.5 * canvas_3.width / 2;
            segmentScale.thickness = 0.3 * canvas_3.width / 2;
            segmentScale.init_angle = -90;
            segmentScale.angle = 135;
            segmentScale.visible = true;

            segmentScale.levels = [
                        { 'divisions_count' : 6, 'mark_length' : 17, 'mark_width' : 2, 'mark_color' : 'black' },
                        { 'divisions_count' : 5, 'mark_length' : 10, 'mark_width' : 1, 'mark_color' : 'black' },
            ];
            segmentScale.mark_position = 'middle';
            segmentScale.background = '#fcc800';

            segmentScale.build();
            segmentScale.draw();
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(!canvas_3.segmentScale.in_progress) {
                    if(canvas_3.segmentScale.marks_visible) { canvas_3.segmentScale.fadeOut('together', 0, 1, 0); }
                    else { canvas_3.segmentScale.fadeIn('together', 0, 1, 0); }
                }
            }
        }
    }

    // Disappear-Appear One-by-One
    SegmentScaleCanvas {
        id: canvas_4
        width: (parent.width - 10) / 2
        height: (parent.width - 10) / 2

        onCanvasReady: {
            segmentScale.name = "scale_4";
            segmentScale.cx = canvas_4.width / 2;
            segmentScale.cy = canvas_4.height / 2;
            segmentScale.r_in = 0.5 * canvas_4.width / 2;
            segmentScale.thickness = 0.3 * canvas_4.width / 2;
            segmentScale.init_angle = -90;
            segmentScale.angle = 135;
            segmentScale.visible = true;

            segmentScale.levels = [
                        { 'divisions_count' : 5, 'mark_length' : 17, 'mark_width' : 2, 'mark_color' : '#00479d' },
                        { 'divisions_count' : 2, 'mark_length' : 10, 'mark_width' : 1, 'mark_color' : '#e5004f' },
                        { 'divisions_count' : 3, 'mark_length' : 5, 'mark_width' : 0.5, 'mark_color' : 'black' }
            ];
            segmentScale.mark_position = 'inner';
            segmentScale.background = '#fcc800';

            segmentScale.build();
            segmentScale.draw();
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(!canvas_4.segmentScale.in_progress) {
                    if(canvas_4.segmentScale.marks_visible) { canvas_4.segmentScale.disappear('one-by-one-clockwise', 0, 'to-center', 2, 0); }
                    else { canvas_4.segmentScale.appear('one-by-one-anticlockwise', 0, 'from-center', 2, 0); }
                }
            }
        }
    }

    // Fading Level-by-Level
    SegmentScaleCanvas {
        id: canvas_5
        width: (parent.width - 10) / 2
        height: (parent.width - 10) / 2

        onCanvasReady: {
            segmentScale.name = "scale_5";
            segmentScale.cx = canvas_5.width / 2;
            segmentScale.cy = canvas_5.height / 2;
            segmentScale.r_in = 0.5 * canvas_5.width / 2;
            segmentScale.thickness = 0.3 * canvas_5.width / 2;
            segmentScale.init_angle = -90;
            segmentScale.angle = 135;
            segmentScale.visible = true;

            segmentScale.levels = [
                        { 'divisions_count' : 5, 'mark_length' : 17, 'mark_width' : 2, 'mark_color' : '#00479d' },
                        { 'divisions_count' : 2, 'mark_length' : 10, 'mark_width' : 1, 'mark_color' : '#e5004f' },
                        { 'divisions_count' : 3, 'mark_length' : 5, 'mark_width' : 0.5, 'mark_color' : 'black' }
            ];
            segmentScale.mark_position = 'outer';
            segmentScale.background = '#fcc800';

            segmentScale.build();
            segmentScale.draw();
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(!canvas_5.segmentScale.in_progress) {
                    if(canvas_5.segmentScale.marks_visible) { canvas_5.segmentScale.fadeOut('level-by-level-anticlockwise', 0, 3, 0); }
                    else { canvas_5.segmentScale.fadeIn('level-by-level-clockwise', 0, 3, 0); }
                }
            }
        }
    }

    // Fading Together
    SegmentScaleCanvas {
        id: canvas_6
        width: (parent.width - 10) / 2
        height: (parent.width - 10) / 2

        onCanvasReady: {
            segmentScale.name = "scale_6";
            segmentScale.cx = canvas_6.width / 2;
            segmentScale.cy = canvas_6.height / 2;
            segmentScale.r_in = 0.45 * canvas_6.width / 2;
            segmentScale.thickness = 0.25 * canvas_6.width / 2;
            segmentScale.init_angle = -90;
            segmentScale.angle = 135;
            segmentScale.visible = true;

            let signs = { 'signs_array' : ['0', '1', '2', '3', '4', '5', '6', '7'],
                'text_options' : {
                    'font' : '8pt Arial',
                    'color' : 'black',
                    'border_width' : 0,
                    'border_color' : 'rgba(0, 0, 0, 0)',
                    'direction' : 'vertical'
                }
            };

            segmentScale.levels = [
                        { 'divisions_count' : 6, 'mark_length' : 10, 'mark_width' : 2, 'mark_color' : 'black', 'signs' : signs},
                        { 'divisions_count' : 5, 'mark_length' : 7, 'mark_width' : 1, 'mark_color' : 'black' },
            ];
            segmentScale.mark_position = 'outer';
            segmentScale.sign_r_in = 0.8 * canvas_6.width / 2;

            segmentScale.build();
            segmentScale.draw();
        }
    }
}
