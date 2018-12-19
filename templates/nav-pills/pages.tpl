<?php
/**
    @origin planeta ---мцпк
*/

if (empty($tab))
    return;
if ($xdat[3]) {
    echo'
    <style>
        .nav-pills-pages li > a {padding-left:29px}
        .nav-pills-pages {position:relative} 
        .nav-pills-pages span.glyphicon, .nav-pills-pages i.fa, .nav-pills-pages i.fas, .nav-pills-pages i.far {position:absolute; top:12px; left:11px; display: block}
        .nav-pills-pages .nav-justified > li > a {text-align:left}
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
<nav class="nav-pills-pages" style="position:relative">
    <ul class="nav '.$view.$justified.'">';// nav-stacked  nav-pills
        foreach ($tab as $dat) {   
            $clas = '';
            $href = Router::convert('?page='.$dat[3], ['name'=>$dat[2]]); # Превратить параметрическую ссылку в ЧПУ 
            if (Router::hrefIsAncestor($href)) 
                $clas .= ' active'; 
            elseif ($dat[3] == $page) 
                $clas .= ' disabled';
            $clas = ($clas) ? ' class="'.substr($clas, 1).'"' : '';
            echo'
            <li'.$clas.'><a href="'.$href.'">'.$xdat[3].$dat[2].'</a></li>';
        }
        echo'
    </ul>
    '.pp($edit['button'],-4,-8).'
</nav>';
        

