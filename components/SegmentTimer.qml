import QtQuick 2.0

SegmentProgressBar {
    /*
    property double min_value: 0
    property double max_value: 30
    property double value: 30
    */

    property string units: ' sec'

    property bool on_pause: false
    property string on_pause_text: 'on pause'
    property string on_pause_font: '20px Open Sans'

    signal segmentTimerChanged;
    signal segmentTimerValueChanged;
    signal segmentTimerIsUp;

    Utilities { id: utilities; }

    Component.onCompleted: {
        this.build();
        this.calc();
    }

    function calc() {
        if(this.in_progress) {

        }
        else {
            this.active_segment.angle = this.valueToAngle();
            this.active_segment.calc();
        }

        //dispatchEvent(new CustomEvent("segment-timer-changed", { detail : { timer : this } } ));
        segmentTimerChanged();
    }

    function build() {
        //this.base_segment = new Segment(this.id + '-base-segment', this.context, this.cx, this.cy, this.r_in, this.thickness, this.init_angle, this.angle);

        let segment_component = Qt.createComponent("Segment.qml");
        this.base_segment = segment_component.createObject(this, {
             id: this.id + '-base-segment', context: this.context, cx: this.cx, cy: this.cy,
             r_in: this.r_in, thickness: this.thickness, init_angle: this.init_angle, angle: this.angle });

        if(this.base_segment_gradient) { this.base_segment.gradient = this.base_segment_gradient.instanceCopy(); }
        this.base_segment.background = this.base_segment_background;
        this.base_segment.border_width = this.base_segment_border_width;
        this.base_segment.border_color = this.base_segment_border_color;
        this.base_segment.calc();

        if(this.full_thickness) {
            this.active_segment_thickness = this.thickness;
        }

        let active_segment_r_in = this.r_in + (this.thickness - this.active_segment_thickness) / 2;
        let angle = this.valueToAngle();

        //this.active_segment = new Segment(this.id + '-progress-segment', this.context, this.cx, this.cy, active_segment_r_in, this.active_segment_thickness, this.init_angle, this.angle);

        this.active_segment = segment_component.createObject(this, {
             id: this.id + '-progress-segment', context: this.context, cx: this.cx, cy: this.cy,
             r_in: active_segment_r_in, thickness: this.active_segment_thickness, init_angle: this.init_angle, angle: this.angle });

        if(this.active_segment_gradient) { this.active_segment.gradient = this.active_segment_gradient.instanceCopy(); }
        this.active_segment.background = this.active_segment_background;
        this.active_segment.border_width = this.active_segment_border_width;
        this.active_segment.border_color = this.active_segment_border_color;
        this.active_segment.calc();

        let timer = this;


        this.base_segment.segmentChanged.connect(segmentTimerChanged);
        this.active_segment.segmentChanged.connect(segmentTimerChanged);

        /*
        addEventListener("segment-changed", function(e) {
            if(e.detail.segment === timer.base_segment) {
                dispatchEvent(new CustomEvent("segment-timer-changed", { detail : { timer : timer } } ));
            }

            if(e.detail.segment === timer.active_segment) {
                dispatchEvent(new CustomEvent("segment-timer-changed", { detail : { timer : timer } } ));
            }
        });
        */
    }

    function draw() {
        this.base_segment.draw();
        this.active_segment.draw();

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

        if(this.in_progress) {
            if(this.on_pause) {
                this.context.font = this.on_pause_font;
                text = this.on_pause_text;
            }
            else { text = '' + this.anim_value + this.units; }
        }
        else { text = '' + this.value + this.units; }

        this.context.fillText(text, this.cx, this.cy);
        this.context.strokeText(text, this.cx, this.cy);
    }

    function countdown(new_value, value, delay = 0) {
        let timer = this;

        if(value <= 0) {
            this.value = new_value;
            this.calc();
            //dispatchEvent(new CustomEvent("segment-timer-value-changed", { detail : { timer : timer } }));
            segmentTimerValueChanged();
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
            if(timer.on_pause) {
                return;
            }

            time = Date.now();
            fraction = (time - start) / (value * 1000);

            let v = fraction * (new_value - old_value);
            let a = fraction * (new_angle - old_angle);

            if(fraction <= 1) {
                timer.active_segment.visible = true;
                timer.anim_value = (parseFloat(old_value + v)).toFixed(0);
                timer.active_segment.angle = old_angle + a;
                timer.active_segment.calc();
                request = timer.context.canvas.requestAnimationFrame(changeValueAnim);
            }
            else {
                timer.value = parseInt(new_value).toFixed(0);
                timer.in_progress = false;
                timer.calc();
                timer.context.canvas.cancelRequestAnimationFrame(request);
                //dispatchEvent(new CustomEvent("segment-timer-is-up", { detail : { timer : timer } }));
                segmentTimerIsUp();
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
        this.value = parseInt(this.anim_value);
        this.on_pause = true;

        this.calc();
    }

    function stop() {
        this.value = this.max_value;
        this.in_progress = false;
        this.on_pause = false;

        this.calc();
    }
}
