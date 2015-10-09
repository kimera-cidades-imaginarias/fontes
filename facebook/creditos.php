<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" lang="pt-BR" xml:lang="pt-BR">

	<?php
		//error_reporting(E_ALL);
  		//ini_set("display_errors", 1);
	?>
	
	<?php include('admin/config/config.php'); ?>
	<?php $result = mysql_query("SELECT * FROM `paginas` WHERE id=1") or trigger_error(mysql_error());  ?>

	<head profile="http://gmpg.org/xfn/11">
            
        <!-- META -->
		<!-- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx -->
            <meta http-equiv="content-type" content="text/html; charset=UTF-8" />
            <meta http-equiv="content-language" content="pt, pt-br" />

        <!-- TITLE -->
		<!-- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx -->
	    	<title>Kimera - Cidades Imaginárias | Jogo da Memoria</title>

	    <!-- CSS -->
		<!-- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx -->
			<link href="css/bootstrap.min.css" rel="stylesheet" media="screen">
			<link href="css/game.css" rel="stylesheet" media="screen">

		<!-- JS -->
		<!-- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx -->
			<script src="js/jquery-latest.js"></script>
    		<script src="js/bootstrap.min.js"></script>
	</head>
  	
  	<body>
  			<h1>Kimera - Cidades Imaginárias | Jogo da Memoria</h1>
  			<p class="desc">Kimera - Cidades Imaginárias é um jogo de simulação de cidades em que o jogador executa a construção de uma cidade, considerando ainda a execução de quests que trabalham elementos humano-criativos de cada jogador e convidam o mesmo ao exercício da imaginação.</p>

  			<div id="window">
  				<div id="dinamicPage">
					<?php $row = mysql_fetch_array($result); ?>

					<h2><span><?php echo $row['titulo']; ?></span></h2>
					<p><?php echo nl2br($row['descricao']); ?></p>

					<a href="index.php" class="bt-voltar">Voltar</a>
				</div>
			</div>

			<ul id="apoiadores">
				<li>Governo Bahia</li>
				<li>Geotec</li>
				<li>UNEB</li>
			</ul>
  	</body>

</html>