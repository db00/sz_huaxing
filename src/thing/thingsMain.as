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
		//[SWF(width="256",height="192",frameRate="60",backgroundColor=0x0)]
	//[SWF(width="1920",height="270",frQameRate="60",backgroundColor="0x0")]
		[SWF(width="7680",height="1080",frQameRate="60",backgroundColor="0x0")]
		public class thingsMain extends Sprite
		{
			private static var _main:thingsMain;

			public static function get main():thingsMain
			{
				if (_main == null)
					_main = new thingsMain;
				return _main;
			}
			CONFIG::NET private function data_recved(e:Event):void
			{
				var data:String = String(e.target.data).substr(1);
				ScreenSave.reset();
				switch(data)
				{
					case "0":// origin status
						ScreenSave.start();
						break;
					case "1":
					case "2":
					case "3":
					case "4":
					case "5":
					case "6":
					case "7":
					case "8":
						MoveWithLines.click_node(int(data)-1);
						break;
					case "left":
						if(movewithlines)
							movewithlines.toleft();
						break;
					case "right":
						if(movewithlines)
							movewithlines.toright();
						break;
					case "next":
					case "prev":
						if(troundshow)
							troundshow.click(data);
						break;
					default:
						if(data.charAt(0)=="i")
						{
							/*
							   if(tvmenu == null){
							   curYear= String(int(int(data.charAt(0))/10)+2008);
							   tvmenu = new Tvmenu(curYear);
							   }
							 */
							if(tvmenu)
								tvmenu.click(data.substr(1));
						}
				}
			}

			public function thingsMain()
			{
				_main = this;


				CONFIG::NET{
					if(Tdata.addressArr && Tdata.addressArr.length > Tdata.windowIndex)
					{
						var httpserver:HttpServer = new HttpServer(Tdata.addressArr[Tdata.windowIndex].port);
						addChild(httpserver);
						httpserver.addEventListener(HttpServer.DATA,data_recved);
					}
				}


				var left_title_png:Bitmap = new Tasset.left_title_png;
				left_title_png.smoothing = true;
				left_title_png.y = 1080*.4-left_title_png.height/2;
				left_title_png.x = 100;


				/*
				   var bg:Bitmap = new Tasset.bg_png;
				   bg.width = Tdata.stageW;
				   bg.height= Tdata.stageH;
				   addChild(bg);
				 */

				addChild(left_title_png);
				addChild(new TrightNews);

				var btnPathArr:Array = [
					Tdata.rootPath+"btn.png",
					Tdata.rootPath+"btn.png",
					Tdata.rootPath+"btn.png",
					Tdata.rootPath+"btn.png",
					Tdata.rootPath+"btn.png",
					Tdata.rootPath+"btn.png",
					Tdata.rootPath+"btn.png",
					Tdata.rootPath+"btn.png",
					];

				var btnPathArr2:Array = [
					Tdata.rootPath+2009+".png",
					Tdata.rootPath+2010+".png",
					Tdata.rootPath+2011+".png",
					Tdata.rootPath+2012+".png",
					Tdata.rootPath+2013+".png",
					Tdata.rootPath+2014+".png",
					Tdata.rootPath+2015+".png",
					Tdata.rootPath+2016+".png",
					];

				movewithlines = new MoveWithLines(btnPathArr,btnPathArr2);
				//movewithlines.x = 700;
				//movewithlines.y = 400;
				movewithlines.addEventListener(Event.SELECT,showTvmemu);
				movewithlines.addEventListener(Event.CHANGE,clears);


				addChild(movewithlines);

				//init(Gdata.curDir);
				addChild(new logs);
				CONFIG::debugging
				{
					logs.txt.visible = true;
					logs.adds("hello.. thingsMain");
					//addChild(new MoveWithLines(SwfLoader.filesInDir(Tdata.rootPath,SwfLoader.imgReg)));
					//tvmenu = new Tvmenu(curYear); addChild(tvmenu).addEventListener(Event.SELECT,showTround);
					//addChild(new TroundShow);
					//return;
				}



				var timeout:uint =10;
				try{
					timeout = uint(SwfLoader.readfile("time.txt"));
				}catch(e:Error){
					logs.adds(e,"timeout:",timeout);
				}
				if(timeout<=0)timeout = 10;
				addChild(new ScreenSave(null,toInit,null,timeout*1000));
			}

			private var movewithlines:MoveWithLines;
			private function toInit(e:Event=null):void
			{
				//logs.txt.visible = true;
				logs.adds("-----------start ScreenSave----------");
				movewithlines.toInit();
				clears();
			}

			private var tvmenu:Tvmenu;
			private function showTvmemu(e:Event=null):void{
				clears();
				if(e){
					var target:Sprite =  movewithlines.curObj as Sprite; 
					var i:int = int(target.name.substr(1))+2009;
					curYear = String(i);
				}
				tvmenu = new Tvmenu(curYear);
				tvmenu.x = movewithlines.selectedX-45/2;
				tvmenu.y = movewithlines.selectedY;
				addChild(tvmenu);
				tvmenu.addEventListener(Event.SELECT,showTround);
			}
			private var curYear:String = "2009";
			private var troundshow:TroundShow; 
			private function showTround(e:Event):void{
				var target:Sprite = tvmenu.SelectedBtn as Sprite;
				if(target)
				{
					//clears();
					var s:String = String(target.name.substr(1));
					trace("selected:",s);
					troundshow= new TroundShow(Tdata.rootPath+curYear+"/"+String(s));
					troundshow.x = movewithlines.selectedX-400;
					troundshow.y = movewithlines.selectedY-400;
					addChild(troundshow);
					//troundshow.addEventListener(Event.SELECT,showTround);
				}
			}

			private function clears(e:Event=null):void
			{
				if(troundshow){
					if(troundshow.parent)troundshow.parent.removeChild(troundshow);
					troundshow= null;
				}
				if(tvmenu){
					if(tvmenu.parent)tvmenu.parent.removeChild(tvmenu);
					tvmenu = null;
				}
			}
		}
}

