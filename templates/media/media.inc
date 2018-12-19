<?php                                            
    
    
    
    # Поразумевается, что навигация по каталогу и контент находятся на одной странице
    # Пока сделал так, хотя, если навигация по каталогу и контент находятся на одной странице, можно писать сразу Blox::getPageId(), а в шаблонах просто $page
    $pageId = $GLOBALS['media']['page'] = Blox::getPageId();

    /** Вариант 1 */
    $options = array('page-id' => $pageId, 'ignore-page-id' => true);    
    # Блок со списком категорий фото-видео
    $instancesOfTpl = Blox::getInstancesOfTpl('media/nav', $options);
    $GLOBALS['media/nav']['block'] = $instancesOfTpl[0];
   
    # Блок с фотографиями
    $instancesOfTpl = Blox::getInstancesOfTpl('media/goods', $options);
    $GLOBALS['media/goods']['block'] = $instancesOfTpl[0]; 
    
  

                           

    
