<?php
	$file = $_REQUEST['file'];

	if( filesize("../letters/".$file.".txt") > 0 )
	{
		$fh = fopen("../letters/".$file.".txt",'r');

		while ($line = fgets($fh)) {
		  echo($line);
		}

		fclose($fh);
	}
