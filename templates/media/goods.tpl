<?php 
    # Assets
    Blox::addToHead(Blox::info('templates','url').'/assets/docs.min.css');
    Blox::addToHead(Blox::info('cms','url').'/vendor/fancybox/jquery.fancybox.css');
    Blox::addToFoot(Blox::info('cms','url').'/vendor/fancybox/jquery.fancybox.pack.js');
   
    Blox::addToFoot(Blox::info('templates','url').'/assets/conformity/conformity.js');
    Blox::addToFoot(Blox::info('templates','url').'/assets/conformity/row-conformity.js', ['after'=>'conformity/conformity.js']);
    Blox::addToHead(Blox::info('templates','url').'/assets/conformity/row-conformity.css');

    //Blox::addToHead('templates/assets/js/fancy-box.js'); 
    # Own
    Blox::addToHead(Blox::info('templates','url').'/media/goods.css');
    Blox::addToFoot('
        <script>
        $(function(){
            $("a[rel=gallery]").fancybox({						
                    "overlayOpacity"    : 0.3,
        			"overlayColor"		: "#000",
                    "titlePosition"	    : "inside",
                    "autoScale"	        : false,
                    "loop"	            : false,
                    "centerOnScroll"    : true,
        	})
        })
        </script>',
        'minimize'
    );
    # Настройки подписи под фото    
    /*
    if ($xdat[9])
        $captionStyle .= 'min-height:'.$xdat[9].'px;';
    if ($xdat[10])
        $captionStyle .= 'font-size:'.$xdat[10].'px;line-height:'.round($xdat[10]*1.2).'px;';
    if ($xdat[11])
        $captionStyle .= 'font-weight:bold;';
    if ($captionStyle)
        Blox::addToHead('<style>.media-photoItem .caption {'.$photoItemStyle.$captionStyle.'}</style>');
    */        
    
    $colClass = '';
    foreach ([5=>'xs', 6=>'sm', 7=>'md', 8=>'lg'] as $field => $type) {
        if ($xdat[$field])
            $colClass .= 'col-'.$type.'-'.$xdat[$field].' ';
    }


    #Определяем есть ли категория, которая должна открыться по умолчанию и осуществляем переход
#Mir
#Добавил  and !$xdat[12]
    if (empty($edit) && !Request::get($GLOBALS['media/goods']['block'], 'pick', 10, 'eq') and !$xdat[12]) {
        $rowsNav = Sql::select('SELECT * FROM `'.Blox::info('db','prefix').'$media/nav` WHERE `block-id`=? AND dat7=1 LIMIT 1', [$GLOBALS['media/nav']['block']]);
        if ($rowsNav) {
            #Определяем, если нет подкатегории, то задаем сортировку товара
            $sql = "SELECT * FROM `".Blox::info('db','prefix')."$media/nav` WHERE dat2=?";
            $rows = Sql::select($sql, [$rowsNav[0]['rec-id']]);
            if (empty($edit) && !isset($_GET['change']) && !isset($_GET['check']) && !Blox::ajaxRequested())
                Url::redirect(Router::convert('?page='.$page.'&block='.$block.'&p[10]='.$rowsNav[0]['rec-id'],'exit'));
        }
    }

    #Вывод общей информации для категорий и галереи
    $ancestorsList = $GLOBALS['ancestorsList'][Request::get($GLOBALS['media/goods']['block'], 'pick', 10, 'eq')];
//qq(Request::get($block,'pick',10,'eq'));
echo'
<div class="media-goods">
    <div class="clearfix">';
        #Выводим кнопку возврата на уровень выше
        if (Request::get($block,'pick',10,'eq')) { # Не первый уровень
            $breadcrumbs = Router::getBreadcrumbs();
            $parentKey = count($breadcrumbs) - 2;
            if ($parentKey > 0) {
                echo'
                <div class="pull-left" style="margin:4px 13px 0 0">
                    <a class="btn btn-primary btn-sm" href="'.$breadcrumbs[$parentKey]['href'].'" title="'.$breadcrumbs[$parentKey]['name'].'"><span class="glyphicon glyphicon-chevron-up"></span></a>
                </div>';
            }
        }
        

        #Заголовок галереи
        if ($ancestorsList['name']) 
            echo'<div class="media-headline"><h1>'.$ancestorsList['name'].'</h1></div>';
        echo'
    </div>';

    #Вывод доп. текста перед галереей
    if ($ancestorsList['show'] == 'ТЕКСТ' || $ancestorsList['show'] == 'ТЕКСТ-ГАЛЕРЕЯ') 
        echo '<div class="media-text">'.$ancestorsList['text'].'</div>'; 

    #Вывод галереи
#Mir
    #Добавил  or empty($ancestorsList)
    if (strpos($ancestorsList['show'], 'ГАЛЕРЕЯ') !== false or empty($ancestorsList))
    {
        #Определяем есть ли категории для вывода
#Mir
        #Добавил  and !$xdat[12]
        if (($ancestorsList['childs'] || isEmpty(Request::get($GLOBALS['media/goods']['block'], 'pick', 10, 'eq'))) && !$xdat[12]) { 
            require_once Blox::info('templates','dir').'/media/get-cats-gallery-htm.php';
            echo getCatsGalleryHtm(Request::get($block, 'pick', 10, 'eq'));// catId
        } else {      
#Mir
            if ($xdat[12])
                $tab = Sql::select('SELECT * FROM '.Blox::getTbl('media/goods').' WHERE `block-id`=?', [$block],'',true);
            #End Mir
            echo '
            <div class="row row-conformity">';
                foreach ($tab as $dat)
                {
                    # Подпись и ее производные: title, alt
                    $caption = '';
                    $title = '';
                    $alt = '';
                    if ($dat[3]) {
                        $caption = $dat[3];
                        $title = $alt = Text::stripTags($dat[3],'strip-quotes'); //Убирание лишних кавычек и прочих тегов
                    } elseif ($dat[1] && $xdat[9]) {
                        if ($xdat[10])
                            $caption = $title = Str::getStringBeforeMark($dat[1], '.', true) ?: $dat[1];
                        else
                            $caption = $title = $dat[1];
                    }
                            
                    if ($dat[2]) 
                        $imgSrc = 'src="'.Blox::info('site','url').'/datafiles/media/photo-sm/'.$dat[2].'" alt="'.$alt.'"';
                    else 
                        $imgSrc = 'src="'.Blox::info('templates','url').'/media/images/nophoto.png" alt=""';
                    echo'
                    <div class="'.$colClass.'media-photoItem">';
                        $attr = 'title="'.$title.'" rel="gallery"';
                        if ($dat[4]) { # video          
                            $href = $dat[4];
                            echo'
                            <a href="'.$href.'" class="img-hover-v1 fancybox.iframe" '.$attr.'>
                                <span>
                                    <img class="img-responsive" '.$imgSrc.'>
                                    <img src="'.Blox::info('templates','url').'/media/images/player.png" class="player-icon">
                                </span>
                            </a>';
                        } else { # photo
                            $href = Blox::info('site','url').'/datafiles/media/photo/'.$dat[1];
                            echo'
                            <a href="'.$href.'" class="img-hover-v1" '.$attr.((!$dat[1] || !$dat[2]) ? ' onClick="return false;"':'').'>
                                <span>
                                    <img class="img-responsive" '.$imgSrc.'>
                                </span>
                            </a>';
                        }
                        echo'
                        <div class="caption">'.$caption.'</div>';# Убрал ссылку так как при сквозном проходе fancy дублируются фото
                        if ($dat['edit']) { 
                            echo'
                            <div style="position:absolute; top:2px; left:19px">'.$dat['edit'].'</div>
                            <div style="position:absolute; top:2px; right:20px">'.$dat['delete'].'</div>';
                        }
    
                    echo'                   
                    </div>';                                                                              
                }
                if ($edit) { 
                    echo'
                    <div class="'.$colClass.'media-photoItem">
                        <a href="'.$edit['new-rec']['href'].'" class="img-hover-v1" title="Добавить фото/видео">
                            <span><img class="img-responsive" src="'.Blox::info('templates','url').'/media/images/addPhoto.png" alt="addPhoto">
                        </a>
                    </div>';
                }
            echo'
            </div>';
        }
    }
    
    #Вывод доп. текста после галереи    
    if ($ancestorsList['show'] == 'ГАЛЕРЕЯ-ТЕКСТ') 
        echo '<div class="media-text">'.$ancestorsList['text'].'</div>';
    
    echo'
</div>';