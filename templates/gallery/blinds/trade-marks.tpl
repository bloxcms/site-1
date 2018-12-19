<?php    
//qq('trade-marks.tpl');
return function($dat) {
    echo'
    <div class="gallery-blinds-trade-marks">
        <div>';
            if ($dat[2])
                echo'<p><small>Дата приоритета:</small><br><b>'.$dat[2],'</b></p>';
            if ($dat[3])
                echo'<p><small>Номер свидетельства:</small><br><b>'.$dat[3].'</b></p>';
            if ($dat[4]) {
                
                //if (mb_strtolower(substr($dat[4], 0, 4)) == 'http') {
                if (preg_match('~^.*?//~', $dat[4])) {
                    $scheme = '';
                    $text = preg_replace('~^.*?//~', '', $dat[4]);
                } else {
                    $scheme = 'http://';
                    $text = $dat[4];
                }
                echo'<p><small>Сайт:</small><br><a href="'.$scheme.$dat[4].'" target="_blank"><b>'.$text.'</b></a></p>';
            }
            echo'
        </div>
    </div>';
};