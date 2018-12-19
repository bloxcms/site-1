/*
 * Fullscreen window opener for pdf and other files
 * @example <button data-window-url="datafiles/logo.pdf" data-window-name="block-99">Enlarge</button>
 * [data-window-name] is not obligatory. It is one window usage for all clicks of a block
 */
$(function() {
    $('[data-window-url]').on('click', function() {
        window.open(
            $(this).data('window-url'),
            $(this).data('window-name') || 'window-name',
            'top=20, left=20, width=' + (screen.width - 40) + ', height=' + (screen.height - 140)
        );
    });
});
//fullscreen=yes,resizable=yes,scrollbars=yes,location=no
//newwin=window.open(); if (window.focus) {newwin.focus()}