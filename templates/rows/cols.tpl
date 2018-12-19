<?php
/*
 * @todo Шаблон cols - не использовать null, a varchar: '' и 0
 */
if (empty($tab))
    return;

if ($xdat[1]) 
    $tab = array_reverse($tab);  #Выводим колонки в обратном порядке
$alignVerticaly = false;
$screens = [2=>'xs', 3=>'sm', 4=>'md', 5=>'lg', 6=>'lg'];
foreach ($tab as $i=>$dat) {
    if ($dat['rec']) {
        $clas = '';
        for ($i=2; $i<=5; $i++) {
            $ii = $i;
            if (
                $i==5  
                && !Blox::info('user','userIsAsVisitor') 
                && Blox::info('user', 'userIsEditor') 
                && !isEmpty($dat[6])
            ) {
                $ii = 6;      # В режиме редактирования обрабатываем 6-е поле вместо 5-го
            }
           
            if ($dat[$ii]==='0') # mysql и mysqli возвращают числа как строки!
                $clas .= ' hidden-'.$screens[$ii];                    
            elseif (!empty($dat[$ii]))
                $clas .= ' col-'.$screens[$ii].'-'.$dat[$ii];
        }
        $clas = substr($clas, 1);
        if (empty($clas))
            $clas = 'col-xs-12';
        $styleCode  = ' style="position:relative';
        //$styleCode .= ($dat[8]) ? '; border-left: 1px solid #dadada' : '';
        $styleCode .= ($dat[9]===null) ? '' : '; padding-left:'.$dat[9].'px';
        $styleCode .= ($dat[10]===null) ? '' : '; padding-right:'.$dat[10].'px';
        $styleCode .= ($dat[11]===null) ? '' : '; padding-top:'.$dat[11].'px';
        $styleCode .= ($xdat[2]===null) ? '' : '; margin-top:'.$xdat[2].'px';
        $styleCode .= '"';
        echo'
        <div class="'.$clas.'"'.$styleCode.'>';
            if ($dat[8])
                echo'<div class="rows-col-heading">'.$dat[8].'</div>';
            if ($dat[7]) {
                echo'<div class="to-bottom">'.$dat[1].'</div>';
                $alignVerticaly = true;
            } else
                echo $dat[1]; 
            echo $dat['edit'];
        echo'
        </div>';
    }
}
# Сигнализируем в шаблон row , что блок на шаблоне cols вложен
$GLOBALS['rows/cols']['parents'][$blockInfo['parent-block-id']][$blockInfo['parent-rec-id']] = [
    'colExists' => true,
    'alignVerticaly' => $alignVerticaly,
];
