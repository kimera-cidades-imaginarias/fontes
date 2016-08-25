<?php if(isset($_SESSION["user_id"]) && isset($_SESSION["email"]) && isset($_SESSION["password"])){ ?>

<?php

	echo '<table class="table table-hover">';
		echo "<thead>"; 
			echo "<tr>"; 
				echo "<td><b>N° Controle</b></td>"; 
				echo "<td><b>Perfil</b></td>"; 
				echo "<td><b>E-mail</b></td>"; 
				echo "<td></td>";
				echo "<td></td>";
			echo "</tr>";
		echo "</thead>"; 
		
		echo "<tbody>";

		$result = $con->query("SELECT * FROM `user`");
			
		while($row = $result->fetch_assoc()) {
			foreach($row AS $key => $value) { $row[$key] = stripslashes($value); } 
			
			echo "<tr>";  
				echo "<td valign='top'>" . nl2br( $row['id']) . "</td>";  
				echo "<td valign='top'>";
					if($row['permission'] == 0) { echo 'Aluno'; }
					if($row['permission'] == 1) { echo 'Professor'; }
					if($row['permission'] == 2) { echo 'Administrador'; }
				echo "</td>";  
				echo "<td valign='top'>" . nl2br( $row['email']) . "</td>";  
				echo "<td valign='top'><a href=index.php?pagina=editar-usuario&id={$row['id']}>Editar</a></td>"; 
				echo "<td valign='top'><a href=index.php?pagina=deletar-usuario&id={$row['id']}>Deletar</a></td>";
			echo "</tr>"; 
		} 

		echo "</tbody>"; 
	echo "</table>"; 
?>

<?php } ?>