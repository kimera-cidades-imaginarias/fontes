<?php
/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of contato
 *
 * @author Administrador
 */
class Contato extends AppModel {
    var $name     = 'Contato';
    var $useTable = false;
    var $_schema  = array(
        'nome'		=>array('type'=>'string', 'length'=>100),
        'email'		=>array('type'=>'string', 'length'=>100),
        'mensagem'	=>array('type'=>'text')
    );

    var $validate = array(
        'nome' => array(
            'rule' => 'notEmpty',
            'message' => 'Informe o seu nome.'
        ),
        'email' => array(
            'rule' => 'email',
            'message' => 'Informe o seu e-mail.'
        ),
        'mensagem' => array(
            'rule' => 'notEmpty',
            'message' => 'Informe a mensagem.'
        )
    );
}
?>
