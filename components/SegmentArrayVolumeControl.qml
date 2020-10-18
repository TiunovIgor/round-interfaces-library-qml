import QtQuick 2.0

Item {
    //this.id = id; // segment identificator as a text string
    property string name
    property var context // CanvasRenderingContext2D for drawing a segment
    property double cx // X coordinate of the segment center
    property double cy // Y coordinate of the segment center
    property double r_in // segment inner radius
    property double thickness // segment thickness
    property double r_out: r_in + thickness // segment outer radius
    property double init_angle // segment initial angle
    property double angle

    property double min_value: 0
    property double max_value: 100
    property double value: 0
    property double speed: 0.5 // value change animation speed

    property double sx
    property double sy

    property string min_text: 'min'
    property string min_font: '11pt Arial'
    property string min_color: 'black'
    property double min_border_width: 1
    property string min_border_color: 'rgba(0, 0, 0, 0)'
    property double min_init_x: 0
    property double min_init_y: 0
    property double min_offset_x: 0
    property double min_offset_y: 15

    property string max_text: 'max'
    property string max_font: '11pt Arial'
    property string max_color: 'black'
    property double max_border_width: 1
    property string max_border_color: 'rgba(0, 0, 0, 0)'
    property double max_init_x: 0
    property double max_init_y: 0
    property double max_offset_x: 0
    property double max_offset_y: 15

    property SegmentArray segment_array: null
    property var segment_array_gradient: null
    property string segment_array_background: "rgba(200, 200, 200, 1)"
    property double segment_array_border_width: 1
    property string segment_array_border_color: "rgba(100, 100, 100, 0.5)"

    property SegmentGradient segment_gradient: null
    property string segment_background: "rgba(200, 200, 200, 1)"
    property double segment_border_width: 1
    property string segment_border_color: "rgba(50, 50, 50, 0)"

    property SegmentGradient active_segment_gradient: null
    property string active_segment_background: "rgba(50, 50, 50, 1)"
    property double active_segment_border_width: 1
    property string active_segment_border_color: "rgba(50, 50, 50, 0)"

    property int active_index: 0;

    property SegmentKnob knob: null

    property bool in_progress: false

    property double anim_value: this.value;

    signal segmentArrayVolumeControlChanged;

    Utilities { id: utilities; }

    Component.onCompleted: {
        this.build();
        this.calc();
    }

    function calc() {
        if(this.in_progress) {

        }
        else {
            let control = this;
            let segments = control.segment_array.segments;
            //this.segment_array.angle = this.valueToAngle();
            //this.segment_array.thickness = this.valueToThickness();
            //this.segment_array.calc();

            segments.forEach(function callback(value, index, array) {
                if(index < control.active_index) {
                    if(control.active_segment_gradient) { value.gradient = control.active_segment_gradient.instanceCopy(); }
                    value.background = control.active_segment_background;
                    value.border_width = control.active_segment_border_width;
                    value.border_color = control.active_segment_border_color;
                    value.calc();
                }
                else {
                    if(control.segment_gradient) { value.gradient = control.segment_gradient.instanceCopy(); }
                    value.background = control.segment_background;
                    value.border_width = control.segment_border_width;
                    value.border_color = control.segment_border_color;
                    value.calc();
                }
            });
        }

        //dispatchEvent(new CustomEvent("segment-array-volume-control-changed", { detail : { volume_control : this } } ));
        segmentArrayVolumeControlChanged();
    }

    function calcLabels() {
        let start_a = this.init_angle * Math.PI / 180;
        let end_a = (this.init_angle + this.angle) * Math.PI / 180;

        this.min_init_x = (this.r_in + 15) * Math.cos(start_a) + this.cx;
        this.min_init_y = (this.r_in + 15) * Math.sin(start_a) + this.cy;

        this.max_init_x = (this.r_in + 15) * Math.cos(end_a) + this.cx;
        this.max_init_y = (this.r_in + 15) * Math.cos(end_a) + this.cy;
    }

    function build() {
        //this.segment_array = new SegmentArray(this.id + '-segment-array', this.context, this.cx, this.cy, this.r_in, this.thickness, this.init_angle, this.angle);

        let segment_array_component = Qt.createComponent("SegmentArray.qml");
        this.segment_array = segment_array_component.createObject(this, {
             id: this.id + '-segment-array', context: this.context, cx: this.cx, cy: this.cy,
             r_in: this.r_in, thickness: this.thickness, init_angle: this.init_angle, angle: this.angle });

        if(this.segment_array_gradient) { this.base_spiral.gradient = this.base_spiral_gradient.instanceCopy(); }
        this.segment_array.background = this.segment_array_background;
        this.segment_array.border_width = this.segment_array_border_width;
        this.segment_array.border_color = this.segment_array_border_color;
        this.segment_array.calc();

        this.calcLabels();

        //this.knob = new SegmentKnob(this.id + '-knob', this.context, this.cx, this.cy, 0, this.thickness * 0.6);
        let knob_component = Qt.createComponent("SegmentKnob.qml");
        this.knob = knob_component.createObject(this, {
             id: this.id + '-knob', context: this.context, cx: this.cx, cy: this.cy,
             r_in: 0, thickness: this.thickness * 0.6 });

        this.knob.calc();

        //this.removeKnobListeners();

        let control = this;

        //this.removeKnobListeners();

        /*
        this.mousedown = function(e) { control.catchKnob(e); };
        this.context.canvas.addEventListener('mousedown', control.mousedown);

        this.mousemove = function(e) { control.rotateKnobByMouseMovement(e); };
        this.context.canvas.addEventListener('mousemove', control.mousemove);

        this.wheel = function(e) { control.rotateKnobByMouseWheel(e); };
        this.context.canvas.addEventListener('wheel', control.wheel);

        this.mouseup = function() { control.releaseKnob(); };
        this.context.canvas.addEventListener('mouseup', control.mouseup);

        this.mouseout = function() { control.releaseKnob(); };
        this.context.canvas.addEventListener('mouseout', control.mouseout);
        */
    }

    function draw() {
        this.segment_array.draw();
        this.knob.draw();

        this.context.textAlign = "center";
        this.context.textBaseline = 'middle';

        // Draw Min Label
        this.context.font = this.min_font;;
        this.context.fillStyle = this.min_color;
        this.context.lineWidth = this.min_border_width;
        this.context.strokeStyle = this.min_border_color;

        this.context.fillText(this.min_text, this.min_init_x + this.min_offset_x, this.min_init_y + this.min_offset_y);
        this.context.strokeText(this.min_text, this.min_init_x + this.min_offset_x, this.min_init_y + this.min_offset_y);

        // Draw Max Label;
        this.context.font = this.max_font;;
        this.context.fillStyle = this.max_color;
        this.context.lineWidth = this.max_border_width;
        this.context.strokeStyle = this.max_border_color;

        this.context.fillText(this.max_text, this.max_init_x + this.max_offset_x, this.max_init_y + this.max_offset_y);
        this.context.strokeText(this.max_text, this.max_init_x + this.max_offset_x, this.max_init_y + this.max_offset_y);
    }

    function catchKnob(e) {
        let control = this;
        let knob = this.knob;

        if(knob.isPointInside(e.x, e.y)) {
            knob.is_active = true;

            control.sx = e.x - control.cx;
            control.sy = e.y - control.cy;
        }
    }

    function rotateKnobByMouseMovement(e) {
        let control = this;
        let knob = this.knob;

        if(knob.is_active) {
            let x1 = this.sx;
            let y1 = this.sy;
            let x2 = e.x - this.cx;
            let y2 = e.y - this.cy;

            let a = Math.atan( (x1 * y2 - y1 * x2) / (x1 * x2 + y1 * y2) ) * 180 / Math.PI;
            let value;

            let new_a = knob.notch_angle + a;
            if(new_a < knob.notch_min_angle) {
                knob.setNotchAngle(knob.notch_min_angle);
                value = control.angleToValue(knob.notch_min_angle);

            }
            else if(new_a > knob.notch_max_angle) {
                knob.setNotchAngle(knob.notch_max_angle);
                value = control.angleToValue(knob.notch_max_angle);
            }
            else {
                knob.setNotchAngle(new_a);
                value = control.angleToValue(new_a);
            }

            control.active_index = control.valueToActiveIndex(value);
            control.calc();

            this.sx = x2;
            this.sy = y2;

            //dispatchEvent(new CustomEvent("segment-array-volume-control-changed", { detail : { volume_control : control } } ));
            segmentArrayVolumeControlChanged();
        }
    }

    function rotateKnobByMouseWheel(e) {
        if(this.knob.is_active) {
            let new_a = this.notch_angle - e.angleDelta.y / 360;
            if(new_a < this.notch_min_angle) { this.setNotchAngle(this.notch_min_angle); }
            else if(new_a > this.notch_max_angle) { this.setNotchAngle(this.notch_max_angle); }
            else { this.setNotchAngle(new_a); }

            //dispatchEvent(new CustomEvent("segment-array-volume-control-changed", { detail : { volume_control : this } } ));
            segmentArrayVolumeControlChanged();
        }
    }

    function releaseKnob() {
        let knob = this.knob;

        if(knob.is_active) {
            knob.is_active = false;
        }
    }

    function angleToValue(angle) {
        let k = this.knob;
        let f = (k.notch_angle - k.notch_min_angle) / (k.notch_max_angle - k.notch_min_angle);
        let v = f * (this.max_value - this.min_value) + this.min_value;
        return v;
    }

    function valueToActiveIndex(value = this.value) {
        let array = this.segment_array;

        let ind = array.segments_count * (value - this.min_value) / (this.max_value - this.min_value);
        ind = Math.floor(ind);
        return ind;
    }

    function setValue(new_value) {
        let control = this;

        control.active_spiral.angle = control.valueToAngle(new_value);
        control.active_spiral.thickness = control.valueToThickness(new_value);
        control.active_spiral.calc();

        this.calc();
    }

    function changeValue(new_value, speed = this.speed, delay = 0) {
        let progress_bar = this;

        if(speed <= 0) {
            this.value = new_value;
            this.calc();
            //dispatchEvent(new CustomEvent("segment-progress-bar-value-changed", { detail : { progress_bar : progress_bar } }));
            segmentArrayVolumeControlChanged();
            return;
        }

        this.anim_value = this.value;
        let old_value = this.value;

        let old_angle = this.valueToAngle(old_value);
        let new_angle = this.valueToAngle(new_value);

        this.in_progress = true;
        this.calc();

        let start = null;
        let time = null;
        let fraction = 0;
        let request = null;

        function changeValueAnim() {
            time = Date.now();
            fraction = (time - start) / (speed * 1000);

            let v = fraction * (new_value - old_value);
            let a = fraction * (new_angle - old_angle);

            if(fraction <= 1) {
                progress_bar.anim_value = (old_value + v).toFixed(0);
                progress_bar.progress_segment.angle = old_angle + a;
                progress_bar.progress_segment.angle %= 360;
                progress_bar.progress_segment.calc();
            }

            if(fraction > 1) {
                progress_bar.value = parseInt(new_value.toFixed(0));
                progress_bar.in_progress = false;
                progress_bar.calc();
                progress_bar.context.canvas.cancelRequestAnimationFrame(request);
                //dispatchEvent(new CustomEvent("segment-progress-bar-value-changed", { detail : { progress_bar : progress_bar } }));
                segmentArrayVolumeControlChanged();
            }
            else {
                progress_bar.progress_segment.visible = true;
                request = progress_bar.context.canvas.requestAnimationFrame(changeValueAnim);
            }
        };

        request = utilities.setTimeout(function() {
            start = Date.now();
            progress_bar.context.canvas.requestAnimationFrame(changeValueAnim);
        }, delay * 1000);
    }

    function removeKnobListeners() {
        let control = this;
        let knob = this.knob;

        /*
        knob.context.canvas.removeEventListener('mousedown', knob.mousedown);
        knob.context.canvas.removeEventListener('mousemove', knob.mousemove);
        knob.context.canvas.removeEventListener('mousewheel', knob.mousewheel);
        knob.context.canvas.removeEventListener('mouseup', knob.mouseup);
        knob.context.canvas.removeEventListener('mouseout', knob.mouseout);
        */
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
    }

    /*
    SegmentArrayVolumeControl.prototype.instanceCopy = function() {
        const copy = new this.constructor();
        const keys = Object.keys(this);
        keys.forEach(key => { copy[key] = this[key]; });
        return copy;
    };
    */
}
