<?php
    echo $javascript->link('prototype');
?>

<h2><?php echo $pluralHumanName;?></h2>
<table cellpadding="0" cellspacing="0">
<tr>
    <th><?php echo $this->Paginator->sort('nome');?></th>
    <th><?php echo $this->Paginator->sort('email');?></th>
    <th>Ações</th>
</tr>
<?php
$i = 0;
foreach (${$pluralVar} as ${$singularVar}):
	$class = null;
	if ($i++ % 2 == 0) {
		$class = ' class="altrow"';
	}
echo "\n";
	echo "\t<tr{$class}>\n";
            echo "\t\t<td>\n\t\t\t" . ${$singularVar}[$modelClass]['nome'] . " \n\t\t</td>\n";
            echo "\t\t<td>\n\t\t\t" . ${$singularVar}[$modelClass]['email'] . " \n\t\t</td>\n";	

            echo "\t\t<td class=\"actions\">\n";
            echo "\t\t\t" . $this->Html->link(__('View', true), array('action' => 'view', ${$singularVar}[$modelClass][$primaryKey])) . "\n";
            echo "\t\t\t" . $this->Html->link(__('Edit', true), array('action' => 'edit', ${$singularVar}[$modelClass][$primaryKey])) . "\n";
            echo "\t\t\t" . $this->Html->link(__('Delete', true), array('action' => 'delete', ${$singularVar}[$modelClass][$primaryKey]), null, __('Are you sure you want to delete', true).' #' . ${$singularVar}[$modelClass][$primaryKey]) . "\n";
            echo "\t\t</td>\n";
	echo "\t</tr>\n";

endforeach;
echo "\n";
?>
</table>
	<p><?php
	echo $this->Paginator->counter(array(
		'format' => __('Página %page% de %pages%, exibindo %current% registros de um total de %count%, de %start% até %end%', true)
	));
	?></p>
	<div class="paging">
	<?php echo "\t" . $this->Paginator->prev('<< ' . __('previous', true), array(), null, array('class' => 'disabled')) . "\n";?>
	 | <?php echo $this->Paginator->numbers() . "\n"?>
	<?php echo "\t ". $this->Paginator->next(__('next', true) .' >>', array(), null, array('class' => 'disabled')) . "\n";?>
	</div>
