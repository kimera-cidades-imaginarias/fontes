	<?php @session_start("kimera"); ?>
	<?php include_once('../action/connect.php'); ?>

	<?php if(isset($_SESSION["user_id"]) && isset($_SESSION["email"]) && isset($_SESSION["password"])) { ?>
	<form action="#" role="form" id="form" method="post">
      	<input type="hidden" name="user_id" value="<?php echo $_SESSION["user_id"]; ?>" />
      	<input type="hidden" name="permission" value="<?php echo $_SESSION["permission"]; ?>" />
        
      	<input type="text" name="title" class=" btn-block" />
        <textarea rows="10" name="letter" class="btn-large btn-block"></textarea>

        <button type="button" class="nova btn">Nova carta</button>
        <button type="button" class="enviar btn btn-primary">Enviar</button>
    </form>

    <hr />

    <?php if($_SESSION["permission"] == 0){ ?>
    <h4>Minhas Cartas</h4>
    <ul id="listLetter">
    	<?php 
    		$sql = "SELECT * FROM letter WHERE user_id = " . $_SESSION["user_id"] . " OR permission = 1 ORDER BY date_time ASC";

    		$result = $con->query($sql); 
    		if ($result->num_rows > 0) {
    			while($row = $result->fetch_assoc()) {
    	?>
    	<li><a href="<?php echo $row["letter"]; ?>"><?php echo $row["title"]; ?></a></li>
    	<?php 
    			} 
    		}
    	?>
    </ul>
    <?php } ?>

    <?php if($_SESSION["permission"] == 1){ ?>
    <h4>Todas Cartas</h4>
    <ul id="listLetter">
    	<?php 
    		$sql = "SELECT * FROM letter ORDER BY date_time ASC";

    		$result = $con->query($sql); 
    		if ($result->num_rows > 0) {
    			while($row = $result->fetch_assoc()) {
    	?>
    	<li><a href="<?php echo $row["letter"]; ?>"><?php echo $row["title"]; ?></a></li>
    	<?php 
    			} 
    		}
    	?>
    </ul>
    <?php } ?>

    <script type="text/javascript">
      function creatLetter()
      {
        var data = $('#form').serialize();

        $.ajax({
           type: "POST",
           url: "action/creat-letter.php",
           async: false,
           data: data,
           
           success: function(data)
           {
           	  updateLetter();
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
      	$('#form textarea').val(id);
      }

      function updateLetter()
      {
      	$('#form textarea').val('');
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
          updateLetter();

          return false;
        });

        $('#listLetter li a').click(function (e) 
        {
          showMyLetter( $(this).attr("href") );

          return false;
        });
      });
    </script>
    <?php } ?>