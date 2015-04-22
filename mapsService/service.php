<?php 
    header('Content-Type: image/png'); 
    
    @$endereco   = $_GET['endereco'];
    @$latitude   = $_GET['latitude'];
    @$longitude  = $_GET['longitude'];
    @$zoom       = $_GET['zoom'];
    @$tipo       = $_GET['tipo']; //roadmap satellite terrain hybrid

    if(isset($endereco))
    {
        $address = urlencode($endereco);

        $url = "http://maps.google.com/maps/api/geocode/json?sensor=false&address=" . $address;
        $response = file_get_contents($url);
        $json = json_decode($response,true);
     
        $latitude = $json['results'][0]['geometry']['location']['lat'];
        $longitude = $json['results'][0]['geometry']['location']['lng']; 
    }

    $thumb = imagecreatetruecolor(1680, 2160);
 	
	$image = imagecreatefromstring(file_get_contents("http://maps.googleapis.com/maps/api/staticmap?&center=".$latitude.",".$longitude."&zoom=".$zoom."&scale=2&format=png&sensor=false&size=640x823&maptype=".$tipo."&style=feature:landscape|element:geometry|color:0x9C6B4A&style=feature:landscape.natural.terrain|element:geometry.fill|color:0x278080&style=element:labels|visibility:off&style=feature:water|color:0x5BA6DF&style=feature:poi|color:0x6D8642&style=feature:road|color:0x010100&style=feature:transit.line|color:0xDECDB1", true));
    //$image = imagecreatefromstring(file_get_contents("http://static-maps.yandex.ru/1.x/?lang=en-US&ll=37.620070,55.753630&z=16&spn=0.1,0.1&l=map,trf", true));

    $frame = imagecreatefromstring(file_get_contents("grid.png", true)); 

	imagecopyresized($thumb, $image, 0, 0, 0, 0, 1680, 2160, 1280, 1280);
	imagecopymerge($thumb, $frame, 0, 0, 0, 0, 1680, 2160, 100); 

	ImageJPEG($thumb); 
?>