<!-- yandexSearch -->
<?php 
/** 
 * Поисковая форма Яндекса
 * Подключение: <?php include'templates/yandex-search-form.inc' ?>
 * Сначала необходимо создать и настроить яндекс поиск https://site.yandex.ru
 * Код формы не использовать, а взять из него только searchid. Не применять Router::convert(), так как в режиме редактора появляется параметр page, который при отправке формы замещается яндексовскими параметрами.
 * Код результата поиска поместить в шаблон yandex-search-result и назначить его на отдельной странице. URL взять параметрический: ?page=22.
 */

# Настройки
$searchid = 2335254;
###############################################################
    
$searchPageId = Blox::getBlockPageId(Blox::getInstancesOfTpl('yandex-search-result')[0]); 
if ($page == $searchPageId) { 
    $searchValue = $_GET['text'];
    $searchStyle = ' style="background:#faffbd"';
}
?>
<form action="?page=<?=$searchPageId?>" method="get" target="_self" accept-charset="utf-8">
    <input type="hidden" name="page" value="<?=$searchPageId?>" /> <!--!!!-->
    <input type="hidden" name="searchid" value="<?=$searchid?>" />
    <input type="hidden" name="l10n" value="ru" />
    <input type="hidden" name="reqenc" value="" />
    <div class="input-group" style="margin:0px 0 0px 0">
    	<input type="text" name="text" class="form-control" value="<?=$searchValue?>"<?=$searchStyle?> placeholder="Искать на сайте">
    	<span class="input-group-btn">
    		<button class="btn btn-default" type="submit"><i class="fa fa-search"></i></button>
    	</span>
    </div>
</form>
<!-- /yandexSearch -->