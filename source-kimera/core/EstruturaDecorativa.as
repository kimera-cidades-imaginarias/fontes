package core
{	
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	public class EstruturaDecorativa extends Estrutura
	{
		
		public function EstruturaDecorativa( pNome				: String, 
											 pId				: String, 
											 pDescricao			: String, 
											 pCaminhoGrafico	: String, 
											 pTamanho			: Point,
											 pTamanhoPerspec	: Point,
											 pAreasLivres		: Array,
											 pTempoConstrucao	: int = 30000,
											 pFuncao			: String = null)
		{
			super( pNome, pId, pDescricao, pCaminhoGrafico, pTamanho, pTamanhoPerspec, pAreasLivres, pTempoConstrucao, pFuncao );
		}
		
		override public function GetCategoria() : String
		{
			return 'Decorativa';
		}
	}
}