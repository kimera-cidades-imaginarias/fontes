<?php
	include_once('connect.php');

	$data = json_encode($_POST);
	$array = json_decode($data);

	$add = "";

	foreach($array as $key => $value)
	{	
		$add .= " " . $key . " = '" . $value ."' ";

		if ($value !== end($array))
		{
			$add .= "AND";
		}
	}

	$sql = "SELECT * FROM user WHERE " . $add;

	//echo $sql;
	$result = $con->query($sql);

	if ($result && $result->num_rows > 0) 
	{
		@session_start("kimera");

		while($row = $result->fetch_assoc()) {
			$_SESSION["user_id"] = $row["id"];
			$_SESSION["email"] = $row["email"];
			$_SESSION["permission"] = $row["permission"];
			$_SESSION["password"] = $row["password"];
		}

		echo 'true';
	}
	else
	{
		echo 'false';
	}
