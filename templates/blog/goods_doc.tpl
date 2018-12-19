<?php
    $siteName = 'perfect-sound-pro.ru';
    
    if (!$dat['edit'])
        echo'<a href="?download&file='.$dat[1].'" class="fancybox btn-u btn-u-sm" ><i class="fa fa-cloud-download"></i> &nbsp;Скачать прайс-лист</a>';
    
    echo'
    <div style="padding-top:25px">';
    if ($dat['edit']) {
        echo $dat['edit'].'<br>Для отображения документа перейдите в режим просмотра<br><span style="color:#f00">Не забыть заменить имя домена на реальное в файле showPrice.tpl</span>';
    }
    elseif ($dat[1]) {
        $maxW = ($dat[2]) ? $dat[2] : 640;
        $maxH = ($dat[3]) ? $dat[3] : 640;
        
        echo'
        <iframe height="'.$maxH.'px" src="http://docs.google.com/viewer?url=http%3A%2F%2F'.urlencode($siteName).'%2Fdatafiles%2F'.$dat[1].'&amp;embedded=true" style="border: none;" width="'.$maxW.'px"></iframe>';
    }   
    echo'
    </div>';
    
    
    

        