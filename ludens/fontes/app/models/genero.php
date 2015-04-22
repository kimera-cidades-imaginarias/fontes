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
class Genero extends AppModel {
    var $name = 'Genero';
    var $displayField = 'nome';

    var $validate = array(
        'nome' => array(
                'rule' => 'notEmpty'
        )
    );

    var $hasMany = array('Jogo');

}
?>
