<section class="testimonials"">
<div class="color-overlay">
	<div class="container wow fadeIn">
    	<div class="section-header wow fadeIn">
    		<h2 class="">Отзывы</h2>
    	</div>


		<div id="feedbacks" class="owl-carousel owl-theme">

    		<div class="feedback">
    			<div class="image"><img src="xfiles/clients-pic/1.png" alt=""></div>				
    			<div class="message">
                    Я и себе здесь велик прикупила и подруге мы подобрали. Теперь катаемся уже вовсю. Выбор нереально огромный, тут вообще невозможно не найти подходящую модель. Мне кажется, вообще все возможные марки есть и ценовая категория разная. Я часто езжу на велосипеде, поэтому себе подороже купила, навороченный, а подруга редко ездит, поэтому ей такую простенькую модель совсем недорогую купили.
                </div>
    			<div class="name">Салахова Гульнур</div>
    	    </div>

    	
    		<div class="feedback">
    			<div class="image"><img src="xfiles/clients-pic/2.png" alt=""></div>				
    			<div class="message">
                    Низкие цены. Собирают неплохо, но я взял в заводской упаковке, хотел сам повозиться.
                </div>
    			<div class="name">Петров Сергей Николаевич</div>
    	    </div>

    	
    		<div class="feedback">
    			<div class="image"><img src="xfiles/clients-pic/4.png" alt=""></div>				
    			<div class="message">
                    Я например очень трепетно отношусь к выбору таких покупок как велосипеды, айфоны и т.п. прежде много инфы перелопачивая в нете. И друзья посоветовали мне Crait. Несомненно понравились цены, пожалуй ниже расценок я еще не видел. Ассортимент огромен просто. Привезли как и говорили на следующий день, добротно так запакованный, а потому ни единой царапины или скола. Мой диагноз – молодцы. Спасибо ребята!
                </div>
    			<div class="name">Марат Хамидуллин</div>
    	    </div>



		</div>
	</div>
</div>

</section>
<?php
Blox::addToFoot('
<script>
$(function () {
    /*testimonials*/
    $("#feedbacks").owlCarousel({
        navigation: true, /* Show next and prev buttons*/
        navigationText:	["&laquo; ПРЕДЫДУЩИЙ","СЛЕДУЮЩИЙ &raquo;"],
        slideSpeed: 1000,
        paginationSpeed: 1000,
        autoPlay: 30000,
        singleItem: true
    });
});
</script>'
);