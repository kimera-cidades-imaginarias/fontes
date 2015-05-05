﻿/* Rain effect */
/* Developed by Carlos Yanez */
/* Image: http://www.flickr.com/photos/jinthai/3142824715/ */

package core.efeitos
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class Rain extends MovieClip
	{
		private var offset:int = 50;
		private var dropsNumber:int;
		private var dropsVector:Vector.<MovieClip> = new Vector.<MovieClip>();

		public function init(drops:int, fallSpeed:int, windSpeed:int, hArea:int, vArea:int, dir:String):void
		{
			dropsNumber = drops;

			if (dir == "right")
			{
				offset *= -1;
			}

			for (var i:int = 0; i < drops; i++)
			{
				var drop:Drop = new Drop();

				drop.fallSpeed=fallSpeed;
				drop.windSpeed=windSpeed;
				drop.dir=dir;
				drop.hArea=hArea;
				drop.vArea=vArea;

				drop.x = Math.random() * (hArea + offset);
				drop.y=Math.random()*vArea;

				//

				drop.scaleX = Math.round(((Math.random() * 1) + 0.3) * 10) / 10;
				drop.scaleY=drop.scaleX;

				//

				dropsVector.push(drop);

				addChild(drop);
			}

			inTheDirection();
		}

		private function inTheDirection():void
		{
			for (var i:int = 0; i < dropsNumber; i++)
			{
				switch (dropsVector[i].dir)
				{
					case "left" :

						dropsVector[i].addEventListener(Event.ENTER_FRAME, moveLeft);

						break;

					case "right" :

						dropsVector[i].scaleX*=-1;
						dropsVector[i].addEventListener(Event.ENTER_FRAME, moveRight);

						break;

					default :

						trace("There is some error dude...");
				}
			}
		}

		private function moveLeft(e:Event):void
		{
			e.target.x-=e.target.windSpeed;
			e.target.y+=Math.random()*e.target.fallSpeed;

			if (e.target.y>e.target.vArea+e.target.height)
			{
				e.target.x = Math.random() * (e.target.hArea + (offset * 2));
				e.target.y=- e.target.height;
			}
		}

		private function moveRight(e:Event):void
		{
			e.target.x+=e.target.windSpeed;
			e.target.y+=Math.random()*e.target.fallSpeed;

			if (e.target.y>e.target.vArea+e.target.height)
			{
				e.target.x = Math.random() * (e.target.hArea - offset * 2) + offset * 2;//Check
				e.target.y=- e.target.height;
			}
		}
	}
}