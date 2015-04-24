/**
  2商业体验—互动橱窗
  此软件为多点触控系统(两个点交互),模拟华星光电设备在行业内营销方式,以查询为主,模拟商业领域查询的模式进行软件开发.初步限定为服装行业.当无人点击时,进入屏保状态.



  点击“品牌形象”要回到默认的主界面，需增加指示标示
  1.2	 设置一个默认主界面
  1.3	 点击每个功能键，界面要有动态效果
  互动橱窗需要改进的
 */
package business
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
	[SWF(width="1080",height="1920",frQameRate="60",backgroundColor="0x0")]
		//}

		//[SWF(width="256",height="192",frameRate="60",backgroundColor=0x0)]
		public class businessMain extends Sprite
		{
			private static var _main:businessMain;

			public static function get main():businessMain
			{
				if (_main == null)
					_main = new businessMain;
				return _main;
			}

			public function businessMain()
			{
				_main = this;
				mask = addChild(new Bitmap(new BitmapData(stage.stageWidth,stage.stageHeight)));
				//addChild(new logs);
				stage.displayState = StageDisplayState.FULL_SCREEN;

				showB1();
				logs.adds("hello..,businessMain");

				CONFIG::debugging{
					//addChild(new BpayEnd());
					//addChild(new Bpay());
					//addChild(new PicMoveShow(["1.png","2.png","3.png"])).addEventListener(PicMoveShow.SELECTED,show_detail);
				}
			}
			private static var b1:B1;
			public static function showB1(e:Event=null):void
			{
				if(b1==null){
					b1= new B1;
				}
				main.addChild(b1);
				Btitle.show_buy(false);
				if(b1.picmoveshow){
					b1.picmoveshow._visible = true;
					EasyOut.alphaIn(b1);
				}
			}
			private function show_detail(e:Event=null):void{
				logs.adds(PicMoveShow.curSelectedIndex);
			}
		}
}

