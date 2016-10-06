<?php 
	$path = "../kml/"; 
	$diretorio = dir($path); 

	while($arquivo = $diretorio -> read()){ 
		if($arquivo != '.' && $arquivo != '..'){
			echo '<tr>';
				echo '<td>'.$arquivo.'</td>';
				echo '<td><a href="editor.php?arquivo='.$arquivo.'" class="btn btn-primary">Explorar</a></td>';
				echo '<td><a href="kml/'.$arquivo.'" class="btn">Download</a></td>';
				echo '<td><a href="#" class="btn delete" title="'.$arquivo.'">Excluir</a></td>';
			echo '</tr>';
		}
	}

	$diretorio -> close(); 
?>

<script type="text/javascript">
	$(function(){
	    $(".delete").click(function(){

	    	s=prompt('Senha de confirmação: ','*****');

	    	if(s == "123@kagora"){
	    		var a = $(this).attr('title');

		        $.ajax({
		            type: "POST",
		            data: { name:a },
		            url: "action/delete.php",
		            dataType: "html",

		            success: function(result){
		            	window.location = 'index.php?tab=carregarMapa';
		            	//document.location.reload(true);
		            },
		            beforeSend: function(){
		                
		            },
		            complete: function(msg){
		                
		            }
		        });
	    	}
	    	else
	    	{
	    		alert("Senha incorreta!");
	    	}

	    });	     
	});
</script>