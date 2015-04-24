package work
{
	import flash.text.TextField;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.events.Event;
	public class Quanqiushuju extends Sprite
	{
		private static var _main:Quanqiushuju;
		public static function get main():Quanqiushuju
		{
			if(_main == null)_main = new Quanqiushuju;
			return _main;
		}
		public function Quanqiushuju()
		{
			_main = this;
			showFirst();
		}
		//private var bg:Bitmap;
		//private var video:Videos;
		public function showFirst():void
		{
			/*
			   if(bg)
			   {
			   addChildAt(bg,0);
			   }else{
			   [Embed(source="s/bg.png")] var  bgpng:Class;
			   bg = new bgpng;
			   }

			   bg.width = 6480;
			   bg.height= 1920;
			   addChildAt(bg,0);
			 */

			if(snews == null){
				snews = new Snews;
				snews.y = 1920/2-1809/2;
			}
			addChild(snews);


			if(chuhuo==null){
				chuhuo = new PhotoLoader("server/出货信息.png",2032,1722);
				chuhuo.addEventListener(Event.COMPLETE,removeold);
				ViewSet.center(chuhuo,0,0,6480,1920);
			}
			addChild(chuhuo);


			if(srate == null){
				srate = new Srate;
				var xx:int = (6480/2 + 2032/2); 
				srate.x = xx + (6480 - xx)/2 - srate.width/2;
				srate.y = 1920/2-srate.height/2;
			}
			addChild(srate);
		}

		private function removeold(e:Event):void
		{
		}

		private var snews:Snews;
		private var srate:Srate;
		private var chuhuo:PhotoLoader;

		/*
		   public function showVideo():void
		   {
		   if(video == null)video = new Videos("server/全球数据.flv");
		   if(video){
		   addChild(video);
		   video.setSize(0,0,6480,1920);
		   video.play();
		   video.addEventListener(Event.COMPLETE,quit);
		   }
		   ScreenSave.stop();
		   }
		   public function quit(e:Event=null):void
		   {
		   ScreenSave.reset();
		   if(video){
		   if(video.parent)video.parent.removeChild(video);
		   try{
		   video.stop();
		   }catch(e:Error){
		   video = null;
		   }
		   }
		   video = null;
		   }
		 */

	}
}

