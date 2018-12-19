// Conformity - equal height elements based on row rather than set
// .row.row-conformity
$(document).ready(function () {
    $('row-conformity > [class*=col-]').conformity();
    $(window).on('resize load', function() {
        $('.row-conformity > [class*=col-]').conformity();
    });
    // Bug fix for scroll. When you use: $(window).on(scroll) and metisMenu in one page, window begins to scroll smoothly up.
    $('body,html').on('wheel DOMMouseScroll mousewheel keyup', function(e){
        if ( e.which > 0 || e.type == "mousedown" || e.type == "mousewheel"){
            $('.row-conformity > [class*=col-]').conformity();
        }
    });
});
