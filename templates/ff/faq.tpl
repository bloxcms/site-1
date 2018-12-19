<?php
Blox::addToHead('templates/ff/faq/faq.css');

# Конфигурация формы
if ('json' == $_GET['mode']) # ajax
{ 
    echo' { 
        "action":"?block='.$block.'&mode=valid",
        "method":"post",
        "fields":[
            {"name":"field7","label":"Тема"},
            {"name":"field2","label":"'.$xdat[13].'","type":"textarea","validation":"not-empty"},
            '; if ($xdat[5]) echo'
            {"name":"field5","label":"Ваш email", "validation":"email"},
            '; if ($xdat[4]) echo'
            {"name":"field4","label":"Ваше имя и фамилия"},
            '; if ($xdat[6]) echo'
            {"name":"field6","label":"Ваш телефон"},
            '; if ($xdat[2]) echo'
            {"name":"field10","label":"Ваш сайт"},
            '; echo'
            {"name":"ff-faq-captcha","label":"Введите эти знаки","type":"captcha"},
            {"name":"ff-faq-submit","type":"submit","default":"Отправить"}
        ]
    }';
} 
# Обработка данных формы
elseif ('valid' == $_GET['mode']) 
{
    # записать
    foreach ([2,4,5,6,7,9,10,11,12] as $field)
        $newdat[$field] = $_POST['data']['field'.$field];
    $newdat[13] = Url::encode(Router::getPhref(Blox::getPageHref())); # Закодированный URL страницы
    Dat::insert($blockInfo, $newdat);

    # Письмо для админа
    require_once 'templates/ff/form/Form.php';
    $msg = \ff\Form::getDivsHtm($_POST['config']['divs'], $_POST, '', $_GET['block'], ['for-email']);
    $msg.='<p style="color:red">Запись пока скрыта. Вам необходимо сделать ее видимой или удалить.<br><a href="'.Blox::info('site','url').'/?login&pagehref='.Blox::getPageHref(true).'">Перейти на страницу "'.$xdat[3].'"</a>.</p>';

    $toEmails = $xdat[10] ?: Blox::info('site','emails','to');
    if (!$toEmails) {
        $alert['text'] = 'Не задан электронный адрес';
        $alert['bg'] = 'alert-danger';
    }
	$data = [
		'from'=> Blox::info('site','emails','from'),
		'to'=> $toEmails,					
		'subject'=> 'На странице "'.$xdat[3].'" сайта '.Url::punyDecode(Blox::info('site','url')).' появилась новая запись',
		'htm'=> $msg
	];
    if (Email::send($data)) {
        $alert['text'] = 'Ваше сообщение успешно отправлено';
        $alert['bg'] = 'alert-success';
    } else {
        $alert['text'] = 'Сообщение отправить не удалось';
        $alert['bg'] = 'alert-danger';
    }
    echo'<h4 class="alert '.$alert['bg'].'" role="alert">'.$alert['text'].'</h4>';
} 
# Вывод отзывов
else 
{   //if (!Blox::ajaxRequested()) {  # Это не Ajax
    echo'<div class="ff-faq">';
    if ($block == $blockInfo['src-block-id'])
    {
        $request = Request::get($block);
        echo'
        <div class="ff-faq-header">
            <div class="inline-block">
                <h1 style="float:left">'.$xdat[3].'</h1>
            </div>';
            if ($xdat[12])
                echo'<div class="inline-block"><button data-ff-popups-url="'.$xdat[12].'" class="btn btn-primary">'.$xdat[8].' <i class="fa fa-caret-up"></i></button></div>';
            if ($xdat[9]) {
                if (Str::isInteger($xdat[9]))
                    $xdat[9] = '200px';
                echo'
                <div class="inline-block" style="width:'.$xdat[9].'">
                    <form class="input-group" action="'.Router::convert('?page='.$page).'" method="post">
                        <input type="text" class="form-control" name="search" placeholder="Поиск"'.($request['search']['texts'] ? ' value="'.$request['search']['texts'][2].'" style="background:rgba(255,255,0,0.5)"' :'').'>
                        <input type="hidden" name="block" value="'.$block.'">
                        <span class="input-group-btn">
                            <button class="btn btn-default" type="submit"><i class="fa fa-search"></i></button> 
                        </span>
                    </form>
                </div>';
            }
            echo'
        </div>';
        echo'
        <div style="position:relative">';
        
        if ($request['search']['texts']) {
            if ($request['part']['num-of-recs']) {
                echo'
                <h4 class="alert alert-success" role="alert">
                    По запросу <b>&quot;'.$request['search']['texts'][2].'&quot;</b> '
                    .Str::declineWords(
                        ['найдена', 'найдены', 'найдено'],
                        $request['part']['num-of-recs'],
                        ['запись', 'записи', 'записей']
                    ).'
                </h4>';
            } else {
                echo'<h4 class="alert alert-warning" role="alert">По запросу <b>'.$request['search']['texts'][2].'</b> ничего не найдено</h4>';
            }
        }
            
        if ($tab)
        {
            $pages = [];
            foreach ($tab as $dat) {
                echo'
                <div class="row">
                    <div class="col-md-12">';                                                             
                        echo pp($dat['edit'], -15, 0);                                             
                        echo '<div style="position: absolute; right:0px; top:0px">'.$dat['delete'].'</div>';                                                                                         
                        # Заголовок
                        if ($dat[7]) 
                            echo'<h4>'.$dat[7].'</h4>';                        
                        echo'
                        <ul class="list-unstyled list-inline blog-info">';
                            if ($dat[1] && $xdat[1])# Дата
                                echo'<li><i class="fa fa-calendar"></i> '.date('d.m.Y', strtotime($dat[1])).'</li>';                                
                            if ($dat[4] && $xdat[4])
                                echo'<li><i class="fa fa-user"></i> '.$dat[4].'</li>';
                            if ($dat[6] && $xdat[6])
                                echo'<li><i class="fa fa-phone-square"></i> '.$dat[6].'</li>';
                            if ($dat[5] && $xdat[5]) {
                                if ($edit) {
                                    if (!$dat[9])
                                        $emailOpacity = ' style="opacity:0.5"';
                                    else
                                        $emailOpacity = '';
                                } elseif ($dat[9]) {
                                    $emailOpacity = '';                                
                                } else {
                                    $emailOpacity = null;
                                }
                                if (isset($emailOpacity))                                        
                                    echo'<li'.$emailOpacity.'><i class="fa fa-envelope"></i> <a href="maito:'.$dat[5].'">'.$dat[5].'</a></li>';
                            }
                            if ($dat[10] && $xdat[2])
                                echo'<li><a href="'.$dat[10].'" target="_blank"><i class="fa fa-globe"></i> '.$dat[10].'</a></li>';
                            if ($xdat[15]) { # Ссылка на страницу с этой записью
                                $pageInfo = [];
                                if ($pageInfo = $pages[$dat[13]])
                                    ;
                                elseif ($phref = Url::decode($dat[13])) {
                                    $pageInfo = [
                                        'href'=>Router::convert($phref),
                                        'name'=>Text::truncate(Text::stripTags(Router::getPageInfoByPhref($phref)['name']), 40, 'plain'),
                                    ];
                                    $pages[$dat[13]] = $pageInfo;
                                }
                                if ($pageInfo['href'])
                                    echo'<li><a href="'.$pageInfo['href'].'" title="Перейти на страницу с этой записью"><i class="fa fa-list-ul"></i> '.$pageInfo['name'].'</a></li>';
                            }
                        echo'    
                        </ul>';                     
                        # Text
        			    if ($dat[2]) 
                            echo $dat[2];
                        # Ответ
        			    if ($dat[11] && $xdat[7]) {
                            echo '
                            <blockquote>
                                '.$dat[11];
                                if ($dat[12])
                                    echo'<footer><cite title="">'.$dat[12].'</cite></footer>';
                                echo'
                            </blockquote>';
                        }
                    echo'    
                    </div>
                </div>
                <hr>';
            }   

            # prevnext code
            if ($request['part']['parts'][1]) # Более одной части
            {            
                echo'
                <div class="text-center">
                    <ul class="pagination">';                      
                        if (empty($request['part']['prev'])) echo'<li><a class="disabled" href=""><span>Предыдущий</span></a></li>';
                        else echo'<li><a href="'.Router::convert('?page='.$page.'&block='.$block.'&part='.$request['part']['prev']).'"><span>Предыдущий</span></a></li>';                                                   
                                 
                        if (empty($request['part']['next'])) echo'<li><a class="disabled" style="margin-left:10px" href=""><span>Следующий</span></a></li>';
                        else echo'<li><a style="margin-left:10px" href="'.Router::convert('?page='.$page.'&block='.$block.'&part='.$request['part']['next']).'"><span>Следующий</span></a></li>';                            
                    echo'            
                    </ul>
                </div>';            
                
                //<!--Pagination-->
                echo'
                <div class="text-center">
                    <ul class="pagination pagination-small">';                      
                        # Вывод сокращенной пагинации
                        $partNums = Misc::paginate($request['part']['current'], $request['part']['num-of-parts'], 5, 10, true);
                        foreach ($partNums as $partNum) {
                            if ($partNum) {
                                if ($partNum == $request['part']['current']) echo'<li class="active"><a href="">'.$partNum.'</a></li>';
                                else echo'<li><a href="'.Router::convert('?page='.$page.'&block='.$block.'&part='.$partNum).'">'.$partNum.'</a></li>';
                            } else
                                echo'<li><a class="disabled separator" href="">...</a></li>';
                        }
                    echo'            
                    </ul>
                </div>';
            }
        }
        
        echo '
        </div>';
    # Делегирован
    } else {
        echo'
        <div class="well small" style="position:relative; padding:0px 10px 10px; background-color:transparent; background-image:none">
            <div class="pull-right" style="margin-top:11px">';
                if ($xdat[12])
                    echo' <button data-ff-popups-url="'.$xdat[12].'" class="btn btn-xs btn-primary">'.$xdat[8].' <i class="fa fa-caret-up"></i></button>';
                echo'
                <a class="btn btn-xs btn-default" href="?page='.Blox::getBlockPageId($blockInfo['src-block-id']).'">Посмотреть все</a>
            </div>
            <h4>'.(($xdat[11]) ?:'').'</h4>';
            foreach ($tab as $dat) {
                //if ($dat['rec']) {
                    # Дата
                    if ($dat[1]) {
                        echo'
                        <ul class="list-unstyled list-inline">';
                            if ($dat['edit'])
                                echo'<li>'.$dat['edit'].'</li>';
                            if ($xdat[1])
                                echo'<li><i class="fa fa-calendar"></i> '.date('d.m.Y', strtotime($dat[1])).'</li>';
                            if ($dat[4] && $xdat[4])
                                echo'<li><i class="fa fa-user"></i> '.$dat[4].'</li>';
                            echo'
                        </ul>';
                    }          
                    # Заголовок
                    if ($dat[7]) 
                        echo'<h4 style="margin:-4px 0px 6px">'.$dat[7].'</h4>';
                    # Text
    			    if ($dat[2]) 
                        echo $dat[2];
                    # Ответ
    			    if ($dat[11] && $xdat[7]) {
                        echo '
                        <blockquote>
                            '.$dat[11];
                            if ($dat[12])
                                echo'<footer><cite title="">'.$dat[12].'</cite></footer>';
                            echo'
                        </blockquote>';
                    }
                //}
            }
            if ($edit)
                echo pp($edit['button'].($xdat[15] ? '' : ' Внимание! Записи находятся в ротации!'), 0, -11);
            echo'
        </div>';
    }
    echo'</div>';
} 

