<div id="area-restrita" class="full-box">
     <? echo $this->element('header_area_restrita'); ?>
    <div class="full-box-content">
        <? echo $this->element('menu_area_restrita'); ?>
        <div class="clear"></div>
        <div class="tabs" id="area-restrita-tabs-content">
            <div id="aba-relatorio">
                <? echo $session->flash(); ?>
                <h3 id="relatorio-title">Novo Indicador</h3>
                <?
                    echo $form->create('Indicador', array('class' => 'label-side formulario'));
                    echo $form->input('nome');
                    echo $form->input('codigo');
                    echo $form->input('descricao');

                    $tipos = array(
                        1 => 'Taxa de leitura (caracteres por segundo)',
                        2 => 'Tempo (hh:mm:ss)',
                        3 => 'Sim/Não',
                        4 => 'Quantidade (número)'
                    );

                    echo $form->input('tipo'    , array('options' => $tipos), null);
                    echo $form->input('jogo_id',
                                      array('type' => 'hidden',
                                            'value' => $jogo_id));

                    $apresentacoes = array(
                        1 => 'Primeiro registro realizado',
                        2 => 'Último registro realizado',
                        3 => 'Menor dos registros',
                        4 => 'Maior dos registros',
                        5 => 'Soma dos registros',
                        6 => 'Média dos registros'
                    );
                    echo $form->input('exibir'    , array('options' => $apresentacoes));

                    echo '<br/><br/>';
                    echo $form->end(array('label' => 'Salvar', 'class' => 'botao-grande'));
                ?>
                <div class="clear"></div>
            </div> <!-- .tabst#relatorio-resultado-->
        </div><!-- #area-restrita-tabs-content-->
    </div><!-- #area-restrita-content-->
    <span class="full-box--footer"></span>
</div><!--#contato-->

<?
    echo $this->element('saj');
    echo $this->element('cadastre');
    echo $this->element('novidades');
?>