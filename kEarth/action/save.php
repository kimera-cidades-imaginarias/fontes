<?php
	if($_FILES['arquivo']['error'] > 0) die('Error ' . $_FILES['file']['error']);
	if(empty($_FILES['arquivo']['name'])) die('No file sent.');

	$file = $_FILES['arquivo']['name'];
	$tmp = $_FILES['arquivo']['tmp_name'];

	if(is_uploaded_file($tmp))
	{
	    if(!move_uploaded_file($tmp, '../kml/' . $file)) echo 'error !';
	}
	else echo 'Upload failed !';
