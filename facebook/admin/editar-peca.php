<?php if(isset($_SESSION['gerenciador']['autenticado']) && $_SESSION['gerenciador']['autenticado'] == true){ ?>

<?php

	if (isset($_GET['id']) ) { 
		$id = (int) $_GET['id']; 

		if (isset($_POST['submitted'])) { 
			foreach($_POST AS $key => $value) { $_POST[$key] = mysql_real_escape_string($value); } 

			if($_FILES['imagem01']['name'] != '' && $_FILES['imagem02']['name'] != ''){
				
				require('classes/wideimage/WideImage.php');

				$watermark = WideImage::load('../img/bt-ampliar.png');

				$nomeImgTemp01 = $_FILES['imagem01']['name'];
				$extencaoTempImg01 = explode('.', $nomeImgTemp01);

				$extencao01 = strtolower($extencaoTempImg01[1]);
				$nomeFoto01 = md5($extencaoTempImg01[0].time());

				$imagem01 = $nomeFoto01.'.'.$extencao01;

				$newfile01 = '../uploads/'.$imagem01;
				move_uploaded_file($_FILES['imagem01']['tmp_name'],$newfile01);

				$original01 = WideImage::load($newfile01);
				$new01 = $original01->resize(200,200,'outside')
						->crop(0,0,200,200)
						->merge($watermark,'right','bottom',100)
						->saveToFile('../uploads/'.$imagem01);

				$new02 = $original01->resize(600,600,'outside')
					->crop(0,0,600,600)
					->saveToFile('../uploads/g_'.$imagem01);

				// --------------------------------------------- //

				$nomeImgTemp02 = $_FILES['imagem02']['name'] ;
				$extencaoTempImg02 = explode('.', $nomeImgTemp02);

				$extencao02 = strtolower($extencaoTempImg02[1]);
				$nomeFoto02 = md5($extencaoTempImg02[0].time());

				$imagem02 = $nomeFoto02.'.'.$extencao02;
				
				$newfile02 = '../uploads/'.$imagem02;
				move_uploaded_file($_FILES['imagem02']['tmp_name'],$newfile02);

				$original02 = WideImage::load($newfile02);
				$new01 = $original02->resize(200,200,'outside')
						->crop(0,0,200,200)
						->merge($watermark,'right','bottom',100)
						->saveToFile('../uploads/'.$imagem02);

				$new02 = $original02->resize(600,600,'outside')
					->crop(0,0,600,600)
					->saveToFile('../uploads/g_'.$imagem02);

				$sqlIMg = " ,  `imagem01` =  '{$imagem01}' ,  `imagem02` =  '{$imagem02}' ";					
			} else {
				$sqlIMg = '';
			}
			
			$sql = "UPDATE `pecas` SET  `titulo` =  '{$_POST['titulo']}' , `publicado` =  '{$_POST['publicado']}' ".$sqlIMg." WHERE `id` = '$id' "; 
			
			if(mysql_query($sql) or die(mysql_error())){
				echo '<script type="text/javascript"> window.location = "index.php?pagina=listar-pecas&status=sucesso" </script>';
			} else {
				echo '<script type="text/javascript"> window.location = "index.php?pagina=listar-pecas&status=erro" </script>';
			}
		} 

		$row = mysql_fetch_array ( mysql_query("SELECT * FROM `pecas` WHERE `id` = '$id' ")); 
?>

<form action='' method='POST' enctype="multipart/form-data"> 
	<p><b>Titulo:</b><br /><input type='text' name='titulo' value='<?php echo stripslashes($row['titulo']) ?>' /> </p>
	<p><b>Imagem01:</b> (<?php echo stripslashes($row['imagem01']) ?>) <br /><input type='file' name='imagem01' id="imagem01" /> </p>
	<p><b>Imagem02:</b> (<?php echo stripslashes($row['imagem02']) ?>) <br /><input type='file' name='imagem02' id="imagem02" /> </p>
	<p><input type="checkbox" name="publicado" value="1" <?php if($row['publicado'] == 1){ echo 'checked'; } ?> ><b> Publicado</b></p>
	
	<div class="form-actions">
		<input type='submit' value='Salvar cadastro' class="btn btn-primary" />

		<input type='hidden' value='1' name='submitted' />
	</div>
</form> 

<?php } ?> 

<?php } ?>