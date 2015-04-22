<?php if(isset($_SESSION['gerenciador']['autenticado']) && $_SESSION['gerenciador']['autenticado'] == true){ ?>

<?php

	echo '<table class="table table-hover">';
		echo "<thead>"; 
			echo "<tr>"; 
				echo "<td><b>N° Controle</b></td>"; 
				echo "<td><b>Título</b></td>"; 
				echo "<td></td>";
				echo "<td></td>";
			echo "</tr>";
		echo "</thead>"; 
		
		echo "<tbody>";
		$result = mysql_query("SELECT * FROM `pecas`") or trigger_error(mysql_error()); 
		
		while($row = mysql_fetch_array($result)){ 
			foreach($row AS $key => $value) { $row[$key] = stripslashes($value); } 
			
			echo "<tr>";  
				echo "<td valign='top'>" . nl2br( $row['id']) . "</td>";  
				echo "<td valign='top'>" . nl2br( $row['titulo']) . "</td>";  
				echo "<td valign='top'><a href=index.php?pagina=editar-peca&id={$row['id']}>Editar</a></td>"; 
				echo "<td valign='top'><a href=index.php?pagina=deletar-peca&id={$row['id']}>Deletar</a></td>";
			echo "</tr>"; 
		} 

		echo "</tbody>"; 
	echo "</table>"; 
?>

<?php } ?>