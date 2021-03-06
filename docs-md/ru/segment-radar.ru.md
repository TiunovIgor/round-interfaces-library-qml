<a href="../../readme.ru.html">Главная</a> → Радар  

***

# SegmentRadar

## Содержание
1. [Описание объекта](#description)  
2. [Зависимости объекта](#dependencies)  
3. [Создание объекта](#constructor)  
4. [Примеры] (#examples)  
5. [Свойства](#properties)  
6. [Методы](#methods)  
7. [События](#events)  

##<a id="description"></a>Описание объекта

Радар (графический объект) – круговой интерфейс для визуализации данных, поступающих с радиолокационной станции или радара (рис. 1).  

![SegmentGeometry](../../docs/images/segment_radar.png)  
Рис. 1 - Радар

##<a id="dependencies"></a>Зависимости объекта  
Для создания объекта типа SegmentRadar необходимо подключить следующие скрипты:  

* segment.js  
* segment-dot.js   
* segment-grid.js  
* segment-gradient.js  
* utilities.js  

##<a id="constructor"></a>Создание объекта  
Для создания объекта в функцию-конструктор передаются основные параметры:   
>
*id* - идентификатор радара в виде текстовой строки.  
*context* - контекст типа CanvasRenderingContext2D для отрисовки радара.  
*cx* - координата X центра радара.  
*cy* - координата Y центра радара.  
*thickness* - толщина радара.  

##<a id="examples"></a>Примеры  
<a href="../../examples/round-radar-examples.html" target="_blank">Примеры</a> использования различных свойств и методов объекта.  

##<a id="properties"></a>Свойства

*factor* - коэффициент масштабирования целей на экране радара.  

Радар - это составной объект. В его состав входят:  
>
*grid* - координатная сетка, представленная объектом типа <a href="segment-grid.ru.html">SegmentGrid</a>.  
*locator* - локатор, представленный объектом типа сегмент <a href="segment.ru.html">Segment</a>.  
*frame* - рамка, представленная объектом типа сегмент <a href="segment.ru.html">Segment</a>.  

### Стиль оформления радара  
>
*gradient* - градиент заливки координатной сетки типа <a href="segment-gradient.ru.html">SegmentGradient</a>.
*background* - цвет заливки координатной сетки (применяется, если не задан градиент заливки).  
*border_width* - толщина границ координатной сетки.  
*border_color* - цвет границ координатной сетки.  

>
*locator_angle* - угол сегмента, представляющего локатор.  
*locator_period* - период вращения локатора.  
*locator_gradient* - градиен заливки локатора.  
*locator_border_width* - толщина границ локатора.  
*locator_border_color* - цвет границ локатора.  

>
*frame_gradient* - градиент заливки рамки.  
*frame_background* - цвет заливки рамки (применяется, если на задан градиент заливки).  
*frame_border_width* - толщина границ рамки.  
*frame_border_color* - цвет границ рамки.  

>
*dot_radius* - радиус точек, представляющих цели.  
*dot_gradient* - градиент заливки целей.  
*dot_background* - цвет заливки целей.  
*dot_border_width* - толщина границ целей.  
*dot_border_color* - цвет границ целей.  

### Флаги сегмента
>
*visible* - видимость. Значение *true* обеспечивает видимость объекта.  
*targets_visible* - видимость целей.  
*locator_enabled* - режим работы локатора: *true* - включен, *false* - выключен.  
*in_progress* - в процессе. Флаг принимает значение *true* в процессе анимации.  

##<a id="methods"></a>Методы

> *build()* - выполняет основные вычисления формы и внешнего вида радара с учетом заданных свойств и флагов.  

> *draw()* - функция отрисовки радара.  

> *instanceCopy()* - создание независимой копии объекта.  

> *startLocator()* - включение локатора.  

> *rotateLocator()* - вращение локатора (используется автоматически, если локатор включен).  

> *stopLocator()* - выключение локатора.  

> *targetsToDots(targets)* - метод расчета координат целей на экране локатора по входному массиву целей.  
Массив целей должен содержать объекты в формате:  
>>  {  'id' : идентификатор, 'x' : абсцисса, 'y' : ордината, 'angle' : угол }  

### Анимация сегмента

Радар предназначен для ослеживания координат целей.  
При изменении положения целей необходимо вызывать метод targetsToDots, в который необходимо передать обновленный массив целей.  
Этот метод обновит список точек, представляющих цели, и запустит событие *segment-radar-changed*.  
По наступлении этого события необходимо очистить холст и вызвать метод draw() для отрисовки радара.  

##<a id="events"></a> События

События, запускаемые объектом SegmentRadar, реализованы с помощью CustomEvent.  
В поле *detail.radar* передается ссылка на сам объект.  

> *segment-radar-changed* - состояние радара изменено.  
  
***

<a href="../../readme.ru.html">Главная</a> → Радар  