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
      <link rel="stylesheet" href="http://openlayers.org/en/v3.15.1/css/ol.css" type="text/css">

    <!-- JS -->
    <!-- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx -->
      <script src="js/jquery-latest.js" type="text/javascript"></script>
      <script src="js/jquery-ui.min.js" type="text/javascript"></script>
      <script>
        $.widget.bridge('uibutton', $.ui.button);
        $.widget.bridge('uitooltip', $.ui.tooltip);
      </script>
      <script src="js/bootstrap.js" type="text/javascript"></script> 
      <script src="js/jquery.md5.js" type="text/javascript"></script>

      <script src="http://openlayers.org/en/v3.15.1/build/ol.js"></script>

      <!-- tabs -->
        <script type="text/javascript">

          $(function () 
          {
            $('#myTab a').click(function (e) 
            {
              e.preventDefault();
              $(this).tab('show')
            });

            $('#myTab a:first').tab('show');
            $('.tab-content a').tooltip();

            $(".alert").alert('close')
          })

        </script>

      <!-- maps -->
        <script type="text/javascript">
          
          var map = null;

          var construcoes = [];
          
          var nomeMapa = "";
          var coordenadasMapa = [0,0]

          function creatIconOnMap(nome, icone, ltd, lng)
          {
            var iconFeature = new ol.Feature({
              geometry: new ol.geom.Point([lng,ltd]),
              name: nome
            });

            var iconStyle = new ol.style.Style({
              image: new ol.style.Icon( ({
                anchor: [0.5, 46],
                anchorXUnits: 'fraction',
                anchorYUnits: 'pixels',
                src: icone
              }))
            });

            iconFeature.setStyle(iconStyle);

            construcoes.push(iconFeature);
          } 

          function updateMap()
          {
            /*
            var vectorSource = new ol.source.Vector({
              features: construcoes
            });

            var vectorLayer = new ol.layer.Vector({
              source: vectorSource
            });

            map.removeLayer(vectorLayer);
            map.addLayer(vectorLayer);
            */
          }

          function initializeAPI() 
          {        
            var vectorSource = new ol.source.Vector({
              features: construcoes
            });

            var vectorLayer = new ol.layer.Vector({
              source: vectorSource
            });

            //map
            map = new ol.Map({
              layers: [
                new ol.layer.Tile({
                  source: new ol.source.OSM()
                }), vectorLayer
              ],
              target: 'map',
              controls: ol.control.defaults({
                attributionOptions:({
                  collapsible: false
                })
              }),
              view: new ol.View({
                projection: 'EPSG:4326',
                center: [coordenadasMapa[1], coordenadasMapa[0]],
                zoom:18
              })
            });
          }

          function showProfDaniel()
          {
            //prof. daniel
            $( "#help .balao" ).html("Agora é com você!<br /> Use sua criatividade para modificar o mapa, <br />adicionando novas construções e explorando<br /> as ferramentas de geolocalização.");
            $( "#help" ).fadeIn( 400 );

            my_timer = setTimeout(function () 
            {
                $( "#help" ).fadeOut( 400 );
            }, 6000);
          }

          function showMapaName(nomeMapa)
          {
            $('.nomeCidade').html("("+nomeMapa+")");
          }

          function populateList(markers)
          {
            $("#construcoes").html('');

            for (var i = 0; i < markers.length; i++) {
              $("#construcoes").append( '<li><a href="#"><img src="img/icone-editar.png" /></a> <a href="javascript:removeMarker('+i+')""><img src="img/icone-delete.png" /></a> <a href="javascript:focusMarker('+i+')">' + markers[i].get('name') + '</a></li>');
            }
          }

          function focusMarker(index)
          {   
            map.setView(new ol.View({
              projection: 'EPSG:4326',
              center:  construcoes[index].getGeometry().getLastCoordinate(),
              zoom: 18
            }));
          }

          function removeMarker(index)
          {
            var r = confirm("Voce tem certeza que deseja remover esta construção?");
                  
            if (r == true) 
            {
              construcoes.splice(index, 1);
              populateList(construcoes);
              updateMap();
            } 
          }

          function loadKml(file) 
          {
            $.ajax(
            {
              type: "GET",
              url: "kml/"+file+"?rnd"+Math.random(),
              dataType: "xml",

              success: function(xml) {
                var serializer = new XMLSerializer(); 
                var kml = serializer.serializeToString(xml);
                 
                processKML(kml);          
              }
            });
          }

          function processKML(data) 
          {
            //nome do mapa
            $(data).find("Cidade").each(function(index, value)
            {
              nomeMapa = $(this).text();
            });
            
            //construcoes
            $(data).find("Placemark").each(function(index, value)
            {
                var name = $(this).find("name").text() ;
                var coordinates = $(this).find("coordinates").text().split(","); 
                var styleUrl = $(this).find("styleUrl").text();

                var icon = $(data).find(styleUrl).text();
                icon = icon.substring(icon.indexOf("<href>")+6, icon.indexOf("</href>"));

                var longitude = coordinates[0] ;
                var latitude = coordinates[1] ;

                if(name && longitude && latitude)
                {
                  creatIconOnMap(name, icon, latitude, longitude);
                }
            });

            //camera
            $(data).find("Camera").each(function(index, value){
              var longitude = $(this).find("longitude").text() ;
              var latitude = $(this).find("latitude").text() ;
              var tilt = parseInt($(this).find("tilt").text()) ;

              if(longitude && latitude && tilt){
                coordenadasMapa[0] = latitude;
                coordenadasMapa[1] = longitude;
              }
            })

            //api
            initializeAPI();

            //tutorial
            showProfDaniel();

            //show infos
            showMapaName(nomeMapa);
            populateList(construcoes);
          }

        </script>

    <!-- simulador -->
        <script type="text/javascript">

            $(document).ready( function() 
            {
              //load constructions
              <?php if(isset($_REQUEST['arquivo'])){ echo "loadKml('".$_REQUEST['arquivo']."',map);"; } ?>

              //aba edificacoes
              $( ".lista a" ).click(function(e) 
              {
                return false;
              });

              //ajuda
              $( "#closeHelp" ).click(function(e) 
              {
                $( "#help" ).fadeOut( 400 );
                clearTimeout(my_timer);

                return false;
              });

              //inicial
              $( ".inicial" ).click(function(e) 
              {
                  var r = confirm("Todas as alterações não salvas serão perdidas, deseja mesmo sair para a Página Inicial?");
                  
                  if (r == true) {
                    window.location.assign("index.php?tab=novoMapa")
                  } 

                  return false;
              });
          });

        </script>
  </head>
  
  <body>
    <div class="container">
      <br />
    
      <div class="row-fluid">
        <div class="well span9">
          <div id="map"></div>  
          <div id="info"></div>
          <div id="help">
            <img src="img/help.png">
            <p class="balao"></p>
            <a href="#" id="closeHelp"><img src="img/close_icon.png" /></a>
          </div>
        </div>

        <div class="well span3 panelContrucao">
            <p><b>Construções Criadas</b><br /><small <?php if(!isset($_REQUEST['nome'])){ echo 'class="nomeCidade"'; } ?> >(<?php if(isset($_REQUEST['nome'])){ echo $_REQUEST['nome']; } ?>)</small></p>
            
            <hr />

            <ul id="construcoes">
            
            </ul>
        </div>

        <div class="well span3 panelFerramentas">
            <p><a href="#" class="btn span12 inicial">Página Inicial</a></p>
            <p><a href="#" class="btn span12" id="salvar">Salvar Construções</a></p>
            <p><a href="files/manual.pdf" class="btn span12" id="manual" target="_blank">Manual de Acesso e Uso</a></p>
        </div>
      </div>

      <div class="row-fluid">
        <div class="span12">
          
          <div class="tab-content well">
            <ul class="nav nav-pills" role="tablist" id="myTab">
              <li role="presentation"><a href="#tabs1" role="tab" data-toggle="tab"><img width="30" src="img/icone_representa_comercio.png" /> Comércio</a></li>
              <li role="presentation"><a href="#tabs2" role="tab" data-toggle="tab"><img width="30" src="img/icone_representa_educacao.png" /> Educação</a></li>
              <li role="presentation"><a href="#tabs3" role="tab" data-toggle="tab"><img width="30" src="img/icone_representa_habitacoes.png" /> Habitações</a></li>
              <li role="presentation"><a href="#tabs4" role="tab" data-toggle="tab"><img width="30" src="img/icone_representa_infraestrutura.png" /> Infraestrutura</a></li>
              <li role="presentation"><a href="#tabs5" role="tab" data-toggle="tab"><img width="30" src="img/icone_representa_lazer.png" /> Lazer</a></li>
              <li role="presentation"><a href="#tabs6" role="tab" data-toggle="tab"><img width="30" src="img/icone_configuracoes.png" /> Ferramentas</a></li>
            </ul>

            <div role="tabpanel" class="tab-pane" id="tabs1">
              <ul class="lista">
                <li><a href="academia" rel="tooltip" title="Academia"><img src="img/icone_comercio_academia.png" /></a></li>
                <li><a href="banco-01" rel="tooltip" title="Banco 01"><img src="img/icone_comercio_banco01.png" /></a></li>
                <li><a href="banco-02" rel="tooltip" title="Banco 02"><img src="img/icone_comercio_banco02.png" /></a></li>
                <li><a href="banco-03" rel="tooltip" title="Banco 03"><img src="img/icone_comercio_banco03.png" /></a></li>
                <li><a href="lanchonete" rel="tooltip" title="Lanchonete"><img src="img/icone_comercio_lanchonete.png" /></a></li>
                <li><a href="loja" rel="tooltip" title="Loja"><img src="img/icone_comercio_loja.png" /></a></li>
                <li><a href="posto-de-gasolina" rel="tooltip" title="Posto de Gasolina"><img src="img/icone_comercio_postodegasolina.png" /></a></li>
                <li><a href="super-mercado" rel="tooltip" title="Supermercado"><img src="img/icone_comercio_supermercado.png" /></a></li>
              </ul>
            </div>

            <div role="tabpanel" class="tab-pane" id="tabs2">
              <ul class="lista">
                <li><a href="biblioteca" rel="tooltip" title="Biblioteca"><img src="img/icone_educacao_biblioteca.png" /></a></li>
                <li><a href="escola" rel="tooltip" title="Escola"><img src="img/icone_educacao_escola.png" /></a></li>
                <li><a href="universidade" rel="tooltip" title="Universidade"><img src="img/icone_educacao_universidade.png" /></a></li>
              </ul>
            </div>

            <div role="tabpanel" class="tab-pane" id="tabs3">
              <ul class="lista">
                <li><a href="casa-de-luxo" rel="tooltip" title="Casa de Luxo"><img src="img/icone_habitacoes_casaluxo.png" /></a></li>
                <li><a href="casa-media" rel="tooltip" title="Casa Média"><img src="img/icone_habitacoes_casamedia.png" /></a></li>
                <li><a href="casa-simples" rel="tooltip" title="Casa Simples"><img src="img/icone_habitacoes_casasimples.png" /></a></li>
                <li><a href="hotel" rel="tooltip" title="Hotel"><img src="img/icone_habitacoes_hotel.png" /></a></li>
                <li><a href="predio-de-luxo" rel="tooltip" title="Prédio de Luxo"><img src="img/icone_habitacoes_predioluxo.png" /></a></li>
                <li><a href="predio-medio" rel="tooltip" title="Prédio Médio"><img src="img/icone_habitacoes_prediomedio.png" /></a></li>
                <li><a href="predio-simples" rel="tooltip" title="Prédio Simples"><img src="img/icone_habitacoes_prediosimples.png" /></a></li>
              </ul>
            </div>

            <div role="tabpanel" class="tab-pane" id="tabs4">
              <ul class="lista">
                <li><a href="aeroporto" rel="tooltip" title="Aeroporto"><img src="img/icone_infraestrutura_aeroporto.png" /></a></li>
                <li><a href="bombeiros" rel="tooltip" title="Bombeiros"><img src="img/icone_infraestrutura_bombeiros.png" /></a></li>
                <li><a href="ciclo-paque" rel="tooltip" title="Ciclo Parque"><img src="img/icone_infraestrutura_ciclo_paque.png" /></a></li>
                <li><a href="delegacia" rel="tooltip" title="Delegacia"><img src="img/icone_infraestrutura_delegacia.png" /></a></li>
                <li><a href="estacao-tratamento-de-agua" rel="tooltip" title="Estaçao de Tratamento de Água"><img src="img/icone_infraestrutura_estacao_tratamento_de_agua.png" /></a></li>
                <li><a href="hospital" rel="tooltip" title="Hospital"><img src="img/icone_infraestrutura_hospital.png" /></a></li>
                <li><a href="industria" rel="tooltip" title="Indústria"><img src="img/icone_infraestrutura_industria.png" /></a></li>
                <li><a href="industria-de-reciclagem-de-lixo" rel="tooltip" title="Indústria de Reciclagem de Lixo"><img src="img/icone_infraestrutura_industria_de_reciclagem_de_lixo.png" /></a></li>
                <li><a href="parque-ecologico" rel="tooltip" title="Parque Ecológico"><img src="img/icone_infraestrutura_parque_ecologico.png" /></a></li>
                <li><a href="posto-de-saude" rel="tooltip" title="Posto de Saúde"><img src="img/icone_infraestrutura_postodesaude.png" /></a></li>
                <li><a href="rodoviaria" rel="tooltip" title="Rodoviária"><img src="img/icone_infraestrutura_rodoviaria.png" /></a></li>
                <li><a href="termo-eletrica" rel="tooltip" title="Termoelétrica"><img src="img/icone_infraestrutura_termoeletrica.png" /></a></li>
                <li><a href="usina-eolica" rel="tooltip" title="Usina Eólica"><img src="img/icone_infraestrutura_usina_eolica.png" /></a></li>
              </ul>
            </div>

            <div role="tabpanel" class="tab-pane" id="tabs5">
              <ul class="lista">
                <li><a href="estadio-de-futibol" rel="tooltip" title="Estádio de Futebol"><img src="img/icone_lazer_estadiofutebol.png" /></a></li>
                <li><a href="praia" rel="tooltip" title="Praia"><img src="img/icone_lazer_praia.png" /></a></li>
                <li><a href="restaurante-luxo" rel="tooltip" title="Restaurante de Luxo"><img src="img/icone_lazer_restauranteluxo.png" /></a></li>
                <li><a href="restaurante-simples" rel="tooltip" title="Restaurante Simples"><img src="img/icone_lazer_restaurantesimples.png" /></a></li>
                <li><a href="shopping" rel="tooltip" title="Shopping"><img src="img/icone_lazer_shopping.png" /></a></li>
                <li><a href="sorveteria" rel="tooltip" title="Sorveteria"><img src="img/icone_lazer_sorveteria.png" /></a></li>
                <li><a href="teatro" rel="tooltip" title="Teatro"><img src="img/icone_lazer_teatro.png" /></a></li>
                <li><a href="zoologico" rel="tooltip" title="Zoológico"><img src="img/icone_lazer_zoologico.png" /></a></li>
              </ul>
            </div>

             <div role="tabpanel" class="tab-pane" id="tabs6">
              <ul class="lista">
                <li><a href="area" rel="tooltip" title="Medir Área"><img src="img/icone_area.png" /></a></li>
                <li><a href="ponto" rel="tooltip" title="Medir Distâncias"><img src="img/icone_ponto.png" /></a></li>
                <li><a href="coordenada" rel="tooltip" title="Retornar Coordenadas"><img src="img/icone_coordenada.png" /></a></li>
                <li><a href="rota" rel="tooltip" title="Calcular Rota"><img src="img/icone_rota.png" /></a></li>
              </ul>
            </div>
            
          </div>
        </div>
      </div>

      <p class="versao">Versão: d709955</p>
    </div>
  </body>

</html>
