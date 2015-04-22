<?php
/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of ArvoreGruposComponent
 *
 * @author Administrador
 */
class TwitterUtilComponent extends Object {

    //called before Controller::beforeFilter()
    function initialize(&$controller, $settings = array()) {
        // saving the controller reference for later uses
        $this->controller =& $controller;
    }

    //called after Controller::beforeFilter()
    function startup(&$controller) {
    }

    //called after Controller::beforeRender()
    function beforeRender(&$controller) {
    }

    //called after Controller::render()
    function shutdown(&$controller) {
    }

    //called before Controller::redirect()
    function beforeRedirect(&$controller, $url, $status=null, $exit=true) {
    }

    function redirectSomewhere($value) {
            // utilizing a controller method
            $this->controller->redirect($value);
    }

    //--------------------------------------------------------------

    function get_posts()
    {
        $this->Twitter  = ConnectionManager::getDataSource('twitter');
        $response       = $this->Twitter->account_verify_credentials();
        $search_results = $this->Twitter->search('cakephp');
        $posts          = $this->Twitter->account_archive();

        // Conseguiu recupera tweets.
        if (isset($posts['Statuses']))
        {
            $result = array();
            $cont = 0;
            foreach ($posts['Statuses']['Status'] as $post)
            {
                $data    = strtotime($post['created_at']);
                $dia     = date('d', $data);
                $mes     = date("M", $data);

                $result[] = array('dia' => $dia, 'mes' => $mes, 'texto' => $post['text']);

                $cont++;
                if ($cont > 3) break;
            }

            $hd = fopen('tweets.txt', 'w');
            if ($hd)
            {
                $result_serialized = serialize($result);
                fputs($hd, $result_serialized);
                fclose($hd);
            }

            //debug($result);
            return $result;
        }

        // Não conseguiu recuperar, pega do cache.
        else
        {
            $hd = fopen('tweets.txt', 'r');
            if ($hd)
            {
                if (filesize('tweets.txt') > 0) $result = unserialize(fread($hd, filesize('tweets.txt')));
                else $result = array();
                fclose($hd);

            }
            else $result = array();
            return $result;
        }
    }

  
}
?>
