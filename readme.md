English | <a href="readme.ru.html">Русский</a>

***

# Round Interfaces Library

Round Interfaces Library is a collection of graphic objects classes for building round user interfaces.  

![Plain Color Interface](docs/images/plain_color_interface.png)
![Hi-Tech Interface](docs/images/hi_tech_interface.png)
![Futuristic Interface](docs/images/futuristic_interface.png)
![Palette Interface](docs/images/palette_interface.png)  

## Library Purpose 

Round interfaces can be used to:  

* diversify the design of a project or product;  
* provide compactness when visualizing information;  
* get a virtual version of the physical control interfaces or measuring instruments.  

This library is being developed to simplify the process of designing and implementing round interfaces.  

For example, round progress bar can be created with a few lines of code:  
![Round Progress Bar](docs/images/segment_progress_bar.png)

>
    HTML:  
>>
    <canvas id="progress-bar" width="200" height="200">
        <div>Use a canvas-compatible browser</div>
    </canvas>
>
    JS:  
>>
    let canvas = document.getElementById('progress-bar');
    let context = canvas.getContext('2d');
    context.width = canvas.width;
    context.height = canvas.height;
    let cx = context.width/2;
    let cy = context.height/2;
>>
*let bar = new SegmentProgressBar('bar', context, cx, cy, 50, 25);*  
*bar.draw();*  

## Tools  

The library is written in JavaScript.  
To render graphic elements, the HTML Canvas is used.  

The documentation in English and Russian is supplied as part of the library in HTML and Markdown formats.  
To use the library, you need basic knowledge of HTML and JavaScript.  

## Structure of project files and folders  

> *js* - main folder with library files. To use the library in your own project, just connect these files.  

> *docs* - main user documentation folder. The documentation is provided in HTML format.    
> *docs-md* - documentation in MD format for revision and use in your own projects.  

> *examples* - a folder with examples of using basic graphic objects.  
> *gui-examples-js* - a folder with examples of implementation of user interfaces composed of basic graphic objects.  

>> <a href="examples/gui-examples.html" target="_blank">Examples</a> describe how to build the shape and animation of round interfaces.  

> *css* - folder with styles for examples.  
> *svg* - folder with vector images for examples.  
> *sounds* - folder with sound samples for testing the round equalizer

## Basic elements of round interfaces (extended in the version 2.0 of the library)  

1. <a href="docs/segment.html">Segment</a>  
2. <a href="docs/segment-grid.html">SegmentGrid</a> (new)  
3. <a href="docs/segment-spiral.html">SegmentSpiral</a> (new)  
4. <a href="docs/segment-level.html">SegmentLevel</a>  
5. <a href="docs/segment-array.html">SegmentArray</a>  
6. <a href="docs/segment-dot.html">SegmentDot</a>  
7. <a href="docs/segment-dots-array.html">SegmentDotsArray</a>  
8. <a href="docs/segment-scale-mark.html">SegmentScaleMark</a>  
9. <a href="docs/segment-scale-sign.html">SegmentScaleSign</a> (new)  
10. <a href="docs/segment-scale.html">SegmentScale</a>
11. <a href="docs/segment-gradient.html">SegmentGradient</a>  
12. <a href="docs/utilities.html">Utilities</a>  

## Round controls (implemented in the version 2.0 of the library)  

1. Progress Bar  
1.1. <a href="docs/segment-progress-bar.html">SegmentProgressBar</a>  
1.2. <a href="docs/segment-array-progress-bar.html">SegmentArrayProgressBar</a>  
1.3. <a href="docs/segment-dots-array-progress-bar.html">SegmentDotsArrayProgressBar</a>  

2. Gauge  
2.1. <a href="docs/segment-arrow.html">SegmentArrow</a>  
2.2. <a href="docs/segment-gauge.html">SegmentGauge</a>  

3. Timer  
3.1. <a href="docs/segment-timer.html">SegmentTimer</a>  
3.2. <a href="docs/segment-array-timer.html">SegmentArrayTimer</a>  
3.3. <a href="docs/segment-dots-array-timer.html">SegmentDotsArrayTimer</a>  
3.4. <a href="docs/segment-gauge-timer.html">SegmentGaugeTimer</a>  

4. Volume Control  
4.1. <a href="docs/segment-knob.html">SegmentKnob</a>  
4.2. <a href="docs/segment-spiral-volume-control.html">SegmentSpiralVolumeControl</a>  
4.3. <a href="docs/segment-array-volume-control.html">SegmentArrayVolumeControl</a>  

5. <a href="docs/segment-equalizer.html">SegmentEqualizer</a>  

6. <a href="docs/segment-captcha.html">SegmentCaptcha</a>  

7. <a href="docs/segment-chart.html">SegmentChart</a>  

8. <a href="docs/segment-radar.html">SegmentRadar</a>  


## Round controls for graphics management (planned for development in the 3rd version of the library)  

1. Icon Manager  
2. Image Gallery  
3. Round Interfaces Editor  

## License  
This library can be used and modified for commercial, educational and personal purposes.  
Error messages and recommendations for improvement can be sent to the author's email.  

## About Library
Version: 2.0

## About Author  
Author: Igor Tiunov  
E-mail: igor@tiunovs.com  