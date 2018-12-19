<?php
/**
    @origin ижмин   ---avtozaim    ---челныдизель
*/


if (empty($tab))
    return;
if ($xdat[3]) {
    echo'
    <style>
        .nav-pills-downloads li > a {padding-left:29px}
        .nav-pills-downloads {position:relative} 
        .nav-pills-downloads span.glyphicon, .nav-pills-downloads i.fa, .nav-pills-downloads i.fas, .nav-pills-downloads i.far {position:absolute; top:12px; left:11px; display: block}
    </style>';
}

if ('горизонтально' == $xdat[1] || !$xdat[1])
    $view = 'nav-pills';
elseif ('вертикально' == $xdat[1])
    $view = 'nav-pills nav-stacked';
elseif ('вкладки' == $xdat[1])
    $view = 'nav-tabs';
$justified = ($xdat[2] && 'вертикально' != $xdat[1])
    ? ' nav-justified'
    : ''
;
   
echo'
<nav class="nav-pills-downloads">
    <ul class="nav '.$view.$justified.'">';
        foreach ($tab as $dat) {   
            $download = '';
            $href = '';            
            $clas = '';
            $target = ($dat[7]) ? ' target="_blank"' : '';
            if ($dat[5]) {
                if ($dat[6]) {
                    $href = '?download&file='.$dat[5];
                    $download = ' download';
                } else {
                    $href = 'datafiles/'.$dat[5];
                }
            } else
                $clas .= ' disabled';
            $clas = ($clas) ? ' class="'.substr($clas, 1).'"' : '';
            echo'
            <li'.$clas.'><a href="'.$href.'"'.$target.$download.' title="Скачать файл">'.$xdat[3].$dat[2].'</a></li>';
        }
        echo'
    </ul>
    '.pp($edit['button'],-4,-8).'
</nav>';
        

