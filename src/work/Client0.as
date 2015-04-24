package work
{
	import flash.text.TextField;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	public class Client0 extends Sprite
	{
		private static var _main:Client0;
		public static function get main():Client0
		{
			if(_main == null)
				_main = new Client0;
			return _main;
		}
		private var bg:Bitmap;
		public function Client0()
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

					var i:int = 0;
					while(i<Wdata.dirArr.length){
						var btn:Sprite;
						switch(i)
						{
							case 0:
								btn = ViewSet.makebtn(1250,50,Wdata.dirArr[i],300,300,clicked);
								[Embed(source="asset/shiping.swf")] var shipingswf:Class;
								//btn.addChild(new PhotoLoader("client/shipinghuiyi.png",607,574));
								btn.addChild(new shipingswf);
								break;
							case 1:
								btn = ViewSet.makebtn(275,300,Wdata.dirArr[i],300,300,clicked);
								//btn.addChild(new PhotoLoader("client/shengchanjiankong.png",607,574));
								[Embed(source="asset/shengchan.swf")] var shengchanswf:Class;
								btn.addChild(new shengchanswf);
								break;
							case 2:
								btn = ViewSet.makebtn(850,520,Wdata.dirArr[i],300,300,clicked);
								//btn.addChild(new PhotoLoader("client/quanqiushuju.png",607,574));
								[Embed(source="asset/quanqiu.swf")] var quanqiuswf:Class;
								btn.addChild(new quanqiuswf);
								break;
						}
						addChild(btn);
						++i;
					}
					//var s:String = SwfLoader.readfile(Wdata.dirArr+"info.txt");
					//addChild(ViewSet.maketxt(940, 530,s, 100, 100, 28,"left",0xffffff));
					//addChild(ViewSet.makebtn(1920-200,00,"back",200,200,clicked));
				}
			}
		}

		private function selectbtn(btn:Sprite,b:Boolean=true):void
		{
			if(btn && b){
				var oldY:int = btn.y;
				var tweenlist:Array = new Array;
				tweenlist.push(new TweenLite(btn,1,{y:-btn.height}));
				tweenlist.push(new TweenLite(btn,3,{y:-btn.height}));
				tweenlist.push(new TweenLite(btn,1,{y:oldY}));
				var tweengroup:TweenGroup = new TweenGroup(tweenlist);
				tweengroup.align = TweenGroup.ALIGN_SEQUENCE; //stacks them end-to-end, one after the other
				return;
				var son:Sprite= btn.getChildAt(btn.numChildren-1) as Sprite;
				if(son){
					if(b){
						//TweenLite.to(son,.5,{rotationX:10,y:-100});
					}else{
						//TweenLite.to(son,.5,{rotationX:0,y:0});
					}
				}
			}
		}


		private var curSelectBtn:Sprite;
		private function clicked(e:Event):void
		{
			var target:Sprite = e.target as Sprite;
			if(target==null)
				return;

			if(curSelectBtn)
				selectbtn(curSelectBtn,false);
			selectbtn(target,true);
			curSelectBtn = target;

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

