import QtQuick 2.12
import QtQuick.Controls 2.1
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.12

import "../components"

GridLayout {
    id: gridLayout
    Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
    implicitWidth: parent.width
    Layout.topMargin: 20

    columns: 1
    rowSpacing: 10

    property string caption: "Round Gauge Examples"

    Component.onCompleted: {
        let count = gridLayout.getChildCount();
        let height = 0;
        for(let i = 0; i < count; i++){
            height += gridLayout.getChildAt(i).height + 10;
        }

        if(height > parent.areaHeight) this.implicitHeight = height;
        else this.implicitHeight = parent.areaHeight;
    }

    RoundGaugeCanvas {
        id: canvas_1
        width: parent.width * 3 / 4
        height: parent.width * 3 / 4

        onCanvasReady: {
            let w = canvas_1.width / 2;

            segmentGauge.name = "gauge_1";
            segmentGauge.cx = w;
            segmentGauge.cy = w;
            segmentGauge.r_in = 0;
            segmentGauge.thickness = 0.9 * w;
            segmentGauge.init_angle = 160;
            segmentGauge.angle = 220;
            segmentGauge.visible = true;

            segmentGauge.build();
            segmentGauge.base_segment.border_width = 2;
            segmentGauge.base_segment.border_color = 'black';
            segmentGauge.base_segment.background = 'rgba(240, 240, 240, 1)';
            segmentGauge.base_segment.calc();
            segmentGauge.scale.r_in = 0.7 * w;
            segmentGauge.scale.thickness = 0.15 * w;
            segmentGauge.scale.calc();
            segmentGauge.arrow.length = 0.8 * w;
            segmentGauge.arrow.width = 0.08 * w;
            segmentGauge.arrow.angle = 160;
            segmentGauge.arrow.setImgSrc('../svg/arrow-two.svg');
            segmentGauge.arrow.img_offset_x = 0.04 * w;
            segmentGauge.arrow.img_offset_y = 0.16 * w;
            segmentGauge.text = "km/h";
            segmentGauge.font = "25px Open Sans";
            segmentGauge.text_offset_y = 0.4 * w;
            segmentGauge.calc();

            //'font' : 'italic 12pt Arial',

            let signs_1 = { 'signs_array' : ['0', '20', '40', '60', '80', '100', '120', '140', '160', '180', '200', '220'],
                'text_options' : {
                    'font' : 'italic 11px sans-serif',
                    'color' : 'black',
                    'border_width' : 0,
                    'border_color' : 'rgba(0, 0, 0, 0)',
                    'direction' : 'vertical'
                }
            };

            segmentGauge.scale.levels = [
                { 'divisions_count' : 11, 'mark_length' : 0.08 * w, 'mark_width' : 2, 'mark_color' : 'black', 'signs' : signs_1 },
                { 'divisions_count' : 2, 'mark_length' : 0.05 * w, 'mark_width' : 1, 'mark_color' : 'black' }
            ];

            console.log(JSON.stringify(segmentGauge.scale.levels));

            segmentGauge.scale.sign_r_in = 0.60 * w;
            segmentGauge.scale.build();

            segmentGauge.scale.base_segment.border_outer_width = 1;
            segmentGauge.scale.base_segment.border_outer_color = 'black';
            segmentGauge.scale.base_segment.border_color = 'gray';
            segmentGauge.scale.base_segment.calc();

            segmentGauge.draw();
        }
    }

    RoundGaugeCanvas {
        id: canvas_2
        width: parent.width * 3 / 4
        height: parent.width * 3 / 4

        onCanvasReady: {
            let w = canvas_2.width / 2;

            segmentGauge.name = "chart_2";
            segmentGauge.cx = w;
            segmentGauge.cy = w;
            segmentGauge.r_in = 0;
            segmentGauge.thickness = 0.6 * w;
            segmentGauge.init_angle = 135;
            segmentGauge.angle = 270;
            segmentGauge.visible = true;

            segmentGauge.build();

            segmentGauge.scale.r_in = 0.35 * w;
            segmentGauge.scale.mark_position = 'inner';
            let signs_2 = { 'signs_array' : ['0', '5', '10', '15'],
                'text_options' : {
                    'font' : '12pt Arial',
                    'color' : 'darkred',
                    'border_width' : 0,
                    'border_color' : 'rgba(0, 0, 0, 0)',
                    'direction' : 'vertical'
                }
            };

            segmentGauge.scale.levels = [
                { 'divisions_count' : 3, 'mark_length' : 0.075 * w, 'mark_width' : 2, 'mark_color' : 'darkred', 'signs' : signs_2 },
                { 'divisions_count' : 5, 'mark_length' : 0.075 * w, 'mark_width' : 1, 'mark_color' : 'black' },
                { 'divisions_count' : 2, 'mark_length' : 0.04 * w, 'mark_width' : 1, 'mark_color' : 'black' }
            ];
            segmentGauge.scale.sign_r_in = 0.5 * w;
            segmentGauge.scale.background = '#efefef'
            segmentGauge.scale.border_color = 'rgba(0, 0, 0, 0)';
            segmentGauge.scale.build();
            segmentGauge.scale.base_segment.border_inner_color = 'black';
            segmentGauge.scale.base_segment.calc();

            segmentGauge.base_segment.background = '#efefef';
            //gauge_3.base_segment.border_color = 'black';
            segmentGauge.base_segment.calc();

            /*
            segmentGauge.frame.gradient = new SegmentGradient('radial', 'from-center',
                'rgba(250, 250, 250, 0.5) 0%, black 20%, rgba(200, 200, 200, 1) 70%, rgba(10, 10, 10, 1) 100%');
                */
            segmentGauge.frame.gradient = Qt.createQmlObject('import "../components"; SegmentGradient { type: "radial"; direction: "from-center";
                stops_string: "rgba(250, 250, 250, 0.5) 0%, black 20%, rgba(200, 200, 200, 1) 70%, rgba(10, 10, 10, 1) 100%" }', this, "grad_1");

            segmentGauge.frame.border_color = 'gray';
            segmentGauge.calc();

            segmentGauge.arrow.setImgSrc('../svg/arrow-one.svg');
            segmentGauge.arrow.angle = 135;
            segmentGauge.arrow.length = 0.45 * w;
            segmentGauge.arrow.width = 0.035 * w;
            segmentGauge.arrow.img_offset_x = 0.018 * w;
            segmentGauge.arrow.img_offset_y = 0.075 * w;
            segmentGauge.text = 'bar';
            segmentGauge.text_border_color = 'rgba(0, 0, 0, 0)';
            segmentGauge.text_offset_y = 0.15 * w;
            segmentGauge.calc();
            segmentGauge.draw();
        }
    }
}
