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
    property double init_angle: -90 // segment initial angle
    property double angle: 360 //

    property Segment base_segment: null
    property SegmentGradient base_segment_gradient: null
    property string base_segment_background: "rgba(230, 230, 230, 1)"
    property double base_segment_border_width: 0
    property string base_segment_border_color: 'none'

    property Segment frame: null
    property SegmentGradient frame_gradient: null
    property string frame_background: "rgba(0, 0, 0, 0)"
    property double frame_border_width: 0
    property string frame_border_color: 'rgba(0, 0, 0, 0)'

    property SegmentScale scale: null
    property SegmentArrow arrow: null

    property double min_value: 0
    property double max_value: 200
    property double value: 0
    property double speed: 0.5 // value change animation speed

    property string font_family: 'Arial'
    property string font_size: '15px'
    property string font
    property string text_color: 'black'
    property double text_border_width: 0
    property string text_border_color: 'black'

    property string text
    property double text_offset_x: 0
    property double text_offset_y: 20

    property bool in_progress: false

    property double anim_value: this.value

    signal segmentGaugeChanged;
    signal segmentGaugeValueChanged;

    Utilities { id: utilities; }

    Component.onCompleted: {
        this.build();
        this.calc();
    }

    function calc() {
        if(this.in_progress) {

        }
        else {
            //this.progress_segment.angle = this.valueToAngle();
            //this.progress_segment.calc();
        }

        //dispatchEvent(new CustomEvent("segment-gauge-changed", { detail : { gauge : this } } ));
        segmentGaugeChanged();
    }

    function build() {
        //this.base_segment = new Segment(this.id + '-base-segment', this.context, this.cx, this.cy, this.r_in, this.thickness, this.init_angle, 360);

        let segment_component = Qt.createComponent("Segment.qml");
        this.base_segment = segment_component.createObject(this, {
             id: this.id + '_base_segment', context: this.context, cx: this.cx, cy: this.cy,
             r_in: this.r_in, thickness: this.thickness, init_angle: this.init_angle, angle: 360 });

        if(this.base_segment_gradient) { this.base_segment.gradient = this.base_segment_gradient.instanceCopy(); }
        this.base_segment.background = this.base_segment_background;
        this.base_segment.border_width = this.base_segment_border_width;
        this.base_segment.border_color = this.base_segment_border_color;
        this.base_segment.calc();

        //this.frame = new Segment(this.id + '-frame', this.context, this.cx, this.cy, this.thickness, this.thickness * 0.1, this.init_angle, 360);

        this.frame = segment_component.createObject(this, {
             id: this.id + '-frame', context: this.context, cx: this.cx, cy: this.cy,
             r_in: this.thickness, thickness: this.thickness * 0.1, init_angle: this.init_angle, angle: 360 });

        if(this.frame_gradient) { this.frame.gradient = this.frame_gradient.instanceCopy(); }
        this.frame.background = this.frame_background;
        this.frame.border_width = this.frame_border_width;
        this.frame.border_color = this.frame_border_color;
        this.frame.calc();

        //this.glass = new Segment(this.id + '-glass', this.context, this.cx, this.cy, this.thickness * 0.5, this.thickness, this.init_angle, 360);

        /*
        this.glass = segment_component.createObject(this, {
             id: this.id + '-glass', context: this.context, cx: this.cx, cy: this.cy,
             r_in: this.thickness * 0.5, thickness: this.thickness, init_angle: this.init_angle, angle: 360 });

        if(this.glass_gradient) { this.glass.gradient = this.glass_gradient.instanceCopy(); }
        this.glass.background = this.glass_background;
        this.glass.border_width = this.glass_border_width;
        this.glass.border_color = this.glass_border_color;
        this.glass.calc();
        */

        //this.scale = new SegmentScale(this.id + '-scale', this.context, this.cx, this.cy, this.r_in + this.thickness - 30, 25, this.init_angle, this.angle);

        let scale_component = Qt.createComponent("SegmentScale.qml");
        this.scale = scale_component.createObject(this, {
             id: this.id + '-scale', context: this.context, cx: this.cx, cy: this.cy,
             r_in: this.r_in + this.thickness - 30, thickness: 25, init_angle: this.init_angle, angle: this.angle });

        this.scale.background = 'white';
        this.scale.base_segment.border_width = 0;
        this.scale.base_segment.border_color = 'none';
        this.scale.base_segment.calc();
        this.scale.mark_position = 'outer';
        this.scale.levels = [
                { 'divisions_count' : 9, 'mark_length' : 12, 'mark_width' : 2, 'mark_color' : 'black' },
                { 'divisions_count' : 2, 'mark_length' : 7, 'mark_width' : 1, 'mark_color' : 'black' },
                { 'divisions_count' : 5, 'mark_length' : 5, 'mark_width' : 0.5, 'mark_color' : 'black' }
            ];
        this.scale.build();
        this.scale.calc();

        //this.arrow = new SegmentArrow(this.id + '-arrow', this.context, this.cx, this.cy, this.thickness * 0.1, this.thickness - 15, this.init_angle);

        let arrow_component = Qt.createComponent("SegmentArrow.qml");
        this.arrow = arrow_component.createObject(this, {
             id: this.id + '-arrow', context: this.context, cx: this.cx, cy: this.cy,
             r_in: this.thickness * 0.1, thickness: this.thickness - 15, init_angle: this.init_angle });

        this.arrow.angle = this.valueToAngle(this.value);
        this.arrow.calc();

        //let angle = this.valueToAngle();

        let gauge = this;

        this.base_segment.segmentChanged.connect(segmentGaugeChanged);
        this.frame.segmentChanged.connect(segmentGaugeChanged);
        //this.glass.segmentChanged.connect(segmentGaugeChanged);

        this.scale.segmentScaleChanged.connect(segmentGaugeChanged);
        this.arrow.segmentArrowChanged.connect(segmentGaugeChanged);

        /*
        addEventListener("segment-changed", function(e) {
            if(e.detail.segment === gauge.base_segment || e.detail.segment === gauge.frame || e.detail.segment === gauge.glass) {
                dispatchEvent(new CustomEvent("segment-gauge-changed", { detail : { gauge : gauge } } ));
            }
        });

        addEventListener("segment-scale-changed", function(e) {
            if(e.detail.scale === gauge.scale) {
                dispatchEvent(new CustomEvent("segment-gauge-changed", { detail : { gauge : gauge } } ));
            }
        });

        addEventListener("segment-arrow-changed", function(e) {
            if(e.detail.arrow === gauge.arrow) {
                dispatchEvent(new CustomEvent("segment-gauge-changed", { detail : { gauge : gauge } } ));
            }
        });
        */
    }

    function draw() {
        this.base_segment.draw();
        this.frame.draw();
        this.scale.draw();

        let font = this.font;
        if(this.font === undefined || this.font === null || this.font === '') {
            font = this.font_size + ' ' + this.font_family;
        }

        this.context.font = font;
        this.context.fillStyle = this.text_color;
        this.context.lineWidth = this.text_border_width;
        this.context.strokeStyle = this.text_border_color;

        this.context.textAlign = "center";
        this.context.textBaseline = 'middle';

        let text;

        //if(this.in_progress) { text = '' + this.anim_text; }
        //else { text = '' + this.text; }
        text = '' + this.text;

        let x = this.cx + this.text_offset_x;
        let y = this.cy + this.text_offset_y;

        this.context.fillText(text, x, y);
        this.context.strokeText(text, x, y);

        this.arrow.draw();
    }

    function valueToAngle(value = this.value) {
        while(this.angle < 0) { this.angle += 360; }
        if(this.angle > 360) { this.angle = 360; }

        let a = this.angle * (value - this.min_value) / (this.max_value - this.min_value);
        return a;
    }

    function setValue(new_value) {
        this.value = new_value;
        this.arrow.angle = this.init_angle + this.valueToAngle(new_value);

        this.arrow.calc();
        this.calc();
    }

    function changeValue(new_value, speed = this.speed, delay = 0) {
        let gauge = this;
        let arrow = gauge.arrow;

        if(speed <= 0) {
            this.value = new_value;
            this.calc();
            //dispatchEvent(new CustomEvent("segment-gauge-value-changed", { detail : { gauge : gauge } }));
            segmentGaugeValueChanged();
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
                arrow.visible = true;
                gauge.anim_value = (old_value + v).toFixed(0);
                arrow.angle = old_angle + a;
                arrow.angle %= 360;
                arrow.calc();
                arrow.context.canvas.requestAnimationFrame(changeValueAnim);
            }

            if(fraction > 1) {
                gauge.value = parseInt(new_value.toFixed(0));
                gauge.in_progress = false;
                gauge.calc();
                gauge.context.canvas.cancelRequestAnimationFrame(request);
                //dispatchEvent(new CustomEvent("segment-gauge-value-changed", { detail : { gauge : gauge } }));
                segmentGaugeValueChanged();
            }
            else {
            }
        };

        request = utilities.setTimeout(function() {
            start = Date.now();
            gauge.context.canvas.requestAnimationFrame(changeValueAnim);
        }, delay * 1000);
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

    function isPointInside(x, y) {
        if(this.angle >= 360) return true;

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

        return res;
    }

    /*
    SegmentGauge.prototype.instanceCopy = function() {
        const copy = new this.constructor();
        const keys = Object.keys(this);
        keys.forEach(key => { copy[key] = this[key]; });
        return copy;
    };
    */
}
