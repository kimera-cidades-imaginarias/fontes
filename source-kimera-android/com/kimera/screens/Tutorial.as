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
			
			this.visible = false;
		}
		
		public function abrir(evt = null)
		{
			TweenLite.to(this, 0.5, {autoAlpha: 1});
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