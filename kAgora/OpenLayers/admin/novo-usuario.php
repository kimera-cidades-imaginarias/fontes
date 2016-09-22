<?php
@session_start();
?>

<?php include_once('../action/connect.php'); ?>


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

<form action='novo-usuario.php' method='POST' id="novo-usuario"> 
	<p><b>Usuário:</b><br /><input type='text' name='email' placeholder="Exemplo: nome.sobreno" /> </p>
	<p><b>Senha:</b><br /><input type='password' name='password' placeholder="*****" /> </p>
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

<!-- tabs -->
	<script type="text/javascript">
	  $(function () {
	  	$('#btUsuarios').tab('show');
	  })

	  var frm = $('#novo-usuario');
	    frm.submit(function (ev) {
	        $.ajax({
	            type: frm.attr('method'),
	            url: frm.attr('action'),
	            data: frm.serialize(),
	            
	            success: function (data) {
	                window.location = "index.php?pagina=listar-usuarios&status=sucesso";
	            }
	        });

	        ev.preventDefault();
	    });
	</script>