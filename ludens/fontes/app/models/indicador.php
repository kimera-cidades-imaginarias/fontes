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
class Indicador extends AppModel {
    var $name = 'Indicador';
    var $displayField = 'nome';
    var $validate = array(
        'nome' => array(
                'rule' => 'notEmpty'
        ),
        'codigo' => array(
                'rule' => array('between', 3, 30),
                'message' => 'O código deve ter entre 3 e 30 caracteres.'
        )
    );

    var $belongsTo  = array('Jogo');
    var $hasMany    = array('Registro');
}
?>
