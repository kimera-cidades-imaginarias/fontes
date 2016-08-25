	<?php @session_start("kimera"); ?>
	<?php include_once('../action/connect.php'); ?>

	<?php if(isset($_SESSION["user_id"]) && isset($_SESSION["email"]) && isset($_SESSION["password"])) { ?>
	
    <hr />

    <form action="#" class="form-horizontal" role="form" id="form" method="post">
      	<input type="hidden" name="user_id" value="<?php echo $_SESSION["user_id"]; ?>" />
      	<input type="hidden" name="permission" value="<?php echo $_SESSION["permission"]; ?>" />
        
        <div class="control-group">
          <label class="control-label" >De:</label>
          <div class="controls">
      	     <input type="text" name="title" class=" btn-block" />
          </div>
        </div>

        <div class="control-group">
          <label class="control-label" >Para:</label>
          <div class="controls">
             <input type="text" class=" btn-block" value="Prof. Daniel" disabled />
          </div>
        </div>

        <textarea rows="10" name="letter" class="btn-large btn-block"></textarea>

        <button type="button" class="nova btn">Nova carta</button>
        <button type="button" class="enviar btn btn-primary">Enviar</button>
    </form>

    <hr />

    <h4>Minhas Cartas</h4>
    <ul id="listLetter">
    </ul>

    <script type="text/javascript">
      function creatLetter()
      {
        var data = $('#form').serialize();

        $.ajax({
           type: "POST",
           url: "action/creat-letter.php",
           async: true,
           data: data,
           
           success: function(data)
           {
           	  clearLetter();
           	  $('#myModal').modal('hide');

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

      function showMyLetter(id)
      {
        $.ajax({
           type: "POST",
           url: "action/show-letter.php",
           data: 'id='+id,
           dataType : "json",
           
           success: function(data)
           {
              clearLetter();

              $('#form input[name*="title"]').val(data.letter[0].title);
              $('#form textarea').val(data.letter[0].letter);

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

      function clearLetter()
      {
      	$('#form input[name*="title"]').val('');
        $('#form textarea').val('');
      }

      function listLetter()
      {
        var data = '';

        <?php if(isset($_SESSION["user_id"])){ echo "var data = '".$_SESSION["user_id"]."';"; } ?>

        $.ajax({
           type: "POST",
           url: "action/list-letter.php",
           async: false,
           data: 'user_id='+data,
           
           success: function(data)
           {
              clearLetter();
              $('#listLetter').html(data);

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

      $(document).ready(function() 
      {
        $('.enviar').click(function (e) 
        {
          creatLetter();

          return false;
        });

        $('.nova').click(function (e) 
        {
          clearLetter();

          return false;
        });

        $('#listLetter li a').click(function (e) 
        {
          showMyLetter( $(this).attr("href") );

          return false;
        });

        listLetter();
      });
    </script>
<?php } ?>