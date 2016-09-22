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

        echo '<script type="text/javascript"> window.location = "index.php?pagina=home" </script>';
      } else {
        echo '<script type="text/javascript"> window.location = "index.php?status=aviso" </script>';
      } 
    } else {
      echo '<script type="text/javascript"> window.location = "index.php?status=erro" </script>';
    }
  }
?>


  <div class="row">
    <div class="span6 offset3">
      <center><p>Seja bem-vindo ao módulo de administração das cartas voadoras do K-Ágora. <br />Para acessar digite seu e-mail e senha nos campos abaixo.<br /><br /></p></center>

      <div class="row-fluid">
        <div class="span4">
          <img class="img" src="../img/figura_personagem_corpo_inteiro_rei_kimera.jpg" />
        </div>

        <div class="span8">
          <form class="form-horizontal left" action='' method='POST'> 
            <div class="control-group">
              <label for="inputEmail">Email</label>
              <input type="text" name="email" id="inputEmail" placeholder="Exemplo: nome.sobreno">
            </div>

            <div class="control-group">
              <label for="inputPassword">Senha</label>
              <input type="password" name="password" id="inputPassword" placeholder="*****">
            </div>

            <div class="control-group">
              <input type='hidden' value='1' name='submitted' />
              <button type="submit" class="btn btn-primary">Entrar</button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>


