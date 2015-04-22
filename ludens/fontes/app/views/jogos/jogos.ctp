<div id="area-restrita" class="full-box">
     <? echo $this->element('header_area_restrita'); ?>
    <div class="full-box-content">
        <? echo $this->element('menu_area_restrita'); ?>
        <div class="clear"></div>
        <div class="tabs" id="area-restrita-tabs-content">
            <div id="aba-relatorio">
                <? echo $session->flash(); ?>
                <br/>
                <h3 id="relatorio-title">Jogos</h3>
                <?
                    echo $html->link('Novo Jogo', '/jogos/editar/', array('class' => 'botao-grande'));
                ?>

                <div id="relatorio-resultado">
                    <div id="relatorio-resultado-box">
                        <table cellpadding="0" cellspacing="0">
                            <thead>
                                <tr>
                                    <th scope="col">Nome</th>
                                    <th scope="col">Código</th>
                                    <th scope="col">Ações</th>
                                </tr>
                            </thead>
                            <tfoot>
                                <tr>
                                    <td>&nbsp;</td>
                                    <td>&nbsp;</td>
                                    <td>&nbsp;</td>
                                </tr>
                            </tfoot>
                            <tbody>
                                <?
                                    if (count($jogos) == 0)
                                    {
                                        echo '<tr><td colspan="3">Nenhum registro encontrado.</td></tr>';
                                    }

                                    foreach ($jogos as $jogo)
                                    {
                                        echo '<tr>' .
                                                '<td style="text-align: left; ">' .
                                                    $jogo['Jogo']['nome'] .
                                                '</td>' .
                                                '<td style="text-align: left; ">' .
                                                    $jogo['Jogo']['codigo'] .
                                                '</td>' .
                                                '<td>' .
                                                    $html->link('[Editar Indicadores]',
                                                                '/indicadores/indicadores/' . $jogo['Jogo']['id'] . '/') .
                                                    '&nbsp;&nbsp;' .
                                                    $html->link('[Editar]',
                                                                '/jogos/editar/' . $jogo['Jogo']['id'] . '/') .
                                                    '&nbsp;&nbsp;' .
                                                    $html->link('[Remover]',
                                                                '/jogos/remover/' . $jogo['Jogo']['id'] . '/') .
                                                '</td>' .
                                             '</tr>';
                                    }
                                ?>
                            </tbody>
                        </table>
                    </div><!--#relatorio-resultado-box-->
                    <!--<a href="#" id="imprimir">imprimir relatório</a>-->
                    <br/><br/>
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