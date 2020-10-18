<a href="readme.html">English</a> | Русский

***

# Библиотека круговых интерфейсов (QML-версия)

Round Interfaces Library - это коллекция классов графических объектов для построения круговых интерфейсов пользователя.  

![Volume Control](docs/images/qml_volume_control.png)
![Chart](docs/images/qml_chart.png)
![Radar](docs/images/qml_radar.png)
![Progress Bar](docs/images/qml_progress_bar.png)  

## Назначение библиотеки 

Круговые интерфейсы могут применяться с целью:  

* обеспечить информативность, компактность и быстроту восприятия данных при их визуализации;  
* получить виртуальный вариант физических интерфейсов управления или измерительных приборов;  
* разнообразить дизайн проекта или продукта.  

Данная библиотека разрабатывается с целью упростить процесс проектирования и реализации круговых интерфейсов.  

Например, внешний вид кругового индикатора прогресса можно настроить, задав следующие свойства:  

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

## Средства реализации  

Библиотека написана на QML с применением JavaScript.  
Для отрисовки графических элементов используется компонент Canvas.  

Документация на английском и русском языках поставляется в составе библиотеки в форматах HTML и Markdown.  
Для использования библиотеки необходимы базовые знания Qt/QML и JavaScript.  

## Структура файлов и папок проекта  

> *components* - основная папка с файлами библиотеки. Для использования библиотеки в собственном проекте достаточно подключить эти файлы.  

> *docs* - папка с документацией в .html формате. Документация приведена на английском и русском языках.    
> *docs-md* - папка с документацией в .md формате для исправления ошибок, доработки и использования в собственных проектах.  

> *examples* - папка с примерами использования компонентов библиотеки.  

> *font* - папка со шрифтами.  
> *svg* - папка с векторными изображениями для оформления примеров.  
> *icons* - папка с иконками приложения.  

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
Версия на QML (включая демонстрационное мобильное приложение): 1.4  

## Об авторе  
Автор: Игорь Тиунов  
E-mail: igor@tiunovs.com  