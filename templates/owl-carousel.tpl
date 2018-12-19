<?php

/**
 * Базовый шаблон карусели для картинок.
 * При создании новых шаблонов на основе owlCarousel, например: owl-carousel-news, оставляйте папку owl-carousel общей для всех.
 */
?>

<style>
    .owl-theme .caption {text-align:center; padding-top: 7px; font-size:16px}
    .owl-theme .owl-carousel a {display:block}
    /* Custom
    .owl-theme .owl-nav [class*='owl-']:hover {background: #4DC7A0}
    .owl-theme .owl-dots .owl-dot.active span, .owl-theme .owl-dots .owl-dot:hover span {background: #4DC7A0}
    */
</style>

<div class="owl-theme" style="position:relative" id="block-<?=$block?>">
    <?php 
    if ($xdat[6] && $tab)
        echo'<div class="owl-headline">'.$xdat[6].'</div>';
    /** Reserve
    <div class="owl-nav-container"></div>
    */ 
    ?>
    <div class="owl-carousel">
        <?php
        foreach ($tab as $dat) {
            $alt = Text::truncate(Text::stripTags($dat[2],'strip-quotes'), 200, 'plain');
            echo'
            <div class="item">';
                if ('открывать большое фото' == $xdat[7]) {
                    if ($dat[1]) {
                        $img = '<img src="datafiles/owl-carousel/'.$dat[1].'" alt="'.$alt.'">';
                        echo ($dat[4]) 
                            ? '<a rel="fancybox-gallery-'.$block.'" href="datafiles/owl-carousel/'.$dat[4].'" title="'.$alt.'" class="fancybox">'.$img.'</a>'
                            : $img
                        ;
                    }
                    if ($dat[2])
                        echo'<div class="caption">'.$dat[2].'</div>';
                } elseif ('переходить по ссылке' == $xdat[7]) {
                    $htm = '';
                    if ($dat[1])
                        $htm.= '<img src="datafiles/owl-carousel/'.$dat[1].'" alt="'.$alt.'">';
                    if ($dat[2])
                        $htm.= '<div class="caption">'.$dat[2].'</div>';
                    # Entire div is a link
                    echo ($dat[3]) 
                        ?'<a href="'.$dat[3].'" title="'.$alt.'">'.$htm.'</a>'
                        : $htm
                    ;
                }
                echo pp($dat['edit']);
                echo' 
            </div>';        
        }
        ?>
    </div>    
    <?=pp($edit['button'], -4, -8, 1)?>
</div>

