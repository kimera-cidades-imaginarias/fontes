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
      <title>Kimera - KEarth</title>
      
    <!-- CSS -->
    <!-- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx -->
      <link href="css/bootstrap.css" rel="stylesheet" type="text/css" media="screen" />
      <link href="css/principal.css" rel="stylesheet" type="text/css" media="screen" />

    <!-- JS -->
    <!-- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx -->
      <script src="js/jquery-latest.js" type="text/javascript"></script>
      <script src="js/bootstrap.js" type="text/javascript"></script> 
      <script src="js/jquery.md5.js" type="text/javascript"></script> 
      <script src="https://maps.googleapis.com/maps/api/js?v=3.exp&signed_in=true"></script>
      <script src="https://www.google.com/jsapi?key=ABQIAAAA5El50zA4PeDTEMlv-sXFfRSsTL4WIgxhMZ0ZK_kHjwHeQuOD4xTdBhxbkZWuzyYTVeclkwYHpb17ZQ"></script>

      <!-- tabs -->
        <script type="text/javascript">
          $(function () {
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

      <!-- earth -->
        <script type="text/javascript">
          var ge = null;
          var kmlObject = null;
          
          var edicao = false;
          var cursor = false;

          var edificacao = "";
          var kmlFile = "";
      
          google.load("earth", "1", {"other_params":"sensor=true"});

          function init() 
          {
            google.earth.setLanguage('pt');
            google.earth.createInstance('map', initCB, failureCB);            
          }

          function initCB(instance) 
          {
            //basic config
              ge = instance;
              
              ge.getWindow().setVisibility(true);
              ge.getNavigationControl().setVisibility(ge.VISIBILITY_AUTO);
              ge.getNavigationControl().setStreetViewEnabled(true);
              
              ge.getLayerRoot().enableLayerById(ge.LAYER_BORDERS, true);
              ge.getLayerRoot().enableLayerById(ge.LAYER_TERRAIN, true);
              ge.getLayerRoot().enableLayerById(ge.LAYER_TREES, true);
              ge.getLayerRoot().enableLayerById(ge.LAYER_BUILDINGS, true);

              ge.getSun().setVisibility(false);

            //frame over
              var screenOverlay = ge.createScreenOverlay('');
              var icon = ge.createIcon('');
             
              icon.setHref('https://kimera4.websiteseguro.com/kearth/img/frame.png');
              screenOverlay.setIcon(icon);

              var screenXY = screenOverlay.getScreenXY();
              screenXY.setXUnits(ge.UNITS_PIXELS);
              screenXY.setYUnits(ge.UNITS_PIXELS);
              screenXY.setX(0);
              screenXY.setY(0);

              var overlayXY = screenOverlay.getOverlayXY();
              overlayXY.setXUnits(ge.UNITS_PIXELS);
              overlayXY.setYUnits(ge.UNITS_PIXELS);
              overlayXY.setX(0);
              overlayXY.setY(0);

              var overlaySize = screenOverlay.getSize()
              overlaySize.setXUnits(ge.UNITS_FRACTION);
              overlaySize.setYUnits(ge.UNITS_FRACTION);
              overlaySize.setX(1);
              overlaySize.setY(1);

              screenOverlay.setVisibility(true);
              ge.getFeatures().appendChild(screenOverlay);

            //loads
              //get adress
                <?php if(isset($_REQUEST['endereco'])){ 
                  echo ' getCordenate("'.$_REQUEST['endereco'].'"); '; 
                } ?>
                
              //load constructions
                <?php if(isset($_REQUEST['arquivo'])){ 
                  echo ' loadKML("'.$_REQUEST['arquivo'].'"); '; 
                } ?>

            //cursor
              //creat cursor
                var placemark = ge.createPlacemark('');
                var point = ge.createPoint('');

                placemark.setGeometry(point);

              //get cordenate
                google.earth.addEventListener(ge.getWindow(), 'mousemove', function(event) 
                {
                  if (event.getDidHitGlobe() &&  edicao == true) 
                  {
                    var latitude = event.getLatitude();
                    var longitude = event.getLongitude();
                    
                    if(cursor == false)
                    {
                      ge.getFeatures().appendChild(placemark);
                      cursor = true;
                    }

                    point.setLatitude(latitude);
                    point.setLongitude(longitude);
                  }
                });

              //construc
                google.earth.addEventListener(ge.getWindow(), 'mousedown', function(event) 
                {
                  if (event.getDidHitGlobe() &&  edicao == true) 
                  {
                    var latitude = event.getLatitude();
                    var longitude = event.getLongitude();

                    var construir = "https://kimera4.websiteseguro.com/kearth/models/"+edificacao+".DAE";

                    ge.getFeatures().removeChild(placemark);
                    
                    edicao = false;
                    cursor = false;

                    var idConstrucao = $.md5(latitude+''+longitude);

                    kmlFile += '<Placemark id="'+idConstrucao+'">';
                      kmlFile += '<name>'+edificacao+'</name>';
                      kmlFile += '<Model>';
                        //kmlFile += '<altitudeMode>absolute</altitudeMode>';
                        kmlFile += '<Location>';
                            kmlFile += '<longitude>'+longitude+'</longitude>';
                            kmlFile += '<latitude>'+latitude+'</latitude>';
                            kmlFile += '<altitude>2</altitude>';
                        kmlFile += '</Location>';
                        kmlFile += '<Orientation>';
                            kmlFile += '<heading>0</heading>';
                            kmlFile += '<tilt>0</tilt>';
                            kmlFile += '<roll>0</roll>';
                        kmlFile += '</Orientation>';
                        kmlFile += '<Scale>';
                            kmlFile += '<x>1.0</x>';
                            kmlFile += '<y>1.0</y>';
                            kmlFile += '<z>1.0</z>';
                        kmlFile += '</Scale>';
                        kmlFile += '<Link>';
                            kmlFile += "<href>"+construir+"</href>";
                        kmlFile += '</Link>';
                      kmlFile += '</Model>';
                    kmlFile += '</Placemark>';

                    manageKML();
                  }
                });                
 
          }

          function failureCB(errorCode) {
          
          }

          google.setOnLoadCallback(init);

       </script>

    <!-- simulador -->
        <script type="text/javascript">

          //string
            function removeAcento(strToReplace) 
            {
              var str_acento = "áàãâäéèêëíìîïóòõôöúùûüçÁÀÃÂÄÉÈÊËÍÌÎÏÓÒÕÖÔÚÙÛÜÇ,.; ";
              var str_sem_acento = "aaaaaeeeeiiiiooooouuuucAAAAAEEEEIIIIOOOOOUUUUC---";
              
              var string_final = "";
              
              for (var i = 0; i < strToReplace.length; i++) {
                  if (str_acento.indexOf(strToReplace.charAt(i)) != -1) {
                      string_final += str_sem_acento.substr(str_acento.search(strToReplace.substr(i, 1)), 1);
                  } else {
                      string_final += strToReplace.substr(i, 1);
                  }
              }
              
              return string_final.toLowerCase();
            }

          //camera
            function fixCamera(lat, lng)
            {
              var lookAt = ge.createLookAt('');

              lookAt.setLatitude(lat);
              lookAt.setLongitude(lng);
              lookAt.setAltitude(139);
              lookAt.setHeading(-70.0);
              lookAt.setTilt(75);
              lookAt.setRange(2000.0);

              ge.getView().setAbstractView(lookAt);
            }
          
          //adress
            function getCordenate(address)
            {
              var geocoder = new google.maps.Geocoder();
              var geolocate = new Array();

              geocoder.geocode( { 'address': address}, function(results, status) 
              {
                if (status == google.maps.GeocoderStatus.OK) 
                {
                  geolocate[0] = results[0].geometry.location.lat();
                  geolocate[1] = results[0].geometry.location.lng(); 

                  fixCamera(geolocate[0], geolocate[1]); //fix this bug

                  //return geolocate;                 
                }
              });
            }

            function getAddress(lat, lng)
            {
              var geocoder = new google.maps.Geocoder();
              var latlng = new google.maps.LatLng(lat,lng);
              var address = null;

              geocoder.geocode({'latLng': latlng}, function(results, status) {
                  if (status == google.maps.GeocoderStatus.OK) 
                  {
                    address = results[1].formatted_address;

                    saveKML(lat, lng, address); //fix this bug

                    //return address;
                  }
              });
            }

          //kml
            function loadKML(file)
            {
              $.ajax(
              {
                type: "GET",
                url: "kml/"+file+"?rnd"+Math.random(),
                dataType: "xml",

                success: function(xml) {
                  var serializer = new XMLSerializer(); 
                  var kml = serializer.serializeToString(xml);
                   
                  runKML(kml);
                  filterKML(kml); 
                  manageKML();           
                }
              });

            }

            function runKML(kml)
            {
              if(kmlObject != null){
                ge.getFeatures().removeChild(kmlObject);
              }

              kmlObject = ge.parseKml(kml);

              ge.getFeatures().appendChild(kmlObject);
              
              if (kmlObject.getAbstractView())
              {
                ge.getView().setAbstractView(kmlObject.getAbstractView());
              }
            }

            function filterKML(kml)
            {
              var str = kml;

              var start = str.indexOf("<Document>");
              var end = str.indexOf("<Camera>");

              var res = str.substring(start+10, end);

              kmlFile += res;
            }

            function manageKML()
            {
              var kml = "<Document>"+kmlFile+"</Document>"; 

              runKML(kml);
              populateList();
            }

            function saveKML(cameraLat, cameraLng, cameraLocate)
            {
              kmlFile += '<Camera>';
                kmlFile += '<longitude>'+cameraLng+'</longitude>';
                kmlFile += '<latitude>'+cameraLat+'</latitude>';
                kmlFile += '<altitude>139</altitude>';
                kmlFile += '<heading>-70.0</heading>';
                kmlFile += '<tilt>75</tilt>';
              kmlFile += '</Camera>';

              $.ajax(
              {
                  type: 'POST',
                  url: 'action/creat.php',
                  data: { data: kmlFile, name: removeAcento(cameraLocate) }
              }).done(function(data) {
                $("#info").html('<br /><div class="alert alert-success">Arquivo salvo com sucesso, você pode acessá-lo na listagem de mapas clicando <a href="index.php?tab=carregarMapa">aqui.</a></div>');
              });
            }  

          //list constructions / manage
            function populateList()
            {
              var xml = "<Document>"+kmlFile+"</Document>"; 
              var xmlDoc = $.parseXML( xml );

              $("#construcoes").html( "" );
              
              $(xmlDoc).find("Placemark").each(function()
              {
                var id = $(this).attr("id");
                var name = $(this).find("name").text();
                var latitude = $(this).find("latitude").text();
                var longitude = $(this).find("longitude").text();

                $("#construcoes").append( '<li><a href="javascript:;" onmouseover="overMark('+latitude+', '+longitude+')" onclick="clickMark(\''+id+'\')" ><img src="img/icone-delete.png" /> ' +name+ '</a></li>' );
              }); 
            }

            function overMark(lat,lng)
            {       
              var lookAt = ge.getView().copyAsLookAt(ge.ALTITUDE_RELATIVE_TO_GROUND);

              lookAt.setLatitude(lat);
              lookAt.setLongitude(lng);
              lookAt.setRange(50.0);

              ge.getView().setAbstractView(lookAt);
            }

            function clickMark(id){
              var start = kmlFile.indexOf(id);
              var end = kmlFile.indexOf("</Placemark>", start);

              var res = kmlFile.substring(start-15, end+12);
              kmlFile = kmlFile.replace(res, "");

              manageKML();
            }

          //start engine
            $(document).ready( function() 
            {
              edificacao = "";
              
              //constructions events
              $( ".lista a" ).click(function(e) {
                edicao = true;
                cursor = false;

                edificacao = $(this).attr('href');  

                return false;
              });

              $( "#salvar" ).click(function(e) {
                var lookAt = ge.getView().copyAsLookAt(ge.ALTITUDE_RELATIVE_TO_GROUND);
                
                var cameraLat = lookAt.getLatitude();
                var cameraLng = lookAt.getLongitude();
                
                getAddress(cameraLat, cameraLng);

                return false;
              });

              $( ".inicial" ).click(function(e) {
                  var r = confirm("Você pode perder o conteúdo criado, deseja salvar suas construções antes de sair?");
                  
                  if (r == true) {
                  
                    var lookAt = ge.getView().copyAsLookAt(ge.ALTITUDE_RELATIVE_TO_GROUND);
                
                    var cameraLat = lookAt.getLatitude();
                    var cameraLng = lookAt.getLongitude();
                    
                    getAddress(cameraLat, cameraLng);

                  } else {
                    window.location.assign("index.php?tab=carregarMapa")
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
        </div>

        <div class="well span3 panelContrucao">
            <p><b>Contruções Criadas</b></p>
            <hr />
            <ul id="construcoes">
            
            </ul>
        </div>

        <div class="well span3 panelFerramentas">
            <p><a href="#" class="btn span12 inicial">Menu Inicial</a></p>
            <p><a href="#" class="btn span12" id="salvar">Salvar Construções</a></p>
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
              <li role="presentation"><a href="#tabs6" role="tab" data-toggle="tab"><img width="30" src="img/icone_configuracoes.png" /> Testes</a></li>
            </ul>

            <div role="tabpanel" class="tab-pane" id="tabs1">
              <ul class="lista">
                <li><a href="banco-01" rel="tooltip" title="Banco 01"><img src="img/icone_comercio_banco01.png" /></a></li>
                <li><a href="banco-02" rel="tooltip" title="Banco 02"><img src="img/icone_comercio_banco02.png" /></a></li>
                <li><a href="banco-03" rel="tooltip" title="Banco 03"><img src="img/icone_comercio_banco03.png" /></a></li>
                <li><a href="lanchonete" rel="tooltip" title="Lanchonete"><img src="img/icone_comercio_lanchonete.png" /></a></li>
                <li><a href="loja" rel="tooltip" title="Loja"><img src="img/icone_comercio_loja.png" /></a></li>
                <li><a href="posto-de-gasolina" rel="tooltip" title="Posto de Gasolina"><img src="img/icone_comercio_postodegasolina.png" /></a></li>
                <li><a href="super-mercado" rel="tooltip" title="Super Mercado"><img src="img/icone_comercio_supermercado.png" /></a></li>
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
                <li><a href="predio-de-luxo" rel="tooltip" title="Prédio de Luxo"><img src="img/icone_habitacoes_predioluxo.png" /></a></li>
                <li><a href="predio-medio" rel="tooltip" title="Prédio Medio"><img src="img/icone_habitacoes_prediomedio.png" /></a></li>
                <li><a href="predio-simples" rel="tooltip" title="Prédio Simples"><img src="img/icone_habitacoes_prediosimples.png" /></a></li>
              </ul>
            </div>

            <div role="tabpanel" class="tab-pane" id="tabs4">
              <ul class="lista">
                <li><a href="bombeiros" rel="tooltip" title="Bombeiros"><img src="img/icone_infraestrutura_bombeiros.png" /></a></li>
                <li><a href="ciclo-paque" rel="tooltip" title="Ciclo Parque"><img src="img/icone_infraestrutura_ciclo_paque.png" /></a></li>
                <li><a href="delegacia" rel="tooltip" title="Delegacia"><img src="img/icone_infraestrutura_delegacia.png" /></a></li>
                <li><a href="estacao-tratamento-de-agua" rel="tooltip" title="Estaçao de Tratamento de Água"><img src="img/icone_infraestrutura_estacao_tratamento_de_agua.png" /></a></li>
                <li><a href="hospital" rel="tooltip" title="Hospital"><img src="img/icone_infraestrutura_hospital.png" /></a></li>
                <li><a href="industria" rel="tooltip" title="Indústria"><img src="img/icone_infraestrutura_industria.png" /></a></li>
                <li><a href="industria-de-reciclagem-de-lixo" rel="tooltip" title="Indùstria de Reciclagem de Lixo"><img src="img/icone_infraestrutura_industria_de_reciclagem_de_lixo.png" /></a></li>
                <li><a href="parque-ecologico" rel="tooltip" title="Parque Ecológico"><img src="img/icone_infraestrutura_parque_ecologico.png" /></a></li>
                <li><a href="posto-de-saude" rel="tooltip" title="Posto de Saúde"><img src="img/icone_infraestrutura_postodesaude.png" /></a></li>
                <li><a href="termo-eletrica" rel="tooltip" title="Termoelétrica"><img src="img/icone_infraestrutura_termoeletrica.png" /></a></li>
                <li><a href="usina-eolica" rel="tooltip" title="Usina Eólica"><img src="img/icone_infraestrutura_usina_eolica.png" /></a></li>
              </ul>
            </div>

            <div role="tabpanel" class="tab-pane" id="tabs5">
              <ul class="lista">
                <li><a href="estadio-de-futibol" rel="tooltip" title="Estádio de Futebol"><img src="img/icone_lazer_estadiofutebol.png" /></a></li>
                <li><a href="restaurante-luxo" rel="tooltip" title="Restaurante de Luxo"><img src="img/icone_lazer_restauranteluxo.png" /></a></li>
                <li><a href="restaurante-simples" rel="tooltip" title="Restaurante Simples"><img src="img/icone_lazer_restaurantesimples.png" /></a></li>
                <li><a href="sorveteria" rel="tooltip" title="Sorveteria"><img src="img/icone_lazer_sorveteria.png" /></a></li>
              </ul>
            </div>

            <div role="tabpanel" class="tab-pane" id="tabs6">
              <ul class="lista">
                <li><a href="modelo-01" rel="tooltip" title="Modelo 01"><img src="img/icone_configuracoes.png" /></a></li>
                <li><a href="modelo-02" rel="tooltip" title="Modelo 02"><img src="img/icone_configuracoes.png" /></a></li>
                <li><a href="modelo-03" rel="tooltip" title="Modelo 03"><img src="img/icone_configuracoes.png" /></a></li>
                <li><a href="modelo-04" rel="tooltip" title="Modelo 04"><img src="img/icone_configuracoes.png" /></a></li>
                <li><a href="modelo-05" rel="tooltip" title="Modelo 05"><img src="img/icone_configuracoes.png" /></a></li>
                <li><a href="modelo-06" rel="tooltip" title="Modelo 06"><img src="img/icone_configuracoes.png" /></a></li>
                <li><a href="modelo-07" rel="tooltip" title="Modelo 07"><img src="img/icone_configuracoes.png" /></a></li>
                <li><a href="modelo-08" rel="tooltip" title="Modelo 08"><img src="img/icone_configuracoes.png" /></a></li>
                <li><a href="modelo-09" rel="tooltip" title="Modelo 09"><img src="img/icone_configuracoes.png" /></a></li>
              </ul>
            </div>
            
          </div>
        </div>
      </div>
    </div>

  </body>

</html>
