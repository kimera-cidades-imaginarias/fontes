<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

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
      <link href="css/ol.css" rel="stylesheet" type="text/css" media="screen">
      <link href="css/ol3-popup.css" rel="stylesheet" type="text/css" media="screen"/>

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
      <script src="js/ol.js" type="text/javascript"></script>
      <script src="js/ol3-popup.js" type="text/javascript"></script>
      <script src="https://maps.googleapis.com/maps/api/js?v=3.exp&signed_in=true"></script>

      <!-- tabs -->
        <script type="text/javascript">

          $(function () 
          {
            $('.nav-pills a').click(function (e) 
            {
              e.preventDefault();
              $(this).tab('show')
            });

            $('.nav-pills a:first').tab('show');

            $('.tab-content a').tooltip();
            $('.panelFerramentas a').tooltip();
            

            //$(".alert").alert('close')
          })

        </script>

      <!-- maps -->
        <script type="text/javascript">
          
          var map = null;
          var panorama = null;

          var styles = [
            'Road',
            'Aerial',
            'AerialWithLabels',
            'collinsBart',
            'ordnanceSurvey'
          ];

          var popup = null;

          var construcoes = [];
          var points = [];
          var geoLetters = [];

          var zoom = 18;

          var nomeMapa = "";
          var coordenadasMapa = [0,0];
          var coordenadasMouse = [0,0];

          var mousePositionControl = null;

          var vectorSourceLayer = null;
          var vectorLineLayer = null;
          var vectorPolygonLayer = null;
          var vectorGeoLetterLayer = null;
          var layers = [];

          var cursor = null;
          var tool = null;
          var iconTemp = null;

          var lastPosition = null;

          var directionsService = new google.maps.DirectionsService();

          function creatSinglePointOnMap(ltd, lng)
          {
            var iconFeature = new ol.Feature({
              geometry: new ol.geom.Point([lng,ltd]),
              name: 'Ponto'
            });

            var iconStyle = new ol.style.Style({
              image: new ol.style.Icon( ({
                anchor: [0.5, 46],
                anchorXUnits: 'fraction',
                anchorYUnits: 'pixels',
                src: 'img/ponto.png',
                scale:0.5
              }))
            });

            iconFeature.setStyle(iconStyle);

            construcoes.push(iconFeature);
          }

          function createLineOnMap(points)
          {
            var featureLine = new ol.Feature({
              geometry: new ol.geom.LineString(points)
            });

            var vectorLine = new ol.source.Vector({});
            vectorLine.addFeature(featureLine);

            vectorLineLayer = new ol.layer.Vector({
                source: vectorLine,
                style: new ol.style.Style({
                    stroke: new ol.style.Stroke({ color: '#00FF00', width: 2 })
                })
            });

            map.addLayer(vectorLineLayer);
          }

          function createPolygonOnMap(points)
          {
            var featurePolygon = new ol.Feature({
              geometry: new ol.geom.Polygon([points])
            });

            var vectorPolygon = new ol.source.Vector({});
            vectorPolygon.addFeature(featurePolygon);

            vectorPolygonLayer = new ol.layer.Vector({
                source: vectorPolygon,
                style: new ol.style.Style({
                    stroke: new ol.style.Stroke({ color: '#00FF00', width: 2 })
                })
            });

            map.addLayer(vectorPolygonLayer);
          }

          function creatConstructionOnMap(nome, icone, ltd, lng)
          {
            //map
            var iconFeature = new ol.Feature({
              geometry: new ol.geom.Point([lng,ltd]),
              name: nome
            });

            var iconStyle = new ol.style.Style({
              image: new ol.style.Icon( ({
                anchor: [0.5, 46],
                anchorXUnits: 'fraction',
                anchorYUnits: 'pixels',
                src: icone,
                scale:0.65
              }))
            });

            iconFeature.setStyle(iconStyle);
            iconFeature.setId(construcoes.length + 1);

            construcoes.push(iconFeature);
          } 

          function creatGeoLetterOnMap(letter, ltd, lng)
          {
            var iconFeature = new ol.Feature({
              geometry: new ol.geom.Point([lng,ltd]),
              name: letter
            });

            var iconStyle = new ol.style.Style({
              image: new ol.style.Icon( ({
                anchor: [0.5, 46],
                anchorXUnits: 'fraction',
                anchorYUnits: 'pixels',
                src: 'img/geoCarta.png',
                scale:0.65
              }))
            });

            iconFeature.setStyle(iconStyle);

            geoLetters.push(iconFeature);
          }

          function updateMap()
          {
            map.removeLayer(vectorLineLayer);
            map.removeLayer(vectorPolygonLayer);
            map.removeLayer(vectorSourceLayer);

            //contruecoes
            var vectorSource = new ol.source.Vector({});

            vectorSourceLayer = new ol.layer.Vector({
              source: vectorSource
            });

            vectorSource.addFeatures(construcoes);
            vectorSource.addFeatures(geoLetters);

            //construcoes interaction
            for(var i=0; i<construcoes.length; i++)
            {
              var dragInteraction = new ol.interaction.Modify({
                  features: new ol.Collection([construcoes[i]]),
                  style: null,
                  pixelTolerance: 40
              });

              dragInteraction.on('modifystart',function(e)
              {
                lastPosition = e.features.getArray()[0].getGeometry().getCoordinates();
              },[construcoes[i]]);

              dragInteraction.on('modifyend',function(e)
              {
                if(tool == null)
                {
                  if(!coliderMarkerCheck(e.features.getArray()[0].getId(), coordenadasMouse[0], coordenadasMouse[1]))
                  {
                    alert("Duas constru\u00e7\u00f5es n\u00e3o podem ocupar o mesmo espa\u00e7o\u0021");

                    e.features.getArray()[0].getGeometry().setCoordinates(lastPosition);
                  }
                }

                lastPosition = null;
              },[construcoes[i]]);

              map.addInteraction(dragInteraction);
            } 

            //geoletter interraction
            for(var i=0; i<geoLetters.length; i++)
            {
              var dragInteraction = new ol.interaction.Modify({
                  features: new ol.Collection([geoLetters[i]]),
                  style: null,
                  pixelTolerance: 40
              });

              map.addInteraction(dragInteraction);
            } 

            var select_interaction = new ol.interaction.Select({condition: ol.events.condition.click});

            select_interaction.getFeatures().on("add", function (e) { 
              if(e.element.getStyle().getImage().getSrc() == 'img/geoCarta.png')
              {
                var geoFeature = e.element;
                var content = '<h4>Considerações sobre a localização:</h4>';
                    content += '<p>'+geoFeature.get('name')+'</p>';
                    content += '<hr />';
                    content += '<textarea id="myOpinion" placeholder="suas considerações aqui!"></textarea>';
                    content += '<br /><a href="#" id="editGeoLetter" class="btn btn-primary">Enviar</a>';
                  
                popup.show(geoFeature.getGeometry().getCoordinates(), content);

                $("#editGeoLetter").click(function(e)
                {
                    e.preventDefault();

                    var mop = geoFeature.get('name') + ' <br /> ' + $("#myOpinion").val();

                    geoFeature.set('name', mop); 

                    popup.hide();

                    return false;
                });
              }
            });

            map.addInteraction(select_interaction);

            map.addLayer(vectorSourceLayer);

            map.render();
          }

          function updateStreetView(lat, lng)
          {
            panorama = new google.maps.StreetViewPanorama(
              document.getElementById('streetView'),
              {
                position: 
                {
                  lat: Number(lat),
                  lng: Number(lng)
                },
                pov: { heading: 165, pitch: 0 },
                zoom: 1,
                visible: true
            });
          }

          function showStreetView()
          {
            $( "#streetView" ).show();
            $( "#streetView" ).before( '<a href="#" id="closeStreetView"><img src="img/close_icon.png" /></a>' );

            $( "#closeStreetView" ).click(function()
            { 
              hideStreetView(); 
              showMap(); 

              tool = null; 
              cursor = null; 
            });
          }

          function hideStreetView()
          {
            $( "#streetView" ).hide();
            $( "#closeStreetView" ).remove();
          }

          function showMap()
          {
            $( "#map" ).show();
          }

          function hideMap()
          {
            $( "#map" ).hide();
          }

          function showLetter()
          {
            $('#myModal').modal('show');

            $.ajax({
               type: "POST",
               url: "pages/home.php",
               
               success: function(data)
               {
                  $('#myModal #data').html(data);

                  return false;
               },
               error: function(xhr, textStatus, errorThrown) 
               {
                  return false;
               }
            });
          }

          function hideLetter()
          {
            $('#myModal').modal('hide');
          }

          function initializeAPI() 
          {     
            mousePositionControl = new ol.control.MousePosition({
              coordinateFormat:  function(coord) 
              {
                coordenadasMouse = [coord[1], coord[0]]; 
                return ol.coordinate.toStringXY(coordenadasMouse,4);
              },
              projection: 'EPSG:4326'
            });

            var vectorSource = new ol.source.Vector({});

            vectorSourceLayer = new ol.layer.Vector({
              source: vectorSource
            });

            vectorSource.addFeatures(construcoes);
            vectorSource.addFeatures(geoLetters);

            //layers
            var i, ii;
            for (i = 0, ii = styles.length; i < ii; ++i) {
              layers.push(new ol.layer.Tile({
                visible: false,
                preload: Infinity,
                source: new ol.source.BingMaps({
                  key: 'AneoK4q3ZeMobiXkwCaUbSDp4q7r8y6YX_Gn3t3U11sNCjRzrRUodMqwtnahX3Q2',
                  imagerySet: styles[i]
                }), vectorSourceLayer
              }));
            }

            //map
            map = new ol.Map({
              /*
              layers: [
                new ol.layer.Tile({
                  source: new ol.source.OSM()
                }), vectorSourceLayer
              ],
              */
              layers: layers,
              loadTilesWhileInteracting: true,
              target: 'map',
              controls: ol.control.defaults({
                attributionOptions:({
                  collapsible: false
                })
              }).extend([mousePositionControl]),
              view: new ol.View({
                projection: 'EPSG:4326',
                center: [coordenadasMapa[1], coordenadasMapa[0]],
                zoom:18
              })
            });

            popup = new ol.Overlay.Popup({insertFirst: false});
            map.addOverlay(popup);

            map.getView().on('propertychange', function(e) {
               switch (e.key) {
                  case 'resolution':
                    zoom = map.getView().getZoom();

                    recizeAllMakers();

                    break;
               }
            });

            //streetmap
            updateStreetView(coordenadasMapa[0], coordenadasMapa[1]);

            //load layer
            onChange();
          }

          //layer change
          function onChange(style = 'Road') {
            for (var i = 0, ii = layers.length; i < ii; ++i) {
              layers[i].setVisible(styles[i] === style);
            }
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

          function populateMarkerList(markers)
          {
            $("#construcoes").html('');

            for (var i = 0; i < markers.length; i++) 
            {
              $("#construcoes").append( '<li><a href="javascript:editMarker('+i+')" title="Renomear Construção" rel="tooltip"><img src="img/icone-editar.png" /></a> <a href="javascript:removeMarker('+i+')" title="Remover Construção" rel="tooltip"><img src="img/icone-delete.png" /></a> <a href="javascript:focusMarker('+i+', construcoes)">' + markers[i].get('name') + '</a></li>');
            }

            $('#construcoes li a').tooltip();
          }

          function populateGeoLetterList(geoletters)
          {
            $("#geocartas").html('');

            for (var i = 0; i < geoletters.length; i++) 
            {
              $("#geocartas").append( '<li><a href="javascript:removeGeoLetter('+i+')" title="Remover Carta Geolocalizada" rel="tooltip"><img src="img/icone-delete.png" /></a> <a href="javascript:focusMarker('+i+', geoLetters)">Carta Geolocalizada ' + i + '</a></li>');
            }

            $('#geoletters li a').tooltip();
          }

          function focusMarker(index, markers)
          {   
            map.setView(new ol.View({
              projection: 'EPSG:4326',
              center:  markers[index].getGeometry().getLastCoordinate(),
              zoom: 18
            }));
          }

          function removeMarker(index, auto = false)
          {
            if(auto == false)
            {
              var r = confirm("Voce tem certeza que deseja remover esta construção?");
            }

            if (r == true || auto == true) 
            {
              construcoes.splice(index, 1);
              populateMarkerList(construcoes);
              updateMap();
            } 
          }

          function removeGeoLetter(index, auto = false)
          {
             if(auto == false)
            {
              var r = confirm("Voce tem certeza que deseja remover esta carta geolocalizada?");
            }

            if (r == true || auto == true) 
            {
              geoLetters.splice(index, 1);
              populateGeoLetterList(geoLetters);
              updateMap();
            } 
          }

          function editMarker(index)
          {
            $("#construcoes").html("");
            $("#construcoes").before('<form id="editMarker" action="#"><input type="text" id="nameMarker" value="'+construcoes[index].get('name')+'" /> <br /> <input type="submit" class="btn btn-primary" value="Salvar" /> </form>');
            
            $("#editMarker").submit(function(e)
            {
                e.preventDefault();

                construcoes[index].set('name', $("#nameMarker").val()); 

                $( "#editMarker" ).remove();
                
                populateMarkerList(construcoes);

                return false;
            });
          }

          function recizeMaker(index)
          {
            var myZoom = zoom/18;
            construcoes[index].getStyle().getImage().setScale( myZoom - 0.5 );

            updateMap();
          }

          function recizeAllMakers()
          {
            for(var i=0; i<construcoes.length; i++)
            {
              recizeMaker(i);
            } 
          }

          function coliderMarkerCheck(id, lat, lng)
          {
            var t = construcoes.length;
            var ltemp = 0;

            if(t == 0)
            {
              return true;
            }
            else
            {
              for (var i = 0; i < t; i++) 
              {
                if( id == null || id != construcoes[i].getId() )
                {
                  var olg = ""+construcoes[i].getGeometry().getCoordinates();
                  var tlat = olg.substr(olg.indexOf(",")+1, olg.length);
                  var tlng = olg.substr(0, olg.indexOf(","));

                  if(ltemp == 0)
                  {
                    ltemp = Math.floor(getDistance(lat, lng, tlat, tlng));
                  }
                  else if(Math.floor(getDistance(lat, lng, tlat, tlng)) <= ltemp)
                  {
                    ltemp = Math.floor(getDistance(lat, lng, tlat, tlng));
                  }

                }
              }

              if(ltemp >= (80 / zoom) * 10)
              {
                return true;
              } 
              else 
              {
                return false;
              }
            }
          }

          function rad(x) 
          {
            return x * Math.PI / 180;
          }

          function getDistance(p1_lat, p1_lng, p2_lat, p2_lng) 
          {
            var R = 6378137; // Earth’s mean radius in meter
            
            var dLat = rad(p2_lat - p1_lat);
            var dLong = rad(p2_lng - p1_lng);
            
            var a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
              Math.cos(rad(p1_lat)) * Math.cos(rad(p2_lat)) *
              Math.sin(dLong / 2) * Math.sin(dLong / 2);
            var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
            var d = R * c;

            return d; // returns the distance in meter
          }

          function checkArea(ltd, lng)
          {
            tool = "area";

            if(points.length < 4)
            {
              creatSinglePointOnMap(ltd, lng);
              updateMap();

              points.push([lng, ltd]);
            }

            if(points.length == 4)
            {
              createPolygonOnMap(points);

              setTimeout(function()
              {
                var base1 = Math.floor(getDistance(points[0][1], points[0][0], points[1][1], points[1][0]));
                var altura1 = Math.floor(getDistance(points[1][1], points[1][0], points[2][1], points[2][0]));
                var areaTerreno1 = Math.floor((base1*altura1)/2);

                var base2 = Math.floor(getDistance(points[2][1], points[2][0], points[3][1], points[3][0]));
                var altura2 = Math.floor(getDistance(points[3][1], points[3][0], points[0][1], points[0][0]));
                var areaTerreno2 = Math.floor((base2*altura2)/2);

                var areaTerreno = areaTerreno1 + areaTerreno2;

                alert("Área total de: " + areaTerreno + " m²" );

                removeMarker(construcoes.length-1, true);
                removeMarker(construcoes.length-1, true);
                removeMarker(construcoes.length-1, true);
                removeMarker(construcoes.length-1, true);

                points = [];

                tool = null;
                cursor = null;
              }, 1000);
            }
          }

          function checkPoint(ltd, lng)
          {
            tool = "ponto";

            if(points.length < 2)
            {
              creatSinglePointOnMap(ltd, lng);
              updateMap();

              points.push([lng, ltd]);
            }

            if(points.length == 2)
            {
              createLineOnMap(points);

              setTimeout(function()
              {
                var distanciaEntrePontos = Math.floor(getDistance(points[0][1], points[0][0], points[1][1], points[1][0]));

                alert("Dist\u00e2ncia entre os pontos\u003a " + distanciaEntrePontos + "m" );

                removeMarker(construcoes.length-1, true);
                removeMarker(construcoes.length-1, true);

                points = [];

                tool = null;
                cursor = null;
              }, 1000);
            }
          }

          function checkCordenate(ltd, lng)
          {
            tool = "coordenada";

            creatSinglePointOnMap(ltd, lng);
            updateMap();

            setTimeout(function()
            {
              mltd = "" + ltd;
              mlgn = "" + lng;

              alert( "Coordenadas do ponto:  Latitude: " + mltd.substr(0, 7) + " , Longitude:" + mlgn.substr(0, 7) );

              removeMarker(construcoes.length-1, true);

              tool = null;
              cursor = null;
            }, 1000);
          }

          function checkRoute(ltd, lng)
          {
            tool = "rota";

            if(points.length < 2)
            {
              creatSinglePointOnMap(ltd, lng);
              updateMap();

              points.push([lng, ltd]);
            }

            if(points.length == 2)
            {
              var start =  new google.maps.LatLng(points[0][1], points[0][0]);
              var end =  new google.maps.LatLng(points[1][1], points[1][0]);

              var request = {
                origin:start,
                destination:end,
                travelMode: google.maps.TravelMode.DRIVING
              };

              directionsService.route(request, function(result, status) 
              {
                if (status == google.maps.DirectionsStatus.OK)
                {
                  var route = result.routes[0];

                  points = [];
                  for (var i = 0; i < route.legs[0].steps.length; i++) {
                    //alert(JSON.stringify(route.legs[0].steps[i].start_location));
                    points.push([route.legs[0].steps[i].start_location.lng(), route.legs[0].steps[i].start_location.lat()]);
                  }

                  //alert(JSON.stringify(points));
                  createLineOnMap(points);

                  setTimeout(function()
                  {
                    alert("Dist\u00e2ncia entre os pontos seguindo a rota escolhida\u003a " + route.legs[0].distance.text );

                    removeMarker(construcoes.length-1, true);
                    removeMarker(construcoes.length-1, true);

                    points = [];

                    tool = null;
                    cursor = null;
                  }, 1000);
                }
                else
                {
                  alert("Erro em obter rota!");

                  removeMarker(construcoes.length-1, true);
                  removeMarker(construcoes.length-1, true);

                  points = [];

                  tool = null;
                  cursor = null;
                }
              });
            }
          }

          function checkStreetView(ltd, lng)
          {
            tool = "streetView";

            hideMap();
            showStreetView();
            updateStreetView(ltd, lng)
          }

          function loadAdress(name, adress)
          {
            var geocoder = new google.maps.Geocoder();

            geocoder.geocode( { 'address': adress}, function(results, status) {
              if (status == google.maps.GeocoderStatus.OK) 
              {
                processAdress(name, results[0].geometry.location.lat(), results[0].geometry.location.lng());
              }
            });
          }

          function processAdress(name, lat, lng)
          {
            //map data
            nomeMapa = name;

            coordenadasMapa[0] = lat;
            coordenadasMapa[1] = lng;

            //api
            initializeAPI();

            //tutorial
            showProfDaniel();

            //show infos
            showMapaName(nomeMapa);

            populateMarkerList(construcoes);
            populateGeoLetterList(geoLetters);
            
            updateMap();
          }

          function loadKml(file) 
          {
            $.ajax(
            {
              type: "GET",
              url: "kml/"+file+"?rnd"+Math.random(),
              dataType: "xml",

              success: function(xml) 
              {
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
                  creatConstructionOnMap(name, icon, latitude, longitude);
                }
            });

            //Geoletter
            $(data).find("Geoletter").each(function(index, value)
            {
                var name = $(this).find("name").text() ;
                var coordinates = $(this).find("coordinates").text().split(","); 

                var longitude = coordinates[0] ;
                var latitude = coordinates[1] ;

                if(name && longitude && latitude)
                {
                  creatGeoLetterOnMap(name, latitude, longitude);
                }
            });

            //camera
            $(data).find("Camera").each(function(index, value){
              var longitude = $(this).find("longitude").text() ;
              var latitude = $(this).find("latitude").text() ;

              if(longitude && latitude){
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

            populateMarkerList(construcoes);
            populateGeoLetterList(geoLetters);

            updateMap();
          }

          function saveKML()
          {
            var kmlFile = "";

            //markers
            for (var i = 0; i < construcoes.length; i++) {
              kmlFile += '<Style id="icon'+i+'">';
                kmlFile += '<IconStyle>';
                  kmlFile += '<Icon>';
                    kmlFile += "<href>"+ construcoes[i].getStyle().getImage().getSrc() +"</href>";
                  kmlFile += '</Icon>';
                kmlFile += '</IconStyle>';
              kmlFile += '</Style>';

              kmlFile += '<Placemark>';
                kmlFile += '<name>'+ construcoes[i].get('name') +'</name>';
                kmlFile += '<styleUrl>#icon'+i+'</styleUrl>';
                kmlFile += '<Point>';
                  kmlFile += '<coordinates>'+ construcoes[i].getGeometry().getCoordinates() +',0</coordinates>';
                kmlFile += '</Point>';                
              kmlFile += '</Placemark>';
            }

            //geoletter
            for (var i = 0; i < geoLetters.length; i++) {
              kmlFile += '<Geoletter>';
                kmlFile += '<name>'+ geoLetters[i].get('name') +'</name>';
                kmlFile += '<Point>';
                  kmlFile += '<coordinates>'+ geoLetters[i].getGeometry().getCoordinates() +',0</coordinates>';
                kmlFile += '</Point>';                
              kmlFile += '</Geoletter>';
            }

            //camera
            kmlFile += '<Camera>';
              kmlFile += '<longitude>'+ coordenadasMapa[1] +'</longitude>';
              kmlFile += '<latitude>'+ coordenadasMapa[0] +'</latitude>';
            kmlFile += '</Camera>';

            //save
            var kml = "<Document>"+kmlFile+"</Document>"; 

            <?php if(isset($_REQUEST['arquivo'])){ ?>
              var nome = "<?php echo substr($_REQUEST['arquivo'], 0, -4); ?>";
              var cidade = nomeMapa;
            <?php } else { ?>
              var nome = "<?php echo removerCaracter($_REQUEST['nome']); ?>-<?php echo date('d-m-Y-H-i-s'); ?>";
              var cidade = "<?php echo $_REQUEST['nome']; ?>";
            <?php } ?>

            $.ajax(
            {
                type: 'POST',
                url: 'action/creat-map.php',
                data: { data: kml, name: nome, cidade: cidade  }
            }).done(function(data) 
            {
              var item = $('<br /><div class="alert alert-success">Arquivo salvo com sucesso, você pode acessá-lo na listagem de mapas através da aba Carregar Mapa na página inicial.</div>').delay( 12000 ).fadeOut( 400 );
              $("#info").append(item);
            });
          }

        </script>

    <!-- simulador -->
        <script type="text/javascript">

            $(document).ready( function() 
            {
              //load constructions
              <?php if(isset($_REQUEST['arquivo'])){ echo "loadKml('".$_REQUEST['arquivo']."',map);"; } ?>

              //get adress
              <?php if( isset($_REQUEST['endereco']) && isset($_REQUEST['nome']) ){ echo "loadAdress('".$_REQUEST['nome']."', '".$_REQUEST['endereco']."')"; } ?>

              //start drag api
              myDrager();

              //aba edificacoes
              $( ".lista a" ).click(function(e) 
              {
                //icon
                if(iconTemp != null)
                {
                  iconTemp.fadeTo( "fast", 1 );
                }

                iconTemp = $( this );
                iconTemp.fadeTo( "fast", 0.5 );

                //help
                if( $(this).attr('href') == "geoCarta" ){
                  $( "#help .balao" ).html("Aplique a carta no mapa para <br /> expressar sua opinião sobre o local.");
                  $( "#help" ).fadeIn( 400 );

                  my_timer = setTimeout(function () {
                      $( "#help" ).fadeOut( 400 );
                  }, 6000);
                }

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

                if( $(this).attr('href') == "streetView" ){
                  $( "#help .balao" ).html("Aplique um ponto no mapa para <br />visualizar a localização<br /> tridimensional.");
                  $( "#help" ).fadeIn( 400 );

                  my_timer = setTimeout(function () {
                      $( "#help" ).fadeOut( 400 );
                  }, 6000);
                }

                //carta voadora
                /*
                if( $(this).attr('href') == "carta" ){
                  showLetter();
                }
                */

                //cursor
                cursor = { 
                  img: $(this).attr('href'), 
                  title: $(this).attr('data-original-title')
                };

                return false;
              });

              //ajuda
              $( "#closeHelp" ).click(function(e) 
              {
                $( "#help" ).fadeOut( 400 );
                clearTimeout(my_timer);

                return false;
              });

              //letter
              hideLetter();

              //inicial
              $( "#inicial" ).click(function(e) 
              {
                  var r = confirm("Todas as alterações não salvas serão perdidas, deseja mesmo sair para a Página Inicial?");
                  
                  if (r == true) {
                    window.location.assign("index.php?tab=novoMapa")
                  } 

                  return false;
              });

              //cartas
              $( "#cartas" ).click(function(e)
               {
                showLetter();

                return false;
              });

              //salvar
              $( "#salvar" ).click(function(e)
               {
                saveKML();

                return false;
              });

              //map style select
              $( "#layer-select" ).change(function() 
              {
                onChange($( this ).val()); 
              });

              //auto save
              time =1;
              setInterval( function() 
              {
                  time++;
                  
                  $('#time').html(time);

                  if (time % 300 == 0)
                  {
                     saveKML();
                  }    
              }, 1000 );

              //streetView
              hideStreetView();

              //map
              $( "#map" ).click(function(e) 
              {
                if(cursor != null)
                {
                  setTimeout(function() { creatCursor() },200);
                  handleDragStop(null, null);
                }
              });
          });

          //Drag Options
          function myDrager() {
            $('.lista a').draggable( {
              cursor: 'move',
              containment: 'document',
              start: handleDragStart,
              stop: handleDragStop,
              helper: myHelper
            });

            $('#map').droppable( {
              drop: handleDropEvent
            });
          }

          function myHelper( event ) {
            if( $(this).attr('href') == "rota" || $(this).attr('href') == "area" || $(this).attr('href') == "ponto" || $(this).attr('href') == "coordenada" || $(this).attr('href') == "streetView" )
            {
              return '<div id="draggableHelper"><img src="img/ponto.png" width="100" /></div>';
            }
            else
            {
              return '<div id="draggableHelper"><img src="img/' + $(this).attr('href') + '.png" width="100" /></div>';
            }
          }

          function handleDragStart( event, ui ) 
          {
              if(iconTemp != null)
              {
                iconTemp.fadeTo( "fast", 1 );
              }

              iconTemp = $( this );
              iconTemp.fadeTo( "fast", 0.5 );

              cursor = { 
                img: $(this).attr('href'), 
                title: $(this).attr('data-original-title')
              };
          }

          function handleDragStop( event, ui ) 
          {
            iconTemp.fadeTo( "fast", 1 );            
          }

          function handleDropEvent( event, ui ) 
          {
            var draggable = ui.draggable;

            setTimeout(function() { creatCursor() },200)
          }

          function creatCursor()
          {
            //geoletter
            if(cursor["img"] == "geoCarta")
            {
              creatGeoLetterOnMap('', coordenadasMouse[0], coordenadasMouse[1]);
              
              populateGeoLetterList(geoLetters);
              
              updateMap();

              cursor = null;
            }

            //area
            else if(cursor["img"] == "area")
            {
              if(tool == null || tool == "area")
              {
                checkArea(coordenadasMouse[0], coordenadasMouse[1]);
              }
              else
              {
                alert("Finalize a ação da ferramenta anterior!");
              }
            }

            //distancias
            else if(cursor["img"] == "ponto")
            {
              if(tool == null || tool == "ponto")
              {
                checkPoint(coordenadasMouse[0], coordenadasMouse[1]);
              }
              else
              {
                alert("Finalize a ação da ferramenta anterior!");
              }
            }

            //coordenadas
            else if(cursor["img"] == "coordenada")
            {
              if(tool == null || tool == "coordenada")
              {
                checkCordenate(coordenadasMouse[0], coordenadasMouse[1]);
              }
              else
              {
                alert("Finalize a ação da ferramenta anterior!");
              }
            }

            //rota
            else if(cursor["img"] == "rota")
            {
              if(tool == null || tool == "rota")
              {
                checkRoute(coordenadasMouse[0], coordenadasMouse[1]);
              }
              else
              {
                alert("Finalize a ação da ferramenta anterior!");
              }
            }

            //streetView
            else if(cursor["img"] == "streetView")
            {
              if(tool == null)
              {
                checkStreetView(coordenadasMouse[0], coordenadasMouse[1]);
              }
            }

            //carta voadora
            else if(cursor["img"] == "carta"){}

            //construcoes
            else
            {
              if( coliderMarkerCheck(null, coordenadasMouse[0], coordenadasMouse[1]) ){
                creatConstructionOnMap(cursor["title"], 'img/' + cursor["img"] + '.png', coordenadasMouse[0], coordenadasMouse[1]);
                populateMarkerList(construcoes);
                updateMap();

                cursor = null;
              }
              else
              {
                 alert("Duas constru\u00e7\u00f5es n\u00e3o podem ocupar o mesmo espa\u00e7o\u0021");
              }
            }
          }

        </script>
  </head>
  
  <body>
    <!-- Modal -->
    <div id="myModal" class="modal hide fade modalCarta" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
      <img src="img/asa-esq.png" class="asa-esq" />
      <img src="img/asa-dir.png" class="asa-dir" />

      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        <h3>Cartas Voadoras</h3>
      </div>
      
      <div id="data" class="modal-body"></div>
    </div>

    <!-- App -->
    <div class="container-fluid">
      <br />
    
      <div class="row-fluid">
        <div class="well span9">
          <div id="map">
          </div> 

          <div id="streetView">
          </div>  
          
          <div id="info">
          </div>
          
          <div id="help">
            <img src="img/help.png">
            <p class="balao"></p>
            <a href="#" id="closeHelp"><img src="img/close_icon.png" /></a>
          </div>
        </div>

        <div class="well span3 panelContrucao">
            <p <?php if(!isset($_REQUEST['nome'])){ echo 'class="nomeCidade"'; } ?> ><?php if(isset($_REQUEST['nome'])){ echo $_REQUEST['nome']; } ?></p>
            
            <div class="tab-content">
              <ul class="nav nav-pills" role="tablist">
                <li role="presentation"><a href="#construcoes" role="tab" data-toggle="tab">Construções</a></li>
                <li role="presentation"><a href="#geocartas" role="tab" data-toggle="tab">Geocartas</a></li>
              </ul>

              <hr />

              <ul id="construcoes" role="tabpanel" class="tab-pane">
              </ul>

              <ul id="geocartas" role="tabpanel" class="tab-pane">
              </ul>
            </div>
        </div>

        <div class="well span3 panelMapStyle">
          <p><b>Modo de Visualização</b></p>
          <select id="layer-select">
            <option value="Aerial">Satélite</option>
            <option value="AerialWithLabels">Satélite com Estradas</option>
            <option value="Road" selected>Estradas</option>
          </select>
        </div>

        <div class="well span3 panelFerramentas">
          <div class="row-fluid">
            <a href="#" rel="tooltip" class="span6" id="inicial" title="Página Inicial"><img src="img/icone_pagina_inicial.png" width="60" /></a>
            <a href="#" rel="tooltip" class="span6" id="salvar" title="Salvar Construções"><img src="img/icone_salvar.png" width="60" /></a>
          </div>
          <div class="row-fluid">
            <a href="#" rel="tooltip" class="span6" id="cartas" title="Cartas Voadoras"><img src="img/icone_cartas_voadoras.png" width="60" /></a>
            <a href="files/manual.pdf" rel="tooltip" class="span6" id="manual" target="_blank" title="Manual"><img src="img/icone_manual.png" width="60" /></a>
          </div>
        </div>
      </div>

      <div class="row-fluid">
        <div class="well span12">
          
          <div class="tab-content">
            <ul class="nav nav-pills" role="tablist">
              <li role="presentation"><a href="#tabs1" role="tab" data-toggle="tab"><img width="30" src="img/icone_representa_comercio.png" /> Comércio</a></li>
              <li role="presentation"><a href="#tabs2" role="tab" data-toggle="tab"><img width="30" src="img/icone_representa_educacao.png" /> Educação</a></li>
              <li role="presentation"><a href="#tabs3" role="tab" data-toggle="tab"><img width="30" src="img/icone_representa_habitacoes.png" /> Habitações</a></li>
              <li role="presentation"><a href="#tabs4" role="tab" data-toggle="tab"><img width="30" src="img/icone_representa_infraestrutura.png" /> Infraestrutura</a></li>
              <li role="presentation"><a href="#tabs5" role="tab" data-toggle="tab"><img width="30" src="img/icone_representa_lazer.png" /> Lazer</a></li>
              <li role="presentation"><a href="#tabs6" role="tab" data-toggle="tab"><img width="30" src="img/icone_configuracoes.png" /> Ferramentas</a></li>
            </ul>

            <hr />

            <div role="tabpanel" class="tab-pane" id="tabs1">
              <ul class="lista">
                <li><a href="academia" rel="tooltip" title="Academia"><img src="img/icone_comercio_academia.png" /></a></li>
                <li><a href="banco-01" rel="tooltip" title="Banco 01"><img src="img/icone_comercio_banco01.png" /></a></li>
                <li><a href="banco-02" rel="tooltip" title="Banco 02"><img src="img/icone_comercio_banco02.png" /></a></li>
                <li><a href="banco-03" rel="tooltip" title="Banco 03"><img src="img/icone_comercio_banco03.png" /></a></li>
                <li><a href="farmacia" rel="tooltip" title="Farmácia"><img src="img/icone_infraestrutura_farmacia.png" /></a></li>
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
                <li><a href="igreja" rel="tooltip" title="Igreja"><img src="img/icone_lazer_igreja.png" /></a></li>
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
                <li><a href="geoCarta" rel="tooltip" title="Carta Geolocalizada"><img src="img/icone_geo_carta.png" /></a></li>
                <li><a href="area" rel="tooltip" title="Medir Área"><img src="img/icone_area.png" /></a></li>
                <li><a href="ponto" rel="tooltip" title="Medir Distâncias"><img src="img/icone_ponto.png" /></a></li>
                <li><a href="coordenada" rel="tooltip" title="Retornar Coordenadas"><img src="img/icone_coordenada.png" /></a></li>
                <li><a href="rota" rel="tooltip" title="Calcular Rota"><img src="img/icone_rota.png" /></a></li>
                <li><a href="streetView" rel="tooltip" title="Visão Tridimensional"><img src="img/icone_streetView.png" /></a></li>
              </ul>
            </div>
            
          </div>
        </div>
      </div>

      <p class="versao">Versão: F.1.0.0</p>
    </div>
  </body>

</html>
