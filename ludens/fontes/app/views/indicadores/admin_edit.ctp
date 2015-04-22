<fieldset>
<legend>Editar Indicador</legend>
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
echo $form->input('tipo'    , array('options' => $tipos));
echo $form->input('jogo_id' , array('options' => $jogos));
$apresentacoes = array(
    1 => 'Primeiro registro realizado',
    2 => 'Último registro realizado',
    3 => 'Menor dos registros',
    4 => 'Maior dos registros',
    5 => 'Soma dos registros',
    6 => 'Média dos registros'
);
echo $form->input('exibir'    , array('options' => $apresentacoes));

echo $form->end('Salvar Indicador');
?>
</fieldset>