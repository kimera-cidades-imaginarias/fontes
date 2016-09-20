<?php
@session_start();
?>

<?php include_once('../action/connect.php'); ?>

<?php if(isset($_SESSION["user_id"]) && isset($_SESSION["email"]) && isset($_SESSION["password"])){ ?>

<?php 

	if (isset($_POST['submitted'])) { 
		$id = (int) $_REQUEST['id']; 

		foreach($_POST AS $key => $value) { $_POST[$key] = $con->real_escape_string($value); } 
		
		$sql = "UPDATE `user` SET `email` =  '{$_POST['email']}' ,  `password` =  '{$_POST['password']}',  `permission` =  '{$_POST['permission']}'   WHERE `id` = '$id' "; 

		if($con->query($sql)){
			echo '<script type="text/javascript"> window.location = "index.php?pagina=listar-usuarios&status=sucesso" </script>';
		} else {
			echo '<script type="text/javascript"> window.location = "index.php?pagina=listar-usuarios&status=erro" </script>';
		}			
	} 


	if (isset($_REQUEST['id']) ) { 
		$id = (int) $_REQUEST['id']; 
		
		$result = $con->query("SELECT * FROM `user` WHERE `id` = '$id' ");
		$row = $result->fetch_assoc();
?>

<form action='editar-usuario.php?id=<?php echo $id; ?>' method='POST' id="editar-usuario"> 
	<div <?php if($_SESSION["permission"] != 2){ ?>class="hide"<?php } ?> >
		<p><b>Usuário:</b><br /><input type='text' name='email' value='<?php echo stripslashes($row['email']) ?>'  /> </p>
	</div>

	<div>
		<p><b>Senha:</b><br /><input type='password' name='password' value='<?php echo  stripslashes($row['password']) ?>' /> </p>
	</div>

	<div <?php if($_SESSION["permission"] != 2){ ?>class="hide"<?php } ?> >
	<p><b>Perfil:</b><br />
		<select name="permission">
			<option value="0" <?php if($row['permission'] == 0){ echo 'selected'; } ?> >Aluno</option>
			<option value="1" <?php if($row['permission'] == 1){ echo 'selected'; } ?> >Professor</option>
			<option value="2" <?php if($row['permission'] == 2){ echo 'selected'; } ?> >Administrador</option>
		</select>
	</p>
	</div>
	
	<div class="form-actions">
		<input type='submit' value='Salvar cadastro' class="btn btn-primary" />

		<input type='hidden' value='1' name='submitted' />
	</div>
</form> 

<?php } ?> 

<?php } ?>

<!-- tabs -->
	<script type="text/javascript">
	  $(function () {
	  	$('#btUsuarios').tab('show');
	  })

	  var frm = $('#editar-usuario');
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