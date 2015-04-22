<fieldset>
<legend>Adicionar Jogador</legend>
<?php

echo $form->create('Jogador');
echo $form->input('nome');
echo $form->input('email');
echo $form->input('matricula');
echo $form->input('nascimento', array('dateFormat' => 'DMY', 'minYear' => Date('Y')-90));
echo $form->input('Grupo');
echo $form->input('senha', array('type' => 'password'));
echo $form->input('instituicao_id');
echo $form->end('Salvar Jogador');
?>
</fieldset>