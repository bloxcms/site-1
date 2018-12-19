<?php 
#ORIGIN: пневмо-подвеска.рф     ---nemstandart  ---ETK
?>

    
<div class="blog-image">
<?php    
if ($dat[1])
{
    $img = '
    <img 
        src="datafiles/'.$dat[1].'" 
        alt="'.$dat[2].'" 
        class="mouseover'.($dat[5]?' imgframe':'').($dat[6] ? '' : ' img-responsive').'"
        '.(($dat[6]) ? ' style="width:'.$dat[6].'"' : '').' 
    />';
    if(empty($dat[3]))
        echo $img;
    else {   
        echo'<a href="'.$dat[3].'"'; 
        if ($dat[4]) 
            echo' target="_blank"'; 
        echo'>'.$img.'</a>';
    }
    if ($dat[7])
        echo '<p>'.$dat[2].'</p>';
}
echo pp($dat['edit'],0,0);
?>
</div>

