<?php if(isset($_SESSION['gerenciador']['autenticado']) && $_SESSION['gerenciador']['autenticado'] == true){ ?>

<?php 
	if (isset($_POST['submitted'])) { 
		foreach($_POST AS $key => $value) { $_POST[$key] = mysql_real_escape_string($value); } 
		
		$sql = "INSERT INTO `usuarios` ( `nome` ,  `email` ,  `senha`  ) VALUES(  '{$_POST['nome']}' ,  '{$_POST['email']}' ,  '{$_POST['senha']}'  ) "; 
		
		if(mysql_query($sql) or die(mysql_error())){
			echo '<script type="text/javascript"> window.location = "index.php?pagina=listar-usuarios&status=sucesso" </script>';
		} else {
			echo '<script type="text/javascript"> window.location = "index.php?pagina=listar-usuarios&status=erro" </script>';
		}
	} 
?>

<form action='' method='POST'> 
	<p><b>Nome:</b><br /><input type='text' name='nome' class="input-xxlarge" /> </p>
	<p><b>Email:</b><br /><input type='text' name='email' class="input-xxlarge" /> </p>
	<p><b>Senha:</b><br /><input type='password' name='senha'/> </p>
	
	<div class="form-actions">
		<input type='submit' value='Salvar cadastro' class="btn btn-primary" />

		<input type='hidden' value='1' name='submitted' />
	</div>
</form> 

<?php } ?>