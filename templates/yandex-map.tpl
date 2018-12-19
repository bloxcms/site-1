<?php
/**
 * @todo Проверить без аякса Blox::addToHead($aa);  --> Blox::addToFoot($aa);
 * @todo 
    https://tech.yandex.ru/maps/doc/jsapi/2.1/dg/concepts/geoobjects-docpage/
    Балун
    https://tech.yandex.ru/maps/doc/jsapi/2.1/dg/concepts/map-docpage#balloon_and_hint

 */

echo'
<div id="block-'.$block.'">';


    if ($mapCenter = trim($xdat[1])) {
        if ($mapCenter[0]=='{')
            $mapCenter = Blox::getByJson($mapCenter);
    } elseif ($edit)
        echo'<h3 class="alert alert-danger text-center">Не заданы координаты центра карты!</h3>';

    if ($xdat[13]) {
        if (file_exists($xdat[13])) {
            $getCustomBalloonHtm = function($serial, $dat, $xdat, $blockInfo) {
                ob_start();
                include $xdat[13];
                return trim(
                    str_replace(
                        ["\n", "\r\n", "\r"], ' ', 
                        ob_get_clean()
                    )
                );
            };
            $baloonExists = true;
        } elseif ($edit) {
            echo'<h3 class="alert alert-danger text-center">В поле 13 экстраданных шаблона yandex-map указан неправильный путь к балуну!</h3>';
        }
    }


    # Заголовок карты
    if ($xdat[3]) 
        echo'<div class="yandex-map-headline">'.$xdat[3].'</div>';
    # Контейнер для карты
    echo'
    <div class="yandex-map-content" id="yandex-map-'.$block.'" class="" style="position:relative; width:100%; height:'.($_GET['mode']=='enlarge' ? 3*$xdat[4] : $xdat[4]).'px; box-sizing: border-box; -moz-box-sizing: border-box; margin-right:35px">';
        if ($xdat[5])
            echo $xdat[5];
        echo pp($edit['button'],10,0,2);
        /** #enlarge
        echo'
        <div class="yandex-map-enlarge" style="margin-left:auto; margin-right:auto; position:absolute; top:-9px; left:0; right:0;  z-index:1; width:22px ">
            <button class="btn btn-default btn-xs" style="padding: 1px 7px;" title="Увеличить высоту карты"><i class="fas fa-arrow-up"></i></button>
        </div>
        */
        echo'
    </div>';


    # список
    if ($xdat[6])
        $GLOBALS['yandex-map']['tab'] = $tab;

    $js = '<script src="https://api-maps.yandex.ru/2.1/?lang=ru_RU" type="text/javascript"></script>';
    if (Blox::ajaxRequested())
        echo $js;
    else
        Blox::addToHead($js);
    /**
    При назначении данного шаблона в navblocks, то по умолчанию происходит ошибка  "ymaps is not defined". Но по кликам по вкладкам карта работает. Пришлось сделать задержку setTimeout().
    */ ?>
    <script type="text/javascript">
        function initYandexMap<?=$block?>() {
            if (typeof ymaps !== "undefined") {
                ymaps.ready(function() {
                    var myMap = new ymaps.Map('yandex-map-<?=$block?>', {
                        center: [<?=$mapCenter?>],
                		zoom: <?=$xdat[2]?> 
                    });
                    <?php foreach ($tab as $serial => $dat) { ?> 
                		myPlacemark<?=$dat['rec']?> = new ymaps.Placemark(
                            [<?=$dat[1]?>], 
                            {
                                hintContent: '<?=$dat[2]?>',
                                <?php if ($baloonExists) { 
                                    if ($dat[8])
                                        $useFancybox = true;
                                    ?>
                                    balloonContentBody: '<?=$getCustomBalloonHtm($serial, $dat, $xdat, $blockInfo)?>',
                                <?php } else { ?>    
                                    balloonContentHeader: '<?=$dat[2]?>',
                                    balloonContentBody: '<?=$dat[3]?>',
                                    balloonContentFooter: '<?=$dat[4]?>',
                                <?php } ?>
                                <?= !$xdat[7] ? 'iconContent: "'.($dat[7] ?: $serial+1).'"' : ''?>                     
                            },{
                                <?php
                                if ($xdat[9]) { ?>
                                    iconLayout: '<?=($xdat[7] ? 'default#image' : 'default#imageWithContent')?>',
                                    iconImageHref: '<?=($dat[6] ?: $xdat[9])?>',
                                    iconImageSize: [<?=$xdat[10]?>],
                                    iconImageOffset: [<?=$xdat[11]?>]
                                <?php } elseif ($xdat[8]) { ?>
                                    preset: '<?=($dat[6] ?: $xdat[8])?>'
                                <?php } else { ?>
                                    preset: 'islands#blueIcon'
                                <?php } ?>
                            }
                        );
                		myMap.geoObjects.add(myPlacemark<?=$dat['rec']?>);
                        myMap.behaviors.disable('scrollZoom');
                    <?php } ?> 
                });
            } else {
                window.setTimeout(
                    function() {
                        initYandexMap<?=$block?>();
                    }, 
                    100
                );
            }
        };
        initYandexMap<?=$block?>();
    </script>

    <?php
    if ($useFancybox) {
        Blox::addToHead(Blox::info('cms','url').'/style/fancybox/jquery.fancybox.css');
        Blox::addToFoot(Blox::info('cms','url').'/style/fancybox/jquery.fancybox.js', ['position'=>'bottom']);
        Blox::addToFoot(Blox::info('cms','url').'/style/fancybox/jquery.fancybox.settings.js', ['after'=>'jquery.fancybox.js']);
    }
    $js = '
    <script>
    $(function() {
        /** #enlarge Не работает через аякс - не загружается карта
        $("body").on("click", "#yandex-map-'.$block.' .yandex-map-enlarge", function() {
            Blox.ajax("?block='.$block.'&mode=enlarge");
        });
        */
        if(/Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent))
            $("#yandex-map-'.$block.'").append(\'<div style="background:rgba(0,0,0,0.5) url('.Blox::info('templates','url').'/yandex-map/scroll.png) repeat-y top; position:absolute; width:40px; top:0px; right:0; bottom:0; z-index:1; margin:45px 5px; border-radius:5px 0 0 5px"></div>\');
    });
        
    </script>';
    if (Blox::ajaxRequested())
        echo $js;
    else
        Blox::addToFoot($js, 'minimize');
    echo'
</div>';