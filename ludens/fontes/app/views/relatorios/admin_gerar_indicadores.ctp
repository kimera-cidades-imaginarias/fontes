<h1>Relatório por Grupo</h1>
<h2><?=$instituicao['Instituicao']['nome']?></h2>
<h2>
    <?
        if (isset($jogador)) echo $jogador['Jogador']['nome'];
    ?>
</h2>
<?=$debug?>

<table width="100%">
<?
    for ($l = 0; $l < count($resultado); $l++)
    {
        $linha = $resultado[$l];

        echo '<tr>';
        
        for ($c = 0; $c < count($linha); $c++)
        {
            echo '<td>' . $linha[$c] . '</td>';
        }

        echo '</tr>';
    }
?>
</table>
