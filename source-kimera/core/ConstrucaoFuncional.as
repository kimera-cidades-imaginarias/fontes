package core
{
	import as3isolib.display.IsoSprite;
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	public class ConstrucaoFuncional extends Construcao
	{
		static const ESTADO_CONSTRUINDO = 'construindo';
		static const ESTADO_PRONTO		= 'pronto';
		
		private var nivel        : Nivel;
		private var estrutura    : EstruturaFuncional;
		private var turnoCriacao : int;
		private var estado		 : String;
		
		public function ConstrucaoFuncional( turno		: int, 
											 pPosicao	: Point, 
											 pEstrutura	: EstruturaFuncional, 
											 nomeNivel	: String,
											 pConfigInicial : Boolean,
											 pPontosVida = 100)
		{
			super(pPosicao, pConfigInicial, pPontosVida);
			
			estrutura    = pEstrutura;
			nivel	     = estrutura.GetNivelByName(nomeNivel);
			turnoCriacao = turno;
			
			estado		 = ConstrucaoFuncional.ESTADO_CONSTRUINDO;
			//criacao		 = getTimer();
		}
		
		public function GetMovieClip()
		{
			trace( 'Grafico: ' + estrutura.GetGrafico() );
			trace(nivel.GetNumero());
			return estrutura.GetGrafico().applicationDomain.getDefinition("Nivel" + nivel.GetNumero()) as Class;
		}
		
		public function GetMask()
		{
			return estrutura.GetGrafico().applicationDomain.getDefinition("Mask") as Class;
		}
		
		public override function GetMovieClipConstruindo()
		{
			if ( estrutura.GetGrafico().applicationDomain.hasDefinition( "Construindo" + nivel.GetNumero() ) )
				return estrutura.GetGrafico().applicationDomain.getDefinition("Construindo" + nivel.GetNumero()) as Class;
			else
				return MovieClip;
		}
		
		public function GetEstrutura() : Estrutura
		{
			return estrutura;
		}
		
		public function GetNivel() : Nivel
		{
			return nivel;
		}
		
		public function GetDescricao() : String
		{
			return nivel.GetDescricao();
		}
		
		public function SetNivelByName(nomeNivel: String)
		{
			nivel = estrutura.GetNivelByName(nomeNivel);
		}
		
		public function UpNivel()
		{
			nivel = estrutura.GetNivel(nivel.GetNumero());
		}
		
		public function GetContribuicao(contribuicao: Object)
		{
			var contribuicaoNivel 	= nivel.GetContribuicao(contribuicao);
			return Math.round(contribuicaoNivel * (pontosVida/100));
		}

		public function GetCategoria()
		{
			return estrutura.GetCategoria();
		}

		public function GetFuncao()
		{
			return estrutura.getFuncao();
		}
		
		public function GetTempoConstrucao()
		{
			var nivel = GetNivel();
			return nivel.GetTempoConstrucao();
		}
		
		public function AplicarDano( dano )
		{
			pontosVida -= dano;
			if (pontosVida < 0) pontosVida = 0;
		}

		public function ReturnPontosDeVida():Number
		{
			return pontosVida;
		}
	}
}