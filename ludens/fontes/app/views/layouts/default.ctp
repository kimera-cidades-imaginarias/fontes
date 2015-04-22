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
 * @subpackage    cake.cake.libs.view.templates.layouts
 * @since         CakePHP(tm) v 0.10.0.1076
 * @license       MIT License (http://www.opensource.org/licenses/mit-license.php)
 */
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<?php echo $this->Html->charset(); ?>
	<title>
		<?php echo $title_for_layout; ?>
	</title>
	<?php
		echo $this->Html->meta('icon');
		echo $this->Html->css('cake.generic');
                echo $javascript->link('prototype');
		echo $scripts_for_layout;
	?>
</head>
<body>
	<div id="container">
		<div id="header">
                    <h1>LUDENS - Painel de Administração</h1>
                    <? echo $html->link('Logout', '/admin/administradores/logout', array('class' => 'btn-logout')); ?>
		</div>
		<div id="content">

			<?php echo $this->Session->flash(); ?>

                        <div class="view">
                            <?php echo $content_for_layout; ?>
                        </div>
                    
                        <div class="actions">
                            <h3><?php __('Actions'); ?></h3>
                            <ul>
                                <? if (isset($singularHumanName)): ?>
                                <li><?php echo $this->Html->link(sprintf(__('Novo(a) %s', true), $singularHumanName), array('action' => 'add')); ?></li>
                                <br/>
                                <br/>
                                <? endif; ?>
                                <li> <?=$this->Html->link("Instituições", array('controller' => "instituicoes", 'action' => 'index'))?> </li>
                                <li> <?=$this->Html->link("Jogos"   , array('controller' => "jogos", 'action' => 'index'))?> </li>
                                <li> <?=$this->Html->link("Gêneros" , array('controller' => "generos", 'action' => 'index'))?> </li>
                                <li> <?=$this->Html->link("Estados" , array('controller' => "estados", 'action' => 'index'))?> </li>
                                <li> <?=$this->Html->link("Banners" , array('controller' => "banners", 'action' => 'index'))?> </li>
                                <li> <?=$this->Html->link("Administradores" , array('controller' => "administradores", 'action' => 'index'))?> </li>
                            </ul>
                            <br/>
                            <br/>
                            <h3>Relatórios</h3>
                            <ul>
                                <li> <?=$this->Html->link("Indicadores", array('controller' => "relatorios", 'action' => 'indicadores_filtros'))?> </li>
                            </ul>
                        </div>
		</div>
		<div id="footer">
			<?php echo $this->Html->link(
					$this->Html->image('cake.power.gif', array('alt'=> __('CakePHP: the rapid development php framework', true), 'border' => '0')),
					'http://www.cakephp.org/',
					array('target' => '_blank', 'escape' => false)
				);
			?>
		</div>
	</div>
	<?php echo $this->element('sql_dump'); ?>
</body>
</html>
