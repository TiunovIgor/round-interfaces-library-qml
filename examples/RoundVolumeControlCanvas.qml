import QtQuick 2.0

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

    property SegmentSpiralVolumeControl segmentSpiralVolumeControl: SegmentSpiralVolumeControl {
        onSegmentSpiralVolumeControlChanged: {
            if(initialized) {
                //console.log('segmentSpiralVolumeControlChanged');
                canvas.requestAnimationFrame(function() {
                    canvas.context.reset();
                    segmentSpiralVolumeControl.draw();
                });
            }
        }
    }
    property SegmentArrayVolumeControl segmentArrayVolumeControl: SegmentArrayVolumeControl {
        onSegmentArrayVolumeControlChanged: {
            if(initialized) {
                canvas.requestAnimationFrame(function() {
                    canvas.context.reset();
                    segmentArrayVolumeControl.draw();
                });
            }
        }
    }

    function draw() {
        if(initialized) {
            if(segmentSpiralVolumeControl) segmentSpiralVolumeControl.draw();
            if(segmentArrayVolumeControl) segmentArrayVolumeControl.draw();
        }
    }

    onPaint: {
        if(!initialized) {
            let context = getContext('2d');
            if(segmentSpiralVolumeControl) {
                segmentSpiralVolumeControl.context = context;
                segmentSpiralVolumeControl.base_spiral.context = context;
                segmentSpiralVolumeControl.active_spiral.context = context;
                segmentSpiralVolumeControl.knob.context = context;
            }
            if(segmentArrayVolumeControl) {
                segmentArrayVolumeControl.context = context;
                segmentArrayVolumeControl.segment_array.context = context;
                segmentArrayVolumeControl.knob.context = context;
            }

            initialized = true;
            canvasReady();
        }

        if(initialized) {
            draw();
        }
    }
}
