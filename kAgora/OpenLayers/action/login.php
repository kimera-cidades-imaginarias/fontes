<?php
	include_once('connect.php');

	$result = $con->query("SELECT * FROM `user` WHERE email = '" . $_POST['email'] . "' AND password = '" . $_POST['password'] . "'");
	$num_rows = mysqli_num_rows($result);

	if($num_rows > 0)
	{
		@session_start();

		$row = $result->fetch_assoc();
		
		$_SESSION["user_id"] = $row["id"];
		$_SESSION["email"] = $row["email"];
		$_SESSION["permission"] = $row["permission"];
		$_SESSION["password"] = $row["password"];

		echo 'true';
	}
	else
	{
		echo 'false';
	}
