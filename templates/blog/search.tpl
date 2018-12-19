<?php 
#ORIGIN: пневмо-подвеска.рф     ---nemstandart  ---ETK

if ('unify' == $GLOBALS['blog']['theme']) {
    $u = '-u';
    $primary   = '';
    $secondary = ' btn-u-default';
} else {
    $u = '';
    $primary   = ' btn-primary';
    $secondary = ' btn-default';
}

    
    
$searchText = Request::get(113, 'search', 'texts', 1);
$complexId = 'brands';
?>
<div class="row" style="margin-bottom:22px">
    <div class="col-sm-3">    
        <?php
        if (!isset($_GET['p'][10])) {
            if ($aa = Sql::select('SELECT count(*) FROM '.Blox::getTbl('blog/nav').' WHERE `block-id`=?', [113])[0]['count(*)'])
                echo'<h1 style="margin:0;padding:0">Бренды'.($searchText ? ' по запросу "'.$searchText.'"' :'&nbsp;<small>('.$aa.')</small>').'</h1>';
        }
        ?>
    </div>
    <div class="col-sm-3">
        <button data-popupform="brand-brands" class="btn'.$u.$secondary.'" data-popupform-default-message="Прошу разместить на странице Бренды еще один бренд: ...">Предложить бренд</button>
    </div>
    <div class="col-sm-6 input-group" style="padding-right:55px; padding-left:15px">  
        <form action="<?=Router::convert('?page='.$page)?>" method='post'>
            <input type="hidden" name="block" value="113">
            <input type="hidden" name="highlight" value="1">
            <div class="input-group-btn">
                <input type="text" name="search[1]" class="form-control" value="<?=$searchText?>" placeholder="Поиск бренда по фрагменту названия"<?=($searchText) ? ' style="background-color:#fff4bd"':''?>>        
                <button type="submit" class="btn'.$u.$secondary.'"><span class="glyphicon glyphicon-search"></span></button>
            </div>
        </form>
    </div>
</div>
    

<?php /* Аякс не годится так как работают сразу два блока
    <script>
        var bloxDelay = (function(){
          var timer = 0;
          return function(callback, ms){
            clearTimeout (timer);
            timer = setTimeout(callback, ms);
          };
        })();

        $(function() {
            $('.siteSettings input[name="search"]').keyup(function() {
                var inputVal = $(this);
                $('#table').animate({"opacity":"0.3"});                    
                bloxDelay(
                    function(){
                        $.ajax(
                            type: "POST",
                            url: "?block=<?=$block?>"
                            data: 'name='  + inputVal.val(),
                            )
                            .success(function(response) {
                                $('#table').html(response).animate({"opacity": "1"});
                            });
                    }, 
                    1000 
                );
            });
        });
    </script>
*/
?>