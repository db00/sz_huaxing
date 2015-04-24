/**
 * @file Wall3d.as
   d:/flex_sdk_4.5/bin/amxmlc -static-link-runtime-shared-libraries=true -source-path=.. Wall3d.as -output test2.swf && d:/flex_sdk_4.5/bin/FlashPlayerDebugger.exe test2.swf
 * @author db0@qq.com
 * @version 1.0.1
 * @date 2015-04-17
 */
package staff
{
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.utils.setTimeout;
	import flash.utils.clearTimeout;
	
	[SWF(width=768,height=108,backgroundColor=0x0)]
	
	public class Wall3d extends Sprite
	{
		//private var group:TweenGroup;
		private var _items:Array;
		private var pathArr:Array;
		private var _holder:Sprite;
		private var stageWidth:int = 768;
		private var stageHeight:int = 108;
		private var arrloader:ArrLoader;
		private var minNumItems:uint = 50;
		
		public function Wall3d(pathArr:Array = null, stageWidth:int = 768, stageHeight:int = 108)
		{
			this.pathArr = pathArr;
			this.stageWidth = stageWidth;
			this.stageHeight = stageHeight;
			if (pathArr)
			{
				arrloader = new ArrLoader(pathArr, init, null);
			}
			else
			{
				if (stage)
					init();
				else
					addEventListener(Event.ADDED_TO_STAGE, init);
			}
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			root.transform.perspectiveProjection.fieldOfView = 30;
			//stage.scaleMode = StageScaleMode.NO_SCALE;
			//stage.align = StageAlign.TOP_LEFT;
			
			_holder = new Sprite();
			addChild(_holder);
			_holder.z = 0;
			
			var numItems:int = minNumItems;
			if (pathArr && numItems < arrloader.bmpArr.length)
				numItems = arrloader.bmpArr.length;
			var i:int = 0;
			_items = new Array();
			while (i < numItems)
			{
				if (pathArr)
				{
					var mc:Sprite = new Sprite();
					var bmp:Bitmap = new Bitmap(Bitmap(arrloader.bmpArr[i % arrloader.bmpArr.length]).bitmapData.clone());
					bmp.smoothing = true;
					//bmp.height = stageHeight/6; bmp.scaleX = bmp.scaleY ;
					bmp.x = -bmp.width / 2;
					bmp.y = -bmp.height / 2;
					mc.addChild(bmp);
					[Embed(source="bord.png")]
					var bordpng:Class;
					var bord:Bitmap = new bordpng;
					bord.smoothing = true;
					ViewSet.center(bord, -1, -1, 2, 2);
					mc.addChild(bord);
					_items.push(mc);
				}
				else
				{
					_items.push(makeSprite() as Sprite);
				}
				++i;
			}
			
			//showDepthMove();
			//showLeftRightMove();
			resumeCenter();
			
			addEventListener(Event.ENTER_FRAME, enterFrames);
		}
		
		private function showLeftRightMove():void
		{
			stopAllMoveAndWait();
			var i:int = 0;
			var arr:Array = new Array;
			var randomArr:Array = genRandomArr(_items.length);
			while (i < _items.length)
			{
				var mc:Sprite = _items[randomArr[i]] as Sprite;
				setRightRadom(mc);
				
				arr.push(mc);
				++i;
			}
			
			var duration:Number = 10;
			var numscreenW:uint = 2.;
			
			tweengroup = TweenGroup.allTo(arr, duration, {x: -stageWidth * numscreenW});
			tweengroup.align = TweenGroup.ALIGN_INIT; //same as ALIGN_START except that it honors any delay set in each tween.
			//tweengroup.progress = .0170;
			tweengroup.stagger = .1;
			clearTimeout(timeoutId);
			//timeoutId = setTimeout(showLeftRightMove,10000);
		}
		private var tweengroup:TweenGroup;
		
		private var pauseTimeId:uint;
		
		private function pauseCenter():void
		{
			clearTimeout(pauseTimeId);
			if (tweengroup)
				tweengroup.pause();
			pauseTimeId = setTimeout(resumeCenter, 6000);
			
			if (isDepthMove)
			{
				var mc:Sprite = theNestestPic;
				TweenLite.to(mc, 1, {x: stageWidth / 2, y: stageHeight / 2, z: -100 ,alpha :1});
			}
		}
		
		private var depMoveIndex:int = 0;
		private var leftMoveIndex:int = 0;
		private var isDepthMove:Boolean = false;
		
		private function resumeCenter():void
		{
			if (isDepthMove)
			{
				depMoveIndex++;
				if (depMoveIndex > 0)
				{
					depMoveIndex = 0;
					leftMoveIndex = 0;
					isDepthMove = false;
					showLeftRightMove();
				}
			}
			else
			{
				leftMoveIndex++;
				if (leftMoveIndex > 0)
				{
					depMoveIndex = 0;
					leftMoveIndex = 0;
					isDepthMove = true;
					showDepthMove();
				}
			}
			clearTimeout(pauseTimeId);
			if (tweengroup)
				TweenGroup(tweengroup).resume();
			pauseTimeId = setTimeout(pauseCenter, 4000);
		}
		
		private function stopAllMoveAndWait(fun:Function = null, wait:uint = 0):void
		{
			clearTimeout(timeoutId);
			if (tweengroup)
			{
				tweengroup.clear();
				tweengroup = null;
			}
			if (fun != null)
			{
				timeoutId = setTimeout(fun, wait);
			}
		}
		
		private function get theNestestPic():Sprite
		{
			var retmc:Sprite = null;
			for each (var mc:Sprite in _items)
			{
				if (retmc == null)
					retmc = mc;
				else if (getDistFromeCenter(retmc) > getDistFromeCenter(mc))
					retmc = mc;
				//else if (retmc.z > mc.z )retmc = mc;
			}
			return retmc;
		}
		
		private function getDistFromeCenter(mc:Sprite):int
		{
			var p:Point = mc.local3DToGlobal(new Vector3D(0, 0, 0));
			var dx:int = p.x - stageWidth / 2;
			var dy:int = p.y - stageHeight / 2;
			var dz:int = 0;// mc.z ;
			if (dz < 0 || Math.abs(dy) >= stageHeight / 2 - mc.height*.4)
				return 0xffffff;
			return Math.sqrt(dx * dx + dy * dy + dz * dz );
		}
		
		private static var timeoutId:uint;
		
		private function showDepthMove():void
		{
			stopAllMoveAndWait();
			var allArr:Array = new Array;
			var numOnceTime:uint = 8;
			var i:int = 0;
			var randomArr:Array = genRandomArr(_items.length);
			while (i < _items.length)
			{
				var mc:Sprite = _items[randomArr[i]] as Sprite;
				setDeepest(mc, i >= _items.length * .8);
				var yu:uint = uint(i % numOnceTime);
				allArr.push(mc);
				++i;
			}
			
			var duration:Number = 6;
			tweengroup = TweenGroup.allTo(allArr, duration, {z: -1000, alpha: 1, onComplete: hide()});
			tweengroup.align = TweenGroup.ALIGN_INIT; //same as ALIGN_START except that it honors any delay set in each tween.
			tweengroup.stagger = .1;
			//tweengroup.progress = 0.3;
			clearTimeout(timeoutId);
			//timeoutId = setTimeout(showDepthMove,10000);
		}
		
		private function hide(t:Sprite = null):void
		{
			if (t)
				t.alpha = 0;
		}
		
		public static function genRandomArr(num:uint):Array
		{
			var arr:Array = new Array(num);
			var i:int = 0;
			while (i < num)
			{
				arr[i] = i;
				++i;
			}
			i = 0;
			while (i < num)
			{
				var rad:int = Math.random() * num;
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
			for (var i:int = 0; i < _items.length; i++)
			{
				if (_items[i])
					_holder.addChildAt(_items[i] as Sprite, i);
			}
		}
		
		private function makeSprite():Sprite
		{
			var s:Sprite = new Sprite();
			s.graphics.beginFill(0xffffff * Math.random()); //743x557
			s.graphics.drawRect(-743 / 2, -557 / 2, 743, 557);
			s.graphics.endFill();
			setDeepest(s);
			return s;
		}
		
		private var index:int = 0;
		
		private function setDeepest(s:Sprite, islast:Boolean = false):void
		{
			++index;
			if (index >= _items.length * 2)
				index = 0;
			s.scaleX = s.scaleY = stageWidth / 7680;
			s.x = (index % 5) / 4 * (stageWidth - s.width) + s.width / 2;
			s.y = (index % 10) / 9 * (stageHeight - s.height) * 3 + s.height / 2;
			switch (index % 4)
			{
				case 0: 
					s.x -= stageWidth;
					break;
				case 1: 
					s.x += stageWidth;
					break;
				case 2: 
					s.y -= stageHeight;
					break;
				case 3: 
					s.y += stageHeight;
					break;
			}
			s.z = 3000;
			s.alpha = 0.0;
			_holder.addChild(s);
		}
		
		private function setRightRadom(s:Sprite):void
		{
			++index;
			if (index > 2 * _items.length)
				index = 0;
			
			s.scaleX = s.scaleY = stageWidth / 7680;
			var tox:Number = stageWidth * 3;
			var toy:Number = (stageHeight - s.height) * (index % 5) / 4;
			var toz:Number = (4 - index % 3) / 4;
			s.alpha = toz;
			toz = (1 - toz) * 2000;
			s.x = tox;
			s.y = toy + s.height / 2;
			s.z = toz;
			_holder.addChild(s);
		}
		
		private function depthSort(objA:DisplayObject, objB:DisplayObject):int
		{
			if (objA == null || objB == null)
				return 0;
			if (objA.stage && objB.stage)
			{
				var posA:Vector3D = objA.transform.matrix3D.position;
				posA = _holder.transform.matrix3D.deltaTransformVector(posA);
				var posB:Vector3D = objB.transform.matrix3D.position;
				posB = _holder.transform.matrix3D.deltaTransformVector(posB);
				return posB.z - posA.z;
			}
			return 0;
		}
		
		private function enterFrames(e:Event):void
		{
			sortItems();
		}
	}
}

