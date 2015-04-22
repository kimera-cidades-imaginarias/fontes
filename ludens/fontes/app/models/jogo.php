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
class Jogo extends AppModel {
    var $name = 'Jogo';
    var $displayField = 'nome';
    var $validate = array(
        'nome' => array(
                'rule' => 'notEmpty'
        ),
        'codigo' => array(
            'rule' => 'notEmpty',
            'tamanho' => array(
               'rule' => array('between', 4, 10),
               'message' => 'O código deve ter entre 4 e 10 caracters'
            ),
            'unico' => array(
                'rule' => 'unique',
                'message' => 'Código já em uso.'
            )

        )
    );

    var $belongsTo  = array('Genero', 'Instituicao');
    var $hasMany    = array('Indicador');
}
?>
