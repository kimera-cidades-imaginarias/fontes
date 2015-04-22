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
class InstituicoesController extends AppController {
    var $name       = 'Instituicoes';
    var $scaffold   = 'admin';
    var $helpers    = array('Html','Form','Javascript','Ajax');

    function admin_edit($id = '')
    {
        $this->Instituicao->id = $id;
	if (empty($this->data)) {
            $this->data             = $this->Instituicao->read();
            $this->set('estados', $this->Instituicao->Estado->find('list'));
            $cidades = $this->Instituicao->Cidade->find('list', 
                        array('conditions' => array('Cidade.estado_id' => $this->data['Instituicao']['estado_id'])));
            
            $this->set('cidades', $cidades);
            //$this->set('cidade_id', $this->data['Instituicao']['cidade_id']);
	} else {
            if ($this->Instituicao->save($this->data))
            {
                $this->Session->setFlash('Instituição gravada com sucesso.');
                $this->redirect(array('controller' => 'instituicoes', 'action' => 'index'));
            }
	}
    }

    function admin_update_select()
    {
        $this->layout = 'ajax';
        if(!empty($this->data['Instituicao']['estado_id']))
        {
            $this->set('cidades', $this->Instituicao->Cidade->findAllByEstadoId($this->data['Instituicao']['estado_id']));
        }
    }

    //----------------------------------------------------------

    function cadastro()
    {
        $this->layout = 'site';
        $this->set('title_for_layout', 'Ludens - Cadastro de instituição');
                 
        $this->set('current_page', 'cadastro');
        $this->set('noticias', $this->get_posts());
        
        $this->set('tipos'  , array('ESC' => 'Instituição de Ensino', 'DES' => 'Desenvolvedora de jogos'));
        $this->set('estados', $this->Instituicao->Estado->find('list'));

        if(!empty($this->data))
        {
            $this->data['Usuario']['registro'] = date('Y-m-d h:i:s');
            $this->Instituicao->create($this->data);
            if ($this->Instituicao->validates())
            {
                $this->Instituicao->save();
                $this->Session->setFlash('Instituição criada com sucesso.');
                $this->redirect(array('controller' => 'usuarios', 'action'=>'cadastro'));
            }
        }
    }

    function atualizar_cidades()
    {
        $this->layout = 'ajax';
        if(!empty($this->data['Instituicao']['estado_id']))
        {
            $this->set('cidades', $this->Instituicao->Cidade->findAllByEstadoId($this->data['Instituicao']['estado_id']));
        }
    }
}
?>
