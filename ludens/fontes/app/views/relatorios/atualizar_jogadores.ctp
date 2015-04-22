<?
    if (count($jogadores) > 0)
    {
?>
<div class="input select">
    <label for="grupo_id">Jogador</label>
    <select name="data[Indicadores][jogador]" id="grupo_id">
        <option value="0">Todos (grupo)</option>
        <?
            foreach($jogadores as $jogador)
            {
                 echo '<option value="' . $jogador['id'] . '">' . $jogador['nome'] . '</option>\n';
            }
        ?>
    </select>
</div>
<?
    }
    else if (!$grupoInvalido) echo "Nenhum jogador neste grupo.";
?>