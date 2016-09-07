<?php if(isset($_SESSION["user_id"]) && isset($_SESSION["email"]) && isset($_SESSION["password"])){ ?>

<form class="form-search" action="index.php?pagina=listar-cartas" method="POST">
	<div id="dtBox"></div>
  	<input type="text" class="input-medium search-query" data-field="date" placeholder="Selecionar Data" name="date_time">
  	<button type="submit" class="btn">Busca</button>
</form>

<?php
	echo '<table class="table table-hover">';
		echo "<thead>"; 
			echo "<tr>"; 
				echo "<td><b>N° Controle</b></td>"; 
				echo "<td><b>De</b></td>"; 
				echo "<td><b>Data / Hora</b></td>";
				echo "<td></td>";
				echo "<td></td>";
			echo "</tr>";
		echo "</thead>"; 
		
		echo "<tbody>";

		$sql = "SELECT * FROM letter";
		
		if($_SESSION["permission"] == 1 || $_SESSION["permission"] == 2)
		{
			if(isset($_REQUEST['date_time']) && $_REQUEST['date_time'] != '')
			{
				$sql .= " WHERE date_time between '".$_REQUEST['date_time']." 00:00:00' and '".$_REQUEST['date_time']." 23:59:59' ";
			}

			$sql .= " ORDER BY date_time ASC";
		}
		else
		{
			$sql .= " WHERE user_id = ".$_SESSION["user_id"]."";

			if(isset($_REQUEST['date_time']) && $_REQUEST['date_time'] != '')
			{
				$sql .= " AND date_time between '".$_REQUEST['date_time']." 00:00:00' and '".$_REQUEST['date_time']." 23:59:59' ";
			}

			$sql .= " ORDER BY date_time ASC";
		}

		//echo $sql;

		$result = $con->query($sql);
			
		while($row = $result->fetch_assoc()) {
			foreach($row AS $key => $value) { $row[$key] = stripslashes($value); } 
			
			echo "<tr>";  
				echo "<td valign='top'>" . nl2br( $row['id']) . "</td>";  
				echo "<td valign='top'>" . nl2br( $row['title']) . "</td>";
				echo "<td valign='top'>" . nl2br( $row['date_time']) . "</td>";  
				echo "<td valign='top'><a href=index.php?pagina=editar-carta&id={$row['id']}>Editar</a></td>"; 
				echo "<td valign='top'><a href=index.php?pagina=deletar-carta&id={$row['id']}>Deletar</a></td>";
			echo "</tr>"; 
		} 

		echo "</tbody>"; 
	echo "</table>"; 
?>

<?php } ?>

<!-- calendar -->
<script type="text/javascript">
$(document).ready(function() 
	{
		var bIsPopup = displayPopup();
	
		$("#dtBox").DateTimePicker(
		{
			isPopup: bIsPopup,
			dateFormat: "yyyy-MM-dd",
			shortDayNames: ["Dom", "Seg", "Ter", "Qua", "Qui", "Sex", "Sab"],
			fullDayNames: ["Domingo", "Segunda", "Terça", "Quarta", "Quinta", "Sexta", "Sabado"],
			shortMonthNames: ["Jan", "Fev", "Mar", "Abr", "Mai", "Jun", "Jul", "Ago", "Set", "Out", "Nov", "Dez"],
			fullMonthNames: ["Janeiro", "Fevereiro", "Março", "Abril", "Maio", "Junho", "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro"],
			titleContentDate: "",
			setButtonContent: "Selecionar",
			clearButtonContent: "Limpar",
		
			addEventHandlers: function()
			{
				var dtPickerObj = this;
			
				$(window).resize(function()
				{
					bIsPopup = displayPopup();
					dtPickerObj.setIsPopup(bIsPopup);
				});
			}
		});
	});

	function displayPopup()
	{
		if($(document).width() >= 768)
			return false;
		else
			return true;
	}
</script>

<!-- tabs -->
	<script type="text/javascript">
	  $(function () {
	  	$('#btCartas').tab('show');
	  })
	</script>