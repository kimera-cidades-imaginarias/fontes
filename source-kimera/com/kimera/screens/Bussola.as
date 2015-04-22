package com.kimera.screens
{
	import core.Simulador;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.setTimeout;
	
	import gs.TweenLite;
	
	public class Bussola extends MovieClip
	{
		
		public function Bussola()
		{
			super();
			
			this.pedra1_mc.addEventListener( MouseEvent.CLICK, adicionarPedra );
			this.pedra2_mc.addEventListener( MouseEvent.CLICK, adicionarPedra );
			this.pedra3_mc.addEventListener( MouseEvent.CLICK, adicionarPedra );
			
			pedra1_mc.visible = false;
			pedra2_mc.visible = false;
			pedra3_mc.visible = false;
			
			pedra1Adicionada_mc.visible = false;
			pedra2Adicionada_mc.visible = false;
			pedra3Adicionada_mc.visible = false;
		}
		
		public function marcarPedraMagica(num : int) : void
		{
			if(num == 1){
				pedra1Adicionada_mc.visible = true;
			}
			
			if(num == 2){
				pedra2Adicionada_mc.visible = true;
			}
			
			if(num == 3){
				pedra3Adicionada_mc.visible = true;
			}
		}

		public function desmarcarPedras():void
		{
			pedra1Adicionada_mc.visible = false;
			pedra2Adicionada_mc.visible = false;
			pedra3Adicionada_mc.visible = false;
		}

		protected function adicionarPedra(evt : Event)
		{
			if(evt.target.name == "pedra1_mc")
			{
				TweenLite.to(this.pedra1_mc, 0.5, {autoAlpha: 0});
				TweenLite.to(this.pedra1Adicionada_mc, 0.5, {autoAlpha: 1, delay: 0.5});
				
				this.pedra1Adicionada_mc.gotoAndPlay(2);
			}
			
			if(evt.target.name == "pedra2_mc")
			{
				TweenLite.to(this.pedra2_mc, 0.5, {autoAlpha: 0});
				TweenLite.to(this.pedra2Adicionada_mc, 0.5, {autoAlpha: 1, delay: 0.5});
				
				this.pedra2Adicionada_mc.gotoAndPlay(2);
			}
			
			if(evt.target.name == "pedra3_mc")
			{
				TweenLite.to(this.pedra3_mc, 0.5, {autoAlpha: 0});
				TweenLite.to(this.pedra3Adicionada_mc, 0.5, {autoAlpha: 1, delay: 0.5});
				
				this.pedra3Adicionada_mc.gotoAndPlay(2);
			}
			
			setTimeout(pedraAdicionada, 1200);
		}
		
		protected function pedraAdicionada()
		{
			Game.getInstance().VerificaFluxoDeJogo("adicionarPedra");
		}
		
		public function pegarPedraMagica(num : int) : void
		{
			Game.getInstance().PausaJogo(true);
			
			if(num == 1){
				TweenLite.to(this.pedra1_mc, 0.5, {autoAlpha: 1});
				//TweenLite.to(this.pedra1_mc, 1, {delay: 1, rotation: 980})
			}
			
			if(num == 2){
				TweenLite.to(this.pedra2_mc, 0.5, {autoAlpha: 1});
				//TweenLite.to(this.pedra1_mc, 1, {delay: 1, rotation: 980})
			}
			
			if(num == 3){
				TweenLite.to(this.pedra3_mc, 0.5, {autoAlpha: 1});
				//TweenLite.to(this.pedra1_mc, 1, {delay: 1, rotation: 980})
			}
		}
		
		public function ocultarMenu(evt = null){			
			Game.getInstance().PausaJogo(false);
		}
	}
}