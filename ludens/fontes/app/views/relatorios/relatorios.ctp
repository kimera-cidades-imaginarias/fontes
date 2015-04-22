<script>
    function Expandir(aluno_id, indicador_id)
    {
        window.open ("../relatorios/registros/" + aluno_id + "/" + indicador_id + "/", "", "status=0,toolbar=0,width=400,height=500");
    }
</script>
<div id="area-restrita" class="full-box">
     <? echo $this->element('header_area_restrita'); ?>
    <div class="full-box-content">
        <? echo $this->element('menu_area_restrita'); ?>
        <div class="clear"></div>
        <div class="tabs" id="area-restrita-tabs-content">
            <div id="aba-relatorio">
                <h3 id="relatorio-title">Relatório de Grupos/Jogadores</h3>
                <?
                    echo $form->create('Indicadores',
                                            array('url' =>
                                                  array('controller' => 'relatorios',
                                                        'action'     => 'relatorios' ),
                                                  'class' => 'label-side formulario'));
                    echo $form->input('instituicao', array('type' => 'hidden',
                                                           'value' => $session->read('Auth.Usuario.instituicao_id')));
                    echo $form->input('jogo'        ,
                                        array('options' => $jogos,
                                              'id' => 'jogo_id'), null);

                    echo $form->input('grupo',
                                        array('options' => $grupos,
                                              'empty' => 'Selecione um grupo...',
                                              'id' => 'grupo_id',
                                              'after' => '<span class="ajax_update" id="ajax_indicator" style="display:none;">&nbsp;' .
                                                         $html->image('loading4.gif') .
                                                         '</span>'));

                    if ($jogador_selecionado == null)
                    {
                        $content = $html->image('loading4.gif');
                        $class   = 'display:none;';
                    }
                    else
                    {
                        $class  = '';
                        $content = $form->input('jogador',
                                        array('options' => $jogadores,
                                              'empty' => 'Todos',
                                              'id' => 'jogador_id'));
                    }
                ?>

                <div id='container-jogadores'>
                    <span class='ajax_update' id='ajax_indicator' style='<?php echo $class?>'>
                        <? echo $content; ?>
                    </span>
                </div>
                <br/>
                <?

                // Ajax: seleção de grupo;
                echo $ajax->observeField('grupo_id',  array(        'url'       => 'atualizar_jogadores',
                                                                    'update'    => 'container-jogadores',
                                                                    'before'    =>"Element.show('ajax_indicator')",
                                                                    'complete'  =>"Element.hide('ajax_indicator');")
                );

                echo $form->end(array('label' => 'Gerar relatório', 'class' => 'botao-grande'));
                ?>

                <div id="relatorio-resultado">
                    <div id="relatorio-resultado-box">

                        <? if ($relatorio) { ?>
                            <? if (isset($jogador)) { ?>
                                <h3>Relatório Individual</h3>
                            <? } else { ?>
                                <h3>Relatório de Grupo</h3>
                            <? } ?>
                            <div id="dados-aluno">
                                <?
                                if (isset($jogador))
                                {
                                    echo '<strong>' . $jogador['Jogador']['nome'] . '</strong><br/>';
                                    echo $grupo['Grupo']['nome'];
                                }
                                else
                                {
                                    echo '<strong>' . $grupo['Grupo']['nome'] . '</strong>';
                                }
                                ?>
                                <br />
                                <? echo $instituicao['Instituicao']['nome']; ?><br />
                            </div>
                            <p>
                                <span class="img-caption"><? echo $jogo['Jogo']['nome']; ?></span>
                            </p>
                            <table cellpadding="0" cellspacing="0">
                                <thead>
                                    <tr>
                                        <th scope="col">Indicadores</th>
                                        <?
                                            $linha = $resultado[0];
                                            for ($c = 1; $c < count($linha); $c++)
                                            {
                                                echo '<th scope="row">' . $linha[$c] . '</td>';
                                            }
                                        ?>

                                    </tr>
                                </thead>
                                <tfoot>
                                    <tr>
                                         <?
                                            for ($c = 0; $c < count($linha); $c++)
                                            {
                                                echo '<td>&nbsp;</td>';
                                            }
                                        ?>
                                    </tr>
                                </tfoot>
                                <tbody>
                                    <?
                                        for ($l = 1; $l < count($resultado); $l++)
                                        {
                                            $linha = $resultado[$l];

                                            echo '<tr>';

                                            for ($c = 0; $c < count($linha); $c++)
                                            {
                                                if ($c == 0) echo '<th scope="row">' . $linha[0][0] . ' [<a style="cursor:pointer;" title="' . $linha[0][1] . '">?</a>]</td>';
                                                else
                                                {
                                                    if ($c == 1 && isset($jogador) && $linha[$c]!='-')
                                                    {
                                                        echo '<td><a href="javascript:Expandir(' . $jogador['Jogador']['id'] . ', ' .  $linha[0][2] . ');">' . $linha[$c] . '</a></td>';
                                                    }
                                                    else echo '<td>' . $linha[$c] . '</td>';
                                                }
                                            }

                                            echo '</tr>';
                                        }
                                    ?>

                                </tbody>
                            </table>
                            <p>RELATÓRIO GERADO EM <? echo date('d.m.Y') . ' ÀS ' . date('H:i') . 'h'; ?></p>
                        <? } else { ?>
                            Selecione os filtros e clique em gerar.
                        <? } ?>
                    </div><!--#relatorio-resultado-box-->
                    <? if ($relatorio) { ?>
                    <a href="javascript:window.print()" id="imprimir">imprimir relatório</a>
                    <? } else { ?>
                    <br/><br/>
                    <? } ?>
                    <div class="clear"></div>
                </div><!-- aba1-->
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