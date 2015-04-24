package work
{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.events.Event;
	public class Shengchanjiankong extends Sprite
	{
		private static var _main:Shengchanjiankong;
		public static function get main():Shengchanjiankong
		{
			if(_main == null)_main = new Shengchanjiankong;
			return _main;
		}
		public function Shengchanjiankong()
		{
			_main = this;
			//[Embed(source="s/bg.png")] var  bgpng:Class; bg = new bgpng;
			//bg.width = 6480; bg.height= 1920; addChild(bg);

			//showFirst();
		}
		//private var bg:Bitmap;
		private var video:Videos;
		/*
		public function showFirst():void
		{
			if(bg)
			{
				addChild(bg);
				return;
			}

			SwfLoader.SwfLoad("server/生产监控.jpg",addbg);
		}

		private function addbg(e:Event):void
		{
			if(e && e.type == Event.COMPLETE)
			{
				bg = e.target.content as Bitmap;
				if(bg){
					bg.width = 6480;
					bg.height= 1920;
					addChild(bg);
				}
			}
		}
		*/

		public function showVideo():void
		{
			quit();
			ScreenSave.stop();
			if(video == null){
				video = new Videos("server/shengchan.flv");
				video.addEventListener(Event.COMPLETE,quit);
			}
			video.setSize(0,0,6480,1920);
			addChild(video);
		}

		public function quit(e:Event=null):void
		{
			if(video){
				if(video.parent)video.parent.removeChild(video);
				try{
					video.stop();
				}catch(e:Error){
					video = null;
				}
			}
			video = null;
			//ScreenSave.reset();
			ScreenSave.start();
		}
	}
}

