<?php 
#ORIGIN: доставака.рф
# Вносить стиль в файл ff-lead.css этот код бесполезно, так как блок вызывается аяксом. 
?>
<style>
.ff-lead .form-group-lg .form-control {padding-left: 35px; font-weight:bold; background:#fff url(<?=Blox::info('templates','url')?>/ff/lead/icon-user.png) no-repeat 7px center}
.ff-lead .form-group-lg .form-control[name="name"] {background-image: url(<?=Blox::info('templates','url')?>/ff/lead/icon-user.png)}
.ff-lead .form-group-lg .form-control[name="phone"] {background-image: url(<?=Blox::info('templates','url')?>/ff/lead/icon-phone.png)}
.ff-lead .btn-danger, 
.ff-lead .btn-danger:focus, 
.ff-lead .btn-danger.focus {background-color: #f60309}
.ff-lead [name="form-submit"] {width: 100%; font-weight:bold; }
.ff-lead .alert.alert-success {background:green; font-size:22px; color:#fff; border:none; width:276px}
/*.ff-lead-img {border-radius:12px; box-shadow: 0px 0px 20px rgba(0,0,0,.5)}*/
<?=$dat[4]?>
</style>
<?php
if (Blox::ajaxRequested()) { # Вывод в модальном окне 
    echo'
    <div class="ff-lead" style="position:relative" id="block-'.$block.'">';
        if ($dat[1]) {
            $alt = ($dat[2]) ? Text::truncate(trim(Text::stripTags($dat[2], 'strip-quotes')), 99, 'plain') : '';
            echo '<img src="datafiles/ff/lead/'.$dat[1].'" class="ff-lead-img" alt="'.$alt.'" />';
        }
        echo'<div class="ff-lead-form">'.$dat[3].'</div>';
        echo '<img src="'.Blox::info('templates','url').'/ff/lead/icon-close.png" data-dismiss="modal" style="position:absolute; right:-33px; top:11px" />';
        echo pp($dat['edit']);
        echo'
    </div>';
} else {
    if ($edit) { # Вывод на странице
    	//echo $edit['button'];
        echo'Шаблон <b>ff/lead</b>';
        echo'<a class="btn btn-default" href="'.$edit['href'].'">Настройка всплывающих окон</a>';
    }
}
