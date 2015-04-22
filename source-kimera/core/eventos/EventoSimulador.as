
package core.eventos
{
	import flash.events.Event;
	
	public class EventoSimulador extends Event
	{
		public static const TURNO 				 = 'EventoSimuladorTurno';
		public static const TEMPO_TURNO			 = 'EventoSimuladorTempoTurno';
		public static const INDICE 				 = 'EventoSimuladorIndice';
		public static const DESEMPENHO 			 = 'EventoSimuladorDesempenho';
		public static const POPULACAO 			 = 'EventoSimuladorPopulacao';
		public static const HABITADOS 			 = 'EventoSimuladorHabitados';
		public static const EMPREGADOS 			 = 'EventoSimuladorEmpregados';
		public static const PONTOS	 			 = 'EventoSimuladorPontos';
		public static const DINHEIRO 			 = 'EventoSimuladorDinheiro';
		public static const ATUALIZAR_CONSTRUCAO = 'EventoSimuladorAtualizarConstrucao';
		public static const CONSTRUCAO_PRONTA 	 = 'EventoSimuladorConstrucaoPronta';
		public static const ATUALIZAR_META		 = 'EventoSimuladorAtualizarMeta';
		public static const FIM_META			 = 'EventoSimuladorFimMeta';
		public static const PROGRESSO_TURNO		 = 'EventoSimuladorProgressoTurno';
		
		public static const MENSAGEM			 	= 'EventoSimuladorMensagem';
		
		public static const AVANCO_TUTORIAL			= 'EventoSimuladorAvancoTutorial';
		
		public static const DESASTRE			 	= 'EventoSimuladorDesastre';
		
		public static const ATUALIZAR_XP			= 'EventoSimuladorXP';
		public static const ATUALIZAR_NIVEL_JOGADOR	= 'EventoSimuladorPassagemNivelJogador';
		
		public static const EMPRESTIMO_DISPONIVEL		= 'EventoSimuladorEmprestimoDisponivel';
		public static const ATUALIZAR_TEMPO_EMPRESTIMO	= 'EventoSimuladorAtualizarTempoEmprestimo';
		public static const UTILIZANDO_EMPRESTIMO		= 'EventoSimuladorUtilizandoEmprestimo';
		public static const TEMPO_EMPRESTIMO_ESGOTADO	= 'EventoSimuladorTempoEmprestimoEsgotado';
		
		public static const INICIO_CONSERTO			= 'EventoSimuladorInicioConserto';
		public static const FIM_CONSERTO			= 'EventoSimuladorFimConserto';
		
		public static const CONSTRUCAO_DESTRUIDA	= 'EventoSimuladorConstrucaoDestruida';
		
		public static const CHUVA				= 'EventoSimuladorChuva';
		public static const SOL				 	= 'EventoSimuladorSol';
		public static const NEVOA			 	= 'EventoSimuladorNevoa';
		
		public static const TRANSITO			= 'EventoSimuladorTransito';
		
		public var data;

		public function EventoSimulador(type: String, data: Object)
		{
			super(type);
			this.data = data;
		}
		
		public override function clone(): Event
		{
			return new EventoSimulador(type, data);
		}
	}
}