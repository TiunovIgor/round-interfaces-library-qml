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

    property string caption: "Segment Level Examples"

    Component.onCompleted: {
        let count = gridLayout.getChildCount();
        let height = 0;
        for(let i = 0; i < count; i++){
            height += gridLayout.getChildAt(i).height + 10;
        }
        this.implicitHeight = height;
    }

    // Disappear-Appear One By One
    SegmentLevelCanvas {
        id: canvas_1
        width: (parent.width - 10) / 2
        height: (parent.width - 10) / 2

        onCanvasReady: {
            segmentLevel.name = "lvl_1";
            segmentLevel.cx = canvas_1.width / 2;
            segmentLevel.cy = canvas_1.height / 2;
            segmentLevel.r_in = 0.3 * canvas_1.width / 2;
            segmentLevel.visible = true;

            let r = canvas_1.width / 2;

            let segment_component = Qt.createComponent("../components/Segment.qml");

            let seg_1 = segment_component.createObject(this, {
                 id: 'seg_1', context: segmentLevel.context, cx: segmentLevel.cx, cy: segmentLevel.cy,
                 r_in: 0.3 * r, thickness: 0.4 * r, init_angle: -10, angle: 45 });
            seg_1.background = '#e5004f';
            seg_1.calc();

            let seg_2 = segment_component.createObject(this, {
                 id: 'seg_2', context: segmentLevel.context, cx: segmentLevel.cx, cy: segmentLevel.cy,
                 r_in: 0.3 * r, thickness: 0.35 * r, init_angle: 95, angle: 40 });
            seg_2.background = '#22ac38';
            seg_2.calc();

            let seg_3 = segment_component.createObject(this, {
                 id: 'seg_3', context: segmentLevel.context, cx: segmentLevel.cx, cy: segmentLevel.cy,
                 r_in: 0.3 * r, thickness: 0.3 * r, init_angle: 210, angle: 50 });
            seg_3.background = '#00a0e9';
            seg_3.calc();

            segmentLevel.addSegment(seg_1);
            segmentLevel.addSegment(seg_2);
            segmentLevel.addSegment(seg_3);

            segmentLevel.build();
            segmentLevel.draw();
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(!canvas_1.segmentLevel.in_progress) {
                    if(canvas_1.segmentLevel.segments_visible) { canvas_1.segmentLevel.disappear('one-by-one-clockwise', 0, 'to-axis', 2, 0); }
                    else { canvas_1.segmentLevel.appear('one-by-one-anticlockwise', 0, 'from-axis', 1.5, 0); }
                }
            }
        }
    }

    // Disappear-Appear Together
    SegmentLevelCanvas {
        id: canvas_2
        width: (parent.width - 10) / 2
        height: (parent.width - 10) / 2

        onCanvasReady: {
            segmentLevel.name = "lvl_2";
            segmentLevel.cx = canvas_2.width / 2;
            segmentLevel.cy = canvas_2.height / 2;
            segmentLevel.r_in = 0.3 * canvas_2.width / 2;
            segmentLevel.visible = true;

            let r = canvas_2.width / 2;

            let segment_component = Qt.createComponent("../components/Segment.qml");

            let seg_1 = segment_component.createObject(this, {
                 id: 'seg_1', context: segmentLevel.context, cx: segmentLevel.cx, cy: segmentLevel.cy,
                 r_in: 0.3 * r, thickness: 0.4 * r, init_angle: -10, angle: 45 });
            seg_1.background = '#22ac38';
            seg_1.calc();

            let seg_2 = segment_component.createObject(this, {
                 id: 'seg_2', context: segmentLevel.context, cx: segmentLevel.cx, cy: segmentLevel.cy,
                 r_in: 0.3 * r, thickness: 0.35 * r, init_angle: 95, angle: 60 });
            seg_2.background = '#00a0e9';
            seg_2.calc();

            let seg_3 = segment_component.createObject(this, {
                 id: 'seg_3', context: segmentLevel.context, cx: segmentLevel.cx, cy: segmentLevel.cy,
                 r_in: 0.3 * r, thickness: 0.3 * r, init_angle: 210, angle: 75 });
            seg_3.background = '#00479d';
            seg_3.calc();

            segmentLevel.addSegment(seg_1);
            segmentLevel.addSegment(seg_2);
            segmentLevel.addSegment(seg_3);

            segmentLevel.build();
            segmentLevel.draw();
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(!canvas_2.segmentLevel.in_progress) {
                    if(canvas_2.segmentLevel.segments_visible) { canvas_2.segmentLevel.disappear('together', 0, 'clockwise', 1.5, 0); }
                    else { canvas_2.segmentLevel.appear('together', 0, 'anticlockwise', 1.5, 0); }
                }
            }
        }
    }

    // Rotation for 45° during 3 seconds
    SegmentLevelCanvas {
        id: canvas_3
        width: (parent.width - 10) / 2
        height: (parent.width - 10) / 2

        onCanvasReady: {
            segmentLevel.name = "lvl_3";
            segmentLevel.cx = canvas_3.width / 2;
            segmentLevel.cy = canvas_3.height / 2;
            segmentLevel.r_in = 0.3 * canvas_3.width / 2;
            segmentLevel.visible = true;

            let r = canvas_3.width / 2;

            let segment_component = Qt.createComponent("../components/Segment.qml");

            let seg_1 = segment_component.createObject(this, {
                 id: 'seg_1', context: segmentLevel.context, cx: segmentLevel.cx, cy: segmentLevel.cy,
                 r_in: 0.15 * r, thickness: 0.35 * r, init_angle: -30, angle: 30 });
            seg_1.background = '#e5004f';
            seg_1.calc();

            let seg_2 = segment_component.createObject(this, {
                 id: 'seg_2', context: segmentLevel.context, cx: segmentLevel.cx, cy: segmentLevel.cy,
                 r_in: 0.4 * r, thickness: 0.2 * r, init_angle: 95, angle: 60 });
            seg_2.background = '#fcc800';
            seg_2.calc();

            let seg_3 = segment_component.createObject(this, {
                 id: 'seg_3', context: segmentLevel.context, cx: segmentLevel.cx, cy: segmentLevel.cy,
                 r_in: 0.25 * r, thickness: 0.40 * r, init_angle: 210, angle: 75 });
            seg_3.background = '#22ac38';
            seg_3.calc();

            segmentLevel.addSegment(seg_1);
            segmentLevel.addSegment(seg_2);
            segmentLevel.addSegment(seg_3);

            segmentLevel.build();
            segmentLevel.draw();
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(!canvas_3.segmentLevel.in_progress) {
                    canvas_3.segmentLevel.rotate('one-by-one-clockwise', 0.5, 'clockwise', 45, 3, 0);
                }
            }
        }
    }

    // Fading One By One
    SegmentLevelCanvas {
        id: canvas_4
        width: (parent.width - 10) / 2
        height: (parent.width - 10) / 2

        onCanvasReady: {
            segmentLevel.name = "lvl_4";
            segmentLevel.cx = canvas_4.width / 2;
            segmentLevel.cy = canvas_4.height / 2;
            segmentLevel.r_in = 0.3 * canvas_4.width / 2;
            segmentLevel.visible = true;

            let r = canvas_4.width / 2;

            let segment_component = Qt.createComponent("../components/Segment.qml");

            let seg_1 = segment_component.createObject(this, {
                 id: 'seg_1', context: segmentLevel.context, cx: segmentLevel.cx, cy: segmentLevel.cy,
                 r_in: 0.15 * r, thickness: 0.35 * r, init_angle: 30, angle: 30 });
            seg_1.background = '#00a0e9';
            seg_1.calc();

            let seg_2 = segment_component.createObject(this, {
                 id: 'seg_2', context: segmentLevel.context, cx: segmentLevel.cx, cy: segmentLevel.cy,
                 r_in: 0.4 * r, thickness: 0.2 * r, init_angle: 105, angle: 60 });
            seg_2.background = '#00479d';
            seg_2.calc();

            let seg_3 = segment_component.createObject(this, {
                 id: 'seg_3', context: segmentLevel.context, cx: segmentLevel.cx, cy: segmentLevel.cy,
                 r_in: 0.25 * r, thickness: 0.4 * r, init_angle: 230, angle: 75 });
            seg_3.background = '#e5004f';
            seg_3.calc();

            segmentLevel.addSegment(seg_1);
            segmentLevel.addSegment(seg_2);
            segmentLevel.addSegment(seg_3);

            segmentLevel.build();
            segmentLevel.draw();
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(!canvas_4.segmentLevel.in_progress) {
                    if(canvas_4.segmentLevel.segments_visible) { canvas_4.segmentLevel.fadeOut('one-by-one-clockwise', 0, 2, 0); }
                    else { canvas_4.segmentLevel.fadeIn('one-by-one-anticlockwise', 0, 2, 0); }
                }
            }
        }
    }
}
