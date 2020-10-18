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

    property SegmentTimer segmentTimer: SegmentTimer {
        onSegmentTimerChanged: {
            if(initialized) {
                canvas.context.reset();
                segmentTimer.draw();
            }
        }

        onSegmentTimerIsUp: {
            segmentTimer.stop();
        }
    }
    property SegmentArrayTimer segmentArrayTimer: SegmentArrayTimer {
        onSegmentArrayTimerChanged: {
            if(initialized) {
                canvas.context.reset();
                segmentArrayTimer.draw();
            }
        }

        onSegmentArrayTimerIsUp: {
            segmentArrayTimer.stop();
        }
    }
    property SegmentDotsArrayTimer segmentDotsArrayTimer: SegmentDotsArrayTimer {
        onSegmentDotsArrayTimerChanged: {
            if(initialized) {
                canvas.context.reset();
                segmentDotsArrayTimer.draw();
            }
        }

        onSegmentDotsArrayTimerIsUp: {
            segmentDotsArrayTimer.stop();
        }
    }
    property SegmentGaugeTimer segmentGaugeTimer: SegmentGaugeTimer {
        onSegmentGaugeTimerChanged: {
            if(initialized) {
                canvas.context.reset();
                segmentGaugeTimer.draw();
            }
        }

        onSegmentGaugeTimerIsUp: {
            segmentGaugeTimer.stop();
        }
    }

    function draw() {
        if(initialized) {
            if(segmentTimer) segmentTimer.draw();
            if(segmentArrayTimer) segmentArrayTimer.draw();
            if(segmentDotsArrayTimer) segmentDotsArrayTimer.draw();
            if(segmentGaugeTimer) segmentGaugeTimer.draw();
        }
    }

    onPaint: {
        if(!initialized) {
            let context = getContext('2d');
            if(segmentTimer) segmentTimer.context = context;
            if(segmentArrayTimer) segmentArrayTimer.context = context;
            if(segmentDotsArrayTimer) segmentDotsArrayTimer.context = context;
            if(segmentGaugeTimer) segmentGaugeTimer.context = context;

            initialized = true;
            canvasReady();
        }

        if(initialized) {
            draw();
        }
    }
}
