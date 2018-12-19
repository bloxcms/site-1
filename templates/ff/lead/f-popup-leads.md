
## Управление всплывающими окнами

После создания блоков на данном шаблоне, нужно создать код для управления вызовом этих блоков.
На странице (page.tpl), где должна всплывать форма необходимо создать коды для вызова того или иного блока на то или иное событие.

Для этого нужно подключить файл ff/popups/trigger.js и вызвать функцию $.popupTrigger() с нужными опциями.
Документация: ff/popups/trigger.md.

Пример:


	<?php
	Blox::addToFoot(Blox::info('templates','url').'/ff/popups/trigger.js');
	Blox::addToFoot('<script>
	    $.popupTrigger({url:"?block=494&single=1", event:"load"});
	    $.popupTrigger({url:"?block=494&single=2", event:"scroll", size:"lg"});
	</script>');
	?>
	
	
где 
* block=494 — это номер блока на данном шаблоне (ff/lead);
* single=1 — это номер вызываемой записи.

## Ширина модального окна
В зависимости от ширины модального окна, которая определяется параметром size, ширина картинки должна быть следующей:
* size:"sm" — 300px
* по умолчанию — 600px 
* size:"lg" — 900px


## Рекомендуемая конфигурация формы

	{ 
		"action" : "templates/ff/lead/action-1.php",
		"method" : "include",
		"fields" : [
			{
				"name" : "theme",
				"type" : "hidden",
				"default" : "Хочу купить окна еще дешевле"
			},{
				"name" : "name",
				"size" : "lg",
				"placeholder" : "Ваше имя"
			},{
				"name" : "phone",
				"size" : "lg",
				"validation" : "not-empty",
				"mask":"(999) 999-9999",
				"placeholder" : "Ваш телефон"
			},{
				"name" : "form-submit",
				"type" : "submit",
				"class" : "btn btn-danger btn-lg",
				"default" : "ХОЧУ ЕЩЕ ДЕШЕВЛЕ"
			} 
		]
	}


## Позиционирование формы в модальном окне

HTML структура записи, отображаемой в модальном окне проста - за картинкой идет код формы, заключенный в элемент div.ff-lead-form.

Как правило, код формы необходимо позиционировать абсолютно относительно модального окна.
Для этого впишите нужный стиль в поле 4.

Пример:

	.ff-lead-form {width:276px; position: absolute; top:253px; left:270px}
	.ff-lead-img {border-radius:12px; box-shadow: 0px 0px 20px rgba(0,0,0,.5)}
	.ff-lead [name="form-submit"] {width: 100%; font-weight:bold}
	.ff-lead .alert.alert-success {background:green; font-size:22px; color:#fff; border:none}



