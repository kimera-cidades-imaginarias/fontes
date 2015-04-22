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
class JogosController extends AppController {
    var $name       = 'Jogos';
    var $scaffold   = 'admin';
    
    function beforeFilter() {
        parent:: beforeFilter();

        // Verifica se trata-se de uma solicitação à área restrita.
        if (!isset($this->params['admin']) || !$this->params['admin'])
        {
            $this->Auth->userModel      = 'Usuario';
            $this->Auth->fields         = array( 'username'     => 'email'        , 'password' => 'password' );
            $this->Auth->logoutRedirect = array(Configure::read('Routing.admin') => false, 'controller' => 'site', 'action' => 'index');
        }
    }

    //------------------------------------------------------------------------
    function jogos()
    {
        $this->area_restrita();
        $this->set('pagina_area_restrita'   , 'jogos');

        $instituicao_id = $this->Session->read('Auth.Usuario.instituicao_id');
        $this->set( 'jogos',
                    $this->Jogo->find('all', array('conditions' => array('Jogo.instituicao_id' => $instituicao_id),
                                                      'order' => 'Jogo.nome')
                    ));
    }

    function editar($id = null)
    {
        $this->area_restrita();

        $this->set('generos', $this->Jogo->Genero->find('list'));
        $this->set('pagina_area_restrita'   , 'jogos');

        $this->Jogo->id = $id;
        if (empty($this->data)) {
            $this->data = $this->Jogo->read();
        }
        else
        {
            if ($this->Jogo->save($this->data)) {
                $this->Session->setFlash(
                        '<div style="margin-top: 20px; padding: 0pt 0.7em;" ' .
                              'class="ui-state-highlight ui-corner-all ui-alert">'.
                            '<p>' .
                                '<span style="float: left; margin-right: 0.3em;" ' .
                                       'class="ui-icon ui-icon-info"></span>' .
                                'Jogo salvo com sucesso.' .
                            '</p>' .
                        '</div>'
                );
                $this->redirect(array('action' => 'jogos'));
            }
            else
            {
                $this->Session->setFlash(
                    '<div style="padding: 0pt 0.7em;" class="ui-state-error ui-corner-all ui-alert">' .
                        '<p><span style="float: left; margin-right: 0.3em;" class="ui-icon ui-icon-alert"></span>' .
                        '<strong>Atenção:</strong> ocorreram erros ao salvar o jogo.</p>' .
                    '</div>'
                );
            }
        }
    }
}
?>
