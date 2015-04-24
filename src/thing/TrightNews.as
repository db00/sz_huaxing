package thing 
{
	import flash.utils.setTimeout;
	import flash.utils.clearTimeout;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import flash.events.Event;
	public class TrightNews extends Sprite
	{
		private var filesArr:Array;
		private var dir:String;
		private var numPerPage:uint = 4;
		public function TrightNews(s:String="new")
		{
			var bmp:Bitmap = new Tasset.newsbg_png;
			bmp.smoothing = true;
			addChild(bmp);
			x = 7680 -width*1;
			y = 1080/2 -height/2;


			dir = Tdata.rootPath + s;


			makeHeadBtn();

			showPage();
		}

		private function makeHeadBtn():void
		{
			var i:int = 0;
			while(i<numPage)
			{
				var btnpng:String = dir + "/btn/"+i+"s.png";;
				var btnpng2:String = dir+"/btn/"+i+"b.png";;
				var btn:ImgBtn = new ImgBtn([btnpng,btnpng2]);
				addChild(btn);
				btn.name = "i"+i;
				btn.x = 100*i;
				btn.addEventListener(MouseEvent.CLICK,selectBtn);
				++i;
			}

			var prevBtn:Sprite = new Sprite;
			var nextBtn:Sprite = new Sprite;
			prevBtn.name ="prev";
			nextBtn.name ="next";
			Bitmap(prevBtn.addChild(new Tasset.prev_png)).smoothing=true;
			Bitmap(nextBtn.addChild(new Tasset.next_png)).smoothing=true;
			BtnMode.setSpriteBtn(prevBtn);
			BtnMode.setSpriteBtn(nextBtn);
			prevBtn.x = 200;
			nextBtn.x = width - nextBtn.width;
			prevBtn.scaleX = 
				prevBtn.scaleY = 
				nextBtn.scaleX = 
				nextBtn.scaleY = .6;
			addChild(prevBtn);
			addChild(nextBtn);
			prevBtn.addEventListener(MouseEvent.CLICK,prev);
			nextBtn.addEventListener(MouseEvent.CLICK,next);
		}

		private function selectBtn(e:Event):void
		{
			var i:int = 1+int(e.target.name.substr(1));
			showPage(i);
		}

		private function prev(e:Event=null):void
		{
			showPage(--curPage);
		}
		private function next(e:Event=null):void
		{
			showPage(++curPage);
		}

		private var items:Sprite = new Sprite;
		private function showPage(i:int=0):void
		{
			if(i<0)i=numPage-1;
			if(i>=numPage)i=0;

			var start:int=i*numPerPage;

			if(filesArr==null)
				filesArr = SwfLoader.filesInDir(dir,SwfLoader.imgReg);


			if(start<0)i=numPage-1;
			if(start>=filesArr.length)i=0;

			logs.adds(filesArr.length,"numPage:",numPage,"curPage:",i);

			start = i*numPerPage;

			ViewSet.removes(items);
			addChild(items);


			var j:int = 0;
			while(j<numPerPage && start+j<filesArr.length)
			{
				var p:String = filesArr[start];
				var imgbtn:ImgBtn = new ImgBtn([p],450,108);//450,108
				imgbtn.name = "i"+(i+start);
				imgbtn.addEventListener(MouseEvent.CLICK,shows);
				imgbtn.x = 10;
				imgbtn.y = 115*j + 80;
				items.addChild(imgbtn);
				++j;
			}
			curPage = i;
			showNextPage();
		}

		private function get numPage():uint
		{
			if(filesArr==null)
				filesArr = SwfLoader.filesInDir(dir,SwfLoader.imgReg);

			if(filesArr){
				return Math.ceil(filesArr.length/numPerPage);
			}
			return 0;
		}

		private var curPage:int = 0;
		private var setTimeoutid:uint;
		private function showNextPage(e:Event=null):void
		{
			clearTimeout(setTimeoutid);
			if(numPage>1){
				var a:int = curPage;
				if(e){
					if(e.target.name == "prev") {
						setTimeoutid = setTimeout(showPage,10000,a-1);
						return;
					}
				}
				setTimeoutid = setTimeout(showPage,10000,a+1);
			}
		}

		public var SelectedBtn:ImgBtn;
		private function shows(e:Event=null):void{
			var target:ImgBtn = e.target as ImgBtn;
			if(SelectedBtn)SelectedBtn.selected = false;
			if(target){
				target.selected = true;
				SelectedBtn = target;
				logs.adds(target.name);
				dispatchEvent(new Event(Event.SELECT));
			}

		}
	}
}
