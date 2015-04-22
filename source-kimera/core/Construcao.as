package core
{
	import as3isolib.display.IsoSprite;
	import flash.geom.Point;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.display.MovieClip;
	import flash.utils.getTimer;
	
	public class Construcao
	{
		public static var STATUS_CONSTRUINDO = 'construindo';
		public static var STATUS_CONSERTANDO = 'consertando';
		public static var STATUS_PRONTA 	  = 'pronta';		
		
		protected var pontosVida    : Number;
		
		private var status       	: String;
		private var tempoCriacao 	: int; // Instante em que a construcao foi criada.
		private var tempoConstrucao : int; // Tempo, em milissegundos, que a construcao leva
										   // p/ ficar pronta.
										   
		private var tempoConserto	: int; // Instante em que a construção começou
										   // a ser consertada.
		
		private var posicao      	: Point;
		private var grafico      	: IsoSprite;
		
		private var configInicial	: Boolean; // indica se a construção já veio com a fase, ou se foi construída depois.
		
		public function Construcao( pPosicao : Point, pConfigInicial : Boolean, pPontosVida = 100)
		{
			posicao      	= pPosicao;
			status       	= Construcao.STATUS_CONSTRUINDO;
			tempoCriacao 	= getTimer();
			grafico		 	= null;
			pontosVida		= pPontosVida;
			configInicial   = pConfigInicial;
		}
		
		public function GetGrafico() : IsoSprite
		{
			return grafico;
		}
		
		public function GetMovieClipConstruindo()
		{
			return MovieClip;
		}
		
		public function SetGrafico(pGrafico: IsoSprite)
		{
			grafico = pGrafico;
		}
		
		public function GetPosicao() : Point
		{
			return posicao;
		}
		
		public function SetStatus(pStatus: String)
		{
			status = pStatus;
		}
		
		public function GetStatus()
		{
			return status;
		}		
		
		public function SetPosicao(pPosicao)
		{
			posicao = pPosicao;
		}
		
		public function SetTempoCriacao(pTempoCriacao: int)
		{
			tempoCriacao = pTempoCriacao;
		}
		
		public function GetTempoCriacao()
		{
			return tempoCriacao;
		}
		
		public function SetTempoConserto(pTempoConserto: int)
		{
			tempoConserto = pTempoConserto;
		}
		
		public function GetTempoConserto()
		{
			return tempoConserto;
		}
		
		public function SetPontosVida(pPontosVida: Number)
		{
			pontosVida = pPontosVida;
		}
		
		public function GetPontosVida()
		{
			return pontosVida;
		}
		
		public function GetConfigInicial()
		{
			return configInicial;
		}
	}
}