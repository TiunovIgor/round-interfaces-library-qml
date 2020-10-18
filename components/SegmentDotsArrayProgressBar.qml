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

    property double min_value: 0
    property double max_value: 100
    property double value: 0
    property double speed: 0.5 // value change animation speed

    property string font_family: 'Open Sans'
    property string font_size: '30px'
    property string font
    property string text_color: 'black'
    property double text_border_width: 1
    property string text_border_color: 'rgba(0,0,0,0)'
    property string units: '%'

    property Segment base_segment: null

    property SegmentGradient gradient: null
    property string background: "rgba(240, 240, 240, 1)"
    property double border_width: 1
    property string border_color: "rgba(100, 100, 100, 1)"

    property bool proportional: false
    property string start_with: 'dot'

    property var dots: []
    property int dots_count: 24
    property double dot_angle: 7
    property double dot_radius: 4
    property double base_radius: (this.r_in + this.r_out) / 2

    property SegmentGradient dot_gradient: null
    property string dot_background: 'rgba(200, 200, 200, 1)'
    property double dot_border_width: 1
    property string dot_border_color: 'rgba(50, 50, 50, 1)'

    property SegmentGradient active_dot_gradient: null
    property string active_dot_background: 'rgba(100, 100, 100, 1)'
    property double active_dot_border_width: 1
    property string active_dot_border_color: 'rgba(10, 10, 10, 1)'

    property int spaces_count: 100
    property double space_angle: 3

    property int active_index

    property bool dots_visible: true
    property bool in_progress: false

    property double anim_value: this.value

    property var appeared_dots: []
    property var disappeared_dots: []
    property var faded_in_dots: []
    property var faded_out_dots: []

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

    signal segmentDotsArrayProgressBarChanged;
    signal segmentDotsArrayProgressBarValueChanged;

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

        let progress_bar = this;

        this.base_segment.segmentChanged.connect(segmentDotsArrayProgressBarChanged);

        this.dots.forEach(function(dot) {
            dot.segmentDotChanged.connect(segmentDotsArrayProgressBarChanged);
            dot.segmentDotAppeared.connect(function() {
                checkAppearedDots(dot);
            });
            dot.segmentDotDisappeared.connect(function() {
                checkDisappearedDots(dot);
            });
            dot.segmentDotFadedIn.connect(function() {
                checkFadedInDots(dot);
            });
            dot.segmentDotFadedOut.connect(function() {
                checkFadedOutDots(dot);
            });
        });

        /*
        addEventListener("segment-changed", function(e) {
            if(e.detail.segment === progress_bar.base_segment) {
                dispatchEvent(new CustomEvent("segment-dots-array-progress-bar-changed", { detail : { progress_bar : progress_bar } } ));
            }
        });

        addEventListener("segment-dot-changed", function(e) {
            if(progress_bar.dots.indexOf(e.detail.dot) >= 0) {
                dispatchEvent(new CustomEvent("segment-dots-array-progress-bar-changed", { detail : { progress_bar : progress_bar } } ));
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

        let progress_bar = this;

        this.dots.forEach(function callback(value, index, array) {
            if(index < progress_bar.active_index) {
                if(progress_bar.active_dot_gradient) { value.gradient = progress_bar.active_dot_gradient.instanceCopy(); }
                value.background = progress_bar.active_dot_background;
                value.border_width = progress_bar.active_dot_border_width;
                value.border_color = progress_bar.active_dot_border_color;
            }
            else {
                if(progress_bar.segment_gradient) { value.gradient = progress_bar.dot_gradient.instanceCopy(); }
                value.background = progress_bar.dot_background;
                value.border_width = progress_bar.dot_border_width;
                value.border_color = progress_bar.dot_border_color;
            }
        });

        //dispatchEvent(new CustomEvent("segment-dots-array-progress-bar-changed", { detail : { progress_bar : this } } ));
        segmentDotsArrayProgressBarChanged();
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

        if(this.in_progress) { text = '' + this.anim_value + this.units; }
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

    function changeValue(new_value, speed = this.speed, delay = 0) {
        let progress_bar = this;

        if(speed <= 0) {
            this.value = new_value;
            this.calc();
            //dispatchEvent(new CustomEvent("segment-dots-array-progress-bar-value-changed", { detail : { progress_bar : progress_bar } }));
            segmentDotsArrayProgressBarValueChanged();
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
            time = Date.now();
            fraction = (time - start) / (speed * 1000);

            let v = fraction * (new_value - old_value);
            let ind = fraction * (new_index - old_index);

            if(fraction <= 1) {
                progress_bar.anim_value = parseInt((old_value + v).toFixed());
                progress_bar.active_index = parseInt((old_index + ind).toFixed());
                progress_bar.calc();
            }

            if(fraction > 1) {
                progress_bar.value = parseInt(new_value.toFixed(0));
                progress_bar.in_progress = false;
                progress_bar.calc();
                progress_bar.context.canvas.cancelRequestAnimationFrame(request);
                //dispatchEvent(new CustomEvent("segment-dots-array-progress-bar-value-changed", { detail : { progress_bar : progress_bar } }));
                segmentDotsArrayProgressBarValueChanged();
            }
            else {
                progress_bar.dots_visible = true;
                request = progress_bar.context.canvas.requestAnimationFrame(changeValueAnim);
            }
        };

        request = utilities.setTimeout(function() {
            start = Date.now();
            progress_bar.context.canvas.requestAnimationFrame(changeValueAnim);
        }, delay * 1000);
    }

    function appear(order, lag, direction, duration, delay) {
        this.in_progress = true;

        this.appeared_dots = [];

        let check_func = this.checkAppearedDots.bind(this);

        let dots_arr = this;
        let dots = this.dots;

        let dot_duration = duration;
        let lag_array = [];

        for(let i=0; i < dots.length; i++) {
            if(order === 'together') {
                lag_array[i] = 0;
            }
            else if(order === 'one-by-one-clockwise') {
                dot_duration = (duration - lag * (dots.length - 1)) / dots.length;
                lag_array[i] = i * (dot_duration + lag);
            }
            else if(order === 'one-by-one-anticlockwise') {
                dot_duration = (duration -lag * (dots.length - 1)) / dots.length;
                lag_array[i] = (dots.length - 1 - i) * (dot_duration + lag);
            }
        }

        utilities.setTimeout(function() {
            dots.forEach(function callback(value, index, array) {
                value.appear(direction, dot_duration, lag_array[index]);

                /*
                addEventListener("segment-dot-appeared", function(e) {
                    if(dots.indexOf(e.detail.dot) >= 0) {
                        check_func(e.detail.dot);
                    }
                });
                */
            });
        }, delay * 1000);
    }

    function checkAppearedDots(dot) {
        if(this.dots.indexOf(dot) < 0) {
            return;
        }
        else {
            if(this.appeared_dots.indexOf(dot) < 0) {
                this.appeared_dots.push(dot);
            }

            let appeared = true;
            let array = this;

            this.dots.forEach(function(d) {
                if(array.appeared_dots.indexOf(d) < 0) {
                    appeared = false;
                }
            });

            if(appeared) {
                this.dots_visible = true;
                this.appeared_dots = [];
                this.in_progress = false;
                //dispatchEvent(new CustomEvent("segment-dots-array-appeared", { detail : { progress_bar : this } }));
                segmentDotsArrayProgressBarChanged();
            }
        }
    }

    function disappear(order, lag, direction, duration, delay) {
        this.in_progress = true;

        this.disappeared_dots = [];

        let check_func = this.checkDisappearedDots.bind(this);

        let seg_arr = this;
        let dots = this.dots;

        let dot_duration = duration;
        let lag_array = [];

        for(let i=0; i < dots.length; i++) {
            if(order === 'together') {
                lag_array[i] = 0;
            }
            else if(order === 'one-by-one-clockwise') {
                dot_duration = (duration - lag * (dots.length - 1)) / dots.length;
                lag_array[i] = i * (dot_duration + lag);
            }
            else if(order === 'one-by-one-anticlockwise') {
                dot_duration = (duration -lag * (dots.length - 1)) / dots.length;
                lag_array[i] = (dots.length - 1 - i) * (dot_duration + lag);
            }
        }

        utilities.setTimeout(function() {
            dots.forEach(function callback(value, index, array) {
                value.disappear(direction, dot_duration, lag_array[index]);

                /*
                addEventListener("segment-dot-disappeared", function(e) {
                    if(dots.indexOf(e.detail.dot) >= 0) {
                        check_func(e.detail.dot);
                    }
                });
                */
            });
        }, delay * 1000);
    }

    function checkDisappearedDots(dot) {
        if(this.dots.indexOf(dot) < 0) {
            return;
        }
        else {
            if(this.disappeared_dots.indexOf(dot) < 0) {
                this.disappeared_dots.push(dot);
            }

            let disappeared = true;
            let array = this;

            this.dots.forEach(function(d) {
                if(array.disappeared_dots.indexOf(d) < 0) {
                    disappeared = false;
                }
            });

            if(disappeared) {
                this.dots_visible = false;
                this.disappeared_dots.length = 0;
                this.in_progress = false;
                //dispatchEvent(new CustomEvent("segment-dots-array-disappeared", { detail : { progress_bar : this } }));
                segmentDotsArrayProgressBarChanged();
            }
        };
    }

    function fadeIn(order, lag, duration, delay) {
        this.in_progress = true;

        this.faded_in_dots = [];

        let check_func = this.checkFadedInDots.bind(this);

        let dot_arr = this;
        let dots = this.dots;

        let dot_duration = duration;
        let lag_array = [];

        for(let i=0; i < dots.length; i++) {
            if(order === 'together') {
                lag_array[i] = 0;
            }
            else if(order === 'one-by-one-clockwise') {
                dot_duration = (duration - lag * (dots.length - 1)) / dots.length;
                lag_array[i] = i * (dot_duration + lag);
            }
            else if(order === 'one-by-one-anticlockwise') {
                dot_duration = (duration -lag * (dots.length - 1)) / dots.length;
                lag_array[i] = (dots.length - 1 - i) * (dot_duration + lag);
            }
        }

        utilities.setTimeout(function() {
            dots.forEach(function callback(value, index, array) {
                value.fadeIn(dot_duration, lag_array[index]);

                /*
                addEventListener("segment-dot-faded-in", function(e) {
                    if(dots.indexOf(e.detail.dot) >= 0) {
                        check_func(e.detail.dot);
                    }
                });
                */
            });
        }, delay * 1000);
    }

    function checkFadedInDots(dot) {
        if(this.dots.indexOf(dot) < 0) {
            return;
        }
        else {
            if(this.faded_in_dots.indexOf(dot) < 0) {
                this.faded_in_dots.push(dot);
            }

            let faded_in = true;
            let array = this;

            this.dots.forEach(function(d) {
                if(array.faded_in_dots.indexOf(d) < 0) {
                    faded_in = false;
                }
            });

            if(faded_in) {
                this.dots_visible = true;
                this.faded_in_dots = [];
                this.in_progress = false;
                //dispatchEvent(new CustomEvent("segment-dots-array-faded-in", { detail : { progress_bar : this } }));
                segmentDotsArrayProgressBarChanged();
            }
        }
    }

    function fadeOut(order, lag, duration, delay) {
        this.in_progress = true;

        this.faded_out_dots = [];

        let check_func = this.checkFadedOutDots.bind(this);

        let dot_arr = this;
        let dots = this.dots;

        let dot_duration = duration;
        let lag_array = [];

        for(let i=0; i < dots.length; i++) {
            if(order === 'together') {
                lag_array[i] = 0;
            }
            else if(order === 'one-by-one-clockwise') {
                dot_duration = (duration - lag * (dots.length - 1)) / dots.length;
                lag_array[i] = i * (dot_duration + lag);
            }
            else if(order === 'one-by-one-anticlockwise') {
                dot_duration = (duration -lag * (dots.length - 1)) / dots.length;
                lag_array[i] = (dots.length - 1 - i) * (dot_duration + lag);
            }
        }

        utilities.setTimeout(function() {
            dots.forEach(function callback(value, index, array) {
                value.fadeOut(dot_duration, lag_array[index]);

                /*
                addEventListener("segment-dot-faded-out", function(e) {
                    if(dots.indexOf(e.detail.dot) >= 0) {
                        check_func(e.detail.dot);
                    }
                });
                */
            });
        }, delay * 1000);
    }

    function checkFadedOutDots(dot) {
        if(this.dots.indexOf(dot) < 0) {
            return;
        }
        else {
            if(this.faded_out_dots.indexOf(dot) < 0) {
                this.faded_out_dots.push(dot);
            }

            let faded_out = true;
            let array = this;

            this.dots.forEach(function(d) {
                if(array.faded_out_dots.indexOf(d) < 0) {
                    faded_out = false;
                }
            });

            if(faded_out) {
                this.dots_visible = false;
                this.faded_out_dots = [];
                this.in_progress = false;
                //dispatchEvent(new CustomEvent("segment-dots-array-faded-out", { detail : { progress_bar : this } }));
                segmentDotsArrayProgressBarChanged();
            }
        }
    }

    /*
    SegmentDotsArrayProgressBar.prototype.instanceCopy = function() {
        const copy = new this.constructor();
        const keys = Object.keys(this);
        keys.forEach(key => { copy[key] = this[key]; });
        return copy;
    };
    */
}
