import QtQuick 2.0

Item {
    //this.id = id; // Идентификатор сегмента
    property string name
    property var context // Контекст для отрисовки сегмента
    property double cx // Координата X центра (опорной точки) сегмента
    property double cy // Координата Y центра (опорной точки) сегмента
    property double r_in // Внутренний радиус кольца
    property double thickness // Толщина сегмента
    property double r_out: r_in + thickness // Внешний радиус кольца
    property double init_angle // Начальный угол от оси X в градусах
    property double angle // Угол сегмента в градусах

    property SegmentGradient gradient: null // Градиент сегментной спирали
    property string background: "rgba(200, 200, 200, 1)" // Цвет сегментной спирали
    property double border_width: 1 // Толщина границы сегмента
    property string border_color: "rgba(100, 100, 100, 1)" // Цвет границы сегмента

    property string position: 'inner' // Позиция фигуры в базовом сегменте относительно спиральной стороны
    property string direction: 'clockwise' // Направление увеличения толщины фигуры

    property double border_opening_width // Толщина открывающей границы - первой стороны по часовой стрелке
    property string border_opening_color: '' // Цвет открывающей границы
    property double border_outer_width // Толщина внешней границы - дуги с большей длинной
    property string border_outer_color: '' // Цвет внешней границы
    property double border_inner_width // Толщина внутренней границы - дуги с меньшей длинной
    property string border_inner_color: '' // Цвет внутренней границы
    property double border_closing_width // Толщина закрывающей границы - второй стороны по часовой стрелке
    property string border_closing_color: '' // Цвет закрывающей границы
    property double border_spiral_width // Толщина спиральной границы
    property string border_spiral_color: '' // Цвет спиральной границы

    property bool in_progress: false // Признак анимации сегмента

    property double dx1;
    property double dy1;
    property double dx2;
    property double dy2;
    property double dx3;
    property double dy3;
    property double dx4;
    property double dy4;
    property double start_a;
    property double end_a;

    property double opening_line_width;
    property double closing_line_width;
    property double inner_line_width;
    property double outer_line_width;
    property double spiral_line_width;

    property string opening_stroke_style;
    property string closing_stroke_style;
    property string inner_stroke_style;
    property string outer_stroke_style;
    property string spiral_stroke_style;

    property double anim_dx1;
    property double anim_dy1;
    property double anim_dx2;
    property double anim_dy2;
    property double anim_dx3;
    property double anim_dy3;
    property double anim_dx4;
    property double anim_dy4;
    property double anim_start_a;
    property double anim_end_a;

    property double anim_r_in: 0;
    property double anim_thickness: 0;
    property double anim_r_out: 0;
    property double anim_init_angle: 0;
    property double anim_angle: 0;

    property SegmentGradient anim_gradient: null;
    property string anim_background;
    property double anim_border_width;
    property string anim_border_color;

    property string anim_border_opening_color;
    property string anim_border_closing_color;
    property string anim_border_outer_color;
    property string anim_border_inner_color;
    property string anim_border_spiral_color;

    signal segmentSpiralChanged;
    signal segmentSpiralAppeared;
    signal segmentSpiralDisappeared;
    signal segmentSpiralRotated;
    signal segmentSpiralFadedIn;
    signal segmentSpiralFadedOut;

    Utilities { id: utilities; }

    Component.onCompleted: {
        this.calc();
    }

    function calc() {
        if(this.in_progress) {
            this.anim_r_out = this.anim_r_in + this.anim_thickness;

            this.anim_start_a = this.anim_init_angle * Math.PI / 180; // Начальный угол от оси Y (в радианах)
            this.anim_end_a = (this.anim_init_angle + this.anim_angle) * Math.PI / 180; // Конечный угол от оси Y (в радианах)

            this.anim_dx1 = this.anim_r_in * Math.cos(this.anim_start_a) + this.cx; // Координата X первой точки (ближайшая по часовой, ближайшая к центру)
            this.anim_dy1 = this.anim_r_in * Math.sin(this.anim_start_a) + this.cy; // Координата Y первой точки
            this.anim_dx2 = this.anim_r_out * Math.cos(this.anim_start_a) + this.cx; // Координата X второй точки (ближайшая по часовой, дальняя от центра)
            this.anim_dy2 = this.anim_r_out * Math.sin(this.anim_start_a) + this.cy; // Координата Y второй точки
            this.anim_dx3 = this.anim_r_out * Math.cos(this.anim_end_a) + this.cx; // Координата X третьей точки (дальняя по часовой, дальняя от центра)
            this.anim_dy3 = this.anim_r_out * Math.sin(this.anim_end_a) + this.cy; // Координата Y третьей точки
            this.anim_dx4 = this.anim_r_in * Math.cos(this.anim_end_a) + this.cx; // Координата X четвертой точки (дальняя по часовой, ближайшая к центру)
            this.anim_dy4 = this.anim_r_in * Math.sin(this.anim_end_a) + this.cy; // Координата Y четвертой точки
        }
        else {
            this.r_out = this.r_in + this.thickness;

            this.start_a = this.init_angle * Math.PI / 180; // Начальный угол от оси Y (в радианах)
            this.end_a = (this.init_angle + this.angle) * Math.PI / 180; // Конечный угол от оси Y (в радианах)

            this.dx1 = this.r_in * Math.cos(this.start_a) + this.cx; // Координата X первой точки (ближайшая по часовой, ближайшая к центру)
            this.dy1 = this.r_in * Math.sin(this.start_a) + this.cy; // Координата Y первой точки
            this.dx2 = this.r_out * Math.cos(this.start_a) + this.cx; // Координата X второй точки (ближайшая по часовой, дальняя от центра)
            this.dy2 = this.r_out * Math.sin(this.start_a) + this.cy; // Координата Y второй точки
            this.dx3 = this.r_out * Math.cos(this.end_a) + this.cx; // Координата X третьей точки (дальняя по часовой, дальняя от центра)
            this.dy3 = this.r_out * Math.sin(this.end_a) + this.cy; // Координата Y третьей точки
            this.dx4 = this.r_in * Math.cos(this.end_a) + this.cx; // Координата X четвертой точки (дальняя по часовой, ближайшая к центру)
            this.dy4 = this.r_in * Math.sin(this.end_a) + this.cy; // Координата Y четвертой точки
        }

        this.calcBorder();

        //dispatchEvent(new CustomEvent("segment-spiral-changed", { detail : { spiral : this } } ));
        segmentSpiralChanged();
    }

    function calcBorder() {
        let border_width;
        let border_color;

        let border_opening_color;
        let border_closing_color;
        let border_outer_color;
        let border_inner_color;
        let border_spiral_color;

        if(this.in_progress) {
            border_width = this.anim_border_width;
            border_color = this.anim_border_color;

            border_opening_color = this.anim_border_opening_color;
            border_closing_color = this.anim_border_closing_color;
            border_outer_color = this.anim_border_outer_color;
            border_inner_color = this.anim_border_inner_color;
            border_spiral_color = this.anim_border_spiral_color;
        }
        else {
            border_width = this.border_width;
            border_color = this.border_color;

            border_opening_color = this.border_opening_color;
            border_closing_color = this.border_closing_color;
            border_outer_color = this.border_outer_color;
            border_inner_color = this.border_inner_color;
            border_spiral_color = this.border_spiral_color;
        }

        // Opening Border Style
        if(this.border_opening_width !== '' && this.border_opening_width !== undefined && !isNaN(this.border_opening_width)) {
            this.opening_line_width = this.border_opening_width; }
        else { this.opening_line_width = this.border_width; }
        if(border_opening_color !== '' && border_opening_color !== undefined) {
            if(border_opening_color === 'none') { this.opening_stroke_style = 'rgba(0, 0, 0, 0)'; }
            else { this.opening_stroke_style = border_opening_color; }
        }
        else {
            if(this.border_color === 'none') { this.opening_stroke_style = 'rgba(0, 0, 0, 0)'; }
            else {
                if(this.angle % 360 === 0) { this.opening_stroke_style = 'rgba(0, 0, 0, 0)'; }
                else { this.opening_stroke_style = this.border_color; }
            }
        }

        // Outer Border Style
        if(this.border_outer_width !== '' && this.border_outer_width !== undefined && !isNaN(this.border_outer_width)) {
            this.outer_line_width = this.border_outer_width; }
        else { this.outer_line_width = this.border_width; }
        if(border_outer_color !== '' && border_outer_color !== undefined) {
            if(border_outer_color === 'none') { this.outer_stroke_style = 'rgba(0, 0, 0, 0)'; }
            else { this.outer_stroke_style = border_outer_color; }
        }
        else {
            if(this.border_color === 'none') { this.outer_stroke_style = 'rgba(0, 0, 0, 0)'; }
            else { this.outer_stroke_style = this.border_color; }
        }

        // Inner Border Style
        if(this.border_inner_width !== '' && this.border_inner_width !== undefined && !isNaN(this.border_inner_width)) {
            this.inner_line_width = this.border_inner_width; }
        else { this.inner_line_width = this.border_width; }
        if(border_inner_color !== '' && border_inner_color !== undefined) {
            if(border_inner_color === 'none') { this.inner_stroke_style = 'rgba(0, 0, 0, 0)'; }
            else { this.inner_stroke_style = border_inner_color; }
        }
        else {
            if(this.border_color === 'none') { this.inner_stroke_style = 'rgba(0, 0, 0, 0)'; }
            else { this.inner_stroke_style = this.border_color; }
        }

        // Closing Border Style
        if(this.border_closing_width !== '' && this.border_closing_width !== undefined && !isNaN(this.border_closing_width)) {
            this.closing_line_width = this.border_closing_width; }
        else { this.closing_line_width = this.border_width; }
        if(border_closing_color !== '' && border_closing_color !== undefined) {
            if(border_closing_color === 'none') { this.closing_stroke_style = 'rgba(0, 0, 0, 0)'; }
            else { this.closing_stroke_style = border_closing_color; }
        }
        else {
            if(this.border_color === 'none') { this.closing_stroke_style = 'rgba(0, 0, 0, 0)'; }
            else {
                if(this.angle % 360 === 0) { this.closing_stroke_style = 'rgba(0, 0, 0, 0)'; }
                else { this.closing_stroke_style = this.border_color; }
            }
        }

        // Spiral Border Style
        if(this.border_spiral_width !== '' && this.border_spiral_width !== undefined && !isNaN(this.border_spiral_width)) {
            this.spiral_line_width = this.border_spiral_width; }
        else { this.spiral_line_width = this.border_width; }
        if(border_spiral_color !== '' && border_spiral_color !== undefined) {
            if(border_spiral_color === 'none') { this.spiral_stroke_style = 'rgba(0, 0, 0, 0)'; }
            else { this.spiral_stroke_style = border_spiral_color; }
        }
        else {
            if(this.border_color === 'none') { this.spiral_stroke_style = 'rgba(0, 0, 0, 0)'; }
            else {
                if(this.angle % 360 === 0) { this.spiral_stroke_style = 'rgba(0, 0, 0, 0)'; }
                else { this.spiral_stroke_style = this.border_color; }
            }
        }
    }

    function draw() {
        if(this.visible) {
            let d = {};

            d.cx = this.cx;
            d.cy = this.cy;
            d.gradient = null;
            d.background = this.background;

            if(this.in_progress) {
                d.dx1 = this.anim_dx1; d.dy1 = this.anim_dy1;
                d.dx2 = this.anim_dx2; d.dy2 = this.anim_dy2;
                d.dx3 = this.anim_dx3; d.dy3 = this.anim_dy3;
                d.dx4 = this.anim_dx4; d.dy4 = this.anim_dy4;
                d.r_in = this.anim_r_in; d.r_out = this.anim_r_out;
                d.init_angle = this.anim_init_angle;
                d.angle = this.anim_angle;
                d.start_a = this.anim_start_a; d.end_a = this.anim_end_a;
                d.th = this.anim_r_out - this.anim_r_in;
                if((this.anim_gradient !== null) && (this.anim_gradient instanceof SegmentGradient)) {
                    d.gradient = this.anim_gradient.instanceCopy();
                    //console.log(d.gradient);
                }
                d.background = this.anim_background;
            }
            else {
                d.dx1 = this.dx1; d.dy1 = this.dy1;
                d.dx2 = this.dx2; d.dy2 = this.dy2;
                d.dx3 = this.dx3; d.dy3 = this.dy3;
                d.dx4 = this.dx4; d.dy4 = this.dy4;
                d.r_in = this.r_in; d.r_out = this.r_out;
                d.init_angle = this.init_angle;
                d.angle = this.angle;
                d.start_a = this.start_a; d.end_a = this.end_a;
                d.th = this.r_out - this.r_in;
                if((this.gradient !== null) && (this.gradient instanceof SegmentGradient)) { d.gradient = this.gradient.instanceCopy(); }
                d.background = this.background;
            }

            let length = Math.abs(Math.PI * d.r_out * d.angle / 180);
            d.a = d.end_a - d.start_a;
            d.d = d.a / length;

            if(this.position === 'inner' && this.direction === 'clockwise') {
                this.drawInnerClockwiseFill(d);
                this.drawInnerClockwiseBorders(d);
            }
            else if(this.position === 'inner' && this.direction === 'anticlockwise') {
                this.drawInnerAnticlockwiseFill(d);
                this.drawInnerAnticlockwiseBorders(d);
            }
            else if(this.position === 'outer' && this.direction === 'clockwise') {
                this.drawOuterClockwiseFill(d);
                this.drawOuterClockwiseBorders(d);
            }
            else if(this.position === 'outer' && this.direction === 'anticlockwise') {
                this.drawOuterAnticlockwiseFill(d);
                this.drawOuterAnticlockwiseBorders(d);
            }
        }
    }

    function drawInnerClockwiseFill(d) {
        if(d.gradient !== null && d.gradient instanceof SegmentGradient && d.gradient.type === 'conic') {
            let arc_length = Math.floor(d.gradient.resolution * 2 * Math.PI * d.r_out);
            let img_data = d.gradient.getImageDataByArcLength(arc_length).data;
            let da = Math.abs(d.end_a - d.start_a) / arc_length;

            for(let i = 0; i < arc_length; i++)
            {
                let angle;
                if(d.gradient.direction === 'clockwise') { angle = d.start_a + i * da; }
                else { angle = d.end_a - i * da; }
                let r = d.r_in + d.th * (angle - d.start_a) / d.a;

                let gx1 = d.r_in * Math.cos(angle) + d.cx;
                let gy1 = d.r_in * Math.sin(angle) + d.cy;
                let gx2 = r * Math.cos(angle) + d.cx;
                let gy2 = r * Math.sin(angle) + d.cy;

                let index = i * 4;
                let color = 'rgba(' + img_data[index] + ',' + img_data[index + 1] + ',' + img_data[index + 2] + ',' + (img_data[index + 3] / 255) + ')';

                this.context.beginPath();
                this.context.moveTo(gx1, gy1);
                this.context.lineTo(gx2, gy2);
                this.context.lineWidth = 1 / d.gradient.resolution;
                this.context.strokeStyle = color;
                this.context.stroke();

                this.context.closePath();
            }
        }
        else {
            this.context.moveTo(d.dx1, d.dy1);

            this.context.beginPath();

            for(let da = d.start_a; da < d.end_a; da += d.d) {
            let r = d.r_in + d.th * (da - d.start_a) / d.a;
            let dx = r * Math.cos(da) + d.cx;
            let dy = r * Math.sin(da) + d.cy;
            this.context.lineTo(dx, dy);
        }
            this.context.arc(d.cx, d.cy, d.r_in, d.end_a, d.start_a, true);
            this.context.lineTo(d.dx1, d.dy1);

            if(d.gradient !== null && d.gradient instanceof SegmentGradient) {
                let canvas_gradient;

                if(d.gradient.type === 'radial') {
                    if(d.gradient.direction === 'from-center') { canvas_gradient = this.context.createRadialGradient(d.cx, d.cy, d.r_in, d.cx, d.cy, d.r_out); }
                    else if(d.gradient.direction === 'to-center') { canvas_gradient = this.context.createRadialGradient(d.cx, d.cy, d.r_out, d.cx, d.cy, d.r_in); }
                }
                else if(d.gradient.type === 'linear') {
                    let x1 = (d.dx1 + d.dx4) / 2;
                    let y1 = (d.dy1 + d.dy4) / 2;
                    let x2 = d.r_out * Math.cos((d.end_a + d.start_a) / 2) + d.cx;
                    let y2 = d.r_out * Math.sin((d.end_a + d.start_a) / 2) + d.cy;

                    if(d.gradient.direction === 'from-center') { canvas_gradient = this.context.createLinearGradient(x1, y1, x2, y2); }
                    else if(d.gradient.direction === 'to-center') { canvas_gradient = this.context.createLinearGradient(x2, y2, x1, y1); }
                    else if(d.gradient.direction === 'from-opening') { canvas_gradient = this.context.createLinearGradient(d.dx2, d.dy2, d.dx3, d.dy3); }
                    else if(d.gradient.direction === 'from-closing') { canvas_gradient = this.context.createLinearGradient(d.dx3, d.dy3, d.dx2, d.dy2); }
                }

                d.gradient.stops.forEach(function(stop) {
                    canvas_gradient.addColorStop(stop.offset, stop.color);
                });

                this.context.fillStyle = canvas_gradient;
            }
            else {
                this.context.fillStyle = d.background;
            }
            this.context.fill();
            this.context.closePath();
        }
    }

    function drawInnerClockwiseBorders(d) {
        // Draw spiral border
        this.context.beginPath();

        for(let da = d.start_a; da < d.end_a; da += d.d) {
            let r = d.r_in + d.th * (da - d.start_a) / d.a;
            let dx = r * Math.cos(da) + d.cx;
            let dy = r * Math.sin(da) + d.cy;
            this.context.lineTo(dx, dy);
        }

        this.context.lineWidth = this.spiral_line_width;
        this.context.strokeStyle = this.spiral_stroke_style;
        this.context.stroke();
        this.context.closePath();

        // Draw closing border
        this.context.beginPath();
        this.context.moveTo(d.dx3, d.dy3);
        this.context.lineTo(d.dx4, d.dy4);
        this.context.lineWidth = this.closing_line_width;
        this.context.strokeStyle = this.closing_stroke_style;
        this.context.stroke();
        this.context.closePath();

        // Draw inner border
        this.context.beginPath();
        this.context.arc(d.cx, d.cy, d.r_in, d.end_a, d.start_a, true);
        this.context.lineWidth = this.inner_line_width;
        this.context.strokeStyle = this.inner_stroke_style;
        this.context.stroke();
        this.context.closePath();
    }

    function drawInnerAnticlockwiseFill(d) {
        if(d.gradient !== null && d.gradient instanceof SegmentGradient && d.gradient.type === 'conic') {
            let arc_length = Math.floor(d.gradient.resolution * 2 * Math.PI * d.r_out);
            let img_data = d.gradient.getImageDataByArcLength(arc_length).data;
            let da = Math.abs(d.end_a - d.start_a) / arc_length;

            for(let i = 0; i < arc_length; i++)
            {
                let angle;
                if(d.gradient.direction === 'clockwise') { angle = d.start_a + i * da; }
                else { angle = d.end_a - i * da; }
                let r = d.r_out - d.th * (angle - d.start_a) / d.a;

                let gx1 = d.r_in * Math.cos(angle) + d.cx;
                let gy1 = d.r_in * Math.sin(angle) + d.cy;
                let gx2 = r * Math.cos(angle) + d.cx;
                let gy2 = r * Math.sin(angle) + d.cy;

                let index = i * 4;
                let color = 'rgba(' + img_data[index] + ',' + img_data[index + 1] + ',' + img_data[index + 2] + ',' + (img_data[index + 3] / 255) + ')';

                this.context.beginPath();
                this.context.moveTo(gx1, gy1);
                this.context.lineTo(gx2, gy2);
                this.context.lineWidth = 1 / d.gradient.resolution;
                this.context.strokeStyle = color;
                this.context.stroke();

                this.context.closePath();
            }
        }
        else {
            this.context.moveTo(d.dx1, d.dy1);
            this.context.lineTo(d.dx2, d.dy2);

            this.context.beginPath();

            for(let da = d.start_a; da < d.end_a; da += d.d) {
                let r = d.r_out - d.th * (da - d.start_a) / d.a;
                let dx = r * Math.cos(da) + d.cx;
                let dy = r * Math.sin(da) + d.cy;
                this.context.lineTo(dx, dy);
            }
            this.context.arc(d.cx, d.cy, d.r_in, d.end_a, d.start_a, true);

            if(d.gradient !== null && d.gradient instanceof SegmentGradient) {
                let canvas_gradient;

                if(d.gradient.type === 'radial') {
                    if(d.gradient.direction === 'from-center') { canvas_gradient = this.context.createRadialGradient(d.cx, d.cy, d.r_in, d.cx, d.cy, d.r_out); }
                    else if(d.gradient.direction === 'to-center') { canvas_gradient = this.context.createRadialGradient(d.cx, d.cy, d.r_out, d.cx, d.cy, d.r_in); }
                }
                else if(d.gradient.type === 'linear') {
                    let x1 = (d.dx1 + d.dx4) / 2;
                    let y1 = (d.dy1 + d.dy4) / 2;
                    let x2 = d.r_out * Math.cos((d.end_a + d.start_a) / 2) + d.cx;
                    let y2 = d.r_out * Math.sin((d.end_a + d.start_a) / 2) + d.cy;

                    if(d.gradient.direction === 'from-center') { canvas_gradient = this.context.createLinearGradient(x1, y1, x2, y2); }
                    else if(d.gradient.direction === 'to-center') { canvas_gradient = this.context.createLinearGradient(x2, y2, x1, y1); }
                    else if(d.gradient.direction === 'from-opening') { canvas_gradient = this.context.createLinearGradient(d.dx2, d.dy2, d.dx3, d.dy3); }
                    else if(d.gradient.direction === 'from-closing') { canvas_gradient = this.context.createLinearGradient(d.dx3, d.dy3, d.dx2, d.dy2); }
                }

                d.gradient.stops.forEach(function(stop) {
                    canvas_gradient.addColorStop(stop.offset, stop.color);
                });

                this.context.fillStyle = canvas_gradient;
            }
            else {
                this.context.fillStyle = d.background;
            }
            this.context.fill();
            this.context.closePath();
        }
    }

    function drawInnerAnticlockwiseBorders(d) {
        // Draw opening border
        this.context.beginPath();
        this.context.moveTo(d.dx1, d.dy1);
        this.context.lineTo(d.dx2, d.dy2);
        this.context.lineWidth = this.opening_line_width;
        this.context.strokeStyle = this.opening_stroke_style;
        this.context.stroke();
        this.context.closePath();

        // Draw spiral border
        this.context.beginPath();

        for(let da = d.start_a; da < d.end_a; da += d.d) {
            let r = d.r_out - d.th * (da - d.start_a) / d.a;
            let dx = r * Math.cos(da) + d.cx;
            let dy = r * Math.sin(da) + d.cy;
            this.context.lineTo(dx, dy);
        }

        this.context.lineWidth = this.spiral_line_width;
        this.context.strokeStyle = this.spiral_stroke_style;
        this.context.stroke();
        this.context.closePath();

        // Draw inner border
        this.context.beginPath();
        this.context.arc(d.cx, d.cy, d.r_in, d.end_a, d.start_a, true);
        this.context.lineWidth = this.inner_line_width;
        this.context.strokeStyle = this.inner_stroke_style;
        this.context.stroke();
        this.context.closePath();
    }

    function drawOuterClockwiseFill(d) {
        if(d.gradient !== null && d.gradient instanceof SegmentGradient && d.gradient.type === 'conic') {
            let arc_length = Math.floor(d.gradient.resolution * 2 * Math.PI * d.r_out);
            let img_data = d.gradient.getImageDataByArcLength(arc_length).data;
            let da = Math.abs(d.end_a - d.start_a) / arc_length;

            for(let i = 0; i < arc_length; i++)
            {
                let angle;
                if(d.gradient.direction === 'clockwise') { angle = d.start_a + i * da; }
                else { angle = d.end_a - i * da; }
                let r = d.r_out - d.th * (angle - d.start_a) / d.a;

                let gx1 = d.r_out * Math.cos(angle) + d.cx;
                let gy1 = d.r_out * Math.sin(angle) + d.cy;
                let gx2 = r * Math.cos(angle) + d.cx;
                let gy2 = r * Math.sin(angle) + d.cy;

                let index = i * 4;
                let color = 'rgba(' + img_data[index] + ',' + img_data[index + 1] + ',' + img_data[index + 2] + ',' + (img_data[index + 3] / 255) + ')';

                this.context.beginPath();
                this.context.moveTo(gx1, gy1);
                this.context.lineTo(gx2, gy2);
                this.context.lineWidth = 1 / d.gradient.resolution;
                this.context.strokeStyle = color;
                this.context.stroke();

                this.context.closePath();
            }
        }
        else {
            this.context.beginPath();

            this.context.arc(d.cx, d.cy, d.r_out, d.start_a, d.end_a);
            this.context.lineTo(d.dx4, d.dy4);

            for(let da = d.end_a; da > d.start_a; da -= d.d) {
                let r = d.r_in + d.th * (d.end_a - da) / d.a;
                let dx = r * Math.cos(da) + d.cx;
                let dy = r * Math.sin(da) + d.cy;
                this.context.lineTo(dx, dy);
            }

            if(d.gradient !== null && d.gradient instanceof SegmentGradient) {
                let canvas_gradient;

                if(d.gradient.type === 'radial') {
                    if(d.gradient.direction === 'from-center') { canvas_gradient = this.context.createRadialGradient(d.cx, d.cy, d.r_in, d.cx, d.cy, d.r_out); }
                    else if(d.gradient.direction === 'to-center') { canvas_gradient = this.context.createRadialGradient(d.cx, d.cy, d.r_out, d.cx, d.cy, d.r_in); }
                }
                else if(d.gradient.type === 'linear') {
                    let x1 = (d.dx1 + d.dx4) / 2;
                    let y1 = (d.dy1 + d.dy4) / 2;
                    let x2 = d.r_out * Math.cos((d.end_a + d.start_a) / 2) + d.cx;
                    let y2 = d.r_out * Math.sin((d.end_a + d.start_a) / 2) + d.cy;

                    if(d.gradient.direction === 'from-center') { canvas_gradient = this.context.createLinearGradient(x1, y1, x2, y2); }
                    else if(d.gradient.direction === 'to-center') { canvas_gradient = this.context.createLinearGradient(x2, y2, x1, y1); }
                    else if(d.gradient.direction === 'from-opening') { canvas_gradient = this.context.createLinearGradient(d.dx2, d.dy2, d.dx3, d.dy3); }
                    else if(d.gradient.direction === 'from-closing') { canvas_gradient = this.context.createLinearGradient(d.dx3, d.dy3, d.dx2, d.dy2); }
                }

                d.gradient.stops.forEach(function(stop) {
                    canvas_gradient.addColorStop(stop.offset, stop.color);
                });

                this.context.fillStyle = canvas_gradient;
            }
            else {
                this.context.fillStyle = d.background;
            }
            this.context.fill();
            this.context.closePath();
        }
    }

    function drawOuterClockwiseBorders(d) {
        // Draw outer border
        this.context.beginPath();
        this.context.arc(d.cx, d.cy, d.r_out, d.start_a, d.end_a);
        this.context.lineWidth = this.outer_line_width;
        this.context.strokeStyle = this.outer_stroke_style;
        this.context.stroke();
        this.context.closePath();

        // Draw closing border
        this.context.beginPath();
        this.context.moveTo(d.dx3, d.dy3);
        this.context.lineTo(d.dx4, d.dy4);
        this.context.lineWidth = this.closing_line_width;
        this.context.strokeStyle = this.closing_stroke_style;
        this.context.stroke();
        this.context.closePath();

        // Draw spiral border
        this.context.beginPath();

        for(let da = d.end_a; da > d.start_a; da -= d.d) {
            let r = d.r_in + d.th * (d.end_a - da) / d.a;
            let dx = r * Math.cos(da) + d.cx;
            let dy = r * Math.sin(da) + d.cy;
            this.context.lineTo(dx, dy);
        }

        this.context.lineWidth = this.spiral_line_width;
        this.context.strokeStyle = this.spiral_stroke_style;
        this.context.stroke();
        this.context.closePath();
    }

    function drawOuterAnticlockwiseFill(d) {
        if(d.gradient !== null && d.gradient instanceof SegmentGradient && d.gradient.type === 'conic') {
            let arc_length = Math.floor(d.gradient.resolution * 2 * Math.PI * d.r_out);
            let img_data = d.gradient.getImageDataByArcLength(arc_length).data;
            let da = Math.abs(d.end_a - d.start_a) / arc_length;

            for(let i = 0; i < arc_length; i++)
            {
                let angle;
                if(d.gradient.direction === 'clockwise') { angle = d.start_a + i * da; }
                else { angle = d.end_a - i * da; }
                let r = d.r_in + d.th * (angle - d.start_a) / d.a;

                let gx1 = d.r_out * Math.cos(angle) + d.cx;
                let gy1 = d.r_out * Math.sin(angle) + d.cy;
                let gx2 = r * Math.cos(angle) + d.cx;
                let gy2 = r * Math.sin(angle) + d.cy;

                let index = i * 4;
                let color = 'rgba(' + img_data[index] + ',' + img_data[index + 1] + ',' + img_data[index + 2] + ',' + (img_data[index + 3] / 255) + ')';

                this.context.beginPath();
                this.context.moveTo(gx1, gy1);
                this.context.lineTo(gx2, gy2);
                this.context.lineWidth = 1 / d.gradient.resolution;
                this.context.strokeStyle = color;
                this.context.stroke();

                this.context.closePath();
            }
        }
        else {
            this.context.beginPath();

            this.context.moveTo(d.dx1, d.dy1);
            this.context.lineTo(d.dx2, d.dy2);
            this.context.arc(d.cx, d.cy, d.r_out, d.start_a, d.end_a);

            for(let da = d.end_a; da > d.start_a; da -= d.d) {
                let r = d.r_out - d.th * (d.end_a - da) / d.a;
                let dx = r * Math.cos(da) + d.cx;
                let dy = r * Math.sin(da) + d.cy;
                this.context.lineTo(dx, dy);
            }

            if(d.gradient !== null && d.gradient instanceof SegmentGradient) {
                let canvas_gradient;

                if(d.gradient.type === 'radial') {
                    if(d.gradient.direction === 'from-center') { canvas_gradient = this.context.createRadialGradient(d.cx, d.cy, d.r_in, d.cx, d.cy, d.r_out); }
                    else if(d.gradient.direction === 'to-center') { canvas_gradient = this.context.createRadialGradient(d.cx, d.cy, d.r_out, d.cx, d.cy, d.r_in); }
                }
                else if(d.gradient.type === 'linear') {
                    let x1 = (d.dx1 + d.dx4) / 2;
                    let y1 = (d.dy1 + d.dy4) / 2;
                    let x2 = d.r_out * Math.cos((d.end_a + d.start_a) / 2) + d.cx;
                    let y2 = d.r_out * Math.sin((d.end_a + d.start_a) / 2) + d.cy;

                    if(d.gradient.direction === 'from-center') { canvas_gradient = this.context.createLinearGradient(x1, y1, x2, y2); }
                    else if(d.gradient.direction === 'to-center') { canvas_gradient = this.context.createLinearGradient(x2, y2, x1, y1); }
                    else if(d.gradient.direction === 'from-opening') { canvas_gradient = this.context.createLinearGradient(d.dx2, d.dy2, d.dx3, d.dy3); }
                    else if(d.gradient.direction === 'from-closing') { canvas_gradient = this.context.createLinearGradient(d.dx3, d.dy3, d.dx2, d.dy2); }
                }

                d.gradient.stops.forEach(function(stop) {
                    canvas_gradient.addColorStop(stop.offset, stop.color);
                });

                this.context.fillStyle = canvas_gradient;
            }
            else {
                this.context.fillStyle = d.background;
            }
            this.context.fill();
            this.context.closePath();
        }
    }

    function drawOuterAnticlockwiseBorders(d) {
        // Draw opening border
        this.context.beginPath();
        this.context.moveTo(d.dx1, d.dy1);
        this.context.lineTo(d.dx2, d.dy2);
        this.context.lineWidth = this.opening_line_width;
        this.context.strokeStyle = this.opening_stroke_style;
        this.context.stroke();
        this.context.closePath();

        // Draw outer border
        this.context.beginPath();
        this.context.arc(d.cx, d.cy, d.r_out, d.start_a, d.end_a);
        this.context.lineWidth = this.outer_line_width;
        this.context.strokeStyle = this.outer_stroke_style;
        this.context.stroke();
        this.context.closePath();

        // Draw spiral border
        this.context.beginPath();

        for(let da = d.end_a; da > d.start_a; da -= d.d) {
            let r = d.r_out - d.th * (d.end_a - da) / d.a;
            let dx = r * Math.cos(da) + d.cx;
            let dy = r * Math.sin(da) + d.cy;
            this.context.lineTo(dx, dy);
        }

        this.context.lineWidth = this.spiral_line_width;
        this.context.strokeStyle = this.spiral_stroke_style;
        this.context.stroke();
        this.context.closePath();
    }

    function prepareAnim() {
        this.anim_r_in = this.r_in;
        this.anim_thickness = this.thickness;
        this.anim_r_out = this.r_out;
        this.anim_init_angle = this.init_angle;
        this.anim_angle = this.angle;

        if(this.gradient) { this.anim_gradient = this.gradient.instanceCopy(); }
        this.anim_background = this.background;
        this.anim_border_width = this.border_width;
        this.anim_border_color = this.border_color;

        this.anim_border_opening_color = this.border_opening_color;
        this.anim_border_closing_color = this.border_closing_color;
        this.anim_border_outer_color = this.border_outer_color;
        this.anim_border_inner_color = this.border_inner_color;
        this.anim_border_spiral_color = this.border_spiral_color;
    }

    function appear(direction, duration, delay) {
        this.prepareAnim();

        this.in_progress = true;
        this.calc();

        let spiral = this;

        let start = null;
        let time = null;
        let fraction = 0;
        let request = null;

        function appearAnim() {
            time = Date.now();
            fraction = (time - start) / (duration * 1000);

            let anim_func;
            if(direction === 'from-center') {
                if(spiral.position === 'inner') { anim_func = spiral.appearFromCenter.bind(spiral); }
                else return;
            }
            else if(direction === 'to-center') {
                if(spiral.position === 'outer') { anim_func = spiral.appearToCenter.bind(spiral); }
                else return;
            }
            else if(direction === 'clockwise') {
                if(spiral.direction === 'clockwise') { anim_func = spiral.appearClockwise.bind(spiral); }
                else return;
            }
            else if(direction === 'anticlockwise') {
                if(spiral.direction === 'anticlockwise') { anim_func = spiral.appearAnticlockwise.bind(spiral); }
                else return;
            }
            anim_func(fraction);

            if(fraction > 1) {
                spiral.stopAppearance();
                spiral.context.canvas.cancelRequestAnimationFrame(request);
                //dispatchEvent(new CustomEvent("segment-spiral-appeared", { detail : { spiral : spiral } }));
                segmentSpiralAppeared();
            }
            else {
                spiral.visible = true;
                request = spiral.context.canvas.requestAnimationFrame(appearAnim);
            }
        };

        request = utilities.setTimeout(function() {
            start = Date.now();
            request = spiral.context.canvas.requestAnimationFrame(appearAnim);
        }, delay * 1000);
    }

    function appearFromCenter(t) {
        let r = this.r_in + (this.r_out - this.r_in) * t;
        if(r < this.r_out) {
            this.anim_r_out = r;
            this.anim_thickness = this.anim_r_out - this.anim_r_in;
        }
        else {
            this.anim_r_out = this.r_out;
            this.anim_thickness = this.thickness;
        };
        this.calc();
    }

    function appearToCenter(t) {
        let r = this.r_out - (this.r_out - this.r_in) * t;
        if(r > this.r_in) {
            this.anim_r_in = r;
            this.anim_thickness = this.anim_r_out - this.anim_r_in;
        }
        else {
            this.anim_r_in = this.r_in;
            this.anim_thickness = this.thickness;
        }
        this.calc();
    }

    function appearClockwise(t) {
        let a = this.angle * t;
        if(a < this.angle) {
            this.anim_angle = a;
            if(this.position === 'inner') { this.anim_thickness = this.thicknessByAngle(a); }
            else {
                this.anim_thickness = this.thicknessByAngle(a);
                this.anim_r_in = this.r_out - this.anim_thickness;
            }
        }
        else {
            this.anim_angle = this.angle;
            this.anim_thickness = this.thickness;
            this.anim_r_in = this.r_in;
        }
        this.calc();
    }

    function appearAnticlockwise(t) {
        let a = this.angle * t;
        if(a < this.angle) {
            this.anim_init_angle = this.init_angle + this.angle - a;
            this.anim_angle = a;
            if(this.position === 'inner') { this.anim_thickness = this.thicknessByAngle(a); }
            else {
                this.anim_thickness = this.thicknessByAngle(a);
                this.anim_r_in = this.r_out - this.anim_thickness;
            }
        }
        else {
            this.anim_init_angle = this.init_angle;
            this.anim_angle = this.angle;
        }
        this.calc();
    }

    function stopAppearance() {
        this.anim_r_in = 0;
        this.anim_r_out = 0;
        this.anim_init_angle = 0;
        this.anim_angle = 0;

        this.in_progress = false;
        this.visible = true;

        this.calc();
    }

    function disappear(direction, duration, delay) {
        this.prepareAnim();

        this.in_progress = true;
        this.calc();

        let spiral = this;

        let start;
        let time = null;
        let fraction = 0;
        let request = null;

        function disappearAnim() {
            time = Date.now();
            fraction = (time - start) / (duration * 1000);

            let anim_func;
            if(direction === 'from-center') {
                if(spiral.position === 'outer') { anim_func = spiral.disappearFromCenter.bind(spiral); }
                else return;
            }
            else if(direction === 'to-center') {
                if(spiral.position === 'inner') { anim_func = spiral.disappearToCenter.bind(spiral); }
                else return;
            }
            else if(direction === 'clockwise') {
                if(spiral.direction === 'anticlockwise') { anim_func = spiral.disappearClockwise.bind(spiral); }
                else return;
            }
            else if(direction === 'anticlockwise') {
                if(spiral.direction === 'clockwise') { anim_func = spiral.disappearAnticlockwise.bind(spiral); }
                else return;
            }
            anim_func(fraction);

            if(fraction > 1) {
                spiral.stopDisappearance();
                spiral.context.canvas.cancelRequestAnimationFrame(request);
                //dispatchEvent(new CustomEvent("segment-spiral-disappeared", { detail : { spiral : spiral } }));
                segmentSpiralDisappeared();
            }
            else {
                spiral.visible = true;
                request = spiral.context.canvas.requestAnimationFrame(disappearAnim);
            }
        };

        request = utilities.setTimeout(function() {
            start = Date.now();
            spiral.context.canvas.requestAnimationFrame(disappearAnim);
        }, delay * 1000);
    }

    function disappearFromCenter(t) {
        let r = this.r_in + (this.r_out - this.r_in) * t;
        if(r < this.r_out) {
            this.anim_r_in = r;
            this.anim_thickness = this.anim_r_out - this.anim_r_in;
        }
        else {
            this.anim_r_in = this.r_out;
            this.anim_thickness = this.thickness;
        };
        this.calc();
    }

    function disappearToCenter(t) {
        let r = this.r_out - (this.r_out - this.r_in) * t;
        if(r > this.r_in) {
            this.anim_r_out = r;
            this.anim_thickness = this.anim_r_out - this.anim_r_in;
        }
        else {
            this.anim_r_out = this.r_in;
            this.anim_thickness = this.thickness;
        }
        this.calc();
    }

    function disappearClockwise(t) {
        let a = this.angle * t;
        if(a < this.angle) {
            this.anim_init_angle = this.init_angle + a;
            this.anim_angle = this.angle - a;
            if(this.position === 'inner') { this.anim_thickness = this.thicknessByAngle(this.angle - a); }
            else {
                this.anim_thickness = this.thicknessByAngle(this.angle - a);
                this.anim_r_in = this.r_out - this.anim_thickness;
            }
        }
        else {
            this.anim_init_angle = this.init_angle;
            this.anim_angle = 0;
            this.anim_thickness = this.thickness;
            this.anim_r_in = this.r_in;
        }
        this.calc();
    }

    function disappearAnticlockwise(t) {
        let a = this.angle * t;
        if(a < this.angle) {
            this.anim_init_angle = this.init_angle;
            this.anim_angle = this.angle - a;
            if(this.position === 'inner') { this.anim_thickness = this.thicknessByAngle(this.angle - a); }
            else {
                this.anim_thickness = this.thicknessByAngle(this.angle - a);
                this.anim_r_in = this.r_out - this.anim_thickness;
            }
        }
        else {
            this.anim_init_angle = this.init_angle;
            this.anim_angle = 0;
            this.anim_thickness = this.thickness;
            this.anim_r_in = this.r_in;
        }
        this.calc();
    }

    function stopDisappearance() {
        this.anim_r_in = 0;
        this.anim_r_out = 0;
        this.anim_init_angle = 0;
        this.anim_angle = 0;

        this.in_progress = false;
        this.visible = false;

        this.calc();
    }

    function rotate(direction, angle, duration, delay) {
        this.prepareAnim();

        this.in_progress = true;
        this.calc();

        let spiral = this;

        let start;
        let time = null;
        let fraction = 0;
        let request = null;

        function rotateAnim() {
            time = Date.now();

            fraction = (time - start) * angle / (duration * 1000);

            let anim_func;
            if(direction === 'clockwise') { anim_func = spiral.rotateClockwise.bind(spiral); }
            else if(direction === 'anticlockwise') { anim_func = spiral.rotateAnticlockwise.bind(spiral); }
            anim_func(fraction);

            if((time - start) > duration * 1000) {
                spiral.stopRotation();
                spiral.cancelRequestAnimationFrame(request);
                //dispatchEvent(new CustomEvent("segment-spiral-rotated", { detail : { spiral : spiral } }));
                segmentSpiralRotated();
            }
            else {
                spiral.visible = true;
                request = spiral.context.canvas.requestAnimationFrame(rotateAnim);
            }
        };

        request = utilities.setTimeout(function() {
            start = Date.now();
            spiral.context.canvas.requestAnimationFrame(rotateAnim);
        }, delay * 1000);
    }

    function rotateClockwise(a) {
        this.anim_init_angle = this.init_angle + a;
        this.calc();
    }

    function rotateAnticlockwise(a) {
        this.anim_init_angle = this.init_angle - a;
        this.calc();
    }

    function stopRotation() {
        this.r_in = this.anim_r_in;
        this.r_out = this.anim_r_out;
        this.init_angle = this.anim_init_angle;
        this.angle = this.anim_angle;

        this.anim_r_in = 0;
        this.anim_r_out = 0;
        this.anim_init_angle = 0;
        this.anim_angle = 0;

        this.in_progress = false;

        this.calc();
    }

    function fadeIn(duration, delay) {
        this.prepareAnim();

        this.calc();
        this.in_progress = true;

        let spiral = this;

        let start;
        let time = null;
        let fraction = 0;
        let request = null;

        let bg = utilities.rgbaStrToObj(utilities.rgbaStrFromColor(this.background));

        let opening_bc = utilities.rgbaStrToObj(utilities.rgbaStrFromColor(this.opening_stroke_style));
        let closing_bc = utilities.rgbaStrToObj(utilities.rgbaStrFromColor(this.closing_stroke_style));
        let outer_bc = utilities.rgbaStrToObj(utilities.rgbaStrFromColor(this.outer_stroke_style));
        let inner_bc = utilities.rgbaStrToObj(utilities.rgbaStrFromColor(this.inner_stroke_style));
        let spiral_bc = utilities.rgbaStrToObj(utilities.rgbaStrFromColor(this.spiral_stroke_style));

        let new_bg = Object.assign({}, bg);

        let new_opening_bc = Object.assign({}, opening_bc);
        let new_closing_bc = Object.assign({}, closing_bc);
        let new_outer_bc = Object.assign({}, outer_bc);
        let new_inner_bc = Object.assign({}, inner_bc);
        let new_spiral_bc = Object.assign({}, spiral_bc);

        function fadeInAnim() {
            time = Date.now();
            fraction = (time - start) / (duration * 1000);

            if(spiral.gradient !== null) {
                let new_gr = spiral.gradient.instanceCopy();
                new_gr.fade(fraction);
                spiral.anim_gradient = new_gr.instanceCopy();
            }

            new_bg.a = bg.a * (fraction);
            spiral.anim_background = utilities.rgbaObjToStr(new_bg);

            new_opening_bc.a = opening_bc.a * (fraction);
            spiral.anim_border_opening_color = utilities.rgbaObjToStr(new_opening_bc);

            new_closing_bc.a = closing_bc.a * (fraction);
            spiral.anim_border_closing_color = utilities.rgbaObjToStr(new_closing_bc);

            new_outer_bc.a = outer_bc.a * (fraction);
            spiral.anim_border_outer_color = utilities.rgbaObjToStr(new_outer_bc);

            new_inner_bc.a = inner_bc.a * (fraction);
            spiral.anim_border_inner_color = utilities.rgbaObjToStr(new_inner_bc);

            new_spiral_bc.a = spiral_bc.a * (fraction);
            spiral.anim_border_spiral_color = utilities.rgbaObjToStr(new_spiral_bc);

            let calc_func = spiral.calc.bind(spiral);
            calc_func();

            if(fraction > 1) {
                if(this.gradient !== null && (this.gradient instanceof SegmentGradient)) { this.anim_gradient = this.gradient.instanceCopy(); }
                spiral.anim_background = spiral.background;
                spiral.anim_border_color = spiral.border_color;
                spiral.stopFadingIn();
                spiral.context.canvas.cancelRequestAnimationFrame(request);
                //dispatchEvent(new CustomEvent("segment-spiral-faded-in", { detail : { spiral : spiral } }));
                segmentSpiralFadedIn();
            }
            else {
                spiral.visible = true;
                spiral.context.canvas.requestAnimationFrame(fadeInAnim);
            }
        };

        request = utilities.setTimeout(function() {
            start = Date.now();
            spiral.context.canvas.requestAnimationFrame(fadeInAnim);
        }, delay * 1000);
    }

    function stopFadingIn() {
        this.visible = true;
        this.in_progress = false;

        this.calc();
    }

    function fadeOut(duration, delay) {
        this.prepareAnim();

        this.in_progress = true;
        this.calc();

        let spiral = this;

        let start;
        let time = null;
        let fraction = 0;
        let request = null;

        let bg = utilities.rgbaStrToObj(utilities.rgbaStrFromColor(this.anim_background));

        let opening_bc = utilities.rgbaStrToObj(utilities.rgbaStrFromColor(this.opening_stroke_style));
        let closing_bc = utilities.rgbaStrToObj(utilities.rgbaStrFromColor(this.closing_stroke_style));
        let outer_bc = utilities.rgbaStrToObj(utilities.rgbaStrFromColor(this.outer_stroke_style));
        let inner_bc = utilities.rgbaStrToObj(utilities.rgbaStrFromColor(this.inner_stroke_style));
        let spiral_bc = utilities.rgbaStrToObj(utilities.rgbaStrFromColor(this.spiral_stroke_style));

        let new_bg = Object.assign({}, bg);

        let new_opening_bc = Object.assign({}, opening_bc);
        let new_closing_bc = Object.assign({}, closing_bc);
        let new_outer_bc = Object.assign({}, outer_bc);
        let new_inner_bc = Object.assign({}, inner_bc);
        let new_spiral_bc = Object.assign({}, spiral_bc);

        function fadeOutAnim() {
            time = Date.now();
            fraction = (time - start) / (duration * 1000);

            if(spiral.gradient !== null) {
                let new_gr = spiral.gradient.instanceCopy();
                new_gr.fade(1 - fraction);
                spiral.anim_gradient = new_gr.instanceCopy();
            }

            new_bg.a = bg.a * (1 - fraction);
            spiral.anim_background = utilities.rgbaObjToStr(new_bg);

            new_opening_bc.a = opening_bc.a * (1 - fraction);
            spiral.anim_border_opening_color = utilities.rgbaObjToStr(new_opening_bc);

            new_closing_bc.a = closing_bc.a * (1 - fraction);
            spiral.anim_border_closing_color = utilities.rgbaObjToStr(new_closing_bc);

            new_outer_bc.a = outer_bc.a * (1 - fraction);
            spiral.anim_border_outer_color = utilities.rgbaObjToStr(new_outer_bc);

            new_inner_bc.a = inner_bc.a * (1 - fraction);
            spiral.anim_border_inner_color = utilities.rgbaObjToStr(new_inner_bc);

            new_spiral_bc.a = spiral_bc.a * (1 - fraction);
            spiral.anim_border_spiral_color = utilities.rgbaObjToStr(new_spiral_bc);

            let calc_func = spiral.calc.bind(spiral);
            calc_func();

            if(fraction > 1) {
                if(this.gradient !== null && (this.gradient instanceof SegmentGradient)) { this.anim_gradient = this.gradient.instanceCopy(); }
                spiral.anim_background = spiral.background;
                spiral.anim_border_color = spiral.border_color;
                spiral.stopFadingOut();
                spiral.context.canvas.cancelRequestAnimationFrame(request);
                //dispatchEvent(new CustomEvent("segment-spiral-faded-out", { detail : { spiral : spiral } }));
                segmentSpiralFadedOut();
            }
            else {
                spiral.visible = true;
                request = spiral.context.canvas.requestAnimationFrame(fadeOutAnim);
            }
        };

        request = utilities.setTimeout(function() {
            start = Date.now();
            spiral.context.canvas.requestAnimationFrame(fadeOutAnim); }, delay * 1000);
    }

    function stopFadingOut() {
        this.visible = false;
        this.in_progress = false;

        this.calc();
    }

    function thicknessByAngle(a) {
        let th = this.thickness * a / this.angle;
        return th;
    }

    /*
    function instanceCopy() {
        const copy = new this.constructor();
        const keys = Object.keys(this);
        keys.forEach(key => { copy[key] = this[key]; });
        return copy;
    };
    */
}
