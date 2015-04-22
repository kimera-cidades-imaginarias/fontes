<?php if(isset($_SESSION['gerenciador']['autenticado']) && $_SESSION['gerenciador']['autenticado'] == true){ ?>

<?php

	$id = (int) $_GET['id']; 
	$sql = "DELETE FROM `pecas` WHERE `id` = '$id' ";

	if(mysql_query($sql) or die(mysql_error())){
		echo '<script type="text/javascript"> window.location = "index.php?pagina=listar-pecas&status=sucesso" </script>';
	} else {
		echo '<script type="text/javascript"> window.location = "index.php?pagina=listar-pecas&status=erro" </script>';
	}
?>

<?php } ?>