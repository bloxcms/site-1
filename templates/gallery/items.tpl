<?php
//qq('items.tpl');

/**
 * @origin logo.su
 * @todo Сделать чистку мусора в блоках
 *      Сделать чисту, если нет запросов. Если такого режима нет, то сделать спецкнопку (выгружать но не отображать)
 *      ... dat1 NOT IN()
 */
if (empty($tab))
    return;

Blox::addToFoot(Blox::info('templates','url').'/assets/conformity/conformity.js');
Blox::addToFoot(Blox::info('templates','url').'/assets/conformity/row-conformity.js', ['after'=>'conformity/conformity.js']);
Blox::addToHead(Blox::info('templates','url').'/assets/conformity/row-conformity.css');
$pagehref = Blox::getPageHref(true);
# fancybox
if ($xdat[11]) {
    # Отключить в мобильных
    $useragent=$_SERVER['HTTP_USER_AGENT'];
    if (preg_match('/(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|mobile.+firefox|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows ce|xda|xiino/i',$useragent)||preg_match('/1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-/i',substr($useragent,0,4)))
        ;
    else {
        $allowFancybox = true;
        Blox::addToHead(Blox::info('cms','url').'/vendor/fancybox/jquery.fancybox.css');
        Blox::addToFoot(Blox::info('cms','url').'/vendor/fancybox/jquery.fancybox.js', ['position'=>'bottom']);
        Blox::addToFoot(Blox::info('cms','url').'/vendor/fancybox/jquery.fancybox.settings.js', ['after'=>'jquery.fancybox.js']);
    }
    
    

}

if (empty($xdat))
    Blox::prompt('Отсутствуют экстраданные блока '.$blockInfo['id'].' (<b>'.$blockInfo['tpl'].'</b>). Попробуйте изменить время модификации файла templates/'.$blockInfo['tpl'].'.tdd (пересохраните).', true);
# Blind
if ($blindTpl = Blox::getBlockInfo($xdat['blocks'][8])['tpl']) {
    # Извлекаем данные для шторки
    foreach ($tab as $dat) {
        if ($dat['rec'])
            $recs.= ','.$dat['rec'];
    }
    if ($recs) {
        $result = Sql::query('SELECT * FROM '.Blox::getTbl($blindTpl).' WHERE `block-id`=? AND dat1 IN ('.substr($recs, 1).')', [$xdat['blocks'][8]]);
        if ($result) {
            while ($row = $result->fetch_row()) {
                $recId = $row[0];
                unset($row[0]);
                if ($row) { 
                    $sortNum = array_pop($row);
                    $blockId = array_pop($row);
                    $row = ['rec'=>$recId] + $row;
                } else { # is it necessary?
                    $row['rec'] = $recId;
                }
                $trademarks[$row[1]] = $row;
            }
            $result->free();
        }
    }
    $echoBlindContent = include_once Blox::info('templates', 'dir').'/'.$blindTpl.'.tpl';
    if (file_exists(Blox::info('templates','dir').'/'.$blindTpl.'.css'))
        Blox::addToHead(Blox::info('templates','url').'/'.$blindTpl.'.css');
    $blindEditAttr = 'class="blox-edit-button gallery-blind-edit-button blox-maintain-scroll" title="Редактировать данные в шторке"';
    $blindEditImg = '<img class="blox-edit-button-img" src="'.Blox::info('cms','url').'/assets/edit-button-edit-rec.png" alt="≡">';
    $pxUrl = Blox::info('cms','url').'/assets/px.gif';
    $blindEditHref = '?edit&block='.$xdat['blocks'][8];
}

echo'
<div class="gallery-items" id="block-'.$block.'">';
    if ($xdat[2])
        echo'<div class="gallery-items-headline'.($xdat[3] ? ' text-center':'').'">'.$xdat[2].'</div>';
    echo'
    <div class="row row-conformity'.($xdat[3] ? ' row-center':'').'">';
        foreach ($tab as $i=>$dat) {
            $alt = Text::truncate(Text::stripTags($dat[5],'strip-quotes'), 200, 'plain');
            $img = '<img src="'.($dat[4] ? 'datafiles/gallery/items/sm/'.$dat[4] : $pxUrl).'" alt="'.$alt.'">';
            if ($dat[6])
                $img = '<a href="'.Router::convert($dat[6]).'" title="">'.$img.'</a>';
            //elseif ($xdat[11] && $dat[3])
            elseif ($allowFancybox && $dat[3])
                $img = '<a data-fancybox-group="block-'.$block.'" href="datafiles/gallery/items/lg/'.$dat[3].'" title="" data-fancybox-title="'.$alt.'" >'.$img.'</a>';
            echo'
            <div class="'.$xdat[7].'">
                <div class="thumbnail">
                    <div class="gallery-items-img">';
                        echo $img;
                        if ($blindTpl) {
                            if ($dat[6] || ($xdat[11] && $dat[3]))
                                 $noPointer = ' pointer-events-none';

                            echo'
                            <div class="gallery-items-overlay'.$noPointer.'">
                                <div class="gallery-items-overlay-2">';
                                    $echoBlindContent($trademarks[$dat['rec']]);
                                    if ($dat['edit'] && $dat['rec']) {
                                        $q = ($trademarks[$dat['rec']]['rec'])
                                            ? '&rec='.$trademarks[$dat['rec']]['rec']
                                            : '&rec=new&defaults[1]='.$dat['rec']
                                        ;
                                        echo'<a href="'.$blindEditHref.$q.'&pagehref='.$pagehref.'" '.$blindEditAttr.'>'.$blindEditImg.'</a>';
                                    }
                                    echo'
                                </div>
                            </div>';
                        }
                        echo'
                    </div>';
                    if ($dat[5] && !$xdat[1]) {
                        echo'
                        <div class="caption">
                            '.$dat[5].'
                        </div>';
                    }
                    echo $dat['edit'];
                    echo'
                </div>
        	</div>';
        }
        echo'
    </div>';
    echo'
</div>';
