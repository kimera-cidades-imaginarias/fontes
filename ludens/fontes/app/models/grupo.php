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
class Grupo extends AppModel {
    var $name = 'Grupo';
    var $displayField = 'nome';

    var $validate = array(
        'nome' => array(
                'rule' => 'notEmpty'
        )
    );

    var $hasMany = array(
        'SubGrupo' => array(
            'className' => 'Grupo',
            'foreignKey' => 'grupo_pai_id'
        )
    );
    
    var $belongsTo = array(
        'Instituicao',
        'GrupoPai' => array(
            'className' => 'Grupo',
            'foreignKey' => 'grupo_pai_id'
        )
    );

    var $hasAndBelongsToMany = array('Jogador');
}
?>
