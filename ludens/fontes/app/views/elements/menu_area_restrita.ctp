    <?
        $classesLinks = array(  'relatorios' => '', 'grupos' => '', 'alunos' => '', 'jogos' => '',
                                'instrucoes' => '', 'importar' => '');
        $classesLinks[$pagina_area_restrita] = 'current';
    ?>
    <ul id="menu-restrito-tabs">
        <li id="first-child" class="<?=$classesLinks['relatorios']?>">
            <?php echo $html->link('Relatórios' , '/relatorios/relatorios/' , array('class'=>$classesLinks['relatorios'])); ?>
        </li>
        <li class="<?=$classesLinks['grupos']?>">
            <?php echo $html->link('Grupos'     , '/grupos/grupos/'         , array('class'=>$classesLinks['grupos'])); ?>
        </li>

        <?php
            if ($session->read('instituicao_tipo') == 'DES')
            {
        ?>
                <li class="<?=$classesLinks['alunos']?>">
                    <?php echo $html->link('Jogadores'  , '/jogadores/jogadores/'   , array('class'=>$classesLinks['alunos'])); ?>
                </li>
                <li class="<?=$classesLinks['jogos']?>">
                    <?php echo $html->link('Jogos'  , '/jogos/jogos/'   , array('class'=>$classesLinks['jogos'])); ?>
                </li>
         <?
            }
            else
            {
         ?>
                <li id="" class="<?=$classesLinks['alunos']?>">
                    <?php echo $html->link('Jogadores'  , '/jogadores/jogadores/'   , array('class'=>$classesLinks['alunos'])); ?>
                </li>
         <?
            }
         ?>
            <li id="last-child" class="<?=$classesLinks['importar']?>">
                <?php echo $html->link('Importar'  , '/indicadores/importar/'   , array('class'=>$classesLinks['importar'])); ?>
            </li>
        <!--
        <li id="last-child" class="<?=$classesLinks['instrucoes']?>">
            <?php echo $html->link('Instruções' , '/site/instrucoes/'       , array('class'=>$classesLinks['instrucoes'])); ?>
        </li>
        -->
    </ul>