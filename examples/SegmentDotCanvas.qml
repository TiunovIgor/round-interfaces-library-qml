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

    property SegmentDot segmentDot: SegmentDot {
        id: item

        onSegmentDotChanged: {
            if(initialized) {
                canvas.context.reset();
                segmentDot.draw();
            }
        }
    }

    function draw() {
        if(initialized);
        segmentDot.draw();
    }

    onPaint: {
        if(!initialized) {
            let context = getContext('2d');
            segmentDot.context = context;
            initialized = true;
            canvasReady();
        }

        if(initialized) {
            draw();
        }
    }
}
