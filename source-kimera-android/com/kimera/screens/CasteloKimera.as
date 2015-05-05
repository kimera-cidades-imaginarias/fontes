package com.kimera.screens
{
	import core.Simulador;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import gs.TweenLite;
	
	public class CasteloKimera extends MovieClip
	{
		public function CasteloKimera()
		{
			super();
			
			this.fechar_btn.addEventListener( MouseEvent.CLICK, ocultarMenu );
		}
		
		public function atualizar(){
			var sim : Simulador = Simulador.GetInstance();
			
			var indice1 = "Comércio: " 			+ 	Math.round(sim.GetIndice(Simulador.COMERCIO) 	* 100)		+"%";
			var indice2 = "Educação: " 			+ 	Math.round(sim.GetIndice(Simulador.EDUCACAO) 	* 100)		+"%";
			var indice3 = "Infraestrutura: " 	+ 	Math.round(sim.GetIndice(Simulador.INFRA) 		* 100)		+"%";
			var indice4 = "Saúde: " 			+ 	Math.round(sim.GetIndice(Simulador.SAUDE) 		* 100)		+"%";
			var indice5 = "Segurança: " 		+ 	Math.round(sim.GetIndice(Simulador.SEGURANCA) 	* 100)		+"%";
			var indice6 = "Moradia: " 		+ 	Math.round(sim.GetIndice(Simulador.MORADIA) 	* 100)		+"%";
			
			indice1_txt.text = indice1;
			indice2_txt.text = indice2;
			indice3_txt.text = indice3;
			indice4_txt.text = indice4;
			indice5_txt.text = indice5;
			indice6_txt.text = indice6;
		}
		
		protected function ocultarMenu(evt){
			TweenLite.to(this, 0.5, {autoAlpha: 0});
			
			Game.getInstance().OcultarMenuDecoracao(evt);
		}
	}
}