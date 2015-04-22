﻿
package core.util
{
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.utils.getTimer;

    public class NumberFormat
	{
        public static function FormatCurrency( number:Number, 
											   precision:int, 
											   decimalDelimiter:String = ".", 
											   commaDelimiter:String = ",", 
											   prefix:String = "", 
											   suffix:String = "" ):String
		{
			var decimalMultiplier:int = Math.pow(10, precision);
			var str:String = Math.round(number * decimalMultiplier).toString();
			
			var leftSide:String = str.substr(0, -precision);
			var rightSide:String = str.substr(-precision);
			
			var leftSideNew:String = "";
				for (var i:int = 0;i < leftSide.length;i++)
			{
				if (i > 0 && (i % 3 == 0 ))
				{
					leftSideNew = commaDelimiter + leftSideNew;
				}
					 
				leftSideNew = leftSide.substr(-i - 1, 1) + leftSideNew;
			} 
				   
			return prefix + leftSideNew + decimalDelimiter + rightSide + suffix;
		}
    }
}