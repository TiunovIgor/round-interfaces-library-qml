import QtQuick 2.0

Item {
    //this.id = id; // Object identificator
    property string name
    property var context // CanvasRenderingContext2D for drawing a segment array
    property double cx // X coordinate of the base segment center
    property double cy // Y coordinate of the base segment center
    property double r_in: 0 // base segment inner radius
    property double thickness // initial angle of the base segment
    property double r_out: thickness // base segment outer radius
    property double init_angle: -90 // initial angle of the base segment
    property double angle: 360 // angle of the base segment

    property SegmentGrid grid: null

    property SegmentGradient gradient: null
    property string background: "black"
    property double border_width: 1
    property string border_color: "rgba(32, 81, 0, 1)"

    property Segment locator: null
    property double locator_angle: 40
    property double locator_period: 5
    property SegmentGradient locator_gradient: null
    property string locator_background: 'rgba(0, 0, 0, 0)'
    property double locator_border_width: 1
    property string locator_border_color: 'none'

    property Segment frame: null
    property SegmentGradient frame_gradient: null
    property string frame_background: "rgba(0, 0, 0, 0)"
    property double frame_border_width: 0
    property string frame_border_color: 'rgba(50, 50, 50, 1)'

    property double factor: 0.2

    property var targets: []

    property var dots: []
    property double dot_radius: 5
    property SegmentGradient dot_gradient: null
    property string dot_background: 'rgba(100, 100, 100, 1)'
    property double dot_border_width: 1
    property string dot_border_color: 'black'

    property bool targets_visible: true
    property bool locator_enabled: false
    property bool in_progress: false

    property var appeared_segments: []
    property var disappeared_segments: []
    property var faded_in_segments: []
    property var faded_out_segments: []

    signal segmentRadarChanged;
    signal segmentRadarTargetsChanged;

    Component.onCompleted: {
        this.build();
        this.calc();
    }

    function build() {
        this.targets = [];

        //this.grid = new SegmentGrid(this.id + '_grid', this.context, this.cx, this.cy, this.r_in, this.thickness, this.init_angle, this.angle);

        let grid_component = Qt.createComponent("SegmentGrid.qml");
        this.grid = grid_component.createObject(this, {
             id: this.id + '_grid', context: this.context, cx: this.cx, cy: this.cy,
             r_in: this.r_in, thickness: this.thickness, init_angle: this.init_angle, angle: this.angle });

        if(this.gradient) { this.grid.gradient = this.gradient.instanceCopy(); }
        this.grid.background = this.background;
        this.grid.border_width = this.border_width;
        this.grid.border_color = this.border_color;
        this.grid.build();
        this.grid.calc();

        //this.frame = new Segment(this.id + '-frame', this.context, this.cx, this.cy, this.thickness, this.thickness * 0.1, this.init_angle, this.angle);

        let segment_component = Qt.createComponent("Segment.qml");
        this.frame = segment_component.createObject(this, {
             id: this.id + '-frame', context: this.context, cx: this.cx, cy: this.cy,
             r_in: this.thickness, thickness: this.thickness * 0.1, init_angle: this.init_angle, angle: this.angle });

        if(this.frame_gradient) { this.frame.gradient = this.frame_gradient.instanceCopy(); }
        this.frame.background = this.frame_background;
        this.frame.border_width = this.frame_border_width;
        this.frame.border_color = this.frame_border_color;
        this.frame.calc();

        let locator_thickness = this.thickness - this.border_width;

        //this.locator = new Segment(this.id + '_locator', this.context, this.cx, this.cy, this.r_in, locator_thickness, this.init_angle, this.locator_angle);

        this.locator = segment_component.createObject(this, {
             id: this.id + '-locator', context: this.context, cx: this.cx, cy: this.cy,
             r_in: this.r_in, thickness: locator_thickness, init_angle: this.init_angle, angle: this.locator_angle });

        if(this.locator_gradient) { this.locator.gradient = this.locator_gradient.instanceCopy(); }
        this.locator.background = this.locator_background;
        this.locator.border_width = this.locator_border_width;
        this.locator.border_color = this.locator_border_color;
        this.locator.calc();

        let radar = this;

        this.grid.segmentChanged.connect(segmentRadarChanged);
        this.frame.segmentChanged.connect(segmentRadarChanged);
        this.locator.segmentChanged.connect(segmentRadarChanged);
        this.locator.segmentRotated.connect(function() { rotateLocator(); });

        this.dots.forEach(function(dot) {
            dot.segmentDotChanged.connect(segmentRadarChanged);
        });

        this.segmentRadarTargetsChanged.connect(segmentRadarChanged);

        /*
        addEventListener("segment-changed", function(e) {
            if(e.detail.segment === radar.grid || e.detail.segment === radar.frame || e.detail.segment === radar.locator) {
                dispatchEvent(new CustomEvent("segment-radar-changed", { detail : { radar : radar } } ));
            }
        });

        addEventListener("segment-dot-changed", function(e) {
            if(radar.dots.indexOf(e.detail.dot) >= 0) {
                dispatchEvent(new CustomEvent("segment-radar-changed", { detail : { radar : radar } } ));
            }
        });

        addEventListener('segment-radar-targets-changed', function(e) {
            if(e.detail.radar === radar) {
                dispatchEvent(new CustomEvent('segment-radar-changed', { detail : { radar : radar } } ));
            }
        });

        addEventListener("segment-rotated", function(e) {
            if(e.detail.segment === radar.locator) {
                radar.rotateLocator();
            }
        });
        */
    }

    function calc() {
        if(this.in_progress) {
            /*
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

        //dispatchEvent(new CustomEvent("segment-radar-changed", { detail : { array : this } } ));
        segmentRadarChanged();
    }

    function startLocator() {
        if(!this.locator_enabled) {
            this.locator_enabled = true;
            this.rotateLocator();
        }
    }

    function rotateLocator() {
        if(this.locator_enabled) {
            this.locator.rotate('clockwise', this.angle, this.locator_period, 0);
        }
    }

    function stopLocator() {
        this.locator_enabled = false;
    }

    function targetsToDots(targets) {
        let radar = this;
        this.dots = [];

        if(targets.length > 0) {
            targets.forEach(function(target) {
                let x = target.x * radar.factor + radar.cx;
                let y = target.y * radar.factor + radar.cy;

                //let dot = new SegmentDot(target.id, radar.context, x, y, radar.dot_radius);
                let dot_component = Qt.createComponent('SegmentDot.qml');
                let dot = dot_component.createObject(radar, { id: target.id, context: radar.context, cx: x, cy: y, r: radar.dot_radius });

                if(radar.dot_gradient) { dot.gradient = radar.dot_gradient.instanceCopy(); }
                dot.background = radar.dot_background;
                dot.border_width = radar.dot_border_width;
                dot.border_color = radar.dot_border_color;
                dot.visible = true;
                dot.calc();
                radar.dots.push(dot);
            });
        }

        //dispatchEvent(new CustomEvent('segment-radar-targets-changed', { detail : { radar : radar } }));
        segmentRadarTargetsChanged();
    }

    function draw() {
        this.grid.draw();
        this.frame.draw();

        this.dots.forEach(function(dot) {
            dot.draw();
        });

        this.locator.draw();
    }

    /*
    SegmentRadar.prototype.instanceCopy = function() {
        const copy = new this.constructor();
        const keys = Object.keys(this);
        keys.forEach(key => { copy[key] = this[key]; });
        return copy;
    };
    */
}
