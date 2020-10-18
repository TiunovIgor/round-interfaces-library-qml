import QtQuick 2.12
import QtQuick.Controls 2.1
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.12

import "../components"

GridLayout {
    id: gridLayout
    Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
    implicitWidth: parent.width

    columns: 1
    rowSpacing: 10

    property string caption: "Round Captcha Examples"

    Component.onCompleted: {
        let count = gridLayout.getChildCount();
        let height = 0;
        for(let i = 0; i < count; i++){
            height += gridLayout.getChildAt(i).height + 10;
        }
        this.implicitHeight = height;
    }

    // Segment Captcha
    RoundCaptchaCanvas {
        id: canvas_1
        width: parent.width
        height: parent.height

        onCanvasReady: {
            captcha.name = "seg_1";
            captcha.cx = canvas_1.width / 2;
            captcha.cy = canvas_1.height / 2;
            captcha.r_in = 0.2 * canvas_1.width / 2;
            captcha.thickness = 0.6 * canvas_1.width / 2;
            captcha.visible = true;

            /*
            captcha.base_segment_gradient = Qt.createQmlObject('import "../components";
                SegmentGradient { type: "radial"; direction: "from-center"; stops_string: "purple 0%, purple 100%" }', this, "grad_1");
            captcha.segment_gradient = Qt.createQmlObject('import "../components";
                SegmentGradient { type: "radial"; direction: "to-center"; stops_string: "skyblue 50%, steelblue 100%" }', this, "grad_2");
            */
            captcha.base_segment_background = 'steelblue';
            captcha.segment_background = 'skyblue'; // '#00a0e9'

            captcha.segments_count = 3;

            captcha.build();
            captcha.calc();
            captcha.draw();
        }
        MouseArea {
            anchors.fill: parent

            preventStealing: true

            onPressed: { canvas_1.captcha.catchSegment(mouse); }
            onPositionChanged: { canvas_1.captcha.rotateSegmentByMouseMovement(mouse); }
            onWheel: { canvas_1.captcha.rotateSegmentByMouseWheel(wheel); }
            onReleased: { canvas_1.captcha.releaseSegment(); }
            onExited: { canvas_1.captcha.releaseSegment(); }
        }
    }
}
