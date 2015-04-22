<?php if(isset($_SESSION['gerenciador']['autenticado']) && $_SESSION['gerenciador']['autenticado'] == true){ ?>

<?php 

	if (isset($_GET['id']) ) { 
		$id = (int) $_GET['id']; 
		
		if (isset($_POST['submitted'])) { 
			foreach($_POST AS $key => $value) { $_POST[$key] = mysql_real_escape_string($value); } 
			
			$sql = "UPDATE `paginas` SET  `titulo` =  '{$_POST['titulo']}' ,  `descricao` =  '{$_POST['descricao']}'   WHERE `id` = '$id' "; 
			
			if(mysql_query($sql) or die(mysql_error())){
				echo '<script type="text/javascript"> window.location = "index.php?pagina=listar-paginas&status=sucesso" </script>';
			} else {
				echo '<script type="text/javascript"> window.location = "index.php?pagina=listar-paginas&status=erro" </script>';
			}			
		} 

		$row = mysql_fetch_array ( mysql_query("SELECT * FROM `paginas` WHERE `id` = '$id' ")); 
?>

<form action='' method='POST'> 
	<p><b>T&iacutetulo:</b><br /><input type='text' name='titulo' value='<?php echo stripslashes($row['titulo']) ?>' class="input-xxlarge" /> </p>
	<p><b>Descri&ccedil;&atilde;o:</b><br /><textarea type='text' name='descricao'  class="input-xxlarge"><?php echo stripslashes($row['descricao']) ?></textarea></p>
	
	<div class="form-actions">
		<input type='submit' value='Salvar cadastro' class="btn btn-primary" />

		<input type='hidden' value='1' name='submitted' />
	</div>
</form> 

<?php } ?> 

<?php } ?>