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
class Jogador extends AppModel {
    var $name = 'Jogador';
    var $displayField = 'nome';

    var $validate = array(
        'nome' => array(
            'rule' => 'notEmpty',
            'message' => 'Informe o nome do jogador.'
        ),
        'email' => array(
            'rule' => 'email',
            'message' => 'Informe o e-mail do jogador.'
        ),
        'Grupo' => array(
            'rule' => 'notEmpty',
            'message' => 'Selecione ao menos um grupo.'
        )
    );

    var $belongsTo = array('Instituicao');
    var $hasAndBelongsToMany = array('Grupo');
    var $hasMany    = array('Registro');
}
?>
