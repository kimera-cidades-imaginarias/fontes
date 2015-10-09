<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" lang="pt-BR" xml:lang="pt-BR">
	
	<?php include('admin/config/config.php'); ?>
	<?php $result = mysql_query("SELECT * FROM `pecas` WHERE publicado=1 LIMIT 24") or trigger_error(mysql_error());  ?>

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
			<link href="css/bootstrap.min.css" rel="stylesheet" media="screen" />
			<link href="css/game.css" rel="stylesheet" media="screen" />
			<link href="plugins/shadowbox-3.0.3/shadowbox.css" rel="stylesheet" media="screen" />

		<!-- JS -->
		<!-- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx -->
			<script src="js/jquery-latest.js"></script>
    		<script src="js/bootstrap.min.js"></script>
    		<script src="plugins/shadowbox-3.0.3/shadowbox.js"></script>
    		<script src="js/game.js"></script>
    		<script>
    			$(document).ready(function() {
					$("img").hide();
					$("div.alert").hide();

					$("#boxcard div").click(openCard);

					definirPecas(<?php echo mysql_num_rows($result); ?>);
					shuffle();
					openCard();
				});

				Shadowbox.init({
				    overlayColor: "#2D568A"
				});
    		</script>

    	<!-- PHP CONFIG -->
    	<!-- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx -->
    	 <?php

    	 	//error_reporting(E_ALL);
 			//ini_set("display_errors", 1);

    	 	session_start();

			require_once('facebook-php-sdk-v4-5.0-dev/src/Facebook/autoload.php');

			$fb = new Facebook\Facebook([
			  'app_id' => '649094798460813',
			  'app_secret' => '3fed1ccadef808154d441d4c13055af0',
			  'default_graph_version' => 'v2.4',
			]);
		?>
	</head>
  	
  	<body>

  			<h1>Kimera - Cidades Imaginárias | Jogo da Memoria</h1>
  			<p class="desc">Kimera - Cidades Imaginárias é um jogo de simulação de cidades em que o jogador executa a construção de uma cidade, considerando ainda a execução de quests que trabalham elementos humano-criativos de cada jogador e convidam o mesmo ao exercício da imaginação.</p>

  			<div id="window">

			<?php if(isset($_SESSION['facebook_access_token'])){ ?>

				<div class="alert alert-error">
					Figuras não coincidem!
				</div>

				<div id="boxcard">
	        	<?php 
	        		$count = 1;

	        		while($row = mysql_fetch_array($result)){ 
	        	?>
		            <div id="card<?php echo $count++; ?>"><a href="uploads/g_<?php echo $row['imagem01']; ?>" rel="shadowbox"><img src="uploads/<?php echo $row['imagem01']; ?>" alt="<?php echo $row['titulo']; ?>" /></a></div>
		            <div id="card<?php echo $count++; ?>"><a href="uploads/g_<?php echo $row['imagem02']; ?>" rel="shadowbox"><img src="uploads/<?php echo $row['imagem02']; ?>" alt="<?php echo $row['titulo']; ?>" /></a></div>
	            <?php 
	        		} 
	        	?>
		        </div>

		    <?php } ?>

		    <?php if(!isset($_SESSION['facebook_access_token'])){ ?>

				<?php
					$helper = $fb->getRedirectLoginHelper();
					$permissions = ['email'];
					$loginUrl = $helper->getLoginUrl('https://kimera4.websiteseguro.com/facebook/login-callback.php', $permissions);
				?>
				
				<h2>Prove que você tem boa memória, para entrar nessa nova aventura no <span>REINO DE KIMERA!</span></h2>

				<a href="<?php echo $loginUrl; ?>" class="bt-facebook">Login</a>
				<a href="creditos.php" class="bt-creditos">Créditos</a>

			<?php } ?>

			</div>

			<ul id="apoiadores">
				<li>Governo Bahia</li>
				<li>Geotec</li>
				<li>UNEB</li>
			</ul>
  	</body>

</html>