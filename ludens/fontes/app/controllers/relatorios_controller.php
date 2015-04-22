<?php
/**
 * Description of jogos_controller
 *
 * @author Administrador
 */
class RelatoriosController extends AppController {
    var $name       = 'Relatorios';
    var $scaffold   = 'admin';
    
    var $components = array('GruposUtil');
    var $uses       = array('Jogo', 'Jogador', 'Instituicao', 'Grupo', 'Indicador', 'Registro');

    // Formulário de filtragem.
    function admin_indicadores_filtros()
    {
        $this->set('jogos'      , $this->Jogo->find('list'));
        $this->set('instituicoes'   , $this->Instituicao->find('list'));
    }

    function admin_atualizar_grupos()
    {
        $this->layout = 'ajax';
        if(!empty($this->data['Indicadores']['instituicao']))
        {
            $instituicao_id = $this->data['Indicadores']['instituicao'];
            $this->set('grupos', $this->GruposUtil->get_grupos($instituicao_id));
        }
        else $this->set('grupos', array());
     }

     function admin_atualizar_jogadores()
     {
         $this->layout = 'ajax';
         $this->set('grupoInvalido', false);

         $this->set('jogadores', array());
         if(!empty($this->data['Indicadores']['grupo']))
         {
             $grupo_id  = $this->data['Indicadores']['grupo'];
             $grupo     = $this->Grupo->findById($grupo_id);

             if (count($grupo['SubGrupo']) == 0) $this->set('jogadores', $grupo['Jogador']);
             else $this->set('grupoInvalido', true);
             //$this->set('jogadores', $this->GruposUtil->get_jogadores($grupo_id));
         }
     }

     function listar_jogadores_grupo_atual()
     {
         $jogadores = array();
         if(!empty($this->data['Indicadores']['grupo']))
         {
             $grupo_id  = $this->data['Indicadores']['grupo'];
             $grupo     = $this->Grupo->findById($grupo_id);

             if (count($grupo['SubGrupo']) == 0)
             {
                 foreach ($grupo['Jogador'] as $jogador)
                 {
                    $jogadores[$jogador['id']] = $jogador['nome'];
                 }
             }
         }
         $this->set('jogadores', $jogadores);
     }
  
     // Geração do relatório.
     function admin_gerar_indicadores()
     {
         $this->layout = 'ajax';
         $this->gerar_indicadores();
     }

     //------------------------------------------------------------------------

     function relatorios()
     {
         $this->area_restrita();
         $this->set('pagina_area_restrita'  , 'relatorios');

         $instituicao_id = $this->Session->read('Auth.Usuario.instituicao_id');

         $instituicao = $this->Instituicao->findById($instituicao_id);
         
         $this->Session->write('instituicao'        , $instituicao['Instituicao']['nome']);
         $this->Session->write('instituicao_tipo'   , $instituicao['Instituicao']['tipo']);

         $this->set('jogos' , $this->Jogo->find('list',
                                                array('conditions' =>
                                                        array('Jogo.instituicao_id' => $instituicao_id))));
         $this->set('grupos', $this->GruposUtil->get_grupos($instituicao_id));
         $this->set('jogador_selecionado', false);

         $this->gerar_indicadores();
     }

     function gerar_indicadores()
     {
         $this->set('relatorio', false);

         // Relatório de grupo.
         if (!empty($this->data['Indicadores']['grupo']))
         {
             $this->set( 'relatorio', true);
             $this->set( 'jogador_selecionado'  , true );
             $this->listar_jogadores_grupo_atual();

             // Instituição.
             $instituicao = $this->Instituicao->find('all', array('conditions' => array('Instituicao.id' => $this->data['Indicadores']['instituicao'])));
             $this->set('instituicao', $instituicao[0]);
             $this->set('debug', '');

             // Jogo.
             $jogo = $this->Jogo->findById($this->data['Indicadores']['jogo']);
             $this->set('jogo', $jogo);

             // Matriz NxN
             // 1º linha: ---          , jogador, grupo1, grupo2, ..., grupon
             // 2º linha: Tempo quest 1,      10,     15,     20, ..., 17.5
             // ...
             $resultado = array();

             $linha   = array();
             $linha[] = '---';

             // Relatório de grupo ou de jogador?
             $relatorio_grupo = empty($this->data['Indicadores']['jogador']) || ($this->data['Indicadores']['jogador'] == '0');

             if (!$relatorio_grupo)
             {
                 $jogador   = $this->Jogador->findById($this->data['Indicadores']['jogador']);
                 $this->set('jogador', $jogador);
                 $linha[]  = $jogador['Jogador']['nome'];
             }

             $primeiroGrupo = $this->Grupo->findById($this->data['Indicadores']['grupo']);
             $grupo         = $primeiroGrupo;
             $this->set('grupo', $primeiroGrupo);
             
             do {
                 $linha[] = $grupo['Grupo']['nome'];
                 if (isset($grupo['GrupoPai'])) $grupo   =  $this->Grupo->findById($grupo['GrupoPai']['id']);
                 else $grupo = null;
             } while ($grupo);

             array_push($resultado, $linha);

             // Indicadores associados ao jogo.
             $indicadores = $this->Indicador->find('all',
                    array('conditions' => array('Indicador.jogo_id' => $this->data['Indicadores']['jogo']),
                          'order' => array('Indicador.nome')
                    )
             );

             // Percorre os indicadores, calculando para cada indicador o valor do jogador e
             // dos grupos.
             foreach ($indicadores as $indicador)
             {
                 $linha     = array();
                 $linha[]   = array($indicador['Indicador']['nome'], $indicador['Indicador']['descricao'], $indicador['Indicador']['id']);

                 // Como a informação será apresentada.
                 // Primeiro registro realizado.
                 $indice = 0;
                 if ($indicador['Indicador']['exibir'] == 1)
                 {
                        $indice = 'Registro';
                        $order = 'Registro.id ASC';
                        $field = 'Registro.valor AS resultado';
                        $limit = 1;
                 }

                 // Último registro realizado
                 else  if ($indicador['Indicador']['exibir'] == 2)
                 {
                        $indice = 'Registro';
                        $order = 'Registro.id DESC';
                        $field = 'Registro.valor AS resultado';
                        $limit = 1;
                 }

                 // Menor dos registros.
                 else  if ($indicador['Indicador']['exibir'] == 3)
                 {
                        $order = null;
                        $field = 'min(Registro.valor) AS resultado';
                        $limit = null;
                 }

                 // Maior dos registros.
                 else  if ($indicador['Indicador']['exibir'] == 4)
                 {
                        $order = null;
                        $field = 'max(Registro.valor) AS resultado';
                        $limit = null;
                 }

                 // Soma dos registros.
                 else  if ($indicador['Indicador']['exibir'] == 5)
                 {
                        $order = null;
                        $field = 'sum(Registro.valor) AS resultado';
                        $limit = null;
                 }

                 // Média dos registros.
                 else  if ($indicador['Indicador']['exibir'] == 6)
                 {
                        $order = null;
                        $field = 'avg(Registro.valor) AS resultado';
                        $limit = null;
                 }

                 // Recupera o valor que o jogador teve para o indicador.
                 if (!$relatorio_grupo)
                 {
                    $r = $this->Registro->find('all', array(
                        'conditions' =>  array('Registro.jogador_id'     => $jogador['Jogador']['id'],
                                               'Registro.indicador_id'   => $indicador['Indicador']['id']),
                        'fields'     => $field,
                        'order'      => $order,
                        'limit'      => $limit
                    ));

                    if ($r)  $linha[] = $this->formatar_valor($r[0][$indice]['resultado'], $indicador['Indicador']['tipo']); //$linha[] = $r[0][$indice]['resultado'];
                    else     $linha[] = '-';
                 }

                 // Recupera o valor para os grupos.
                 $grupo         = $primeiroGrupo;
                 do {

                    $ids_jogadores = $this->GruposUtil->get_jogadores($grupo['Grupo']['id']);
                    if (!is_string($indice))
                    {
                        // Calcula o valor agrupando por cada jogador do grupo.
                        $registros = $this->Registro->find('all', array(
                            'fields'     => $field,
                            'conditions' => array(  'Registro.indicador_id' => $indicador['Indicador']['id'],
                                                    'Registro.jogador_id' => $ids_jogadores),
                            'group'      => 'Registro.jogador_id'
                        ));

                        // Contabiliza a média.
                        $valor = 0;
                        for ($i = 0; $i < count($registros); $i++) $valor += $registros[$i][0]['resultado'];
                        if ($valor != 0) $valor = $valor / count($registros);
                    }
                    else
                    {
                        $dbo = $this->Registro->getDataSource();
                        $subQuery = $dbo->buildStatement(
                            array(
                                'fields' => array('max(Registro2.id)'),
                                'table' => $dbo->fullTableName($this->Registro),
                                'alias' => 'Registro2',
                                'conditions' => array('Registro2.indicador_id'  => $indicador['Indicador']['id'],
                                                      'jogador_id'              => $ids_jogadores),
                                'group' => 'Registro2.jogador_id',
                                'limit' => null,
                                'offset'=> null,
                                'order' => null,
                                'joins' => array()
                            ),
                            $this->Registro
                        );

                        $subQuery           = ' Registro.id IN (' . $subQuery . ') ';
                        //echo $subQuery;
                        $subQueryExpression = $dbo->expression($subQuery);
                        $conditions         = array();
                        $conditions[]       = $subQueryExpression;

                        $registros = $this->Registro->find('all', array(
                            'fields'     => array('avg(Registro.valor) as resultado'),
                            'conditions' => $conditions
                        ));

                        $valor = $registros[0][0]['resultado'];
                    }

                    $valor = $this->formatar_valor($valor, $indicador['Indicador']['tipo']);
                    $linha[] = $valor;

                    if (isset($grupo['GrupoPai'])) $grupo   =  $this->Grupo->findById($grupo['GrupoPai']['id']);
                    else $grupo = null;
                 } while ($grupo);

                 array_push($resultado, $linha);
             }

              $this->set('resultado', $resultado);
         }
     }

     function atualizar_jogadores()
     {
         $this->admin_atualizar_jogadores();
     }

     function formatar_tempo($tempo)
     {
         $tempoint = intval($tempo);
         return gmdate("H:i:s", $tempoint);// . ' (' . $tempo . ')';
     }

     function formatar_valor($valor, $tipo)
     {
        // Indicador tipo tempo
        if ($tipo == 2)
        {
            $valor = $this->formatar_tempo( $valor );
        }

        //Indicador sim / nao
        else  if ($tipo == 3)
        {
            $valor = $valor ? 'Sim' : 'Não';
        }
        else
        {
            $valor =  number_format(floatval($valor), 2);
        }

        return $valor;
     }

     function registros($jogador_id, $indicador_id)
     {
         $this->layout = 'ajax';
         //$this->layout = 'site';

         $jogador   = $this->Jogador->findById($jogador_id);
         $indicador = $this->Indicador->findById($indicador_id);
         $this->set('jogador'   , $jogador['Jogador']['nome']);
         $this->set('indicador' , $indicador['Indicador']['nome']);
         $tipo = $indicador['Indicador']['tipo'];


         //'date_format(data,"%d/%m/%Y %H:%i:%s") as data',
         $registros = $this->Registro->find('all', array(
                            'fields'     => array( 'valor', 'data' ),
                            'conditions' => array(  'jogador_id'      => $jogador_id,
                                                    'indicador_id'   => $indicador_id    ),
                            'order'      => 'data DESC'
         ));

         $r = array();
         foreach ($registros as $registro)
         {
             $dataHora = explode(' ', $registro['Registro']['data']);
             $data = explode('-', $dataHora[0]);
             $data = $data[2] . '/' . $data[1] . '/' . $data[0];
             $data = $data . ' ' . $dataHora[1];
             $r[] = array( 'data' =>  $data, 'valor' => $this->formatar_valor($registro['Registro']['valor'], $tipo) );
         }

         $this->set('registros', $r);
     }

}
?>

