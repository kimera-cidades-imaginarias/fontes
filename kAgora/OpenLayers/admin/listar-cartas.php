<?php if(isset($_SESSION["user_id"]) && isset($_SESSION["email"]) && isset($_SESSION["password"])){ ?>

<?php

	echo '<table class="table table-hover">';
		echo "<thead>"; 
			echo "<tr>"; 
				echo "<td><b>N° Controle</b></td>"; 
				echo "<td><b>De</b></td>"; 
				echo "<td></td>";
				echo "<td></td>";
			echo "</tr>";
		echo "</thead>"; 
		
		echo "<tbody>";
		
		if($_SESSION["permission"] == 1 || $_SESSION["permission"] == 2)
		{
			$sql = "SELECT * FROM letter ORDER BY date_time ASC";
		}
		else
		{
			$sql = "SELECT * FROM letter WHERE user_id = ".$_SESSION["user_id"]." ORDER BY date_time ASC";
		}

		$result = $con->query($sql);
			
		while($row = $result->fetch_assoc()) {
			foreach($row AS $key => $value) { $row[$key] = stripslashes($value); } 
			
			echo "<tr>";  
				echo "<td valign='top'>" . nl2br( $row['id']) . "</td>";  
				echo "<td valign='top'>" . nl2br( $row['title']) . "</td>";  
				echo "<td valign='top'><a href=index.php?pagina=editar-carta&id={$row['id']}>Editar</a></td>"; 
				echo "<td valign='top'><a href=index.php?pagina=deletar-carta&id={$row['id']}>Deletar</a></td>";
			echo "</tr>"; 
		} 

		echo "</tbody>"; 
	echo "</table>"; 
?>

<?php } ?>