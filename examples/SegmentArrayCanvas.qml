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

    property SegmentArray segmentArray: SegmentArray {
        id: item

        onSegmentArrayChanged: {
            if(initialized) {
                canvas.context.clearRect(0, 0, canvas.width, canvas.height);
                segmentArray.draw();
            }
        }
    }

    function draw() {
        canvas.context.clearRect(0, 0, canvas.width, canvas.height);
        segmentArray.draw();
    }

    onPaint: {
        if(!initialized) {
            let context = getContext('2d');
            segmentArray.context = context;
            segmentArray.segments.forEach(function(segment) {
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
