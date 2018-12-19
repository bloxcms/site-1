<?php
if ($GLOBALS['yandex-map']['tab']) {
    echo'<ol>';
    foreach ($GLOBALS['yandex-map']['tab'] as $dat) { 
        echo'<li><b>'.$dat[2].'</b>. '.$dat[3].'. '.$dat[4].'</li>';
    }
    echo'</ol>';
}
