<?php
/**
 * @origin oknadiev ---eskulap  ---волгопром.рф
 * Переименовано из u-testimonials-v2
 */  
 
if ($xdat[6])
    Blox::addToHead(Blox::info('templates','url').'/u-testimonials-v1/u-testimonials-v1.css');
     
?>
<style>   
#block-<?=$block?>.testimonials.testimonials-v1 .carousel-arrow {top:-30px}
#block-<?=$block?> .testimonials-headline {position:relative; top:-5px; font-size:20px; padding:0px; margin:0px 0px 0px 13px}
</style>
<div id="block-<?=$block?>" class="carousel slide testimonials testimonials-v1 <?=['светлый'=>'','темный'=>'testimonials-bg-dark','цветной'=>'testimonials-bg-default',][$xdat[5]]?>">
    <div class="testimonials-headline">
        <?=$xdat[1] ?: '&nbsp;'?>
    </div>
    <?php 
    if ($xdat[2] && $xdat[3]) { ?>
	<div style="position:absolute; top:-7px; right:<?=$tab[1] ? 48 : 0 ?>px">
		<a class="btn btn-link" href="<?=$xdat[2]?>" title=""><?=$xdat[3]?></a>
	</div>
    <?php 
    }   
    if ($tab[1]) { ?>
	<div class="carousel-arrow">
		<a class="left carousel-control" href="#block-<?=$block?>" data-slide="prev">
			<i class="fa fa-angle-left<?=($xdat[4] ? ' rounded-x' : '')?>"></i>
		</a>
		<a class="right carousel-control" href="#block-<?=$block?>" data-slide="next">
			<i class="fa fa-angle-right<?=($xdat[4] ? ' rounded-x' : '')?>"></i>
		</a>
	</div>
    <?php } ?>    
	<div class="carousel-inner">
        <?php foreach ($tab as $i=>$dat) { ?>
		<div class="item<?=($i) ? '' : ' active'?>">
			<p<?=($xdat[4] ? ' class="rounded-3x"' : '')?>><?=$dat[1]?></p>
			<div class="testimonial-info">
                <?php if ($dat[4])
                    echo'<img class="rounded-x" src="datafiles/testimonials/'.$dat[4].'" alt="">';
                ?>
				<span class="testimonial-author">
					<?=$dat[2]?>
					<em><?=$dat[3]?></em>
				</span>
			</div>
		</div>
        <?php } ?>
	</div>
    <?=pp($edit['button'])?>
</div>