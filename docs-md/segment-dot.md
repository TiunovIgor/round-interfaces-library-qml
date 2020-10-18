<a href="../readme.html">Home</a> → Segment Dot

***

# SegmentDot

## Contents
1. [Object description](#description)  
2. [Object dependencies](#dependencies)
3. [Object creation](#constructor)  
4. [Examples] (#examples)  
5. [Properties](#properties)  
6. [Methods](#methods)  
7. [Events](#events)  

##<a id="description"></a>Object description

Segment Dot is a round interface element represented as a circle.  
SegmentDot is an auxiliary class of the round interfaces library for implementing an array of dots.  

![SegmentDot](../docs/images/segment_dot.png)  
Fig. 1 - Dot  

##<a id="dependencies"></a>Object dependencies  
The following scripts should be included in the \<head> section:  

* segment-gradient.js  
* utilities.js  

##<a id="constructor"></a>Object creation  
To create an object, the main parameters are passed to the constructor function:   
>
*id* - dot identificator as a text string.  
*context* - CanvasRenderingContext2D for drawing a dot.  
*cx* - X coordinate of the dot center.  
*cy* - Y coordinate of the dot center.  
*r* - dot radius.  

##<a id="examples"></a>Examples  
<a href="../examples/segment-dot-examples.html" target="_blank">Examples</a> of using various properties and methods of the object.  

##<a id="properties"></a>Properties

### Dot Style
>
*gradient* - fill gradient. Type of value is <a href="segment-gradient.html">SegmentGradient</a>.

>Valid *direction* values for a Linear Gradient:  
>> _"to-left"_ - from right to left.  
>> _"to-right"_ - from left to right.  
>> _"to-bottom"_ - top down.  
>> _"to-top"_ - down up.

>Valid *direction* values for a Radial Gradient:  
>> _"from-center"_ - from dot center.  
>> _"to-center"_ - to dot center.  

>Valid *direction* values for a Conic Gradient:  
>> _"clockwise"_.  
>> _"anticlockwise"_.  

>
*background* - fill color (applies if fill gradient is not specified).  
*border_width* - dot border width.  
*border_color* - dot border color.  

### Dot Flags
>
*visible* - flag ensures the visibility of the object if set in *true*.  
*in_progress* - flag takes the value *true* during the animation.  

##<a id="methods"></a>Methods  

> *calc()* - performs basic calculations of the shape and style of a dot when it is created, changed and during animation.  
This method should be called after changing the properties of the object so that they take effect.  

> *draw()* - draws an object.  

> *instanceCopy()* - creates an independent copy of the object.

### Dot Animation

Dot animation is various changes in the shape, position, or style of the dot over time.  

Key animation parameters:  
> *duration* - animation duration. Sets in seconds.  
> *delay* - delay before the start of the animation. Sets in seconds.  
> *direction* - animation direction. Valid values ​​depend on the type of animation.  

#### Animation Methods

> *appear(direction, duration, delay)* - the appearance of a dot due to a gradual change in its shape.  
>> Valid values ​​for the *direction*:  
>> _"from-center"_ - from dot center.  

> *disappear(direction, duration, delay)* - the disappearance of a dot due to a gradual change in its shape.  
>> Valid values ​​for the *direction*:  
>> _"to-center"_ - to dot center.  

> *fadeIn(duration, delay)* - gradual appearance of a dot due to a change in its transparency.  

> *fadeOut(duration, delay)* - gradual disappearance of a dot due to a change in its transparency.  

##<a id="events"></a>Events

Events triggered by a SegmentDot are implemented using a CustomEvent.  
In the *detail.dot* field, a link to the object itself is passed.  

> *segment-changed* - event dispatches every time the *calc()* method is executed.  

> *segment-dot-appeared*  
> *segment-dot-disappeared*    
> *segment-dot-faded_in*  
> *segment-dot-faded_out*  

***

<a href="../readme.html">Home</a> → Segment Dot  