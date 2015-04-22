<div id="cadastro-box" class="conteudo-central">
    <div class="big-box">
        <h2 class="big-box-title"><strong>cadastro /</strong> instituições</h2>
        <div class="big-box-content">
            <? echo $html->image('sobre-img.jpg', array('alt' => 'Cadastro no Ludens', 'align' => 'Cadastro' )); ?>
            <!--
            <ul id="cadastro-menu">
                <li><a href="#" title="Sou Professor" id="professor" class="opcao-cadastro"><span class="link-op-img"></span>Sou Professor / Educador</a></li>
                <li><a href="#" title="Sou Desenvolvedor" id="deselvolvedor" class="opcao-cadastro"><span class="link-op-img"></span>Sou desenvolvedor</a></li>
            </ul>
            -->
            
            <?php
                echo $javascript->link('jquery.meio.mask.min');

                echo $form->create('Instituicao', array('class' => 'label-slide formulario'));
                echo '<fieldset>';
                echo '<legend>Cadastro da instituição</legend>';
                echo '<p>Informe abaixo os dados de cadastro de sua instituição. Ao fim, você voltará automaticamente ao cadastro de usuário.</p>';
                echo $form->input('nome');
                echo $form->input('tipo'        , array('label' => '', 'empty' => 'Tipo...', 'options' => $tipos));
                echo $form->input('endereco');
                echo $form->input('numero');
                echo $form->input('bairro');
                echo $form->input('estado_id'   , array('id' => 'estado_id', 'label' => '', 'empty' => 'Estado...', 'options' => $estados));
                echo $form->input('cidade_id'   , array('id' => 'cidade_id', 'label' => '', 'empty' => 'Selecione um estado...' ));
                echo $ajax->observeField('estado_id',  array(   'url'    => 'atualizar_cidades',
                                                                'update' => 'cidade_id',
                                                                'before' => 'Loading("cidade_id")' ));
                echo $form->input('cep', array('alt' => 'cep'));
                echo $form->input('contato', array('label' => 'Responsável'));
                echo $form->input('telefone1', array('alt' => 'phone'));
                echo $form->input('telefone2', array('alt' => 'phone'));
                echo $form->input('email');
                echo $form->input('site');
                echo $form->end( array('label' => 'Enviar', 'value' => 'Enviar', 'class' => 'botao-enviar') );
                echo '</fieldset>';
            ?>
        </div><!-- #big-box-content-->
        <span class="big-box-footer"></span>
    </div>
</div>
<div id="sidebar">
    <? echo $this->element('saj'); ?>
    <? echo $this->element('novidades'); ?>
</div>