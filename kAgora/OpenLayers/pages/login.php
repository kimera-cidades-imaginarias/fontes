    <p>Para acessar as Cartas Voadoras é necessário efetuar o login através dos campos abaixo. Caso você não possua cadastro em nosso sistema, acesse a aba cadastro e preencher os valores dos campos abaixo e em seguida clicar no botão cadastrar.</p>


    <div class="tabbable">
      <ul class="nav nav-tabs">
        <li class="active"><a href="#tab1" data-toggle="tab">Acessar</a></li>
        <li><a href="#tab2" data-toggle="tab">Cadastrar</a></li>
      </ul>

      <div class="tab-content">
        <div class="tab-pane active" id="tab1">
          <form class="form-horizontal" action="#" role="form" id="formLogin" method="post">   
            <div class="control-group">
              <label class="control-label" for="inputEmail">Email</label>
              <div class="controls">
                <input type="text" id="inputEmail" name="email" placeholder="nome.sobrenome@instituicao.edu.br" required data-msg-required="Este campo não pode ser vazio!">
              </div>
            </div>
            <div class="control-group">
              <label class="control-label" for="inputPassword">Senha</label>
              <div class="controls">
                <input type="password" id="inputPassword" name="password" placeholder="***" required data-msg-required="Este campo não pode ser vazio!">
              </div>
            </div>
            <div class="control-group">
              <div class="controls">
                <button type="button" class="entrar btn btn-primary">Acessar</button>
              </div>
            </div>
          </form>
        </div>

        <div class="tab-pane" id="tab2">
          <form class="form-horizontal" action="#" role="form" id="formCreate" method="post">   
            <div class="control-group">
              <label class="control-label" for="inputEmail">Email</label>
              <div class="controls">
                <input type="text" id="inputEmail" name="email" placeholder="nome.sobrenome@instituicao.edu.br" required data-msg-required="Este campo não pode ser vazio!">
              </div>
            </div>
            <div class="control-group">
              <label class="control-label" for="inputPassword">Senha</label>
              <div class="controls">
                <input type="password" id="inputPassword" name="password" placeholder="***" required data-msg-required="Este campo não pode ser vazio!">
              </div>
            </div>
            <div class="control-group">
              <div class="controls">
                <button type="button" class="cadastrar btn">Cadastrar</button>
              </div>
            </div>
          </form>
        </div>
      </div>
    </div>

    <script type="text/javascript">
      function creatuser()
      {
        var data = $('#formCreate').serialize();

        $.ajax({
           type: "POST",
           url: "action/creat-user.php",
           async: false,
           data: data,
           
           success: function(data)
           {
              if(data == 'true')
              {
                login();
              }

              if(data == 'false')
              {
                alert('Preencha todos os campos!');
              }

              return false;
           },
           complete: function(data) 
           {
              return false;
           },
           error: function(xhr, textStatus, errorThrown) 
           {
              return false;
           }
        });
      }

      function login()
      {
        var data = $('#formLogin').serialize();

        $.ajax({
           type: "POST",
           url: "action/login.php",
           async: false,
           data: data,
           
           success: function(data)
           {
              if(data == 'true')
              {
                loadLetter();
              }

              if(data == 'false')
              {
                alert('Usuario nao cadastrado!');
              }

              return false;
           },
           complete: function(data) 
           {
              return false;
           },
           error: function(xhr, textStatus, errorThrown) 
           {
              return false;
           }
        });
      }

      function loadLetter()
      {
        $.ajax({
           type: "POST",
           url: "pages/letter.php",
           
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

      $(document).ready(function() 
      {
        $('.cadastrar').click(function (e) 
        {
          creatuser();

          return false;
        });

        $('.entrar').click(function (e) 
        {
          login();

          return false;
        });
      });
    </script>