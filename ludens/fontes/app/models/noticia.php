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
class Noticia extends AppModel {
    var $actsAs = array('DateFormatter');
    var $name = 'Noticia';
    var $validate = array(
        'titulo' => array(
                'rule' => 'notEmpty',
                'message' => 'Informe o título da notícia.'
        ),
        'data' => array(
                'rule' => 'date',
                'message' => 'Informe a data de publicação da notícia.'
        ),
        'texto' => array(
                'rule' => 'notEmpty',
                'message' => 'Informe o texto da notícia.'
        ),
    );


}
?>
