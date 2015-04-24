package  {
	import flash.display.Shape;
	import flash.display.Sprite;
	public class Dots extends Sprite
	{
		private static var _main:Dots;
		public static function get main():Dots
		{
			if(_main==null)_main = new Dots;
			return _main;
		}
		public function Dots():void
		{
			_main = this;
		}
		public static function show(cur:int,total:int):void
		{
			main.visible = true;
			main.show(cur,total);
		}
		public static function hide():void
		{
			main.visible = false;
		}

		private function get c_rad():int
		{
			return (10);
		}
		private function get c_dot():Shape
		{
			var shape:Shape = new Shape();
			with(shape){
				graphics.lineStyle(1,0x627890);
				graphics.drawRect(0,0,c_rad,c_rad);
			}
			return shape;
		}
		private function get d_dot():Shape
		{
			var shape:Shape = new Shape();
			with(shape){
				graphics.beginFill(0x90e2fe);
				graphics.drawRect(0,0, c_rad,c_rad);
				graphics.endFill();
			}
			return shape;
		}

		private function show(cur:int=0,total:int=1):void
		{
			logs.adds("show Dots:",cur,total,".............................................");
			ViewSet.removes(main);
			var gap:int = (20);
			var i:int = 0;
			while(i<total)
			{
				var dot:Shape = c_dot;
				dot.x = i * gap;
				main.addChild(dot);
				++i;
			}
			var dot2:Shape = d_dot;
			dot2.x = cur * gap;
			main.addChild(dot2);
			//if(main.stage)main.stage.addChild(main);
		}
		
	}
}

