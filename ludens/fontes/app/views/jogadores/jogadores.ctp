<script>
    function RemoverRegistros(id)
    {
        var answer = confirm("Tem certeza que deseja remover todos os registros de indicadores associados a este jogador?");
	if (answer){
            window.location = '/ludens/jogadores/remover_indicadores/' + id + '/';
	}
    }
</script>
<div id="area-restrita" class="full-box">
     <? echo $this->element('header_area_restrita'); ?>
    <div class="full-box-content">
        <? echo $this->element('menu_area_restrita'); ?>
        <div class="clear"></div>
        <div class="tabs" id="area-restrita-tabs-content">
            <div id="aba-relatorio">
                <? echo $session->flash(); ?>
                <br/>
                <h3 id="relatorio-title">Jogadores</h3>
                <?
                    echo $html->link('Novo Jogador', '/jogadores/editar/', array('class' => 'botao-grande'));
                ?>

                 <?
                    echo $form->create('Grupos',
                                            array('url' =>
                                                  array('controller' => 'jogadores',
                                                        'action'     => 'jogadores' ),
                                                  'class' => 'label-side formulario'));

                    echo $form->input('grupo',
                                        array('options' => $grupos,
                                              'empty' => 'Todos',
                                              'id' => 'grupo_id'));
                    echo $form->end(array('label' => 'Filtrar', 'class' => 'botao-grande'));
                ?>
                <div id="relatorio-resultado">
                    <div id="relatorio-resultado-box">
                        <table cellpadding="0" cellspacing="0">
                            <thead>
                                <tr>
                                    <th scope="col">Nome</th>
                                    <th scope="col">E-mail</th>
                                    <th scope="col">Nascimento</th>
                                    <th scope="col">Matrícula</th>
                                    <th scope="col">Ações</th>
                                </tr>
                            </thead>
                            <tfoot>
                                <tr>
                                    <td>&nbsp;</td>
                                    <td>&nbsp;</td>
                                    <td>&nbsp;</td>
                                    <td>&nbsp;</td>
                                    <td>&nbsp;</td>
                                </tr>
                            </tfoot>
                            <tbody>
                                <?
                                    if (count($jogadores) == 0)
                                    {
                                        echo '<tr><td colspan="5">Nenhum registro encontrado.</td></tr>';
                                    }

                                    foreach ($jogadores as $jogador)
                                    {
                                        echo '<tr>' .
                                                '<td style="text-align: left; ">' .
                                                    $jogador['Jogador']['nome'] .
                                                '</td>' .
                                                '<td style="text-align: left; ">' .
                                                    $jogador['Jogador']['email'] .
                                                '</td>' .
                                                '<td style="text-align: left; ">' .
                                                    $jogador['Jogador']['nascimento'] .
                                                '</td>' .
                                                '<td style="text-align: left; ">' .
                                                    $jogador['Jogador']['matricula'] .
                                                '</td>' .
                                                '<td>' .
                                                    $html->link('[Editar]',
                                                                '/jogadores/editar/' . $jogador['Jogador']['id'] . '/') .
                                                    '&nbsp;&nbsp;' .
                                                    $html->link('[Remover]',
                                                                '/jogadores/remover/' . $jogador['Jogador']['id'] . '/') .
                                                    '&nbsp;&nbsp;' .
                                                    $html->link('[Remover registros]',
                                                                '/jogadores/remover_indicadores/' . $jogador['Jogador']['id'] . '/') .
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