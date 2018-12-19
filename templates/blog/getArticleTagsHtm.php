<?php

function getArticleTagsHtm($tagsList, $blogPage=null)//Аргументы: (id статьи из blog/nav)
{
	if ($tagsList)	{
        if ($tags = explode(',', $tagsList)) {
            $htm = '';
            $uniques = [];
            foreach($tags as $tg) {
                $tg = trim($tg);
                if (!$uniques[$tg]) {
                    $uniques[$tg] = true;
			        $htm .= ', <a href="?page='.($blogPage ?: Blox::getPageId()).'&tag='.urlencode($tg).'">'.$tg.'</a>';
                }
            }
            return '<li><span class="glyphicon glyphicon-tags small"></span>'.substr($htm, 1).'</li>';
        }
    }
}
