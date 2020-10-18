<a href="../../readme.ru.html">Главная</a> → Утилиты библиотеки

***

# Utilities

##<a id="requestAnimFrame"></a> requestAnimFrame

*window.requestAnimFrame(callback)* - реализация функции requestAnimationFrame для планирования анимации.  
Используется для запуска анимации всех объектов, представленных в данной библиотеке.  

##<a id="point"></a>Point

*Point(x, y)* - создает точку в виде объекта с параметрами x и y.  

##<a id="rgbaStrFromRgb"></a>rgbaStrFromRgb

*rgbaStrFromRgb(str)* - преобразует полученный цвет в rgb-формате в строку rgba.

##<a id="rgbaStrFromHex"></a>rgbaStrFromHex

*rgbaStrFromHex(str)* - преобразует полученный цвет в hex-формате в строку rgba.  

##<a id="rgbaStrFromColorName"></a>rgbaStrFromColorName

*rgbaStrFromColorName(str)* - преобразует название цвета в строку rgba.  

##<a id="rgbaStrFromColor"></a>rgbaStrFromColor

*rgbaStrFromColor(str)* - преобразует цвет, заданный строкой любого допустимого формата, в строку rgba.  

##<a id="rgbaStrToObj"></a>rgbaStrToObj  

*rgbaStrToObj(str)* - преобразует полученную rgba-строку в JSON объект с ключами 'r', 'g', 'b', 'a'.  
Используется при анимациии выцветания объектов для управления параметром прозрачности 'a'.  
Возвращает цвет в виде JSON-объекта.  

##<a id="rgbaObjToStr"></a>rgbaObjToStr  

*rgbaObjToStr(obj)* - преобразует полученный JSON объект с ключами 'r', 'g', 'b', 'a' в rgba-строку.  
Используется при анимации выцветания объектов для задания цвета заливки после изменения прозрачности.  
Возвращает цвет в виде строки.

##<a id="libraryInfo"></a>libraryInfo

*libraryInfo()* - возвращает информацию о библиотеке в виде JSON-объекта с ключами:
>
*name* - имя библиотеки.  
*version* - версия библиотеки.  

***

<a href="../../readme.ru.html">Главная</a> → Утилиты библиотеки  