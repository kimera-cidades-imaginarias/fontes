<?php
/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of genres_controller
 *
 * @author Administrador
 */
class GruposController extends AppController {
    var $name = 'Grupos';
    var $scaffold = 'admin';
    var $components = array('GruposUtil');

    function grupos()
    {
        $this->area_restrita();
        $this->set('pagina_area_restrita'   , 'grupos');

        $this->set('grupos', $this->GruposUtil->get_grupos($this->Session->read('Auth.Usuario.instituicao_id')));
    }

    function remover($id)
    {
        $this->Grupo->delete($id);
        $this->redirect(array('controller' => 'grupos', 'action' => 'grupos'));
    }

    function editar($id = null)
    {
        $this->area_restrita();
        $this->set('pagina_area_restrita'   , 'grupos');

        //$grupo_id   = $this->params['pass'];
        $grupos     = $this->GruposUtil->get_grupos($this->Session->read('Auth.Usuario.instituicao_id'));
        if ($id) unset($grupos[$id]);
        $this->set('grupos_pai', $grupos);

        $this->Grupo->id = $id;
        if (empty($this->data)) {
            $this->data = $this->Grupo->read();
        }
        else
        {
            if ($this->Grupo->save($this->data)) {
                $this->Session->setFlash(
                        '<div style="margin-top: 20px; padding: 0pt 0.7em;" ' .
                              'class="ui-state-highlight ui-corner-all ui-alert">'.
                            '<p>' .
                                '<span style="float: left; margin-right: 0.3em;" ' .
                                       'class="ui-icon ui-icon-info"></span>' .
                                'Grupo salvo com sucesso.' .
                            '</p>' .
                        '</div>'
                );
                $this->redirect(array('action' => 'grupos'));
            }
            else
            {
                $this->Session->setFlash(
                    '<div style="padding: 0pt 0.7em;" class="ui-state-error ui-corner-all ui-alert">' .
                        '<p><span style="float: left; margin-right: 0.3em;" class="ui-icon ui-icon-alert"></span>' .
                        '<strong>Atenção:</strong> ocorreram erros ao salvar o grupo.</p>' .
                    '</div>'
                );
            }
        }
    }
}
?>
