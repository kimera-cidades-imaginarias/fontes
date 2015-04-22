<div id="area-restrita" class="full-box">
     <? echo $this->element('header_area_restrita'); ?>
    <div class="full-box-content">
        <? echo $this->element('menu_area_restrita'); ?>
        <div class="clear"></div>
        <div class="tabs" id="area-restrita-tabs-content">
            <div id="aba-relatorio">
                <? echo $session->flash(); ?>
                <h3 id="relatorio-title">Novo Jogo</h3>
                <?
                    echo $form->create('Jogo', array('class' => 'label-side formulario'));
                    echo $form->input('nome');
                    echo $form->input('genero_id', array('options' => $generos));
                    echo $form->input('codigo');
                    echo $form->input('instituicao_id',
                                      array('type' => 'hidden',
                                            'value' => $session->read('Auth.Usuario.instituicao_id')));
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