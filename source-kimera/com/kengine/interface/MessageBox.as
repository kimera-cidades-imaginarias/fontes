package com.kengine.interface
{
	import flash.display.Sprite;
	
	public class MessageBox extends Sprite
	{
		const VELOCIDADE_ROLAGEM_TEXTO 	: int = 10;
		const VELOCIDADE_ROLAGEM_ICONES : int = 10;
		
		public function MessageBox()
		{
			super();
			
			scrollBarMensagens = new Scrollbar( container_mc, 
												mask_mc, 
												scroll_mc.scroll_mc, 
												scroll_mc.track_mc, 
												scroll_mc.track_mc, true, 6);
			
			scrollBarMensagens.addEventListener( Event.ADDED, scrollBarMensagens.init ); 
			addChild( scrollBarMensagens );
			
			container_mc.startY = container_mc.y;
			down_btn.addEventListener(MouseEvent.CLICK, function(evt)	{ buttonDown( scroll_mc.scroll_mc, scroll_mc.track_mc ); });
			up_btn.addEventListener(MouseEvent.CLICK, function(evt)	{ buttonUp( scroll_mc.scroll_mc, scroll_mc.track_mc ); });
		}
		
		public function buttonDown( scroll_mc : Sprite, track_mc : Sprite) : void 
		{
			if (scroll_mc.y + VELOCIDADE_ROLAGEM_TEXTO > track_mc.height) scroll_mc.y = track_mc.height;
			else scroll_mc.y += VELOCIDADE_ROLAGEM_TEXTO;
		}
		
		public function buttonUp( scroll_mc : Sprite, track_mc : Sprite ) : void 
		{			
			if (scroll_mc.y - VELOCIDADE_ROLAGEM_TEXTO < 0) scroll_mc.y = 0;
			else scroll_mc.y -= VELOCIDADE_ROLAGEM_TEXTO;			
		}
		
		public function buttonRight( scroll_mc : Sprite, track_mc : Sprite) : void 
		{
			if (scroll_mc.x + scroll_mc.width + VELOCIDADE_ROLAGEM_ICONES > track_mc.width) scroll_mc.x = track_mc.width - scroll_mc.width;
			else scroll_mc.x += VELOCIDADE_ROLAGEM_ICONES;
		}
		
		public function buttonLeft( scroll_mc : Sprite, track_mc : Sprite ) : void 
		{			
			if (scroll_mc.x - VELOCIDADE_ROLAGEM_ICONES < 0) scroll_mc.x = 0;
			else scroll_mc.x -= VELOCIDADE_ROLAGEM_ICONES;
		}
	}
}