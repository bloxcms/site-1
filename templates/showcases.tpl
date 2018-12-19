<?php

echo'
<div class="showcases">';
    foreach ($tab as $dat) {
        if ($dat[6])
            echo'<h2>'.$dat[6].'</h2>';
        echo'
        <div class="row" style="position:relative">
            <div class="col-md-5">';
                if ($dat[1]) {
                    $img = '<img src="datafiles/'.$dat[1].'" alt="'.$dat[2].'" class="img-responsive" />';
                    if(empty($dat[5]))
                        echo $img;
                    else
                        echo'<a href="'.$dat[5].'" title="'.$dat[2].'">'.$img.'</a>';
                }
                echo'
            </div>
            <div class="col-md-7" style="margin:0">
                <div class="row row-conformity">
                    <div class="col-md-7 text-center">
                        <img src="datafiles/'.$dat[3].'" alt="'.$dat[2].'" class="img-responsive" style="margin-left: auto; margin-right: auto" />
                    </div>
                    <div class="col-md-5 text-center">';
                        if ($dat[4])
                            echo'<span class="showcases-price">от <b>'.Str::formatNumber($dat[4], ['decimals'=>0, 'mark'=>',', 'separator'=>'&nbsp;'], '.').'</b> <i class="fa fa-ruble"></i></span>';
                        if ($dat[5])
                            echo' <a href="'.$dat[5].'" class="btn btn-primary">Цены и комплектация</a>';
                        echo'
                    </div>';
                    $tfield = 11;
                    $ifield = 12;
                    for ($i=1; $i<=6; $i++) {
                        if (!$dat[$ifield])
                            continue;
                        echo'
                        <div class="col-xs-6 col-sm-4">
                            <img src="datafiles/'.$dat[$ifield].'" alt="'.$dat[$tfield].'" class="img-responsive" />
                        </div>';
                        $tfield += 2;
                        $ifield += 2;
                    }
                    echo'
                </div>
            </div>
            '.pp($dat['edit']).'
        </div>';
    }
    echo'
</div>';