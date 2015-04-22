package com.kengine.externo
{
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	
	import gs.TweenLite;
	
	public class ScreenCinematic extends Screen
	{		
		public function ScreenCinematic()
		{
			super();
		}
		
		protected function finishCinematic()
		{
			this.finishScreen();
		}
	}
}