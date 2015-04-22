<div id="area-restrita" class="full-box">
     <? echo $this->element('header_area_restrita'); ?>
    <div class="full-box-content">
        <? echo $this->element('menu_area_restrita'); ?>
        <div class="clear"></div>
        <div class="tabs" id="area-restrita-tabs-content">
            <div id="aba-relatorio">
                <? echo $session->flash(); ?>
                <br/>
                <h3 id="relatorio-title">Importação de indicadores</h3>
                <p>
                    Informe um arquivo de registro de indicadores e clique em importar. O tamanho máximo permitido é 1Mb.
                </p>
                <?
                    echo $form->create('Indicador',
                                            array('url' =>
                                                  array('action'     => 'importar' ),
                                                  'class' => 'label-side formulario',
                                                  'enctype' => 'multipart/form-data'));
                    echo $form->file('arquivo');
                    echo '<br/><br/>';
                    echo $form->end(array('label' => 'Importar', 'class' => 'botao-grande'));
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