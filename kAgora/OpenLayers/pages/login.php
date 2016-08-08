    <form class="form-horizontal" action="#" role="form" id="form" method="post">   
      <div class="control-group">
        <label class="control-label" for="inputEmail">Email</label>
        <div class="controls">
          <input type="text" id="inputEmail" name="email" placeholder="Email">
        </div>
      </div>
      <div class="control-group">
        <label class="control-label" for="inputPassword">Senha</label>
        <div class="controls">
          <input type="password" id="inputPassword" name="password" placeholder="Senha">
        </div>
      </div>
      <div class="control-group">
        <div class="controls">
          <button type="button" class="cadastrar btn">Cadastrar</button>
          <button type="button" class="entrar btn btn-primary">Entrar</button>
        </div>
      </div>
    </form>

    <script type="text/javascript">
      function creatuser()
      {
        var data = $('#form').serialize();

        $.ajax({
           type: "POST",
           url: "action/creat-user.php",
           async: false,
           data: data,
           
           success: function(data)
           {
              login();

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
        var data = $('#form').serialize();

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