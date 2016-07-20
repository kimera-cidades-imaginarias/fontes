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
      <title>Kimera - K-Ágora</title>
      
    <!-- CSS -->
    <!-- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx -->
      <link href="css/bootstrap.css" rel="stylesheet" type="text/css" media="screen" />
      <link href="css/principal.css" rel="stylesheet" type="text/css" media="screen" />

    <!-- JS -->
    <!-- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx -->
      <script src="js/jquery-latest.js" type="text/javascript"></script>
      <script src="js/bootstrap.js" type="text/javascript"></script> 
      <script src="js/jquery.validate.min.js"></script>
      <script src="js/additional-methods.js"></script>

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

            $("#criarMapa").validate();
            $("#file").validate();
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

          $(function ()
          {
             $("#arquivo").change(function () {
                var fileExtension = ['kml','kmz'];

                if ($.inArray($(this).val().split('.').pop().toLowerCase(), fileExtension) == -1) {
                  $( "#arquivo" ).after( "<p>Apenas arquivos no formato '.kml','.kmz' são permitidos.</p>" );
                  $("#arquivo").val('');
                }
            });

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

    <div class="container-fluid">
      <h1>Kimera - KEarth</h1>

      <div class="row-fluid">
        <div class="well span12">
          <div role="tabpanel">
            <div class="tab-content">

              <!--menu -->
              <ul class="nav nav-tabs" role="tablist" id="myTab">
                <li role="presentation"><a href="#sobre" role="tab" data-toggle="tab">K-Ágora</a></li>
                <li role="presentation"><a href="#novoMapa" role="tab" data-toggle="tab">Novo mapa</a></li>
                <li role="presentation"><a href="#carregarMapa" role="tab" data-toggle="tab">Carregar mapa</a></li>
                <li role="presentation"><a href="#creditos" role="tab" data-toggle="tab">Créditos</a></li>
              </ul>

              <!-- sobre -->
              <div role="tabpanel" class="tab-pane" id="sobre">

                <h3>O que é o K-Ágora:</h3>
                <p>O K-Ágora é uma expansão do jogo-simulador Kimera – Cidades Imaginárias, jogável diretamente através do navegador, sem necessidade de instalação.</p>
                <p>É possível criar mapas jogáveis a partir de qualquer localidade real de nosso planeta Terra, possibilitando experimentações sobre o espaço e lugar, inserindo novos elementos e modificando a paisagem através de diversos tipos de construções organizadas em 05 diferentes categorias: Comércio, Educação, Habitações, Infraestrutura e Lazer.</p>
                <p>Também é possível utilizar diversas ferramentas, como cálculo de distâncias, cálculo de área, traçar rotas de trânsito e medir a distância entre dois pontos, graças à integração com a API (Interface de Programação de Aplicativos) do Google Maps.</p>
                <p>Para visualizar o Manual de acesso e uso, <a href="files/manual.pdf" target="_blank">clique aqui</a>.</p>

                <hr />

                <h3>Objetivos:</h3>
                <p>O K-Ágora, assim como o jogo-simulador Kimera, tem como objetivos possibilitar a Educação Cartográfica, explorando o entendimento que as crianças de 08 a 12 anos tem sobre o espaço vivido, percebido e concebido, além  de simular a construção de uma cidade, valorizando os aspectos que a criança considera significativos para sua vida e para a harmonia do espaço/lugar vividos.</p>
                <p>Alguns dos conteúdos pedagógicos abordados:</p>
                <ul>
                  <li><b>Natureza:</b> Transformação e preservação</li>
                  <li><b>Paisagem:</b> Transformação e leitura</li>
                  <li><b>Lugar:</b> Relações cotidianas e espaços de vivências</li>
                  <li><b>Noções cartográficas:</b> Leitura de mapas simples, representações de lugares cotidianos, orientação, localização, distância e leitura de recursos cartográficos</li>
                  <li><b>Meio ambiente:</b> Preservação e manutenção</li>
                  <li><b>Sociedade:</b> Relações de trabalho, grupos sociais e diversidade.</li>
                </ul>

                <hr />

                <h3>Requisitos:</h3>
                <p>O K-Ágora é compatível com a grande maioria dos navegadores disponíveis no mercado, sendo recomendados:</p>
                <ul>
                  <li>Internet Explorer versão 9 ou superior</li>
                  <li>Firefox versão mais atual</li>
                  <li>Chrome versão mais atual</li>
                  <li>Safari versão 5.1 ou superior</li>
                  <li>Opera versão mais atual</li>
                </ul>
                <p>A resolução de vídeo recomendada é a partir de 1152x864 (proporção 4:3) ou 1280x720 (proporção 16:9)</p>

              </div>

              <!-- Novo mapa -->
              <div role="tabpanel" class="tab-pane" id="novoMapa">
                <h2>01.</h2>
                <p>Digite o nome e endereço desejado para criar seu mapa no campo abaixo. Clique em navegar e comece a explorar e modificar o espaço geográfico.</p>

                <hr />

                <form action="editor.php" method="POST" id="criarMapa">
                  <div class="form-group">
                    <label for="endereco">Nome</label>
                    <input type="text" class="form-control input-large" id="nome" name="nome" placeholder="Nome: Salvador" required data-msg-required="Este campo não pode ser vazio!" >

                    <label for="endereco">Endereço</label>
                    <input type="text" class="form-control input-xxlarge" id="endereco" name="endereco" placeholder="Exemplo: Brasil, Bahia, Salvador, Centro" required data-msg-required="Este campo não pode ser vazio!" >
                  </div>

                  <input type="submit" class="btn btn-primary" value="Navegar" />
                </form>
              </div>

              <!-- carregar mapa -->
              <div role="tabpanel" class="tab-pane" id="carregarMapa">
                <h2>01.</h2>
                <p>Carregue seu arquivo KML no campo abaixo para adicioná-lo à nossa biblioteca.</p>

                <form action="#" method="POST" id="file" enctype="multipart/form-data">
                  <div class="form-group">
                    <label for="endereco">Arquivo</label>
                    <input type="file" name="arquivo" id="arquivo" required data-msg-required="Este campo não pode ser vazio!" accept="application/vnd.google-earth.kml+xml" />
                  </div>

                  <br /><input type="submit" class="btn btn-primary" value="Carregar" />
                </form>

                <hr />

                <h2>02.</h2>
                <p>Selecione um dos mapas abaixo para começar a explorar e modificar o espaço geográfico.</p>

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

              <!-- Creditos -->
              <div role="tabpanel" class="tab-pane" id="creditos">
                <h3>Créditos:</h3>
                
                <div class="row-fluid">
                  <div class="span4">
                    <h5>Conteúdo</h5>
                    <ul>
                      <li>André Luiz Andrade Rezende</li>
                      <li>Fabiana dos Santos Nascimento</li>
                      <li>Fernando Kiffer de Souza Toledo</li>
                      <li>Gustavo Erick de Andrade</li>
                      <li>Inaiá Brandão Pereira</li>
                      <li>Walter Von Czékus Garrido</li>
                    </ul>

                    <h5>Arte e Design</h5>
                    <ul>
                      <li>Evaldo Nascimento</li>
                      <li>Josemeira Machado Dias</li>
                      <li>Taís Rocha Ribeiro</li>
                    </ul>

                    <h5>Edição e Diagramação</h5>
                    <ul>
                      <li>Josemeire Machado Dias</li>
                      <li>Taís Rocha Ribeiro</li>
                    </ul>

                    <h5>Coordenação Geral</h5>
                    <ul>
                      <li>Tânia Maria Hetkowski</li>
                    </ul>
                  </div>

                  <div class="span4">
                    <h5>Game Design</h5>
                    <ul>
                      <li>André Luiz Andrade Rezende</li>
                    </ul>

                    <h5>Pedagógico</h5>
                    <ul>
                      <li>Andréa Ferreira Lago</li>
                      <li>Fabiana dos Santos Nascimento</li>
                      <li>Inaiá Brandão Pereira</li>
                      <li>Tânia Regina Dias Silva Pereira</li>
                      <li>Walter Von Czékus Garrido</li>
                    </ul>

                    <h5>Design</h5>
                    <ul>
                      <li>André Luiz Souza da Silva </li>
                      <li>Ila Mascarenhas Muniz</li>
                      <li>Josemeire Machado Dias Betonnasi</li>    
                    </ul>
                  </div>

                  <div class="span4">
                    <h5>Programação</h5>
                    <ul>
                      <li>André Luiz Andrade Rezende</li>
                      <li>Fernando Kiffer de Souza Toledo</li>
                      <li>Humberto Ataide Santiago Junior</li>
                      <li>Iury Barreto da Silva</li>
                      <li>Jason Scalco Piloti</li>
                      <li>Saulo Leal dos Santos</li>
                      <li>Victor Borges</li>
                    </ul>

                    <h5>Roteiro</h5>
                    <ul>
                      <li>Gustavo Erick de Andrade</li>
                    </ul>

                    <h5>Design de Áudio</h5>
                    <ul>
                      <li>Eliaquim Aciole dos Santos Junior</li>
                    </ul>

                    <h5>Transmídia</h5>
                    <ul>
                      <li>André Luiz Souza da Silva Betonnasi</li>
                      <li>Acácia Angélica Monteiro</li>
                      <li>Gilvania Clemente Viana</li>
                      <li>Jodeílson Mafra Martins</li>
                      <li>Lucas Lins Muniz Pimenta</li>
                      <li>Maria Cristina Ribeiro de Jesus Mota</li>
                      <li>Tais Rocha Ribeiro</li>
                    </ul>
                  </div>
                </div>

                <hr />

                <h3>Realização:</h3>
                <center><img src="img/realizacao.jpg" /></center>

                <hr />

                <h3>Financiamento:</h3>
                <center><img src="img/financiamento.jpg" /></center>

                <hr />

                <h3>Apoio:</h3>
                <center><img src="img/apoio.jpg" /></center>

              </div>

            </div>
          </div>
        </div>
      </div>

      <p class="versao">Versão: .d709955</p>
    </div>

  </body>
</html>