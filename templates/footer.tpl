<div class="footer sticky-footer">
    <footer>
        <div class="container">
            <div class="row row-conformity row-center">
                <div class="col-xs-12">
                    <?=$dat[1]?>
                </div>
                <?php /*
                <div class="col-xs-12 col-sm-8 col-md-8 col-lg-8">
                    <?=$dat[1]?>
                </div>
                <div class="col-xs-12 col-sm-4 col-md-4 col-lg-4">
                    <div>
                    <h4>Задать вопрос</h4>
                    <?=$dat[4]?>
                    </div>
                </div>
                */?>
            </div>
        </div>
        <div class="copyright">
            <div class="container">
                <div class="row">
                    <div class="col-xs-8 col-sm-10 col-md-10 col-lg-11">
                        &copy; <?='2005'.('2005' != date('Y') ? '–'.date('Y') : '')?> <?=$dat[2]?>
                    </div>
                    <div class="col-xs-4 col-sm-2 col-md-2 col-lg-1">
                        <a href="" title="Разработка сайтов и продвижение сайтов" target="_blank" style="display:inline-block;opacity:0.6;width:88px;margin:6px;">Веб-студия</a>
                    </div>
                </div>
            </div>
        </div>
        <?= pp($edit['button']) ?>
    </footer>
</div>

<?php 
/*
Отключить режим sticky-footer можно и из самого шаблона добавив в него код: <code>$GLOBALS[\'footer\'][\'not-sticky\'] = true;</code>
if (!$GLOBALS['footer']['not-sticky'] || ...)
*/
if (!in_array($page, array_map('trim', explode(',',$dat[3])))) { 
    # sticky-footer - forcing footer to bottom of page, if document height is smaller than window height
    Blox::addToFoot('
        <script>
            $(window).on("load resize scroll ajaxComplete", function() {
                var f = $(".sticky-footer");
                f.css({position:"static"});
        		if ((f.offset().top + f.height()) < $(window).height())
        			f.css({position:"fixed", bottom:"0", width:"100%"});
        	})
        </script>',
        'minimize'
    );
} 