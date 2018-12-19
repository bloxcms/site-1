<?php

namespace ff;

class Form {
    private static 
        $masks = []
    ;

   

    public static function getForm($block, $divs, $errorMessages, $options=[])
    {   
        if ($options)
            \Arr::formatOptions($options);
        $htm ='
        <form action="?block='.$block.'" method="post" id="ff-form-form-'.$block.'" enctype="multipart/form-data">
            '.self::getDivsHtm($divs, $_POST, $errorMessages, $block, $options).'
        </form>';
        //if (!Blox::ajaxRequested()) {
            $script ='
            <script>
                $(function() 
                {
                    $("[type=\'submit\']").prop("disabled", false); /* Активация кнопок типа submit в данной форме */
                    /* Form submit */
                    $("#ff-form-form-'.$block.'").ajaxForm({
                        target:"#block-'.$block.'",
                        beforeSerialize: function(form) {
                            /* onsubmitSelector */
                            $("[data-ff-form-onsubmitselector]").each(function() {
                                var srcElement = $(this).data("ff-form-onsubmitselector");
                                $(this).val($(srcElement).html());
                            });                                
                        },
                        beforeSubmit: function(aa, form) {
                            /*TODO e.preventDefault(); вместо disabled */
                            $(":submit", form).attr("disabled", "disabled"); /* Инактивация кнопок типа submit в данной форме */
                            
                            if ($.fn.bloxLoader)
                                $("#block-'.$block.'").bloxLoader();
                        }
                    });';
                    
                    /* Captcha renewal */
                    if (self::getFieldPropsByElement($divs, ['type'=>'captcha'])) {
                        $script.='
                        $("#ff-form-captcha-renewal-'.$block.'").on("click", function(e) {
                            $("#ff-form-captcha-'.$block.'").fadeOut(); /* погасить капчу */
                            $.ajax({
                                url: "?block='.$block.'&ff-form-captcha-renewal",
                                success: function(data) {
                                    $("#ff-form-captcha-'.$block.'").html(data).fadeIn();
                                    $("[type=\'submit\']").prop("disabled", false); /* Активация кнопок типа submit в данной форме */
                                }
                            });
                            e.preventDefault();
                        });'; 
                    }
                    /* Selector */
                    $script.='
                    $("[data-ff-form-selector]").each(function() {
                        var srcElement = $(this).data("ff-form-selector");
                        var $type = $(this).attr("type");
                        if ("text" == $type || "hidden" == $type) {
                            if (!$(this).val())
                                $(this).val($(srcElement).html());
                        } else if ("TEXTAREA" == $(this).prop("tagName")) {
                            if (!$(this).html())
                                $(this).html($(srcElement).html());
                        }
                    });';
                    /* Masks */
                    if ($masks = self::getMasks($block)) {
                        require_once \Blox::info('templates','dir').'/ff/form/init-inputmask.inc';
                        foreach ($masks as $inpName=>$mask) {
                            $script.='
                            $("#block-'.$block.' [name=\''.$inpName.'\']").inputmask(';
                                $mask = trim($mask);
                                if ('{'==$mask[0]) /* i.e. object */
                                    $script.= $mask;
                                else
                                    $script.= '"'.$mask.'"'; /* mask itself */
                                $script.='
                            );'; 
                        }
                    }
                    $script.='
                });
            </script>';
            
            if (\Blox::ajaxRequested())
                $htm.= $script;
            else
                \Blox::addToFoot($script);//, 'minimize'
        //}
        return $htm;
    }
    



    /**
     * @todo Пока параметр $post не используется. На него перейдем, когда будем делать универсальный метод.
     * @param array $options {
     *   @var bool 'use-session'
     *   @var bool 'for-email'
     * }
     */
    public static function getDivsHtm($divs, $post, $errorMessages=[], $blockId=null, $options=[])
    {   
        if ($options)
            \Arr::formatOptions($options);
        
        //if (!$options['use-session'])
            //unset($_SESSION['ff/form'][$blockId]['data']);
        
        $htm = '';
        foreach ($divs as $div) {
            if ($div['id'])
                $idAttr = ' id="'.$div['id'].'"';
            if ($div['class'])
                $clAttr = ' class="'.$div['class'].'"';
            $htm .= '
            <div'.$idAttr.$clAttr.'>';
                if ($div['fields']) { # Непосредственно вывод полей
                    # поэтому непосредственный заголовок полей передается в метод, так как заголовок должен верстаться в сетке полей, а не сам по себе.
                    $htm .= self::getFieldsHtm($div, $post, $errorMessages, $blockId, $options);
                } elseif ($div['divs']) { # Вывод раздела
                    
                    if ($div['heading']) {
                        if ($options['for-email'])
                            $htm .= '<h3>'.$div['heading'].'</h3>';
                        else
                            $htm .= '<div class="ff-form-div-heading">'.$div['heading'].'</div>';
                    }
                    
                    if ($div['subheading']) {
                        if ($options['for-email'])
                            $htm .= '<h4>'.$div['subheading'].'</h4>';
                        else
                            $htm .= '<div class="ff-form-div-subheading">'.$div['subheading'].'</div>';
                    }
                    $htm .= self::getDivsHtm($div['divs'], $post, $errorMessages, $blockId, $options);
                }
                $htm .= '
            </div>';
        }
        return $htm;    
    }
    
    
    
    

    public static function getFieldsHtm($div, $post, $errorMessages=[], $blockId=null, $options=[])
    {   
        if ($options)
            \Arr::formatOptions($options);
        $fieldsHtm = '';
        $prevTrailing = false;
        # Default layout
        if (!$div['layout'])
            $div['layout'] = ['fields'=>'vertical', 'labels'=>'top'];
        #
        if (!$div['layout']['fields'])
            $div['layout']['fields'] = 'vertical';
        # 
        if (!$div['layout']['labels'] && $div['layout']['fields'] != 'horizontal')
            $div['layout']['labels'] = 'top';
        #
        if (!$div['layout']['cols'] && $div['layout']['fields']=='vertical' && $div['layout']['labels']=='left')
            $div['layout']['cols'] = ['col-sm-4','col-sm-8'];        
//qq($div);
        # Вывод полей формы
        foreach ($div['fields'] as $properties) 
        {
            $type = '';
            $inHtm = '';
            $hasError = '';                
            $helpBlock = '';
            //$errorMessage = '';   2017-03-21 20:12
            if (isset($errorMessages[$properties['name']])) {
                $hasError = ' has-error';
                if ($errorMessages[$properties['name']])
                    $helpBlock = '<div class="help-block small">'.$errorMessages[$properties['name']].'</div>';
            }    

            if (mb_strpos($properties['validation'], 'not-empty') !== false) {
                $danger = '&nbsp;<span class="text-danger">*</span>';
            } else {
                $danger = '';
            }


            if (!$properties['type'] || 'hidden'==$properties['type'])
                $ftype = 'input';
            else
                $ftype = $properties['type'];
            # $value
            if (isset($_POST['data'][$properties['name']])) {               
                if ($ftype == 'submit') {
                    $value = $properties['default'];
                } else {
                    $value = $_POST['data'][$properties['name']];
                }
                if ($options['use-session'])
                    $_SESSION['ff/form'][$blockId]['data'][$properties['name']] = $value;
            } else {
                if (isset($_GET['ff-form']['data'][$properties['name']])) {# Передача данных через кнопку [data-ff-popups-url]
                    $value = $_GET['ff-form']['data'][$properties['name']];
                } elseif ($options['use-session'] && isset($_SESSION['ff/form'][$blockId]['data'][$properties['name']])) {
                    $value = $_SESSION['ff/form'][$blockId]['data'][$properties['name']];
                } else  {
                    $value = $properties['default'];
                }   
            }

            $attributes = '';
            if ($properties['attributes']) {
                foreach ($properties['attributes'] as $k=>$v) {
                    $attributes.= ' '.$k;
                    if ($v)
                        $attributes.= '="'.$v.'"';
                }
            }
            $placeholder = ($properties['placeholder']) 
                ? ' placeholder="'.$properties['placeholder'].'"' : 
                ''
            ;
            $selector = '';
            $onsubmitSelector = '';
            if (!$options['for-email'] && ($ftype == 'input' || $ftype == 'textarea')) {
                $selector = ($properties['selector']) 
                    ? ' data-ff-form-selector="'.$properties['selector'].'"' 
                    : ''
                ;
                if ($selector)
                    $placeholder = '';
                $onsubmitSelector = ($properties['onsubmitSelector']) 
                    ? ' data-ff-form-onsubmitselector="'.$properties['onsubmitSelector'].'"' 
                    : ''
                ;
            }   
            #       
            if ($ftype == 'input') {
                if (!$options['for-email']) {
                    $type = ('hidden'==$properties['type'])
                        ? 'hidden'
                        : 'text'
                    ;
                    $inHtm = '<input type="'.$type.'" class="'.($properties['class'] ?: 'form-control').'" name="data['.$properties['name'].']" value="'.$value.'"'.$placeholder.$selector.$onsubmitSelector.$attributes.' />';
                    if ($properties['mask']) {
                        self::addMask($blockId, 'data['.$properties['name'].']', $properties['mask']);
                    }
                } elseif ('hidden' != $properties['type'])
                    $inHtm = ' '.$value;
            } elseif ($ftype == 'textarea') {
                if ($options['for-email'])
                    $inHtm = '<br>'.$value;
                else
                    $inHtm = '<textarea class="'.($properties['class'] ?: 'form-control').'" name="data['.$properties['name'].']"'.$placeholder.$selector.$onsubmitSelector.$attributes.'>'.$value.'</textarea>';
            } elseif ($ftype == 'radio') {
                /* Вариант где передается слово*/
                $sep = ($properties['checks-layout']=='vertical') ? '<br>' : ' &nbsp; ';
                foreach ($properties['options'] as $i => $option) {
                    if (!(!$i && !$properties['label']))
                        if (!$options['for-email'])
                            $inHtm.= $sep;
                        elseif ($value==$option)
                            $inHtm.= $sep;
                    if (!$options['for-email'])
                        $inHtm.= '<label class="radio-inline"><input type="radio" name="data['.$properties['name'].']" value="'.$option.'" '.($value==$option ? ' checked="checked"' : '').($properties['class'] ? ' class="'.$properties['class'].'"' : '').$attributes.' /> '.$option.'</label>';
                    elseif ($value==$option)
                        $inHtm.= ' • '.$option;
                }
                /* Вариант где передается ключ
                $sep = ($properties['checks-layout']=='vertical') ? '<br>' : ' &nbsp; ';
                foreach ($properties['options'] as $i => $option) {
                    $ii = "$i";
                    $inHtm.= '<label class="radio-inline"><input type="radio" name="data['.$properties['name'].']" value="'.$ii.'" '.($value==$ii ? ' checked="checked"' : '').' /> '.$option.'</label>'.$sep;
                }
                */
            } elseif ($ftype == 'checkbox')  {
                $inHtm = '';
                /* Вариант где передается слово, неотмеченные не передаются */
                if ($properties['options']) { # Несколько чекбоксов-опций
                    $sep = ($properties['checks-layout']=='vertical') ? '<br>' : ' &nbsp; ';
                    foreach ($properties['options'] as $i => $option) {
                        if (!(!$i && !$properties['label'])) {
                            if (!$options['for-email'])
                                $inHtm.= $sep;
                            elseif ($value[$i])
                                $inHtm.= $sep;
                        }
                        #
                        if ($options['for-email']) {
                            $inHtm.= ' • '.$option;
                        } else {//if ($value[$i])
                            $inHtm.= '<input type="hidden" name="data['.$properties['name'].']['.$i.']" value="0" />';
                            $inHtm.= '<label class="checkbox-inline"><input type="checkbox" name="data['.$properties['name'].']['.$i.']" value="'.$option.'" '.($value[$i] ? ' checked="checked"' : '').($properties['class'] ? ' class="'.$properties['class'].'"' : '').$attributes.' /> '.$option.'</label>';
                        }   
                    }
                } 
                /* Вариант где передается 0 или 1, в том числе и для неотмеченного
                if ($properties['options']) { # Несколько чекбоксов-опций
                    $sep = ($properties['checks-layout']=='vertical') ? '<br>' : ' &nbsp; ';
                    foreach ($properties['options'] as $i => $option) {
                        $inHtm.= '<input type="hidden"   name="data['.$properties['name'].']['.$i.']" value="0" />';
                        $inHtm.= '<label class="checkbox-inline"><input type="checkbox" name="data['.$properties['name'].']['.$i.']" value="1" '.($value[$i] ? ' checked="checked"' : '').' /> '.$option.'</label>'.$sep;
                    }
                } else { # Один чекбокс
                    $inHtm.= '<input type="hidden"   name="data['.$properties['name'].']" value="0" />';
                    $inHtm.= '<input type="checkbox" name="data['.$properties['name'].']" value="1" id="'.$properties['name'].'" '.($value ? ' checked="checked"' : '').' />';
                }
                */
            } elseif ($ftype == 'select')  {
                # Вариант где передается слово
                if ($properties['options']) {
                    if ($options['for-email']) {
                        foreach ($properties['options'] as $option) {
                            if ($option==$value) {
                                $inHtm = ' • '.$option;
                                break;
                            }
                        }
                    } else {
                        $inHtm = '<select  name="data['.$properties['name'].']" class="'.($properties['class'] ?: 'form-control').'"'.$attributes.'>';
                        foreach ($properties['options'] as $option) {
                            #$option = trim($option, "'\" ");
                            $inHtm.= '<option ';
                            if ($option==$value) 
                                $inHtm.= 'selected="selected" ';
                            $inHtm.= 'value="'.$option.'">'.$option.'</option>';
                        } 
                        $inHtm .= '</select>';
                    }
                }
            } elseif ($ftype == 'captcha' && !$options['for-email']) {
                $inHtm = '
                    <div class="clearfix">
                        <style>.ff-form [name="data['.$properties['name'].']"] {width:30%; float:left}</style>
                        <input type="text" class="'.($properties['class'] ?: 'form-control').'" name="data['.$properties['name'].']"'.$attributes.' />
                        <span id="ff-form-captcha-'.$blockId.'"><img src="'.\Captcha::getImageUrl('data['.$properties['name'].']', $properties).'" /></span>
                        <button class="btn btn-default btn-xs" id="ff-form-captcha-renewal-'.$blockId.'" >Обновить</button>
                    </div>
                ';
            } elseif ($ftype == 'submit' && !$options['for-email']) {
                $inHtm = '<button name="data['.$properties['name'].']" type="submit" value="" class="'.($properties['class'] ?: 'btn btn-primary').'"'.$attributes.'>'.$value.'</button>';
            } elseif ($ftype == 'file') {
                if ($options['for-email']) 
                    $inHtm = 'Смотрите вложение';
                else {
                    $inHtm = '';
                    if ($div['layout']['labels']=='top')
                        $inHtm.= '<br>';
                    $inHtm.= '
                    <label class="ff-form-file '.($properties['class'] ?: 'btn btn-default').'">
                        <input type="file" name="data['.$properties['name'].']" onchange="$(\'#upload-file-info\').html(this.files[0].name)">
                        Выберите файл
                    </label>
                    <span id="upload-file-info"></span>';
                }
            }


    

    
    
            $trailing = false;
            if ($properties['features']) {
                if (!is_array($properties['features'])) {
                    # Format $properties['features']
                    $aa = $properties['features'];
                    unset($properties['features']);
                    $properties['features'][] = $aa;
                }
                if (in_array('trail',$properties['features']))
                    $trailing = true;
            }
            
            # Begin #Trailing
            if ($trailing && !$prevTrailing)
                $fieldsHtm .= '<div class="form-inline" style="margin-bottom:15px">';

            # Вывод поля     
            if ($type == 'hidden') {
                $fieldsHtm .= $inHtm;
            } else {
                $labelForCheckbox = ($ftype == 'checkbox' && !$properties['options']) 
                    ? ' for="'.$properties['name'].'"'
                    : ''
                ;
                
                $sizeClass = ($properties['size'])
                    ? ' form-group-'.$properties['size']
                    : ''
                ;
                //('submit'==$ftype ? ' text-center' : '').
                $fieldsHtm .='
                <div class="form-group'.$sizeClass.$hasError.'">';
                    if ($div['layout']['labels']=='left') {
                        if (isset($properties['label'])) {
                            $labelClass = ' class="'.$div['layout']['cols'][0].' control-label"';
                            $inputDivClass = ' class="'.$div['layout']['cols'][1].'"';
                        } else {
                            $labelClass = ' class="hidden-xs"';
                            $inputDivClass = ' class="col-sm-12"';
                        }
                    } else {
                        $labelClass = '';
                        $inputDivClass = '';
                    }
                    
                    
                    if (!$options['for-email']) {
                        if (isset($properties['label'])) {
                            $fieldsHtm .='<label'.$labelClass.$labelForCheckbox.'>'.$properties['label'].$danger.'</label>';
                            if (($ftype == 'radio' || $ftype == 'checkbox') && ($div['layout']['labels']=='top' && $properties['checks-layout'] !='vertical'))
                                $fieldsHtm .='<br>';
                        }
                    } else {
                        if (isset($properties['label']))
                            $fieldsHtm .='<b>'.$properties['label'].':</b> ';
                        elseif ($properties['placeholder'])
                            $fieldsHtm .='<b>'.$properties['placeholder'].':</b> ';
                    }
                    // && 'submit' !== $ftype
                    if ($inputDivClass)
                        $fieldsHtm .='<div'.$inputDivClass.'>'.$inHtm.$helpBlock.'</div>';
                    else 
                        $fieldsHtm .= $inHtm.$helpBlock;
                    $fieldsHtm .='
                </div>';
            }
            
            # End #Trailing
            if (!$trailing && $prevTrailing)
                $fieldsHtm .= '</div>';
            
            $prevTrailing = $trailing;
            
            if ($options['for-email'])
                $fieldsHtm .= '<br>';
                
        }
        
        # Страховка, если последнему полю случайно дали команду trail
        if ($trailing)
            $fieldsHtm .= '</div>';
        
        # Heading htm
        $headingHtm = '';
        if ($div['heading']) {
            if (!$options['for-email'])
                $headingHtm .= '<div class="ff-form-fields-heading">'.$div['heading'].'</div>';
            else
                $headingHtm .= '<h3>'.$div['heading'].'</h3>';
        }
        
        if ($div['subheading']) {
            if (!$options['for-email'])
                $headingHtm .= '<div class="ff-form-fields-subheading">'.$div['subheading'].'</div>';
            else
                $headingHtm .= '<h4>'.$div['subheading'].'</h4>';
        }
                

        
        # Assemble headingHtm + fieldsHtm
        $outerHtm = '';
        $outerClass = '';
        if ($div['layout']['labels']=='left') {
            $outerClass = 'form-horizontal';
            if ($headingHtm)
                $outerHtm .= $headingHtm;
        } elseif ($div['layout']['fields']=='vertical') {
            $outerClass = '';
            $outerHtm .= $headingHtm;
        } elseif ($div['layout']['fields']=='horizontal') {
            $outerClass = 'form-inline';
            $outerHtm .= $headingHtm;
        }

        if ($outerClass)
            $outerHtm .= '<div class="'.$outerClass.'">'.$fieldsHtm.'</div>';
        else
            $outerHtm .= $fieldsHtm;
        
        return $outerHtm;
    }





    public static function genErrorMessages($divs, &$errorMessages)
    {   
        foreach ($divs as $div) {
            if ($div['divs']) {
                self::genErrorMessages($div['divs'], $errorMessages);                
            } 
            elseif ($div['fields']) {
                foreach ($div['fields'] as $properties) {
                    if ($properties['validation']) {
                        if ($properties['type']=='checkbox') {
                            $value2 = '';
                            foreach ($_POST['data'][$properties['name']] as $v) {
                                ##if ($v==1) { // Это для второй схемы работы: где передается 0 или 1, в том числе и для неотмеченного
                                if ($v) {
                                    $value2 = 'xxx'; # To be not empty
                                    break;
                                }
                            }
                            if (!$value2) {
                                # KLUDGE
                                if (!\Str::isValid($value2, $properties['validation'], $errorMessage)) {
                                    if ($errorMessage) 
                                        $errorMessages[$properties['name']] = '';
                                }
                            }
                        } else {
                            $value = $_POST['data'][$properties['name']];
                            if (!\Str::isValid($value, $properties['validation'], $errorMessage)) {
                                if ($errorMessage) 
                                    $errorMessages[$properties['name']] = $errorMessage;
                            }
                        }
                    } elseif ($properties['type']=='captcha') {
                        if (\Captcha::exceeded('data['.$properties['name'].']')) {
                            $errorMessages[$properties['name']] = 'Вы исчерпали лимит ввода секретных знаков. Попробуйте позднее';
                        } elseif (!\Captcha::check('data['.$properties['name'].']', $_POST['data'][$properties['name']])) {
                            $errorMessages[$properties['name']] = 'Неправильные знаки';
                        }
                    }
                }
            }
        }
    }
    
    


    
    public static function getFieldPropsByElement($divs, $arr)
    {   
        $ar = each($arr);
        foreach ($divs as $div) {
            if ($div['divs']) {
                if ($properties = self::getFieldPropsByElement($div['divs'], $arr))
                    return $properties;
            } elseif ($div['fields']) {
                foreach ($div['fields'] as $properties) {
                    if ($properties[$ar['key']]==$ar['value']) {
                        return $properties;
                    }
                }
            }
        }
    }
    


    public static function addMask($blockId, $name, $mask)
    {   
        self::$masks[$blockId][$name] = $mask;
    }

    public static function getMasks($blockId=null)
    {
        if ($blockId==null)
            return self::$masks;
        elseif ($blockId)
            return self::$masks[$blockId];
        else
            return false;
    }



    public static function getActionReport($blockInfo, $success)
    {   
        ob_start();
        include $_POST['config']['action'];
        return ob_get_clean();
    }

    /* Use \Str::getJsonError()
    public static function getJsonError() {
        static $errors = [
            JSON_ERROR_NONE             => null,
            JSON_ERROR_DEPTH            => 'Maximum stack depth exceeded',
            JSON_ERROR_STATE_MISMATCH   => 'Underflow or the modes mismatch',
            JSON_ERROR_CTRL_CHAR        => 'Unexpected control character found',
            JSON_ERROR_SYNTAX           => 'Syntax error, malformed JSON',
            JSON_ERROR_UTF8             => 'Malformed UTF-8 characters, possibly incorrectly encoded'
        ];
        $error = json_last_error();
        return array_key_exists($error, $errors) ? $errors[$error] : "Unknown error ({$error})";
    }
    */
    
    
}