/**
   大事记
 */
package thing
{
	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.Capabilities;
	import flash.utils.*;
	[SWF(width="1920",height="1080",frQameRate="60",backgroundColor="0x0")]
	
	public class thingsMain4 extends Sprite
	{
		private static var _main:thingsMain4;
		
		public static function get main():thingsMain4
		{
			if (_main == null)
				_main = new thingsMain4;
			return _main;
		}
		
		private static function get windowIndex():int
		{
			return Tdata.windowIndex;
		}
		private var movewithlines:MoveWithLines;
		
		public function thingsMain4()
		{
			_main = this;
			Tdata.windowIndex = 3;
			[Embed(source="asset/bg4.jpg")]
			var bg1png:Class;
			var bg:Bitmap = new bg1png;
			addChild(bg);
			bg.width = 1920;
			bg.height = 1080;
			
			addChild(new logs);
			logs.txt.visible = false;
			
			stage.scaleMode = StageScaleMode.EXACT_FIT;
			stage.displayState = StageDisplayState.FULL_SCREEN;
			//stage.align = StageAlign.TOP_LEFT;
			//stage.scaleMode = StageScaleMode.NO_SCALE;
			
			var thingsmain:thingsMain = new thingsMain;
			thingsmain.x = -windowIndex * 1920;
			mask = addChild(new Bitmap(new BitmapData(1920, 1080)));
			addChild(thingsmain);
		}
	}
}

