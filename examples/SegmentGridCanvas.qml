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

    property SegmentGrid segmentGrid: SegmentGrid {
        id: item

        onSegmentChanged: {
            if(initialized) {
                canvas.context.reset();
                segmentGrid.draw();
            }
        }
    }

    function draw() {
        if(initialized);
        segmentGrid.draw();
    }

    onPaint: {
        if(!initialized) {
            let context = getContext('2d');
            segmentGrid.context = context;
            initialized = true;
            canvasReady();
        }

        if(initialized) {
            draw();
        }
    }
}
