

package core.util 
{
	
	public class ColorUtil
	{
		
		public static function HexToRGB(hex:uint):Array
		{
			var rgb:Array = [];
		
			var r:uint = hex >> 16 & 0xFF;
			var g:uint = hex >> 8 & 0xFF;
			var b:uint = hex & 0xFF;
		
			rgb.push(r, g, b);
			return rgb;
		}
		
		public static function RGBToHex(r:uint, g:uint, b:uint):uint
		{
			var hex:uint = (r << 16 | g << 8 | b);
			return hex;
		}
		
	}
}