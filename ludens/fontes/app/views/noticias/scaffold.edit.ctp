<fieldset>
<legend>Adicionar Notícia</legend>
<?php

echo $form->create('Noticia');
echo $form->input('titulo');
echo $form->input('data', array('dateFormat' => 'DMY'));
echo $form->input('texto', array('rows' => '3'));

echo $form->end('Salvar Notícia');
?>
</fieldset>