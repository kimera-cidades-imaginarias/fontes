package com.kimera.screens
{
	import com.kengine.Screen;
	import com.kimera.KimeraGame;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import gs.TweenLite;
	
	public class Creditos extends Screen
	{
		public var proximoSlide:Number = new Number(0);

		override public function initInterface() : void 
		{
			//screen
			sair_btn.addEventListener( MouseEvent.CLICK, sair );
			sair_btn.addEventListener( MouseEvent.MOUSE_OVER, mouseOverBotao );
			
			this.visible = false;
		}
		
		public function abrir(evt = null)
		{
			Game.getInstance().MudarEstadoInterface("estado_menu_principal");

			TweenLite.to(this, 0.5, {autoAlpha: 1});
			this.gotoAndPlay(2);
		}
		
		public function sair(evt = null)
		{
			TweenLite.to(this, 0.5, {autoAlpha: 0});
		}
		
		public function mouseOverBotao(evt)
		{
			Game.getInstance().gestorSom.Reproduzir( 'mouse-over' );
		}

		public function reproduzir(n:Number)
		{
			this.proximoSlide = n;

			play();
		}

		public function slide(){
			TweenLite.killDelayedCallsTo(reproduzir);

			gotoAndPlay(this.proximoSlide);
		}
	}
}