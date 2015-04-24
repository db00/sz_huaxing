package business
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	public class Btitle extends Sprite
	{
		private static var title1:Bitmap;
		private static var title2:Bitmap;
		public function Btitle()
		{
			addEventListener(MouseEvent.CLICK,businessMain.showB1);//点击显示首页
			BtnMode.setSpriteBtn(this);
		}
		public static function show_buy(b:Boolean):void
		{
			if(title1==null)
			{
				title1 = new Bassets.title1png;
				title1.smoothing = true;
				title1.y = 50;
			}
			if(title2==null)
			{
				title2 = new Bassets.titlepaypng;
				title2.smoothing = true;
				title2.y = 50;
			}
			if(b)
				main.addChild(title2);
			else
				main.addChild(title1);

			businessMain.main.addChild(main);
		}
		public static function show(b:Boolean=true):void
		{
			main.visible = b;
			if(b){
				businessMain.main.addChild(main);
				EasyOut.alphaIn(main);
			}
		}
		private static var _main:Btitle;
		public static function get main():Btitle
		{
			if(_main == null)
				_main = new Btitle();
			return _main;
		}
	}
}
