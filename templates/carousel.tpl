<?php 
    /*
    Caption  http://jsfiddle.net/Et4pc/153/ 
    Широкий  http://www.bootply.com/59900   http://stackoverflow.com/questions/16350902/bootstrap-carousel-full-screen  - Bootstrap Carousel Full Screen
    data-interval="1000"
    */     
    
    if (!$tab) {
        if ($edit)
            echo '<div style="position:relative">'.pp($edit['button']).'</div>';
        return;   
    }
        
    if ($xdat[3])
        $hstyle = ' style="height:'.$xdat[3].'px"'; // ;overflow-y:hidden с этим появляется полоса прокрутки внизу при выносе стрелок за пределы
        
    $intervalAttrs = ($xdat[6]) ? ' data-interval="'.$xdat[6].'"' : '';
    
    echo'
    <style>
        #block-'.$block.' .carousel-control.left {background-image:none}
        #block-'.$block.' .carousel-control.right {background-image:none}';
        if ($xdat[4]) {
            echo'
            #block-'.$block.' .carousel-control.left {left: -110px;}
            #block-'.$block.' .carousel-control.right {right: -110px;}';
        }
        echo'
    </style>';
?>
<div>
    <div id="block-<?=$block?>" class="carousel slide" data-ride="carousel"<?=$intervalAttrs.$hstyle?>>
        <div class="carousel-inner" role="listbox" style="height: 100%;">
            <?php
            $countHidden = 0;
            $indicators = '';
            foreach ($tab as $i=>$dat) {
                if ($dat[2]){
                    $countHidden++;
                    continue;
                }
                $alt = ($dat[3])
                    ? Text::stripTags($dat[3], 'strip-quotes')
                    : ''
                ;
                if ($i==0) {
                    $activeClass = ' active'; # The .active class needs to be added to one of the slides. Otherwise, the carousel will not be visible.    
                    $activeAttr = ' class="active"';
                } else {
                    $activeClass = '';
                    $activeAttr = '';
                }
                
                if ($xdat[3]) { # Постоянная высота баннера
                    if ('левая часть' == $dat[5])
                        $bgPosition = 'left';
                    elseif ('правая часть' == $dat[5])
                        $bgPosition = 'right';
                    else # 'средняя часть'
                        $bgPosition = 'center';
                    $img = '<div style="width:100%;height:100%;background:url(datafiles/'.$dat[1].');background-size:cover;background-position:'.$bgPosition.';">&nbsp;</div>';
                } else # баннер будет уменьшаться пропорционально
                    $img = '<img alt="'.$alt.'" src="datafiles/'.$dat[1].'" data-holder-rendered="true" style="width:100%">';
                    
                if ($dat[4])
                    $hrefAttrs = 'href="'.$dat[4].'" title="'.$alt.'"'.($dat[8] ? ' target="_blank"' : '');
                    
                echo'
                <div class="item'.$activeClass.'" style="height: 100%;">';
                    if ($dat[6] || $xdat[3]) { # Текст (html-код) поверх баннера или картинка находится в блоке
                        echo $img;
                        $stretch = 'display:block; position:absolute; top:0; bottom:0; left:0; right:0';
                        if ($dat[6])
                            echo'<div style="'.$stretch.'">'.$dat[6].'</div>';
                        if ($dat[4] && !$dat[7])
                            echo '<a '.$hrefAttrs.' style=" text-decoration: none;'.$stretch.'">&nbsp;</a>';
                    } else { # Обычная картинка (не в фоне)
                        if ($dat[4])
                            echo '<a '.$hrefAttrs.' style="display:block">'.$img.'</a>';
                        else
                            echo $img;
                    }
                    echo'
                </div>';
                if (!$xdat[1])
                    $indicators .= '<li data-target="#block-'.$block.'" data-slide-to="'.$i.'"'.$activeAttr.'></li>';
            }
            echo'
        </div>';
        
        if ($i and (count($tab)-$countHidden)>1) {  # Более одного баннера 
            # indicators
            if (!$xdat[1])
                echo'<ol class="carousel-indicators" style="bottom:0">'.$indicators.'</ol>';
            if (!$xdat[2]) {
                ?>
                <a class="left carousel-control" href="#block-<?=$block?>" role="button" data-slide="prev">
                    <span class="glyphicon glyphicon-chevron-left" aria-hidden="true"></span>
                    <span class="sr-only">Previous</span>
                </a>
                <a class="right carousel-control" href="#block-<?=$block?>" role="button" data-slide="next">
                    <span class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span>
                    <span class="sr-only">Next</span>
                </a>
                <?php 
            } 
        } ?>
        <?=$xdat[5]?>
        <?= pp($edit['button']) ?>
    </div>
    <?=$xdat[8]?>
</div>