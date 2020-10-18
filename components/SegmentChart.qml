import QtQuick 2.0

Item {
    //this.id = id; // Object identificator
    property string name
    property var context // CanvasRenderingContext2D for drawing a segment array
    property double cx // X coordinate of the base segment center
    property double cy // Y coordinate of the base segment center
    property double r_in // base segment inner radius
    property double thickness // initial angle of the base segment
    property double r_out: r_in + thickness // base segment outer radius
    property double init_angle: -90 // initial angle of the base segment
    property double angle: 360 // angle of the base segment

    property SegmentGradient gradient: null
    property string background: "rgba(250, 250, 250, 1)"
    property double border_width: 1
    property string border_color: "rgba(100, 100, 100, 1)"

    property SegmentGrid base_segment: null

    property string type: 'pie' // pie, radial, bar
    property var source: []; // array of arrays [ 'key', 'value', 'color' ]
    property var data: [];

    property double min_value: 0 // 0%
    property double max_value: 100 // 100%
    property double total: 0

    property bool proportional: false
    property bool full_thickness: false
    property string start_with: 'segment'

    property var segments: []
    property int segments_count: 0
    property double segment_angle: 0
    property string segment_position: ''
    property double segment_thickness: 0.8 * this.thickness
    property double segment_r_in: this.r_in + (this.thickness - this.segment_thickness) / 2

    property SegmentGradient segment_gradient: null
    property string segment_background: 'rgba(180, 180, 180, 1)'
    property double segment_border_width: 1
    property string segment_border_color: 'rgba(10, 10, 10, 1)'

    property int spaces_count: 0
    property double space_angle: 0
    property double space_thickness: 3

    property var signs: []
    property double sign_r_in: this.r_in + this.thickness + 10
    property double sign_r_offset: 10
    property string font_family: 'Arial'
    property string font_size: '11pt'
    property string font
    property string text_color: 'black'
    property double text_border_width: 0
    property string text_border_color: 'rgba(0, 0, 0, 0)'
    property string text_direction: 'vertical' // vertical, clockwise, anticlockwise, from-center, to-center

    property bool segments_visible: true
    property bool signs_visible: true
    property bool in_progress: false //

    property var appeared_segments: []
    property var disappeared_segments: []
    property var faded_in_segments: []
    property var faded_out_segments: []

    signal segmentChartChanged;
    signal segmentChartAppeared;
    signal segmentChartDisappeared;
    signal segmentChartFadedIn;
    signal segmentChartFadedOut;

    Utilities { id: utilities; }

    Component.onCompleted: {
        this.build();
        this.calc();
    }

    function build() {
        this.segments = [];

        //this.base_segment = new SegmentGrid(this.id + '_base_segment', this.context, this.cx, this.cy, this.r_in, this.thickness, this.init_angle, this.angle);

        let segment_component = Qt.createComponent("SegmentGrid.qml");
        this.base_segment = segment_component.createObject(this, {
             id: this.id + '_base_segment', context: this.context, cx: this.cx, cy: this.cy,
             r_in: this.r_in, thickness: this.thickness, init_angle: this.init_angle, angle: this.angle });

        if(this.gradient) { this.base_segment.gradient = this.gradient.instanceCopy(); }
        this.base_segment.background = this.background;
        this.base_segment.border_width = this.border_width;
        this.base_segment.border_color = this.border_color;
        this.base_segment.circles_count = 0;
        this.base_segment.beams_count = 0;

        this.base_segment.calc();

        this.segments_count = this.source.length;

        if(this.type !== 'bar') {
            if(this.segment_position === 'inner') { this.segment_r_in = this.r_in; }
            else if(this.segment_position === 'middle') { this.segment_r_in = this.r_in + (this.thickness - this.segment_thickness) / 2; }
            else if(this.segment_position === 'outer') { this.segment_r_in = this.r_out - this.segment_thickness; }

            if(this.angle === 360) {
            this.spaces_count = this.segments_count;
            }
            else {
                if(this.start_with === 'segment') { this.spaces_count = this.segments_count - 1; }
                else { this.spaces_count = this.segments_count + 1; }
            }
        }

        if(this.type === 'radial') {
            this.segment_angle = (this.angle - this.spaces_count * this.space_angle) / this.segments_count;
            this.segment_r_in = this.r_in;
            this.segment_thickness = this.thickness;
        }

        if(this.type === 'bar') {
            if(this.start_with === 'segment') { this.spaces_count = this.segments_count - 1; }
            else {this.spaces_count = this.segments_count + 1; }

            this.segment_thickness = (this.thickness - this.spaces_count * this.space_thickness) / this.segments_count;
        }

        this.total = 0;
        for(let i=0; i < this.source.length; i++) {
            let seg = this.source[i];

            let key, value, color;

            if(seg.length >= 3) {
                key = seg[0];
                value = this.strToValue(seg[1]);
                color = seg[2];
            }
            else if(seg.length === 2) {
                key = seg[0];
                value = this.strToValue(seg[1]);
                if(this.segment_gradient) { color = this.segment_gradient.instanceCopy(); }
                else { color = this.segment_background; }
            }
            else { console.log("error format of source"); }

            this.data[i] = { 'key' : key, 'value' : value, 'color' : color };
            this.total += value;
        }

        if(this.type === 'pie') { this.build_pie(); }
        else if(this.type === 'radial') { this.build_radial(); }
        else { this.build_bar(); }

        let chart = this;

        this.base_segment.segmentChanged.connect(segmentChartChanged);

        this.segments.forEach(function(segment) {
            segment.segmentChanged.connect(segmentChartChanged);
            segment.segmentAppeared.connect(function() {
                checkAppearedSegments(segment);
            });
            segment.segmentDisappeared.connect(function() {
                checkDisappearedSegments(segment);
            });
            segment.segmentFadedIn.connect(function() {
                checkFadedInSegments(segment);
            });
            segment.segmentFadedOut.connect(function() {
                checkFadedOutSegments(segment);
            });
        });

        /*
        addEventListener("segment-changed", function(e) {
            if(e.detail.segment === chart.base_segment) {
                dispatchEvent(new CustomEvent("segment-chart-changed", { detail : { chart : chart } } ));
            }

            if(chart.segments.indexOf(e.detail.segment) >= 0) {
                dispatchEvent(new CustomEvent("segment-chart-changed", { detail : { chart : chart } } ));
            }
        });
        */
    }

    function build_pie() {
        let first_angle = this.init_angle;
        if(this.start_with === 'space') { first_angle += this.space_angle; }

        //for(let i=0; i < this.data.length; i++) {
        for(let i=0; i < this.segments_count; i++) {
            let init_a = first_angle;
            for(let j=0; j < i; j++) { init_a += this.valueToAngle(this.data[j].value) + this.space_angle; }
            let a = this.valueToAngle(this.data[i].value);

            //let segment = new Segment(this.id + '_s_' + (i+1), this.context, this.cx, this.cy, this.segment_r_in, this.segment_thickness, init_a, a);

            let segment_component = Qt.createComponent("Segment.qml");
            let segment = segment_component.createObject(this, {
                 id: this.id + '_s_' + (i+1), context: this.context, cx: this.cx, cy: this.cy,
                 r_in: this.segment_r_in, thickness: this.segment_thickness, init_angle: init_a, angle: a });

            console.log(segment.init_angle);

            if(this.data[i].color instanceof SegmentGradient) { segment.gradient = this.data[i].color.instanceCopy(); }
            else { segment.background = this.data[i].color; }
            segment.border_width = this.segment_border_width;
            segment.border_color = this.segment_border_color;
            segment.visible = this.segments_visible;
            segment.calc();
            this.segments.push(segment);

            let sign_a = init_a + a / 2;

            //let sign = new SegmentScaleSign(this.id + '_sign_' + (i+1), this.context, this.cx, this.cy, this.sign_r_in, this.data[i].value, sign_a);

            let sign_component = Qt.createComponent("SegmentScaleSign.qml");
            let sign = sign_component.createObject(this, {
                 id: this.id + '_sign_' + (i+1), context: this.context, cx: this.cx, cy: this.cy,
                 r_in: this.sign_r_in, text: this.data[i].value, angle: sign_a });

            sign.font = this.font;
            sign.text_color = this.text_color;
            sign.text_border_width = this.text_border_width;
            sign.text_border_color = this.text_border_color;
            sign.text_direction = this.text_direction; // vertical, clockwise, anticlockwise, from_center, to_center.
            sign.calc();
            this.signs.push(sign);
        }
    }

    function build_radial() {
        let first_angle = this.init_angle;
        if(this.start_with === 'space') { first_angle += this.space_angle; }

        for(let i=0; i < this.segments_count; i++) {
            let th = this.valueToThickness(this.data[i].value);
            let init_a = first_angle + (this.segment_angle + this.space_angle) * i;

            //let segment = new Segment(this.id + '_s_' + (i+1), this.context, this.cx, this.cy, this.segment_r_in, th, init_a, this.segment_angle);

            let segment_component = Qt.createComponent("Segment.qml");
            let segment = segment_component.createObject(this, {
                 id: this.id + '_s_' + (i+1), context: this.context, cx: this.cx, cy: this.cy,
                 r_in: this.segment_r_in, thickness: th, init_angle: init_a, angle: this.segment_angle });

            if(this.data[i].color instanceof SegmentGradient) { segment.gradient = this.data[i].color.instanceCopy(); }
            else { segment.background = this.data[i].color; }
            segment.border_width = this.segment_border_width;
            segment.border_color = this.segment_border_color;
            segment.visible = this.segments_visible;
            segment.calc();
            this.segments.push(segment);

            let sign_r_in = this.r_in + th + this.sign_r_offset;
            let sign_a = init_a + this.segment_angle / 2;

            //let sign = new SegmentScaleSign(this.id + '_sign_' + (i+1), this.context, this.cx, this.cy, sign_r_in, this.data[i].value, sign_a);

            let sign_component = Qt.createComponent("SegmentScaleSign.qml");
            let sign = sign_component.createObject(this, {
                 id: this.id + '_sign_' + (i+1), context: this.context, cx: this.cx, cy: this.cy,
                 r_in: sign_r_in, text: this.data[i].value, angle: sign_a });

            sign.font = this.font;
            sign.text_color = this.text_color;
            sign.text_border_width = this.text_border_width;
            sign.text_border_color = this.text_border_color;
            sign.text_direction = this.text_direction; // vertical, clockwise, anticlockwise, from_center, to_center.
            sign.calc();
            this.signs.push(sign);
        }
    }

    function build_bar() {
        let r_in = this.r_in;
        if(this.start_with === 'space') { r_in += this.space_thickness; }

        //for(let i=0; i < this.data.length; i++) {
        for(let i=0; i < this.segments_count; i++) {
            let segment_r_in = r_in + (this.segment_thickness + this.space_thickness) * i;
            let a = this.valueToAngle(this.data[i].value);

            //let segment = new Segment(this.id + '_s_' + (i+1), this.context, this.cx, this.cy, segment_r_in, this.segment_thickness, this.init_angle, a);

            let segment_component = Qt.createComponent("Segment.qml");
            let segment = segment_component.createObject(this, {
                 id: this.id + '_s_' + (i+1), context: this.context, cx: this.cx, cy: this.cy,
                 r_in: segment_r_in, thickness: this.segment_thickness, init_angle: this.init_angle, angle: a });

            if(this.data[i].color instanceof SegmentGradient) { segment.gradient = this.data[i].color.instanceCopy(); }
            else { segment.background = this.data[i].color; }
            segment.border_width = this.segment_border_width;
            segment.border_color = this.segment_border_color;
            segment.visible = this.segments_visible;
            segment.calc();
            this.segments.push(segment);
        }
    }

    function strToValue(str) {
        let value;
        if(!isNaN(str)) { value = parseInt(str); }
        else { value = parseInt(str.replace(/\s+/g, '').replace(/%/g, '')); }
        return value;
    }

    function valueToAngle(val) {
        let angle;

        let a = this.angle - this.spaces_count * this.space_angle;

        if(this.type === 'pie') { angle = a * val / this.total; }
        if(this.type === 'bar') { angle = this.angle * (val - this.min_value) / (this.max_value - this.min_value); }

        return angle;
    }

    function valueToThickness(val) {
        let thickness;

        let th = this.thickness - this.spaces_count * this.space_thickness;

        if(this.type === 'radial') { thickness = this.segment_thickness * (val - this.min_value) / (this.max_value - this.min_value); }

        return thickness;
    }

    function calc() {
        if(this.in_progress) {
            this.anim_r_out = this.anim_r_in + this.anim_thickness;

            /*
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
            */
        }
        else {
            this.r_out = this.r_in + this.thickness;

            /*
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
            */
        }

        //dispatchEvent(new CustomEvent("segment-chart-changed", { detail : { chart : this } } ));
        segmentChartChanged();
    }

    function draw() {
        this.base_segment.draw();

        this.segments.forEach(function(segment) {
            segment.draw();
        });

        this.signs.forEach(function(sign) {
            sign.draw();
        });
    }

    function appear(order, lag, direction, duration, delay) {
        this.in_progress = true;

        this.appeared_segments = [];

        let check_func = this.checkAppearedSegments.bind(this);

        let seg_arr = this;
        let segments = this.segments;

        let segment_duration = duration;
        let lag_array = [];

        for(let i=0; i < segments.length; i++) {
            if(order === 'together') {
                lag_array[i] = 0;
            }
            else if(order === 'one-by-one-clockwise') {
                segment_duration = (duration - lag * (segments.length - 1)) / segments.length;
                lag_array[i] = i * (segment_duration + lag);
            }
            else if(order === 'one-by-one-anticlockwise') {
                segment_duration = (duration -lag * (segments.length - 1)) / segments.length;
                lag_array[i] = (segments.length - 1 - i) * (segment_duration + lag);
            }
        }

        utilities.setTimeout(function() {
            segments.forEach(function callback(value, index, array) {
                value.appear(direction, segment_duration, lag_array[index]);

                /*
                addEventListener("segment-appeared", function(e) {
                    if(segments.indexOf(e.detail.segment) >= 0) {
                        check_func(e.detail.segment);
                    }
                });
                */
            });
        }, delay * 1000);
    }

    function checkAppearedSegments(segment) {
        if(this.segments.indexOf(segment) < 0) {
            return;
        }
        else {
            if(this.appeared_segments.indexOf(segment) < 0) {
                this.appeared_segments.push(segment);
            }

            let appeared = true;
            let array = this;

            this.segments.forEach(function(seg) {
                if(array.appeared_segments.indexOf(seg) < 0) {
                    appeared = false;
                }
            });

            if(appeared) {
                this.segments_visible = true;
                this.appeared_segments = [];
                this.in_progress = false;
                //dispatchEvent(new CustomEvent("segment-chart-appeared", { detail : { chart : this } }));
                segmentChartAppeared();
            }
        }
    }

    function disappear(order, lag, direction, duration, delay) {
        this.in_progress = true;

        this.disappeared_segments = [];

        let check_func = this.checkDisappearedSegments.bind(this);

        let seg_arr = this;
        let segments = this.segments;

        let segment_duration = duration;
        let lag_array = [];

        for(let i=0; i < segments.length; i++) {
            if(order === 'together') {
                lag_array[i] = 0;
            }
            else if(order === 'one-by-one-clockwise') {
                segment_duration = (duration - lag * (segments.length - 1)) / segments.length;
                lag_array[i] = i * (segment_duration + lag);
            }
            else if(order === 'one-by-one-anticlockwise') {
                segment_duration = (duration -lag * (segments.length - 1)) / segments.length;
                lag_array[i] = (segments.length - 1 - i) * (segment_duration + lag);
            }
        }

        utilities.setTimeout(function() {
            segments.forEach(function callback(value, index, array) {
                value.disappear(direction, segment_duration, lag_array[index]);

                /*
                addEventListener("segment-disappeared", function(e) {
                    if(segments.indexOf(e.detail.segment) >= 0) {
                        check_func(e.detail.segment);
                    }
                });
                */
            });
        }, delay * 1000);
    }

    function checkDisappearedSegments(segment) {
        if(this.segments.indexOf(segment) < 0) {
            return;
        }
        else {
            if(this.disappeared_segments.indexOf(segment) < 0) {
                this.disappeared_segments.push(segment);
            }

            let disappeared = true;
            let array = this;

            this.segments.forEach(function(seg) {
                if(array.disappeared_segments.indexOf(seg) < 0) {
                    disappeared = false;
                }
            });

            if(disappeared) {
                this.segments_visible = false;
                this.disappeared_segments.length = 0;
                this.in_progress = false;
                //dispatchEvent(new CustomEvent("segment-chart-disappeared", { detail : { chart : this } }));
                segmentChartDisappeared();
            }
        };
    }

    function fadeIn(order, lag, duration, delay) {
        this.in_progress = true;

        this.faded_in_segments = [];

        let check_func = this.checkFadedInSegments.bind(this);

        let seg_arr = this;
        let segments = this.segments;

        let segment_duration = duration;
        let lag_array = [];

        for(let i=0; i < segments.length; i++) {
            if(order === 'together') {
                lag_array[i] = 0;
            }
            else if(order === 'one-by-one-clockwise') {
                segment_duration = (duration - lag * (segments.length - 1)) / segments.length;
                lag_array[i] = i * (segment_duration + lag);
            }
            else if(order === 'one-by-one-anticlockwise') {
                segment_duration = (duration -lag * (segments.length - 1)) / segments.length;
                lag_array[i] = (segments.length - 1 - i) * (segment_duration + lag);
            }
        }

        utilities.setTimeout(function() {
            segments.forEach(function callback(value, index, array) {
                value.fadeIn(segment_duration, lag_array[index]);

                /*
                addEventListener("segment-faded-in", function(e) {
                    if(segments.indexOf(e.detail.segment) >= 0) {
                        check_func(e.detail.segment);
                    }
                });
                */
            });
        }, delay * 1000);
    }

    function checkFadedInSegments(segment) {
        if(this.segments.indexOf(segment) < 0) {
            return;
        }
        else {
            if(this.faded_in_segments.indexOf(segment) < 0) {
                this.faded_in_segments.push(segment);
            }

            let faded_in = true;
            let array = this;

            this.segments.forEach(function(seg) {
                if(array.faded_in_segments.indexOf(seg) < 0) {
                    faded_in = false;
                }
            });

            if(faded_in) {
                this.segments_visible = true;
                this.faded_in_segments = [];
                this.in_progress = false;
                //dispatchEvent(new CustomEvent("segment-chart-faded-in", { detail : { chart : this } }));
                segmentChartFadedIn();
            }
        }
    }

    function fadeOut(order, lag, duration, delay) {
        this.in_progress = true;

        this.faded_out_segments = [];

        let check_func = this.checkFadedOutSegments.bind(this);

        let seg_arr = this;
        let segments = this.segments;

        let segment_duration = duration;
        let lag_array = [];

        for(let i=0; i < segments.length; i++) {
            if(order === 'together') {
                lag_array[i] = 0;
            }
            else if(order === 'one-by-one-clockwise') {
                segment_duration = (duration - lag * (segments.length - 1)) / segments.length;
                lag_array[i] = i * (segment_duration + lag);
            }
            else if(order === 'one-by-one-anticlockwise') {
                segment_duration = (duration -lag * (segments.length - 1)) / segments.length;
                lag_array[i] = (segments.length - 1 - i) * (segment_duration + lag);
            }
        }

        utilities.setTimeout(function() {
            segments.forEach(function callback(value, index, array) {
                value.fadeOut(segment_duration, lag_array[index]);

                /*
                addEventListener("segment-faded-out", function(e) {
                    if(segments.indexOf(e.detail.segment) >= 0) {
                        check_func(e.detail.segment);
                    }
                });
                */
            });
        }, delay * 1000);
    }

    function checkFadedOutSegments(segment) {
        if(this.segments.indexOf(segment) < 0) {
            return;
        }
        else {
            if(this.faded_out_segments.indexOf(segment) < 0) {
                this.faded_out_segments.push(segment);
            }

            let faded_out = true;
            let array = this;

            this.segments.forEach(function(seg) {
                if(array.faded_out_segments.indexOf(seg) < 0) {
                    faded_out = false;
                }
            });

            if(faded_out) {
                this.segments_visible = false;
                this.faded_out_segments = [];
                this.in_progress = false;
                //dispatchEvent(new CustomEvent("segment-chart-faded-out", { detail : { chart : this } }));
                segmentChartFadedOut();
            }
        }
    }

    /*
    SegmentChart.prototype.instanceCopy = function() {
        const copy = new this.constructor();
        const keys = Object.keys(this);
        keys.forEach(key => { copy[key] = this[key]; });
        return copy;
    };
    */
}
