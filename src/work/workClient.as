/**
  1 工作体验—桌面联动会议互动
  在此展项,屏幕显示内容为模拟视频会议现场的场景及控制场景.操作软件系统和显示系统是需要进行联动.通过桌面触摸点击进入控制系统后,墙面上的6块显示屏进行画面联动,进行模拟会议现场。

 */
package work
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
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.ProgressEvent;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.Capabilities;
	import flash.utils.*;
	//CONFIG::PUBLISH
	//{
	[SWF(width="1920",height="1080",frQameRate="60",backgroundColor="0x0")]
		//}

		//[SWF(width="256",height="192",frameRate="60",backgroundColor=0x0)]
		public class workClient extends Sprite
		{
			private static var _main:workClient;

			public static function get main():workClient
			{
				if (_main == null)
					_main = new workClient;
				return _main;
			}

			public function workClient()
			{
				_main = this;
				stage.displayState = StageDisplayState.FULL_SCREEN;
				stage.scaleMode = StageScaleMode.EXACT_FIT;

				addChild(Client0.main);
				CONFIG::debugging{
					addChild(new logs);
					logs.adds("hello.. workClient");
					//addChild(Client1.main);
				}
			}


		}
}

