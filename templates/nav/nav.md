## Основные данные. Поле 9 
Пример использования классов icon1, icon2 для отображения пиктограмм перед пунктами меню. 

Файл page.css:

	li[class*=icon] > a {background-position: 9px 50%; background-repeat:no-repeat; padding-left:35px} 
	li[class*=icon]:first-child > a {background-position-y:69%!important} 
	li[class*=icon-]:last-child > a {background-position-y:35%!important}
	li.icon1        > a {background-image: url(images/1.png)}
	li.icon2        > a {background-image: url(images/2.png)}
	...
	
## Экстраданные. Поля 1, 2 и 3

Если блоки на целевой странице используют только привязку к URL (http://bloxcms.net/documentation/class-tdd.htm#bind-phref), то можно указывать любой номер поля (поле 2) и несуществующий номер блока (поле 1).
Хотя последнее нежелательно, так как будут идти sql-запросы к полям несуществующего блока.

Однако, если вы сделегируете меню на другую страницу, то система не сможет по неправильному блоку определить страницу каталога.

В этом случае применяйте еще и поле 3 (номер страницы).