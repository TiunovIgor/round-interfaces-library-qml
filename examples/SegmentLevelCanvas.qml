import QtQuick 2.12

import "../components"

Canvas {
    id: canvas

    property var initialized: false;
    signal canvasReady;

    Rectangle {
        color: "transparent"
        anchors.fill: parent
        border.width: 1
        border.color: "#ddd"
    }

    property SegmentLevel segmentLevel: SegmentLevel {
        id: item

        onSegmentLevelChanged: {
            if(initialized) {
                canvas.context.reset();
                segmentLevel.draw();
            }
        }
    }

    function draw() {
        if(initialized);
        segmentLevel.draw();
    }

    onPaint: {
        if(!initialized) {
            let context = getContext('2d');
            segmentLevel.context = context;
            segmentLevel.segments.forEach(function(segment) {
                segment.context = context;
            });

            initialized = true;
            canvasReady();
        }

        if(initialized) {
            draw();
        }
    }
}
