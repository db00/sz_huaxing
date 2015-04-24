/**
  var picmoveshow:PicMoveShow = new PicMoveShow();
  picmoveshow.addEventListener(PicMoveShow.SELECTED,show_detail);
  addChild(picmoveshow);
  private function show_detail(e:Event=null):void
  {
  logs.adds(PicMoveShow.curSelectedIndex);
  }

 * @file PicMoveShow.as
 *  鼠标滑动切换图片浏览
 * @author db0@qq.com
 * @version 1.0.1
 * @date 2015-04-03
 */
package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class PicMoveShow extends Sprite
	{
		private var numShow:uint = 7;
		private var curIndex:int=-1;
		private var pathArr:Array;
		private var posArr:Array = [[-1080,0],[-1080,0],[00,0],[00,0],[600,0],[1080,0],[1080,0]];
		private var scaleArr:Array = [.0001,.0001,.5,1.0,.5,.0001,.0001];

		public function PicMoveShow(pathArr:Array=null)
		{
			this.pathArr= pathArr;
			addEventListener(Event.ADDED_TO_STAGE,init);
			addEventListener(Event.REMOVED_FROM_STAGE,clears);
		}
		private function clears(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE,init);
			removeEventListener(Event.REMOVED_FROM_STAGE,clears);
			_visible = false;
			//ViewSet.removes(this);
		}

		public function set _visible(b:Boolean):void
		{
			visible = b;
			if(stage)
				if(b){
					stage.addEventListener(MouseEvent.MOUSE_DOWN,startCtrl);
				}else{
					if(stage){
						stage.removeEventListener(MouseEvent.MOUSE_DOWN,startCtrl);
						stage.removeEventListener(MouseEvent.MOUSE_UP,startCtrl);
					}
				}
		}

		private function init(e:Event):void
		{
			stage.addEventListener(MouseEvent.MOUSE_DOWN,startCtrl);
			setIndex();
		}

		private var mouX:int;
		private function startCtrl(e:MouseEvent):void
		{
			trace(e.type);
			if(stage)
				switch(e.type){
					case MouseEvent.MOUSE_DOWN:
						mouX = stage.mouseX;
						stage.addEventListener(MouseEvent.MOUSE_UP,startCtrl);
						stage.addEventListener(MouseEvent.MOUSE_MOVE,startCtrl);
						break;
					case MouseEvent.MOUSE_UP:
						stage.removeEventListener(MouseEvent.MOUSE_MOVE,startCtrl);
						stage.removeEventListener(MouseEvent.MOUSE_UP,startCtrl);
					case MouseEvent.MOUSE_MOVE:
						if(mouX - stage.mouseX > 100){
							stage.removeEventListener(MouseEvent.MOUSE_MOVE,startCtrl);
							stage.removeEventListener(MouseEvent.MOUSE_UP,startCtrl);
							next();
						}else if(mouX - stage.mouseX < -100){
							stage.removeEventListener(MouseEvent.MOUSE_MOVE,startCtrl);
							stage.removeEventListener(MouseEvent.MOUSE_UP,startCtrl);
							prev();
						}
						break;
				}
		}

		private function setIndex(_index:int=0):void
		{
			if(_index != curIndex){
				var i:int = 0;
				var delta:int = _index - curIndex; 
				while(i<numShow)
				{
					var obj:PhotoLoader = getChildByName("i"+i) as PhotoLoader;
					var to:int = i - delta;
					if(obj == null){
						if(i!=0 && delta >0 || i!=numShow-1 && delta <0){
							var _w:int = 1080;
							var _h:int = 1700;
							var path_index:int = _index + i - (numShow+1)/2 - delta;
							while(path_index < 0)path_index += pathArr.length;
							while(path_index >= pathArr.length)path_index -= pathArr.length;
							var fname:String = pathArr[path_index];
							var _text:String = fname.replace(/^.*\/([^\/]+)\/[^\/]+$/,"$1");
							obj = new PhotoLoader(fname,_w,_w,null,_text);
							obj.obj = (path_index);
							obj.addEventListener(MouseEvent.MOUSE_DOWN,clickobj);
							obj.name = "i" + i;
							if(delta < 0){//from left
								obj.x = posArr[0][0];
								obj.y = posArr[0][1];
								obj.scaleX = obj.scaleY = scaleArr[0];
							}else{//from right
								obj.x = posArr[numShow-1][0];
								obj.y = posArr[numShow-1][1];
								obj.scaleX = obj.scaleY = scaleArr[numShow-1];
							}
							addChild(obj);
						}
					}

					if(obj){
						trace(to);
						if(to < 0){//向着左边隐藏
							to = 0;
						}else if(to >= numShow){//向着右边隐藏
							to = numShow - 1;
						}
						if(to == (numShow-1)/2){//中间的
							addChild(obj);
						}
						TweenLite.to(obj,1.,{ x:posArr[to][0],y:posArr[to][1],scaleX:scaleArr[to],scaleY:scaleArr[to], onComplete:removes,onCompleteParams:[obj,to]});
					}
					++i;
				}
				i = 0;
				while(i< numChildren){
					obj = getChildAt(i) as PhotoLoader;
					if(obj){
						var _i:int = int(obj.name.substr(1));
						to = _i - delta;
						obj.name = "i" + to;
					}
					++i;
				}
				curIndex = _index;
			}
		}
		private function removes(obj:Sprite,to:int):void
		{
			if(obj && (to == 0 || to == numShow -1)){
				if(obj.parent)obj.parent.removeChild(obj);
				obj = null;
			}
		}
		private function next():void
		{
			trace("next");
			setIndex(curIndex+1);
		}
		private function prev():void
		{
			trace("prev");
			setIndex(curIndex-1);
		}
		private var mX:int ;
		public static var curSelectedIndex:int;
		public static const SELECTED:String = "__clicked_obj___";
		private function clickobj(e:MouseEvent):void{
			var target:PhotoLoader= e.currentTarget as PhotoLoader;
			if(target){
				switch(e.type){
					case MouseEvent.MOUSE_DOWN:
						mX = target.mouseX;
						target.addEventListener(MouseEvent.MOUSE_UP,clickobj);
						break;
					case MouseEvent.MOUSE_UP:
					case MouseEvent.MOUSE_OUT:
						target.removeEventListener(MouseEvent.MOUSE_UP,clickobj);
						if(mX - target.mouseX > 10){
						}else if(mX - target.mouseX < -10){
						}else if(target.name=="i"+(numShow-1)/2){//中间的
							curSelectedIndex = int(target.obj);
							dispatchEvent(new Event(SELECTED));
						}
						break;
				}
			}

		}
	}
}

