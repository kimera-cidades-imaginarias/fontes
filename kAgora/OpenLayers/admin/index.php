<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<?php 
	error_reporting(E_ALL);
  	ini_set("display_errors", 1);

	session_start(); 
?>

<html xmlns="http://www.w3.org/1999/xhtml" lang="pt-BR" xml:lang="pt-BR">

	<head profile="http://gmpg.org/xfn/11">
            
        <!-- META -->
		<!-- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx -->
            <meta http-equiv="content-type" content="text/html; charset=UTF-8" />
            <meta http-equiv="content-language" content="pt, pt-br" />

        <!-- TITLE -->
		<!-- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx -->
	    	<title>Kimera - K-Ágora | Administrador</title>

	    <!-- CSS -->
		<!-- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx -->
			<link href="../css/bootstrap.css" rel="stylesheet" media="screen">
			<link href="../css/principal.css" rel="stylesheet" media="screen">

		<!-- JS -->
		<!-- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx -->
			<script src="../js/jquery-latest.js"></script>
    		<script src="../js/bootstrap.js"></script>


    	<?php include('../action/connect.php'); ?>
	</head>
  	
  	<body>
  		<div class="container">
  			<h1>Kimera - Cidades Imaginárias | Administrador</h1>

  			<div class="well span12">
  			<?php if(isset($_SESSION["user_id"]) && isset($_SESSION["email"]) && isset($_SESSION["password"])){ ?>
  			<ul class="nav nav-tabs">
				<li class="active"><a href="index.php">Início</a></li>

				<?php if($_SESSION["user_id"] == 2){ ?>
				<li class="dropdown">
					<a class="dropdown-toggle" data-toggle="dropdown" href="#">Usuários <b class="caret"></b></a>
					<ul class="dropdown-menu">
						<li><a href="index.php?pagina=novo-usuario">Novo cadastro</a></li>
						<li><a href="index.php?pagina=listar-usuarios">Visualizar cadastros</a></li>
					</ul>
				</li>
				<?php } ?>

				<li class="dropdown">
					<a class="dropdown-toggle" data-toggle="dropdown" href="#">Cartas <b class="caret"></b></a>
					<ul class="dropdown-menu">
						<li><a href="index.php?pagina=nova-carta">Nova carta</a></li>
						<li><a href="index.php?pagina=listar-cartas">Visualizar cartas</a></li>
					</ul>
				</li>
				<li class="dropdown">
					<a class="dropdown-toggle" data-toggle="dropdown" href="#">Sistema <b class="caret"></b></a>
					<ul class="dropdown-menu">
						<li><a href="index.php?acao=sair">Sair</a></li>
					</ul>
				</li>
		    </ul>
		    <?php } ?>

		    <?php 
		    	if(isset($_REQUEST['acao']) && $_REQUEST['acao'] == 'sair'){ 
		    		session_destroy();
		    		echo '<script type="text/javascript"> window.location = "index.php?status=sucesso" </script>';
		    	}
		    ?>

		    <?php if(isset($_REQUEST['status'])){ ?>
			    <?php if($_REQUEST['status'] == 'sucesso'){ ?>
			    <div class="alert alert-success">
		        	<button type="button" class="close" data-dismiss="alert">x</button>
		        	Ação executada com <strong>Sucesso!</strong>
		        </div>
		        <?php } ?>

		        <?php if($_REQUEST['status'] == 'erro'){ ?>
			    <div class="alert alert-error">
	            	<button type="button" class="close" data-dismiss="alert">x</button>
	            	<strong>Erro</strong> ao executar ação!
	            </div>
		        <?php } ?>

		        <?php if($_REQUEST['status'] == 'aviso'){ ?>
		        <div class="alert alert-info">
	            	<button type="button" class="close" data-dismiss="alert">×</button>
	            	Não há resultados para esta <strong>Ação</strong>
	            </div>
	            <?php } ?>
	        <?php } ?>

		   <?php 
		   		if(isset($_SESSION["user_id"]) && isset($_SESSION["email"]) && isset($_SESSION["password"]))
		   			{ 
			    	if(!isset($_REQUEST['pagina'])){
			    		$pagina = 'home';
			    	} else {
			    		$pagina = $_REQUEST['pagina'];
			    	}
			    }
			    else
			    {
			    	$pagina = 'login';
			    }

		    	include_once($pagina . '.php'); 
		    ?>
		    </div>
  		</div>
  	</body>
  	
</html>