<?php /**
https://stackoverflow.com/questions/10797632/simulate-background-sizecover-on-video-or-img  второй ответ
*/
?>
<div class="video-fixedheight"<?=($dat[8] ? ' style="height:'.$dat[8].'"' : '')?>>
    <div class="video-fixedheight-wrap">
        <video autoplay="autoplay" loop="loop">
            <?php    
            if ($dat[1])
                echo'<source src="datafiles/'.$dat[1].'" type="video/mp4">';
            if ($dat[2])
                echo'<source src="datafiles/'.$dat[2].'" type="video/ogg">';
            if ($dat[3])
                echo'<source src="datafiles/'.$dat[3].'" type="video/ogv">';
            if ($dat[4])
                echo'<source src="datafiles/'.$dat[4].'" type="video/webm">';
            if ($dat[5])
                echo'<img class="img-responsive" src="datafiles/'.$dat[5].'" title="" alt="" />';
            ?>
            <!-- Ваш браузер не поддерживает видеопроигрыватель -->
        </video>
    </div>
    <div class="video-fixedheight-overlay"<?=($dat[6] ? ' style="'.$dat[6].'"' : '')?>></div>
    <div class="video-fixedheight-content"><?=$dat[7].pp($dat['edit'])?></div>
</div>