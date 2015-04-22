<fieldset>
<legend>Adicionar Grupo</legend>
<?php
echo $javascript->link('prototype');

echo $form->create('Grupo');
echo $form->input('nome');
echo $form->input('grupo_pai_id', array('empty' => 'Sem pai'));
echo $form->input('instituicao_id');
echo $form->input('Jogador');

echo $form->end('Salvar Grupo');
?>
</fieldset>