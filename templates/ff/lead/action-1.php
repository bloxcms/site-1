<?php

/**
 * Скрипт для отправки данных формы по элект.почте
 *
 * НА ВХОДЕ
 *      $_POST - данные с формы и конфигурации (в элементе 'config') массив конфигурации формы, полученный из JSON
 * НА ВЫХОДЕ
 *      вывести HTML-код с сообщением о результате выполнения скрипта с помощью echo. 
 * 
 * Чтобы изменить сообщения, выводимые после клика, и другие общие установки, добавляйте в json-конфигурацию невидимые поля 
 *     settings-subject
 *     settings-emails-to
 *     settings-emails-from
 *     settings-reports-no-emails
 *     settings-reports-email-sent
 *     settings-reports-email-not-sent
 *     Пример:
 *     "fields" : [
 * 	       {
 *             "name" : "settings-reports-email-sent",
 *             "type" : "hidden",
 *             "default" : "Ваш заказ отправлен"
 * 		   } 
 * 	   ]
 * 
 */
 
if (!$success)
    return;

//qq($_POST);
//qq($_GET);
$settings = [
    'subject' => $_POST['settings-subject'] ?: 'Сообщение с сайта '.Url::punyDecode(Blox::info('site','url')),
    'emails' => [
        'to' => $_POST['settings-emails-to'] ?: Blox::info('site','emails','to'),
        'from' => $_POST['settings-emails-from'] ?: Blox::info('site','emails','from'),
    ],
    'reports' => [
        'no-emails' => $_POST['settings-reports-no-emails'] ?: 'Сообщения временно не принимаются', # Так как не определен  email
        'email-sent' => $_POST['settings-reports-email-sent'] ?: 'Ваше сообщение нами получено. Мы свяжемся с вами в течение 1 часа',
        'email-not-sent' => $_POST['settings-reports-email-not-sent'] ?: 'Сообщение отправить не удалось',
    ],
];
# transport
if (!$_POST['settings-emails-from'] && Blox::info('site','emails','from') && Blox::info('site','emails','transport'))
    $transport = Blox::info('site','emails','transport');
else
    $transport = [];
       
if ($settings['emails']['to']) 
{
    if ($settings['emails']['from'])
        ;
    else
        Blox::prompt('В файле '.$_POST['config']['action'].' не определен обратный электронный адрес. Письмо может быть не доставлено', true);
    $msg = '<h2>'.$_POST['theme'].'</h2>';
    $msg.= \ff\Form::getDivsHtm($_POST['config']['divs'], $_POST, '', $_GET['block'], ['for-email']);


    if (Email::send([
        'from'=>$settings['emails']['from'], 
        'to'=>$settings['emails']['to'], 
        'subject'=>$settings['subject'], 
        'htm'=>$msg, 
        'transport'=>$transport,
    ])) {
        $alert['text'] = $settings['reports']['email-sent'];
        $alert['bg'] = 'alert-success';    
    } else {
        $alert['text'] = $settings['reports']['email-not-sent'];
        $alert['bg'] = 'alert-danger';
    }
}
else {
    $alert['text'] = $settings['reports']['no-emails'];
    $alert['bg'] = 'alert-danger';
}
echo'<h4 class="alert '.$alert['bg'].'" role="alert">'.$alert['text'].'</h4>';

