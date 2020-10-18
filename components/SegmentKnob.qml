import QtQuick 2.0

Item {
    //this.id = id; // Object identificator
    property string name
    property var context // CanvasRenderingContext2D for drawing a segment dots array
    property double cx // X coordinate of the base segment center
    property double cy // Y coordinate of the base segment center
    property double r_in // base segment inner radius
    property double thickness // base segment thickness
    property double r_out: r_in + thickness // base segment outer radius
    property double init_angle: -90 // base segment initial angle
    property double angle: 360 // base segment angle

    property Segment base_segment: null

    //property SegmentGradient gradient: new SegmentGradient('radial', 'from-center', '#fff 0%, #eee 80%, #ccc 86%, #666 90%, #eee 95%, #ddd 100%');
    property string background: "rgba(200, 200, 200, 1)"
    property double border_width: 1
    property string border_color: "rgba(100, 100, 100, 1)"

    property string notch_type: 'dot' // 'dot' - SegmentDot, 'mark' - SegmentScaleMark
    property double notch_init_angle: this.angle / 2
    property double notch_min_angle: 180
    property double notch_max_angle: 360
    property double notch_angle: 180
    property double notch_width: 1 // dot_border_width or mark_width
    property string notch_color: 'rgba(50, 50, 50, 1)' // dot_border_color or mark_color

    property SegmentDot dot: null
    property double dot_radius: 5
    property double dot_base_radius: this.r_in + this.thickness * 0.7
    property SegmentGradient dot_gradient: null
    property string dot_background: 'rgba(150, 150, 150, 1)'

    property SegmentScaleMark mark: null
    property double mark_r_in: this.r_in + this.thickness - 9
    property double mark_length: 8

    property bool notch_visible: true
    property bool in_progress: false
    property bool is_active: false

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

    property double anim_notch_angle;
    property double anim_init_angle;

    signal segmentKnobChanged;

    Utilities { id: utilities; }

    Component.onCompleted: {
        this.build();
        this.calc();
    }

    function build() {
        //this.base_segment = new Segment(this.id + '_base_segment', this.context, this.cx, this.cy, this.r_in, this.thickness, this.init_angle, this.angle);

        let segment_component = Qt.createComponent("Segment.qml");
        this.base_segment = segment_component.createObject(this, {
             id: this.id + '_base_segment', context: this.context, cx: this.cx, cy: this.cy,
             r_in: this.r_in, thickness: this.thickness, init_angle: this.init_angle, angle: this.angle });

        if(this.gradient) { this.base_segment.gradient = this.gradient.instanceCopy(); }
        this.base_segment.background = this.background;this.base_segment.border_width = this.border_width;
        this.base_segment.border_color = this.border_color;
        this.base_segment.calc();

        let angle = this.init_angle + this.notch_init_angle;
        let a = angle * Math.PI / 180;

        if(this.notch_type === 'dot') {
            let nx = this.dot_base_radius * Math.cos(a) + this.cx;
            let ny = this.dot_base_radius * Math.sin(a) + this.cy;

            //this.dot = new SegmentDot(this.id + '_notch', this.context, nx, ny, this.dot_radius);

            let dot_component = Qt.createComponent("SegmentDot.qml");
            this.dot = dot_component.createObject(this, {
                 id: this.id + '_notch', context: this.context, cx: nx, cy: ny, r: this.dot_radius });

            if(this.dot_gradient) { this.dot.gradient = this.dot_gradient.instanceCopy(); }
            this.dot.background = this.dot_background;
            this.dot.border_width = this.notch_width;
            this.dot.border_color = this.notch_color;
            this.dot.calc();
        }
        else if(this.notch_type === 'mark') {
            //this.mark = new SegmentScaleMark(this.id + '_notch', this.context, this.cx, this.cy, this.mark_r_in, this.mark_length, angle);

            let mark_component = Qt.createComponent("SegmentScaleMark.qml");
            this.mark = mark_component.createObject(this, {
                 id: this.id + '_notch', context: this.context, cx: this.cx, cy: this.cy,
                 r_in: this.mark_r_in, length: this.mark_length, angle: angle });

            this.mark.width = this.notch_width;
            this.mark.color = this.notch_color;
            this.mark.calc();
        }

        let knob = this;

        this.base_segment.segmentChanged.connect(segmentKnobChanged);
        if(this.dot) this.dot.segmentDotChanged.connect(segmentKnobChanged);
        if(this.mark) this.mark.segmentScaleMarkChanged.connect(segmentKnobChanged);

        /*
        addEventListener("segment-changed", function(e) {
            if(e.detail.segment === knob.base_segment) {
                dispatchEvent(new CustomEvent("segment-knob-changed", { detail : { knob : knob } } ));
            }
        });

        addEventListener("segment-dot-changed", function(e) {
            if(e.detail.dot === knob.dot) {
                dispatchEvent(new CustomEvent("segment-knob-changed", { detail : { knob : knob } } ));
            }
        });

        addEventListener("segment-scale-mark-changed", function(e) {
            if(e.detail.mark === knob.mark) {
                dispatchEvent(new CustomEvent("segment-knob-changed", { detail : { knob : knob } } ));
            }
        });
        */

        /*
        this.mousedown = function(e) { knob.catchKnob(e); };
        this.context.canvas.addEventListener('mousedown', knob.mousedown);

        this.mousemove = function(e) { knob.rotateKnobByMouseMovement(e); };
        this.context.canvas.addEventListener('mousemove', knob.mousemove);

        this.wheel = function(e) { knob.rotateKnobByMouseWheel(e); };
        this.context.canvas.addEventListener('wheel', knob.wheel);

        this.mouseup = function() { knob.releaseKnob(); };
        this.context.canvas.addEventListener('mouseup', knob.mouseup);

        this.mouseout = function() { knob.releaseKnob(); };
        this.context.canvas.addEventListener('mouseout', knob.mouseout);
        */
    }

    function calc() {
        let notch_angle;

        if(this.in_progress) {
            this.anim_start_a = this.anim_init_angle * Math.PI / 180;
            this.anim_end_a = (this.anim_init_angle + this.anim_angle) * Math.PI / 180;

            this.anim_dx1 = this.anim_r_in * Math.cos(this.anim_start_a) + this.cx;
            this.anim_dy1 = this.anim_r_in * Math.sin(this.anim_start_a) + this.cy;
            this.anim_dx2 = this.anim_r_out * Math.cos(this.anim_start_a) + this.cx;
            this.anim_dy2 = this.anim_r_out * Math.sin(this.anim_start_a) + this.cy;
            this.anim_dx3 = this.anim_r_out * Math.cos(this.anim_end_a) + this.cx;
            this.anim_dy3 = this.anim_r_out * Math.sin(this.anim_end_a) + this.cy;
            this.anim_dx4 = this.anim_r_in * Math.cos(this.anim_end_a) + this.cx;
            this.anim_dy4 = this.anim_r_in * Math.sin(this.anim_end_a) + this.cy;

            notch_angle = this.anim_notch_angle;
        }
        else {
            this.r_out = this.r_in + this.thickness;

            this.start_a = this.init_angle * Math.PI / 180;
            this.end_a = (this.init_angle + this.angle) * Math.PI / 180;

            this.dx1 = this.r_in * Math.cos(this.start_a) + this.cx;
            this.dy1 = this.r_in * Math.sin(this.start_a) + this.cy;
            this.dx2 = this.r_out * Math.cos(this.start_a) + this.cx;
            this.dy2 = this.r_out * Math.sin(this.start_a) + this.cy;
            this.dx3 = this.r_out * Math.cos(this.end_a) + this.cx;
            this.dy3 = this.r_out * Math.sin(this.end_a) + this.cy;
            this.dx4 = this.r_in * Math.cos(this.end_a) + this.cx;
            this.dy4 = this.r_in * Math.sin(this.end_a) + this.cy;

            notch_angle = this.notch_angle;
        }

        let notch_a = notch_angle * Math.PI / 180;
        if(this.notch_type === 'dot' && this.dot !== null) {
            let nx = this.dot_base_radius * Math.cos(notch_a) + this.cx;
            let ny = this.dot_base_radius * Math.sin(notch_a) + this.cy;
            this.dot.cx = nx;
            this.dot.cy = ny;
            this.dot.calc();
        }
        else if(this.notch_type === 'mark' && this.mark !== null) {
            this.mark.angle = notch_a;
            this.mark.calc();
        }

        //dispatchEvent(new CustomEvent("segment-knob-changed", { detail : { knob : this } } ));
        segmentKnobChanged();
    }

    function draw() {
        this.base_segment.draw();

        if(this.notch_type === 'dot' && this.dot !== null) {
            this.dot.draw();
        }
        else if(this.notch_type === 'mark' && this.mark !== null) {
            this.mark.draw();
        }
    }

    function setNotchAngle(angle) {
        this.notch_angle = angle;

        this.init_angle = angle - this.notch_init_angle;

        this.base_segment.init_angle = this.init_angle;
        this.base_segment.calc();

        this.anim_notch_angle = angle;
        this.anim_init_angle = angle - this.notch_init_angle;

        let a = angle * Math.PI / 180;

        if(this.notch_type === 'dot') {
            let nx = this.dot_base_radius * Math.cos(a) + this.cx;
            let ny = this.dot_base_radius * Math.sin(a) + this.cy;
            this.dot.cx = nx;
            this.dot.cy = ny;
            this.dot.calc();
        }
        else if(this.notch_type === 'mark') {
            this.mark.angle = angle;
            this.mark.calc();
        }

        this.calc();
    }

    function changeNotchAngle(anlge) {

    }

    function catchKnob(e) {
        let knob = this;

        if(knob.isPointInside(e.x, e.y)) {
            knob.is_active = true;

            knob.sx = e.x - knob.cx;
            knob.sy = e.y - knob.cy;
        }
    }

    function rotateKnobByMouseMovement(e) {
        if(this.is_active) {
            let x1 = this.sx;
            let y1 = this.sy;
            let x2 = e.x - this.cx;
            let y2 = e.y - this.cy;

            let a = Math.atan( (x1 * y2 - y1 * x2) / (x1 * x2 + y1 * y2) ) * 180 / Math.PI;

            let new_a = this.notch_angle + a;
            if(new_a < this.notch_min_angle) { this.setNotchAngle(this.notch_min_angle); }
            else if(new_a > this.notch_max_angle) { this.setNotchAngle(this.notch_max_angle); }
            else { this.setNotchAngle(new_a); }

            this.sx = x2;
            this.sy = y2;

            //dispatchEvent(new CustomEvent("segment-knob-changed", { detail : { knob : this } } ));
            segmentKnobChanged();
        }
    }

    function rotateKnobByMouseWheel(e) {
        if(this.is_active) {
            let new_a = this.notch_angle - e.angleDelta.y / 360;
            if(new_a < this.notch_min_angle) { this.setNotchAngle(this.notch_min_angle); }
            else if(new_a > this.notch_max_angle) { this.setNotchAngle(this.notch_max_angle); }
            else { this.setNotchAngle(new_a); }

            //dispatchEvent(new CustomEvent("segment-knob-changed", { detail : { knob : this } } ));
            segmentKnobChanged();
        }
    }

    function releaseKnob() {
        if(this.is_active) {
            this.init_angle = this.notch_angle - this.notch_init_angle;
            this.base_segment.init_angle = this.init_angle;
            this.base_segment.calc();
            this.calc();

            this.is_active = false;
        }
    }

    function isPointInside(x, y) {
        let init_angle = this.init_angle % 360;
        while(init_angle < 0) { init_angle += 360; }

        let px = x - this.cx;
        let py = this.cy - y;
        let r = Math.sqrt(Math.pow(px, 2) + Math.pow(py, 2));
        let a = - (Math.atan2(py, px) * 180 / Math.PI);
        while(a < 0) { a += 360; }

        let res = true;
        if(r < this.r_in || r > this.r_out) { res = false; }
        if((a < init_angle && (a + 360) > (init_angle + this.angle)) || a > (init_angle + this.angle)) { res = false; }

        //console.log("isPointInside: " + x + ' ' + y + ' ' + res);

        return res;
    }

    /*
    SegmentKnob.prototype.instanceCopy = function() {
        const copy = new this.constructor();
        const keys = Object.keys(this);
        keys.forEach(key => { copy[key] = this[key]; });
        return copy;
    };
    */
}
