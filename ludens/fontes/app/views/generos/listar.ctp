<h1>Gêneros de jogos</h1>
<table>
	<tr>
		<th>Id</th>
		<th>Nome</th>
                <th>Ações</th>
	</tr>

	<!-- Here is where we loop through our $posts array, printing out post info -->

	<?php foreach ($generos as $r): ?>
	<tr>
		<td><?php echo $r['Genero']['id']; ?></td>
		<td>
                    <?php echo $html->link($r['Genero']['nome'], array('controller' => 'generos', 'action' => 'editar', $r['Genero']['id'])); ?>
		</td>
                <td>
                    <?php echo $html->link('Remover', array('action' => 'remover', $r['Genero']['id']), null, 'Você tem certeza?' )?>
                </td>
	</tr>
	<?php endforeach; ?>

</table>
<?php echo $html->link('Novo',array('controller' => 'generos', 'action' => 'adicionar'))?>
