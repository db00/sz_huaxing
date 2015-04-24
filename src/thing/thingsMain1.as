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
	//CONFIG::PUBLISH
	//{
	
	//}
	[SWF(width="1920",height="1080",frQameRate="60",backgroundColor="0x0")]
	
	public class thingsMain1 extends Sprite
	{
		private static var _main:thingsMain1;
		
		private static function get windowIndex():int
		{
			return Tdata.windowIndex;
		}
		
		public static function get main():thingsMain1
		{
			if (_main == null)
				_main = new thingsMain1;
			return _main;
		}
		
		private var movewithlines:MoveWithLines;
		
		public function thingsMain1()
		{
			_main = this;
			Tdata.windowIndex = 0;
			
			//scaleX = scaleY = .4;
			[Embed(source="asset/bg1.jpg")]
			var bg1png:Class;
			var bg:Bitmap = new bg1png;
			addChild(bg);
			bg.width = 1920;
			bg.height = 1080;
			
			addChild(new logs);
			logs.txt.visible = false;
			
			var thingsmain:thingsMain = new thingsMain;
			thingsmain.x = -windowIndex * 1920;
			mask = addChild(new Bitmap(new BitmapData(1920, 1080)));
			addChild(thingsmain);
			
			stage.scaleMode = StageScaleMode.EXACT_FIT;
			CONFIG::PUBLISH
			{
				stage.displayState = StageDisplayState.FULL_SCREEN;
				//stage.scaleMode = StageScaleMode.NO_SCALE;
				//stage.align = StageAlign.TOP_LEFT;
			}
			CONFIG::debugging
			{
				stage.displayState = StageDisplayState.FULL_SCREEN;
				//stage.scaleMode = StageScaleMode.NO_SCALE;
				//stage.align = StageAlign.TOP_LEFT;
			}
		}
	
	}
}

