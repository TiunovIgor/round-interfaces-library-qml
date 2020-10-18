import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.12

import "../components"

GridLayout {
    id: gridLayout
    Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
    implicitWidth: parent.width

    columns: 2
    rowSpacing: 10

    property string caption: "Round Progress Bar Examples"

    Component.onCompleted: {
        let count = gridLayout.getChildCount();
        let height = 0;
        for(let i = 0; i < count; i++){
            height += gridLayout.getChildAt(i).height + 10;
        }

        if(height > parent.areaHeight) this.implicitHeight = height;
        else this.implicitHeight = parent.areaHeight;
    }

    RoundProgressBarCanvas {
        id: canvas_1
        width: (parent.width - 10) / 2
        height: (parent.width - 10) / 2

        onCanvasReady: {
            segmentProgressBar.name = "bar_1";
            segmentProgressBar.cx = canvas_1.width / 2;
            segmentProgressBar.cy = canvas_1.height / 2;
            segmentProgressBar.r_in = 0.5 * canvas_1.width / 2;
            segmentProgressBar.thickness = 0.25 * canvas_1.width / 2;
            segmentProgressBar.visible = true;

            segmentProgressBar.build();
            segmentProgressBar.calc();
            segmentProgressBar.draw();
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(!canvas_1.segmentProgressBar.in_progress) {
                    let value = Math.floor(Math.random() * 100);
                    canvas_1.segmentProgressBar.changeValue(value, 1);
                }
            }
        }
    }

    RoundProgressBarCanvas {
        id: canvas_2
        width: (parent.width - 10) / 2
        height: (parent.width - 10) / 2

        onCanvasReady: {
            segmentProgressBar.name = "bar_2";
            segmentProgressBar.cx = canvas_2.width / 2;
            segmentProgressBar.cy = canvas_2.height / 2;
            segmentProgressBar.r_in = 0.6 * canvas_2.width / 2;
            segmentProgressBar.thickness = 0.2 * canvas_2.width / 2;
            segmentProgressBar.visible = true;

            segmentProgressBar.build();

            segmentProgressBar.base_segment.border_outer_width = 1;
            segmentProgressBar.base_segment.border_outer_color = 'none';
            segmentProgressBar.base_segment.border_inner_width = 3;
            segmentProgressBar.base_segment.border_inner_color = 'black';
            segmentProgressBar.base_segment.background = '#fefefe';
            segmentProgressBar.base_segment.calc();
            segmentProgressBar.active_segment.r_in = 0.61 * canvas_2.width / 2;
            segmentProgressBar.active_segment.thickness = 0.15 * canvas_2.width / 2;

            //segmentProgressBar.active_segment.gradient = new SegmentGradient('radial', 'from-center', '#FFFF00 50%, #FFC000 100%');
            segmentProgressBar.active_segment.gradient = Qt.createQmlObject('import "../components";
                SegmentGradient { type: "radial"; direction: "from-center"; stops_string: "#FFFF00 50%, #FFC000 100%" }', this, "grad_2");

            segmentProgressBar.active_segment.border_opening_width = 1;
            segmentProgressBar.active_segment.border_opening_color = 'black';
            segmentProgressBar.active_segment.border_closing_width = 1;
            segmentProgressBar.active_segment.border_closing_color = 'black';
            segmentProgressBar.active_segment.border_outer_width = 1;
            segmentProgressBar.active_segment.border_outer_color = 'black';
            segmentProgressBar.active_segment.calc();
            segmentProgressBar.font = '40px Open Sans';
            segmentProgressBar.value = 100;
            segmentProgressBar.calc();
            segmentProgressBar.draw();
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(!canvas_2.segmentProgressBar.in_progress) {
                    let value = Math.floor(Math.random() * 100);
                    canvas_2.segmentProgressBar.changeValue(value, 0.3);
                }
            }
        }
    }

    RoundProgressBarCanvas {
        id: canvas_3
        width: (parent.width - 10) / 2
        height: (parent.width - 10) / 2

        onCanvasReady: {
            segmentProgressBar.name = "bar_3";
            segmentProgressBar.cx = canvas_3.width / 2;
            segmentProgressBar.cy = canvas_3.height / 2;
            segmentProgressBar.r_in = 0.6 * canvas_3.width / 2;
            segmentProgressBar.thickness = 0.2 * canvas_3.width / 2;
            segmentProgressBar.init_angle = 180;
            segmentProgressBar.angle = 180;
            segmentProgressBar.visible = true;

            segmentProgressBar.build();

            segmentProgressBar.base_segment.border_width = 1;
            segmentProgressBar.base_segment.border_color = 'black';
            segmentProgressBar.base_segment.background = '#fefefe';
            segmentProgressBar.base_segment.calc();
            segmentProgressBar.active_segment.r_in = 0.61 * canvas_3.width / 2;
            segmentProgressBar.active_segment.thickness = 0.15 * canvas_3.width / 2;

            //segmentProgressBar.active_segment.gradient = new SegmentGradient('radial', 'from-center', '#FFFF00 50%, #FFC000 100%');
            segmentProgressBar.active_segment.gradient = Qt.createQmlObject('import "../components";
                SegmentGradient { type: "radial"; direction: "from-center"; stops_string: "#FFFF00 50%, #FFC000 100%" }', this, "grad_3");

            segmentProgressBar.active_segment.border_opening_color = 'black';
            segmentProgressBar.active_segment.border_closing_color = 'black';
            segmentProgressBar.active_segment.border_outer_color = 'black';
            segmentProgressBar.active_segment.calc();
            segmentProgressBar.font = '40px Open Sans';
            segmentProgressBar.units = '°';
            segmentProgressBar.max_value = 180;
            segmentProgressBar.value = 180;
            segmentProgressBar.calc();
            segmentProgressBar.draw();
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(!canvas_3.segmentProgressBar.in_progress) {
                    let value = Math.floor(Math.random() * canvas_3.segmentProgressBar.max_value);
                    canvas_3.segmentProgressBar.changeValue(value, 0.3);
                }
            }
        }
    }

    RoundProgressBarCanvas {
        id: canvas_4
        width: (parent.width - 10) / 2
        height: (parent.width - 10) / 2

        onCanvasReady: {
            segmentArrayProgressBar.name = "bar_4";
            segmentArrayProgressBar.cx = canvas_4.width / 2;
            segmentArrayProgressBar.cy = canvas_4.height / 2;
            segmentArrayProgressBar.r_in = 0.5 * canvas_4.width / 2;
            segmentArrayProgressBar.thickness = 0.25 * canvas_4.width / 2;
            segmentArrayProgressBar.visible = true;

            segmentArrayProgressBar.build();
            segmentArrayProgressBar.calc();
            segmentArrayProgressBar.draw();
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(!canvas_4.segmentArrayProgressBar.in_progress) {
                    let value = Math.floor(Math.random() * 100);
                    canvas_4.segmentArrayProgressBar.changeValue(value, 1);
                }
            }
        }
    }

    RoundProgressBarCanvas {
        id: canvas_5
        width: (parent.width - 10) / 2
        height: (parent.width - 10) / 2

        onCanvasReady: {
            segmentArrayProgressBar.name = "bar_5";
            segmentArrayProgressBar.cx = canvas_5.width / 2;
            segmentArrayProgressBar.cy = canvas_5.height / 2;
            segmentArrayProgressBar.r_in = 0.5 * canvas_5.width / 2;
            segmentArrayProgressBar.thickness = 0.25 * canvas_5.width / 2;
            segmentArrayProgressBar.visible = true;

            segmentArrayProgressBar.value = 100;
            segmentArrayProgressBar.background = 'rgba(0, 0, 0, 0)';
            segmentArrayProgressBar.border_color = 'none';
            segmentArrayProgressBar.segment_background = 'rgba(240, 240, 240, 1)';
            segmentArrayProgressBar.active_segment_background = '#00A0E9';
            segmentArrayProgressBar.build();
            segmentArrayProgressBar.calc();
            segmentArrayProgressBar.draw();
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(!canvas_5.segmentArrayProgressBar.in_progress) {
                    let value = Math.floor(Math.random() * 100);
                    canvas_5.segmentArrayProgressBar.changeValue(value, 1);
                }
            }
        }
    }

    RoundProgressBarCanvas {
        id: canvas_6
        width: (parent.width - 10) / 2
        height: (parent.width - 10) / 2

        onCanvasReady: {
            segmentArrayProgressBar.name = "bar_6";
            segmentArrayProgressBar.cx = canvas_6.width / 2;
            segmentArrayProgressBar.cy = canvas_6.height / 2;
            segmentArrayProgressBar.r_in = 0.5 * canvas_6.width / 2;
            segmentArrayProgressBar.thickness = 0.25 * canvas_6.width / 2;
            segmentArrayProgressBar.init_angle = 135;
            segmentArrayProgressBar.angle = 270;
            segmentArrayProgressBar.visible = true;

            segmentArrayProgressBar.start_with = 'space';
            segmentArrayProgressBar.segments_count = 36;
            segmentArrayProgressBar.segment_angle = 4;
            segmentArrayProgressBar.segment_background = 'white';
            segmentArrayProgressBar.segment_border_color = 'rgba(100, 100, 100, 0.5)';
            segmentArrayProgressBar.active_segment_background = '#601986';
            segmentArrayProgressBar.max_value = 160;
            segmentArrayProgressBar.units = ' mph';
            segmentArrayProgressBar.font = '20px Times New Roman';
            segmentArrayProgressBar.build();
            segmentArrayProgressBar.calc();
            segmentArrayProgressBar.base_segment.background = 'rgba(0, 0, 0, 0)';
            segmentArrayProgressBar.base_segment.border_outer_color = 'none';
            segmentArrayProgressBar.base_segment.calc();
            segmentArrayProgressBar.draw();
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(!canvas_6.segmentArrayProgressBar.in_progress) {
                    let value = Math.floor(Math.random() * canvas_6.segmentArrayProgressBar.max_value);
                    canvas_6.segmentArrayProgressBar.changeValue(value, 1);
                }
            }
        }
    }

    RoundProgressBarCanvas {
        id: canvas_7
        width: (parent.width - 10) / 2
        height: (parent.width - 10) / 2

        onCanvasReady: {
            segmentDotsArrayProgressBar.name = "bar_7";
            segmentDotsArrayProgressBar.cx = canvas_7.width / 2;
            segmentDotsArrayProgressBar.cy = canvas_7.height / 2;
            segmentDotsArrayProgressBar.r_in = 0.5 * canvas_7.width / 2;
            segmentDotsArrayProgressBar.thickness = 0.25 * canvas_7.width / 2;
            segmentDotsArrayProgressBar.visible = true;

            segmentDotsArrayProgressBar.build();
            segmentDotsArrayProgressBar.calc();
            segmentDotsArrayProgressBar.draw();
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(!canvas_7.segmentDotsArrayProgressBar.in_progress) {
                    let value = Math.floor(Math.random() * 100);
                    canvas_7.segmentDotsArrayProgressBar.changeValue(value, 1);
                }
            }
        }
    }

    RoundProgressBarCanvas {
        id: canvas_8
        width: (parent.width - 10) / 2
        height: (parent.width - 10) / 2

        onCanvasReady: {
            segmentDotsArrayProgressBar.name = "bar_8";
            segmentDotsArrayProgressBar.cx = canvas_8.width / 2;
            segmentDotsArrayProgressBar.cy = canvas_8.height / 2;
            segmentDotsArrayProgressBar.r_in = 0.5 * canvas_8.width / 2;
            segmentDotsArrayProgressBar.thickness = 0.25 * canvas_8.width / 2;
            segmentDotsArrayProgressBar.visible = true;

            segmentDotsArrayProgressBar.background = 'rgba(0, 0, 0, 0)';
            segmentDotsArrayProgressBar.border_color = 'rgba(0, 0, 0, 0)';
            segmentDotsArrayProgressBar.dots_count = 24;
            segmentDotsArrayProgressBar.dot_radius = 5;
            segmentDotsArrayProgressBar.active_dot_background = '#E60033';
            segmentDotsArrayProgressBar.text_border_color = 'none';
            segmentDotsArrayProgressBar.build();
            segmentDotsArrayProgressBar.draw();
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(!canvas_8.segmentDotsArrayProgressBar.in_progress) {
                    let value = Math.floor(Math.random() * 100);
                    canvas_8.segmentDotsArrayProgressBar.changeValue(value, 1);
                }
            }
        }
    }

    RoundProgressBarCanvas {
        id: canvas_9
        width: (parent.width - 10) / 2
        height: (parent.width - 10) / 2

        onCanvasReady: {
            segmentDotsArrayProgressBar.name = "bar_9";
            segmentDotsArrayProgressBar.cx = canvas_9.width / 2;
            segmentDotsArrayProgressBar.cy = canvas_9.height / 2;
            segmentDotsArrayProgressBar.r_in = 0.5 * canvas_9.width / 2;
            segmentDotsArrayProgressBar.thickness = 0.20 * canvas_9.width / 2;
            segmentDotsArrayProgressBar.init_angle = -30;
            segmentDotsArrayProgressBar.angle = 240;
            segmentDotsArrayProgressBar.visible = true;

            segmentDotsArrayProgressBar.start_with = 'space';
            segmentDotsArrayProgressBar.dots_count = 20;
            segmentDotsArrayProgressBar.dot_radius = 3;
            segmentDotsArrayProgressBar.dot_background = 'rgba(250, 250, 250, 1)';
            segmentDotsArrayProgressBar.active_dot_background = '#d90093';
            segmentDotsArrayProgressBar.text_color = '#d90093';
            segmentDotsArrayProgressBar.text_border_color = 'none';
            segmentDotsArrayProgressBar.units = '';
            segmentDotsArrayProgressBar.max_value = 20;
            segmentDotsArrayProgressBar.build();
            segmentDotsArrayProgressBar.base_segment.background = 'rgba(0, 0, 0, 0)';
            segmentDotsArrayProgressBar.base_segment.border_color = '#d90093';
            segmentDotsArrayProgressBar.base_segment.border_outer_color = 'rgba(0, 0, 0, 0)';
            segmentDotsArrayProgressBar.base_segment.calc();
            segmentDotsArrayProgressBar.draw();
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(!canvas_9.segmentDotsArrayProgressBar.in_progress) {
                    let value = Math.floor(Math.random() * 20);
                    canvas_9.segmentDotsArrayProgressBar.changeValue(value, 0.4);
                }
            }
        }
    }
}
