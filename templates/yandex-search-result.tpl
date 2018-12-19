<?php
  /* 
   * Результаты поиска на сайте
   * Просто скопировать сюда код из конструктора яндекса, отметив опцию "Добавить CSS к коду результатов".
   * Настроить цвета 
   * Форма находится здесь: yandex-search-form.inc
   */
?>

<div id="ya-site-results" onclick="return {'tld': 'ru','language': 'ru','encoding': '','htmlcss': '1.x','updatehash': false}"></div><script type="text/javascript">(function(w,d,c){var s=d.createElement('script'),h=d.getElementsByTagName('script')[0];s.type='text/javascript';s.async=true;s.charset='utf-8';s.src=(d.location.protocol==='https:'?'https:':'http:')+'//site.yandex.net/v2.0/js/all.js';h.parentNode.insertBefore(s,h);(w[c]||(w[c]=[])).push(function(){Ya.Site.Results.init();})})(window,document,'yandex_site_callbacks');</script>
<style>
#ya-site-results
{
    color: #000000;
    background: #FFFFFF;
}

#ya-site-results .b-pager__current,
#ya-site-results .b-serp-item__number
{
    color: #000000 !important;
}

#ya-site-results
{
    font-family: Arial !important;
}

#ya-site-results :visited,
#ya-site-results .b-pager :visited,
#ya-site-results .b-foot__link:visited,
#ya-site-results .b-copyright__link:visited
{
    color: #e07e60;
}

#ya-site-results a:link,
#ya-site-results a:active,
#ya-site-results .b-pseudo-link,
#ya-site-results .b-head-tabs__link,
#ya-site-results .b-head-tabs__link:link,
#ya-site-results .b-head-tabs__link:visited,
#ya-site-results .b-dropdown__list .b-pseudo-link,
#ya-site-results .b-dropdowna__switcher .b-pseudo-link,
.b-popupa .b-popupa__content .b-menu__item,
#ya-site-results .b-foot__link:link,
#ya-site-results .b-copyright__link:link,
#ya-site-results .b-serp-item__mime,
#ya-site-results .b-pager :link
{
    color: #f2501e;
}

#ya-site-results :link:hover,
#ya-site-results :visited:hover,
#ya-site-results .b-pseudo-link:hover
{
    color: #f2501e !important;
}

#ya-site-results .l-page,
#ya-site-results .b-bottom-wizard
{
    font-size: 13px;
}

#ya-site-results .b-pager
{
    font-size: 1.25em;
}

#ya-site-results .b-serp-item__text,
#ya-site-results .ad
{
    font-style: normal;
    font-weight: normal;
}

#ya-site-results .b-serp-item__title-link,
#ya-site-results .ad .ad-link
{
    font-style: normal;
    font-weight: normal;
}

#ya-site-results .ad .ad-link a
{
    font-weight: bold;
}

#ya-site-results .b-serp-item__title,
#ya-site-results .ad .ad-link
{
    font-size: 16px;
}

#ya-site-results .b-serp-item__title-link:link,
#ya-site-results .b-serp-item__title-link
{
    font-size: 1em;
}

#ya-site-results .b-serp-item__number
{
    font-size: 13px;
}

#ya-site-results .ad .ad-link a
{
    font-size: 0.88em;
}

#ya-site-results .b-serp-url,
#ya-site-results .b-direct .url,
#ya-site-results .b-direct .url a:link,
#ya-site-results .b-direct .url a:visited
{
    font-size: 13px;
    font-style: normal;
    font-weight: normal;
    color: #f2501e;
}

#ya-site-results .b-serp-item__links-link
{
    font-size: 13px;
    font-style: normal;
    font-weight: normal;
    color: #444444 !important;
}

#ya-site-results .b-pager__inactive,
#ya-site-results .b-serp-item__from,
#ya-site-results .b-direct__head-link,
#ya-site-results .b-image__title,
#ya-site-results .b-video__title
{
    color: #000000 !important;
}

#ya-site-results .b-pager__current,
#ya-site-results .b-pager__select
{
    background: #E0E0E0;
}

#ya-site-results .b-foot,
#ya-site-results .b-line
{
    border-top-color: #E0E0E0;
}

#ya-site-results .b-dropdown__popup .b-dropdown__list,
.b-popupa .b-popupa__content
{
    background-color: #FFFFFF;
}

.b-popupa .b-popupa__tail
{
    border-color: #E0E0E0 transparent;
}

.b-popupa .b-popupa__tail-i
{
    border-color: #FFFFFF transparent;
}

.b-popupa_direction_left.b-popupa_theme_ffffff .b-popupa__tail-i,
.b-popupa_direction_right.b-popupa_theme_ffffff .b-popupa__tail-i
{
    border-color: transparent #FFFFFF;
}

#ya-site-results .b-dropdowna__popup .b-menu_preset_vmenu .b-menu__separator
{
    border-color: #E0E0E0;
}

.b-specification-list,
.b-specification-list .b-pseudo-link,
.b-specification-item__content label,
.b-specification-item__content .b-link,
.b-specification-list .b-specification-list__reset .b-link
{
    color: #000000 !important;
    font-family: Arial;
    font-size: 13px;
    font-style: normal;
    font-weight: normal;
}

.b-specification-item__content .b-calendar__title
{
    font-family: Arial;
    color: #000000;
    font-size: 13px;
    font-style: normal;
    font-weight: normal;
}

.b-specification-item__content .b-calendar-month__day_now_yes
{
    color: #E0E0E0;
}

.b-specification-item__content .b-calendar .b-pseudo-link
{
    color: #000000;
}

.b-specification-item__content
{
    font-family: Arial !important;
    font-size: 13px;
}

.b-specification-item__content :visited
{
    color: #e07e60;
}

.b-specification-item__content .b-pseudo-link:hover,
.b-specification-item__content :visited:hover
{
    color: #f2501e !important;
}

#ya-site-results .b-popupa .b-popupa__tail-i
{
    background: #FFFFFF;
    border-color: #E0E0E0 !important;
}
</style>
