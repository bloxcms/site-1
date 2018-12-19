<?php 
#REQUIRE: bootstrap-btn.css
#ORIGIN: коляиоля.рф

/**
    Применяется класс .btn от bootstrap
    Если сам bootstrap не подключен, то подключить bootstrap-btn.css (см. в актуальных): Blox::addToHead('templates/bootstrap-btn.css');
*/

# maintainScroll
Blox::addToFoot(Blox::info('cms','url').'/assets/jquery.cookie.js');
Blox::addToFoot(Blox::info('cms','url').'/assets/blox.maintain-scroll.js');

$paddings = array(
    'xs' => array(1=>10, 2=>19, 3=>28, 4=>37),
    'sm' => array(1=>14, 2=>23, 3=>32, 4=>41),
    ''   => array(1=>16, 2=>26, 3=>36, 4=>46),
    'lg' => array(1=>22, 2=>33, 3=>45, 4=>57),
);
    
   
# Поиск переносов <br>
$maxConter = 0;
$minConter = 0;
foreach ($tab as $k => $dat) {
    $counter = substr_count($dat[2], '<br');    
    if ($counter > $maxConter)
        $maxConter = $counter;
    if ($counter < $minConter)
        $minConter = $counter;
    $counters[$k] = $counter;
}



if ($xdat[2]) 
    echo '<div class="horizButtonsMenuWrap">';  

    if (empty($xdat[2])) {
        echo'
        <div class="headline">
            <h2>'.$xdat[3].'</h2>
        </div>';
    }
    else
        echo '<h2>'.$xdat[3].'</h2>';

    echo'    
    <div class="horizButtonsMenu">
        <ul>';
        foreach ($tab as $k => $dat) {
            //$href = Router::convert('?page='.$dat[3], array('name'=>$dat[2]));
            if ($dat['rec']) {
            echo'<li';
            echo'><a href="'.$dat[3].'"';        
            echo'class="btn';//blox-maintain-scroll
            if ($xdat[1])
                echo' btn-'.$xdat[1];        
            if ($dat[4])
                echo' btn-'.$dat[4];            
            //if ($dat[3] == $page)
                //echo' disabled';
            echo'"';
            if ($diff = $maxConter - $counters[$k])
                echo' style="padding-top:'.$paddings[$xdat[1]][$diff].'px; padding-bottom:'.$paddings[$xdat[1]][$diff].'px"';
            echo'>'.$dat[2].'</a></li>';
            }
        }
        echo'
        </ul>'.pp($edit['button']).'
    </div>';
if ($xdat[2]) 
    echo '</div>';
    
    
        
