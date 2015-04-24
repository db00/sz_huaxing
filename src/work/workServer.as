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
	[SWF(width="6480",height="1920",frameRate="60",backgroundColor="0x0")]
		//}

		//[SWF(width="1256",height="1920",frameRate="60",backgroundColor=0x0)]
		public class workServer extends Sprite
		{
			private static var _main:workServer;

			public static function get main():workServer
			{
				if (_main == null)
					_main = new workServer;
				return _main;
			}
			public static var httpserver:HttpServer;


			public function workServer()
			{
				_main = this;
				var timeout:uint = 0;
				try{
					timeout = uint(SwfLoader.readfile("time.txt"));
				}catch(e:Error){
					addChild(new logs);
					logs.adds(timeout,"timeout 60 .");
					logs.txt.visible = true;
				}
				if(timeout==0)timeout=60;
				addChild(new ScreenSave("server/pingbao.flv",null,null,timeout*1000));
				ScreenSave.start();





				addChild(new PhotoLoader("bg.png",6480,1920));
				/*
				   [Embed(source="s/bg.jpg")] var bgpng:Class;
				   var bg:Bitmap = new bgpng;
				   bg.width = 6480;
				   bg.height= 1920;
				   bg.smoothing = true;
				   addChild(bg);
				 */

				CONFIG::debugging{
					logs.adds("hello.. workServer");
					var theMask:Sprite = new Sprite();
					var i:int = 0;
					while(i<6){
						var screenMask:Bitmap = new Bitmap(new BitmapData(1078,1920));
						screenMask.x = 1080*i;
						theMask.addChild(screenMask);
						++i;
					}
					mask = addChild(theMask);
					//addChild(new Srate);
					//addChild(new Snews);
					addChild(Quanqiushuju.main);
					addChild(Shipinhuiyi.main);
					addChild(Shengchanjiankong.main);
					init("全球数据");
				}


				httpserver = new HttpServer(Wdata.port);
				addChild(httpserver);
				httpserver.addEventListener(HttpServer.DATA,data_recved);

				stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
				stage.scaleMode = StageScaleMode.EXACT_FIT;
			}

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
				if(s == curState)return;
				ScreenSave.stop();
				logs.adds(s);
				if(s!="视频会议"){
					Shipinhuiyi.main.quit();
				}
				if(s!="生产监控"){
					Shengchanjiankong.main.quit();
				}
				if(s!="全球数据"){
					//Quanqiushuju.main.quit();
				}
				switch(s)
				{
					case "视频会议":
						addChild(Shipinhuiyi.main);
						Shipinhuiyi.main.showVideo();
						break;
						/*
						   if(curState!=s){
						   Shipinhuiyi.main.showFirst();
						   }else{
						   Shipinhuiyi.main.showVideo();
						   }
						   break;
						 */
					case "生产监控":
						addChild(Shengchanjiankong.main);
						Shengchanjiankong.main.showVideo();
						break;
						/*
						   if(curState!=s){
						   Shengchanjiankong.main.showFirst();
						   }else{
						   Shengchanjiankong.main.showVideo();
						   }
						   break;
						 */
					case "全球数据":
						ScreenSave.reset();
						addChild(Quanqiushuju.main);
						Quanqiushuju.main.showFirst();
						break;
						/*
						   if(curState!=s){
						   Quanqiushuju.main.showFirst();
						   }else{
						   Quanqiushuju.main.showVideo();
						   }
						   break;
						 */
					case "enter":
						break;
				}
				curState = s;
			}
		}
}

