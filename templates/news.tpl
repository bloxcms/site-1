<?php

# ORIGIN: omega-prom    ---volta16   ---zavgar (разделены рубрика и общий заголовок)    ---toolmakers.ru     ---blox.ru   ---ETK ---Блик

$headline = $xdat[1] ?: 'Новости';
$rubric = $xdat[2] ?: $headline;

$today = strtotime(date('Y-m-d')); 
//Blox::addToHead('templates/assets/css/pages/blog.css', ['before'=>'!page.css']);
Blox::addToHead('templates/news.css', ['before'=>'!page.css']);

if (empty($tab))
    return;
echo"<div class='newsBox'"; if ($block != $blockInfo['src-block-id']) echo " style='padding-top:0'";echo">";

# Представления на основной новостной странице.
# Идентификатор регулярного блока совпадает и
# идентификатором блока с данными, т.е. блок не делегирован.
if ($block == $blockInfo['src-block-id'])
{
    $request = Request::get($block);
    #\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ Шапка \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    if ($_GET['single'])
    {    
        if ($request['part']['default'] == $request['part']['current'])
            $aa = "?page=$page";
        else
            $aa = "?page=$page&block=$block&part=".$request['part']['current'];
        
        $newsButton = '<a class="btn btn-primary btn-xs" href="'.Router::convert($aa).'" title="В список новостей"><span class="glyphicon glyphicon-arrow-up"></span></a>';

        if ($tab['prev'] || $tab['next']) # более одной записи
        {
            # prev-next
            if ($tab['prev']['rec'])
                $lArrowButton = '<a class="btn btn-primary btn-xs" href="'.Router::convert('?page='.$page.'&block='.$block.'&single='.$tab['prev']['rec']).'" title="позже"><span class="glyphicon glyphicon-chevron-left"></span></a>';  
            else
                $lArrowButton = '<a class="btn btn-primary btn-xs disabled" href="" title="позже"><span class="glyphicon glyphicon-chevron-left"></span></a>';  

            if ($tab['next']['rec'])
                $rArrowButton = '<a class="btn btn-primary btn-xs" href="'.Router::convert('?page='.$page.'&block='.$block.'&single='.$tab['next']['rec']).'" title="раньше"><span class="glyphicon glyphicon-chevron-right"></span></a>';  
            else
                $rArrowButton = '<a class="btn btn-primary btn-xs disabled" href="" title="раньше"><span class="glyphicon glyphicon-chevron-right"></span></a>';  
        }
    }
    elseif ($request['part']['parts'][1]) # более одной части
    {
        $newsButton = "";

        ########################################################
        # Кнопка "Назад"
        if (empty($request['part']['prev'])) {
            $disabled = ' disabled';
            $href = '';
        }
        else {        
            $disabled = '';
            
            if ($request['part']['default'] == $request['part']['prev'])
                $href = Router::convert("?page=$page");
            else
                $href = Router::convert("?page=$page&block=$block&part=".$request['part']['prev']);
        }
        
        $lArrowButton = '<a class="btn btn-primary btn-xs blox-maintain-scroll'.$disabled.'" href="'.$href.'" title="позже"><span class="glyphicon glyphicon-chevron-left"></span></a>';  


        ########################################################
        # Кнопка "Вперед"        
        if (empty($request['part']['next'])) {
            $disabled = ' disabled';
            $href = '';
        }
        else {        
            $disabled = '';
            
            if ($request['part']['default'] == $request['part']['next'])
                $href = Router::convert("?page=$page");
            else
                $href = Router::convert("?page=$page&block=$block&part=".$request['part']['next']);
        }
        
        $rArrowButton = '<a class="btn btn-primary btn-xs blox-maintain-scroll'.$disabled.'" href="'.$href.'" title="раньше"><span class="glyphicon glyphicon-chevron-right"></span></a>';        
    }
    
    ########################################################
    
    if ($_GET['single'])
        $topHeadline = '<h3 style="margin-top:0px"><a href="'.Router::convert('?page='.$page).'">'.$rubric.'</a></h3>';
    else {
        $topHeadline = '<h1>'.$headline;
            if ($p = $_GET['part']) {
                $appendix = ' <span style="opacity:0.3; font-weight:normal">/'.$p.'</span>'; 
                $topHeadline .= $appendix; 
                Blox::setTitleAppendix($appendix);}
        $topHeadline .= '</h1>';
    }

    echo $topHeadline;    
    echo "<div class='topButtonBox'>";        
        echo "$newsButton&nbsp;&nbsp;&nbsp;";
        echo "$lArrowButton&nbsp;&nbsp;&nbsp;$rArrowButton";
    echo "</div>";
    #///////////////////////////////// Шапка /////////////////////////////////


    #\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ Тело \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    #################### "Одна новость" (подробно) ####################
    if ($_GET['single'])
    {
        echo'
        <div class="blog margin-bottom-40" style="position:relative;">';        
            echo pp($dat['edit'],-20,0);
            echo'
            <h1>'.$dat[2].'</h1>';                                                      
            echo'
            <div class="blog-post-tags">';
            
                # Дата
                if ($dat[1]) {
                    echo'
                    <ul class="list-unstyled list-inline blog-info">';
                        echo'
                          <li'.(strtotime($dat[1]) > $today ? ' style="color:red"' : '').'><span class="glyphicon glyphicon-calendar small"></span> '.date('d.m.Y', strtotime($dat[1])).'</li>';
                        //<li><i class="fa fa-calendar"></i> '.date('d.m.Y', strtotime($dat[1])).'</li>';
                        //<li><i class="fa fa-comments"></i> <a href="#">24 Comments</a></li>
                        //<li><i class="fa fa-tags"></i> Technology, Internet</li>
                    echo'    
                    </ul>';
                }                                                    
                /*                
                <ul class="list-unstyled list-inline blog-tags">
                    <li>
                        <i class="fa fa-tags"></i>
                        <a href="#">Technology</a>
                        <a href="#">Education</a>
                        <a href="#">Internet</a>
                        <a href="#">Media</a>
                    </li>
                </ul>
                */
            echo'    
            </div>';
            echo'
            <div class="blog-img">';
                if ($dat[4])  {
                    $alt = ($dat[2])
                        ? Text::stripTags($dat[2],'strip-quotes')
                        : ''
                    ;
                    echo'
                    <p style="text-align:center"><img class="img-responsive" src="datafiles/news/'.$dat[4].'" alt="'.$alt.'"></p>';
                }
            echo'
            </div>';
            
            echo $dat[3];
        echo'
        </div>';

        # Виджет для комментариев от ВКонтакте
        //Blox::addToHead('<script src="//vk.com/js/api/openapi.js?116"></script>');
        //echo'
        //<script>VK.init({apiId: 5011567, onlyWidgets: true})</script>
        //<div id="vk_comments"></div>
        //<script>VK.Widgets.Comments("vk_comments", {limit: 10, width: "640", attach: "*"});</script>';
        # Цвет поменять не удается, так как это iframe //Blox::addToFoot('<style>.wcomments_head {background-color:#c00!important}</style>');
    }
    ################# "Список" (по умолчанию, последние новости) #################
    else
    {
        $infos['parent-key'] = '';
        foreach ($tab as $num => $dat)
        {    
            $alt = '';
            if ($dat['rec'])
            {                       
                $infos['key'] = $blockInfo['src-block-id'].'-'.$dat['rec'];
                $infos['name'] = $dat[2];
                $href = Router::convert("?page=$page&block=$block&single=".$dat['rec'], $infos);   
                $alt = ($dat[2])
                    ? Text::stripTags($dat[2],'strip-quotes')
                    : ''
                ;
            }            
            
            echo'
            <hr>
            <div class="row blog blog-medium margin-bottom-40">
                <div class="col-md-4">';
                    if ($dat[5])
                    echo'
                    <div class="blog-img">
                        <a href="'.$href.'"><img class="img-responsive'.($dat[6]?' bordered':'').'" src="datafiles/news/'.$dat[5].'" alt="'.$alt.'"></a>
                    </div>';
                    echo'
                </div>';
                echo'
                <div class="col-md-8">';                
                    echo pp($dat['edit']);
                    if ($dat['rec'])
                    {                                                                                               
                        # Анонс
                        if ($dat[2]) 
                            echo'<h3><a href="'.$href.'">'.$dat[2].'</a></h3>';
                        # Дата
                        if ($dat[1]) {
                            echo'
                            <ul class="list-unstyled list-inline blog-info">';
                                echo'
                                <li'.(strtotime($dat[1]) > $today ? ' style="color:red"' : '').'><span class="glyphicon glyphicon-calendar small"></span> '.date('d.m.Y', strtotime($dat[1])).'</li>';
                                //<li><i class="fa fa-comments"></i> <a href="#">24 Comments</a></li>
                                //<li><i class="fa fa-tags"></i> Technology, Internet</li>
                            echo'    
                            </ul>';
                        }
                        
                        # Text
        			    if ($dat[3]) {
                            echo Text::truncate($dat[3], 266);
                        }                    
                        # Кнопка "Подробнее"
                        echo'
                        <p><a class="btn btn-primary btn-sm" href="'.$href.'">Подробнее</a></p>';
                    }
            echo'    
                </div>
            </div>';                
            /*
            # Разделитель      
            if (($num + 1) != count($tab))
                echo'
                <hr>';      
            */    
        }
        echo '<hr>';

    }
}
############### "Новости коротко" (на чужой странице) ##############
else // $block != $blockInfo['src-block-id']
{
    $blockPageId = Blox::getBlockPageId($blockInfo['src-block-id']);
    echo'
    <div class="well" style="padding:0px 10px 10px; margin-bottom:0px;">';
        if ($xdat[3])
            echo'<h4><a href="'.Router::convert('?page='.$blockPageId).'">'.$xdat[3].'</a></h4>';
        echo'    
        <div class="delegated">';
            /**
            if ($edit) # Не показываем кнопку new
                $maxNumOfShortNews++;
            */
            
            if ($xdat[3])
                echo'
                <hr class="margin-bottom-10">'; 

            //for ($i=0; $i<$maxNumOfShortNews; $i++)
            $hrStat = false;
            foreach ($tab as $i => $dat)
            {
                //$dat = $tab[$i];      
        
                if ($dat['rec']) # Не показываем кнопку new //$dat &&
                {                
                    $alt = ($dat[2])
                        ? Text::stripTags($dat[2],'strip-quotes')
                        : ''
                    ;
                    $href = Router::convert('?page='.$blockPageId.'&block='.$blockInfo['delegated-id'].'&single='.$dat['rec']);
                    //if ($i != $maxNumOfShortNews-1)
                    if ($hrStat)
                        echo'
                        <hr class="margin-bottom-10">'; 
                    else
                        $hrStat = true;
                    
                    echo
                    '<div class="blog blog-medium">';                
                        if ($dat['edit']) echo pp($dat['edit'],-15,2);  
                        
                        echo'
                        <h4><a href="'.$href.'">'.$dat[2].'</a></h4>';
                        echo'
                        <div class="blog-post-tags">';                        
                                                 
                            # Дата
                            if ($dat[1]) {
                                echo'
                                <ul class="list-unstyled list-inline blog-info">';
                                    echo'
                                    <li'.(strtotime($dat[1]) > $today ? ' style="color:red"' : '').'><span class="glyphicon glyphicon-calendar small"></span> '.date('d.m.Y', strtotime($dat[1])).'</li>';
                                echo'    
                                </ul>';
                            }                                                    
                        echo'    
                        </div>';
                        # Фото
                        echo'
                        <div class="blog-img">';
                            if ($dat[5]) 
                                echo'
                                <a href="'.$href.'"><img class="img-responsive'.($dat[6]?' bordered':'').'" src="datafiles/news/'.$dat[5].'" alt="'.$alt.'"></a>';
                        echo'
                        </div>';
                        
                        if ($dat[3])
                            echo Text::truncate($dat[3], 170);               
                        
                        echo'
                        <p><a class="btn-u btn-u-xs" href="'.$href.'">Подробнее <i class="fa fa-angle-double-right margin-left-5"></i></a></p>';                
                                        
                                        
       
                    
                    echo'
                    </div>';
                }
    	    }
                    
        echo"</div>";
    echo"</div>";
}
echo"</div>";// newsBox