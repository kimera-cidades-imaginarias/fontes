<?php
	include_once('connect.php');

	$result = $con->query("SELECT * FROM `user` WHERE email = '" . $_POST['email'] . "'");
	$num_rows = mysqli_num_rows($result);

	if($num_rows > 0)
	{
		echo 'Este usuário já foi cadastrado!';
	} else {
		foreach($_POST AS $key => $value) { $_POST[$key] = $con->real_escape_string($value); } 
		
		$sql = "INSERT INTO `user` ( `email` ,  `password`,  `permission`  ) VALUES(  '{$_POST['email']}' ,  '{$_POST['password']}' ,  '0'  ) "; 
		
		if($con->query($sql)){
			echo 'Usuário cadastrado com sucesso!';
		} else {
			echo 'Erro ao cadastrar usuário!';
		}
	}
	