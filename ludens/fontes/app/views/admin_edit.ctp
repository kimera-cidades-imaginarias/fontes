<fieldset>
<legend>Adicionar Banner</legend>
<?php

echo $form->create('Banner', array('enctype' => 'multipart/form-data'));
echo $form->input('nome');
echo $form->input('texto');
echo $form->file('arquivo', array('label' => 'Arquivo'));
echo $form->input('link');
echo $form->input('tempo');
echo $form->input('ordem');
echo $form->input('ativo', array('options' => array('0' => 'Não', '1' => 'Sim')));

echo $form->end('Salvar Banner');
?>
</fieldset>