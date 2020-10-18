English | <a href="readme.ru.html">Русский</a>

***

# Round Interfaces Library (QML version)

Round Interfaces Library is a collection of graphic objects classes for building round user interfaces.  

![Volume Control](docs/images/qml_volume_control.png)
![Chart](docs/images/qml_chart.png)
![Radar](docs/images/qml_radar.png)
![Progress Bar](docs/images/qml_progress_bar.png)  

## Library Purpose 

Round interfaces can be used to:  

* provide informativeness, compactness and speed of perception of data when visualizing it;  
* get a virtual version of the physical control interfaces or measuring instruments;  
* diversify the design of a project or product.  

This library is being developed to simplify the process of designing and implementing round interfaces.  

For example, the appearance of a round progress bar can be customized by setting the following properties:  
![Round Progress Bar](docs/images/qml_custom_progress_bar.png)

>
    QML:  
>>
    segmentArrayProgressBar.name = "bar_1";
    segmentArrayProgressBar.cx = canvas_5.width / 2;
    segmentArrayProgressBar.cy = canvas_5.height / 2;
    segmentArrayProgressBar.r_in = 0.5 * canvas_5.width / 2;
    segmentArrayProgressBar.thickness = 0.25 * canvas_5.width / 2;
    segmentArrayProgressBar.visible = true;
>>
    segmentArrayProgressBar.value = 100;
    segmentArrayProgressBar.background = 'rgba(0, 0, 0, 0)';
    segmentArrayProgressBar.border_color = 'none';
    segmentArrayProgressBar.segment_background = 'rgba(240, 240, 240, 1)';
    segmentArrayProgressBar.active_segment_background = '#00A0E9';
>>
    segmentArrayProgressBar.build();
    segmentArrayProgressBar.calc();
    segmentArrayProgressBar.draw();  

## Tools  

The library is written in QML with JavaScript.  
To render graphic elements, the Canvas component is used.  

The documentation in English and Russian is supplied as part of the library in HTML and Markdown formats.  
To use the library you need basic knowledge of Qt/QML and JavaScript.  

## Structure of project files and folders  

> *components* - main folder with library files. To use the library in your own project, just connect these files.  

> *docs* - main user documentation folder. The documentation is provided in HTML format.    
> *docs-md* - documentation in MD format for revision and use in your own projects.  

> *examples* - folder with examples of using library components.  

> *fonts* - folder with fonts.  
> *svg* - folder with vector images for examples.  
> *icons* - folder with application icons.  

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
QML version (including demo mobile app): 1.4  

## About Author  
Author: Igor Tiunov  
E-mail: igor@tiunovs.com  