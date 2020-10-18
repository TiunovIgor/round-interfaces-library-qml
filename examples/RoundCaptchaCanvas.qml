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

    property SegmentCaptcha captcha: SegmentCaptcha {
        id: item

        onSegmentCaptchaChanged: {
            if(initialized) {
                canvas.requestAnimationFrame(function() {
                    canvas.context.reset();
                    captcha.draw();
                });
            }
        }

        onSegmentCaptchaUnlocked: {
            captcha.build();
            captcha.calc();
            draw();
        }
    }

    function draw() {
        if(initialized);
        canvas.context.reset();
        captcha.draw();
    }

    onPaint: {
        if(!initialized) {
            let context = getContext('2d');
            captcha.context = context;
            initialized = true;
            canvasReady();
        }

        if(initialized) {
            draw();
        }
    }
}
