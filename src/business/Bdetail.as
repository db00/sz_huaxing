/**
 * @file Bdetail.as
 *  
 2、点击详情后出现的参数内容需要跟该商品信息同步

 在当前服装目录下新加一个detail.png,显示详情的文件

 * @author db0@qq.com
 * @version 1.0.1
 * @date 2015-04-08
 */
package business
{
	import flash.display.Sprite;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;

	public class Bdetail extends Sprite
	{
		private static var boxbg:Sprite = new Sprite;
		public function Bdetail()
		{
			addChild(new Bitmap(new BitmapData(Bdata.stageW,Bdata.stageH,true,0x55000000)));


			ViewSet.removes(boxbg);
			var box:Bitmap = new Bitmap(new BitmapData(961,874));
			ViewSet.center(box,0,0,Bdata.stageW,Bdata.stageH);
			addChild(boxbg);
			/*
			   boxbg.addChild(box);
			   box.smoothing = true;
			 */

			var closebtn:Sprite= new Sprite;
			var closebmp:Bitmap = new Bassets.closepng;
			closebmp.smoothing = true;
			closebtn.addChild(closebmp);
			closebtn.x = box.x + box.width - closebtn.width*2;
			closebtn.y = box.y + closebtn.height*1;
			addChild(closebtn);
			BtnMode.setSpriteBtn(closebtn);

			var payBtn:Sprite= new Sprite;
			var morebmp:Bitmap = new Bassets.buybtn;
			morebmp.smoothing = true;
			payBtn.addChild(morebmp);
			payBtn.x = box.x + box.width*.8 - payBtn.width/2;
			payBtn.y = box.y + box.height*.7 - payBtn.height*1.5;
			addChild(payBtn);
			BtnMode.setSpriteBtn(payBtn);

			closebtn.addEventListener(MouseEvent.CLICK,closeThis);
			payBtn.addEventListener(MouseEvent.CLICK,toBuy);
		}

		private static var bgurl:String;
		public static function setBg(url:String):void
		{
			bgurl = url;
			if(url){
				var obj:PhotoLoader = new PhotoLoader(url,961,874);
				if(obj){//961x874
					ViewSet.removes(boxbg);
					ViewSet.center(obj,0,0,Bdata.stageW,Bdata.stageH);
					boxbg.addChild(obj);
				}
			}
		}

		private function closeThis(e:MouseEvent=null):void
		{
			visible = false;
		}
		private function toBuy(e:MouseEvent):void
		{
			closeThis();
			if(bgurl)
				Bpay.show(true,new PhotoLoader(String(bgurl).replace(/[^\/\\]+\.png/i,"buybox.png"),961,668));
		}
		public static function show(b:Boolean=true):void
		{
			main.visible = b;
			if(b){
				if(b)businessMain.main.addChild(main);
				Btitle.show_buy(false);
				EasyOut.alphaIn(main);
			}
		}
		private static var _main:Bdetail;
		public static function get main():Bdetail
		{
			if(_main == null)
				_main = new Bdetail();
			return _main;
		}
	}
}

