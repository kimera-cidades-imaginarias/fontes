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
class Instituicao extends AppModel {
    var $name = 'Instituicao';
    var $displayField = 'nome';

    var $validate = array(
        'nome' => array(
            'rule' => 'notEmpty',
            'message' => 'Informe o nome da instituição.'
        ),
        'email' => array(
            'rule' => 'email',
            'message' => 'Informe o e-mail da instituição.'
        ),
        'endereco' => array(
            'rule' => 'notEmpty',
            'message' => 'Informe o endereço da instituição.'
        ),
       'número' => array(
            'rule' => 'notEmpty',
            'message' => 'Informe número do endereço.'
        ),
       'telefone1' => array(
            'rule' => 'notEmpty',
            'message' => 'Informe o telefone da instituição.'
        ),
       'contato' => array(
            'rule' => 'notEmpty',
            'message' => 'Informe o nome da pessoa responsável na instituição.'
        )
    );

    var $belongsTo  = array('Estado', 'Cidade');
    var $hasMany = array('Usuario', 'Grupo', 'Jogador');
}
?>
