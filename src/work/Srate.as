package work
{
	import flash.text.TextField;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.events.Event;
	public class Srate extends Sprite
	{
		private static var _main:Srate;
		public static function get main():Srate
		{
			if(_main == null)_main = new Srate;
			return _main;
		}
		public function Srate()
		{
			_main = this;
			[Embed(source="s/rate/bg.png")] var bgpng:Class;
			var bg:Bitmap = new bgpng;
			bg.smoothing = true;
			addChild(bg);

			var d:int = 210;
			var _y:int = 150;
			var _x:int = 1100;
			[Embed(source="s/rate/usd.png")] var uspng:Class;
			var us:Bitmap = new uspng;
			us.smoothing = true;
			addChild(us);
			_y += d;
			us.y = _y;
			us.x = _x;

			[Embed(source="s/rate/gbp.png")] var ukpng:Class;
			var uk:Bitmap = new ukpng;
			uk.smoothing = true;
			addChild(uk);
			_y += d;
			uk.y = _y;
			uk.x = _x;

			[Embed(source="s/rate/jpy.png")] var jppng:Class;
			var jp:Bitmap = new jppng;
			jp.smoothing = true;
			addChild(jp);
			_y += d;
			jp.y = _y;
			jp.x = _x;

			[Embed(source="s/rate/krw.png")] var krpng:Class;
			var kr:Bitmap = new krpng;
			kr.smoothing = true;
			addChild(kr);
			_y += d;
			kr.y = _y;
			kr.x = _x;

			[Embed(source="s/rate/ntd.png")] var twpng:Class;
			var tw:Bitmap = new twpng;
			tw.smoothing = true;
			addChild(tw);
			_y += d;
			tw.y = _y;
			tw.x = _x;

			[Embed(source="s/rate/hkd.png")] var hkpng:Class;
			var hk:Bitmap = new hkpng;
			hk.smoothing = true;
			addChild(hk);
			_y += d;
			hk.y = _y;
			hk.x = _x;


			d = 3;
			var _str:String = SwfLoader.readfile("server/exchange_rate.txt");
			var arr:Array = _str.split(/[\r\n]/);
			for each(var s:String in arr)
			{
				var exchange_rate_txt:TextField;
				exchange_rate_txt = ViewSet.make_txt(0, 0, s.replace(/,/,"\r\n"),800,600, 0xffffff,50,true) as TextField;
				if(s.match("美")) {
					exchange_rate_txt.y = us.y + d;
				}else if(s.match("日")){
					exchange_rate_txt.y = jp.y + d;
				}else if(s.match("英")){
					exchange_rate_txt.y = uk.y + d;
				}else if(s.match("韩")){
					exchange_rate_txt.y = kr.y + d;
				}else if(s.match("台")){
					exchange_rate_txt.y = tw.y + d;
				}else if(s.match("港")){
					exchange_rate_txt.y = hk.y + d;
				}
			}
		}
	}
}

