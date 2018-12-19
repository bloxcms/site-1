<?php
# ORIGIN: zavgar    ---kalegin.ru

    /*
    #Подключение скриптов и css
    Blox::addToHead(Blox::info('templates','url').'/assets/plugins/fancybox/source/jquery.fancybox.css', ['position'=>'top']);
    Blox::addToFoot(Blox::info('templates','url').'/assets/plugins/fancybox/source/jquery.fancybox.pack.js', ['position'=>'bottom']);
    <script>        
    $(document).ready(function() {
        $('a[rel=gallery]').fancybox({
            'overlayOpacity'    : 0.7,
    		'overlayColor'		: '#000',
            'titlePosition'	    : 'inside',
            'autoScale'	        : true,
            'centerOnScroll'    : true,
            'showNavArrows'     : false,
            'enableKeyboardNav' : false,
    	    'titleFormat'		: function(title, currentArray, currentIndex, currentOpts) {
    		    return '<span>' + (title.length ? ' </b>&nbsp;&nbsp;&nbsp; ' + title : '') + '</span>';
    		}
    	});
    });
    </script>
    */
    
    Blox::addToHead(Blox::info('cms','url').'/vendor/fancybox/jquery.fancybox.css');
    Blox::addToFoot(Blox::info('cms','url').'/vendor/fancybox/jquery.fancybox.js', ['position'=>'bottom']);
    Blox::addToFoot(Blox::info('cms','url').'/vendor/fancybox/jquery.fancybox.settings.js', ['after'=>'jquery.fancybox.js']);

    echo '
    <div class="paragraphs">';
        foreach ($tab as $ser => $dat) {
            echo'
            <div style="position:relative">';
                $img = '';
                $floatTo = '';
                if ($dat[4]) {                                                                   
                    # Альтернатива подписи к фото
                    if ($dat[5]) # подпись к фото
                        $alt = Text::stripTags($dat[5], 'strip-quotes');
                    elseif ($dat[1]) # заголовок
                        $alt = Text::stripTags($dat[1], 'strip-quotes');
                    # Выводим нужное фото
                    $filename = ($dat[3] && $dat[6] > 40) 
                        ? $dat[3]
                        : $dat[4]
                    ;
                    $img = '<img class="image" src="datafiles/'.$filename.'" alt="'.$alt.'" />';  //class="img-thumbnail"
                    # Разрешить открывать фото в отдельном окне
                    if ($dat[8])                         
                        $img = '<a href="datafiles/'.$dat[3].'" title="'.$dat[5].'" class="fancybox">'.$img.'</a>'; # data-fancybox-group="field-'.$field.'"
                    # Фото уплывает 
                    if ($dat[7] !='центр') {                                
                        if ($dat[7]=='вправо') $floatTo = 'floatRight'; 
                        else $floatTo = 'floatLeft';        
                    } else $floatTo = 'floatNone';                     
                }
                     
                ##################### Вывод #####################

                if (!empty($dat[1]))
                    echo '<div class="headline"><h3>'.$dat[1].'</h3></div>';
                if ($edit) 
                    echo '<div style="position:absolute; top:-5px; left:-16px">'.$dat['edit'].'</div>'; 
                
                if (!empty($dat[2])) 
                    $textHtm = $dat[2]; 
                else  
                    $textHtm = '&nbsp;';      //Выводим пустышку, когда нет контента, чтобы кнопки не накладывались друг на друга
                # Фото
                if ($img) {
                    echo '
                    <div class="'.$floatTo.'" style="width:'.$dat[6].'%">';
                        echo $img;
                        if ($dat[5]) echo '<div class="photoCaption small"><strong>'.$dat[5].'</strong></div>';
                    echo '
                    </div>';

                    echo $textHtm;

                    echo '
                    <div style="clear:both; font-size:0px;"></div>';
                } else {
                    echo'<div style="position:relative; clear:both;">';
                        //echo $editHtm;
                        if (!$dat['rec']) echo"<span style='font-size:11px;'> Новая запись</span>";
                        echo $textHtm;
                    echo'</div>';
                }                   
                echo'
            </div>';
        }// foreach
        echo'
    </div>';