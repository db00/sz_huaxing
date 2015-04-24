/**
 * @file Moves.as
 *  天更蓝
 [ "一次处理", "二次处理", "深度处理" ];
 * @author db0@qq.com
 * @version 1.0.1
 * @date 2015-04-07
 */
package green
{
	import flash.text.TextField;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import gs.easing.*;
	public class Moves
	{
		public function Moves()
		{


			/*
			var tweenList:Array = Array();

			var i:int = 0;
			while(i<3){
				var mc:Sprite= getChildByName(Gdata.btns10[i]);
				var tween:TweenLite = new TweenLite(mc, 1, {x:300});
				tweenList.push(tween);
				++i;
			}
			var myGroup:TweenGroup = new TweenGroup(tweenList);
			myGroup.align = TweenGroup.ALIGN_SEQUENCE;
			*/
		}
		public static function btnOut(btn:Sprite,_x:int,_y:int,_onComplete:Function=null):TweenLite
		{
			if (btn) {
				btn.visible = true;
				ViewSet.center(btn, 1920 / 2 - 1, 1080 / 2 - 1, 2, 2);
				btn.alpha = 0;
				return new TweenLite(btn,1,{x:_x,y:_y,alpha:1,/*ease:Elastic.easeOut,*/onComplete:_onComplete});
				//TweenLite.to(btn.parent.getChildByName(btn.name+"l"),1,{x1:1920/2,y1:1080/2,x2:_x,y2:_y,ease:Elastic.easeOut});
			}
			return null;
		}
		public static function zoomOut(btn:Sprite,_:Number,onComplete:Function=null):void
		{
			if(btn){
				//ViewSet.center(btn,1920/2-1,1080/2-1,2,2);
				btn.scaleX = btn.scaleY = 1.0;
				TweenLite.from(btn,1,{scaleX:_,scaleY:_,/*ease:Elastic.easeOut,*/onComplete:onComplete});
			}
		}
	}
}

