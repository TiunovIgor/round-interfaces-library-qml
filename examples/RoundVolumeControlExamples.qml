import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.12

import "../components"

GridLayout {
    id: gridLayout
    Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
    implicitWidth: parent.width

    columns: 1
    rowSpacing: 30

    property string caption: "Round Volume Control Examples"

    Component.onCompleted: {
        let count = gridLayout.getChildCount();
        let height = 0;
        for(let i = 0; i < count; i++){
            height += gridLayout.getChildAt(i).height + 10;
        }
        this.implicitHeight = height;
    }

    RoundVolumeControlCanvas {
        id: canvas_1
        width: parent.width * 3 / 4
        height: parent.width * 3 / 4

        onCanvasReady: {
            segmentSpiralVolumeControl.name = "control_1";
            segmentSpiralVolumeControl.cx = canvas_1.width / 2;
            segmentSpiralVolumeControl.cy = canvas_1.height / 2;
            segmentSpiralVolumeControl.r_in = 0.6 * canvas_1.width / 2;
            segmentSpiralVolumeControl.thickness = 0.15 * canvas_1.width / 2;
            segmentSpiralVolumeControl.init_angle = 135;
            segmentSpiralVolumeControl.angle = 270;
            segmentSpiralVolumeControl.visible = true;

            segmentSpiralVolumeControl.build();

            segmentSpiralVolumeControl.knob.dot_base_radius = 0.35 * canvas_1.width / 2;
            segmentSpiralVolumeControl.knob.notch_init_angle = 135;
            segmentSpiralVolumeControl.knob.notch_min_angle = 135;
            segmentSpiralVolumeControl.knob.notch_max_angle = 135 + 270;
            segmentSpiralVolumeControl.knob.thickness = 0.50 * canvas_1.width / 2;
            segmentSpiralVolumeControl.knob.build();
            //segmentSpiralVolumeControl.removeKnobListeners();
            segmentSpiralVolumeControl.knob.setNotchAngle(segmentSpiralVolumeControl.knob.notch_min_angle);

            /*
            segmentSpiralVolumeControl.knob.base_segment.gradient = Qt.createQmlObject('import "../components";
                SegmentGradient { type: "conic"; direction: "clockwise"; name: "volume knob";
                stops_string: "#ccc 0%, #ddd 23%, #eee 25%, #ddd 27%, #ddd 73%, #eee 75%, #ddd 77%, #ccc 100%" }', this, "grad_1");
            */

            /*
            segmentSpiralVolumeControl.knob.base_segment.gradient = Qt.createQmlObject('import "../components";
                SegmentGradient { type: "conic"; direction: "clockwise"; name: "volume knob";
                stops_string: "#ccc 0%, orange 23%, purple 100%" }', this, "grad_1");
            */

            segmentSpiralVolumeControl.knob.base_segment.gradient = Qt.createQmlObject('import "../components";
                SegmentGradient { type: "radial"; direction: "from-center"; stops_string: "#fff 0%, #eee 80%, #ccc 86%, #666 90%, #eee 95%, #ddd 100%" }',
                this, "grad_1");

            segmentSpiralVolumeControl.knob.base_segment.calc();

            //segmentSpiralVolumeControl.base_spiral.background = 'rgba(240, 240, 240, 1)';
            //segmentSpiralVolumeControl.base_spiral.border_color = 'rgba(100, 100, 100, 1)';
            segmentSpiralVolumeControl.base_spiral.calc();

            //segmentSpiralVolumeControl.active_spiral.gradient = new SegmentGradient('conic', 'clockwise', '#0086d1 0%, #006096 100%');
            segmentSpiralVolumeControl.active_spiral.background = 'rgba(50, 50, 50, 1)';
            segmentSpiralVolumeControl.active_spiral.calc();

            segmentSpiralVolumeControl.draw();
        }
        MouseArea {
            id: area_1
            anchors.fill: parent

            onPressed: { canvas_1.segmentSpiralVolumeControl.catchKnob(mouse); }
            onPositionChanged: {
                if(canvas_1.segmentSpiralVolumeControl.knob.is_active) {
                    area_1.preventStealing = true;
                    canvas_1.segmentSpiralVolumeControl.rotateKnobByMouseMovement(mouse);
                }
            }
            onWheel: { canvas_1.segmentSpiralVolumeControl.rotateKnobByMouseWheel(wheel); }
            onReleased: {
                canvas_1.segmentSpiralVolumeControl.releaseKnob();
                area_1.preventStealing = false;
            }
            onExited: {
                canvas_1.segmentSpiralVolumeControl.releaseKnob();
                area_1.preventStealing = false;
            }
        }
    }

    RoundVolumeControlCanvas {
        id: canvas_2
        width: parent.width * 3 / 4
        height: parent.width * 3 / 4

        onCanvasReady: {
            segmentArrayVolumeControl.name = "control_2";
            segmentArrayVolumeControl.cx = canvas_2.width / 2;
            segmentArrayVolumeControl.cy = canvas_2.height / 2;
            segmentArrayVolumeControl.r_in = 0.5 * canvas_2.width / 2;
            segmentArrayVolumeControl.thickness = 0.2 * canvas_2.width / 2;
            segmentArrayVolumeControl.init_angle = 135;
            segmentArrayVolumeControl.angle = 270;
            segmentArrayVolumeControl.visible = true;

            segmentArrayVolumeControl.build();

            segmentArrayVolumeControl.knob.dot_base_radius = 0.35 * canvas_2.width / 2;
            segmentArrayVolumeControl.knob.notch_init_angle = 135;
            segmentArrayVolumeControl.knob.notch_min_angle = 135;
            segmentArrayVolumeControl.knob.notch_max_angle = 135 + 270;
            segmentArrayVolumeControl.knob.thickness = 0.5 * canvas_2.width / 2;
            segmentArrayVolumeControl.knob.build();
            //segmentArrayVolumeControl.removeKnobListeners();
            segmentArrayVolumeControl.knob.setNotchAngle(segmentArrayVolumeControl.knob.notch_min_angle);


            //segmentArrayVolumeControl.knob.base_segment.gradient = new SegmentGradient('conic', 'clockwise', '#ccc 0%, #ddd 23%, #eee 25%, #ddd 27%, #ddd 73%, #eee 75%, #ddd 77%, #ccc 100%');
            segmentArrayVolumeControl.knob.base_segment.gradient = Qt.createQmlObject('import "../components";
                SegmentGradient { type: "radial"; direction: "from-center"; stops_string: "#fff 0%, #eee 80%, #ccc 86%, #666 90%, #eee 95%, #ddd 100%" }',
                this, "grad_3");
            //segmentArrayVolumeControl.knob.base_segment.gradient = new SegmentGradient('radial', 'from-center', '#fff 0%, #eee 80%, #ccc 86%, #666 90%, #eee 95%, #ddd 100%');
            segmentArrayVolumeControl.knob.base_segment.calc();

            segmentArrayVolumeControl.segment_array.segments_count = 36;
            segmentArrayVolumeControl.segment_array.proportional = true;
            segmentArrayVolumeControl.segment_array.background = 'rgba(240, 240, 240, 0)';
            segmentArrayVolumeControl.segment_array.border_color = 'rgba(100, 100, 100, 0)';
            //vol_4.segment_array.segment_background = '#0099ee';
            segmentArrayVolumeControl.segment_array.build();
            segmentArrayVolumeControl.segment_array.calc();

            segmentArrayVolumeControl.calc();

            segmentArrayVolumeControl.draw();
        }
        MouseArea {
            id: area_2
            anchors.fill: parent

            onPressed: { canvas_2.segmentArrayVolumeControl.catchKnob(mouse); }
            onPositionChanged: {
                if(canvas_2.segmentArrayVolumeControl.knob.is_active) {
                    area_2.preventStealing = true;
                    canvas_2.segmentArrayVolumeControl.rotateKnobByMouseMovement(mouse);
                }
            }
            onWheel: { canvas_2.segmentArrayVolumeControl.rotateKnobByMouseWheel(wheel); }
            onReleased: {
                canvas_2.segmentArrayVolumeControl.releaseKnob();
                area_2.preventStealing = false;
            }
            onExited: {
                canvas_2.segmentArrayVolumeControl.releaseKnob();
                area_2.preventStealing = false;
            }
        }
    }
}
