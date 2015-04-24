package work
{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.events.Event;
	public class Shipinhuiyi extends Sprite
	{
		private static var _main:Shipinhuiyi;
		public static function get main():Shipinhuiyi
		{
			if(_main == null)_main = new Shipinhuiyi;
			return _main;
		}
		public function Shipinhuiyi()
		{
			_main = this;
			/*
			   [Embed(source="s/vidbg.jpg")] var vidbgpng :Class;
			   bg = new vidbgpng;
			   bg.smoothing = true;
			   bg.width = 6480;
			   bg.height= 1920;
			   addChild(bg);

			   showFirst();
			 */
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

		   SwfLoader.SwfLoad("server/shiping.jpg",addbg);
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
				video = new Videos("server/shiping.flv");
				video.addEventListener(Event.COMPLETE,quit);
			}
			video.setSize(0,0,6480,1920);
			addChild(video);
			video.play();
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
			ScreenSave.start();
		}

	}
}

