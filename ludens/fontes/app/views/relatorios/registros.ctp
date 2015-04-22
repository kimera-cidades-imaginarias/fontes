<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title>Ludens - Área restrita do usuário</title>
        <link rel="stylesheet" type="text/css" href="/ludens/css/style.css" />
	<link rel="stylesheet" type="text/css" href="/ludens/css/print.css" media="print" />

        <script type="text/javascript" src="/ludens/js/prototype.js"></script>        <script type="text/javascript" src="/ludens/js/jquery-1.4.2.min.js"></script>        <script type="text/javascript" src="/ludens/js/jquery.slidinglabels.min.js"></script>        <script type="text/javascript" src="/ludens/js/ludens.js"></script>

    </head>
    <body>
        <div id="relatorio-resultado">
            <div id="relatorio-resultado-box">
                <div id="dados-aluno">
                    <strong><?php echo $jogador;?></strong><br/>
                    <?php echo $indicador;?><br />
                </div>
                <table width="200px">
                    <thead>
                        <tr>
                            <th>Data</th>
                            <th>Valor</th>
                        </tr>
                    </thead>
                    <tbody>
                    <?php foreach ($registros as $registro): ?>
                        <tr>
                            <td><?php echo $registro['data']; ?></td>
                            <td><?php echo $registro['valor']; ?></td>
                        </tr>
                    <?php endforeach; ?>
                    </tbody>
                    <tfoot>
                        <tr>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                        </tr>
                    </tfoot>
                </table>
            </div>
        </div>
    </body>
</html>