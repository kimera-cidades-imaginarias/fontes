<?php @session_start(); ?>

<?php include_once('../action/connect.php'); ?>

<?php if(isset($_SESSION["user_id"]) && isset($_SESSION["email"]) && isset($_SESSION["password"])){ ?>

<?php 

	if (isset($_POST['submitted'])) { 
		$id = (int) $_REQUEST['id']; 

		foreach($_POST AS $key => $value) { $_POST[$key] = $con->real_escape_string($value); } 
		
		$sql = "UPDATE `letter` SET `from` =  '{$_POST['from']}' , `title` =  '{$_POST['title']}' ,  `letter` =  '{$_POST['letter']}',  `user_id` =  '{$_POST['user_id']}',  `permission` =  '{$_POST['permission']}'   WHERE `id` = '$id' "; 

		if($con->query($sql)){
			echo '<script type="text/javascript"> window.location = "index.php?pagina=listar-cartas&status=sucesso" </script>';

			die();
		} else {
			echo '<script type="text/javascript"> window.location = "index.php?pagina=listar-cartas&status=erro" </script>';

			die();
		}			
	} 

	if (isset($_REQUEST['id']) ) { 
		$id = (int) $_REQUEST['id']; 
		
		$result = $con->query("SELECT * FROM `letter` WHERE `id` = '$id' ");
		$row = $result->fetch_assoc();
?>

<form action='editar-carta.php?id=<?php echo $id; ?>' method='POST' id="editar-carta"> 
	<p><b>De:</b><br /><input type='text' name='from'  value='<?php echo stripslashes($row['from']) ?>' readonly="readonly" /> </p>
	<p><b>Assunto:</b><br /><input type='text' name='title'  value='<?php echo stripslashes($row['title']) ?>' /> </p>
	<p><b>Carta:</b><br /><textarea rows="10" name="letter" class="btn-large btn-block"><?php echo stripslashes($row['letter']) ?></textarea> </p>

	<input type="hidden" name="user_id" value='<?php echo stripslashes($row['user_id']) ?>' />
    <input type="hidden" name="permission" value='<?php echo stripslashes($row['permission']) ?>' />
	
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
	  	$('#btCartas').tab('show');
	  })

	  var frm = $('#editar-carta');
	    frm.submit(function (ev) 
	    {
	        $.ajax({
	            type: frm.attr('method'),
	            url: frm.attr('action'),
	            data: frm.serialize(),
	            
	            success: function (data) 
	            {
	            	$('body').html(data);
	               //window.location = "index.php?pagina=listar-cartas&status=sucesso";
	            }
	        });

	        ev.preventDefault();
	    });
	</script>