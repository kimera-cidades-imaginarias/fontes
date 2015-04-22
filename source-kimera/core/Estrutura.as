package core
{	
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	public class Estrutura
	{
		private var nome           : String;
		private var id             : String;
		private var descricao      : String;		
		private var caminhoGrafico : String;
		private var tamanho		   : Point;
		private var tamanhoPerspec : Point;
		private var tempoConstrucao: int;
		private var areasLivres	   : Array;
		private var funcao		   : String;
		public var grafico;
		
		public function Estrutura(pNome				: String, 
								  pId				: String,
								  pDescricao		: String, 
								  pCaminhoGrafico	: String, 
								  pTamanho			: Point,
								  pTamanhoPerspec	: Point,
								  pAreasLivres		: Array,
								  pTempoConstrucao	: int = 30000,
								  pFuncao			: String = null)
		{
			nome      	   = pNome;
			areasLivres    = pAreasLivres;
			id			   = pId;
			descricao 	   = pDescricao;
			caminhoGrafico = pCaminhoGrafico;
			tamanho   	   = pTamanho;
			tamanhoPerspec = pTamanhoPerspec;
			tempoConstrucao= pTempoConstrucao;
			grafico	       = null;
			funcao		   = pFuncao;
		}
		
		public function GetNome() : String
		{
			return nome;
		}
		
		public function GetId() : String
		{
			return id;
		}
		
		public function GetCategoria() : String
		{
			return "";
		}
		
		public function GetCaminhoGrafico() : String
		{
			return caminhoGrafico;
		}
		
		public function GetDescricao() : String
		{
			return descricao;
		}
		
		public function GetGrafico()
		{
			return grafico;
		}
		
		public function GetTamanho() : Point
		{
			return tamanho;
		}
		
		public function GetTamanhoPerspectiva() : Point
		{
			return tamanhoPerspec;
		}
		
		public function GetAreasLivres() : Array
		{
			return areasLivres;
		}
		
		public function GetTempoConstrucao()
		{
			return tempoConstrucao;
		}
		
		public function getFuncao()
		{
			return funcao;
		}
	}
}