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
class AdministradoresController extends AppController {
    var $name       = 'Administradores';
    var $scaffold   = 'admin';
    var $components = array('Auth');

    /**
     *  The AuthComponent provides the needed functionality
     *  for login, so you can leave this function blank.
     */
    function admin_login() {
        $this->layout = 'admin_login';
    }

    function admin_logout() {
        $this->redirect($this->Auth->logout());
    }
}
?>
