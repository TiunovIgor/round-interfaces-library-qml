<a href="../readme.html">Home</a> → Segment Equalizer  

***

# SegmentEqualizer

## Contents
1. [Object description](#description)  
2. [Object dependencies](#dependencies)
3. [Object creation](#constructor)  
4. [Examples] (#examples)  
5. [Properties](#properties)  
6. [Methods](#methods)  
7. [Events](#events)  

##<a id="description"></a>Object description

Equalizer is a graphic element for visualizing the signal amplitude depending on the frequency characteristics (Fig. 1).

![SegmentEqualizer](../docs/images/segment_equalizer.png)  
Fig. 1 - Segment Equalizer.  

##<a id="dependencies"></a>Object dependencies  
The following scripts should be included in the \<head> section:  

* segment.js  
* segment-gradient.js  
* utilities.js  

##<a id="constructor"></a>Object creation  
To create an object, the main parameters are passed to the constructor function. These parameters are used to create the base segment:  
>
*id* - equalizer identificator as a text string.  
*context* - CanvasRenderingContext2D for drawing the equalizer.  
*cx* - X coordinate of the base segment center.  
*cy* - Y coordinate of the base segment center.  
*r_in* - base segment inner radius.  
*thickness* - thickness of the base segment.  
*init_angle* - the initial angle of the base segment in degrees. May take negative values. 
*angle* - angle of the base segment in degrees.  

##<a id="examples"></a>Examples  
<a href="../examples/round-equalizer-examples.html" target="_blank">Examples</a> of using various properties and methods of the object.  

##<a id="properties"></a>Properties
>
*values* - array of coefficients in the range \[-1;1] which determining the waveform.  
For visualization of the waveform, coefficients are applied to the thickness of the array segments.  

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

### Object Flags
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

> *changeValues(values, speed, delay)* - function of applying new coefficients *values*, defining the waveform, with *speed* after *delay*.  

##<a id="events"></a>Events

Events triggered by a SegmentEqualizer are implemented using a CustomEvent.  
In the *detail.equalizer* field, a link to the object itself is passed.  

> *segment-equalizer-changed* - object is changed.  

***

<a href="../readme.html">Home</a> → Segment Equalizer  