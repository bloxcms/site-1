<?php /*ORIGIN: ижмин  */ 
$style = 'position:relative;';
qq($blockInfo);
if ($blockInfo['delegated-id'])
    $style.= $dat[3];
?>
<div class="text-scroll" style="<?=$style?>">
    <div class="text-scroll-head"><?=$dat[1]?></div>
    <div class="text-scroll-body"><?=$dat[2]?></div>
    <?=$dat['edit']?>
</div>
    
