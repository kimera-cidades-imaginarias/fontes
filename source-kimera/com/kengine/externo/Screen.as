package com.kengine.externo
{	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	import gs.TweenLite;
	
	public class Screen extends MovieClip
	{
		protected var interfaceState 		: String;
		protected var interfaceOldState 	: String;
		protected var shiftPressed			: Boolean;
		protected var _endCallback:Function = null;
		
		public static var EVENT_FINISHED : String = "finish";
		
		public function Screen()
		{
			super();
			trace("screen cons");
			initInterface();
			
			// Event Listeners da interface
			this.addEventListener( KeyboardEvent.KEY_DOWN, keyPress, false, 0, true );
			this.addEventListener( KeyboardEvent.KEY_UP  , keyUp, false, 0, true );
		}
		
		public function endCallback(value:Function):void
		{
			_endCallback = value;
		}
		
		/**
		 * Função responsável por permitir a inicialização
		 * dos diversos elementos dassa tela, como botões,
		 * sons, filmes entre outros.
		 */
		public function initInterface() : void
		{
			
		}
		
		public function setState( newState : String ) : void
		{
			interfaceOldState = interfaceState;
			interfaceState = newState;
		}
		
		public function keyPress(evt)
		{
			if(evt.keyCode == 16) // SHIFT
			{
				shiftPressed = true;
			}
		}
		
		public function keyUp(evt)
		{
			if(evt.keyCode == 16) // SHIFT
			{
				shiftPressed = false;
			}
		}
		
		protected function clearMovie()
		{
			trace("clearMovie");
			dispatchEvent(new Event(EVENT_FINISHED));
			delete this;
		}
		
		public function finishScreen()
		{
			trace("finish screen");
			TweenLite.to(this, 0.5, {autoAlpha: 0, onComplete: clearMovie});	
			if(_endCallback != null)
				_endCallback();
		}
	}
}