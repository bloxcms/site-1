<?php
# АНОНСЫ
function getCatsPreviewsHtm($complexId, $navTab, $xdat=[])/*, $xdat*///$main - определяет, на главной ли странице выводятся превью
{	
    if ('unify' == $GLOBALS['blog']['theme']) {
        $u = '-u';
        $primary   = '';
        $secondary = ' btn-u-default';
    } else {
        $u = '';
        $primary   = ' btn-primary';
        $secondary = ' btn-default';
    }
        
    # Когда пункты навигации не показываются в дереве, нужно показывать кнопки редактирования в галерее
    $pagehrefQuery = '&pagehref='.Blox::getPageHref(true);
    $permissions = Permission::get('record', [$GLOBALS['blog/nav'][$complexId]['src-block-id']])[''];
    $parentInfo = $GLOBALS['blog/nav'][$complexId]['ancestorsInfo'][$navTab[0][2]];
    if ($parentInfo['level'] >= $GLOBALS['blog/nav'][$complexId]['maxLevel']) 
        $childsAreNotShownInMenu = true;

    foreach($navTab as $i => $navDat)
    {
        # Выбираем первый параграф статьи
		$sql   = 'SELECT * FROM '.Blox::getTbl('blog/goods').' WHERE dat10=? AND `block-id`=? ORDER BY sort ASC LIMIT 2';
        $tab = Sql::select($sql, [$navDat['rec'], $GLOBALS['blog/goods'][$complexId]['src-block-id']],'', true);
        $dat = $tab[0];
        $phref  = '?page='.$GLOBALS['blog/goods'][$complexId]['srcPageId'].'&block='.$GLOBALS['blog/goods'][$complexId]['src-block-id'].'&p[10]='.$navDat['rec'];
        $href = Router::convert($phref);
    
        $htm.= ($i) ? '<hr>' : '';
        $htm.='
        <div class="row row-conformity blog blog-medium">
            <div class="col-md-4">
                <div class="blog-img">';
                    # Выбираем превьюшку: картинка из первого или второго параграфа, или иконка категории
                    $img = '';
                    if ($navDat[3]) # Если вдруг мы хотим в превью поставить спец.картинку, отличающуюся от картинок в статье, то используем резерв для иконки
                        $img = 'nav/'.$navDat[3];
                    elseif ($dat[4])
                        $img = 'goods/'.$dat[4];
                    elseif ($tab[1][4])
                        $img = 'goods/'.$tab[1][4];
                    
                    if ($img)    
                        $htm.='<a href="'.$href.'"><img class="img-responsive" src="datafiles/blog/'.$img.'" alt=""></a>';
                    $htm.='
                </div>
            </div>
            <div class="col-md-8">';    
                # Заголовок						                    
                $htm .= '<h3 style="margin-top:0">';
                    if ($permissions['edit'] && $childsAreNotShownInMenu)
                        $htm .= '<a class="blox-edit-button blox-maintain-scroll"  title="Редактировать пункт навигации" href="?edit&block='.$GLOBALS['blog/nav'][$complexId]['regularId'].'&rec='.$navDat['rec'].$pagehrefQuery.'"><img src="'.Blox::info('cms','url').'/assets/edit-button-edit-rec.png" alt="&equiv;"/></a> ';
                    $htm .= '<a href="'.$href.'">'.($navDat[1] ?: $navDat[4]).'</a></h3>';
                if ($xdat[4]) {
    				$htm.='
                    <ul class="list-unstyled list-inline blog-info">';
                        //if ($permissions['edit'] && $childsAreNotShownInMenu)
                            //$htm .= '<li><a class="blox-edit-button blox-maintain-scroll"  title="Редактировать пункт навигации" href="?edit&block='.$GLOBALS['blog/nav'][$complexId]['regularId'].'&rec='.$navDat['rec'].$pagehrefQuery.'"><img src="'.Blox::info('cms','url').'/assets/edit-button-edit-rec.png" alt="&equiv;"/></a></li>';

    					# Дата
                        if ($navDat[9])
                            $htm.='<li><i class="fa fa-calendar" title="Дата публикации"></i> '.date('d.m.Y', strtotime($navDat[9])).'</li>';
                        if ($navDat[2]) {
                            if ($aa = $GLOBALS['blog/nav'][$complexId]['ancestorsInfo'][$navDat[2]])
                                $bb = $aa['name'];
                            else {
                                # KLUDGE: Сделать за один запрос
                        		$sql = 'SELECT dat1 FROM '.Blox::getTbl('blog/nav').' WHERE `block-id`=? AND `rec-id`=? AND dat11<>1';
                                $bb = Sql::select($sql, [$GLOBALS['blog/nav'][$complexId]['src-block-id'], $navDat[2]])[0]['dat1'];
                            }
                            #TODO: Use $GLOBALS['blog/nav'][$complexId]['ancestorsInfo'][$navId]['href']
                            $htm.='<li><span class="glyphicon glyphicon-th-list small"></span> <a href="'.Router::convert('?page='. $GLOBALS['blog/goods'][$complexId]['srcPageId'].'&block='.$GLOBALS['blog/goods'][$complexId]['src-block-id'].'&p[10]='.$navDat[2]).'">'.$bb.'</a></li>';
                        }                    
    					#Теги
    					require_once Blox::info('templates','dir').'/blog/getArticleTagsHtm.php';
    					$htm.= getArticleTagsHtm($navDat[10]);
    				$htm.='    
                    </ul>';
                }
                # Text
			    if ($dat[2]) {
                    ## $htm .= Text::truncate($dat[2], 300); Убрал из за бага - см код метода
                    ## $htm .= Text::truncate(Text::stripTags($dat[2],'strip-quotes'), 300, 'plain');
                    $htm .= $dat[2]; # Первый параграф используется также как анонс
                }                    
                # Кнопка "Подробнее"
                $htm.='
                <p><a class="btn'.$u.$primary.' btn'.$u.'-xs" href="'.$href.'">Подробнее <i class="fa fa-angle-double-right margin-left-5"></i></a></p>';            
                $htm.='    
            </div>
        </div>';
    }
    
    # Новая запись
    if ($permissions['create'] && $childsAreNotShownInMenu) {
        $htm.='<hr>';
        $htm.='
        <div class="row row-conformity blog blog-medium">
            <div class="col-md-4"></div>
            <div class="col-md-8">
                <p>
                    <a class="btn'.$u.$secondary.' btn'.$u.'-md" title="Добавить категорию или статью" href="?edit&block='.$GLOBALS['blog/nav'][$complexId]['regularId'].'&rec=new&parent='.$navDat[2].$pagehrefQuery.'">
                        <span class="glyphicon glyphicon-plus">Добавить</span>
                    </a>
                </p>
            </div>
        </div>';
    }
                
    return $htm;
}