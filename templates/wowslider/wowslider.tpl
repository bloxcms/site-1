<?php
/*
wowslider	http://wowslider.com/bootstrap-carousel-example-shift-demo.html
    download its app and set all effects
    The code style of the plugin is obtrusive!
Other slide effects
    &&&&&	wowslider	http://wowslider.com/bootstrap-carousel-example-shift-demo.html
    &&&&	https://www.jqueryscript.net/slider/Responsive-jQuery-Carousel-Slider-with-Slice-Transitions-indySliceSlider.html
    &&&	simple not resp https://www.cssscript.com/simple-javascript-css-image-slider-slice-transition-effect/
    &&	https://codepen.io/aphextwix/pen/BzkNBb
*/     
Blox::addToHead('<link rel="stylesheet" type="text/css" href="templates/wowslider/engine1/style.css" />');
Blox::addToFoot('<script type="text/javascript" src="templates/wowslider/engine1/wowslider.js"></script>');
Blox::addToFoot('<script type="text/javascript" src="templates/wowslider/engine1/script.js"></script>');
if (!$tab) {
    if ($edit)
        echo '<div style="position:relative">'.$edit['button'].'</div>';
    return;   
}
echo'
<div class="wowslider" style="position:relative">
    <div id="wowslider-container1">
        <div class="ws_images">
            <ul>';
                foreach ($tab as $i=>$dat) {
                    $alt[$i] = ($dat[3])
                        ? Text::stripTags($dat[3], 'stripQuotes')
                        : ''
                    ;
                    $img = '<img alt="'.$alt[$i].'" title="'.$alt[$i].'" src="datafiles/wowslider/lg/'.$dat[1].'" id="wows1_'.$i.'">';
                    echo'<li>';
                    if ($dat[4])
                        echo '<a href="'.$dat[4].'" '.($dat[8] ? ' target="_blank"' : '').'>'.$img.'</a>';
                    else
                        echo $img;
                    echo'</li>';
                }
                echo'
        	</ul>
        </div>
    	<div class="ws_bullets">
            <div>';
                foreach ($tab as $i=>$dat)
                    echo'<a href="#" title="'.$alt[$i].'"><span><img src="datafiles/wowslider/sm/'.$dat[5].'" alt="'.$alt[$i].'"/></span></a>';
        		echo'
        	</div>
        </div>
        <div class="ws_shadow"></div>
    </div>';
    echo $edit['button'];
    echo'
</div>';