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
class JogadoresController extends AppController {
    var $components = array('GruposUtil');

    var $name       = 'Jogadores';
    var $scaffold   = 'admin';

    var $instituicao_id;
    var $cont;
    var $resultado;

    function admin_add()
    {
        $this->instituicao_id = $this->params['pass'][0];
        $this->set('grupos', $this->GruposUtil->get_grupos($this->instituicao_id) );

        $instituicoes = $this->Jogador->Instituicao->find('list');
        $this->set('instituicoes', $instituicoes);

        if (!empty($this->data)) {
            $this->save();
        }
    }

    function admin_edit($id = null)
    {
        $this->Jogador->id = $id;
	if (empty($this->data)) {
            $this->data             = $this->Jogador->read();

            $this->instituicao_id   = $this->data['Jogador']['instituicao_id'];
            $this->set('grupos', $this->GruposUtil->get_grupos($this->instituicao_id));

            $instituicoes = $this->Jogador->Instituicao->find('list');
            $this->set('instituicoes', $instituicoes);
	} else {
            $this->save();
	}
    }

    function save()
    {
        // Verifica se o(s) grupo(s) selecionado(s) é válido.
        foreach($this->data['Grupo']['Grupo'] as $grupo)
        {
            $filhos = $this->Jogador->Grupo->find('all',
                    array('conditions' => array('Grupo.grupo_pai_id' => $grupo)));

            // Apenas folhas da árvore de grupos podem ser selecionadas
            // como grupo de um jogador.
            if (count($filhos) > 0)
            {
                $this->Session->setFlash('Você deve selecionar apenas grupos filhos.');
                return ;
            }
        }

        if ($this->Jogador->save($this->data))
        {
            $this->Session->setFlash('Jogador gravado com sucesso.');
            $this->redirect(array('controller' => 'instituicoes', 'action' => 'view/' . $this->instituicao_id));
        }
    }

    //------------------------------------------------------------------------
    function jogadores()
    {
        $this->area_restrita();
        $this->set('pagina_area_restrita'   , 'alunos');

        $instituicao_id = $this->Session->read('Auth.Usuario.instituicao_id');

        if (empty($this->data['Grupos']['grupo']))
        {
            $this->set( 'jogadores',
                        $this->Jogador->find('all', array('conditions' => array('Jogador.instituicao_id' => $instituicao_id),
                                                          'order' => 'Jogador.nome')
                        ));
        }
        else
        {
            $jogadores = $this->GruposUtil->get_jogadores($this->data['Grupos']['grupo']);
            $this->set( 'jogadores',
                        $this->Jogador->find('all', array('conditions' => array('Jogador.id' => $jogadores),
                                                          'order' => 'Jogador.nome')
                        ));
        }
        $this->set('grupos', $this->GruposUtil->get_grupos($instituicao_id));
    }

    function remover($id)
    {
        $this->Jogador->Registro->deleteAll(array('Registro.jogador_id' => $id));
        $this->Jogador->delete($id, true);
        $this->redirect(array('controller' => 'jogadores', 'action' => 'jogadores'));
    }

    function remover_indicadores($id)
    {
        $this->Jogador->Registro->deleteAll(array('Registro.jogador_id' => $id));

        $this->Session->setFlash(
                '<div style="margin-top: 20px; padding: 0pt 0.7em;" ' .
                      'class="ui-state-highlight ui-corner-all ui-alert">'.
                    '<p>' .
                        '<span style="float: left; margin-right: 0.3em;" ' .
                               'class="ui-icon ui-icon-info"></span>' .
                        'Indicadores removidos com sucesso.' .
                    '</p>' .
                '</div>'
        );
        $this->redirect(array('controller' => 'jogadores', 'action' => 'jogadores'));
    }

    function editar($id = null)
    {
        $this->area_restrita();
        $this->set('pagina_area_restrita'   , 'alunos');
        $instituicao_id = $this->Session->read('Auth.Usuario.instituicao_id');
        $this->set('grupos'                , $this->GruposUtil->get_grupos($instituicao_id));

        $this->Jogador->id = $id;
        if (empty($this->data)) {
            $this->data = $this->Jogador->read();
        }
        else
        {
            if ($this->Jogador->save($this->data)) {
                $this->Session->setFlash(
                        '<div style="margin-top: 20px; padding: 0pt 0.7em;" ' .
                              'class="ui-state-highlight ui-corner-all ui-alert">'.
                            '<p>' .
                                '<span style="float: left; margin-right: 0.3em;" ' .
                                       'class="ui-icon ui-icon-info"></span>' .
                                'Jogador salvo com sucesso.' .
                            '</p>' .
                        '</div>'
                );
                $this->redirect(array('action' => 'jogadores'));
            }
            else
            {
                $this->Session->setFlash(
                    '<div style="padding: 0pt 0.7em;" class="ui-state-error ui-corner-all ui-alert">' .
                        '<p><span style="float: left; margin-right: 0.3em;" class="ui-icon ui-icon-alert"></span>' .
                        '<strong>Atenção:</strong> ocorreram erros ao salvar o jogador.</p>' .
                    '</div>'
                );
            }
        }
    }
}
?>
