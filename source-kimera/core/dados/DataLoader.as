package core.dados
{
	import core.Fase;
	import core.ConstrucaoDecorativa;
	import core.ConstrucaoFuncional;
	import core.Contribuicao;
	import core.Nivel;
	import core.EstruturaFuncional;
	import core.EstruturaDecorativa;
	import core.FaseRender;
	import core.EmissorSom;
	import core.media.Som;
	import core.util.ColorUtil;
	
	import flash.geom.Point;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	import flash.utils.setTimeout;
	import flash.utils.setInterval;
	import flash.media.Sound;	
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	
	import core.sistema.air.Arquivo;
	
	public class DataLoader extends EventDispatcher
	{
		private static var dataLoader = null;
		
		private var numeroNivel;
		private var loadIcone;
		
		private var estruturas	: Object = null;
		private var xmlXps		: XML    = null;
		private var mensagens;
		private var xml;
		private var xml2;
				
		// Mapeamento.
		private var faseAtual 	: Fase;
		
		// Load.
		private var indiceLoad;
		private var texturas, construcoes, emissores, sonsPopup;
		
		// Matriz que identifica o que é área livre, mar ou pista.]
		// A identificação é feita pela cor da área na textura.
		private var matriz: Array;
		
		public static const TAM_CELULA		= 30;
		
		public static const TOLERANCIA_COR 	= 100;
		public static const COR_AREA_LIVRE	= 0x9C6B4A;
		public static const COR_AREA_LIVRE2	= 0x6B8442;
		public static const COR_AREA_LIVRE3	= 0xC5BEA4;
		public static const COR_PISTA 		= 0x010100;
		public static const COR_MAR 		= 0x5BA6DF;
		public static const COR_TERRENO		= 0x9C6B4B;
		public static const COR_VEGETACAO	= 0x6B8442;
		public static const COR_CONSTRUCAO	= 0xF8CE17;
		
		
		//-------------------------------------voo-------------------------------------//
		
		private var qtdTotalCelulasCenario = 0;
		
		private var qtdMar = 0;
		private var posicoesMar: Array = new Array();
		
		private var qtdTerreno = 0;
		private var posicoesTerreno: Array = new Array();
		
		private var qtdVegetacao = 0;
		private var posicoesVegetacao: Array = new Array();

		private var qtdConstrucao = 0;
		private var posicoesConstrucao: Array = new Array();
		
		//-----------------------------------------------------------------------------//
		
		public static function GetInstance()
		{
			if(dataLoader == null) dataLoader = new DataLoader();
			return dataLoader;
		}		
		public function DataLoader()
		{
		}
		
		public function CarregarFase(arquivo: String, save: String, editor: Boolean = false) 
		{
			//trace("[Carregando fase...]");
			
			var tamanho, i, element;

			if(editor == true)
			{
				var conteudo 	= Arquivo.LerConteudoArquivo(arquivo, false);
			}
			else
			{
				var conteudo 	= Arquivo.LerConteudoArquivo(arquivo);
			}

			xml 	 		= new XML(conteudo);			
			var objetivos   = new Array();
			texturas    	= new Array();
			construcoes 	= new Array();

			// se as estruturas ainda não foram carregadas!		
			if(!estruturas) estruturas  = CarregarEstruturas();	 
			
			//OrdernarEstruturas();
			
			if(!xmlXps) xmlXps = CarregarInfoXps();
			emissores		= new Array();
			sonsPopup		= new Array();
			
			// Cria uma matriz no tamanho do mapa.
			tamanho   		= xml.mapa.tamanho.split("x");	
			matriz			= new Array();
			for (i = 0; i < int(tamanho[0]); i++)
				matriz.push( new Array(int(tamanho[1])) )
				
			// Inicia a matriz com lugares ocupados
			for (var x_ = 0; x_ < matriz.length; x_++)
				for (var y_ = 0; y_ < matriz[x_].length; y_++)
					matriz[x_][y_] = Fase.AREA_OCUPADA;
						
			for each (var objetivo:XML in xml.objetivos.objetivo) 
			{
				if(objetivo.tipo == "construir")
				{
					objetivos.push({tipo: objetivo.tipo, qtd: objetivo.quantidade, construcao: objetivo.construcao,
							   nivel: objetivo.nivel, descricao: objetivo.descricao, xps: objetivo.xps});
				}
				else if(objetivo.tipo == "indice")
				{
					objetivos.push({tipo: objetivo.tipo, indice: objetivo.indice, valor: objetivo.valor,
								   descricao: objetivo.descricao, xps: objetivo.xps});
				}				
			}

			mensagens = new Array();
			for each (var mensagem:XML in xml.mensagens.mensagem) 
			{
				mensagens.push( mensagem );			
			}
			
			trace("montanto construcoes funcionais");
			// Construcoes Funcionais
			for( i = 0; i < estruturas.length; i++)
			{
				if (estruturas[i] is EstruturaFuncional)
				{
					var niveis = estruturas[i].GetNiveis();
					for(var j = 0; j < niveis.length; j++)
					{
						for each (element in xml.mapa.elementos.elemento)
						{
							if(element.construcao == niveis[j].GetNome())
							{
								var pos = element.posicao.split("x");
								construcoes.push(
									new ConstrucaoFuncional( 1, 
															 new Point(pos[0], pos[1]), 
															 estruturas[i], 
															 element.construcao,
															 true)
								);
							}
						}
					}
				}
			}

			trace("montanto construcoes decorativas");
			// Construcoes Decorativas
			for( i = 0; i < estruturas.length; i++)
			{
				if (estruturas[i] is EstruturaDecorativa)
				{
					for each (element in xml.mapa.elementos.elemento)
					{
						if(element.nome == estruturas[i].GetNome())
						{
							pos = element.posicao.split("x");
							construcoes.push(new ConstrucaoDecorativa(new Point(pos[0], pos[1]), estruturas[i], true));
						}
					}
				}
			}
			
			if(save != null){
				trace('-> carregar o save');
				CarregarConstrucoes(save);
			}
			
			for each (var element2:XML in xml.mapa.elementos.elemento)
			{
				switch(String(element2.tipo))
				{					
					case "textura":
					{
						var tam = element2.tamanho.split("x");
						var pos = element2.posicao.split("x");
						texturas.push(	{ caminho: element2.textura, 
									  	  tamanho: new Point(tam[0], tam[1]), 
										  posicao: new Point(pos[0], pos[1]),
										  textura: null } );
						break;
					}
					
					case "emissor_som":
					{
						pos = element2.posicao.split("x");
						emissores.push(new EmissorSom( new Point(pos[0], pos[1]), element2.caminho, element2.nome) );
						break;
					}
					
					case "som_popup":
					{
						sonsPopup.push({nome: element2.nome_estrutura, caminho: element2.caminho, som: null});
						break;
					}
				}
			}
			
			var tutorial;
			if(xml.tutorial == "false") tutorial = false;
			else tutorial = true;
			
			var populacaoXML:Number;
			var habitadosXML:Number;
			var empregadosXML:Number;
			var dinheiroXML:Number;
			var pontucaoXML:Number;
			
			if(save != null){
				populacaoXML	= xml2.populacao;
				habitadosXML 	= xml2.habitados
				empregadosXML 	= xml2.empregados
				dinheiroXML 	= xml2.dinheiro
				pontucaoXML		= xml2.pontuacao
			}
			else
			{
				populacaoXML	= xml.populacao;
				habitadosXML 	= xml.habitados
				empregadosXML 	= xml.empregados
				dinheiroXML 	= xml.dinheiro
				pontucaoXML		= xml.pontuacao
			}
			
			var cam		= xml.camera.split("x");	
			faseAtual   = new Fase( matriz,
								  new Point(tamanho[0], tamanho[1]),
								  new Point(cam[0], cam[1]),
							 	  texturas,
							 	  objetivos,
							 	  construcoes,
							 	  emissores,
								  xml.data,
								  xml.constante_k,
								  xml.indice_minimo,
								  xml.populacao_considerada,
							 	  populacaoXML,
								  habitadosXML,
								  empregadosXML,
								  dinheiroXML,
							 	  xml.tempo,
								  xml.numero,
								  xml.tempo_emprestimo,
								  xml.valor_emprestimo,
								  xml.tempo_gastar_emprestimo,
								  xml.texto_descritivo,
								  xml.nivel_inicial,
								  xml.nivel_max,
								  tutorial);
						
			texturas 	= faseAtual.GetTexturas();
			construcoes	= faseAtual.GetConstrucoes();
			indiceLoad = -1;
			CarregarProximaTextura();
		}
		
		/* ---------------------------- save -------------------------------- */
		
		public function CarregarConstrucoes(arquivo: String){
			var i, element;
			var conteudo 	= Arquivo.LerConteudoArquivo(arquivo);
			
			//if(!estruturas) estruturas  = CarregarEstruturas();	 
			
			xml2 	 		= new XML(conteudo);			
			construcoes 	= new Array();
			
			trace("montanto construcoes funcionais 2");
			// Construcoes Funcionais
			for( i = 0; i < estruturas.length; i++)
			{
				if (estruturas[i] is EstruturaFuncional)
				{
					var niveis = estruturas[i].GetNiveis();
					for(var j = 0; j < niveis.length; j++)
					{
						for each (element in xml2.mapa.elementos.elemento)
						{
							if(element.construcao == niveis[j].GetNome())
							{
								var pos = element.posicao.split("x");
								construcoes.push(
									new ConstrucaoFuncional( 1, 
															 new Point(pos[0], pos[1]), 
															 estruturas[i], 
															 element.construcao,
															 true)
								);
								
								trace('->' + estruturas[i].GetNome())
								trace('->' + pos[0] + 'x' + pos[1])
							}
						}
					}
				}
			}

			trace("montanto construcoes decorativas 2");
			// Construcoes Decorativas
			for( i = 0; i < estruturas.length; i++)
			{
				if (estruturas[i] is EstruturaDecorativa)
				{
					for each (element in xml2.mapa.elementos.elemento)
					{
						if(element.nome == estruturas[i].GetNome())
						{
							pos = element.posicao.split("x");
							construcoes.push(new ConstrucaoDecorativa(new Point(pos[0], pos[1]), estruturas[i], true));
							
							trace('->' + estruturas[i].GetNome())
							trace('->' + pos[0] + 'x' + pos[1])
						}
					}
				}
			}
			
			//construcoes	= faseAtual.GetConstrucoes();
		}
		
		//-------------------------------------voo-------------------------------------//
		
		public function getTotalCelulasCenario () 
		{
			return qtdTotalCelulasCenario;
		}
		
		//mar
		public function getTotalElementosMar () 
		{
			return qtdMar;
		}
		
		public function getPosicaoElementosMar () 
		{
			return posicoesMar;
		}
		
		//terreno
		public function getTotalElementosTerreno () 
		{
			return qtdTerreno;
		}
		
		public function getPosicaoElementosTerreno () 
		{
			return posicoesTerreno;
		}
		
		//vegetacao
		public function getTotalElementosVegetacao () 
		{
			return qtdVegetacao;
		}
		
		public function getPosicaoElementosVegetacao () 
		{
			return posicoesVegetacao;
		}

		//construcao
		public function getTotalElementosConstrucao () 
		{
			return qtdConstrucao;
		}
		
		public function getPosicaoElementosConstrucao () 
		{
			return posicoesConstrucao;
		}
		
		//-----------------------------------------------------------------------------//
		
		public function CarregarProximaTextura( evt = null )
		{
			indiceLoad++;
			
			if (indiceLoad >= texturas.length)
			{
				//ImprimirMatriz();
				
				indiceLoad = -1;
				CarregarProximaEstrutura();
			}
			else
			{			
				var loader = new Loader();
				loader.contentLoaderInfo.addEventListener( Event.COMPLETE, FimLoadTextura );
				
				loader.load( new URLRequest( texturas[indiceLoad].caminho ) );
				
				dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, indiceLoad, texturas.length + construcoes.length + emissores.length + sonsPopup.length + 1) );
			}
		}
		
		function FimLoadTextura(evt)
		{
			var textura 				 = evt.target.loader.content;			
			texturas[indiceLoad].textura = textura;	
			
			// Processa a textura, preenchendo na matriz, areas
			// livres, pistas, mar, etc.
			ProcessarTextura( texturas[indiceLoad] );
			
			CarregarProximaTextura();
		}
		
		function ProcessarTextura(textura)
		{
			var pos = textura.posicao;
			var tam = textura.tamanho;			
			
			//trace('ProcessarTextura: ' + pos +  ' => ' + tam);
			
			// Percorre todas as celulas da textura identificando as
			// cores presentes.
			for (var x_ = 1; x_ <= tam.x; x_++)
			{
				for (var y_ = 1; y_ <= tam.y; y_++)
				{
					var cores 		= GetCores( new Point( x_, y_), textura.textura );
					
					// Identifica qual elemento é: Pista, área livre ou mar.
					var elemento	= GetElemento( cores );
					//var elemento = 'x';
					
					// Atribui à matriz.
					// Lembre-se que o indice inicial da matriz é 0!
					var pos2				= new Point( pos.x + x_ - 2, pos.y + y_ - 2 );
					matriz[pos2.x][pos2.y] 	= elemento;
					
					//-------------------------------------voo-------------------------------------//
					
					qtdTotalCelulasCenario += 1;
					
					if (elemento == Fase.MAR ) {
						qtdMar += 1;
						
						posicoesMar.push({pX:pos2.x*TAM_CELULA, pY:pos2.y*TAM_CELULA});
					}
					
					if (elemento == Fase.TERRENO ) {
						qtdTerreno += 1;
						
						posicoesTerreno.push({pX:pos2.x*TAM_CELULA, pY:pos2.y*TAM_CELULA});
					}
					
					if (elemento == Fase.VEGETACAO ) {
						qtdVegetacao += 1;
						
						posicoesVegetacao.push({pX:pos2.x*TAM_CELULA, pY:pos2.y*TAM_CELULA});
					}

					if (elemento == Fase.CONSTRUCAO ) {
						qtdConstrucao += 1;
						
						posicoesConstrucao.push({pX:pos2.x*TAM_CELULA, pY:pos2.y*TAM_CELULA});
					}
					
					//-----------------------------------------------------------------------------//
				}
			}
		}
		
		function PixelParaCelula( p )
		{
			return new Point( Math.ceil(p.x / DataLoader.TAM_CELULA), Math.ceil(p.y / DataLoader.TAM_CELULA) );
		}
		
		// Retorna um vetor de 4 elementos.
		// Cada elemento correspode a cor de um dos cantos da celula
		// especificado, no bitmap especificado.
		// Pontos
		// ----------
		// | 1	  2 |
		// |		|
		// | 3	  4 |
		// ----------
		function GetCores( celula, bitmap )
		{			 
			var bmpData = bitmap.bitmapData;
			var pos 	= new Point( (celula.x-1) * DataLoader.TAM_CELULA, (celula.y-1) * DataLoader.TAM_CELULA );
			var b		= DataLoader.TAM_CELULA / 6; // Borda
			var r 		= new Array();
			
			var cores = '';
			
			// Ponto 1.
			r.push( bmpData.getPixel( pos.x + b, pos.y + b ) ); 
			cores +=  bmpData.getPixel( pos.x + b, pos.y + b ).toString(16)  + ' (' + Diferenca( bmpData.getPixel( pos.x + b, pos.y + b ), DataLoader.COR_MAR ) + ') ' ;
			
			// Ponto 2.
			r.push( bmpData.getPixel( pos.x + b, pos.y + DataLoader.TAM_CELULA - b ) ); 
			cores += bmpData.getPixel( pos.x + b, pos.y + DataLoader.TAM_CELULA - b  ).toString(16)  + ' (' + Diferenca( bmpData.getPixel( pos.x + b, pos.y + DataLoader.TAM_CELULA - b ), DataLoader.COR_MAR ) + ') ';
			
			// Ponto 3.
			r.push( bmpData.getPixel( pos.x + DataLoader.TAM_CELULA - b, pos.y + b ) ); 
			cores += bmpData.getPixel( pos.x + DataLoader.TAM_CELULA - b, pos.y + b ).toString(16)  + ' (' + Diferenca( bmpData.getPixel( pos.x + DataLoader.TAM_CELULA - b, pos.y + b ), DataLoader.COR_MAR )  + ') ';
			
			// Ponto 4.
			r.push( bmpData.getPixel( pos.x + DataLoader.TAM_CELULA - b, pos.y + DataLoader.TAM_CELULA - b ) ); 
			cores += bmpData.getPixel( pos.x + DataLoader.TAM_CELULA - b, pos.y + DataLoader.TAM_CELULA - b  ).toString(16) + ' (' + Diferenca( bmpData.getPixel( pos.x + DataLoader.TAM_CELULA - b, pos.y + DataLoader.TAM_CELULA - b  ), DataLoader.COR_MAR ) + ') ' ;
			
			//trace( celula + ': ' + cores);
			
			return r;
		}
		
		function GetElemento( cores )
		{
			var i;
			
			// Se todos os pontos foram verdes, é uma área livre.
			var b = true;
			for (i = 0; i < cores.length; i++) b = b && CompararCores(cores[i], DataLoader.COR_AREA_LIVRE);			
			if (b) return Fase.AREA_LIVRE;
			
			b = true;
			for (i = 0; i < cores.length; i++) b = b && CompararCores(cores[i], DataLoader.COR_AREA_LIVRE2);			
			if (b) return Fase.AREA_LIVRE;
			
			b = true;
			for (i = 0; i < cores.length; i++) b = b && CompararCores(cores[i], DataLoader.COR_AREA_LIVRE3);			
			if (b) return Fase.AREA_LIVRE;
			
			//-------------------------------------voo-------------------------------------//
			
			// Se todas mar.
			for (i = 0; i < cores.length; i++) if (CompararCores(cores[i], DataLoader.COR_MAR)) return Fase.MAR;
			
			// Se todas forem terreno
			for (i = 0; i < cores.length; i++) if (CompararCores(cores[i], DataLoader.COR_TERRENO)) return Fase.TERRENO;
			
			// Se todas forem vegetacao
			for (i = 0; i < cores.length; i++) if (CompararCores(cores[i], DataLoader.COR_VEGETACAO)) return Fase.VEGETACAO;

			// Se todas forem construcao
			for (i = 0; i < cores.length; i++) if (CompararCores(cores[i], DataLoader.COR_CONSTRUCAO)) return Fase.CONSTRUCAO;
			
			//-----------------------------------------------------------------------------//
			
			// Se ao menos um for cinza, é uma pista.
			for (i = 0; i < cores.length; i++) if (CompararCores(cores[i], DataLoader.COR_PISTA)) return Fase.PISTA;
			
			// Area desconhecida / inutilizada.
			return 0;
		}
		
		function Diferenca( cor1, cor2 )
		{
			var cor1RGB = ColorUtil.HexToRGB( cor1 );
			var cor2RGB = ColorUtil.HexToRGB( cor2 );
			
			var dif = 0;
			
			for (var i = 0; i < cor1RGB.length; i++)
				dif += Math.abs( cor1RGB[i] - cor2RGB[i] );

			return dif;
		}
		
		function CompararCores( cor1, cor2 )
		{						
			return Diferenca(cor1, cor2) <= DataLoader.TOLERANCIA_COR;			
		}
		
		function CarregarProximaEstrutura( evt = null )
		{			
			indiceLoad++;
			
			if (indiceLoad >= estruturas.length)
			{
				indiceLoad = -1;
				CarregarProximoSom();
			}
			else
			{			
				var loader = new Loader();
				loader.contentLoaderInfo.addEventListener( Event.COMPLETE, FimLoadEstrutura );
				loader.load( new URLRequest( estruturas[indiceLoad].GetCaminhoGrafico() ) );
				
				dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, texturas.length + indiceLoad, texturas.length + estruturas.length + emissores.length + sonsPopup.length + 1) );
			}			
		}
		
		function FimLoadEstrutura(evt)
		{
			//var estrutura 				 	= evt.target.loader.content;			
			estruturas[indiceLoad].grafico 	= evt.target;			
			CarregarProximaEstrutura();
		}
		
		function CarregarProximoSom(evt = null)
		{
			indiceLoad++;
			
			if (indiceLoad >= emissores.length)
			{
				indiceLoad = -1;
				CarregarProximoSomPopup();
			}
			else
			{			
				var loader = new Sound();
				loader.addEventListener( Event.COMPLETE, FimLoadEmissor );
				loader.load( new URLRequest( emissores[indiceLoad].GetCaminho() ) );
				
				dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, texturas.length + estruturas.length + indiceLoad, texturas.length + construcoes.length + emissores.length + sonsPopup.length + 1) );
				
			}
		}
		
		function FimLoadEmissor(evt)
		{
			 emissores[indiceLoad].SetSound( new Som(evt.target) );
			 CarregarProximoSom();
		}
		
		function CarregarProximoSomPopup(evt = null)
		{
			indiceLoad++;
			
			if (indiceLoad >= sonsPopup.length)
			{
				CarregarMusica();
			}
			else
			{			
				var loader = new Sound();
				loader.addEventListener( Event.COMPLETE, FimLoadSomPopup );
				loader.load( new URLRequest( sonsPopup[indiceLoad].caminho ) );
				
				dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, texturas.length + estruturas.length + emissores.length + indiceLoad, texturas.length + construcoes.length + emissores.length + sonsPopup.length + 1) );
				
			}
		}
		
		function FimLoadSomPopup(evt)
		{
			sonsPopup[indiceLoad].som = new Som(evt.target);
			CarregarProximoSomPopup();
		}
		
		function CarregarMusica()
		{
			dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, texturas.length + estruturas.length + emissores.length + sonsPopup.length, texturas.length + construcoes.length + emissores.length + sonsPopup.length + 1) );
			
			var loader = new Sound();
			loader.addEventListener( Event.COMPLETE, FimLoadMusica );
			loader.load( new URLRequest( xml.musica ) );
		}
		
		function FimLoadMusica(evt)
		{
			faseAtual.SetMusica( new Som( evt.target ) );
			faseAtual.Iniciar();
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
				
		// --------------------------------------------------------------------------------------
				
		/**
		 * Carrega as estruturas do jogo
		 */
		private function CarregarEstruturas() : Object
		{
			// Carregamento de estruturas funcionais			
			var pastaData = "data" + Arquivo.GetSeparador() + "construcoes" + Arquivo.GetSeparador() + "funcional" + Arquivo.GetSeparador(); //jason alterou
			var resultado = new Array();
			//trace(pastaData);
			if ( Arquivo.ExistePasta( pastaData ) )
			{
				//trace("pasta existe!");
				var arquivosEstruturas_array  = Arquivo.GetArquivosPasta(pastaData, new Array("xml"));
				trace("carregando estruturas");
				for (var i2 = 0; i2 < arquivosEstruturas_array.length; i2++)
				{
					var arquivoXML 	= arquivosEstruturas_array[i2];
					trace(pastaData + arquivoXML);					
					var conteudo 	= Arquivo.LerConteudoArquivo(pastaData + arquivoXML);					
					var xml 	  	= new XML(conteudo);					
					var niveis 	  	= new Array();
					
					for each (var n:XML in xml.niveis.nivel) 
					{
						var contribuicoes = new Array();
						for each(var c: XML in n.contribuicoes.contribuicao)
						{
							contribuicoes.push(new Contribuicao(c.tipo, c.categoria, int(c.quantidade)));
						}

						niveis.push(
							new Nivel( int(n.xps),
									   n.nome,
									   xml.construcao.descricao,
									   Number(n.exigencias_construcao.custo),
									   Number(n.exigencias_construcao.desabitados),
									   Number(n.exigencias_construcao.habitados),
									   int(n.exigencias_construcao.tempo),
									   Number(n.exigencias_demolicao.custo),
									   int(n.exigencias_demolicao.tempo),
									   Number(n.custo_manutencao),
									   Number(n.exigencias_construcao.nivel_jogador),
									   contribuicoes, 
									   int(n.nivel),
									   n.tempo
									   )
						);
					}
					
					var tamanho   = xml.construcao.tamanho.split("x");
					
					var areasLivres;
					if(xml.construcao.areas_livres != "")
					{
						trace(" a :" + xml.construcao.nome);
						areasLivres = new Array();
						for each (var a:XML in xml.construcao.areas_livres.area_livre) 
						{
							var x_ = a.x.split("x");
							trace(x_);
							var y_ = a.y.split("x");
							trace(y_);
							var p = {x1: x_[0], x2: x_[1], y1: y_[0], y2: y_[1]};
							areasLivres.push(p);
						}
					}
					else areasLivres = null;
					
					var tamanhoP  = null;
					if(xml.construcao.tamanho_perspectiva != "")
					{
						trace(xml.construcao.nome + " " + xml.construcao.tamanho_perspectiva);
						trace(xml.construcao.tamanho_perspectiva);
						var tamanhoArray = xml.construcao.tamanho_perspectiva.split("x");
						tamanhoP = new Point(tamanhoArray[0], tamanhoArray[1]);
					}				
					
					var estrutura = new EstruturaFuncional(
							xml.construcao.nome, 
							xml.construcao.id, 
							xml.construcao.descricao, 
							niveis, 
							xml.construcao.categoria, 
							xml.construcao.grafico, 
							new Point(tamanho[0], tamanho[1]),
							tamanhoP,
							areasLivres
					);
					
					resultado.push(estrutura);
				}
			}
			
			// Ordena as construções por nível de jogador necessário para construir
			QuickSort(resultado, 0, resultado.length - 1);
			
			// Carregamento de estruturas decorativas			
			pastaData 			 =  "data" + Arquivo.GetSeparador() + "construcoes" + Arquivo.GetSeparador() + "decorativo" + Arquivo.GetSeparador();			
			trace("carregando decorativos");
			if ( Arquivo.ExistePasta( pastaData ) )
			{
				arquivosEstruturas_array   = Arquivo.GetArquivosPasta( pastaData, new Array("xml") );
				
				for (i2 = 0; i2 < arquivosEstruturas_array.length; i2++)
				{
					arquivoXML 	  = arquivosEstruturas_array[i2];
					conteudo 	  = Arquivo.LerConteudoArquivo(pastaData + arquivoXML);					
					xml 	      = new XML(conteudo);					
					tamanho       = xml.construcao.tamanho.split("x");
					tamanhoP  = null;
					if(xml.construcao.tamanho_perspectiva != "")
					{
						tamanhoArray = xml.construcao.tamanho_perspectiva.split("x");
						tamanhoP = new Point(tamanhoArray[0], tamanhoArray[1]);
					}
					
					if(xml.construcao.areas_livres != "")
					{
						areasLivres	  = new Array();
						for each (var a2:XML in xml.construcao.areas_livres.area_livre) 
						{
							x_ = a2.x.split("x");
							y_ = a2.y.split("x");
							p = {x1: int(x_[0]), x2: int(x_[1]), y1: int(y_[0]), y2: int(y_[1])};
							areasLivres.push(p);
						}
					}
					else areasLivres = null;
					
					estrutura     = new EstruturaDecorativa( xml.construcao.nome, 
															 xml.construcao.id, 
															 xml.construcao.descricao, 
															 xml.construcao.caminho, 
															 new Point(tamanho[0], tamanho[1]),
															 tamanhoP,
															 areasLivres,
															 xml.construcao.tempo != undefined ? int(xml.construcao.tempo) : 1,
															 xml.construcao.funcao != undefined ? xml.construcao.funcao : null);					
					resultado.push(estrutura);
				}
			}
			trace("fim do carregamento");
			
			return resultado;
		}
		
		function CarregarInfoXps()
		{
			// Carregamento de arquivo sobre os xps		
			var arquivo  = "data" + Arquivo.GetSeparador() + "xps.xml";
			var conteudo = Arquivo.LerConteudoArquivo(arquivo);
			var xmlConteudo = new XML(conteudo);
			
			return xmlConteudo;
		}
		
		public function XpsPorReal( nivelJogador: int )
		{
			for each (var n:XML in xmlXps.niveis.nivel) 
			{
				if(int(n.nivel) == nivelJogador) return n.xps;
			}
			return null;
		}
		
		public function XpsParaProximoNivel( nivelJogador: int )
		{
			for each (var n:XML in xmlXps.niveis.nivel) 
			{
				if(int(n.nivel) == nivelJogador) return n.xps_proximo_nivel;
			}
			return null;
		}
		
		public function LoadEmissores(pEmissores: Array)
		{
			var e = pEmissores;
			for(var i = 0; i < e.length; i++)
			{
				var musica = new Som(e[i].GetCaminho());				
				e[i].SetSound(musica);
			}
			return e;
		}
		
		//-----------------------------------------------------------------------
		function ImprimirMatriz()
		{
			for (var y_ = 0; y_ < matriz[0].length; y_++)
			//for (var y_ = 0; y_ < 72; y_++)
			{
				var linha = '';
				for (var x_ = 0; x_ < matriz.length; x_++)
				//for (var x_ = 0; x_ < 56; x_++)
				{
					linha += matriz[x_][y_] + '';
				}
				trace(linha);
			}
		}
		
		private function ContarCelulasLivres()
		{
			var contador = 0;
			for (var y_ = 0; y_ < matriz[0].length; y_++)
			{
				for (var x_ = 0; x_ < matriz.length; x_++)
				{
					if(matriz[x_][y_] == 1) contador++;
				}
			}
			trace("Células livres: " + contador);
		}
		
		//-----------------------------------------------------------------------
		/*
		private function SetGraficoEstrutura(nomeEstrutura: String, grafico)
		{
			for(var i = 0; i < estruturas.decorativas; i++)
			{
				if(estruturas.decorativas[i].GetNome() == nomeEstrutura)
				{
					estruturas.decorativas[i].SetGrafico(grafico);
					return;
				}
			}
			
			for(i = 0; i < estruturas.funcionais; i++)
			{
				if(estruturas.funcionais[i].GetNome() == nomeEstrutura)
				{
					estruturas.funcionais[i].SetGrafico(grafico);
					return;
				}
			}
		}
		*/
		public function GetOcorrencia(pGrafico, pNumeroNivel = null, niveisIcones: Array = null)
		{
			var grafico;
			if(pGrafico.content is MovieClip) 
			{
				var nivelClass;
				if(niveisIcones != null)
				{
					var vetorGraficos = new Array();
					for(var i = 0; i < niveisIcones.length; i++)
					{
						nivelClass = pGrafico.applicationDomain.getDefinition("Icone" + niveisIcones[i].GetNumero()) as Class
						grafico    = new nivelClass();
						vetorGraficos.push(grafico);
					}
					return vetorGraficos;
				}
				else
				{
					nivelClass = pGrafico.applicationDomain.getDefinition("Nivel" + pNumeroNivel) as Class;
					grafico    = new nivelClass();
				}
			}
			else grafico = Bitmap(pGrafico.content);
			
			return grafico;
		}
		
		public function GetEstruturaByName(nome: String)
		{
			for(var i = 0; i < estruturas.length; i++)
			{
				if(estruturas[i].GetNome() == nome) return estruturas[i];
			}
			return null;
		}
		
		public function GetEstruturaById(id: String)
		{
			for(var i = 0; i < estruturas.length; i++)
			{
				if(estruturas[i].GetId() == id) return estruturas[i];
			}
			return null;
		}		
		
		public function GetEstruturasPorCategoria(indice: String)
		{
			var est 	= GetEstruturas();
			var array 	= new Array();
			for(var i 	= 0; i < est.length; i++)
			{
				if(est[i] is EstruturaFuncional && est[i].GetCategoria() == indice) array.push(est[i]);
			}
			return array;
		}
		
		public function GetEstruturas()
		{
			return estruturas;
		}
		
		public function GetEstruturasDecorativas()
		{
			var est = new Array();
			for(var i = 0; i < estruturas.length; i++)
			{
				if(estruturas[i] is EstruturaDecorativa) est.push(estruturas[i]);
			}
			return est;
		}
		
		public function GetEstruturasFuncionais()
		{
			var est = new Array();
			for(var i = 0; i < estruturas.length; i++)
			{
				if(estruturas[i] is EstruturaFuncional) est.push(estruturas[i]);
			}
			return est;
		}
		
		/**
		 * @return Fase
		 */
		public function GetFase() : Fase
		{
			return faseAtual;
		}
		
		public function GetEmissores()
		{
			return emissores;
		}
		
		public function GetMensagens()
		{
			return mensagens;
		}
		
		public function GetMensagemByTitulo(titulo : String)
		{			
			for (var i = 0; i < mensagens.length; i++)
			{
				var m 	= mensagens[i];
				var ok	= true;
				var f = null;
				
				if(m.titulo == titulo){
					return m;
				}
			}
		}
		
		public function GetSomPopup(nome: String)
		{
			for(var i = 0; i < sonsPopup.length; i++)
			{
				if( sonsPopup[i].nome == nome) return sonsPopup[i].som;
			}
			return null;
		}
		
		public function SetVolumeSomPopup(volume)
		{
			for(var i = 0; i < sonsPopup.length; i++)
			{
				sonsPopup[i].som.SetVolume(volume);
			}
		}
		
		function QuickSort(arrayInput, left, right)
		{
			var i = left;
			var j = right;
			var pivotPoint = arrayInput[Math.round(( left + right )* 0.5)].GetNivel(0).GetNivelJogador();
			var tempStore;
			// Loop
			while (i<=j)
			{
				while (arrayInput[i].GetNivel(0).GetNivelJogador() < pivotPoint) i++;
				while (arrayInput[j].GetNivel(0).GetNivelJogador() > pivotPoint) j--;
				if (i <= j)
				{
					tempStore = arrayInput[i];
					arrayInput[i] = arrayInput[j];
					i++;
					arrayInput[j] = tempStore;
					j--;
				}
			}
			// Swap
			if (left<j)  QuickSort(arrayInput, left, j);
			if (i<right) QuickSort(arrayInput, i, right);
			return arrayInput;
		}
	}
}