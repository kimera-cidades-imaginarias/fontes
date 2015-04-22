    <div class="full-box-header">
        <?php
            if ($session->read('instituicao_tipo') == 'ESC')
            {
                echo '<h2 class="big-box-title" id="professor-login"><span class="link-op-img"></span>área restrita do professor</h2>';
            }
            else
            {
                echo '<h2 class="big-box-title" id="desenvolvedor-login"><span class="link-op-img"></span>área restrita do desenvolvedor</h2>';
            }
        ?>
        
        <?php echo $html->link('Meu cadastro'   , '/usuarios/editar/'   , array('class' => 'menu2-area-restrita meu-cadastro-link')); ?>
        <?php echo $html->link('Sair'           , '/usuarios/logout/'   , array('class' => 'menu2-area-restrita sair-link')); ?>
    </div>