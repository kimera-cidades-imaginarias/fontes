package com.kimera.screens
{
	import core.Simulador;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import gs.TweenLite;

	import core.sistema.air.Arquivo;
	
	public class CartaVoadora extends MovieClip
	{
		protected var arquivoCarta : String;
		protected var campo : String;

		private var simulacaoGlobal = true;
		
		public function CartaVoadora()
		{
			super();
			
			this.fechar_btn.addEventListener( MouseEvent.CLICK, ocultarMenu );
			this.enviar_btn.addEventListener( MouseEvent.CLICK, ocultarMenu );
		}
		
		protected function setArquivo(nome : String) : void
		{
			arquivoCarta = Arquivo.GetPastaAplicacao(false) + Arquivo.GetSeparador() + "saves" + Arquivo.GetSeparador() + nome + ".xml";	
		}

		public function mostrarCarta(enviar = null, simulacao = true)
		{
			if(enviar != null){
				setArquivo(enviar);
			} else {
				setArquivo("carta");
			}

			if(simulacao == true)
			{
				Game.getInstance().PausaJogo(true);
				Game.getInstance().pausarSimulacaoJanela();
			} 
			else
			{
				simulacaoGlobal = false;
			}

			caixa_txt.text = carregarCarta();

			trace('carta: ' + carregarCarta())

			Game.getInstance().setChildIndex(this, Game.getInstance().numChildren-1);

			TweenLite.to(this, 0.5, {autoAlpha: 1});
		}
		
		protected function carregarCarta() : String
		{
			var texto : String;
			if ( Arquivo.ExisteArquivo( arquivoCarta , false ) )
			{
				var configuracoes = Arquivo.LerConteudoArquivo( arquivoCarta , false );
				var xml 		  = new XML( configuracoes );
				texto = xml.opcoes.@texto;
			}
			else texto = "";
			
			return texto;
		}
		
		protected function salvarCarta(texto : String)
		{
			var outputString:String = '<?xml version="1.0" encoding="utf-8"?>\n';
			var prefsXML = <informacao/>;
			prefsXML.opcoes.@texto = texto;
			outputString += prefsXML.toXMLString();
			
			Arquivo.EscreverArquivo(arquivoCarta, outputString, false);	
		}
		
		public function ocultarMenu(evt = null){
			salvarCarta(caixa_txt.text);
			TweenLite.to(this, 0.5, {autoAlpha: 0});
			
			if(simulacaoGlobal == true)
			{
				Game.getInstance().continuarSimulacaoJanela();
				Game.getInstance().PausaJogo(false);
				Game.getInstance().VerificaFluxoDeJogo("CartaFechada");
			}

			simulacaoGlobal = true;
			
			this.enviar_btn.visible = false;
			this.bt_limpar.visible = false;
		}
	}
}