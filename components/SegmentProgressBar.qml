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
    property double angle: 360

    property double min_value: 0
    property double max_value: 100
    property double value: 0
    property double speed: 0.5 // value change animation speed

    property string font_family: 'Arial'
    property string font_size: '30px'
    property string font
    property string text_color: 'black'
    property double text_border_width: 1
    property string text_border_color: 'rgba(0,0,0,0)'
    property string units: '%'

    property Segment base_segment: null
    property Segment active_segment: null

    property double acitve_segment_r_in: this.r_in
    property double active_segment_thickness: 0.6 * this.thickness

    property SegmentGradient base_segment_gradient: null
    property string base_segment_background: "rgba(250, 250, 250, 1)"
    property double base_segment_border_width: 1
    property string base_segment_border_color: "rgba(100, 100, 100, 0.5)"

    property SegmentGradient active_segment_gradient: null
    property string active_segment_background: "rgba(100, 100, 100, 1)"
    property double active_segment_border_width: 0
    property string active_segment_border_color: 'none'

    property bool full_thickness: false
    property bool in_progress: false

    property double anim_value: this.value

    signal segmentProgressBarChanged;
    signal segmentProgressBarValueChanged;

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

        //dispatchEvent(new CustomEvent("segment-progress-bar-changed", { detail : { segment : this } } ));
        segmentProgressBarChanged();
    }

    function build() {
        if((this.angle %= 360) === 0) { this.angle = 360; }
        else if(this.angle > 360) { this.angle = 360; }
        else if(this.angle < 0) { while(this.angle < 0) { this.angle += 360; }; }

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

        let active_segment_r_in;
        if(this.active_segment_r_in) active_segment_r_in = this.active_segment_r_in;
        else active_segment_r_in = this.r_in + (this.thickness - this.active_segment_thickness) / 2;

        let angle = this.valueToAngle();

        //this.active_segment = new Segment(this.id + '-active-segment', this.context, this.cx, this.cy, active_segment_r_in, this.active_segment_thickness, this.init_angle, this.angle);

        this.active_segment = segment_component.createObject(this, {
            id: this.id + '-active-segment', context: this.context, cx: this.cx, cy: this.cy,
            r_in: active_segment_r_in, thickness: this.active_segment_thickness, init_angle: this.init_angle, angle: this.angle });

        if(this.active_segment_gradient) { this.active_segment.gradient = this.active_segment_gradient.instanceCopy(); }
        this.active_segment.background = this.active_segment_background;
        this.active_segment.border_width = this.active_segment_border_width;
        this.active_segment.border_color = this.active_segment_border_color;
        this.active_segment.calc();

        let progress_bar = this;

        this.base_segment.segmentChanged.connect(segmentProgressBarChanged);
        this.active_segment.segmentChanged.connect(segmentProgressBarChanged);

        /*
        addEventListener("segment-changed", function(e) {
            if(e.detail.segment === progress_bar.base_segment) {
                dispatchEvent(new CustomEvent("segment-progress-bar-changed", { detail : { progress_bar : progress_bar } } ));
            }

            if(e.detail.segment === progress_bar.active_segment) {
                dispatchEvent(new CustomEvent("segment-progress-bar-changed", { detail : { progress_bar : progress_bar } } ));
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

        if(this.in_progress) { text = '' + this.anim_value + this.units; }
        else { text = '' + this.value + this.units; }

        this.context.fillText(text, this.cx, this.cy);
        this.context.strokeText(text, this.cx, this.cy);
    }

    function valueToAngle(value = this.value) {
        while(this.angle < 0) { this.angle += 360; }
        if(this.angle > 360) { this.angle = 360; }

        let a = this.angle * (value - this.min_value) / (this.max_value - this.min_value);
        return a;
    }

    function changeValue(new_value, speed = this.speed, delay = 0) {
        let progress_bar = this;

        if(speed <= 0) {
            this.value = new_value;
            this.calc();
            //dispatchEvent(new CustomEvent("segment-progress-bar-value-changed", { detail : { progress_bar : progress_bar } }));
            segmentProgressBarValueChanged();
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
                progress_bar.active_segment.angle = old_angle + a;
                if(progress_bar.active_segment.angle > 360) { progress_bar.active_segment.angle = 360; }
                progress_bar.active_segment.calc();
            }

            if(fraction > 1) {
                progress_bar.value = parseInt(new_value.toFixed(0));
                progress_bar.in_progress = false;
                progress_bar.calc();
                progress_bar.context.canvas.cancelRequestAnimationFrame(request);
                //dispatchEvent(new CustomEvent("segment-progress-bar-value-changed", { detail : { progress_bar : progress_bar } }));
                segmentProgressBarValueChanged();
            }
            else {
                progress_bar.active_segment.visible = true;
                request = progress_bar.context.canvas.requestAnimationFrame(changeValueAnim);
            }
        };

        request = utilities.setTimeout(function() {
            start = Date.now();
            progress_bar.context.canvas.requestAnimationFrame(changeValueAnim);
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

    function appear(direction, duration, delay) {
        this.prepareAnim();

        this.in_progress = true;
        this.calc();

        let segment = this;

        let start = null;
        let time = null;
        let fraction = 0;
        let request = null;

        function appearAnim() {
            time = Date.now();
            fraction = (time - start) / (duration * 1000);

            let anim_func;
            if(direction === 'from-center') { anim_func = segment.appearFromCenter.bind(segment); }
            else if(direction === 'to-center') { anim_func = segment.appearToCenter.bind(segment); }
            else if(direction === 'from-axis') { anim_func = segment.appearFromAxis.bind(segment); }
            else if(direction === 'clockwise') { anim_func = segment.appearClockwise.bind(segment); }
            else if(direction === 'anticlockwise') { anim_func = segment.appearAnticlockwise.bind(segment); }
            anim_func(fraction);

            if(fraction > 1) {
                segment.stopAppearance();
                segment.context.canvas.cancelRequestAnimationFrame(request);
                //dispatchEvent(new CustomEvent("segment-appeared", { detail : { segment : segment } }));
                segmentProgressBarChanged();
            }
            else {
                segment.visible = true;
                segment.context.canvas.requestAnimationFrame(appearAnim);
            }
        };

        request = utilities.setTimeout(function() {
            start = Date.now();
            segment.context.canvas.requestAnimationFrame(appearAnim);
        }, delay * 1000);
    }

    function appearFromCenter(t) {
        let r = this.r_in + (this.r_out - this.r_in) * t;
        if(r < this.r_out) { this.anim_r_out = r; }
        else { this.anim_r_out = this.r_out; };
        this.calc();
    }

    function appearToCenter(t) {
        let r = this.r_out - (this.r_out - this.r_in) * t;
        if(r > this.r_in) { this.anim_r_in = r; }
        else { this.anim_r_in = this.r_in; }
        this.calc();
    }

    function appearFromAxis(t) {
        let a = (this.angle / 2) * t;
        if(a < this.angle / 2) {
            this.anim_init_angle = this.init_angle + this.angle/2 - a;
            this.anim_angle = a * 2;
        }
        else {
            this.anim_init_angle = this.init_angle;
            this.anim_angle = this.angle;
        }
        this.calc();
    }

    function appearClockwise(t) {
        let a = this.angle * t;
        if(a < this.angle) { this.anim_angle = a; }
        else { this.anim_angle = this.angle; }
        this.calc();
    }

    function appearAnticlockwise(t) {
        let a = this.angle * t;
        if(a < this.angle) {
            this.anim_init_angle = this.init_angle + this.angle - a;
            this.anim_angle = a;
        }
        else {
            this.anim_init_angle = this.init_angle;
            this.anim_angle = this.angle;
        }
        this.calc();
    }

    function stopAppearance() {
        this.anim_r_in = 0;
        this.anim_r_out = 0;
        this.anim_init_angle = 0;
        this.anim_angle = 0;

        this.in_progress = false;
        this.visible = true;

        this.calc();
    }

    function disappear(direction, duration, delay) {
        this.prepareAnim();

        this.in_progress = true;
        this.calc();

        let segment = this;

        let start;
        let time = null;
        let fraction = 0;
        let request = null;

        function disappearAnim() {
            time = Date.now();
            fraction = (time - start) / (duration * 1000);

            let anim_func;
            if(direction === 'from-center') { anim_func = segment.disappearFromCenter.bind(segment); }
            else if(direction === 'to-center') { anim_func = segment.disappearToCenter.bind(segment); }
            else if(direction === 'to-axis') { anim_func = segment.disappearToAxis.bind(segment); }
            else if(direction === 'clockwise') { anim_func = segment.disappearClockwise.bind(segment); }
            else if(direction === 'anticlockwise') { anim_func = segment.disappearAnticlockwise.bind(segment); }
            anim_func(fraction);

            if(fraction > 1) {
                segment.stopDisappearance();
                segment.context.canvas.cancelRequestAnimationFrame(request);
                //dispatchEvent(new CustomEvent("segment-disappeared", { detail : { segment : segment } }));
                segmentProgressBarChanged();
            }
            else {
                segment.visible = true;
                request = segment.context.canvas.requestAnimationFrame(disappearAnim);
            }
        };

        request = utilities.setTimeout(function() {
            start = Date.now();
            segment.context.canvas.requestAnimationFrame(disappearAnim);
        }, delay * 1000);
    }

    function disappearFromCenter(t) {
        let r = this.r_in + (this.r_out - this.r_in) * t;
        if(r < this.r_out) { this.anim_r_in = r; }
        else { this.anim_r_in = this.r_out; };
        this.calc();
    }

    function disappearToCenter(t) {
        let r = this.r_out - (this.r_out - this.r_in) * t;
        if(r > this.r_in) { this.anim_r_out = r; }
        else { this.anim_r_out = this.r_in; }
        this.calc();
    }

    function disappearToAxis(t) {
        let a = (this.angle / 2) * t;
        if(a < this.angle / 2) {
            this.anim_init_angle = this.init_angle + a;
            this.anim_angle = this.angle - a * 2;
        }
        else {
            this.anim_init_angle = this.init_angle;
            this.anim_angle = this.angle;
        }
        this.calc();
    }

    function disappearClockwise(t) {
        let a = this.angle * t;
        if(a < this.angle) {
            this.anim_init_angle = this.init_angle + a;
            this.anim_angle = this.angle - a;
        }
        else {
            this.anim_init_angle = this.init_angle;
            this.anim_angle = 0;
        }
        this.calc();
    }

    function disappearAnticlockwise(t) {
        let a = this.angle * t;
        if(a < this.angle) {
            this.anim_init_angle = this.init_angle;
            this.anim_angle = this.angle - a;
        }
        else {
            this.anim_init_angle = this.init_angle;
            this.anim_angle = 0;
        }
        this.calc();
    }

    function stopDisappearance() {
        this.anim_r_in = 0;
        this.anim_r_out = 0;
        this.anim_init_angle = 0;
        this.anim_angle = 0;

        this.in_progress = false;
        this.visible = false;

        this.calc();
    }

    function rotate(direction, angle, duration, delay) {
        this.prepareAnim();

        this.in_progress = true;
        this.calc();

        let segment = this;

        let start;
        let time = null;
        let fraction = 0;
        let request = null;

        function rotateAnim() {
            time = Date.now();

            fraction = (time - start) * angle / (duration * 1000);

            let anim_func;
            if(direction === 'clockwise') { anim_func = segment.rotateClockwise.bind(segment); }
            else if(direction === 'anticlockwise') { anim_func = segment.rotateAnticlockwise.bind(segment); }
            anim_func(fraction);

            if((time - start) > duration * 1000) {
                segment.stopRotation();
                segment.context.canvas.cancelRequestAnimationFrame(request);
                //dispatchEvent(new CustomEvent("segment-rotated", { detail : { segment : segment } }));
                segmentProgressBarChanged();
            }
            else {
                segment.visible = true;
                request = segment.context.canvas.requestAnimationFrame(rotateAnim);
            }
        };

        request = utilities.setTimeout(function() {
            start = Date.now();
            segment.context.canvas.requestAnimationFrame(rotateAnim);
        }, delay * 1000);
    }

    function rotateClockwise(a) {
        this.anim_init_angle = this.init_angle + a;
        this.calc();
    }

    function rotateAnticlockwise(a) {
        this.anim_init_angle = this.init_angle - a;
        this.calc();
    }

    function stopRotation() {
        this.r_in = this.anim_r_in;
        this.r_out = this.anim_r_out;
        this.init_angle = this.anim_init_angle;
        this.angle = this.anim_angle;

        this.anim_r_in = 0;
        this.anim_r_out = 0;
        this.anim_init_angle = 0;
        this.anim_angle = 0;

        this.in_progress = false;

        this.calc();
    }

    function fadeIn(duration, delay) {
        this.prepareAnim();

        this.calc();
        this.in_progress = true;

        let segment = this;

        let start;
        let time = null;
        let fraction = 0;
        let request = null;

        let bg = utilities.rgbaStrToObj(utilities.rgbaStrFromColor(this.background));

        let opening_bc = utilities.rgbaStrToObj(utilities.rgbaStrFromColor(this.opening_stroke_style));
        let closing_bc = utilities.rgbaStrToObj(utilities.rgbaStrFromColor(this.closing_stroke_style));
        let outer_bc = utilities.rgbaStrToObj(utilities.rgbaStrFromColor(this.outer_stroke_style));
        let inner_bc = utilities.rgbaStrToObj(utilities.rgbaStrFromColor(this.inner_stroke_style));

        let new_bg = Object.assign({}, bg);

        let new_opening_bc = Object.assign({}, opening_bc);
        let new_closing_bc = Object.assign({}, closing_bc);
        let new_outer_bc = Object.assign({}, outer_bc);
        let new_inner_bc = Object.assign({}, inner_bc);

        function fadeInAnim() {
            time = Date.now();
            fraction = (time - start) / (duration * 1000);

            if(segment.gradient !== null) {
                let new_gr = segment.gradient.instanceCopy();
                new_gr.fade(fraction);
                segment.anim_gradient = new_gr.instanceCopy();
            }

            new_bg.a = bg.a * (fraction);
            segment.anim_background = utilities.rgbaObjToStr(new_bg);

            new_opening_bc.a = opening_bc.a * (fraction);
            segment.anim_border_opening_color = utilities.rgbaObjToStr(new_opening_bc);

            new_closing_bc.a = closing_bc.a * (fraction);
            segment.anim_border_closing_color = utilities.rgbaObjToStr(new_closing_bc);

            new_outer_bc.a = outer_bc.a * (fraction);
            segment.anim_border_outer_color = utilities.rgbaObjToStr(new_outer_bc);

            new_inner_bc.a = inner_bc.a * (fraction);
            segment.anim_border_inner_color = rgbaObjToStr(new_inner_bc);

            let calc_func = segment.calc.bind(segment);
            calc_func();

            if(fraction > 1) {
                if(this.gradient !== null && (this.gradient instanceof SegmentGradient)) { this.anim_gradient = this.gradient.instanceCopy(); }
                segment.anim_background = segment.background;
                segment.anim_border_color = segment.border_color;
                segment.stopFadingIn();
                segment.context.canvas.cancelRequestAnimationFrame(request);
                //dispatchEvent(new CustomEvent("segment-faded-in", { detail : { segment : segment } }));
                segmentProgressBarChanged();
            }
            else {
                segment.visible = true;
                request = segment.context.canvas.requestAnimationFrame(fadeInAnim);
            }
        };

        request = utilities.setTimeout(function() {
            start = Date.now();
            segment.context.canvas.requestAnimationFrame(fadeInAnim);
        }, delay * 1000);
    }

    function stopFadingIn() {
        this.visible = true;
        this.in_progress = false;

        this.calc();
    }

    function fadeOut(duration, delay) {
        this.prepareAnim();

        this.in_progress = true;
        this.calc();

        let segment = this;

        let start;
        let time = null;
        let fraction = 0;
        let request = null;

        let bg = utilities.rgbaStrToObj(utilities.rgbaStrFromColor(this.anim_background));

        let opening_bc = utilities.rgbaStrToObj(utilities.rgbaStrFromColor(this.opening_stroke_style));
        let closing_bc = utilities.rgbaStrToObj(utilities.rgbaStrFromColor(this.closing_stroke_style));
        let outer_bc = utilities.rgbaStrToObj(utilities.rgbaStrFromColor(this.outer_stroke_style));
        let inner_bc = utilities.rgbaStrToObj(utilities.rgbaStrFromColor(this.inner_stroke_style));

        let new_bg = Object.assign({}, bg);

        let new_opening_bc = Object.assign({}, opening_bc);
        let new_closing_bc = Object.assign({}, closing_bc);
        let new_outer_bc = Object.assign({}, outer_bc);
        let new_inner_bc = Object.assign({}, inner_bc);

        function fadeOutAnim() {
            time = Date.now();
            fraction = (time - start) / (duration * 1000);

            if(segment.gradient !== null) {
                let new_gr = segment.gradient.instanceCopy();
                new_gr.fade(1 - fraction);
                segment.anim_gradient = new_gr.instanceCopy();
            }

            new_bg.a = bg.a * (1 - fraction);
            segment.anim_background = utilities.rgbaObjToStr(new_bg);

            new_opening_bc.a = opening_bc.a * (1 - fraction);
            segment.anim_border_opening_color = utilities.rgbaObjToStr(new_opening_bc);

            new_closing_bc.a = closing_bc.a * (1 - fraction);
            segment.anim_border_closing_color = utilities.rgbaObjToStr(new_closing_bc);

            new_outer_bc.a = outer_bc.a * (1 - fraction);
            segment.anim_border_outer_color = utilities.rgbaObjToStr(new_outer_bc);

            new_inner_bc.a = inner_bc.a * (1 - fraction);
            segment.anim_border_inner_color = utilities.rgbaObjToStr(new_inner_bc);

            let calc_func = segment.calc.bind(segment);
            calc_func();

            if(fraction > 1) {
                if(this.gradient !== null && (this.gradient instanceof SegmentGradient)) { this.anim_gradient = this.gradient.instanceCopy(); }
                segment.anim_background = segment.background;
                segment.anim_border_color = segment.border_color;
                segment.stopFadingOut();
                segment.context.canvas.cancelRequestAnimationFrame(request);
                //dispatchEvent(new CustomEvent("segment-faded-out", { detail : { segment : segment } }));
                segmentProgressBarChanged();
            }
            else {
                segment.visible = true;
                request = segment.context.canvas.requestAnimationFrame(fadeOutAnim);
            }
        };

        request = utilities.setTimeout(function() {
            start = Date.now();
            segment.context.canvas.requestAnimationFrame(fadeOutAnim);
        }, delay * 1000);
    }

    function stopFadingOut() {
        this.visible = false;
        this.in_progress = false;

        this.calc();
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

        return res;
    }

    /*
    SegmentProgressBar.prototype.instanceCopy = function() {
        const copy = new this.constructor();
        const keys = Object.keys(this);
        keys.forEach(key => { copy[key] = this[key]; });
        return copy;
    };
    */
}
