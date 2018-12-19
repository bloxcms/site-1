<?php
/**
 * @todo Две ветки: с идентификатором комплекта и без дублируют друг друга
 * @origin gb2  ---eskulap   ---toolm ---kalegin.ru    ---nemstandart
 */

require_once Blox::info('templates','dir').'/blog/getArticleTagsHtm.php';
$navTbl = Blox::getTbl('blog/nav');
$items = [];

if ($dat[1]) # С идентификатором комплекта
{
    $complexId = $dat[1];
    # Определить блок с заданным Идентификатором комплекта блоков или пустым
    $sql  = 'SELECT `block-id` FROM '.Blox::getTbl('blog/nav','x').' WHERE dat8=?';
    if ($navBlockId = Sql::select($sql, [$complexId])[0]['block-id']) {   
        if ($dat[4])
            $limit = ' LIMIT 50'; # Пока тупо много извлекаем
        elseif ($dat[2])
            $limit = ' LIMIT '.(int)$dat[2];
        else
            $limit = ' LIMIT 5'; # Страховка
        # Нескрытые и непустые категории
        # Категории, которые не являются ничьими родителями, т.е. найти записи с recid, которые не упоминаются в поле 2. 
        # Дополнительное требование - с картинкой и названием статьи
        $sql  = 'SELECT * FROM '.$navTbl.' WHERE `block-id`=? AND dat11<>1 AND dat1<>\'\' AND `rec-id` NOT IN(SELECT dat2 FROM '.$navTbl.' WHERE `block-id`=?) ORDER BY dat9 DESC'.$limit; ## LIMIT 10
        if ($navRows = Sql::select($sql, [$navBlockId, $navBlockId])) {
    		$sql = 'SELECT `block-id` FROM '.Blox::getTbl('blog/goods','x').' WHERE dat6=? LIMIT 1';
            if ($goodsSrcBlockId = Sql::select($sql, [$complexId])[0]['block-id'])
                $goodsSrcPageId = Blox::getBlockPageId($goodsSrcBlockId);
            else 
                return;
            $phrefBase = '?page='.$goodsSrcPageId.'&block='.$goodsSrcBlockId.'&p[10]=';
            $counter = 0;
            foreach ($navRows as $navData) {
                $src = '';
                if ($navData['dat3'])
                    $src = 'datafiles/blog/nav/'.$navData['dat3'];
                else {
            		$sql   = 'SELECT * FROM '.Blox::getTbl('blog/goods').' WHERE dat10=? AND `block-id`=? ORDER BY sort ASC LIMIT 2';
                    $goodsTab = Sql::select($sql, [$navData['rec-id'], $goodsSrcBlockId],'', true);
                    if ($goodsTab[0][4])
                        $src = 'datafiles/blog/goods/'.$goodsTab[0][4];
                    elseif ($goodsTab[1][4])
                        $src = 'datafiles/blog/goods/'.$goodsTab[1][4];
                }
                
                if ($dat[4]) {
                    if (!$navData['dat1'] || !$src) 
                        continue; # Без фото и названия не показываем и не считаем
                    else
                        $counter++;
                }

                $href = Router::convert($phrefBase.$navData['rec-id']);
                $parentNavHref = Router::convert($phrefBase.$navData['dat2']);
                $parentNavName = Dat::get(['src-block-id'=>$navBlockId, 'tpl'=>'blog/nav'], ['rec'=>$navData['dat2']])[1];
                $items[] = ['src'=>$src, 'href'=>$href, 'navData'=>$navData, 'parent'=>['href'=>$parentNavHref, 'name'=>$parentNavName]];
                if ($dat[4]) {
                    if ($counter >= $dat[2])
                        break;
                }
            }
        }
    }
}
else # Без идентификатора комплекта
{
    if ($dat[4])
        $limit = ' LIMIT 50'; # Пока тупо много извлекаем
    elseif ($dat[2])
        $limit = ' LIMIT '.(int)$dat[2];
    else
        $limit = ' LIMIT 5'; # Страховка
    # Нескрытые и непустые категории
    # Категории, которые не являются ничьими родителями, т.е. найти записи с recid, которые не упоминаются в поле 2. 
    # Дополнительное требование - с картинкой и названием статьи
    $sql  = '
        SELECT * FROM '.$navTbl.' 
        WHERE 
            dat11<>1 AND 
            dat1<>\'\' AND 
            (`rec-id`, `block-id`) NOT IN (SELECT dat2, `block-id` FROM '.$navTbl.') 
        ORDER BY dat9 DESC'.$limit;
    if ($navRows = Sql::select($sql)) {
        $counter = 0;
        foreach ($navRows as $navData) {
            if ($aa = $goodsInfo[$navData['block-id']]) {
                $goodsSrcBlockId = $aa['block-id'];
                $goodsSrcPageId = $aa['page-id'];
            } else {
        		$sql = '
                    SELECT `block-id` FROM '.Blox::getTbl('blog/goods','x').' 
                    WHERE dat6=(SELECT dat8 FROM '.Blox::getTbl('blog/nav','x').' WHERE `block-id`=? LIMIT 1) 
                    LIMIT 1';
                if ($goodsSrcBlockId = Sql::select($sql, [$navData['block-id']])[0]['block-id']) {
                    if ($goodsSrcPageId = Blox::getBlockPageId($goodsSrcBlockId))
                        $goodsInfo[$navData['block-id']] = ['block-id'=>$goodsSrcBlockId,'page-id'=>$goodsSrcPageId]; # Save goods data for other recs of the same nav block
                }
            }

            if ($goodsSrcPageId) {
                $src = '';
                if ($navData['dat3'])
                    $src = 'datafiles/blog/nav/'.$navData['dat3'];
                else {      
            		$sql = 'SELECT * FROM '.Blox::getTbl('blog/goods').' WHERE dat10=? AND `block-id`=? ORDER BY sort ASC LIMIT 2';
                    $goodsTab = Sql::select($sql, [$navData['rec-id'], $goodsSrcBlockId],'', true);
                    if ($goodsTab[0][4])
                        $src = 'datafiles/blog/goods/'.$goodsTab[0][4];
                    elseif ($goodsTab[1][4])
                        $src = 'datafiles/blog/goods/'.$goodsTab[1][4];
                }
                        
                if ($dat[4]) {
                    if (!$navData['dat1'] || !$src) 
                        continue; # Без фото и названия не показываем и не считаем
                    else
                        $counter++;
                }

                $phrefBase = '?page='.$goodsSrcPageId.'&block='.$goodsSrcBlockId.'&p[10]=';
                $href = Router::convert($phrefBase.$navData['rec-id']);
                $parentNavHref = Router::convert($phrefBase.$navData['dat2']);
                $parentNavName = Dat::get(['src-block-id'=>$navData['block-id'], 'tpl'=>'blog/nav'], ['rec'=>$navData['dat2']])[1];
                $items[] = ['src'=>$src, 'href'=>$href, 'navData'=>$navData, 'goodsInfo'=>$goodsInfo[$navData['block-id']], 'parent'=>['href'=>$parentNavHref, 'name'=>$parentNavName]];
                if ($dat[4]) {
                    if ($counter >= $dat[2])
                        break;
                }
            }
            //$items[] = ['src'=>$src, 'href'=>$href, 'navData'=>$navData, 'goodsInfo'=>$goodsInfo[$navData['block-id']], 'parent'=>['href'=>$parentNavHref, 'name'=>$parentNavName]];
        }
    }
}


# Output

if (!$items)
    return;
echo'
<style>
    #block-'.$block.' {position:relative}
    #block-'.$block.' .media-object {width:48px; height:48px}
    #block-'.$block.' .media-heading {font-size:16px}
</style>
<div id="block-'.$block.'">';
    echo $dat[5];
    echo'
    <ul class="media-list">';
        foreach ($items as $item) {
            echo'
            <li class="media">
                <div class="media-left">';
                    if ($dat[3])
                        echo'<a href="'.$href.'"><img class="media-object" src="'.$item['src'].'" alt=""></a>';
                    echo'
                </div>
                <div class="media-body">
                    <h4 class="media-heading"><a href="'.$item['href'].'">'.$item['navData']['dat1'].'</a></h4>
                    <ul class="list-unstyled list-inline blog-info small">
                    	<li><i class="fa fa-calendar" title="Дата публикации"></i> '.date('d.m.Y', strtotime($item['navData']['dat9'])).'</li>';#Дата 
                        # Два пункта будет многовато - берем или теги или родительскую категорию
                        if ($item['navData']['dat10'])
                    	    echo getArticleTagsHtm($item['navData']['dat10'], $item['goodsInfo']['page-id']);
                        elseif ($item['navData']['dat2'])
                            echo'<li><span class="glyphicon glyphicon-th-list small"></span> <a href="'.$item['parent']['href'].'">'.$item['parent']['name'].'</a></li>';
                        echo'
                    </ul>
                </div>
            </li>';
        }
        echo'
    </ul>
    '.pp($dat['edit']).'
</div>';  