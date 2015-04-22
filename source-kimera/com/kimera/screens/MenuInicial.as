package com.kimera.screens
{
	import com.kengine.Screen;
	import com.kimera.KimeraGame;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	import gs.TweenLite;
	
	public class MenuInicial extends Screen
	{
		override public function initInterface() : void 
		{
			loginScreen.visible = false;
			loginScreen.loader.visible = false;

			loginScreen.btSair.addEventListener( MouseEvent.MOUSE_OVER	 , mouseOverBotao );
			loginScreen.btSair.addEventListener( MouseEvent.CLICK	    , ocultarLogin);

			loginScreen.btLogar.addEventListener( MouseEvent.MOUSE_OVER	 , mouseOverBotao ); 
			loginScreen.btLogar.addEventListener( MouseEvent.CLICK	    , iniciarJogo); 

			loginScreen.btPular.addEventListener( MouseEvent.MOUSE_OVER	 , mouseOverBotao ); 
			loginScreen.btPular.addEventListener( MouseEvent.CLICK	    , iniciarJogoDireto); 

			//menuInterior_mc.novoJogo_btn.addEventListener( MouseEvent.CLICK	    , mostrarLogin); 
			menuInterior_mc.novoJogo_btn.addEventListener( MouseEvent.CLICK	    , iniciarJogoDireto); 
			
			menuInterior_mc.continuar_btn.addEventListener( MouseEvent.CLICK	, abrirTelaCarregar );
			menuInterior_mc.tutorial_btn.addEventListener( MouseEvent.CLICK	    , mostrarTutorial ); 
			menuInterior_mc.creditos_btn.addEventListener( MouseEvent.CLICK	    , mostrarCreditos );
			menuInterior_mc.configuracoes_btn.addEventListener( MouseEvent.CLICK, mostrarConfiguracoes );
			menuInterior_mc.sair_btn.addEventListener( MouseEvent.CLICK	        , sair );
			
			menuInterior_mc.novoJogo_btn.addEventListener( MouseEvent.MOUSE_OVER	 , mouseOverBotao );
			menuInterior_mc.continuar_btn.addEventListener( MouseEvent.MOUSE_OVER	 , mouseOverBotao );
			menuInterior_mc.tutorial_btn.addEventListener( MouseEvent.MOUSE_OVER	 , mouseOverBotao );
			menuInterior_mc.creditos_btn.addEventListener( MouseEvent.MOUSE_OVER	 , mouseOverBotao );
			menuInterior_mc.configuracoes_btn.addEventListener( MouseEvent.MOUSE_OVER, mouseOverBotao );
			menuInterior_mc.sair_btn.addEventListener( MouseEvent.MOUSE_OVER	     , mouseOverBotao );

			menuInterior_mc.construir_btn.addEventListener( MouseEvent.CLICK	    , mostrarConstruirCidade ); 
			menuInterior_mc.construir_btn.addEventListener( MouseEvent.MOUSE_OVER	, mouseOverBotao ); 

			menuInterior_mc.kamplus_btn.addEventListener( MouseEvent.CLICK	    , mostrarKamplus ); 
			menuInterior_mc.kamplus_btn.addEventListener( MouseEvent.MOUSE_OVER	, mouseOverBotao ); 
		}

		function iniciarJogo(evt){
			if(Global.variables.android == true){
				Global.variables.ludens = false;
				KimeraGame.getInstance().iniciarJogo(evt);
			} else {
				Global.variables.ludens = true;
				Game.getInstance().ValidarLogin(loginScreen.ludens_login.text, loginScreen.ludens_senha.text);

				mostrarLoader();
			}
		}

		function iniciarJogoDireto(evt){
			Global.variables.ludens = false;

			Game.getInstance().menu_mc.ocultarLoader();
			Game.getInstance().menu_mc.ocultarLogin();
			
			KimeraGame.getInstance().iniciarJogo(evt);
		}

		public function ocultarLogin(evt = null){
			loginScreen.visible = false;
		}

		public function mostrarLogin(evt = null)
		{
			loginScreen.visible = true;
		}

		public function ocultarLoader(evt = null){
			loginScreen.loader.visible = false;
		}

		public function mostrarLoader(evt = null)
		{
			loginScreen.loader.visible = true;
		}

		public function shacke(evt = null)
		{
			ocultarLoader();

			shakeTween(loginScreen, 5);
		}

		function shakeTween(item:MovieClip, repeatCount:int):void
		{
		   TweenLite.to(item,0.5,{repeat:repeatCount-1, y:item.y+(1+Math.random()*5), x:item.x+(1+Math.random()*5), delay:0.5});
		   TweenLite.to(item,0.5,{y:item.y, x:item.x, delay:(repeatCount+1) * .1});
		}
				
		function mostrarConfiguracoes(evt)
		{
			Game.getInstance().MostrarConfiguracoes(evt);
		}
		
		function abrirTelaCarregar(evt)
		{
			Game.getInstance().AbrirTelaCarregar(evt);
		}
		
		function novoJogo(evt)
		{
			Game.getInstance().NovoJogo(evt);
		}
		
		function sair(evt)
		{
			Game.getInstance().Sair(evt);
		}
		
		function mostrarCreditos(evt = null){
			Game.getInstance().MostrarCreditos();
		}
		
		function mostrarTutorial(evt = null){
			Game.getInstance().MostrarTutorial();
		}
		
		function mostrarConstruirCidade(evt = null){
			Game.getInstance().MostrarConstruirCidade();
		}

		function mostrarKamplus(evt = null){
			Game.getInstance().MostrarKamplus();
		}

		function mouseOverBotao(evt)
		{
			Game.getInstance().gestorSom.Reproduzir( 'mouse-over' );
		}
	}
}
