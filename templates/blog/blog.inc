<?php    
     
    # Идентификатор комплекта блоков с шаблонами blog/*
    if ('blog/nav' == $blockInfo['tpl']) {
        $navSrcBlockId = $blockInfo['src-block-id'];
        $navRegularId = $blockInfo['id']; # For Search
        if ($xdat[8])  # tpl
            $complexId = $xdat[8];
        else
            ; # Пока не надо
    } elseif ('blog/goods' == $blockInfo['tpl']) {
        $goodsSrcBlockId = $blockInfo['src-block-id'];
        if ($xdat[6])  # tpl
            $complexId = $xdat[6];
        else # tdd
            ;//$complexId = Dat::get($blockInfo, [], 'x')[6]; # Пока не надо
    }
    
    
        
    if (!$GLOBALS['blog/nav'][$complexId]) {
        # Определяем $navSrcBlockId если inc был вызван не из blog/nav
        if (!$navSrcBlockId) {
    		$sql = 'SELECT `block-id` FROM '.Blox::getTbl('blog/nav','x').' WHERE dat8=? LIMIT 2';
            if ($aa = Sql::select($sql, [$complexId],'', false)) {
                if ($aa[1])
                    Blox::prompt('Найдено два блока с шаблоном blog/nav и идентификатором комплекта '.$complexId.'. Переименуйте идентификатор комплекта у одного из блоков blog/nav!',true);
                $navSrcBlockId = $aa[0]['block-id'];
            } else
                Blox::prompt('Не найдено блока с шаблоном blog/nav и идентификатором комплекта '.$complexId, true);
        }
        $GLOBALS['blog/nav'][$complexId]['src-block-id'] = $navSrcBlockId;
        $GLOBALS['blog/nav'][$complexId]['regularId'] = $navRegularId;# For Search
    }
    
    if (!$GLOBALS['blog/goods'][$complexId]) {
        # Определяем $goodsSrcBlockId и $goodsSrcPageId  если inc был вызван не из blog/goods
        # Считаем , что исходный _goods назначается на основной странице данного комплекта 
        if (!$goodsSrcBlockId) {
    		$sql = 'SELECT `block-id` FROM '.Blox::getTbl('blog/goods','x').' WHERE dat6=? LIMIT 2';
            if ($aa = Sql::select($sql, [$complexId],'', false)) {
                if ($aa[1])
                    Blox::prompt('Найдено два блока с шаблоном blog/goods и одинаковыми идентификаторами комплектов "'.$complexId.'". Переименуйте идентификатор комплекта у одного из блоков!',true);
                $goodsSrcBlockId = $aa[0]['block-id'];
            } else
                Blox::prompt('Не найдено блока с шаблоном blog/goods и идентификатором комплекта "'.$complexId.'"', true);
        }
        $GLOBALS['blog/goods'][$complexId]['src-block-id'] = $goodsSrcBlockId;
        $GLOBALS['blog/goods'][$complexId]['srcPageId'] = Blox::getBlockPageId($goodsSrcBlockId); # TODO Это можно не вычислять, если бы не было делирования вложенных блоков

    }    
