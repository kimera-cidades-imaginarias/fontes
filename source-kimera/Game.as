package
{

	import as3isolib.display.IsoSprite;
	import as3isolib.display.primitive.IsoRectangle;
	import as3isolib.display.primitive.IsoBox;
	import as3isolib.enum.IsoOrientation;
	import as3isolib.geom.IsoMath;
	import as3isolib.geom.Pt;
	import as3isolib.graphics.BitmapFill;
	import as3isolib.graphics.SolidColorFill;
	
	import com.kengine.Engine;
	import com.kengine.util.ScreenLoader;
	
	import com.kimera.KimeraGame;
	import com.kimera.screens.CasteloKimera;
	import com.kimera.screens.Mensagem;
	import com.kimera.externo.voo.SensorRemoto;
	
	import core.Construcao;
	import core.ConstrucaoDecorativa;
	import core.ConstrucaoFuncional;
	import core.Fase;
	import core.FaseRender;
	import core.Nivel;
	import core.Simulador;
	import core.dados.DataLoader;
	import core.efeitos.Rain;
	import core.eventos.EventoSimulador;
	import core.interfac.*;
	import core.media.GestorSom;
	import core.media.Som;
	import core.util.Cronometro;
	import core.util.MovieClipUtil;
	import core.util.NumberFormat;
	import core.util.LudensUtil;
	import core.util.EventoLudens;
	import core.sistema.air.Arquivo;

	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.ui.Mouse;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.display.Loader;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.events.TransformGestureEvent;

	import com.adobe.images.JPGEncoder;
	
	import flash.utils.Timer;
	import flash.utils.clearInterval;
	import flash.utils.getDefinitionByName;
	import flash.utils.getTimer;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	import flash.utils.ByteArray;

	import flash.net.FileReference;
	import flash.net.FileFilter;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.net.URLVariables;
	import flash.net.URLRequestMethod;
		
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import flash.media.SoundTransform;
	import flash.system.Security;
	import flash.system.Capabilities;
	import flash.text.TextField;

	import flash.desktop.NativeApplication;
	
	import gs.TweenLite;
	import gs.plugins.AutoAlphaPlugin;
	import gs.plugins.ColorMatrixFilterPlugin;
	import gs.plugins.TweenPlugin;
	import gs.plugins.VisiblePlugin;
	import flash.ui.Keyboard;

	//ENABLE GESTURES
	Multitouch.inputMode = MultitouchInputMode.GESTURE;

	public class Game extends MovieClip
	{
		// Constantes
		
		private const LIMITE_ESQUERDA 	= 20;
		private const LIMITE_DIREITA   	= 1004;
		private const LIMITE_SUPERIOR  	= 20;
		private const LIMITE_INFERIOR  	= 708;

		private const ROLAMENTO 	   			= 5;
		private const VELOCIDADE_ROLAGEM_TEXTO  = 10;
		private const VELOCIDADE_ROLAGEM_ICONES = 10;
		
		public const ESTADO_PAUSA			  	   	   = "estado_pausa";
		public const ESTADO_GAMEPLAY			  	   = "estado_gameplay";
		public const ESTADO_ADICIONAR_CONSTRUCAO 	   = "estado_adicionar_construcao";
		public const ESTADO_ADICIONAR_EMISSOR 	   	   = "estado_adicionar_emissor";
		public const ESTADO_MENU_ADICIONAR_CONSTRUCAO  = "estado_menu_adicionar_construcao";
		public const ESTADO_CARREGANDO				   = "estado_carregando";
		public const ESTADO_CONFIGURACOES 			   = "estado_configuracoes";		
		public const ESTADO_CARREGAR_JOGO 			   = "estado_carregar_jogo";
		public const ESTADO_MENU_PRINCIPAL			   = "estado_menu_principal";
		public const ESTADO_MENSAGENS				   = "estado_mensagens";
		public const ESTADO_CARTA_VOADORA			   = "estado_carta_voadora";
		public const ESTADO_TELA_METAS				   = "estado_tela_metas";
		public const ESTADO_TUTORIAL		   		   = "estado_tutorial";
		public const ESTADO_TUTORIAL_PARTE_I		   = "estado_tutorial_primeira_parte";
		public const ESTADO_TUTORIAL_PARTE_II		   = "estado_tutorial_segunda_parte";
				
		private const CELULAS_RELOGIO 	= 16;
		
		// Variáveis		

		public var initialPanPoint : Point;
		
		public var render    	: FaseRender = null;
		public var simulador 	: Simulador;
		public var sensorRemoto : SensorRemoto = new SensorRemoto();

		public var filtroMar			: IsoRectangle = null;
		public var filtroTerreno		: IsoRectangle = null;
		public var filtroVegetacao		: IsoRectangle = null;

		public var janelaGlobal:String 		= new String('NORMAL');
		public var qualidadeGlobal:String 	= new String('HIGH');
		
		var aplicacaoAtiva : Boolean = true;   // mapa não rola em tela de desastre e de atualizar construção;
		
		public var indice : String = "Moradia";
		
		var arrayDecodificado : Array  = new Array();
		
		// Sons

		var opcoes 	  : Object;
		var sliderSom : SliderBar;
		var somPopupEstrutura : String;
		
		var arquivoConfiguracoes : String;
		var estadoInterface 	 : String;
		var estadoAnterior 		 : String;
		
		var keyRolamento = null;
		
		// //-------------------------------- Globais -------------------------------//

		Global.variables.android = false; //jason teste
		Global.variables.modoEditor = false; 
		Global.variables.ludens = true; 
		Global.variables.faseConstrucao = "";

		var graficoClicado    : IsoSprite;
		var tamanhoSeletor    : Point;
		
		var seletor		      : IsoRectangle = null;
		public var iconeSelecionado  : MovieClip 	 = null;
		
		var construcaoClicada = null;
		
		// ------------ Emissão de Som -------------//

		var emissores 	: Array     = null;
		public var gestorSom 	: GestorSom = null;
		var construindo : Array     = new Array(); // array com os nomes das construções que estão em construção / conserto.
		var emissoresAdicionados : Array = new Array();
		
		var indexTransito : int = 1;
		
		// Zoom.
		var zoomFactors	: Array = [0.25, 0.4, 0.7, 1, 1.3, 1.5];
		var zoomIndex 	: int   = 3;
		
		// Fase.
		var fase 		  : Fase	   = null; // NÃO USADA!!!!!!!!
		public var dataLoader	  : DataLoader = null;
		public var faseACarregar : String     = null;
		
		/* eventosCriadosI indica se alguns eventos de interface já foram criados. Para a fase tutorial eles não são criados.
		 * eventosCriadosII indica se os eventos de gameplay já foram criados. Esses dois indicadores servem para 
		 * eventos não serem criados mais de uma vez */
		 
		var eventosCriadosI  : Boolean = false;
		var eventosCriadosII : Boolean = false;
		
		// Auxiliares interface.
		var dinheiroObj   : Object = {quantidade: 0};
		var pontuacaoObj   : Object = {quantidade: 0};
		var populacaoObj  : Object = {populacao: 0};
		var habitadosObj  : Object = {habitados: 0};
		var empregadosObj  : Object = {empregados: 0};
		
		// Interface		
		var scrollBarMensagens   : Scrollbar 		= null;
		var scrollBarKamplus   	: Scrollbar 		= null;
		var scrollBarConstrucoes : ScrollHorizontal = null;
		
		// Empréstimo
		var emEmprestimo 	: Boolean = false;
		public var vaiAdicionar 	: Boolean = false;
		var emprestimoAtual : Object  = {quantidade: 0};
		
		var construcaoDesastre = null; // Construção afetada pelo último desastre ocorrido.
		
		var palavrasChave : Array = new Array({key: "driadesedeumal", text: "Vamos lá para a próxima missão? Fique atento para buscar soluções, pois vários problemas irão aparecer. Boa sorte!"},
									  		  {key: "adeuscetus", text: "Pronto para a sua próxima missão? Vamos ajudar a manter a cidade limpa, para isso construa uma Indústria de Reciclagem!"},
									  		  {key: "", text: ""},
									  		  {key: "tenhoboamemoria", text: ""});
		
		var shiftPressed : Boolean = false;
				
		var atualizarMenu;
		var atualizarPopupEstrutura;
		var tempo : String = "sol";
		
		// Tutorial
		var emTutorial 			: Boolean = false;
		var casasTutorial 		: int = 0;
		var postosTutorial 		: int = 0;
		var bibliotecasTutorial : int = 0;
		
		var ultimaAcao : String;
		
		// Se o jogador ficar tanto tempo sem interagir com o jogo, pausará automaticamente.
		var timerMouse : Timer = new Timer(1000);
		
		// Ludens
		var ludensUtil : LudensUtil = new LudensUtil('KIMERA');

		var indiceIndicador, arrayIndicadores;
		
		var qtdVezesEmprestimoFase : int;
		
		var cronometroFase        = null;
		var cronometroSelecaoPers = null;
		var cronometroMenu		  = null;
		var cronometroMsgTutorial = null;
								   
		var tempoTotalPausa  = 0;
		var qtdGameOver      = 0;
		
		public var rotuloDesastre:String = '';

		public var engine : KimeraGame = null;
		
		var qtdConstrucoes = {moradia: 0, educacao: 0, lazer: 0, comercio: 0, infraestrutura: 0};
		
		static private var _instance:Game; 
		public var stageObj : Stage;		
		
		public function Game()
		{
			if(stage) {
				init();
			} else {
				addEventListener(Event.ADDED_TO_STAGE,init);
			}
		}
			
		protected function init(evt:Event = null):void
		{	
			//Android detect
			trace('OS: ' + Capabilities.manufacturer);

			if((Capabilities.manufacturer == 'Android Linux'))
 			{
				Global.variables.android = true;
			}

			engine = new KimeraGame(this);
			
			removeEventListener(Event.ADDED_TO_STAGE,init);
			
			_instance = this;
			
			//Security.allowDomain("*");
			//Security.loadPolicyFile('crossdomain.xml');
			
			stageObj = stage;
			
			// Inicializações e variáveis									
			stage.align     = StageAlign.TOP;
			stage.quality 	= StageQuality.BEST;
			stage.scaleMode = StageScaleMode.EXACT_FIT;
			stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE; 

			
			TweenPlugin.activate([AutoAlphaPlugin, ColorMatrixFilterPlugin, VisiblePlugin]);
			
			SetVisibilidadeInicial();
			
			mensagens_mc.text_txt.htmlText = "";
			
			this.carregarEventListners();
			
			// Slider e scrollbars
			
			sliderSom = new SliderBar( configuracao_mc.slider_mc, MudancaOpcao );

			scrollBarMensagens = new Scrollbar( mensagens_mc.container_mc, 
											   	mensagens_mc.mask_mc, 
												mensagens_mc.scroll_mc.scroll_mc, 
												mensagens_mc.scroll_mc.track_mc, 
												mensagens_mc.scroll_mc.track_mc, true, 6);
			
			scrollBarMensagens.addEventListener( Event.ADDED, scrollBarMensagens.init ); 
			addChild( scrollBarMensagens );
			
			mensagens_mc.container_mc.startY = mensagens_mc.container_mc.y;
			mensagens_mc.down_btn.addEventListener(MouseEvent.CLICK, function(evt)	{ ButtonDown( mensagens_mc.scroll_mc.scroll_mc, mensagens_mc.scroll_mc.track_mc ); });
			mensagens_mc.up_btn.addEventListener(MouseEvent.CLICK, function(evt)	{ ButtonUp( mensagens_mc.scroll_mc.scroll_mc, mensagens_mc.scroll_mc.track_mc ); });

			scrollBarKamplus = new Scrollbar( 	kamplus_mc.container_mc, 
											   	kamplus_mc.mask_mc, 
												kamplus_mc.scroll_mc.scroll_mc, 
												kamplus_mc.scroll_mc.track_mc, 
												kamplus_mc.scroll_mc.track_mc, true, 6);
			
			scrollBarKamplus.addEventListener( Event.ADDED, scrollBarKamplus.init ); 
			addChild( scrollBarKamplus );
			
			kamplus_mc.container_mc.startY = kamplus_mc.container_mc.y;
			kamplus_mc.down_btn.addEventListener(MouseEvent.CLICK, function(evt)	{ ButtonDown( kamplus_mc.scroll_mc.scroll_mc, kamplus_mc.scroll_mc.track_mc ); });
			kamplus_mc.up_btn.addEventListener(MouseEvent.CLICK, function(evt)	{ ButtonUp( kamplus_mc.scroll_mc.scroll_mc, kamplus_mc.scroll_mc.track_mc ); });
			
			scrollBarConstrucoes = new ScrollHorizontal( adicionar_mc.container_mc, 
											   	adicionar_mc.mask_mc, 
												adicionar_mc.scroll_mc.scroll_mc, 
												adicionar_mc.scroll_mc.track_mc, 
												adicionar_mc.scroll_mc.track_mc,
												adicionar_mc.containerMask_mc, true, 6);
			
			scrollBarConstrucoes.addEventListener( Event.ADDED, scrollBarConstrucoes.init ); 
			addChild( scrollBarConstrucoes );
			
			adicionar_mc.container_mc.startX = adicionar_mc.container_mc.x;
			adicionar_mc.left_btn.addEventListener(MouseEvent.CLICK, function(evt)	{ ButtonLeft( adicionar_mc.scroll_mc.scroll_mc, adicionar_mc.scroll_mc.track_mc ); });
			adicionar_mc.right_btn.addEventListener(MouseEvent.CLICK, function(evt)	{ ButtonRight( adicionar_mc.scroll_mc.scroll_mc, adicionar_mc.scroll_mc.track_mc ); });
			
			this.carregarSom();
			
			// Clima.
			clima_mc.alpha 			= 0;
			clima_mc.mouseChildren 	= false;
			clima_mc.mouseEnabled	= false;
			
			// Loading.
			carregando_mc.visible 	= false;
			
			// Opções.
			arquivoConfiguracoes	= Arquivo.GetPastaAplicacao(false) + Arquivo.GetSeparador() + "config.xml"; //erro aqui
			CarregarOpcoes();
			
			// Dataloader.
			dataLoader = DataLoader.GetInstance();
			
			// Fase render.						
			render = FaseRender.GetInstance();
			container_mc.addChild( render.GetMapView() );
			
			MudarEstadoInterface( ESTADO_MENU_PRINCIPAL );
						
			if(Global.variables.modoEditor) ConfigurarModoEditor();
			else ConfigurarModoNormal();
			
			engine.inicioMotor();
		}
		
		protected function carregarSom(){
			// Sons
			
			gestorSom = GestorSom.GetInstance();
			gestorSom.SetVolumeGrupo('musicas', 0.5);
			gestorSom.CarregarSomBiblioteca('click-construcao', ClickConstrucao, 'efeitos');
			gestorSom.CarregarSomBiblioteca('click-comum', ClickComum, 'efeitos');
			gestorSom.CarregarSomBiblioteca('click-diferenciado', ClickDiferenciado, 'efeitos');
			gestorSom.CarregarSomBiblioteca('construindo', Construindo, 'efeitos');
			gestorSom.CarregarSomBiblioteca('construcao-demolicao', ConstrucaoDemolicao, 'efeitos');
			gestorSom.CarregarSomBiblioteca('construcao-finalizada', FimConstrucao, 'efeitos');
			gestorSom.CarregarSomBiblioteca('mouse-over', MouseOverSound, 'efeitos');
			gestorSom.CarregarSomBiblioteca('plaquinha-mouse-over', PlaquinhaMouseOver, 'efeitos');
			gestorSom.CarregarSomBiblioteca('popup', PopUp, 'efeitos');
			gestorSom.CarregarSomBiblioteca('chuva', TempoChuva, 'efeitos_climaticos');
			gestorSom.CarregarSomBiblioteca('trovao', TempoTrovao, 'efeitos_climaticos');
			gestorSom.CarregarSomBiblioteca('powerup_usando', PowerUp_Usando, 'efeitos');
			gestorSom.CarregarSomBiblioteca('powerup_carregado', PowerUp_Carregado, 'efeitos');
			gestorSom.CarregarSomBiblioteca('powerup_esgotado', PowerUp_Esgotado, 'efeitos');
			gestorSom.CarregarSomBiblioteca('fase-completa', FaseCompleta, 'musicas');
			
			gestorSom.CarregarSomArquivo('musica-menu-principal', 'data/musicas/menu_inicial.mp3', 'musicas');
			gestorSom.CarregarSomArquivo('musica-power-up', 'data/musicas/tema_power_up.mp3', 'musicas');
			gestorSom.CarregarSomArquivo('musica-password', 'data/musicas/password.mp3', 'musicas');
			gestorSom.CarregarSomArquivo('musica-carregando', 'data/musicas/carregando.mp3', 'musicas');
			gestorSom.CarregarSomArquivo('musica-escolha-personagem', 'data/musicas/escolha_personagem.mp3', 'musicas');

			gestorSom.CarregarSomArquivo('buzina-carros', 'data/efeitos/buzina-carros.mp3', 'musicas');
			gestorSom.CarregarSomArquivo('tiroteio', 'data/efeitos/tiroteio.mp3', 'musicas');
			gestorSom.CarregarSomArquivo('driade', 'data/efeitos/driade.mp3', 'musicas');
			gestorSom.CarregarSomArquivo('cetus', 'data/efeitos/cetus.mp3', 'musicas');
			gestorSom.CarregarSomArquivo('kaos', 'data/efeitos/kaos.mp3', 'musicas');
			gestorSom.CarregarSomArquivo('inundacao', 'data/efeitos/inundacao.mp3', 'musicas');
			gestorSom.CarregarSomArquivo('mosquitos', 'data/efeitos/mosquitos.mp3', 'musicas');
			gestorSom.CarregarSomArquivo('fogo', 'data/efeitos/fire.mp3', 'musicas');
			gestorSom.CarregarSomArquivo('sirene', 'data/efeitos/sirene.mp3', 'musicas');
			
			gestorSom.Reproduzir('musica-carregando', 99999);
		}
		
		protected function carregarEventListners()
		{
			// Event Listeners da interface
			NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN,checkKeypress);

			stage.addEventListener( KeyboardEvent.KEY_DOWN, KeyPress );
			stage.addEventListener( KeyboardEvent.KEY_UP  , KeyUp );
			stage.addEventListener( MouseEvent.MOUSE_MOVE , MovimentoMouse );
			
			configuracao_mc.fechar_btn.addEventListener( MouseEvent.CLICK, OcultarConfig );
			configuracao_mc.som_btn.addEventListener( MouseEvent.CLICK, MudarVolume );
			configuracao_mc.muteSound_btn.addEventListener( MouseEvent.CLICK, MudarVolume );
			
			configuracao_mc.janela_btn.addEventListener( MouseEvent.CLICK, FormatoJanela );
			configuracao_mc.telaCheia_btn.addEventListener( MouseEvent.CLICK, FormatoTelaCheia );
			
			configuracao_mc.qualidadeBaixa_btn.addEventListener( MouseEvent.CLICK, MudarQualidade );
			configuracao_mc.qualidadeMedia_btn.addEventListener( MouseEvent.CLICK, MudarQualidade );
			configuracao_mc.qualidadeAlta_btn.addEventListener( MouseEvent.CLICK , MudarQualidade );

			configuracao_mc.continuar_btn.addEventListener( MouseEvent.CLICK , LeituraCartas );

			passagem_mc.fechar_btn.addEventListener( MouseEvent.CLICK, OcultarTelaPassagem );
			passagem_mc.continuar_btn.addEventListener( MouseEvent.CLICK, OcultarTelaPassagem );
			
			adicionar_mc.moradia_btn.addEventListener( MouseEvent.CLICK	 , MudarIndice );
			adicionar_mc.educacao_btn.addEventListener( MouseEvent.CLICK , MudarIndice );
			adicionar_mc.comercio_btn.addEventListener( MouseEvent.CLICK, MudarIndice );
			
			adicionar_mc.lazer_btn.addEventListener( MouseEvent.CLICK, MudarIndice );
			adicionar_mc.infraestrutura_btn.addEventListener( MouseEvent.CLICK, MudarIndice );
			
			adicionar_mc.fechar_btn.addEventListener( MouseEvent.CLICK	 , OcultarMenuConstrucao );
			
			atualizar_mc.consertar_btn.addEventListener( MouseEvent.CLICK, ConsertarConstrucao );			
			//atualizar_mc.atualizar_btn.addEventListener( MouseEvent.CLICK, AtualizarConstrucao );
			atualizar_mc.excluir_btn.addEventListener( MouseEvent.CLICK  , ExcluirConstrucao );
			atualizar_mc.fechar_btn.addEventListener( MouseEvent.CLICK	 , OcultarMenuAtualizar );
			
			mensagens_mc.fechar_btn.addEventListener( MouseEvent.CLICK, OcultarMensagens );
			
			pausa_mc.configuracoes_btn.addEventListener( MouseEvent.CLICK, MostrarConfiguracoes );
			pausa_mc.voltar_btn.addEventListener( MouseEvent.CLICK, Continuar );			
			pausa_mc.sair_btn.addEventListener( MouseEvent.CLICK, SairJogo );
			
			carregar_mc.continuar_btn.addEventListener( MouseEvent.CLICK, ValidarCodigo );
			carregar_mc.voltar_btn.addEventListener( MouseEvent.CLICK   , OcultarCarregarJogo );
			
			gameOver_mc.novoJogo_btn.addEventListener( MouseEvent.CLICK, ReiniciarJogo );
			fimJogo_mc.novoJogo_btn.addEventListener( MouseEvent.CLICK , NovoJogo2 );
			gameOver_mc.sair_btn.addEventListener( MouseEvent.CLICK	   , VoltarMenu );
			fimJogo_mc.sair_btn.addEventListener( MouseEvent.CLICK	   , VoltarMenu );
			
			//desastre_mc.fechar_btn.addEventListener( MouseEvent.CLICK	, FecharDesastre );
			desastre_mc.visualizar_mc.addEventListener( MouseEvent.CLICK, VisualizarDesastre );

			//desastre_mc.engrenagens_mc.visible = false;
			
			//botaoPausa_btn.addEventListener( MouseEvent.CLICK, Pausar );

			timerMouse.addEventListener(TimerEvent.TIMER, controleOcioso);
		}

		public function controleOcioso(e:TimerEvent):void{
			//trace("Times Fired: " + e.currentTarget.currentCount);

			if(e.currentTarget.currentCount >= 10 ){
				//if( simulador.GetVariavel("Fase1") != "1" && simulador.GetVariavel("Fase1") != "7" ){
					attention_contrucao.visible = true;
					attention_contrucao.play();
				//}
			}

			/*
			if( e.currentTarget.currentCount >= 10 ){
				if( simulador.GetVariavel("Fase1") == "1" || simulador.GetVariavel("Fase1") == "7" ){
					attention_jaquetiba.visible = true;
					attention_jaquetiba.play();
				}
			}
			*/
		}
		
		//----------------------------------------------------------------------------
		// ÍNDICE - utilize ctrl + F para localizar o que deseja a partir dos "<?>"
		//----------------------------------------------------------------------------
		//
		// <1>  : Funções utilizadas pelo construtor
		// <2>  : Funções referentes ao Ludens
		// <3>  : Iniciando alguma fase
		// <4>  : Encerrando alguma fase
		// <5>  : Events Handlers Parte I : Janelas, telas e menu
		// <6>  : Events Handlers Parte II : Interface Gampeplay
		// <7>  : Metas (objetivos)
		// <8>  : Mensagens
		// <9>  : Aplicação de desastres
		// <10> : Conserto de construções
		// <11> : Adicionar construções
		// <12> : Atualizar construções
		// <13> : Excluir construções
		// <14> : Eventos de turno
		// <15> : OnEnterFrame e scroll do mapa
		// <16> : Seletor (retângulo que mostra a área da construção a ser adicionada)
		// <17> : Tooltips diversos
		// <18> : Funções de Pausa
		// <19> : Funções de encerramento do jogo.
		// <20> : Sons e emissores
		// <21> : Alguns outros eventos
		// <22> : Opções de salvar algumas coisas
		// <23> : Funções da scroll bar
		// <24> : Funções de empréstimo
		// <25> : Funções do tutorial
		// <26> : Úteis.
		//
		//-----------------------------------------------------------------------------
		
		//--------------------------------------------------------------
		// <1> Funções utilizadas pelo construtor
		//--------------------------------------------------------------
		
		function SetVisibilidadeInicial()
		{
			// Visibilidade (todos os elementos de interface que iniciam invisíveis)

			adicionar_mc.addMobile.visible = false;
			adicionar_mc.addMobile.useHandCursor = true;
			adicionar_mc.addMobile.buttonMode = true;

			hand.visible= false;
			processar_mv.visible = false;

			btNorte.visible = false; btNorte.alpha = 0;
			btSul.visible = false; btSul.alpha = 0;
			btLeste.visible = false; btLeste.alpha = 0;
			btOeste.visible = false; btOeste.alpha = 0;

			salvar_btn.visible = false;
			alterar_visualizacao_btn.visible = false;
			menu_visualizacao.visible = false;
			barra.visible = false;

			tooltipConstrucoes_mc.visible = false;
			//tooltipNivel_mc.visible = false;
			tooltipMsg_mc.visible = false;
			tooltipCartaVoadora_mc.visible = false;
			tooltipZoomIn.visible = false;
			tooltipZoomOut.visible = false;
			tooltipConfiguracoes.visible = false;
			tooltipSalvar.visible = false;
			tooltipAlterarVisualizacao.visible = false;
			tooltipArea.visible = false;
					
			configuracao_mc.visible = false;			
			fadeSuperior_mc.visible = false;			

			mensagens_mc.visible = false;
			adicionar_mc.visible = false;
			atualizar_mc.visible = false;

			passagem_mc.visible = false;			
			carregar_mc.visible	= false;			
			gameOver_mc.visible	= false;
			desastre_mc.visible	= false;			
			fimJogo_mc.visible = false;

			pausa_mc.visible = false;			
			fade_mc.visible = false;
			
			cartaVoadora_mc.visible = false;
			
			castelo_mc.visible = false;
			guardioes_mc.visible = false;
			trepadeiras_interface.visible = false;
			sirene_interface.visible = false;
			
			attention_contrucao.visible = false;
			attention_jaquetiba.visible = false;

			//nomeDoMapa.visible = false;
			
			//adicionar_mc.tooltipP_mc.visible = false;
			//adicionar_mc.tooltipG_mc.visible = false;

			cartaVoadora_mc.enviar_btn.visible = false;
			cartaVoadora_mc.bt_limpar.visible = false;
		}


		public function bloquearInterface(){
			trace('bloqueou');

			if( Global.variables.android == true )
			{
				adicionar_btn.removeEventListener(MouseEvent.MOUSE_DOWN, MouseOverAdicionar);
				adicionar_btn.removeEventListener(MouseEvent.MOUSE_UP , MouseOutAdicionar);
				adicionar_btn.removeEventListener(MouseEvent.CLICK, MenuAddConstrucao);
 
				carta_btn.removeEventListener(MouseEvent.MOUSE_DOWN, MouseOverCarta);
				carta_btn.removeEventListener(MouseEvent.MOUSE_UP , MouseOutCarta);
				carta_btn.removeEventListener(MouseEvent.CLICK, MostrarCarta);

				mensagem_btn.removeEventListener(MouseEvent.MOUSE_DOWN, MouseOverMsg);
				mensagem_btn.removeEventListener(MouseEvent.MOUSE_UP , MouseOutMsg);
				mensagem_btn.removeEventListener(MouseEvent.CLICK, MostrarMensagens);

				botaoPausa_btn.removeEventListener(MouseEvent.MOUSE_DOWN, MouseOverConfiguracoes);
				botaoPausa_btn.removeEventListener(MouseEvent.MOUSE_UP , MouseOutConfiguracoes);
				botaoPausa_btn.removeEventListener(MouseEvent.CLICK, Pausar);
			}
			else
			{
				adicionar_btn.removeEventListener(MouseEvent.MOUSE_OVER, MouseOverAdicionar);
				adicionar_btn.removeEventListener(MouseEvent.MOUSE_OUT , MouseOutAdicionar);
				adicionar_btn.removeEventListener(MouseEvent.CLICK, MenuAddConstrucao);

				carta_btn.removeEventListener(MouseEvent.MOUSE_OVER, MouseOverCarta);
				carta_btn.removeEventListener(MouseEvent.MOUSE_OUT , MouseOutCarta);
				carta_btn.removeEventListener(MouseEvent.CLICK, MostrarCarta);

				mensagem_btn.removeEventListener(MouseEvent.MOUSE_OVER, MouseOverMsg);
				mensagem_btn.removeEventListener(MouseEvent.MOUSE_OUT , MouseOutMsg);
				mensagem_btn.removeEventListener(MouseEvent.CLICK, MostrarMensagens);
				
				botaoPausa_btn.removeEventListener(MouseEvent.MOUSE_OVER, MouseOverConfiguracoes);
				botaoPausa_btn.removeEventListener(MouseEvent.MOUSE_OUT , MouseOutConfiguracoes);
				botaoPausa_btn.removeEventListener(MouseEvent.CLICK, Pausar);
			}
		}

		public function liberarInterface(){
			trace('liberou');

			if( Global.variables.android == true )
			{
				adicionar_btn.addEventListener(MouseEvent.MOUSE_DOWN, MouseOverAdicionar);
				adicionar_btn.addEventListener(MouseEvent.MOUSE_UP , MouseOutAdicionar);
				adicionar_btn.addEventListener(MouseEvent.CLICK, MenuAddConstrucao);

				carta_btn.addEventListener(MouseEvent.MOUSE_DOWN, MouseOverCarta);
				carta_btn.addEventListener(MouseEvent.MOUSE_UP , MouseOutCarta);
				carta_btn.addEventListener(MouseEvent.CLICK, MostrarCarta);

				mensagem_btn.addEventListener(MouseEvent.MOUSE_DOWN, MouseOverMsg);
				mensagem_btn.addEventListener(MouseEvent.MOUSE_UP , MouseOutMsg);
				mensagem_btn.addEventListener(MouseEvent.CLICK, MostrarMensagens);

				botaoPausa_btn.addEventListener(MouseEvent.MOUSE_DOWN, MouseOverConfiguracoes);
				botaoPausa_btn.addEventListener(MouseEvent.MOUSE_UP , MouseOutConfiguracoes);
				botaoPausa_btn.addEventListener(MouseEvent.CLICK, Pausar);
			}
			else
			{
				adicionar_btn.addEventListener(MouseEvent.MOUSE_OVER, MouseOverAdicionar);
				adicionar_btn.addEventListener(MouseEvent.MOUSE_OUT , MouseOutAdicionar);
				adicionar_btn.addEventListener(MouseEvent.CLICK, MenuAddConstrucao);

				carta_btn.addEventListener(MouseEvent.MOUSE_OVER, MouseOverCarta);
				carta_btn.addEventListener(MouseEvent.MOUSE_OUT , MouseOutCarta);
				carta_btn.addEventListener(MouseEvent.CLICK, MostrarCarta);
				
				mensagem_btn.addEventListener(MouseEvent.MOUSE_OVER, MouseOverMsg);
				mensagem_btn.addEventListener(MouseEvent.MOUSE_OUT , MouseOutMsg);
				mensagem_btn.addEventListener(MouseEvent.CLICK, MostrarMensagens);
				
				botaoPausa_btn.addEventListener(MouseEvent.MOUSE_OVER, MouseOverConfiguracoes);
				botaoPausa_btn.addEventListener(MouseEvent.MOUSE_OUT , MouseOutConfiguracoes);
				botaoPausa_btn.addEventListener(MouseEvent.CLICK, Pausar);
			}
		}
		
		/**
		 * Retorna uma instancia da classe principal do jogo
		 */
		static public function getInstance() : Game
		{
			return _instance;
		}
		
		public function setIndice(_indice : String)
		{
			this.indice = _indice;	
		}
		
		public function VerificaFluxoDeJogo( chave : String )
		{
			engine.verificaFluxoDeJogo(chave);
		}
		
		function CarregarOpcoes()
		{
			if ( Arquivo.ExisteArquivo( arquivoConfiguracoes , false) )
			{
				var configuracoes = Arquivo.LerConteudoArquivo( arquivoConfiguracoes , false );
				var xml 		  = new XML( configuracoes );
				opcoes = {volume: Number( xml.opcoes.@volume ), qualidade:String(xml.opcoes.@qualidade), janela:String(xml.opcoes.@janela)};
			}
			else opcoes = {volume: 0.5, qualidade:'HIGH', janela:'NORMAL'};
			
			sliderSom.SetValue( opcoes.volume );
			
			//setar qualidade padrao
			if(opcoes.qualidade == 'LOW'){
				stage.quality = StageQuality.LOW;
			}
			
			if(opcoes.qualidade == 'MEDIUM'){
				stage.quality = StageQuality.MEDIUM;
			}
			
			if(opcoes.qualidade == 'HIGH'){
				stage.quality = StageQuality.HIGH;
			}
			
			//setar janela padrao
			if(opcoes.janela == 'NORMAL'){
				stage.displayState = StageDisplayState.NORMAL; 
			}
			
			if(opcoes.janela == 'FULL_SCREEN'){
				stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE; 
			}
		}
		

		
		public function ConfigurarModoEditor()
		{

			trace('->Modo editor')
			Global.variables.modoEditor = true;
		}
		
		public function ConfigurarModoNormal()
		{

			trace('->Modo normal')
			Global.variables.modoEditor = false;
		}
		
		//------------------------------
		// <3> Iniciando alguma fase.
		//------------------------------
		
		public function ValidarLogin(usuario:String, senha:String){
			//autentica
			ludensUtil.Conectar('http://www.comunidadesvirtuais.pro.br/ludens/api/', 'email', usuario, senha);
		}

		public function EmitirRelatorio(codigo:String, valor:String){
			ludensUtil.Registrar(codigo, valor);
		}

		function IniciarJogo(nomeXML : String)
		{
			MudarEstadoInterface( ESTADO_CARREGANDO );
			
			var caminho = "data" + Arquivo.GetSeparador() + "fases" + Arquivo.GetSeparador() + nomeXML;
			var save = null;
			
			trace('-----> nome xml: ' + nomeXML);

			engine.reiniciarVariaveis();

			if(nomeXML == 'fase1.xml'){
				nomeDoMapa.campo.text = "Nível 1 - Imaginar";
			}

			else if(nomeXML == 'fase2.xml'){
				nomeDoMapa.campo.text = "Nível 2 - Construir";

				if ( Arquivo.ExisteArquivo( Arquivo.GetPastaAplicacao(false) + 'saves'+Arquivo.GetSeparador()+'fase1.xml' , false) )
				{
					save = Arquivo.GetPastaAplicacao(false) + 'saves'+Arquivo.GetSeparador()+'fase1.xml';
				}
			}
			
			else if(nomeXML == 'fase3.xml'){
				nomeDoMapa.campo.text = "Nível 3 - Transformar";

				if ( Arquivo.ExisteArquivo( Arquivo.GetPastaAplicacao(false) + 'saves'+Arquivo.GetSeparador()+'fase2.xml', false ) )
				{
					save = Arquivo.GetPastaAplicacao(false) + 'saves'+Arquivo.GetSeparador()+'fase2.xml';
				}
			}

			else {
				if ( Arquivo.ExisteArquivo( Arquivo.GetPastaAplicacao(false) + 'saves'+Arquivo.GetSeparador()+nomeXML, false ) )
				{	
					save = Arquivo.GetPastaAplicacao(false) + 'saves'+Arquivo.GetSeparador()+nomeXML;
				}	
			}

			dataLoader.addEventListener(Event.COMPLETE, FimLoad);

			if(Global.variables.modoEditor == true)
			{
				dataLoader.CarregarFase( Arquivo.GetPastaAplicacao(false) + caminho, save, true );
			}
			else
			{
				dataLoader.CarregarFase( /*Arquivo.GetPastaAplicacao() +*/ caminho, save );
			}	
		}
		
		function FimLoad(evt)
		{
			//reinicia render
			render.RemoverEstruturas();
			render.RemoverTexturas();
			render.RemoverNoGrid(3);

			MostrarInvasaoDriadeDoMal(2);
			MostrarAlertaDesastre(2)

			bussola_mc.desmarcarPedras();

			ZerarValores(); 	// zera alguns valores interface
			RemoverMensagens();
			
			var fase : Fase = dataLoader.GetFase();
			
			simulador = Simulador.GetInstance();
			
			ListenersInterface( true );
			
			if( !eventosCriadosI ) CriarListeners();
			
			dataLoader.removeEventListener( Event.COMPLETE, FimLoad );
			stage.addEventListener(Event.ENTER_FRAME, OnEnterFrame);
			
			simulador.Iniciar( fase );
			
			render.Exibir( fase );
			render.SetPan( fase.GetPosInicialCamera() );
					
			// Inicia emissores.
			var emissores = dataLoader.GetEmissores();			
			for(var i = 0; i < emissores.length; i++)
			{
				var pos = emissores[i].GetPosicaoCelulas();
				emissores[i].SetPosicao(new Point(pos.x * FaseRender.CELL_SIZE - FaseRender.CELL_SIZE/2, 
												  pos.y * FaseRender.CELL_SIZE - FaseRender.CELL_SIZE/2));
				emissores[i].GetSom().SetVolume( 0 );
				emissores[i].GetSom().Play(0, 9999999);
			}
			
			gestorSom.PararTudo();
			fase.GetMusica().Play( 0, 9999999 );
			fase.GetMusica().SetVolume( opcoes.volume );
			
			MudarEstadoInterface( ESTADO_GAMEPLAY );
			
			qtdVezesEmprestimoFase = 0;
			cronometroFase = new Cronometro();
			cronometroFase.Iniciar();
			
			VerificarNovaFase(fase.GetNumero());
		}
		
		function ZerarValores()
		{
			relogio_mc.placa_mc.turnos_txt.text = 0;
			populacao_mc.quantidade_txt.text = 0;
			habitados_mc.quantidade_txt.text = 0;
			empregados_mc.quantidade_txt.text = 0;
			pontos_mc.montante_txt.text = 0;
			dinheiro_mc.montante_txt.text = 0;
		}

		public function movimentarMapaPress(e:Event = null)
		{
			var r = new Point(0, 0);

			if(e.target.name == 'btOeste')
			{
				r.x = -ROLAMENTO;
			}

			if(e.target.name == 'btLeste')
			{
				r.x = ROLAMENTO;
			}

			if(e.target.name == 'btNorte')
			{
				r.y = -ROLAMENTO;
			}

			if(e.target.name == 'btSul')
			{
				r.y = ROLAMENTO;
			}

			keyRolamento = r;
		}

		//mapa pam
		private function mapaPam(event : MouseEvent) : void
		{
		   	initialPanPoint = new Point(stage.mouseX, stage.mouseY);

		   	if(Global.variables.android == true)
			{
		   		showAndroidMoveControl();
		   	}

		   	stage.addEventListener(MouseEvent.MOUSE_MOVE, viewPan);
		   	stage.addEventListener(MouseEvent.MOUSE_UP, viewMouseUp);
		}

		private function viewPan(event : Event)
		{
			//Mouse.cursor ="hand";

			Mouse.hide();
			hand.visible= true;
			hand.startDrag(true);

			render.Rolar(initialPanPoint.x - stage.mouseX, initialPanPoint.y - stage.mouseY);

		   	initialPanPoint.x = stage.mouseX;
		  	initialPanPoint.y = stage.mouseY;
		}

		private function viewMouseUp(event : Event)
		{
		   	stage.removeEventListener(MouseEvent.MOUSE_MOVE, viewPan);
		   	stage.removeEventListener(MouseEvent.MOUSE_UP, viewMouseUp);

		   	hand.visible= false;
		   	Mouse.show();

		   	if(Global.variables.android == true)
			{
		   		hideAndroidMoveControl(true);
		   	}
		   	//Mouse.cursor ="arrow"
		}
		//fim mapa pam

		public function movimentarMapaOut(e:Event = null)
		{
			keyRolamento = null;
		}
		
		public function showAndroidMoveControl(e:Event = null){
			btNorte.visible = true;
			btSul.visible 	= true;
			btLeste.visible = true;
			btOeste.visible = true;

			TweenLite.to(btNorte, 0.5, {alpha: 1});
			TweenLite.to(btSul, 0.5, {alpha: 1});
			TweenLite.to(btLeste, 0.5, {alpha: 1});
			TweenLite.to(btOeste, 0.5, {alpha: 1});

			btNorte.addEventListener(MouseEvent.MOUSE_DOWN, movimentarMapaPress);
			btNorte.addEventListener(MouseEvent.MOUSE_UP , movimentarMapaOut);

			btSul.addEventListener(MouseEvent.MOUSE_DOWN, movimentarMapaPress);
			btSul.addEventListener(MouseEvent.MOUSE_UP , movimentarMapaOut);

			btLeste.addEventListener(MouseEvent.MOUSE_DOWN, movimentarMapaPress);
			btLeste.addEventListener(MouseEvent.MOUSE_UP , movimentarMapaOut);

			btOeste.addEventListener(MouseEvent.MOUSE_DOWN, movimentarMapaPress);
			btOeste.addEventListener(MouseEvent.MOUSE_UP , movimentarMapaOut);	
		}

		

		public function hideAndroidMoveControl(janela:Boolean = false){
			if(janela == false){
				TweenLite.to(btNorte, 0.5, {alpha: 0});
				TweenLite.to(btSul, 0.5, {alpha: 0});
				TweenLite.to(btLeste, 0.5, {alpha: 0});
				TweenLite.to(btOeste, 0.5, {alpha: 0, onComplete:hideListnerMoveControl});
			}
			else
			{
				TweenLite.to(btNorte, 0.5, {alpha: 0, delay:2});
				TweenLite.to(btSul, 0.5, {alpha: 0, delay:2});
				TweenLite.to(btLeste, 0.5, {alpha: 0, delay:2});
				TweenLite.to(btOeste, 0.5, {alpha: 0, onComplete:hideListnerMoveControl, delay:2});
			}
		}

		public function hideListnerMoveControl(e:Event = null){
			btNorte.visible = false;
			btSul.visible 	= false;
			btLeste.visible = false;
			btOeste.visible = false;

			btNorte.removeEventListener(MouseEvent.MOUSE_DOWN, movimentarMapaPress);
			btNorte.removeEventListener(MouseEvent.MOUSE_UP , movimentarMapaOut);

			btSul.removeEventListener(MouseEvent.MOUSE_DOWN, movimentarMapaPress);
			btSul.removeEventListener(MouseEvent.MOUSE_UP , movimentarMapaOut);

			btLeste.removeEventListener(MouseEvent.MOUSE_DOWN, movimentarMapaPress);
			btLeste.removeEventListener(MouseEvent.MOUSE_UP , movimentarMapaOut);

			btOeste.removeEventListener(MouseEvent.MOUSE_DOWN, movimentarMapaPress);
			btOeste.removeEventListener(MouseEvent.MOUSE_UP , movimentarMapaOut);

			keyRolamento = null;
		}

		public function ListenersInterface( ativados: Boolean )
		{
			trace("ListenersInterface: "+ativados);
			
			if( ativados )
			{
				botaoPausa_btn.useHandCursor 			= true;
				adicionar_btn.useHandCursor 			= true;
				mensagem_btn.useHandCursor  			= true;
				mensagem_btn.useHandCursor	 			= true;
				zoomOut_btn.useHandCursor   			= true;
				zoomIn_btn.useHandCursor    			= true;
				salvar_btn.useHandCursor     			= true;
				alterar_visualizacao_btn.useHandCursor  = true;
				barra.visible 							= true;
								
				liberarInterface();

				if(Global.variables.android == true)
				{
					zoomIn_btn.addEventListener(MouseEvent.MOUSE_DOWN, MouseOverZoomIn);
					zoomIn_btn.addEventListener(MouseEvent.MOUSE_UP , MouseOutZoomIn);
					zoomIn_btn.addEventListener(MouseEvent.CLICK , ZoomInOut);
					
					zoomOut_btn.addEventListener(MouseEvent.MOUSE_DOWN, MouseOverZoomOut);
					zoomOut_btn.addEventListener(MouseEvent.MOUSE_UP , MouseOutZoomOut);
					zoomOut_btn.addEventListener(MouseEvent.CLICK, ZoomInOut);
				}
				else
				{
					
					zoomIn_btn.addEventListener(MouseEvent.MOUSE_OVER, MouseOverZoomIn);
					zoomIn_btn.addEventListener(MouseEvent.MOUSE_OUT , MouseOutZoomIn);
					zoomIn_btn.addEventListener(MouseEvent.CLICK , ZoomInOut);
					
					zoomOut_btn.addEventListener(MouseEvent.MOUSE_OVER, MouseOverZoomOut);
					zoomOut_btn.addEventListener(MouseEvent.MOUSE_OUT , MouseOutZoomOut);
					zoomOut_btn.addEventListener(MouseEvent.CLICK, ZoomInOut);
				}

				container_mc.addEventListener(TransformGestureEvent.GESTURE_ZOOM, onZoom);
				container_mc.addEventListener(MouseEvent.MOUSE_WHEEL, WhellZoom);
				container_mc.addEventListener(MouseEvent.MOUSE_DOWN, mapaPam);

				if(Global.variables.modoEditor == true){
					barra.visible = true;
					//nomeDoMapa.visible = true;

					salvar_btn.visible = true;

					if(Global.variables.android == true)
					{ 
						salvar_btn.addEventListener(MouseEvent.MOUSE_DOWN, MouseOverSalvar);
						salvar_btn.addEventListener(MouseEvent.MOUSE_UP , MouseOutSalvar);
						salvar_btn.addEventListener(MouseEvent.CLICK, Salvar);
					}
					else
					{
						salvar_btn.addEventListener(MouseEvent.MOUSE_OVER, MouseOverSalvar);
						salvar_btn.addEventListener(MouseEvent.MOUSE_OUT , MouseOutSalvar);
						salvar_btn.addEventListener(MouseEvent.CLICK, Salvar);
					}

					if( Arquivo.ExisteArquivo(Arquivo.GetPastaAplicacao(false) + 'data' + Arquivo.GetSeparador() + 'texturas' + Arquivo.GetSeparador() + Global.variables.faseConstrucao +'-satellite.jpg', false) && Arquivo.ExisteArquivo(Arquivo.GetPastaAplicacao(false) + 'data' + Arquivo.GetSeparador() + 'texturas' + Arquivo.GetSeparador() + Global.variables.faseConstrucao +'-terrain.jpg', false) && Arquivo.ExisteArquivo(Arquivo.GetPastaAplicacao(false) + 'data' + Arquivo.GetSeparador() + 'texturas' + Arquivo.GetSeparador() + Global.variables.faseConstrucao +'-hybrid.jpg', false) ){
						alterar_visualizacao_btn.visible = true;

						if(Global.variables.android == true)
						{
							alterar_visualizacao_btn.addEventListener(MouseEvent.MOUSE_DOWN, MouseOverAlterarVisualizacao);
							alterar_visualizacao_btn.addEventListener(MouseEvent.MOUSE_UP , MouseOutAlterarVisualizacao);
							alterar_visualizacao_btn.addEventListener(MouseEvent.CLICK, AbrirPainelVisualizacao);
						}
						else
						{
							alterar_visualizacao_btn.addEventListener(MouseEvent.MOUSE_OVER, MouseOverAlterarVisualizacao);
							alterar_visualizacao_btn.addEventListener(MouseEvent.MOUSE_OUT , MouseOutAlterarVisualizacao);
							alterar_visualizacao_btn.addEventListener(MouseEvent.CLICK, AbrirPainelVisualizacao);
						}
					} else {
						alterar_visualizacao_btn.visible = false;
					}
				} else {
					salvar_btn.visible = false;
					alterar_visualizacao_btn.visible = false;
					barra.visible = false;
					
					//nomeDoMapa.visible = false;
				}
			}

			
		}

		public function checkKeypress(event:KeyboardEvent):void
		{
			switch (event.keyCode)
		 	{
				case Keyboard.BACK:
					event.preventDefault();
					
					if(estadoInterface == (ESTADO_MENU_PRINCIPAL || ESTADO_CARREGAR_JOGO || ESTADO_CONFIGURACOES || ESTADO_CARREGANDO) ){
						Sair();
					} else {				
						switch (estadoInterface)
						{
							case ESTADO_GAMEPLAY					: Pausar(); break;
							case ESTADO_PAUSA						: Continuar(null); break;
							case ESTADO_MENU_ADICIONAR_CONSTRUCAO	: OcultarMenuConstrucao(null); break;
							case ESTADO_MENSAGENS					: OcultarMensagens(null); break;
							case ESTADO_CARTA_VOADORA				: cartaVoadora_mc.ocultarMenu(null); break;
							case ESTADO_CONFIGURACOES				: OcultarConfig(null); break;
						}
					}
					
					break;
				
			}
		} 
		
		// Esses eventos são criados apenas uma vez, afinal, servem para todas as fases.
		function CriarListeners()
		{
			stage.addEventListener(MouseEvent.CLICK, MouseClick);
			
			simulador.addEventListener(EventoSimulador.MENSAGEM			   , ReceberMensagem);
			
			simulador.addEventListener(EventoSimulador.TURNO			   , AtualizaTurno);
			simulador.addEventListener(EventoSimulador.INDICE			   , AtualizaIndice);
			simulador.addEventListener(EventoSimulador.DESEMPENHO		   , AtualizaBarraDesempenho);
			simulador.addEventListener(EventoSimulador.POPULACAO		   , MudancaPopulacao);
			simulador.addEventListener(EventoSimulador.HABITADOS		   , MudancaHabitados);
			simulador.addEventListener(EventoSimulador.EMPREGADOS		   , MudancaEmpregados);
			simulador.addEventListener(EventoSimulador.PROGRESSO_TURNO 	   , ProgressoTurno);
			simulador.addEventListener(EventoSimulador.ATUALIZAR_CONSTRUCAO, MenuAtualizarConstrucao);
			simulador.addEventListener(EventoSimulador.CONSTRUCAO_PRONTA   , ConstrucaoFinalizada);
			simulador.addEventListener(EventoSimulador.FIM_CONSERTO 	   , ConstrucaoFinalizada);
			
			simulador.addEventListener(EventoSimulador.DINHEIRO	, MudancaDinheiro);
			//simulador.addEventListener(EventoSimulador.CHUVA	, Chuva);
			//simulador.addEventListener(EventoSimulador.SOL		, Sol);
			
			//simulador.addEventListener(EventoSimulador.TRANSITO	, Transito);
			
			simulador.addEventListener(EventoSimulador.ATUALIZAR_META	, AtualizarMeta);
			simulador.addEventListener(EventoSimulador.FIM_META			, FimMeta);
			
			//simulador.addEventListener(EventoSimulador.DESASTRE			, Desastre);
			
			simulador.addEventListener(EventoSimulador.ATUALIZAR_XP					, AtualizarXPs);
			simulador.addEventListener(EventoSimulador.ATUALIZAR_NIVEL_JOGADOR		, AtualizarNivelJogador);			
			
			simulador.addEventListener(EventoSimulador.INICIO_CONSERTO		, InicioConserto);
			simulador.addEventListener(EventoSimulador.FIM_CONSERTO			, FimConserto);			
			
			if( Global.variables.android == true )
			{
				populacao_mc.addEventListener(MouseEvent.MOUSE_DOWN, MouseOver);
				populacao_mc.addEventListener(MouseEvent.MOUSE_UP , MouseOut);

				habitados_mc.addEventListener(MouseEvent.MOUSE_DOWN, MouseOver);
				habitados_mc.addEventListener(MouseEvent.MOUSE_UP , MouseOut);

				empregados_mc.addEventListener(MouseEvent.MOUSE_DOWN, MouseOver);
				empregados_mc.addEventListener(MouseEvent.MOUSE_UP , MouseOut);

				dinheiro_mc.addEventListener(MouseEvent.MOUSE_DOWN, MouseOver);
				dinheiro_mc.addEventListener(MouseEvent.MOUSE_UP , MouseOut);
				
				pontos_mc.addEventListener(MouseEvent.MOUSE_DOWN, MouseOver);
				pontos_mc.addEventListener(MouseEvent.MOUSE_UP , MouseOut);
			}
			else
			{
				populacao_mc.addEventListener(MouseEvent.MOUSE_OVER, MouseOver);
				populacao_mc.addEventListener(MouseEvent.MOUSE_OUT , MouseOut);

				habitados_mc.addEventListener(MouseEvent.MOUSE_OVER, MouseOver);
				habitados_mc.addEventListener(MouseEvent.MOUSE_OUT , MouseOut);

				empregados_mc.addEventListener(MouseEvent.MOUSE_OVER, MouseOver);
				empregados_mc.addEventListener(MouseEvent.MOUSE_OUT , MouseOut);

				dinheiro_mc.addEventListener(MouseEvent.MOUSE_OVER, MouseOver);
				dinheiro_mc.addEventListener(MouseEvent.MOUSE_OUT , MouseOut);

				pontos_mc.addEventListener(MouseEvent.MOUSE_OVER, MouseOver);
				pontos_mc.addEventListener(MouseEvent.MOUSE_OUT , MouseOut);
			}
			
			// Construção será destruída por eventos?
			//simulador.addEventListener(EventoSimulador.CONSTRUCAO_DESTRUIDA	, ConstrucaoDestruida);			
			
			eventosCriadosI = true;
		}

		function MouseOutPausa(evt)
		{
			//descricaoPausa_mc.visible = false;
		}
		
		function MouseOverPausa(evt)
		{
			//descricaoPausa_mc.visible = true;
		}
		
		function MouseOverMsg(evt)
		{
			tooltipMsg_mc.visible = true;
		}
		
		function MouseOutMsg(evt)
		{
			tooltipMsg_mc.visible = false;
		}
		
		function MouseOverAdicionar(evt)
		{
			tooltipConstrucoes_mc.visible = true;
		}
		
		function MouseOutAdicionar(evt)
		{
			tooltipConstrucoes_mc.visible = false;
		}
		
		function MouseOverCarta(evt)
		{
			tooltipCartaVoadora_mc.visible = true;
		}
		
		function MouseOutCarta(evt)
		{
			tooltipCartaVoadora_mc.visible = false;
		}
		
		function MouseOverZoomIn(evt)
		{
			tooltipZoomIn.visible = true;
		}
		
		function MouseOutZoomIn(evt)
		{
			tooltipZoomIn.visible = false;
		}
		
		function MouseOverZoomOut(evt)
		{
			tooltipZoomOut.visible = true;
		}
		
		function MouseOutZoomOut(evt)
		{
			tooltipZoomOut.visible = false;
		}
		
		function MouseOverConfiguracoes(evt)
		{
			tooltipConfiguracoes.visible = true;
		}
		
		function MouseOutConfiguracoes(evt)
		{
			tooltipConfiguracoes.visible = false;
		}

		function MouseOverSalvar(evt)
		{
			tooltipSalvar.visible = true;
		}
		
		function MouseOutSalvar(evt)
		{
			tooltipSalvar.visible = false;
		}

		function MouseOverAlterarVisualizacao(evt)
		{
			tooltipAlterarVisualizacao.visible = true;
		}
		
		function MouseOutAlterarVisualizacao(evt)
		{
			tooltipAlterarVisualizacao.visible = false;
		}

		function AbrirPainelVisualizacao(evt = null)
		{
			if( Global.variables.android == true ){ hideAndroidMoveControl(); }				

			menu_visualizacao.visible = true;
			tooltipAlterarVisualizacao.visible = false;

			menu_visualizacao.btn_rotas.addEventListener(MouseEvent.CLICK, AlterarVisualizacao);
			menu_visualizacao.btn_satelite.addEventListener(MouseEvent.CLICK, AlterarVisualizacao);
			menu_visualizacao.btn_tereno.addEventListener(MouseEvent.CLICK, AlterarVisualizacao);
			menu_visualizacao.btn_hibrido.addEventListener(MouseEvent.CLICK, AlterarVisualizacao);

			if(Global.variables.android == true)
			{
				alterar_visualizacao_btn.removeEventListener(MouseEvent.MOUSE_DOWN, MouseOverAlterarVisualizacao);
				alterar_visualizacao_btn.removeEventListener(MouseEvent.MOUSE_UP , MouseOutAlterarVisualizacao);
				alterar_visualizacao_btn.removeEventListener(MouseEvent.CLICK, AbrirPainelVisualizacao);
			}

		}

		function OcultarPainelVisualizacao(evt = null){
			menu_visualizacao.visible = false;

			menu_visualizacao.btn_rotas.removeEventListener(MouseEvent.CLICK, AlterarVisualizacao);
			menu_visualizacao.btn_satelite.removeEventListener(MouseEvent.CLICK, AlterarVisualizacao);
			menu_visualizacao.btn_tereno.removeEventListener(MouseEvent.CLICK, AlterarVisualizacao);
			menu_visualizacao.btn_hibrido.removeEventListener(MouseEvent.CLICK, AlterarVisualizacao);

			if(Global.variables.android == true)
			{
				alterar_visualizacao_btn.doubleClickEnabled=true; 
				alterar_visualizacao_btn.addEventListener(MouseEvent.MOUSE_DOWN, MouseOverAlterarVisualizacao);
				alterar_visualizacao_btn.addEventListener(MouseEvent.MOUSE_UP , MouseOutAlterarVisualizacao);
				alterar_visualizacao_btn.addEventListener(MouseEvent.CLICK, AbrirPainelVisualizacao);
			}
		}

		var loaderMap = new Loader();

		function AlterarVisualizacao(evt = null){
			MudarEstadoInterface(ESTADO_PAUSA);

			OcultarTodas();

			TweenLite.to(fade_mc, 0.5, {alpha: 1});
			TweenLite.to(fadeSuperior_mc, 0.5, {alpha: 1})
			processar_mv.visible = true;

			loaderMap.contentLoaderInfo.addEventListener( Event.COMPLETE, alteraTextura );

			if( evt.target.name == "btn_rotas" ){
				//loaderMap.load( new URLRequest( simulador.GetFase().texturas[0].caminho + "&tipo=roadmap" ) );
				//loaderMap.load( new URLRequest( Arquivo.GetPastaAplicacao(false) + 'data' + Arquivo.GetSeparador() + 'texturas' + Arquivo.GetSeparador() + Global.variables.faseConstrucao +'.jpg' ) );
				loaderMap.load( new URLRequest( Arquivo.enderecamento( Arquivo.GetPastaAplicacao(false) + 'data' + Arquivo.GetSeparador() + 'texturas' + Arquivo.GetSeparador() + Global.variables.faseConstrucao +'.jpg' )) );
			}

			if( evt.target.name == "btn_satelite" ){
				//loaderMap.load( new URLRequest( simulador.GetFase().texturas[0].caminho + "&tipo=satellite" ) );
				//loaderMap.load( new URLRequest( Arquivo.GetPastaAplicacao(false) + 'data' + Arquivo.GetSeparador() + 'texturas' + Arquivo.GetSeparador() + Global.variables.faseConstrucao +'-satellite.jpg' ) );
				loaderMap.load( new URLRequest( Arquivo.enderecamento( Arquivo.GetPastaAplicacao(false) + 'data' + Arquivo.GetSeparador() + 'texturas' + Arquivo.GetSeparador() + Global.variables.faseConstrucao +'-satellite.jpg' )) );
			}

			if( evt.target.name == "btn_tereno" ){
				//loaderMap.load( new URLRequest( simulador.GetFase().texturas[0].caminho + "&tipo=terrain" ) );
				//loaderMap.load( new URLRequest( Arquivo.GetPastaAplicacao(false) + 'data' + Arquivo.GetSeparador() + 'texturas' + Arquivo.GetSeparador() + Global.variables.faseConstrucao +'-terrain.jpg' ) );
				loaderMap.load( new URLRequest( Arquivo.enderecamento( Arquivo.GetPastaAplicacao(false) + 'data' + Arquivo.GetSeparador() + 'texturas' + Arquivo.GetSeparador() + Global.variables.faseConstrucao +'-terrain.jpg' )) );
			}

			if( evt.target.name == "btn_hibrido" ){
				//loaderMap.load( new URLRequest( simulador.GetFase().texturas[0].caminho + "&tipo=hybrid" ) );
				//loaderMap.load( new URLRequest( Arquivo.GetPastaAplicacao(false) + 'data' + Arquivo.GetSeparador() + 'texturas' + Arquivo.GetSeparador() + Global.variables.faseConstrucao +'-hybrid.jpg' ) );
				loaderMap.load( new URLRequest( Arquivo.enderecamento( Arquivo.GetPastaAplicacao(false) + 'data' + Arquivo.GetSeparador() + 'texturas' + Arquivo.GetSeparador() + Global.variables.faseConstrucao +'-hybrid.jpg' )) );
			}

			TweenLite.to(fade_mc, 4, {autoAlpha: 0, onComplete:OcultarPainelVisualizacao });
			TweenLite.to(fadeSuperior_mc, 4, {autoAlpha: 0, onComplete:fimSalvar });
		}

		function alteraTextura(evt)
		{
			var textura = evt.target.loader.content;	
			simulador.GetFase().texturas[0].textura = textura;

			render.ExibirTexturaPersonalizada(simulador.GetFase().texturas[0]);
		}
		
		function Salvar(evt)
		{
			tooltipSalvar.visible = false;

			MudarEstadoInterface(ESTADO_PAUSA);

			OcultarTodas();

			TweenLite.to(fade_mc, 0.5, {alpha: 1});
			TweenLite.to(fadeSuperior_mc, 0.5, {alpha: 1})
			processar_mv.visible = true;	

			pausarSimulacaoJanela();		
			SalvarConstrucaoArquivo(0);

			TweenLite.to(fade_mc, 4, {autoAlpha: 0});
			TweenLite.to(fadeSuperior_mc, 4, {autoAlpha: 0, onComplete:fimSalvar});
		}

		function fimSalvar()
		{
			MudarEstadoInterface(ESTADO_GAMEPLAY);

			processar_mv.visible = false;	

			continuarSimulacaoJanela();			
		}

		//----------------------------------------
		// <4> Encerrando alguma fase.
		//----------------------------------------
		
		function SairJogo(evt = null)
		{	
			ConfigurarModoNormal();
			EncerrarSons();
			EncerrarJogo(true);
			MudarEstadoInterface(ESTADO_MENU_PRINCIPAL);
			TweenLite.to(menu_mc, 1, {autoAlpha: 1});
			TweenLite.to(fadeSuperior_mc, 0.5, {autoAlpha: 0});
			TweenLite.to(pausa_mc, 0.5, {autoAlpha: 0});
		}
				
		function EncerrarJogo( gameOver: Boolean )
		{
//			simulador.SetVariavel("etapaTutorial", "1");
//			simulador.SetVariavel("poucoDinheiro", "1");
			
			/********* Encerramento da fase atual **********/
			stage.removeEventListener(Event.ENTER_FRAME, OnEnterFrame);

			seletor = null; // ao remover os carros, acabo removendo também o seletor do grid
			
			//EncerrarSons();
			
			var emissores = dataLoader.GetEmissores();			
			for(var i = 0; i < emissores.length; i++) emissores[i].EncerrarSom();
			
			OcultarTodas();

						
			/********** Início de uma nova fase caso não seja game over ********/
			var numeroProximaFase = dataLoader.GetFase().GetNumero() + 1;
			var caminho = /*Arquivo.GetPastaAplicacao() +*/ "data" + Arquivo.GetSeparador() + "fases" + Arquivo.GetSeparador() + "fase" + numeroProximaFase + ".xml";
			if( !gameOver )
			{
				if( Arquivo.ExisteArquivo( caminho ))
				{
					render.Encerrar();

					MudarEstadoInterface(ESTADO_CARREGANDO);
					IniciarJogo("fase" + numeroProximaFase + ".xml");
				}
				else
				{
					gestorSom.Reproduzir('fase-completa');
					TweenLite.to(fimJogo_mc, 1, {autoAlpha: 1}); //acabou o jogo!! =)
				}
			}
			mensagens_mc.text_txt.htmlText = "";
		}
		
		function EncerrarSons()
		{
			gestorSom.PararTudo();
			var emissores = dataLoader.GetEmissores();			
			for(var i = 0; i < emissores.length; i++) emissores[i].PararSom();
			
			var estruturas = dataLoader.GetEstruturas();
			for(i = 0; i < estruturas.length; i++)
			{
				var somPopup = dataLoader.GetSomPopup(estruturas[i].GetNome());
				if(somPopup) somPopup.Stop();
			}
			
			simulador.GetFase().GetMusica().Stop();
		}
		
		function OcultarTodas()
		{
			aplicacaoAtiva  = true;
			fade_mc.alpha 	= 0;
			fadeSuperior_mc.alpha = 0;
			fade_mc.visible	= false;
			
			//passagem2_mc.visible = false;
			adicionar_mc.visible = false;
			mensagens_mc.visible = false;
			atualizar_mc.visible = false;
			
			if(cartaVoadora_mc.visible == true){
				cartaVoadora_mc.ocultarMenu(null);
				cartaVoadora_mc.visible = false;
			}
		}
		
		public function FimFase()
		{
			if(timerMouse != null)
				timerMouse.stop();
			timerMouse = null;
			OcultarTodas();
			EncerrarSons();
			gestorSom.Reproduzir( 'fase-completa' );
			TweenLite.to(fadeSuperior_mc, 0.5, {autoAlpha: 1});
			
			var index = dataLoader.GetFase().GetNumero();
			
			if(index < 3) // são 2 fazes com password, a 3ª terceira só tem texto de conclusão.
			{
				TweenLite.to(passagem_mc, 1, {autoAlpha: 1});
				passagem_mc.mensagem_txt.text = palavrasChave[index-1].text;
				passagem_mc.password_mc.codigo_txt.text = palavrasChave[index-1].key;
				passagem_mc.password_mc.visible = true;
			} else {
				OcultarTelaPassagem();
			}

			//MudarEstadoInterface( ESTADO_PAUSA );
			//simulador.PausarSimulacao();

			pausarSimulacaoJanela();
		}
		
		//-------------------------------------------------------
		// <5> Events Handlers Parte I : Janelas, telas e menu
		//-------------------------------------------------------
		
		function VoltarMenu(evt)
		{
			MudarEstadoInterface(ESTADO_MENU_PRINCIPAL);
			TweenLite.to(gameOver_mc, 1, {autoAlpha: 0});
			TweenLite.to(fimJogo_mc, 1, {autoAlpha: 0});
			TweenLite.to(menu_mc, 1, {autoAlpha: 1});
		}
		
		public function NovoJogo(evt)
		{
			gestorSom.Reproduzir( 'click-diferenciado' );
//			selecaoPers_mc.nome_txt.text = "";
//			TweenLite.to(selecaoPers_mc, 1, {autoAlpha: 0});
			TweenLite.to(menu_mc, 1, {autoAlpha: 0});
			TweenLite.to(carregar_mc, 1, {autoAlpha: 0});
			
			if(faseACarregar == null)
			{
				IniciarJogo("fase1.xml");
			}
			else
			{
				IniciarJogo(faseACarregar);
				faseACarregar = null;
			}
		}
		
		public function PrepComecarJogo()
		{
			SetVisibilidadeInicial();
			
//			TweenLite.to(selecaoPers_mc, 1, {autoAlpha: 0});
			TweenLite.to(menu_mc, 0, {autoAlpha: 0});
			TweenLite.to(carregar_mc, 0, {autoAlpha: 0});
		}
		
		public function NovoJogo2(evt)
		{
			render.Encerrar();

			bussola_mc.desmarcarPedras();

			gestorSom.Reproduzir( 'click-diferenciado' );
			TweenLite.to(fimJogo_mc, 1, {autoAlpha: 0});

			NovoJogo(null);
		}
		
		function ReiniciarJogo(evt)
		{
			render.Encerrar();
			
			gestorSom.Reproduzir( 'click-diferenciado' );
			TweenLite.to(gameOver_mc, 1, {autoAlpha: 0});

			IniciarJogo("fase" + dataLoader.GetFase().GetNumero() + ".xml");
		}
		
		public function MostrarConfiguracoes(evt = null)
		{
			MudarEstadoInterface(ESTADO_CONFIGURACOES);
			configuracao_mc.alpha = 0;
			TweenLite.to(configuracao_mc, 1, {autoAlpha: 1});

			configuracao_mc.codigo_txt.text = '';
			configuracao_mc.alerta_txt.text = '';
		}
		
		public function AbrirTelaCarregar(evt)
		{
			gestorSom.Parar( 'musica-menu-principal');
			gestorSom.Reproduzir( 'musica-password' , 99999999);
			MudarEstadoInterface(ESTADO_CARREGAR_JOGO);
			carregar_mc.codigo_txt.text = "";
			carregar_mc.alerta_txt.text = "";

			if(Global.variables.android == true)
			{
				carregar_mc.codigo_txt.requestSoftKeyboard();
				carregar_mc.codigo_txt.needsSoftKeyboard = true;
			}

			carregar_mc.alpha = 0;
			TweenLite.to(carregar_mc, 1, {autoAlpha: 1});
		}
				
		public function MostrarCreditos(evt = null)
		{
			creditos_mc.abrir();
		}
		
		public function MostrarTutorial(evt = null)
		{
			tutorial_mc.abrir();
		}

		public function MostrarConstruirCidade(evt = null)
		{
			construirCidade_mc.abrir();
		}

		public function MostrarKamplus(evt = null)
		{
			kamplus_mc.abrir();
		}
		
		function OcultarConfig(evt = null)
		{
			SalvarOpcoes();
			MudarEstadoInterface(estadoAnterior);
			TweenLite.to(configuracao_mc, 1, {autoAlpha: 0});
		}
		
		function OcultarCarregarJogo(evt = null)
		{
			gestorSom.Parar( 'musica-password');
			
			MudarEstadoInterface(ESTADO_MENU_PRINCIPAL);
			TweenLite.to(carregar_mc, 1, {autoAlpha: 0});
		}
		
		function MudarQualidade(evt)
		{
			if(evt.currentTarget.name == 'qualidadeBaixa_btn'){
				trace('baixa');
				stage.quality = StageQuality.LOW;
				qualidadeGlobal = 'LOW';
			}
			
			if(evt.currentTarget.name == 'qualidadeMedia_btn'){
				trace('media')
				stage.quality = StageQuality.MEDIUM;
				qualidadeGlobal = 'MEDIUM';
			}
			
			if(evt.currentTarget.name == 'qualidadeAlta_btn'){
				trace('alta');
				stage.quality = StageQuality.HIGH;
				qualidadeGlobal = 'HIGH';
			}
		}

		function LeituraCartas(evt)
		{
			//limpar
			cartaVoadora_mc.bt_limpar.addEventListener( MouseEvent.CLICK, LimparCarta );
			
			if(configuracao_mc.codigo_txt.text == 'arquivodaniel01')
			{
				cartaVoadora_mc.mostrarCarta('cartaFase1', false);

				if(Global.variables.android == true)
				{
					cartaVoadora_mc.caixa_txt.requestSoftKeyboard();
					cartaVoadora_mc.caixa_txt.needsSoftKeyboard = true;
				}

				cartaVoadora_mc.bt_limpar.visible = true;
			}

			else if(configuracao_mc.codigo_txt.text == 'arquivodaniel02')
			{
				cartaVoadora_mc.mostrarCarta('cartaFase2', false);

				if(Global.variables.android == true)
				{
					cartaVoadora_mc.caixa_txt.requestSoftKeyboard();
					cartaVoadora_mc.caixa_txt.needsSoftKeyboard = true;
				}

				cartaVoadora_mc.bt_limpar.visible = true;
			}

			else if(configuracao_mc.codigo_txt.text == 'anotacoes')
			{
				cartaVoadora_mc.mostrarCarta('carta', false);

				if(Global.variables.android == true)
				{
					cartaVoadora_mc.caixa_txt.requestSoftKeyboard();
					cartaVoadora_mc.caixa_txt.needsSoftKeyboard = true;
				}

				cartaVoadora_mc.bt_limpar.visible = true;
			}

			else
			{
				configuracao_mc.alerta_txt.text = 'Insira um código valido!';
			}
		}
		
		// Opções de formato janela e formato tela cheia
		function FormatoJanela(evt)
		{
			stage.displayState = StageDisplayState.NORMAL; 
			janelaGlobal = 'NORMAL';
			
		}
		
		function FormatoTelaCheia(evt)
		{
			//stage.displayState = StageDisplayState.FULL_SCREEN; 
			stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
			janelaGlobal = 'FULL_SCREEN';
	
		}
		
		function ValidarCodigo(evt)
		{
			var codigo = carregar_mc.codigo_txt.text;
			
			var resultado = CompararChave(codigo);
			if(resultado.ok && codigo != '')
			{
				ConfigurarModoNormal();
				faseACarregar = resultado.fase;
				gestorSom.Parar('musica-password');
				carregar_mc.codigo_txt.text = "";
				carregar_mc.alerta_txt.text = "";
				NovoJogo(null);

			}
			else
			{
				carregar_mc.alerta_txt.text = "Insira um código valido!";
			}
		}
		
		//----------------------------------------------------
		// <6> Events Handlers Parte II : Interface Gampeplay
		//----------------------------------------------------
		
		// Interface em geral:
		
		function AtualizarXPs(evt)
		{
			var proximaFrame = Math.floor(evt.data.perc * 16);
			//nivelJogador_mc.setor_mc.gotoAndStop(proximaFrame);
			AtualizarPontuacao(evt);
		}
		
		function AtualizarPontuacao(evt)
		{
			var quantidade = pontuacaoObj.quantidade + Number(evt.data.pontos);
			trace("g - XP: "+quantidade);
			TweenLite.to(pontuacaoObj, 3, {quantidade: quantidade, onUpdate: PontuacaoOnUpdate});
		}
		
		function PontuacaoOnUpdate()
		{
			pontos_mc.montante_txt.text = Math.round(pontuacaoObj.quantidade);
		}
		
		function AtualizarNivelJogador(evt)
		{
			if((simulador.GetVariavel("etapaTutorial") == "8") && (evt.data.nivel == 3))
			{
				cronometroMsgTutorial.Iniciar();
				simulador.SetVariavel("etapaTutorial", "9");
			}
			//if(evt.data.nivel < 10) nivelJogador_mc.nivel_txt.text = "0" + evt.data.nivel;
			//else nivelJogador_mc.nivel_txt.text = evt.data.nivel;
		}
		
		function MudancaDinheiro(evt)
		{
			var quantidade 	= Number(evt.data.quantidade);
			TweenLite.to(dinheiroObj, 3, {quantidade: quantidade, onUpdate: DinheiroOnUpdate});
			//MudancaDinheiroEmprestimo(evt.data.emprestimo);
		}
		
		function DinheiroOnUpdate()
		{
			dinheiro_mc.montante_txt.text = NumberFormat.FormatCurrency( dinheiroObj.quantidade, 2, ',' , '.', 'K$ ' );
		}
		
		function MudancaPopulacao(evt)
		{
			var populacao : int					= evt.data.populacao;
			TweenLite.to(populacaoObj, 3, {populacao: populacao, onUpdate: PopulacaoOnUpdate});
		}
		
		function PopulacaoOnUpdate()
		{
			populacao_mc.quantidade_txt.text =  Math.round(populacaoObj.populacao);
		}
		
		function MudancaHabitados(evt)
		{
			var habitados : int					= evt.data.habitados;
			TweenLite.to(habitadosObj, 3, {habitados: habitados, onUpdate: HabitadosOnUpdate});
		}
		
		function HabitadosOnUpdate()
		{
			habitados_mc.quantidade_txt.text =  Math.round(habitadosObj.habitados);
		}
		
		function MudancaEmpregados(evt)
		{
			var empregados : int					= evt.data.empregados;
			TweenLite.to(empregadosObj, 3, {empregados: empregados, onUpdate: EmpregadosOnUpdate});
		}
		
		function EmpregadosOnUpdate()
		{
			empregados_mc.quantidade_txt.text =  Math.round(empregadosObj.empregados);
		}
		
		function Chuva(evt)
		{
			TweenLite.to(clima_mc, 0.4, {alpha: 0.3, onComplete: Chuva2});
		}
		
		function Chuva2()
		{
			tempo = "chuva";
			gestorSom.Reproduzir('trovao');
			gestorSom.Reproduzir('chuva', 9999999, true);
			var rain:Rain = new Rain();
			rain.init(200, 50, 5, 1024, 768, "left");
			containerClima_mc.addChild(rain);
		}
		
		function Sol(evt)
		{
			tempo = "sol";
			gestorSom.Parar( 'chuva', true);
			while (containerClima_mc.numChildren > 0) containerClima_mc.removeChildAt(0);
			TweenLite.to(clima_mc, 0.4, {alpha: 0});
		}
		
		function Transito(evt)
		{
//			if( indexTransito == 1 )
//			{
//				gestorSom.Reproduzir('transito1');
//				indexTransito++;
//			}
//			else
//			{
//				gestorSom.Reproduzir('transito2');
//				indexTransito--;
//			}
		}
		
		function MudancaOpcao(evt)
		{	
			if (evt.movie.name == "slider_mc")
			{
				opcoes.volume 	= evt.value;
				var volumeChuva = evt.value * 0.3;
				gestorSom.SetVolumeGrupo('efeitos_climaticos', volumeChuva);
				gestorSom.SetVolumeGrupo('efeitos', evt.value);
				gestorSom.SetVolumeGrupo('musicas', evt.value);
				
				if(estadoAnterior == ESTADO_PAUSA)
				{
					simulador.GetFase().GetMusica().SetVolume( evt.value );
				}
			}
		}
		
		function MudarVolume(evt)
		{
			if(evt.currentTarget.name == "som_btn")
			{
				opcoes.volume = 1;
				configuracao_mc.slider_mc.botao_mc.x = 360;
			}
			else if(evt.currentTarget.name == "muteSound_btn")
			{
				opcoes.volume = 0;
				configuracao_mc.slider_mc.botao_mc.x = 0;
			}
			
			var volumeChuva = opcoes.volume * 0.3;
			gestorSom.SetVolumeGrupo('efeitos_climaticos', volumeChuva);
			gestorSom.SetVolumeGrupo('efeitos', opcoes.volume);			
			gestorSom.SetVolumeGrupo('musicas', opcoes.volume);
			
			if(estadoAnterior == ESTADO_PAUSA)
			{
				simulador.GetFase().GetMusica().SetVolume( opcoes.volume );
			}
		}
		
		function MudarIndice(evt)
		{
			switch(evt.target.name)
			{
				case "educacao_btn"	: indice = "Educação"; break;
				case "seguranca_btn": indice = "Segurança";	break;
				case "moradia_btn"	: indice = "Moradia"; break;
				case "comercio_btn"	: indice = "Comércio"; break;
				case "lazer_btn"	: indice = "Lazer"; break;
				case "infraestrutura_btn"	: indice = "Infraestrutura"; break;
				case "copa_btn"		: indice = "Copa"; break;
			}
			
			adicionar_mc.balao_mc.x = evt.target.x;
			adicionar_mc.balao_mc.y = evt.target.y;				
			ExibirMenuAdicionarEstrutura();
		}
		
		function ZoomInOut(evt)
		{
			tooltipZoomIn.visible = false;
			tooltipZoomOut.visible = false;

			evt.stopPropagation();
			
			if (render.IsZooming()) return;
			
			if (evt.target == zoomIn_btn) 	zoomIndex++;
			else 							zoomIndex--;
			
			if (zoomIndex < 0) 
			{
				zoomIndex = 0;
				return ;
			}
			else if (zoomIndex >= zoomFactors.length)
			{
				zoomIndex = zoomFactors.length - 1;
				return ;
			}
			
			if(zoomIndex >= 3)	// sons vão se tornar audíveis
			{
				gestorSom.SetVolumeGrupo('efeitos', opcoes.volume);
				dataLoader.SetVolumeSomPopup( opcoes.volume );
			}
			else	// sons vão se tornar inaudíveis
			{
				var emissores = dataLoader.GetEmissores();
				for(var i = 0; i < emissores.length; i++)
				{
					emissores[i].GetSom().SetVolume(0);
				}
				dataLoader.SetVolumeSomPopup( 0 );
				gestorSom.SetVolumeGrupo('efeitos', 0);
			}
			
			render.SetZoom( zoomFactors[zoomIndex] );
		}

		function WhellZoom(event:MouseEvent){
			event.stopPropagation();

			trace('zoom scrooll ' + event.delta);

			if (render.IsZooming()) return;

			if ( event.delta > 0 ) {
				zoomIndex++;
			}

			if ( event.delta < 0 ) {
				zoomIndex--;
			}

			if (zoomIndex < 0) 
			{
				zoomIndex = 0;
				return ;
			}
			else if (zoomIndex >= zoomFactors.length)
			{
				zoomIndex = zoomFactors.length - 1;
				return ;
			}
			
			if(zoomIndex >= 3)	// sons vão se tornar audíveis
			{
				gestorSom.SetVolumeGrupo('efeitos', opcoes.volume);
				dataLoader.SetVolumeSomPopup( opcoes.volume );
			}
			else	// sons vão se tornar inaudíveis
			{
				var emissores = dataLoader.GetEmissores();
				for(var i = 0; i < emissores.length; i++)
				{
					emissores[i].GetSom().SetVolume(0);
				}
				dataLoader.SetVolumeSomPopup( 0 );
				gestorSom.SetVolumeGrupo('efeitos', 0);
			}
			
			render.SetZoom( zoomFactors[zoomIndex] );
		}

		function onZoom(event:TransformGestureEvent):void
		{
			trace("zoom taps "+ event.scaleX);

		    if (render.IsZooming()) return;

			zoomIndex = event.scaleX;
			
			if (zoomIndex < 0) 
			{
				zoomIndex = 0;
				return ;
			}
			else if (zoomIndex >= zoomFactors.length)
			{
				zoomIndex = zoomFactors.length - 1;
				return ;
			}
			
			if(zoomIndex >= 3)	// sons vão se tornar audíveis
			{
				gestorSom.SetVolumeGrupo('efeitos', opcoes.volume);
				dataLoader.SetVolumeSomPopup( opcoes.volume );
			}
			else	// sons vão se tornar inaudíveis
			{
				var emissores = dataLoader.GetEmissores();
				for(var i = 0; i < emissores.length; i++)
				{
					emissores[i].GetSom().SetVolume(0);
				}
				dataLoader.SetVolumeSomPopup( 0 );
				gestorSom.SetVolumeGrupo('efeitos', 0);
			}
			
			render.SetZoom( zoomFactors[zoomIndex] );
		}
		
		function MouseOverBotao(evt)
		{
			gestorSom.Reproduzir( 'mouse-over' );
		}
		
		function MouseOver(evt)
		{
			if( estadoInterface == ESTADO_TUTORIAL_PARTE_I ) evt.currentTarget.gotoAndStop(3);
			else if( !emTutorial ) evt.currentTarget.gotoAndStop(2);
		}
		
		function MouseOut(evt)
		{
			evt.currentTarget.gotoAndStop(1);
		}
		
		function MouseOverPlaca(evt)
		{
			gestorSom.Reproduzir( 'plaquinha-mouse-over' );
			evt.currentTarget.gotoAndPlay(1);
		}
		
		function MouseOutPlaca(evt)
		{
			evt.currentTarget.gotoAndStop(1);
		}
		
		// Janelas:
		
		function ExibirMenuDecorativas(evt) // só para modo editor, não se pode construir decorativas geralmente
		{
			indice = "decorativas";
			LimparContainerConstrucoes();
			
			var estruturas = dataLoader.GetEstruturasDecorativas();
			for(var i = 0; i < estruturas.length; i++)
			{
				var estrutura	= estruturas[i];				
				var n = 0;
				var icone = new MovieClip();
				var texto = new TextField();
				texto.text = estrutura.GetNome();
				icone.addChild(texto);
				
				icone.x 				= Math.floor(i / 2) * 107;
				icone.y 				= (i % 2) * 100;
				icone.buttonMode		= true;
				icone.mouseChildren  	= false;
				icone.nomeEstrutura		= estrutura.GetNome();
				icone.addEventListener(MouseEvent.CLICK, AcoplarEstruturaSeletor);
				
				var mascara = new MaskIcone();
				mascara.x = icone.x;
				mascara.y = icone.y;
				adicionar_mc.containerMask_mc.addChild(mascara);
				icone.mask = adicionar_mc.containerMask_mc.getChildAt( adicionar_mc.containerMask_mc.numChildren - 1 );
				
				adicionar_mc.container_mc.addChild( icone );
			}
			
			//if(adicionar_mc.container_mc.width > adicionar_mc.slots_mc.width) adicionar_mc.slots_mc.visible = false;
			//else adicionar_mc.slots_mc.visible = true;
			
			adicionar_mc.visible = true;
		}
		
		function ExibirMenuEmissores(evt) // só para modo editor, não se pode colocar emissores no mapa geralmente
		{
			indice = "emissores";
			var arrayEmissores = new Array({nome: "Som do Dique", caminho: "data/musicas/dique.mp3"},
										   {nome: "Som do Mercado Modelo", caminho: "data/musicas/mercado_modelo.mp3"},
										   {nome: "Som do Mar", caminho: "data/musicas/mar.mp3"},
										   {nome: "Som do Mar com navio", caminho: "data/musicas/mar_navio.mp3"});
			LimparContainerConstrucoes();
			
			for(var i = 0; i < arrayEmissores.length; i++)
			{
				var icone = new MovieClip();
				var texto = new TextField();
				texto.text = arrayEmissores[i].nome;
				icone.addChild(texto);
				
				icone.x 				= Math.floor(i / 2) * 107;
				icone.y 				= (i % 2) * 100;
				icone.buttonMode		= true;
				icone.mouseChildren  	= false;
				icone.emissor			= arrayEmissores[i];
				icone.addEventListener(MouseEvent.CLICK, AcoplarEmissorSeletor);
				
				var mascara = new MaskIcone();
				mascara.x = icone.x;
				mascara.y = icone.y;
				adicionar_mc.containerMask_mc.addChild(mascara);
				icone.mask = adicionar_mc.containerMask_mc.getChildAt( adicionar_mc.containerMask_mc.numChildren - 1 );
				
				adicionar_mc.container_mc.addChild( icone );
			}
		}
		
		function OcultarTelaPassagem(evt = null)
		{
			gestorSom.Parar( 'fase-completa');
			TweenLite.to(passagem_mc	, 1		, {autoAlpha: 0});
			TweenLite.to(fadeSuperior_mc, 0.5	, {autoAlpha: 0});
			EncerrarJogo(false);
		}
		
		function OcultarMenuAtualizar(evt)
		{
			aplicacaoAtiva = true;
			PararEmissorInterno();
			clearInterval(atualizarPopupEstrutura);
			TweenLite.to(atualizar_mc	, 0.5, {autoAlpha: 0});
			TweenLite.to(fade_mc		, 0.5, {autoAlpha: 0});
			TweenLite.to(fadeSuperior_mc, 0.5, {autoAlpha: 0});
			construcaoClicada = null;
		}
		
		public function OcultarMenuDecoracao(evt)
		{
			aplicacaoAtiva = true;
			TweenLite.to(fade_mc		, 0.5, {autoAlpha: 0});
			TweenLite.to(fadeSuperior_mc, 0.5, {autoAlpha: 0});
			construcaoClicada = null;
		}
		
		public function PausaJogo(bool : Boolean)
		{
			if(bool == true){
				aplicacaoAtiva = false;
				TweenLite.to(fade_mc		, 0.5, {autoAlpha: 1});
				TweenLite.to(fadeSuperior_mc, 0.5, {autoAlpha: 1});
			} else {
				aplicacaoAtiva = true;
				TweenLite.to(fade_mc		, 0.5, {autoAlpha: 0});
				TweenLite.to(fadeSuperior_mc, 0.5, {autoAlpha: 0});
				ListenersInterface(true);
				MudarEstadoInterface(ESTADO_GAMEPLAY);
			}
		}
		
		function MenuAddConstrucao(evt)
		{
			if( Global.variables.android == true ){ hideAndroidMoveControl(); }

			tooltipConstrucoes_mc.visible = false;

			MudarEstadoInterface(ESTADO_MENU_ADICIONAR_CONSTRUCAO);
			OcultarTodas();
			fade_mc.alpha = adicionar_mc.alpha = 0;
			fadeSuperior_mc.alpha = adicionar_mc.alpha = 0;
			
			TweenLite.to(fade_mc, 0.5, {autoAlpha: 1});
			TweenLite.to(fadeSuperior_mc, 0.5, {autoAlpha: 1});

			ExibirMenuAdicionarEstrutura();
			//atualizarMenu = setInterval(AtualizarMenuAdicionarEstrutura, 1500);
			TweenLite.to(adicionar_mc	, 0.5, {autoAlpha: 1});
			gestorSom.Reproduzir( 'click-construcao' );
			
			pausarSimulacaoJanela();	
		}
		
		function OcultarMenuConstrucao(evt = null)
		{
			clearInterval(atualizarMenu);
			MudarEstadoInterface(ESTADO_GAMEPLAY);
			TweenLite.to(adicionar_mc	, 0.5, {autoAlpha: 0});
			TweenLite.to(fade_mc		, 0.5, {autoAlpha: 0});
			TweenLite.to(fadeSuperior_mc, 0.5, {autoAlpha: 0});
			
			continuarSimulacaoJanela();
		}		
		
		function MostrarMensagens(evt = null)
		{
			if( Global.variables.android == true ){ hideAndroidMoveControl(); }

			tooltipMsg_mc.visible = false;

			if (estadoInterface == ESTADO_MENSAGENS) return;
			
			OcultarTodas();
			ListenersInterface(false);
			if(!emTutorial) MudarEstadoInterface(ESTADO_MENSAGENS);
			
			fade_mc.alpha = adicionar_mc.alpha = 0;
			fade_mc.alpha = adicionar_mc.alpha = 0;

			TweenLite.to(fade_mc		, 0.5, {autoAlpha: 1})
			TweenLite.to(fadeSuperior_mc, 0.5, {autoAlpha: 1});
			TweenLite.to(mensagens_mc, 1, {autoAlpha: 1});
			
			gestorSom.Reproduzir( 'click-construcao' );
			
			pausarSimulacaoJanela();			
		}
		
		function OcultarMensagens(evt = null)
		{
			MudarEstadoInterface(ESTADO_GAMEPLAY);
			ListenersInterface(true);

			TweenLite.to(fade_mc		, 0.2, {autoAlpha: 0});
			TweenLite.to(fadeSuperior_mc, 0.5, {autoAlpha: 0});
			TweenLite.to(mensagens_mc, 0.4, {autoAlpha: 0});
			
			continuarSimulacaoJanela();
			
			setTimeout(VerificarFechamentoMensagem, 450);
		}
		
		public function MostrarCarta(evt = null, arquivo = null, inGame = false)
		{	
			if( Global.variables.android == true ){ hideAndroidMoveControl(); }

			tooltipCartaVoadora_mc.visible = false;

			if (estadoInterface == ESTADO_CARTA_VOADORA) return;
			
			OcultarTodas();
			ListenersInterface(false);
			
			MudarEstadoInterface(ESTADO_CARTA_VOADORA);
			
			cartaVoadora_mc.mostrarCarta(arquivo);

			if(Global.variables.android == true)
			{
				cartaVoadora_mc.caixa_txt.requestSoftKeyboard();
				cartaVoadora_mc.caixa_txt.needsSoftKeyboard = true;
			}

			if(inGame == true || estadoInterface == ESTADO_CARTA_VOADORA){
				cartaVoadora_mc.enviar_btn.visible = true;
			}
			
			//MudarEstadoInterface(ESTADO_MENSAGENS);
			gestorSom.Reproduzir( 'click-construcao' );
		}

		public function LimparCarta(evt:Event = null):void
		{
			cartaVoadora_mc.caixa_txt.text = "";
			cartaVoadora_mc.ocultarMenu();
		}
		
		public function MostrarPedraMagica(num : int) : void
		{
			bussola_mc.pegarPedraMagica(num);
		}

		public function MarcarPedraMagica(num : int) : void
		{
			bussola_mc.marcarPedraMagica(num);
		}
		
		public function MostrarInvasaoDriadeDoMal(num : int) :void{
			if(num == 1){
				trepadeiras_interface.visible = true;
				trepadeiras_interface.play();
			}
			
			if(num == 2){
				trepadeiras_interface.visible = false;
			}
		}

		public function MostrarAlertaDesastre(num : int) :void{
			if(num == 1){
				sirene_interface.gotoAndPlay(2);
				sirene_interface.visible = true;
			}
			
			if(num == 2){
				sirene_interface.gotoAndStop(1);
				sirene_interface.visible = false;
			}
		}
		
		public function pausarSimulacaoJanela():void
		{
			simulador.PausarSimulacao();
			//MudarEstadoInterface( ESTADO_PAUSA ); //jason
		}
		
		public function continuarSimulacaoJanela():void
		{
			simulador.ContinuarSimulacao();
			MudarEstadoInterface( ESTADO_GAMEPLAY );
		}

		public function destacarDecorativa(funcao:String):void
		{
			var construcoes = simulador.GetFase().GetConstrucoesPorFuncao( funcao );

			construcaoDesastre = construcoes[0];

			var grafico = construcaoDesastre.GetGrafico();
			
			//-----------------------------------------------------------------------------------------------------------//
			Piscar( grafico.container );
			//-----------------------------------------------------------------------------------------------------------//

			var posG 	= IsoMath.isoToScreen( new Pt(grafico.x, grafico.y) );

			TweenLite.to( render.pan, 0.5, {x: posG.x, y: posG.y, onUpdate: render.AtualizarPan});
		}

		public function destacarFuncional(categoria:String):void
		{
			var construcoes = simulador.GetFase().GetConstrucoesPorCategoria( categoria );

			construcaoDesastre = construcoes[0];

			var grafico = construcaoDesastre.GetGrafico();

			//-----------------------------------------------------------------------------------------------------------//
			Piscar( grafico.container );
			//-----------------------------------------------------------------------------------------------------------//

			var posG 	= IsoMath.isoToScreen( new Pt(grafico.x, grafico.y) );

			TweenLite.to( render.pan, 0.5, {x: posG.x, y: posG.y, onUpdate: render.AtualizarPan});
		}
		
		//------------------------------
		// <7> Metas (objetivos)
		//------------------------------
		
		function VerificarMetasCumpridas() // verifica se todas as metas foram cumpridas
		{
			var objetivos = simulador.GetFase().GetObjetivos();
			var fimFase   = true;
			for(var i = 0; i < objetivos.length; i++)
			{
				//if(metas_mc["check" + i + "_mc"].v_mc.visible == false) fimFase = false;
			}
			if(fimFase)	// Iniciar nova fase
			{
				//FimFase();
			}
		}
		
		// Atualiza a interface das metas tanto quando é cumprida em parte, como cumprida por completo.
		
		function AtualizarMeta(evt)
		{
			if (evt.data.meta.tipo == 'construir')
			{
				var quantidade;
				if(evt.data.valor < 10) quantidade = "0" + String(evt.data.valor);
				else quantidade = evt.data.valor;
				
				//TweenLite.to(metas_mc["check" + evt.data.indice + "_mc"].tintCheck_mc, 0, {tint:0xFFFF32});
				
				//metas_mc["check" + evt.data.indice + "_mc"].qtd_txt.visible = true;
				//metas_mc["check" + evt.data.indice + "_mc"].qtd_txt.text = quantidade;
			}
		}
		
		function FimMeta(evt)
		{
			//if(evt.data.meta.tipo == "indice") metas_mc["check" + evt.data.indice + "_mc"].visible = true;
			//metas_mc["check" + evt.data.indice + "_mc"].qtd_txt.visible = false;
			//TweenLite.to(metas_mc["check" + evt.data.indice + "_mc"].tintCheck_mc, 0, {tint:0xA7DF00});
			//metas_mc["check" + evt.data.indice + "_mc"].v_mc.visible 	= true;
		}
		

		function AbrirTelaMetas(evt = null)
		{
//			timerMouse.reset();
			MudarEstadoInterface(ESTADO_TELA_METAS);
			OcultarTodas();
			
			//passagem2_mc.alpha = 0;
			//TweenLite.to(passagem2_mc, 1, {autoAlpha: 1});
			
			gestorSom.Reproduzir( 'click-construcao' );
			simulador.PausarSimulacao();
		}
		
		function OcultarTelaMetas(evt = null)
		{
			simulador.ContinuarSimulacao();
			MudarEstadoInterface(ESTADO_GAMEPLAY);
			//TweenLite.to(passagem2_mc	, 1		, {autoAlpha: 0});
			TweenLite.to(fade_mc		, 0.5	, {autoAlpha: 0});
			TweenLite.to(fadeSuperior_mc, 0.5, {autoAlpha: 0});
			
//			timerMouse.start();
		}
		
		//----------------------------
		// <8> Mensagens
		//----------------------------
		
		function ReceberMensagem(evt)
		{
			var data = evt.data;
			trace('icone data: '+data.icone)
			AdicionarMensagem(data.titulo, data.texto, true, data.personagem, data.icone);
			
			if(data.funcao != undefined && data.funcao != "")
				this[data.funcao]();
			
			MostrarMensagens();
		}
		
		function AdicionarMensagem(titulo, texto, exibir = false, personagem = "", icone = "")
		{
			var botaoMensagem 			= new BotaoMensagem();
			botaoMensagem.text_txt.text = (mensagens_mc.container_mc.numChildren+1) + '. ' + titulo;
			botaoMensagem.addEventListener( MouseEvent.CLICK		, ExibirMensagem );
			botaoMensagem.addEventListener( MouseEvent.MOUSE_OVER	, MCOver );
			botaoMensagem.addEventListener( MouseEvent.MOUSE_OUT	, MCOut );			
			botaoMensagem.selecionado   = false;
			botaoMensagem.mouseChildren	= false;
			botaoMensagem.buttonMode  	= true;
			botaoMensagem.texto			= texto;
			botaoMensagem.personagem	= personagem;
			botaoMensagem.icone	= icone;
			botaoMensagem.y 			= 0; 
			
			for (var i = 0; i < mensagens_mc.container_mc.numChildren; i++)
			{
				var c = mensagens_mc.container_mc.getChildAt( i );
				c.y = (mensagens_mc.container_mc.numChildren-i) * (botaoMensagem.height + 5)
			}
			
			mensagens_mc.container_mc.addChild( botaoMensagem );
			if (exibir) botaoMensagem.dispatchEvent( new Event(MouseEvent.CLICK) );
		}
		
		function RemoverMensagens()
		{
			// removendo todos os eventos
			for (var i = 0; i < mensagens_mc.container_mc.numChildren; i++)
			{
				var botaoMensagem = mensagens_mc.container_mc.getChildAt( i );
				botaoMensagem.removeEventListener( MouseEvent.CLICK		, ExibirMensagem );
				botaoMensagem.removeEventListener( MouseEvent.MOUSE_OVER, MCOver );
				botaoMensagem.removeEventListener( MouseEvent.MOUSE_OUT	, MCOut );	
			}
			// removendo todas as mensagens
			while (mensagens_mc.container_mc.numChildren > 0) mensagens_mc.container_mc.removeChildAt(0);
		}
		
		public function DeselecionarTodos(container_mc)
		{
			for (var i = 0; i < container_mc.numChildren; i++)
			{
				var botao_mc = container_mc.getChildAt(i);
				botao_mc.gotoAndStop( 'Up' );
				botao_mc.selecionado = false;
			}
		}
		
		function ExibirMensagem(evt)
		{
			DeselecionarTodos( mensagens_mc.container_mc );
			
			var botao_mc 			= MovieClip(evt.target);
			botao_mc.selecionado 	= true;
			botao_mc.gotoAndStop( 'Over' );
			mensagens_mc.text_txt.htmlText = botao_mc.texto;
			mensagens_mc.mostrarPersonagem(botao_mc.personagem);
			mensagens_mc.mostrarIcone(botao_mc.icone);
		}

		function MCOver(evt)
		{
			var botao_mc 			= MovieClip(evt.target);
			botao_mc.gotoAndStop('Over');
		}
		
		function MCOut(evt)
		{
			var botao_mc 			= MovieClip(evt.target);
			if (!botao_mc.selecionado) botao_mc.gotoAndStop('Up');
		}

		public function exibirNomeMapa(nome:String){
			nomeDoMapa.visible = true;
			nomeDoMapa.campo.text = nome;
		}
		
		//----------------------------------
		// <9> Aplicação de desastres
		//----------------------------------
		
		/***
		*
		*	Event Handler para um desastre.
		*	(Assaltos, invasões, passeatas, etc.
		*	Evento disparado pelo Simulador.
		*
		*******/
		
		public function Desastre(evt)
		{
			desastre_mc.titulo_txt.text = evt.data.titulo;
			desastre_mc.texto_txt.text 	= evt.data.texto;
			desastre_mc.icone_mc.gotoAndStop(evt.data.rotulo);
			
			construcaoDesastre = evt.data.construcao;

			// Escurece a construção.
			var grafico = construcaoDesastre.GetGrafico();
			TweenLite.to(grafico.container, 0, {colorMatrixFilter:{colorize: 0x000000, amount:0.6}});
			 
			OcultarTodas();
			desastre_mc.alpha = 0;
			aplicacaoAtiva 	  = false;
			TweenLite.to( desastre_mc, 0.5, {autoAlpha: 1});
			TweenLite.to( fade_mc	 , 0.5, {autoAlpha: 1});
			TweenLite.to(fadeSuperior_mc, 0.5, {autoAlpha: 1});
		}
		
		// Único desastre que ocorre no tutorial. É uma das etapas.
		
		public function DesastreTutorial()
		{
			desastre_mc.titulo_txt.text = "Violência";
			desastre_mc.texto_txt.text 	= "Seu índice de educação chegou a 100%. Mas veja! Uma construção foi atacada por vândalos. Clique no botão abaixo e visualize a construção danificada e, após selecionar a estrutura, use o botão de “Consertar unidade” para que ela volte a funcionar.";
			desastre_mc.icone_mc.gotoAndStop("Assalto");
							
			construcaoDesastre  = ConstrucaoRandomDesastre();
			
			// Aplica o dano à construcao.
			var dano = simulador.CalcularDanoDesastre();
			construcaoDesastre.AplicarDano( dano );

			// Escurece a construção.
			var grafico = construcaoDesastre.GetGrafico();
			TweenLite.to(grafico.container, 0, {colorMatrixFilter:{colorize: 0x000000, amount:0.6}});	
			 
			OcultarTodas();
			desastre_mc.alpha = 0;
			aplicacaoAtiva 	  = false;
			TweenLite.to( desastre_mc, 0.5, {autoAlpha: 1});
			TweenLite.to( fade_mc	 , 0.5, {autoAlpha: 1});
			TweenLite.to(fadeSuperior_mc, 0.5, {autoAlpha: 1});
		}

		public function GerarDesastre(titulo:String, descricao:String, rotulo:String, categoria:String)
		{
			desastre_mc.titulo_txt.text = titulo;
			desastre_mc.texto_txt.text 	= descricao;
			desastre_mc.icone_mc.gotoAndStop(rotulo);

			this.rotuloDesastre = rotulo;
							
			construcaoDesastre  = ConstrucaoRandomDesastreCategoria(categoria, rotulo);
			
			// Aplica o dano à construcao.
			var dano = simulador.CalcularDanoDesastre();
			construcaoDesastre.AplicarDano( dano );

			// Escurece a construção.
			var grafico = construcaoDesastre.GetGrafico();
			TweenLite.to(grafico.container, 0, {colorMatrixFilter:{colorize: 0x000000, amount:0.6}});	
			 
			OcultarTodas();
			desastre_mc.alpha = 0;
			aplicacaoAtiva 	  = false;
			TweenLite.to( desastre_mc, 0.5, {autoAlpha: 1});
			TweenLite.to( fade_mc	 , 0.5, {autoAlpha: 1});
			TweenLite.to(fadeSuperior_mc, 0.5, {autoAlpha: 1});
		}

		public function GerarDano(categoria:String, rotulo:String)
		{
			construcaoDesastre  = ConstrucaoRandomDesastreCategoria(categoria, rotulo);
			
			// Aplica o dano à construcao.
			var dano = simulador.CalcularDanoDesastre();
			construcaoDesastre.AplicarDano( dano );

			if(construcaoDesastre.ReturnPontosDeVida() == 0){
				//destruir
				simulador.RemoverEstrutura(construcaoDesastre.GetGrafico());
				gestorSom.Reproduzir( 'construcao-demolicao' );	
			} else {

				// Escurece a construção.
				//var grafico = construcaoDesastre.GetGrafico();
				//TweenLite.to(grafico.container, 0, {colorMatrixFilter:{colorize: 0x000000, amount:0.6}});	

				this.rotuloDesastre = rotulo;

				VisualizarDesastreBoss();
			}
		}
		
		public function ConstrucaoRandomDesastreCategoria(categoria:String, dano:String)
		{
			var achou = false;
			var construcoes = simulador.GetFase().GetConstrucoesPorCategoria( categoria );
			var construcao;
			while(!achou)
			{
				// Seleciona uma construcao aleatória para aplicar o desastre.
				var construcaoI	= Math.floor( Math.random() * construcoes.length );				
				construcao = construcoes[construcaoI];					
				if(construcao.GetStatus() == "pronta") achou = true;
			}
			return construcao;
		}

		public function ConstrucaoRandomDesastre()
		{
			var achou = false;
			var construcoes = simulador.GetFase().GetConstrucoesPorCategoria( "Moradia" );
			var construcao;
			while(!achou)
			{
				// Seleciona uma construcao aleatória para aplicar o desastre.
				var construcaoI	= Math.floor( Math.random() * construcoes.length );				
				construcao = construcoes[construcaoI];					
				if(construcao.GetStatus() == "pronta") achou = true;
			}
			return construcao;
		}
		
		/***
		*
		*	Event Handler para clique no botão
		*	fechar da janela de desastres.
		*
		******/
		public function FecharDesastre(evt = null)
		{
			TweenLite.to( desastre_mc, 0.5, {autoAlpha: 0});
			TweenLite.to( fade_mc	 , 0.5, {autoAlpha: 0});
			TweenLite.to( fadeSuperior_mc, 0.5, {autoAlpha: 0});
			aplicacaoAtiva = true;
		}
		
		/***
		*
		*	Event Handler para clique no botão
		*	visualizar desastre.
		*
		******/
		public function VisualizarDesastreBoss(evt = null)
		{
			//TweenLite.to(fadeSuperior_mc, 0.5, {autoAlpha: 0});

			if (construcaoDesastre)
			{
				var grafico = construcaoDesastre.GetGrafico();
				var posG 	= IsoMath.isoToScreen( new Pt(grafico.x, grafico.y) );

				if(rotuloDesastre == 'Incendio'){
					var fogo = new Incendio();
					var spriteFogo:IsoSprite = new IsoSprite();

					spriteFogo.setSize(grafico.width, grafico.height, 0);
					spriteFogo.moveTo(grafico.x, grafico.y, 0);
					spriteFogo.sprites = [fogo];
					
					gestorSom.Reproduzir('fogo', 4);

					render.AdicionarNoGrid(spriteFogo, false, 3);
					AtualizarFiltros();
				}

				if(rotuloDesastre == 'Inundacao'){
					var agua = new Inundacao();
					var spriteAgua:IsoSprite = new IsoSprite();

					spriteAgua.setSize(grafico.width, grafico.height, 0);
					spriteAgua.moveTo(grafico.x, grafico.y, 0);
					spriteAgua.sprites = [agua];

					gestorSom.Reproduzir('inundacao', 4);
					
					render.AdicionarNoGrid(spriteAgua, false, 3);
					AtualizarFiltros();
				}
				
				// Enquadra a construção alvo do desastre.
				TweenLite.to( render.pan, 0.5, {x: posG.x, y: posG.y, 
						 						onUpdate: render.AtualizarPan, onComplete: VisualizarDesastre2,
												onCompleteParams: [evt]});					
			}
		}

		public function VisualizarDesastre(evt = null)
		{
			//TweenLite.to(fadeSuperior_mc, 0.5, {autoAlpha: 1});

			if (construcaoDesastre)
			{
				var grafico = construcaoDesastre.GetGrafico();
				var posG 	= IsoMath.isoToScreen( new Pt(grafico.x, grafico.y) );

				if(rotuloDesastre == 'Incendio'){
					var fogo = new Incendio();
					var spriteFogo:IsoSprite = new IsoSprite();

					spriteFogo.setSize(grafico.width, grafico.height, 0);
					spriteFogo.moveTo(grafico.x, grafico.y, 0);
					spriteFogo.sprites = [fogo];
					
					gestorSom.Reproduzir('fogo', 4);

					render.AdicionarNoGrid(spriteFogo, false, 3);
					AtualizarFiltros();
				}

				if(rotuloDesastre == 'Assalto'){
					var tiros = new Assalto();
					var spriteTiros:IsoSprite = new IsoSprite();

					spriteTiros.setSize(grafico.width, grafico.height, 0);
					spriteTiros.moveTo(grafico.x, grafico.y, 0);
					spriteTiros.sprites = [tiros];
					
					gestorSom.Reproduzir('tiroteio', 4);

					render.AdicionarNoGrid(spriteTiros, false, 3);
					AtualizarFiltros();
				}

				if(rotuloDesastre == 'Saude'){
					var dengue = new Saude();
					var spriteDengue:IsoSprite = new IsoSprite();

					spriteDengue.setSize(grafico.width, grafico.height, 0);
					spriteDengue.moveTo(grafico.x, grafico.y, 0);
					spriteDengue.sprites = [dengue];
					
					gestorSom.Reproduzir('mosquitos', 4);

					render.AdicionarNoGrid(spriteDengue, false, 3);
					AtualizarFiltros();
				}

				if(rotuloDesastre == 'Inundacao'){
					var agua = new Inundacao();
					var spriteAgua:IsoSprite = new IsoSprite();

					spriteAgua.setSize(grafico.width, grafico.height, 0);
					spriteAgua.moveTo(grafico.x, grafico.y, 0);
					spriteAgua.sprites = [agua];

					gestorSom.Reproduzir('inundacao', 4);
					
					render.AdicionarNoGrid(spriteAgua, false, 3);
					AtualizarFiltros();
				}

				if(rotuloDesastre == 'Sujeira'){
					var lixo = new Sujeira();
					var spriteLixo:IsoSprite = new IsoSprite();

					spriteLixo.setSize(grafico.width, grafico.height, 0);
					spriteLixo.moveTo(grafico.x, grafico.y, 0);
					spriteLixo.sprites = [lixo];

					//gestorSom.Reproduzir('inundacao', 4);
					
					render.AdicionarNoGrid(spriteLixo, false, 3);
					AtualizarFiltros();
				}
				
				// Fecha a janela.
				FecharDesastre();
				
				// Enquadra a construção alvo do desastre.
				TweenLite.to( render.pan, 0.5, {x: posG.x, y: posG.y, 
						 						onUpdate: render.AtualizarPan, onComplete: VisualizarDesastre2,
												onCompleteParams: [evt]});					
			}
		}
		
		/***
		*
		*	Faz a construção piscar em vermelho após
		*	enquadramento, após cliar no botão visualizar desastre.
		*
		******/
		public function VisualizarDesastre2(evt)
		{
			var grafico = construcaoDesastre.GetGrafico();
			
			// Só escurece a construção se ela não estiver sendo consertada.
			if (construcaoDesastre.GetStatus() != Construcao.STATUS_CONSERTANDO) grafico.container.tint = 0x000000;
			else grafico.container.tint = null;
			
			Piscar( grafico.container );
		}
		
		function Piscar( mc )
		{
			mc.contPiscar = 0;
			Piscar1( mc );
		}
		
		function Piscar1( mc )
		{
			if ( mc.contPiscar > 3 ) 
			{
				if (mc.tint != null)  TweenLite.to(mc, 0.2, {colorMatrixFilter:{colorize:mc.tint, amount:0.6}});	
				return;
			}			
			TweenLite.to(mc, 0.5, {colorMatrixFilter:{colorize:0xff0000, amount:1}, onComplete: Piscar2, onCompleteParams: [mc]});	
		}
		
		function Piscar2( mc )
		{
			mc.contPiscar++;
			TweenLite.to(mc, 0.5, {colorMatrixFilter:{colorize:0xff0000, amount:0}, onComplete: Piscar1, onCompleteParams: [mc]});		
		}
		
		//----------------------------------------
		// <10> Conserto de construções
		//----------------------------------------
		
		/***
		*
		*	Event Handler para o início do
		*	do conserto de uma construção.
		*	Evento disparado pelo simulador assim
		*	que o jogador clica em consertar.
		*
		*******/
		function InicioConserto(evt)
		{
			var construcao 	= evt.data.construcao;
			var grafico 	= construcao.GetGrafico();
			
			// Remove o tint da construção.
			TweenLite.to(grafico.container, 0.1, {colorMatrixFilter:{colorize:0xFFFFCC}});
		}
		
		/***
		*
		*	Event Handler para o fim do conserto
		*	de uma construção.
		*	Evento disparado pelo simulador quando a 
		*	construção atinge 100hps (completamente consertada
		*	ou quando ela é destruída durante o conserto.
		*
		*****/
		function FimConserto(evt)
		{
			var construcao 	= evt.data.construcao;
			var grafico 	= construcao.GetGrafico();

			TweenLite.to(grafico.container, 0.1, {colorMatrixFilter:{amount:1}});
		}
		
		function ConsertarConstrucao(evt)
		{
			simulador.ConsertarEstrutura(construcaoClicada);
			construindo.push(construcaoClicada.GetEstrutura().GetNome());
			OcultarMenuAtualizar(null);
			gestorSom.Reproduzir( 'construindo' );
			ultimaAcao = "conserto";
		}
		
		//-------------------------------------------------
		// <11> Adicionar construções (inclusive telas)
		//-------------------------------------------------
		
		function AtualizarMenuAdicionarEstrutura()
		{
			for(var i = 0; i < adicionar_mc.container_mc.numChildren; i++)
			{
				var icone = adicionar_mc.container_mc.getChildAt(i);
				if(icone.custo <= simulador.GetDinheiroDisponivel() &&
					(icone.desabitados <= simulador.GetPopulacao()) &&
					(icone.habitados <= simulador.GetHabitados()) )
				{
					icone.alpha = 1;
					icone.buttonMode = true;
					
					if(!icone.hasEventListener(MouseEvent.CLICK)) icone.addEventListener(MouseEvent.CLICK, AcoplarEstruturaSeletor);
				}
			}
		}
		
		function ExibirMenuAdicionarEstrutura()
		{
			adicionar_mc.addMobile.visible = false;

			adicionar_mc.indice_txt.text = indice;
			LimparContainerConstrucoes();
			
			var estruturas = dataLoader.GetEstruturasPorCategoria( indice );

			for(var i = 0; i < estruturas.length; i++)
			{
				var estrutura	= estruturas[i];				
				var n = 0;
				
					var nivel : Nivel	= estrutura.GetNiveis()[n];

					trace('-->' + nivel.GetNivelJogador())
					trace('-->' + simulador.GetFase().GetNumero())

					if((nivel.GetNivelJogador() <= simulador.GetFase().GetNumero()) || Global.variables.modoEditor == true){
						var classe 		= estrutura.GetGrafico().applicationDomain.getDefinition("Icone" + nivel.GetNumero()) as Class;
						var icone  		= new classe();

						trace(classe);
						trace(icone);
									
						icone.x 				= Math.floor(( i )/ 2) * 107;
						icone.y 				= (( i ) % 2) * 100;
						icone.buttonMode		= true;
						icone.mouseChildren  	= false;
						icone.nomeEstrutura		= estrutura.GetNome();
						icone.nomeNivel			= nivel.GetNome();
						icone.numeroNivel		= nivel.GetNivelJogador();

						//if(Global.variables.modoEditor == false)
						//{
							icone.custo				= nivel.GetCusto();
							icone.desabitados		= nivel.GetDesabitados();
							icone.habitados			= nivel.GetHabitados();
						//}
						//else
						//{
							//icone.custo				= 0;
							//icone.desabitados		= 0;
							//icone.habitados			= 0;
						//}

						if(Global.variables.modoEditor == false)
						{
							if((nivel.GetCusto() > simulador.GetDinheiroDisponivel()) || 
								(nivel.GetDesabitados() > simulador.GetPopulacao()) ||
								(nivel.GetHabitados() > simulador.GetHabitados())) // não há dinheiro suficiente
							{
								icone.alpha = 0.3;
								icone.buttonMode = false;
							}
							else
							{
								if( Global.variables.android == true )
								{
									icone.addEventListener(MouseEvent.CLICK, seletorBotaoMobile); //jason

									icone.addEventListener(MouseEvent.MOUSE_DOWN, MostrarTooltip);
									icone.addEventListener(MouseEvent.MOUSE_UP, OcultarTooltip);
								}
								else
								{
									icone.addEventListener(MouseEvent.CLICK, AcoplarEstruturaSeletor);

									icone.addEventListener(MouseEvent.MOUSE_OVER, MostrarTooltip);
									icone.addEventListener(MouseEvent.MOUSE_OUT, OcultarTooltip);
								}
							} 
						} else {
							if( Global.variables.android == true )
							{
								icone.addEventListener(MouseEvent.CLICK, seletorBotaoMobile); //jason

								icone.addEventListener(MouseEvent.MOUSE_DOWN, MostrarTooltip);
								icone.addEventListener(MouseEvent.MOUSE_UP, OcultarTooltip);
							}
							else
							{
								icone.addEventListener(MouseEvent.CLICK, AcoplarEstruturaSeletor);

								icone.addEventListener(MouseEvent.MOUSE_OVER, MostrarTooltip);
								icone.addEventListener(MouseEvent.MOUSE_OUT, OcultarTooltip);
							}
						} 
						
						var mascara = new MaskIcone();

						mascara.x = icone.x;
						mascara.y = icone.y;

						adicionar_mc.containerMask_mc.addChild(mascara);

						icone.mask = adicionar_mc.containerMask_mc.getChildAt( adicionar_mc.containerMask_mc.numChildren - 1 );
												
						adicionar_mc.container_mc.addChild( icone );
					}
								
			}
			
			//if(adicionar_mc.container_mc.width > adicionar_mc.slots_mc.width) adicionar_mc.slots_mc.visible = false;
			//else adicionar_mc.slots_mc.visible = true;
		}
		
		function AdicionarConstrucao()
		{
			trace('-> add construcao');
			trace('-> mod editor: '+Global.variables.modoEditor);

			var pos  = new Point( Math.floor(seletor.x/FaseRender.CELL_SIZE), Math.floor(seletor.y/FaseRender.CELL_SIZE) );
			var rect = new Rectangle(pos.x, pos.y, tamanhoSeletor.x, tamanhoSeletor.y);
			var fase : Fase = simulador.GetFase();

			trace(fase.AreaLivre(rect))
			
			if ( fase.AreaLivre(rect) )
			{
				vaiAdicionar = false;
				var dataLoader 	= DataLoader.GetInstance();
				var estrutura	= dataLoader.GetEstruturaByName( iconeSelecionado.nomeEstrutura );
				
				if(indice != "decorativas")
				{
					// para ludens:
					switch(estrutura.GetCategoria())
					{
						case "Educação":
						{
							qtdConstrucoes.educacao++;
							break;
						}
						case "Moradia":
						{
							qtdConstrucoes.moradia++;
							break;
						}
						case "Comércio":
						{
							qtdConstrucoes.comercio++;
							break;
						}
						case "Lazer":
						{
							qtdConstrucoes.lazer++;
							break;
						}
						case "Infraestrutura":
						{
							qtdConstrucoes.infraestrutura++;
							break;
						}
					}
					var construcao	= new ConstrucaoFuncional(1, pos, estrutura, iconeSelecionado.nomeNivel, false);
					var custo = construcao.GetEstrutura().GetNivel(0).GetCusto();					
					
					if(Global.variables.modoEditor == true)
					{
						var ok = simulador.AdicionarNovaEstrutura( construcao , false, 0, true);
					}
					else
					{
						var ok = simulador.AdicionarNovaEstrutura( construcao, true, custo );					
					}
					
					
					if(ok)
					{
						gestorSom.Reproduzir( 'construindo' );
						construindo.push(construcao.GetEstrutura().GetNome());	
					}
				}
				else
				{
					construcao = new ConstrucaoDecorativa(pos, estrutura, false);
					simulador.AdicionarNovaEstrutura( construcao, false ); // só adiciona a construção no mapa
					gestorSom.Reproduzir( 'construindo' );
					construindo.push(construcao.GetEstrutura().GetNome());
				}
				ultimaAcao = "construcao";
				seletor.container.visible = false;
			} 
			else
			{
				tooltipArea.visible = true;
				tooltipArea.x = stage.mouseX;
				tooltipArea.y = stage.mouseY;

				TweenLite.to(tooltipArea, 1, {visible: false, delay:1});
			}
		}
		
		//-----------------------------------
		// <12> Atualizar construções
		//-----------------------------------
		
		function MenuAtualizarConstrucao(evt)
		{
			gestorSom.Reproduzir( 'click-construcao' );
			
			if(!aplicacaoAtiva)  return;
			
			graficoClicado 	= evt.data.grafico;
			var posG 		= IsoMath.isoToScreen( new Pt(graficoClicado.x, graficoClicado.y) );
			TweenLite.to( render.pan, 0.5, {x: posG.x, y: posG.y, 
						 					onUpdate: render.AtualizarPan, onComplete: MenuAtualizarConstrucao2,
											onCompleteParams: [evt]});								
		}
		
		function ValidarBotaoAtualizar()
		{
			if(construcaoClicada is ConstrucaoFuncional)
			{
				var ok = false;
				var numeroNivelAtual = construcaoClicada.GetNivel().GetNumero();
				var proximoNivelConstrucao = construcaoClicada.GetEstrutura().GetNivel(numeroNivelAtual);
				//atualizar_mc.nivelJogador_txt.text = "";
				if(proximoNivelConstrucao) // se houver um próximo nivel
				{
					var custo = proximoNivelConstrucao.GetCusto();
					var desabitados = proximoNivelConstrucao.GetDesabitados();
					var habitados = proximoNivelConstrucao.GetHabitados();
					
					if(custo <= simulador.GetDinheiroDisponivel() &&
						desabitados <= simulador.GetPopulacao() &&
						habitados <= simulador.GetHabitados())
					{
						ok = true;
					}
					else
					{
						ok = false;
					}
				}
				else
				{
					ok = false;
					//atualizar_mc.nivelJogador_txt.text = "";
				}
				if(construcaoClicada.GetStatus() != Construcao.STATUS_PRONTA) ok = false;
				
				//atualizar_mc.atualizar_btn.alpha 		 = (ok ? 1 : 0.5);
				//atualizar_mc.atualizar_btn.mouseEnabled  = (ok ? true : false);
			}
		}
		
		/**
		 * Trata o clicar na construcao
		 * */
		function MenuAtualizarConstrucao2(evt)
		{
			atualizar_mc.mais_mc.visible  = false;
			atualizar_mc.menos_mc.visible = false;
			
			aplicacaoAtiva 	= false;
			
			construcaoClicada = simulador.GetConstrucaoPeloGrafico(graficoClicado);
			
			// CASTELO REI KIMERA
			if(construcaoClicada is ConstrucaoDecorativa)
			{
				var decorativa : ConstrucaoDecorativa = construcaoClicada;
				if(decorativa.GetFuncao() == "castelo"){
					
					castelo_mc.atualizar();
					//castelo_mc.visible = true;
					
					if(evt)
					{						
						graficoClicado = evt.data.grafico;
						
						// Calcula a posição da janela de atualização para que fique exatamente sobre
						// a construção.
						var pan2  = render.GetPan();
						var posG2 = IsoMath.isoToScreen( new Pt(graficoClicado.x, graficoClicado.y) );
						var pos2  = new Point(
							stage.stageWidth/2  + (( Math.abs(pan2.x) - Math.abs(posG2.x))*render.GetZoom()),
							stage.stageHeight/2 - (( Math.abs(pan2.y) - Math.abs(posG2.y))*render.GetZoom())
						);
						
						castelo_mc.x 	= pos2.x;
						castelo_mc.y 	= pos2.y;
						
						TweenLite.to(fade_mc		, 0.5, {autoAlpha: 1});
						TweenLite.to(castelo_mc	, 0.5, {autoAlpha: 1});	
						TweenLite.to(fadeSuperior_mc, 0.5, {autoAlpha: 1});
					}	
					
					return;
					
				// Casa dos Guardiões
				} else if (decorativa.GetFuncao() == "guardioes") {
					guardioes_mc.mostrarTela();
					
					if(evt)
					{						
						graficoClicado = evt.data.grafico;
						
						// Calcula a posição da janela de atualização para que fique exatamente sobre
						// a construção.
						var pan3  = render.GetPan();
						var posG3 = IsoMath.isoToScreen( new Pt(graficoClicado.x, graficoClicado.y) );
						var pos3  = new Point(
							stage.stageWidth/2  + (( Math.abs(pan3.x) - Math.abs(posG3.x))*render.GetZoom()),
							stage.stageHeight/2 - (( Math.abs(pan3.y) - Math.abs(posG3.y))*render.GetZoom())
						);
						
						guardioes_mc.x 	= pos3.x;
						guardioes_mc.y 	= pos3.y;
						
						TweenLite.to(fade_mc		, 0.5, {autoAlpha: 1});
						TweenLite.to(fadeSuperior_mc, 0.5, {autoAlpha: 1});
						TweenLite.to(guardioes_mc	, 0.5, {autoAlpha: 1});

						guardioes_mc.tilion_mc.visible = false;
						guardioes_mc.doren_mc.visible = false;
						guardioes_mc.kimera_mc.visible = false;

						if(simulador.GetFase().GetNumero() == 1){
							guardioes_mc.tilion_mc.visible = true;
						}

						if(simulador.GetFase().GetNumero() == 2){
							guardioes_mc.doren_mc.visible = true;
						}

						if(simulador.GetFase().GetNumero() == 3){
							guardioes_mc.kimera_mc.visible = true;
						}
					}	
					
					return;
				}
			}
			
			
			
			/******** Caso 1: construção funcional *******/
			
			if(construcaoClicada is ConstrucaoFuncional)
			{
				//mini game reciclegem
				trace('---> '+construcaoClicada.GetNivel().GetNome());
				
				if(construcaoClicada.GetNivel().GetNome() == 'Indústria de Reciclagem de Lixo'){
					if(simulador.GetVariavel("Fase3") == "2"){
						MostrarTelaPreta(false);
						
						var minigame = new ScreenLoader("data/minigames/minigame_01.swf", controlarLimpeza);
						stageObj.addChild(minigame);
						OcultarTodas();
					}
				}

				atualizar_mc.descricao_txt.text		= construcaoClicada.GetNivel().GetDescricao();
				atualizar_mc.excluir_btn.visible 	= true;
				//atualizar_mc.atualizar_btn.visible	= true;
				atualizar_mc.pontosVida_txt.visible = true;
				
				//atualizar_mc.atualizar_btn.alpha = 0.5;
				atualizar_mc.consertar_btn.alpha = 0.5;
				
				atualizar_mc.nome_txt.text 	= construcaoClicada.GetNivel().GetNome();
				
				var numeroProximoNivel = construcaoClicada.GetNivel().GetNumero();
//				if(numeroProximoNivel <= 2)
//				{
//					if(construcaoClicada.GetEstrutura().GetNome() != "Favela")
//					{
//						var custoProximoNivel = construcaoClicada.GetEstrutura().GetNivel(numeroProximoNivel).GetCusto();
//						if(construcaoClicada.GetNivel().GetCusto() == 0) atualizar_mc.dinheiro_txt.text = "K$0,00"
//						else atualizar_mc.dinheiro_txt.text = NumberFormat.FormatCurrency( custoProximoNivel, 2, ',' , '.', 'K$ ' );
//					}
//					else atualizar_mc.dinheiro_txt.text = "";
//				}
//				else atualizar_mc.dinheiro_txt.text = "";
			
				// Pontos de vida.
				if(construcaoClicada.GetPontosVida() != 0) atualizar_mc.pontosVida_txt.text = construcaoClicada.GetPontosVida().toFixed(0) + "/" + 100;
				else atualizar_mc.pontosVida_txt.text = "0/100";
			
				// Conserto da construção.
				var consertar = (	construcaoClicada.GetPontosVida() < 100 && 
						 		construcaoClicada.GetStatus() == Construcao.STATUS_PRONTA);
//				
				atualizar_mc.consertar_btn.visible 		= true;
				atualizar_mc.consertar_btn.alpha 		= (consertar ? 1 : 0.5);
				atualizar_mc.consertar_btn.mouseEnabled	= (consertar ? true : false);
			
//				var n = "não há."
//				var niveis = construcaoClicada.GetEstrutura().GetNiveis();
//				for(var i = 0; i < niveis.length; i++)
//				{
//					if(niveis[i].GetNumero() == construcaoClicada.GetNivel().GetNumero() + 1) n = niveis[i].GetNumero();
//				}
//				atualizar_mc.proxNivel_txt.text = "Próximo nível: " + n;
				
				var contribuicoes = construcaoClicada.GetNivel().GetContribuicoesPorTipo("atendimento");
				var cPositivas = "";
				for(var i = 0; i < contribuicoes.length; i++)
				{
					if(i > 0) cPositivas += ", " + contribuicoes[i].GetCategoria();
					else cPositivas += contribuicoes[i].GetCategoria();
				}
				if(contribuicoes.length != 0)
				{
					atualizar_mc.mais_mc.visible   = true;
					atualizar_mc.positivo_txt.text = cPositivas;
				}
				else atualizar_mc.positivo_txt.text = "";
				
				// Verifica se aquela construção pode ser demolida.
				
				var ok = true;
				if(simulador.GetVariavel("etapaTutorial") == "6") ok = false;
				atualizar_mc.excluir_btn.alpha 		  = (((simulador.ValidarDemolicao( construcaoClicada ) && ok)|| Global.variables.modoEditor)? 1 : 0.5);
				atualizar_mc.excluir_btn.mouseEnabled = (((simulador.ValidarDemolicao( construcaoClicada ) && ok)|| Global.variables.modoEditor)? true : false);
				
				ValidarBotaoAtualizar();
				atualizarPopupEstrutura = setInterval(ValidarBotaoAtualizar, 1000);
			}
			
			/******** Caso 2: construção decorativa *******/
			
			else	
			{
				atualizar_mc.pontosVida_txt.visible = false;
				atualizar_mc.consertar_btn.visible	= false;
				//atualizar_mc.atualizar_btn.visible	= false;
				atualizar_mc.excluir_btn.visible 	= false;
				//atualizar_mc.proxNivel_txt.text 	= "";
				atualizar_mc.positivo_txt.text 		= "";
				atualizar_mc.negativo_txt.text 		= "";
				//atualizar_mc.dinheiro_txt.text 		= "";
				//atualizar_mc.nivelJogador_txt.text 	= "";
				atualizar_mc.descricao_txt.text		= construcaoClicada.GetEstrutura().GetDescricao();
				atualizar_mc.nome_txt.text 			= construcaoClicada.GetEstrutura().GetNome();
			}
						
			fade_mc.alpha 	= atualizar_mc.alpha = 0;
			fadeSuperior_mc.alpha = atualizar_mc.alpha = 0;
						
			if(evt)
			{
				ReproduzirEmissorInterno();
				
				graficoClicado = evt.data.grafico;

				// Calcula a posição da janela de atualização para que fique exatamente sobre
				// a construção.
				var pan  = render.GetPan();
				var posG = IsoMath.isoToScreen( new Pt(graficoClicado.x, graficoClicado.y) );
				var pos  = new Point(
					stage.stageWidth/2  + (( Math.abs(pan.x) - Math.abs(posG.x))*render.GetZoom()),
					stage.stageHeight/2 - (( Math.abs(pan.y) - Math.abs(posG.y))*render.GetZoom())
				);
				
				atualizar_mc.x 	= pos.x;
				atualizar_mc.y 	= pos.y;
				
				TweenLite.to(fade_mc		, 0.5, {autoAlpha: 1});
				TweenLite.to(fadeSuperior_mc, 0.5, {autoAlpha: 1});
				TweenLite.to(atualizar_mc	, 0.5, {autoAlpha: 1});	
			}		
		}

		function controlarLimpeza(){
			VerificaFluxoDeJogo("limparSujeira");
			OcultarTodas();
		}
		
		function AtualizarConstrucao(evt)
		{
			var numeroNivelAtual = construcaoClicada.GetNivel().GetNumero();
			
			// se existir um próximo nivel para a construção, e o jogador tiver nivel suficiente para construir
			var proximoNivelConstrucao = construcaoClicada.GetEstrutura().GetNivel(numeroNivelAtual);
			if(proximoNivelConstrucao) 
			{
				var custo = proximoNivelConstrucao.GetCusto();
				var ok 	  = simulador.ValidarAtualizacao(construcaoClicada, custo, proximoNivelConstrucao);
				if(ok)
				{
					ultimaAcao = "atualizacao";
					construindo.push(construcaoClicada.GetEstrutura().GetNome());
					OcultarMenuAtualizar(null);
					gestorSom.Reproduzir( 'construindo' );
				}
			}
		}
		
		//-----------------------------------
		// <13> Excluir construções
		//-----------------------------------
		
		function ExcluirConstrucao(evt)
		{
			simulador.RemoverEstrutura(graficoClicado);
			OcultarMenuAtualizar(null);
			gestorSom.Reproduzir( 'construcao-demolicao' );
		}
		
		//------------------------------------
		// <14> Eventos de turno
		//------------------------------------
		
		/***
		*
		*	Event Handler para o evento de mudança de turno
		*	disparado pelo simulador.
		*
		*******/
		function AtualizaTurno(evt)
		{
			var turno = evt.data.turno < 10 ? "0" + evt.data.turno : evt.data.turno;
			relogio_mc.placa_mc.turnos_txt.text = turno;
						
			// Acaba fase baseado nas metas cumpridas
			//VerificarMetasCumpridas();
		}
		
		/***
		*
		*	Event Handler para o evento de progresso de turno
		*	disparado pelo simulador.
		*
		*******/
		function ProgressoTurno(evt)
		{
			/**** Calculando porcentagem da placa e frame do brilho do relógio ****/
			var frameBrilho = Math.floor(evt.data.percentagem * 100);
			var tempoFase = dataLoader.GetFase().GetTempoConclusao();
			var tempoCorrido = simulador.GetTempoTotalFase();
			var porcentagem = Math.floor( ( tempoCorrido / tempoFase ) * 100 );
			
			if(porcentagem <= 100) /*logio_mc.placa_mc.porcentagem_txt.text = porcentagem + "%";*/
			
			if((( porcentagem / 100 ) * CELULAS_RELOGIO) <= 16) /*logio_mc.brilho_mc.gotoAndStop( frameBrilho );*/
						
			/***** Calculando o a cor da célula do relógio e o possível fim de jogo *****/
			var frameCelula = Math.floor( ( porcentagem / 100 ) * CELULAS_RELOGIO );
			//relogio_mc.barraCores_mc.gotoAndStop( frameCelula );

			if( frameCelula >= CELULAS_RELOGIO )
			{
//				var turnoAtual = simulador.GetTurnoAtual() + 1;
//				if(turnoAtual < 10) turnoAtual = "0" + turnoAtual;
//				relogio_mc.placa_mc.turnos_txt.text = turnoAtual;
				//simulador.PausarSimulacao();
				pausarSimulacaoJanela();
				EncerrarJogo(true);
//				qtdGameOver++;
				EncerrarSons();
				gestorSom.Reproduzir( 'musica-password' , 99999999);
				TweenLite.to(gameOver_mc, 1, {autoAlpha: 1});
			}
		}
		
		function AtualizaIndice(evt)
		{
//			var tinta;
//			if(evt.data.valor <= 0.5) tinta = 0xcc0033;
//			else tinta = 0x4CAFE8;
//			
//			var resultado = evt.data.valor;
//			if(resultado < 0.1) resultado = 0.1;
//			
//			switch(evt.data.indice)
//			{
//				case "Educação":
//					if(indices_mc.barraEducacao_mc.height > 0)
//					{
//						if(indices_mc.barraEducacao_mc.scaleY != resultado)
//						{
//							TweenLite.to(indices_mc.barraEducacao_mc, 0.5, {scaleY: resultado, tint:tinta});
//						}
//					}
//					break;
//				case "Moradia":
//					if(indices_mc.barraMoradia_mc.height > 0)
//					{
//						if(indices_mc.barraMoradia_mc.scaleY != resultado)
//						{
//							TweenLite.to(indices_mc.barraMoradia_mc, 0.5, {scaleY: resultado, tint:tinta});
//						}
//					}
//					break;
//				case "Segurança":
//					if(indices_mc.barraSeguranca_mc.height > 0)
//					{
//						if(indices_mc.barraSeguranca_mc.scaleY != resultado)
//						{
//							TweenLite.to(indices_mc.barraSeguranca_mc, 0.5, {scaleY: resultado, tint:tinta});
//						}
//					}
//					break;
//			}
		}
		
		function AtualizaBarraDesempenho(evt)
		{
			var desempenho = Math.floor(evt.data.valor * 100);
			var frame	   = 100 - desempenho;
			
			//TweenLite.to(barraDesempenho_mc, 1, {frame: frame});
			
			// TODO GAMEOVER
			return;

			if((desempenho <= dataLoader.GetFase().GetIndiceMinimo()) /*&& (!Global.variables.modoEditor)*/)
			{
				//simulador.PausarSimulacao();
				pausarSimulacaoJanela();
				EncerrarJogo(true);
				qtdGameOver++;
				EncerrarSons();
				//gestorSom.PararTudo();
				gestorSom.Reproduzir( 'musica-password' , 99999999);
				TweenLite.to(gameOver_mc, 1, {autoAlpha: 1});
			}
		}
		
		//----------------------------------------------
		// <15> OnEnterFrame e scroll do mapa
		//----------------------------------------------
		
		function OnEnterFrame(evt)
		{
			if( !aplicacaoAtiva ) return ;
			
			if(estadoInterface == ESTADO_GAMEPLAY){
				ScrollMap();
			}
			
			
			if ((estadoInterface == ESTADO_ADICIONAR_CONSTRUCAO) || (estadoInterface == ESTADO_ADICIONAR_EMISSOR))
			{
				var dataLoader 	= DataLoader.GetInstance();
				var estrutura	= dataLoader.GetEstruturaByName( iconeSelecionado.nomeEstrutura );
				var custo = 0

				if(estrutura.GetCategoria() != "Decorativa") {
					custo = estrutura.GetNivel(0).GetCusto();
				}
				
				if((custo <= simulador.GetDinheiroDisponivel()) && (shiftPressed || vaiAdicionar))
				{
					// Posição do cursor em coordenadas isométricas.
					if( Global.variables.android == true )
					{
						var mousePos 	  = new Point((container_mc.x /2) / render.GetZoom(),
													  (container_mc.y /2)  / render.GetZoom());
					}
					else
					{
						var mousePos 	  = new Point((container_mc.mouseX - 1024/2) / render.GetZoom(),
													  (container_mc.mouseY - 768/2)  / render.GetZoom());
					}
					
					var mouseIsoPoint = IsoMath.screenToIso(new Pt(mousePos.x  + render.pan.x, 
																   mousePos.y  + render.pan.y), false);
						
					// Identifica a célula sobre a qual o cursor do mouse se encontra.
					var mouseCellPos = new Point( Math.floor( mouseIsoPoint.x / FaseRender.CELL_SIZE ),
												  Math.floor( mouseIsoPoint.y / FaseRender.CELL_SIZE ) );
					
					// Assegura que o cursor encontra-se sobre o mapa isométrico.
					if (mouseCellPos.x >= 0 && mouseCellPos.y >= 0 &&
						mouseCellPos.x <= simulador.GetTamanhoFase().x - tamanhoSeletor.x && mouseCellPos.y <= simulador.GetTamanhoFase().y - tamanhoSeletor.y)
					{
						seletor.container.visible = true;
						
						// Posiciona o seletor.
						seletor.moveTo( mouseCellPos.x * FaseRender.CELL_SIZE,
										mouseCellPos.y * FaseRender.CELL_SIZE, 0 );
						
						// Verifica se a área onde o seletor encontra-se
						//está disponível para construção.
						var fase = simulador.GetFase();
						var rect = new Rectangle(mouseCellPos.x, mouseCellPos.y, tamanhoSeletor.x, tamanhoSeletor.y);
						seletor.container.alpha = fase.AreaLivre(rect) ? 1 : 0.4; 
						
						render.AtualizarCena( 1 );  // renderiza o grid
					}				
					else seletor.container.visible = false;
				}
				else MudarEstadoInterface( ESTADO_GAMEPLAY );
			}
			
			if(zoomIndex >= 3) AtualizarEmissores();
		}
		
		function ScrollMap()
		{	
			if(keyRolamento) var r = keyRolamento;
			else r = new Point(0, 0);

			if( Global.variables.android != true ){
				if (mouseX < LIMITE_ESQUERDA) 		r.x = -ROLAMENTO;
				else if(mouseX > LIMITE_DIREITA)	r.x = ROLAMENTO;
				if (mouseY < LIMITE_SUPERIOR) 		r.y = -ROLAMENTO;
				else if(mouseY > LIMITE_INFERIOR)	r.y = ROLAMENTO;
			}
				
			var size    			= new Point( simulador.GetTamanhoFase().x * FaseRender.CELL_SIZE, 
										   		 simulador.GetTamanhoFase().y * FaseRender.CELL_SIZE );
			var nextCenterIsoPoint	= IsoMath.screenToIso(new Pt( render.pan.x + r.x, render.pan.y + r.y), false);
			
			if (nextCenterIsoPoint.x < 0 || nextCenterIsoPoint.y < 0 ||
				nextCenterIsoPoint.x > size.x || nextCenterIsoPoint.y > size.y) r = new Point(0, 0);
			
			if (estadoInterface == ESTADO_PAUSA) { r.x = null; r.y = null; }

			render.Rolar(r.x, r.y);
		}
		
		public function MostrarTelaPreta(valor)
		{
			this.telaPreta_mc.visible = valor;
		}
		
		//--------------------------------------------------------------------------------
		// <16> Seletor (retângulo que mostra a área da construção a ser adicionada)
		//--------------------------------------------------------------------------------

		public function seletorBotaoMobile(evt){
			var teste:Event = evt;

			adicionar_mc.addMobile.addEventListener( MouseEvent.CLICK, function(evt){ AcoplarEstruturaSeletor(teste) } );
		}
		
		public function AcoplarEstruturaSeletor(evt)
		{
			if(evt is Event)
				evt.stopPropagation();
			
			vaiAdicionar = true;

			IniciarSeletor();
			
			// Recupera uma referência para o tipo de estrutura que
			// foi clicado pelo usuário.
			iconeSelecionado	= MovieClip(evt.target);
			
			var estrutura     	= dataLoader.GetEstruturaByName( iconeSelecionado.nomeEstrutura );
			tamanhoSeletor	    = estrutura.GetTamanho();

			trace('nome da estrutura e: '+String(iconeSelecionado.nomeEstrutura)+' tamanho do seletor: '+tamanhoSeletor.y+'x'+tamanhoSeletor.x);
			trace('fase render size: '+FaseRender.CELL_SIZE);

			//Configura o tamanho do seletor e o exibe.
			seletor.setSize(tamanhoSeletor.x * FaseRender.CELL_SIZE, tamanhoSeletor.y * FaseRender.CELL_SIZE, 0); 
			seletor.container.visible = true;
			
			OcultarMenuConstrucao(null);
			MudarEstadoInterface( ESTADO_ADICIONAR_CONSTRUCAO );			
		}
		
		function AcoplarEmissorSeletor(evt)
		{
			evt.stopPropagation();
			IniciarSeletor();
			iconeSelecionado = MovieClip(evt.target);
			tamanhoSeletor = new Point(1,1);
			
			seletor.setSize(FaseRender.CELL_SIZE, FaseRender.CELL_SIZE, 0); 
			seletor.container.visible = true;			
			OcultarMenuConstrucao(null);
			MudarEstadoInterface( ESTADO_ADICIONAR_EMISSOR );	
		}
		
		function IniciarSeletor()
		{
			// Seletor não existe.
			if (!seletor)
			{
				trace('inicio seletor')
				seletor 				= new IsoRectangle(); 
				seletor.setSize(FaseRender.CELL_SIZE, FaseRender.CELL_SIZE, 0); 
				var bf : SolidColorFill = new SolidColorFill(100, 0.5);
				seletor.fills 					= [bf];
				seletor.container.visible 		= false;
				render.AdicionarNoGrid(seletor);
				seletor.container.mouseEnabled 	= false;
				seletor.container.mouseChildren = false;
			}
		}
		
		//-------------------------------------voo-------------------------------------//
		
		public function IniciarFiltroMar(pX:int, pY:int, cor:uint){

		}

		public function IniciarFiltroMarRandom (pX:int, pY:int, cor:uint) 
		{
			var cetus = new Cetus();
			var filtroMarRandom:IsoSprite = new IsoSprite();
			
			filtroMarRandom.setSize(30, 30, 0);
			filtroMarRandom.moveTo(pX, pY, 0);
			filtroMarRandom.sprites = [cetus];
			
			render.AdicionarNoGrid(filtroMarRandom, false, 3);

			var posG = IsoMath.isoToScreen( new Pt(pX, pY) );

			// Enquadra a construção alvo do desastre.
			TweenLite.to( render.pan, 0.5, {x: posG.x, y: posG.y, onUpdate: render.AtualizarPan});
		}
		
		public function IniciarFiltroTerreno (pX:int, pY:int, cor:uint) 
		{			
			var plantaDriade = new Planta();
			var filtroTerreno:IsoSprite = new IsoSprite();
			
			filtroTerreno.setSize(30, 30, 0);
			filtroTerreno.moveTo(pX, pY, 0);
			filtroTerreno.sprites = [plantaDriade];
			
			render.AdicionarNoGrid(filtroTerreno, false, 3);

			IsoMath.screenToIso(new Pt(pX,pY), false);
		}

		public function IniciarFiltroTerrenoRandom (pX:int, pY:int, cor:uint) 
		{			
			var driade = new Driade();
			var filtroTerrenoRandom:IsoSprite = new IsoSprite();
			
			filtroTerrenoRandom.setSize(30, 30, 0);
			filtroTerrenoRandom.moveTo(pX, pY, 0);
			filtroTerrenoRandom.sprites = [driade];
			
			render.AdicionarNoGrid(filtroTerrenoRandom, false, 3);

			var posG = IsoMath.isoToScreen( new Pt(pX, pY) );

			// Enquadra a construção alvo do desastre.
			TweenLite.to( render.pan, 0.5, {x: posG.x, y: posG.y, onUpdate: render.AtualizarPan});
		}
		
		public function IniciarFiltroVegetacao (pX:int, pY:int, cor:uint) 
		{
			
		}

		public function IniciarFiltroVegetacaoRandom (pX:int, pY:int, cor:uint) 
		{
			var kaos = new Kaos();
			var filtroVegetacaoRandom:IsoSprite = new IsoSprite();
			
			filtroVegetacaoRandom.setSize(30, 30, 0);
			filtroVegetacaoRandom.moveTo(pX, pY, 0);
			filtroVegetacaoRandom.sprites = [kaos];
			
			render.AdicionarNoGrid(filtroVegetacaoRandom, false, 3);

			var posG = IsoMath.isoToScreen( new Pt(pX, pY) );

			// Enquadra a construção alvo do desastre.
			TweenLite.to( render.pan, 0.5, {x: posG.x, y: posG.y, onUpdate: render.AtualizarPan});
		}

		public function IniciarFiltroConstrucao (pX:int, pY:int, cor:uint) 
		{			
			var buracos = new Transporte();
			var filtroTerreno:IsoSprite = new IsoSprite();
			
			filtroTerreno.setSize(30, 30, 0);
			filtroTerreno.moveTo(pX, pY, 0);
			filtroTerreno.sprites = [buracos];
			
			render.AdicionarNoGrid(filtroTerreno, false, 3);
		}
		
		public function IniciarFiltroConstrucaoRandom (pX:int, pY:int, cor:uint) 
		{
			
		}

		public function AtualizarFiltros(){
			render.AtualizarNoGrid(3);
			render.AtualizarNoGrid(2);
			render.AtualizarNoGrid(1);
		}
		
		public function RemoverFiltros(num:int = 3){
			render.RemoverNoGrid(num);
		}
		
		//-----------------------------------------------------------------------------//
		
		//-----------------------------------
		// <17> Tooltips diversos
		//-----------------------------------
		
		function MostrarTooltip(evt)
		{
			if( Global.variables.android == true ){
				adicionar_mc.addMobile.visible = true;
				adicionar_mc.addMobile.nomeConstrucao.text = "POSICIONAR NO MAPA: " + evt.target.nomeEstrutura;
			}

			var diferencial:Number = (adicionar_mc.mask_mc.x - adicionar_mc.container_mc.x);

			adicionar_mc.tooltipG_mc.nome_txt.text = 'Construção: ' + evt.target.nomeEstrutura;
			adicionar_mc.tooltipG_mc.custo_txt.text = NumberFormat.FormatCurrency( evt.target.custo, 2, ',' , '.', 'K$ ' );

			//if(Global.variables.modoEditor == false)
			//{	
				if(evt.target.desabitados > 0)
				{
					adicionar_mc.tooltipG_mc.beneficio_txt.text = "Pessoas com casa: " + evt.target.desabitados + "\n";
					adicionar_mc.tooltipG_mc.beneficio_txt.text += "Pessoas com emprego: " + Math.round((evt.target.desabitados/100)*10);	
				} 
				else if(evt.target.habitados > 0)
				{
					adicionar_mc.tooltipG_mc.beneficio_txt.text = "Pessoas com casa: -" + Math.round((evt.target.habitados/100)*10) + "\n";
					adicionar_mc.tooltipG_mc.beneficio_txt.text += "Pessoas com emprego: " + evt.target.habitados;
				}

				if(evt.target.habitados > 0)
				{
					adicionar_mc.tooltipG_mc.requisito_txt.text = "Pessoas com casa: " + evt.target.habitados;
				}

				if(evt.target.desabitados > 0)
				{
					adicionar_mc.tooltipG_mc.requisito_txt.text = "Pessoas sem casa: " + evt.target.desabitados;
				}
			//}
			//else
			//{
				//adicionar_mc.tooltipG_mc.beneficio_txt.text = '-';
				//adicionar_mc.tooltipG_mc.requisito_txt.text = '-';
				//adicionar_mc.tooltipG_mc.requisito_txt.text = '-';

			//}

			//adicionar_mc.tooltipG_mc.visible = true;
			adicionar_mc.tooltipG_mc.mouseEnabled = false;
			adicionar_mc.tooltipG_mc.mouseChildren = false;
			
		}
		
		function OcultarTooltip(evt)
		{
			//adicionar_mc.tooltipG_mc.visible = false;
			//adicionar_mc.tooltipP_mc.visible = false;
		}
		
		function ShowToolTipMeta(evt)
		{
			if(!emTutorial) this[evt.target.nomeTooltip].visible = true;
		}
		
		function HideToolTipMeta(evt)
		{
			if(!emTutorial) this[evt.target.nomeTooltip].visible = false;
		}
		
		//-----------------------------
		// <18> Funções de Pausa.
		//-----------------------------
				
		function Pausar(evt = null)
		{
			if( Global.variables.android == true ){ 
				hideAndroidMoveControl(); 
				OcultarTodas();
			}

			tooltipConfiguracoes.visible = false;

			if(timerMouse != null)
				timerMouse.reset();
			
			if(!emEmprestimo) dataLoader.GetFase().GetMusica().Pausar();
			else gestorSom.Pausar( 'musica-power-up' );
			PausarSons();

			//simulador.PausarSimulacao();
			MudarEstadoInterface( ESTADO_PAUSA );

			pausarSimulacaoJanela();
			
			fadeSuperior_mc.alpha = pausa_mc.alpha = 0;		
			TweenLite.to(fadeSuperior_mc, 0.5, {autoAlpha: 1});
			TweenLite.to(pausa_mc		, 0.5, {autoAlpha: 1});
			
			// bloquear interações
		}
		
		public function PausarSons()
		{			
			var estruturas = dataLoader.GetEstruturas();
			for(var i = 0; i < estruturas.length; i++)
			{
				var somPopup = dataLoader.GetSomPopup(estruturas[i].GetNome());
				if(somPopup)
				{
					if(somPopup.IsTocando())
					{
						somPopup.Pausar();
						somPopupEstrutura = estruturas[i].GetNome();
					}
				}
			}
			
			var emissores = dataLoader.GetEmissores();
			for(i = 0; i < emissores.length; i++)
				emissores[i].GetSom().Pausar();
		}
		public function ContinuarSons()
		{
			if(somPopupEstrutura) 
			{
				var somPopup = dataLoader.GetSomPopup(somPopupEstrutura);
				somPopup.Retornar(99999);
			}
			
			var emissores = dataLoader.GetEmissores();
			for(var i = 0; i < emissores.length; i++){
				if(emissores[i].GetSom() != null)
					emissores[i].GetSom().Retornar(9999999);
			}
		}

		public function PausarMusica()
		{
			var fase : Fase = dataLoader.GetFase();
			fase.GetMusica().SetVolume( 0 );
		}
		public function ContinuarMusica()
		{
			var fase : Fase = dataLoader.GetFase();
			fase.GetMusica().SetVolume( opcoes.volume );
		}
		
		function Continuar(evt = null)
		{
			//timerMouse.start();
			if(!emEmprestimo) dataLoader.GetFase().GetMusica().Retornar(9999999);
			else gestorSom.Retornar( 'musica-power-up', 999999);
			ContinuarSons();
			MudarEstadoInterface( ESTADO_GAMEPLAY );
			TweenLite.to(pausa_mc		, 0.5, {autoAlpha: 0});
			TweenLite.to(fadeSuperior_mc, 0.5, {autoAlpha: 0});
			
			simulador.ContinuarSimulacao();
			
			// Desbloquear interações
		}
		
		//---------------------------------------
		// <19> Funções de encerramento do jogo.
		//---------------------------------------
		
		public function Sair(evt = null)
		{
			menu_mc.mouseChildren = false;
			menu_mc.mouseEnabled  = false;
			
			NativeApplication.nativeApplication.exit();
		}
		
		function RegistrarProximoIndicador(evt = null)
		{
			indiceIndicador++;
			//if (indiceIndicador >= arrayIndicadores.length) Sair();
		}
		
		//-----------------------------------
		// <20> Sons e emissores
		//-----------------------------------
		
		function AtualizarEmissores()
		{
			var emissores = dataLoader.GetEmissores();
			for(var i = 0; i < emissores.length; i++)
			{
				var posEmissor 	= IsoMath.isoToScreen(new Pt(emissores[i].GetPosicao().x, 
															 emissores[i].GetPosicao().y), true);
				var posRealEmissorX = stage.stageWidth/2 - (render.GetMapView().currentX - posEmissor.x);
				
				if(posRealEmissorX >= stage.stageWidth/2)
				{
					var volX = (stage.stageWidth - posRealEmissorX) / 512;
					var pan = 1 - volX;
				}
				else
				{
					volX = posRealEmissorX / 512;
					pan = volX - 1;
				}
				
				var posRealEmissorY = stage.stageHeight/2 - (render.GetMapView().currentY - posEmissor.y);
				if(posRealEmissorY < stage.stageHeight/2) var volY = posRealEmissorY;
				else volY = stage.stageHeight - posRealEmissorY;
				
				volY = volY / 512;
				
				var total = (volX + volY)/4;
				
				if(total < 0) emissores[i].GetSom().SetVolume(0);
				else emissores[i].GetSom().SetVolume(total * opcoes.volume);
				
				emissores[i].GetSom().SetPan(pan);
			}
		}
		
		function GuardarEmissor()
		{
			/*
			var pos  = new Point( Math.floor(seletor.x/FaseRender.CELL_SIZE), Math.floor(seletor.y/FaseRender.CELL_SIZE) );
			emissoresAdicionados.push({posicao: pos, caminho: iconeSelecionado.emissor.caminho, nome: iconeSelecionado.emissor.nome});
			
			simulador.AdicionarRepresentacaoEmissor(pos, RepresentacaoEmissor);
			
			MudarEstadoInterface( ESTADO_GAMEPLAY );
			*/
		}
		
		function ReproduzirEmissorInterno()
		{
			var somPopup = dataLoader.GetSomPopup(construcaoClicada.GetEstrutura().GetNome());
			if(somPopup) somPopup.Play(0, 99999999);
		}
		
		function PararEmissorInterno()
		{
			var somPopup = dataLoader.GetSomPopup(construcaoClicada.GetEstrutura().GetNome());
			if(somPopup) somPopup.Stop();
		}
		
		//--------------------------------------
		// <21> Alguns outros eventos
		//--------------------------------------		
		
		function ConstrucaoFinalizada(evt)
		{
			for(var i = 0; i < construindo.length; i++)
			{
				if(evt.data.construcao.GetEstrutura().GetNome() == construindo[i])
				{
					if(construindo.length == 1) gestorSom.Parar( 'construindo' );
					construindo.splice(i, 1);
					gestorSom.Reproduzir( 'construcao-finalizada' );
					VerificaCondicoesConstrucao( evt.data.construcao.GetEstrutura().GetNome() );
				}
			}
			if(!Global.variables.modoEditor) VerificarMetasCumpridas();
		}
		
		function MouseClick(evt)
		{
			if (estadoInterface == ESTADO_ADICIONAR_CONSTRUCAO) 
			{
				evt.stopPropagation();
				AdicionarConstrucao();
			}
			else if(estadoInterface == ESTADO_ADICIONAR_EMISSOR)
			{
				evt.stopPropagation();
				GuardarEmissor();
			}
		}
		
		function KeyPress(evt)
		{
			// ESC
			if (evt.keyCode == 27)
			{
				switch (estadoInterface)
				{
					case ESTADO_GAMEPLAY					: Pausar(); break;
					case ESTADO_PAUSA						: Continuar(null); break;
					case ESTADO_MENU_ADICIONAR_CONSTRUCAO	: OcultarMenuConstrucao(null); break;
					case ESTADO_MENSAGENS					: OcultarMensagens(null); break;
					case ESTADO_CARTA_VOADORA				: cartaVoadora_mc.ocultarMenu(null); break;
					case ESTADO_CONFIGURACOES				: OcultarConfig(null); break;
				}
			}
			else if(evt.keyCode == 16)
			{
				shiftPressed = true;
			}
			else if((estadoInterface == ESTADO_GAMEPLAY) || (estadoInterface == ESTADO_TUTORIAL_PARTE_I))
			{
				if(evt.keyCode == 37 || evt.keyCode == 38 || evt.keyCode == 39 || evt.keyCode == 40 ||
					evt.keyCode == 65 || evt.keyCode == 68 || evt.keyCode == 83 || evt.keyCode == 87)
				{
					var r = new Point(0, 0);
					if( evt.keyCode == 37 || evt.keyCode == 65 ) //seta da esquerda ou 'A'
					{
						r.x = -ROLAMENTO;
					}
					else if( evt.keyCode == 39 || evt.keyCode == 68 ) // seta da direita ou 'D'
					{
						r.x = ROLAMENTO;
					}
					if( evt.keyCode == 38 || evt.keyCode == 87 ) // seta pra cima ou 'W'
					{
						r.y = -ROLAMENTO;
					}
					else if( evt.keyCode == 40 || evt.keyCode == 83 ) // seta pra baixo ou 'S'
					{
						r.y = ROLAMENTO;
					}
					keyRolamento = r;
				}
				else if(evt.keyCode == 81) // tecla Q: construir
				{
					MenuAddConstrucao(null);
				}
				else if(evt.keyCode == 70) // tecla F: objetivos
				{
					//AbrirTelaMetas(null);
				}
				else if(evt.keyCode == 69) // tecla E: mensagens
				{
					MostrarMensagens(null);
				}
				else if(evt.keyCode == 67){ // tecla C: carta
					MostrarCarta();
				}
				else if(evt.keyCode == 79){ //tecla O: configuracoes
					MostrarConfiguracoes();
				}
				else if(evt.keyCode == 73){ //tecla I: sair do jogo
					SairJogo();
				}

				trace(evt.keyCode)
			}
		}
		
		function KeyUp(evt)
		{
			if(evt.keyCode == 37 || evt.keyCode == 38 || evt.keyCode == 39 || evt.keyCode == 40 ||
			   evt.keyCode == 65 || evt.keyCode == 68 || evt.keyCode == 83 || evt.keyCode == 87)
			{
				keyRolamento = null;
			}
			if(evt.keyCode == 16)
			{
				shiftPressed = false;
			}
		}
		
		//--------------------------------------------
		// <22> Opções de salvar algumas coisas
		//--------------------------------------------
		
		public function SalvarConstrucaoArquivo(fase:Number):void
        {
            var construcoes = simulador.GetFase().GetConstrucoes();
			
			if(fase == 0)
			{
				var nomeDaFase:String = Global.variables.faseConstrucao;
				var arquivo:String = Arquivo.GetPastaAplicacao(false) + "saves" + Arquivo.GetSeparador() + nomeDaFase+".xml";
			} 
			else 
			{
				var arquivo:String = Arquivo.GetPastaAplicacao(false) + "saves" + Arquivo.GetSeparador() + "fase"+fase+".xml";
			}
          
		  	var outputString:String = '<?xml version="1.0" encoding="utf-8"?>\n';
			//var prefsXML = <elementos/>;
			
			outputString += '<fase>'+ Arquivo.GetQuebraLinha();
				outputString += '<populacao>'+Math.round(populacaoObj.populacao)+'</populacao>'+ Arquivo.GetQuebraLinha();
				outputString += '<habitados>'+Math.round(habitadosObj.habitados)+'</habitados>'+ Arquivo.GetQuebraLinha();
				outputString += '<empregados>'+Math.round(empregadosObj.empregados)+'</empregados>'+ Arquivo.GetQuebraLinha();
				outputString += '<dinheiro>'+dinheiroObj.quantidade+'</dinheiro>'+ Arquivo.GetQuebraLinha();
				outputString += '<pontuacao>'+pontuacaoObj.quantidade+'</pontuacao>'+ Arquivo.GetQuebraLinha();
			
				outputString += '<mapa>'+ Arquivo.GetQuebraLinha();
					outputString += '<elementos>'+ Arquivo.GetQuebraLinha();
			
			/******* Construções funcionais ******/
			outputString += '<!-- Construções funcionais -->' + Arquivo.GetQuebraLinha() + Arquivo.GetQuebraLinha();
			for(var i = 0; i < construcoes.length; i++)
			{
				if((construcoes[i] is ConstrucaoFuncional) &&
				   (construcoes[i].GetEstrutura().GetNome() != "Habitação"))
				{
					outputString += '<elemento>' + Arquivo.GetQuebraLinha();
					outputString += '    <tipo>construcao</tipo>' + Arquivo.GetQuebraLinha();
					outputString += '    <construcao>' + construcoes[i].GetNivel().GetNome() + '</construcao>' + Arquivo.GetQuebraLinha();
					outputString += '    <posicao>' + construcoes[i].GetPosicao().x + "x" + construcoes[i].GetPosicao().y + '</posicao>' + Arquivo.GetQuebraLinha();
					outputString += '</elemento>' + Arquivo.GetQuebraLinha();
				}
			}
			
			/******* Construções decorativas ******/
			outputString += Arquivo.GetQuebraLinha() + '<!-- Construções decorativas -->' + Arquivo.GetQuebraLinha() + Arquivo.GetQuebraLinha();
			for(i = 0; i < construcoes.length; i++)
			{
				if(construcoes[i] is ConstrucaoDecorativa)
				{
					outputString += '<elemento>' + Arquivo.GetQuebraLinha();
					outputString += '    <tipo>decorativo</tipo>' + Arquivo.GetQuebraLinha();
					outputString += '    <nome>' + construcoes[i].GetEstrutura().GetNome() + '</nome>' + Arquivo.GetQuebraLinha();
					outputString += '    <posicao>' + construcoes[i].GetPosicao().x + "x" + construcoes[i].GetPosicao().y + '</posicao>' + Arquivo.GetQuebraLinha();
					outputString += '</elemento>' + Arquivo.GetQuebraLinha();
				}
			}
			/****** Emissores de Som ******/
			outputString += Arquivo.GetQuebraLinha() + '<!-- Emissores de som -->' + Arquivo.GetQuebraLinha() + Arquivo.GetQuebraLinha();
			for(i = 0; i < emissoresAdicionados.length; i++)
			{
				outputString += '<elemento>' + Arquivo.GetQuebraLinha();
				outputString += '    <tipo>emissor_som</tipo>' + Arquivo.GetQuebraLinha();
				outputString += '    <nome>' + emissoresAdicionados[i].nome + '</nome>' + Arquivo.GetQuebraLinha();
				outputString += '    <caminho>' + emissoresAdicionados[i].caminho + '</caminho>' + Arquivo.GetQuebraLinha();
				outputString += '    <posicao>' + emissoresAdicionados[i].posicao.x + "x" + emissoresAdicionados[i].posicao.y + '</posicao>' + Arquivo.GetQuebraLinha();
				outputString += '</elemento>' + Arquivo.GetQuebraLinha();
			}
			
					outputString += '</elementos>'+ Arquivo.GetQuebraLinha();
				outputString += '</mapa>'+ Arquivo.GetQuebraLinha();
			outputString += '</fase>';
			
			//outputString += prefsXML.toXMLString();

			trace('------------------------>> SALVANDO: ' + arquivo);
			
			if( Arquivo.ExisteArquivo(arquivo, false) )
			{
				Arquivo.DeletarArquivo(arquivo, false);
			}

            Arquivo.EscreverArquivo(arquivo, outputString, false);
        }
		
		function SalvarOpcoes()
		{
			var outputString:String = '<?xml version="1.0" encoding="utf-8"?>\n';
			var prefsXML = <preferences/>;
			prefsXML.opcoes.@volume = opcoes.volume;
			prefsXML.opcoes.@qualidade = qualidadeGlobal;
			prefsXML.opcoes.@janela = janelaGlobal;
			outputString += prefsXML.toXMLString();
			
			Arquivo.EscreverArquivo(arquivoConfiguracoes, outputString, false);	
		}

		public function salvarImagemMapa(nome:String, conteudo: ByteArray){
			var arquivo:String = Arquivo.GetPastaAplicacao(false) + Arquivo.GetSeparador() + "data" + Arquivo.GetSeparador() + "texturas" + Arquivo.GetSeparador() + nome + '.jpg';
	
			Arquivo.EscreverArquivoBytes(arquivo, conteudo, false);
		}

		public function salvarArquivoMapa(nome:String){
			//gera o xml do mapa
			var arquivo:String = Arquivo.GetPastaAplicacao(false) + "data" + Arquivo.GetSeparador() + "fases" + Arquivo.GetSeparador() + nome + '.xml';
          
		  	var outputString:String = '<?xml version="1.0" encoding="utf-8"?>\n';
		  	outputString +='<fase>';
		  	outputString +='	<tutorial>false</tutorial>'
		  	outputString +='	<numero>0</numero>'
		  	outputString +='	<texto_descritivo></texto_descritivo>'
		  	outputString +='	<tempo>0</tempo>'
		  	outputString +='	<populacao>10000</populacao>'
		  	outputString +='	<dinheiro>100000</dinheiro>'
		  	outputString +='	<constante_k>0.10</constante_k>'
		  	outputString +='	<indice_minimo>10</indice_minimo>'
		  	outputString +='	<populacao_considerada>0.05</populacao_considerada>'
		  	outputString +='	<tempo_emprestimo>0</tempo_emprestimo>'
		  	outputString +='	<tempo_gastar_emprestimo>0</tempo_gastar_emprestimo>'
		  	outputString +='	<valor_emprestimo>0</valor_emprestimo>'
		  	outputString +='	<camera>28x36</camera>'
		  	outputString +='	<musica>'+Arquivo.GetPastaAplicacao() +'data'+Arquivo.GetSeparador()+'musicas'+Arquivo.GetSeparador()+'tema1.mp3</musica>'
		  	outputString +='	<nivel_inicial>0</nivel_inicial>'
		  	outputString +='	<nivel_max>3</nivel_max>'
		  	outputString +='	<objetivos></objetivos>'
		  	outputString +='	<mensagens>'
		  	outputString +='		<mensagem>'
			outputString +=				'<condicoes>'
			outputString +=					'<condicao>'
			outputString +=						'<tipo>variavel</tipo>'
			outputString +=						'<variavel>Fase0</variavel>'
			outputString +=						'<condicao>igual</condicao>'
			outputString +=						'<valor>1</valor>'
			outputString +=					'</condicao>'
			outputString +=				'</condicoes>'
			outputString +=				'<titulo>Construa sua cidade</titulo>'
			outputString +=				'<texto>'
			outputString +=					'<![CDATA[Olá, meu nome é Rei Kimera, seja criativo e construa sua cidade.]]>'
			outputString +=				'</texto>'
			outputString +=				'<personagem>Rei Kimera Semente</personagem>'
			outputString +=				'<funcao></funcao>'
			outputString +='		</mensagem>'
		  	outputString +='	</mensagens>'
		  	outputString +='	<mapa>'
			outputString +='		<tamanho>56x72</tamanho>'
			outputString +='		<elementos>'
			outputString +='			<elemento>'
			outputString +='				<tipo>textura</tipo>'
			outputString +='				<textura>'+ Arquivo.GetPastaAplicacao(false) + 'data' + Arquivo.GetSeparador() + 'texturas' + Arquivo.GetSeparador() + nome +'.jpg</textura>'
			outputString +='				<tamanho>56x72</tamanho>'
			outputString +='				<posicao>1x1</posicao>'
			outputString +='			</elemento>'
			outputString +='		</elementos>'
			outputString +='	</mapa>'
		  	outputString +='</fase>';

		  	Arquivo.EscreverArquivo(arquivo, outputString, false);
		}
		
		//------------------------------------------
		// <23> Funções da scroll bar
		//------------------------------------------
		
		function ButtonDown( scroll_mc, track_mc)
		{
			if (scroll_mc.y + VELOCIDADE_ROLAGEM_TEXTO > track_mc.height) scroll_mc.y = track_mc.height;
			else scroll_mc.y += VELOCIDADE_ROLAGEM_TEXTO;
		}
		
		function ButtonUp( scroll_mc, track_mc )
		{			
			if (scroll_mc.y - VELOCIDADE_ROLAGEM_TEXTO < 0) scroll_mc.y = 0;
			else scroll_mc.y -= VELOCIDADE_ROLAGEM_TEXTO;			
		}
		
		function ButtonRight( scroll_mc, track_mc)
		{
			if (scroll_mc.x + scroll_mc.width + VELOCIDADE_ROLAGEM_ICONES > track_mc.width) scroll_mc.x = track_mc.width - scroll_mc.width;
			else scroll_mc.x += VELOCIDADE_ROLAGEM_ICONES;
		}
		
		function ButtonLeft( scroll_mc, track_mc )
		{			
			if (scroll_mc.x - VELOCIDADE_ROLAGEM_ICONES < 0) scroll_mc.x = 0;
			else scroll_mc.x -= VELOCIDADE_ROLAGEM_ICONES;
		}
		
		//--------------------------
		// <26> Úteis.
		//--------------------------
		
		function VerificaCondicoesConstrucao( nomeEstrutura : String ) : void
		{
			engine.verificaCondicoesConstrucao(nomeEstrutura);
		}
		
		function VerificarNovaFase(numeroFase : Number) : void
		{
			engine.verificarNovaFase(numeroFase);
		}
		
		function VerificarNovaMensagem() : void
		{
			engine.verificarNovaMensagem();
		}
		
		function VerificarFechamentoMensagem() : void
		{
			engine.verificarFechamentoMensagem();
		}
		
		function CompararChave(codigo)
		{
			for(var i = 0; i < palavrasChave.length; i++)
			{
				if(i == 3){
					//extra

					var fase = "fase-extra.xml";
					if(palavrasChave[i].key == codigo) return {fase: fase, ok: true};
				} else {
					//normal

					var numFase = i + 2; // a partir da fase 2
					var fase = "fase" + numFase + ".xml";
					if(palavrasChave[i].key == codigo) return {fase: fase, ok: true};
				}
			}
			return {fase: null, ok: false};
		}
		
		function VerificaNivelJogador(nivel) : Boolean
		{
			//if(nivel.GetNivelJogador() <= Number(nivelJogador_mc.nivel_txt.text)) return true;
			//else return false;

			return false;
		}
		
		// Jogador ausente do computador (AFK: away from keyboard) => vai pausar a simulação.
		function JogadorAFK(evt)
		{
			//Pausar();
		}
		
		function MovimentoMouse(evt)
		{
			if(timerMouse)
			{
				timerMouse.reset();
				timerMouse.start();
			}
		}
		
		function LimparContainerConstrucoes()
		{
			while (adicionar_mc.container_mc.numChildren > 0)
			{
				if( Global.variables.android == true )
				{
					adicionar_mc.container_mc.getChildAt(0).doubleClickEnabled = true; 
					adicionar_mc.container_mc.getChildAt(0).removeEventListener(MouseEvent.DOUBLE_CLICK, AcoplarEstruturaSeletor);
					adicionar_mc.container_mc.getChildAt(0).removeEventListener(MouseEvent.MOUSE_DOWN, MostrarTooltip);
					adicionar_mc.container_mc.getChildAt(0).removeEventListener(MouseEvent.MOUSE_UP, OcultarTooltip);
				}
				else
				{
					adicionar_mc.container_mc.getChildAt(0).removeEventListener(MouseEvent.CLICK, AcoplarEstruturaSeletor);
					adicionar_mc.container_mc.getChildAt(0).removeEventListener(MouseEvent.MOUSE_OVER, MostrarTooltip);
					adicionar_mc.container_mc.getChildAt(0).removeEventListener(MouseEvent.MOUSE_OUT, OcultarTooltip);
				}
				
				adicionar_mc.container_mc.removeChildAt(0);
			}
		}
		
		public function MudarEstadoInterface( novoEstado )
		{
			estadoAnterior  = estadoInterface;
			estadoInterface = novoEstado;
			
			if (novoEstado == ESTADO_MENU_PRINCIPAL)
			{
				if(estadoAnterior != ESTADO_CONFIGURACOES )
				{
					gestorSom.PararTudo();
					gestorSom.Reproduzir('musica-menu-principal', 99999);
				}
			}
			
			if (novoEstado == ESTADO_ADICIONAR_CONSTRUCAO)
			{
				render.SetEdicaoConstrucoesHabilitado( false );
			}
			else
			{				
				if  (novoEstado == ESTADO_CARREGANDO)
				{
					carregando_mc.visible = true;

					stage.removeEventListener( KeyboardEvent.KEY_DOWN, KeyPress );
					stage.removeEventListener( KeyboardEvent.KEY_UP  , KeyUp );

					NativeApplication.nativeApplication.removeEventListener(KeyboardEvent.KEY_DOWN,checkKeypress);

					gestorSom.PararTudo();
					if( !gestorSom.EstaTocando('musica-menu-principal') ) gestorSom.Reproduzir('musica-carregando', 99999);
				}
				else 
				{
					if (seletor) seletor.container.visible = false;
					
					if (novoEstado == ESTADO_GAMEPLAY)
					{
						render.SetEdicaoConstrucoesHabilitado( true );
						carregando_mc.visible = false;

						stage.addEventListener( KeyboardEvent.KEY_DOWN, KeyPress );
						stage.addEventListener( KeyboardEvent.KEY_UP  , KeyUp );

						NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN,checkKeypress);
					}
				}
			}
		}

	}
}