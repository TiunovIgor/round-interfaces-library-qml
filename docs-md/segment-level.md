<a href="../readme.html">Home</a> → Segment Level

***

# SegmentLevel

## Contents
1. [Object description](#description)  
2. [Object dependencies](#dependencies)
3. [Object creation](#constructor)  
4. [Examples] (#examples)  
5. [Properties](#properties)  
6. [Methods](#methods)  
7. [Events](#events)  

##<a id="description"></a>Object description

Segment Level is a set of segments combined for joint management and animation. (fig. 1).

![SegmentLevel](../docs/images/segment_level.png)  
Fig. 1 - Segment Level

##<a id="dependencies"></a>Object dependencies  
The following scripts should be included in the \<head> section:  

* segment.js  
* segment-gradient.js  
* utilities.js  

##<a id="constructor"></a>Object creation 
To create an object, the main parameters are passed to the constructor function:   
>
*id* - segment level identificator as a text string.  
*context* - CanvasRenderingContext2D for drawing a segment level.  
*cx* - X coordinate of the segment level reference point.  
*cy* - Y coordinate of the segment level reference point.  
*r_in* - conditional inner radius. Outer and inner Radii of level segments can be different.  

##<a id="examples"></a>Examples  
<a href="../examples/segment-level-examples.html" target="_blank">Examples</a> of using various properties and methods of the object.  

##<a id="properties"></a>Properties

### Segment Level Flags
>
*visible* - value *true* ensures object visibility.  
*segments_visible* - value *true* ensures level segments visibility.  
*in_progress* - flag takes the value *true* during the animation.  

##<a id="methods"></a>Methods

> *addSegment(segment)* - adds *segment* to the list of level segments.  

> *removeSegment(segment)* - removes *segment* from the list of level segments.  

> *build* - used when you need to dispatch *segment-level-changed* event for level segments redrawing.  

> *draw()* - level rendering method. Calls the .draw() method for each object from the list of level segments.

> *instanceCopy()* - creates an independent copy of the object.

### Segment Level Animation

Segment level animation is various changes in the shape, position, or style of the level segments over time.  

> *duration* - animation duration. Sets in seconds.  
> *delay* - delay before the start of the animation. Sets in seconds.  
> *direction* - animation direction. Valid values ​​depend on the type of animation.  
> *order* - animation order. Valid values:  
>> _"together"_.  
>> _"one-by-one-clockwise"_.  
>> _"one-by-one-anticlockwise"_.  
>> In case of *one-by-one* order the *duration* will be divided evenly between the level elements, taking into account the *lag* between animation of level elements.  

> *lag* - lag between animation of level elements. Sets in seconds.  

#### Animation Methods

> *appear(order, lag, direction, duration, delay)* - appearance of the level segments due to a gradual change in their shape.  
>> The *direction* parameter can take values ​​that are valid for a similar method of <a href="segment.html">Segment</a>.  
>> If all level segments appear, then the event *segment-level-appeared* dispatches.  

> *disappear(direction, duration, delay)* - disappearance of the level segments due to a gradual change in their shape.  
>> The *direction* parameter can take values ​​that are valid for a similar method of <a href="segment.html">Segment</a>.  
>> If all level segments appear, then the event *segment-level-disappeared* dispatches.

> *rotate(order, lag, direction, angle, duration, delay)* - rotation of the level segments.  
>> The *angle* of rotation is set in degrees.  

>> Valid values ​​for the *direction*:  
>> _"clockwise"_ - clockwise rotation.  
>> _"anticlockwise"_ - anticlockwise rotation.  
>> If all level segments rotate, then the event *segment-level-rotated* dispatches.  

> *fadeIn(order, lag, duration, delay)* - gradual appearance of the level segments due to a change in their transparency.  
>> If all level segments appear using fading, then the event *segment-level-faded-in* dispatches.  

> *fadeOut(order, lag, duration, delay)* - gradual disappearance of the level segments due to a change in their transparency.
>> If all level segments disappear using fading, then the event *segment-level-faded-out* dispatches.  

##<a id="events"></a>Events

Events triggered by a SegmentLevel are implemented using a CustomEvent.  
In the *detail.level* field, a link to the object itself is passed.  

> *segment-level-appeared*  
> *segment-level-disappeared*  
> *segment-level-rotated*  
> *segment-level-faded-in*  
> *segment-level-faded-out*  

***

<a href="../readme.html">Home</a> → Segment Level  