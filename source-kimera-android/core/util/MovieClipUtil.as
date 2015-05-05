

package core.util
{
	import flash.display.BitmapData;
	
	public class MovieClipUtil
	{		
		public static function GetVisibleBounds(mc)
		{
			var myBitmapData:BitmapData = new BitmapData(mc.width,mc.height);
			myBitmapData.draw(mc);
			var bounds = myBitmapData.getColorBoundsRect( 0xFFFFFFFF, 0xFFFFFFFF, false );
			myBitmapData.dispose();
			return(bounds)
		}		
	}	
}