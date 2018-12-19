/**
 * Запуск всплывающих окон в ответ на различные события
 * Идентификатором события служит url всплываающего окна.
 * @see ff/popups/trigger.md
 *
 * @todo Для событий click и других ввести опцию selector, указывающиую на элемент
 *
 * @todo For IE9+ replace "new Date().getTime()" by "Date.now()". It is faster (https://stackoverflow.com/questions/15401211/date-vs-date-gettime).  
 *     "new Date().getTime()" is equal to "Number(new Date()) and is equal to "+new Date". (http://stackoverflow.com/questions/221539/what-does-the-plus-sign-do-in-new-date) 
 *
 * Cancel execution while delay 
 *     if (events[i]=='...') {
 *         ...
 *         clearTimeout(delaytimers[opts.url]);
 *     }
 */
;(function($) {
    var delaytimers = {};
    /* Проверяем события, неотработанные на своих страницах. Across page long time delay */
    var longTimeEvents = {};
    $(document).on('ready', function() { /* TODO Добавить все события, например: load scroll */
        longTimeEvents = JSON.parse(localStorage.getItem('ff-popups-trigger-long-time-events') || '{}'); 
        var passedSeconds, currTime;
        for (var k in longTimeEvents) {
            currTime = new Date().getTime();
            if ((currTime - longTimeEvents[k]['time']) > longTimeEvents[k]['opts']['delay']*1000)
                fpopup(longTimeEvents[k]['opts']);
        }
    });
        /* Declare $.popupTrigger() */
    $.popupTrigger = function(opts) {
        /* Defaults */
        if (typeof opts.url === 'undefined') 
            return;
        if (typeof opts.event === 'undefined') 
            return;
        if (typeof opts.delay === 'undefined') 
            opts.delay = 0;
        if (typeof opts.offdays === 'undefined') 
            opts.offdays = 0;
        if (!opts.url || !opts.event) 
            return;
        
        /* Event handlers by type of event */
        var events = opts.event.split(' ');
        for (var i = 0; i < events.length; ++i) {
            /*load*/
            if (events[i]=='load') { /* load */
                $(window).on('load', function() {
                    execute(opts);
                });
            } 
            /*scroll*/
            else if (events[i]=='scroll') {
                var scrollsCounter=0;
                var prevScrollTimeStamp;
                $(window).on('scroll', function(e) {
                    if (e.timeStamp) {
                        /* Событие scroll происходит на все что попало (load, click), поэтому отбираем только быструю последовательность 5 скролей. Так и бывает даже при одном щелчке колесика мыши. On pagedown key press there are 6 scroll events  */
                        if (prevScrollTimeStamp) {
                            if (e.timeStamp - prevScrollTimeStamp < 1000) //ms
                                scrollsCounter++;
                            else
                                scrollsCounter = 0;
                        }
                        prevScrollTimeStamp = e.timeStamp;
                        if (scrollsCounter >= 5) {
                            execute(opts);
                            scrollsCounter = 0;
                        }
                    } else { /* Firefox bug since 2004 - timeStamp is 0 every time */
                        execute(opts); 
                    }
                });
            } 
            /*mouseleave*/
            else if (events[i]=='mouseleave') { /* mouseleave */
                $(window).on('load', function() {
                    $('body').on('mouseleave', function(e) {
                        if (e.clientY < 0)//	the mouse has crossed top of the window
                            execute(opts);
                    });
                    if (opts.delay) { /* Cancel execution while delay */
                        $('body').on('mouseenter', function(e) {
                            clearTimeout(delaytimers[opts.url]);
                        });
                    }
                });
            }
        }
        

        function execute(opts) {
            if ($('#ff-popups-box.in').length) // Modal is already popupped
                return;
            var currTime = new Date().getTime();
            /* Was this popup shown recently? */
            var go = true;
            if (opts.offdays) {
                var popupTime = parseInt(localStorage.getItem('ff-popups-trigger-popup-time' + opts.url));
                if (popupTime && (currTime - popupTime) < opts.offdays*1000*3600*24)
                    go = false;
            }
            /* direct execution */
            if (go) {

                if (opts.delay) {
                    if (longTimeEvents[opts.url]) { /* Неотрабатанное событие. Если событие не отработано, не обновлять данные о нем  */
                        if ((currTime - longTimeEvents[opts.url]['time']) > opts.delay*1000)
                            fpopup(opts);
                    } else {
                        longTimeEvents[opts.url] = {time:currTime, opts:opts}; /* В следующей строчке всплывашка может не успеть, поэтому сохраним событие */
                        localStorage.setItem('ff-popups-trigger-long-time-events', JSON.stringify(longTimeEvents));
                        delaytimers[opts.url] = setTimeout(function(){fpopup(opts)}, opts.delay * 1000); /* timeout on the same page */
                    }
                } else 
                    fpopup(opts);
            }
        }
    };
    
    function fpopup(opts) {
        $.fpopup({url:opts.url, size:opts.event});
        if (opts.offdays)
            localStorage.setItem('ff-popups-trigger-popup-time' + opts.url, new Date().getTime());
        if (opts.delay) {
            delete longTimeEvents[opts.url];
            localStorage.setItem('ff-popups-trigger-long-time-events', JSON.stringify(longTimeEvents));
        }
    }
}(jQuery));