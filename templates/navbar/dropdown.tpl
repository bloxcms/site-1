<?php

if (empty($tab))
    return;

echo '<ul class="dropdown-menu">';
foreach ($tab as $dat)
{
    $href = Router::convert('?page='.$dat[1], array('name'=>$dat[2]));
    $ancestorClass = Router::hrefIsAncestor($href) ? ' class="active"' : '';

    if (empty($dat[2])) 
        $dat[2] = "&nbsp;";# Чтобы кнопка редактирования не накладывались
    
    echo '<li'.$ancestorClass.'>'.pp($dat['edit'], -3, 3);
        //if ($dat[1] == $page)
        //    echo '<span>'.$dat[2].'</span>';
        //else        
            echo '<a href="'.$href.'">'.$dat[2].'</a>';
    echo "</li>";
}
echo '</ul>';




