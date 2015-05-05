package com.kengine.util
{
	import flash.utils.getTimer;	
	public class Timer
	{
		private var tempo 			: int = 0;
		private var contadorTempo   : int = 0;
		
		public function Timer(tempoInicial : int = 0)
		{
			tempo = tempoInicial;
		}
		
		public function Iniciar() : void
		{
			contadorTempo = getTimer();
		}
		
		public function GetTempoPassado() : int
		{
			var tempoPassado = getTimer() - contadorTempo;
			var total = (tempo + tempoPassado);
			return total;
		}
	}
}