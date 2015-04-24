/**
  o
  /home/libiao/flex_sdk_4.5/bin/mxmlc Carousel.as 
 * @file Carousel.as
 *  
 * @author db0@qq.com
 * @version 1.0.1
 * @date 2015-04-04
 */
package
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.net.URLRequest;
	import flash.utils.Timer;

	public class Carousel extends Sprite
	{
		private var _holder:demo3d;
		private var _items:Array;
		private var _radius:Number = 100;
		private var _numItems:int;
		private var _angle:Number;

		private var shiftTime:Number = 100;
		private var pwidth:Number = 500;
		private var onceTime:Number = 100;
		private var listX:Number = 0;
		private var speed:Number = 10;

		private var numcol:int = 4;
		private var curIndex:int = 0;

		//计时器,
		private var timer:Timer = new Timer(30);
		private var counter:int = 0;

		private var pathArr:Array;

		public function Carousel(pathArr:Array=null)
		{
			this.pathArr = pathArr;
			addEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, removes);
		}

		private function removes(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, removes);
			timer.removeEventListener(TimerEvent.TIMER, onEnterFrames);
			timer.stop();
			trace("xxxxxxxxxxxxxx");
			ViewSet.removes(this);
		}

		public function addEvent():void
		{
			if (timer.running == false ) timer.start();
			timer.addEventListener(TimerEvent.TIMER, onEnterFrames);
		}

		public function removeEvent():void
		{
			timer.removeEventListener(TimerEvent.TIMER, onEnterFrames);
		}

		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			trace("**********c*************");
			//root.transform.perspectiveProjection.fieldOfView = 120;
			//root.transform.perspectiveProjection.focalLength = 1000;
			//root.transform.perspectiveProjection.projectionCenter = new Point(stage.stageWidth/2,stage.stageHeight/2);

			_holder = new demo3d();
			//_holder.x = stage.stageWidth / 2;
			_holder.y = stage.stageHeight / 2 + pwidth/2/2;
			_holder.zz = 0;
			addChild(_holder);

			_items = new Array();
			_numItems = pathArr.length;

			addEvent();

			_angle = Number(Math.PI * 2 / _numItems * numcol);

			loadPic();
			sortItems();
		}



		private function loadPic():void
		{
			//trace("------");
			if (curIndex < pathArr.length) {
				var loaders:Loader = new Loader();
				loaders.load(new URLRequest(pathArr[curIndex]));
				trace(pathArr[curIndex]);
				loaders.contentLoaderInfo.addEventListener(Event.COMPLETE, loadeds);
			}else {

			}
		}

		private function loadeds(e:Event):void 
		{
			e.target.removeEventListener(Event.COMPLETE, loadeds);

			var photo:Bitmap = e.target.content as Bitmap;
			var angle:Number = Number(_angle * curIndex) ;
			var item:demo3d = makeItem();

			item.y = Math.cos(angle) * _radius;
			item.zz = Math.sin(angle) * _radius*4;

			//item.x =   curIndex * ((stage.stageWidth -pwidth/2) / _numItems) -stage.stageWidth / 2+pwidth + listX;
			item.x =   curIndex * ((7680)/(pathArr.length-1));

			//trace(photo.width,photo.height);
			_items.push(item);
			item.name = "p" + curIndex;
			item.addChild(photo);

			var scalex:Number = pwidth / photo.width;
			var scaley:Number = pwidth / photo.height;
			var scale:Number = Math.min(scalex, scaley);
			photo.smoothing = true;
			photo.scaleX = photo.scaleY = scale;
			photo.y = photo.x = -pwidth / 2;


			[Embed(source="staff/bord.png")] var  bordpng:Class;
			var bordbmp:Bitmap = new bordpng;
			bordbmp.smoothing = true;
			bordbmp.width = photo.width*.98;
			bordbmp.height = photo.height*.98;
			bordbmp.x = photo.x+photo.width*.01;
			bordbmp.y = photo.y+photo.height*.01;
			item.addChild(bordbmp);


			//item.alpha = Math.abs(Number(angle*180/Math.PI % 360 -180) / 180) + .1;

			//trace(angle,"------------",item.alpha);
			curIndex++;
			loadPic();
		}


		private function makeItem():demo3d
		{
			var item:demo3d = new demo3d();
			//item.graphics.beginFill(Math.random() * 0xffffff);
			item.graphics.drawRect(-pwidth/2, -pwidth/2, pwidth, pwidth);
			_holder.addChild(item);
			return item;
		}

		private function sortItems():void
		{
			//_items.sort(depthSort);
			_items.sortOn("zz", Array.NUMERIC | Array.DESCENDING);
			for(var i:int = 0; i < _items.length; i++)
			{
				_holder.addChildAt(_items[i] as demo3d, i);
			}
		}

		private function depthSort(objA:DisplayObject, objB:DisplayObject):int
		{
			var posA:Vector3D = objA.transform.matrix3D.position;
			posA = _holder.transform.matrix3D.deltaTransformVector(posA);
			var posB:Vector3D = objB.transform.matrix3D.position;
			posB = _holder.transform.matrix3D.deltaTransformVector(posB);
			return posB.z - posA.z;
		}

		private var deltaAngle:Number = 0;
		private var curState:int = 6;
		private var perNum:int;
		private function onEnterFrames(event:Event):void
		{
			counter++;
			var loop:int = counter % (25 *60*10);

			deltaAngle-= .03;

			if (deltaAngle >= 2*Math.PI)
				deltaAngle = 0;
			if (deltaAngle < 0)
				deltaAngle += 2*Math.PI;

			var angle:Number;
			for (var i:int = 0; i < _items.length; i++) 
			{
				var item:demo3d = _holder.getChildByName("p"+i) as demo3d;

				angle = Number((Math.PI/2*2 + Math.PI*2 / _numItems)  * i)  + deltaAngle;
				//angle = -angle;

				item.y = Math.cos(angle) * _radius;
				item.zz = Math.sin(angle) * _radius * 4;


				item.x -= 3;if(item.x <= -item.width)item.x = pathArr.length * ((7680)/(pathArr.length-1)) - pwidth;//stage.stageWidth;

				var blur:Number = (4 -(_radius * 4 - item.zz) / _radius);


				item.filters = [new BlurFilter(blur, blur)];
				item.alpha = (_radius * 4 - item.zz) / _radius + .3;
				item.scaleX = item.scaleY = ((_radius * 4 - item.zz) / _radius + .3)/5+.4//_radius - item.zz;
			}

			//trace(_radius,angle);
			sortItems();
			return;

			////DNA -> 绕x轴
			//timer.removeEventListener(TimerEvent.TIMER, onEnterFrames);
			//perNum = int(_items.length / curState++);
			//if (curState >= 10) curState = 6;
			//
			//
			//trace(_items.length, perNum);
			//
			//for (i = 0; i < _items.length; i++) 
			//{
			//item = _holder.getChildByName("p" + i) as demo3d;
			//
			//angle = Number(( Math.PI * 2 / perNum)  * i);
			//
			//stateArr[i] = { x:item.x, y:item.y, z:item.zz, alpha:item.alpha, scale:item.scaleX, blur:blur};
			//
			//var xx:int//=int(i/6)*100;
			//var yy:int = Math.cos(angle) * _radius;
			//var zz:int = Math.sin(angle) * _radius * 4;
			//
			//var alp:Number = (_radius * 4 - zz) / _radius + .3;
			//var scal:Number = ((_radius * 4 - zz) / _radius + .3) / 5 + .4;
			//blur = (4 -(_radius * 4 - zz) / _radius);
			//
			//item.filters = [];
			//
			//TweenLite.to(item,shiftTime,{/*x:xx,*/y:yy,zz:zz,alpha:alp,scaleX:scal,scaleY:scal,onComplete:state2});
			//}
		}

		/*
		   private function state2():void 
		   {
		   sortItems();
		   deltaAngle = 0;
		   counter = 0;
		   timer.addEventListener(TimerEvent.TIMER, onEnterFrames2);
		   }

		   private function state1():void 
		   {
		   sortItems();
		   deltaAngle = 0;
		   counter = 0;
		   timer.addEventListener(TimerEvent.TIMER, onEnterFrames);
		   }

		   private function state3():void 
		   {
		   sortItems();
		   deltaAngle = 0;
		   counter = 0;
		   timer.addEventListener(TimerEvent.TIMER, onEnterFrames3);
		   }

		   private function state4():void 
		   {
		   sortItems();
		   deltaAngle = 0;
		   counter = 0;
		   timer.addEventListener(TimerEvent.TIMER, onEnterFrames4);
		   }
		 */

		/*

		   private function onEnterFrames2(e:TimerEvent):void 
		   {
		//trace(deltaAngle);
		counter++;
		var loop:int = counter % (25 *60*10);
		if (true || loop < 25*onceTime){//绕x轴

		deltaAngle += .0023 * speed;
		if (deltaAngle >= 2*Math.PI)
		deltaAngle = 0;

		for (var i:int = 0; i < _items.length; i++) 
		{
		var item:demo3d = _holder.getChildByName("p" + i) as demo3d;
		var angle:Number = Number(( Math.PI * 2 / perNum)  * i) + deltaAngle;


		//var xx:int=int(i/6)*100;
		var yy:int = Math.cos(angle) * _radius;
		var zz:int = Math.sin(angle) * _radius * 4;
		var blur:Number = (4 -(_radius * 4 - zz) / _radius);

		var alp:Number = (_radius * 4 - zz) / _radius + .3;
		var scal:Number = ((_radius * 4 - zz) / _radius + .3) / 5 + .4;

		item.filters = [new BlurFilter(blur, blur)];

		//item.x--; if(item.x<-item.width) item.x = stage.stageWidth;
		item.y = yy;
		item.zz = zz;
		item.alpha = alp;
		item.scaleX = item.scaleY = scal;
		}
		sortItems();
		return;
		}else {//->绕x轴 *3
		//timer.removeEventListener(TimerEvent.TIMER, onEnterFrames2);
		//perNum = int(_items.length / 7);
		//
		//trace(_items.length, perNum);
		//
		//for (i = 0; i < _items.length; i++) 
		//{
		//item = _holder.getChildByName("p" + i) as demo3d;
		//
		//angle = Number((Math.PI/2*2 + Math.PI*2 / _numItems)  * i);
		//
		//stateArr[i] = { x:item.x, y:item.y, z:item.zz, alpha:item.alpha, scale:item.scaleX, blur:blur};
		//
		//yy = Math.cos(angle) * _radius;
		//var line:int = i % 3;
		//
		//var xx:int=int(i/6)*100;
		//
		//yy = Math.cos(angle) * _radius;
		//
		//if (line == 0) {
		//yy = Math.cos(angle) * _radius-100;
		//}
		//
		//if (line == 2 ) {
		//yy = Math.cos(angle) * _radius+100;
		//}
		//
		//zz = Math.sin(angle) * _radius * 4;
		//
		//alp = (_radius * 4 - zz) / _radius + .3;
		//scal = ((_radius * 4 - zz) / _radius + .3) / 5 + .4;
		//blur = (4 -(_radius * 4 - zz) / _radius);
		//
		//item.filters = [];
		//
		//TweenLite.to(item,shiftTime,{y:yy,zz:zz,alpha:alp,scaleX:scal,scaleY:scal,onComplete:state3});
		//}





		//->绕x轴 *3
		timer.removeEventListener(TimerEvent.TIMER, onEnterFrames2);
		//perNum = int(_items.length / 7);

		//trace(_items.length, perNum);

		++numLines;
		if (numLines > 4) numLines = 3;

		for (i = 0; i < _items.length; i++) 
		{
			item = _holder.getChildByName("p" + i) as demo3d;



			angle = Number((Math.PI/(numLines)*2 + Math.PI*2 / _numItems)  * i);

			//stateArr[i] = { x:item.x, y:item.y, z:item.zz, alpha:item.alpha, scale:item.scaleX, blur:blur};

			yy = Math.cos(angle) * _radius;
			zz = Math.sin(angle) * _radius * 4;

			alp = (_radius * 4 - zz) / _radius + .3;
			scal = ((_radius * 4 - zz) / _radius + .3) / 5 + .4;
			blur = (4 -(_radius * 4 - zz) / _radius);

			item.filters = [];

			TweenLite.to(item, shiftTime, {y:yy, zz:zz, alpha:alp, scaleX:scal, scaleY:scal, onComplete:state4 } );
		}
	}
	}
	*/

		/*
		   private function onEnterFrames3(e:TimerEvent):void // * 3条相错
		   {
		//trace(deltaAngle);
		counter++;
		var loop:int = counter % (25 *60*10);
		if (loop < 25*onceTime){//绕x轴 *3

		deltaAngle += .0023 * speed;
		if (deltaAngle >= 2*Math.PI)
		deltaAngle = 0;

		for (var i:int = 0; i < _items.length; i++) 
		{
		var item:demo3d = _holder.getChildByName("p" + i) as demo3d;
		var angle:Number = Number((Math.PI/2*2 + Math.PI*2 / _numItems)  * i) + deltaAngle;

		var line:int = i % 3;

		//var xx:int=int(i/6)*100;

		var yy:int = Math.cos(angle) * _radius;

		if (line == 0) {
		yy = Math.cos(angle) * _radius-100;
		}

		if (line == 2 ) {
		yy = Math.cos(angle) * _radius+100;
		}

		var zz:int = Math.sin(angle) * _radius * 4;
		var blur:Number = (4 -(_radius * 4 - zz) / _radius);

		var alp:Number = (_radius * 4 - zz) / _radius + .3;
		var scal:Number = ((_radius * 4 - zz) / _radius + .3) / 5 + .4;

		item.filters = [new BlurFilter(blur, blur)];

		//item.x = xx;
		item.y = yy;
		item.zz = zz;
		item.alpha = alp;
		item.scaleX = item.scaleY = scal;
		}
		sortItems();
		return;
		}else {//->绕x轴 *3
		timer.removeEventListener(TimerEvent.TIMER, onEnterFrames3);
		//perNum = int(_items.length / 7);

		//trace(_items.length, perNum);

		++numLines;
		if (numLines > 4) numLines = 3;

		for (i = 0; i < _items.length; i++) 
		{
		item = _holder.getChildByName("p" + i) as demo3d;



		angle = Number((Math.PI/(numLines)*2 + Math.PI*2 / _numItems)  * i);

		//stateArr[i] = { x:item.x, y:item.y, z:item.zz, alpha:item.alpha, scale:item.scaleX, blur:blur};

		yy = Math.cos(angle) * _radius;
		zz = Math.sin(angle) * _radius * 4;

		alp = (_radius * 4 - zz) / _radius + .3;
		scal = ((_radius * 4 - zz) / _radius + .3) / 5 + .4;
		blur = (4 -(_radius * 4 - zz) / _radius);

	item.filters = [];

	TweenLite.to(item,shiftTime,{y:yy,zz:zz,alpha:alp,scaleX:scal,scaleY:scal,onComplete:state4});
	}
	}
	}


	private var numLines:int = 3;
	private function onEnterFrames4(e:TimerEvent):void //3*1
		{
			//trace(deltaAngle);
			counter++;
			var loop:int = counter % (25 *60*10);
			if (loop < 25*onceTime*2){ //绕x轴 *3条

				deltaAngle += .0023 * speed;
				if (deltaAngle >= 2*Math.PI)
					deltaAngle = 0;

				for (var i:int = 0; i < _items.length; i++) 
				{
					var item:demo3d = _holder.getChildByName("p" + i) as demo3d;
					var angle:Number = Number((Math.PI/numLines*2 + Math.PI*2 / _numItems)  * i) + deltaAngle;

					var line:int = _items.length / 3;

					//var xx:int=int(i/6)*100;

					var yy:int = Math.cos(angle) * _radius;

					var zz:int = Math.sin(angle) * _radius * 4;
					var blur:Number = (4 -(_radius * 4 - zz) / _radius);

					var alp:Number = (_radius * 4 - zz) / _radius + .3;
					var scal:Number = ((_radius * 4 - zz) / _radius + .3) / 5 + .4;

					item.filters = [new BlurFilter(blur, blur)];

					//item.x = xx;
					item.y = yy;
					item.zz = zz;
					item.alpha = alp;
					item.scaleX = item.scaleY = scal;
				}
				sortItems();
				return;
			}else {//->DNA
				timer.removeEventListener(TimerEvent.TIMER, onEnterFrames4);
				//perNum = int(_items.length / 7);

				//trace(_items.length, perNum);

				for (i = 0; i < _items.length; i++) 
				{
					item = _holder.getChildByName("p" + i) as demo3d;

					angle = Number((Math.PI/2*2 + Math.PI*2 / _numItems)  * i);

					//stateArr[i] = { x:item.x, y:item.y, z:item.zz, alpha:item.alpha, scale:item.scaleX, blur:blur};

					yy = Math.cos(angle) * _radius;
					zz = Math.sin(angle) * _radius * 4;

					alp = (_radius * 4 - zz) / _radius + .3;
					scal = ((_radius * 4 - zz) / _radius + .3) / 5 + .4;
					blur = (4 -(_radius * 4 - zz) / _radius);

					item.filters = [];

					TweenLite.to(item,shiftTime,{y:yy,zz:zz,alpha:alp,scaleX:scal,scaleY:scal,onComplete:state1});
				}
			}
		}
	*/
	}
}

import flash.display.Sprite;
class demo3d extends Sprite
{
	public var zz:int = 0;
}
