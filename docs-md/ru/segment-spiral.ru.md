<a href="../../readme.ru.html">Главная</a> → Сегментная спираль  

***

# SegmentSpiral

## Содержание
1. [Описание объекта](#description)  
2. [Зависимости объекта](#dependencies)  
3. [Создание объекта](#constructor)  
4. [Примеры] (#examples)  
5. [Свойства](#properties)  
6. [Методы](#methods)  
7. [События](#events)  

##<a id="description"></a>Описание объекта

Сегментная спираль – часть сегмента кольца, ограниченная окружностью и частью спирали, имеющими общий центр, а также лучом, исходящим из этого центра (рис. 1).

![SegmentSpiralGeometry](../../docs/images/segment_spiral_geometry.png)  
Рис. 1 - Геометрия сегментной спирали

C - центр сегментной спирали - это центр базового сегмента.  
R1 - радиус меньшей окружности.  
R2 - радиус большей окружности.  
CA - луч, ограничивающий базовый сегмент и определяющий его начало.  
CB - луч, ограничивающий базовый сегмент и определяющий его конец.  
T - толщина базового сегмента, равная разнице между R2 и R1.  
α - начальный угол базового сегмента - это угол между горизонтальной осью X и лучом CA.  
β - угол сегмент - это угол между лучами CA и CB.  

##<a id="dependencies"></a>Зависимости объекта  
Для создания объекта типа SegmentSpiral необходимо подключить следующие скрипты:  

* segment-gradient.js  
* utilities.js  

##<a id="constructor"></a>Создание объекта  
Для создания объекта в функцию-конструктор передаются основные параметры:   
>
*id* - идентификатор сегментной спирали в виде текстовой строки.  
*context* - контекст типа CanvasRenderingContext2D для отрисовки сегментной спирали.  
*cx* - координата X центра базового сегмента.  
*cy* - координата Y центра базового сегмента.  
*r_in* - внутренний радиус базового сегмента.  
*thickness* - толщина базового сегмента.  
*init_angle* - начальный угол базового сегмента в градусах. Может принимать отрицательные значения. 
*angle* - угол базового сегмента в градусах.

Внешний радиус сегмента *r_out* будет рассчитан автоматически в процессе создания объекта.

##<a id="examples"></a>Примеры  
<a href="../../examples/segment-spiral-examples.html" target="_blank">Примеры</a> использования различных свойств и методов объекта.  

##<a id="properties"></a>Свойства

### Параметры фигуры
>
*position* - позиция фигуры в базовом сегменте относительно спиральной стороны.  

>Допустимые значения позиции фигуры:
>> _"inner"_ - внутри. Примыкание к внутренней границе базового сегмента.  
>> _"outer"_ - снаружи. Примыкание к внешней границе базового сегмента.  

>
*direction* - направление увеличения толщины фигуры.  

>Допустимые значения направления фигуры:  
>> _"clockwise"_ - по часовой стрелке.  
>> _"anticlockwise"_ - против часовой стрелки.

### Стиль оформления спирали  
>
*gradient* - градиент заливки типа <a href="segment-gradient.ru.html">SegmentGradient</a>.
  
>Допустимые значения направления для линейного градиента:  
>> _"from-center"_ - из центра.  
>> _"to-center"_ - к центру.  
>> _"from-opening"_ - от открывающей границы к закрыващей вдоль хорды окружности.  
>> _"from-closing"_ - от закрывающей границы к открывающей вдоль хорды окружности.  

>Допустимые значения направления для радиального градиента:  
>> _"from-center"_ - из центра.  
>> _"to-center"_ - к центру.  

>Допустимые значения направления для конического градиента:
>> _"clockwise"_ - по часовой стрелке.
>> _"anticlockwise"_ - против часовой стрелки.  

>
*background* - цвет заливки (применяется, если не задан градиент заливки).  
*border_width* - толщина границ сегментной спирали.  
*border_color* - цвет границ сегментной спирали.

Границы сегментной спирали могут быть заданы отдельно.  

Типы границ сегментной спирали:

A) Открывающая граница (Opening Border) – открывающая граница базового сегмента. 
Применима для сегментной спирали с направлением увеличения толщины фигуры против часовой стрелки Anticlockwise.  
> *border_opening_width* - ширина открывающей границы.    
> *border_opening_color* - цвет открывающей границы.  

B) Внешняя граница (Outer Border) – дуга базового сегмента с большим радиусом. 
Применима для сегментной спирали с позицией фигуры Outer.   
> *border_outer_width* - ширина внешней границы.    
> *border_outer_color* - цвет внешней границы.  

C) Внутренняя граница (Inner Border) – дуга базового сегмента с меньшим радиусом. 
Применима для сегментной спирали с позицией фигуры Inner.  
> *border_inner_width* - ширина внутренней границы.    
> *border_inner_color* - цвет внутренней границы.  

D) Закрывающая граница (Closing Border) – закрывающая граница базового сегмента. 
Применима для сегментной спирали с направлением увеличения толщины фигуры по часовой стрелке Clockwise.  
> *border_closing_width* - ширина закрывающей границы.    
> *border_closing_color* - цвет закрывающей границы.  

E) Спиральная граница (Spiral Border) – сторона фигуры, построенная по уравнению спирали.  
> *border_spiral_width* - ширина спиральной границы.    
> *border_spiral_color* - цвет спиральной границы.  

Если задана отдельная граница сегмента, то для ее отрисовки будет применяться указанный стиль: ширина и/или цвет.  
Если отдельная граница не задана, то для ее отрисовки будет применяться общий стиль границ сегментной спирали.  

### Флаги сегмента
>
*visible* - видимость. Значение *true* обеспечивает видимость объекта.  
*in_progress* - в процессе. Флаг принимает значение *true* в процессе анимации.  

##<a id="methods"></a>Методы

> *calc()* - выполняет основные вычисления формы и внешнего вида сегментной спирали при ее создании, изменении параметров и в процессе анимации.  
Этот метод необходимо вызывать после изменения свойств объекта, чтобы они вступили в силу.  

> *calcBorder()* - определяет стили границ сегментной спирали. Вызывается автоматически из метода *calc()*.  

> *draw()* - функция отрисовки объекта.  

> *instanceCopy()* - создание независимой копии объекта.

### Анимация сегмента

Анимация сегментной спирали - это различные изменения формы, положения или стиля оформления фигуры со временем.

Основные параметры анимации:
> *duration* - длительность анимации. Задается в секундах.  
> *delay* - задержка перед началом анимации. Задается в секундах.   
> *direction* - направление анимации. Набор допустимых значений зависит от вида анимации.  

#### Методы анимации

> *appear(direction, duration, delay)* - появление сегментной спирали за счет постепенного изменения формы.  

> Допустимые значения параметра *direction* для метода анимации появления:  
>> _"from-center"_ - из центра. Доступно, если позиция фигуры - *inner*.  
>> _"to-center"_ - к центру. Доступно, если позиция фигуры - *outer*.  
>> _"clockwise"_ - по часовой стрелке. Доступно, если направление фигуры - *clockwise*.  
>> _"anticlockwise"_ - против часовой стрелки. Доступно, если направление фигуры - *anticlockwise*.  

> *disappear(direction, duration, delay)* - исчезание сегмента за счет постепенного изменения формы.  

> Допустимые значения параметра *direction* для метода анимации исчезания:  
>> _"from-center"_ - из центра. Доступно, если позиция фигуры - *outer*.  
>> _"to-center"_ - к центру. Доступно, если позиция фигуры - *inner*.  
>> _"clockwise"_ - по часовой стрелке. Доступно, если направление фигуры - *anticlockwise*.  
>> _"anticlockwise"_ - против часовой стрелки. Доступно, если направление фигуры - *clockwise*.  

> *rotate(direction, angle, duration, delay)* - поворот сегментной спирали на угол *angle* в течение *duration* секунд.  

> Угол поворота *angle* задается в градусах.  

> Допустимые значения параметра *direction* для метода анимации вращения:  
>> _"clockwise"_ - по часовой стрелке.  
>> _"anticlockwise"_ - против часовой стрелки.  

> *fadeIn(duration, delay)* - постепенное появление сегментной спирали за счет изменения прозрачности.  

> *fadeOut(duration, delay)* - постепенное исчезание сегментной спирали за счет изменения прозрачности.  

##<a id="events"></a> События

События, запускаемые объектом SegmentSpiral, реализованы с помощью CustomEvent.  
В поле *detail.spiral* передается ссылка на сам объект.  

> *segment-spiral-changed* - сегментная спираль изменена. Событие запускается каждый раз, когда выполняется метод calc().  

> *segment-spiral-appeared* - сегментная спираль появилась.  
> *segment-spiral-disappeared* - сегментная спираль исчезла.  
> *segment-spiral-rotated* - сегментная спираль повернута.  
> *segment-spiral-faded-in* - сегментная спираль появилась методом выцветания.  
> *segment-spiral-faded-out* - сегментная спираль исчезла методом выцветания.  

***

<a href="../../readme.ru.html">Главная</a> → Сегментная спираль  