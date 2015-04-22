package com.kimera.screens
{	
	import com.kengine.Screen;
	import com.kimera.KimeraGame;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import gs.TweenLite;
	
	import flash.net.FileReference;
	import flash.events.Event;
	import flash.net.FileFilter;
	
	import core.sistema.*;
	import core.sistema.air.Arquivo;
	
	public class Kamplus extends Screen
	{
		//janela
		override public function initInterface() : void 
		{
			//window
			this.sair_btn.addEventListener( MouseEvent.CLICK	        	, sair );
			this.sair_btn.addEventListener( MouseEvent.MOUSE_OVER	     	, mouseOverBotao );
			
			this.visible = false;
		}
		
		public function abrir(evt = null)
		{
			Game.getInstance().gestorSom.Parar( 'musica-menu-principal');
			Game.getInstance().gestorSom.Reproduzir( 'musica-password' , 99999999);
			
			Game.getInstance().MudarEstadoInterface("estado_carregar_jogo");

			TweenLite.to(this, 0.5, {autoAlpha: 1});

			//lista arquivos
			listarArquivosDir();
		}

		function listarArquivosDir(){
			var pastaData 	=  "data" + Arquivo.GetSeparador() + "fases" + Arquivo.GetSeparador();		
			var arquivos:Array = Arquivo.GetArquivosPasta(pastaData, ['xml'], false);

			//remove old itens if exist
			for (var i:Number = this.container_mc.numChildren-1 ; i >= 0 ; i--)
			{
			    
			    this.container_mc.removeChildAt(i);
			    
			}

			//add new item
			for(var i:Number = 0; i<arquivos.length; i++){
				var item = new itemMapa();
				var nomeTemp:String = arquivos[i];

				item.name = String(arquivos[i]);
				item.x = 0;
				item.y = (i * 80);
				item.descricao.text = nomeTemp.slice(0, nomeTemp.length-4);
				item.buttonMode = true;

				item.btJogar.addEventListener( MouseEvent.MOUSE_OVER, mouseOverBotao );
				item.btJogar.addEventListener( MouseEvent.CLICK	    , function(e){ carregarMapa(e.currentTarget.parent.name); });

				item.btExcluir.addEventListener( MouseEvent.MOUSE_OVER, mouseOverBotao );
				item.btExcluir.addEventListener( MouseEvent.CLICK   , function(e){ excluirMapa(e.currentTarget.parent.name); });

				this.container_mc.addChild(item);
			}
		}

		public function excluirMapa(fase:String)
		{
			var pastaData 	=  "data" + Arquivo.GetSeparador() + "fases" + Arquivo.GetSeparador() + fase;
			Arquivo.DeletarArquivo(pastaData, false);

			var pastaSave 	=  "saves" + Arquivo.GetSeparador() + fase;
			if(Arquivo.ExisteArquivo(pastaSave, false)){
				Arquivo.DeletarArquivo(pastaSave, false);
			}

			listarArquivosDir();
		}

		function carregarMapa(fase:String){
			this.sair();

			Global.variables.faseConstrucao = fase.slice(0, fase.length-4);

			Game.getInstance().exibirNomeMapa(fase.slice(0, fase.length-4));
			Game.getInstance().ConfigurarModoEditor();

			Game.getInstance().faseACarregar = fase;
			Game.getInstance().NovoJogo(null);
		}
		
		function sair(evt = null)
		{
			Game.getInstance().gestorSom.Parar( 'musica-password');
			
			Game.getInstance().MudarEstadoInterface("estado_menu_principal");

			TweenLite.to(this, 0.5, {autoAlpha: 0});
		}
		
		function mouseOverBotao(evt)
		{
			Game.getInstance().gestorSom.Reproduzir( 'mouse-over' );
		}
	}
}
