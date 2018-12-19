<?php 
/*
 * @todo Сделать ревизию инициализации и отправки/перезагрузки формы через аякс. Изза mask пришлось немного переделать 
 *     Вариант 1. Лучше для единообразия сделать так чтобы форма и загружалась и работала через аякс - все равно же нужно возвращать репорт. + Тогда на странице не нужно подключать init-inputmask.inc?
 *     Вариант 2. Если же скрипты выводить на странице, то можно ли реагировать на события в контексте body? + Тогда не нужно подгружать
 *     input mask on modal window not working https://github.com/RobinHerbots/Inputmask/issues/782
 */
 

/**
 
 *
 * ОСОБЕННОСТИ
 * 1.
 * Так как форма обычно вызывается в модальном окне, то она должна выводиться аяксом.
 * 2.
 * При отправке, запрос всегда идет к самому блоку формы. И таргет всегда он сам. В этот таргет заново выводится форма (с пометками об ошибках или без). 
 * Кроме формы, в случае успеха выводится дополнительный скрипт, который после полной загрузки делает аякс-запрос к другому урлу и может иметь произвольный таргет (но последнее уже не играет роли).
 * Отсюда вывод - из-за доп.скрипта или необходимости отмечать ошибки, форма должна перезагружается всегда.
 * Таким образом, мы имеем два разных урла для запроса и два разных таргета для вывода.
 * 3.
 * Как следствие перезагрузки формы - элементы формы становятся невидимы для внешний js-скриптов, то есть, пользовательские скрипты, касающиеся элементов формы, нужно записывать в конфигурации формы (свойства: on-ready, on-success, on-error)
 *
 * Алгоритм
 *     Взять код формы
 *     Если начальный вывод (Если нет аякс-запроса к блоку формы)
 *         Вывести код формы с контейнером (#block-99)
 *     Иначе
 *         Вывести код формы
 *     Вывести доп.скрипт (всегда)
 *
 */

require_once Blox::info('templates','dir').'/ff/form/Form.php';

# JSON
if ($dat[1]) {
    $dat1 = trim($dat[1]);
    if ('{' != $dat1[0]) { # URL to get JSON
        if ('change' != Blox::getScriptName()) {
            $dat1 = Url::convertToRelative($dat1);
            $json = Blox::execute($dat1, 'get');
        }
    } else 
        $json = $dat1;
        if (function_exists('json_decode')) {
            $jsonConfig = json_decode($json, true);
            $jsonError = trim(Str::getJsonError());
            if ($dat['edit'] && !($jsonError === '' || $jsonError === 'No error')) { # === '' comes from new declaration of Str::getJsonError()
                $jsonErrorMsg = 'В json-конфигурации обнаружена ошибка: '.$jsonError.'.<br>Вы можете проверить код конфигурации на сайте <a href="http://jsonlint.com" target="_blank">jsonlint.com</a>';
            }
        } elseif ($dat['edit']) {
            $jsonErrorMsg = 'PHP-функция <b>json_decode()</b> не существует!';
        }
    
} elseif ($dat['edit']) {
    $jsonErrorMsg = 'Не задана конфигурация формы в поле 1. Чтобы появилась конфигурация по умолчанию, назначьте этот же шаблон сюда же еще раз';
}

# Если нет ключа divs, то массив config привести к стандарту (с ключом divs).
if (!$jsonConfig['divs']) {
    $divs2 = $jsonConfig;
    $jsonConfig = [];
    
    # Общие свойства выносим из div 
    foreach (['action','method','target','on-error','on-success','on-ready'] as $p) { // "on-error" NOTTESTED
        if (isset($divs2[$p])) {
            $jsonConfig[$p] = $divs2[$p];  
            unset($divs2[$p]);  
        }
    }
    $jsonConfig['divs'][0] = $divs2;
}

if (isset($_GET['ff-form-captcha-renewal'])) # Обновление капчи через Ajax
{ 
    $captchaProps = \ff\Form::getFieldPropsByElement($jsonConfig['divs'], ['type'=>'captcha']);
    echo '<img src="'.Captcha::getImageUrl($captchaProps['name'], $captchaProps).'" />';
    return;
}
else # Вывод формы или обработка данных формы
{
    if (!Blox::ajaxRequested()) {
        Blox::addToHead(Blox::info('templates','url').'/ff/form/form.css');
        Blox::addToFoot(Blox::info('cms','url').'/assets/jquery.form.min.js');
    }
    # Submit properties
    $submitProps = \ff\Form::getFieldPropsByElement($jsonConfig['divs'], ['type'=>'submit']);
    if (isset($_POST['data'][$submitProps['name']])) {   
        \ff\Form::genErrorMessages($jsonConfig['divs'], $errorMessages);
        if (!isset($errorMessages))
            $success = true; # Не избавляйся от этого!
    }
        
    $zz = \ff\Form::getForm($block, $jsonConfig['divs'], $errorMessages, ['use-session'=>$dat[3]]);
    $htm = '';
    if (Blox::ajaxRequested() && $_GET['block']==$block) { # Вывести без контейнера
        if (!$success || !$dat[2])  // При выводе отклика форму не убирать
            $htm.= $zz;
    } else { # Это первый вывод
        $htm.= '
        <div class="ff-form" id="block-'.$block.'">
            '.$zz.pp($dat['edit']).'
        </div>';
    }

    if (!$success) { 
        # Место для вывода сообщений об ошибках
        if ($jsonErrorMsg) # jsonError
            $htm.='<div class="alert alert-danger">'.$jsonErrorMsg.'</div>';
        /* on-error */
        if ($jsonConfig['on-error']) {
            $script ='<script>$(function(){var blockId = '.$block.'; '.$jsonConfig['on-error'].'})</script>';
            if (Blox::ajaxRequested())
                $htm.= $script;
            else
                Blox::addToFoot($script);
        }   
    } 
    else { # Вывести аяксом ответ в указанном элементе (target), в том числе, вместо или внутри формы.
        # Этот else я убирал, но тогда при работе с шаблоном else, после вывода формы, сразу уходит на action (см. ниже $jsonConfig['action'])
        #
        # Данные формы прошли проверку, приступаем к их обработке
        $_POST['config'] = $jsonConfig; # Чтобы передать одним массивом
        if ('include' == $jsonConfig['method']) { # send data via include
            $htm.= \ff\Form::getActionReport($blockInfo, $success);# Генерация html-кода отчета вместо формы. В нижней части не получается - только вместо всей формы
        } else { # send data via ajax. Добавить отчет в нижней части формы
            $script ='
            <script>
                $(function() {
                    $.ajax({
                        url: "'.$jsonConfig['action'].'",
                        data : '.json_encode($_POST).',
                        method : "'.$jsonConfig['method'].'",
                        success: function(data) {
                            $("'.($jsonConfig['target'] ?: '#block-'.$block).'").html(data);';
                            if ($jsonConfig['on-success']) {
                                $script.='
                                    var blockId = '.$block.';
                                    '.$jsonConfig['on-success'];
                            }
                            $script.='
                        }
                    });
                });
            </script>';
            if (Blox::ajaxRequested())
                $htm.= $script;
            else
                Blox::addToFoot($script, 'minimize');
        }
        /**Fade
        $htm.='
        <script>
            // Проявить отчет
            $(function() {
                $("#block-'.$block.'").hide().fadeIn();
            });
        </script>';
        */
    }
    /* on-ready */
    if ($jsonConfig['on-ready']) {
        $script ='<script>$(function(){var blockId = '.$block.';'.$jsonConfig['on-ready'].'})</script>';
        if (Blox::ajaxRequested())
            $htm.= $script;
        else
            Blox::addToFoot($script);//, 'minimize'
    }
//qq($htm);
    echo $htm;
}