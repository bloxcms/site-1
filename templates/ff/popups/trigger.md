
# Запуск всплывающих окон в ответ на различные события
 
Можно управлять модальными окнами, так чтобы они всплывали на определенные события, с определенной задержкой и только один раз в течение определенного срока.

Для этого нужно подключить файл ff/popups/trigger.js и вызвать функцию $.popupTrigger() с нужными опциями.
Естественно должен быть также активирован шаблон ff/popups.

Обязательными являются две опции: url и event.

	<?php
	Blox::addToFoot(Blox::info('templates','url').'/ff/popups/trigger.js');
	Blox::addToFoot('<script>$.popupTrigger({url:"?block=494&single=1", event:"load"});</script>');
	Blox::addToFoot('<script>$.popupTrigger({url:"?block=494&single=2", event:"scroll"});</script>');
	?>


### Пример со всеми опциями
	
    $.popupTrigger({
        url:"?block=494&single=1", 
        event:"load scroll",
        delay:3,
        offdays:7,
        size:"lg"
    });


## Опции

+ **delay** — задержка в секундах (float) от момента события до самого всплывания окна. 
	+ Если окно не успело всплыть, то оно всплывет через заданное время в другой раз (хоть через год, если используется тот же браузер) и даже на другой странице (если на той странице будет подключен файл ff/popups/trigger.js). 
	+ В случае события mouseleave, опция delay имеет еще одну функцию, а именно, в течение времени, указанного в delay, всплытие окна будет отменено, если указатель мыши вернется обратно в окно.
+ **event** —  (string) название события или список названий, перечисленный через пробел. Возможные значения: 
	+ load (загрузка страницы)
	+ scroll (прокрутка окна)
	+ mouseleave (выход указателя мыши за верхний край окна). Для этого события рекомендуется использовать также опцию delay в секунды три.
	+ если нужно еще, обращайтесь к разработчику
+ **offdays** —  количество дней (float), в течение которых окно с указанным URL будет блокировано и всплывать не будет. Если необходим интервал, меньший, чем день, используйте десятичную дробь с точкой.
+ **size** —  (string) размер модального окна (см. документацию к шаблону ff/popups). Возможные значения: lg, sm.
+ **url** —  (string) URL вызываемого блока (см. документацию к шаблону ff/popups).

