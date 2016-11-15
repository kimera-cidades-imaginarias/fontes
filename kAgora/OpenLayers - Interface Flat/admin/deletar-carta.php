<?php @session_start(); ?>

<?php if(isset($_SESSION["user_id"]) && isset($_SESSION["email"]) && isset($_SESSION["password"])){ ?>

<?php
	$id = (int) $_GET['id']; 
	$sql = "DELETE FROM `letter` WHERE `id` = '$id' ";

	if($con->query($sql)){
		echo '<script type="text/javascript"> window.location = "index.php?pagina=listar-cartas&status=sucesso" </script>';
	} else {
		echo '<script type="text/javascript"> window.location = "index.php?pagina=listar-cartas&status=erro" </script>';
	}
?>

<?php } ?>