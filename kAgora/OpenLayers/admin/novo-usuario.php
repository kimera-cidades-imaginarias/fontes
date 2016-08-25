<?php if(isset($_SESSION["user_id"]) && isset($_SESSION["email"]) && isset($_SESSION["password"])){ ?>

<?php 
	if (isset($_POST['submitted'])) { 
		foreach($_POST AS $key => $value) { $_POST[$key] = $con->real_escape_string($value); } 
		
		$sql = "INSERT INTO `user` ( `email` ,  `password`,  `permission`  ) VALUES(  '{$_POST['email']}' ,  '{$_POST['password']}' ,  '{$_POST['permission']}'  ) "; 
		
		if($con->query($sql)){
			echo '<script type="text/javascript"> window.location = "index.php?pagina=listar-usuarios&status=sucesso" </script>';
		} else {
			echo '<script type="text/javascript"> window.location = "index.php?pagina=listar-usuarios&status=erro" </script>';
		}
	} 
?>

<form action='' method='POST'> 
	<p><b>Email:</b><br /><input type='text' name='email' class="input-xxlarge" /> </p>
	<p><b>Senha:</b><br /><input type='password' name='password'/> </p>
	<p><b>Perfil:</b><br />
		<select name="permission">
			<option value="0">Aluno</option>
			<option value="1">Professor</option>
			<option value="2">Administrador</option>
		</select>
	</p>
	
	<div class="form-actions">
		<input type='submit' value='Salvar cadastro' class="btn btn-primary" />

		<input type='hidden' value='1' name='submitted' />
	</div>
</form> 

<?php } ?>