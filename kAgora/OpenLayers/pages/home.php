<?php
	@session_start("kimera");

	if(isset($_SESSION["user_id"]) && isset($_SESSION["email"]) && isset($_SESSION["password"]))
	{
		$page = 'letter.php';
	}
	else
	{
		$page = 'login.php';
	}

	include_once($page);
