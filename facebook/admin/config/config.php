<?php
	// connect to db
	/*
	$link = mysql_connect('mysql01.kimera4.hospedagemdesites.ws', 'kimera4', 'mudar123');
	
	if (!$link) {
	    die('Not connected : ' . mysql_error());
	}

	if (! mysql_select_db('kimera4') ) {
	    die ('Can\'t use foo : ' . mysql_error());
	}
	*/
	
	$link = mysql_connect('localhost', 'root', '');
	
	if (!$link) {
	    die('Not connected : ' . mysql_error());
	}

	if (! mysql_select_db('kimera') ) {
	    die ('Can\'t use foo : ' . mysql_error());
	}
	