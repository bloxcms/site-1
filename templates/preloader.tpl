<?php
/* LOADER makes sure the whole site is loaded */

Blox::addToHead('templates/preloader/preloader.css');
Blox::addToFoot('
<script>
$(window).load(function() {
    $(".status").fadeOut(); /* will first fade out the loading animation */
	$(".preloader").delay(500).fadeOut("slow");/* will fade out the whole DIV that covers the website.*/
})
</script>'
);
?>    
    
<div class="preloader">
    <div class="status">&nbsp;</div>
</div>
