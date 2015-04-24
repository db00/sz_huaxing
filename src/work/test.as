/**

  /home/libiao/flex_sdk_4.5/bin/amxmlc -tools-locale en_US -compiler.strict test.as -define=CONFIG::IS_IOS,false -define=CONFIG::debugging,true -define=CONFIG::PUBLISH,false -define=CONFIG::chat,false -define=CONFIG::NO_VOICE,false -define=CONFIG::FANTI,false -define=CONFIG::NORMAL_SCREEN,true -source-path=.. -debug=true -output ./test.swf  -library-path+=../greensock.swc && /home/libiao/flex_sdk_4.5/bin/adl test.xml
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
	[SWF(width="6480",height="1920",frQameRate="60",backgroundColor="0xffffff")]
		//}

		//[SWF(width="1256",height="1920",frameRate="60",backgroundColor=0x0)]
		public class test extends Sprite
		{
			private static var _main:test;

			public static function get main():test
			{
				if (_main == null)
					_main = new test;
				return _main;
			}
			public static var httpserver:HttpServer;


			private var screensave:ScreenSave = new ScreenSave("屏保.flv");
			private function init():void
			{
				addChild(screensave);
			}
			public function test()
			{
				_main = this;
				addChild(new logs);
				logs.adds("hello.. workServer");
				if(stage){
					addChild(screensave);
				}else{
					addEventListener(Event.ADDED_TO_STAGE,init);
				}

				/*
				   [Embed(source="s/bg.png")] var  bgpng:Class;
				   var bg:Bitmap = new bgpng;
				   bg.width = 6480;
				   bg.height= 1920;
				   addChild(bg);

				   stage.displayState = StageDisplayState.FULL_SCREEN;


				   CONFIG::debugging{
				//addChild(new Srate);
				//addChild(new Snews);
				addChild(Shengchanjiankong.main);
				addChild(Shipinhuiyi.main);
				addChild(Quanqiushuju.main);
				}
				addChild(bg);

				httpserver = new HttpServer(Wdata.port);
				addChild(httpserver);
				httpserver.addEventListener(HttpServer.DATA,data_recved);
				 */
			}

			/*
			   private function data_recved(e:Event):void
			   {
			   var data:String = e.target.data;
			   if(data){
			   data = decodeURI(data);
			   logs.adds("httpserver data:",data);
			   init(data.substr(1));
			   }
			   }

			   private var curState:String ;
			   private function init(s:String):void
			   {
			   logs.adds(s);
			   if(s!="视频会议"){
			   Shipinhuiyi.main.quit();
			   }
			   if(s!="生产监控"){
			   Shengchanjiankong.main.quit();
			   }
			   if(s!="全球数据"){
			   Quanqiushuju.main.quit();
			   }
			   switch(s)
			   {
			   case "视频会议":
			   addChild(Shipinhuiyi.main);
			   if(curState!=s){
			   Shipinhuiyi.main.showFirst();
			   }else{
			   Shipinhuiyi.main.showVideo();
			   }
			   break;
			   case "生产监控":
			   addChild(Shengchanjiankong.main);
			   if(curState!=s){
			   Shengchanjiankong.main.showFirst();
			   }else{
			   Shengchanjiankong.main.showVideo();
			   }
			   break;
			   case "全球数据":
			   addChild(Quanqiushuju.main);
			   if(curState!=s){
			   Quanqiushuju.main.showFirst();
			   }else{
			   Quanqiushuju.main.showVideo();
			   }
			   break;
			   case "enter":
			   break;
			   }
			   curState = s;
			   }
			 */
		}
}

