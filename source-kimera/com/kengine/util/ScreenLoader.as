package com.kengine.util
{
	
	import com.kengine.Engine;
	import com.kengine.externo.Screen;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;

	public class ScreenLoader extends Sprite
	{
		public var loader:Loader=new Loader();
		public var mcExternal:Screen;
		protected var _endCallback:Function = null;
		
		public static var EVENT_LOADED : String = "swfLoaded"; 
		
		public function ScreenLoader(arquivo : String, callBack:Function = null)
		{
			loader.load(new URLRequest(arquivo));
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,swfIn, false, 0, true);
			this.addChild(loader);
			_endCallback = callBack;
		}
		
		protected function swfIn(e:Event):void {
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,swfIn);
			mcExternal=loader.content as Screen;
			
			mcExternal.addEventListener(Screen.EVENT_FINISHED, unload, false, 0, true);
			mcExternal.endCallback(_endCallback);
			
			trace("swfload");
			
			Engine.getInstance().pararMusica();
			
			dispatchEvent(new Event(EVENT_LOADED));
		}
		
		protected function unload(evt:Event = null):void{
			trace("unload");
			loader.unloadAndStop();
			mcExternal=null;
			this.removeChild(loader);
		}
	}
}