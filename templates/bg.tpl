<?php
/**
 * @origin transcoin
 */

$clasAttr = ($dat[7]) ? ' class="'.$dat[7].'"' : '';
echo'
<style>';
    # Первый фон (фото)
    echo'#block-'.$block.' {position:relative';//; padding:0
    if ($dat[8])
        echo';'.$dat[8];
    if ($dat[2]) {
        echo';background-image:url(datafiles/'.$dat[2].');background-position:center';
        if ('покрыть'== $dat[3])
            echo';background-size:cover;background-repeat:no-repeat';
        # Parallax
        if ($dat[6]) {
            /**
             * Plugin: jQuery Parallax
    	     * .parallax(xPosition, speedFactor, outerHeight) options:
    	     *     xPosition - Horizontal position of the element
    	     *     inertia - speed to move relative to vertical scroll. Example: 0.1 is one tenth the speed of scrolling, 2 is twice the speed of scrolling
    	     *     outerHeight (true/false) - Whether or not jQuery should use it's outerHeight option to determine when a section is in the viewport
             */
             Blox::addToFoot(Blox::info('templates','url').'/assets/plugins/jquery.parallax.js');
             Blox::addToFoot('<script>$(document).ready(function(){$("#block-'.$block.'").parallax()})</script>');
             echo';background-attachment: fixed;';
        }
    }
    echo'}';
    # Второй фон
    if ($dat[4])
        echo' #block-'.$block.':before {top:0;left:0;width:100%;height:100%;content:" ";position:absolute;'.$dat[4].'}';
    echo'
</style>

<div id="block-'.$block.'"'.$clasAttr.'>';
    if ($dat[5])
        echo'<div class="container" style="position: relative;">'.$dat[1].'</div>';
    else
        echo $dat[1];
    echo pp($dat['edit'], 0, 0, 2).'
</div>';
    
    
    
