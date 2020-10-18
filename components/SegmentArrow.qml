import QtQuick 2.0

Item {
    id: segmentArrow
    //this.id = id; // Object identificator
    property var context // CanvasRenderingContext2D for drawing a mark
    property double cx // X coordinate of the segment scale center
    property double cy // Y coordinate of the segment scale center
    property double length // arrow length
    property double angle // arrow angle

    //let arrow = this;

    property Image img: Image {
        onStatusChanged: {
            if(img.status == Image.Ready) { segmentArrow.calc(); }
        }
    };

    property string img_src: '../svg/arrow-one.svg'
    property double img_angle: -90
    property double img_offset_x: this.width / 2
    property double img_offset_y: 10

    property bool in_progress: false;

    property double dx1
    property double dy1
    property double dx2
    property double dy2
    property double a

    property double anim_dx1
    property double anim_dy1
    property double anim_dx2
    property double anim_dy2
    property double anim_a

    property double anim_width: 0
    property double anim_length: 0
    property double anim_angle: -90

    signal segmentArrowChanged;

    Component.onCompleted: {
        this.setImgSrc(this.img_src);
        this.calc();
    }

    // setImgSrc(this.img_src);

    // calc();

    function calc() {
        if(this.in_progress) {
            this.anim_a = this.anim_angle * Math.PI / 180;

            this.anim_dx1 = this.anim_r_in * Math.cos(this.anim_a) + this.cx; // First point. X coordinate
            this.anim_dy1 = this.anim_r_in * Math.sin(this.anim_a) + this.cy; // First point. Y coordinate
            this.anim_dx2 = this.anim_r_out * Math.cos(this.anim_a) + this.cx; // Second point. X coordinate
            this.anim_dy2 = this.anim_r_out * Math.sin(this.anim_a) + this.cy; // Second point. Y coordinate
        }
        else {
            //this.r_out = this.r_in + this.length;

            this.a = this.angle * Math.PI / 180;

            this.dx1 = this.r_in * Math.cos(this.a) + this.cx;
            this.dy1 = this.r_in * Math.sin(this.a) + this.cy;
            this.dx2 = this.r_out * Math.cos(this.a) + this.cx;
            this.dy2 = this.r_out * Math.sin(this.a) + this.cy;
        }

        //dispatchEvent(new CustomEvent("segment-arrow-changed", { detail : { arrow : this } } ));
        segmentArrowChanged();
    }

    function setImgSrc(src) {
        let arrow = this;        

        /*
        this.img.onload = function() {
            arrow.calc();
        };
        */

        this.img.source = src;
    }

    function draw() {
        if(this.visible) {
            let width;
            let length;
            let angle;

            if(this.in_progress) {
                width = this.anim_width;
                length = this.anim_length;
                angle = this.anim_angle;
            }
            else {
                width = this.width;
                length = this.length;
                angle = this.angle;
            }

            this.context.save();
            this.context.translate(this.cx, this.cy);
            this.context.rotate((angle - this.img_angle) * Math.PI / 180);
            this.context.drawImage(this.img, - this.img_offset_x, - length + this.img_offset_y, width, length);
            this.context.restore();
        }
    }

    function prepareAnim() {
        this.anim_width = this.width;
        this.anim_length = this.length;
        this.anim_angle = this.angle;
    }

    /*
    SegmentArrow.prototype.instanceCopy = function() {
        const copy = new this.constructor();
        const keys = Object.keys(this);
        keys.forEach(key => { copy[key] = this[key]; });
        return copy;
    };
    */
}
