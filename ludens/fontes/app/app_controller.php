<?php
/**
 * Application level Controller
 *
 * This file is application-wide controller file. You can put all
 * application-wide controller-related methods here.
 *
 * PHP versions 4 and 5
 *
 * CakePHP(tm) : Rapid Development Framework (http://cakephp.org)
 * Copyright 2005-2010, Cake Software Foundation, Inc. (http://cakefoundation.org)
 *
 * Licensed under The MIT License
 * Redistributions of files must retain the above copyright notice.
 *
 * @copyright     Copyright 2005-2010, Cake Software Foundation, Inc. (http://cakefoundation.org)
 * @link          http://cakephp.org CakePHP(tm) Project
 * @package       cake
 * @subpackage    cake.cake.libs.controller
 * @since         CakePHP(tm) v 0.2.9
 * @license       MIT License (http://www.opensource.org/licenses/mit-license.php)
 */

/**
 * This is a placeholder class.
 * Create the same file in app/app_controller.php
 *
 * Add your application-wide methods in the class below, your controllers
 * will inherit them.
 *
 * @package       cake
 * @subpackage    cake.cake.libs.controller
 * @link http://book.cakephp.org/view/957/The-App-Controller
 */
class AppController extends Controller {
    var $helpers    = array('Session', 'Html', 'Form', 'Javascript', 'Ajax', 'Paginator');
    var $components = array('RequestHandler', 'Session', 'Auth', 'OauthConsumer');
    var $persistModel =  false;

    var $twitterAccessToken  = "";

    function beforeFilter() {
        
        $this->Auth->userModel      = 'Usuario';
        $this->Auth->loginError     = "E-mail/senha inválidos!";
        $this->Auth->authError      = "É necessário estar logado para acessar esta página.";
        
        if (isset($this->params['admin']) && $this->params['admin'])
        {
            // Painel de administração.
            $this->set('title_for_layout', 'Ludens - Painel de administração');
            
            //debug('admin');
            $this->Auth->userModel      = 'Administrador';
            $this->Auth->loginRedirect  = array( 'controller'   => 'instituicoes' , 'action'   => 'index' );
            $this->Auth->fields         = array( 'username'     => 'email'        , 'password' => 'password' );
        }
        else
        {
            // Área restrita.
            if ($this->acessoAreaRestrita())
            {
                $this->Auth->loginRedirect  = array( 'controller'   => 'relatorios'     , 'action'   => 'relatorios' );
                //$this->Auth->allow();
            }

            // Site.
            else
            {
                $this->Auth->allow();
            }
        }
    }

    function acessoAreaRestrita()
    {
        return ($this->params['controller'] == 'relatorios') ||
               ($this->params['controller'] == 'grupos') ||
               ($this->params['controller'] == 'jogadores') ||
               ($this->params['controller'] == 'jogos' && $this->params['controller'] == 'editar') ||
               ($this->params['controller'] == 'usuarios' && $this->params['action'] == 'editar') ||
               ($this->params['controller'] == 'usuarios' && $this->params['action'] == 'login');
    }

    function area_restrita()
    {
        //debug("areaRestrita");
        
        $this->layout = 'site';
        $this->set('title_for_layout', 'Ludens - Área restrita do usuário');
        
        //$this->set('noticias'        , $this->TwitterUtil->get_posts());
        $this->set('noticias'        , $this->get_posts());
        $this->set('current_page'    , 'area_restrita');
    }

    //--------------------------------------------------------------------
    function get_posts()
    {
        $accessToken = array('key' => '188532185-tG57SmYNNvBqYkNB1Ah1hLOZHL5iaNxJHvUwgF6a',
                             'secret' => 'BABnTBQBJlkdbJ67MUuIvR01msFVZm34eFQKaQ0' );
        /*
        $r = $this->OauthConsumer->get( 'Twitter',
                                    $accessToken['key'],
                                    $accessToken['secret'],
                                    'http://api.twitter.com/1/statuses/home_timeline.json',
                                    array('count' => '6'));
         */
        $r = $this->OauthConsumer->get( 'Twitter',
                                    '',
                                    '',
                                    'http://api.twitter.com/1/statuses/user_timeline.json',
                                    array(  'screen_name' => 'cvirtuais',
                                            'count' => '6',
                                            'include_rts' => 'true' ));
                 

        $result = array();
        $r = json_decode($r);
        $i = 0;

        if ($r && is_array($r))
        {
            //debug($r);
            foreach ($r as $tweet)
            {
                $data    = strtotime($tweet->created_at);
                $dia     = date('d', $data);
                $mes     = date("M", $data);
                $result[] = array('dia' => $dia, 'mes' => $mes, 'texto' => $tweet->text);
                //print_r($tweet->text);
                $i++;

                if ($i >= 4) break;
            }
        }

        if ($i != 0)
        {
            $hd = fopen('tweets.txt', 'w');
            if ($hd)
            {
                $result_serialized = serialize($result);
                fputs($hd, $result_serialized);
                fclose($hd);
            }
        }
       
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
        }
        return $result;
        
        //print_r($r);

        /*
        if ($this->twitterAccessToken == '')
        {
             $requestToken = 
                $this->OauthConsumer->getRequestToken(  'Twitter',
                                                        'http://twitter.com/oauth/request_token',
                                                        'http://' . $_SERVER['HTTP_HOST'] . '/ludens/' . $this->params['controller'] . '/twitter_callback/' );
             $this->Session->write('twitter_request_token', $requestToken);
             //debug('requestToken: '. $requestToken);
             $this->redirect('http://twitter.com/oauth/authorize?oauth_token=' . $requestToken->key);
        }
        else
        {
            return $this->get_posts2();
        }
         * 
         */
    }

    /*
    function twitter_callback()
    {
        $requestToken               = $this->Session->read('twitter_request_token');
        $this->twitterAccessToken    = $this->OauthConsumer->getAccessToken('Twitter', 'http://twitter.com/oauth/access_token', $requestToken);
        debug( $this->twitterAccessToken );
        $this->redirect('http://' . $_SERVER['HTTP_HOST'] . '/ludens/');
    }

    function get_posts2()
    {
        return '';
    }
    */
    
    //--------------------------------------------------------------------
    function mostrar_mensagem($mensagem)
    {
        $this->Session->setFlash(
                    '<div style="margin-top: 20px; padding: 0pt 0.7em;" ' .
                      'class="ui-state-highlight ui-corner-all ui-alert">'.
                    '<p>' .
                        '<span style="float: left; margin-right: 0.3em;" ' .
                               'class="ui-icon ui-icon-info"></span>' .
                        $mensagem .
                    '</p>' .
                    '</div>'
                );
    }
    
    function mostrar_erro($erro)
    {
        $this->Session->setFlash(
            '<div style="padding: 0pt 0.7em;" class="ui-state-error ui-corner-all ui-alert">' .
            '<p><span style="float: left; margin-right: 0.3em;" class="ui-icon ui-icon-alert"></span>' .
            '<strong>Erro:</strong> ' . $erro . '</p>' .
            '</div>'
        );
    }
}
