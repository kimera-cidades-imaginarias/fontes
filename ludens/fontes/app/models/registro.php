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
class Registro extends AppModel {
    var $name = 'Registro';
    var $belongsTo  = array('Jogador', 'Indicador');
}
?>
