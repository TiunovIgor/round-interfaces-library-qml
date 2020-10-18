import QtQuick 2.12

import "../components"

Canvas {
    id: canvas

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

    property SegmentGauge segmentGauge: SegmentGauge {
        id: item

        onSegmentGaugeChanged: {
            if(initialized) {
                canvas.context.reset();
                segmentGauge.draw();
            }
        }
    }

    function draw() {
        if(initialized);
        segmentGauge.draw();
    }

    onPaint: {
        if(!initialized) {
            let context = getContext('2d');
            segmentGauge.context = context;

            initialized = true;
            canvasReady();
        }

        if(initialized) {
            draw();
        }
    }
}
