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
		
		//essa transformação de pontos para endereço não estava funcionando
        //$url = "http://maps.google.com/maps/api/geocode/json?sensor=false&address=" . $address . "&key=AIzaSyDKqbq2wqMMANlrkbTdQ9uMtUEus4PJEC4";
        //$response = file_get_contents($url);
        //$json = json_decode($response,true);
        //$latitude = $json['results'][0]['geometry']['location']['lat'];
        //$longitude = $json['results'][0]['geometry']['location']['lng']; 
		
		//uma vez que ele aceita direto agora o endereço, modifiquei para receber direto o endereço no lugar da lat e long
		$image = imagecreatefromstring(file_get_contents("http://maps.googleapis.com/maps/api/staticmap?&center=".$address."&zoom=".$zoom."&scale=2&format=png&sensor=false&size=640x823&maptype=".$tipo."&style=feature:landscape|element:geometry|color:0x9C6B4A&style=feature:landscape.natural.terrain|element:geometry.fill|color:0x278080&style=element:labels|visibility:off&style=feature:water|color:0x5BA6DF&style=feature:poi|color:0x6D8642&style=feature:road|color:0x010100&style=feature:transit.line|color:0xDECDB1&key=AIzaSyDKqbq2wqMMANlrkbTdQ9uMtUEus4PJEC4", true));
		
    }else{
			$image = imagecreatefromstring(file_get_contents("http://maps.googleapis.com/maps/api/staticmap?&center=".$latitude.",".$longitude."&zoom=".$zoom."&scale=2&format=png&sensor=false&size=640x823&maptype=".$tipo."&style=feature:landscape|element:geometry|color:0x9C6B4A&style=feature:landscape.natural.terrain|element:geometry.fill|color:0x278080&style=element:labels|visibility:off&style=feature:water|color:0x5BA6DF&style=feature:poi|color:0x6D8642&style=feature:road|color:0x010100&style=feature:transit.line|color:0xDECDB1&key=AIzaSyDKqbq2wqMMANlrkbTdQ9uMtUEus4PJEC4", true));
    
	}

    $thumb = imagecreatetruecolor(1680, 2160);
 	
	//$image = imagecreatefromstring(file_get_contents("https://maps.googleapis.com/maps/api/staticmap?center=Brooklyn+Bridge,New+York,NY&zoom=13&size=600x300&maptype=roadmap&markers=color:blue%7Clabel:S%7C40.702147,-74.015794&markers=color:green%7Clabel:G%7C40.711614,-74.012318&markers=color:red%7Clabel:C%7C40.718217,-73.998284&key=AIzaSyDKqbq2wqMMANlrkbTdQ9uMtUEus4PJEC4", true));

    $frame = imagecreatefromstring(file_get_contents("grid.png", true)); 

	imagecopyresized($thumb, $image, 0, 0, 0, 0, 1680, 2160, 1280, 1280);
	imagecopymerge($thumb, $frame, 0, 0, 0, 0, 1680, 2160, 100); 

	ImageJPEG($thumb); 
?>