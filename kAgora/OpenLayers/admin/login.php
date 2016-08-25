<?php
  //autentica
  if (isset($_POST['submitted'])) {
    if($_POST['email'] != ''){
      $login_digitado = $_POST['email'];
      $login_escape = addcslashes($login_digitado, "\0..\37!@\177..\377");
    } else{
      $login_digitado = false;
    }
    
    if($_POST['password'] != '' ){
      $senha_digitada = $_POST['password'];
      $senha_escape = addcslashes($senha_digitada, "\0..\37!@\177..\377");
    } else{
      $senha_digitada = false;
    }
    
    if($login_digitado != false && $senha_digitada != false){
      $consulta = "SELECT * FROM user WHERE email = '$login_escape' AND password = '$senha_escape'";
      $rs = $con->query($consulta);
        
      $dados = $rs->fetch_assoc();
      
      if($dados['email'] == $login_digitado && $dados['password'] == $senha_digitada){

        $_SESSION["user_id"] = $dados["id"];
        $_SESSION["email"] = $dados["email"];
        $_SESSION["permission"] = $dados["permission"];
        $_SESSION["password"] = $dados["password"];

        echo '<script type="text/javascript"> window.location = "index.php?pagina=listar-cartas&status=sucesso" </script>';
      } else {
        echo '<script type="text/javascript"> window.location = "index.php?status=aviso" </script>';
      } 
    } else {
      echo '<script type="text/javascript"> window.location = "index.php?status=erro" </script>';
    }
  }
?>

<div class="hero-unit">
  <form class="form-horizontal" action='' method='POST'> 
    
    <div class="control-group">
      <label class="control-label" for="inputEmail">Email</label>
      <div class="controls">
        <input type="text" name="email" id="inputEmail" placeholder="Email">
      </div>
    </div>

    <div class="control-group">
      <label class="control-label" for="inputPassword">Senha</label>
      <div class="controls">
        <input type="password" name="password" id="inputPassword" placeholder="Senha">
      </div>
    </div>

    <div class="control-group">
      <div class="controls">
        <input type='hidden' value='1' name='submitted' />
        <button type="submit" class="btn">Entrar</button>
      </div>
    </div>

  </form>
</div>