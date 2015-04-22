package com.kengine
{
	import flash.display.Sprite;
	
	public class Engine extends Sprite
	{		
		static private var _instance : Engine;
		protected var _game : Game;
		
		public function Engine(__game : Game)
		{			
			super();
			
			_game = __game;
			_instance = this;
		}
		
		static public function getInstance() : Engine
		{
			if(_instance) return _instance;
			_instance = new Engine(Game.getInstance());
			return _instance;
		}
		
		public function pararMusica()
		{
			_game.gestorSom.PararTudo();
		}
		
		/******************************
		 * Tratamento do fluxo do jogo
		 ******************************/
		
		/**
		 * Chamada ao iniciar o jogo
		 */
		public function inicioMotor() : void
		{
			
		}
		
		/**
		 * Verifica condições ao construir nova edificação
		 */
		public function verificaCondicoesConstrucao( nomeEstrutura : String ) : void
		{
			
		}
		
		/**
		 * Verifica alguma condição do jogo
		 */
		public function verificaFluxoDeJogo( chave : String ) : void
		{
			
		}
		
		/**
		 * Verifica condições ao inicio de uma nova fase
		 */
		public function verificarNovaFase( numeroFase : Number ) : void
		{
			
		}
		
		/**
		 * Verifica condições ao receber nova mensagem (A mensagem deve chamar essa funcao)
		 */
		public function verificarNovaMensagem() : void
		{
			
		}
		
		/**
		 * Verifica condições ao fechar tela de mensagem
		 */
		public function verificarFechamentoMensagem() : void
		{
			
		}
	}
}