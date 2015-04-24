package work
{
	import flash.text.TextField;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	public class Client1 extends Sprite
	{
		private static var _main:Client1;
		public static function get main():Client1
		{
			if(_main == null)
				_main = new Client1;
			return _main;
		}
		private var bg:Bitmap;
		public function Client1()
		{
			_main = this;
			SwfLoader.SwfLoad("client/bg.jpg",bgloaded);
		}
		private function bgloaded(e:Event=null):void
		{
			if(e && e.type == Event.COMPLETE)
			{
				var bmp:Bitmap = e.target.content as Bitmap;
				if(bmp){
					bmp.smoothing = true;
					addChild(bmp);

					/*

					var i:int = 0;
					while(i<Wdata.dirArr.length){
						var btn:Sprite;
						switch(i)
					{
							case 0:
								btn = ViewSet.makebtn(1250,50,Wdata.dirArr[i],300,300,clicked);
								break;
							case 1:
								btn = ViewSet.makebtn(375,300,Wdata.dirArr[i],300,300,clicked);
								break;
							case 2:
								btn = ViewSet.makebtn(850,520,Wdata.dirArr[i],300,300,clicked);
								break;
						}
						addChild(btn);
						++i;
					}
					*/
					//var s:String = SwfLoader.readfile(Wdata.dirArr+"info.txt");
					//addChild(ViewSet.maketxt(940, 530,s, 100, 100, 28,"left",0xffffff));
					var size:int =400;
					addChild(ViewSet.makebtn(1920/2-size/2,1080/2-size/2,"enter",size,size,clicked));
				}
			}
		}
		private function clicked(e:Event):void
		{
			var _name:String = e.target.name;
			if(_name == "back")
			{
				parent.removeChild(this);
				return;
			}
			SwfLoader.loadData(Wdata.url + _name,loaded);
		}

		private function loaded(e:Event=null):void
		{
			logs.adds(e);
			if(e && e.type == Event.COMPLETE)
			{
				logs.adds(e.target.data);
			}
		}
	}
}

