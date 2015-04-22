package core.interfac
{
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.geom.Rectangle; 
	import flash.display.Shape; 

	public class ScrollHorizontal extends MovieClip
	{
		
		private var _dragged:MovieClip; 
		private var _mask:MovieClip; 
		private var _ruler:MovieClip; 
		private var _background:MovieClip; 
		private var _hitarea:MovieClip;
		private var _containerMask:MovieClip;
		private var _blurred:Boolean; 
		private var _XFactor:Number;
				
		private var _initX:Number; 
		
		private var minX:Number;
		private var maxX:Number;
		private var percentuale:uint;
		private var contentstarty:Number; 
		private var bf:BlurFilter;
		
		private var initialized:Boolean = false; 
		
		public function ScrollHorizontal(dragged:MovieClip, maskclip:MovieClip, ruler:MovieClip, background:MovieClip, hitarea:MovieClip, containerMask: MovieClip, blurred:Boolean = false, xfactor:Number = 4 )
		{
			super();
			_dragged = dragged; 
			_mask = maskclip; 
			_ruler = ruler; 
			_background = background; 
			_hitarea = hitarea as MovieClip;
			trace(_hitarea);
			_containerMask = containerMask;
			_blurred = blurred; 
			_XFactor = xfactor; 
		}
		
		public function set dragged (v:MovieClip) {
			_dragged = v; 
		}
		
		public function set maskclip (v:MovieClip) {
			_mask = v; 
		}
		
		public function set ruler (v:MovieClip) {
			_ruler = v; 
		}
		
		public function set background (v:MovieClip) {
			_background = v; 
		}
		
		public function set hitarea (v:MovieClip) {
			_hitarea = v; 
		}		
		
		private function checkPieces():Boolean {
			var ok:Boolean = true; 
			if (_dragged == null) {
				trace("SCROLLBAR: DRAGGED not set"); 
				ok = false; 	
			}
			if (_mask == null) {
				trace("SCROLLBAR: MASK not set"); 
				ok = false; 	
			}
			if (_ruler == null) {
				trace("SCROLLBAR: RULER not set"); 	
				ok = false; 
			}
			if (_background == null) {
				trace("SCROLLBAR: BACKGROUND not set"); 	
				ok = false; 
			}
			if (_hitarea == null) {
				trace("SCROLLBAR: HITAREA not set"); 	
				ok = false; 
			}
			return ok; 
		}
		
		public function init(e:Event = null):void {
			if (checkPieces() == false) {
				trace("SCROLLBAR: CANNOT INITIALIZE"); 
			} else { 
				
				if (initialized == true) {
					reset();
				}
				bf = new BlurFilter(0, 0, 1); 
				this._dragged.filters = new Array(bf); 
				this._dragged.mask = this._mask; 
				this._dragged.cacheAsBitmap = true; 
				
				this.minX = _background.x; 
				
				this._ruler.buttonMode = true; 
	
				this.contentstarty = _dragged.x; 
	
				_ruler.addEventListener(MouseEvent.MOUSE_DOWN, clickHandle); 
				stage.addEventListener(MouseEvent.MOUSE_UP, releaseHandle); 
				stage.addEventListener(MouseEvent.MOUSE_WHEEL, wheelHandle, true); 
				this.addEventListener(Event.ENTER_FRAME, enterFrameHandle); 
				
				initialized = true; 
			}
		}
		
		private function clickHandle(e:MouseEvent) 
		{
			var rect:Rectangle = new Rectangle(minX, _background.y - _ruler.height/2, maxX, 0);
			_ruler.startDrag(false, rect);
		}
		
		private function releaseHandle(e:MouseEvent) 
		{
			_ruler.stopDrag();
		}
		
		private function wheelHandle(e:MouseEvent)
		{
			if (this._hitarea.hitTestPoint(stage.mouseX, stage.mouseY, false))
			{
				scrollData(e.delta);		
			}
		}
		
		private function enterFrameHandle(e:Event)
		{
			positionContent();
		}
		
		private function scrollData(q:int)
		{
			var d:Number;
			var rulerX:Number; 
			
			var quantity:Number = this._ruler.width / 5; 

			d = -q * Math.abs(quantity); 
	
			if (d > 0) {
				rulerX = Math.min(maxX, _ruler.x + d);
			}
			if (d < 0) {
				rulerX = Math.max(minX, _ruler.x + d);
			}
			
			_ruler.x = rulerX; 
	
			positionContent();
		}
		
		public function positionContent():void {
			var upX:Number;
			var downX:Number;
			var curX:Number;
			
			/* thanks to Kalicious (http://www.kalicious.com/) */
			this._ruler.width = (this._mask.width / this._dragged.width) * this._background.width;
			this.maxX = this._background.width - this._ruler.width;
			/*	*/ 		

			var limit:Number = this._background.width - this._ruler.width; 

 			if (this._ruler.x > limit) {
				this._ruler.x = limit; 
			} 
	
			checkContentLength();	
	
			percentuale = (100 / maxX) * _ruler.x;
				
			upX = 0;
			downX = _dragged.width - (_mask.width / 2);
			 
			var fx:Number = contentstarty - (((downX - (_mask.width/2)) / 100) * percentuale); 
			
			var currx:Number = _dragged.x; 
			var finalx:Number = fx; 
			
			if (currx != finalx) {
				var diff:Number = finalx-currx;
				currx += diff / _XFactor; 
				
				var bfactor:Number = Math.abs(diff)/8; 
				bf.blurX = bfactor/2; 
				if (_blurred == true) {
					_dragged.filters = new Array(bf);
				}
			}
			
			_dragged.x = currx;
			_containerMask.x = currx;
		}
		
		public function checkContentLength():void
		{
			if (_dragged.width < _mask.width) {
				_ruler.visible = false;
				reset();
			} else {
				_ruler.visible = true; 
			}
		}
		
		public function reset():void {
			_dragged.x = contentstarty; 
			_ruler.x = 0; 			
		}
		
	}
}