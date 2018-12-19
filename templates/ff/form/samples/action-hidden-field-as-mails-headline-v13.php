<?php


                
                
/**
 * Скрытое поле
 *		"name" : "headline",
 *		"type" : "hidden",
 *		"selector" : ""
 *
 *
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
 *     settings-reports-noEmails
 *     settings-reports-emailSent
 *     settings-reports-emailNotSent
 *     Пример:
 *     "fields" : [
 * 	       {
 *             "name" : "settings-reports-emailSent",
 *             "type" : "hidden",
 *             "default" : "Ваш заказ отправлен"
 * 		   } 
 * 	   ]
 * 
 */

//qq('action-default.php');
//qq($_POST);
//qq($_GET);
 
if (!$success)
    return;


$settings = [
    'subject' => $_POST['settings-subject'] ?: 'Сообщение с сайта '.Url::punyDecode(Blox::getInfo('site','url')),
    'emails' => [
        'to' => $_POST['settings-emails-to'] ?: Blox::getInfo('site','emails','to'),
        'from' => $_POST['settings-emails-from'] ?: Blox::getInfo('site','emails','from'),
    ],
    'reports' => [
        'noEmails' => $_POST['settings-reports-noEmails'] ?: 'Сообщения временно не принимаются', # Так как не определен  email
        'emailSent' => $_POST['settings-reports-emailSent'] ?: 'Ваше сообщение отправлено',
        'emailNotSent' => $_POST['settings-reports-emailNotSent'] ?: 'Сообщение отправить не удалось',
    ],
];

# transport
if (!$_POST['settings-emails-from'] && Blox::getInfo('site','emails','from') && Blox::getInfo('site','emails','transport'))
    $transport = Blox::getInfo('site','emails','transport');
else
    $transport = [];
       
if ($settings['emails']['to']) 
{
    if ($settings['emails']['from'])
        ;
    else
        Blox::prompt('В файле '.$_POST['config']['action'].' не определен обратный электронный адрес. Письмо может быть не доставлено', true);
    
    $msg = '<h3>'.Text::stripTags($_POST['headline']).'</h3>';
    $msg.= \ff\Form::getDivsHtm($_POST['config']['divs'], $_POST, '', $_GET['block'], true);

    if (Email::send([
        'from'=>$settings['emails']['from'], 
        'to'=>$settings['emails']['to'], 
        'subject'=>$settings['subject'], 
        'htm'=>$msg, 
        'transport'=>$transport,
    ])) {
        $alert['text'] = $settings['reports']['emailSent'];
        $alert['bg'] = 'alert-success';    
    } else {
        $alert['text'] = $settings['reports']['emailNotSent'];
        $alert['bg'] = 'alert-danger';
    }
}
else {
    $alert['text'] = $settings['reports']['noEmails'];
    $alert['bg'] = 'alert-danger';
}
echo'<h4 class="alert '.$alert['bg'].'" role="alert">'.$alert['text'].'</h4>';

