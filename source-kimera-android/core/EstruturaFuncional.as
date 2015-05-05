package core
{	
	import flash.geom.Point;
	import flash.display.MovieClip;
	
	public class EstruturaFuncional extends Estrutura
	{		
		private var niveis         : Array;
		private var categoria      : String;
		
		
		public function EstruturaFuncional( pNome			: String, 
										   	pId				: String, 
								  			pDescricao		: String, 
								 			pNiveis			: Array, 
								  			pCategoria		: String, 
								  			pCaminhoGrafico	: String, 
								  			pTamanho		: Point,
											pTamanhoPerspec	: Point,
											pAreasLivres	: Array)
		{
			super( pNome, pId, pDescricao, pCaminhoGrafico, pTamanho, pTamanhoPerspec, pAreasLivres);
			
			niveis    	   = pNiveis;
			categoria 	   = pCategoria;
		}
		
		public function GetNiveis() : Array
		{
			return niveis;
		}
		
		public function GetNivel(indice)
		{
			return niveis[indice];
		}
		
		public function GetNivelByName(nome: String): Nivel
		{
			for(var i = 0; i < niveis.length; i++)
			{
				trace("Nivel: "+niveis[i].GetNome()+" / "+nome);
				if(niveis[i].GetNome() == nome) return niveis[i];
			}
			return null;
		}
		
		override public function GetCategoria() : String
		{
			return categoria;
		}
	}
}