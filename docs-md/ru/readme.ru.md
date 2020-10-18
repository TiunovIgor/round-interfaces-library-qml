<a href="readme.html">English</a> | Русский

***

# Библиотека круговых интерфейсов

Round Interfaces Library - это коллекция классов графических объектов для построения круговых интерфейсов пользователя.  

![Plain Color Interface](docs/images/plain_color_interface.png)
![Hi-Tech Interface](docs/images/hi_tech_interface.png)
![Futuristic Interface](docs/images/futuristic_interface.png)
![Palette Interface](docs/images/palette_interface.png)  

## Назначение библиотеки 

Круговые интерфейсы могут применяться с целью:  

* разнообразить дизайн проекта или продукта;  
* обеспечить компактность при визуализации информации;  
* получить виртуальный вариант физических интерфейсов управления или измерительных приборов.  

Данная библиотека разрабатывается с целью упростить процесс проектирования и реализации круговых интерфейсов.  

Например, круговой индикатор прогресса можно создать в несколько строк кода:

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

## Средства реализации  

Библиотека написана на языке JavaScript.  
Для отрисовки графических элементов используется HTML элемент Canvas.  

Документация на английском и русском языках поставляется в составе библиотеки в форматах HTML и Markdown.  
Для использования библиотеки необходимы базовые знания HTML и JavaScript.  

## Структура файлов и папок проекта  

> *js* - основная папка с файлами библиотеки. Для использования библиотеки в собственном проекте достаточно подключить эти файлы.  

> *docs* - папка с документацией в .html формате. Документация приведена на английском и русском языках.    
> *docs-md* - папка с документацией в .md формате для исправления ошибок, доработки и использования в собственных проектах.  

> *examples* - папка с примерами использования базовых графических объектов.  
> *gui-examples-js* - папка с примерами реализации интерфейсов пользователя, составленных из базовых графических объектов.  

>> <a href="examples/gui-examples.html" target="_blank">Примеры</a> описывают способы построения формы и анимации круговых интерфейсов.  

> *css* - папка с файломи стилей для оформления примеров.  
> *svg* - папка с векторными изображениями для оформления примеров.  
> *sounds* - папка с музыкальными файлами для тестирования кругового эквалайзера

## Базовые элементы круговых интерфейсов (расширено во 2-й версии библиотеки)  

1. <a href="docs/ru/segment.ru.html">Segment</a> - Сегмент
2. <a href="docs/ru/segment-grid.ru.html">SegmentGrid</a> - Сегментная сетка (новый)  
3. <a href="docs/ru/segment-spiral.ru.html">SegmentSpiral</a> - Сегментная спираль (новый)  
4. <a href="docs/ru/segment-level.ru.html">SegmentLevel</a> - Уровень сегментов
5. <a href="docs/ru/segment-array.ru.html">SegmentArray</a> - Массив сегментов
6. <a href="docs/ru/segment-dot.ru.html">SegmentDot</a> - Сегментная точка
7. <a href="docs/ru/segment-dots-array.ru.html">SegmentDotsArray</a> - Сегментный массив точек
8. <a href="docs/ru/segment-scale-mark.ru.html">SegmentScaleMark</a> - Отметка сегментной шкалы
9. <a href="docs/ru/segment-scale-sign.ru.html">SegmentScaleSign</a> - Символ сегментной шкалы (новый)  
10. <a href="docs/ru/segment-scale.ru.html">SegmentScale</a> - Сегментная шкала
11. <a href="docs/ru/segment-gradient.ru.html">SegmentGradient</a> - Сегментный градиент
12. <a href="docs/ru/utilities.ru.html">Utilities</a> - Утилиты библиотеки

## Круговые элементы управления и визуализации (реализовано во 2-й версии библиотеки)  

1. Progress Bar - Индикатор прогресса  
1.1. <a href="docs/ru/segment-progress-bar.ru.html">SegmentProgressBar</a> - Индикатор прогресса в виде сегмента кольца  
1.2. <a href="docs/ru/segment-array-progress-bar.ru.html">SegmentArrayProgressBar</a> - Индикатор прогресса в виде сегментного массива  
1.3. <a href="docs/ru/segment-dots-array-progress-bar.ru.html">SegmentDotsArrayProgressBar</a> - Индикатор прогресса в виде сегментного массива точек  

2. Gauge - Измерительный прибор с круговой шкалой  
2.1. <a href="docs/ru/segment-arrow.ru.html">SegmentArrow</a> - Стрелка  
2.2. <a href="docs/ru/segment-gauge.ru.html">SegmentGauge</a> - Измерительный прибор  

3. Timer - Таймер  
3.1. <a href="docs/ru/segment-timer.ru.html">SegmentTimer</a> - Таймер с индиктором прогресса в виде сегмента кольца  
3.2. <a href="docs/ru/segment-array-timer.ru.html">SegmentArrayTimer</a> - Таймер с индиктором прогресса в виде сегментного массива  
3.3. <a href="docs/ru/segment-dots-array-timer.ru.html">SegmentDotsArrayTimer</a> - Таймер с индиктором прогресса в виде сегментного массива точек  
3.4. <a href="docs/ru/segment-gauge-timer.ru.html">SegmentGaugeTimer</a> - Таймер с индиктором прогресса в виде циферблата со стрелкой  

4. Volume Control - Управление громкостью  
4.1. <a href="docs/ru/segment-knob.ru.html">SegmentKnob</a> - Ручка-регулятор  
4.2. <a href="docs/ru/segment-spiral-volume-control.ru.html">SegmentSpiralVolumeControl</a> - Регулятор громкости со спиральным индикатором  
4.3. <a href="docs/ru/segment-array-volume-control.ru.html">SegmentArrayVolumeControl</a> - Регулятор громкости с индикатором в виде сегментного массива  

5. <a href="docs/ru/segment-equalizer.ru.html">SegmentEqualizer</a> - Круговой эквалайзер  

6. <a href="docs/ru/segment-captcha.ru.html">SegmentCaptcha</a> - Круговой тест CAPTCHA

7. <a href="docs/ru/segment-chart.ru.html">SegmentChart</a> - Круговая диаграмма  

8. <a href="docs/ru/segment-radar.ru.html">SegmentRadar</a> - Радар  

## Круговые интерфейсы управления графикой (запланировано к реализации в 3-й версии библиотеки)  

1. Icon Manager - Менеджер иконок  
2. Image Gallery - Галерея изображений
3. Round Interfaces Editor - Редактор круговых интерфейсов

## Лицензия  
Настояющую библиотеку можно использовать и дорабатывать в коммерческих, образовательных и личных целях.  
Сообщения об ошибках и рекомендации по доработке можно направлять на электронную почту автора.  

## О библиотеке
Версия: 2.0

## Об авторе  
Автор: Игорь Тиунов  
E-mail: igor@tiunovs.com  