<a href="../readme.html">Home</a> → Segment Knob

***

# SegmentKnob

## Contents
1. [Object description](#description)  
2. [Object dependencies](#dependencies)
3. [Object creation](#constructor)  
4. [Examples] (#examples)  
5. [Properties](#properties)  
6. [Methods](#methods)  
7. [Events](#events)  

##<a id="description"></a>Object description  

Knob is a rotary control for changing any value (Fig. 1).

![SegmentKnob](../docs/images/segment_knob.png)  
Рис. 1 - Knob

##<a id="dependencies"></a>Object dependencies  
The following scripts should be included in the \<head> section:  

* segment.js  
* segment-dot.js  
* segment-scale-mark.js  
* segment-gradient.js  
* utilities.js  

##<a id="constructor"></a>Object creation  
To create an object, the main parameters are passed to the constructor function:  
>
*id* - knob identificator as a text string.  
*context* - CanvasRenderingContext2D for drawing the knob.  
*cx* - X coordinate of the base segment.  
*cy* - Y coordinate of the base segment.  
*r_in* - inner base segment radius.  
*thickness* - thickness of the base segment.  
*init_angle* - the initial angle of the base segment in degrees. May take negative values.  
*angle* - angle of the base segment in degrees.  

The outer radius of the base segment *r_out* will be calculated automatically during the creation of the object.  

The object will take the form of a ring if you set the *angle* of the segment to a multiple of 360 degrees.  
The object will take the form of a circle segment if the inner radius *r_in* is set to 0.  
The object will take the form of a circle if both of these conditions are met.  

##<a id="examples"></a>Examples  
<a href="../examples/round-volume-control-examples.html" target="_blank">Examples</a> of using various properties and methods of the object.  

##<a id="properties"></a>Properties

SegmentKnob is a composite object. It includes:  
>
*base_segment* - segment that defines the base of the knob.  
Also, the knob has a notch that indicates the current value of the changing parameter.  
Valid *notch type* values:  
>> *dot* - <a href="segment-dot.html">SegmentDot</a>.  
>> *mark* - <a href="segment-scale-mark.html">SegmentScaleMark</a>.  

The notch has the following general parameters:  
>
*notch_type*.  
*notch_init_angle* - the initial angle of the notch relative to the base segment. It defaults to half the angle of the base segment.  
*notch_min_angle* - minimum notch angle.  
*notch_max_angle* - maximum notch angle.  
*notch_angle* - current notch angle.  
*notch_width* - width of *dot* border, or width of *mark*.  
*notch_color* - color of *dot* border, or color of *mark*.  

The following parameters can be specified for the *dot* notch:  
> *dot_radius*.  
> *dot_base_radius*.  
> *dot_gradient*.  
> *dot_background*.  

The following parameters can be specified for the *mark* notch:  
> *mark_r_in*.  
> *mark_length*.  

### Base Segment Style  
>
*gradient* - base segment fill gradient. Type of value is <a href="segment-gradient.html">SegmentGradient</a>.   
*background* - base segment fill color (applies if fill gradient is not specified).  
*border_width* - base segment border width.  
*border_color* - base segment border color.  

### Object Flags  
>
*visible* - value *true* ensures object visibility.  
*notch_visible* - value *true* ensures notch visibility.  
*in_progress* - flag takes the value *true* during the animation.  
*is_active* - flag takes the value *true* during grabbing and rotating the knob.  

##<a id="methods"></a>Methods  

> *build()* - performs basic calculations of the shape and style of object, taking into account the specified properties and flags.  

> *calcBorder()* -  computes base segment borders styles. Called automatically from *calc()* method.  

> *draw()* - draws an object.  

> *instanceCopy()* - creates an independent copy of the object.  

> *isPointInside(x, y)* - function for checking whether a point with coordinates (x,y) belongs to a figure.  

> *setNotchAngle(angle)* - changes the position of the knob to bring the notch to the *angle*.  

> *catchKnob(e)* - grabbing the knob by left clicking on it.  
>>
The method is set as a listener for the *mousedown* event on the canvas.  
The listener is available through the *mousedown* parameter to ensure that it can be removed.  
Removing and redefining a listener is necessary in compound objects (for example, a volume control).  

> *rotateKnobByMouseMovement(e)* - rotating the grabbed knob by mouse move.  
>>
The method is set as a listener for the *mousemove* event on the canvas.  
The listener is available through the *mousemove* parameter to ensure that it can be removed.  
Removing and redefining a listener is necessary in compound objects.  

> *rotateKnobByMouseWheel(e)* - rotating the grabbed knob by mouse wheel.  
>>
The method is set as a listener for the *wheel* event on the canvas.  
The listener is available through the *wheel* parameter to ensure that it can be removed.  
Removing and redefining a listener is necessary in compound objects.  

> *releaseKnob()* - the grabbed knob is released by releasing the left mouse button.  
>>
The method is set as a listeners for the *mouseup* and *mouseout* events on the canvas.  
The listeners are available through the *mouseup* and *mouseout* parameters to ensure that it can be removed.  
Removing and redefining a listener is necessary in compound objects.  

##<a id="events"></a>Events  

Events triggered by a SegmentKnob are implemented using a CustomEvent.  
In the *detail.knob* field, a link to the object itself is passed.  

> *segment-knob-changed* - state of the object is changed.  

***

<a href="../readme.html">Home</a> → Segment Knob
