<?php
function getCatsGalleryHtm($catId)
{   
    
    $xdat = Dat::get(['tpl'=>'media/nav', 'src-block-id'=>$GLOBALS['media/nav']['block']], [], 'x');
    $colClass = '';
    foreach ([11=>'xs', 12=>'sm', 13=>'md', 14=>'lg'] as $field => $type) {
        if ($xdat[$field])
            $colClass .= 'col-'.$type.'-'.$xdat[$field].' ';
    }
    
    #Для уровня у которого есть "дети" показываем категории галереи
    $sql  = 'SELECT * FROM `'.Blox::info('db','prefix').'$media/nav` WHERE dat2=? AND `block-id`=?';
    $sql .= ' ORDER BY '.(($GLOBALS['media']['sortNavList']) ? 'dat1' : 'sort');
    $tab = Sql::select($sql, [$catId, $GLOBALS['media/nav']['block']], '', true);
    
    $htm .='<div class="row row-conformity">';
    
    foreach($tab as $dat) {
        $miniphoto = $dat[3];
        if (($miniphoto))
            $imgFile = 'datafiles/media/catalog/'.$miniphoto;
        else
            $imgFile = Blox::info('templates','url').'/media/images/nocatphoto.png';
        $img = '<img class="img img-responsive" src="'.$imgFile.'" alt="'.$dat[1].'">';
        $phref  = '?page='.$GLOBALS['media']['page'].'&block='.$GLOBALS['media/goods']['block'].'&p[10]='.$dat['rec'];
        $href = Router::convert($phref);
        $title = $dat[1] ? ' title="'.$dat[1].'"' : '';                
        $htm .='<div class="'.$colClass.'media-thumbnail">';
            $htm .= '<a class="thumbnail img-hover-v1" href="'.$href.'"><span>'.$img.'</span></a>';            
            $htm .= '<div class="caption">';
                $htm .= '<a href="'.$href.'">'.$dat[1].'</a>';
            $htm .= '</div>';
        $htm .='</div>';        
    }
    $htm .='</div>';    
    return $htm;
}