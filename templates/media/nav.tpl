<?php
# ORIGIN: ильбухтино    ---hammer    ---diev  ---пушар.рф 2016-04-14 ---тв-транзит.рф     ---nemstandart


$GLOBALS['media']['sortNavList'] = $xdat[2];
Blox::addToHead(Blox::info('templates','url').'/media/nav.css',['after'=>'docs.min.css']);
Blox::addToHead(Blox::info('templates','url').'/assets/docs.sidebar.css');

#######################################################
#Вывод уровней каталога
if (!function_exists('showNavLevel'))
{
    function showNavLevel($startNum, $currentNum,  $startLevel, $maxLevel, $openSchemes, $openActives, $ancestors, $childs, $records, $newRecButton)
    {
        /*
            $startNum   - ID категории с которой стартует вывод
            $currentNum - номер выбранной категории
            $startLevel - номер уровня, с которого стартует вывод. Первый уровень номер = 1.
            $maxLevel  - максимальное кол-во уровней для создания и отображения
            $openSchemes    - схема открытия уровней
            $openActives    - активность уровней
            $ancestors, $childs, $records   - массивы данных
            $newRecButton   - код кнопки новой записи
        */
//qq($records);
        $itemsBlock = $GLOBALS['media/goods']['block'];
        $itemsPage  = $GLOBALS['media']['page'];

        echo'
        <ul class="nav'.($startLevel==1 ? ' bs-docs-sidenav' : '').'">';
            #Подготовка для сортировки
            foreach ($childs[$startNum] as $numLs)
                $sortChilds[$numLs] = $records[$numLs][1];
            #Сортировка
            if ($GLOBALS['media']['sortNavList']) asort($sortChilds);
            foreach ($sortChilds as $numL => $nameL)    #$nameL не используется в выводе, а служит для работы foreach
            {
                #Перенаправление на первую подкатегорию, если установлена соответствующая галочка
                if (empty($records[$numL]['edit']) && $records[$numL][6] && $currentNum == $numL && $childs[$numL])
                {
                    #Сортировка подкатегории
                    foreach ($childs[$numL] as $numLs1)
                        $sortChilds1[$numLs1] = $records[$numLs1][1];
                    #Сортировка
                    if ($GLOBALS['media']['sortNavList']) asort($sortChilds1);
                    reset($sortChilds1);
                    $navCatArtikul = key($sortChilds1);
                    #Если на уровне подкатегории есть товар, то даем ему сортировку
                    if (empty($records[$numL]['edit']) && !isset($_GET['change']) && !isset($_GET['check']) && !Blox::ajaxRequested())
                        Url::redirect(Router::convert('?page='.$itemsPage.'&block='.$itemsBlock.'&p[10]='.$navCatArtikul),'exit');
                }

                #Для категории активный значок перед строкой
                if ($GLOBALS['media']['levelActiveAncestors']) {
                    $actStr = (in_array($numL, $ancestors) && $openActives[$startLevel-1]) 
                        ? 'active'
                        : $actStr = ''
                    ;
                } else {
                    $ancestorsRev = array_reverse($ancestors);
                    $actStr = ($numL == $ancestorsRev[0] && $openActives[$startLevel-1]) ? 'active' : '';
                }
                $activeClass = ($currentNum == $numL) ? 'active ' : '';

                echo '<li class="'.$actStr.'">';
                #Отмечаем категорию, если на неё настроен переход при входе в каталог, по умолчанию
                $defaultItem = ($records[$numL]['edit'] && $records[$numL][7]) ? '<b class="red"> *</b>' : '';
                
                
                $infos['key'] = $GLOBALS['media/nav']['block'].'-'.$records[$numL]['rec'];
                if (!$records[$numL][2]) 
                    $infos['parent-key'] = ''; # Если нет родительской записи
                else
                    $infos['parent-key'] = $GLOBALS['media/nav']['block'].'-'.$records[$numL][2];
                    
                $infos['name'] = $records[$numL][1];
                $phref = '?page='.$itemsPage.'&block='.$itemsBlock.'&p[10]='.$numL;
                $href = Router::convert($phref, $infos, $keys);

                $aa = Text::stripTags($records[$numL][1]);

                if ($records[$numL]['edit']) 
                    $aa = '<span class="blox-edit-button" style="margin-right:3px" data-blox-edit-href="'.$records[$numL]['edit-href'].'"><img src="'.Blox::info('cms','url').'/assets/edit-button-edit-rec.png" alt="&equiv;"/></span>'.$aa;                
                
                if ($openActives[$startLevel-1])
                    echo '<a href="'.$href.'">'.$aa.$defaultItem.'</a>';
                else
                    echo $aa.$defaultItem;
                # Ограничиваем по макс. уровню
                if ($startLevel < $maxLevel)  {
                    #Проверяем есть ли в уровне "дети" или включен режим редактирования, чтобы выводить кнопку новой записи
                    if ($childs[$numL] || $records[$numL]['edit']) {
                        #Определяем для следующего уровня тип вывода, согласно схеме
                        if ($openSchemes[$startLevel] == 'S')
                            showNavLevel($numL, $currentNum, $startLevel+1,  $maxLevel, $openSchemes, $openActives, $ancestors, $childs, $records, $newRecButton);
                        elseif ($openSchemes[$startLevel] == 'I' && $numL == $ancestors[$startLevel-1])
                            showNavLevel($numL, $currentNum, $startLevel+1,  $maxLevel, $openSchemes, $openActives, $ancestors, $childs, $records, $newRecButton);
                    }
                }
                echo'</li>';
            }
            #Выводим кнопку создания новой записи для уровня
            if ($GLOBALS['media']['navNewButton']) {
                if ($records[$numL]['edit'] && $startLevel <= $maxLevel) {
                    echo '<li>';
                    $recButtonHref = str_replace('&rec=new', '&rec=new&parent='.$startNum, $newRecButton);                           
                    preg_match('~href="(.*?)"~', $recButtonHref, $matches);                                                     
                    if ($matches[1])                                
                        echo '<a href=""><span class="blox-edit-button" style="margin-right:3px" data-blox-edit-href="'.$matches[1].'"><img src="'.Blox::info('cms','url').'/assets/edit-button-new-rec.png" alt="+"/></span>&nbsp;</a>';                    
                    echo '</li>';
                }
            }
        echo'
        </ul>';
    }
}
#######################################################

    $currentNum = Request::get($GLOBALS['media/goods']['block'], 'pick', 10, 'eq');
    if ($_GET['pick10']) $currentNum = $_GET['pick10'];

    $itemsBlock = $GLOBALS['media/goods']['block'];
    $itemsPage = $GLOBALS['media']['page'];

    #Максимальное кол-во уровней
    $maxLevel  = strlen(str_replace('-', '', $GLOBALS['media']['levelsOpenScheme']));
    #Массив схемы открытия уровней (для каждого уровня одна схема)
    $openSchemes = str_split(str_replace('-', '', $GLOBALS['media']['levelsOpenScheme']));
    #Массив логики открытия уровней полный (для каждого уровня схема и действие)
    $openSchemesAll = str_split($GLOBALS['media']['levelsOpenScheme']);
    #Массив статуса открытия уровней полный (для каждого уровня схема и действие)
    $openActives = str_split($GLOBALS['media']['levelsOpenActive']);

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

    #Переменная - номер выбранной категории. Не зависит от наличия артикула категории. Используется в других шаблонах.
    $GLOBALS['media_currentNum'] = $currentNum;
    #Построение цепочки
    $ancestors = [];
    $ancestorLast = $currentNum;
    do {
        if ($ancestorLast !=0) 
            $ancestors[] = $ancestorLast;
        $ancestorLast = $records[$ancestorLast][2];
    }
    while ($ancestorLast != 0);

    $ancestors = array_reverse($ancestors);

    #Получаем название каталога
    #TODO Убрать запрос ниже
    $rowsTitle = Sql::select('SELECT * FROM `'.Blox::info('db','prefix').'$media/goods` WHERE `block-id`=?', [$GLOBALS['media/goods']['block']]);
    #Формируем глобальный массив предков, с названиями категорий и др. параметрами, для работы в шаблонах отображения товаров
    #Для нулевого уровня, т.е. когда все только зашли на страницу "Каталог"
    $GLOBALS['ancestorsList'][0]['level'] = 0;
    $GLOBALS['ancestorsList'][0]['num'] = 0;
    $GLOBALS['ancestorsList'][0]['name'] = $xdat[4];
    $GLOBALS['ancestorsList'][0]['href'] = '?page='.$itemsPage;
    $GLOBALS['ancestorsList'][0]['childs'] = true;
    $GLOBALS['ancestorsList'][0]['show'] = $xdat[5];
    $GLOBALS['ancestorsList'][0]['text'] = $xdat[6];
    
    $GLOBALS['media/nav']['xdat'] = $xdat; # Для get-cats-gallery-htm.php, поля 15,16,17

    #Для всех остальных уровней, когда пошли по каталогу
    foreach ($ancestors as $ancestorNum => $ancestor) {
        $GLOBALS['ancestorsList'][$ancestor]['level'] = $ancestorNum + 1;
        $GLOBALS['ancestorsList'][$ancestor]['num'] = $ancestor;
        $GLOBALS['ancestorsList'][$ancestor]['name'] = ($records[$ancestor][4]) 
            ? $records[$ancestor][4]
            : $records[$ancestor][1]
        ;
        $GLOBALS['ancestorsList'][$ancestor]['href'] = '?page='.$itemsPage.'&block='.$itemsBlock.'&p[10]='.$ancestor;
        $GLOBALS['ancestorsList'][$ancestor]['show'] = $records[$ancestor][8];
        $GLOBALS['ancestorsList'][$ancestor]['text'] = $records[$ancestor][9];

        if ($childs[$ancestor]) $GLOBALS['ancestorsList'][$ancestor]['childs'] = true;
        else $GLOBALS['ancestorsList'][$ancestor]['childs'] = false;
    }


    if ($dat['edit'] || ($GLOBALS['media']['showNavigation'] && !$dat['edit']))
    {
        $affix = ($xdat[3]) ? ' data-spy="affix" data-offset-top="'.$xdat[3].'"' : '';
        echo'
        <nav class="bs-docs-sidebar"'.$affix.'>';
            if ($xdat[1]) echo'<h4>'.$xdat[1].'</h4>';
                $currentLevel = 0;  #Уровень на котором выбрана позиция $currentNum
                
            if (in_array($currentNum, $ancestors)) {
                $currentLevel = array_search($currentNum, $ancestors)+1;
                /*
                $GLOBALS['media/nav']['currentDat'][13] = $records[$currentNum][13]; # Высота, отведенная под подпись
                $GLOBALS['media/nav']['currentDat'][14] = $records[$currentNum][14]; # Размер шрифта подписи
                $GLOBALS['media/nav']['currentDat'][15] = $records[$currentNum][15]; # Шрифт жирный
                */
            }

            if ($currentLevel == 0) { #Нет выбранной категории, первый уровень = 'S', выводим дерево начиная с 1-го уровня
                if ($openSchemes[0] == 'S')
                    showNavLevel(0, $currentNum, 1, $maxLevel, $openSchemes, $openActives, $ancestors, $childs, $records, $edit['new-rec']['button']);
            } else { #Есть выбранная категория. Определяем согласно схемы с какого уровня выводить.
                #Определяем нужно ли сделующий за текущим уровнем открывать на новой странице
                #Получаем массив уровней для открытия на новой странице
                $i=0;   #Уровень
                foreach($openSchemesAll as $openScheme) {
                    if ($openScheme != '-') {
                        $i++;
                        if ($i == $currentLevel+1) break;
                    } else 
                        $newTrees[] = $i;
                }

                $newTrees = array_reverse($newTrees);
                #Проверка, если у уровня нет детей, то нельзя отображать начиная с него.
                #Отображаем с предыдущего, который должен отображаться заново.
                foreach ($newTrees as $newTree) {
                    if ($childs[$ancestors[$newTree-1]]) {
                        $newTreeNum = $newTree;
                        break;
                    }
                }

                if ($newTreeNum)   #Стартуем вывод дерева заново
                    showNavLevel($ancestors[$newTreeNum-1], $currentNum, $newTreeNum+1, $maxLevel, $openSchemes, $openActives, $ancestors, $childs, $records, $edit['new-rec']['button']);
                else
                    showNavLevel(0, $currentNum, 1, $maxLevel, $openSchemes, $openActives, $ancestors, $childs, $records, $edit['new-rec']['button']);
            }
        echo'
        </nav>';
    }
