/**
 * @file G0.as
 *  first page
 * @author db0@qq.com
 * @version 1.0.1
 * @date 2015-04-07
 */
package green
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class G0 extends Sprite
	{
		private static var _main:G0 = null;
		
		public static function get main():G0
		{
			if (_main == null)
				_main = new G0();
			return _main;
		}
		private var bg:Bitmap;
		
		public function G0()
		{
			_main = this;
			[Embed(source="asset/bg.png")]
			var bgpng:Class;
			Bitmap(addChild(new bgpng)).smoothing = true;
			
			[Embed(source="asset/title.png")]
			var titlepng:Class;
			Bitmap(addChild(new titlepng)).smoothing = true;
			
			[Embed(source="asset/btn1.swf")]
			var btn01swf:Class;
			[Embed(source="asset/btn2.swf")]
			var btn02swf:Class;
			[Embed(source="asset/btn3.swf")]
			var btn03swf:Class;
			
			var i:int = 0;
			while (i < Gdata.btns10.length)
			{
				var btn:Sprite = addChild(ViewSet.makebtn(600 * i + 100, 300, Gdata.btns0[i], 500, 500, clicked)) as Sprite;
				try
				{
					var s:String = SwfLoader.readfile(Gdata.Dir0 + "info.txt").split(/[\r\n]/)[i];
					addChild(ViewSet.maketxt(590 * i + 430, 590, s, 200, 100, 26, "left", 0xffffff));
				}
				catch (e:Error)
				{
				}
				
				switch (i)
				{
					case 0: 
						btn.addChild(new btn01swf);
						break;
					case 1: 
						btn.addChild(new btn02swf);
						break;
					case 2: 
						btn.addChild(new btn03swf);
						break;
				}
				++i;
			}
		}
		
		private function clicked(e:Event):void
		{
			Gdata.dir0 = e.target.name;
			logs.adds(Gdata.dir0);
			
			if (Gdata.dir0 == Gdata.btns0[0])
			{
				parent.addChild(G1.main);
				G1.main.showBtns();
			}
			else if (Gdata.dir0 == Gdata.btns0[1])
			{
				parent.addChild(G2.main);
				G2.main.showBtns();
			}
			else if (Gdata.dir0 == Gdata.btns0[2])
			{
				parent.addChild(G3.main);
				G3.main.showBtns();
			}
		}
	}
}

