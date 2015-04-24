/**

1、滑动选择衣服时卡顿现象（在我电脑上也是有点卡）

 * @file B1.as
 *  浏览列表
 * @author db0@qq.com
 * @version 1.0.1
 * @date 2015-04-06
 */
package business
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.utils.setTimeout;
	import flash.utils.clearTimeout;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	public class B1 extends Sprite
	{
		private static var timeoutId:uint;
		public function B1()
		{
			//addChild(new Bassets.bg);
			addChild(new Bitmap(new BitmapData(1080,1920,false,0)));
			init();
		}
		private var mylist:MyList;

		private function init():void
		{
			mylist = new MyList();
			mylist.addEventListener(Event.SELECT,on_click_show);
			mylist.setVRoll(false);//竖直方向
			mylist.MaskRect = new Rectangle(0,0,Bdata.stageW,Bdata.stageH);
			mylist.y = Bdata.stageH - 200;
			mylist.x = Bdata.stageW*.05 ;
			addChild(mylist);


			var i:int = 0;
			for each(var arr:Array in Bdata.btnsPathArr)
			{
				if(arr[0].match(/0\.png$/i)){
				}else{
					var _url:String = arr[0];
					arr[0] = arr[1];
					arr[1] = _url;
				}
				var btn:ImgBtn = new ImgBtn(arr);
				btn.name = "b"+i;
				btn.x = 250 *i;
				mylist.addItem(btn);
				if(i==0){
					mylist.ClickObject = btn;
				}
				++i;
			}

			timeoutId = setTimeout(on_click_show,1000);//first time added to the stage , clicked the first botton automatically.
		}
		public static var curDirs:Array;
		private function get curDir():Array
		{
			if(curDirs)curDirs.slice(0,curDirs.length);
			curDirs = SwfLoader.dirsInDir(Bdata.dirArr[select_index],".*");
			return curDirs;
		}
		private var PicsArr:Array;
		private var colorsArr:Array;
		private var infosArr:Array;
		private var detailsArr:Array;

		private var prevSelected:ImgBtn;
		private var select_index:uint=10000000;
		private function on_click_show(e:Event=null):void{
			clearTimeout(timeoutId);
			var target:ImgBtn = mylist.ClickObject as ImgBtn;
			if(select_index != uint(target.name.substr(1))){
				target.selected = true;
				if(prevSelected)prevSelected.selected = false;
				prevSelected = target as ImgBtn;
				select_index = uint(target.name.substr(1));
				logs.adds(select_index);

				var dirs:Array = curDir;
				if(dirs == null)return;

				if(PicsArr)PicsArr.slice(0,PicsArr.length);
				if(colorsArr)colorsArr.slice(0,colorsArr.length);
				if(infosArr)infosArr.slice(0,infosArr.length);
				if(detailsArr)detailsArr.slice(0,detailsArr.length);
				PicsArr = new Array;
				colorsArr = new Array;
				infosArr = new Array;
				detailsArr = new Array;

				var showArr:Array = new Array;
				var i:int = 0;
				while(i< dirs.length)
				{
					var files:Array = SwfLoader.filesInDir(dirs[i],".*");
					for each(var f:String in files)
					{
						if(f.match(/info/i))
						{
							if(infosArr[i]==null)infosArr[i]=new Array;
							infosArr[i].push(f);
						}
						if(f.match(/detail/i))
						{
							if(detailsArr[i]==null)detailsArr[i]=new Array;
							detailsArr[i].push(f);
						}
						if(f.match(/color/i))
						{
							if(colorsArr[i]==null)colorsArr[i]=new Array;
							colorsArr[i].push(f);
						}
						if(f.match(/mod/i))
						{
							if(PicsArr[i]==null)PicsArr[i]=new Array;
							PicsArr[i].push(f);
						}

					}
					++i;
				}

				i = 0;
				while(i< dirs.length)
				{
					showArr.push(PicsArr[i][0]);
					++i;
				}


				dispatchEvent(new Event(Event.SELECT));

				removeList();

				picmoveshow = new PicMoveShow(showArr);
				picmoveshow.y = Bdata.stageH * .2;
				picmoveshow.addEventListener(PicMoveShow.SELECTED,show_detail);
				addChild(picmoveshow);
				picmoveshow._visible = true;
			}
		}
		private function removeList():void
		{
			if(picmoveshow)
			{
				if(picmoveshow.parent)
					picmoveshow.parent.removeChild(picmoveshow);
			}
			picmoveshow = null;
		}
		public var picmoveshow:PicMoveShow;
		private var b2:B2;
		private function show_detail(e:Event=null):void
		{
			picmoveshow._visible = false;
			logs.adds(PicMoveShow.curSelectedIndex);
			var i:int = PicMoveShow.curSelectedIndex;
			if(b2){
				ViewSet.removes(b2);
				if(b2.parent)b2.parent.removeChild(b2);
				b2 = null;
			}
			b2 = new B2(PicsArr[i],infosArr[i],colorsArr[i],detailsArr[i]);
			parent.addChild(b2);
			Btitle.show_buy(false);
		}

	}
}

