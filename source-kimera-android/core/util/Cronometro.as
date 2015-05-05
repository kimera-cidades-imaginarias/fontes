package core.util
{
	import flash.utils.getTimer;	
	public class Cronometro
	{
		private var tempo = 0;
		private var contadorTempo = 0;
		
		public function Cronometro(tempoInicial = 0)
		{
			tempo = tempoInicial;
		}
		
		public function Iniciar(tempoInicial = 0)
		{
			tempo = tempoInicial;
			contadorTempo = getTimer();
		}
		
		public function GetTempoPassado()
		{
			var tempoPassado = getTimer() - contadorTempo;
			var total = (tempo + tempoPassado);
			return total;
		}
	}
}