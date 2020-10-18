import QtQuick 2.12
import QtQuick.Controls 2.1
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.12

import "../components"

GridLayout {
    id: gridLayout
    Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
    implicitWidth: parent.width

    columns: 2
    rowSpacing: 10

    property string caption: "Segment Dot Examples"

    Component.onCompleted: {
        let count = gridLayout.getChildCount();
        let height = 0;
        for(let i = 0; i < count; i++){
            height += gridLayout.getChildAt(i).height + 10;
        }
        this.implicitHeight = height;
    }

    // Disappear to center - Appear from center
    SegmentDotCanvas {
        id: canvas_1
        width: (parent.width - 10) / 2
        height: (parent.width - 10) / 2

        onCanvasReady: {
            segmentDot.name = "seg_1";
            segmentDot.cx = canvas_1.width / 2;
            segmentDot.cy = canvas_1.height / 2;
            segmentDot.r = 0.3 * canvas_1.width / 2;
            segmentDot.visible = true;

            segmentDot.calc();
            segmentDot.draw();
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(!canvas_1.segmentDot.in_progress) {
                    if(canvas_1.segmentDot.visible) { canvas_1.segmentDot.disappear('to-center', 0.5, 0); }
                    else { canvas_1.segmentDot.appear('from-center', 0.5, 0); }
                }
            }
        }
    }

    // FadeOut - FadeIn
    SegmentDotCanvas {
        id: canvas_2
        width: (parent.width - 10) / 2
        height: (parent.width - 10) / 2

        onCanvasReady: {
            segmentDot.name = "seg_2";
            segmentDot.cx = canvas_2.width / 2;
            segmentDot.cy = canvas_2.height / 2;
            segmentDot.r = 0.3 * canvas_2.width / 2;
            segmentDot.visible = true;

            segmentDot.calc();
            segmentDot.draw();
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(!canvas_2.segmentDot.in_progress) {
                    if(canvas_2.segmentDot.visible) { canvas_2.segmentDot.fadeOut(1, 0); }
                    else { canvas_2.segmentDot.fadeIn(1, 0); }
                }
            }
        }
    }
}
