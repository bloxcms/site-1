<?php
# ORIGIN: rosokna-.ru   ---omega-prom    ---toolm ---челныдизель   


/**
 * @todo Сделать alt на увеличенную в fancybox картинку в шаблонах paragraphs.tpl и blog/goods.tpl
 */
 


 
if ('unify' == $GLOBALS['blog']['theme']) {
    $u = '-u';
    $primary   = '';
    $secondary = ' btn-u-default';
} else {
    $u = '';
    $primary   = ' btn-primary';
    $secondary = ' btn-default';
}
    
/**
TODO, KLUDGE: 
-   Эти две ветви if не оптимизированы.
-   Нужно учесть что данные _goods уже выведены штатно. Не годиться - $params['dont-output-block'], нужно пиком отрубить 
*/
# Идентификатор комплекта блоков с шаблонами blog/*
$complexId = $xdat[6];
$navBlockInfo = Blox::getBlockInfo($GLOBALS['blog/nav'][$complexId]['regularId']);

# Блок делегирован на главную
if ($blockInfo['delegated-id']) 
{
    require Blox::info('templates','dir').'/blog/blog.inc'; # Здесь вычисляется $complexId
    echo'<div class="blog-goods">';# id="#allArticles"
        # Категории, которые не являются ничьими родителями, т.е. найти записи с recid, которые не упоминаются в поле 2. 
        # Хотя если начать писать статью прямо с категории, то это условие не подойдет, но мы договоримся, что сразу с самого верха не создаем статей.
        # Иначе дополнительно нужно проверить и goods, а лучше сразу обратиться к этой таблице.
        $tbl = Blox::getTbl('blog/nav');
        /** Для варианта без пагинации, проще
        $sql  = 'SELECT * FROM '.$tbl.' WHERE dat2<>0 AND dat11<>1 AND `rec-id`<>ANY(SELECT dat2 FROM '.$tbl.') ORDER BY dat9 DESC LIMIT 10';
        $navTab = Sql::select($sql,[],'', true);
        */
        #\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
        # Варианта с пагинацией
        

        $navTdd = Tdd::get($navBlockInfo);
        #TODO: Replace "`rec-id`<>ANY" by "`rec-id` NOT IN"
        $xSql = 'AND '.tbl.'.dat2<>0 AND '.tbl.'.dat11<>1 AND '.tbl.'.`rec-id`<>ANY(SELECT '.tbl.'.dat2 FROM '.$tbl.')';// ORDER BY dat9
        Request::add('block='.$GLOBALS['blog/nav'][$complexId]['src-block-id'].'&limit=5&sort[9]=desc');
        $navTab = Request::getTable($tbl, $GLOBALS['blog/nav'][$complexId]['src-block-id'], '', $xSql, $navTdd);
        $navPartRequest = Request::get($GLOBALS['blog/nav'][$complexId]['src-block-id'],'part');
        # Ссылки на соседние записи
        $navPartsNav ='';
            if ($navPartRequest['prev'] || $navPartRequest['next']) {
                $cl='';
                if (empty($navPartRequest['prev'])) 
                    $cl=' disabled';
                $navPartsNav .=' <a href="'.Router::convert('?page='.$page.'&block='.$GLOBALS['blog/nav'][$complexId]['src-block-id'].'&part='.$navPartRequest['prev']).'#allArticles" class="btn'.$u.$primary.' btn'.$u.'-sm'.$cl.'" rel="nofollow"><span class="glyphicon glyphicon-chevron-left"></span> Позже</a>';
                $cl='';
                if (empty($navPartRequest['next'])) 
                    $cl=' disabled';
                $navPartsNav .=' <a href="'.Router::convert('?page='.$page.'&block='.$GLOBALS['blog/nav'][$complexId]['src-block-id'].'&part='.$navPartRequest['next']).'#allArticles" class="btn'.$u.$primary.' btn'.$u.'-sm'.$cl.'" rel="nofollow">Раньше <span class="glyphicon glyphicon-chevron-right"></span></a>';
            }
        
        if ($navPartsNav)
            echo'<div style="margin-bottom:11px"><nav>'.$navPartsNav.'</nav></div><hr>';
        #////////////////////////////////////////////////////////////////

        require_once Blox::info('templates','dir').'/blog/getCatsPreviewsHtm.php';
        echo getCatsPreviewsHtm($complexId, $navTab, $xdat);        
        echo '<hr><div style="margin-top:55px">'.$navPartsNav.'</div>';
    echo'</div>';  
}
else # Блок находится на основной странице (не главной)
{
    Blox::addToHead(Blox::info('cms','url').'/vendor/fancybox/jquery.fancybox.css');
    Blox::addToFoot(Blox::info('cms','url').'/vendor/fancybox/jquery.fancybox.js', ['position'=>'bottom']);
    Blox::addToFoot(Blox::info('cms','url').'/vendor/fancybox/jquery.fancybox.settings.js', ['after'=>'jquery.fancybox.js']);

    $pick10request = Request::get($block, 'pick', 10, 'eq');
    #Определяем есть ли категория, которая должна открыться по умолчанию и осуществляем переход
    if (!$pick10request) {
        if (empty($edit) && !isset($_GET['change']) && !isset($_GET['check']) && !Blox::ajaxRequested()) {
            if ($navRows2 = Sql::select('SELECT * FROM '.Blox::getTbl('blog/nav').' WHERE `block-id`=? AND dat7=1 AND dat11<>1 LIMIT 1', [$GLOBALS['blog/nav'][$complexId]['src-block-id']])) {
                Url::redirect(Router::convert('?page='.$page.'&block='.$block.'&p[10]='.$navRows2[0]['rec-id']),'exit');
            }
        }
    }
    #Вывод общей информации для категорий и статей
    $currInfo = $GLOBALS['blog/nav'][$complexId]['ancestorsInfo'][$pick10request];

    echo'
    <div class="blog-goods">';
        # Ссылки на соседние записи
        $singlesNav ='';
        if ($currInfo['level'] > 0) {
            # Up
            $breadcrumbs = Router::getBreadcrumbs();# Можно сделать не через $breadcrumbs, а через $currInfo, как в shop, но потребуется блок blog/nav
            $parentKey = count($breadcrumbs) - 2;
            if ($parentKey > 0)
                $singlesNav .=' <a href="'.$breadcrumbs[$parentKey]['href'].'" class="btn'.$u.$primary.' btn'.$u.'-sm" title="'.$breadcrumbs[$parentKey]['name'].'"><span class="glyphicon glyphicon-chevron-up"></span></a>';
            # Prev and next
            if ($GLOBALS['blog/nav'][$complexId]['currNeighbors']['prev'] || $GLOBALS['blog/nav'][$complexId]['currNeighbors']['next']) {# Есть ссылки на соседние записи
                # Prev
                $cl='';
                if (!$GLOBALS['blog/nav'][$complexId]['currNeighbors']['prev'])
                    $cl=' disabled';
                $singlesNav .=' <a href="'.$GLOBALS['blog/nav'][$complexId]['currNeighbors']['prev']['href'].'" class="btn'.$u.$primary.' btn'.$u.'-sm blox-maintain-scroll'.$cl.'" title="'.$GLOBALS['blog/nav'][$complexId]['currNeighbors']['prev']['text'].'" rel="prev"><span class="glyphicon glyphicon-chevron-left"></span> Предыдущий</a>';
                # Next
                $cl='';
                if (!$GLOBALS['blog/nav'][$complexId]['currNeighbors']['next'])
                    $cl=' disabled';
                $singlesNav .=' <a href="'.$GLOBALS['blog/nav'][$complexId]['currNeighbors']['next']['href'].'" class="btn'.$u.$primary.' btn'.$u.'-sm blox-maintain-scroll'.$cl.'" title="'.$GLOBALS['blog/nav'][$complexId]['currNeighbors']['next']['text'].'" rel="next">Следующий <span class="glyphicon glyphicon-chevron-right"></span></a>';           
                # Output all
                echo '
                <div class="row" style="margin-bottom:11px">
                    <div class="col-xs-12"><nav>'.$singlesNav.'</nav></div>
                </div>';
            } else {
                # Output only "Up"
                echo'<div class="pull-left" style="margin:4px 13px 0 0"><nav>'.$singlesNav.'</nav></div>';
            }
        }

        if ($_GET['tag'])
        {
            $taggedArticlesList = $GLOBALS['blog/nav'][$complexId]['taggedArticlesList'][$_GET['tag']];
        	echo'<h1>Статьи с тегом "'.$_GET['tag'].'"</h1>';	
            $sql ='SELECT * FROM '.Blox::getTbl('blog/nav').' WHERE `rec-id` IN('.$taggedArticlesList['marks'].') AND `block-id`='.(int)$GLOBALS['blog/nav'][$complexId]['src-block-id'].' AND dat11<>1 ORDER BY sort DESC';
        	$navTab = Sql::select($sql,[$taggedArticlesList['values']],'', true);
            
            if (
                !$navTab[1] # Найдена только одна статья с таким тегом . Перенаправляем на саму статью                      
                && $navTab[0]['rec'] 
            ) {
                if (Blox::getScriptName() == 'main') {
                    Url::redirect(
                        Router::convert('?page='.$GLOBALS['blog/goods'][$complexId]['srcPageId'].'&block='.$GLOBALS['blog/goods'][$complexId]['src-block-id'].'&p[10]='.$navTab[0]['rec']),
                        ['loop-protection', 'exit', 'status'=>307]
                    );
                }
            }
            # Если перенаправление не удалось, то показать галерею
        	require_once Blox::info('templates','dir').'/blog/getCatsPreviewsHtm.php';
        	echo getCatsPreviewsHtm($complexId, $navTab, $xdat);
        }
        else
        {			
        	#Заголовок статьи
            echo'
            <div class="pull-left">'; # Чтобы не перекрывалась кнопка "Выше"
                if ($currInfo['headline']) 
                    $headline = $currInfo['headline'];
                elseif ($currInfo['name']) 
                    $headline = $currInfo['name'];
                elseif ($xdat[1]) {
                    if ('--' !== $xdat[1]) # TODO лучше поставить галочку?
                        $headline = $xdat[1];
                } else 
                    $headline = 'Статьи';
                    
                if ($headline)
                    echo'<h1>'.$headline.'</h1>';
                echo'
            </div>';
            
            echo'<div style="clear:both"></div>';

            # Определяем режим отображения категорий, вместо самой статьи
            if ($currInfo['childs'] || isEmpty($pick10request)) {
                #Если способ вывода содержит категории, то осуществляем вывод категории
                if (in_array($currInfo['view'], ['ГАЛЕРЕЯ','АНОНСЫ','ТАБЛИЦА'])) {
                    #Для уровня у которого есть "дети" показываем категории статей            
                    if ('ПО-ДАТЕ' == $GLOBALS['blog/nav'][$complexId]['sorting'])
                        $sortQuery = '&sort[9]=desc';
                    elseif ('ПО-НАЗВАНИЮ' == $GLOBALS['blog/nav'][$complexId]['sorting'])
                        $sortQuery = '&sort[1]=asc';
                    else
                         $sortQuery = '';
                    #TODO: Этот запрос действует на блок навигации, но это не страшно, так как блок навигации уже выведен. Тогда $navTab можно получить заранее, а не здесь! 
                    Request::add('block='.$GLOBALS['blog/nav'][$complexId]['regularId'].'&p[2]='.$pick10request.'&pick[11][ne]=1'.$sortQuery);
                    $navTab = Request::getTab($navBlockInfo, Tdd::get($navBlockInfo));
                }
            }

            if ($navTab) 
            {
                if (
                    !$navTab[1] # Найдена только одна статья с таким тегом . Перенаправляем на саму статью                      
                    && $navTab[0]['rec'] 
                ) {
                    if (Blox::getScriptName() == 'main') {
                        Url::redirect(
                            Router::convert('?page='.$GLOBALS['blog/goods'][$complexId]['srcPageId'].'&block='.$GLOBALS['blog/goods'][$complexId]['src-block-id'].'&p[10]='.$navTab[0]['rec']), 
                            ['loop-protection', 'exit']
                        );
                    }
                } 
                # Если перенаправление не удалось, то показать галерею
                if (in_array($currInfo['articleLocation'], ['','НЕТ','СНИЗУ'])) {
                    if ('ГАЛЕРЕЯ'==$currInfo['view']) {
                        require_once Blox::info('templates','dir').'/blog/getCatsGalleryHtm.php';
                        echo getCatsGalleryHtm($complexId, $navTab, $xdat);
                    } elseif ('АНОНСЫ'==$currInfo['view']) {
                	    require_once Blox::info('templates','dir').'/blog/getCatsPreviewsHtm.php';
                		echo getCatsPreviewsHtm($complexId, $navTab, $xdat);
                    } elseif ('ТАБЛИЦА'==$currInfo['view']) {
                	    require_once Blox::info('templates','dir').'/blog/getCatsTableHtm.php';
                		echo getCatsTableHtm($complexId, $navTab, $xdat);
                    }
                }
            }


            # Непосредственно вывод самой статьи, а не галереи или анонсов категорий
            # TODO Учесть 'НЕТ'!=$currInfo['articleLocation'] то есть не выводить статью, когда она прямо запрещена. Пока не получается, так как $navTab пусто
            if (!$navTab || in_array($currInfo['articleLocation'], ['СВЕРХУ','СНИЗУ']))
            {

                if ($xdat[4]) {
            		echo'
            		<ul class="list-unstyled list-inline blog-info">';
            			echo'<li><i class="fa fa-calendar" title="Дата публикации"></i> '.date('d.m.Y', strtotime($currInfo['date'])).'</li>';#Дата                
                        if ($currInfo['parent']['name'])
                            echo'<li><span class="glyphicon glyphicon-th-list small"></span> <a href="'.Router::convert($currInfo['parent']['href']).'">'.$currInfo['parent']['name'].'</a></li>';
            			require_once Blox::info('templates','dir').'/blog/getArticleTagsHtm.php';#Теги
            			echo getArticleTagsHtm($currInfo['tags']);
            		    echo'
                    </ul>';
                }
                
                echo'
                <div class="blog-paragraphs">';
                if ($tab) 
                {
                    # Предпоследний элемент цепочки
                    end($GLOBALS['blog/nav'][$complexId]['ancestorsInfo']);
                    $xdat7 = $xdat[7];
                    if ($xdat7!==null) {
                        if ($xdat7 < 0) {
                            $xdat7 = count($tab) + $xdat7;
                            if (!$dat['edit'])
                                $xdat7++;
                        }
                        if ($dat['edit'] && stripos($xdat[5], 'blox-noTpl') !== false)
                            $note7 = ' <span class="small">Вставка блока с другой функциональностью</span>';
                        
                    }
                    foreach ($tab as $ser => $dat)
                    {
                        if ($xdat7!==null && $xdat7==0 && $ser===0)
                            echo '<div>'.$xdat[5].$note7.'</div>';
                        echo'
                        <div style="position:relative'.($dat[11] ? '; background:'.$dat[11] : '').'">';
                            ##################### Подготовка установок #####################
                            $img = '';
                            $floatTo = '';                
                            if (!empty($dat[4])) 
                            {                                                                   
                                # Альтернатива подписи к фото
                                if ($dat[5]) # подпись к фото
                                    $alt = $dat[5];
                                elseif ($dat[1]) # заголовок 2
                                    $alt = $dat[1];
                                elseif ($headline) # заголовок 1
                                    $alt = $headline;
                                    
                                if ($alt)
                                    $alt = Text::stripTags($alt,'strip-quotes');

                                # Выводим нужное фото          
                                if ($dat[6] > 40) 
                                    $imgSrc = 'datafiles/blog/goods/'.$dat[3]; # выводим большое фото
                                else 
                                    $imgSrc = 'datafiles/blog/goods/'.$dat[4];#  выводим маленькое фото 
                                $img = '<img src="'.$imgSrc.'" alt="'.$alt.'" class="img-responsive" />';
                                # Разрешить открывать фото в отдельном окне
                                if ($dat[8]) 
                                    $img = '<a data-fancybox-group="block-'.$block.'" href="datafiles/blog/goods/'.$dat[3].'" title="'.$dat[5].'">'.$img.'</a>';
                                
                                # Фото уплывает 
                                if ($dat[7] !='центр')
                                    $floatTo = ($dat[7]=='вправо') ? 'floatRight' : 'floatLeft'; 
                                else 
                                    $floatTo = 'floatNone';                     
                            }                             
                            ##################### Вывод #####################
                            if ($dat[1])
                                echo'<h3'.($ser==0 ? ' class="first"' : '').'>'.$dat[1].'</h3>'; # Первый загловок h2 без паддинга сверху
                            
                            $textHtm = $dat[2] ?: '&nbsp;'; //Выводим пустышку, когда нет контента, чтобы кнопки не накладывались друг на друга
                            # Фото
                            if ($img) {
                                echo'<div class="'.$floatTo.'" style="width:'.$dat[6].'%">';
                                    echo $img;
                                    if ($dat[5] && !$dat[12]) 
                                        echo'<div class="photoCaption small"><strong>'.$dat[5].'</strong></div>';
                                echo'</div>';
                                echo $textHtm;
                                echo'<div style="clear:both; font-size:0px;"></div>';
                            }else{
                                echo'<div style="position:relative; clear:both;">';
                                    if (!$dat['rec']) echo"<span style='font-size:11px;'> Новая запись</span>";
                                    echo $textHtm;
                                echo'</div>';
                            }	
                            echo pp($dat['edit'], -16, -5);						
                			echo'
                        </div>';
                        # После N-го параграфа идет доп.блок с другой функциональностью, например для цен.
                        if ($xdat7!==null && $xdat7==($ser+1)) 
                            echo '<div>'.$xdat[5].$note7.'</div>';
                        
                    }
                    if ($xdat7!==null && $xdat7 > ($ser+1)) # Еще не выводилось
                        echo '<div>'.$xdat[5].$note7.'</div>';
                    Blox::addToFoot('<script>$(function(){$(".blog-paragraphs table").addClass("table table-condensed table-bordered table-striped")})</script>');
                } else {                        
                    echo '<div>'.$xdat[5].'</div>';
                }
                echo'
                </div>'; 
                include 'vkComments.inc';
                if ($xdat[3]) {
                    echo '<div style="margin-top:55px; text-align:center">'.$singlesNav.'</div>';
                    /*
                    if ($tab) 
                    { ?>
                        <br>
                        <div style="text-align:center">
                            <!-- Поделиться -->
                            <script type="text/javascript" src="//yastatic.net/share/share.js" charset="utf-8"></script><div class="yashare-auto-init" data-yashareL10n="ru" data-yashareType="link" data-yashareQuickServices="vkontakte,facebook,twitter,odnoklassniki,moimir"></div>
                        </div>
                      <?php
                    }
                    */
                }
            } #/ Вывод статьи

            if ($navTab) {
                if ('СВЕРХУ'==$currInfo['articleLocation']) {
                    if ('ГАЛЕРЕЯ'==$currInfo['view']) {
                        require_once Blox::info('templates','dir').'/blog/getCatsGalleryHtm.php';
                        echo getCatsGalleryHtm($complexId, $navTab, $xdat);
                    } elseif ('АНОНСЫ'==$currInfo['view']) {	
                	    require_once Blox::info('templates','dir').'/blog/getCatsPreviewsHtm.php';
                		echo getCatsPreviewsHtm($complexId, $navTab, $xdat);
                    } elseif ('ТАБЛИЦА'==$currInfo['view']) {	
                	    require_once Blox::info('templates','dir').'/blog/getCatsTableHtm.php';
                		echo getCatsTableHtm($complexId, $navTab, $xdat);
                    }
                }
            }
        }
        echo'
    </div>'; 
}