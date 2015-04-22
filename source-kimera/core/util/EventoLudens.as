
package core.util
{
	import flash.events.Event;
	
	
	public class EventoLudens extends Event
	{		
		public static const FALHA_LOGIN 		= "EventoLudensFalharLogin";
		public static const SUCESSO_LOGIN 		= "EventoLudensSucessoLogin";
		
		public static const SUCESSO_REGISTRO 	= "EventoLudensSucessoRegistro";
		public static const FALHA_REGISTRO 		= "EventoLudensFalharRegistro";
		
		public var data: Object;
		
		public function EventoLudens(type: String, pData: Object)
		{
			super(type);
			this.data = pData;
		}
		
		public override function clone():Event
        {
            return new EventoLudens(type, data);
        }	
	}
}