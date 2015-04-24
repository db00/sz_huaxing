/**
  4绿色环保—互动查询
  点击查询绿色、环保、节能等各个方面的信息，软件可针对图片及视频进行放大缩小等功能的操作，无人触摸式进入屏保模式。
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
	import flash.utils.*;
	//CONFIG::PUBLISH
	//{
	[SWF(width="1920",height="1080",frQameRate="60",backgroundColor="0x0")]
		//}
		//[SWF(width="256",height="192",frameRate="60",backgroundColor=0x0)]
		public class ShowPic extends Sprite
		{
			private static var _main:ShowPic;

			public static function get main():ShowPic
			{
				if (_main == null)
					_main = new ShowPic;
				return _main;
			}
			public function ShowPic()
			{
				if(_main){
					if(_main.parent)_main.parent.removeChild(_main);
					_main = null;
				}
				_main = this;
				[Embed(source="asset/bg.png")] var bgpng:Class;
				Bitmap(main.addChildAt(new bgpng,0)).smoothing = true;//背景
				[Embed(source="asset/bg4.png")] var bg4png:Class;
				var bg4bmp:Bitmap = new bg4png;
				bg4bmp.smoothing = true;
				ViewSet.center(bg4bmp,1920/2-1,1080/2-31,2,2);
				main.addChild(bg4bmp);//半透明背景
				init(Gdata.curDir);
			}

			private var title:Bitmap;


			private var curDir:String;
			private var prev_btn:Sprite;
			private var close_btn:Sprite;
			private var next_btn:Sprite;
			private var imglistshow:ImgListShow;

			private var path_arr:Array;
			private function init(dir:String):void{
				visible = true;

				if(curDir == dir)
					return;
				curDir = dir;

				if(close_btn == null){
					close_btn = ViewSet.makebtn(1920-200,00,"back",200,200,clicked);
					[Embed(source="asset/close.png")] var closepng:Class;
					var backbmp:Bitmap = close_btn.addChild(new closepng) as Bitmap;
					backbmp.x = backbmp.y = 30;
				}

				if(title==null){
					[Embed(source="asset/title.png")] var titlepng:Class;
					title = new titlepng;
				}

				if(path_arr)path_arr.splice(0,path_arr.length);
				path_arr= SwfLoader.filesInDir(dir,SwfLoader.imgReg);
				logs.adds(dir,path_arr);
				/*imglist.init(path_arr,2,new Bitmap(new BitmapData(100,100)));*/

				var rate:Number = .95;
				var w:int = 1920;
				var h:int = 1080;
				if(next_btn == null){
					next_btn = new Sprite();
					[Embed(source="asset/next.png")] var nextpng:Class;
					next_btn.addChild(new nextpng);
					next_btn.x=(.5+rate/2)*w-next_btn.width/2;
					next_btn.y = h/2-next_btn.height/2;
					BtnMode.setSpriteBtn(next_btn);
				}
				if(prev_btn== null){
					prev_btn = new Sprite();
					[Embed(source="asset/prev.png")] var prevpng:Class;
					prev_btn.addChild(new prevpng);
					prev_btn.x=(.5-rate/2)*w-prev_btn.width/2;
					prev_btn.y = h/2-prev_btn.height/2;
					BtnMode.setSpriteBtn(prev_btn);
				}
				if(imglistshow==null){
					var rect:Rectangle = new Rectangle((1-rate)/2*w,(1-rate)/2*h,w*rate,h*rate);
					imglistshow = new ImgListShow(rect,null,next_btn,prev_btn);
				}
				addChild(imglistshow);
				imglistshow.init_bmpArr(path_arr);
				imglistshow.left_righ_effect = true;
				imglistshow.index=-1;
				imglistshow.show(0);
				imglistshow.addEventListener(Event.CHANGE,showDots);


				addChild(close_btn);
				addChild(title);
				showDots(null);
			}

			private function showDots(e:Event):void
			{
				if(path_arr && imglistshow){
					addChild(Dots.main);
					Dots.show(imglistshow.index,path_arr.length);
					ViewSet.center(Dots.main,1920/2-1,1080*.9,2,2);
				}
			}

			private function clicked(e:Event):void
			{
				if(e.target.name == "back")
				{
					visible = false;
					parent.removeChild(this);
					switch(Gdata.dir0)
					{
						case "天更蓝":
							G1.main.showBtns();
							break;
						case "水更清":
							G2.main.showBtns();
							break;
						case "更友好":
							G3.main.showBtns();
							break;
					}
					return;
				}
			}

			public static function show(b:Boolean=true):void {
				main.visible = b;
				if(b){
					main.init(Gdata.curDir);
					//ViewSet.removes(smain.bg_container);
					//smain.bg_container.addChild(main);
				}else{
					return;
				}
			}
		}
}

