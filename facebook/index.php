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
			require_once('php-sdk/facebook.php');

			$config = array(
				'appId' => '649094798460813',
				'secret' => '3fed1ccadef808154d441d4c13055af0',
				'allowSignedRequest' => false
			);

			$facebook = new Facebook($config);
		?>
	</head>
  	
  	<body>
  			<h1>Kimera - Cidades Imaginárias | Jogo da Memoria</h1>
  			<p class="desc">Kimera - Cidades Imaginárias é um jogo de simulação de cidades em que o jogador executa a construção de uma cidade, considerando ainda a execução de quests que trabalham elementos humano-criativos de cada jogador e convidam o mesmo ao exercício da imaginação.</p>

  			<div id="window">
				<?php
					$user_id = $facebook->getUser();

					if( $user_id )
					//if( 1==1 )
					{
						//bloco de autenticacao
						try
						{
							//$user_profile = $facebook->api('/me','GET');
							//echo "Bem-vindo: " . $user_profile['name'];
				?>

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

				<?php
							//bloco de publicacao
							try
							{
								$ret_obj = $facebook->api('/me/feed', 'POST',
									array(
										'link' => 'www.kimera.pro.br',
										'message' => 'Estou jogando Kimera - Cidades Imáginárias, venha você também conhecer esse novo mundo!'
									));
							} 
							catch(FacebookApiException $e) 
							{
								//$login_url = $facebook->getLoginUrl( array('scope' => 'publish_stream')); 
								//echo 'Por-favor, efetue seu <a href="' . $login_url . '">login.</a>';
								
								error_log($e->getType());
								error_log($e->getMessage());
							}
						} 
						catch(FacebookApiException $e)
						{
							//$login_url = $facebook->getLoginUrl(); 
							//echo 'Por-favor, efetue seu <a href="' . $login_url . '">login.</a>';
							
							error_log($e->getType());
							error_log($e->getMessage());
						}
					} 
					else 
					{
						$login_url = $facebook->getLoginUrl();
				?>
				
				<h2>Prove que você tem boa memória, para entrar nessa nova aventura no <span>REINO DE KIMERA!</span></h2>

				<?php
						echo '<a href="' . $login_url . '" class="bt-facebook">login.</a>';
						echo '<a href="creditos.php" class="bt-creditos">Créditos</a>';
					}
				?>
			</div>

			<ul id="apoiadores">
				<li>Governo Bahia</li>
				<li>Geotec</li>
				<li>UNEB</li>
			</ul>
  	</body>

</html>