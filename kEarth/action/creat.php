<?php
	$name = $_REQUEST['name'];
	
	$content =  '<?xml version="1.0" encoding="UTF-8"?>';
	$content .= '<kml xmlns="http://www.opengis.net/kml/2.2">';
		$content .= '<Document>';
			$content .= $_REQUEST['data'];
		$content .= '</Document>';
	$content .= '</kml>';
	
	$fp = fopen("../kml/".$_REQUEST['name'].".kml","w+");
	fwrite($fp,$content);
	fclose($fp);
