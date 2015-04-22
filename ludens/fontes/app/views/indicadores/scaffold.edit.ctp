<fieldset>
<legend>Adicionar Indicador</legend>
<?php

echo $form->create('Indicador');
echo $form->input('nome');
echo $form->input('codigo');
echo $form->input('descricao', array('rows' => '3'));

$tipos = array(
    1 => 'Taxa de leitura (caracteres por segundo)',
    2 => 'Tempo (hh:mm:ss)',
    3 => 'Sim/Não',
    4 => 'Quantidade (número)'
);
echo $form->input('tipo'    , array('options' => $tipos), null);
echo $form->input('jogo');


echo $form->end('Salvar Indicador');
?>
</fieldset>