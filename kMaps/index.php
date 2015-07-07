<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" lang="pt-BR" xml:lang="pt-BR">

  <head profile="http://gmpg.org/xfn/11">

    <!-- META -->
    <!-- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx -->
      <meta http-equiv="content-type" content="text/html; charset=UTF-8" />
      <meta http-equiv="content-language" content="pt, pt-br" />
    
      <meta http-equiv="X-UA-Compatible" content="IE=edge"> 
      <meta name="viewport" content="width=device-width initial-scale=1.0 maximum-scale=1.0 user-scalable=yes" />

    <!-- TITLE -->
    <!-- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx -->    
      <link rel="shortcut icon" href="img/favicon.ico" type="img/x-icon" />
      <title>Kimera - KMaps</title>
      
    <!-- CSS -->
    <!-- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx -->
      <link href="css/bootstrap.css" rel="stylesheet" type="text/css" media="screen" />
      <link href="css/principal.css" rel="stylesheet" type="text/css" media="screen" />

    <!-- JS -->
    <!-- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx -->
      <script src="js/jquery-latest.js" type="text/javascript"></script>
      <script src="js/bootstrap.js" type="text/javascript"></script> 

      <!-- tabs -->
        <script type="text/javascript">
          $(function () {
            $('#myTab a').click(function (e) {
              e.preventDefault();
              $(this).tab('show')
            });

            $('#myTab a:first').tab('show')

            <?php
              if(isset($_REQUEST['tab'])){
                echo " $(\"a[href='#".$_REQUEST['tab']."']\").tab('show'); ";
              }
            ?>
          })
        </script>

      <!-- form -->
        <script type="text/javascript">
          function updateList(){
            $.ajax({
              type: "GET",
              url: "action/list.php",
              success: function(data) {

                $("#dados").html(data);    
              }
            });
          }

          $(function () {
            $("#file").submit(function(e){
                e.preventDefault();

                data = new FormData($('#file')[0]);
                var formTemp = $("#file").html();
                $("#file").html('<p>Aguarde...</p>');

                $.ajax({
                    type: 'POST',
                    url: 'action/save.php',
                    data: data,
                    cache: false,
                    contentType: false,
                    processData: false
                }).done(function(data) {
                    
                    updateList();
                    $("#file").html(formTemp);

                }).fail(function(jqXHR,status, errorThrown) {
                    console.log(errorThrown);
                    console.log(jqXHR.responseText);
                    console.log(jqXHR.status);
                });
            });

            updateList();
          })


        </script>

  </head>
  
  <body>

    <div class="container">
      <h1>Kimera - KEarth</h1>

      <div role="tabpanel">
        <div class="tab-content well">

          <!--menu -->
          <ul class="nav nav-tabs" role="tablist" id="myTab">
            <li role="presentation"><a href="#sobre" role="tab" data-toggle="tab">K-Maps</a></li>
            <li role="presentation"><a href="#novoMapa" role="tab" data-toggle="tab">Novo mapa</a></li>
            <li role="presentation"><a href="#carregarMapa" role="tab" data-toggle="tab">Carregar mapa</a></li>
          </ul>

          <!-- sobre -->
          <div role="tabpanel" class="tab-pane" id="sobre">

            <h3>O que é o K-Maps?</h3>
            <p></p>

            <hr />

            <h3>Objetivos</h3>
            <p></p>

            <hr />

            <h3>Requisitos</h3>
            <p></p>

          </div>

          <!-- Novo mapa -->
          <div role="tabpanel" class="tab-pane" id="novoMapa">
            <h2>01.</h2>
            <p>Digite o endereço desejado para criar seu mapa no campo abaixo. Clique em navegar e comece a diversão.</p>

            <hr />

            <form action="editor.php" method="POST">
              <div class="form-group">
                <label for="endereco">Endereço</label>
                <input type="text" class="form-control input-xxlarge" id="endereco" name="endereco" placeholder="Exemplo: Brasil, Bahia, Salvador, Centro">
              </div>

              <input type="submit" class="btn btn-primary" value="Navegar" />
            </form>
          </div>

          <!-- carregar mapa -->
          <div role="tabpanel" class="tab-pane" id="carregarMapa">
            <h2>01.</h2>
            <p>Carregue seu arquivo KML no campo abaixo para adiciona-lo a nossa biblioteca.</p>

            <form action="#" method="POST" id="file" enctype="multipart/form-data">
              <div class="form-group">
                <label for="endereco">Arquivo</label>
                <input type="file" name="arquivo" id="arquivo" />
              </div>

              <br /><input type="submit" class="btn btn-primary" value="Carregar" />
            </form>

            <hr />

            <h2>02.</h2>
            <p>Selecione um dos mapas abaixo para começar a diversão.</p>

            <table class="table table-striped">
              <thead>
                <tr>
                  <th width="75%">Nome</th>
                  <th width="25%" colspan="3">Ação</th>
                </tr>
              </thead>
              <tbody id="dados">

              </tbody>
            </table>
          </div>

        </div>
      </div>

      <p class="versao">Versão: 4743a11</p>
    </div>

  </body>
</html>