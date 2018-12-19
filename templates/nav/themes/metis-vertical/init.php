<?php

# TODO  Добавить проверку 'levelsScheme' => 'SSS', то есть все уровни открыты
Blox::addToHead('templates/nav/onokumus/metismenu/dist/metisMenu.min.css');    
Blox::addToFoot('templates/nav/onokumus/metismenu/dist/metisMenu.min.js');
Blox::addToFoot('<script>$(function(){$("#block-'.$block.' .metismenu").metisMenu({preventDefault: false})})</script>');
//Blox::addToFoot('<script>$(function() {$("#block-'.$block.' .metismenu").metisMenu()})</script>');
Blox::addToHead('templates/nav/themes/metis-vertical/nav.css');

return []; # Для $themeFeatures. пока не используется