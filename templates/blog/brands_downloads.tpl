<?php
if (!$tab)
    return;

# Размеры колонок
$cols = [
  'xs'=>6,
  'sm'=>6,
  'md'=>4,
  'lg'=>3,
];

$colsClass = '';
foreach ($cols as $k=>$v) {
    if ($v)
        $colsClass .= ' col-'.$k.'-'.$v;
}
$colsClass = substr($colsClass, 1);
?>

<div class="thumbnails"> 
    <h3>Скачать каталоги производителя</h3>
    <div class="row">
    <?php    
    foreach ($tab as $dat) 
    {
        if (!$dat['rec']) 
            continue;
            
        $imgAttr = ' alt=""';
        $aAttr = ' target="_blank"';
        
        if ($dat[5]) {
            $href = urlencode('datafiles/blog/goods/brands_downloads/'.$dat[5]);
            $aAttr .= ' href="?download&url='.$href.'"';
        } else
            $imgAttr .= ' style="opacity:0.5"';
        
        if ($dat[6])
            $aAttr .= ' download';
        
        if ($dat[3])
            $imgAttr .= ' src="datafiles/blog/goods/brands_downloads/'.$dat[3].'"';
        else {
            $imgAttr .= ' src="'.Blox::info('templates','url').'/images/nophoto262.png"';
            $imgAttr .= ' style="opacity:0.6"';
        }
        ?>
        <div class="<?=$colsClass?>">
            <div class="thumbnail">
                <a<?=$aAttr?>>
                    <img<?=$imgAttr?> />
                    <div class="caption"<?=($xdat[2] ? 'style="height:'.$xdat[2].'px"' : '')?>>
                        <?=$dat[2]?>
                    </div>
                </a>
            </div>
        </div>
    <?php 
    }
    ?>
    </div>
    <?=pp($edit['button'],-15,2)?>
</div>