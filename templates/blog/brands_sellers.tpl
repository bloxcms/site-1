<?php
/**
    ORIGIN: челныдизель
    
    TODO: добавить произвольную иконку
*/

if (!$tab)    // && !Blox::info('user','user-is-admin')
    return;
/*
if ($xdat[4])
    $bullet = '';
elseif ('Ссылка' == $xdat[3])   
    $bullet = $xdat[3].' ';
elseif ('Ссылка' == $xdat[1])
    $bullet = '<i class="fa fa-chevron-circle-right"></i> ';
elseif ('Страница' == $xdat[1])    
    $bullet = '<i class="fa fa-chevron-circle-right"></i> ';
elseif ('Файл' == $xdat[1])
    $bullet = '<i class="fa fa-file"></i> ';
else
    $bullet = '';
*/
$bullet = '<i class="fa fa-chevron-circle-right"></i> ';
    


    

if ($bullet)
    echo'<style>.navPills {position:relative; margin:22px 0;} .navPills span.glyphicon, .navPills i.fa {position:absolute; top:12px; left:11px; display: block}</style>';

   
echo'
<nav class="navPills navPills'.$blockInfo['src-block-id'].'">';
    echo'<h3>Компании - официальные поставщики</h3>'; # Заголовок    
    
    echo'
    <ul class="nav nav-pills nav-stacked">';
        foreach ($tab as $dat) 
        {   
            if ($dat['rec'] && $dat[2]) {
                $download = '';
                $href = '';            
                $clas = '';
                //$target = ($dat[7]) ? ' target="_blank"' : '';
                $target = ' target="_blank"';
                $title = '';
                
                if ($dat[3]) {            
                    //$href = Router::convert($dat[3]);
                    $href = $dat[3];

                } 
                /*
                elseif ('Страница' == $xdat[1]) {
                    $href = Router::convert('?page='.$dat[4], ['name'=>$dat[2]]); # Превратить параметрическую ссылку в ЧПУ 
                    if (Router::hrefIsAncestor($href)) 
                        $clas .= ' active'; 
                    elseif ($dat[4] == $page) 
                        $clas .= ' disabled';
                } 
                elseif ('Файл' == $xdat[1]) {
                    
                    
                    if ($dat[5]) {
                        if ($dat[6]) {
                            $href = '?download&file='.$dat[5];
                            $download = ' download';
                            $title = ' title="Скачать файл"';
                        } else {
                            $href = 'datafiles/blog/goods/brands_downloads/'.$dat[5];
                            //$title = ' title="Открыть файл"';
                        }
                    } else
                        $clas .= ' disabled';
                */
                        
                        
                //}            
                $clas = ($clas) ? ' class="'.substr($clas, 1).'"' : '';        
                
                    
                echo'
                <li'.$clas.'><a style="padding-left:30px" href="'.$href.'"'.$target.$download.$title.'>'.$bullet.$dat[2].'</a></li>';
            } /*else {
                echo'
                <li'.$clas.'> &nbsp; &nbsp;'.$dat['edit'].'</li>';
            }*/
        }
    echo'
    </ul>
    '.pp($edit['button'],-4,-8).'
</nav>';
        

