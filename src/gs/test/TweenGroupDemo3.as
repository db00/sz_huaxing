/**
 * @file TweenGroupDemo3.as
d:\flex_sdk_4.5\bin\mxmlc -source-path=../.. TweenGroupDemo3.as -output test.swf && d:\flex_sdk_4.5\bin\FlashPlayerDebugger.exe test.swf  
 * @author db0@qq.com
 * @version 1.0.1
 * @date 2015-04-17
 */
package gs.test{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	[SWF(backgroundColor=0xffffff)]
		public class TweenGroupDemo3 extends Sprite
		{
			private var sprite:Sprite;
			private var tween1:TweenLite;
			private var tween2:TweenLite;
			private var tween3:TweenLite;

			public function TweenGroupDemo3()
			{
				stage.scaleMode = StageScaleMode.NO_SCALE;
				stage.align = StageAlign.TOP_LEFT;

				sprite = new Sprite();
				sprite.graphics.beginFill(0xff0000);
				sprite.graphics.drawRect(-50, -25, 100, 50);
				sprite.graphics.endFill();
				sprite.x = 100;
				sprite.y = 100;
				addChild(sprite);

				tween1 = new TweenLite(sprite, 3, {x:400});
				tween2 = new TweenLite(sprite, 3, {y:300, overwrite:0});
				tween3 = new TweenLite(sprite, 3, {rotation:360, overwrite:0});
				var tg:TweenGroup = new TweenGroup([tween1, tween2, tween3],1);
				//tg.align = TweenGroup.ALIGN_SEQUENCE;
				tg.align = TweenGroup.ALIGN_INIT; //same as ALIGN_START except that it honors any delay set in each tween.
			}
		}
}
