<?php
# ORIGIN: povoljie  ---ижмин ---transcoin
# TODO  Дублируют друг друга main-navigation и sticky-navigation
#
Blox::addToHead('templates/navbar/navbar.css');
?>
<div class="navbar navbar-inverse">
    <div class="container" style="position:relative">
        <!-- Brand and toggle get grouped for better mobile display -->
        <div class="navbar-header">
            <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1" style="padding: 4px 10px">
                <div style="display:inline-block">
                    <span class="sr-only">Toggle navigation</span>
                    <span class="icon-bar"></span><span class="icon-bar"></span><span class="icon-bar"></span>
                </div>
                <span style="display:inline-block; color:#fff">Меню</span>
            </button>
            <?=$xdat[1]?>
            <!--<a class="navbar-brand" href="#" ><img src="xfiles/logo.svg" style="height:45px; margin-top: -7px;"></a>-->
        </div>
        <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
            <ul class="nav navbar-nav<?=($xdat[2] ? ' navbar-right' : '')?>">
                <?php 
                echo '<li'.($page==1 ? ' class="active"' : '').'><a href="./" data-rows-scroll>Главная</a></li>';
                $navbarClickable = false;
                foreach ($tab as $dat) {
                    if ($dat[6])
                        echo '<li><a href="'.$dat[6].'" data-rows-scroll>'.$dat[2].'</a></li>';
                    else {                                
                        $href = Router::convert('?page='.$dat[1], ['name'=>$dat[2]]);
                        $clas = '';
                        $clas2 = '';
                        $caret = '';
                        if (Router::hrefIsAncestor($href)) 
                            $clas .= ' active';
                        if ($dat[5]) {
                            $clickableClass = '';
                            if ($dat[7]) {
                                $navbarClickable = true;
                                $clickableClass = ' navbar-item-clickable';
                            }
                            $clas .= ' dropdown';
                            $clas2 = ' class="dropdown-toggle'.$clickableClass.'" data-toggle="dropdown" role="button"';
                            $caret = ' <span class="caret"></span>';
                        }
                        if ($clas)
                            $clas = ' class="'.substr($clas, 1).'"';
                        
                        echo '<li'.$clas.'>';
                            echo'<a href="'.$href.'"'.$clas2.'>'.$dat[2].$caret.'</a>';
                            if ($dat[5]) {
                                if ($edit && substr($dat[3], 27, 11) == 'blox-no-tpl') # В режиме редактирования, в случае не назначенного шаблона dropMenu, кнопку назначения выводим в выпадающем меню
                                    echo'<ul class="dropdown-menu"><li>'.$dat[3].' &nbsp;  &nbsp; &nbsp; &nbsp; &nbsp; </li></ul>';
                                else
                                    echo $dat[3];
                            }
                        echo'</li>';
                    }
                }
                ?>
            </ul>
        </div><!-- /.navbar-collapse -->
        <?=$xdat[5]?>
    </div><!-- /.container-fluid -->
    
    <?= pp($edit['button'],-3,-7) ?>
</div>

<?php
if ($navbarClickable) {
    Blox::addToHead('<style>@media only screen and (min-width:'.$xdat[4].'px) {.dropdown:hover .dropdown-menu {display: block;}}</style>');
    Blox::addToFoot('<script>$(".navbar-item-clickable").click(function(e) {if ($(document).width() > '.$xdat[4].') {e.preventDefault();var url = $(this).attr("href");if (url !== "#") {window.location.href = url;}}});</script>');
}