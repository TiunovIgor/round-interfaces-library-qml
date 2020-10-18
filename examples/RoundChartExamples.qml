import QtQuick 2.12
import QtQuick.Controls 2.1
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.12

import "../components"

GridLayout {
    id: gridLayout
    Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
    implicitWidth: parent.width

    columns: 2
    rowSpacing: 10

    property string caption: "Round Chart Examples"

    Component.onCompleted: {
        let count = gridLayout.getChildCount();
        let height = 0;
        for(let i = 0; i < count; i++){
            height += gridLayout.getChildAt(i).height + 10;
        }
        this.implicitHeight = height;
    }

    RoundChartCanvas {
        id: canvas_1
        width: (parent.width - 10) / 2
        height: (parent.width - 10) / 2

        onCanvasReady: {
            segmentChart.name = "chart_1";
            segmentChart.cx = canvas_1.width / 2;
            segmentChart.cy = canvas_1.height / 2;
            segmentChart.r_in = 0.5 * canvas_1.width / 2;
            segmentChart.thickness = 0.3 * canvas_1.width / 2;
            segmentChart.visible = true;

            segmentChart.source = [
                        [ 'apples', '20', '#e5004f' ],
                        [ 'oranges', '46', '#fcc800' ],
                        [ 'pineapple', '17', '#22ac38' ],
                        [ 'kiwi', '11', '#00a0e9' ],
                        [ 'pears', '6', '#00479d' ]
                    ];
            segmentChart.space_angle = 3;
            segmentChart.background = 'rgba(250, 250, 250, 1)';
            segmentChart.sign_r_in = segmentChart.r_in + segmentChart.thickness / 2;
            segmentChart.text_color = 'white';

            segmentChart.build();

            /*
            segmentChart.base_segment.background = 'black';
            segmentChart.base_segment.calc();
            */

            segmentChart.draw();
        }
    }

    RoundChartCanvas {
        id: canvas_2
        width: (parent.width - 10) / 2
        height: (parent.width - 10) / 2

        onCanvasReady: {
            segmentChart.name = "chart_2";
            segmentChart.cx = canvas_2.width / 2;
            segmentChart.cy = canvas_2.height / 2;
            segmentChart.r_in = 0;
            segmentChart.thickness = 0.7 * canvas_2.width / 2;
            segmentChart.visible = true;

            segmentChart.source = [
                [ 'apples', '20', '#e5004f' ],
                [ 'oranges', '46', '#fcc800' ],
                [ 'pineapple', '17', '#22ac38' ],
                [ 'kiwi', '11', '#00a0e9' ],
                [ 'pears', '6', '#00479d' ]
            ];
            segmentChart.space_angle = 0;
            segmentChart.segment_r_in = 0;
            segmentChart.segment_thickness = segmentChart.thickness;
            segmentChart.background = 'rgba(250, 250, 250, 1)';

            segmentChart.build();
            segmentChart.draw();
        }
    }

    RoundChartCanvas {
        id: canvas_3
        width: (parent.width - 10) / 2
        height: (parent.width - 10) / 2

        onCanvasReady: {
            segmentChart.name = "chart_3";
            segmentChart.cx = canvas_3.width / 2;
            segmentChart.cy = canvas_3.height / 2;
            segmentChart.r_in = 0.3 * canvas_3.width / 2;
            segmentChart.thickness = 0.5 * canvas_3.width / 2;
            segmentChart.visible = true;

            segmentChart.type = 'radial';
            segmentChart.source = [
                [ 'apples', '50', '#e5004f' ],
                [ 'oranges', '87', '#fcc800' ],
                [ 'pineapple', '17', '#22ac38' ],
                [ 'kiwi', '68', '#00a0e9' ],
                [ 'pears', '96', '#00479d' ]
            ];
            segmentChart.background = 'rgba(0, 0, 0, 0)';
            segmentChart.border_color = 'none';

            segmentChart.build();
            segmentChart.calc();
            segmentChart.draw();
        }        
    }

    RoundChartCanvas {
        id: canvas_4
        width: (parent.width - 10) / 2
        height: (parent.width - 10) / 2

        onCanvasReady: {
            segmentChart.name = "chart_4";
            segmentChart.cx = canvas_4.width / 2;
            segmentChart.cy = canvas_4.height / 2;
            segmentChart.r_in = 0;
            segmentChart.thickness = 0.7 * canvas_4.width / 2;
            segmentChart.visible = true;

            segmentChart.type = 'radial';
            segmentChart.source = [
                [ 'apples', '50', '#e5004f' ],
                [ 'oranges', '87', '#fcc800' ],
                [ 'pineapple', '17', '#22ac38' ],
                [ 'kiwi', '68', '#00a0e9' ],
                [ 'pears', '96', '#00479d' ]
            ];
            segmentChart.background = 'rgba(0, 0, 0, 0)';
            segmentChart.border_color = 'none';

            segmentChart.build();
            segmentChart.draw();
        }
    }

    RoundChartCanvas {
        id: canvas_5
        width: (parent.width - 10) / 2
        height: (parent.width - 10) / 2

        onCanvasReady: {
            segmentChart.name = "chart_5";
            segmentChart.cx = canvas_5.width / 2;
            segmentChart.cy = canvas_5.height / 2;
            segmentChart.r_in = 0.2 * canvas_5.width / 2;
            segmentChart.thickness = 0.7 * canvas_5.width / 2;
            segmentChart.visible = true;

            segmentChart.type = 'bar';
            segmentChart.source = [
                [ 'apples', '19', '#e5004f' ],
                [ 'oranges', '78', '#fcc800' ],
                [ 'pineapple', '31', '#22ac38' ],
                [ 'kiwi', '64', '#00a0e9' ],
                [ 'pears', '50', '#00479d' ]
            ];

            segmentChart.build();
            segmentChart.draw();
        }
    }
}
