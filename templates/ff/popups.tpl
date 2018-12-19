<?php 
//qq($_GET); 
if (Blox::ajaxRequested()) { # Вывод в модальном окне 
    # Меняем данные блока popup на другие, переданные через параметры URL
    $dat2 = ($_GET['ff-popups'])
        ? Arr::mergeByKey($dat, $_GET['ff-popups'])
        : $dat
    ;
    $styleAttr = ($dat2[4])
        ? ' style="'.$dat2[4].'"'
        : ''
    ;
    # Размеры окна
    $sizeAttr = ($dat2[3])
        ? ' data-modal-dialog-size="'.$dat2[3].'"'
        : ''
    ;

    $headerStyleAttr = ($dat2[1])
        ? ''
        : ' style="background-color:transparent; border-bottom:0"'
    ;
    ?>
    <div class="modal-content"<?=$styleAttr.$sizeAttr?>>
        <div class="modal-header bg-primary" <?=$headerStyleAttr?>>
            <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
            <h3 class="modal-title" style="margin-right:22px; color:inherit"><?=$dat2[1]?></h3>
        </div>
        <div class="modal-body">
            <?=$dat2[2]?>
        </div>
        <?=pp($dat2['edit'])?>
    </div>
    <?php 
} elseif ($edit) { # Вывод на странице
	//echo $edit['button']; 
    echo '<h4>Шаблон <b>ff/popups</b></h4>';
    echo'<a href="'.$edit['href'].'" class="btn btn-default">Настройка всплывающих окон</a>'; 
}
