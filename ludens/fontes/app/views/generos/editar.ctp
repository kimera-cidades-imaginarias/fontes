<h1>Editar Gênero</h1>
<?php
    echo $form->create('Genero');
    echo $form->input('nome');
    echo $form->input('id', array('type' => 'hidden'));
    echo $form->end('Salvar');
?>