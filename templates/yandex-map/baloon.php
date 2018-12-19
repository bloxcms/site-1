<?php 
if ($dat[9]) {
    $clas1 = 'col-xs-5';
    $clas2 = 'col-xs-7';
} else {
    $clas1 = 'hidden-xs';
    $clas2 = 'col-xs-12';
}
?>


<div class="row">
    <div class="<?=$clas1?>">
        <?php
        $img = '<img class="img-responsive" src="datafiles/yandex-map/'.$dat[9].'">';
        if ($dat[8])
            echo'<a data-fancybox-group="block-'.$blockInfo['id'].'" title="'.$dat[2].'" href="datafiles/yandex-map/'.$dat[8].'">'.$img.'</a>';
        else
            echo $img;
        ?>
    </div>
    <div class="<?=$clas2?>">
        <h4 style="margin-top:0"><?=$dat[2]?></h4>
        <p><?=$dat[3]?></p>
        <p style="margin-bottom:0"><?=$dat[4]?></p>
    </div>
</div>
<?php if ($_GET['field']==4) { ?>
<div class="row">
    <div class="col-xs-12 text-center" style="padding:10px 0px 4px; border-top:solid 2px #ddd">
            <button data-yandexmap-recid="<?=$dat['rec']?>" data-yandexmap-srcblockid="<?=$blockInfo['srcBlockId']?>" class="btn btn-success" >Доставить в эту аптеку</button>
    </div>
</div>
<?php } ?>