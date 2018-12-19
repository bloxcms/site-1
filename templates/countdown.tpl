<?php
    Blox::addToHead('templates/countdown/timeTo.css');
    Blox::addToHead('templates/countdown/timeTo.config.css');
    Blox::addToFoot('templates/countdown/jquery.timeTo.js');//['after'=>'templates/jquery...']
    Blox::addToHead('templates/countdown/countdown.css');
echo'
<div class="countdown">';
    if ($dat[2] || $dat[3]) {
        if ($dat[2])
            echo'<div class="countdown-text-2">'.$dat[2].'<span class="countdown-date">'.date('d.m.Y H:i', strtotime($dat[1])).'</span></div>';
        if ($dat[3])
            echo '<div class="countdown-text-3">'.$dat[3].'</div>';
    }
    echo'
    <div id="countdown-'.$block.'"></div>
    '.pp($dat['edit']).'
</div>';
Blox::addToFoot('
<script>
    $("#countdown-'.$block.'").timeTo({
        timeTo: new Date("'.$dat[1].'"),
        displayDays: 2,   
        displayCaptions: true,
        captionSize: 16,
        lang: "ru",
        fontFamily: "Roboto",
        fontSize: 33
    });
</script>');