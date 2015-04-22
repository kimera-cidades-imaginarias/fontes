<div id="cadastro-box" class="conteudo-central">
    <div class="big-box">
        <h2 class="big-box-title"><strong>cadastro /</strong> utilize o sistema gratuitamente!</h2>
        <div class="big-box-content">
            <? echo $html->image('sobre-img.jpg', array('alt' => 'Cadastro no Ludens', 'align' => 'Cadastro' )); ?>
            <!--
            <ul id="cadastro-menu">
                <li><a href="#" title="Sou Professor" id="professor" class="opcao-cadastro"><span class="link-op-img"></span>Sou Professor / Educador</a></li>
                <li><a href="#" title="Sou Desenvolvedor" id="deselvolvedor" class="opcao-cadastro"><span class="link-op-img"></span>Sou desenvolvedor</a></li>
            </ul>
            -->
            <br/>
            <p>
                Para usar o Ludens, você deve realizar um cadastro. Uma vez cadastrado, você poderá acessar a área restrita.
                Se você for um <em>educador</em>, poderá gerenciar grupos, alunos e também gerar relatórios.
                Se você for um <em>desenvolvedor</em>, poderá também cadastrar jogos e gerenciar os indicadores de cada jogo.
            </p>
            <p>
                Caso sua instituição não esteja presente na lista de instituições, primeiro será necessário cadastra-lá. É simples e rápido e você será redirecionado novamente para essa página.
            </p>
            <p>
                Se você já realizou o seu cadastro mas não recebeu as informações de acesso no e-mail informado, por favor verifique sua caixa de SPAM. Caso não exista nenhuma mensagem em sua caixa de SPAM, clique aqui para reenviarmos suas informações de acesso.
            </p>
            <br/>
            <?
                $flash = $session->flash();
                if ($flash != '') echo $flash . '<br/>';
            ?>
            <fieldset>
            <legend>Cadastro de usuário</legend>
            <?php
                echo $form->create('Usuario', array('class' => 'label-slide formulario'));
                echo $form->input('instituicao_id', array(  'empty' => 'Instituição...',
                                                            'label' => '',
                                                            'options' => $instituicoes,
                                                            'after' => ' <br/>Sua instituição não está na lista? ' . $html->link('Clique aqui', '/instituicoes/cadastro/') . ' para cadastrá-la!'));
                echo $form->input('nome');
                echo $form->input('email');
                echo $form->input('password');
                echo $form->input('confirmar_senha', array('type' => 'password'));
                echo $form->end( array('label' => 'Enviar', 'value' => 'Enviar', 'class' => 'botao-enviar') );
            ?>
            </fieldset>
            <? echo $flash; ?>
            <br/>
        </div><!-- #big-box-content-->
        <span class="big-box-footer"></span>
    </div>
</div>
<div id="sidebar">
    <? echo $this->element('saj'); ?>
    <? echo $this->element('novidades'); ?>
</div>