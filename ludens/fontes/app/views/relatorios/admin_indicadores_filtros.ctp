<?php
    /*
     * To change this template, choose Tools | Templates
     * and open the template in the editor.
     */
    echo $javascript->link('prototype');

    echo $form->create('Indicadores', array('url' => array('controller' => 'relatorios', 'action' => 'gerar_indicadores')));

    echo $form->input('jogo'    , array('options' => $jogos     , 'id' => 'jogo_id'), null);
    echo $form->input('instituicao' , array('options' => $instituicoes  , 'id' => 'instituicao_id', 'empty' => 'Selecione uma instituição.'), null);
    echo $form->input('grupo'   , array('options' => array('' => 'Selecione uma instituição.'), 'id' => 'grupo_id', 'after' => '<span class="ajax_update" id="ajax_indicator" style="display:none;">&nbsp;' . $html->image('loading.gif') . '</span>'));
    ?>

    <div id='container-jogadores'>
        <span class='ajax_update' id='ajax_indicator' style='display:none;'>
            <? echo $html->image('loading.gif'); ?>
        </span>
    </div>

    <?
    // Ajax: seleção de instituição.
    echo $ajax->observeField('instituicao_id',  array(  'url' => 'atualizar_grupos',
                                                        'update' => 'grupo_id',
                                                        'before'=>"Element.show('ajax_indicator')",
                                                        'complete'=>"Element.hide('ajax_indicator');")
    );

    // Ajax: seleção de grupo;
    echo $ajax->observeField('grupo_id',  array(        'url' => 'atualizar_jogadores',
                                                        'update' => 'container-jogadores',
                                                        'before'=>"Element.show('ajax_indicator')",
                                                        'complete'=>"Element.hide('ajax_indicator');")
    );

    echo $form->end('Gerar relatório');
?>
