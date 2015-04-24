/**
 * @file G2.as
 *  水更清
 [ "纯水回收", "废水处理", "人工湿地", "雨水回收"];
 * @author db0@qq.com
 * @version 1.0.1
 * @date 2015-04-07
 */
package green
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	public class G2 extends Sprite
	{
		private static var _main:G2;
		public static function get main():G2
		{
			if(_main == null)
				_main = new G2;
			return _main;
		}
		private var bmp:Bitmap;
		private var graybmp:Bitmap;
		public function G2()
		{
			_main = this;
			[Embed(source="asset/bg3.png")] var  bg3png:Class;
			bmp = new bg3png;
			if(bmp){
				bmp.smoothing = true;
				addChild(bmp);

				graybmp = addChild(new Bitmap(new BitmapData(1920,1080,true,0x88000000))) as Bitmap;

				[Embed(source="asset/title.png")] var titlepng:Class;
				var title:Bitmap = new titlepng;
				title.smoothing = true;
				addChild(title);
				[Embed(source="asset/2/line.png")] var linepng:Class;
				linebmp = new linepng;
				linebmp.smoothing = true;
				linebmp.x=1920*.475-linebmp.width/2;
				linebmp.y=1080*.45-linebmp.height/2;
				addChild(linebmp);



				var i:int = 0;
				while(i<Gdata.btns11.length){
					var btn:Sprite;
					switch(i){
						case 0:
							btn = (ViewSet.makebtn(375,330,Gdata.btns11[i],200,200,clicked));
							[Embed(source="asset/2/b1.png")] var b1png:Class;
							var b1bmp:Bitmap = new b1png;
							b1bmp.smoothing = true;
							btn.addChild(b1bmp);
							break;
						case 1:
							btn = (ViewSet.makebtn(1250,250,Gdata.btns11[i],200,200,clicked));
							[Embed(source="asset/2/b2.png")] var b2png:Class;
							var b2bmp:Bitmap = new b2png;
							b2bmp.smoothing = true;
							btn.addChild(b2bmp);
							break;
						case 2:
							btn = (ViewSet.makebtn(1350,520,Gdata.btns11[i],200,200,clicked));
							[Embed(source="asset/2/b3.png")] var b3png:Class;
							var b3bmp:Bitmap = new b3png;
							b3bmp.smoothing = true;
							btn.addChild(b3bmp);
							break;
						case 3:
							btn = (ViewSet.makebtn(320,570,Gdata.btns11[i],200,200,clicked));
							[Embed(source="asset/2/b4.png")] var b4png:Class;
							var b4bmp:Bitmap = new b4png;
							b4bmp.smoothing = true;
							btn.addChild(b4bmp);
							break;
					}
					addChild(btn);
					++i;
				}
				var s:String = SwfLoader.readfile(Gdata.Dir2+"info.txt");
				centerTxt = addChild(ViewSet.maketxt(940, 530,s, 200, 100, 28,"left",0xffffff)) as TextField;

				var backbtn:Sprite = addChild(ViewSet.makebtn(1920-200,00,"back",200,200,clicked)) as Sprite;
				[Embed(source="asset/close.png")] var backpng:Class;
				var backbmp:Bitmap = new backpng;
				backbmp.smoothing = true;
				backbmp.x = 30;
				backbmp.y = 30;
				backbtn.addChild(backbmp);
				//showBtns();

				[Embed(source="asset/2/center.png")] var centerpng:Class;
				var centerbmp:Bitmap = new centerpng;
				centerbmp.smoothing = true;
				centerbmp.x=1920*.47-centerbmp.width/2;
				centerbmp.y=1080*.49-centerbmp.height/2;
				centers.addChild(centerbmp);
				addChild(centers);
			}
		}
		private var centers:Sprite = new Sprite();
		public function showBtns(e:Event=null):void
		{
			if (txtContainer) txtContainer.visible = false;
			Moves.zoomOut(centers,.5,btnsOut);
			//Moves.btnOut(getChildByName(Gdata.btns11[0]) as Sprite,375,330);
			//Moves.btnOut(getChildByName(Gdata.btns11[1]) as Sprite,1250,250);
			//Moves.btnOut(getChildByName(Gdata.btns11[2]) as Sprite,1350,520);
			//Moves.btnOut(getChildByName(Gdata.btns11[3]) as Sprite,320,570,showLines);
			centerTxt.visible = false;
			linebmp.visible = false;


			var _i:int = 1;
			getChildByName(Gdata["btns1" + _i][0]).visible = false;
			getChildByName(Gdata["btns1" + _i][1]).visible = false;
			getChildByName(Gdata["btns1" + _i][2]).visible = false;
			getChildByName(Gdata["btns1" + _i][3]).visible = false;
		}


		private function btnsOut(_i:int = 1):void
		{
			var tweenlist:Array = new Array;
			var tween1:TweenLite = Moves.btnOut(getChildByName(Gdata["btns1"+_i][0]) as Sprite, 375, 330);
			var tween2:TweenLite = Moves.btnOut(getChildByName(Gdata["btns1"+_i][1]) as Sprite, 1250, 250);
			var tween3:TweenLite = Moves.btnOut(getChildByName(Gdata["btns1"+_i][2]) as Sprite, 1350, 520);
			var tween4:TweenLite = Moves.btnOut(getChildByName(Gdata["btns1"+_i][3]) as Sprite, 320, 570, showLines);

			var myGroup:TweenGroup = new TweenGroup([tween1, tween2, tween3,tween4]);
			myGroup.align = TweenGroup.ALIGN_INIT;
			myGroup.stagger = .5;
		}

		private var txtContainer:Sprite = null;
		private function showBtnTxt(b:Boolean=true,_index:int=1):void
		{
			if(txtContainer==null)
			{
				txtContainer = new Sprite;
				var i:int = 0;
				var _x:int =0;
				var _y:int =0;
				while(i<Gdata["btns1"+_index].length)
				{
					var dir:String = Gdata.dir(_index,i);
					var txtfile:String = dir+"info.txt";
					logs.adds("=======================",txtfile);
					switch(i)
					{
						case 0:
							_x = 375 - 100;
							_y = 330;
							break;
						case 1:
							_x = 1250 + 200;
							_y = 250;
							break;
						case 2:
							_x = 1350 + 200;
							_y = 520;
							break;
						case 3:
							_x = 320 - 100;
							_y = 570;
							break;
					}
					var _s:String = SwfLoader.readfile(txtfile) || "";
					logs.adds("file text:",_s);
					var txt:TextField;
					txt = ViewSet.maketxt(_x,_y,_s,100,100,22,"left",0xffffff);
					txtContainer.addChild(txt);
					++i;
				}
			}
			addChild(txtContainer);
			if (txtContainer) txtContainer.visible = true;
		}






		private var centerTxt:TextField;
		private var linebmp:Bitmap;
		private function showLines():void
		{
			linebmp.visible = true;
			centerTxt.visible = true;
			addChild(centerTxt);
			showBtnTxt();
		}
		private function clicked(e:Event):void
		{
			if(e.target.name == "back")
			{
				parent.removeChild(this);
				return;
			}
			Gdata.dir1 = e.target.name;
			logs.adds(Gdata.curDir);

			if(bmp) addChild(bmp);
			if(graybmp) addChild(graybmp);
			colorBmp = new Flashing(Gdata.curColorUrl,to4);
			addChild(colorBmp);
		}
		private var colorBmp:Flashing;
		private function to4():void
		{
			if(bmp) addChildAt(bmp,0);
			if(graybmp) addChildAt(graybmp,1);
			if(colorBmp){
				if(colorBmp.parent)
					colorBmp.parent.removeChild(colorBmp);
				colorBmp = null;
			}
			parent.addChild(ShowPic.main);
			ShowPic.show();
		}
	}
}

