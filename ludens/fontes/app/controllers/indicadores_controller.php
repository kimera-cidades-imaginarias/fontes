<?php
/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of jogos_controller
 *
 * @author Administrador
 */
class IndicadoresController extends AppController {
    var $name       = 'Indicadores';
    var $scaffold   = 'admin';
    var $uses       = array('Indicador', 'Jogo', 'Jogador', 'Registro');

    function beforeFilter() {
        parent:: beforeFilter();

        // Verifica se trata-se de uma solicitação à área restrita.
        if (!isset($this->params['admin']) || !$this->params['admin'])
        {
            $this->Auth->userModel      = 'Usuario';
            $this->Auth->fields         = array( 'username'     => 'email'        , 'password' => 'password' );
            $this->Auth->logoutRedirect = array(Configure::read('Routing.admin') => false, 'controller' => 'site', 'action' => 'index');
        }
    }
/* */
    function admin_add()
    {
        $this->set('jogos', $this->Indicador->Jogo->find('list'));
        if (!empty($this->data)) {
            if ($this->Indicador->save($this->data))
            {
                $this->Session->setFlash('Indicador gravado com sucesso.');
                $this->redirect(array('controller' => 'jogos', 'action' => 'view/' . $this->data['Indicador']['jogo_id']));
            }
	}
    }

    function admin_edit($id = null)
    {
        $this->Indicador->id = $id;
        $this->set('jogos', $this->Indicador->Jogo->find('list'));
	if (empty($this->data)) {
            $this->data             = $this->Indicador->read();
	} else {
            if ($this->Indicador->save($this->data))
            {
                $this->Session->setFlash('Indicador gravado com sucesso.');
                $this->redirect(array('controller' => 'jogos', 'action' => 'view/' . $this->data['Indicador']['jogo_id']));
            }
	}
    }

    function admin_delete($id = null)
    {
        $this->Indicador->id = $id;
        $this->data          = $this->Indicador->read();
        $jogo_id             = $this->data['Indicador']['jogo_id'];

        $this->Indicador->delete($id);
        $this->redirect(array('controller' => 'indicadores', 'action' => 'view/' . $jogo_id));
    }

    //------------------------------------------------------------------------
    function validar_jogo($jogo_id)
    {
        $instituicao_id = $this->Session->read('Auth.Usuario.instituicao_id');
        $jogos = $this->Indicador->Jogo->find('all', array('conditions' => array('Jogo.id' => $jogo_id,
                                                                                 'Jogo.instituicao_id' => $instituicao_id)));
        if(count($jogos) == 0)
        {
              $this->Session->setFlash(
                    '<div style="padding: 0pt 0.7em;" class="ui-state-error ui-corner-all ui-alert">' .
                        '<p><span style="float: left; margin-right: 0.3em;" class="ui-icon ui-icon-alert"></span>' .
                        '<strong>Jogo inválido.</p>' .
                    '</div>'
                );
              $this->redirect(array('controller' => 'jogos', 'action' => 'jogos'));
              return false;
        }
        return true;
    }

    function indicadores($jogo_id)
    {
        if ($this->validar_jogo($jogo_id))
        {
            $this->area_restrita();
            $this->set('pagina_area_restrita'   , 'jogos');

            //$jogo_id        = $this->params['pass'][0];
            $instituicao_id = $this->Session->read('Auth.Usuario.instituicao_id');
            $this->set( 'jogo_id'   , $jogo_id);
            $this->set( 'indicadores',
                        $this->Indicador->find('all', array('conditions' => array('Indicador.jogo_id' => $jogo_id),
                                                          'order' => 'Indicador.nome')
            ));
        }
    }

    function editar($id = null)
    {
        $this->area_restrita();
        print_r($this->data);
                
        $jogo_id = isset($this->data['Indicador']['jogo_id']) ? 
                         $this->data['Indicador']['jogo_id'] : $this->params['named']['jogo_id'];
        if ($this->validar_jogo($jogo_id))
        {
            $this->set('jogo_id'                , $jogo_id);
            $this->set('pagina_area_restrita'   , 'jogos');

            $this->Indicador->id = $id;
            if (empty($this->data)) {
                $this->data = $this->Indicador->read();
            }
            else
            {
                if ($this->Indicador->save($this->data)) {
                    $this->Session->setFlash(
                            '<div style="margin-top: 20px; padding: 0pt 0.7em;" ' .
                                  'class="ui-state-highlight ui-corner-all ui-alert">'.
                                '<p>' .
                                    '<span style="float: left; margin-right: 0.3em;" ' .
                                           'class="ui-icon ui-icon-info"></span>' .
                                    'Indicador salvo com sucesso.' .
                                '</p>' .
                            '</div>'
                    );
                    $this->redirect(array(  'controller' => 'indicadores',
                                            'action' => 'indicadores/'. $jogo_id . '/'));
                }
                else
                {
                    $this->Session->setFlash(
                        '<div style="padding: 0pt 0.7em;" class="ui-state-error ui-corner-all ui-alert">' .
                            '<p><span style="float: left; margin-right: 0.3em;" class="ui-icon ui-icon-alert"></span>' .
                            '<strong>Atenção:</strong> ocorreram erros ao salvar o indicador.</p>' .
                        '</div>'
                    );
                }
            }
        }
    }
        
    function remover($id)
    {
        $this->Indicador->delete($id, true);
        $jogo_id = isset($this->data['Indicador']['jogo_id']) ? 
                         $this->data['Indicador']['jogo_id'] : $this->params['named']['jogo_id'];
        $this->redirect(array('controller' => 'indicadores', 'action' => 'indicadores/' . $jogo_id));
        /*
        $this->Jogador->Registro->deleteAll(array('Registro.jogador_id' => $id));
        $this->Jogador->delete($id, true);
        $this->redirect(array('controller' => 'jogadores', 'action' => 'jogadores'));
         * 
         */
    }


    //---------------------------------------------------------

    function validar_arquivo($texto)
    {
        // Parsing do arquivo.
        $identificacoes = 0;
        $codigos_jogo   = 0;
        $indicadores    = 0;

        $data = explode("\n", $texto);
        for ($i = 0; $i < count($data); $i++)
        {
            $linha = trim($data[$i]);
            if (strlen($linha) > 0)
            {
                if ($linha{0} != '#')
                {
                    if ($linha{0} == '$')
                    {
                        $comando = explode("::", $linha);
                        if ($comando[0] == '$ID')
                        {
                            if (count($comando) == 3 &&
                                ($comando[1] == 'matricula' || $comando[1] == 'email')) $identificacoes++;
                            else
                            {
                                $this->mostrar_erro('erro sintático no arquivo na linha ' . ($i+1) . ': ' .
                                                    'a definição do identificador deve assumir o formato ' .
                                                    '$ID:matricula::valor ou $ID::email::valor.'); return false;
                            }
                        }
                        else  if ($comando[0] == '$CODIGO')
                        {
                            if (count($comando) == 2) $codigos_jogo++;
                            else
                            {
                                $this->mostrar_erro('erro sintático no arquivo na linha ' . ($i+1) . ': ' .
                                                    'a definição do jogo deve assumir o formato ' .
                                                    '$CODIGO::valor.'); return false;
                            }
                        }
                        else
                        {
                             $this->mostrar_erro('comando inválido na linha ' . ($i+1) . ': ' .
                                                 $comando[0]); return false;
                        }
                    }
                    else
                    {
                         $indicador = explode("::", $linha);
                         if (count($indicador) == 2)
                         {
                            $indicadores++;
                         }
                         else
                         {
                            $this->mostrar_erro('comando inválido na linha ' . ($i+1) . ': ' .
                                                 $comando[0]); return false;
                         }
                    }
                }
            }
        }

        if ($codigos_jogo == 0)
        {
            $this->mostrar_erro('o arquivo não define o código do jogo'); return false;
        }

        if ($codigos_jogo > 1)
        {
            $this->mostrar_erro('o arquivo define o código do jogo mais de uma vez'); return false;
        }

        if ($identificacoes == 0)
        {
            $this->mostrar_erro('nenhum jogador foi definido no arquivo'); return false;
        }

        if ($indicadores == 0)
        {
            $this->mostrar_erro('nenhum indicador foi definido no arquivo'); return false;
        }
        return true;
    }

    function importar_arquivo($texto)
    {
        $data           = explode("\n", $texto);
        
        $codigo_jogo    = '';
        $jogadores      = array();
        $jogador        = null;

        for ($i = 0; $i < count($data); $i++)
        {
            $linha = trim($data[$i]);
            if (strlen($linha) > 0)
            {
                if ($linha{0} != '#')
                {
                    if ($linha{0} == '$')
                    {
                        $comando = explode("::", $linha);
                        if ($comando[0] == '$ID')
                        {
                            if ($jogador != null) $jogadores[] = $jogador;

                            $jogador = array( 'tipo_identificador' => '',
                                              'identificador' => '',
                                              'indicadores' => array()  );

                            if ($comando[1] == 'matricula')  $jogador['tipo_identificador'] = 'matricula';
                            else                             $jogador['tipo_identificador'] = 'email';
                            $jogador['identificador'] = $comando[2];
                        }
                        else  if ($comando[0] == '$CODIGO') $codigo_jogo = $comando[1];
                    }
                    else
                    {
                        if ($jogador)
                        {
                             $indicador = explode("::", $linha);
                             $jogador['indicadores'][$indicador[0]] =  $indicador[1];
                        }
                    }
                }
            }
        }
        if ($jogador != null) $jogadores[] = $jogador;

        $instituicao_id = $this->Session->read('Auth.Usuario.instituicao_id');
                
        // Identifica o jogo.
        $jogo = $this->Jogo->find('list',
                                   array('conditions' => array('Jogo.codigo' => $codigo_jogo,
                                                               'Jogo.instituicao_id' => $instituicao_id)));

        //print_r($jogo);
        if (count($jogo) != 1)
        {
            $this->mostrar_erro('código de jogo inválido'); return false;
        }
        $jogo_id = key($jogo);

        foreach($jogadores as $jogador)
        {
            if ($jogador['tipo_identificador'] == 'matricula')
            {
                $j = $this->Jogador->find('list',
                                          array('conditions' => array('Jogador.matricula' => $jogador['identificador'],
                                                                      'Jogador.instituicao_id' => $instituicao_id)));
            }
            else
            {
                $j = $this->Jogador->find('list',
                                          array('conditions' => array('Jogador.email' => $jogador['identificador'],
                                                                      'Jogador.instituicao_id' => $instituicao_id)));
            }

            if (count($j) > 0)
            {
                foreach ($jogador['indicadores'] as $codigo_indicador => $valor_indicador)
                {

                    $i = $this->Indicador->find('list',
                                                array('conditions' => array('Indicador.codigo'  => $codigo_indicador,
                                                                            'Indicador.jogo_id' => $jogo_id)));

                    $data = array(
                        'indicador_id' => key($i),
                        'jogador_id'   => key($j),
                        'valor' => $valor_indicador,
                        'data' => Date('Y-m-d h:i:s')
                    );
                    $this->Registro->create();
                    $this->Registro->set($data);
                    $this->Registro->save();

                    //print_r($data);
                }

            }
        }

        return true;
    }

    function importar()
    {
         $MAX_FILE_SIZE = 1024 * 1024;

         $this->area_restrita();
         $this->set('pagina_area_restrita'   , 'importar');

         if (!empty($this->data))
         {
            if ($this->data['Indicador']['arquivo']['name'] == '')
            {
                $this->mostrar_erro('é necessário informar um arquivo.'); return ;
            }

            if ($this->data['Indicador']['arquivo']['size'] >= $MAX_FILE_SIZE)
            {
                $this->mostrar_erro('tamanho do arquivo excedido.'); return ;
            }
            
            $data = file_get_contents($this->data['Indicador']['arquivo']['tmp_name']);
            if ($this->validar_arquivo($data))
            {
                if ($this->importar_arquivo($data))
                    $this->mostrar_mensagem('Arquivo processado com sucesso.');
            }
         }
    }
}
?>
