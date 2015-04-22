package core
{
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.display.MovieClip;
	import flash.media.Sound;
	
	import core.media.Som;
	import as3isolib.display.IsoSprite;
	
	public class Fase
	{		
		public static const AREA_OCUPADA	= 0;
		public static const AREA_LIVRE		= 1;
		public static const PISTA			= 2;
		public static const MAR				= 3;
		public static const AREA_LIVRE_XML	= 4;
		public static const TERRENO			= 5;
		public static const VEGETACAO		= 6;
		public static const CONSTRUCAO		= 2;
		
		private var grid        	: Array;
		private var numero			: int;
		private var tamanho     	: Point;
		private var camera     		: Point;
		public var texturas    	: Array;
		private var objetivos   	: Array;
		private var construcoes 	: Array;
		private var emissores   	: Array; 
		private var constanteK		: Number;
		private var indiceMinimo	: Number;
		private var popConsiderada	: Number;
		private var tempoConclusao	: int;
		private var dinheiroInicial	: int;
		private var populacaoInicial: int;
		private var habitadosInicial: int; 
		private var empregadosInicial: int; 
		private var tempoEmprestimo	: int;
		private var valorEmprestimo	: int;
		private var tempoGastarEmprestimo: int;	
		private var textoDescritivo : String;
		private var data			: Date;
		private var tutorial		: Boolean;
		
		
		private var nivelInicial: int;
		private var nivelMax: int;
		
		private var musica			: Som	= null;
		private var pistas			: Array;
		
		public function Fase( pGrid		     : Array, 
							  pTamanho	     : Point, 
							  pCamera		 : Point,
							  pTexturas	     : Array, 
							  pObjetivos	 : Array,
							  pConstrucoes   : Array,
							  pEmissores	 : Array,
							  pData			 : String,
							  pConstanteK	 : Number,
							  pIndiceMinimo  : Number,
							  pPopConsiderada: Number,
							  pPopulacao	 : int,
							  pHabitados	 : int,
							  pEmpregados	 : int,
							  pDinheiro		 : int,
							  pTempo		 : int,
							  pNumero		 : int,
							  pTempoEmprestimo: int,
							  pValorEmprestimo: int,
							  pTempoGastarEmprestimo: int,
							  pTextoDescritivo: String,
							  pNivelInicial: int,
							  pNivelMax: int,
							  pTutorial: Boolean)
		{
			grid        	= pGrid;
			tamanho     	= pTamanho;
			camera			= pCamera;
			texturas    	= pTexturas;
			tutorial 		= pTutorial;
			objetivos   	= pObjetivos;
			construcoes 	= pConstrucoes;
			emissores		= pEmissores;
			constanteK		= pConstanteK;
			indiceMinimo	= pIndiceMinimo;
			popConsiderada  = pPopConsiderada;
			tempoConclusao	= pTempo;
			numero			= pNumero;
			dinheiroInicial	= pDinheiro;
			populacaoInicial= pPopulacao;
			habitadosInicial= pHabitados;
			empregadosInicial= pEmpregados;
			tempoEmprestimo = pTempoEmprestimo;
			valorEmprestimo = pValorEmprestimo;
			textoDescritivo = pTextoDescritivo;
			tempoGastarEmprestimo = pTempoGastarEmprestimo;
			
			nivelInicial	= pNivelInicial;
			nivelMax		= pNivelMax;
			
			SetData(pData);
		}
		
		public function Iniciar()
		{
			// Marca os lugares ocupados por construções.
			for(var i = 0; i < construcoes.length; i++)
			{
				var construcao = construcoes[i];
				MarcarAreaConstrucao( construcoes[i] );
			}		
			
			// Armazena os espaços que são pistas.
			pistas = new Array();
			for (var c = 0; c < grid.length; c++)
			{
				for (var l = 0; l < grid[c].length; l++)
				{
					if (grid[c][l] == Fase.PISTA) 
					{
						pistas.push( new Point(c, l) );
					}
				}
			}			
		}
		
		/*********
		*	Verifica se a área definida por um retângulo está livre para construcao
		*	no mapa.
		*	INDICE DA ÁREA COMEÇANDO EM 0!
		******/
		public function AreaLivre(area: Rectangle)
		{
			//if(Global.variables.modoEditor) return true;
			for (var c = area.x; c < area.x + area.width; c++)
			{
				for (var l = area.y; l < area.y + area.height; l++)
				{
					if (grid[c][l] != Fase.AREA_LIVRE) return false;
				}
			}
			
			return true;
		}
		
		/**********
		*	Marca a área ocupada por uma construção como ocupada/desocupada no
		*	mapa.
		*************/
		public function MarcarAreaConstrucao(construcao, remover = false)
		{
			var posicao = construcao.GetPosicao();
			var tamanho = construcao.GetEstrutura().GetTamanho();
			
			var areasLivres = construcao.GetEstrutura().GetAreasLivres();
			if(!remover)
			{
				AdicionarAreaConstrucao(areasLivres, posicao, tamanho);
			}
			else RemoverAreaConstrucao(areasLivres, posicao, tamanho);
			//ImprimirGrid();
		}
		
		function AdicionarAreaConstrucao(areasLivres, posicao, tamanho)
		{
			if(areasLivres)
			{
				for(var i = 0; i < areasLivres.length; i++)
				{
					var ponto = areasLivres[i];
					for (x_ = ponto.x1; x_ <= ponto.x2; x_++)
					{
						for (y_ = ponto.y1; y_ <= ponto.y2; y_++)
						{
							/*if((grid[posicao.x + x_][posicao.y + y_] != PISTA) && (grid[posicao.x + x_][posicao.y + y_] != MAR))
								grid[posicao.x + x_][posicao.y + y_] = Fase.AREA_LIVRE;*/
							if(grid[posicao.x + x_][posicao.y + y_] == AREA_LIVRE)
								grid[posicao.x + x_][posicao.y + y_] = AREA_LIVRE_XML;
						}
					}
				}
			}
			
			for (var x_ = 0; x_ < tamanho.x; x_++)
			{
				for (var y_ = 0; y_ < tamanho.y; y_++)
				{
					if(grid[posicao.x + x_][posicao.y + y_] != AREA_LIVRE_XML)
					{
						if((grid[posicao.x + x_][posicao.y + y_] != PISTA) &&
							(grid[posicao.x + x_][posicao.y + y_] != MAR))
								grid[posicao.x + x_][posicao.y + y_] = Fase.AREA_OCUPADA;
					}
					else grid[posicao.x + x_][posicao.y + y_] = Fase.AREA_LIVRE;
				}
			}
		}
		
		function RemoverAreaConstrucao(areasLivres, posicao, tamanho)
		{
			if(areasLivres)
			{
				for(var i = 0; i < areasLivres.length; i++)
				{
					var ponto = areasLivres[i];
					for (x_ = ponto.x1; x_ <= ponto.x2; x_++)
					{
						for (y_ = ponto.y1; y_ <= ponto.y2; y_++)
						{
							if(grid[posicao.x + x_][posicao.y + y_] == AREA_OCUPADA)
								grid[posicao.x + x_][posicao.y + y_] = AREA_LIVRE_XML;
						}
					}
				}
			}
			
			for (var x_ = 0; x_ < tamanho.x; x_++)
			{
				for (var y_ = 0; y_ < tamanho.y; y_++)
				{
					if(grid[posicao.x + x_][posicao.y + y_] == AREA_OCUPADA)
						grid[posicao.x + x_][posicao.y + y_] = Fase.AREA_LIVRE;
					else if(grid[posicao.x + x_][posicao.y + y_] == AREA_LIVRE_XML)
						grid[posicao.x + x_][posicao.y + y_] = Fase.AREA_OCUPADA;
				}
			}
		}

		//----------------------------------------------------------------
		
		/*******
		*	Localiza uma espaço livre no mapa com as dimensões
		*	especificadas.
		**********/
		public function GetEspacoAleatorio(tamanho: Point)
		{
			var livres = GetEspacosLivres( tamanho );
			if (livres.length > 0) 
			{	
				var r = Math.floor(Math.random() * livres.length);
				return new Point(livres[r].x, livres[r].y);	
			}
			return null;
		}
		
		public function GetEspacosLivres(tamanho: Point)
		{
			var r = new Array();
			
			// Verifica se existe algum espaço livre com o tamanho solicitado.
			for (var x_ = 0; x_ < grid.length; x_++)
			{
				for (var y_ = 0; y_ < grid[x_].length; y_++)
				{
					var rect = new Rectangle(x_, y_, tamanho.x, tamanho.y)
					if (AreaLivre(rect)) r.push( rect );		
				}
			}
			return r;
		}

		//------------------------------------------------------------
		
		public function AdicionarConstrucao(construcao)
		{
			construcoes.push( construcao );
			MarcarAreaConstrucao( construcao );
		}
		
		public function GetConstrucoesPorCategoria(categoria = '') : Array
		{
			if (categoria == '') return construcoes;
			else
			{
				var r = new Array();
				for (var i = 0; i < construcoes.length; i++)
				{
					if (construcoes[i].GetCategoria() == categoria)
						r.push( construcoes[i] );
				}
				return r;
			}
		}

		public function GetConstrucoesPorFuncao(funcao = '') : Array
		{
			if (funcao == '') return construcoes;
			else
			{
				var r = new Array();
				for (var i = 0; i < construcoes.length; i++)
				{
					if (construcoes[i].GetFuncao() == funcao)
						r.push( construcoes[i] );
				}
				return r;
			}
		}
		
		public function ImprimirGrid()
		{
			// Imprime o grid.
			for (var i = 0; i < grid.length; i++)
			{
				trace('Área livre em ' + grid[i].posicao);
				var matriz = grid[i].matriz;
				for (var l = 0; l < matriz.length; l++)
				{
					var r = '';
					for (var c = 0; c < matriz[l].length; c++)
					{
						r += matriz[l][c]
					}
					trace(r);
				}
			}
		}
		
		public function GetTexturas() : Array
		{
			return texturas;
		}
		
		public function GetConstrucoes() : Array
		{
			return construcoes;
		}
		
		public function GetConstrucoesPorNivel( nome, nivelMinimo )
		{
			var resultado = new Array();
			if (nome != '')
			{
				for (var i = 0; i < construcoes.length; i++)
				{
					if (construcoes[i].GetEstrutura().GetNome() == nome )
					{
						if (nivelMinimo != -1) 
						{
							if (construcoes[i].GetNivel().GetNumero() >= nivelMinimo)
							{
								resultado.push( construcoes[i] );
							}
						}
						else resultado.push( construcoes[i] );
					}
				}				
			}		
			return resultado;
		}
		
		public function GetConstrucoesPorNivel2( nome, nivelMinimo )
		{
			var contador = 0;
			if (nome != '')
			{
				for (var i = 0; i < construcoes.length; i++)
				{
					if(!construcoes[i].GetConfigInicial())
					{
						if (construcoes[i].GetEstrutura().GetNome() == nome )
						{
							if (nivelMinimo != -1) 
							{
								if (construcoes[i].GetNivel().GetNumero() >= nivelMinimo) contador++;
							}
							else contador++;
						}
					}
				}				
			}		
			return contador;
		}
		
		public function GetEmissores() : Array
		{
			return emissores;
		}
		
		public function GetTamanho() : Point
		{
			return tamanho;
		}
		
		public function GetObjetivos() : Array
		{
			return objetivos;
		}
		
		public function GetPopulacaoInicial() : int
		{
			return populacaoInicial;
		}
		
		public function GetHabitadosInicial() : int
		{
			return habitadosInicial;
		}
		
		public function GetEmpregadosInicial() : int
		{
			return empregadosInicial;
		}
		
		public function GetDinheiroInicial() : int
		{
			return dinheiroInicial;
		}
		
		public function GetTempoConclusao() : int
		{
			return tempoConclusao;
		}
		
		public function GetData()
		{
			return data;
		}
		
		public function IsTutorial() // diz se é ou não uma fase com tutorial no início
		{
			return tutorial;
		}
		
		public function SetData(pData)
		{
			var dados = pData.split("/");
			data  = new Date(Number(dados[2]), Number(dados[1]), Number(dados[0])); // dia, mês e ano
		}
		
		public function GetConstanteK()	: Number
		{
			return constanteK;
		}
		
		public function GetIndiceMinimo(): Number
		{
			return indiceMinimo;
		}
		
		public function GetPercentPopConsiderada()
		{
			return popConsiderada;
		}
		
		public function SetGraficoConstrucao(grafico: IsoSprite, indice: int)
		{
			construcoes[indice].SetGrafico(grafico);
		}
		
		public function SetEmissores(pEmissores)
		{
			emissores = pEmissores;
		}
		
		public function GetMatriz()
		{
			return grid;
		}
		
		public function SetMatriz(matriz: Array)
		{
			grid = matriz;
		}
		
		public function GetPistas()
		{
			return pistas;
		}
		
		public function GetPosInicialCamera()
		{
			return camera;
		}
		
		public function SetMusica( pMusica )
		{
			musica = pMusica;
		}
		
		public function GetMusica()
		{
			return musica;
		}
		
		public function GetTempoEmprestimo()
		{
			return tempoEmprestimo;
		}
		
		public function GetValorEmprestimo()
		{
			return valorEmprestimo;
		}
		
		public function GetTempoGastarEmprestimo()
		{
			return tempoGastarEmprestimo;
		}
		
		public function GetNumero()
		{
			return numero;
		}
		
		public function GetNivelInicial()
		{
			return nivelInicial;
		}
		
		public function GetNivelMax()
		{
			return nivelMax;
		}
		
		public function GetTextoDescritivo()
		{
			return textoDescritivo;
		}
	}
}