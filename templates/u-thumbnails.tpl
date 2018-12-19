<?php

    /**
     * @origin avtograd ---осаго    ---omega-prom   ---Росокна Саламандер       ---avtozaim1    ---недракам 
     * @todo Ликвидировать $xdat[7] сделать чисто BS как в u-services.tpl
     * @todo При окрашивании фона становится видна разница в высоте. "Height:100" не помогает. Придется использовать js - считывать высоту родителя, заданную плагином conform, и ставить ее.
     */
       
    Blox::addToFoot(Blox::info('templates','url').'/assets/conformity/conformity.js');
    Blox::addToFoot(Blox::info('templates','url').'/assets/conformity/row-conformity.js', ['after'=>'conformity/conformity.js']);
    Blox::addToHead(Blox::info('templates','url').'/assets/conformity/row-conformity.css');

    
    # Автоматический расчет ширины для разных устройств
    if (!$xdat[7]) {
        # Соответствие между шириной иконки при lg и шириной при меньших экранах (построить эмпирически - см. #done)
        #done  *    **      *       *   ?   *   ??  ??  ??  ?   ??  *       done* /redone ***
        #lg = [1,	2,	    3,	    4,	5,	6,	7,	8,	9,	10,	11,	12];    см. $xdat[1]
        $md = [2,	2,	    3,	    4,	5,	6,	7,	8,	9,	10,	11,	12];    
        $sm = [3,	4,   	4/*6*/,	4,	5,	6,	7,	8,	9,	10,	11,	12];
        $xs = [4,	6,	    6,	    6,	5,	12,	7,	8,	9,	10,	11,	12];
    }


        
    if (empty($tab))
        return;

    if (empty($xdat))
        Blox::prompt('Отсутствуют экстраданные блока '.$blockInfo['id'].' (<b>'.$blockInfo['tpl'].'</b>). Попробуйте изменить время модификации файла templates/'.$blockInfo['tpl'].'.tdd (пересохраните).', true);
    
    /*.u-thumbnails .thumbnail-style a.btn-more:hover {box-shadow:0 0 0 2px #0d53a0}  Зеленая обводка ярлыка */
    echo'
    <div class="u-thumbnails" id="block-'.$block.'" style="position:relative;">';
        # Заголовок
        if ($xdat[2]) {
            #$align = $xdat[3] ? '' : '; text-align:center';    
            #echo'<div class="row"><h3 style="margin:0 0 22px'.$align.'">'.$xdat[2].'</h3></div>';
            echo'<div class="headline'.($xdat[3] ? ' text-center':'').'"><h2>'.$xdat[2].'</h2></div>';   
        }
        echo'
        <div class="row row-conformity'.($xdat[3] ? ' row-center':'').'">';
            $w = $xdat[1] - 1;
            foreach ($tab as $i=>$dat) {
                $alt = Text::truncate(Text::stripTags($dat[5] ?: $dat[3],'strip-quotes'), 200, 'plain');
                $img = '<img style="width:100%;height:auto" src="'.($dat[1] ? 'datafiles/'.$dat[1] : Blox::info('cms','url').'/assets/px.gif').'" alt="'.$alt.'">';//class="img-responsive"
                if ($dat[2]) {
                    $href = Router::convert($dat[2]);
                    $img = '<a href="'.$href.'" title="">'.$img.'</a>';
                }
                $colsClasses = 
                    $xdat[7] ?: 
                    'col-xs-'.$xs[$w].' col-sm-'.$sm[$w].' col-md-'.$md[$w].' col-lg-'.$xdat[1]
                ;
                echo'
                <div class="'.$colsClasses.'">
                    <div class="thumbnails thumbnail-style thumbnail-kenburn">
                    	<div class="thumbnail-img">
                            <div class="overflow-hidden">'.$img.'</div>';
                            if ($dat[5]) {
                                if ($href)
                                    echo'<a class="btn-more hover-effect" href="'.$href.'" title="">'.$dat[5].'</a>';
                                else
                                    echo'<a class="btn-more hover-effect" href="'.$href.'" title="">'.$dat[5].'</a>';
                                    //echo'<span class="btn-more hover-effect">'.$dat[5].'</span>';
                            }
                            echo'
                        </div>';
                        if ($dat[3] || $dat[4]) {                        
                            echo'
                            <div class="caption">'; // caption - от bootstrap
                                if ($dat[3]) {
                                    echo'<h3>';
                                    if ($href) 
                                        echo'<a href="'.$href.'" title="">'.$dat[3].'</a>';
                                    else 
                                        echo'<span>'.$dat[3].'</span>';
                                    echo'</h3>';
                                }
                                if ($dat[4]) 
                                    echo $dat[4];
                            echo'
                            </div>';
                    }                                                
                    echo'
                    </div>
            	</div>';
            }
            echo pp($edit['button'],-2);
        echo'
        </div>';
    echo'
    </div>';
