import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.12

import "../components"

GridLayout {
    id: gridLayout
    anchors.topMargin: 10
    Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
    implicitWidth: parent.width

    columns: 2
    rowSpacing: 10

    property string caption: "Round Timer Examples"

    Component.onCompleted: {
        let count = gridLayout.getChildCount();
        let height = 0;
        for(let i = 0; i < count; i++){
            height += gridLayout.getChildAt(i).height + 10;
        }

        if(height > parent.areaHeight) this.implicitHeight = height;
        else this.implicitHeight = parent.areaHeight;

        console.log(parent.areaHeight + ' ' + height + ' ' + this.implicitHeight);
    }

    RoundTimerCanvas {
        id: canvas_1
        width: (parent.width - 10) / 2
        height: (parent.width - 10) / 2

        onCanvasReady: {
            segmentTimer.name = "timer_1";
            segmentTimer.cx = canvas_1.width / 2;
            segmentTimer.cy = canvas_1.height / 2;
            segmentTimer.r_in = 0.6 * canvas_1.width / 2;
            segmentTimer.thickness = 0.2 * canvas_1.width / 2;
            segmentTimer.visible = true;

            segmentTimer.max_value = 10;
            segmentTimer.value = segmentTimer.max_value;
            segmentTimer.build();
            segmentTimer.base_segment.border_outer_width = 1;
            segmentTimer.base_segment.border_outer_color = 'none';
            segmentTimer.base_segment.border_inner_width = 3;
            segmentTimer.base_segment.border_inner_color = 'black';
            segmentTimer.base_segment.background = '#fefefe';
            segmentTimer.base_segment.calc();
            segmentTimer.active_segment.r_in = 0.62 * canvas_1.width / 2;
            segmentTimer.active_segment.thickness = 0.15 * canvas_1.width / 2;

            //segmentTimer.active_segment.gradient = new SegmentGradient('radial', 'from-center', '#FFFF00 50%, #FFC000 100%');
            segmentTimer.active_segment.gradient = Qt.createQmlObject('import "../components";
                SegmentGradient { type: "radial"; direction: "from-center"; stops_string: "#FFFF00 50%, #FFC000 100%" }', this, "grad_1");

            segmentTimer.active_segment.border_opening_width = 1;
            segmentTimer.active_segment.border_opening_color = 'black';
            segmentTimer.active_segment.border_closing_width = 1;
            segmentTimer.active_segment.border_closing_color = 'black';
            segmentTimer.active_segment.border_outer_width = 1;
            segmentTimer.active_segment.border_outer_color = 'black';
            segmentTimer.active_segment.calc();
            segmentTimer.font = '30px Open Sans';
            segmentTimer.calc();
            segmentTimer.draw();

            console.log(segmentTimer.init_angle + ' ' + segmentTimer.angle + ' ' + segmentTimer.value + ' ' + segmentTimer.max_value + ' ' + segmentTimer.min_value);
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(!canvas_1.segmentTimer.in_progress) {
                    canvas_1.segmentTimer.start();
                }
                else {
                    if(canvas_1.segmentTimer.on_pause) { canvas_1.segmentTimer.start(); }
                    else { canvas_1.segmentTimer.pause(); }
                }
            }
        }
    }

    RoundTimerCanvas {
        id: canvas_2
        width: (parent.width - 10) / 2
        height: (parent.width - 10) / 2

        onCanvasReady: {
            segmentArrayTimer.name = "timer_2";
            segmentArrayTimer.cx = canvas_2.width / 2;
            segmentArrayTimer.cy = canvas_2.height / 2;
            segmentArrayTimer.r_in = 0.6 * canvas_2.width / 2;
            segmentArrayTimer.thickness = 0.2 * canvas_2.width / 2;
            //segmentArrayTimer.init_angle = -90;
            //segmentArrayTimer.angle = 360;
            segmentArrayTimer.visible = true;

            segmentArrayTimer.max_value = 5;
            segmentArrayTimer.value = segmentArrayTimer.max_value;
            segmentArrayTimer.font = '40px Open Sans';
            segmentArrayTimer.units = ' s';
            segmentArrayTimer.background = 'rgba(0, 0, 0, 0)';
            segmentArrayTimer.border_color = 'none';
            segmentArrayTimer.segment_background = 'rgba(240, 240, 240, 1)';
            segmentArrayTimer.active_segment_background = '#00A0E9';
            segmentArrayTimer.build();
            segmentArrayTimer.calc();
            segmentArrayTimer.draw();           
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(!canvas_2.segmentArrayTimer.in_progress) {
                    canvas_2.segmentArrayTimer.start();
                }
                else {
                    if(canvas_2.segmentArrayTimer.on_pause) { canvas_2.segmentArrayTimer.start(); }
                    else { canvas_2.segmentArrayTimer.pause(); }
                }
            }
        }
    }

    RoundTimerCanvas {
        id: canvas_3
        width: (parent.width - 10) / 2
        height: (parent.width - 10) / 2

        onCanvasReady: {
            segmentDotsArrayTimer.name = "timer_3";
            segmentDotsArrayTimer.cx = canvas_3.width / 2;
            segmentDotsArrayTimer.cy = canvas_3.height / 2;
            segmentDotsArrayTimer.r_in = 0.6 * canvas_3.width / 2;
            segmentDotsArrayTimer.thickness = 0.2 * canvas_3.width / 2;
            segmentDotsArrayTimer.visible = true;

            segmentDotsArrayTimer.max_value = 5;
            segmentDotsArrayTimer.value = segmentDotsArrayTimer.max_value;
            segmentDotsArrayTimer.font = '50px Open Sans';
            segmentDotsArrayTimer.units = '';
            segmentDotsArrayTimer.background = 'rgba(0, 0, 0, 0)';
            segmentDotsArrayTimer.border_color = 'rgba(0, 0, 0, 0)';
            segmentDotsArrayTimer.dots_count = 24;
            segmentDotsArrayTimer.dot_radius = 5;
            segmentDotsArrayTimer.active_dot_background = '#E60033';
            segmentDotsArrayTimer.text_border_color = 'none';
            segmentDotsArrayTimer.build();
            segmentDotsArrayTimer.calc();
            segmentDotsArrayTimer.draw();              
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(!canvas_3.segmentDotsArrayTimer.in_progress) {
                    canvas_3.segmentDotsArrayTimer.start();
                }
                else {
                    if(canvas_3.segmentDotsArrayTimer.on_pause) { canvas_3.segmentDotsArrayTimer.start(); }
                    else { canvas_3.segmentDotsArrayTimer.pause(); }
                }
            }
        }
    }

    RoundTimerCanvas {
        id: canvas_4
        width: (parent.width - 10) / 2
        height: (parent.width - 10) / 2

        onCanvasReady: {
            let w = canvas_4.width / 2;

            segmentGaugeTimer.name = "timer_4";
            segmentGaugeTimer.cx = w;
            segmentGaugeTimer.cy = w;
            segmentGaugeTimer.r_in = 0;
            segmentGaugeTimer.thickness = 0.8 * w;
            segmentGaugeTimer.init_angle = -90;
            segmentGaugeTimer.angle = 360;
            segmentGaugeTimer.visible = true;

            segmentGaugeTimer.max_value = 60;
            segmentGaugeTimer.build();

            segmentGaugeTimer.scale.r_in = 0.7 * w;
            segmentGaugeTimer.scale.thickness = 0.1 * w;
            segmentGaugeTimer.scale.mark_position = 'outer';

            let signs = { 'signs_array' : ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'],
                'text_options' : {
                    'font' : 'italic 12pt Arial',
                    'color' : 'black',
                    'border_width' : 0,
                    'border_color' : 'rgba(0, 0, 0, 0)',
                    'direction' : 'vertical'
                }
            };

            segmentGaugeTimer.scale.levels = [
                { 'divisions_count' : 12, 'mark_length' : 0.1 * w, 'mark_width' : 2, 'mark_color' : 'black', 'signs' : signs },
                { 'divisions_count' : 5, 'mark_length' : 0.05 * w, 'mark_width' : 1, 'mark_color' : 'black' }
            ];
            segmentGaugeTimer.scale.sign_r_in = 0.55 * w;
            segmentGaugeTimer.scale.background = 'white';
            segmentGaugeTimer.scale.border_color = 'rgba(0, 0, 0, 0)';
            segmentGaugeTimer.scale.build();
            segmentGaugeTimer.scale.calc();

            segmentGaugeTimer.base_segment.background = 'white';
            segmentGaugeTimer.base_segment.calc();

            segmentGaugeTimer.frame.r_in = 0.8 * w;
            segmentGaugeTimer.frame.thickness = 0.05 * w;

            //segmentGaugeTimer.frame.gradient = new SegmentGradient('radial', 'from-center', 'black 20%, rgba(200, 200, 200, 1) 70%, rgba(10, 10, 10, 1) 100%');
            segmentGaugeTimer.frame.gradient = Qt.createQmlObject('import "../components"; SegmentGradient { type: "radial"; direction: "from-center";
                stops_string: "black 20%, rgba(200, 200, 200, 1) 70%, rgba(10, 10, 10, 1) 100%" }', this, "grad_1");

            segmentGaugeTimer.frame.border_color = 'gray';
            segmentGaugeTimer.calc();

            segmentGaugeTimer.arrow.setImgSrc('../svg/arrow-one.svg');
            segmentGaugeTimer.arrow.length = 0.7 * w;
            segmentGaugeTimer.arrow.width = 0.04 * w;
            segmentGaugeTimer.arrow.img_offset_x = 0.02 * w;
            segmentGaugeTimer.arrow.img_offset_y = 0.04 * w;
            segmentGaugeTimer.arrow.calc();

            segmentGaugeTimer.setValue(segmentGaugeTimer.max_value);

            segmentGaugeTimer.text = '';
            segmentGaugeTimer.text_border_color = 'rgba(0, 0, 0, 0)';
            segmentGaugeTimer.calc();

            segmentGaugeTimer.draw();
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(!canvas_4.segmentGaugeTimer.in_progress) {
                    canvas_4.segmentGaugeTimer.start();
                }
                else {
                    if(canvas_4.segmentGaugeTimer.on_pause) { canvas_4.segmentGaugeTimer.start(); }
                    else { canvas_4.segmentGaugeTimer.pause(); }
                }
            }
        }
    }
}
