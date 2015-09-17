package com.kimera.screens
{	
	import com.kengine.Screen;
	import com.kimera.KimeraGame;

	import core.sistema.air.Arquivo;
	
	import gs.TweenLite;

	import com.adobe.images.JPGEncoder;

	import flash.events.MouseEvent;
	import flash.events.Event;
	
	import flash.net.FileReference;
	import flash.net.FileFilter;
	import flash.net.URLRequest;
	import flash.net.URLLoader;

	import flash.display.MovieClip;
	import flash.display.Loader;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import flash.utils.ByteArray;

	public class ConstruirCidade extends Screen
	{
		// core app upload
		private var _loadFile:FileReference;
		private var _saveFile:FileReference;

		private var mapaName:String = new String();
		private var state:Number = new Number(2);

		public var loaderMap:Loader = new Loader();
		public var contador:Number = new Number(1);

		private var latitude:Number 
		private var longitude:Number
		private var enderecoMapa:String 
		private var complemento:String = "";

		private function browseImage(evt :Event = null) : void
		{
			_loadFile = new FileReference();
			_loadFile.addEventListener(Event.SELECT, selectHandler);
			
			var fileFilter:FileFilter = new FileFilter("Images: (*.jpg)", "*.jpg;");
			_loadFile.browse([fileFilter]);
		}
		
		private function selectHandler(event:Event):void
		{
			_loadFile.removeEventListener(Event.SELECT, selectHandler);
			_loadFile.addEventListener(Event.COMPLETE, loadCompleteHandler);
			_loadFile.load();
		}

		private function loadCompleteHandler(event:Event):void
		{
		    _loadFile.removeEventListener(Event.COMPLETE, loadCompleteHandler);
		    
		    //mapaName = _loadFile.name;
		    //mapaName = mapaName.slice(0,mapaName.length-4);

		    //gera arquivo mapa
			if(this.file_window.nome_do_mapa.text != ''){
				mapaName = this.file_window.nome_do_mapa.text;
			}

			this.file_window.construir_btn.alpha = 1;
			this.file_window.construir_btn.addEventListener( MouseEvent.CLICK	        	, criarMapaJogoArquivo );
			this.file_window.construir_btn.addEventListener( MouseEvent.MOUSE_OVER	     	, mouseOverBotao );		
		}

		private function criarMapaJogoArquivo(evt)
		{
			if(this.file_window.nome_do_mapa.text != ""){
				if( !Arquivo.ExisteArquivo( Arquivo.GetPastaAplicacao(false) + Arquivo.GetSeparador() + "data" + Arquivo.GetSeparador() + "fases" +Arquivo.GetSeparador() + mapaName + '.xml' , false ) ){
					//nome
					mapaName = this.file_window.nome_do_mapa.text;
					Global.variables.faseConstrucao = mapaName;

					//salva o jpg
			    	Game.getInstance().salvarImagemMapa(mapaName, _loadFile.data);

					Game.getInstance().gestorSom.Parar( 'musica-password');

					this.file_window.bgInput.gotoAndStop(1);
					this.sair();
					this.gerarMapaArquivo();
				} else {
					this.file_window.bgInput.gotoAndStop(2);
				}
			} else {
				this.file_window.bgInput.gotoAndStop(3);
			}
		}

		private function gerarMapaArquivo(evt = null)
		{
			//gera arquivo mapa
			Game.getInstance().salvarArquivoMapa(mapaName);

			this.carregarMapa();
		}

		private function criarMapaJogoCoordenadas(evt)
		{
			 //gera arquivo mapa
			if(this.cordenate_window.nome_do_mapa.text != ''){
				mapaName = this.cordenate_window.nome_do_mapa.text;
			}

			if(this.cordenate_window.nome_do_mapa.text != ""){
				if( !Arquivo.ExisteArquivo( Arquivo.GetPastaAplicacao(false) + Arquivo.GetSeparador() + "data" + Arquivo.GetSeparador() + "fases" +Arquivo.GetSeparador() + mapaName + '.xml' , false ) ){
					
					mapaName = this.cordenate_window.nome_do_mapa.text;

					if( (state == 1 && this.cordenate_window.cord.latitude_graus.text != "" && this.cordenate_window.cord.latitude_minutos.text != "" && this.cordenate_window.cord.latitude_segundos.text != "" && this.cordenate_window.cord.longitude_graus.text != "" && this.cordenate_window.cord.longitude_minutos.text != "" && this.cordenate_window.cord.longitude_segundos.text != "") || (state == 2 && this.cordenate_window.end.endereco.text != "") ){
						Game.getInstance().gestorSom.Parar( 'musica-password');

						this.cordenate_window.cord.inputCordenadas.gotoAndStop(1);
						this.cordenate_window.end.inputEndereco.gotoAndStop(1);

						this.cordenate_window.bgInput.gotoAndStop(1);
						this.sair();
						this.gerarMapaCoordenadas();
					} else {
						if(state == 1){
							this.cordenate_window.cord.inputCordenadas.gotoAndStop(2);
						}

						else if(state == 2){
							this.cordenate_window.end.inputEndereco.gotoAndStop(2);
						}
					}
				}
				else
				{
					this.cordenate_window.bgInput.gotoAndStop(2);
				}
			} else {
				this.cordenate_window.bgInput.gotoAndStop(3);
			}
		}

		private function gerarMapaCoordenadas(evt = null)
		{
			this.enderecoMapa 	= String(this.cordenate_window.end.endereco.text);	
			this.latitude 		= 	Number(this.cordenate_window.cord.latitude_graus.text) + ((( Number(this.cordenate_window.cord.latitude_minutos.text) * 60 ) + ( Number(this.cordenate_window.cord.latitude_segundos.text) )) / 3600);
			this.longitude 		=	Number(this.cordenate_window.cord.longitude_graus.text) + ((( Number(this.cordenate_window.cord.longitude_minutos.text) * 60 ) + ( Number(this.cordenate_window.cord.longitude_segundos.text) )) / 3600);
			
			Global.variables.faseConstrucao = mapaName;

			Game.getInstance().MudarEstadoInterface( "estado_carregando" );

			loaderMap.contentLoaderInfo.addEventListener( Event.COMPLETE, gravarTextura );

			//gera texturas mapa
			loaderMapa();
		}

		private function loaderMapa(){


			if(contador == 1){
				mapaName = Global.variables.faseConstrucao + '-satellite';
				complemento = '&tipo=satellite';

				loadNow();

				contador++;
			}

			else if(contador == 2){
				mapaName = Global.variables.faseConstrucao + '-hybrid';
				complemento = '&tipo=hybrid';

				loadNow();

				contador++;
			}
			else if(contador == 3){
				mapaName = Global.variables.faseConstrucao + '-terrain';
				complemento = '&tipo=terrain';

				loadNow();

				contador++;
			}
			else if(contador == 4){
				mapaName = Global.variables.faseConstrucao + '';
				complemento = '&tipo=roadmap';

				loadNow();

				contador++;
			}
			else if(contador == 5){
				loaderMap.contentLoaderInfo.removeEventListener( Event.COMPLETE, gravarTextura );

				//gera arquivo mapa
				Game.getInstance().salvarArquivoMapa(Global.variables.faseConstrucao);

				this.carregarMapa();
			}
		}

		private function loadNow(){
			if(state == 1){
				loaderMap.load( new URLRequest( 'https://kimera4.websiteseguro.com/mapsService/service.php?latitude='+String(latitude)+'&longitude='+String(longitude)+'&zoom=17' + complemento ) );
			}

			else if(state == 2){
				loaderMap.load( new URLRequest( 'https://kimera4.websiteseguro.com/mapsService/service.php?zoom=17&endereco='+String(enderecoMapa) + complemento ) );
			}
		}

		private function gravarTextura(evt)
		{
			var textura:BitmapData = Bitmap(evt.target.loader.content).bitmapData;
			var jpgEncoder:JPGEncoder = new JPGEncoder( 80 );
			var stream:ByteArray = jpgEncoder.encode( textura );
			
			Game.getInstance().salvarImagemMapa(mapaName, stream);

			//gera proxima textura
			loaderMapa();
		}

		private function carregarMapa(evt = null)
		{
			this.contador = 1;

			Game.getInstance().exibirNomeMapa(Global.variables.faseConstrucao);
			Game.getInstance().ConfigurarModoEditor();

			Game.getInstance().faseACarregar = Global.variables.faseConstrucao + '.xml'
			Game.getInstance().NovoJogo(evt);
		}

		//janela
		override public function initInterface() : void 
		{
			//window
			this.btn_window.visible = true;
			this.cordenate_window.visible = false;
			this.file_window.visible = false;

			this.sair_btn.addEventListener( MouseEvent.CLICK	        	, sair );
			this.sair_btn.addEventListener( MouseEvent.MOUSE_OVER	     	, mouseOverBotao );

			//btn_window
			this.btn_window.coordenadas_btn.addEventListener( MouseEvent.CLICK	        , abrirCordenateWindow );
			this.btn_window.coordenadas_btn.addEventListener( MouseEvent.MOUSE_OVER	    , mouseOverBotao );

			this.btn_window.arquivo_btn.addEventListener( MouseEvent.CLICK	        , abrirFileWindow );
			this.btn_window.arquivo_btn.addEventListener( MouseEvent.MOUSE_OVER	    ,  mouseOverBotao);

			//cordenate_window
			this.cordenate_window.construir_btn.addEventListener( MouseEvent.CLICK	        	, criarMapaJogoCoordenadas );
			this.cordenate_window.construir_btn.addEventListener( MouseEvent.MOUSE_OVER	     	, mouseOverBotao );

			this.cordenate_window.voltar_btn.addEventListener( MouseEvent.CLICK	        	, abrirBtnWindow );
			this.cordenate_window.voltar_btn.addEventListener( MouseEvent.MOUSE_OVER	    , mouseOverBotao );

			this.cordenate_window.cord.visible = false;
			
			this.cordenate_window.btEndereco.addEventListener( MouseEvent.CLICK	        	, ativarEndereco );
			this.cordenate_window.btEndereco.addEventListener( MouseEvent.MOUSE_OVER	    , mouseOverBotao );

			this.cordenate_window.btCoordenadas.addEventListener( MouseEvent.CLICK	        , ativarCordenadas );
			this.cordenate_window.btCoordenadas.addEventListener( MouseEvent.MOUSE_OVER	    , mouseOverBotao );

			//file_window
			this.file_window.construir_btn.alpha = 0.5;

			this.file_window.upload_btn.addEventListener( MouseEvent.CLICK	        	, browseImage );
			this.file_window.upload_btn.addEventListener( MouseEvent.MOUSE_OVER	     	, mouseOverBotao );

			this.file_window.voltar_btn.addEventListener( MouseEvent.CLICK	        	, abrirBtnWindow );
			this.file_window.voltar_btn.addEventListener( MouseEvent.MOUSE_OVER	     	, mouseOverBotao );
			
			this.visible = false;
		}

		private function ativarEndereco(evt = null)
		{
			state = 2;

			this.cordenate_window.end.visible = true;
			this.cordenate_window.cord.visible = false;
		}

		private function ativarCordenadas(evt = null)
		{
			state = 1;

			this.cordenate_window.end.visible = false;
			this.cordenate_window.cord.visible = true;
		}

		private function abrirCordenateWindow(evt = null)
		{
			this.btn_window.visible = false;
			this.cordenate_window.visible = true;
			this.file_window.visible = false;
		}

		private function abrirFileWindow(evt = null)
		{
			this.btn_window.visible = false;
			this.cordenate_window.visible = false;
			this.file_window.visible = true;
		}

		private function abrirBtnWindow(evt = null)
		{
			this.btn_window.visible = true;
			this.cordenate_window.visible = false;
			this.file_window.visible = false;
		}
		
		public function abrir(evt = null)
		{
			//window
			this.btn_window.visible = true;
			this.cordenate_window.visible = false;
			this.file_window.visible = false;

			Game.getInstance().gestorSom.Parar( 'musica-menu-principal');
			Game.getInstance().gestorSom.Reproduzir( 'musica-password' , 99999999);
			
			Game.getInstance().MudarEstadoInterface("estado_menu_principal");

			TweenLite.to(this, 0.5, {autoAlpha: 1});
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
