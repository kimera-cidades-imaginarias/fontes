<?php
@session_start();
?>

<?php include_once('../action/connect.php'); ?>

<?php if(isset($_SESSION["user_id"]) && isset($_SESSION["email"]) && isset($_SESSION["password"])){ ?>

<?php 
	if (isset($_POST['submitted'])) { 
		foreach($_POST AS $key => $value) { $_POST[$key] = $con->real_escape_string($value); } 
		
		$sql = "INSERT INTO `letter` ( `title` ,  `letter`,  `user_id`,  `permission`  ) VALUES(  '{$_POST['title']}' ,  '{$_POST['letter']}' ,  '{$_POST['user_id']}' ,  '{$_POST['permission']}'  ) "; 
		
		if($con->query($sql)){
			echo '<script type="text/javascript"> window.location = "index.php?pagina=listar-cartas&status=sucesso" </script>';
		} else {
			echo '<script type="text/javascript"> window.location = "index.php?pagina=listar-cartas&status=erro" </script>';
		}
	} 
?>

<form action='nova-carta.php' method='POST' id="nova-carta"> 
	<p><b>De:</b><br /><input type='text' name='title' /> </p>
	<p><b>Carta:</b><br /><textarea rows="10" name="letter" class="btn-large btn-block"></textarea> </p>

	<input type="hidden" name="user_id" value="<?php echo $_SESSION["user_id"]; ?>" />
    <input type="hidden" name="permission" value="<?php echo $_SESSION["permission"]; ?>" />
	
	<div class="form-actions">
		<input type='submit' value='Salvar cadastro' class="btn btn-primary" />
		<input type='hidden' value='1' name='submitted' />
	</div>
</form> 

<?php } ?>

<!-- tabs -->
	<script type="text/javascript">
	  $(function () {
	  	$('#btCartas').tab('show');
	  })

	   var frm = $('#nova-carta');
	    frm.submit(function (ev) {
	        $.ajax({
	            type: frm.attr('method'),
	            url: frm.attr('action'),
	            data: frm.serialize(),
	            
	            success: function (data) {
	                window.location = "index.php?pagina=listar-cartas&status=sucesso";
	            }
	        });

	        ev.preventDefault();
	    });
	</script>