package core
{
	import as3isolib.display.IsoSprite;
	
	import core.dados.DataLoader;
	import core.eventos.EventoSimulador;
	import core.pathfinding.LocalizadorRotas;
	
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.utils.clearInterval;
	import flash.utils.getTimer;
	import flash.utils.setInterval;
	
	import gs.TweenLite;
	import gs.easing.Linear;
	
	public class Simulador extends EventDispatcher
	{
		public static const EDUCACAO  = "Educação";
		public static const MORADIA   = "Moradia";
		public static const SEGURANCA = "Segurança";
		public static const COMERCIO = "Comércio";
		public static const SAUDE = "Saúde";
		public static const INFRA = "Infraestrutura";

		const TEMPO_TURNO 		= 5000;
		const INDICE_INICIAL   	= 0.7;
		const CONSTANTE_CRESCIMENTO_POPULACAO = 3000;
		
		const FASE_COMECAM_DESASTRES = 99;
		
		// Percentagem que será aplicada ao valor da construcao
		// para definir seu valor de conserto.
		const PERCENTAGEM_CONSERTO = 1.3;
		
		private static var simulador = null;
		
		private var turnoAtual : int;
		private var fase       : Fase	= null;
		private var timer      : Timer;
		
		// Vetor de construções da fase
		private var construcoes : Array;
		
		private var emissores  : Array;
		
		private var dinheiro   			: Number;
		private var usandoEmprestimo 	: Boolean = false;
		private var dinheiroEmprestimo  : Number;		
		
		private var indices	   : Array;
		private var pontos  : int;
		private var populacao  : int;
		private var habitados  : int;
		private var empregados  : int;
		private var desempenho : Number;
		
		private var nivel	   		: int;
		private var xpsNivel		: int;
		private var xpsAcumulados	: int;
		private var xpsNecessarios	: int;
		
		private var render	   = null;
		private var dataLoader : DataLoader = null;
		
		private var toId;
		private var emPausa : Boolean;;
		
		// Variáveis de tempo
		private var difAnterior;			// (1): Auxilia no cálculo para determinar quando é o próximo turno;
		private var tempoTotalFase;			// (2): Tempo total da fase até o momento, excluindo tempos perdidos em pausas;
		private var tempoInicioFase;		// (3): Marca tempo em que a fase iniciou;
		private var tempoInicioEmprestimo;	// (4): Indica o tempo em que começou a utilizar o empréstimo. Quando o empréstimo está disponível, fica com valor de -1;
		private var tempoUltimoEmp;			// (5): Indica o tempo que o empréstimo esgota e começa a enxer denovo;
		private var tempoPausasEmp;			// (6): Marca tempo de pausa ocorrida durante o empréstimo;
		private var tempoInicioPausa;		// (7): Marca tempo que se iniciou a pausa;
		private var tempoTotalPausa;		// (8): Tempo total gasto em pausas durante a fase;
		private var tempoUltimaPausa;		// (9): Marca tempo que terminou a última pausa;
		
		private var tempoInicialBoss:Number = new Number(0);
		private var tempoFinalBoss:Number = new Number(0);	
		private var tempoTotalBoss:Number = new Number(0);
		
		private var localizadorRotas : LocalizadorRotas;
		
		private var carros	  : Array = [ Carro1, Carro2, Carro3, Carro4 ];
		private var veiculos  : Array = [];
		
		private var variaveis : Array = new Array();
		
		private var turnosSemDesastre : int = 0;
		
		public static function GetInstance()
		{
			if(simulador == null) simulador = new Simulador();
			return simulador;
		}
		
		public function Simulador()
		{
			simulador = this;
			render     = FaseRender.GetInstance();
			dataLoader = DataLoader.GetInstance();
			
			indices	   = new Array();

			indices.push(INDICE_INICIAL);
			indices.push(INDICE_INICIAL);
			indices.push(INDICE_INICIAL);	
			indices.push(INDICE_INICIAL);
			indices.push(INDICE_INICIAL);
			indices.push(INDICE_INICIAL);
		}
		
		public function Iniciar( pFase: Fase )
		{		
			fase 	   			= pFase;
			
			//localizadorRotas 	= new LocalizadorRotas( fase.GetMatriz() );	
			
			emPausa = false;
			// Acrescenta carros no inicio da fase.
			//AdicionarVeiculos();
			
			// Construções já devem iniciar prontas.
			construcoes = fase.GetConstrucoes();
			for (var i = 0; i < construcoes.length; i++) construcoes[i].SetTempoCriacao(-999999);
						
			populacao  = fase.GetPopulacaoInicial();
			habitados  = fase.GetHabitadosInicial();
			empregados  = fase.GetEmpregadosInicial();
			dinheiro   = fase.GetDinheiroInicial();
			
			turnoAtual  			= 0;
			tempoTotalFase			= 0;
			tempoInicioEmprestimo	= 0;
			tempoTotalPausa			= 0;
			tempoUltimaPausa		= 0;
			tempoPausasEmp			= 0;

			tempoInicialBoss 		= 0;
			tempoFinalBoss 			= 0;
			tempoTotalBoss 			= 0;
			
			var tempoAtual = getTimer();
			tempoInicioFase 		= tempoAtual;
			toId = setInterval(Simular, 100);
			
			tempoUltimoEmp = tempoInicioFase;
						
			indices[Simulador.EDUCACAO]		= CalcularIndice( Simulador.EDUCACAO );
			indices[Simulador.MORADIA] 		= CalcularIndice( Simulador.MORADIA );
			indices[Simulador.SEGURANCA] 	= CalcularIndice( Simulador.SEGURANCA );		
			indices[Simulador.COMERCIO] 	= CalcularIndice( Simulador.COMERCIO );
			indices[Simulador.SAUDE] 		= CalcularIndice( Simulador.SAUDE );
			indices[Simulador.INFRA] 		= CalcularIndice( Simulador.INFRA );
			
			desempenho  	= (indices[Simulador.EDUCACAO] + indices[Simulador.MORADIA] + indices[Simulador.SEGURANCA] +
							   indices[Simulador.COMERCIO] + indices[Simulador.SAUDE] + indices[Simulador.INFRA]) / 6;
			nivel			= fase.GetNivelInicial();
			xpsNivel		= 50; //inicia-se com 50 de xp
			xpsAcumulados	= 0;
			xpsNecessarios	= dataLoader.XpsParaProximoNivel(nivel);
			dinheiroEmprestimo = 0;
			
			if(!fase.IsTutorial()) DispacharEventoIndice();

			dispatchEvent(new EventoSimulador(EventoSimulador.DESEMPENHO	, {valor: desempenho}));
			dispatchEvent(new EventoSimulador(EventoSimulador.DINHEIRO		, {quantidade: dinheiro, emprestimo: dinheiroEmprestimo}));
			dispatchEvent(new EventoSimulador(EventoSimulador.POPULACAO		, {populacao: populacao}));
			dispatchEvent(new EventoSimulador(EventoSimulador.HABITADOS		, {habitados: habitados}));
			dispatchEvent(new EventoSimulador(EventoSimulador.EMPREGADOS	, {empregados: empregados}));
			
			dispatchEvent(new EventoSimulador(EventoSimulador.ATUALIZAR_NIVEL_JOGADOR, {nivel: nivel}));
			dispatchEvent(new EventoSimulador(EventoSimulador.ATUALIZAR_XP, {perc: 0.00001, pontos: 0}));
		}
		
		//------------------------------------------
		//
		// 			Turnos e simulação do jogo
		//
		//------------------------------------------
		
		/* Função chama a cada 100 ms que faz o controle da simulação do jogo */
		
		public function Simular()
		{
			//trace("t: " + tempoTotalPausa);
			var proximoTurno;
			var tempoAtual  = getTimer();
			tempoTotalFase	= tempoAtual - tempoInicioFase - tempoTotalPausa;
			
			var dif = tempoTotalFase % TEMPO_TURNO;
			if(dif < difAnterior) proximoTurno = true;
			else proximoTurno = false;
			difAnterior = dif;
			
			tempoUltimaPausa = 0;
						
			AtualizarConstrucoes();
			AtualizarMensagens();
			
			var p = proximoTurno ? 1 : dif/TEMPO_TURNO;
			dispatchEvent(new EventoSimulador(EventoSimulador.PROGRESSO_TURNO, {percentagem: p}));
			if (proximoTurno) ProximoTurno();
			
			render.AtualizarCena( 1 );
		}
		
		/* A cada turno essa função é chamada. Nela se fazem cálculos como o quanto a população cresceu naquele turno,
		o quanto se recebeu dinheiro, etc, e dispacha tudo via evento para os ouvintes da classe Game. */
		
		private function ProximoTurno()
		{
			if(Global.variables.modoEditor == false)
			{
				// Calcula os índices.
				indices[Simulador.EDUCACAO]	= CalcularIndice( Simulador.EDUCACAO );
				indices[Simulador.MORADIA] 	= CalcularIndice( Simulador.MORADIA );
				indices[Simulador.SEGURANCA]= CalcularIndice( Simulador.SEGURANCA );
				indices[Simulador.COMERCIO]= CalcularIndice( Simulador.COMERCIO );
				indices[Simulador.SAUDE]= CalcularIndice( Simulador.SAUDE );
				indices[Simulador.INFRA]= CalcularIndice( Simulador.INFRA );
							
				// Processa os eventos.
				ProcessarEventos();
				
				// Atualizar construcoes.
				AtualizarConstrucoes();
				
				// Crescimento populacional
				//var nascidos 	= (( 0.027 * ( 1 - indices[Simulador.EDUCACAO] ) + 0.003) * populacao )/288;
				var nascidos 	= 0.01 * this.GetPopulacaoTotal();
				populacao 		= populacao + nascidos;
				
				ReceberDinheiro();
							
				turnoAtual++;
				
				desempenho  	= (indices[Simulador.EDUCACAO] + indices[Simulador.MORADIA] + indices[Simulador.SEGURANCA] +
									indices[Simulador.COMERCIO] + indices[Simulador.SAUDE] + indices[Simulador.INFRA]) / 6;
							
				dispatchEvent(new EventoSimulador(EventoSimulador.TURNO 	, {turno : turnoAtual}));

				dispatchEvent(new EventoSimulador(EventoSimulador.INDICE	, {indice: Simulador.EDUCACAO	, valor: indices[Simulador.EDUCACAO]}));
				dispatchEvent(new EventoSimulador(EventoSimulador.INDICE	, {indice: Simulador.MORADIA	, valor: indices[Simulador.MORADIA]}));
				dispatchEvent(new EventoSimulador(EventoSimulador.INDICE	, {indice: Simulador.SEGURANCA	, valor: indices[Simulador.SEGURANCA]}));
				dispatchEvent(new EventoSimulador(EventoSimulador.INDICE	, {indice: Simulador.COMERCIO	, valor: indices[Simulador.COMERCIO]}));
				dispatchEvent(new EventoSimulador(EventoSimulador.INDICE	, {indice: Simulador.SAUDE		, valor: indices[Simulador.SAUDE]}));			
				dispatchEvent(new EventoSimulador(EventoSimulador.INDICE	, {indice: Simulador.INFRA		, valor: indices[Simulador.INFRA]}));

				dispatchEvent(new EventoSimulador(EventoSimulador.POPULACAO	, {populacao: populacao}));
				
				AtualizarClima();
				VerificarMetasIndices();
			}
			else
			{
				turnoAtual++;

				dispatchEvent(new EventoSimulador(EventoSimulador.TURNO 	, {turno : turnoAtual}));
			}
		}		
		
		private function GetProbabilidadeEvento( categoria )
		{
			if (categoria == Simulador.MORADIA)
			{
				return (1 - indices[Simulador.MORADIA]) / 2;
			}
			else if (categoria == Simulador.SEGURANCA)
			{
				return ((1-indices[Simulador.SEGURANCA])/4) + ((1-indices[Simulador.EDUCACAO])/4);
			}
		}
		
		public function CalcularDanoDesastre()
		{
			return ((1-indices[Simulador.SEGURANCA])/2) * 100;
		}
		
		private function ProcessarEventos()
		{		
			/*	
			var construcao;
		
			// Evento de moradia.
			var probabilidade = GetProbabilidadeEvento(Simulador.MORADIA);
					
			// Cria uma favela em um ponto aleatório do mapa.
			var rand = Math.random();
			
			
			// TODO Avaliar uso de favelas
			if (rand <= probabilidade && fase.GetNumero() >= FASE_COMECAM_DESASTRES) // caso não sejam mais as fases de tutorial
			{
				var favelas 	= new Array('favela1', 'favela2', 'favela3');
				var favela		= favelas[ Math.floor(Math.random()*favelas.length) ];
				var estrutura	= dataLoader.GetEstruturaById( favela );
				var pos 		= fase.GetEspacoAleatorio( estrutura.GetTamanho() );
				
				if (pos) 
				{
					construcao	= new ConstrucaoFuncional(1, pos, estrutura, 'Favela', false);
					AdicionarNovaEstrutura( construcao );
				}
				else trace('Não há espaço livre p/ favela!');
			}
			
			// Evento de segurança.
			probabilidade = GetProbabilidadeEvento(Simulador.SEGURANCA);
			rand		  = Math.random();
			
			//Danifica uma construção funcional aleatória no mapa.
			if ((rand <= probabilidade) && (turnosSemDesastre == 0) && (fase.GetNumero() >= FASE_COMECAM_DESASTRES))
			{
				// Tipos de desastre. Use o placeholder {NOME} para exibir o nome da estrutura atingida.
				// TODO: Talvez seja melhor que isso seja definido via XML.
				var tiposDesastre = new Array(
					{categoria	: 'Educação'	, 
					 textos		:  new Array({titulo: 'Revolta' , texto: 'Alunos se revoltam com a baixa qualidade do ensino e promovem quebra-quebra numa das escolas da cidade.', rotulo: 'Quebra-quebra'},
											 {titulo: 'Passeata', texto: 'Funcionários promovem passeata contra a baixa qualidade do ensino público em Salvador.', rotulo: 'Revolta'})}, 
					{categoria	: 'Moradia'	, 
					 textos		:  new Array({titulo: 'Invasão', texto: 'Sem-tetos invadem condomínio em um bairro de classe média de Salvador.', rotulo: 'Quebra-quebra'})},
					{categoria	: 'Segurança', 
					 textos		: new Array({titulo: 'Violência', texto: 'Traficantes incedeiam {NOME} em Salvador.', rotulo: 'Assalto'})},
					{categoria	: 'Copa', 
					 textos		: new Array({titulo: 'Atentado', texto: 'Marginais provocam atentado no {NOME} de Salvador.', rotulo: 'Assalto'})}
				);
				
				// Cria um vetor apenas com categorias que possuem construcoes.
				var desastres = new Array();
				for (var i = 0; i < tiposDesastre.length; i++)
				{
					var tipo 		     = tiposDesastre[i];
					var construcoesCateg = fase.GetConstrucoesPorCategoria( tipo.categoria );
					
					if (construcoesCateg.length > 0) desastres.push({categoria	: tipo.categoria, 
														   		textos		: tipo.textos,
																construcoes : construcoesCateg});
				}
				
				if (desastres.length > 0)
				{
					var achou = false;
					while(!achou)
					{
						// Seleciona uma categoria aleatória.
						var desastreI 	= Math.floor( Math.random() * desastres.length );
						var desastre	= desastres[desastreI];
						
						// Seleciona uma construcao aleatória para aplicar o desastre.
						var construcaoI	= Math.floor( Math.random() * desastre.construcoes.length );
						construcao	= desastre.construcoes[construcaoI];
						
						if(construcao.GetStatus() == "pronta") achou = true;
					}
					
					//Seleciona um texto aleatório de descricao do desastre.
					var textoI		= Math.floor( Math.random() * desastre.textos.length );
					var nome		= construcao.GetEstrutura().GetNome().toLocaleLowerCase();
					var texto		= desastre.textos[textoI].texto.replace('{NOME}', nome);
										
					// Aplica o dano à construcao.
					var dano 		= CalcularDanoDesastre();
					construcao.AplicarDano( dano );
					
					// Dispacha o evento.
					dispatchEvent( new EventoSimulador(EventoSimulador.DESASTRE, {	construcao	: construcao,
													   								titulo		: desastre.textos[textoI].titulo,
													   								rotulo		: desastre.textos[textoI].rotulo,
																					texto		: texto }) );
				}
				else trace('Não há construções para aplicar desastre.');
			}
			
			if(fase.GetNumero() >= 4) turnosSemDesastre++;
			if((turnosSemDesastre == 2) && (fase.GetNumero() >= 4) && (fase.GetNumero() <= 8)) turnosSemDesastre = 0;
			else if(fase.GetNumero() > 8) turnosSemDesastre = 0;
			*/			
		}
		
		private function CalcularIndice( categoria: String )
		{
			var totalAtendido = 0;
			
			// Percorre a lista de construcoes daquele índice, computando
			// a quantidade de pessoas atendidas pela construção.
			for (var i = 0; i < construcoes.length; i++)
			{
				var c = construcoes[i];
				if (c is ConstrucaoFuncional)
				{
					var d : ConstrucaoFuncional = c;
					totalAtendido += c.GetContribuicao({tipo: 'atendimento', categoria: categoria});
				}
			}
			//var popConsiderada = ( fase.GetPercentPopConsiderada() / 100 ) * fase.GetPopulacaoInicial();
			//var indice = totalAtendido / ( popConsiderada + this.GetPopulacaoTotal() - fase.GetPopulacaoInicial() );
			
			var indice = totalAtendido / this.GetPopulacaoTotal();
			
			//trace("Calc Indice "+categoria+": "+totalAtendido+" / "+this.GetPopulacaoTotal()+" = "+indice * 100);
			indice > 1 ? indice = 1 : 0;

			return indice;
		}
		
		public function Encerrar()
		{
			clearInterval(toId);
		}
		
		//-----------------------------
		// Pausa
		//-----------------------------
		
		public function PausarSimulacao()
		{
			if(!emPausa)
			{
				emPausa = true;
				clearInterval(toId);
				tempoInicioPausa = getTimer();
			}
		}
		
		public function ContinuarSimulacao()
		{
			if(emPausa)
			{
				emPausa = false;
				tempoUltimaPausa = getTimer() - tempoInicioPausa;
				tempoPausasEmp += tempoUltimaPausa;
				tempoTotalPausa += tempoUltimaPausa;
				toId = setInterval(Simular, 100);
			}
		}
		
		public function PausaTutorial()
		{
			clearInterval(toId);
			tempoInicioPausa = getTimer();
			toId = setInterval(SimularApenasMensagens, 100);
		}
		
		public function ContinuacaoPosTutorial()
		{
			clearInterval(toId);
			ContinuarSimulacao();
		}
		
		// Retorna o tempo total gasto em pausa naquela fase. Método utilizado para o Ludens.
		public function GetTempoPausaFase() : int
		{
			if(emPausa)
			{
				tempoUltimaPausa = getTimer() - tempoInicioPausa;
				tempoTotalPausa += tempoUltimaPausa;
			}
			return tempoTotalPausa;
		}
		
		//---------------------------------------------------------
		// Métodos de empréstimo, de receber e gastar dinheiro.
		//---------------------------------------------------------
		
		private function AtualizarEmprestimos()
		{
//			if (tempoInicioEmprestimo == -1) return;
//			
//			if(!usandoEmprestimo)
//			{
//				var p = (getTimer() - tempoPausasEmp - tempoUltimoEmp) / fase.GetTempoEmprestimo();
//				if (p > 1) p = 1;
//				dispatchEvent( new EventoSimulador(EventoSimulador.ATUALIZAR_TEMPO_EMPRESTIMO, {percentagem: p}) );
//				if( Math.ceil(p * 100) >= 93 )
//				{
//					tempoPausasEmp = 0;
//					// Evita que o evento seja disparado novamente
//					tempoInicioEmprestimo = -1;
//					dispatchEvent( new EventoSimulador(EventoSimulador.EMPRESTIMO_DISPONIVEL, {quantidade: fase.GetValorEmprestimo()}) );
//				}
//			}
//			else
//			{
//				p = (getTimer() -  tempoPausasEmp - tempoInicioEmprestimo) / fase.GetTempoGastarEmprestimo();
//				if (p > 1) p = 1;
//				dispatchEvent( new EventoSimulador(EventoSimulador.UTILIZANDO_EMPRESTIMO, {percentagem: p} ) );
//				if (p == 1) ResetarEmprestimo();
//			}
		}
		
		public function SetUsandoEmprestimo( valor: Boolean )
		{
//			usandoEmprestimo = valor;
		}
		
		public function UsarEmprestimo()
		{
			// Assegura que o emprestimo está disponivel.
//			if (tempoInicioEmprestimo == -1)
//			{
//				usandoEmprestimo   = true;
//				dinheiroEmprestimo = fase.GetValorEmprestimo();
//				dispatchEvent( new EventoSimulador(EventoSimulador.UTILIZANDO_EMPRESTIMO, {percentagem: 0, valor: dinheiroEmprestimo}) );
//				tempoInicioEmprestimo = getTimer();
//			}
		}
		
		public function ResetarEmprestimo()
		{
//			tempoPausasEmp   	  = 0;
//			dinheiroEmprestimo	  = 0;
//			//tempoInicioEmprestimo = -1;
//			dispatchEvent( new EventoSimulador(EventoSimulador.TEMPO_EMPRESTIMO_ESGOTADO, {quantidade: fase.GetValorEmprestimo()}) );
//			usandoEmprestimo      = false;
//			tempoInicioEmprestimo = getTimer();
//			tempoUltimoEmp        = getTimer(); 
		}
		
		private function GastarDinheiro( quantidade )
		{
			dinheiroEmprestimo -= quantidade;
			if (dinheiroEmprestimo < 0)
			{
				dinheiro += dinheiroEmprestimo;
				dinheiroEmprestimo = 0;
			}
			
			// Vai aparecer uma mensagem falando que o jogador está com pouco dinheiro e que ele pode pegar emprestado.
			// Essa mensagem aparece apenas 1 vez, e é definida no XML da fase.
			//if((dinheiro < 50000) && (GetVariavel("poucoDinheiro") == "1")) SetVariavel("poucoDinheiro", "2");
			
			dispatchEvent(new EventoSimulador(EventoSimulador.DINHEIRO, {quantidade: dinheiro, emprestimo: dinheiroEmprestimo}));
		}
		
		private function GastarDesabitados( quantidade )
		{			
			populacao -= quantidade;
			habitados += quantidade;
			empregados += Math.round((quantidade/100)*10);

			if (habitados < 0) habitados = 0;
			if (populacao < 0) populacao = 0;
			
			dispatchEvent(new EventoSimulador(EventoSimulador.POPULACAO, {populacao: populacao}));
			dispatchEvent(new EventoSimulador(EventoSimulador.HABITADOS, {habitados: habitados}));
		}
		
		private function GastarHabitados( quantidade )
		{			
			habitados -= Math.round((quantidade/100)*10);
			empregados += quantidade;

			if (habitados < 0) habitados = 0;
			if (empregados < 0) empregados = 0;
			
			dispatchEvent(new EventoSimulador(EventoSimulador.HABITADOS, {habitados: habitados}));
			dispatchEvent(new EventoSimulador(EventoSimulador.EMPREGADOS, {empregados: empregados}));
		}
		
		private function RetornarDesabitados( quantidade )
		{			
			populacao += quantidade;
			habitados -= quantidade;

			if (habitados < 0) habitados = 0;
			if (populacao < 0) populacao = 0;
			
			dispatchEvent(new EventoSimulador(EventoSimulador.POPULACAO, {populacao: populacao}));
			dispatchEvent(new EventoSimulador(EventoSimulador.HABITADOS, {habitados: habitados}));
		}
		
		private function RetornarHabitados( quantidade )
		{			
			habitados += quantidade;
			empregados -= quantidade;
			
			if (habitados < 0) habitados = 0;
			if (empregados < 0) empregados = 0;

			dispatchEvent(new EventoSimulador(EventoSimulador.HABITADOS, {habitados: habitados}));
			dispatchEvent(new EventoSimulador(EventoSimulador.EMPREGADOS, {empregados: empregados}));
		}
		
		private function ReceberDinheiro()
		{
			var dinheiroRecebido = indices[Simulador.MORADIA] * indices[Simulador.SEGURANCA] * indices[Simulador.COMERCIO] * 
				this.GetPopulacaoTotal() * fase.GetConstanteK();
			
			dinheiro += dinheiroRecebido;
			
			dispatchEvent(new EventoSimulador(EventoSimulador.DINHEIRO, {quantidade: dinheiro, emprestimo: dinheiroEmprestimo}));
		}
		
		private function RetornarDinheiro( quantidade)
		{
			var dinheiroRecebido = quantidade;
			dinheiro += dinheiroRecebido;
			
			dispatchEvent(new EventoSimulador(EventoSimulador.DINHEIRO, {quantidade: dinheiro, emprestimo: dinheiroEmprestimo}));
		}
		
		//-------------------------------------
		// Mensangens
		//-------------------------------------
		
		private function AtualizarMensagens()
		{
			var mensagens = dataLoader.GetMensagens();
			
			for (var i = 0; i < mensagens.length; i++)
			{
				var m 	= mensagens[i];
				var ok	= true;
				var f = null;
				
				for each (var condicao:XML in m.condicoes.condicao) 
				{
					var valor;				
					if (condicao.tipo == 'indice') valor = indices[condicao.indice];
					else if (condicao.tipo == 'quantidade-construcoes') valor = GetConstrucoesPeloNome( condicao.construcao ).length;
					else if (condicao.tipo == 'objetivos-completos') valor = ContarMetasCompletas();
					else if (condicao.tipo == 'tempo-passado') valor = Math.ceil(tempoTotalFase / 1000);
					else if (condicao.tipo == 'variavel')
					{
						valor = GetVariavel(condicao.variavel);
						f     = m.funcao;
					}
					else 
					{
						trace('[Simulador.as] Mensagem de tipo desconhecido: ' + condicao.tipo + '.'); continue;
						continue;
					}
										
					if(condicao.condicao) ok = ok && Comparar(valor, condicao.valor, condicao.condicao);
					if (!ok) break;
				}
				
				if (ok)
				{
					mensagens.splice(i--, 1);
					dispatchEvent( new EventoSimulador(EventoSimulador.MENSAGEM	, {titulo: m.titulo, texto: m.texto, funcao: f, personagem: m.personagem, icone: m.icone}) );					
				}
			}
		}
		
		private function Comparar( valor1, valor2, condicao )
		{
			if (condicao == 'maior') return valor1 > valor2;
			else if (condicao == 'igual') return valor1 == valor2;
			else if (condicao == 'menor') return valor1 < valor2;
			else if (condicao == 'diferente') return valor1 != valor2;	
			else return false;
		}
		
		//--------------------------------------------------------
		//
		// 		Atualizar, adicionar e excluir objetos no mapa
		//
		//--------------------------------------------------------
		
		/* Atualizações*/
		
		private function AtualizarConstrucoes()
		{
			var tempoAtual 		= getTimer();
			var grafico ;
				
			for (var i = 0; i < construcoes.length; i++)
			{
				var c = construcoes[i];

				// O tempo para uma construção ser construida (GetTempoConstrucao()) é definido no XML.
				if (c.GetStatus() == Construcao.STATUS_CONSTRUINDO)
				{
					var estrutura		= c.GetEstrutura();
					grafico 			= c.GetGrafico();
					var percent 		= (tempoAtual - c.GetTempoCriacao()) / c.GetTempoConstrucao();
					var construcao_mc 	= grafico.container.getChildAt(0);
					grafico.sprites[0].progresso_mc.mask_mc.scaleX = percent;
					
					if(c.GetEstrutura().GetNome() == "Favela") percent = 1; // vai construir a favela de imediato.
					
					if (percent >= 1)
					{
						construcao_mc.alpha				= 1;
						grafico.sprites[1].visible 		= true;
						grafico.sprites[0].visible 		= false;
						grafico.container.mouseEnabled  = true;
						c.SetStatus( Construcao.STATUS_PRONTA );
						
						dispatchEvent(new EventoSimulador(EventoSimulador.CONSTRUCAO_PRONTA 	, {construcao : c}));
						VerificarMetasConstrucoes();
					}
				}
				
				// A construção é consertada na mesma velocidade em que é construida.
				// O valor para conserto de uma construcao, é calculado da seguinte forma:
				// valor conserto = hps_recuperados/100 * (Valor construcao * PERCENTAGEM_CONSERTO).
				// Se o dinheiro do jogador acaba, a construção vai continuar no estado de "construindo
				// até ter o valor necessário para terminar.
				else if (c.GetStatus() == Construcao.STATUS_CONSERTANDO)
				{
					grafico 			= c.GetGrafico();
					var hpsRecuperados  = ((tempoAtual - c.GetTempoConserto()) / c.GetTempoConstrucao()) * 100;
					var dinheiroGasto	= (hpsRecuperados/100) * (c.GetNivel().GetCusto() * PERCENTAGEM_CONSERTO);
					
					//trace( tempoAtual + " " + c.GetTempoConserto() + " " + c.GetTempoConstrucao() + " " + hpsRecuperados);
					if (GetDinheiroDisponivel() > dinheiroGasto)
					{
						var hps			    = c.GetPontosVida() + hpsRecuperados;					
						if (hps > 100) hps  = 100;
						var p			    = hps / 100;
						
						c.SetTempoConserto( tempoAtual );
						c.SetPontosVida( hps );
						grafico.sprites[0].progresso_mc.mask_mc.scaleX = p;
											
						// Desconta o custo.
						GastarDinheiro( dinheiroGasto );
						
						// Conserto chegou ao fim?
						if (p >= 1)
						{
							grafico.sprites[0].visible 	= false;
							c.SetStatus(  Construcao.STATUS_PRONTA );
							dispatchEvent(new EventoSimulador(EventoSimulador.FIM_CONSERTO 	, {construcao : c}));
						}
					}
					else c.SetTempoConserto( tempoAtual );
				}
			}
		}
		
		private function AtualizarVeiculos()
		{
			for (var i = 0; i < veiculos.length; i++)
			{
				var veiculo 	= veiculos[i];
				veiculo.pos.x  += veiculo.vetorVelocidade.x;
				veiculo.pos.y  += veiculo.vetorVelocidade.y;
				
				var proxPos 	= veiculo.pos; 
				var proxPonto 	= veiculo.rota[veiculo.indice+1];
				veiculo.sprite.moveTo( proxPos.x, proxPos.y, 0 );
				
				if (Point.distance(proxPos, proxPonto) < 0.5)
				{
					MoverParaProximoPonto( veiculo );
				}
			}
		}
		
		private function AtualizarEstrutura( construcao )
		{
			construcao.UpNivel();
			construcao.SetTempoCriacao( getTimer() );
			render.AtualizarConstrucao( construcao );
			construcao.SetStatus( Construcao.STATUS_CONSTRUINDO );	
		}
		
		/* Adições */
	
		public function AdicionarRepresentacaoEmissor( posicao : Point, movieclip : Class )  // para modo editor
		{
			var pos	= render.CelulaParaISO( new Point(posicao.x, posicao.y) );
			var spriteEmissor = render.CriarSprite( movieclip, pos.x, pos.y );
			render.AdicionarSprite( spriteEmissor, 2 );
			render.AtualizarCena(2);
		}
		
		public function AdicionarNovaEstrutura( construcao, compra = false, valor = 0, editor = false)
		{
			var ok = true;
			
			if(editor == true)
			{
				trace('->AdicionarNovaEstrutura modo editor')
				fase.AdicionarConstrucao( construcao );
				render.AdicionarConstrucao( construcao );
			}
			else
			{
				trace('->AdicionarNovaEstrutura modo normal')
				if ( compra )
				{
					var _desabitados = construcao.GetEstrutura().GetNivel(0).GetDesabitados();
					var _habitados = construcao.GetEstrutura().GetNivel(0).GetHabitados();
					
					if (valor <= GetDinheiroDisponivel() && 
						_desabitados <= this.GetPopulacao() &&
						_habitados <= this.GetHabitados())
					{
						GastarDinheiro( valor );
						GastarDesabitados (_desabitados);
						GastarHabitados (_habitados);
					}
					else {
						ok = false;	
					}
				}
				
				if (ok)
				{
					fase.AdicionarConstrucao( construcao );
					render.AdicionarConstrucao( construcao );
					
					if(compra) GanharXPs( valor );
				}
			}
			
			
			return ok;
		}
		
		public function AdicionarVeiculos()
		{
//			for ( var i = 0; i < 50; i++) AdicionarVeiculo();
		}
		
		private function AdicionarVeiculo()
		{
//			// Recupera os espaços da matriz que são pista.
//			var pistas 		= fase.GetPistas();
//			
//			// Adiciona um carro aleatório.
//			var carro 		= new carros[ Math.floor( Math.random() * carros.length ) ]();
//				
//			// Seleciona um ponto aleatório de origem.
//			var origem		= pistas[ Math.floor( Math.random() * pistas.length ) ];
//			carro.celulaX	= origem.x;
//			carro.celulaY	= origem.y;
//			
//			carro.dx 		= 0;
//			carro.dy 		= 0;
//			
//			// Define a rota do carro.
//			NovoMovimentoCarro( carro );
//			
//			// Se for possivel criar uma rota para o movimento do carro.
//			// (por algum motivo em alguns casos a rota estava vazia).
//			if ( carro.rota )
//			{				
//				var pos		 	 = render.CelulaParaISO( new Point(origem.x, origem.y) );
//				pos.x 		    += ( FaseRender.CELL_SIZE/2 );
//				pos.y 		    += ( FaseRender.CELL_SIZE/2 );
//				carro.pos		 = pos;
//				var carroS		 = render.CriarSprite( carro, pos.x, pos.y );
//				
//				carro.sprite	 = carroS;
//				carro.velocidade = 10;
//				
//				// Adiciona ao mapa isometrico.
//				render.AdicionarSprite( carroS, 1 );
//				
//				// Move o carro.
//				MoverParaProximoPonto( carro );
//				
//				veiculos.push( carro );
//			}
		}
		
		/* Movimentação dos veículos adicionados */
		
		private function NovoMovimentoCarro( carro : MovieClip )
		{
//			var pistas 	= fase.GetPistas();
//			 
//			var origem  = new Point( carro.celulaX, carro.celulaY );
//			var destino = new Point( carro.celulaX, carro.celulaY );
//			var rota	= [];
//			
//			while ( Point.distance(origem, destino) < 10 )
//				destino	= pistas[ Math.floor( Math.random() * pistas.length ) ];
//				
//			rota	= localizadorRotas.GetRota( origem, destino );
//			if (rota.length == 0) return;
//			
//			//Converte a rota de celulas para pixels.
//			for (var i = 0; i < rota.length; i++)
//			{
//				rota[i].x *=  FaseRender.CELL_SIZE;
//				rota[i].y *=  FaseRender.CELL_SIZE;
//				
//				rota[i].x += (FaseRender.CELL_SIZE/2);
//				rota[i].y += (FaseRender.CELL_SIZE/2);
//			}
//			
//			carro.indice		= -1;
//			carro.rota			= rota;
		}
		
		private function DeterminarVelocidade( carro )
		{
//			var v = new Point(0, 0);
//			if ( carro.indice < carro.rota.length-1 )
//			{
//				var atual 	= carro.rota[carro.indice];
//				var proximo	= carro.rota[carro.indice+1];
//				
//				var dx = proximo.x > atual.x ? 1 : -1;
//				var dy = proximo.y > atual.y ? 1 : -1;
//				v.x = dx * (Math.abs(atual.x - proximo.x) / 5);
//				v.y = dy * (Math.abs(atual.y - proximo.y) / 5);
//			}
//			
//			return v;
		}
		
		private function MoverParaProximoPonto( carro : MovieClip )
		{
//			carro.indice++;
//			if ( carro.indice+1 >= carro.rota.length ) 
//			{
//				carro.indice 	= 0;
//				var rota 		= carro.rota.reverse();
//				carro.rota		= rota;
//			}
//			
//			carro.vetorVelocidade	= DeterminarVelocidade( carro );
//			
//			carro.dx = 0;
//			carro.dy = 0;
//			if (carro.vetorVelocidade.x < 0) 
//			{
//				carro.dy = FaseRender.CELL_SIZE / 4;
//				carro.gotoAndStop(4);
//			}
//			else if (carro.vetorVelocidade.x > 0) 
//			{
//				carro.dy = -FaseRender.CELL_SIZE / 4;
//				carro.gotoAndStop(2);
//			}
//			else if (carro.vetorVelocidade.y > 0) 
//			{
//				carro.dx = FaseRender.CELL_SIZE / 4;
//				carro.gotoAndStop(1);
//			}
//			else 
//			{	
//				carro.dx = -FaseRender.CELL_SIZE / 4;
//				carro.gotoAndStop(3);
//			}
		}
		
		/* Conserto */
		
		public function ConsertarEstrutura( construcao )
		{
			construcao.SetTempoConserto(getTimer());
			construcao.SetStatus( Construcao.STATUS_CONSERTANDO );
			
			var grafico = construcao.GetGrafico();
			grafico.sprites[0].visible 	= true;
			
			dispatchEvent(new EventoSimulador(EventoSimulador.INICIO_CONSERTO 	, {construcao : construcao}));
		}
		
		/* Validações */
		
		public function ValidarAtualizacao( construcao, valor = 0 , proximoNivelConstrucao = null) : Boolean
		{
			var ok = true;

			if(Global.variables.modoEditor == false)
			{
				var _desabitados;
				var _habitados;
				
				if(proximoNivelConstrucao != null){
					_desabitados = proximoNivelConstrucao.GetDesabitados();
					_habitados = proximoNivelConstrucao.GetHabitados();
				}
				
				if (valor <= GetDinheiroDisponivel() &&
					_desabitados <= populacao &&
					_habitados <= habitados
				)
				{
					GastarDinheiro( valor );
					GastarDesabitados(_desabitados);
					GastarHabitados(_habitados);
					GanharXPs( valor );		
					AtualizarEstrutura(construcao);
				}
				else ok = false;
			}

			return ok;
		}
		
		public function ValidarDemolicao( construcao ) : Boolean
		{			
//			if ( construcao.GetEstrutura().GetCategoria() == Simulador.MORADIA &&
//				 GetIndice( Simulador.MORADIA ) < 0.9 )
//			{
//				return false;
//			}
			
			return true;
		}
		
		/* Remoção */
		
		public function RemoverEstrutura(grafico)
		{
			// excluir do vetor de construções da fase
			for(var i = 0; i < construcoes.length; i++)
			{
				if(construcoes[i].GetGrafico() == grafico) 
				{
					if(Global.variables.modoEditor == false)
					{
						if(construcoes[i].GetCategoria != 'Decorativa'){
							var dinheiro = construcoes[i].GetEstrutura().GetNivel(0).GetCusto();
							RetornarDinheiro(dinheiro / 2);
							RetornarPopulacao(construcoes[i]);
						}
					}

					fase.MarcarAreaConstrucao( construcoes[i], true );
					render.RemoverIsoSprite(construcoes[i].GetGrafico());
					construcoes.splice(i, 1);
					return;
				}
			}
		}
		
		public function RemoverEstruturaDoMapa(construcao)
		{
			fase.MarcarAreaConstrucao( construcao, true );
			render.RemoverIsoSprite(construcao.GetGrafico());
			
			for(var i = 0; i < construcoes.length; i++)
			{
				if(construcoes[i].GetGrafico() == construcao.GetGrafico()) 
				{
					construcoes.splice(i, 1);
					return;
				}
			}
		}
		
		public function RetornarPopulacao(construcao)
		{
			var _desabitados = construcao.GetEstrutura().GetNivel(0).GetDesabitados();
			var _habitados = construcao.GetEstrutura().GetNivel(0).GetHabitados();
			
			RetornarDesabitados(_desabitados);
			RetornarHabitados(_habitados);
			
		}
		
		/****
		*	Dispara o evento que exibe o menu de atualização de construção.
		****/
		public function AtualizarConstrucao(evt)
		{
			dispatchEvent(new EventoSimulador(EventoSimulador.ATUALIZAR_CONSTRUCAO, {grafico: evt.target.grafico}));
		}
				
		//----------------------------------------------------------------
		// Verificação do cumprimento dos objetivos das fases
		//----------------------------------------------------------------
		
		private function ContarMetasCompletas() : int
		{
			var objetivos 	= fase.GetObjetivos();
			var c 			= 0;
			for (var i = 0; i < objetivos.length; i++)
			{
				var o = objetivos[i];
				if (o.cumprida) c++;
			}			
			return c;
		}
		
		private function VerificarMetasConstrucoes()
		{
			var objetivos 	= fase.GetObjetivos();
			for (var i = 0; i < objetivos.length; i++)
			{
				var o = objetivos[i];
				
				if ( o.tipo == 'construir' )
				{
					var contador = fase.GetConstrucoesPorNivel2( o.construcao, o.nivel );
					if(contador >= objetivos[i].qtd)
					{
						dispatchEvent(new EventoSimulador(EventoSimulador.FIM_META, {indice:i, meta: objetivos[i]}));
						o.cumprida = true;
					}
					else 
					{
						o.cumprida = false;
						dispatchEvent(new EventoSimulador(EventoSimulador.ATUALIZAR_META, {indice: i, meta: objetivos[i], valor: (objetivos[i].qtd - contador)}));
					}
				}
			}
		}
		
		private function VerificarMetasIndices()
		{
			var objetos 	= fase.GetObjetivos();
			for (var i = 0; i < objetos.length; i++)
			{
				var o = objetos[i];
				
				if ( o.tipo == 'indice' )
				{
					var indice = indices[o.indice] * 100;
					if (indice >= int(o.valor)) 
					{
						o.cumprida = true;
						dispatchEvent(new EventoSimulador(EventoSimulador.FIM_META, {indice: i, meta: objetos[i]}));
					}
					else 
					{
						o.cumprida = false;
						dispatchEvent(new EventoSimulador(EventoSimulador.ATUALIZAR_META, {indice: i, meta: objetos[i]}));
					}
				}
			}			
		}
		
		//-----------------------------------
		// Gets e Sets
		//-----------------------------------
		
		public function GetPopulacaoTotal() : int
		{
			return populacao + habitados + empregados;
		}
		
		public function GetIndice( nome ) : Number
		{
			return indices[nome];
		}
		
		public function GetNivelAtualJogador() : int
		{
			return nivel;
		}
		
		public function GetConstrucaoByName( nomeEst )
		{
			for(var i = 0; i < construcoes.length; i++)
			{
				if(construcoes[i].GetEstrutura().GetNome() == nomeEst) return construcoes[i];
			}
			return null;
		}
		
		public function GetConstrucoesPeloNome( nome ) : Array
		{
			var r = new Array();
			for(var i = 0; i < construcoes.length; i++)
			{
				if(construcoes[i].GetEstrutura().GetNome() == nome) r.push( construcoes[i] );
			}
			return r;
		}
		
		public function GetEmissores() : Array
		{
			return emissores;
		}
		
		public function GetTamanhoFase() : Point
		{
			return fase.GetTamanho();
		}
		
		public function GetMatrizFase() : Array
		{
			return fase.GetMatriz();
		}
		
		public function GetFase() : Fase
		{
			return fase;
		}
		
		public function GetDesempenho() : Number
		{
			return desempenho;
		}
		
		public function GetIndiceMoradia() : Number
		{
			return indices[Simulador.MORADIA];
		}
		
		public function GetIndiceEducacao() : Number
		{
			return indices[Simulador.EDUCACAO];
		}
		
		public function GetIndiceSeguranca() : Number
		{
			return indices[Simulador.SEGURANCA];
		}
		
		public function GetIndiceComercio() : Number
		{
			return indices[Simulador.COMERCIO];
		}
		
		public function GetDinheiro() : int
		{
			return dinheiro;
		}
		
		public function GetDinheiroEmprestimo() : int
		{
			return dinheiroEmprestimo;
		}
		
		public function GetDinheiroDisponivel() :int
		{
			return dinheiro + dinheiroEmprestimo;
		}
		
		public function GetPopulacao() :int
		{
			return populacao;
		}
		
		public function GetHabitados() :int
		{
			return habitados;
		}
		
		public function GetEmpregados() :int
		{
			return empregados;
		}
		
		public function GetQuantidadeTurnos()
		{
			return (fase.GetTempoConclusao() / TEMPO_TURNO) ;
		}
		
		public function GetTempoTotalFase() : int
		{
			return tempoTotalFase;
		}
		
		public function GetTurnoAtual() : int
		{
			return turnoAtual;
		}
		
		public function GetConstrucaoPeloGrafico( grafico )
		{
			for(var i = 0; i < construcoes.length; i++)
			{
				if(construcoes[i].GetGrafico() == grafico)
				{
					return construcoes[i];
				}
			}		
		}

		public function setTempoInicialBoss(n:Number){
			trace('#inicial: '+n);
			this.tempoInicialBoss = n;
		}

		public function setTempoFinalBoss(n:Number){
			trace('#final: '+n);
			this.tempoFinalBoss = n;
		}

		public function getTempoTotalBoss():Number{
			this.tempoTotalBoss = this.tempoFinalBoss - this.tempoInicialBoss;
			trace('#total: '+this.tempoTotalBoss);

			return this.tempoTotalBoss;
		}
		
		//-----------------------------------------
		// Eventos de clima e trânsito
		//-----------------------------------------
		
		var estadoClima = '';
		private function AtualizarClima()
		{
			var rand = Math.floor(Math.random() * 100)+1;
			
			if (estadoClima == 'chuva')
			{
				if (rand < 60) 
				{
					estadoClima = '';
					dispatchEvent(new EventoSimulador(EventoSimulador.SOL, {})); //Sol();
				}
			}
			else if (estadoClima == '')
			{
				//if (rand < 40)
				if (rand < 10)
				{
					estadoClima = 'chuva';
					dispatchEvent(new EventoSimulador(EventoSimulador.CHUVA, {})); //Chuva();
				}
			}
			
		}
		
		private function ReproduzirTransito()
		{
//			var rand = Math.floor(Math.random() * 100)+1;
//			if( rand < 15 ) dispatchEvent(new EventoSimulador(EventoSimulador.TRANSITO, {}));
		}
		
		//---------------------------------------------------
		
		var FATOR_XPS = 100;
		
		/***
		*	Calcula a quantidade inicial de XPs que o jogador
		*	tem em um dado nível.
		*
		*	Na atual metodologia:
		*		Nivel 1: 0xps
		*		Nivel 2: 100 xps (+ 100 xps)
		*		Nivel 3: 300 xps (+ 200 xps)
		*		Nivel 4: 700 xps (+ 400 xps)
		*		Nivel 5: 1500 xps (+ 800 xps)		
		*
		*	Ou seja, uma PG, de elemento inicial 100 (contamos a partir do nivel 2) e razão 2.
		*		
		****/
		private function CalcularXPsNivel( nivelAtual: int )
		{			
			if (nivelAtual == 1) return 0;
			else  return CalcularXPsNivel( nivelAtual-1 ) + FATOR_XPS * Math.pow(2, nivelAtual-2);
		}
	
		/****
		*	Computa o ganho de XPs pelo jogador, verificando e disparando a passagem de nível.
		*
		******/
		private function GanharXPs( valor )
		{
			if (nivel < fase.GetNivelMax())
			{
				xpsAcumulados += Math.ceil( dataLoader.XpsPorReal( nivel ) * valor );
				if (xpsAcumulados >= xpsNecessarios)
				{
					xpsAcumulados   = 0;
					nivel++;
					xpsNecessarios	= dataLoader.XpsParaProximoNivel(nivel);
								
					dispatchEvent( new EventoSimulador(EventoSimulador.ATUALIZAR_NIVEL_JOGADOR, {nivel: nivel}) );
				}
				
				var p = xpsAcumulados / xpsNecessarios;
				trace("s - XP: "+valor);
				dispatchEvent( new EventoSimulador(EventoSimulador.ATUALIZAR_XP, {perc: p, pontos: valor}) );
			}
		}
	
		/***
		*	Calcula a quantidade de XPs ganhos (baseado no multiplicador de desempenho)
		*	dado um valor base de xps que uma ação gerou.
		****
		public function CalcularXPsMultiplicador( xps )
		{
			return xps;
		}*/
		
		/****
		*	Calcula a quantidade de XPs que o jogador necessita
		*	para avançar para o próximo nível.
		*****
		public function CalcularXPsProximoNivel( nivelAtual: int )
		{
			return CalcularXPsNivel(nivelAtual+1) - CalcularXPsNivel(nivelAtual);
		}*/
		
		/*********************** Tutorial *************************/
		
		public function SetVariavel( variavel	 : String,
								     valor		 : String )
		{
			variaveis[variavel]	= valor;
		}
		
		public function GetVariavel( variavel	: String )
		{
			if (variaveis[variavel] == null)
			{
				SetVariavel(variavel, "1");
				return "1";
			}
			return variaveis[variavel];
		}
		
		private function SimularApenasMensagens()
		{
			AtualizarMensagens();
		}
		
		public function DispacharEventoIndice()
		{
			dispatchEvent(new EventoSimulador(EventoSimulador.INDICE, {indice: Simulador.EDUCACAO	, valor: indices[Simulador.EDUCACAO]}));
			dispatchEvent(new EventoSimulador(EventoSimulador.INDICE, {indice: Simulador.MORADIA	, valor: indices[Simulador.MORADIA]}));
			dispatchEvent(new EventoSimulador(EventoSimulador.INDICE, {indice: Simulador.SEGURANCA	, valor: indices[Simulador.SEGURANCA]}));
			
			dispatchEvent(new EventoSimulador(EventoSimulador.INDICE, {indice: Simulador.COMERCIO	, valor: indices[Simulador.COMERCIO]}));
			dispatchEvent(new EventoSimulador(EventoSimulador.INDICE, {indice: Simulador.SAUDE	, valor: indices[Simulador.SAUDE]}));
			dispatchEvent(new EventoSimulador(EventoSimulador.INDICE, {indice: Simulador.INFRA	, valor: indices[Simulador.INFRA]}));
		}
	}
}