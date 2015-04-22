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
class SiteController extends AppController {
    //var $name = 'Site';
    var $uses = array('Contato');
    var $helpers = array('Html', 'Session');

    function index()
    {
        $this->layout = 'site';
        $this->set('title_for_layout', 'Ludens - Sistema de avaliação de jogadores');

        $this->set('current_page', 'index');
        $this->set('noticias', $this->ultimas_noticias());
        if (isset($this->params['pass'][0]) && $this->params['pass'][0] == 'login') $this->set('login', '1');
    }

    function sobre()
    {
        $this->layout    = 'site';
        $this->set('title_for_layout', 'Ludens - Sistema de avaliação de jogadores');
        
        $this->set('current_page', 'sobre');
        $this->set('noticias', $this->ultimas_noticias());
    }

    /*
    function cadastro()
    {
        $this->layout = 'site';
        $this->set('current_page', 'cadastro');
        $this->set('noticias', $this->ultimas_noticias());
    }
     

    function contato()
    {
        $this->layout = 'site';
        $this->set('title_for_layout', 'Ludens - Entre em contato conosco.');
        
        $this->set('current_page', 'contato');
        $this->set('noticias', $this->ultimas_noticias());
    }
     * *
     */

    function ultimas_noticias()
    {
        //return $this->TwitterUtil->get_posts();
        return $this->get_posts();
    }
}
?>
