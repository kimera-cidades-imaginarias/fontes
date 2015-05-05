package com.kimera.screens
{
	import core.Simulador;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import gs.TweenLite;
	
	public class CasaDosGuardioes extends MovieClip
	{
		public function CasaDosGuardioes()
		{
			super();
			
			this.fechar_btn.addEventListener( MouseEvent.CLICK, ocultarMenu );

			this.tilion_mc.addEventListener( MouseEvent.CLICK, invocarTilion );
			this.tilion_mc.useHandCursor = true;
			this.tilion_mc.buttonMode = true;

			this.doren_mc.addEventListener( MouseEvent.CLICK, invocarDoren );
			this.doren_mc.useHandCursor = true;
			this.doren_mc.buttonMode = true;

			this.kimera_mc.addEventListener( MouseEvent.CLICK, invocarKimera );
			this.kimera_mc.useHandCursor = true;
			this.kimera_mc.buttonMode = true;
		}
		
		public function mostrarTela(){
			
		}
		
		protected function ocultarMenu(evt = null) : void
		{
			TweenLite.to(this, 0.5, {autoAlpha: 0});
			
			Game.getInstance().OcultarMenuDecoracao(evt);
		}
		
		protected function invocarTilion(evt = null) : void
		{
			this.ocultarMenu();
			var game : Game = Game.getInstance();			
			game.VerificaFluxoDeJogo("invocarTilion");
		}

		protected function invocarDoren(evt = null) : void
		{
			this.ocultarMenu();
			var game : Game = Game.getInstance();			
			game.VerificaFluxoDeJogo("invocarDoren");
		}

		protected function invocarKimera(evt = null) : void
		{
			this.ocultarMenu();
			var game : Game = Game.getInstance();			
			game.VerificaFluxoDeJogo("invocarKimera");
		}
	}
}