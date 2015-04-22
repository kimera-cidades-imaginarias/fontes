package core
{
	import flash.geom.Point;
	//import flash.media.Sound;
	
	import core.media.Som;
	
	public class EmissorSom
	{
		private var posicaoCelulas : Point;
		private var posicao		   : Point;
		private var caminho		   : String;
		private var nome		   : String;
		private var som			   : Som;
		
		public function EmissorSom(pPosicao: Point, pCaminho: String, pNome: String)
		{
			posicaoCelulas = pPosicao;
			caminho 	   = pCaminho;
			nome		   = pNome;
			som			   = null;
		}
		
		public function GetSom() : Som
		{
			return som;
		}
		
		public function EncerrarSom()
		{
			som.Stop();
			som = null;
		}
		
		public function PararSom()
		{
			if(som) som.Stop();
		}
		
		public function GetCaminho() : String
		{
			return caminho;
		}
		
		public function GetPosicaoCelulas() : Point
		{
			return posicaoCelulas;
		}
		
		public function GetPosicao() : Point
		{
			return posicao;
		}
		
		public function GetNome() : String
		{
			return nome;
		}
		
		public function SetPosicao(point: Point)
		{
			posicao = point;
		}
		
		public function SetSound(pSom: Som)
		{
			som = pSom;
		}
	}
}