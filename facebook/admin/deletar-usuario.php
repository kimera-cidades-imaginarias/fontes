<?php if(isset($_SESSION['gerenciador']['autenticado']) && $_SESSION['gerenciador']['autenticado'] == true){ ?>

<?php

	$id = (int) $_GET['id']; 
	$sql = "DELETE FROM `usuarios` WHERE `id` = '$id' ";

	if(mysql_query($sql) or die(mysql_error())){
		echo '<script type="text/javascript"> window.location = "index.php?pagina=listar-usuarios&status=sucesso" </script>';
	} else {
		echo '<script type="text/javascript"> window.location = "index.php?pagina=listar-usuarios&status=erro" </script>';
	}
?>

<?php } ?>