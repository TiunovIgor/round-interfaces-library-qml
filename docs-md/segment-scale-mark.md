<a href="../readme.html">Home</a> → Segment Scale Mark

***

# SegmentScaleMark

## Contents
1. [Object description](#description)  
2. [Object dependencies](#dependencies)  
3. [Object creation](#constructor)  
4. [Properties](#properties)  
5. [Methods](#methods)  
6. [Events](#events)  

##<a id="description"></a>Object description

Segment Scale Mark is a mark on the segment scale corresponding to a certain measured value (Fig. 1).  
SegmentScaleMark is an auxilary class of the round interfaces library for implementing a round scale.  

![SegmentScaleMark](../docs/images/segment_scale_mark.png)  
Fig. 1 - Segment Scale Mark

##<a id="dependencies"></a>Object dependencies  
The following scripts should be included in the \<head> section:  

* utilities.js  

##<a id="constructor"></a>Object creation  
To create an object, the main parameters are passed to the constructor function:   
>
*id* - mark identificator as a text string.  
*context* - CanvasRenderingContext2D for drawing a mark.  
*cx* - X coordinate of the segment scale center.  
*cy* - Y coordinate of the segment scale center.  
*r_in* - mark inner radius.  
*length* - mark length.  
*angle* - angle of the mark in degrees.  

The outer radius of the mark *r_out* will be calculated automatically during the creation of the object.  

##<a id="properties"></a>Properties

### Mark Style  
>
*width* - mark width.  
*color* - mark color.  

### Mark Flags  
>
*visible* - flag ensures the visibility of the object if set in *true*.  
*in_progress* - flag takes the value *true* during the animation.  

##<a id="methods"></a>Methods

> *calc()* - performs basic calculations of the shape and style of a mark when it is created, changed and during animation.  
This method should be called after changing the properties of the object so that they take effect.  

> *draw()* - draws an object.  

> *instanceCopy()* - creates an independent copy of the object.  

### Mark Animation

Mark animation is various changes in the shape, position, or style of the mark over time.  

Key animation parameters:  
> *duration* - animation duration. Sets in seconds.  
> *delay* - delay before the start of the animation. Sets in seconds.  
> *direction* - animation direction. Valid values ​​depend on the type of animation.  

#### Animation Methods

> *appear(direction, duration, delay)* - the appearance of a mark due to a gradual change in its shape.  
>> Valid values ​​for the *direction*:  
>> _"from-center"_ - from scale center.  
>> _"to-center"_ - to scale center.  
>> _"from-middle"_ - from middle of the mark.  

> *disappear(direction, duration, delay)* - the disappearance of a mark due to a gradual change in its shape.  
>> Valid values ​​for the *direction*:  
>> _"from-center"_ - from scale center.  
>> _"to-center"_ - to scale center.  
>> _"to-middle"_ - to middle of the mark.  

> *fadeIn(duration, delay)* - gradual appearance of a mark due to a change in its transparency.  

> *fadeOut(duration, delay)* - gradual disappearance of a mark due to a change in its transparency.  

##<a id="events"></a>Events

Events triggered by a SegmentScaleMark are implemented using a CustomEvent.  
In the *detail.mark* field, a link to the object itself is passed.  

> *segment-scale-mark-changed* - event dispatches every time the *calc()* method is executed.  

> *segment-scale-mark-appeared*  
> *segment-scale-mark-disappeared*  
> *segment-scale-mark-faded-in*  
> *segment-scale-mark-faded-out*  

***

<a href="../readme.html">Home</a> → Segment Scale Mark  