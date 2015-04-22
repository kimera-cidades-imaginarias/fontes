<?php
/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of ArvoreGruposComponent
 *
 * @author Administrador
 */
class GruposUtilComponent extends Object {

    var $Jogador;
    var $Grupo;
    
    var $cont;
    var $resultado;
    
    //called before Controller::beforeFilter()
    function initialize(&$controller, $settings = array()) {
        // saving the controller reference for later uses
        $this->controller =& $controller;
        
        $this->Jogador    = ClassRegistry::init('Jogador');
        $this->Grupo      = ClassRegistry::init('Grupo');
    }

    //called after Controller::beforeFilter()
    function startup(&$controller) {
    }

    //called after Controller::beforeRender()
    function beforeRender(&$controller) {
    }

    //called after Controller::render()
    function shutdown(&$controller) {
    }

    //called before Controller::redirect()
    function beforeRedirect(&$controller, $url, $status=null, $exit=true) {
    }

    function redirectSomewhere($value) {
            // utilizing a controller method
            $this->controller->redirect($value);
    }

    //--------------------------------------------------------------

    function get_grupos($instituicao_id)
    {        
        // Lista os grupos associados a respectiva instituicao.
        $grupos = $this->Jogador->Grupo->find('all',
                        array('conditions' => array('Grupo.instituicao_id' => $instituicao_id,
                                                    'Grupo.grupo_pai_id' => null)));
        $this->cont       = 0;
        $this->resultado  = Array();
        $this->construir_arvore_recursivo($grupos);
        //$this->set('grupos', $this->resultado);
        return $this->resultado;
    }

    function construir_arvore_recursivo($grupos)
    {
        foreach($grupos as $grupo)
        {
            $this->resultado[$grupo['Grupo']['id']] = $this->hifens($this->cont) . $grupo['Grupo']['nome'];
            $filhos = $this->Jogador->Grupo->find('all',
                array('conditions' => array('Grupo.grupo_pai_id' => $grupo['Grupo']['id'])));

            $this->cont++;
            $this->construir_arvore_recursivo($filhos);
            $this->cont--;
        }
    }

    function hifens($cont)
    {
        for ($i = 0, $r = ''; $i < $cont; $i++) $r .= '. . ';
        return $r;
    }

    //--------------------------------------------------------------

    function get_jogadores($grupo_id)
    {
        $this->resultado  = Array();
        $this->get_jogadores_recursivo($grupo_id);
        return $this->resultado;
    }

    function get_jogadores_recursivo($grupo_id)
    {
        $grupo = $this->Grupo->findById($grupo_id);
        if (count($grupo['SubGrupo']) == 0)
        {
            foreach ($grupo['Jogador'] as $jogador)     array_push($this->resultado, $jogador['id']);
            //foreach ($grupo['Jogador'] as $jogador)     array_push($this->resultado, $jogador);
        }
        else
        {
            foreach ($grupo['SubGrupo'] as $subGrupo)   $this->get_jogadores_recursivo($subGrupo['id']);
        }
    }
}
?>
