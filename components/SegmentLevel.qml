import QtQuick 2.0

Item {
    //this.id = id; // Object identificator
    property string name
    property var context // CanvasRenderingContext2D for drawing a segment level
    property double cx // X coordinate of the segment level reference point
    property double cy // Y coordinate of the segment level reference point
    property double r_in // conditional inner radius

    property bool segments_visible: true
    property bool in_progress: false

    property var segments: []

    property var appeared_segments: []
    property var disappeared_segments: []
    property var rotated_segments: []
    property var faded_in_segments: []
    property var faded_out_segments: []

    signal segmentLevelChanged;
    signal segmentLevelAppeared;
    signal segmentLevelDisappeared;
    signal segmentLevelRotated;
    signal segmentLevelFadedIn;
    signal segmentLevelFadedOut;

    Utilities { id: utilities; }

    //let level = this;

    /*
    addEventListener("segment-changed", function(e) {
            if(level.segments.indexOf(e.detail.segment) >= 0) {
                dispatchEvent(new CustomEvent("segment-level-changed", { detail : { level : level } } ));
            }
        });
        */

    function build() {
        //dispatchEvent(new CustomEvent("segment-level-changed", { detail : { level : this } } ));
        segmentLevelChanged();

        this.segments.forEach(function(segment) {
            segment.segmentChanged.connect(segmentLevelChanged);
            segment.segmentAppeared.connect(function() {
                checkAppearedSegments(segment);
            });
            segment.segmentDisappeared.connect(function() {
                checkDisappearedSegments(segment);
            });
            segment.segmentRotated.connect(function() {
                checkRotatedSegments(segment);
            });
            segment.segmentFadedIn.connect(function() {
                checkFadedInSegments(segment);
            });
            segment.segmentFadedOut.connect(function() {
                checkFadedOutSegments(segment);
            });
        });
    }

    function draw() {
        if(this.visible) {
            this.segments.forEach(function(segment) { segment.draw(); } );
        }
    }

    function addSegment(segment) {
        this.segments.push(segment);
    }

    function removeSegment(segment) {
        let index = this.segments.indexOf(segment);
        if(index > -1) {
            this.segments.splice(index, 1);
        }
    }

    function appear(order, lag, direction, duration, delay) {
        this.in_progress = true;

        this.appeared_segments = [];

        let check_func = this.checkAppearedSegments.bind(this);

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
                //dispatchEvent(new CustomEvent("segment-level-appeared", { detail : { level : this } }));
                segmentLevelAppeared();
            }
        }
    }

    function disappear(order, lag, direction, duration, delay) {
        this.in_progress = true;

        this.disappeared_segments = [];

        let check_func = this.checkDisappearedSegments.bind(this);

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
                //dispatchEvent(new CustomEvent("segment-level-disappeared", { detail : { array : this } }));
                segmentLevelDisappeared();
            }
        };
    }

    function rotate(order, lag, direction, angle, duration, delay) {
        this.in_progress = true;

        this.rotated_segments = [];

        let check_func = this.checkRotatedSegments.bind(this);

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
                value.rotate(direction, angle, segment_duration, lag_array[index]);

                /*
                addEventListener("segment-rotated", function(e) {
                    if(segments.indexOf(e.detail.segment) >= 0) {
                        check_func(e.detail.segment);
                    }
                });
                */
            });
        }, delay * 1000);
    }

    function checkRotatedSegments(segment) {
        if(this.segments.indexOf(segment) < 0) {
            return;
        }
        else {
            if(this.rotated_segments.indexOf(segment) < 0) {
                this.rotated_segments.push(segment);
            }

            let rotated = true;
            let array = this;

            this.segments.forEach(function(seg) {
                if(array.rotated_segments.indexOf(seg) < 0) {
                    rotated = false;
                }
            });

            if(rotated) {
                this.segments_visible = true;
                this.rotated_segments.length = 0;
                this.in_progress = false;
                //dispatchEvent(new CustomEvent("segment-level-rotated", { detail : { array : this } }));
                segmentLevelRotated();
            }
        };
    }

    function fadeIn(order, lag, duration, delay) {
        this.in_progress = true;

        this.faded_in_segments = [];

        let check_func = this.checkFadedInSegments.bind(this);

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
                //dispatchEvent(new CustomEvent("segment-level-faded-in", { detail : { level : this } }));
                segmentLevelFadedIn();
            }
        }
    }

    function fadeOut(order, lag, duration, delay) {
        this.in_progress = true;

        this.faded_out_segments = [];

        let check_func = this.checkFadedOutSegments.bind(this);

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
                //dispatchEvent(new CustomEvent("segment-level-faded-out", { detail : { level : this } }));
                segmentLevelFadedOut();
            }
        }
    }

    /*
    SegmentLevel.prototype.instanceCopy = function() {
        const copy = new this.constructor();
        const keys = Object.keys(this);
        keys.forEach(key => { copy[key] = this[key]; });
        return copy;
    };
    */
}
