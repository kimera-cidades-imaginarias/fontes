<h1>Relatório por Grupo</h1>
<h2><?=$instituicao['Instituicao']['nome']?></h2>
<h2><?=$grupo['Grupo']['nome']?></h2>
<?=$debug?>

<table width="100%">
    <tr><td colspan=<?=count($indicadores)+1?>><strong>indicadores</strong></td></tr>
    <tr>
        <td><strong>Jogadores</strong></td>
        <?php
            foreach ($indicadores AS $indicador) echo '<td>' . $indicador . '</td>';
        ?>
    </tr>

<?php
    foreach ($jogadores AS $jogador)
    {
        echo '<tr><td>' . $jogador['nome'] . '</td>';
        foreach ($jogador['registros'] AS $registro) echo '<td>' . $registro . '</td>';
        echo '</tr>';
    }

    echo '<tr><td>Média</td>';
    foreach ($medias AS $media)
    {
        echo '<td><strong>' . $media . '</strong></td>';
    }
    echo '</tr>';
?>
</table>
