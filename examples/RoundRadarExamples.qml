import QtQuick 2.12
import QtQuick.Controls 2.1
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.12

import "../components"

GridLayout {
    id: gridLayout
    Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
    implicitWidth: parent.width

    columns: 1
    rowSpacing: 10

    property string caption: "Round Radar Examples"

    Component.onCompleted: {
        let count = gridLayout.getChildCount();
        let height = 0;
        for(let i = 0; i < count; i++){
            height += gridLayout.getChildAt(i).height + 10;
        }
        this.implicitHeight = height;
    }

    function createTargets(w) {
        let targets = [
                { 'id' : '1', 'x' : Math.random() * w - 0.5 * w, 'y' : Math.random() * w - 0.5 * w },
                { 'id' : '2', 'x' : Math.random() * w - 0.5 * w, 'y' : Math.random() * w - 0.5 * w },
                { 'id' : '3', 'x' : Math.random() * w - 0.5 * w, 'y' : Math.random() * w - 0.5 * w }
            ];
        return targets;
    }

    RoundRadarCanvas {
        id: canvas_1
        width: parent.width * 3 / 4
        height: parent.width * 3 / 4

        onCanvasReady: {
            segmentRadar.name = "radar_1";
            segmentRadar.cx = canvas_1.width / 2;
            segmentRadar.cy = canvas_1.height / 2;
            segmentRadar.thickness = 0.8 * canvas_1.width / 2;
            segmentRadar.visible = true;

            segmentRadar.build();

            segmentRadar.grid.background = 'black';
            segmentRadar.grid.circles_count = 5;
            segmentRadar.grid.circle_width = 1;
            segmentRadar.grid.circle_color = 'rgba(32, 81, 0, 1)';
            segmentRadar.grid.beams_count = 30;
            segmentRadar.grid.beam_width = 1;
            segmentRadar.grid.beam_color = 'rgba(32, 81, 0, 1)';
            segmentRadar.grid.build();

            segmentRadar.frame.gradient = Qt.createQmlObject('import "../components";
                SegmentGradient { type: "radial"; direction: "from-center"; stops_string: "rgba(0, 255, 0, 1) 20%, rgba(0, 105, 0, 1) 100%" }', this, "grad_1");

            segmentRadar.frame.r_in = segmentRadar.thickness;
            segmentRadar.frame.thickness = 5;
            segmentRadar.frame.calc();

            segmentRadar.dot_gradient = Qt.createQmlObject('import "../components";
                SegmentGradient { type: "radial"; direction: "from-center"; stops_string: "rgba(0, 255, 0, 1) 20%, rgba(0, 105, 0, 1) 100%" }', this, "grad_2");
            segmentRadar.dot_radius = 3;

            segmentRadar.locator.gradient = Qt.createQmlObject('import "../components"; SegmentGradient { type: "conic"; direction: "clockwise";
                stops_string: "rgba(0, 255, 0, 0.2) 0%, rgba(32, 81, 0, 0.6) 100%" }', this, "grad_3");

            segmentRadar.factor = 1;

            segmentRadar.locator.calc();
            segmentRadar.targetsToDots(createTargets(canvas_1.width / 2));

            segmentRadar.draw();

            segmentRadar.startLocator();
        }

        MouseArea {
            id: area_1
            anchors.fill: parent

            onClicked: {
                let w = canvas_1.width / 2;
                canvas_1.segmentRadar.targetsToDots(createTargets(w));
            }
        }
    }

    RoundRadarCanvas {
        id: canvas_2
        width: parent.width * 3 / 4
        height: parent.width * 3 / 4

        onCanvasReady: {
            segmentRadar.name = "radar_2";
            segmentRadar.cx = canvas_2.width / 2;
            segmentRadar.cy = canvas_2.height / 2;
            segmentRadar.thickness = 0.8 * canvas_2.width / 2;
            segmentRadar.visible = true;

            segmentRadar.build();

            //segmentRadar.grid.gradient = new SegmentGradient('radial', 'from-center', 'rgba(55, 145, 160) 0%, rgba(0, 0, 0) 100%');
            segmentRadar.grid.gradient = Qt.createQmlObject('import "../components"; SegmentGradient { type: "radial"; direction: "from-center"; name: "radar grid radial";
                stops_string: "rgba(55, 145, 160, 1) 0%, rgba(0, 0, 0, 1) 100%" }', this, "grad_4");

            segmentRadar.grid.circles_count = 3;
            segmentRadar.grid.circle_width = 1;
            segmentRadar.grid.circle_color = 'rgba(135, 150, 145, 0.5)';
            segmentRadar.grid.beams_count = 8;
            segmentRadar.grid.beam_width = 1;
            segmentRadar.grid.beam_color = 'rgba(135, 150, 145, 0.5)';
            segmentRadar.grid.build();

            //segmentRadar.frame.gradient = new SegmentGradient('conic', 'clockwise',
            //    'rgba(250, 250, 250, 1) 0%, rgba(210, 210, 210, 1) 30%, rgba(250, 250, 250, 1) 50%, rgba(220, 220, 220, 1) 70%, rgba(250, 250, 250, 1) 100%');
            /*
            segmentRadar.frame.gradient = Qt.createQmlObject('import "../components"; SegmentGradient { type: "conic"; direction: "clockwise"; name: "radar frame conic";
                stops_string: "rgba(250, 250, 250, 1) 0%, rgba(210, 210, 210, 1) 30%, rgba(250, 250, 250, 1) 50%, rgba(220, 220, 220, 1) 70%, rgba(250, 250, 250, 1) 100%" }',
                this, "grad_5");
            */
            segmentRadar.frame.gradient = Qt.createQmlObject('import "../components"; SegmentGradient { type: "conic"; direction: "clockwise"; name: "radar frame conic";
                stops_string: "rgba(250, 250, 250, 1) 0%, rgba(210, 210, 210, 1) 30%, orange 50%, rgba(220, 220, 220, 1) 70%, rgba(250, 250, 250, 1) 100%" }',
                this, "grad_5");

            segmentRadar.frame.thickness = 9;
            segmentRadar.frame.calc();

            segmentRadar.dot_radius = 4;
            segmentRadar.dot_background = 'rgba(128, 240, 235, 1)';

            segmentRadar.locator.angle = 60;
            segmentRadar.locator_period = 3;

            //segmentRadar.locator.gradient = new SegmentGradient('conic', 'clockwise', 'rgba(80, 190, 195, 0) 0%, rgba(128, 240, 235, 0.2) 100%');
            segmentRadar.locator.gradient = Qt.createQmlObject('import "../components"; SegmentGradient { type: "conic"; direction: "clockwise";
                stops_string: "rgba(80, 190, 195, 0) 0%, rgba(128, 240, 235, 0.4) 100%" }', this, "grad_6");

            segmentRadar.factor = 1;

            segmentRadar.locator.calc();
            segmentRadar.targetsToDots(createTargets(canvas_2.width / 2));

            segmentRadar.draw();

            segmentRadar.startLocator();
        }

        MouseArea {
            id: area_2
            anchors.fill: parent

            onClicked: {
                let w = canvas_2.width / 2;
                canvas_2.segmentRadar.targetsToDots(createTargets(w));
            }
        }
    }
}
