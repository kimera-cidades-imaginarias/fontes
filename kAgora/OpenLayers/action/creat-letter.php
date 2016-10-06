<?php
	include_once('connect.php');

	if($_POST['letter_id'] != '')
	{
		$id = (int) $_POST['letter_id']; 

		foreach($_POST AS $key => $value) { $_POST[$key] = $con->real_escape_string($value); } 
		
		$sql = "UPDATE `letter` SET `from` =  '{$_POST['from']}' , `title` =  '{$_POST['title']}' ,  `letter` =  '{$_POST['letter']}',  `user_id` =  '{$_POST['user_id']}',  `permission` =  '{$_POST['permission']}'   WHERE `id` = '$id' "; 

		if($con->query($sql)){
			echo 'true';
		} else {
			echo 'false';
		}			
	}
	else
	{
		foreach($_POST AS $key => $value) { $_POST[$key] = $con->real_escape_string($value); } 
		
		$sql = "INSERT INTO `letter` ( `from` , `title` ,  `letter`,  `user_id`,  `permission`  ) VALUES(  '{$_POST['from']}' , '{$_POST['title']}' ,  '{$_POST['letter']}' ,  '{$_POST['user_id']}' ,  '{$_POST['permission']}'  ) "; 
		
		if($con->query($sql)){
			echo 'true';
		} else {
			echo 'false';
		}
	}