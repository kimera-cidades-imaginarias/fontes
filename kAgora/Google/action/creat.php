<?php
	$name = $_REQUEST['name'];
	$cidade = $_REQUEST['cidade'];
	
	$content =  '<?xml version="1.0" encoding="UTF-8"?>';
	$content .= '<kml xmlns="http://www.opengis.net/kml/2.2">';
			$content .= '<cidade>' . $cidade . '</cidade>';
			$content .= $_REQUEST['data'];
	$content .= '</kml>';

	// Preparar objeto DOM
	$dom = new DOMDocument();
	$dom->formatOutput = true;
	$dom->preserveWhiteSpace = false;

	// Carregar o XML ou HTML
	$dom->loadXML($content);
	$newContent = $dom->saveXML();

	//echo $newContent;
	//die();
	
	$fp = fopen("../kml/". $_REQUEST['name'] . ".kml","w+");
	
	fwrite($fp,$newContent);
	fclose($fp);
