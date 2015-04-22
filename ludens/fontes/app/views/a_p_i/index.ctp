<?php
    /*
    echo '{';
    $count = 0;
    foreach($params as $name => $value)
    {
        echo ($count == 0 ? '' : ', ') . '"' . $name . '":"' . $value . '"';
        $count++;
    }
    echo '}';
    */
    echo json_encode($params);
?>