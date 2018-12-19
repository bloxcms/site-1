/**
 * Всплывающее окно с вставкой содержимого произвольного блока
 * Вызов метода
 *     @example $.fpopup('?block=15')    // Если нет опций, можно писать строку
 *     @example $.fpopup({url:'?block=15', size:'lg', selectors:{'параметр':'селектор', ...}})
 * Можно вызывать кнопкой
 *     @example <button data-ff-popups-url="?block=22&single=1" data-popup-selectors="{'ff-form':{'data':{'product' : 'h1' , 'description' : '.shop .description'}}}">Заказать</button>
 */
;(function($) {
    // Declare $.fpopup()
    $.fpopup = function(opts) {
        // Modal reload protection on event other than regular closing
        if ($('#ff-popups-box.in').length) // Modal is popupped
            return;
        //
        var contentUrl = '';
        if (typeof opts == 'string')
            contentUrl = opts;
        else
            contentUrl = opts.url;
        
        /* TODO    
        if (typeof contentUrl === 'undefined') return;
        */
        if (null == contentUrl)
            contentUrl = ''
            
        var modalSize = '';
        if (opts.size)
            modalSize = opts.size;
        //
        if (opts.selectors) {
            var xquery = '';
            var selectors2 = {};
            if (typeof opts.selectors == 'object')
                selectors2 = opts.selectors;
            else if (typeof opts.selectors == 'string') {
                selectors2 = JSON.parse(opts.selectors.replace(/'/g, '"')); // convert json string to object
            }  
            function substituteSelectors(obj) {
                $s = obj.data; //NOTTESTED
                for (var k in $s) {
                    if (typeof $s[k] == 'object' && $s[k] !== null)
                        substituteSelectors($s[k]);
                    else
                        $s[k] = $($s[k]).html(); // Заменить селектор на содержимое элемента
                }
            }
            substituteSelectors(selectors2);
            xquery += '&' + $.param(selectors2); // append params
                
            // Append xquery to URL
            if (xquery) {
                if (!contentUrl || contentUrl.indexOf('?')===-1) // No '?' // @todo consider hashes - location.hash;
                    contentUrl += xquery.replace('&','?');
                else
                    contentUrl += xquery;
            }
        }
        // Append html code to bottom of body
        if (!$('#ff-popups-box').length) {
            $('body').append('<div class="modal fade" id="ff-popups-box" tabindex="-1" role="dialog"><div class="modal-dialog"></div></div>');
        }

        $.ajax({
            url: contentUrl,
            success: function(data) {
                $('#ff-popups-box .modal-dialog').html(data); // Заполняем модальное окно содержимым
                // Размер модального окна
                if (!modalSize) {
                    $('#ff-popups-box .modal-dialog').removeClass('modal-sm modal-lg');
                    modalSize = $('#ff-popups-box .modal-content').data('modal-dialog-size'); 

                }

                if (modalSize)
                    $('#ff-popups-box .modal-dialog').addClass('modal-' + modalSize);
                
                /* Закругления в шапке модалки сделать такими же, как в самой модалке. TODO: Сделать радиус меньше на 1-2 px */
                var modalcontent = $('#ff-popups-box .modal-content');
                $('#ff-popups-box .modal-header').css({
                    'border-top-left-radius'  : modalcontent.css('border-top-left-radius'),
                    'border-top-right-radius' : modalcontent.css('border-top-right-radius')
                }); 
            }
        });
        // Modal
        $('#ff-popups-box').modal();
    };
    
    // Click on button
    $('body').on('click', '[data-ff-popups-url]', function(e) {
        e.preventDefault();
        $(this).attr('data-target', '#ff-popups-box');
        var contentUrl = $(this).data('ff-popups-url');
        if (null == contentUrl)
            contentUrl = ''
        var xquery = '';
        // data-ff-popups-name - Передача данных формы 
        var form = $(this).closest("form");
        var inputs = form.find('[data-ff-popups-name]');
        if (inputs) {
            inputs.each(function() {
                xquery += '&' + $(this).data('ff-popups-name') + '=' + encodeURIComponent($(this).val());
            });
        }
        // Append xquery to URL
        if (xquery) {
            if (contentUrl.indexOf('?')===-1) // No '?' // @todo consider hashes - location.hash;
                contentUrl += xquery.replace('&','?');
            else
                contentUrl += xquery;
        }
        // Передача содержимого html-элементов с помощью селекторов
        var selectors = $(this).data('ff-popups-selectors');
        var size = $(this).data('ff-popups-size');
        $.fpopup({'url':contentUrl, 'selectors':selectors, 'size':size});
    });
}(jQuery));



