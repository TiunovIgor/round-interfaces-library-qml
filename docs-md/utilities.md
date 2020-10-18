<a href="../readme.html">Home</a> → Utilities

***

# Utilities

##<a id="requestAnimFrame"></a>requestAnimFrame

*window.requestAnimFrame(callback)* is an implementation of the requestAnimationFrame function for planning animations.  
Used to start the animation of all graphic objects represented in this library.  

##<a id="point"></a>Point

*Point(x, y)* - creates a point as an object with parameters x and y.  

##<a id="rgbaStrFromRgb"></a>rgbaStrFromRgb

*rgbaStrFromRgb(str)* - recieves color as a string in rgb format and converts it to rgba string.  

##<a id="rgbaStrFromHex"></a>rgbaStrFromHex

*rgbaStrFromHex(str)* - receives hex color code as a string and converts it to rgba string.  

##<a id="rgbaStrFromColorName"></a>rgbaStrFromColorName

*rgbaStrFromColorName(str)* - converts color name to rgba string.  

##<a id="rgbaStrFromColor"></a>rgbaStrFromColor

*rgbaStrFromColor(str)* - converts the color specified by a string of any valid format to an rgba string.    

##<a id="rgbaStrToObj"></a>rgbaStrToObj

*rgbaStrToObj(str)* - receives an rgba string and converts it into a JSON object with the keys 'r', 'g', 'b', 'a'.  
Used during fading animation of graphic objects to control the transparency parameter 'a'.  
Returns the color as a JSON object.  

##<a id="rgbaObjToStr"></a>rgbaObjToStr

*rgbaObjToStr(obj)* - converts the received JSON object with the keys 'r', 'g', 'b', 'a' into an rgba string.  
Used during fading animation of graphic objects to set the fill properties after changing the transparency.  
Returns the color as a string.  

##<a id="libraryInfo"></a>libraryInfo

*libraryInfo()* - returns information about the library as a JSON object with keys::
>
*name* - library name.    
*version* - library version.  

***

<a href="../readme.html">Home</a> → Utilities  