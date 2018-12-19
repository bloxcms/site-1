<?php

Blox::addToHead('<meta name="viewport" content="width=device-width, initial-scale=1">', ['position'=>'top']);  
Blox::addToFoot('//code.jquery.com/jquery-1.12.0.min.js', ['position'=>'top']);
Blox::addToHead('templates/assets/bootstrap/css/bootstrap.min.css', ['position'=>'top']);
//Blox::addToHead('templates/assets/bootstrap/css/bootstrap-theme.min.css', ['after'=>'bootstrap.min.css']);
Blox::addToFoot('templates/assets/bootstrap/js/bootstrap.min.js', ['after'=>'jquery-1']);
Blox::addToHead('<link href="https://fonts.googleapis.com/css?family=Roboto+Condensed:400,400i,700&amp;subset=cyrillic" rel="stylesheet">');
Blox::addToHead('<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.3.1/css/all.css" integrity="sha384-mzrmE5qonljUremFsqc01SB46JvROS7bZs3IO2EmfFsd15uHvIt+Y8vEf7N7fWAU" crossorigin="anonymous">');   
Blox::addToHead('templates/assets/css/theme-colors/orange-altcafe.css', ['before'=>'!page.css']);//green
Blox::addToHead('templates/assets/css/custom.css', ['position'=>'top']);
Blox::addToHead('templates/assets/plugins/animate.css', ['position'=>'top']);
Blox::addToHead('templates/assets/css/headers/header-default.css', ['position'=>'top']);
Blox::addToHead('templates/assets/css/footers/footer-v3.css', ['position'=>'top']);
Blox::addToHead('templates/assets/css/style.css', ['position'=>'top']);
Blox::addToFoot('templates/assets/plugins/smoothScroll.js', ['position'=>'bottom']); 
Blox::addToFoot('templates/assets/js/custom.js', ['position'=>'bottom']);
Blox::addToFoot('templates/assets/js/app.js', ['position'=>'bottom']);
# wow
Blox::addToHead('templates/assets/animate.min.css');
Blox::addToFoot('templates/assets/wow.min.js');// требует custom.js    
Blox::addToFoot('<script>new WOW({mobile:false}).init();</script>');


?>
<header>
    <div style="background:#fff">
        <?=$dat[5]#!top?>
        <div style="height:50px; background:#f2501e">
            <?=$dat[1]#navbar?>
        </div>
    </div>
    
    <?php if ($dat[6]) { ?>
    <div style="margin:22px 0">
        <div class="container">
            <?=$dat[6]#carousel?>
        </div>
    </div>
    <?php } ?>
</header>
<div class="container">
    <?php
    $breadcrumbs = Router::getBreadcrumbs();
    if (!$breadcrumbs) {
        #Если включены фильтры, сортировка, поиск, то вычленяем чистую ссылку на эту страницу, для показа цепочки
        Query::capture();
        Query::remove('part&sort&pick&search&company');              
        $href = Query::build();
        $breadcrumbs = Router::getBreadcrumbs('?'.$href);
    }
    unset($breadcrumbs[0]); # Главная страница
    $lastKey = count($breadcrumbs);
    if ($breadcrumbs) {
        echo'
        <div class="row">
            <div class="hidden-xs hidden-sm">
                <ol class="breadcrumb" style="margin:0; background-color:transparent">';
                    # Главная страница
                    if ($page==1) 
                        echo '<li class="active">Главная</li>';
                    else 
                        echo'<li><a href=".">Главная</a></li>';             
                    foreach ($breadcrumbs as $k => $breadcrumb) {
                        $name = Text::stripTags($breadcrumb['name']);
                        if ($k == $lastKey)  # Последний элемент является текущей страницей
                            echo '<li class="active">'.$name.'</li>';
                        else
                            echo '<li><a href="'.$breadcrumb['href'].'">'.$name.'</a></li>';
                    }
                    echo'
                </ol>
            </div>
        </div>';
    }
    if ($dat[4]) {
        if ('--' != substr(trim($dat[4]), 0, 2)) # Не "закоменированный" заголовок
            echo '<h1>'.$dat[4].'</h1>';
    } elseif ($pname = Router::getCurrentPageInfo()['title']) {
        echo '<h1>'.$pname.'</h1>';
    }
    echo $dat[2]
    ?>
</div>
<?=$dat[3] #footer?>
<?php
    if (empty($edit) && $_SERVER['HTTP_HOST'] != 'localhost' && $_SERVER['HTTP_HOST'] != 'blox') {
        echo"\n";
        include 'metrics.inc';
        echo"\n";
    }
    
    # cart-informer
    echo Blox::getBlockHtm(
        Blox::getInstancesOfTpl('shop/catalog/goods/cart-informer')[0]
    );



Blox::addToFoot(Blox::info('templates','url').'/ff/popups/popups.js'); // Для popup
Blox::addToFoot(Blox::info('cms','url').'/assets/jquery.form.min.js'); // Для form
Blox::addToHead(Blox::info('cms','url').'/assets/blox.loader.css');
Blox::addToFoot(Blox::info('cms','url').'/assets/blox.loader.js');
//include Blox::info('templates','dir').'/f-form/init-inputmask.inc';
include Blox::info('templates','dir').'/ff/form/init-inputmask.inc';

Blox::addToFoot('<script>$(".paragraphs table").addClass("table table-condensed table-bordered table-striped");</script>');
?>
<a href="?login&pagehref=<?=Blox::getPageHref(true)?>" rel="nofollow" style="display:block; line-height:9px; position:absolute; top:5px; right:5px; opacity:0.5"><img src="<?=Blox::info('cms','url')?>/assets/login-black.png"></a>
