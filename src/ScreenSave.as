/**
 * @file ScreenSave.as
 *  

 addChild(new ScreenSave("video-path.flv",startScreenSave,stopScreenSave));

 * @author db0@qq.com
 * @version 1.0.1
 * @date 2015-04-10
 */
package
{
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.utils.setTimeout;
	import flash.utils.clearTimeout;

	public class ScreenSave extends Sprite
	{
		private static var timeoutId:uint;
		private static var timeout:uint=600000;
		private static var isShow:Boolean = false;
		private static var showFunc:Function= null;
		private static var stopFunc:Function= null;
		private static var videoPath:String = null;

		/**
		 * videoPath:	the flv video path
		 * showFunc:	call user's own function ,when start to show ScreenSave;
		 * stopFunc:	call user's own function ,when stop displaying ScreenSave;
		 */
		public function ScreenSave(_videoPath:String=null,_showFunc:Function=null,_stopFunc:Function=null,_timeout:uint=600000)
		{
			_main = this;
			timeout = _timeout;
			videoPath = _videoPath;
			showFunc = _showFunc;
			stopFunc = _stopFunc;

			if(stage){
				init();
			}else{
				addEventListener(Event.ADDED_TO_STAGE,init);
			}
			//addEventListener(Event.REMOVED_FROM_STAGE,clears);
		}
		private function init(e:Event=null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE,init);
			stage.addEventListener(MouseEvent.MOUSE_UP,reset);
			stage.addEventListener(MouseEvent.MOUSE_DOWN,reset);
			stage.addEventListener(KeyboardEvent.KEY_DOWN,reset);
			stage.addEventListener(KeyboardEvent.KEY_UP,reset);
			reset();
		}

		private var screeSaveVideo:Videos=null;
		public function startScreenSave(e:Event=null):void
		{
			if(videoPath && main.stage){
				logs.adds("----------------------------------------------------------------------------------");
				if(screeSaveVideo==null){
					screeSaveVideo = new Videos(videoPath);
				}
				if(screeSaveVideo){
					screeSaveVideo.addEventListener(Event.COMPLETE,startScreenSave);
					screeSaveVideo.play();
					main.stage.addChild(screeSaveVideo);
				}
			}
		}
		public function stopScreenSave(e:Event=null):void
		{
			if(screeSaveVideo){
				if(screeSaveVideo.parent)screeSaveVideo.parent.removeChild(screeSaveVideo);
				try{
					screeSaveVideo.stop();
				}catch(e:Error){
					screeSaveVideo = null;
				}
			}
			screeSaveVideo = null;
		}
		/* -----------------------------------------------*/
		/**
		 *  reset the timer
		 *
		 * @param e:Event
		 *
		 * @return  
		 */
		public static function reset(e:Event=null):void{
			stop();
			timeoutId = setTimeout(start,timeout);
		}
		/* -----------------------------------------------*/
		/**
		 *  stop ScreenSave
		 *
		 * @return  
		 */
		public static function stop():void
		{
			isShow = false;
			clearTimeout(timeoutId);
			main.visible = false;

			if(videoPath)
				main.stopScreenSave();
			if(stopFunc!=null)
				stopFunc();
		}
		/* -----------------------------------------------*/
		/**
		 *  start play ScreenSave
		 *
		 * @return  
		 */
		public static function start():void
		{
			main.visible = true;
			isShow = true;
			logs.adds(videoPath);

			if(videoPath)
				main.startScreenSave();
			if(showFunc!=null)
				showFunc();
		}

		private function clears(e:Event=null):void{
			removeEventListener(Event.ADDED_TO_STAGE,init);
			removeEventListener(Event.REMOVED_FROM_STAGE,clears);
			if(stage){
				stage.addEventListener(MouseEvent.MOUSE_UP,reset);
				stage.addEventListener(MouseEvent.MOUSE_DOWN,reset);
				stage.addEventListener(KeyboardEvent.KEY_DOWN,reset);
				stage.addEventListener(KeyboardEvent.KEY_UP,reset);
			}
		}
		private static var _main:ScreenSave;
		private static function get main():ScreenSave
		{
			if(_main == null)
				_main = new ScreenSave(videoPath,showFunc,stopFunc,timeout);
			return _main;
		}
	}
}

