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
                Para usar o Ludens, você deve realizar um cadastro, informando a qual instituição você pertence.
            </p>
            <p>
                Caso sua instituição ainda não esteja cadastrado será necessário cadastra-lá. É simples e rápido. Você receberá suas informações de acesso via e-mail. 
            </p>
            <p>
                Se você já realizou o cadastro mas não recebeu as informações de acesso no e-mail informado, por favor verifique sua caixa de SPAM. Clique aqui para reenviarmos suas informações de acesso.
            </p>
            <br/>
            <form id="cadastro">
                <p >
                    <label for="escola"><span>Selecione sua instituição na lista</span> ou clique em "Nova Instituição", caso ela ainda não esteja cadastrada:</label><br />
                    <select name="escola" id="escola">
                    </select>
                </p>
            </form>
            <br/>
            <input type="button" class="botao-enviar" value="Nova Instituição" onClick="javascript:location.href='instituicoes/';">
            
        </div><!-- #big-box-content-->
        <span class="big-box-footer"></span>
    </div>
</div>
<div id="sidebar">
    <? echo $this->element('saj'); ?>
    <? echo $this->element('novidades'); ?>
</div>