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
			<link href="../css/DateTimePicker.css" rel="stylesheet" media="screen">

		<!-- JS -->
		<!-- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx -->
			<script src="../js/jquery-latest.js"></script>
    		<script src="../js/bootstrap.js"></script>
    		<script src="../js/DateTimePicker.js"></script>

    		<script type="text/javascript">
			  function loadPageOnModal(url, titulo)
			  {
			  	 $('#myModal').modal('show');
			  	 $('#myModal .modal-header h3').html(titulo);

				  	$.ajax({
					  url: url
					}).done(function(data) { 
					  $('#data').html(data); 
					});
			  }
			</script>

    	<?php include('../action/connect.php'); ?>
	</head>
  	
  	<body>
  		<div class="container-fluid">
  			<a href="../index.php"><h1>Kimera - K-Ágora | Administrador</h1></a>

  			<!-- Modal -->
		    <div id="myModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		      <div class="modal-header">
		        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
		        <h3></h3>
		      </div>
		      
		      <div id="data" class="modal-body"></div>
		    </div>

  			<div class="row-fluid">
	  			<div class="well span12">
	  			<?php if(isset($_SESSION["user_id"]) && isset($_SESSION["email"]) && isset($_SESSION["password"])){ ?>
	  			<ul class="nav nav-tabs" id="myTab">
					<li><a href="index.php" id="btHome">Início</a></li>

					<?php if($_SESSION["permission"] == 2){ ?>
					<li class="dropdown">
						<a class="dropdown-toggle" data-toggle="dropdown" href="#" id="btUsuarios">Usuários <b class="caret"></b></a>
						<ul class="dropdown-menu">
							<li><a href="javascript:loadPageOnModal('novo-usuario.php', 'Novo Usuário')">Novo cadastro</a></li>
							<li><a href="index.php?pagina=listar-usuarios">Visualizar cadastros</a></li>
						</ul>
					</li>
					<?php } ?>

					<li class="dropdown">
						<a class="dropdown-toggle" data-toggle="dropdown" href="#" id="btCartas">Cartas <b class="caret"></b></a>
						<ul class="dropdown-menu">
							<li><a href="javascript:loadPageOnModal('nova-carta.php', 'Nova Carta')">Nova carta</a></li>
							<li><a href="index.php?pagina=listar-cartas">Visualizar cartas</a></li>
						</ul>
					</li>
					<li class="dropdown">
						<a class="dropdown-toggle" data-toggle="dropdown" href="#">Sistema <b class="caret"></b></a>
						<ul class="dropdown-menu">
							<li><a href="index.php?pagina=editar-usuario&id=<?php echo $_SESSION["user_id"]; ?>">Alterar Senha</a></li>
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
	  	</div>
  	</body>
  	
</html>