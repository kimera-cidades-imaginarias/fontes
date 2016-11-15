<?php 
    include_once('connect.php');

    @$user_id = $_REQUEST['user_id'];

    $add = '';

    if(isset($user_id))
    {
        $add .= ' user_id =' . $user_id;
    }
    else
    {
        $add .= 'permission = 1 OR permission = 2';
    }

	$sql = "SELECT * FROM letter WHERE " . $add . " ORDER BY date_time ASC";

	$result = $con->query($sql); 
	if ($result->num_rows > 0) {
		while($row = $result->fetch_assoc()) {
            echo '<li><a href="'.$row["id"].'">Carta de '.$row["from"].': '.$row["title"].'</a></li>';
		} 
	}
?>

