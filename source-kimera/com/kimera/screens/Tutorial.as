package com.kimera.screens
{
	import com.kengine.Screen;
	import com.kimera.KimeraGame;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import gs.TweenLite;
	
	public class Tutorial extends Screen
	{
		override public function initInterface() : void 
		{
			this.sair_btn.addEventListener( MouseEvent.CLICK	        	, sair );
			this.sair_btn.addEventListener( MouseEvent.MOUSE_OVER	     	, mouseOverBotao );

			this.conteudoPc.visible = false;
			this.conteudoAndroid.visible = false;
			
			this.visible = false;
		}
		
		public function abrir(evt = null)
		{
			Game.getInstance().MudarEstadoInterface("estado_menu_principal");
			
			TweenLite.to(this, 0.5, {autoAlpha: 1});

			if( Global.variables.android == true ){ 
				this.conteudoAndroid.visible = true;
				this.conteudoPc.visible = false;

				this.conteudoAndroid.gotoAndPlay(2);
			} else {
				this.conteudoPc.visible = true;
				this.conteudoAndroid.visible = false;
			}
		}
		
		function sair(evt = null)
		{
			TweenLite.to(this, 0.5, {autoAlpha: 0});
		}
		
		function mouseOverBotao(evt)
		{
			Game.getInstance().gestorSom.Reproduzir( 'mouse-over' );
		}
	}
}