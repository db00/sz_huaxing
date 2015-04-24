/**
 * @file TweenGroupDemo2.as
d:\flex_sdk_4.5\bin\mxmlc  -static-link-runtime-shared-libraries=true -source-path=../.. TweenGroupDemo2.as -output test.swf && d:\flex_sdk_4.5\bin\FlashPlayerDebugger.exe test.swf  
 * @author db0@qq.com
 * @version 1.0.1
 * @date 2015-04-17
 */
package gs.test{
	import flash.events.Event;
	import flash.geom.Vector3D;
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;

	[SWF(width=768,height=108,backgroundColor=0x0)] public class TweenGroupDemo2 extends Sprite
	{
		private var group:TweenGroup;
		private var _items:Array;
		private var _holder:Sprite;

		public function TweenGroupDemo2(pathArr:Array=null)
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;

			_holder = new Sprite();
			addChild(_holder);
			_holder.z = 0;

			var numItems:int = 50;
			if(pathArr)numItems = pathArr.length;
			var i:int = 0;
			_items = new Array();
			while(i<numItems){
				if(pathArr){
					//_items.push(new PhotoLoader(pathArr[i]) as Sprite);
				}else{
					_items.push(makeSprite() as Sprite);
				}
				++i;
			}

			var arr1:Array = new Array;
			var arr2:Array = new Array;
			var arr3:Array = new Array;
			i = 0;
			while(i<_items.length){
				var mc:Sprite = _items[i] as Sprite;
				if(i%3==0){
					arr1.push(mc);
				}else if(i%3==1){
					arr2.push(mc);
				}else if(i%3==2){
					arr3.push(mc);
				}
				_items.push(mc);
				++i;
			}

			i = 0;
			while(i<3){
				var tg:TweenGroup;
				if(i==0) tg = TweenGroup.allTo(arr1, 5, {z:0,alpha:1});
				else if(i==1) tg = TweenGroup.allTo(arr2, 5, {z:0,alpha:1});
				else if(i==2) tg = TweenGroup.allTo(arr3, 5, {z:0,alpha:1});
				//tg.align = TweenGroup.ALIGN_SEQUENCE; //stacks them end-to-end, one after the other
				//tg.align = TweenGroup.ALIGN_START; //tweens will start at the same time
				//tg.align = TweenGroup.ALIGN_END;// tweens will end at the same time
				tg.align = TweenGroup.ALIGN_INIT; //same as ALIGN_START except that it honors any delay set in each tween.
				//tg.progressWithDelay = 0.6;
				tg.stagger = 1;
				//tg.align = TweenGroup.ALIGN_NONE; //no special alignment
				++i;
			}

			addEventListener(Event.ENTER_FRAME,enterFrames);
		}

		private function sortItems():void
		{
			_items.sort(depthSort);
			for(var i:int = 0; i < _items.length; i++)
			{
				if(_items[i])
					_holder.addChildAt(_items[i] as Sprite, i);
			}
		}

		private function makeSprite():Sprite
		{
			var s:Sprite = new Sprite();
			s.graphics.beginFill(0xffffff*Math.random());
			s.graphics.drawRect(-37.5, -27.5, 75, 55);
			s.graphics.endFill();

			var stageWidth:int = 768;
			var stageHeight:int = 108;
			var tox:Number = Math.random()*2-1;
			var toy:Number = Math.random()*2-1;
			if(tox<=0) tox = stageWidth*tox - s.width/s.scaleX;
			if(tox>0) tox = stageWidth*(1+tox);
			if(toy<=0) toy = stageHeight*toy - s.height/s.scaleY;
			if(toy>0) toy = stageHeight*(1+toy);

			//s.x = 768*Math.random();
			//s.y = 108*Math.random();
			s.x = tox;
			s.y = toy;
			s.z = 20000;
			s.alpha = 0;
			_holder.addChild(s);
			return s;
		}


		private function depthSort(objA:DisplayObject, objB:DisplayObject):int
		{
			if(objA==null || objB==null)return 0;
			if(objA.stage && objB.stage){
				var posA:Vector3D = objA.transform.matrix3D.position;
				posA = _holder.transform.matrix3D.deltaTransformVector(posA);
				var posB:Vector3D = objB.transform.matrix3D.position;
				posB = _holder.transform.matrix3D.deltaTransformVector(posB);
				return posB.z - posA.z;
			}
			return 0;
		}

		private function enterFrames(e:Event):void{
			sortItems();
		}
	}
}

