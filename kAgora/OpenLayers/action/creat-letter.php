<?php
	include_once('connect.php');

	if (isset($_POST["id"])) 
	{
		$data = json_encode($_POST);
		$array = json_decode($data);

		$sql = "UPDATE letter SET";

		$i=1;
		$total = 0;
		$id=null;

		foreach($array as $key => $value)
		{	
			$total++;
		}

		foreach($array as $key => $value)
		{	
			if ($key != 'id')
			{
				$sql .= " ".$key."='".$value."'";

				$i++;

				if($i < $total)
				{
					$sql .= ',';
				}
			}
			else
			{
				$id = $value;
			}
		}
		$sql .= ' WHERE id='.$id;

		echo $sql;
		$con->query($sql);
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

		$sql = "INSERT INTO letter (".$keys.") VALUES (".$values.")";
		
		echo $sql;
		$con->query($sql);
	}