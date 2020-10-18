import QtQuick 2.0

SegmentDotsArrayProgressBar {
    /*
    property double min_value: 0
    property double max_value: 20
    property double value: 20
    */

    property string units: ' sec'

    property bool on_pause: false
    property string on_pause_text: 'on pause'
    property string on_pause_font: '20px Open Sans'

    signal segmentDotsArrayTimerChanged;
    signal segmentDotsArrayTimerValueChanged;
    signal segmentDotsArrayTimerIsUp;

    Utilities { id: utilities; }

    Component.onCompleted: {
        this.build();
        this.calc();
    }

    function build() {
        this.dots = [];

        //this.base_segment = new Segment(this.id + 'base_segment', this.context, this.cx, this.cy, this.r_in, this.thickness, this.init_angle, this.angle);

        let segment_component = Qt.createComponent("Segment.qml");
        this.base_segment = segment_component.createObject(this, {
             id: this.id + '_base_segment', context: this.context, cx: this.cx, cy: this.cy,
             r_in: this.r_in, thickness: this.thickness, init_angle: this.init_angle, angle: this.angle });

        this.base_segment.border_width = this.border_width;
        this.base_segment.border_color = this.border_color;

        if(this.gradient) { this.base_segment.gradient = this.gradient.instanceCopy(); }
        this.base_segment.background = this.background;

        this.base_segment.calc();

        if(this.angle === 360) { this.spaces_count = this.dots_count; }
        else {
            if(this.start_with === 'dot') { this.spaces_count = this.dots_count - 1; }
            else { this.spaces_count = this.dots_count + 1; }
        }

        if(this.proportional) {
            let a = this.angle / (this.dots_count + this.spaces_count);
            this.dot_angle = a;
            this.space_angle = a;
        }
        else {
            this.space_angle = (this.angle - this.dots_count * this.dot_angle) / this.spaces_count;
        }

        let first_angle = this.base_segment.init_angle;
        if(this.start_with === 'space') { first_angle += this.space_angle; }

        for(let i=0; i < this.dots_count; i++) {
            let dot_init_angle = first_angle + (this.dot_angle + this.space_angle) * i + this.dot_angle / 2;
            let dot_init_a = dot_init_angle * Math.PI / 180;
            let dot_center_x = this.base_radius * Math.cos(dot_init_a) + this.cx; // Координата X центра точки
            let dot_center_y = this.base_radius * Math.sin(dot_init_a) + this.cy; // Координата Y центра точки

            //let dot = new SegmentDot(this.id + '_d_' + (i+1), this.context, dot_center_x, dot_center_y, this.dot_radius);

            let dot_component = Qt.createComponent("SegmentDot.qml");
            let dot = dot_component.createObject(this, {
                 id: this.id + '_d_' + (i+1), context: this.context, cx: dot_center_x, cy: dot_center_y, r: this.dot_radius });

            if(this.dot_gradient) { dot.gradient = this.dot_gradient.instanceCopy(); }
            dot.background = this.dot_background;
            dot.border_width = this.dot_border_width;
            dot.border_color = this.dot_border_color;
            dot.visible = this.dots_visible;
            dot.calc();
            this.dots.push(dot);
        }

        this.active_index = this.valueToActiveIndex(this.value);

        let timer = this;

        this.base_segment.segmentChanged.connect(segmentDotsArrayTimerChanged);

        this.dots.forEach(function(dot) {
            dot.segmentDotChanged.connect(segmentDotsArrayTimerChanged);
        });

        /*
        addEventListener("segment-changed", function(e) {
            if(e.detail.segment === timer.base_segment) {
                dispatchEvent(new CustomEvent("segment-dots-array-progress-bar-changed", { detail : { timer : timer } } ));
            }
        });

        addEventListener("segment-dot-changed", function(e) {
            if(timer.dots.indexOf(e.detail.dot) >= 0) {
                dispatchEvent(new CustomEvent("segment-dots-array-progress-bar-changed", { detail : { timer : timer } } ));
            }
        });
        */
    }

    function calc() {
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
        }
        else {
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

        let timer = this;

        this.dots.forEach(function callback(value, index, array) {
            if(index < timer.active_index) {
                if(timer.active_dot_gradient) { value.gradient = timer.active_dot_gradient.instanceCopy(); }
                value.background = timer.active_dot_background;
                value.border_width = timer.active_dot_border_width;
                value.border_color = timer.active_dot_border_color;
            }
            else {
                if(timer.segment_gradient) { value.gradient = timer.dot_gradient.instanceCopy(); }
                value.background = timer.dot_background;
                value.border_width = timer.dot_border_width;
                value.border_color = timer.dot_border_color;
            }
        });

        //dispatchEvent(new CustomEvent("segment-dots-array-timer-changed", { detail : { timer : this } } ));
        segmentDotsArrayTimerChanged();
    }

    function draw() {
        this.base_segment.draw();

        this.dots.forEach(function(dot) {
            dot.draw();
        });

        let font = this.font;

        if(this.font === undefined || this.font === null || this.font === '') {
            font = this.font_size + ' ' + this.font_family;
        }

        this.context.font = font;
        this.context.fillStyle = this.text_color;

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

        if(this.text_border_color !== '' && this.text_border_color !== 'none') {
            this.context.lineWidth = this.text_border_width;
            this.context.strokeStyle = this.text_border_color;
            this.context.strokeText(text, this.cx, this.cy);
        }

        this.context.fillText(text, this.cx, this.cy);
    }

    function valueToActiveIndex(value = this.value) {
        let ind = this.dots_count * (value - this.min_value) / (this.max_value - this.min_value);
        ind = Math.floor(ind);
        return ind;
    }

    function countdown(new_value, value, delay = 0) {
        let timer = this;

        if(value <= 0) {
            this.value = new_value;
            this.calc();
            //dispatchEvent(new CustomEvent("segment-dots-array-timer-is-up", { detail : { timer : timer } }));
            segmentDotsArrayTimerIsUp();
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
                timer.dots_visible = true;
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
                //dispatchEvent(new CustomEvent("segment-dots-array-timer-is-up", { detail : { timer : timer } }));
                segmentDotsArrayTimerIsUp();
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
