/**
 * @file TweenGroupDemo2.as
d:/flex_sdk_4.5/bin/amxmlc -static-link-runtime-shared-libraries=true -source-path=.. TweenGroupDemo2.as -output test2.swf && d:/flex_sdk_4.5/bin/FlashPlayerDebugger.exe test2.swf  
 * @author db0@qq.com
 * @version 1.0.1
 * @date 2015-04-17
 */
package staff
{
	import flash.events.Event;
	import flash.geom.Vector3D;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.utils.setTimeout;
	import flash.utils.clearTimeout;

	[SWF(width=768,height=108,backgroundColor=0x0)] public class TweenGroupDemo2 extends Sprite
	{
		private var group:TweenGroup;
		private var _items:Array;
		private var pathArr:Array;
		private var _holder:Sprite;
		private var stageWidth:int = 768;
		private var stageHeight:int = 108;
		private var arrloader:ArrLoader;
		private var minNumItems:uint = 50;

		public function TweenGroupDemo2(pathArr:Array=null,stageWidth:int=768,stageHeight:int=108)
		{
			this.pathArr = pathArr;
			this.stageWidth= stageWidth;
			this.stageHeight= stageHeight;
			if(pathArr){
				arrloader = new ArrLoader(pathArr,init,null);
			}else{
				if(stage)init();
				else addEventListener(Event.ADDED_TO_STAGE,init);
			}
		}

		private function init(e:Event=null):void{
			removeEventListener(Event.ADDED_TO_STAGE,init);
			//stage.scaleMode = StageScaleMode.NO_SCALE;
			//stage.align = StageAlign.TOP_LEFT;

			_holder = new Sprite();
			addChild(_holder);
			_holder.z = 0;

			var numItems:int = minNumItems;
			if(pathArr && numItems < arrloader.bmpArr.length)numItems = arrloader.bmpArr.length;
			var i:int = 0;
			_items = new Array();
			while(i<numItems){
				if(pathArr){
					var mc:Sprite = new Sprite();
					var bmp:Bitmap = new Bitmap(Bitmap(arrloader.bmpArr[i%arrloader.bmpArr.length]).bitmapData.clone());
					bmp.smoothing = true;
					//bmp.height = stageHeight/6; bmp.scaleX = bmp.scaleY ;
					bmp.x = -bmp.width/2;
					bmp.y = -bmp.height/2;
					mc.addChild(bmp);
					[Embed(source="bord.png")] var bordpng:Class;
					var bord:Bitmap = new bordpng;
					bord.smoothing = true;
					ViewSet.center(bord,-1,-1,2,2);
					mc.addChild(bord);
					_items.push(mc);
				}else{
					_items.push(makeSprite() as Sprite);
				}
				++i;
			}

			showDepthMove();
			//showLeftRightMove();

			addEventListener(Event.ENTER_FRAME,enterFrames);
		}

		private function showLeftRightMove():void
		{
			var arr1:Array = new Array;
			var arr2:Array = new Array;
			var arr3:Array = new Array;
			var i:int = 0;
			var randomArr:Array = genRandomArr(_items.length);
			while(i<_items.length){
				var mc:Sprite = _items[randomArr[i]] as Sprite;
				setRightRadom(mc);
				if(i%3==0){
					arr1.push(mc);
				}else if(i%3==1){
					arr2.push(mc);
				}else if(i%3==2){
					arr3.push(mc);
				}
				++i;
			}

			i = 0;
			var duration:Number = 10;
			var numscreenW:uint = 3;

			tweengroups.splice(0,tweengroups.length);
			while(i<3){
				var tg:TweenGroup;
				if(i==0) tg = TweenGroup.allTo(arr1, duration, {x:-stageWidth*numscreenW});
				else if(i==1) tg = TweenGroup.allTo(arr2, duration, {x:-stageWidth*numscreenW});
				else if(i==2) tg = TweenGroup.allTo(arr3, duration, {z:-stageWidth*numscreenW});
				tg.align = TweenGroup.ALIGN_INIT; //same as ALIGN_START except that it honors any delay set in each tween.
				tg.progress = .45;
				tg.stagger = .5;
				tweengroups.push(tg);
				++i;
			}
			clearTimeout(timeoutId);
			timeoutId = setTimeout(pauseCenter,duration*1000*.3);
		}

		private var tweengroups:Array = new Array();

		private function pauseCenter():void
		{
			clearTimeout(timeoutId);
			var i:int = 0;
			while(i<tweengroups.length){
				TweenGroup(tweengroups[i]).pause();
				++i;
			}
			timeoutId = setTimeout(resumeCenter,1000);
		}

		private function resumeCenter(fun:Function=null,wait:uint=0):void
		{
			clearTimeout(timeoutId);
			var i:int = 0;
			while(i<tweengroups.length){
				TweenGroup(tweengroups[i]).resume();
				++i;
			}
			timeoutId = setTimeout(stopAllMoveAndWait,4000,showDepthMove);
		}

		private function stopAllMoveAndWait(fun:Function=null,wait:uint=0):void
		{
			clearTimeout(timeoutId);
			var i:int = 0;
			while(i<tweengroups.length){
				TweenGroup(tweengroups[i]).clear();
				++i;
			}
			tweengroups.splice(0,tweengroups.length);
			if(fun!=null){
				timeoutId = setTimeout(fun,wait);
			}
		}

		private static var timeoutId:uint;

		private function showDepthMove():void
		{
			var numOnceTime:uint = 8;
			var allArr:Array = new Array(numOnceTime);
			var i:int = 0;
			while(i<numOnceTime)
			{
				allArr[i] = new Array;
				++i;
			}
			i = 0;
			var randomArr:Array = genRandomArr(_items.length);
			while(i<_items.length){
				var mc:Sprite = _items[randomArr[i]] as Sprite;
				setDeepest(mc);
				var yu:uint = uint(i % numOnceTime);
				allArr[yu].push(mc);
				++i;
			}

			tweengroups.splice(0,tweengroups.length);
			i = 0;
			var duration:Number = 5;
			while(i<numOnceTime){
				var tg:TweenGroup;
				if(i==0){
					tg = TweenGroup.allTo(allArr[i], duration, {z:0,alpha:1});
				}else{
					tg = TweenGroup.allTo(allArr[i], duration, {z:0,alpha:1});
				}
				tg.align = TweenGroup.ALIGN_INIT; //same as ALIGN_START except that it honors any delay set in each tween.
				tg.stagger = 1;
				tweengroups.push(tg);
				tweengroups.reverse();
				++i;
			}
			clearTimeout(timeoutId);
			timeoutId = setTimeout(stopAllMoveAndWait,duration*1000,showLeftRightMove,1000);
		}

		public static function genRandomArr(num:uint):Array
		{
			var arr:Array = new Array(num);
			var i:int = 0;
			while(i<num)
			{
				arr[i] = i;
				++i;
			}
			i = 0;
			while(i<num){
				var rad:int = Math.random()*num;
				var tmp:int = arr[i];
				arr[i] = arr[rad];
				arr[rad] = tmp;
				++i;
			}
			return arr;
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
			s.graphics.beginFill(0xffffff*Math.random());//743x557
			s.graphics.drawRect(-743/2, -557/2, 743, 557);
			s.graphics.endFill();
			setDeepest(s);
			return s;
		}

		private function setDeepest(s:Sprite):void
		{
			s.scaleX = s.scaleY = stageWidth/7680; 
			var tox:Number = Math.random()*stageWidth;
			var toy:Number = Math.random()*stageHeight;
			var r:uint = uint(Math.random()*4);
			switch(r){
				case 1:
					tox -= stageWidth + s.width;
					break;
				case 2:
					tox += stageWidth + s.width;
					break;
				case 3:
					toy -= stageHeight + s.height;
					break;
				case 0:
					toy += stageHeight + s.height;
					break;
				default:
					break;
			}
			s.x = tox;
			s.y = toy;
			s.z = 2000;
			s.alpha = 0.0;
			_holder.addChild(s);
		}


		private var _index:int = 0;
		private function setRightRadom(s:Sprite):void
		{
			s.scaleX = s.scaleY = stageWidth/7680; 
			var tox:Number = stageWidth*2;
			var toy:Number = Math.random()/3 + ((_index%3)+1)/3;
			var toz:Number = 1 - Math.random();
			s.alpha = toz;
			toy = stageHeight*toy;
			toz = (1-toz)*2000;
			s.x = tox;
			s.y = toy - s.height/2;
			s.z = toz;
			_holder.addChild(s);
			++_index;
			if(_index > 2*_items.length)_index = 0;
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

