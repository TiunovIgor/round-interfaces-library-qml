import QtQuick 2.0

import "../components"

Canvas {
    id: canvas

    property var initialized: false;
    signal canvasReady;

    /*
    Rectangle {
        color: "transparent"
        anchors.fill: parent
        border.width: 1
        border.color: "#666"
    }
    */

    property SegmentProgressBar segmentProgressBar: SegmentProgressBar {
        onSegmentProgressBarChanged: {
            if(initialized) {
                canvas.context.reset();
                segmentProgressBar.draw();
            }
        }
    }
    property SegmentArrayProgressBar segmentArrayProgressBar: SegmentArrayProgressBar {
        onSegmentArrayProgressBarChanged: {
            if(initialized) {
                canvas.context.reset();
                segmentArrayProgressBar.draw();
            }
        }
    }
    property SegmentDotsArrayProgressBar segmentDotsArrayProgressBar: SegmentDotsArrayProgressBar {
        onSegmentDotsArrayProgressBarChanged: {
            if(initialized) {
                canvas.context.reset();
                segmentDotsArrayProgressBar.draw();
            }
        }
    }

    function draw() {
        if(initialized) {
            if(segmentProgressBar) segmentProgressBar.draw();
            if(segmentArrayProgressBar) segmentArrayProgressBar.draw();
            if(segmentDotsArrayProgressBar) segmentDotsArrayProgressBar.draw();
        }
    }

    onPaint: {
        if(!initialized) {
            let context = getContext('2d');
            if(segmentProgressBar) segmentProgressBar.context = context;
            if(segmentArrayProgressBar) segmentArrayProgressBar.context = context;
            if(segmentDotsArrayProgressBar) segmentDotsArrayProgressBar.context = context;

            initialized = true;
            canvasReady();
        }

        if(initialized) {
            draw();
        }
    }
}
