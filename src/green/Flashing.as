/**
 * @file G1.as
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
	
	public class Flashing extends Sprite
	{
		private var bg:Bitmap;
		private var endf:Function = null;
		
		public function Flashing(url:String, endf:Function = null)
		{
			this.endf = endf;
			SwfLoader.SwfLoad(url, loaded);
		}
		
		private var myGroup:TweenGroup;
		
		private function loaded(e:Event = null):void
		{
			if (e && e.type == Event.COMPLETE)
			{
				bg = e.target.content as Bitmap;
				if (bg)
				{
					addChild(bg);
					bg.alpha = 0;
					
					var tweenlist:Array = new Array();
					tweenlist.push(new TweenLite(bg, .3, {alpha: 1}));
					tweenlist.push(new TweenLite(bg, .3, {alpha: 0}));
					tweenlist.push(new TweenLite(bg, .3, {alpha: 1}));
					tweenlist.push(new TweenLite(bg, .3, {alpha: 0, onComplete: runEndFun}));
					
					if (myGroup)
						myGroup.clear();
					myGroup = new TweenGroup(tweenlist);
					myGroup.align = TweenGroup.ALIGN_SEQUENCE;
					return;
				}
			}
			runEndFun();
		}
		
		private function runEndFun(e:Event = null):void
		{
			ViewSet.removes(this);
			bg = null;
			if (endf != null)
				endf();
		}
	}
}

