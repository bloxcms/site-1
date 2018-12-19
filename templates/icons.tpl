<?php

/**
 * @origin avtoversant 2017-10-03 16:34 ---eskulap  ---nemstandart
 */


//if (empty($tab))    return;

Blox::addToFoot(Blox::info('templates','url').'/assets/conformity/conformity.js');
Blox::addToFoot(Blox::info('templates','url').'/assets/conformity/row-conformity.js', ['after'=>'conformity/conformity.js']);
Blox::addToHead(Blox::info('templates','url').'/assets/conformity/row-conformity.css');
?>
<style>
    .icons {position:relative}
    .icons [class*=col-] {margin-top:11px; margin-bottom:11px}
    .icons a {display:inline-block}
    .icons a img {position:relative; top:0px; transition: top .4s;}
    .icons a:hover img {position:relative; top:-5px}
    .icons img {margin:0 auto}
    .icons .caption {margin-top:7px; line-height:1.2; text-align:center}
</style>
<?php
# Заголовок
if ($xdat[4] && $tab)
    echo $xdat[4];


    
$rowClass = ($xdat[2]) ? ' row-center' : '';


echo'
<div class="row icons row-conformity'.$rowClass.'" id="block-'.$block.'">';
    if ($tab) {
        foreach ($tab as $dat) {
            $alt = ($dat[3])
                ? Text::stripTags($dat[3], 'strip-quotes')
                : ''
            ;
            $colsClasses = 
                $xdat[1] ?: 
                'col-xs-6 col-sm-4 col-md-3 col-lg-2'
            ;
            $content = '';
            if ($dat[1])
                $content.= '<img class="img-responsive" src="datafiles/'.$dat[1].'" alt="'.$alt.'">';
            if ($dat[3] && !$xdat[3])                
                $content.= '<div class="caption">'.$dat[3].'</div>';
            echo'
            <div class="'.$colsClasses.'">';
                if ($dat[2])
        		    echo '<a href="'.$dat[2].'" title="'.$alt.'">'.$content.'</a>';
                else
                    echo $content;
            	echo'
            </div>';
        }
    }
    echo pp($edit['button'], 14);
    echo'
</div>';
    