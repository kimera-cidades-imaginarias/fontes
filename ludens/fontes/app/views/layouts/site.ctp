<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title><?php echo $title_for_layout?></title>
        <?php echo $html->css('style.css');
              //echo $html->css('print.css');
              echo $html->css(array('print'), 'stylesheet', array('media' => 'print'));
        ?>

        <? echo $javascript->link('prototype'); ?>
        <? echo $javascript->link('jquery-1.4.2.min'); ?>
        <? echo $javascript->link('jquery.slidinglabels.min'); ?>
        <? echo $javascript->link('ludens'); ?>
        
        <?php echo $scripts_for_layout ?>

    </head>
    <body>
        <div id="login-area">
            <div id="login-area-wrapper">
                <?
                    if ($session->read('Auth.Usuario.nome') == '')
                    {
                        echo $form->create('Usuario', array('action' => 'login', 'class' => 'label-slide formulario formulario-topo'));
                        echo $session->flash('auth');
                        echo $form->input('email'   ,  array('size' => 20, 'label' => '_seu email'));
                        echo $form->input('password', array('size' => 20 , 'label' => '_senha'));
                        echo $form->end('Entrar');
                    }
                    else
                    {
                        $linkSair = $html->link('sair', '/usuarios/logout/'); 
                        echo '<div class="input password" style="position: relative;"><strong>Bem vindo(a) ' . $session->read('Auth.Usuario.nome') . ' [' . $linkSair . ']</strong></div>';
                    }
                ?>
                <!-- -->
                <ul id="social-links" >
                    <li><a href="http://www.twitter.com/cvirtuais/" title="Siga o Grupo Comunidades Virtuais no Twitter" target="_blank" id="twitter">Twitter</a></li>
                    <li><a href="/rss/" title="Assine o RSS do Grupo Comunidades Virtuais" target="_blank" id="rss">Rss</a></li>
                </ul>
            </div>
            <!--#login-area-wrapper-->
        </div>
        <!--#login-area-->
        <div id="site">
            <div id="header">
                <h1 id="logo-ludens"><?php echo $html->link('Ludens - Sistema de Avaliação', '/home/', array('title' => 'Ludens - Sistema de Avaliação')); ?></h1>
                <ul id="main-menu">
                    <?
                        $classesLinks = array('index' => '', 'sobre' => '', 'cadastro' => '', 'contato' => '', 'area_restrita' => '');
                        $classesLinks[$current_page] = 'current';
                    ?>
                    <li><?php echo $html->link('Home'    , '/home/'                 , array('class'=>$classesLinks['index'])); ?>&nbsp;&nbsp;&nbsp;/</li>
                    <li><?php echo $html->link('Sobre'   , '/sobre/'                , array('class'=>$classesLinks['sobre'])); ?>&nbsp;&nbsp;&nbsp;/</li>
                    <li><?php echo $html->link('Cadastro', '/usuarios/cadastro/'    , array('class'=>$classesLinks['cadastro'])); ?>&nbsp;&nbsp;&nbsp;/</li>
                    <? if ($session->read('Auth.Usuario.nome') != '') { ?>
                            <li><?php echo $html->link('Contato' , '/contatos/' , array('class'=>$classesLinks['contato'])); ?>&nbsp;&nbsp;&nbsp;/</li>
                            <li><?php echo $html->link('Área restrita' , '/relatorios/relatorios/', array('class'=>$classesLinks['area_restrita'])); ?></li>
                    <? } else { ?>
                            <li><?php echo $html->link('Contato' , '/contatos/' , array('class'=>$classesLinks['contato'])); ?></li>
                    <? }?>
                </ul>
            </div>
            <div id="body">

               <?php echo $content_for_layout ?>
               <div class="clear"></div>
            </div>
            <!-- #body-->
        </div>
        <!-- #site-->
        <div id="footer">
            <div id="footer-wrapper">
                <div id="footer2">
                     <?
                     $fapesb = $html->image('marcas/fapesb.jpg', array('alt' => 'Fundação de Amparo a Pesquisa do Estado da Bahia', 'class' => 'image-center' ));
                     $uneb   = $html->image('marcas/uneb.jpg', array('alt' => 'Universidade do Estado da Bahia', 'class' => 'image-center' ));
                     $comunidades = $html->image('marcas/comunidades.jpg', array('alt' => 'Grupo Comunidades Virtuais', 'class' => 'image-center' ));
                     $rede = $html->image('marcas/rede.jpg', array('alt' => 'Rede Brasileira de Jogos e Educação', 'class' => 'image-center' ));
                     $sbgames = $html->image('marcas/sbgames.jpg', array('alt' => 'SBGames 2011 Salvador', 'class' => 'image-center' ));
                     
                     echo $html->link($fapesb, 'http://www.fapesb.ba.gov.br', array('target' => 'blank' , 'escape' => false));
                     echo $html->link($uneb, 'http://www.uneb.br', array('target' => 'blank' , 'escape' => false));
                     echo $html->link($comunidades, 'http://www.comunidadesvirtuais.pro.br', array('target' => 'blank' , 'escape' => false));
                     //echo $rede;
                     echo $html->link($rede, 'http://www.comunidadesvirtuais.pro.br/rbje.htm', array('target' => 'blank' , 'escape' => false));
                     echo $html->link($sbgames, 'http://www.sbgames.org', array('target' => 'blank' , 'escape' => false));
                     ?>

                </div>
                <div id="copyright">LUDENS COPYRIGHT 2010 - Comunidades Virtuais - Coordenação: Lynn Alves </div>
                <div id="anderson"><a href="http://www.andersonsoares.com.br" title="Portifólio de Anderson" target="_blank">design ByAndi</a></div>
            </div>
        </div>
    </body>
</html>
