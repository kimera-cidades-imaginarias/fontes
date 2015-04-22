<div id="area-restrita" class="full-box">
     <? echo $this->element('header_area_restrita'); ?>
    <div class="full-box-content">
        <? echo $this->element('menu_area_restrita'); ?>
        <div class="clear"></div>
        <div class="tabs" id="area-restrita-tabs-content">
            <div id="aba-relatorio">
                <? echo $session->flash(); ?>
                <br/>
                <h3 id="relatorio-title">Grupos de Jogadores</h3>
                <?
                    echo $html->link('Novo Grupo', '/grupos/editar/', array('class' => 'botao-grande'));
                ?>

                <div id="relatorio-resultado">
                    <div id="relatorio-resultado-box">
                        <table cellpadding="0" cellspacing="0">
                            <thead>
                                <tr>
                                    <th scope="col" width="550px">Nome</th>
                                    <th scope="col">Ações</th>
                                </tr>
                            </thead>
                            <tfoot>
                                <tr>
                                    <td>&nbsp;</td>
                                    <td>&nbsp;</td>
                                </tr>
                            </tfoot>
                            <tbody>
                                <?
                                    if (count($grupos) == 0)
                                    {
                                        echo '<tr><td colspan="2">Nenhum registro encontrado.</td></tr>';
                                    }
                                    
                                    foreach ($grupos as $id => $nome)
                                    {
                                        echo '<tr>' .
                                                '<td style="text-align: left; ">' .
                                                    $nome .
                                                '</td>' .
                                                '<td>' .
                                                    $html->link('[Editar]',
                                                                '/grupos/editar/' . $id . '/') .
                                                    '&nbsp;&nbsp;' .
                                                    $html->link('[Remover]',
                                                                '/grupos/remover/' . $id . '/') .
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