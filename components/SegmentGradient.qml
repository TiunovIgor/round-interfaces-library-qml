import QtQuick 2.0

import "../components"

Item {
    property string type;
    property string direction;
    property string stops_string;
    property var stops: [];

    property string name;

    property int resolution: 4;

    Utilities { id: utilities; }

    function parseStopsString() {
        this.stops = [];

        if(this.stops_string !== '' && this.stops_string !== undefined) {
            let regexp = /,(?![^\(]*\)) /;
            let stops_array = this.stops_string.split(regexp);

            for(let i=0; i < stops_array.length; i++) {
                let newregexp = /\s(?![^\(]*\))/;
                let stop = stops_array[i].split(newregexp);

                if(stop[1].indexOf('%') > 0) {
                    stop[1] = stop[1].replace('%', '') / 100;
                }

                //console.log(utilities.rgbaStrFromColor(stop[0]));

                this.stops.push({ 'color' : stop[0], 'offset' : stop[1] });
            }
        }
    }

    function fade(f) {
        this.parseStopsString();

        for(let i=0; i < this.stops.length; i++) {
            let new_color = utilities.rgbaStrToObj(utilities.rgbaStrFromColor(this.stops[i].color));
            new_color.a = new_color.a * f;
            this.stops[i].color = utilities.rgbaObjToStr(new_color);
        }
    }

    function getImageDataByArcLength(arc_length) {
        aCanvas.width = arc_length;
        aCanvas.height = 1;
        let context = aCanvas.getContext('2d');

        let gradient = context.createLinearGradient(0, 0, arc_length, 0);

        for(let i=0; i < this.stops.length; i++) {
            gradient.addColorStop(this.stops[i].offset, this.stops[i].color);
            //console.log('getImageDataByArcLength offset: ' + this.stops[i].offset + ' ; color: ' + this.stops[i].color);
        }

        context.fillStyle = gradient;
        context.fillRect(0, 0, arc_length, 1);

        let img_data = context.getImageData(0, 0, arc_length, 1);

        context.clearRect(0, 0, arc_length, 1);

        return img_data;
    }

    Component.onCompleted: {
        this.parseStopsString();
    }

    function deepCopy(obj, copy) {
        //var c = c || {};
        //let p = obj.children;
        for(var key in obj) {
            let prop;
            if(typeof obj[key] === 'object') {
                if(Array.isArray(obj[key])) { prop = []; }
                else prop = {};
                deepCopy(obj[key], prop);
            } else {
                copy[key] = obj[key];
                //console.log('deepCopy: ' + prop);
            }
        }
        return copy;

        /*
        var getKeys = function(obj){
           var keys = [];
           for(var key in obj){
              keys.push(key);
           }
           return keys;
        }
        */
    }

    function instanceCopy() {

        /*
        let gradient_component = Qt.createComponent("SegmentGradient.qml");
        let copy = gradient_component.createObject(this, { type: this.type, direction: this.direction, stops_string: this.stops_string } );
        */

        /*
        let copy = Qt.createQmlObject('import "../components"; SegmentGradient { type: "' + this.type + '"; direction: "' + this.direction + '";
             stops_string: "' + this.stops_string + '" }', this, "grad_1");
        */

        /*
        deepCopy(this, copy);
        copy.parseStopsString();

        return copy;
        */
        return this;
    }
}
