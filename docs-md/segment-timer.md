<a href="../readme.html">Home</a> → Segment Timer  

***

# SegmentTimer

## Contents
1. [Object description](#description)  
2. [Object dependencies](#dependencies)
3. [Object creation](#constructor)  
4. [Examples] (#examples)  
5. [Properties](#properties)  
6. [Methods](#methods)  
7. [Events](#events)  

##<a id="description"></a>Object description  

Timer is a control that emits a specific signal after a specified period of time (Fig. 1).

![SegmentTimer](../docs/images/segment_timer.png)  
Fig. 1 - Timer with progress bar in the form of a segment  

##<a id="dependencies"></a>Object dependencies  
The SegmentTimer object is inherited from the SegmentProgressBar object.  
The following scripts should be included in the \<head> section:  

* segment.js  
* segment-progress-bar.js  
* segment-gradient.js  
* utilities.js  

##<a id="constructor"></a>Object creation  
To create an object, the main parameters are passed to the constructor function:  
>
*id* - timer identificator as a text string.  
*context* - CanvasRenderingContext2D for drawing a timer.  
*cx* - X coordinate of the base segment center.  
*cy* - Y coordinate of the base segment center.  
*r_in* - base segment inner radius.  
*thickness* - thickness of the base segment.  
*init_angle* - the initial angle of the base segment in degrees. May take negative values.  
*angle* - angle of the base segment in degrees.  

The outer radius of the base segment *r_out* will be calculated automatically during the creation of the object.  

##<a id="examples"></a>Examples  
<a href="../examples/round-timer-examples.html" target="_blank">Examples</a> of using various properties and methods of the object.  

##<a id="properties"></a>Properties
The SegmentTimer object inherits the properties of the SegmentProgressBar object and has its own properties:  
>
*on_pause_text* - text in the pause mode.  
*on_pause_font* - text font in the pause mode.  

### Object Flags  
The SegmentTimer object inherits the flags of the SegmentProgressBar object and has its own flags:  
>
*on_pause* - pause mode. Value *true* means pause is on. Value *false* means pause is off.  

##<a id="methods"></a>Methods  

> *build()* - performs basic calculations of the shape and style of object, taking into account the specified properties and flags.  

> *draw()* - draws an object.  

> *instanceCopy()* - creates an independent copy of the object.  

> *countdown(new_value, value, delay)* - countdown function from *value* to *new_value* after *delay*.  

> *start()* - start timer to start countdown or continue countdown after pause.  

> *pause()* - turns on pause mode.  

> *stop()* - stops and resets timer.  

##<a id="events"></a>Events  

Events triggered by a SegmentTimer are implemented using a CustomEvent.  
In the *detail.timer* field, a link to the object itself is passed.  

> *segment-array-timer-changed* - state of the object is changed.  
> *segment-array-timer-is-up* - signal of the end of the specified time period.  

***

<a href="../readme.html">Home</a> → Segment Timer  