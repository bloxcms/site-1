<?php
# АНОНСЫ
function getCatsTableHtm($complexId, $navTab, $xdat=[])/*, $xdat*///$main - определяет, на главной ли странице выводятся превью
{	
    if ('unify' == $GLOBALS['blog']['theme']) {
        $u = '-u';
        //$primary   = '';
        $secondary = ' btn-u-default';
    } else {
        $u = '';
        //$primary   = ' btn-primary';
        $secondary = ' btn-default';
    }
        
    # Когда пункты навигации не показываются в дереве, нужно показывать кнопки редактирования в галерее
    $pagehrefQuery = '&pagehref='.Blox::getPageHref(true);
    $permissions = Permission::get('record', [$GLOBALS['blog/nav'][$complexId]['src-block-id']])[''];
    $parentInfo = $GLOBALS['blog/nav'][$complexId]['ancestorsInfo'][$navTab[0][2]];
    if ($parentInfo['level'] >= $GLOBALS['blog/nav'][$complexId]['maxLevel']) 
        $childsAreNotShownInMenu = true;


    /**
    $aaaaagetTableItemHtm2 = function($dat, $itemHref, $previewImage)//, $brief
    {
        #Вывод товарной строки             
        $htm.='            
        <tr>';
            #Вывод Фото
            $htm.='<td><a href="'.$itemHref.'"><img alt="" src="'.$previewImage.'" class="table-view-preview"></a></td>';
            #Вывод названия и основных хар-к
            $htm.='<td><h4><a href="'.$itemHref.'">'.$dat[6].'</a></h4></td>';
            $htm.='
        </tr>';
        return $htm;
    };
    */
    
    $htm.='
    <div class="table-view">
    <table>';
    foreach($navTab as $i => $navDat)
    {
        # Выбираем первый параграф статьи
		$sql   = 'SELECT * FROM '.Blox::getTbl('blog/goods').' WHERE dat10=? AND `block-id`=? ORDER BY sort ASC LIMIT 2';
        $tab = Sql::select($sql, [$navDat['rec'], $GLOBALS['blog/goods'][$complexId]['src-block-id']],'', true);
        $dat = $tab[0];
        $phref  = '?page='.$GLOBALS['blog/goods'][$complexId]['srcPageId'].'&block='.$GLOBALS['blog/goods'][$complexId]['src-block-id'].'&p[10]='.$navDat['rec'];
        $href = Router::convert($phref);
    
        
        $htm.='
        <tr>
            <td>';
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
            </td>
            <td>';
                # Заголовок						                    
                $htm .= '<h3>';
                    if ($permissions['edit'] && $childsAreNotShownInMenu)
                        $htm .= '<a class="blox-edit-button blox-maintain-scroll"  title="Редактировать пункт навигации" href="?edit&block='.$GLOBALS['blog/nav'][$complexId]['regularId'].'&rec='.$navDat['rec'].$pagehrefQuery.'"><img src="'.Blox::info('cms','url').'/assets/edit-button-edit-rec.png" alt="&equiv;"/></a> ';
                    $htm .= '<a href="'.$href.'">'.($navDat[1] ?: $navDat[4]).'</a></h3>';
                if ($xdat[4]) {
    				$htm.='
                    <ul class="list-unstyled list-inline">';// blog-info
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

                # Кнопка "Подробнее"
                //$htm.='<p><a class="btn'.$u.$primary.' btn'.$u.'-xs" href="'.$href.'">Подробнее <i class="fa fa-angle-double-right margin-left-5"></i></a></p>';            
                $htm.='    
            </td>
        </div>';
    }

    $htm.='
    </table>
    </div>';
                
    return $htm;
}