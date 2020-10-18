import QtQuick 2.0

SegmentGauge {
    property bool on_pause: false;
    property string on_pause_text: 'on pause'
    property string on_pause_font: '20px Open Sans'

    signal segmentGaugeTimerChanged;
    signal segmentGaugeTimerValueChanged;
    signal segmentGaugeTimerIsUp;

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

        //dispatchEvent(new CustomEvent("segment-gauge-timer-changed", { detail : { timer : this } } ));
        segmentGaugeTimerChanged();
    }

    function build() {
        //this.base_segment = new Segment(this.id + '-base-segment', this.context, this.cx, this.cy, this.r_in, this.thickness, this.init_angle, 360);

        let segment_component = Qt.createComponent("Segment.qml");
        this.base_segment = segment_component.createObject(this, {
             id: this.id + '-base-segment', context: this.context, cx: this.cx, cy: this.cy,
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

        this.scale.build();

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

        let timer = this;

        this.base_segment.segmentChanged.connect(segmentGaugeTimerChanged);
        this.frame.segmentChanged.connect(segmentGaugeTimerChanged);
        //this.glass.segmentChanged.connect(segmentGaugeTimerChanged);

        this.scale.segmentScaleChanged.connect(segmentGaugeTimerChanged);
        this.arrow.segmentArrowChanged.connect(segmentGaugeTimerChanged);

        this.segmentGaugeChanged.connect(segmentGaugeTimerChanged);

        /*
        addEventListener("segment-changed", function(e) {
            if(e.detail.segment === timer.base_segment || e.detail.segment === timer.frame || e.detail.segment === timer.glass) {
                dispatchEvent(new CustomEvent("segment-gauge-timer-changed", { detail : { timer : timer } } ));
            }
        });

        addEventListener("segment-scale-changed", function(e) {
            if(e.detail.scale === timer.scale) {
                dispatchEvent(new CustomEvent("segment-gauge-timer-changed", { detail : { timer : timer } } ));
            }
        });

        addEventListener("segment-arrow-changed", function(e) {
            if(e.detail.arrow === timer.arrow) {
                dispatchEvent(new CustomEvent("segment-gauge-timer-changed", { detail : { timer : timer } } ));
            }
        });

        addEventListener("segment-gauge-changed", function(e) {
            if(e.detail.gauge === timer) {
                dispatchEvent(new CustomEvent("segment-guage-timer-changed", { detail : { timer : timer } } ));
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

    function countdown(new_value, value, delay = 0) {
        let timer = this;

        if(value <= 0) {
            this.setValue(new_value);
            this.calc();
            //dispatchEvent(new CustomEvent("segment-gauge-timer-value-changed", { detail : { timer : timer } }));
            segmentGaugeTimerValueChanged();
            return;
        }

        this.anim_value = this.value;
        let old_value = this.value;

        let old_angle = this.init_angle + this.valueToAngle(old_value);
        let new_angle = this.init_angle + this.valueToAngle(new_value);

        this.in_progress = true;
        this.calc();

        let start = null;
        let time = null;
        let fraction = 0;
        let request = null;

        function changeValueAnim() {
            if(timer.on_pause) {
                return;
            }

            time = Date.now();
            fraction = (time - start) / (value * 1000);

            let v = fraction * (new_value - old_value);
            let a = fraction * (new_angle - old_angle);

            if(fraction <= 1) {
                timer.arrow.visible = true;
                timer.anim_value = (parseFloat(old_value + v)).toFixed(0);
                timer.arrow.angle = old_angle + a;
                timer.arrow.calc();
                timer.calc();
                request = timer.context.canvas.requestAnimationFrame(changeValueAnim);
            }
            else {
                //timer.value = timer.setValue(parseInt(new_value).toFixed(0));
                timer.setValue(parseInt(new_value).toFixed(0));
                timer.in_progress = false;
                timer.calc();
                timer.context.canvas.cancelRequestAnimationFrame(request);
                //dispatchEvent(new CustomEvent("segment-gauge-timer-is-up", { detail : { timer : timer } }));
                segmentGaugeTimerIsUp();
            }
        }

        request = utilities.setTimeout(function() {
            start = Date.now();
            timer.context.canvas.requestAnimationFrame(changeValueAnim);
        }, delay * 1000);
    }

    function start() {
        this.in_progress = true;
        this.on_pause = false;

        this.countdown(this.min_value, this.value, 0);
    }

    function pause() {
        this.setValue(parseInt(this.anim_value));
        this.on_pause = true;

        this.calc();
    }

    function stop() {
        this.setValue(this.max_value);

        this.in_progress = false;
        this.on_pause = false;

        //this.build();
        this.calc();
    }
}
