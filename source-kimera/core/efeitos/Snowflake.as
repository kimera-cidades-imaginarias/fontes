package core.efeitos
{
	import flash.display.*;
	import flash.events.*;

	public class Snowflake extends MovieClip
	{
        private var xPos:Number = 0;
        private var yPos:Number = 0;

        private var xSpeed:Number = 0;
        private var ySpeed:Number = 0;

        private var radius:Number = 0;

        private var scale:Number = 0;
        private var alphaValue:Number = 0;
		
		private var maxHeight:Number = 0;
		private var maxWidth:Number = 0;
		
		public function Snowflake()
		{
			//SetInitialProperties();
		}
		
		public function SetInitialProperties()
		{
			//Setting the various parameters that need tweaking 
			xSpeed = .05 + Math.random()*.1;
			ySpeed = .1 + Math.random()*3;
			radius = .1 + Math.random()*2;
			scale = .01 + Math.random();
			alphaValue = .1 + Math.random();

			var stageObject:Stage = this.stage as Stage;
			maxWidth = stageObject.stageWidth;
			maxHeight = stageObject.stageHeight;
			
			this.x = Math.random()*maxWidth;
			this.y = Math.random()*maxHeight;
			
			xPos = this.x;
			yPos = this.y;
			
			this.scaleX = this.scaleY = scale;
			this.alpha = alphaValue;
			
			this.addEventListener(Event.ENTER_FRAME, MoveSnowFlake);
		}

		function MoveSnowFlake(e:Event)
		{
			xPos += xSpeed;
			yPos += ySpeed;
			
			this.x += radius*Math.cos(xPos);
			this.y += ySpeed;
			
			if (this.y - this.height > maxHeight)
			{
				this.y = -10 - this.height;
				this.x = Math.random()*maxWidth;
			}
		}
	}
}