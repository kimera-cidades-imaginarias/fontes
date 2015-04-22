<?php
class ApiController extends AppController {

    var $name = 'API';
    var $uses = array('Jogador', 'Jogo', 'Indicador', 'Registro');

    function index()
    {       
        $this->layout   = 'ajax';
        $params         = Array();
        
        // Identifica a ação.
        if (!isset($this->params['form']['action'])) $action = 'login';
        else $action = $this->params['form']['action'];
        
        if ($action == 'login')
        {
            $identificador = isset($this->params['form']['identificador']) ? $this->params['form']['identificador'] : 'email';
            if ($identificador != 'email' && $identificador != 'matricula') $identificador = 'email';

            $id     = trim($this->params['form'][$identificador]);
            $senha  = trim($this->params['form']['senha']);

            //Localiza o registro do usuário.
            $jogador = $this->Jogador->find('all', array('conditions' => array( 'Jogador.' . $identificador => $id,
                                                                                'Jogador.senha' => $senha )));           
            // Usuário localizado.
            if (count($jogador) == 1)
            {
                // Cria a sessão.
                $session_id = md5(uniqid(rand(), true));
                $this->Jogador->query(  " UPDATE lud_jogadores " .
                                        " SET session_id = \"" .  $session_id . "\" " . 
                                        " WHERE id = " . $jogador[0]['Jogador']['id']);
                $params['id']           = $session_id;
                $params['erro']         ='0';
                $params['desc']         ='Usuário identificado.';
                //$_SESSION["jogador_id"] = $jogador[0]['Jogador']['id'];
                //$params['id']           = session_id();
            }

            // Usuário inválido.
            else
            {
                $params['id']   = '';
                $params['erro'] = '1';
                $params['desc'] = 'Usuário inválido.';
            }
        }
        else
        {
            $id = trim($this->params['form']['id']);
            if ($id == '') 
            {
                $logado = false;
            }
            else
            {
                $j = $this->Jogador->find('first',
                    array('conditions' => array('Jogador.session_id' => $id)));
                
                if ($j)
                {
                    $jogador =  $j['Jogador'];
                    $logado = true;
                }
                else
                {
                    $logado = false;
                }

                //session_id($id);
                //$logado = isset($_SESSION["jogador_id"]);
            }

            $params['id'] = $id;
            if ($logado)
            {
                if ($action == 'whoami')
                {
                    //$params['jogador_id'] = $_SESSION["jogador_id"];
                    //$j = $this->Jogador->findAllBySessionId($params['jogador_id']);
                    $params['nome']   = $jogador['nome'];
                    $params['email']  = $jogador['email'];
                    $params['erro']   ='0';
                }
                else if ($action == 'logout')
                {
                    $this->Jogador->query(  " UPDATE lud_jogadores " .
                                            " SET session_id = \"\" " .
                                            " WHERE id = " . $jogador[0]['Jogador']['id']);
                    $params['erro'] = '0';
                    $params['desc'] = 'Sessão encerrada.';
                    $params['id'] = session_id();
                    //session_unset();
                    //session_destroy();
                }
                else if ($action == 'indicador')
                {
                    //Identifica o jogo correspondente ao código passado.
                    $codigo_jogo = trim($this->params['form']['codigo_jogo']);
                    $j = $this->Jogo->findAllByCodigo($codigo_jogo);

                    //Código válido, jogo localizado.
                    if (count($j) == 1)
                    {
                        // Identifica o indicador correspondente.
                        $codigo_indicador = trim($this->params['form']['codigo_indicador']);
                        $jogo_id          = trim($j[0]['Jogo']['id']);
                        $i = $this->Indicador->find('all', array('conditions' => array('Indicador.codigo' => $codigo_indicador,
                                                                                       'Indicador.jogo_id' => $jogo_id)));

                        //Código de indicador válido.
                        if (count($i) == 1)
                        {
                            $valor = $this->params['form']['valor'];
                            if (strlen($valor) > 10) $valor = substr($valor, 0, 10);

                            $this->Registro->read(null);
                            $this->Registro->set(array(
                                'indicador_id' => $i[0]['Indicador']['id'],
                                'jogador_id'   => $jogador["id"],
                                'valor'        => $valor,
                                'data'         => Date('Y-m-d h:i:s')
                            ));
                            $this->Registro->save();

                            $params['erro'] = '0';
                            $params['desc'] = 'Registrado.';
                        }
                        else
                        {
                            $params['erro'] = '1';
                            $params['desc'] = 'Código de indicador inválido ("' . $codigo_indicador . '").';
                        }
                    }
                    else
                    {
                        $params['erro'] = '1';
                        $params['desc'] = 'Código de jogo inválido.';
                    }
                }
                
                // Retorna o valor do ÚLTIMO registro
                // de um indicador.
                else if ($action == 'getindicador')
                {
                    //Identifica o jogo correspondente ao código passado.
                    $codigo_jogo = trim($this->params['form']['codigo_jogo']);
                    $j = $this->Jogo->findAllByCodigo($codigo_jogo);

                    if (count($j) == 1)
                    {
                        // Identifica o indicador correspondente.
                        $codigo_indicador = trim($this->params['form']['codigo_indicador']);
                        $jogo_id          = trim($j[0]['Jogo']['id']);
                        $i = $this->Indicador->find('all', array('conditions' => array('Indicador.codigo' => $codigo_indicador,
                                                                                        'Indicador.jogo_id' => $jogo_id)));

                        if (count($i) > 0)
                        {
                            $jogo_id          = trim($j[0]['Jogo']['id']);
                            $indicador_id     = trim($i[0]['Indicador']['id']);
                            $jogador_id       = $jogador["id"];

                            $r = $this->Registro->find('all', array('conditions' => array('Registro.indicador_id' => $indicador_id,
                                                                                          'Registro.jogador_id'   => $jogador_id),
                                                                    'order' => array('Registro.id DESC'),
                                                                    'limit' => 1));
                            $params['erro']  = '0';
                            $params['desc']  = '';

                            if (count($r) > 0) $params['valor'] = $r[0]['Registro']['valor'];
                            else $params['valor'] = '';
                        }
                        else
                        {
                            $params['erro'] = '1';
                            $params['desc'] = 'Código de indicador inválido.';
                        }
                    }
                    else
                    {
                        $params['erro'] = '1';
                        $params['desc'] = 'Código de jogo inválido.';
                    }
                }
            }
            else
            {
                $params['erro'] = '1';
                $params['desc'] = 'É necessário estar logado para executar essa operação.';
            }
        }
         
        $this->set('params', $params);
    }

    function session_started()
    {
        return isset($_SESSION);
    }
}
?>
