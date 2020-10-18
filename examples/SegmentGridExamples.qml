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

    property string caption: "Segment Grid Examples"

    Component.onCompleted: {
        let count = gridLayout.getChildCount();
        let height = 0;
        for(let i = 0; i < count; i++){
            height += gridLayout.getChildAt(i).height + 10;
        }
        this.implicitHeight = height;
    }

    // Default Segment Grid
    SegmentGridCanvas {
        id: canvas_1
        width: (parent.width - 10) / 2
        height: (parent.width - 10) / 2

        onCanvasReady: {
            segmentGrid.name = "grid_1";
            segmentGrid.cx = canvas_1.width / 2;
            segmentGrid.cy = canvas_1.height / 2;
            segmentGrid.r_in = 0.5 * canvas_1.width / 2;
            segmentGrid.thickness = 0.3 * canvas_1.width / 2;
            segmentGrid.init_angle = 180;
            segmentGrid.angle = 270;
            segmentGrid.visible = true;

            segmentGrid.build();
            segmentGrid.calc();
            segmentGrid.draw();
        }
    }

    // Segment Grid Circle
    SegmentGridCanvas {
        id: canvas_2
        width: (parent.width - 10) / 2
        height: (parent.width - 10) / 2

        onCanvasReady: {
            segmentGrid.name = "grid_2";
            segmentGrid.cx = canvas_2.width / 2;
            segmentGrid.cy = canvas_2.height / 2;
            segmentGrid.r_in = 0;
            segmentGrid.thickness = 0.5 * canvas_2.width / 2;
            segmentGrid.init_angle = -90;
            segmentGrid.angle = 360;
            segmentGrid.visible = true;

            segmentGrid.build();
            segmentGrid.calc();
            segmentGrid.draw();
        }
    }

    // Segment Grid for Target
    SegmentGridCanvas {
        id: canvas_3
        width: (parent.width - 10) / 2
        height: (parent.width - 10) / 2

        onCanvasReady: {
            segmentGrid.name = "grid_3";
            segmentGrid.cx = canvas_3.width / 2;
            segmentGrid.cy = canvas_3.height / 2;
            segmentGrid.r_in = 0;
            segmentGrid.thickness = 0.8 * canvas_3.width / 2;
            segmentGrid.init_angle = -90;
            segmentGrid.angle = 360;
            segmentGrid.visible = true;

            segmentGrid.background = 'white';
            segmentGrid.border_width = 3;
            segmentGrid.border_color = 'black';
            segmentGrid.beams_count = 8;
            segmentGrid.beam_width = 1;
            segmentGrid.beam_color = 'black';
            segmentGrid.circles_count = 4;
            segmentGrid.circle_width = 2;
            segmentGrid.circle_color = 'red';

            segmentGrid.build();
            segmentGrid.calc();
            segmentGrid.draw();
        }
    }

    // Segment Grid for Radar
    SegmentGridCanvas {
        id: canvas_4
        width: (parent.width - 10) / 2
        height: (parent.width - 10) / 2

        onCanvasReady: {
            segmentGrid.name = "grid_4";
            segmentGrid.cx = canvas_4.width / 2;
            segmentGrid.cy = canvas_4.height / 2;
            segmentGrid.r_in = 0;
            segmentGrid.thickness = 0.8 * canvas_4.width / 2;
            segmentGrid.init_angle = -90;
            segmentGrid.angle = 360;
            segmentGrid.visible = true;

            segmentGrid.background = 'black';
            segmentGrid.border_width = 2;
            segmentGrid.border_color = 'green';
            segmentGrid.circles_count = 5;
            segmentGrid.circle_color = 'green';
            segmentGrid.beams_count = 16;
            segmentGrid.beam_color = 'green';

            segmentGrid.build();
            segmentGrid.calc();
            segmentGrid.draw();
        }
    }
}
