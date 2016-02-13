<?php

  /*
  * Tratamento de Strings
  */
  function is_utf8($string)
  {
    return preg_match('%^(?:
      [\x09\x0A\x0D\x20-\x7E] |
      [\xC2-\xDF][\x80-\xBF] |
      \xE0[\xA0-\xBF][\x80-\xBF] |
      [\xE1-\xEC\xEE\xEF][\x80-\xBF]{2} |
      \xED[\x80-\x9F][\x80-\xBF] |
      \xF0[\x90-\xBF][\x80-\xBF]{2} |
      [\xF1-\xF3][\x80-\xBF]{3} |
      \xF4[\x80-\x8F][\x80-\xBF]{2})*$%xs', $string);
  }
  function remove_diacritics($string)
  {
    return preg_replace(array(
        '/\xc3[\x80-\x85]/',  // upper case
        '/\xc3\x87/',
        '/\xc3[\x88-\x8b]/',
        '/\xc3[\x8c-\x8f]/',
        '/\xc3([\x92-\x96]|\x98)/',
        '/\xc3[\x99-\x9c]/',
        '/\xc3[\xa0-\xa5]/',  // lower case
        '/\xc3\xa7/',
        '/\xc3[\xa8-\xab]/',
        '/\xc3[\xac-\xaf]/',
        '/\xc3([\xb2-\xb6]|\xb8)/',
        '/\xc3[\xb9-\xbc]/'
      ), str_split('ACEIOUaceiou', 1), is_utf8($string) ? $string : utf8_encode($string));
  }
  function removerCaracter($string, $slug = '-'){
    $string = remove_diacritics($string);
    $string = preg_replace(array(
        '/[^A-Za-z0-9]/',
        '/' . $slug . '{2,}/'
      ), $slug, $string);
    $string = trim($string, $slug);

    return strlen($string) ? $string : $slug;
  }
  
?>

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
      <script src="js/jquery-ui.min.js" type="text/javascript"></script>
      <script>
        $.widget.bridge('uibutton', $.ui.button);
        $.widget.bridge('uitooltip', $.ui.tooltip);
      </script>
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
          var routes = [];
          var area = [];
          var cursor = null;
          var iconTemp = null;
          var zoomLevel = 0;
          var locationTemp = null;
          var my_timer = null;

          var isDrag = false;
          var myGlobalPos = null;

          var directionsService = new google.maps.DirectionsService();
          var directionsDisplay = new google.maps.DirectionsRenderer();

          var nomeCidade = "";

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
              rotateControl: false,

              panControl: true,
              zoomControl: true,
              mapTypeControl: true,
              scaleControl: false,
              streetViewControl: true,
              overviewMapControl: true

            }

            //map
            map = new google.maps.Map(mapCanvas, mapOptions);

            //listners
            google.maps.event.addListener(map, 'click', function(event) { 
              myGlobalPos = event.latLng; 

              addMarker(myGlobalPos, map); 

              //$('.panelFerramentas').html(myGlobalPos.lat() + " : " + myGlobalPos.lng());  
            });

            google.maps.event.addListener(map, 'mousemove', function(event) { 
                myGlobalPos = event.latLng; 

                //$('.panelFerramentas').html(myGlobalPos.lat() + " : " + myGlobalPos.lng());        
            });

            google.maps.event.addListener(map, 'zoom_changed', function() {
              zoomLevel = map.getZoom();

              resizeAllMarkers(map);
            }); 

            zoomLevel = map.getZoom();

            //prof. daniel
            $( "#help .balao" ).html("Agora é com você!<br /> Use sua criatividade para modificar o mapa, <br />adicionando novas construções e explorando<br /> as ferramentas de geolocalização.");
            $( "#help" ).fadeIn( 400 );

            my_timer = setTimeout(function () {
                $( "#help" ).fadeOut( 400 );
            }, 6000);

            //map.setTilt(45);
            //map.setHeading(90);
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
              url: 'https://kimera4.websiteseguro.com/kAgora/kml/'+file+'?rnd'+Math.random(),
              map: map,
              preserveViewport: false,
              draggable:true
            });
            */

          }

          function processKML(data) {
            //nome da cidade
            $(data).find("Cidade").each(function(index, value){
              nomeCidade = $(this).text() ;
              $('.nomeCidade').html("("+nomeCidade+")");
            });
            
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
                  var image = {
                    url: icon,
                    size: new google.maps.Size(150, 90),
                    origin: new google.maps.Point(0,0),
                    anchor: new google.maps.Point(0, 0),
                    scaledSize: new google.maps.Size(100, 100)
                  };

                  var marker = new google.maps.Marker({
                    position: new google.maps.LatLng(latitude, longitude),
                    title: name,
                    icon: image,
                    map: map, 
                    draggable:true
                  });

                  markers.push(marker);

                  //colider move check
                  google.maps.event.addListener(marker, 'mousedown', function() {
                    locationTemp = marker.position;
                  });

                  google.maps.event.addListener(marker, 'mouseup', function() {
                      if(markers.length > 1){
                        if( coliderMarkerCheck(marker.position, false, marker) != true ){
                          alert("Duas constru\u00e7\u00f5es n\u00e3o podem ocupar o mesmo espa\u00e7o\u0021");

                          marker.setPosition(locationTemp);
                          locationTemp = null;
                        }
                      }

                      locationTemp = null;
                  });

                  populateList();
                }
            });

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
                    kmlFile += "<href>"+markers[i].getIcon().url+"</href>";
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
              var cidade = nomeCidade;
            <?php } else { ?>
              var nome = "<?php echo removerCaracter($_REQUEST['nome']); ?>-<?php echo date('d-m-Y-H-i-s'); ?>";
              var cidade = "<?php echo $_REQUEST['nome']; ?>";
            <?php } ?>

            $.ajax(
            {
                type: 'POST',
                url: 'action/creat.php',
                data: { data: kml, name: nome, cidade: cidade  }
            }).done(function(data) {
              //alert(data);
              var item = $('<br /><div class="alert alert-success">Arquivo salvo com sucesso, você pode acessá-lo na listagem de mapas através da aba Carregar Mapa na página inicial.</div>').delay( 12000 ).fadeOut( 400 );
              $("#info").append(item);
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
              iconTemp.fadeTo( "fast", 1 );

              //ROTA
              if(cursor["img"] == "rota"){
                var marker = new google.maps.Marker({
                  position: location,
                  title: cursor["title"],
                  animation: google.maps.Animation.DROP,
                  icon: 'https://kimera4.websiteseguro.com/kAgora/img/ponto.png', //endereco completo
                  map: map
                });

                routes.push(marker);
                map.panTo(location);

                if(routes.length == 2){
                  directionsDisplay.setMap(map);
                  cursor = null;

                  var start =  new google.maps.LatLng(routes[0].position.lat(), routes[0].position.lng());
                  var end =  new google.maps.LatLng(routes[1].position.lat(), routes[1].position.lng());

                  var request = {
                    origin:start,
                    destination:end,
                    travelMode: google.maps.TravelMode.DRIVING
                  };

                  directionsService.route(request, function(result, status) {
                    if (status == google.maps.DirectionsStatus.OK) {
                      directionsDisplay.setDirections(result);

                      var route = result.routes[0];

                      setTimeout(function(){
                        alert("Dist\u00e2ncia entre os pontos seguindo a rota escolhida\u003a " + route.legs[0].distance.text );

                        routes[0].setMap(null);
                        routes[1].setMap(null);

                        routes.length = 0;
                        cursor = null;
                        directionsDisplay.setMap(null);
                      }, 1000);
                    }
                  });      
                }          
              }

              //AREA
              else if(cursor["img"] == "area"){
                var marker = new google.maps.Marker({
                  position: location,
                  title: cursor["title"],
                  animation: google.maps.Animation.DROP,
                  icon: 'https://kimera4.websiteseguro.com/kAgora/img/ponto.png', //endereco completo
                  map: map
                });

                area.push(marker);
                map.panTo(location);

                if(area.length == 4){
                  cursor = null;

                  setTimeout(function()
                  {
                    var base1 = Math.floor(getDistance(area[0].position, area[1].position));
                    var altura1 = Math.floor(getDistance(area[1].position, area[2].position));
                    var areaTerreno1 = Math.floor((base1*altura1)/2);

                    var base2 = Math.floor(getDistance(area[2].position, area[3].position));
                    var altura2 = Math.floor(getDistance(area[3].position, area[0].position));
                    var areaTerreno2 = Math.floor((base2*altura2)/2);

                    var areaTerreno = areaTerreno1 + areaTerreno2;

                    alert("Área total de: " + areaTerreno + " m²" );

                    area[0].setMap(null);
                    area[1].setMap(null);
                    area[2].setMap(null);
                    area[3].setMap(null);

                    area.length = 0;
                    cursor = null;

                  }, 1000);
                   
                }          
              }

              //COORDENADA
              else if(cursor["img"] == "coordenada"){
                var marker = new google.maps.Marker({
                  position: location,
                  title: cursor["title"],
                  animation: google.maps.Animation.DROP,
                  icon: 'https://kimera4.websiteseguro.com/kAgora/img/ponto.png', //endereco completo
                  map: map
                });

                map.panTo(location);

                setTimeout(function(){
                  var mylat = location.lat() + "";
                  var mylng = location.lng() + "";
                  alert( "Coordenadas do ponto:  Latitude: " + mylat.substr(0, 7) + " , Longitude:" + mylng.substr(0, 7) );

                  marker.setMap(null);

                  cursor = null;
                }, 1000);
              }

              //PONTO
              else if(cursor["img"] == "ponto"){
                var marker = new google.maps.Marker({
                  position: location,
                  title: cursor["title"],
                  animation: google.maps.Animation.DROP,
                  icon: 'https://kimera4.websiteseguro.com/kAgora/img/ponto.png', //endereco completo
                  map: map
                });

                distances.push(marker);
                map.panTo(location);

                if(distances.length == 2){
                  cursor = null;

                  var flightPlanCoordinates = [
                    new google.maps.LatLng(distances[0].position.lat(), distances[0].position.lng()),
                    new google.maps.LatLng(distances[1].position.lat(), distances[1].position.lng())
                  ];

                  var flightPath = new google.maps.Polyline({
                    path: flightPlanCoordinates,
                    geodesic: true,
                    strokeColor: '#2D568A',
                    strokeOpacity: 1.0,
                    strokeWeight: 2
                  });

                  flightPath.setMap(map);

                  setTimeout(function(){
                    alert("Dist\u00e2ncia entre os pontos\u003a " + Math.floor(getDistance(distances[0].position, distances[1].position)) + "m" );

                    distances[0].setMap(null);
                    distances[1].setMap(null);
                    flightPath.setMap(null);

                    distances.length = 0;
                    cursor = null;
                  }, 1000);
                  
                }
              
              //CONSTRUCAO                  
              } else {

                if( coliderMarkerCheck(location, true, null) == true ){
                  var image = {
                    url: 'https://kimera4.websiteseguro.com/kAgora/img/' + cursor["img"] + '.png',
                    size: new google.maps.Size(150, 90),
                    origin: new google.maps.Point(0,0),
                    anchor: new google.maps.Point(0, 0),
                    scaledSize: new google.maps.Size(100, 100)
                  };

                  var marker = new google.maps.Marker({
                    position: location,
                    title: cursor["title"],
                    draggable:true,
                    animation: google.maps.Animation.DROP,
                    //icon: 'https://kimera4.websiteseguro.com/kAgora/img/' + cursor["img"] + '.png', //endereco completo
                    icon: image,
                    map: map
                  });

                  markers.push(marker);
                  map.panTo(location);
                  
                  cursor = null;

                  //colider move check
                  google.maps.event.addListener(marker, 'mousedown', function() {
                    locationTemp = marker.position;
                  });

                  google.maps.event.addListener(marker, 'mouseup', function() {
                      if(markers.length > 1){
                        if( coliderMarkerCheck(marker.position, false, marker) != true ){
                          alert("Duas constru\u00e7\u00f5es n\u00e3o podem ocupar o mesmo espa\u00e7o\u0021");

                          marker.setPosition(locationTemp);
                          locationTemp = null;
                        }
                      }

                      locationTemp = null;
                  });

                  populateList();
                } else {
                  alert("Duas constru\u00e7\u00f5es n\u00e3o podem ocupar o mesmo espa\u00e7o\u0021");
                }

              }
            }
          }

          function coliderMarkerCheck(location, lastElement, obj){
            var ltemp = 0;
            var mtemp = null;

            if(markers.length == 0){
              return true;
            } else {
                            
              var t = markers.length;
              
              for (var i = 0; i < t; i++) {

                if( obj != null ){
                 
                 if(obj != markers[i]){
                    //alert(Math.floor(getDistance(location, markers[i].position)));

                    if(ltemp == 0){
                      mtemp = markers[i];
                      ltemp = Math.floor(getDistance(location, markers[i].position));

                       //alert("f: " +ltemp);
                    }

                    else if(Math.floor(getDistance(location, markers[i].position)) <= ltemp){
                      mtemp = markers[i];
                      ltemp = Math.floor(getDistance(location, markers[i].position));

                      //alert("s: " +ltemp);
                    }
                  }

                } else  {
                  if(ltemp == 0){
                    mtemp = markers[i];
                    ltemp = Math.floor(getDistance(location, markers[i].position));

                     //alert("f: " +ltemp);
                  }

                  else if(Math.floor(getDistance(location, markers[i].position)) <= ltemp){
                    mtemp = markers[i];
                    ltemp = Math.floor(getDistance(location, markers[i].position));

                    //alert("s: " +ltemp);
                  }
                }
              }
                    
              /*       
              var flightPlanCoordinates = [
                new google.maps.LatLng(location.lat(), location.lng()),
                new google.maps.LatLng(mtemp.position.lat(), mtemp.position.lng())
              ];

              var flightPath = new google.maps.Polyline({
                path: flightPlanCoordinates,
                geodesic: true,
                strokeColor: '#FF0000',
                strokeOpacity: 1.0,
                strokeWeight: 2
              });

              flightPath.setMap(map);

              setTimeout(function(){
                flightPath.setMap(null);
              }, 1000);
              */
      
              if(ltemp >= (80 / zoomLevel) * 10){
                return true;
              } else {
                return false;
              }
              
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
            var r = confirm("Voce tem certeza que deseja remover esta construção?");
                  
            if (r == true) {
              markers[index].setMap(null);

              markers.splice(index, 1);
              populateList();
            } 
          }

          function editMarker(index){
            $("#construcoes").html("");
            $("#construcoes").before('<form id="editMarker" action="#"><input type="text" id="nameMarker" value="'+markers[index].getTitle()+'" /> <br /> <input type="submit" class="btn btn-primary" value="Salvar" /> </form>');
            
            $("#editMarker").submit(function(e){
                e.preventDefault();

                markers[index].setTitle($("#nameMarker").val()); 

                $( "#editMarker" ).remove();
                populateList();

                return false;
            });
            //populateList();
          }

          function setAllMap(map) {
            for (var i = 0; i < markers.length; i++) {
              markers[i].setMap(map);
            }
          }

          function resizeAllMarkers(map) {
            for (var i = 0; i < markers.length; i++) {

              if(zoomLevel < 17){
                markers[i].getIcon().scaledSize = new google.maps.Size(zoomLevel, zoomLevel);
               markers[i].setMap(map);
              }
              else
              {
                markers[i].getIcon().scaledSize = new google.maps.Size(4*zoomLevel, 4*zoomLevel);
               markers[i].setMap(map);
              }
             
            }
          }

          function populateList() {
            $("#construcoes").html('');

            for (var i = 0; i < markers.length; i++) {
              $("#construcoes").append( '<li><a href="javascript:editMarker('+i+')"><img src="img/icone-editar.png" /></a> <a href="javascript:removeMarker('+i+')"><img src="img/icone-delete.png" /></a> <a href="javascript:focusMarker('+i+')">' + markers[i].getTitle() + '</a></li>');
            }
          }

          google.maps.event.addDomListener(window, 'load', initialize);

        </script>

    <!-- simulador -->
        <script type="text/javascript">
            
          //get adress
            <?php if(isset($_REQUEST['endereco']) && isset($_REQUEST['nome'])){  
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

              //drag
              myDrager();

              //edificacoes
              $( ".lista a" ).click(function(e) {
                if(iconTemp != null){
                  iconTemp.fadeTo( "fast", 1 );
                }

                iconTemp = $( this );
                iconTemp.fadeTo( "fast", 0.5 );

                cursor = { 
                  img: $(this).attr('href'), 
                  title: $(this).attr('data-original-title')
                };  

                //help
                  if( $(this).attr('href') == "area" ){
                    $( "#help .balao" ).html("Aplique 4 pontos no mapa para <br />calcular a área do terreno.");
                    $( "#help" ).fadeIn( 400 );

                    my_timer = setTimeout(function () {
                        $( "#help" ).fadeOut( 400 );
                    }, 6000);
                  }

                  if( $(this).attr('href') == "ponto" ){
                    $( "#help .balao" ).html("Aplique 2 pontos no mapa para <br />medir a distância entre eles.");
                    $( "#help" ).fadeIn( 400 );

                    my_timer = setTimeout(function () {
                        $( "#help" ).fadeOut( 400 );
                    }, 6000);
                  }

                  if( $(this).attr('href') == "coordenada" ){
                    $( "#help .balao" ).html("Aplique um ponto na tela para <br />saber a coordenada do local.");
                    $( "#help" ).fadeIn( 400 );

                    my_timer = setTimeout(function () {
                        $( "#help" ).fadeOut( 400 );
                    }, 6000);
                  }

                  if( $(this).attr('href') == "rota" ){
                    $( "#help .balao" ).html("Aplique 2 pontos no mapa para <br />medir a distância entre a <br />rota demarcada.");
                    $( "#help" ).fadeIn( 400 );

                    my_timer = setTimeout(function () {
                        $( "#help" ).fadeOut( 400 );
                    }, 6000);
                  }

                return false;
              });

              //auto save
              time =1;

              setInterval( function() {
                  
                  time++;
                  
                  $('#time').html(time);
                  
                  if (time % 300 == 0) {
                     saveKML();
                  }    
                  
                  
              }, 1000 );

              //salvar
              $( "#salvar" ).click(function(e) {
                saveKML();

                return false;
              });

              //ajuda
              $( "#closeHelp" ).click(function(e) {
                $( "#help" ).fadeOut( 400 );
                clearTimeout(my_timer);

                return false;
              });

              //inicial
              $( ".inicial" ).click(function(e) {
                  var r = confirm("Todas as alterações não salvas serão perdidas, deseja mesmo sair para a Página Inicial?");
                  
                  if (r == true) {
                    window.location.assign("index.php?tab=novoMapa")
                  } 

                  return false;
              });
          });

          function myDrager() {
            $('.lista a').draggable( {
              cursor: 'move',
              containment: 'document',
              start: handleDragStart,
              stop: handleDragStop,
              helper: myHelper
            } );

            $('#map').droppable( {
              drop: handleDropEvent
            } );
          }

          function myHelper( event ) {
            if( $(this).attr('href') == "rota" || $(this).attr('href') == "area" || $(this).attr('href') == "ponto" || $(this).attr('href') == "coordenada" )
            {
              return null;
            }
            else{
              return '<div id="draggableHelper"><img src="https://kimera4.websiteseguro.com/kAgora/img/' + $(this).attr('href') + '.png" width="100" /></div>';
            }
          }

          function handleDragStart( event, ui ) {
            //alert($(this).attr('href'));
            if( $(this).attr('href') == "rota" || $(this).attr('href') == "area" || $(this).attr('href') == "ponto" || $(this).attr('href') == "coordenada" )
            {
              isDrag = false;
            }
            else
            {
              isDrag = true;


              if(iconTemp != null){
                iconTemp.fadeTo( "fast", 1 );
              }

              iconTemp = $( this );
              iconTemp.fadeTo( "fast", 0.5 );

              cursor = { 
                img: $(this).attr('href'), 
                title: $(this).attr('data-original-title')
              };
            }

           
          }

          function handleDragStop( event, ui ) {
            //var offsetXPos = parseInt( ui.offset.left );
            //var offsetYPos = parseInt( ui.offset.top );
            //alert( "Drag stopped!\n\nOffset: (" + offsetXPos + ", " + offsetYPos + ")\n");

            iconTemp.fadeTo( "fast", 1 );            
          }

          function handleDropEvent( event, ui ) {
            var draggable = ui.draggable;
            //alert( 'The square with ID "' + draggable.attr('id') + '" was dropped onto me!' );

            if(isDrag){
              //add marker
              //addMarker(myGlobalPos, map);

              setTimeout(function() { teste() },200)

              
              isDrag = false;
            }

            function teste()
            {
              addMarker(myGlobalPos, map);
            }
          }


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
