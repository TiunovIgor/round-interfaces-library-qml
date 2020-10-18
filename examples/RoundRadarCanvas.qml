import QtQuick 2.12

import "../components"

Canvas {
    id: canvas
    antialiasing: true

    property var initialized: false;
    signal canvasReady;

    anchors.horizontalCenter: parent.horizontalCenter

    /*
    Rectangle {
        color: "transparent"
        anchors.fill: parent
        border.width: 1
        border.color: "#666"
    }
    */

    property SegmentRadar segmentRadar: SegmentRadar {
        id: item

        onSegmentRadarChanged: {
            if(initialized) {
                canvas.context.clearRect(0, 0, canvas.width, canvas.height);
                segmentRadar.draw();
            }
        }

        onSegmentRadarTargetsChanged: {
            if(initialized) {
                canvas.context.clearRect(0, 0, canvas.width, canvas.height);
                segmentRadar.draw();
            }
        }
    }

    function draw() {
        if(initialized);
        canvas.context.clearRect(0, 0, canvas.width, canvas.height);
        segmentRadar.draw();
    }

    onPaint: {
        if(!initialized) {
            let context = getContext('2d');
            segmentRadar.context = context;

            initialized = true;
            canvasReady();
        }
        else {
            draw();
        }
    }
}
