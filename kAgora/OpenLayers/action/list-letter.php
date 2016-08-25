<?php 
    include_once('connect.php');

    $user_id = $_REQUEST['user_id'];

    $add = '';

    if(isset($user_id))
    {
        $add .= ' user_id =' . $user_id;
    }

	$sql = "SELECT * FROM letter WHERE " . $add . " OR permission = 1 ORDER BY date_time ASC";

	$result = $con->query($sql); 
	if ($result->num_rows > 0) {
		while($row = $result->fetch_assoc()) {
            echo '<li><a href="javascript:showMyLetter('.$row["id"].')">Carta de '.$row["title"].'</a></li>';
		} 
	}
?>

