<a href="../readme.html">Home</a> → Segment Scale Sign

***

# SegmentScaleSign

## Contents
1. [Object description](#description)  
2. [Object dependencies](#dependencies)  
3. [Object creation](#constructor)  
4. [Properties](#properties)  
5. [Methods](#methods)  
6. [Events](#events)  

##<a id="description"></a>Object description

Segment Scale Sign is a sign on the segment scale corresponding to a certain measured value (Fig. 1).  
SegmentScaleSign is an auxilary class of the round interfaces library for implementing a round scale.  

![SegmentScaleSign](../docs/images/segment_scale_sign.png)  
Fig. 1 - Segment Scale Sign

##<a id="dependencies"></a>Object dependencies  
The following scripts should be included in the \<head> section:  

* utilities.js  

##<a id="constructor"></a>Object creation  
To create an object, the main parameters are passed to the constructor function:   
>
*id* - sign identificator as a text string.  
*context* - CanvasRenderingContext2D for drawing a sign.  
*cx* - X coordinate of the segment scale center.  
*cy* - Y coordinate of the segment scale center.  
*r_in* - sign inner radius.  
*text* - sign text.  
*angle* - angle of the sign in degrees.  

##<a id="properties"></a>Properties

### Sign Style  
>
*font*.  
*text_color*.  
*text_border_width*.  
*text_border_color*.  
*text_direction*.  
>> Valid *text_direction* values:  
>> _"vertical"_.  
>> _"clockwise"_.  
>> _"anticlockwise"_.  
>> _"from-center"_.  
>> _"to-center"_.  

### Sign Flags  
>
*visible* - flag ensures the visibility of the object if set in *true*.  
*in_progress* - flag takes the value *true* during the animation.  

##<a id="methods"></a>Methods

> *calc()* - performs basic calculations of the shape and style of a mark when it is created, changed and during animation.  
This method should be called after changing the properties of the object so that they take effect.  

> *draw()* - draws an object.  

> *instanceCopy()* - creates an independent copy of the object.  

### Sign Animation

Sign animation is various changes in the shape, position, or style of the sign over time.  

Key animation parameters:  
> *duration* - animation duration. Sets in seconds.  
> *delay* - delay before the start of the animation. Sets in seconds.  
> *direction* - animation direction. Valid values ​​depend on the type of animation.  

#### Animation Methods

> *appear(direction, duration, delay)* - the appearance of a sign due to a gradual change in its shape.  
>> Valid values ​​for the *direction*:  
>> _"from-center"_ - from scale center.  
>> _"to-center"_ - to scale center.  

> *disappear(direction, duration, delay)* - the disappearance of a sign due to a gradual change in its shape.  
>> Valid values ​​for the *direction*:  
>> _"from-center"_ - from scale center.  
>> _"to-center"_ - to scale center.  

> *fadeIn(duration, delay)* - gradual appearance of a sign due to a change in its transparency.  

> *fadeOut(duration, delay)* - gradual disappearance of a sign due to a change in its transparency.  

##<a id="events"></a>Events

Events triggered by a SegmentScaleSign are implemented using a CustomEvent.  
In the *detail.sign* field, a link to the object itself is passed.  

> *segment-scale-sign-changed* - event dispatches every time the *calc()* method is executed.  

> *segment-scale-sign-appeared*  
> *segment-scale-sign-disappeared*  
> *segment-scale-sign-faded-in*  
> *segment-scale-sign-faded-out*  

***

<a href="../readme.html">Home</a> → Segment Scale Sign  