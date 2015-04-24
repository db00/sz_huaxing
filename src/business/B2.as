/**
 * @file B2.as
 *  选中衣服
 * @author db0@qq.com
 * @version 1.0.1
 * @date 2015-04-06
 */
package business
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	public class B2 extends Sprite
	{
		private var pic:PhotoLoader;
		private var info:PhotoLoader;
		private var colors:Sprite;
		private var detailsArr:Array;
		private var picArr:Array;

		public function B2(picArr:Array,infosArr:Array,colorsArr:Array,detailsArr:Array)
		{
			//addChild(new Bassets.bg);
			addChild(new Bitmap(new BitmapData(1080,1920,false,0)));

			this.detailsArr = detailsArr;

			this.picArr = picArr;
			pic = addChild(new PhotoLoader(picArr[0],800,1000)) as PhotoLoader;
			pic.y = Bdata.stageH/2 - pic.height/2;
			pic.x = Bdata.stageW*.3 - pic.width/2;

			info = addChild(new PhotoLoader(infosArr[0],300,250)) as PhotoLoader;
			info.y = Bdata.stageH*.3;
			info.x = Bdata.stageW*.6;

			colors = new Sprite;
			var i:int = 0;
			for each(var s:String in colorsArr)
			{
				var colorbtn:PhotoLoader = new PhotoLoader(s,50,50);
				colorbtn.y = info.y + info.height + 20;
				colorbtn.x = info.x + info.width - i*100 - 50;
				colors.addChild(colorbtn);
				colorbtn.name = "i"+s.replace(/^.*\/color([\d]+).png$/,"$1");
				if(colorsArr.length>1)colorbtn.addEventListener(MouseEvent.CLICK,changeColorMod);
				++i;
			}
			addChild(colors);


			var detailbtn:Sprite = new Sprite();
			detailbtn.addChild(new Bassets.detailbtnpng);
			detailbtn.y = info.y + info.height + 200 ;
			detailbtn.x = info.x + info.width - detailbtn.width;
			addChild(detailbtn);
			detailbtn.addEventListener(MouseEvent.CLICK,showDetailBox);
			BtnMode.setSpriteBtn(detailbtn);

			var buybtn:Sprite = new Sprite();
			buybtn.addChild(new Bassets.buybtn);
			buybtn.y = detailbtn.y + detailbtn.height *2;
			buybtn.x = info.x + info.width - buybtn.width;
			addChild(buybtn);
			BtnMode.setSpriteBtn(buybtn);
			buybtn.addEventListener(MouseEvent.CLICK,showBuyBox);


			var backBtn:Sprite = new Sprite();
			backBtn.addChild(new Bassets.backbtnpng);
			backBtn.y = buybtn.y + detailbtn.height *2;
			backBtn.x = info.x + info.width - backBtn.width;
			addChild(backBtn);
			BtnMode.setSpriteBtn(backBtn);
			backBtn.addEventListener(MouseEvent.CLICK,back);
		}

		private function showDetailBox(e:Event=null):void
		{
			Bdetail.show();
			trace("detailsArr:",detailsArr)
				Bdetail.setBg(detailsArr[0]);
			Btitle.show_buy(false);
		}
		private function showBuyBox(e:Event=null):void
		{
			trace("detailsArr:",detailsArr)
				Bpay.show(true,new PhotoLoader(detailsArr[0].replace(/detail/i,"buybox"),961,668));
			addChild(Bpay.main);
			Btitle.show_buy(true);
		}
		private function showSuccesBox(e:Event=null):void
		{
			BpayEnd.show();
			addChild(BpayEnd.main);
		}
		private function changeColorMod(e:MouseEvent):void{
			var url:String = e.target.name.substr(1)+".png";
			for each(var s:String in picArr)
			{
				if(s.match(url)){
					url = s;
					break;
				}
			}
			ViewSet.removes(pic);
			pic.addChild(new PhotoLoader(url,800,1000));
			EasyOut.alphaIn(pic);
		}

		private function back(e:Event=null):void{
			businessMain.showB1();
		}
	}
}

