<?php if(isset($_SESSION['gerenciador']['autenticado']) && $_SESSION['gerenciador']['autenticado'] == true){ ?>

<?php 

	if (isset($_GET['id']) ) { 
		$id = (int) $_GET['id']; 
		
		if (isset($_POST['submitted'])) { 
			foreach($_POST AS $key => $value) { $_POST[$key] = mysql_real_escape_string($value); } 
			
			$sql = "UPDATE `usuarios` SET  `nome` =  '{$_POST['nome']}' ,  `email` =  '{$_POST['email']}' ,  `senha` =  '{$_POST['senha']}'   WHERE `id` = '$id' "; 
			
			if(mysql_query($sql) or die(mysql_error())){
				echo '<script type="text/javascript"> window.location = "index.php?pagina=listar-usuarios&status=sucesso" </script>';
			} else {
				echo '<script type="text/javascript"> window.location = "index.php?pagina=listar-usuarios&status=erro" </script>';
			}			
		} 

		$row = mysql_fetch_array ( mysql_query("SELECT * FROM `usuarios` WHERE `id` = '$id' ")); 
?>

<form action='' method='POST'> 
	<p><b>Nome:</b><br /><input type='text' name='nome' value='<?php echo stripslashes($row['nome']) ?>' class="input-xxlarge" /> </p>
	<p><b>Email:</b><br /><input type='text' name='email' value='<?php echo stripslashes($row['email']) ?>' class="input-xxlarge" /> </p>
	<p><b>Senha:</b><br /><input type='password' name='senha' value='<?php echo  stripslashes($row['senha']) ?>' /> </p>
	
	<div class="form-actions">
		<input type='submit' value='Salvar cadastro' class="btn btn-primary" />

		<input type='hidden' value='1' name='submitted' />
	</div>
</form> 

<?php } ?> 

<?php } ?>