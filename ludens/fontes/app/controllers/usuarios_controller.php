<?php
/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of jogos_controller
 *
 * @author Administrador
 */
class UsuariosController extends AppController {
    var $name       = 'Usuarios';
    var $scaffold   = 'admin';

    function login() {
       $this->redirect(array('controller' => 'site', 'action'=>'index', 'login'));
    }

    function logout() {
        $this->redirect($this->Auth->logout());
    }
    
    function beforeFilter() {
        parent:: beforeFilter();

        // Assegura que será considerado o modelo certo
        // para fazer o hash do campo password.
        if (!isset($this->params['admin']) || !$this->params['admin'])
        {
            $this->Auth->userModel      = 'Usuario';
            $this->Auth->fields         = array( 'username'     => 'email'        , 'password' => 'password' );
            $this->Auth->logoutRedirect = array(Configure::read('Routing.admin') => false, 'controller' => 'site', 'action' => 'index');
        }

        // Cadastro não exige autenticação.
        if ($this->action == 'cadastro')  $this->Auth->allow();
    }

    function cadastro()
    {
        $this->layout = 'site';
        $this->set('title_for_layout', 'Ludens - Cadastre-se e use gratuitamente!');
        
        $this->set('current_page', 'cadastro');
        $this->set('noticias', $this->get_posts());
        $this->set('instituicoes', $this->Usuario->Instituicao->find('list'));

        if(!empty($this->data))
        {
            if ($this->data['Usuario']['password'] == $this->Auth->password($this->data['Usuario']['confirmar_senha']) )
            {
                $this->data['Usuario']['registro']  = date('Y-m-d h:i:s');
                $this->Usuario->create($this->data);
                
                if ($this->Usuario->validates())
                {
                    $this->Usuario->save();
                    $this->Session->setFlash('Usuário criado com sucesso. Você já pode acessar sua conta.');
                    $this->redirect(array('action'=>'cadastro'));
                }
            }
            else
            {
                $this->Usuario->validationErrors['password'] = 'As senha digitadas não são iguais.';
            }
            $this->data['Usuario']['password'] = $this->data['Usuario']['confirmar_senha'];
        }
    }

    function editar()
    {
        $this->area_restrita();
        $this->set('pagina_area_restrita'   , 'meu_cadastro');

        $this->Usuario->id = $this->Session->read('Auth.Usuario.id');

        if(empty($this->data))
        {
            $this->data = $this->Usuario->read();
        }
        else
        {
            if (!empty($this->data['Usuario']['nova_senha']))
            {
                if ($this->data['Usuario']['nova_senha'] != $this->data['Usuario']['confirmar_nova_senha'])
                {
                    $this->Usuario->validationErrors['nova_senha'] = 'As senha digitadas não são iguais.';
                    return ;
                }
                else
                {
                    $this->data['Usuario']['password'] = $this->Auth->password($this->data['Usuario']['nova_senha']);
                }
            }
            
            if ($this->Usuario->save($this->data)) {
                $this->Session->setFlash(
                    '<div style="margin-top: 20px; padding: 0pt 0.7em;" ' .
                      'class="ui-state-highlight ui-corner-all ui-alert">'.
                    '<p>' .
                        '<span style="float: left; margin-right: 0.3em;" ' .
                               'class="ui-icon ui-icon-info"></span>' .
                        'Cadastro atualizado com sucesso.' .
                    '</p>' .
                    '</div>'
                );
            }
            else
            {
                $this->Session->setFlash(
                    '<div style="padding: 0pt 0.7em;" class="ui-state-error ui-corner-all ui-alert">' .
                    '<p><span style="float: left; margin-right: 0.3em;" class="ui-icon ui-icon-alert"></span>' .
                    '<strong>Atenção:</strong> ocorreram erros ao atualizar o cadastro.</p>' .
                    '</div>'
                );
            }
        }
    }
}
?>
