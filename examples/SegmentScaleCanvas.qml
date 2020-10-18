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

    property SegmentScale segmentScale: SegmentScale {
        id: item

        onSegmentScaleChanged: {
            if(initialized) {
                canvas.context.reset();
                segmentScale.draw();
            }
        }
    }

    function draw() {
        if(initialized);
        canvas.context.reset();
        segmentScale.draw();
    }

    onPaint: {
        if(!initialized) {
            let context = getContext('2d');
            segmentScale.context = context;
            segmentScale.marks.forEach(function(mark) {
                mark.context = context;
            });
            segmentScale.signs.forEach(function(sign) {
                sign.context = context;
            });

            initialized = true;
            canvasReady();
        }

        if(initialized) {
            draw();
        }
    }
}
