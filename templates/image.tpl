<?php 
#ORIGIN: eskulap    ---осаго  ---zavgar ---avtokrat   ---пневмо-подвеска.рф     ---nemstandart  ---ETK


# Align
$wrapClass ='';
if ('влево'==$dat[9]) {
    ;
} elseif ('вправо'==$dat[9]) {
    $wrapClass .= ' text-right';
} else { # по-центру
    $wrapClass .= ' text-center';
}

echo'
<div class="image'.$wrapClass.'">';

    if ($dat[1])
    {
        $imgClass = 'mouseover';
        $imgStyle = '';
        if ($dat[6]) {
            $imgStyle .= ';width:'.$dat[6];
        } elseif ($dat[8] == 'ПО-ШИРИНЕ-МЕСТА') {
            $imgStyle .= ';width: 100%;height:auto';
        } elseif ($dat[8] == 'НО-НЕ-БОЛЬШЕ-ИСХОДНОЙ-ШИРИНЫ-ФОТО') {
            $imgClass .= ' img-responsive';
            # Align
            if ('влево'==$dat[9]) {
                ;//$imgStyle .= ';margin-right: auto';
            } elseif ('вправо'==$dat[9]) {
                $imgStyle .= ';margin-left: auto';
            } else { # по-центру
                $imgStyle .= ';margin-left: auto; margin-right: auto';
            }
        }
        
        if ($dat[5])
            $imgClass .= ' imgframe';
        
        
        if ($dat[2]) {
            $alt = Text::truncate(trim(Text::stripTags($dat[2],'strip-quotes')), 99, 'plain');
            $alt = explode('.', $alt)[0]; # Взять до первой точки
        } else
            $alt = '';
        
        $img = '<img src="datafiles/'.$dat[1].'" alt="'.$alt.'" class="'.$imgClass.'"'.($imgStyle ? ' style="'.substr($imgStyle,1).'"' : '').' />';

        if ('над фото'==$dat[7])
            echo '<div class="caption">'.$dat[2].'</div>';


        if(empty($dat[3]))
            echo $img;
        else {
            echo'<a href="'.$dat[3].'" title="'.$alt.'"'.($dat[4] ? ' target="_blank"' : '').'>'.$img.'</a>';
        }
        
        if ('под фото'==$dat[7])
            echo '<div class="caption">'.$dat[2].'</div>';
        elseif ('на фото'==$dat[7])
            echo '<div class="caption above" style="">'.$dat[2].'</div>';
    }    
    

    echo pp($dat['edit'],0,0);
    echo'
</div>';
