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
class Cidade extends AppModel {
    var $name = 'Cidade';
    var $displayField = 'nome';

    var $validate = array(
        'nome' => array(
                'rule' => 'notEmpty',
                'message' => 'Informe o nome da cidade.'
        )
    );
    
    var $belongsTo  = 'Estado';
    var $hasMany    = 'Instituicao';
}
?>
