<?php

function getCatsGalleryHtm($complexId, $navTab, $xdat)
{
   
    $htm .='<div class="row row-conformity">';
    
    # Когда пункты навигации не показываются в дереве, нужно показывать кнопки редактирования в галерее
    $pagehrefQuery = '&pagehref='.Blox::getPageHref(true);
    $permissions = Permission::get('record', [$GLOBALS['blog/nav'][$complexId]['src-block-id']])[''];
    $parentInfo = $GLOBALS['blog/nav'][$complexId]['ancestorsInfo'][$navTab[0][2]];
    if ($parentInfo['level'] >= $GLOBALS['blog/nav'][$complexId]['maxLevel']) 
        $childsAreNotShownInMenu = true;

    foreach($navTab as $i=>$navDat)
    {
        $miniphoto = $navDat[3];

        if (($miniphoto))
            $imgFile = 'datafiles/blog/nav/'.$miniphoto;
        else
            $imgFile = Blox::info('templates','url').'/blog/images/nominiphoto.png';

        $img = '<img class="img" src="'.$imgFile.'" alt="'.Text::stripTags($navDat[1]).'">';

        $phref  = '?page='.$GLOBALS['blog/goods'][$complexId]['srcPageId'].'&block='.$GLOBALS['blog/goods'][$complexId]['src-block-id'].'&p[10]='.$navDat['rec'];
        $href = Router::convert($phref);

        $title = $navDat[1] ? ' title="'.$navDat[1].'"' : '';
                
        if ($xdat[2]) 
            $thumbClass = ' '.$xdat[2]; 
        else 
            $thumbClass = ' col-xs-6 col-sm-4 col-md-3 col-lg-3';         
        $htm .='<div class="blog-thumbnail'.$thumbClass.'">';
            $htm .= '<a class="thumbnail" href="'.$href.'">'.$img.'</a>';            
            $htm .= '<div class="caption">';
                if ($permissions['edit'] && $childsAreNotShownInMenu)
                    $htm .= '<a class="blox-edit-button blox-maintain-scroll" title="Редактировать пункт навигации" href="?edit&block='.$GLOBALS['blog/nav'][$complexId]['regularId'].'&rec='.$navDat['rec'].$pagehrefQuery.'"><img src="'.Blox::info('cms','url').'/assets/edit-button-edit-rec.png" alt="&equiv;"/></a>';
                $htm .= '<a href="'.$href.'">'.$navDat[1].'</a>';
            $htm .= '</div>';
        $htm .='</div>';
    }
    # Новая запись
    if ($permissions['create'] && $childsAreNotShownInMenu) {
        $htm .='<div class="blog-thumbnail'.$thumbClass.'">';
            $htm .= '<a class="thumbnail text-center" href="?edit&block='.$GLOBALS['blog/nav'][$complexId]['regularId'].'&rec=new&parent='.$navDat[2].$pagehrefQuery.'" title="Добавить категорию или статью"><span class="glyphicon glyphicon-plus">Добавить</span></a>';            
        $htm .='</div>';
    }
    
    $htm .='</div>';
    
    return $htm;
}




