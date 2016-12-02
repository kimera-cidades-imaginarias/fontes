    <p>Para acessar as Cartas Voadoras é necessário efetuar o login através dos campos abaixo. Caso você não possua cadastro em nosso sistema, acesse a aba cadastro e preencher os valores dos campos abaixo e em seguida clicar no botão cadastrar.</p>


    <div class="tabbable">
      <ul class="nav nav-tabs">
        <li class="active"><a href="#tab1" data-toggle="tab">Acessar</a></li>
        <li><a href="#tab2" data-toggle="tab">Cadastrar</a></li>
      </ul>

      <div class="tab-content">
        <div class="tab-pane active" id="tab1">
          <form class="form-horizontal" action="action/login.php" role="form" id="formLogin" method="post">   
            <div class="control-group">
              <label class="control-label" for="inputEmail">Usuário</label>
              <div class="controls">
                <input type="text" id="inputEmail" name="email" placeholder="nome.sobrenome" required data-msg-required="Este campo não pode ser vazio!">
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
          <form class="form-horizontal" action="action/creat-user.php" role="form" id="formCreate" method="post">   
            <div class="control-group">
              <label class="control-label" for="inputEmail">Usuário</label>
              <div class="controls">
                <input type="text" id="inputEmail" name="email" placeholder="nome.sobrenome" required data-msg-required="Este campo não pode ser vazio!">
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
      function creatuser(frm)
      {
        $.ajax({
            type: frm.attr('method'),
            url: 'action/creat-user.php',
            data: frm.serialize(),
            
            success: function (data) 
            {
                alert(data);

                login(frm);
            }
        });
      }

      function login(frm)
      {
        $.ajax({
            type: frm.attr('method'),
            url: 'action/login.php',
            data: frm.serialize(),
            
            success: function (data) 
            {
              if(data == 'true')
              {
                $.ajax({
                  url: 'pages/home.php'
                }).done(function(data) { 
                  $('#data').html(data); 
                });
              }
              else
              {
                alert("Usuário Incorreto!");
              }

              return false;
            }
        });
      }

      $(document).ready(function() 
      {
        $('.cadastrar').click(function (e) 
        {
          var frm = $('#formCreate');

          creatuser(frm);

          return false;
        });

        $('.entrar').click(function (e) 
        {
          var frm = $('#formLogin');

          login(frm);

          return false;
        });
      });
    </script>