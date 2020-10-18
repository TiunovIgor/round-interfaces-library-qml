<a href="../readme.html">Home</a> → Segment Array Progress Bar

***

# SegmentArrayProgressBar

## Contents
1. [Object description](#description)  
2. [Object dependencies](#dependencies)
3. [Object creation](#constructor)  
4. [Examples] (#examples)  
5. [Properties](#properties)  
6. [Methods](#methods)  
7. [Events](#events)  

##<a id="description"></a>Object description  

Progress Bar is a graphic element for visualizing the degree of completion of a process (Fig. 1).  

![SegmentArrayProgressBar](../docs/images/segment_array_progress_bar.png)  
Fig. 1 - Progress bar in the form of segment array

##<a id="dependencies"></a>Object dependencies  
The following scripts should be included in the \<head> section:  

* segment.js  
* segment-gradient.js  
* utilities.js  

##<a id="constructor"></a>Object creation  
To create an object, the main parameters are passed to the constructor function:  
>
*id* - progress bar identificator as a text string.  
*context* - CanvasRenderingContext2D for drawing the progress bar.  
*cx* - X coordinate of the base segment center.  
*cy* - Y coordinate of the base segment center.  
*r_in* - base segment inner radius.  
*thickness* - thickness of the base segment.  
*init_angle* - the initial angle of the base segment in degrees. May take negative values.  
*angle* - angle of the base segment in degrees.  

The outer radius of the base segment *r_out* will be calculated automatically during the creation of the object.  

##<a id="examples"></a>Examples  
<a href="../examples/round-progress-bar-examples.html" target="_blank">Examples</a> of using various properties and methods of the object.  

##<a id="properties"></a>Properties
>
*min_value* - minimum value of progress.  
*max_value* - maximum value of progress.  
*value* - current value of progress.  
*speed* - speed of change of the progress indicator when it is programmatically changed.  
>
*active_index* - index of the last active segment of the progress bar.  

SegmentArrayProgressBar is a composite object. It includes:  
>
*base_segment* - base segment of the object.  
*segments* - array of segments visualizing progress.  

### Base Segment Style  
>
*gradient* - fill gradient. Type of value is <a href="segment-gradient.html">SegmentGradient</a>.  
*background* - fill color (applies if fill gradient is not specified).  
*border_width* - base segment border width.  
*border_color* - base segment border color.  

The borders of the base segment can be set separately using direct access to it through the *base_segment* property.  

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

### Array Active Segments Style
> *active_segment_gradient* - array active segments fill gradient. Type of value is <a href="segment-gradient.html">SegmentGradient</a>.  
> *active_segment_background* - array active segments fill color (applies if fill gradient is not specified).  
> *active_segment_border_width* - array active segments border width.  
> *active_segment_border_color* - array active segments border color.  

### Progress Bar Text Style  
In the center of the object is a text caption containing a numerical representation of the degree of completion of the process.  
The text of the label is formed from the *value* and *units* parameters.  
>
*font* - text font.  
*text_color* - text color.  
*text_border_width* - width of the text border.  
*text_border_color* - color of the text border.  
*units* - units of the *value*.  

### Object Flags  
>
*full_thickness* - value *true* provides the same thickness of array segments and base segment.  
*visible* - value *true* ensures object visibility.  
*segments_visible* - value *true* ensures array segments visibility.  
*in_progress* - flag takes the value *true* during the animation.  

##<a id="methods"></a>Methods  

> *build()* - performs basic calculations of the shape and style of object, taking into account the specified properties and flags.  

> *draw()* - draws an object.  

> *instanceCopy()* - creates an independent copy of the object.  

> *valueToActiveIndex(value)* - the function of calculating the active index of the progress indicator depending on the current value of the process completion.  

> *changeValue(value, speed, delay)* - animation of changing the current value of the process completion to *value* with *speed* and *delay*.  

##<a id="events"></a>Events  

Events triggered by a SegmentArrayProgressBar are implemented using a CustomEvent.  
In the *detail.progress_bar* field, a link to the object itself is passed.  

> *segment-array-progress-bar-changed* - state of the object is changed.  

***

<a href="../readme.html">Home</a> → Segment Array Progress Bar  