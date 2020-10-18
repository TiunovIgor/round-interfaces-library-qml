import QtQuick 2.0

SegmentArrayProgressBar {
    /*
    property double min_value: 0
    property double max_value: 20
    property double value: 20
    */

    property string units: ' sec'

    property bool on_pause: false
    property string on_pause_text: 'on pause'
    property string on_pause_font: '20px Open Sans'

    signal segmentArrayTimerChanged;
    signal segmentArrayTimerValueChanged;
    signal segmentArrayTimerIsUp;

    Utilities { id: utilities; }

    Component.onCompleted: {
        this.build();
        this.calc();
    }

    function build() {
        this.segments = [];

        //this.base_segment = new Segment(this.id + '_base_segment', this.context, this.cx, this.cy, this.r_in, this.thickness, this.init_angle, this.angle);

        let segment_component = Qt.createComponent("Segment.qml");
        this.base_segment = segment_component.createObject(this, {
             id: this.id + '-base-segment', context: this.context, cx: this.cx, cy: this.cy,
             r_in: this.r_in, thickness: this.thickness, init_angle: this.init_angle, angle: this.angle });

        this.base_segment.border_width = this.border_width;
        this.base_segment.border_color = this.border_color;

        if(this.gradient) { this.base_segment.gradient = this.gradient.instanceCopy(); }
        this.base_segment.background = this.background;

        if(this.full_thickness) {
            this.segment_r_in = this.r_in;
            this.segment_thickness = this.thickness;
        }
        else {
            if(this.segment_position === 'inner') { this.segment_r_in = this.r_in; }
            else if(this.segment_position === 'middle') { this.segment_r_in = this.r_in + (this.thickness - this.segment_thickness) / 2; }
            else if(this.segment_position === 'outer') { this.segment_r_in = this.r_out - this.segment_thickness; }
        }

        this.base_segment.calc();

        if(this.angle === 360) { this.spaces_count = this.segments_count; }
        else {
            if(this.start_with === 'segment') { this.spaces_count = this.segments_count - 1; }
            else { this.spaces_count = this.segments_count + 1; }
        }

        if(this.proportional) {
            let a = this.angle / (this.segments_count + this.spaces_count);
            this.segment_angle = a;
            this.space_angle = a;
        }
        else {
            this.space_angle = (this.angle - this.segments_count * this.segment_angle) / this.spaces_count;
        }

        let first_angle = this.base_segment.init_angle;
        if(this.start_with === 'space') { first_angle += this.space_angle; }

        for(let i=0; i < this.segments_count; i++) {
            //let segment = new Segment(this.id + '_s_' + (i+1), this.context, this.cx, this.cy, this.segment_r_in, this.segment_thickness,
            //    first_angle + (this.segment_angle + this.space_angle) * i, this.segment_angle);

            let segment = segment_component.createObject(this, {
                 id: this.id + '_s_' + (i+1), context: this.context, cx: this.cx, cy: this.cy, r_in: segment_r_in, thickness: this.segment_thickness,
                 init_angle: first_angle + (this.segment_angle + this.space_angle) * i, angle: this.segment_angle });

            if(this.segment_gradient) { segment.gradient = this.segment_gradient.instanceCopy(); }
            segment.background = this.segment_background;
            segment.border_width = this.segment_border_width;
            segment.border_color = this.segment_border_color;
            segment.visible = this.segments_visible;
            segment.calc();
            this.segments.push(segment);
        }

        this.active_index = this.valueToActiveIndex(this.value);

        let timer = this;

        this.base_segment.segmentChanged.connect(segmentArrayTimerChanged);

        this.segments.forEach(function(segment) {
            segment.segmentChanged.connect(segmentArrayTimerChanged);
        });

        /*
        addEventListener("segment-changed", function(e) {
            if(e.detail.segment === timer.base_segment) {
                dispatchEvent(new CustomEvent("segment-array-timer-changed", { detail : { timer : timer } } ));
            }

            if(timer.segments.indexOf(e.detail.segment) >= 0) {
                dispatchEvent(new CustomEvent("segment-array-timer-changed", { detail : { timer : timer } } ));
            }
        });
        */
    }

    function calc() {
        if(this.in_progress) {
            this.anim_r_out = this.anim_r_in + this.anim_thickness;

            this.anim_start_a = this.anim_init_angle * Math.PI / 180;
            this.anim_end_a = (this.anim_init_angle + this.anim_angle) * Math.PI / 180;

            this.anim_dx1 = this.anim_r_in * Math.cos(this.anim_start_a) + this.cx; // First point. X coordinate
            this.anim_dy1 = this.anim_r_in * Math.sin(this.anim_start_a) + this.cy; // First point. Y coordinate
            this.anim_dx2 = this.anim_r_out * Math.cos(this.anim_start_a) + this.cx; // Second point. X coordinate
            this.anim_dy2 = this.anim_r_out * Math.sin(this.anim_start_a) + this.cy; // Second point. Y coordinate
            this.anim_dx3 = this.anim_r_out * Math.cos(this.anim_end_a) + this.cx; // Third point. X coordinate
            this.anim_dy3 = this.anim_r_out * Math.sin(this.anim_end_a) + this.cy; // Third point. Y coordinate
            this.anim_dx4 = this.anim_r_in * Math.cos(this.anim_end_a) + this.cx; // Fourth point. X coordinate
            this.anim_dy4 = this.anim_r_in * Math.sin(this.anim_end_a) + this.cy; // Fourth point. Y coordinate
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
        }

        let progress_bar = this;

        this.segments.forEach(function callback(value, index, array) {
            if(index < progress_bar.active_index) {
                if(progress_bar.active_segment_gradient) { value.gradient = progress_bar.active_segment_gradient.instanceCopy(); }
                value.background = progress_bar.active_segment_background;
                value.border_width = progress_bar.active_segment_border_width;
                value.border_color = progress_bar.active_segment_border_color;
            }
            else {
                if(progress_bar.segment_gradient) { value.gradient = progress_bar.segment_gradient.instanceCopy(); }
                value.background = progress_bar.segment_background;
                value.border_width = progress_bar.segment_border_width;
                value.border_color = progress_bar.segment_border_color;
            }
        });

        //dispatchEvent(new CustomEvent("segment-array-timer-changed", { detail : { timer : this } } ));
        segmentArrayTimerChanged();
    }

    function draw() {
        this.base_segment.draw();

        this.segments.forEach(function(segment) {
            segment.draw();
        });

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
            //dispatchEvent(new CustomEvent("segment-array-timer-is-up", { detail : { timer : timer } }));
            segmentArrayTimerIsUp();
            return;
        }

        this.anim_value = this.value;
        let old_value = this.value;

        let old_index = this.valueToActiveIndex(old_value);
        let new_index = this.valueToActiveIndex(new_value);

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
            let ind = fraction * (new_index - old_index);

            if(fraction <= 1) {
                timer.segments_visible = true;
                timer.anim_value = parseInt((old_value + v).toFixed());
                timer.active_index = parseInt((old_index + ind).toFixed());
                timer.calc();
                request = timer.context.canvas.requestAnimationFrame(changeValueAnim);
            }
            else {
                timer.value = parseInt(new_value.toFixed(0));
                timer.in_progress = false;
                timer.calc();
                timer.context.canvas.cancelRequestAnimationFrame(request);
                //dispatchEvent(new CustomEvent("segment-array-timer-is-up", { detail : { timer : timer } }));
                segmentArrayTimerIsUp();
            }
        };

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

        this.build();
        this.calc();
    }
}
