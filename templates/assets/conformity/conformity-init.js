// Conformity - equal height elements based on row rather than set
//DEPRECATED
$(document).ready(function () {
    $('.conformity').conformity();
    $(window).on('resize scroll', function() {
        $('.conformity').conformity();        
    });
});


