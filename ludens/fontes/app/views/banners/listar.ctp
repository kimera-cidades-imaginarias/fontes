<?php

    echo '[';
    $i = 0;
    foreach( $banners as $banner )
    {
        if ($i > 0) echo ',';
        echo '{ "texto" : "' . $banner['Banner']['texto'] . '",' .
             ' "arquivo" : "/ludens/' . $banner['Banner']['arquivo'] . '",' .
             ' "link" : "' . $banner['Banner']['link'] . '",' .
             ' "tempo" : "' . $banner['Banner']['tempo'] . '" }';
        $i++;
    }
    echo ']';
?>
