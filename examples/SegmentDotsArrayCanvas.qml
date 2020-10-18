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

    property SegmentDotsArray segmentDotsArray: SegmentDotsArray {
        id: item

        onSegmentDotsArrayChanged: {
            if(initialized) {
                canvas.context.reset();
                segmentDotsArray.draw();
            }
        }
    }

    function draw() {
        if(initialized);
        segmentDotsArray.draw();
    }

    onPaint: {
        if(!initialized) {
            let context = getContext('2d');
            segmentDotsArray.context = context;
            segmentDotsArray.dots.forEach(function(dot) {
                dot.context = context;
            });

            initialized = true;
            canvasReady();
        }

        if(initialized) {
            draw();
        }
    }
}
