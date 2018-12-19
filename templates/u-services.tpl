<?php 
    #ORIGIN eskul   ---avtograd    ---Волгопром
?>

<style>
    .service {padding: 15px 0px 25px 5px;}
    .service .service-icon {padding: 10px 0px 10px 10px;}
</style>

<?php
$colsClass = $xdat[2] ?: 'col-md-4';
Blox::addToFoot(Blox::info('templates','url').'/assets/conformity/conformity.js');
Blox::addToFoot(Blox::info('templates','url').'/assets/conformity/row-conformity.js', ['after'=>'conformity/conformity.js']);
Blox::addToHead(Blox::info('templates','url').'/assets/conformity/row-conformity.css');
Blox::addToFoot('<script>$(window).load(function(){$(".u-services .service > .fa, .u-services .service > .glyphicon").addClass("service-icon")})</script>');

echo'
<div class="u-services" style="position:relative;">';
    echo $xdat[1];
    echo'
	<div class="row row-conformity'.($xdat[3] ? ' row-center':'').'">';            
        foreach ($tab as $dat) {                                       
            echo'
        	<div class="'.$colsClass.'">
        		<div class="service">';                
                    if ($dat[3]) 
                        echo $dat[3];//'<i class="fa '.$dat[3].' service-icon"></i>';
                    echo'
        			<div class="desc">';
        				if ($dat[1]) echo'<h4>'.$dat[1].'</h4>';
                        if ($dat[2]) echo $dat[2];                                
        			echo'
            		</div>';
                    echo'            
        		</div>
        	</div>';                    
        }                    
        echo'
	</div>';
    echo pp($edit['button'],-30,0);
    echo'
</div>';
