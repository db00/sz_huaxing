/**
usage:

var rate:Number = .95;
var w:int = 1920;
var h:int = 1080;

if(next_btn == null){
next_btn = new Sprite();
[Embed(source="asset/next.png")] var nextpng:Class;
next_btn.addChild(new nextpng);
next_btn.x=(.5+rate/2)*w-next_btn.width/2;
next_btn.y = h/2-next_btn.height/2;
}

if(prev_btn== null){
prev_btn = new Sprite();
[Embed(source="asset/prev.png")] var prevpng:Class;
prev_btn.addChild(new prevpng);
prev_btn.x=(.5-rate/2)*w-prev_btn.width/2;
prev_btn.y = h/2-prev_btn.height/2;
}

if(close_btn==null)
{
close_btn = new Sprite();
[Embed(source="asset/close.png")] var closepng:Class;
close_btn.addChild(new closepng);
close_btn.x=(.5+rate/2)*w-close_btn.width/2;
close_btn.y=(.5+rate/2)*h-close_btn.height/2;
}

if(imglistshow==null){
var rect:Rectangle = new Rectangle((1-rate)/2*w,(1-rate)/2*h,w*rate,h*rate);
imglistshow = new ImgListShow(rect,close_btn,next_btn,prev_btn);
}
addChild(imglistshow);
imglistshow.init_bmpArr(path_arr);//init the data
imglistshow.show(0);//show the first pic

 */
package
{
	import flash.events.Event;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.display.DisplayObject;

	public class ImgListShow extends Sprite
	{
		public var canDrag:Boolean = false; //support touch 2 points
		public var loopView:Boolean = false; //loop show the imgs;
		public var index:int; //current show index;
		public var left_righ_effect:Boolean = false; //show the pics with left to right or right to left effect

		private var bmpArr:Array;
		private var cur_bmp:Bitmap;
		private var rect:Rectangle;
		private var close_btn:Sprite;
		private var prev_btn:Sprite;
		private var next_btn:Sprite;
		private var hastitleAndName:Boolean = false;
		private var isToLeft:Boolean;
		private var imgContainer:Sprite=new Sprite();

		public function ImgListShow(_rect:Rectangle, close_btn:Sprite = null, next_btn:Sprite = null, prev_btn:Sprite = null, hastitleAndName:Boolean = false)
		{
			addChild(imgContainer);
			this.hastitleAndName = hastitleAndName;
			rect = _rect;
			if (close_btn)
			{
				this.close_btn = close_btn;
				close_btn.addEventListener(MouseEvent.CLICK, close);
				addChild(close_btn);
			}
			if (prev_btn)
			{
				this.prev_btn = prev_btn;
				prev_btn.addEventListener(MouseEvent.CLICK, prev);
				addChild(prev_btn);
			}
			if (next_btn)
			{
				this.next_btn = next_btn;
				next_btn.addEventListener(MouseEvent.CLICK, next);
				addChild(next_btn);
			}
			if (stage)
				addbg();
			else
				addEventListener(Event.ADDED_TO_STAGE, addbg);
			close();
		}
		private var mousex:int = 0;

		private function MouseEvents(e:Event):void
		{
			if (stage == null)
				return;
			var _changeW:int = stage.stageWidth / 2;
			if (_changeW > rect.width / 2)
			{
				_changeW = rect.width / 2;
			}
			switch (e.type)
			{
				case MouseEvent.MOUSE_DOWN: 
					mousex = stage.mouseX;
					stage.addEventListener(MouseEvent.MOUSE_MOVE, MouseEvents);
					stage.addEventListener(MouseEvent.MOUSE_UP, MouseEvents);
					break;
				case MouseEvent.MOUSE_MOVE: 
					if (mousex - stage.mouseX > _changeW)
					{
						stage.removeEventListener(MouseEvent.MOUSE_MOVE, MouseEvents);
						stage.removeEventListener(MouseEvent.MOUSE_UP, MouseEvents);
						next();
					}
					else if (mousex - stage.mouseX < -_changeW)
					{
						stage.removeEventListener(MouseEvent.MOUSE_MOVE, MouseEvents);
						stage.removeEventListener(MouseEvent.MOUSE_UP, MouseEvents);
						prev();
					}
					break;
				case MouseEvent.MOUSE_UP: 
					stage.removeEventListener(MouseEvent.MOUSE_MOVE, MouseEvents);
					stage.removeEventListener(MouseEvent.MOUSE_UP, MouseEvents);
					break;
			}
		}

		public function init_bmpArr(_bmpArr:Array):void
		{
			if (bmpArr)
				bmpArr.splice(0, bmpArr.length);
			for each (var o:Object in _bmpArr)
			{
				if (bmpArr == null)
					bmpArr = new Array;
				bmpArr.push(o);
			}
			remove_prev();
			removeOlds();
		}

		public function close(e:Event = null):void
		{
			visible = false;
			if (cur_bmp)
			{
				if (cur_bmp.parent)
					cur_bmp.parent.removeChild(cur_bmp);
				cur_bmp = null;
			}
		}

		private var prev_bmp:Bitmap;

		public function show(_index:int = 0):void
		{
			if(_index < 0 || _index >= bmpArr.length)return;

			trace(_index, index);
			/*if(_index == index)return;*/
			if(index < 0)
			{
				close();
				removeOlds();
			}
			visible = true;


			isToLeft = Boolean(_index < index);
			index = _index;
			if (bmpArr == null || index < 0 || index >= bmpArr.length)
				return;

			if (cur_bmp && cur_bmp.parent)
			{
				prev_bmp = cur_bmp;
			}
			removeOlds();

			var bmp:Bitmap = bmpArr[index] as Bitmap;
			var url:String = bmpArr[index] as String;
			if (bmp)
			{
				cur_bmp = new Bitmap(bmp.bitmapData);
				show_bmp();
			}
			else if (url)
			{
				SwfLoader.SwfLoad(url, show_bmp);
			}
			else
			{
				trace("------error-----");
			}
			//if (index == 0) remove_prev();
			/**/

			//remove_prev();
		}

		private var touchtowpoint:TouchTowPoint;

		public static function maketxt(xx:int, yy:int, str:String, ww:int, hh:int, size:int, autoSize:String = "left", color:uint = 0xffffff):TextField
		{
			var txt:TextField = new TextField();
			/*txt.border = true;*/ /*txt.type = TextFieldType.INPUT;*/
			txt.x = xx;
			txt.y = yy;
			txt.width = ww;
			txt.height = hh;
			txt.multiline = true;
			/*txt.selectable = false;*/
			var txtformat:TextFormat = new TextFormat("Microsoft YaHei", size, color);
			txt.defaultTextFormat = txtformat;
			txt.autoSize = autoSize;
			//txt.text = Fanti.jian2fan(str);
			//txt.wordWrap = true;
			//txt.text = String(str);
			txt.text = String(str);
			return txt;
		}

		private function removeOlds():void
		{
			var _i:int = imgContainer.numChildren;
			while(_i>0){
				--_i;
				var _obj:Bitmap = imgContainer.getChildAt(_i) as Bitmap;
				if(_obj){
					if(_obj!=cur_bmp){
						imgContainer.removeChild(_obj);
						_obj.bitmapData.dispose();
						_obj=null;
					}
				}else{
					imgContainer.removeChildAt(_i);
				}
			}
		}

		private function show_bmp(e:Event = null):void
		{
			if (e && Event.COMPLETE == e.type)
			{
				cur_bmp = e.target.content as Bitmap;
				if (hastitleAndName)
				{
					var mc:Sprite = new Sprite();
					mc.addChild(cur_bmp);
					var path:String = bmpArr[index] as String;
					if (path)
					{
						var titleStr:String = path.replace(/^.*[\\\/]+([^\\\/]+)[\\\/]+[^\\\/]+[\\\/]*$/, "$1");
						titleStr = titleStr.replace(/^(.{16})+/g, "$1\n");
						var titleArr:Array = titleStr.split("\n");
						var title:TextField;
						var i:int = 0;
						while (i < titleArr.length)
						{
							title = maketxt(0, i * 43, titleArr[i], cur_bmp.width, 43, 30, "center", 0x90e2fe);
							title.x = cur_bmp.width / 2 - title.width / 2;
							mc.addChild(title);
							++i;
						}

						var nameStr:String = path.replace(/^.*[\\\/]+[^\\\/]+[\\\/]+([^\\\/]+)[\\\/]*(\.png|\.jpg|\.jpeg)$/i, "$1");
						var nameTxt:TextField = ViewSet.maketxt(0, 0, nameStr, cur_bmp.width, 43, 20, "left", 0x90e2fe);
						nameTxt.x = cur_bmp.width / 2 - nameTxt.width / 2;
						mc.addChild(nameTxt);
						cur_bmp.y = title.y + title.height * 1.5;
						nameTxt.y = cur_bmp.y + cur_bmp.height + title.height * .5;
					}
					var bmpd:BitmapData = new BitmapData(mc.width, mc.height, true, 0x0);
					bmpd.draw(mc);
					ViewSet.removes(mc);
					mc = null;

					cur_bmp.bitmapData.dispose();
					cur_bmp = null;
					cur_bmp = new Bitmap(bmpd);
				}
				cur_bmp.smoothing = true;
			}
			if (cur_bmp)
			{

				ViewSet.center_rect(cur_bmp, rect);

				if (touchtowpoint)
				{
					touchtowpoint.x = touchtowpoint.x = 0;
					touchtowpoint.scaleX = touchtowpoint.scaleY = 1;
					touchtowpoint.rotation = 0;
				}
				//TweenLite.from(touchtowpoint,1,{scaleX:0,scaleY:0,alpha:0,x:touchtowpoint.width/3,y:touchtowpoint.height/3});
				imgContainer.addChild(cur_bmp);
				if (left_righ_effect)
				{
					if (isToLeft)
					{
						if (prev_bmp)
							TweenLite.to(prev_bmp, 1, {x: -prev_bmp.width, onComplete: remove_prev});
						TweenLite.from(cur_bmp, 1, {x: cur_bmp.width, onComplete: addToDrag});
					}
					else
					{
						if (prev_bmp)
							TweenLite.to(prev_bmp, 1, {x: prev_bmp.width, onComplete: remove_prev});
						TweenLite.from(cur_bmp, 1, {x: -cur_bmp.width, onComplete: addToDrag});
					}

				}
				else
				{
					if (prev_bmp)
						remove_prev();
				}

			}
			else
			{
				trace("no bmp");
			}
			trace("dispatch hide");
			dispatchEvent(new Event("hidelist"));
			dispatchEvent(new Event(Event.CHANGE));
		}

		private function addToDrag():void
		{
			removeOlds();
			if (canDrag)
			{
				if (touchtowpoint)
				{
					if (touchtowpoint.parent)
						touchtowpoint.parent.removeChild(touchtowpoint);
					touchtowpoint = null;
				}
				touchtowpoint = new TouchTowPoint();
				touchtowpoint.x = touchtowpoint.x = 0;
				touchtowpoint.scaleX = touchtowpoint.scaleY = 1;
				touchtowpoint.rotation = 0;
				imgContainer.addChild(touchtowpoint);
				touchtowpoint.addChild(cur_bmp);
			}
		}

		private function showlist(e:Event):void
		{
			trace("dispatch show");
			dispatchEvent(new Event("showlist"));
		}

		private function hidelist(e:Event):void
		{
			trace("dispatch hide");
			dispatchEvent(new Event("hidelist"));
		}

		private function remove_prev():void
		{
			if (prev_bmp && prev_bmp.parent)
			{
				prev_bmp.parent.removeChild(prev_bmp);
				prev_bmp.bitmapData.dispose();
				prev_bmp = null;
			}
		}

		public function prev(e:Event = null):void
		{
			var _index:int = index;
			if (bmpArr && bmpArr.length > 0)
			{
				_index--;
				if (_index < 0)
				{
					if(loopView)
						_index = bmpArr.length - 1;
					else
						return;
				}
				show(_index);
			}
		}

		public function next(e:Event = null):void
		{
			var _index:int = index;
			if (bmpArr && bmpArr.length > 0)
			{
				_index++;
				if (_index >= bmpArr.length)
				{
					if(loopView)
						_index = 0;
					else
						return;
				}
				show(_index);
			}
		}

		private function addbg(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addbg);
			//stage.addEventListener(MouseEvent.MOUSE_DOWN, MouseEvents);//鼠标滑动切换
			/*addChildAt(new Bitmap(new BitmapData(stage.stageWidth,stage.stageHeight,true,0x99000000)),0);*/
		}
	}
}

