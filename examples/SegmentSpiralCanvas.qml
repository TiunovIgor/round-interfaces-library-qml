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

    property SegmentSpiral segmentSpiral: SegmentSpiral {
        id: item

        onSegmentSpiralChanged: {
            if(initialized) {
                canvas.context.reset();
                segmentSpiral.draw();
            }
        }
    }

    function draw() {
        if(initialized);
        segmentSpiral.draw();
    }

    onPaint: {
        if(!initialized) {
            let context = getContext('2d');
            segmentSpiral.context = context;
            initialized = true;
            canvasReady();
        }

        if(initialized) {
            draw();
        }
    }
}
