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

    property Segment segment: Segment {
        id: item

        onSegmentChanged: {
            if(initialized) {
                canvas.context.reset();
                segment.draw();
            }
        }
    }

    function draw() {
        if(initialized);
        segment.draw();
    }

    onPaint: {
        if(!initialized) {
            let context = getContext('2d');
            segment.context = context;
            initialized = true;
            canvasReady();
        }

        if(initialized) {
            draw();
        }
    }
}
