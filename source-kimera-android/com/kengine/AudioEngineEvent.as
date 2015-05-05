package {

	import flash.events.Event;
	
	public class AudioEngineEvent extends Event {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		static public const SOUND_COMPLETE:String = "soundComplete";
		static public const SOUND_STOPPED:String = "soundStopped";
		static public const SOUND_ERROR:String = "soundError";
		
		protected var _name:String;
		
		/**
		 *	@constructor
		 */
		public function AudioEngineEvent( type:String, name:String, bubbles:Boolean=false, cancelable:Boolean=false ){
			_name = name;
			super(type, bubbles, cancelable);
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------

		override public function clone() : Event {
			return new AudioEngineEvent(type, name, bubbles, cancelable);
		}
		
		/**
		 * Returns the name of the sound object to which the event corresponds.
		 */
		public function get name():String {
			return _name;
		}
				
	}
	
}
