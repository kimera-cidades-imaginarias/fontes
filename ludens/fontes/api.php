<?php
/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
    $action = $_POST['action'];

    if ($action != 'login') session_id($_POST['id']);
    session_start();
    
    if ($action == 'login')
    {
        $_SESSION["user_id"] = 'Arivan';
        EchoOutput(array('id' => session_id(), 'error' =>'0'));
    }
    else if ($action == 'whoami')
    {
        if (isset($_SESSION["user_id"])) EchoOutput(array('user_id' => $_SESSION["user_id"], 'error' =>'0'));
        else EchoOutput(array('user_id' => '', 'error' =>'1'));
    }

//------------------------------------------------------------------------

    function EchoOutput( $data )
    {
        $r = "{";
        foreach ($data as $attribute => $value)
        {
            $r .= ($r != '{' ? ',': '') . '"' . $attribute . '":"' . $value .'"';
        }
        $r.= '}';
        echo $r;
    }

?>
