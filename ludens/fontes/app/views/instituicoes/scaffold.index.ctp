<?php
/**
 *
 * PHP versions 4 and 5
 *
 * CakePHP(tm) : Rapid Development Framework (http://cakephp.org)
 * Copyright 2005-2010, Cake Software Foundation, Inc. (http://cakefoundation.org)
 *
 * Licensed under The MIT License
 * Redistributions of files must retain the above copyright notice.
 *
 * @copyright     Copyright 2005-2010, Cake Software Foundation, Inc. (http://cakefoundation.org)
 * @link          http://cakephp.org CakePHP(tm) Project
 * @package       cake
 * @subpackage    cake.cake.console.libs.templates.views
 * @since         CakePHP(tm) v 0.10.0.1076
 * @license       MIT License (http://www.opensource.org/licenses/mit-license.php)
 */
?>
<h2><?php echo $pluralHumanName;?></h2>

<div id="loading-div" style="display: none;">
    <?php echo $html->image('loading.gif'); ?>
</div>

<table cellpadding="0" cellspacing="0">
<tr>
	<th><?php echo $this->Paginator->sort('nome');?></th>
        <th><?php echo $this->Paginator->sort('telefone1');?></th>
        <th><?php echo $this->Paginator->sort('email');?></th>

	<th><?php __('Actions');?></th>
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
            echo "\t\t<td>\n\t\t\t" . ${$singularVar}[$modelClass]['telefone1'] . " \n\t\t</td>\n";
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

<div id="ajax-paging">
    <p>
        <?php
        //$this->Paginator->options(array('update'=>'content','indicator'=>'loading-div'));
        echo $this->Paginator->counter(array(
                'format' => __('Página %page% de %pages%, exibindo %current% registros de um total de %count%, de %start% até %end%', true)
        ));
        ?>
    </p>
    <div class="paging">
        <?php echo "\t" . $this->Paginator->prev('<< ' . __('previous', true), array(), null, array('class' => 'disabled')) . "\n";?>
         | <?php echo $this->Paginator->numbers() . "\n"?>
        <?php echo "\t ". $this->Paginator->next(__('next', true) .' >>', array(), null, array('class' => 'disabled')) . "\n";?>
    </div>
</div>
