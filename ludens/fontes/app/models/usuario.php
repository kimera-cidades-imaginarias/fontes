<?php
/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of genre
 *
 * @author Administrador
 */
class Usuario extends AppModel {
    var $name = 'Usuario';
    var $validate = array(
        'nome' => array(
                'rule' => 'notEmpty',
                'message' => 'Informe o nome do usuário.'
        ),
        'email' => array(
            'notEmpty' => array(
                'rule' => 'email',
                'message' => 'Informe um e-mail válido.'),
            'unique' => array(
                'rule' => 'isUnique',
                'message' => 'Esse e-mail já está em uso.')
        ),
        'password' => array(
                'rule' => array('between', 5, 50),
                'message' => 'A senha deve ter entre 5 e 10 caracters.'
        ),
        'instituicao_id' => array(
            'rule' => 'notEmpty',
            'message' => 'Selecione uma instituição.'
        )
    );
    var $belongsTo  = array('Instituicao');
}
?>
