<?php
	$content = $_REQUEST['content'];
	$action = $_REQUEST['action'];
	$file = $_REQUEST['file'];

	if($action == 'new')
	{
		$fp = fopen("../letters/".$file.".txt","w") or die("No file!");
		fwrite($fp,$content);
		fclose($fp);
	}
	
	if($action == 'empty')
	{
		$fp = fopen("../letters/".$file.".txt", "r+");
		ftruncate($fp, 0);
		fclose($fp);
	}

	if($action == 'edit')
	{
		$fp = fopen("../letters/".$file.".txt","w") or die("No file!");
		fwrite($fp,$content);
		fclose($fp);
	}