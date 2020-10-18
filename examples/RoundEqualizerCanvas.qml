import QtQuick 2.12

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

    property SegmentEqualizer segmentEqualizer: SegmentEqualizer {
        id: item

        onSegmentEqualizerChanged: {
            if(initialized) {
                canvas.context.clearRect(0, 0, canvas.width, canvas.height);
                segmentEqualizer.draw();
            }
        }
    }

    function draw() {
        if(initialized);
        console.log('Equalizer draw');
        canvas.context.clearRect(0, 0, canvas.width, canvas.height);
        segmentEqualizer.draw();
    }

    onPaint: {
        if(!initialized) {
            let context = getContext('2d');
            segmentEqualizer.context = context;

            initialized = true;
            canvasReady();
        }

        if(initialized) {
            draw();
        }
    }
}
