<div id="area-restrita" class="full-box">
     <? echo $this->element('header_area_restrita'); ?>
    <div class="full-box-content">
        <? echo $this->element('menu_area_restrita'); ?>
        <div class="clear"></div>
        <div class="tabs" id="area-restrita-tabs-content">
            <div id="aba-relatorio">
                <? echo $session->flash(); ?>
                <h3 id="relatorio-title">Novo Jogador</h3>
                <?
                    echo $form->create('Jogador', array('class' => 'label-side formulario'));
                    echo $form->input('nome');
                    echo $form->input('email');
                    echo $form->input('matricula');
                    echo $form->input('senha', array('type' => 'password'));
                    echo $form->input('nascimento', array(  'class' => 'data-select',
                                                            'minYear' => date('Y') - 70,
                                                            'maxYear' => date('Y') - 2));
                    echo $form->input('instituicao_id',
                                      array('type' => 'hidden',
                                            'value' => $session->read('Auth.Usuario.instituicao_id')));
                    echo $form->input('Grupo', array('options' => $grupos));
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