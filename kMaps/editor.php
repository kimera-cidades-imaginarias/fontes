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
      <script src="js/jquery.md5.js" type="text/javascript"></script>
      <script src="https://maps.googleapis.com/maps/api/js?v=3.exp&signed_in=true"></script>

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

      <!-- maps -->
        <script type="text/javascript">
         
          var map;
          var markers = [];
          var distances = [];
          var cursor = null;

          var myMapOptions = {
            latitude: "",
            longitude: "",
            zoom: "",
            tilt: ""
          };

          function initialize() {
            var mapCanvas = document.getElementById('map');
            var mapOptions = {

              mapTypeId: google.maps.MapTypeId.TERRAIN,
              center: new google.maps.LatLng(0, 0),
              zoom: 18,
              tilt: 45,

              panControl: true,
              zoomControl: false,
              mapTypeControl: true,
              scaleControl: false,
              streetViewControl: true,
              overviewMapControl: true

            }

            //map
            map = new google.maps.Map(mapCanvas, mapOptions)

            //listners
            google.maps.event.addListener(map, 'click', function(event) { 
              addMarker(event.latLng, map); 
            });

          }

          function loadKmlLayer(file, map) {
            
            //create placemark
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

            //creat kml layer
            /*
            var kmlLayer = new google.maps.KmlLayer({
              url: 'https://kimera4.websiteseguro.com/kmaps/kml/'+file+'?rnd'+Math.random(),
              map: map,
              preserveViewport: false,
              draggable:true
            });
            */

          }

          function processKML(data) {
            //placemark
            $(data).find("Placemark").each(function(index, value){
                var name = $(this).find("name").text() ;
                var coordinates = $(this).find("coordinates").text().split(","); 
                var styleUrl = $(this).find("styleUrl").text();

                var icon = $(data).find(styleUrl).text();
                icon = icon.substring(icon.indexOf("<href>")+6, icon.indexOf("</href>"));

                var longitude = coordinates[0] ;
                var latitude = coordinates[1] ;

                if(name && longitude && latitude){
                  var marker = new google.maps.Marker({
                    position: new google.maps.LatLng(latitude, longitude),
                    title: name,
                    icon: icon,
                    map: map, 
                    draggable:true
                  });

                  markers.push(marker);

                  populateList();
                }
            })

            //camera
            $(data).find("Camera").each(function(index, value){
              var longitude = $(this).find("longitude").text() ;
              var latitude = $(this).find("latitude").text() ;
              var tilt = parseInt($(this).find("tilt").text()) ;

              if(longitude && latitude && tilt){
                //set
                map.setCenter( new google.maps.LatLng(latitude, longitude));
                map.setZoom(18);
                map.setTilt(tilt);

                //save
                myMapOptions["latitude"] = latitude;
                myMapOptions["longitude"] = longitude;
                myMapOptions["zoom"] = 18;
                myMapOptions["tilt"] = tilt;
              }
            })

          }

          function saveKML(){
            var kmlFile = "";

            //markers
            for (var i = 0; i < markers.length; i++) {
              kmlFile += '<Style id="icon'+i+'">';
                kmlFile += '<IconStyle>';
                  kmlFile += '<Icon>';
                    kmlFile += "<href>"+markers[i].getIcon()+"</href>";
                  kmlFile += '</Icon>';
                kmlFile += '</IconStyle>';
              kmlFile += '</Style>';

              kmlFile += '<Placemark>';
                kmlFile += '<name>'+markers[i].getTitle()+'</name>';
                kmlFile += '<styleUrl>#icon'+i+'</styleUrl>';
                kmlFile += '<Point>';
                  kmlFile += '<coordinates>'+markers[i].position.lng()+','+markers[i].position.lat()+',0</coordinates>';
                kmlFile += '</Point>';                
              kmlFile += '</Placemark>';
            }

            //camera
            kmlFile += '<Camera>';
              kmlFile += '<longitude>'+myMapOptions["longitude"]+'</longitude>';
              kmlFile += '<latitude>'+myMapOptions["latitude"]+'</latitude>';
              kmlFile += '<tilt>'+myMapOptions["tilt"]+'</tilt>';
            kmlFile += '</Camera>';

            //save
            var kml = "<Document>"+kmlFile+"</Document>"; 

            <?php if(isset($_REQUEST['arquivo'])){ ?>
              var nome = "<?php echo substr($_REQUEST['arquivo'], 0, -4); ?>";
            <?php } else { ?>
              var nome = "" + myMapOptions["longitude"] + myMapOptions["latitude"] + "-<?php echo date('d-m-Y-H-i-s'); ?>";
            <?php } ?>

            $.ajax(
            {
                type: 'POST',
                url: 'action/creat.php',
                data: { data: kml, name: nome  }
            }).done(function(data) {
              $("#info").html('<br /><div class="alert alert-success">Arquivo salvo com sucesso, você pode acessá-lo na listagem de mapas clicando <a href="index.php?tab=carregarMapa">aqui.</a></div>');
            });
          }

          function loadAdressLayer(adress, map){
            var geocoder = new google.maps.Geocoder();

            geocoder.geocode( { 'address': adress}, function(results, status) {
              if (status == google.maps.GeocoderStatus.OK) 
              {
                //set
                map.setCenter( new google.maps.LatLng(results[0].geometry.location.lat(), results[0].geometry.location.lng()));
                map.setZoom(18);
                map.setTilt(45);

                //save
                myMapOptions["latitude"] = results[0].geometry.location.lat();
                myMapOptions["longitude"] = results[0].geometry.location.lng();
                myMapOptions["zoom"] = 18;
                myMapOptions["tilt"] = 45;
              }
            });
          }

          function addMarker(location, map) {
            if(cursor != null)
            {
              if(cursor["img"] == "ponto"){
                
                var marker = new google.maps.Marker({
                  position: location,
                  title: cursor["title"],
                  animation: google.maps.Animation.DROP,
                  icon: 'https://kimera4.websiteseguro.com/kmaps/img/ponto.png', //endereco completo
                  map: map
                });

                distances.push(marker);
                map.panTo(location);

                if(distances.length == 2){
                  setTimeout(function(){
                    alert("Distancia entre os pontos: " + Math.floor(getDistance(distances[0].position, distances[1].position)) + "m" );

                    distances[0].setMap(null);
                    distances[1].setMap(null);

                    distances.length = 0;
                    cursor = null;
                  }, 1000);
                  
                }
                                
              } else {

                if( coliderMarkerCheck(location) == true ){
                  var marker = new google.maps.Marker({
                    position: location,
                    title: cursor["title"],
                    draggable:true,
                    animation: google.maps.Animation.DROP,
                    icon: 'https://kimera4.websiteseguro.com/kmaps/img/' + cursor["img"] + '.png', //endereco completo
                    map: map
                  });

                  markers.push(marker);
                  map.panTo(location);
                  
                  cursor = null;

                  populateList();
                } else {
                  alert("Você não pode inserir uma construção aqui!");
                }

              }
            }
          }

          function coliderMarkerCheck(location){
            if(markers.length == 0){
              return true;
            } else {
              var ltemp = 0;
              
              for (var i = 0; i < markers.length; i++) {

                if(ltemp == 0){
                  ltemp = Math.floor(getDistance(location, markers[i].position));
                }

                if(Math.floor(getDistance(location, markers[i].position)) < ltemp){
                  ltemp = Math.floor(getDistance(location, markers[i].position));
                }

              }

              if(ltemp >= 100){
                return true;
              }

              return false;
            }
          }

          function rad(x) {
            return x * Math.PI / 180;
          }

          function getDistance(p1, p2) {
            var R = 6378137; // Earth’s mean radius in meter
            
            var dLat = rad(p2.lat() - p1.lat());
            var dLong = rad(p2.lng() - p1.lng());
            
            var a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
              Math.cos(rad(p1.lat())) * Math.cos(rad(p2.lat())) *
              Math.sin(dLong / 2) * Math.sin(dLong / 2);
            var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
            var d = R * c;

            return d; // returns the distance in meter
          };

          function focusMarker(index){
            var location = markers[index].getPosition();

            map.panTo(location);
          }

          function removeMarker(index){
            markers[index].setMap(null);

            markers.splice(index, 1);
            populateList();
          }

          function setAllMap(map) {
            for (var i = 0; i < markers.length; i++) {
              markers[i].setMap(map);
            }
          }

          function populateList() {
            $("#construcoes").html('');

            for (var i = 0; i < markers.length; i++) {
              $("#construcoes").append( '<li><a href="javascript:removeMarker('+i+')"><img src="img/icone-delete.png" /></a> <a href="javascript:focusMarker('+i+')">' + markers[i].getTitle() + '</a></li>');
            }
          }

          google.maps.event.addDomListener(window, 'load', initialize);

        </script>

    <!-- simulador -->
        <script type="text/javascript">
            
          //get adress
            <?php if(isset($_REQUEST['endereco'])){   
              echo "
              google.maps.event.addDomListener(window, 'load', function () 
              {
                loadAdressLayer('".$_REQUEST['endereco']."',map);
              });
              ";
            } ?>

          //load constructions
            <?php if(isset($_REQUEST['arquivo'])){ 
              echo "
              google.maps.event.addDomListener(window, 'load', function () 
              {
                loadKmlLayer('".$_REQUEST['arquivo']."',map);
              });
              ";
            } ?>

          //jquery
            $(document).ready( function() 
            {

              //edificacoes
              $( ".lista a" ).click(function(e) {
                cursor = { 
                  img: $(this).attr('href'), 
                  title: $(this).attr('data-original-title')
                };  

                return false;
              });

              //salvar
              $( "#salvar" ).click(function(e) {
                saveKML();

                return false;
              });

              //inicial
              $( ".inicial" ).click(function(e) {
                  var r = confirm("Você pode perder o conteúdo criado, deseja salvar suas construções antes de sair?");
                  
                  if (r == true) {
                    saveKML();
                  } else {
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
              <li role="presentation"><a href="#tabs6" role="tab" data-toggle="tab"><img width="30" src="img/icone_configuracoes.png" /> Ferramentas</a></li>
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
                <li><a href="ponto" rel="tooltip" title="Medir Distâncias"><img src="img/icone_ponto.png" /></a></li>
              </ul>
            </div>
            
          </div>
        </div>
      </div>
    </div>

  </body>

</html>
