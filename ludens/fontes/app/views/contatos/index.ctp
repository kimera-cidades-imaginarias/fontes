<div id="contato" class="full-box">
    <div class="full-box-header">
        <h2 class="big-box-title"><strong>contato /</strong> tire suas dúvidas e faça sugestões</h2>
    </div>
    <div id="contato-content" class="full-box-content">
        <?php           
            echo $form->create('Contato', array('action' => 'index', 'class' => 'label-slide formulario'));
            echo $form->input('nome');
            echo $form->input('email');
            echo $form->input('mensagem');
            echo $form->end( array('label' => 'Enviar', 'value' => 'Enviar', 'class' => 'botao-enviar') );
        ?>
        <div  id="outros-contatos" >
            <p>Utilize o painel ao lado para entrar em contato conosco ou ainda pelos telefones abaixo:</p>
            <ul>
                <li>[71] <strong>3344-5566</strong></li>
                <li>[71] <strong>8822-7711</strong></li>
            </ul>
            <br/><br/>
            <? echo $session->flash(); ?>
        </div>
        <div class="clear"></div>
    </div>
    <span class="full-box--footer"></span>
</div>

<?
    echo $this->element('saj');
    echo $this->element('cadastre');
    echo $this->element('novidades');
?>