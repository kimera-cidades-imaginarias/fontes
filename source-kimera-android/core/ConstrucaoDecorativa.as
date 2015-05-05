package core
{
	import flash.geom.Point;
	
	public class ConstrucaoDecorativa extends Construcao
	{
		private var estrutura : EstruturaDecorativa;
		
		public function ConstrucaoDecorativa(pPosicao: Point, pEstrutura: EstruturaDecorativa, pConfigInicial : Boolean)
		{
			super(pPosicao, pConfigInicial);
			estrutura = pEstrutura;
		}
		
		public function GetEstrutura() : EstruturaDecorativa
		{
			return estrutura;
		}
		
		public function GetMovieClip()
		{
			return estrutura.GetGrafico().applicationDomain.getDefinition("Nivel1") as Class;
		}
		
		public function GetMask()
		{
			return estrutura.GetGrafico().applicationDomain.getDefinition("Mask") as Class;
		}
		
		public function GetTempoConstrucao()
		{
			return estrutura.GetTempoConstrucao();
		}
		
		public function GetCategoria()
		{
			return estrutura.GetCategoria();
		}
		
		public function GetFuncao()
		{
			return estrutura.getFuncao();
		}
	}
}