<?php
	include_once('connect.php');

	if (isset($_POST["id"])) 
	{
		$data = json_encode($_POST);
		$array = json_decode($data);

		$sql = "UPDATE user SET";

		foreach($array as $key => $value)
		{	
			$sql .= " ".$key."='".$value."'";

			if ($value !== end($array))
			{
				$sql .= ",";
			}
			else
			{
				$sql .= " WHERE ".$key."=".$value;
			}
		}

		//echo $sql;
		if ($con->query($sql))
		{
			echo 'true';
		}
		else
		{
			echo 'false';
		}
	}
	else
	{
		$data = json_encode($_POST);
		$array = json_decode($data);

		$keys = "";
		$values = "";

		foreach($array as $key => $value)
		{	
			$keys .= " " . $key . "";
			$values .= " '" . $value . "'";

			if ($value !== end($array))
			{
				$keys .= ",";
				$values .= ",";
			}
		}

		$sql = "INSERT INTO user (".$keys.") VALUES (".$values.")";
		
		//echo $sql;
		if ($con->query($sql))
		{
			echo 'true';
		}
		else
		{
			echo 'false';
		}
	}