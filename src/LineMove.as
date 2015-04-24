/**
 * @file LineMove.as
 *  move the line to a position , add set the start and end point of the line



 var linemove:LineMove = new LineMove();
 addChild(linemove);
 linemove.setpos(10,10,28,80);

 * @author db0@qq.com
 * @version 1.0.1
 * @date 2015-04-15
 */
package
{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	public class LineMove extends Sprite
	{
		private var _x1:int;
		private var _y1:int;
		private var _x2:int;
		private var _y2:int;
		public function LineMove(bmp:Bitmap=null)
		{
			if(bmp as Bitmap == null)
			{
				bmp= new Bitmap(new BitmapData(100,1,false,0xffffffff));
			}
			addChild(bmp);
			bmp.smoothing = true;
			setpos(0,0,100,100);
		}

		public function get x1():int {
			return _x1;
		}
		public function get x2():int {
			return _x2;
		}
		public function get y1():int {
			return _y1;
		}
		public function get y2():int {
			return _y2;
		}
		public function set x1(i:int):void{
			_x1 = i;
			setLine();
		}
		public function set x2(i:int):void{
			_x2 = i;
			setLine();
		}
		public function set y1(i:int):void{
			_y1 = i;
			setLine();
		}
		public function set y2(i:int):void{
			_y2 = i;
			setLine();
		}

		private function setLine():void
		{
			var old_visible:Boolean = visible;
			visible = false;
			alpha = 0;
			x = x1;
			y = y1;
			var _x:int=x2-x1;
			var _y:int=y2-y1;
			var dist:int = Math.sqrt(_x*_x + _y*_y);
			rotation = 0;
			width = dist;
			rotation = Math.atan2(_y,_x)*180/Math.PI;
			visible = old_visible;
			alpha = 1;
		}

		public function setpos(_x1:int,_y1:int,_x2:int,_y2:int):void
		{
			this._x1 = _x1;
			this._x2 = _x2;
			this._y1 = _y1;
			this._y2 = _y2;
			setLine();
		}
	}
}

