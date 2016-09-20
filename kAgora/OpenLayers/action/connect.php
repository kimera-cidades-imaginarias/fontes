<?php
	$con = mysqli_connect("localhost","root","","kimera");
	//$con = mysqli_connect("db_kagora.mysql.dbaas.com.br","db_kagora","A123!@#","db_kagora");

	if (mysqli_connect_errno())
	{
		echo "Failed to connect to MySQL: " . mysqli_connect_error();

		die();
	}