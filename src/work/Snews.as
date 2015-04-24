package work
{
	import flash.utils.setTimeout;
	import flash.utils.clearTimeout;
	import flash.text.TextField;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.events.Event;
	public class Snews extends Sprite
	{
		private static var _main:Snews;
		public static function get main():Snews
		{
			if(_main == null)_main = new Snews;
			return _main;
		}
		private var _curpath:String = null;
		private var pathArr:Array;
		private function get curpath():String
		{
			return _curpath;
		}
		private function set curpath(_s:String):void
		{
			_curpath = _s;
		}
		public function Snews()
		{
			_main = this;
			x = 40;
			var d:int = 200;
			var _y:int = 640;
			var _x:int = 180;

			if(pathArr==null){
				pathArr = SwfLoader.filesInDir("server/news/","[\\d]+\\.");
				//trace(pathArr);
				for each(var path:String in pathArr)
				{
					if(path){
						var btn:PhotoLoader = new PhotoLoader(path,813,176);
						addChild(btn);
						btn.y = _y;
						btn.x = _x;
						_y += d;
					}
				}
			}
			initBg();
		}

		private var curIndex:int= 0;
		private var curbg:PhotoLoader = null;
		private var previouse:PhotoLoader = null;
		private var mytext:MyText= null;
		private var timeoutId:uint;
		private function initBg(_index:int=0):void
		{
			clearTimeout(timeoutId);
			curIndex = _index;
			curpath = pathArr[curIndex];

			if(mytext){
				if(mytext.parent)mytext.parent.removeChild(mytext);
				mytext = null;
			}

			if(curpath){


				try{
					p = curpath.replace(/^(.*[0-9]+)\..*$/,"$1news.txt");
					trace("textpaht:",p);
					var _s:String = SwfLoader.readfile(p);
					if(_s){
						mytext = new MyText(0,0,820,700,_s,25,0xffffff,true);
						mytext.x = 1062;
						mytext.y = 870;
						addChild(mytext);
					}
				}catch(e:Error){}

				previouse = curbg;

				var p:String = curpath.replace(/([0-9]+)/,"$1_");
				curbg = new PhotoLoader(p,2072,1809);
				curbg.addEventListener(Event.COMPLETE,removeold);
				addChildAt(curbg,0);

			}

			++curIndex;
			if(curIndex >= pathArr.length)curIndex = 0;
			timeoutId = setTimeout(initBg,10000,curIndex);
		}
		private function removeold(e:Event):void
		{
			if(previouse){
				ViewSet.removes(previouse);
				previouse.parent.removeChild(previouse);
				previouse = null;
			}
		}
	}
}

