import QtQuick 2.0

Item {
    //this.id = id; // Object identificator
    property string name
    property var context // CanvasRenderingContext2D for drawing a mark
    property double cx // X coordinate of the segment scale center
    property double cy // Y coordinate of the segment scale center
    property double r_in // mark inner radius
    property string text // number value
    property double angle // mark angle

    property string font_family: 'Open Sans'
    property string font_size: '9pt'
    property string font
    property string text_color: 'black'
    property double text_border_width: 0
    property string text_border_color: 'black'
    property string text_direction: 'vertical' // vertical, clockwise, anticlockwise, from_center, to_center

    property bool in_progress: false

    property double dx
    property double dy
    property double a

    property double anim_r_in: 0
    property double anim_angle: 0

    property double anim_width: 0
    property string anim_color

    property double anim_dx
    property double anim_dy
    property double anim_a

    signal segmentScaleSignChanged;
    signal segmentScaleSignAppeared;
    signal segmentScaleSignDisappeared;
    signal segmentScaleSignFadedIn;
    signal segmentScaleSignFadedOut;

    Utilities { id: utilities; }

    Component.onCompleted: {
        this.calc();
    }

    function calc() {
        if(this.in_progress) {
            this.anim_a = this.anim_angle * Math.PI / 180;

            this.anim_dx = this.anim_r_in * Math.cos(this.anim_a) + this.cx; // First point. X coordinate
            this.anim_dy = this.anim_r_in * Math.sin(this.anim_a) + this.cy; // First point. Y coordinate
        }
        else {
            this.a = this.angle * Math.PI / 180;

            this.dx = this.r_in * Math.cos(this.a) + this.cx;
            this.dy = this.r_in * Math.sin(this.a) + this.cy;
        }

        //dispatchEvent(new CustomEvent("segment-scale-sign-changed", { detail : { sign : this } } ));
        segmentScaleSignChanged();
    }

    function draw() {
        if(this.visible) {
            let dx, dy;
            let r_in, r_out;
            let text;
            let angle;
            let color;

            if(this.in_progress) {
                dx = this.anim_dx; dy = this.anim_dy;
                r_in = this.anim_r_in;
                r_out = this.anim_r_out;
                text = this.anim_text;
                angle = this.anim_angle;
                color = this.anim_color;
            }
            else {
                dx = this.dx; dy = this.dy;
                dx = this.dx; dy = this.dy;
                r_in = this.r_in;
                r_out = this.r_out;
                text = this.text;
                angle = this.angle;
                color = this.color;
            }

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

            if(this.in_progress) { text = '' + this.anim_text; }
            else { text = '' + this.text; }

            this.context.fillText(text, dx, dy);
            this.context.strokeText(text, dx, dy);
        }
    }

    function prepareAnim() {
        this.anim_r_in = this.r_in;
        this.anim_length = this.length;
        this.anim_r_out = this.r_out;
        this.anim_angle = this.angle;

        this.anim_width = this.width;
        this.anim_color = this.color;
    }

    function appear(direction, duration, delay) {
        this.prepareAnim();

        this.in_progress = true;
        this.calc();

        let sign = this;

        let start;
        let time = null;
        let fraction = 0;
        let request = null;

        function appearAnim() {
            time = Date.now();
            fraction = (time - start) / (duration * 1000);

            let anim_func;
            if(direction === 'from-center') { anim_func = sign.appearFromCenter.bind(sign); }
            else if(direction === 'to-center') { anim_func = sign.appearToCenter.bind(sign); }
            else if(direction === 'from-middle') { anim_func = sign.appearFromMiddle.bind(sign); }

            anim_func(fraction);

            if(fraction > 1) {
                sign.stopAppearance();
                sign.context.canvas.cancelRequestAnimationFrame(request);
                //dispatchEvent(new CustomEvent("segment-scale-sign-appeared", { detail : { sign : sign } }));
                segmentScaleSignAppeared();
            }
            else {
                sign.visible = true;
                request = sign.context.canvas.requestAnimationFrame(appearAnim);
            }
        };

        request = utilities.setTimeout(function() {
            start = Date.now();
            sign.context.canvas.requestAnimationFrame(appearAnim);
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

    function appearFromMiddle(t) {
        let l = this.length * t;
        let r = (this.r_in + this.r_out) / 2;
        if(l < this.length) { this.anim_r_in = r - l / 2; this.anim_r_out = r + l / 2; }
        else { this.anim_r_in = this.r_in; this.anim_r_out = this.r_out; }
        this.calc();
    }

    function stopAppearance() {
        this.anim_r_in = 0;
        this.anim_r_out = 0;
        this.anim_length = 0;
        this.anim_angle = 0;

        this.in_progress = false;
        this.visible = true;

        this.calc();
    }

    function disappear(direction, duration, delay) {
        this.prepareAnim();

        this.in_progress = true;
        this.calc();

        let sign = this;

        let start;
        let time;
        let fraction = 0;
        let request = null;

        function disappearAnim() {
            time = Date.now();
            fraction = (time - start) / (duration * 1000);

            let anim_func;
            if(direction === 'from-center') { anim_func = sign.disappearFromCenter.bind(sign); }
            else if(direction === 'to-center') { anim_func = sign.disappearToCenter.bind(sign); }
            else if(direction === 'to-middle') { anim_func = sign.disappearToMiddle.bind(sign); }
            anim_func(fraction);

            if(fraction > 1) {
                sign.stopDisappearance();
                sign.context.canvas.cancelRequestAnimationFrame(request);
                //dispatchEvent(new CustomEvent("segment-scale-sign-disappeared", { detail : { sign : sign } }));
                segmentScaleSignDisappeared();
            }
            else {
                sign.visible = true;
                sign.context.canvas.requestAnimationFrame(disappearAnim);
            }
        };

        request = utilitites.setTimeout(function() {
            start = Date.now();
            sign.context.canvas.requestAnimationFrame(disappearAnim);
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

    function disappearToMiddle(t) {
        let l = this.length * (1 - t);
        let r = (this.r_in + this.r_out) / 2;
        if(l < this.length) { this.anim_r_in = r - l / 2; this.anim_r_out = r + l / 2; }
        else { this.anim_r_in = this.r_in; this.anim_r_out = this.r_out; }
        this.calc();
    }

    function stopDisappearance() {
        this.anim_r_in = 0;
        this.anim_r_out = 0;
        this.anim_length = 0;
        this.anim_angle = 0;

        this.in_progress = false;
        this.visible = false;

        this.calc();
    }

    function fadeIn(duration, delay) {
        this.prepareAnim();

        this.calc();
        this.in_progress = true;

        let sign = this;

        let start;
        let time = null;
        let fraction = 0;
        let request = null;

        let color = utilitites.rgbaStrToObj(utilitites.rgbaStrFromColor(this.color));
        let new_color = Object.assign({}, color);

        function fadeInAnim() {
            time = Date.now();
            fraction = (time - start) / (duration * 1000);

            new_color.a = color.a * (fraction);
            sign.anim_color = utilitites.rgbaObjToStr(new_color);

            let calc_func = sign.calc.bind(sign);
            calc_func();

            if(fraction > 1) {
                sign.anim_color = sign.color;
                sign.stopFadingIn();
                sign.context.canvas.cancelRequestAnimationFrame(request);
                //dispatchEvent(new CustomEvent("segment-scale-sign-faded-in", { detail : { sign : sign } }));
                segmentScaleSignFadedIn();
            }
            else {
                sign.visible = true;
                request = sign.context.canvas.requestAnimationFrame(fadeInAnim);
            }
        };

        request = utilitites.setTimeout(function() {
            start = Date.now();
            sign.context.canvas.requestAnimationFrame(fadeInAnim);
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

        let sign = this;

        let start;
        let time = null;
        let fraction = 0;
        let request = null;

        let color = utilitites.rgbaStrToObj(utilitites.rgbaStrFromColor(this.anim_color));
        let new_color = Object.assign({}, color);

        function fadeOutAnim() {
            time = Date.now();
            fraction = (time - start) / (duration * 1000);

            new_color.a = color.a * (1 - fraction);
            sign.anim_color = utilitites.rgbaObjToStr(new_color);

            let calc_func = sign.calc.bind(sign);
            calc_func();

            if(fraction > 1) {
                sign.anim_color = sign.color;
                sign.stopFadingOut();
                sign.context.canvas.cancelRequestAnimationFrame(request);
                //dispatchEvent(new CustomEvent("segment-scale-sign-faded-out", { detail : { sign : sign } }));
                segmentScaleSignFadedOut();
            }
            else {
                sign.visible = true;
                request = sign.context.canvas.requestAnimationFrame(fadeOutAnim);
            }
        };

        request = utilitites.setTimeout(function() {
            start = Date.now();
            sign.context.canvas.requestAnimationFrame(fadeOutAnim);
        }, delay * 1000);
    }

    function stopFadingOut() {
        this.visible = false;
        this.in_progress = false;

        this.calc();
    }

    /*
    SegmentScaleSign.prototype.instanceCopy = function() {
        const copy = new this.constructor();
        const keys = Object.keys(this);
        keys.forEach(key => { copy[key] = this[key]; });
        return copy;
    };
    */
}
