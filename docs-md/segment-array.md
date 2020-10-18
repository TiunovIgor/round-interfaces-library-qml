<a href="../readme.html">Home</a> → Segment Array

***

# SegmentArray

## Contents
1. [Object description](#description)  
2. [Object dependencies](#dependencies)
3. [Object creation](#constructor)  
4. [Examples] (#examples)  
5. [Properties](#properties)  
6. [Methods](#methods)  
7. [Events](#events)  

##<a id="description"></a>Object description

Segment Array is an array of segments having the same center and located along an arc of a circle at the same distance from each other (Fig. 1).  

![SegmentArrayGeometry](../docs/images/segment_array_geometry.png)  
Fig. 1 - Segment Array Geometry.

R - inner radius of array elements.  
α - array element angle.  
β - angle between array elements.  

##<a id="dependencies"></a>Object dependencies  
The following scripts should be included in the \<head> section:  

* segment.js  
* segment-gradient.js  
* utilities.js  

##<a id="constructor"></a>Object creation  
To create an object, the main parameters are passed to the constructor function. These parameters are used to create the base segment:  
>
*id* - segment array identificator as a text string.  
*context* - CanvasRenderingContext2D for drawing a segment array.  
*cx* - X coordinate of the base segment center.  
*cy* - Y coordinate of the base segment center.  
*r_in* - base segment inner radius.  
*thickness* - thickness of the base segment.  
*init_angle* - the initial angle of the base segment in degrees. May take negative values. 
*angle* - angle of the base segment in degrees.  

##<a id="examples"></a>Examples  
<a href="../examples/segment-array-examples.html" target="_blank">Examples</a> of using various properties and methods of the object.  

##<a id="properties"></a>Properties

### Base Segment Style  
>
*gradient* - base segment fill gradient. Type of value is <a href="segment-gradient.html">SegmentGradient</a>.   
*background* - base segment fill color (applies if fill gradient is not specified).  
*border_width* - base segment border width.  
*border_color* - base segment border color.  

The borders of the base segment can be set separately using direct access to the base segment through the *base_segment* property.  

### Array Segments Parameters  
>
*segments_count* - the number of segments-elements of the array.  
*segment_angle* - array segment angle (ignored if *proportional* flag is set in *true*).  
*segment_thickness* - array segment thickness.  
*segment_position* - array segments position. Valid values:  
>> _"inner"_ - adjoining the inner border of the base segment.  
>> _"middle"_ - location in the middle of the base segment.  
>> _"outer"_ - adjoining the outer border of the base segment.  
>
*segment_r_in* - array segment inner radius. Ignored if property *segment_position* is set.  
*start_with* - start placing objects on the base segment with segment or with empty space. Valid values:  
>> _"segment"_ - start with segment.  
>> _"space"_ - start with empty space.  

### Array Segments Style
> *segment_gradient* - array segments fill gradient. Type of value is <a href="segment-gradient.html">SegmentGradient</a>.  
> *segment_background* - array segments fill color (applies if fill gradient is not specified).  
> *segment_border_width* - array segments border width.  
> *segment_border_color* - array segments border color.  

### Segment Array Flags
>
*proportional* - value *true* provides the same angles for array segments and the distance between them.  
*full_thickness* - value *true* provides the same thickness of array segments and base segment.  
*visible* - value *true* ensures object visibility.  
*segments_visible* - value *true* ensures array segments visibility.  
*in_progress* - flag takes the value *true* during the animation.  

##<a id="methods"></a>Methods

> *build()* - performs basic calculations of the shape and style of the base segment and array elements, taking into account the specified properties and flags.  

> *draw()* - draws an object.  

> *instanceCopy()* - creates an independent copy of the object.  

### Segment Array Animation

Segment Array animation is various changes in the shape, position, or style of the array segments over time.  

Key animation parameters:  
> *duration* - animation duration. Sets in seconds.  
> *delay* - delay before the start of the animation. Sets in seconds.  
> *direction* - animation direction. Valid values ​​depend on the type of animation.  
> *order* - animation order. Valid values:  
>> _"together"_.  
>> _"one-by-one-clockwise"_.  
>> _"one-by-one-anticlockwise"_.  
>> In case of *one-by-one* order the *duration* will be divided evenly between the array elements, taking into account the *lag* between animation of array elements.  

> *lag* - lag between animation of array elements. Sets in seconds.  

#### Animation Methods

> *appear(order, lag, direction, duration, delay)* - appearance of the array segments due to a gradual change in their shape.  
>> The *direction* parameter can take values ​​that are valid for a similar method of <a href="segment.html">Segment</a>.  
>> If all array segments appear, then the event *segment-array-appeared* dispatches.  

> *disappear(direction, duration, delay)* - disappearance of the array segments due to a gradual change in their shape.  
>> The *direction* parameter can take values ​​that are valid for a similar method of <a href="segment.html">Segment</a>.  
>> If all array segments appear, then the event *segment-array-disappeared* dispatches.

> *fadeIn(order, lag, duration, delay)* - gradual appearance of the array segments due to a change in their transparency.  
>> If all array segments appear using fading, then the event *segment-array-faded-in* dispatches.  

> *fadeOut(order, lag, duration, delay)* - gradual disappearance of the array segments due to a change in their transparency.
>> If all array segments disappear using fading, then the event *segment-array-faded-out* dispatches.  

##<a id="events"></a>Events

Events triggered by a SegmentArray are implemented using a CustomEvent.  
In the *detail.array* field, a link to the object itself is passed.  

> *segment-array-changed* - event dispatches if one of the array elements or the base segment is changed.  

> *segment-array-appeared*  
> *segment-array-disappeared*    
> *segment-array-faded-in*  
> *segment-array-faded-out*  

***

<a href="../readme.html">Home</a> → Segment Array  