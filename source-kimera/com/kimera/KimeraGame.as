package com.kimera
{	
	import as3isolib.display.primitive.IsoRectangle;
	import as3isolib.graphics.SolidColorFill;
	
	import com.kengine.Engine;
	import com.kengine.Screen;
	import com.kengine.ScreenCinematic;
	import com.kengine.util.ScreenLoader;

	import com.kimera.externo.voo.SensorRemoto;
	
	import core.FaseRender;
	import core.Simulador;
	import core.eventos.EventoSimulador;
	import core.util.MovieClipUtil;
	import core.util.Cronometro;
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.utils.setTimeout;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	public class KimeraGame extends Engine
	{
		static private var _instance : KimeraGame;
		
		public var sensorRemoto : SensorRemoto = new SensorRemoto();
		public var cronometro : Cronometro = new Cronometro();
		
		public function KimeraGame(__game : Game)
		{
			super(__game);
			
			_game = __game;
			_instance = this;
		}
		
		static public function getInstance() : KimeraGame
		{
			if(_instance) return _instance;
			_instance = new KimeraGame(Game.getInstance());
			return _instance;
		}
		
		/**
		 * Chamada ao iniciar o motor
		 */
		override public function inicioMotor() : void
		{
			_game.MostrarTelaPreta(true);
			var abertura = new ScreenLoader("data/cinematicas/cinematic00.swf", endAbertura);
			//var abertura = new ScreenLoader("data/cinematicas/cinematic_teste.swf", endAbertura);
			_game.stageObj.addChild(abertura);
		}

		protected function endAbertura(){
			_game.MostrarTelaPreta(false);
			_game.gestorSom.Reproduzir('musica-menu-principal', 99999);
		}

		public function iniciarJogo(evt) : void
		{
			_game.PrepComecarJogo();
			
			// DEBUG TODO
			//novoJogo();
			//return;
			// FIM DEBUG TODO
			
			_game.MostrarTelaPreta(true);

			var abertura = new ScreenLoader("data/cinematicas/cinematic01.swf", iniciarMiniGameBussola);
			//var abertura = new ScreenLoader("data/cinematicas/cinematic_teste.swf", iniciarMiniGameBussola);
			_game.stageObj.addChild(abertura);
		}

		public function iniciarMiniGameBussola() : void 
		{
			cronometro.Iniciar(0);

			_game.MostrarTelaPreta(false);
			var minigame = new ScreenLoader("data/minigames/minigame_00.swf", iniciarCineMundoKimera);
			_game.stageObj.addChild(minigame);
		}
		
		public function iniciarCineMundoKimera() : void
		{
			//ludens
			//if(Global.variables.ludens == true){
				//_game.EmitirRelatorio('TCMG01', String(cronometro.GetTempoPassado()));
			//}

			_game.MostrarTelaPreta(true);
			var abertura = new ScreenLoader("data/cinematicas/cinematic02.swf", novoJogo);
			//var abertura = new ScreenLoader("data/cinematicas/cinematic_teste.swf", novoJogo);
			_game.stageObj.addChild(abertura);
		}
		
		public function novoJogo() : void
		{
			_game.MostrarTelaPreta(false);
			_game.NovoJogo(null);
		}

		public function reiniciarVariaveis() : void
		{
			this.jequitibaConstruido = false;
			this.usina 				 = false;
			this.universidade		 = false;
			this.bombeiros 			 = false;
			this.delegacia			 = false;
			this.postoSaude			 = false;
			this.hospital			 = false;
			this.cicloParque		 = false;
			this.estacaoTratamento 	 = false;
			this.industriaReciclagem = false;
			this.usinaEolica		 = false;

			trace('reiniciada ' + jequitibaConstruido);
		}
		
		/******************************
		 * Tratamento do fluxo do jogo
		 ******************************/
		
		/**
		 * Verifica condições ao construir nova edificação
		 */
		override public function verificaCondicoesConstrucao( nomeEstrutura : String ) : void
		{	
			// FASE 1
			if(_game.simulador.GetFase().GetNumero() == 1){
				
				// Verifica se jequitiba foi construido no local correto
				if(jequitibaConstruido == false){
					this.f1VerificaConstrucaoJequitiba();
					return;
				}
				
				// Empregou 100 pessoas com sucesso
				if(_game.simulador.GetVariavel("Fase1") == "2" && _game.simulador.GetEmpregados() >= 100){
					_game.simulador.SetVariavel("Fase1", "3");
					
					return;
				}
				
				// Verifica se foi contstruida a universidade e termoeletrica
				if(_game.simulador.GetVariavel("Fase1") == "5"){
					if(nomeEstrutura == "Universidade"){
						universidade = true;
					}
					
					if(nomeEstrutura == "Termoelétrica") {
						usina = true;
					}
					
					if(universidade && usina){
						_game.simulador.SetVariavel("Fase1", "6");
						
						return;
					}
				}
				
				if(_game.simulador.GetVariavel("Fase1") == "7"){
					this.f1VerificaConstrucaoGuardioes();
				} 
			}

			//FASE 2
			if(_game.simulador.GetFase().GetNumero() == 2){

				if(_game.simulador.GetVariavel("Fase2") == "1" && _game.simulador.GetEmpregados() >= 2000){
					_game.simulador.SetVariavel("Fase2", "2");
					
					return;
				}

				if(_game.simulador.GetVariavel("Fase2") == "2"){
					if(nomeEstrutura == "Bombeiros"){
						this.bombeiros = true;
					}
					
					if(this.bombeiros){
						_game.MostrarAlertaDesastre(2);
						_game.RemoverFiltros(3);
						
						_game.simulador.SetVariavel("Fase2", "3");
						
						return;
					}					
				}

				if(_game.simulador.GetVariavel("Fase2") == "3"){
					if(nomeEstrutura == "Delegacia"){
						this.delegacia = true;
					}
					
					if(this.delegacia){
						_game.MostrarAlertaDesastre(2);
						_game.RemoverFiltros(3);
						
						_game.simulador.SetVariavel("Fase2", "4");
						
						return;
					}
				}

				if(_game.simulador.GetVariavel("Fase2") == "4"){
					if(nomeEstrutura == "Posto de Saúde"){
						this.postoSaude = true;
					}
					
					if(nomeEstrutura == "Hospital") {
						this.hospital = true;
					}
					
					if(this.postoSaude && this.hospital){
						_game.MostrarAlertaDesastre(2);
						_game.RemoverFiltros(3);

						_game.simulador.SetVariavel("Fase2", "5");
						
						return;
					}	
				}

				if(_game.simulador.GetVariavel("Fase2") == "7"){
					if(nomeEstrutura == "Ciclo Parque"){
						this.cicloParque = true;
					}
					
					if(this.cicloParque){
						_game.MostrarAlertaDesastre(2);
						_game.RemoverFiltros(3);
						
						_game.simulador.SetVariavel("Fase2", "8");
						
						return;
					}
				}

				if(_game.simulador.GetVariavel("Fase2") == "10"){
					if(nomeEstrutura == "Estação de Tratamento de Água")
					{
						this.estacaoTratamento = true;
					}
					
					if(this.estacaoTratamento){
						_game.simulador.SetVariavel("Fase2", "11");
						
						return;
					}	
				}
			}

			//FASE 3
			if(_game.simulador.GetFase().GetNumero() == 3){

				if(_game.simulador.GetVariavel("Fase3") == "1"){
					if(nomeEstrutura == "Indústria de Reciclagem de Lixo"){
						this.industriaReciclagem = true;
					}
					
					if(this.industriaReciclagem){
						_game.simulador.SetVariavel("Fase3", "2");
						
						return;
					}
				}

				if(_game.simulador.GetVariavel("Fase3") == "4"){
					if(nomeEstrutura == "Usina Eólica")
					{
						this.usinaEolica = true;
					}
					
					if(this.usinaEolica){
						_game.simulador.SetVariavel("Fase3", "5");
						
						return;
					}					
				}
			}
		}
		
		/**
		 * Verifica condições ao inicio de uma nova fase
		 */
		override public function verificarNovaFase( numeroFase : Number ) : void
		{
			// FASE 1
			if(numeroFase == 1){
				_game.bussola_mc.desmarcarPedras();

				_game.simulador.SetVariavel("Fase1", "1");
				_game.simulador.SetVariavel("Lido", "0");
				_game.ListenersInterface(false);
				
				return;
			}

			// FASE 2
			if(numeroFase == 2){
				_game.bussola_mc.desmarcarPedras();
				_game.MarcarPedraMagica(1);		

				_game.simulador.SetVariavel("Fase2", "1");
				_game.simulador.SetVariavel("Lido", "0");
				_game.ListenersInterface(false);
				
				return;
			}

			// FASE 3
			if(numeroFase == 3){
				_game.bussola_mc.desmarcarPedras();
				_game.MarcarPedraMagica(1);
				_game.MarcarPedraMagica(2);	

				_game.simulador.SetVariavel("Fase3", "1");
				_game.simulador.SetVariavel("Lido", "0");
				_game.ListenersInterface(false);
				
				return;
			}

			//kamplus
			if(Global.variables.modoEditor == true)
			{
				//sensorRemoto.adicionaSensorConstrucao();
				//_game.AtualizarFiltros();

				return
			}
		}
		
		/**
		 * Verifica condições ao receber nova mensagem (A mensagem deve chamar essa funcao)
		 */
		override public function verificarNovaMensagem() : void
		{
			
		}
		
		/**
		 * Verifica condições ao fechar tela de mensagem
		 */
		override public function verificarFechamentoMensagem() : void
		{
			// FASE 1
			if(_game.simulador.GetFase().GetNumero() == 1){
				// Começa a construir jequitiba
				if(_game.simulador.GetVariavel("Fase1") == "1" && _game.simulador.GetVariavel("Lido") == "0"){
					
					f1PlantarSemente();
					_game.bloquearInterface();

					return;
				}
				
				// Mostra driade
				if(_game.simulador.GetVariavel("Fase1") == "3"){
					_game.MostrarInvasaoDriadeDoMal(1);
					sensorRemoto.adicionaRandonSensorTerreno();
					_game.AtualizarFiltros();
					_game.gestorSom.Reproduzir('driade', 1);
					_game.simulador.SetVariavel("Fase1", "4");

					_game.simulador.setTempoInicialBoss(Number(_game.simulador.GetTempoTotalFase()));
					
					return;
				}
				
				// Mostra jequitiba pedindo pra derrotar driade
				if(_game.simulador.GetVariavel("Fase1") == "4"){
					_game.simulador.SetVariavel("Fase1", "5");
					
					//mal ataca
					sensorRemoto.adicionaSensorTerreno();
					_game.AtualizarFiltros();
					
					return;
				}
				
				// Avisa que ja pode ser construido a casa dos guardioes
				if(_game.simulador.GetVariavel("Fase1") == "6"){
					_game.simulador.SetVariavel("Fase1", "7");

					return;
				}

				// Começa a construir casa guardioes
				if(_game.simulador.GetVariavel("Fase1") == "7" && _game.simulador.GetVariavel("Lido") == "0"){
					_game.simulador.SetVariavel("Lido", "1");
					
					f1ConstruirCasaDosGuardioes();
					_game.bloquearInterface();
					
					return;
				}

				if(_game.simulador.GetVariavel("Fase1") == "8"){
					_game.destacarDecorativa('guardioes');
				}

				// derotou
				if(_game.simulador.GetVariavel("Fase1") == "9"){
					_game.simulador.SetVariavel("Fase1", "10");
					
					return;
				}	
				
				// Pega pedra mágica
				if(_game.simulador.GetVariavel("Fase1") == "10"){
					_game.MostrarPedraMagica(1);
					
					return;
				}
				
				// Escrever mensagem
				if(_game.simulador.GetVariavel("Fase1") == "11"){
					_game.MostrarCarta(null, "cartaFase1", true);
					
					return;
				}
			}

			// FASE 2
			if(_game.simulador.GetFase().GetNumero() == 2){
				// Mostra problemas incendios
				if(_game.simulador.GetVariavel("Fase2") == "2"){
					//animar sirene na interface
					_game.MostrarAlertaDesastre(1);
					_game.gestorSom.Reproduzir('sirene', 1);
					
					//inicia desastre
					_game.GerarDesastre('Incêndios', 'Construa um Corpo de Bombeiros e ajude a combater as chamas que estão incendiando a cidade.', 'Incendio', 'Moradia');

					return;
				}

				// Mostra problemas violencia
				if(_game.simulador.GetVariavel("Fase2") == "3"){
					//animar sirene na interface
					_game.MostrarAlertaDesastre(1);
					_game.gestorSom.Reproduzir('sirene', 1);
					
					//inicia desastre
					_game.GerarDesastre('Violência', 'Construa uma delegacia e ajude a combater os bandidos e manter a cidade segura.', 'Assalto', 'Comércio');

					return;
				}

				// Mostra problemas saude
				if(_game.simulador.GetVariavel("Fase2") == "4"){
					//animar sirene na interface
					_game.MostrarAlertaDesastre(1);
					_game.gestorSom.Reproduzir('sirene', 1);
					
					//inicia desastre
					_game.GerarDesastre('Saúde', 'Crie um hospital e um posto de saúde e ajude a combater a dengue.', 'Saude', 'Moradia');

					return;
				}

				// Mostra problemas transporte
				if(_game.simulador.GetVariavel("Fase2") == "5"){
					//animar sirene na interface
					_game.simulador.SetVariavel("Fase2", "6");
					
					return;
				}

				if(_game.simulador.GetVariavel("Fase2") == "6"){
					_game.MostrarAlertaDesastre(1);
					_game.gestorSom.Reproduzir('sirene', 1);

					_game.simulador.SetVariavel("Fase2", "7");
					
					return;
				}

				if(_game.simulador.GetVariavel("Fase2") == "7"){
					//buracos na estrada
					sensorRemoto.adicionaSensorConstrucao();
					_game.gestorSom.Reproduzir('buzina-carros', 1);
					_game.AtualizarFiltros();

					return;
				}

				// Mostra Cetus
				if(_game.simulador.GetVariavel("Fase2") == "8"){
					//animar agua na interface
					sensorRemoto.adicionaRandonSensorAgua();
					_game.gestorSom.Reproduzir('cetus', 1);
					_game.AtualizarFiltros();
					_game.simulador.SetVariavel("Fase2", "9");

					_game.simulador.setTempoInicialBoss(Number(_game.simulador.GetTempoTotalFase()));
					
					return;
				}
				
				// Mostra jequitiba pedindo pra derrotar cetus
				if(_game.simulador.GetVariavel("Fase2") == "9"){
					//cetus  comeca a destruir
					var timer:Timer = new Timer(1000, 4);
				    
				    timer.addEventListener(TimerEvent.TIMER, function(){  
				    		_game.GerarDano("Moradia" , "Inundacao");
				    	});
				    timer.start();

					_game.simulador.SetVariavel("Fase2", "10");
					
					return;
				}

				if(_game.simulador.GetVariavel("Fase2") == "11"){
					_game.simulador.SetVariavel("Fase2", "12");
					
					return;
				}

				if(_game.simulador.GetVariavel("Fase2") == "12"){
					_game.destacarDecorativa('guardioes');
				}

				// Pega pedra mágica
				if(_game.simulador.GetVariavel("Fase2") == "13"){
					_game.MostrarPedraMagica(2);
					
					return;
				}
				
				// Escrever mensagem
				if(_game.simulador.GetVariavel("Fase2") == "14"){
					_game.MostrarCarta(null, "cartaFase2", true);
					
					return;
				}
			}

			// FASE 3
			if(_game.simulador.GetFase().GetNumero() == 3){

				// Mostra problemas com lixo
				if(_game.simulador.GetVariavel("Fase3") == "2"){
										
					//inicia desastre
					_game.GerarDesastre('Sujeira', 'Clique na Indústria de Reciclagem e ajude a fazer o tratamento correto do lixo.', 'Sujeira', 'Moradia');

					cronometro.Iniciar(0);

					return;
				}

				// Mostra KAOS
				if(_game.simulador.GetVariavel("Fase3") == "3"){
					//aparece sprite kaos
					sensorRemoto.adicionaRandonSensorVegetacao();
					_game.gestorSom.Reproduzir('kaos', 1);
					_game.AtualizarFiltros();
					_game.simulador.SetVariavel("Fase3", "4");

					_game.simulador.setTempoInicialBoss(Number(_game.simulador.GetTempoTotalFase()));
					
					return;
				}
				
				// Mostra jequitiba pedindo pra derrotar kaos
				if(_game.simulador.GetVariavel("Fase3") == "4"){
					//Kaos comeca a destruir
					var timer:Timer = new Timer(1000, 4);
				    
				    timer.addEventListener(TimerEvent.TIMER, function(){  
				    		_game.GerarDano("Moradia" , "Incendio");
				    	});
				    timer.start();
					
					return;
				}

				if(_game.simulador.GetVariavel("Fase3") == "5"){
					_game.simulador.SetVariavel("Fase3", "6");

					return;
				}

				if(_game.simulador.GetVariavel("Fase3") == "6"){
					_game.destacarDecorativa('guardioes');
				}

				if(_game.simulador.GetVariavel("Fase3") == "7"){
					_game.simulador.SetVariavel("Fase3", "8");

					return;
				}

				// Mostra pedra mágica
				if(_game.simulador.GetVariavel("Fase3") == "8"){
					_game.MostrarPedraMagica(3);
					
					return;
				}
			}
		}
		
		/**
		 * Verifica alguma condição do jogo
		 */
		override public function verificaFluxoDeJogo( chave : String ) : void
		{
			// FASE 1
			if(_game.simulador.GetFase().GetNumero() == 1){
				if(chave == "invocarTilion"){
					if(_game.simulador.GetVariavel("Fase1") == "8"){

						_game.MostrarTelaPreta(true);

						_game.PausarSons();
						_game.PausarMusica();

						var abertura = new ScreenLoader("data/cinematicas/cinematic03.swf", f1FimCutscene1);
						_game.stageObj.addChild(abertura);
						
						//destruir driade					
						_game.MostrarInvasaoDriadeDoMal(2);
						_game.RemoverFiltros(3);

						//eludens
						_game.simulador.setTempoFinalBoss(Number(_game.simulador.GetTempoTotalFase()));
						
						//if(Global.variables.ludens == true){
							//_game.EmitirRelatorio('TDL01', String(_game.simulador.getTempoTotalBoss()));
						//}
					}

					return;
				}
				
				if(chave == "adicionarPedra"){
					_game.simulador.SetVariavel("Fase1", "11");
					
					return;
				}
				
				if(chave == "CartaFechada" && _game.simulador.GetVariavel("Fase1") == "11"){
					_game.simulador.SetVariavel("Fase1", "12");
					_game.SalvarConstrucaoArquivo(1);

					//envia dados ludens
					//if(Global.variables.ludens == true){
						//_game.EmitirRelatorio('TCF01', String(_game.simulador.GetTempoTotalFase()));
					//}
					
					_game.FimFase();

					return;
				}
			}

			// FASE 2
			if(_game.simulador.GetFase().GetNumero() == 2){
				if(chave == "invocarDoren"){
					if(_game.simulador.GetVariavel("Fase2") == "12"){

						_game.MostrarTelaPreta(true);

						_game.PausarSons();
						_game.PausarMusica();

						var abertura = new ScreenLoader("data/cinematicas/cinematic04.swf", f2FimCutscene1);
						_game.stageObj.addChild(abertura);
						
						//destruir cetus
						_game.RemoverFiltros(3);

						//ludens
						_game.simulador.setTempoFinalBoss(Number(_game.simulador.GetTempoTotalFase()));
						
						//if(Global.variables.ludens == true){
							//_game.EmitirRelatorio('TDL02', String(_game.simulador.getTempoTotalBoss()));
						//}
					}

					return;
				}

				if(chave == "adicionarPedra"){
					_game.simulador.SetVariavel("Fase2", "14");
					
					return;
				}

				if(chave == "CartaFechada" && _game.simulador.GetVariavel("Fase2") == "14"){
					_game.simulador.SetVariavel("Fase2", "15");
					_game.SalvarConstrucaoArquivo(2);
					
					//envia dados ludens
					//if(Global.variables.ludens == true){
					//	_game.EmitirRelatorio('TCF02', String(_game.simulador.GetTempoTotalFase()));
					//}

					_game.FimFase();
					
					return;
				}
			}

			// FASE 3
			if(_game.simulador.GetFase().GetNumero() == 3){
				if(chave == "limparSujeira"){
					if(_game.simulador.GetVariavel("Fase3") == "2"){
						_game.RemoverFiltros(3);

						//ludens
						//if(Global.variables.ludens == true){
						//	_game.EmitirRelatorio('TCMG01', String(cronometro.GetTempoPassado()));
						//}

						_game.simulador.SetVariavel("Fase3", "3");	
					}

					return;
				}

				if(chave == "invocarKimera"){
					if(_game.simulador.GetVariavel("Fase3") == "6"){

						_game.MostrarTelaPreta(true);

						_game.PausarSons();
						_game.PausarMusica();

						var abertura = new ScreenLoader("data/cinematicas/cinematic05.swf", f3FimCutscene2);
						_game.stageObj.addChild(abertura);
						
						//destruir kaos
						_game.RemoverFiltros(3);

						//ludens
						_game.simulador.setTempoFinalBoss(Number(_game.simulador.getTempoTotalBoss()));

						//if(Global.variables.ludens == true){
						//	_game.EmitirRelatorio('TDL03', String(_game.simulador.getTempoTotalBoss()));
						//}
					}

					return;
				}

				if(chave == "adicionarPedra"){

					_game.MostrarTelaPreta(true);

					_game.PausarSons();
					_game.PausarMusica();

					var abertura = new ScreenLoader("data/cinematicas/cinematic06.swf", f3FimCutscene3);
					_game.stageObj.addChild(abertura);
					
					return;
				}
			}
		}
		
		/******************************
		 * Fase 1 
		 ******************************/
		
		var sementeSeletor1 : IsoRectangle;
		var sementeSeletor2 : IsoRectangle;
		var sementeSeletor3 : IsoRectangle;
		var sementeSeletor4 : IsoRectangle;

		var jequitibaConstruido : Boolean = false;
		var usina 				: Boolean = false;
		var universidade		: Boolean = false;
		
		var posicaoNorte : Point;

		public function f1PlantarSemente() : void
		{	
			_game.ListenersInterface(false);
			posicaoNorte = new Point(74, 62);
			
			// Castelo - 82x70
			// Cria marcação norte / sull / leste / oeste
			sementeSeletor1 = f1CriarSeletor(posicaoNorte.x, posicaoNorte.y);
			sementeSeletor2 = f1CriarSeletor(90, 78);
			sementeSeletor3 = f1CriarSeletor(88, 64);
			sementeSeletor4 = f1CriarSeletor(76, 76);
			
			f1ConstruirJequitiba();
		}
		
		protected function f1ConstruirJequitiba() : void
		{
			// Começa a construir arvore
			_game.setIndice("decorativas");
			
			var icone = new MovieClip();
			icone.nomeEstrutura		= "Jequitibá-Rei";
			
			_game.AcoplarEstruturaSeletor({target: icone});
		}
		
		protected function f1ConstruirCasaDosGuardioes() : void
		{
			_game.ListenersInterface(false);
			
			_game.setIndice("decorativas");
			
			var icone = new MovieClip();
			icone.nomeEstrutura		= "Casa dos Guardiões";
			
			_game.AcoplarEstruturaSeletor({target: icone});
		}
		
		protected function f1RemoverJequitiba() : void
		{
			var construcao = _game.simulador.GetConstrucaoByName("Jequitibá-Rei");
			_game.simulador.RemoverEstruturaDoMapa(construcao);
		}
		
		protected function f1LimparSeletores() : void
		{
			sementeSeletor1.container.visible = false;
			sementeSeletor2.container.visible = false;
			sementeSeletor3.container.visible = false;
			sementeSeletor4.container.visible = false;
			
			_game.setIndice("Moradia");
		}
		
		protected function f1CriarSeletor(x : Number, y : Number) : IsoRectangle
		{
			var sementeSeletor1 = new IsoRectangle(); 
			sementeSeletor1.setSize(FaseRender.CELL_SIZE, FaseRender.CELL_SIZE, 0); 
			var bf : SolidColorFill = new SolidColorFill(200, 0.5);
			sementeSeletor1.fills 					= [bf];
			
			_game.render.AdicionarNoGrid(sementeSeletor1);
			sementeSeletor1.container.mouseEnabled 	= false;
			sementeSeletor1.container.mouseChildren = false;				
			var tamanhoSeletor : Point = new Point(4,4);
			sementeSeletor1.setSize(tamanhoSeletor.x * FaseRender.CELL_SIZE, tamanhoSeletor.y * FaseRender.CELL_SIZE, 0);
			sementeSeletor1.moveTo( x * FaseRender.CELL_SIZE,
				y * FaseRender.CELL_SIZE, 0 );
			sementeSeletor1.container.visible = true;
			
			return sementeSeletor1;
		}
		
		protected function f1VerificaConstrucaoJequitiba() : void
		{
			var construcoes = _game.simulador.GetFase().GetConstrucoesPorCategoria('Decorativa');
			var pos = new Point( Math.floor(sementeSeletor1.x/FaseRender.CELL_SIZE), Math.floor(sementeSeletor1.y/FaseRender.CELL_SIZE) );
			
			for (var i = 0; i < construcoes.length; i++)
			{
				if (construcoes[i].GetEstrutura().GetNome() == "Jequitibá-Rei"){
					if(construcoes[i].GetPosicao().x == posicaoNorte.x &&
						construcoes[i].GetPosicao().y == posicaoNorte.y){
						
						jequitibaConstruido = true;
						
						this.f1LimparSeletores();
						
						_game.ListenersInterface(true);
						_game.liberarInterface();
						
						_game.simulador.SetVariavel("Fase1", "2");
					} else {
						this.f1LimparSeletores();
						this.f1RemoverJequitiba();
						
						var m = _game.dataLoader.GetMensagemByTitulo('Semente na posição errada');
						_game.simulador.dispatchEvent( 
							new EventoSimulador(EventoSimulador.MENSAGEM, 
								{titulo: m.titulo, 
								texto: m.texto,
								funcao: "",
								personagem: m.personagem,
								icone: m.icone}
							)
						);

						//envia relatorio
						//if(Global.variables.ludens == true){
						//	_game.EmitirRelatorio('QTJR', '1');
						//}
					}
				}
			}
		}
		
		protected function f1VerificaConstrucaoGuardioes() : void 
		{
			var construcoes = _game.simulador.GetFase().GetConstrucoesPorCategoria('Decorativa');

			for (var i = 0; i < construcoes.length; i++)
			{
				if (construcoes[i].GetEstrutura().GetNome() == "Casa dos Guardiões"){
					_game.ListenersInterface(true);
					_game.setIndice("Moradia");
					_game.simulador.SetVariavel("Fase1", "8");

					_game.liberarInterface();
				}
			}
		}
		
		protected function f1FimCutscene1() : void
		{
			_game.MostrarTelaPreta(false);
			
			_game.ContinuarSons();
			_game.ContinuarMusica();
			
			_game.simulador.SetVariavel("Fase1", "9");
			_game.ListenersInterface(false);
		}

		/******************************
		 * Fase 2 
		 ******************************/
		var bombeiros			: Boolean = false;
		var delegacia			: Boolean = false;
		var postoSaude			: Boolean = false;
		var hospital			: Boolean = false;
		var cicloParque			: Boolean = false;
		var estacaoTratamento 	: Boolean = false;

		protected function f2FimCutscene1() : void
		{
			_game.MostrarTelaPreta(false);

			_game.ContinuarSons();
			_game.ContinuarMusica();

			_game.simulador.SetVariavel("Fase2", "13");
			_game.ListenersInterface(false);
		}

		/******************************
		 * Fase 3 
		 ******************************/

		var industriaReciclagem	: Boolean = false;
		var usinaEolica		 	: Boolean = false;
		
		protected function f3FimCutscene2() : void
		{
			_game.MostrarTelaPreta(false);

			_game.ContinuarSons();
			_game.ContinuarMusica();

			_game.simulador.SetVariavel("Fase3", "7");
			_game.ListenersInterface(false);
		}
		
		protected function f3FimCutscene3() : void
		{
			_game.MostrarTelaPreta(false);

			_game.ContinuarSons();
			_game.ContinuarMusica();

			_game.simulador.SetVariavel("Fase3", "9");
			_game.ListenersInterface(false);
			
			_game.SalvarConstrucaoArquivo(3);

			//envia dados ludens
			//if(Global.variables.ludens == true){
			//	_game.EmitirRelatorio('TCF03', String(_game.simulador.GetTempoTotalFase()));
			//}

			_game.FimFase();
		}
	}
}