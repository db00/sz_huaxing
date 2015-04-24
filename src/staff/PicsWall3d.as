/**

d:/flex_sdk_4.5/bin/amxmlc PicsWall3d.as && d:/flex_sdk_4.5/bin/FlashPlayerDebugger.exe PicsWall3d.swf
 * @file PicsWall3d.as
 *  a 3d picture wall
 * @author db0@qq.com
 * @version 1.0.1
 * @date 2015-04-16
 */
package staff
{
	import flash.display.DisplayObject;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Vector3D;
	import gs.easing.*;


	[SWF(width=800, height=800, backgroundColor = 0xffffff)]
		public class PicsWall3d extends Sprite
		{
			private var _holder:Sprite;
			private var _items:Array;
			private var _radius:Number = 3840/2;
			private var pathArr:Array = null;
			private var numPerLevel:uint = 2;
			private function makeNumLevel():uint
			{
				var numPerLevel:uint;
				numPerLevel	= (1-.5*Math.random())*pathArr.length;
				return numPerLevel;
			}

			public function PicsWall3d(pathArr:Array=null)
			{
				this.pathArr = pathArr;
				if(stage) init();
				else addEventListener(Event.ADDED_TO_STAGE,init);
			}
			private function init(e:Event=null):void
			{
				removeEventListener(Event.ADDED_TO_STAGE,init);
				//stage.align = StageAlign.TOP_LEFT;
				//stage.scaleMode = StageScaleMode.NO_SCALE;
				root.transform.perspectiveProjection.fieldOfView = 30;
				_holder = new Sprite();
				//_holder.x = stage.stageWidth / 2;
				//_holder.y = stage.stageHeight / 2;
				//_holder.x = 743/ 2;
				//_holder.y = 557/ 2;
				//_holder.z = 0;
				addChild(_holder);

				_items = new Array();

				//_radius = 200;
				for(var i:int = 0; i < pathArr.length; i++)
				{
					var item:Sprite = new PhotoLoader(pathArr[i],743,557);
					_holder.addChild(item);
					//item.z = i * _radius;
					fromFar(item,fromFar,[item,fromFar]);
					/*
					   var angle:Number = Math.PI * 2 / pathArr.length* i;
					   item.x = Math.cos(angle) * _radius;
					   item.z = Math.sin(angle) * _radius;
					   item.rotationY = -360 / pathArr.length * i + 90;
					 */
					_items.push(item);
				}
				//sortItems();

				addEventListener(Event.ENTER_FRAME, onEnterFrame);
			}

			private function sortItems():void
			{
				_items.sort(depthSort);
				for(var i:int = 0; i < _items.length; i++)
				{
					_holder.addChildAt(_items[i] as Sprite, i);
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


			private function onEnterFrame(event:Event):void
			{
				return;
				_holder.z -=10;
				if(_holder.z < -_radius*pathArr.length)
					_holder.z = 0;
				var i:int = 0;
				while(i<_holder.numChildren)
				{
					var obj:Sprite = _holder.getChildAt(i) as Sprite;
					if(obj){
						if(_holder.z + obj.z<0)
							obj.visible = false;
						else
							obj.visible = true;
					}
					++i;
				}
				_holder.rotationY += (stage.stageWidth / 2 - mouseX) * .01;
				_holder.y += (mouseY - _holder.y) * .1;
				//sortItems();
			}

			private function fromFar(mc:Sprite=null,onComplete:Function=null,onCompleteParams:Array=null):void
			{
				if(mc==null)return;
				var stageWidth:int = 7680;
				var stageHeight:int = 1080;
				mc.scaleX = mc.scaleY = .1;
				mc.z = _radius;
				ViewSet.center(mc,stageWidth/2-1,stageHeight/2-1,2,2);
				var tox:Number = Math.random()*2-1;
				var toy:Number = Math.random()*2-1;
				if(tox<=0) tox = stageWidth*tox - mc.width/mc.scaleX;
				if(tox>0) tox = stageWidth*(1+tox);
				if(toy<=0) toy = stageHeight*toy - mc.height/mc.scaleY;
				if(toy>0) toy = stageHeight*(1+toy);
				TweenLite.to(mc,5.,{z:0,x:tox,y:toy,scaleX:1.0,scaleY:1.0,ease:Linear.easeNone,onComplete:onComplete,onCompleteParams:onCompleteParams});
			}
		}
}

