/**
 * jQuery for page scrolling feature - requires jQuery Easing plugin
 * @example
 *     <a class="easy-scroll" href="#anchor">...</a>
 *     <script src="jquery.easing.min.js"></script>
 *     <script src="easy-scroll.js"></script>
 */
$(function() {
    $('.easy-scroll a, a.easy-scroll').on('click', function(event) {
        var $anchor = $(this);
        $('html, body').stop().animate({
            scrollTop: $($anchor.attr('href')).offset().top
        }, 1500, 'easeInOutExpo');
        event.preventDefault();
    });
});
