	<?php @session_start("kimera"); ?>
	<?php include_once('../action/connect.php'); ?>

	<?php if(isset($_SESSION["user_id"]) && isset($_SESSION["email"]) && isset($_SESSION["password"])) { ?>
	
    <form action="action/creat-letter.php" role="form" id="formLetter" method="post">
        <input type="hidden" name="letter_id" value="" />
        <input type="hidden" name="user_id" value="<?php echo $_SESSION["user_id"]; ?>" />
      	<input type="hidden" name="permission" value="<?php echo $_SESSION["permission"]; ?>" />
        
        <div class="control-group">
          <label class="control-label" >De:</label>
      	  <input type="text" name="from" class=" btn-block" value="<?php echo $_SESSION["email"]; ?>" readonly="readonly"  />
        </div>

        <div class="control-group">
          <label class="control-label" >Para:</label>
          <input type="text" name="to" class=" btn-block" value="Prof. Daniel" readonly="readonly" />
        </div>

        <div class="control-group">
          <label class="control-label" >Assunto:</label>
          <input type="text" name="title" class=" btn-block" value=""  />
        </div>        

        <div class="control-group">
          <label class="control-label" >Carta:</label>
          <textarea rows="10" name="letter" class="btn-large btn-block"></textarea>
        </div>

        <button type="button" class="nova btn">Nova carta</button>
        <button type="button" class="enviar btn btn-primary">Enviar</button>
    </form>

    <hr />

    <h4>Minhas Cartas</h4>
    <ul id="listLetter">
    </ul>

    <script type="text/javascript">
      function clearLetter()
      {
        $('#formLetter input[name*="letter_id"]').val('');
        $('#formLetter input[name*="from"]').val('<?php echo $_SESSION["email"]; ?>');
        $('#formLetter input[name*="to"]').val('Prof. Daniel');
        $('#formLetter input[name*="title"]').val('');
        $('#formLetter textarea').val('');

        $('#formLetter input[name*="letter_id"]').prop("readonly",true);
        $('#formLetter input[name*="title"]').prop("readonly",true);
        $('#formLetter textarea').prop("readonly",true);
      }

      function creatLetter()
      {
        var frm = $('#formLetter');

        $.ajax({
            type: frm.attr('method'),
            url: frm.attr('action'),
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
                alert('Erro ao cadastrar!');
              }
            }
        });
      }

      function showLetterByID(id)
      {
        $.ajax({
           type: "POST",
           url: "action/show-letter.php",
           data: 'id='+id,
           dataType : "json",
           
           success: function(data)
           {
              clearLetter();

              if(data.letter[0].user_id != <?php echo $_SESSION["user_id"]; ?>)
              {
                $('#formLetter input[name*="letter_id"]').prop("readonly",true);
                $('#formLetter input[name*="title"]').prop("readonly",true);
                $('#formLetter textarea').prop("readonly",true);

                $('#formLetter input[name*="to"]').val('<?php echo $_SESSION["email"]; ?>');
              }
              else
              {
                $('#formLetter input[name*="letter_id"]').prop("readonly",false);
                $('#formLetter input[name*="title"]').prop("readonly",false);
                $('#formLetter textarea').prop("readonly",false);
              }

              $('#formLetter input[name*="from"]').val(data.letter[0].from);
              $('#formLetter input[name*="letter_id"]').val(data.letter[0].id);
              $('#formLetter input[name*="title"]').val(data.letter[0].title);
              $('#formLetter textarea').val(data.letter[0].letter);

              return false;
           }
        });
      }

      function listLetter()
      {
        $.ajax({
           type: "POST",
           url: "action/list-letter.php",
           async: false,
           data: 'user_id=<?php echo $_SESSION["user_id"]; ?>',
           
           success: function(data)
           {
              $('#listLetter').html(data);

              return false;
           }
        });
      }

      $(document).ready(function() 
      {
        clearLetter();
        listLetter();

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
          showLetterByID( $(this).attr("href") );

          return false;
        });        
      });
    </script>
<?php } ?>