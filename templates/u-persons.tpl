<?php 
/**
 *
 * @origin avtograd
 */

Blox::addToFoot(Blox::info('templates','url').'/assets/conformity/conformity.js');
Blox::addToFoot(Blox::info('templates','url').'/assets/conformity/row-conformity.js', ['after'=>'conformity/conformity.js']);
Blox::addToHead(Blox::info('templates','url').'/assets/conformity/row-conformity.css');

qq($tab);
if ($tab || $edit) {
    if ($xdat[4]) # Заголовок
        echo $xdat[4];
    echo'
    <div class="u-persons row row-conformity'.($xdat[2] ? ' row-center' : '').'">';
        foreach ($tab as $dat) {
            echo'
    		<div class="'.$xdat[1].'">
    			<div class="team-v2">';
                    if (!$xdat[3]) {
                        echo ($dat[1])
                            ? '<img class="img-responsive" src="datafiles/u-persons/'.$dat[1].'" alt="'.Text::stripTags($dat[2],'strip-quotes').'">'
                            : '<svg version="1.1" id="Layer_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" viewBox="0 0 441 441" enable-background="new 0 0 441 441" xml:space="preserve"><rect x="0.5" y="0.5" fill="none" width="440" height="440"/></svg>'
                        ;
                    }
                    echo'
    				<div class="inner-team">';
                        if ($dat[2])
                            echo '<h4>'.$dat[2].'</h4>';
    					if ($dat[3])
                            echo '<div class="inner-team-2">'.$dat[3].'</div>';
                        if ($dat[4])
    					    echo '<div class="inner-team-3">'.$dat[4].'</div>';
                        /*
                        <style>.team-social li a {padding: 6px 6px;}</style>
    					<hr>
    					<ul class="list-inline team-social">
    						<li><a data-placement="top" data-toggle="tooltip" class="fb tooltips" data-original-title="Facebook" href="#"><i class="fa fa-facebook"></i></a></li>
    						<li><a data-placement="top" data-toggle="tooltip" class="tw tooltips" data-original-title="Twitter" href="#"><i class="fa fa-twitter"></i></a></li>
    						<li><a data-placement="top" data-toggle="tooltip" class="gp tooltips" data-original-title="Google plus" href="#"><i class="fa fa-google-plus"></i></a></li>
    					</ul>
                        */
                        echo'
    				</div>
    			</div>
                '.pp($dat['edit']).'
    		</div>';
        } 
        echo'
        <div style="position:absolute; bottom:0px; right:0px">'.$edit['new-rec']['button'].'</div>
    </div>';
}

