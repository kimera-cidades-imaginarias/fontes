<div id="area-restrita" class="full-box">
     <? echo $this->element('header_area_restrita'); ?>
    <div class="full-box-content">
        <? echo $this->element('menu_area_restrita'); ?>
        <div class="clear"></div>
        <div class="tabs" id="area-restrita-tabs-content">
            <div id="aba-relatorio">
                <? echo $session->flash(); ?>
                <h3 id="relatorio-title">Novo Grupo</h3>
                <?
                    echo $form->create('Grupo', array('class' => 'label-side formulario'));
                    echo $form->input('nome');
                    echo $form->input( 'grupo_pai_id',
                                       array('options' => $grupos_pai,
                                             'label'   => 'Grupo pai') );
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