<?php

/**
 * Скрипт для отправки данных формы по элект.почте
 *
 * НА ВХОДЕ
 *      $_POST - данные с формы (в элементе 'data') и конфигурация (в элементе 'config') массив конфигурации формы, полученный из JSON
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
 *      Данные сообщения можно было бы редактировать в окне редактирования шаблона ff/form, однако, там настраиваются вещи, связанные только с самой формой.
 * 
 */
 
if (!$success)
    return;

//qq($_POST);
//qq($_GET);
//qq(Upload::format($_FILES));
$settings = [
    'subject' => $_POST['data']['settings-subject'] ?: 'Сообщение с сайта '.Url::punyDecode(Blox::info('site','url')),
    'emails' => [
        'to'    => $_POST['data']['settings-emails-to'] ?: Blox::info('site','emails','to'),
        'from'  => $_POST['data']['settings-emails-from'] ?: Blox::info('site','emails','from'),
    ],
    'reports' => [
        'no-emails'         => $_POST['data']['settings-reports-no-emails'] ?: 'Сообщения временно не принимаются', # Так как не определен  email
        'email-sent'        => $_POST['data']['settings-reports-email-sent'] ?: 'Ваше сообщение отправлено',
        'email-not-sent'    => $_POST['data']['settings-reports-email-not-sent'] ?: 'Сообщение отправить не удалось',
    ],
];



       
if ($settings['emails']['to']) {
    if (!$settings['emails']['from'])
        Blox::prompt('В файле '.$_POST['config']['action'].' не определен обратный электронный адрес. Письмо может быть не доставлено', true);
    $data = [
        'from'=>$settings['emails']['from'], 
        'to'=>$settings['emails']['to'], 
        'subject'=>$settings['subject'],
        'htm'=> \ff\Form::getDivsHtm($_POST['config']['divs'], $_POST, '', $_GET['block'], ['for-email']),
    ];
    # transport
    if (!$_POST['data']['settings-emails-from'] && Blox::info('site','emails','from') && Blox::info('site','emails','transport'))
        $data['transport'] = Blox::info('site','emails','transport');
    #
    if ($_FILES) {
        foreach (Upload::format($_FILES)['data'] as $k => $v)
            if ($v['error']==0)
                $data['attachments'][] = ['path'=>$v['tmp_name'], 'name'=>$k.'-'.$v['name']];
    }
    #
    if (Email::send($data)) {
        $alert['text'] = $settings['reports']['email-sent'];
        $alert['bg'] = 'alert-success';    
    } else {
        $alert['text'] = $settings['reports']['email-not-sent'];
        $alert['bg'] = 'alert-danger';
    }
} else {
    $alert['text'] = $settings['reports']['no-emails'];
    $alert['bg'] = 'alert-danger';
}
echo'<h4 class="alert '.$alert['bg'].'" role="alert">'.$alert['text'].'</h4>';

