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
class Banner extends AppModel {
    var $name           = 'Banner';
    var $displayField   = 'nome';

    var $validate = array(
        'nome' => array(
                'rule' => 'notEmpty'
        ),
        'texto' => array(
                'rule' => 'notEmpty'
        ),
        'arquivo' => array(
                'rule' => 'notEmpty'
        )
    );

    function beforeValidate($params)
    {
        //debug('beforeSave');

        $arquivo = $this->data['Banner']['arquivo'];
        $destino = 'files/' . $arquivo['name'];
        $this->data['Banner']['arquivo'] = $destino;

        // Em caso de edição, remove o arquivo atual.
        if (!empty($this->id))
        {
            if ($arquivo['name'] == '') return true;
            //debug('EDIT!');
            //print_r($this);
        }

        // Já existe um arquivo com esse nome.
        if (file_exists($destino))
        {
            $this->validationErrors['nome'] = 'Já existe um arquivo com esse nome. Renomeie o arquivo.';
            return false;
        }

        // Arquivo não informado.
        if ($arquivo['name'] == '')
        {
            $this->validationErrors['nome'] = 'É necessário informar um arquivo.';
            return false;
        }

        // Realiza o envio do arquivo.
        if (is_uploaded_file($arquivo['tmp_name']))
        {
            if (move_uploaded_file($arquivo['tmp_name'], 'files/' . $arquivo['name']))
            {
                return true;
            }
        }

        $this->validationErrors['nome'] = 'Não foi possível enviar o arquivo.';
        return false;
    }
}
?>
