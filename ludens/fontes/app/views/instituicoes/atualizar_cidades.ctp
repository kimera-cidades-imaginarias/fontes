<option value=''>Cidade...</option>
<?
    foreach($cidades as $k => $v)
    {
        echo "<option value=\"$k\">" . $v['Cidade']['nome'] . "</option>\n";
    }
?>