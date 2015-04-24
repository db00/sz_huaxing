/**
   4绿色环保—互动查询
   点击查询绿色、环保、节能等各个方面的信息，软件可针对图片及视频进行放大缩小等功能的操作，无人触摸式进入屏保模式。
   the older , the wiser. illiterate girls are considered as virtue in traditional Chinese point of view.
   the older , the uglier.

   anti-aging
 */
package green
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
	//CONFIG::PUBLISH
	//{
	[SWF(width="384",height="216",frameRate="60",backgroundColor=0x0)]
	[SWF(width="1920",height="1080",frQameRate="60",backgroundColor="0x0")]
	
	public class greenMain extends Sprite
	{
		public function greenMain()
		{
			//scaleX = scaleY = .2;
			_main = this;
			
			addChild(G0.main);
			//init(Gdata.curDir);
			CONFIG::debugging
			{
				addChild(new logs);
				logs.adds("hello.. greenMain");
				//addChild(G1.main);
				//addChild(G2.main);
				//addChild(G3.main);
				//addChild(G3.main);
				//addChild(ShowPic.main);
				return;
			}
			stage.displayState = StageDisplayState.FULL_SCREEN;
		}
		private static var _main:greenMain = null;
		
		public static function get main():greenMain
		{
			if (_main == null)
				_main = new greenMain();
			return _main;
		}
	}
}

