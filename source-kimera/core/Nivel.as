package core
{
	import flash.geom.Point;
	
	public class Nivel
	{		
		private var xps             : int;
		private var nome			: String;
		private var descricao		: String;
		private var custo           : Number;		
		private var custoDemolicao  : Number;
		private var custoManutencao : Number;
		private var exigenciaTempoConstrucao : int;
		private var tempoDemolicao  : int;
		private var nivelJogador    : int;
		private var contribuicoes   : Array;
		private var nivel		    : int;
		private var tempoConstrucao : int;
		
		private var desabitados		: Number;
		private var habitados		: Number;
		
		public function Nivel( pXps	: int, 
							   pNome: String, 
							   pDescricao		: String,
							   pCustoConstrucao	: Number, 
							   pDesabitados		: Number,
							   pHabitados		: Number,
							   pExigenciaTempoConstrucao	: int, 
							   pCustoDemolicao	: Number,
							   pTempoDemolicao	: int, 
							   pCustoManutencao	: Number, 
							   pNivelJogador	: int, 
							   pContribuicoes	: Array, 
							   pNivel			: int,
							   pTempoConstrucao : int )
		{
			xps             = pXps;
			nome			= pNome;
			descricao		= pDescricao;
			custo           = pCustoConstrucao;
			exigenciaTempoConstrucao = pExigenciaTempoConstrucao;
			custoDemolicao  = pCustoDemolicao;
			tempoDemolicao  = pTempoDemolicao;
			custoManutencao = pCustoManutencao;
			nivelJogador	= pNivelJogador;
			contribuicoes   = pContribuicoes;
			nivel		    = pNivel;
			tempoConstrucao	= pTempoConstrucao;
			
			desabitados		= pDesabitados;
			habitados		= pHabitados;
		}
		
		public function GetNome() : String
		{
			return nome;
		}
		
		public function GetDescricao() : String
		{
			return descricao;
		}
		
		public function GetNumero() : int
		{
			return nivel;
		}
		
		public function GetContribuicoes() : Array
		{
			return contribuicoes;
		}
		
		public function GetContribuicoesPorTipo(tipo: String) : Array
		{
			var r = new Array();
			for (var i = 0; i < contribuicoes.length; i++)
			{
				if (contribuicoes[i].GetTipo() == tipo) r.push( contribuicoes[i] );  
			}
			return r;
		}
		
		public function GetContribuicao(contribuicao: Object)
		{
			var contribuicoes = GetContribuicoesPorTipo(contribuicao.tipo);
			if (contribuicao.tipo == 'atendimento')
			{
				var capacidadeAtendimento = 0;
				for (var i = 0; i < contribuicoes.length; i++)
				{

					if (contribuicoes[i].GetCategoria() == contribuicao.categoria)
					{
						capacidadeAtendimento += contribuicoes[i].GetQuantidade();
					}
				}
				return capacidadeAtendimento;
			}
		}
		
		public function GetTempoConstrucao()
		{
			return tempoConstrucao;
		}
		
		public function GetCusto()
		{
			return custo;
		}
		
		public function GetDesabitados()
		{
			return desabitados;
		}
		
		public function GetHabitados()
		{
			return habitados;
		}
		
		public function GetXPs()
		{
			return xps;
		}
		
		public function GetNivelJogador()
		{
			return nivelJogador;
		}
	}
}