import QtQuick 2.0

Item {
    //this.id = id; // Object identificator
    property string name
    property var context // CanvasRenderingContext2D for drawing a segment scale
    property double cx // X coordinate of the base segment center
    property double cy // Y coordinate of the base segment center
    property double r_in // base segment inner radius
    property double thickness // base segment thickness
    property double r_out: r_in + thickness // base segment outer radius
    property double init_angle // base segment initial radius
    property double angle // base segment angle

    property SegmentGradient gradient: null
    property string background: "rgba(200, 200, 200, 1)"
    property double border_width: 1
    property string border_color: "rgba(100, 100, 100, 1)"

    property Segment base_segment: null

    property var levels: []
    property var divisions: []
    property var marks: []
    property var signs: []

    property double min_value
    property double max_value

    property string mark_position: ''
    property double mark_r_in: this.r_in

    property string sign_position: ''
    property double sign_r_in: this.r_in + 15
    property string sign_font: '10pt Arial'
    property string sign_text_color: 'black'
    property double sign_text_border_width: 0
    property string sign_text_border_color: 'rgba(0, 0, 0, 0)'
    property string sign_text_direction: 'vertical' // vertical, clockwise, anticlockwise, from_center, to_center

    property bool marks_visible: true
    property bool signs_visible: true
    property bool in_progress: false

    property var appeared_marks: []
    property var disappeared_marks: []
    property var faded_in_marks: []
    property var faded_out_marks: []

    signal segmentScaleChanged;
    signal segmentScaleAppeared;
    signal segmentScaleDisappeared;
    signal segmentScaleFadedIn;
    signal segmentScaleFadedOut;

    Utilities { id: utilities; }

    Component.onCompleted: {
        this.build();
        this.calc();
    }

    function build() {
        this.divisions = [];
        this.marks = [];
        this.signs = [];

        let segment_component = Qt.createComponent("Segment.qml");
        this.base_segment = segment_component.createObject(this, {
             id: this.id + '_base_segment', context: this.context, cx: this.cx, cy: this.cy,
             r_in: this.r_in, thickness: this.thickness, init_angle: this.init_angle, angle: this.angle });

//        this.base_segment = new Segment(this.id + '_base_segment', this.context, this.cx, this.cy, this.r_in, this.thickness, this.init_angle, this.angle);

        if(this.gradient) { this.base_segment.gradient = this.gradient.instanceCopy(); }
        this.base_segment.background = this.background;
        this.base_segment.border_width = this.border_width;
        this.base_segment.border_color = this.border_color;

        this.base_segment.calc();

        for(let i=0; i < this.levels.length; i++) {
            let level = this.levels[i];
            let divisions_count = level.divisions_count;

            for(let j=i-1; j >= 0; j--) {
                let prev_level = this.levels[j];
                divisions_count *= prev_level.divisions_count;
            }

            let division_angle = this.angle / divisions_count;
            let subdivision = { 'divisions_count' : divisions_count, 'division_angle' : division_angle };

            this.divisions.push(subdivision);
        }

        for(let i=0; i < this.levels.length; i++) {
            let level = this.levels[i];
            let subdivision = this.divisions[i];

            let mark_r_in = this.mark_r_in;
            let mark_length = level.mark_length;

            if(this.mark_position === 'inner') { mark_r_in = this.r_in; }
            else if(this.mark_position === 'middle') { mark_r_in = this.r_in + (this.thickness - mark_length) / 2; }
            else if(this.mark_position === 'outer') { mark_r_in = this.r_out - mark_length; }

            // Signs
            let signs = null;
            let signs_array = null;
            let text_options = null;

            let sign_r_in = this.sign_r_in;

            if(level.hasOwnProperty('signs')) {
                signs = level.signs;

                if(signs.hasOwnProperty('signs_array')) {
                    signs_array = signs.signs_array;
                }

                if(signs.hasOwnProperty('text_options')) {
                    text_options = signs.text_options;
                }
            }

            let k = 0;

            for(let j=0; j <= subdivision.divisions_count; j++) {
                if(i !== 0) {
                    if((j === subdivision.divisions_count) && (i !== 0 || this.angle !== 360)) continue;
                    if(j % level.divisions_count === 0) continue;
                }
                else {
                    if(this.angle === 360 && j === 0) continue;
                }

                let angle = this.init_angle + subdivision.division_angle * j;

                let mark_component = Qt.createComponent("SegmentScaleMark.qml");
                let mark = mark_component.createObject(this, {
                     id: this.id + '_m_' + (i+1) + '_' + (j), context: this.context, cx: this.cx, cy: this.cy,
                     r_in: mark_r_in, length: mark_length, angle: angle });

                //let mark = new SegmentScaleMark(this.id + '_m_' + (i+1) + '_' + (j), this.context, this.cx, this.cy, mark_r_in, mark_length, angle);
                mark.width = level.mark_width;
                mark.color = level.mark_color;
                mark.visible = this.marks_visible;
                mark.calc();
                this.marks.push(mark);

                if(signs_array !== null) {
                    if(typeof signs_array[k] !== 'undefined') {
                        let sign_component = Qt.createComponent("SegmentScaleSign.qml");
                        let sign = sign_component.createObject(this, {
                             id: this.id + '_s_' + (i+1) + '_' + (k), context: this.context, cx: this.cx, cy: this.cy,
                             r_in: sign_r_in, text: signs_array[k], angle: angle });

                        //let sign = new SegmentScaleSign(this.id + '_s_' + (i+1) + '_' + (k), this.context, this.cx, this.cy, sign_r_in, signs_array[k], angle);
                        if(typeof text_options !== 'undefined') {
                            if(typeof text_options.hasOwnProperty('font')) { sign.font = text_options.font; }
                            if(typeof text_options.hasOwnProperty('color')) { sign.text_color = text_options.color; }
                            if(typeof text_options.hasOwnProperty('border_width')) { sign.text_border_width = text_options.border_width; }
                            if(typeof text_options.hasOwnProperty('border_color')) { sign.text_border_color = text_options.border_color; }
                            if(typeof text_options.hasOwnProperty('direction')) { sign.text_direction = text_options.direction; }
                        }

                        console.log(sign.text);

                        sign.calc();
                        this.signs.push(sign);

                        k++;
                    }
                }
            }
        }

        let scale = this;

        this.base_segment.segmentChanged.connect(segmentScaleChanged);

        this.marks.forEach(function(mark) {
            mark.segmentScaleMarkChanged.connect(segmentScaleChanged);

            mark.segmentScaleMarkAppeared.connect(function() {
                checkAppearedMarks(mark);
            });
            mark.segmentScaleMarkDisappeared.connect(function() {
                checkDisappearedMarks(mark);
            });
            mark.segmentScaleMarkFadedIn.connect(function() {
                checkFadedInMarks(mark);
            });
            mark.segmentScaleMarkFadedOut.connect(function() {
                checkFadedOutMarks(mark);
            });
        });

        /*
        addEventListener("segment-changed", function(e) {
            if(e.detail.segment === scale.base_segment) {
                dispatchEvent(new CustomEvent("segment-scale-changed", { detail : { scale : scale } } ));
            }
        });

        addEventListener("segment-scale-mark-changed", function(e) {
            if(scale.marks.indexOf(e.detail.mark) >= 0) {
                dispatchEvent(new CustomEvent("segment-scale-changed", { detail : { scale : scale } } ));
            }
        });

        addEventListener("segment-scale-sign-changed", function(e) {
            if(scale.signs.indexOf(e.detail.sign) >= 0) {
                dispatchEvent(new CustomEvent("segment-scale-changed", { detail : { scale : scale } } ));
            }
        });
        */
    }

    function calc() {
        /*
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
        */

        //dispatchEvent(new CustomEvent("segment-scale-changed", { detail : { scale : this } } ));
        segmentScaleChanged();
    }

    function draw() {
        this.base_segment.draw();

        this.marks.forEach(function(mark) {
            mark.draw();
        });

        this.signs.forEach(function(sign) {
            sign.draw();
        });
    }

    function sortMarksByAngle(marks) {
        function compareByAngle(a, b) {
            if(a.angle > b.angle) { return 1; }
            if(a.angle < b.angle) { return -1; }
            if(a.angle === b.angle) { return 0; }
        }
        return marks.sort(compareByAngle);
    }

    function appear(order, lag, direction, duration, delay) {
        this.in_progress = true;

        this.appeared_marks = [];

        let check_func = this.checkAppearedMarks.bind(this);

        let marks = this.marks.concat();
        if(order.startsWith('one-by-one')) { this.sortMarksByAngle(marks); }

        let mark_duration = duration;
        let lag_array = [];

        for(let i=0; i < marks.length; i++) {
            if(order === 'together') {
                lag_array[i] = 0;
            }
            else if((order === 'one-by-one-clockwise') || (order === 'level-by-level-clockwise')) {
                mark_duration = (duration - lag * (marks.length - 1)) / marks.length;
                lag_array[i] = i * (mark_duration + lag);
            }
            else if((order === 'one-by-one-anticlockwise') || (order === 'level-by-level-anticlockwise')) {
                mark_duration = (duration - lag * (marks.length - 1)) / marks.length;
                lag_array[i] = (marks.length - 1 - i) * (mark_duration + lag);
            }
        }

        utilities.setTimeout(function() {
            marks.forEach(function callback(value, index, array) {
                value.appear(direction, mark_duration, lag_array[index]);

                /*
                addEventListener("segment-scale-mark-appeared", function(e) {
                    if(marks.indexOf(e.detail.mark) >= 0) {
                        check_func(e.detail.mark);
                    }
                });
                */
            });
        }, delay * 1000);
    }

    function checkAppearedMarks(mark) {
        if(this.marks.indexOf(mark) < 0) {
            return;
        }
        else {
            if(this.appeared_marks.indexOf(mark) < 0) {
                this.appeared_marks.push(mark);
            }

            let appeared = true;
            let scale = this;

            this.marks.forEach(function(m) {
                if(scale.appeared_marks.indexOf(m) < 0) {
                    appeared = false;
                }
            });

            if(appeared) {
                this.marks_visible = true;
                this.appeared_marks = [];
                this.in_progress = false;
                //dispatchEvent(new CustomEvent("segment-scale-appeared", { detail : { scale : this } }));
                segmentScaleAppeared();
            }
        };
    }

    function disappear(order, lag, direction, duration, delay) {
        this.in_progress = true;

        this.disappeared_marks = [];

        let check_func = this.checkDisappearedMarks.bind(this);

        let marks = this.marks.concat();
        if(order.startsWith('one-by-one')) { this.sortMarksByAngle(marks); }

        let mark_duration = duration;
        let lag_array = [];

        for(let i=0; i < marks.length; i++) {
            if(order === 'together') {
                lag_array[i] = 0;
            }
            else if((order === 'one-by-one-clockwise') || (order === 'level-by-level-clockwise')) {
                mark_duration = (duration - lag * (marks.length - 1)) / marks.length;
                lag_array[i] = i * (mark_duration + lag);
            }
            else if((order === 'one-by-one-anticlockwise') || (order === 'level-by-level-anticlockwise')) {
                mark_duration = (duration - lag * (marks.length - 1)) / marks.length;
                lag_array[i] = (marks.length - 1 - i) * (mark_duration + lag);
            }
        }

        utilities.setTimeout(function() {
            marks.forEach(function callback(value, index, array) {
                value.disappear(direction, mark_duration, lag_array[index]);

                /*
                addEventListener("segment-scale-mark-disappeared", function(e) {
                    if(marks.indexOf(e.detail.mark) >= 0) {
                        check_func(e.detail.mark);
                    }
                });
                */
            });
        }, delay * 1000);
    }

    function checkDisappearedMarks(mark) {
        if(this.marks.indexOf(mark) < 0) {
            return;
        }
        else {
            if(this.disappeared_marks.indexOf(mark) < 0) {
                this.disappeared_marks.push(mark);
            }

            let disappeared = true;
            let scale = this;

            this.marks.forEach(function(m) {
                if(scale.disappeared_marks.indexOf(m) < 0) {
                    disappeared = false;
                }
            });

            if(disappeared) {
                this.marks_visible = false;
                this.disappeared_marks.length = 0;
                this.in_progress = false;
                //dispatchEvent(new CustomEvent("segment-scale-disappeared", { detail : { scale : this } }));
                segmentScaleDisappeared();
            }
        };
    }

    function fadeIn(order, lag, duration, delay) {
        this.in_progress = true;

        this.faded_in_marks = [];

        let check_func = this.checkFadedInMarks.bind(this);

        let marks = this.marks.concat();
        if(order.startsWith('one-by-one')) { this.sortMarksByAngle(marks); }

        let mark_duration = duration;
        let lag_array = [];

        for(let i=0; i < marks.length; i++) {
            if(order === 'together') {
                lag_array[i] = 0;
            }
            else if((order === 'one-by-one-clockwise') || (order === 'level-by-level-clockwise')) {
                mark_duration = (duration - lag * (marks.length - 1)) / marks.length;
                lag_array[i] = i * (mark_duration + lag);
            }
            else if((order === 'one-by-one-anticlockwise') || (order === 'level-by-level-anticlockwise')) {
                mark_duration = (duration - lag * (marks.length - 1)) / marks.length;
                lag_array[i] = (marks.length - 1 - i) * (mark_duration + lag);
            }
        }

        utilities.setTimeout(function() {
            marks.forEach(function callback(value, index, array) {
                value.fadeIn(mark_duration, lag_array[index]);

                /*
                addEventListener("segment-scale-mark-faded-in", function(e) {
                    if(marks.indexOf(e.detail.mark) >= 0) {
                        check_func(e.detail.mark);
                    }
                });
                */
            });
        }, delay * 1000);
    }

    function checkFadedInMarks(mark) {
        if(this.marks.indexOf(mark) < 0) {
            return;
        }
        else {
            if(this.faded_in_marks.indexOf(mark) < 0) {
                this.faded_in_marks.push(mark);
            }

            let faded_in = true;
            let scale = this;

            this.marks.forEach(function(m) {
                if(scale.faded_in_marks.indexOf(m) < 0) {
                    faded_in = false;
                }
            });

            if(faded_in) {
                this.marks_visible = true;
                this.faded_in_marks = [];
                this.in_progress = false;
                //dispatchEvent(new CustomEvent("segment-scale-faded-in", { detail : { scale : this } }));
                segmentScaleFadedIn();
            }
        }
    }

    function fadeOut(order, lag, duration, delay) {
        this.in_progress = true;

        this.faded_out_marks = [];

        let check_func = this.checkFadedOutMarks.bind(this);

        let marks = this.marks.concat();
        if(order.startsWith('one-by-one')) { this.sortMarksByAngle(marks); }

        let mark_duration = duration;
        let lag_array = [];

        for(let i=0; i < marks.length; i++) {
            if(order === 'together') {
                lag_array[i] = 0;
            }
            else if((order === 'one-by-one-clockwise') || (order === 'level-by-level-clockwise')) {
                mark_duration = (duration - lag * (marks.length - 1)) / marks.length;
                lag_array[i] = i * (mark_duration + lag);
            }
            else if((order === 'one-by-one-anticlockwise') || (order === 'level-by-level-anticlockwise')) {
                mark_duration = (duration - lag * (marks.length - 1)) / marks.length;
                lag_array[i] = (marks.length - 1 - i) * (mark_duration + lag);
            }
        }

        utilities.setTimeout(function() {
            marks.forEach(function callback(value, index, array) {
                value.fadeOut(mark_duration, lag_array[index]);

                /*
                addEventListener("segment-scale-mark-faded-out", function(e) {
                    if(marks.indexOf(e.detail.mark) >= 0) {
                        check_func(e.detail.mark);
                    }
                });
                */
            });
        }, delay * 1000);
    }

    function checkFadedOutMarks(mark) {
        if(this.marks.indexOf(mark) < 0) {
            return;
        }
        else {
            if(this.faded_out_marks.indexOf(mark) < 0) {
                this.faded_out_marks.push(mark);
            }

            let faded_out = true;
            let scale = this;

            this.marks.forEach(function(d) {
                if(scale.faded_out_marks.indexOf(d) < 0) {
                    faded_out = false;
                }
            });

            if(faded_out) {
                this.marks_visible = false;
                this.faded_out_marks = [];
                this.in_progress = false;
                //dispatchEvent(new CustomEvent("segment-scale-faded-out", { detail : { scale : this } }));
                segmentScaleFadedOut();
            }
        }
    }

    /*
    SegmentScale.prototype.instanceCopy = function() {
        const copy = new this.constructor();
        const keys = Object.keys(this);
        keys.forEach(key => { copy[key] = this[key]; });
        return copy;
    };
    */
}
