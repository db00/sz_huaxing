package thing 
{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.setTimeout;
	import flash.utils.clearTimeout;

	public class Tvmenu extends Sprite
	{
		private var title:Bitmap;
		private var vline:Bitmap;
		private var vline0:Bitmap;
		public function Tvmenu(s:String="2009")
		{
			vline = new Tasset.vline_png;
			vline.smoothing = true;
			vline0 = new Tasset.vline0_png;
			vline0.smoothing = true;
			addChild(vline0);
			addChild(vline);
			title = new Tasset.title_png;
			title.smoothing = true;
			title.y = title.height*1.5;
			title.x = 200;
			addChild(title);

			var i:int = 0;

			//var filesArr:Array = SwfLoader.filesInDir(Tdata.rootPath+s,SwfLoader.imgReg);
			var filesArr:Array = SwfLoader.dirsInDir(Tdata.rootPath+s,".*");
			filesArr = SwfLoader.sortBytxtFile(filesArr,"file.xml");


			for each(var p:String in filesArr)
			{
				//if(p.match(/b\.png$/i))
				{
					var btnName:String = p.replace(/^.*\/([^\\\/]+)[\/\\]*$/,"$1");
					btnName = btnName.replace(/[\r\n]/ig,"");
					[Embed(source="asset/btnA.png")] var  btnApng:Class;
					[Embed(source="asset/btnB.png")] var  btnBpng:Class;
					var imgbtn:Sprite = new Sprite();
					var bg0:Bitmap = new btnApng;
					var bg1:Bitmap = new btnBpng;
					bg0.smoothing = true;
					bg1.smoothing = true;
					imgbtn.addChild(bg0);
					imgbtn.addChild(bg1);
					imgbtn.mouseChildren = false;
					imgbtn.buttonMode= true;
					var font_size:uint = 16;
					var txt:TextField = maketxt(0, 0,btnName, 400, 43, font_size,0x90e2fe);
					while(txt.width>=400){
						txt = null;
						font_size -= 2;
						txt = maketxt(0, 0,btnName, 400, 43, font_size,0x90e2fe);
					}
					imgbtn.addChild(txt);
					toSelecteBtn(imgbtn,false);
					/*
					   var imgbtn:ImgBtn = new ImgBtn([p,p.replace(/b\.png$/i,"a.png")]);
					   imgbtn.name = "i"+p.replace(/^.*([0-9]+)b\.png$/i,"$1");
					 */
					imgbtn.name = "i"+btnName;
					trace("imgbtn.name:",imgbtn.name);
					imgbtn.addEventListener(MouseEvent.CLICK,shows);
					imgbtn.y = 70*i + title.height*1.5 + title.y;
					addChild(imgbtn);
					++i;
				}
			}

			if(vline.height < height)
			{
				vline.y = height -vline.height + title.height*.5;
				vline0.height = vline.y;
			}

		}
		public function click(s:String):void
		{
			clearTimeout(timeoutId);
			if(SelectedBtn){
				//SelectedBtn.selected = false;
				toSelecteBtn(SelectedBtn,false);
			}
			var target:Sprite = getChildByName(s) as Sprite;
			if(target){
				//target.selected = true;
				toSelecteBtn(target,true);
				SelectedBtn = target;
				logs.adds(target.name);
				timeoutId = setTimeout(dispatchEvents,500);
			}

		}
		public var SelectedBtn:Sprite;
		private function shows(e:Event=null):void{
			clearTimeout(timeoutId);
			var target:Sprite = e.target as Sprite;
			CONFIG::NET{
				if(target)Tdata.sendData(target.name);
				return;
			}
			click(target.name);
			/*
			if(SelectedBtn){
				//SelectedBtn.selected = false;
				toSelecteBtn(SelectedBtn,false);
			}
			if(target){
				//target.selected = true;
				toSelecteBtn(target,true);
				SelectedBtn = target;
				logs.adds(target.name);

				timeoutId = setTimeout(dispatchEvents,500);
			}
			*/
		}

		private static var timeoutId:uint;
		private function dispatchEvents():void
		{
			clearTimeout(timeoutId);
			dispatchEvent(new Event(Event.SELECT));
		}

		private function toSelecteBtn(mc:Sprite,b:Boolean):void
		{
			var txt:TextField = mc.getChildAt(2) as TextField;
			var bg0:Bitmap = mc.getChildAt(0) as Bitmap;
			var bg1:Bitmap = mc.getChildAt(1) as Bitmap;
			if(b){
				txt.x = 80;
				bg1.visible = true;
				bg1.x = -20;
				bg0.visible = false;
				txt.y = bg1.height/2 - txt.height/2;
			}else{
				bg1.visible = false;
				bg0.visible = true;
				txt.x = 100;
				txt.y = bg0.height/2 - txt.height/2;
				bg0.x = 50;
			}
		}


		public static function maketxt(xx:int, yy:int,str:String, ww:int, hh:int, size:int,color:uint=0xffffff):TextField
		{
			var txt:TextField = new TextField();
			/*txt.border = true;*/
			/*txt.type = TextFieldType.INPUT;*/
			txt.x = xx;
			txt.y = yy;
			txt.width = ww;
			txt.height = hh;
			/*txt.multiline = true;*/
			/*txt.selectable = false;*/
			var txtformat:TextFormat = new TextFormat("Microsoft YaHei", size, color);
			txt.defaultTextFormat = txtformat;
			txt.autoSize = "left";
			//txt.text = Fanti.jian2fan(str);
			txt.text = String(str);
			return txt;
		}
	}
}

