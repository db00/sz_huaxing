/**
   3璀璨华星人—多屏联动展示。
   多屏展示软件系统,通过人物笑脸墙的形式进行软件编程,循环播放,后台支持本地数据添加及更新.表现形式需进行在创意。
 */
package staff
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
	//[SWF(width="1024",height="768",frQameRate="60",backgroundColor="0x0")]
	//}
	
	[SWF(width="7680",height="1080",frQameRate="60",backgroundColor="0x0")]
	[SWF(width="768",height="108",frameRate="60",backgroundColor=0x0)]
	
	//[SWF(width="320",height="240",frameRate="60",backgroundColor=0x0)]
	public class staffMain extends Sprite
	{
		private static var _main:staffMain;
		
		public static function get main():staffMain
		{
			if (_main == null)
				_main = new staffMain;
			return _main;
		}
		
		public function staffMain()
		{
			_main = this;
			addChild(new logs);
			logs.txt.visible = false;
			
			var myvideo:MyVideo = new MyVideo("shiping.flv",true);addChild(myvideo);myvideo.setSize(stage.stageWidth,stage.stageHeight);
			return;
			
			mask = addChild(new Bitmap(new BitmapData(stage.stageWidth, stage.stageHeight)));
			var pathArr:Array = SwfLoader.filesInDir(SwfLoader.rootPath + "璀璨华星人", SwfLoader.imgReg);
			
			CONFIG::debugging
			{
				//stage.displayState = StageDisplayState.FULL_SCREEN;
				logs.adds("hello.. staffMain");
				//logs.adds(TweenGroupDemo2.genRandomArr(10));
				//addChild(new TweenGroupDemo2(pathArr,stage.stageWidth,stage.stageHeight));
				addChild(new Wall3d(pathArr, stage.stageWidth, stage.stageHeight));
				SwfLoader.SwfLoad("bg.jpg", bgloaded);
				return;
			}
			CONFIG::PUBLISH
			{
				//[Embed(source="bg.jpg")] var  bgpng:Class; addChild(new bgpng);
				//stage.scaleMode= StageScaleMode.EXACT_FIT;
				//stage.displayState = StageDisplayState.FULL_SCREEN;
				
				SwfLoader.SwfLoad("bg.jpg", bgloaded);
				
				//addChild(new Carousel(pathArr));
				//addChild(new Carousel(["1.png","2.png","3.png"]));
				//addChild(new PicsWall3d(pathArr));
				addChild(new Wall3d(pathArr, stage.stageWidth, stage.stageHeight));
				return;
			}
			stage.scaleMode = StageScaleMode.EXACT_FIT;
			stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
			//stage.addEventListener("fullScreen", fullScreen);
		
		}
		
		private function bgloaded(e:Event = null):void
		{
			if (e && e.type == Event.COMPLETE)
			{
				var bg:Bitmap = e.target.content as Bitmap;
				if (bg)
				{
					bg.smoothing = true;
					bg.width = stage.stageWidth;
					bg.height = stage.stageHeight;
					addChildAt(bg, 0);
				}
			}
		}
		
		private function fullScreen(e:Event = null):void
		{
			stage.displayState = StageDisplayState.FULL_SCREEN;
		}
	}
}

