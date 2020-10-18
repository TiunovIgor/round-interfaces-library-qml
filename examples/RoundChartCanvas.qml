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

    property SegmentChart segmentChart: SegmentChart {
        id: item

        onSegmentChartChanged: {
            if(initialized) {
                canvas.context.reset();
                segmentChart.draw();
            }
        }
    }

    function draw() {
        if(initialized);
        segmentChart.draw();
    }

    onPaint: {
        if(!initialized) {
            let context = getContext('2d');
            segmentChart.context = context;
            segmentChart.segments.forEach(function(segment) {
                segment.context = context;
            });
            segmentChart.signs.forEach(function(sign) {
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
