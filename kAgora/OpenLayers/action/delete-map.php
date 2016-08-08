<?php
	$name = $_REQUEST['name'];
	
	chmod('../kml/' . $name, 0777);
	unlink('../kml/' . $name);