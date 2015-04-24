package thing 
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.Event;
	public class TroundShow extends Sprite
	{
		private var showpic:ShowPic;
		public function TroundShow(path:String="大事记/2009/1/")
		{
			showpic = new ShowPic(path);
			addChild(showpic);
		}
		public function click(s:String):void
		{
			if(showpic && showpic.imglistshow){
				if(s=="prev"){
					showpic.imglistshow.prev();
				}else if(s=="next"){
					showpic.imglistshow.next();
				}
			}
		}
	}
}


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
import thing.*;
class ShowPic extends Sprite
{
	private static var _main:ShowPic;

	public static function get main():ShowPic
	{
		if (_main == null)
			_main = new ShowPic();
		return _main;
	}
	public function ShowPic(dir:String=null)
	{
		if(_main){
			if(_main.parent)_main.parent.removeChild(_main);
			_main = null;
		}
		_main = this;
		//main.addChildAt(new Bitmap(new BitmapData(1920,1080,false,0)),0);//背景
		Bitmap(main.addChildAt(new Tasset.roundbg_png,0)).smoothing = true;
		if(dir)init(dir);
	}


	public var imglistshow:ImgListShow;
	private var path_arr:Array;
	private var next_btn:Sprite = new Sprite();
	private var prev_btn:Sprite = new Sprite();
	private function init(dir:String):void{
		visible = true;

		if(path_arr==null){
			path_arr= SwfLoader.filesInDir(dir,SwfLoader.imgReg);
			//path_arr = SwfLoader.sortBytxtFile(path_arr,"file.xml");
		}
		logs.adds("dir:",dir);
		logs.adds("path_arr:",path_arr);

		var rate:Number = .7;
		var w:int = 800;
		var h:int = 800;

		if(imglistshow==null){
			var close_btn:Sprite = null;
			var nextbmp:Bitmap = new Tasset.next_png;
			var prevbmp:Bitmap = new Tasset.prev_png;
			nextbmp.smoothing = true;
			prevbmp.smoothing = true;
			next_btn.addChild(nextbmp);
			prev_btn.addChild(prevbmp);
			BtnMode.setSpriteBtn(prev_btn);
			BtnMode.setSpriteBtn(next_btn);
			prev_btn.y = next_btn.y = 400;
			prev_btn.x = -100;
			next_btn.x = 800;
			var rect:Rectangle = new Rectangle((1-rate)/2*w,0,w*rate,h);
			imglistshow = new ImgListShow(rect,close_btn,next_btn,prev_btn,true);
		}
		addChild(imglistshow);
		imglistshow.addEventListener(Event.CHANGE,changeDots);
		imglistshow.init_bmpArr(path_arr);//init the data
		imglistshow.show(0);//show the first pic


		var backbtn:Sprite = addChild(ViewSet.makebtn(620,645,"back",200,200,clicked)) as Sprite;
		var closebmp:Bitmap = new Tasset.close_png;
		closebmp.smoothing = true;
		closebmp.x = 30;
		backbtn.addChild(closebmp);

		changeDots(null);
	}
	private function changeDots(e:Event):void
	{
		if(path_arr && path_arr.length>0){
			addChild(Dots.main);
			if(e)Dots.show(imglistshow.index,path_arr.length);
			else Dots.show(0,path_arr.length);
			ViewSet.center(Dots.main,400,700,2,2);
			Dots.main.visible = true;
		}else{
			Dots.main.visible = false;
		}
	}
	private function clicked(e:Event):void
	{
		if(e.target.name == "back")
		{
			visible = false;
			parent.removeChild(this);
			return;
		}
	}

	public static function show(b:Boolean=true):void {
		main.visible = b;
		if(b){
			//ViewSet.removes(smain.bg_container);
			//smain.bg_container.addChild(main);
		}else{
			return;
		}
	}
}

