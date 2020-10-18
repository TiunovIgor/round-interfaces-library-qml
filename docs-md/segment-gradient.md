<a href="../readme.html">Home</a> → Segment Gradient

***

# SegmentGradient

## Contents
1. [Object description](#description)  
2. [Object dependencies](#dependencies)  
3. [Object creation](#constructor)  

##<a id="description"></a>Object description

Segment Gradient is a custom gradient for filling elements of round interfaces.  

##<a id="dependencies"></a>Object dependencies  
The following scripts should be included in the \<head> section:  

* utilities.js  

##<a id="constructor"></a>Object creation  

To create an object, the main parameters are passed to the constructor function:   
> *type* - gradient type. Valid values:  
>> _"linear"_ - linear gradient.  
>> _"radial"_ - radial gradient.  
>> _"conic"_ - conic gradient.  

> *direction* - gradient direction. Valid values ​​depend on the type of gradient and the type of fill object.  

> *stops_string* - line specifying the position of each color through stop points.  
The color can be specified as a keyword, in HEX (RGB) format, in RGB or RGBA format.  
Stop point is set as a percentage.  
Color and stop point separates by a space.  
Color-Point pairs in the string separates by commas.  

An example of a radial custom gradient emanating from the center of a segment (Fig. 1):  
>
SegmentGradient('radial', 'from-center', '#06ff1a 45%, #00b050 76%, #034400 98%')  

![SegmentGradient](../docs/images/segment_gradient.png)  
Fig. 1 - Segment Gradient

***

<a href="../readme.html">Home</a> → Segment Gradient  