package core
{	
	public class Contribuicao
	{		
		private var tipo       : String;
		private var categoria  : String;
		private var quantidade : int;
		
		public function Contribuicao(pTipo: String, 
									 pCategoria: String, 
									 pQuantidade: int)
		{
			tipo       = pTipo;
			categoria  = pCategoria;
			quantidade = pQuantidade;
		}
		
		public function GetTipo()
		{
			return tipo;
		}
		
		public function GetCategoria()
		{
			return categoria;
		}
		
		public function GetQuantidade()
		{
			return quantidade;
		}		
	}
}