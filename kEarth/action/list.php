<?php 
	$path = "../kml/"; 
	$diretorio = dir($path); 

	while($arquivo = $diretorio -> read()){ 
		if($arquivo != '.' && $arquivo != '..'){
			echo '<tr>';
				echo '<td>'.$arquivo.'</td>';
				echo '<td><a href="editor.php?arquivo='.$arquivo.'" class="btn">Jogar</a></td>';
				echo '<td><a href="kml/'.$arquivo.'" class="btn">Download</a></td>';
			echo '</tr>';
		}
	}

	$diretorio -> close(); 
?>