<?php

/**
 * Для галереи нужны только дети и родитель
 * Если отображать древо не нужно, то как узнать родительскую категорию?
 * -    она уже сидит 
 * -    выводить древо скрыто
 * -    делать отдельный запрос
 *
 * @todo Сделать в дереве админа пунктиры
 * @todo Сделать сортировку пуктов
 */
/**
if ($udat['arrange-items']) {
    require_once'templates/shop/catalog/update-items-visibility.php';
    shopCatalog_updateItemsVisibility();
}
*/

#KLUDGE
//$GLOBALS['nav/nav']['src-block-id'] = $blockInfo['src-block-id'];
    

# Галерея категорий или административное древо (в основной колонке)
# $_GET['view']=='tree' или $_GET['view']=='gallery'
if (false) //if (isset($GLOBALS['shop/catalog/goods/setting'])) 
{
    # Переключение режима древа
    if ($edit) {
        if ($_GET['view']=='tree')
            $_SESSION['nav/nav']['view'] = 'tree';
        elseif ($_GET['view']=='gallery')
            $_SESSION['nav/nav']['view'] = '';
    } else
        $_SESSION['nav/nav']['view'] = '';
        
    # Меню навигации (многоуровневый список в виде полностью развернутого древа). Вид для админа
    if ($_SESSION['nav/nav']['view']=='tree') {
        $aa = Nav::get([$blockInfo['src-block-id']]);
        $records = $aa['records'];
        $nodes = Nav::getNodes($blockInfo['src-block-id']);
        Blox::addToHead('templates/nav/themes/edit/nav.css');
        if (!function_exists('getNodes0')) {
            function getNodes0($nodes, &$records) {
                if ($nodes) {
                    $htm = '<ul>';
                    foreach ($nodes as $node) {
                        $numOfItemsHtm = '';
                        if ($node['id']) {
                            $numOfItemsHtm =' #'.$node['id'];
                            if ($node['num-of-items'])
                                $numOfItemsHtm.= ' <span class="badge">'.$node['num-of-items'].'</span>';
                        }
                        $liClass ='';
                        $liClass.= ($node['active']) ? ' active' : '';
                        $liClass.= ($records[$node['id']][3]) ? ' nav-nav-hidden' : '';
                        $liAttr = ($liClass) ? ' class="'.substr($liClass, 1).'"' : '';
                        $htm.= '
                        <li'.$liAttr.'>
                            <span class="tree-item-indent">&nbsp;</span><a href="'.$node['href'].'">'.$node['name'].$numOfItemsHtm.'</a>
                            '.getNodes0($node['children'], $records).'
                        </li>';
                    }
                    $htm.= '</ul>';
                }
                return $htm;
            }
        }
        echo'
        <nav class="treemenu">
            '.getNodes0($nodes, $records).'
        </nav>';
    } 
    # Галерея категорий
    else {
        Blox::addToHead('templates/nav/themes/gallery/nav.css');
        $nav = Nav::get([$blockInfo['src-block-id']]);
        $thumbClass = $xdat[7] ?: 'col-xs-6 col-sm-4 col-md-4 col-lg-3';
        $htm .='<div class="row row-conformity'.($xdat[6]?' row-center':'').'">';
            $childrenIds = $nav['children'][$nav['active-nav-id']];
            if ($childrenIds) {
                foreach($childrenIds as $navId) {
                    $navInfo = $nav['records'][$navId];
                    $thumbClass0 = ($navInfo['parent-id']==0 && $xdat[10]) ? $xdat[10] : '';
                    # Photo
                    if ($navInfo['file'])
                        $imgFile = 'dataFiles/nav/nav/'.$navInfo['file'];
                    elseif ($navInfo['name'])
                        $imgFile = 'templates/nav/themes/gallery/images/emptyminiphoto.png';
                    else
                        $imgFile = 'templates/nav/themes/gallery/images/nominiphoto.png';
                    # alt   
                    $alt = '';
                    if ($navInfo['name'] && $navInfo['file'])
                        $alt = Text::stripTags($navInfo['name'], 'strip-quotes');
                    #img
                    $img = '<img class="img" src="'.$imgFile.'" alt="'.$alt.'">';
                    # Caption
                    $afterCaption = '';
                    $aboveCaption = '';
                    if ($navInfo['name']) {
                        if ($navInfo['file']) {
                            if (!$xdat[9]) {
                                $afterCaption = '
                                <div class="caption-after">
                                    <a href="'.$navInfo['href'].'"><h4>'.$navInfo['name'].'</h4></a>
                                </div>';
                            }
                        } else
                            $aboveCaption = '<a class="caption-above" href="'.$navInfo['href'].'"><h4>'.$navInfo['name'].'</h4></a>';
                    }
                    $hidden = ($navInfo[3]) ? ' nav-nav-hidden' : '';
                    $htm .='
                    <div class="nav-thumbnail '.($thumbClass0 ?: $thumbClass).$hidden.'">';
                        if ($aboveCaption)
                            $htm .= '<div class="thumbnail">'.$img.$aboveCaption.'</div>';
                        else {
                            $htm .= '<a class="thumbnail" href="'.$navInfo['href'].'">'.$img.'</a>';
                            $htm .= $afterCaption;
                        }
                        #
                        if ($navInfo['edit-href'])
                            $htm .= pp('<small title="Номер категории">'.$navInfo['edit'].' #'.$navId.'</small>',18,-17);
                        elseif (Blox::info('user','user-is-editor'))
                            $htm .= pp('<small title="Номер категории">#'.$navId.'</small>',18,-17);
                    $htm .='</div>';
                }
            }
            if ($edit) { # New rec
                $htm .='<div class="nav-thumbnail '.($thumbClass0 ?: $thumbClass).'">';
                    $htm .= '<span class="thumbnail"><img class="img" src="templates/nav/themes/gallery/images/new-category.png" alt=""></span>';
                    $htm .= pp('<small title="Создать новую категорию"><span class="blox-edit-button blox-maintain-scroll" style="margin-right:3px" href="'.$edit['new-rec']['href'].'&defaults[2]='.($nav['active-nav-id'] ?: '0').'"><img src="'.Blox::info('cms','url').'/assets/edit-button-new-rec.png" alt="+" /></span></small>',18,-17);
                $htm .='</div>';
            } 
        $htm .='</div>';
        echo $htm;
    }
    /**
    if ($edit) {
        Query::capture();
        $GLOBALS['nav/nav']['toggleView'] = '
            <a type="button" class="btn btn-default'.($_SESSION['nav/nav']['view'] != 'tree' ? ' disabled' : '').'" href="?'.Query::build('view=gallery').'" title="Отобразить категории каталога в виде галереи"><i class="fa fa-th"></i></a>
            <a type="button" class="btn btn-default'.($_SESSION['nav/nav']['view'] == 'tree' ? ' disabled' : '').'" href="?'.Query::build('view=tree').'"    title="Отобразить категории каталога в виде многоуровневого списка"><i class="fa fa-list-ul"></i></a>';
    }
    */
}   
# Меню навигации (вылеташка или в сортировке товаров)
else {
    $fields = [
        'name'	         => 4,
        'parent-id'       => 2,
        'alt-headline'    => 5,
        'alt-url'	     => 6,
        'ancestors-limit' => 7,// numOfVisibleAncestors path  'name'   steps numOfHigherAncestors    numOfUnforgottenAncestors
        'file'           => 8,
        'num-of-items'     =>10,
    ];
    $options = [
        'target-block-id' => $xdat[1],
        'target-field' => $xdat[2],
        'target-page-id' => $xdat[3],
        'hide-non-active' => $xdat[5],
        'initial-headline' => $xdat[13],
        //'items-pick' => 'pick[9][ne]=1',
        'show-empty-branches' => $xdat[11],
    ];
    //$options['no-edit-buttons'] = true;
    Nav::init($blockInfo, $tab, $fields, $options);
    
    # Меню навигации (многоуровневый список) в основном каталоге (not delegating)
    # TODO: Оптимизировать режим "Выводить только первый уровень меню", то есть не выводить все древо.
    ##if (!$blockInfo['delegated-id']) 
    {
        # For li-icon
        $records = Nav::get([$blockInfo['src-block-id'], 'records']);
        $nodes = Nav::getNodes($blockInfo['src-block-id'], 'no-edit-buttons');

        $themeFile = 'templates/nav/themes/'.$xdat[12].'/init.php';
        if (file_exists($themeFile))
            $themeFeatures = include $themeFile; # $themeFeatures пока не используется
        $metisTheme = in_array($xdat[12], ['metis-vertical','metis-vertical-hover']) ? $xdat[12] : '';
        $level = 1;
        if (!function_exists('getNodes2')) {
            function getNodes2($nodes, $level, &$records, $metisTheme='') {
                if ($nodes) {
                    $ulAttr = ($metisTheme && 1==$level) ? ' class="metismenu"' : '';
                    $level++;
                    $htm = '<ul'.$ulAttr.'>';
                    foreach ($nodes as $node) {
                        $liClass = '';
                        if ($node['active']) {
                            $liClass .= ($metisTheme == 'metis-vertical-hover')
                                ? ' selected'
                                : ' active'
                            ;
                            ##if (!$node['children'])
                                ##$GLOBALS['nav/nav']['lowestActiveNavId'] = $node['id'];
                        }
                        $navInfo = $records[$node['id']];
                        if ($node['id']) {
                            if ($aa = $navInfo[9])
                                $liClass .= ' '.$aa;
                        }
                        $liAttr = ($liClass) ? ' class="'.substr($liClass, 1).'"' : '';
                        $aAttr = ($node['children'] && $metisTheme)
                            ? ' class="has-arrow"' 
                            : ''
                        ;
                        $htm.='
                        <li'.$liAttr.'>
                            <a'.$aAttr.' href="'.$node['href'].'">'.$node['name'].'</a>';
                                $htm.= getNodes2($node['children'], $level, $records, $metisTheme);
                            $htm.='
                        </li>';
                    }
                    $htm.= '</ul>';
                    
                }
                return $htm;
            }
        }
        echo'
        <nav class="nav-nav"  id="block-'.$block.'">
            '.getNodes2($nodes, $level, $records, $metisTheme).'
        </nav>';
    }

}   