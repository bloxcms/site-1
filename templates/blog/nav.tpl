<?php

# ORIGIN: мцпк
 
require Blox::info('templates','dir').'/blog/blog.inc';
$GLOBALS['blog/nav'][$complexId]['sorting'] = $xdat[2];
Blox::addToHead(Blox::info('templates','url').'/assets/docs.sidebar.css');

#######################################################
#Вывод уровней каталога
if (!function_exists('blogNavGetHtm')) # Не переделывать в аноним, так как идет самовызов.
{
    function blogNavGetHtm($complexId, $startNavId, $currentNavId,  $startLevel, $childs, $records, $newRecButton)
    {
        /*
            $startNavId   - ID категории с которой стартует вывод
            $currentNavId - номер выбранной категории
            $startLevel - номер уровня, с которого стартует вывод. Первый уровень номер = 1.
            $childs, $records   - массивы данных
            $newRecButton   - код кнопки новой записи
        */
        $getSortedData = function($complexId, $records, $startNavIdChilds) {
            #Подготовка для сортировки
            if ('ПО-ДАТЕ' == $GLOBALS['blog/nav'][$complexId]['sorting']) {
                $sortField = 9; #[9]
                $sortFunc = 'arsort';
                $dateFormat = Blox::info('site', 'dateTimeFormats', 'date');# Может понадобиться обратное преобразование формата дат к стилю SQL для сортировки, если окажется $dateFormat
            } elseif ('ПО-НАЗВАНИЮ' == $GLOBALS['blog/nav'][$complexId]['sorting']) {
                $sortField = 1; #[1]
                $sortFunc = 'asort';
            }
            $notEmptyValueExists = false;
            foreach ($startNavIdChilds as $navId) {
                if ($sortField) {
                    if ($sortValue = $records[$navId][$sortField]) {
                        $notEmptyValueExists = true;
                        if ($dateFormat) {
                            $d = DateTime::createFromFormat($dateFormat, $sortValue);
                            $sortValue = $d->format('Y-m-d') ?: '';
                            /* вариант 2 
                            $d = str_replace('.', '-', $sortValue); //Нужно?
                            $sortValue = date('Y-m-d', strtotime($d));
                            */          
                        }
                    } else
                        $sortValue = '';
                } else {
                    $sortValue = '';
                }
                $sortedData[$navId] = $sortValue;
            }
            #Сортировка
            if ($notEmptyValueExists) 
                $sortFunc($sortedData);
            return $sortedData;
        };
        
        $sortedData = $getSortedData($complexId, $records, $childs[$startNavId]);

        $htm = '';
        $htm = '
        <ul class="nav'.(($startLevel==1) ? ' bs-docs-sidenav' : '').'">';
            foreach ($sortedData as $navId => $bb)    #$bb не используется в выводе, а служит для работы foreach
            {
                if (empty($records[$navId]['edit']) && $currentNavId == $navId) { 
                    if ($records[$navId][17]) { # Перенаправить на этот URL
                        Url::redirect(Router::convert($records[$navId][17]));
                    } elseif ($records[$navId][6] && $childs[$navId]) { #Перенаправление на первую подкатегорию, если установлена соответствующая галочка
                        $sortedData2 = $getSortedData($complexId, $records, $childs[$navId]);
                        $navCatArtikul = key($sortedData2);
                        #Если на уровне подкатегории есть товар, то даем ему сортировку                    
                        if (empty($edit) && !isset($_GET['change']) && !isset($_GET['check']) && !Blox::ajaxRequested()) {
                            Url::redirect(Router::convert('?page='.$GLOBALS['blog/goods'][$complexId]['srcPageId'].'&block='.$GLOBALS['blog/goods'][$complexId]['src-block-id'].'&p[10]='.$navCatArtikul),'exit');
                        }
                    }
                }
                #Для категории активный значок перед строкой
                $isActive = false;
                if ($GLOBALS['blog']['nav']['mark-active-ancestors']) {
                    if (in_array($navId, $GLOBALS['blog/nav'][$complexId]['ancestors']) && $GLOBALS['blog/nav'][$complexId]['levelsActivities'][$startLevel-1]) 
                        $isActive = true;
                } else {
                    $ancestorsRev = array_reverse($GLOBALS['blog/nav'][$complexId]['ancestors']);
                    if ($navId == $ancestorsRev[0] && $GLOBALS['blog/nav'][$complexId]['levelsActivities'][$startLevel-1]) 
                        $isActive = true;
                }
                # Отменить фиксацию блока навигации, когда выбран или раскрыт этот пункт
                if ($isActive && $records[$navId][12]) {
                    $GLOBALS['blog/nav'][$complexId]['unaffix'] = true;
                }
                
                $htm .= '<li'.($isActive ? ' class="active"' : '').'>';
                    #Отмечаем категорию, если на неё настроен переход при входе в каталог, по умолчанию
                    if ($records[$navId]['edit'] && $records[$navId][7]) 
                        $defaultItem = '<b class="red"> *</b>'; 
                    else 
                        $defaultItem = '';

                    
                    $infos['key'] = $GLOBALS['blog/nav'][$complexId]['src-block-id'].'-'.$records[$navId]['rec'];
                    if (!$records[$navId][2]) 
                        $infos['parent-key'] = ''; # Если нет родительской записи
                    else
                        $infos['parent-key'] = $GLOBALS['blog/nav'][$complexId]['src-block-id'].'-'.$records[$navId][2];
                    $infos['name'] = $records[$navId][1];
                    $phref = '?page='.$GLOBALS['blog/goods'][$complexId]['srcPageId'].'&block='.$GLOBALS['blog/goods'][$complexId]['src-block-id'].'&p[10]='.$navId;
                    $href = Router::convert($phref, $infos);
                    $text = Text::stripTags($records[$navId][1]);

                    if ($records[$navId]['edit']) 
                        $text = '<span class="blox-edit-button" style="margin-right:3px" data-blox-edit-href="'.$records[$navId]['edit-href'].'"><img src="'.Blox::info('cms','url').'/assets/edit-button-edit-rec.png" alt="&equiv;"/></span>'.$text;

                    #Mir
                    #Количество статей в категории
                    #if ($childs[$navId]) {
                        $count = 0;
                        #Кол-во подкатегорий/статей
                        $res = Sql::select('SELECT `rec-id` FROM '.Blox::getTbl('blog/nav').' WHERE dat2=? and `block-id`=?', [$navId, $GLOBALS['blog/nav'][$complexId]['regularId']]);
                        foreach($res as $re){
                            $temp = Sql::select('SELECT count(*) FROM '.Blox::getTbl('blog/nav').' WHERE dat2=? and `block-id`=?', [$re['rec-id'], $GLOBALS['blog/nav'][$complexId]['regularId']])[0]['count(*)'];
                            if ($temp==0)
                                $count++;
                            else
                                $count += $temp;
                        }
                    #}
                    if ($GLOBALS['blog/nav'][$complexId]['levelsActivities'][$startLevel-1] and $count)
                        $htm .= '<a href="'.$href.'">'.$text.$defaultItem.'&nbsp;<small>('.$count.')</small></a>';
                    #End Mir
                    elseif ($GLOBALS['blog/nav'][$complexId]['levelsActivities'][$startLevel-1])
                        $htm .= '<a href="'.$href.'">'.$text.$defaultItem.'</a>';
                    else
                        $htm .= $text.$defaultItem;

                    $aa = blogNavGetHtm($complexId, $navId, $currentNavId, $startLevel+1, $childs, $records, $newRecButton);
                    #Проверяем есть ли в уровне "дети" или включен режим редактирования, чтобы выводить кнопку новой записи
                    if ($childs[$navId] || $records[$navId]['edit']) {
                        # KLUDGE: Вызываем всегда, но не всегда выводим, чтобы сформировать ЧПУ и дерево. Вообще-то это нужно сделать в галерее.                                
                        
                        #Определяем для следующего уровня тип вывода, согласно схеме
                        if ($startLevel < $GLOBALS['blog/nav'][$complexId]['maxLevel']) {
                            if (
                                $GLOBALS['blog/nav'][$complexId]['levelsSchemes'][$startLevel] == 'S' || 
                                (
                                    $GLOBALS['blog/nav'][$complexId]['levelsSchemes'][$startLevel] == 'I' && 
                                    $navId == $GLOBALS['blog/nav'][$complexId]['ancestors'][$startLevel-1]
                                )
                            ) $htm .= $aa;
                        }
                    }
                $htm .= '</li>';

                ########### currNeighbors ###########
                if (!$childs[$navId] && array_key_exists($currentNavId, $sortedData)) { # Нет подуровней && В данном уровне есть текущая ссылка
                    # Можно использовать isset($sortedData[$currentNavId])
                    $linkParams = ['text'=>Text::stripTags($text, 'strip-quotes'), 'href'=>$href];
                    # Найдена текущая статья
                    if ($currentNavId == $navId) {
                        $GLOBALS['blog/nav'][$complexId]['currNeighbors']['curr'] = $linkParams;
                        if ($GLOBALS['blog/nav'][$complexId]['currPrevNeighborParams']) {
                            $GLOBALS['blog/nav'][$complexId]['currNeighbors']['prev'] =  $GLOBALS['blog/nav'][$complexId]['currPrevNeighborParams'];
                            unset($GLOBALS['blog/nav'][$complexId]['currPrevNeighborParams']);
                        }
                    } else {
                        # Текущая статья уже найдена
                        if ($GLOBALS['blog/nav'][$complexId]['currNeighbors']['curr']) {
                            # Записываем next
                            if (!$GLOBALS['blog/nav'][$complexId]['currNeighbors']['next'])
                                $GLOBALS['blog/nav'][$complexId]['currNeighbors']['next'] =  $linkParams;        
                        # Текущая статья еще найдена
                        } else
                            $GLOBALS['blog/nav'][$complexId]['currPrevNeighborParams'] = $linkParams;
                    }
                }
                /**
                    Сейчас ищутся соседние статьи текущего раздела.
                    Найти следующую статью, если она находится в другом разделе, не получится, так как другой раздел не визализирован, а значит не участвовал в проходе по древу.
                    Решение
                    -   Это можно сделать по sql-запросу с сортировкой.
                    -   Проходить по всему древу, но отображать только нужные
                */
            }

            #Выводим кнопку создания новой записи для уровня
            if ($GLOBALS['blog']['nav']['navNewButton']) {
                if ($records[$navId]['edit'] && $startLevel <= $GLOBALS['blog/nav'][$complexId]['maxLevel']) {
                    $htm .= '<li>';
                    $recButtonHref = str_replace('&rec=new', '&rec=new&parent='.$startNavId, $newRecButton);                           
                    preg_match('~href="(.*?)"~', $recButtonHref, $matches);                                                     
                    if ($matches[1])                                
                        $htm .= '<a href=""><span class="blox-edit-button" style="margin-right:3px" data-blox-edit-href="'.$matches[1].'"><img src="'.Blox::info('cms','url').'/assets/edit-button-new-rec.png" alt="+"/></span>&nbsp;</a>';                    
                    $htm .= '</li>';
                }
            }
        $htm .= '
        </ul>';
        # Дочерние уровни в меню не показывать, но отрабатывать и показывать в галерее и анонсах.   
        # KLUDGE: Делаем просто сброс. Оптимизировать - лишнюю обработку выше не проводить. Но код слишком разрозненный. Придется также вводить аргумент $idle в blogNavGetHtm() так как отмена вывода в дочерних записях отсутствует. 
        if ($records[$startNavId][16] && !$records[$startNavId]['edit'])
            $htm = '';  // $idle = true;
        return $htm;
    }
}
#######################################################




$currentNavId = Request::get($GLOBALS['blog/goods'][$complexId]['src-block-id'],'pick', 10, 'eq');
if ($_GET['pick10']) 
    $currentNavId = $_GET['pick10'];


#Максимальное кол-во уровней
$GLOBALS['blog/nav'][$complexId]['maxLevel'] = strlen(str_replace('-', '', $GLOBALS['blog']['nav']['levelsScheme']));
#Массив схемы открытия уровней (для каждого уровня одна схема)
$GLOBALS['blog/nav'][$complexId]['levelsSchemes'] = str_split(str_replace('-', '', $GLOBALS['blog']['nav']['levelsScheme']));
#Массив статуса открытия уровней полный (для каждого уровня схема и действие)
$GLOBALS['blog/nav'][$complexId]['levelsActivities'] = str_split($GLOBALS['blog']['nav']['levelsActivity']);

#Создаем массив "детей", преобразуем массив tab в массив с ключом = `rec-id`
$childs = [];
$records = [];

foreach ($tab as $dat) {
    $records[$dat['rec']] = $dat;
    #Чтобы не выводилась кнопка новой записи, автоматом
    if ($dat['rec']) {
        if ($dat[2] != 0) 
            $childs[$dat[2]][] = $dat['rec'];
        else 
            $childs[0][] = $dat['rec'];
    }
}

#Построение цепочки
$ancestors = [];
$navId = $currentNavId;
do {
    if ($navId != 0) 
        $ancestors[] = $navId;
    $navId = $records[$navId][2];
}
while 
    ($navId != 0);
$ancestors = array_reverse($ancestors);
$GLOBALS['blog/nav'][$complexId]['ancestors'] = $ancestors;

#Получаем название каталога
#Формируем глобальный массив предков, с названиями категорий и др. параметрами, для работы в шаблонах отображения товаров
#Для нулевого уровня, т.е. когда все только зашли на страницу "Каталог"
$GLOBALS['blog/nav'][$complexId]['ancestorsInfo'][0]['level'] = 0;
$GLOBALS['blog/nav'][$complexId]['ancestorsInfo'][0]['id'] = 0;
$GLOBALS['blog/nav'][$complexId]['ancestorsInfo'][0]['href'] = '?page='.$GLOBALS['blog/goods'][$complexId]['srcPageId'];
$GLOBALS['blog/nav'][$complexId]['ancestorsInfo'][0]['childs'] = true;
$GLOBALS['blog/nav'][$complexId]['ancestorsInfo'][0]['view'] = $xdat[4];
$GLOBALS['blog/nav'][$complexId]['ancestorsInfo'][0]['articleLocation'] = $xdat[10];

//$GLOBALS['blog/nav'][$complexId]['xdat'] = $xdat; # Для getCatsGalleryHtm.php, поля 5,6,7

#Для всех остальных уровней, когда пошли по каталогу
foreach ($ancestors as $lev => $navId)
{
    $GLOBALS['blog/nav'][$complexId]['ancestorsInfo'][$navId]['parent']['id'] = $GLOBALS['blog/nav'][$complexId]['ancestorsInfo'][$navId2]['id'];# не используется?
    $GLOBALS['blog/nav'][$complexId]['ancestorsInfo'][$navId]['id'] = $navId;
    #
    $GLOBALS['blog/nav'][$complexId]['ancestorsInfo'][$navId]['parent']['name'] =  $GLOBALS['blog/nav'][$complexId]['ancestorsInfo'][$navId2]['name'];
    $GLOBALS['blog/nav'][$complexId]['ancestorsInfo'][$navId]['parent']['headline'] =  $GLOBALS['blog/nav'][$complexId]['ancestorsInfo'][$navId2]['headline'];
    $GLOBALS['blog/nav'][$complexId]['ancestorsInfo'][$navId]['name'] = $records[$navId][1];
    $GLOBALS['blog/nav'][$complexId]['ancestorsInfo'][$navId]['headline'] = $records[$navId][4];
    #
    $GLOBALS['blog/nav'][$complexId]['ancestorsInfo'][$navId]['parent']['href'] = $GLOBALS['blog/nav'][$complexId]['ancestorsInfo'][$navId2]['href'];
    $GLOBALS['blog/nav'][$complexId]['ancestorsInfo'][$navId]['href'] = '?page='.$GLOBALS['blog/goods'][$complexId]['srcPageId'].'&block='.$GLOBALS['blog/goods'][$complexId]['src-block-id'].'&p[10]='.$navId;
    #        
    $GLOBALS['blog/nav'][$complexId]['ancestorsInfo'][$navId]['level'] = $lev + 1;        
    $GLOBALS['blog/nav'][$complexId]['ancestorsInfo'][$navId]['view'] = $records[$navId][8];
    $GLOBALS['blog/nav'][$complexId]['ancestorsInfo'][$navId]['articleLocation'] = $records[$navId][18];
    $GLOBALS['blog/nav'][$complexId]['ancestorsInfo'][$navId]['date'] = $records[$navId][9];
    $GLOBALS['blog/nav'][$complexId]['ancestorsInfo'][$navId]['tags'] = $records[$navId][10];
    if (($childs[$navId]))
        $GLOBALS['blog/nav'][$complexId]['ancestorsInfo'][$navId]['childs'] = true;
    $navId2 = $navId;
}

$currentLevel = 0;  #Уровень на котором выбрана позиция $currentNavId
if (in_array($currentNavId, $ancestors)) {
    $currentLevel = array_search($currentNavId, $ancestors)+1;
    /*
    $GLOBALS['blog/nav'][$complexId]['currentDat'][13] = $records[$currentNavId][13]; # Высота, отведенная под подпись
    $GLOBALS['blog/nav'][$complexId]['currentDat'][14] = $records[$currentNavId][14]; # Размер шрифта подписи
    $GLOBALS['blog/nav'][$complexId]['currentDat'][15] = $records[$currentNavId][15]; # Шрифт жирный
    */
}

if ($currentLevel == 0)     #Нет выбранной категории, первый уровень = 'S', выводим дерево начиная с 1-го уровня
{
    if ($GLOBALS['blog/nav'][$complexId]['levelsSchemes'][0] == 'S')
        $htm = blogNavGetHtm($complexId, 0, $currentNavId, 1, $childs, $records, $edit['new-rec']['button']);
}
else    #Есть выбранная категория. Определяем согласно схемы с какого уровня выводить.
{
    #Определяем нужно ли сделующий за текущим уровнем открывать на новой странице
    #Получаем массив уровней для открытия на новой странице
    $i=0;   #Уровень
    #Массив логики открытия уровней полный (для каждого уровня схема и действие)
    foreach (str_split($GLOBALS['blog']['nav']['levelsScheme']) as $openScheme) {
        if ($openScheme != '-') {
            $i++;
            if ($i == $currentLevel+1) 
                break;
        } else 
            $newTrees[] = $i;
    }

    $newTrees = array_reverse($newTrees);

    #Проверка, если у уровня нет детей, то нельзя отображать начиная с него.
    #Отображаем с предыдущего, который должен отображаться заново.
    foreach ($newTrees as $lev) {
        if ($childs[$ancestors[$lev-1]]) {
            $newTreeLevel = $lev;
            break;
        }
    }

    if ($newTreeLevel)   #Стартуем вывод дерева заново
        $htm = blogNavGetHtm($complexId, $ancestors[$newTreeLevel-1], $currentNavId, $newTreeLevel+1, $childs, $records, $edit['new-rec']['button']);
    else
        $htm = blogNavGetHtm($complexId, 0, $currentNavId, 1, $childs, $records, $edit['new-rec']['button']);
}


# Теги \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\    
$getTagsNav = function($complexId, $records, $childs)
{
    # Сбор тегов
    $tagsCounts = [];
    if ($records) {
        foreach ($records as $rec => $dat) {
            if (empty($childs[$rec]) && $dat[10]) {# Это статья, а не раздел
                if ($tags = explode(',', $dat[10])) {
                    foreach($tags as $tg) {
                        $tg = trim($tg);
                        if (empty($taggedArticles[$tg][$rec])) {
                            $taggedArticles[$tg][$rec] = true;
                            $taggedArticlesList[$tg]['values'][] = $rec;
                            $taggedArticlesList[$tg]['marks'] .= ',?';
                            $tagsCounts[$tg]++;
                        }
                    }
                }
            }
        }
    }
    arsort($tagsCounts);


    # Вывод тегов
    $counter=0;
    if ($tagsCounts) {
        $htm.='
        <div class="tags">
            <h4><span class="glyphicon glyphicon-tags small"></span> Теги</h4>';
            $htm.='
            <ul class="list-inline">';
                ######################################################################################################################
                #Поделено на 2 цикла затем что если их соединить но поиск по тегам будет работать только по самым употребляемым тегам#
                ######################################################################################################################
                //foreach ($tagsCounts as $tg => $number)
                $GLOBALS['blog/nav'][$complexId]['taggedArticlesList'] = $taggedArticlesList; # Передаем в goods
                    
            	foreach ($tagsCounts as $tg => $number) {
                    $badge = '<span class="badge">'.$tg.'</span>';
                    if ($number > 1) # Имеется несколько статей с данным тегом
                        $badge .= '<span class="badge"><small>'.$number.'</small></span>';
            		$htm.='
                    <li>';
                            ##TODO: $href = '?page='.$GLOBALS['blog/goods'][$complexId]['srcPageId'].'&block='.$GLOBALS['blog/goods'][$complexId]['src-block-id'].'&p[10]='.?????;
                            ## Сейчас если в списке статей с данным тегом оказывается только одна статья, то перенаправляется на статью
                        $htm.='<a href="?page='.$GLOBALS['blog/goods'][$complexId]['srcPageId'].'&tag='.urlencode($tg).'">'.$badge.'</a>'; # Переход на список статей с данным тегом
                        $htm.='
                    </li>';
            		$counter++;
            		if ($counter>20)//выводим самые употребляемые теги
            			break; 
        	    }
        	$htm.='</ul>
        </div>';
        return $htm;
    }
};


if ($xdat[3] && !$GLOBALS['blog/nav'][$complexId]['unaffix']) {
    $affix = ' data-spy="affix" data-offset-top="'.$xdat[3].'"';
}
echo'
<nav class="bs-docs-sidebar"'.$affix.'>';
    if ($xdat[1]) 
        echo'<h4>'.$xdat[1].'</h4>';
    echo $htm;
    echo $getTagsNav($complexId, $records, $childs); # Не выносить за $affix
echo'
</nav>';    



