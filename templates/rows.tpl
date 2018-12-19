<?php

/**
 * @version 2.0.1
 * @origin  transcoin2  ---planeta ---eskulap ---planeta ---avtograd   ---осагоэкспресс  ---omega-prom.ru      ---avtozaim  ---челныдизель.рф  
 * @todo вынести .rows из-под foreach
 * @update from v.1 to v.2 Обновление шаблонов rows, cols из версии 1 в 2: 
 *     В базе данных в таблице blocks заменить "cols" на "rows/cols"; Имя таблицы "tab_cols" заменить на "tab_rows$cols"
 *     После обновления, необходимо поле 7 шаблона rows/cols установить в 0.
 */

Blox::addToFoot(Blox::info('templates','url').'/assets/conformity/conformity.js');
Blox::addToFoot(Blox::info('templates','url').'/assets/conformity/row-conformity.js', ['after'=>'conformity/conformity.js']);
Blox::addToHead(Blox::info('templates','url').'/assets/conformity/row-conformity.css');


if (empty($tab))
    return;

    
foreach ($tab as $dat) {        
    
    $idAttr = '';
    $styleAttr = '';
    $style = 'position:relative;';
    /*
    if ($dat[2]) {
        $style.='background-color:';
        if ($dat[2] == 1) 
            $style.='#ececec;';
        elseif ($dat[2] == 2)
            $style.='#dddddd;';
    }
    */

    # PATCH 2016-12-07 from tinyint(1) to tinyint(4)
    if ($dat[3] == 1)
        $dat[3] = $dat2[3] = 33;
    if ($dat[4] == 1)
        $dat[4] = $dat2[4] = 33;
    if ($dat2)
        Dat::update($blockInfo, $dat2, ['rec'=>$dat['rec']]);

    if ($dat[3]) 
        $style.='padding-top:'.$dat[3].'px;';# Not margin - for backgrounds
    if ($dat[4]) 
        $style.='padding-bottom:'.$dat[4].'px;';
    if ($dat[5]) 
        $style.='opacity:0.4;';
    //if ($dat[6]) 
        //$style.='background-image:url(templates/images/shadow.png);background-repeat:no-repeat;background-position:center top;';
    $clas = 'rows row';
    if ($GLOBALS['rows/cols']['parents'][$block][$dat['rec']]['colExists']) { # Это передано с блока cols. .row нужно только если будет вложен .col-
        //$clas .=' row';
        # Conformity - equal height elements based on row rather than set
        if ($dat[10] || $GLOBALS['rows/cols']['parents'][$block][$dat['rec']]['alignVerticaly'])
            $clas .=' row-conformity';
        if ($dat[9]) # centered-columns
            $clas .= ' row-center';
    } 
    /*
    elseif ($dat['rec'] && Blox::info('user','userIsAdmin')) {
        Blox::prompt('В запись <b>'.$dat['rec'].'</b> блока <b>'.$blockInfo['id'].'(rows)</b> назначен не шаблон <b>rows/cols</b>. Рекомендуется всегда в rows сначала назначать шаблон rows/cols, особенно для блоков rows первого уровня.         <a href="?edit&block='.$blockInfo['id'].'&rec='.$dat['rec'].'&pagehref='.Blox::getPageHref(true).'" title="">Заменить вложенный блок в поле 1</a>', true);
    }
    */

    
    if ($style)
        $styleAttr =' style="'.$style.'"';                    
    if ($dat[7]) {
        $idAttr =' id="'.$dat[7].'"';    
        $toScroll = true;
        if ($dat[12]) {
            $idAttr .=' data-rows-scroll-offset="'.$dat[12].'"';
        }
    }
        
    # Закрыть контейнер с фиксированной шириной и открыть контейнер на всю ширину
    if ($dat[8]) {
        echo'
        </div>
        <div class="container-fluid" style="padding-left:0; padding-right:0">';//'.($dat[13] ? ' '.$dat[13] : '').'
    }
    echo'
    <div class="'.$clas.'"'.$idAttr.$styleAttr.'>';
        if ($dat[11])
            echo'<div class="col-xs-12 row-headline">'.$dat[11].'</div>';
        
        if ($GLOBALS['rows/cols']['parents'][$block][$dat['rec']]['colExists'])
            echo $dat[1];
        else
            echo'<div class="col-xs-12">'.$dat[1].'</div>'; # If now col than force wrap content with div.col-...
        echo'
    </div>';
    # Закрыть контейнер с полной шириной и открыть контейнер с фиксировнной шириной
    if ($dat[8]) {
        echo'
        </div>
        <div class="container">';
    }
}

/**
TODO: [href^='#'] заменить на полный URL, чтобы можно было переходить на другие страницы?
Пока все кидается на главную
*/
if ($toScroll) { 
    $js = '
    <script>
    $(\'[data-rows-scroll] [href^="#"], [data-rows-scroll][href^="#"]\').on("click", function(e) {
        e.preventDefault();
        //function(){window.location.hash = target;}
        var target = this.hash; /* Без этого hash не попадает function() */
        var xOffset = $(target).data("rows-scroll-offset");
        var xOffset2 = 0;
        if (xOffset)
            xOffset2 = Number(xOffset);
        $("html, body").animate(
            {scrollTop: $(this.hash).offset().top}, 
            1000, 
            function(){window.location.hash = target;}/* This removes xOffset2 */
        ).animate(
            {scrollTop: $(this.hash).offset().top + xOffset2}, 
            500
        );
    });
    </script>';
	if (Blox::ajaxRequested())
	    echo $js;
	else
	    Blox::addToFoot($js, ['after'=>'jquery-1'], 'minimize');
    

} ?>

