package business
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	public class BpayEnd extends Sprite
	{
		public function BpayEnd()
		{
			addChild(new Bitmap(new BitmapData(Bdata.stageW,Bdata.stageH,true,0x55000000)));

			var box:Bitmap = new Bassets.paysuccessboxpng;
			box.smoothing = true;
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

			var moreBtn:Sprite= new Sprite;
			var morebmp:Bitmap = new Bassets.morebtnpng;
			morebmp.smoothing = true;
			moreBtn.addChild(morebmp);
			moreBtn.x = box.x + box.width/2 - moreBtn.width/2;
			moreBtn.y = box.y + box.height - moreBtn.height*1.5;
			addChild(moreBtn);
			BtnMode.setSpriteBtn(moreBtn);

			closebtn.addEventListener(MouseEvent.CLICK,closeThis);
			moreBtn.addEventListener(MouseEvent.CLICK,toFirst);
		}
		private function closeThis(e:MouseEvent):void
		{
			Btitle.show_buy(false);
			visible = false;
		}
		private function toFirst(e:MouseEvent):void
		{
			visible = false;
			businessMain.showB1();
			Btitle.show_buy(false);
		}
		public static function show(b:Boolean=true):void
		{
			main.visible = b;
			if(b){
				businessMain.main.addChild(main);
				EasyOut.alphaIn(main);
			}
		}
		private static var _main:BpayEnd;
		public static function get main():BpayEnd
		{
			if(_main == null)
				_main = new BpayEnd();
			return _main;
		}
	}
}
