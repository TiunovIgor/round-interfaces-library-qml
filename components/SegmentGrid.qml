import QtQuick 2.0

Segment {
    property int circles_count: 3
    property double circle_pitch
    property double circle_width: 1
    property string circle_color: '#999'

    property int beams_count: 10
    property double beam_pitch
    property double beam_width: 1
    property string beam_color: '#999'

    property bool circles_visible: true
    property bool beams_visible: true

    Component.onCompleted: {
        this.build();
        this.calc();
    }

    function build() {
        this.circle_pitch = this.thickness / (this.circles_count + 1);

        if(this.angle === 360) { this.beam_pitch = this.angle / (this.beams_count); }
        else { this.beam_pitch = this.angle / (this.beams_count + 1); }
    }

    function draw() {
        if(this.visible) {
            let cx = this.cx, cy = this.cy;

            let dx1, dy1, dx2, dy2, dx3, dy3, dx4, dy4;
            let r_in, r_out;
            let start_a, end_a;
            let gradient = null;
            let background = this.background;

            if(this.in_progress) {
                dx1 = this.anim_dx1; dy1 = this.anim_dy1;
                dx2 = this.anim_dx2; dy2 = this.anim_dy2;
                dx3 = this.anim_dx3; dy3 = this.anim_dy3;
                dx4 = this.anim_dx4; dy4 = this.anim_dy4;
                r_in = this.anim_r_in; r_out = this.anim_r_out;
                start_a = this.anim_start_a; end_a = this.anim_end_a;
                if((this.anim_gradient !== null) && (this.anim_gradient instanceof SegmentGradient)) { gradient = this.anim_gradient.instanceCopy(); }
                background = this.anim_background;
            }
            else {
                dx1 = this.dx1; dy1 = this.dy1;
                dx2 = this.dx2; dy2 = this.dy2;
                dx3 = this.dx3; dy3 = this.dy3;
                dx4 = this.dx4; dy4 = this.dy4;
                r_in = this.r_in; r_out = this.r_out;
                start_a = this.start_a; end_a = this.end_a;
                if(this.gradient !== null && (this.gradient instanceof SegmentGradient)) { gradient = this.gradient.instanceCopy(); }
                background = this.background;
            }

            // Draw Fill
            this.context.moveTo(dx1, dy1);

            this.context.beginPath();
            this.context.lineTo(dx2, dy2);
            this.context.arc(cx, cy, r_out, start_a, end_a);
            this.context.arc(cx, cy, r_in, end_a, start_a, true);
            this.context.lineTo(dx1, dy1);

            if(gradient !== null && gradient instanceof SegmentGradient) {
                let canvas_gradient;

                if(gradient.type === 'radial') {
                    if(gradient.direction === 'from-center') { canvas_gradient = this.context.createRadialGradient(cx, cy, r_in, cx, cy, r_out); }
                    else if(gradient.direction === 'to-center') { canvas_gradient = this.context.createRadialGradient(cx, cy, r_out, cx, cy, r_in); }
                }
                else if(gradient.type === 'linear') {
                    let x1 = (dx1 + dx4) / 2;
                    let y1 = (dy1 + dy4) / 2;
                    let x2 = r_out * Math.cos((end_a + start_a) / 2) + this.cx;
                    let y2 = r_out * Math.sin((end_a + start_a) / 2) + this.cy;

                    if(gradient.direction === 'from-center') { canvas_gradient = this.context.createLinearGradient(x1, y1, x2, y2); }
                    else if(gradient.direction === 'to-center') { canvas_gradient = this.context.createLinearGradient(x2, y2, x1, y1); }
                    else if(gradient.direction === 'from-opening') { canvas_gradient = this.context.createLinearGradient(dx2, dy2, dx3, dy3); }
                    else if(gradient.direction === 'from-closing') { canvas_gradient = this.context.createLinearGradient(dx3, dy3, dx2, dy2); }
                }

                gradient.stops.forEach(function(stop) {
                    canvas_gradient.addColorStop(stop.offset, stop.color);
                });

                this.context.fillStyle = canvas_gradient;
            }
            else {
                this.context.fillStyle = background;
            }
            this.context.fill();
            this.context.closePath();

            // Draw Grid
            if(this.circles_visible) {
                for(let i=0; i < this.circles_count; i++) {
                    let r = r_in + this.circle_pitch * (i + 1);

                    this.context.beginPath();
                    this.context.arc(cx, cy, r, start_a, end_a);
                    this.context.lineWidth = this.circle_width;
                    this.context.strokeStyle = this.circle_color;
                    this.context.stroke();
                    this.context.closePath();
                }
            }

            if(this.beams_visible) {
                for(let i=0; i < this.beams_count; i++) {
                    let ba = this.init_angle + this.beam_pitch * (i + 1);
                    let rba = ba * Math.PI / 180;

                    let bx1 = this.r_in * Math.cos(rba) + this.cx; // First point of beam. X coordinate
                    let by1 = this.r_in * Math.sin(rba) + this.cy; // First point of beam. Y coordinate
                    let bx2 = this.r_out * Math.cos(rba) + this.cx; // Second point of beam. X coordinate
                    let by2 = this.r_out * Math.sin(rba) + this.cy; // Second point of beam. Y coordinate

                    this.context.beginPath();
                    this.context.moveTo(bx1, by1);
                    this.context.lineTo(bx2, by2);
                    this.context.lineWidth = this.beam_width;
                    this.context.strokeStyle = this.beam_color;
                    this.context.stroke();
                    this.context.closePath();
                }
            }

            // Draw Borders

            // Draw Opening Border
            this.context.beginPath();
            this.context.moveTo(dx1, dy1);
            this.context.lineTo(dx2, dy2);
            this.context.lineWidth = this.opening_line_width;
            this.context.strokeStyle = this.opening_stroke_style;
            this.context.stroke();
            this.context.closePath();

            // Draw Outer Border
            this.context.beginPath();
            this.context.arc(cx, cy, r_out, start_a, end_a);
            this.context.lineWidth = this.outer_line_width;
            this.context.strokeStyle = this.outer_stroke_style;
            this.context.stroke();
            this.context.closePath();

            // Draw Inner Border
            this.context.beginPath();
            this.context.arc(cx, cy, r_in, end_a, start_a, true);
            this.context.lineWidth = this.inner_line_width;
            this.context.strokeStyle = this.inner_stroke_style;
            this.context.stroke();
            this.context.closePath();

            // Draw Closing Border
            this.context.beginPath();
            this.context.moveTo(dx3, dy3);
            this.context.lineTo(dx4, dy4);
            this.context.lineWidth = this.closing_line_width;
            this.context.strokeStyle = this.closing_stroke_style;
            this.context.stroke();
            this.context.closePath();
        }
    }
}
