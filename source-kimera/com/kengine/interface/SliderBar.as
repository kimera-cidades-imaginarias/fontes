package com.kengine.interface
{
	import flash.geom.Point;
	import flash.events.Event;	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class SliderBar
	{
		private var movieClip_mc 	: MovieClip;
		private var maxBotaoY		: Number;
		
		private var valueChangeListener	: Function;
		private var value_				: Number;
			
		function SliderBar(movieClip: MovieClip, valueChangeListener_: Function = null)
		{
			movieClip_mc= movieClip;
			maxBotaoY	= movieClip_mc.width;
			
			valueChangeListener	= valueChangeListener_;
			
			Init();
		}		
		
		public function Init()
		{
			movieClip_mc.botao_mc.buttonMode = true;
			movieClip_mc.botao_mc.addEventListener(MouseEvent.MOUSE_DOWN, StartDrag);
			movieClip_mc.botao_mc.addEventListener(MouseEvent.MOUSE_UP	, StopDrag);
			movieClip_mc.addEventListener(MouseEvent.ROLL_OUT			, StopDrag);
		}
		
		//------------------------------------------------------
		//	Interação com o Slider.
		//---------------------------------------------------------
		private function StartDrag(evt: Event)
		{
			movieClip_mc.addEventListener(Event.ENTER_FRAME, DoDrag);
		}
		
		private function DoDrag(evt: Event)
		{
			var maskScale				= movieClip_mc.mouseX / maxBotaoY;		
			if (maskScale >= 0 && maskScale <= 1) SetValue(maskScale);
		}
		
		private function StopDrag(evt: Event)
		{						
			movieClip_mc.removeEventListener(Event.ENTER_FRAME, DoDrag);		
		}
		
		//-------------------------------------------------------
		//	Set / Get de valor.
		//---------------------------------------------------------
		public function SetValue(v: Number)
		{
			value_ = v;

			movieClip_mc.botao_mc.x 	= v * maxBotaoY;
			//movieClip_mc.mask_mc.scaleX = v;

			if (valueChangeListener != null)
			{
				valueChangeListener({movie: movieClip_mc, value: v});
			}
		}
		
		public function GetValue()
		{
			return value_;
		}
	}
}