package business
{
	import flash.display.DisplayObject;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	public class Bpay extends Sprite
	{
		private var box:Sprite = new Sprite;
		public function Bpay()
		{
			addChild(new Bitmap(new BitmapData(Bdata.stageW,Bdata.stageH,true,0x55000000)));

			box.addChild(new Bitmap(new BitmapData(961,668,true,0x0)));
			ViewSet.center(box,0,0,Bdata.stageW,Bdata.stageH);
			addChild(box);

			var closebtn:Sprite= new Sprite;
			var closebmp:Bitmap = new Bassets.closepng;
			closebmp.smoothing = true;
			closebtn.addChild(closebmp);
			closebtn.x = box.x + box.width - closebtn.width*2;
			closebtn.y = box.y + closebtn.height*1;
			addChild(closebtn);
			BtnMode.setSpriteBtn(closebtn);

			var payBtn:Sprite= new Sprite;
			var morebmp:Bitmap = new Bassets.paylaterpng;
			morebmp.smoothing = true;
			payBtn.addChild(morebmp);
			payBtn.mouseChildren = false;
			payBtn.buttonMode = true;
			payBtn.x = box.x + box.width*.7 - payBtn.width/2;
			payBtn.y = box.y + box.height*.4 - payBtn.height*1.5;
			addChild(payBtn);
			BtnMode.setSpriteBtn(payBtn);

			var payonlineBtn:Sprite= new Sprite;
			var payonlinebmp:Bitmap = new Bassets.payonlinebtnpng;
			payonlinebmp.smoothing = true;
			payonlineBtn.addChild(payonlinebmp);
			payonlineBtn.x = box.x + box.width*.7 - payonlineBtn.width/2;
			payonlineBtn.y = box.y + box.height*.55 - payonlineBtn.height*1.5;
			addChild(payonlineBtn);
			BtnMode.setSpriteBtn(payonlineBtn);

			closebtn.addEventListener(MouseEvent.CLICK,closeThis);
			payBtn.addEventListener(MouseEvent.CLICK,toBuy);
			payonlineBtn.addEventListener(MouseEvent.CLICK,toBuy);
		}
		public function setbg(bmp:DisplayObject):void
		{
			ViewSet.removes(box);
			box.addChild(bmp);
			ViewSet.center(box,0,0,Bdata.stageW,Bdata.stageH);
		}
		private function closeThis(e:MouseEvent=null):void
		{
			visible = false;
		}
		private function toBuy(e:MouseEvent):void
		{
			closeThis();
			BpayEnd.show();
		}
		public static function show(b:Boolean=true,bmp:DisplayObject=null):void
		{
			main.visible = b;
			if(b){
				businessMain.main.addChild(main);
				Btitle.show_buy(true);
				if(bmp)main.setbg(bmp);
				EasyOut.alphaIn(main);
			}
		}
		private static var _main:Bpay;
		public static function get main():Bpay
		{
			if(_main == null)
				_main = new Bpay();
			return _main;
		}
	}
}

