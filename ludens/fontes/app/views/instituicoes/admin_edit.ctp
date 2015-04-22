<fieldset>
<legend>Adicionar Empresa</legend>
<?php
echo $javascript->link('prototype');

echo $form->create('Instituicao');
echo $form->input('nome');
echo $form->input('endereco', array('rows' => '3'));
echo $form->input('numero');
echo $form->input('complemento');
echo $form->input('estado_id' ,array('options' => $estados, 'empty' => 'Selecione', 'id' => 'estado_id'), null);

echo $form->input('cidade_id' ,array('id' => 'cidade_id', 'options' => $cidades));
echo $form->input('tipo' ,array('options' => array('ESC' => 'Escola', 'DES' => 'Desenvolvedor de Jogos')));
echo $ajax->observeField('estado_id',  array('url' => 'update_select', 'update' => 'cidade_id'));

echo $form->input('telefone1');
echo $form->input('telefone2');

echo $form->input('email');
echo $form->input('site');
echo $form->input('contato');

echo $form->end('Salvar Empresa');
?>
</fieldset>