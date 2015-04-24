package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	public class ImgBtn extends Sprite
	{
		private var pathArr:Array;
		private var index:int;
		private var unvisible_bg:Bitmap;
		public function ImgBtn(pathArr:Array,ww:int=0,hh:int=0)
		{
			if(ww>0 && hh>0){
				unvisible_bg = addChild(new Bitmap(new BitmapData(ww,hh,true,0))) as Bitmap;
			}
			this.pathArr = pathArr;
			mouseChildren = false;
			buttonMode = true;


			if(pathArr && pathArr.length>0)
			{
				index = pathArr.length;
				loadimg();
			}
		}

		private function loadimg():void
		{
			SwfLoader.SwfLoad(pathArr[--index],addimg);
		}
		private function addimg(e:Event):void
		{
			if(e && e.type == Event.COMPLETE)
			{
				var bmp:Bitmap = e.target.content as Bitmap;
				if(bmp){
					bmp.smoothing = true;
					if(width > 0 && height > 0)
					{
						ViewSet.center(bmp,0,0,width,height);
					}
					addChild(bmp);
					if(index>0)
						loadimg();
					else
						selected = _selected;
				}

			}
		}
		private var _selected:Boolean = false;
		public function get selected():Boolean {
			return _selected;
		}
		public function set selected(b:Boolean):void{
			if(numChildren > 1){
				if(unvisible_bg == null || numChildren >2){
					getChildAt(numChildren-1).visible = !b;
					getChildAt(numChildren-2).visible = b;//added 15.04.15 15:17:52
				}
			}
			_selected = b;
		}
	}
}

