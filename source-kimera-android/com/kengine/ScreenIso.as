package com.kengine
{
	import flash.display.MovieClip;
	
	public class ScreenIso extends Screen
	{
		// Constantes
		const LIMITE_ESQUERDA 	: int = 20;
		const LIMITE_DIREITA 	: int = 1004;
		const LIMITE_SUPERIOR 	: int = 20;
		const LIMITE_INFERIOR 	: int = 708;
		const ROLAMENTO 		: int = 20;
		
		const ESTADO_PAUSA			  	   	   : String = "estado_pausa";
		const ESTADO_GAMEPLAY			  	   : String = "estado_gameplay";
		const ESTADO_ADICIONAR_CONSTRUCAO 	   : String = "estado_adicionar_construcao";
		const ESTADO_ADICIONAR_EMISSOR 	   	   : String = "estado_adicionar_emissor";
		const ESTADO_MENU_ADICIONAR_CONSTRUCAO : String = "estado_menu_adicionar_construcao";
		const ESTADO_CARREGANDO				   : String = "estado_carregando";
		const ESTADO_CONFIGURACOES 			   : String = "estado_configuracoes";		
		const ESTADO_CARREGAR_JOGO 			   : String = "estado_carregar_jogo";
		const ESTADO_MENU_PRINCIPAL			   : String = "estado_menu_principal";
		const ESTADO_MENSAGENS				   : String = "estado_mensagens";
		const ESTADO_TELA_METAS				   : String = "estado_tela_metas";
		const ESTADO_TUTORIAL		   		   : String = "estado_tutorial";
		const ESTADO_TUTORIAL_PARTE_I		   : String = "estado_tutorial_primeira_parte";
		const ESTADO_TUTORIAL_PARTE_II		   : String = "estado_tutorial_segunda_parte";
		
		const CELULAS_RELOGIO 	: Number = 16;
		const WIDTH_ICONE_META	: Number = 37.15;
		const HEIGHT_ICONE_META	: Number = 38.5;
		const POSICAOX_PERS 	: Number = 4;
		const POSICAOY_PERS 	: Number = 13;
		const QUANTIDADE_PERS	: Number = 6;
		const SLOTS_METAS		: Number = 6;
		
		// Variáveis
		var render    : FaseRender = null;
		var simulador : Simulador;
		
		var aplicacaoAtiva : Boolean = true;   // mapa não rola em tela de desastre e de atualizar construção;
		
		var indice : String = "Moradia";
		
		var arrayDecodificado : Array  = new Array();
		
		// Som
		var opcoes 	  : Object;
		var sliderSom : SliderBar;
		var somPopupEstrutura : String;
		
		var arquivoConfiguracoes : String;
		
		var keyRolamento = null;
		
		// -------------- Globais ------------------//
		Global.variables.modoEditor = false; // quando true, dinheiro fica infinito, pode-se construir cosntruções
											 // decorativas e pode-se possicionar emissores de som.
		
		
		var graficoClicado    : IsoSprite;
		var tamanhoSeletor    : Point;
		
		var seletor		      : IsoRectangle = null;
		var iconeSelecionado  : MovieClip 	 = null;
		
		var construcaoClicada = null;
		
		// ------------ Emissão de Som -------------//
		var emissores 	: Array     = null;
		var gestorSom 	: GestorSom = null;
		var construindo : Array     = new Array(); // array com os nomes das construções que estão em construção / conserto.
		var emissoresAdicionados : Array = new Array();
		
		var indexTransito : int = 1;
		
		// Zoom.
		var zoomFactors	: Array = [0.25, 0.4, 0.7, 1, 1.3, 1.5];
		var zoomIndex 	: int   = 3;
		
		// Fase.
		var fase 		  : Fase	   = null;
		var dataLoader	  : DataLoader = null;
		var faseACarregar : String     = null;
		
		/* eventosCriadosI indica se alguns eventos de interface já foram criados. Para a fase tutorial eles não são criados.
		* eventosCriadosII indica se os eventos de gameplay já foram criados. Esses dois indicadores servem para 
		* eventos não serem criados mais de uma vez */
		
		var eventosCriadosI  : Boolean = false;
		var eventosCriadosII : Boolean = false;
		
		// Personagem
		var char 		   : String = "char1GP_mc"; // nome do MovieClip de personagem escolhido
		var nomePersonagem : String = "";			// nome dado pelo jogador
		
		// Auxiliares interface.
		var dinheiroObj   : Object = {quantidade: 0};
		var populacaoObj  : Object = {populacao: 0};
		
		// Interface		
		var scrollBarMensagens   : Scrollbar 		= null;
		var scrollBarConstrucoes : ScrollHorizontal = null;
		
		// Empréstimo
		var emEmprestimo 	: Boolean = false;
		var vaiAdicionar 	: Boolean = false;
		var emprestimoAtual : Object  = {quantidade: 0};
		
		var construcaoDesastre = null; // Construção afetada pelo último desastre ocorrido.
		
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
		var timerMouse : Timer = null;
		
		var qtdVezesEmprestimoFase : int;
		
		var cronometroFase        = null;
		var cronometroSelecaoPers = null;
		var cronometroMenu		  = null;
		var cronometroMsgTutorial = null;
		
		var tempoTotalPausa  = 0;
		var qtdGameOver      = 0;
		
		var qtdConstrucoes = {moradia: 0, educacao: 0, seguranca: 0, copa: 0};
		
		public function ScreenIso()
		{
			super();
						
			// Fase render.						
			render = FaseRender.GetInstance();
			//container_mc.addChild( render.GetMapView() );
			addChild( render.GetMapView() );
			
			//MudarEstadoInterface( ESTADO_MENU_PRINCIPAL );
			setState( ESTADO_MENU_PRINCIPAL );
			
			if(Global.variables.modoEditor) ConfigurarModoEditor();
			else ConfigurarModoNormal();
		}
		
		override public function initInterface() : void
		{
			// Visibilidade (todos os elementos de interface que iniciam invisíveis)
			
			//tooltipConstrucoes_mc.visible = false;
		}
		
		public function ConfigEditorMode() : void
		{
			/* Nesse modo podemos adicionar ao mapa também estruturas decorativas e emissores de som.
			Para emissores, é utilizada uma representação gráfica para melhor visualização. É bom para
			construção de mapas, pois há uma opção de salvar tudo o que foi posto no mapa, juntamente com suas
			posições, em um arquivo que aparecerá na pasta raiz. */
			
			adicionar_mc.decorativa_btn.addEventListener( MouseEvent.CLICK, ExibirMenuDecorativas );
			adicionar_mc.emissor_btn.addEventListener( MouseEvent.CLICK	 , ExibirMenuEmissores );
			salvarPosicoes_btn.addEventListener( MouseEvent.CLICK	     , SalvarConstrucaoArquivo );
		}
		
		public function ConfigNormalMode() : void
		{
			adicionar_mc.decorativa_btn.visible = false;
			adicionar_mc.emissor_btn.visible    = false;
			salvarPosicoes_btn.visible  		= false;
		}
		
		override public function setState( newState : String ) : void
		{
			super.setState(newState);
			
			if (newState == ESTADO_MENU_PRINCIPAL)
			{
				if(interfaceOldState != ESTADO_CONFIGURACOES )
				{
					gestorSom.PararTudo();
					gestorSom.Reproduzir('musica-menu-principal', 99999);
				}
			}
			
			if (newState == ESTADO_ADICIONAR_CONSTRUCAO)
			{
				render.SetEdicaoConstrucoesHabilitado( false );
			}
			else
			{				
				if  (newState == ESTADO_CARREGANDO)
				{
					carregando_mc.visible = true;
					gestorSom.PararTudo();
					if( !gestorSom.EstaTocando('musica-menu-principal') ) gestorSom.Reproduzir('musica-carregando', 99999);
				}
				else 
				{
					if (seletor) seletor.container.visible = false;
					
					if (newState == ESTADO_GAMEPLAY)
					{
						render.SetEdicaoConstrucoesHabilitado( true );
						carregando_mc.visible = false;
					}
				}
			}
		}
		
		override public function keyPress(evt) : void
		{
			super.KeyPress(evt);
			
			if (evt.keyCode == 27)
			{
				switch (estadoInterface)
				{
					case ESTADO_GAMEPLAY					: Pausar(); break;
					case ESTADO_ADICIONAR_CONSTRUCAO		: MudarEstadoInterface( ESTADO_GAMEPLAY ); break;
					case ESTADO_MENU_ADICIONAR_CONSTRUCAO	: OcultarMenuConstrucao(null); break;
					case ESTADO_PAUSA						: Continuar(null); break;
					case ESTADO_CONFIGURACOES				: OcultarConfig(null); break;
					case ESTADO_CARREGAR_JOGO				: OcultarCarregarJogo(null); break;
					case ESTADO_MENSAGENS					: OcultarMensagens(null); break;
					case ESTADO_TELA_METAS					: OcultarTelaMetas(null); break;
				}
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
				else if(evt.keyCode == 70) // tecla Q: objetivos
				{
					AbrirTelaMetas(null);
				}
				else if(evt.keyCode == 69) // tecla E: mensagens
				{
					MostrarMensagens(null);
				}
			}
		}
		
		override public function keyUp(evt) : void
		{
			super.KeyUp(evt);
			
			if(evt.keyCode == 37 || evt.keyCode == 38 || evt.keyCode == 39 || evt.keyCode == 40 ||
				evt.keyCode == 65 || evt.keyCode == 68 || evt.keyCode == 83 || evt.keyCode == 87)
			{
				keyRolamento = null;
			}
		}
	}
}