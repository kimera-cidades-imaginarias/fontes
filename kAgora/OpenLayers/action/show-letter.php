<?php 
    include_once('connect.php');

    $id = $_REQUEST['id'];

    $add = '';

    if(isset($id))
    {
        $add .= ' id =' . $id;
    }

	$sql = "SELECT * FROM letter WHERE " . $add . " LIMIT 1";
   
    $json_str = '{"letter":[';

	$result = $con->query($sql); 
	if ($result->num_rows > 0) {
		while($row = $result->fetch_assoc()) {
            $json_str .='{"id":"'.$row["id"].'", "title":"'.$row["title"].'", "letter": "'.$row["letter"].'", "permission": "'.$row["permission"].'",  "user_id": "'.$row["user_id"].'", "from": "'.$row["from"].'"}';
		} 
	}

    $json_str .= ']}';

    echo  $json_str;
?>

