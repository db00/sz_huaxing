/**
 * @file MoveWithLines.as
 *  move the line to a position , add set the start and end point of the line
 * @author db0@qq.com
 * @version 1.0.1
 * @date 2015-04-15
 */
package
{
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	public class MoveWithLines extends Sprite
	{
		public var curObj:Node;
		public function MoveWithLines(pathArr:Array,pathArr2:Array=null)
		{
			CONFIG::debugging{
				x = 1000; y = 500;
			}
			CONFIG::PUBLISH{
				x = 690; y = 400;
			}
			var i:int = 0;
			if(pathArr){
				while(i<pathArr.length){
					var node:Node = new Node(new PhotoLoader(pathArr[i],315,315));
					node.name = "n"+i;
					node.addEventListener(Event.SELECT,shows);
					addChildAt(node,0);
					if(pathArr2){
						var txt:PhotoLoader = new PhotoLoader(pathArr2[i],239,131);
						txt.x = -txt.width;
						txt.y = -txt.height;
						node.addChild(txt);
					}
					++i;
				}
			}

			addEventListener(Event.ADDED_TO_STAGE,init);
		}

		public static function click_node(i:int):void
		{
			Node.click(i);
		}

		private function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE,init);
			stage.addEventListener(MouseEvent.MOUSE_DOWN,stageMouseEvents);
		}
		public function toleft():void {
			Node.moveLeft();
			dispatchEvent(new Event(Event.CHANGE));
		}
		public function toright():void {
			Node.moveRight();
			dispatchEvent(new Event(Event.CHANGE));
		}
		/**
		 * Ìøµ½³õÊ¼Î»ÖÃ
		 */
		public function toInit(e:Event=null):void
		{
			Node.toInit();
		}
		private static var mousex:int ;
		private function stageMouseEvents(e:Event):void{
			switch(e.type)
			{
				case MouseEvent.MOUSE_DOWN:
					stage.addEventListener(MouseEvent.MOUSE_UP,stageMouseEvents);
					stage.addEventListener(MouseEvent.MOUSE_MOVE,stageMouseEvents);
					mousex = stage.mouseX;
					break;
				case MouseEvent.MOUSE_MOVE:
					if(mousex - stage.mouseX > 50){
						stage.removeEventListener(MouseEvent.MOUSE_MOVE,stageMouseEvents);
						stage.removeEventListener(MouseEvent.MOUSE_UP,stageMouseEvents);
						CONFIG::NET{
							Tdata.sendData("left");
							return;
						}
						toleft();
					}else if(mousex - stage.mouseX < - 50){
						stage.removeEventListener(MouseEvent.MOUSE_MOVE,stageMouseEvents);
						stage.removeEventListener(MouseEvent.MOUSE_UP,stageMouseEvents);
						CONFIG::NET{
							Tdata.sendData("right");
							return;
						}
						toright();
					}else{
					}
					break;
				case MouseEvent.MOUSE_UP:
				case MouseEvent.MOUSE_OUT:
					stage.removeEventListener(MouseEvent.MOUSE_MOVE,stageMouseEvents);
					stage.removeEventListener(MouseEvent.MOUSE_UP,stageMouseEvents);
					break;
			}
		}

		public var selectedX:int;
		public var selectedY:int;
		private function shows(e:Event):void
		{
			curObj = e.target as Node;
			if(curObj){
				selectedX = x + curObj.x;
				selectedY = y + curObj.y;
				CONFIG::debugging{
					selectedX = x + curObj.x/5;
					selectedY = y + curObj.y/5;
				}
				logs.adds(curObj.name,selectedX,selectedY);
				dispatchEvent(new Event(Event.SELECT));
			}
		}
	}
}

import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.display.Bitmap;
import flash.display.BitmapData;
CONFIG::NET{
	import thing.*;
}
class Node extends Sprite
{
	private var leftLine:LineMove;
	private var leftLine2:LineMove;

	private var _rightObj:Node=null;
	public function get rightObj():Node {
		return _rightObj;
	}
	public function set rightObj(obj:Node):void {
		//if(_rightObj==null)
		_rightObj = obj;
	}
	private static var list:Array = null;

	public var curIndex:int = 0;
	public function Node(obj:DisplayObject=null,w:int=315,h:int=315)
	{
		if(leftLine==null){
			[Embed(source="thing/asset/xian1.png")] var  xian1png:Class;
			leftLine = new LineMove(new xian1png);
		}
		if(leftLine2==null){
			[Embed(source="thing/asset/xian2.png")] var  xian2png:Class;
			leftLine2 = new LineMove(new xian2png);
		}

		mouseChildren = false;
		buttonMode = true;
		var prevObj:Node;
		if(list==null){
			list = new Array;
		}else{
			prevObj = list[list.length-1] as Node;
		}
		var bg:Bitmap = (new Bitmap(new BitmapData(w,h,true,0xffffffff)));
		bg.visible = false;
		CONFIG::debugging{
			bg.visible = true;
		}
		ViewSet.center(bg,-1,-1,2,2);
		addChild(bg);
		if(obj){
			ViewSet.center(obj,-1,-1,2,2);
			addChild(obj);
		}
		addChild(leftLine);
		addChild(leftLine2);
		leftLine.mouseEnabled = false;
		leftLine2.mouseEnabled = false;
		selected = false;

		addEventListener(MouseEvent.MOUSE_DOWN,MouseEvents);

		if(prevObj){
			prevObj.rightObj = this;
			x = prevObj.x + gap;
			this.rightObj = list[0];
		}
		curIndex = list.length;
		list.push(this);

		showLeftLine();
		addEventListener(Event.ADDED_TO_STAGE,init);
	}
	private function init(e:Event=null):void
	{
		removeEventListener(Event.ADDED_TO_STAGE,init);
	}
	public static function get gap():int{
		return 900;
	}
	private function showLeftLine():void
	{
		if(Math.abs(x)<10){
			leftLine.visible = false;
			leftLine.alpha = 0;
			leftLine2.visible = false;
			leftLine2.alpha = 0;
		}else{
			leftLine.visible = true;
			leftLine.alpha = 1;
			leftLine2.visible = true;
			leftLine2.alpha = 1;
		}
	}
	public static function moveLeft():void
	{
		logs.adds("to left");
		var tweenlist:Array = new Array;
		for each(var obj:Node in list)
		{
			obj.selected = false;
			//obj.x -= gap;
			tweenlist.push(new TweenLite(obj,1,{x:obj.x-gap,onComplete:onComplete,onCompleteParams:[obj]}));
		}
		var myGroup:TweenGroup = new TweenGroup(tweenlist);
		myGroup.align = TweenGroup.ALIGN_INIT;
	}

	private static function onComplete(obj:Node):void
	{
		if(obj.x < 0){
			obj.x += gap*list.length;
			if(obj.parent)obj.parent.addChildAt(obj,0);
		}else if(obj.x >= gap*list.length){
			obj.x -= gap*list.length;
			if(obj.parent)obj.parent.addChild(obj);
		}
		obj.showLeftLine();
	}

	public static function moveRight():void
	{
		logs.adds("to right");
		var tweenlist:Array = new Array;
		for each(var obj:Node in list)
		{
			obj.selected = false;
			tweenlist.push(new TweenLite(obj,1,{x:obj.x+gap,onComplete:onComplete,onCompleteParams:[obj]}));
			//obj.x += gap;
		}
		var myGroup:TweenGroup = new TweenGroup(tweenlist);
		myGroup.align = TweenGroup.ALIGN_INIT;
	}
	public static function toInit(e:Event=null):void
	{
		for each(var obj:Node in list)
		{
			obj.x = gap * uint(obj.name.substr(1));
			obj.selected = false;
			obj.showLeftLine();
		}
	}
	private var selectedY:int = -50;

	//line end:
	private var y21:int = -20;
	private var y22:int = 80;

	public function set selected(b:Boolean):void {
		if(b){
			TweenLite.to(this,.5,{y:selectedY});
			//y = selectedY;
			if(Math.abs(x)>10)
			{
				TweenLite.to(leftLine,.5,{x1:-gap,y1:-selectedY,x2:0,y2:y21});
				TweenLite.to(leftLine2,.5,{x1:-gap,y1:-selectedY,x2:0,y2:y22});
			}
			//leftLine.setpos(-gap,-selectedY,0,0);
		}else{
			y = 0;
			leftLine.setpos(-gap,0,0,y21);
			leftLine2.setpos(-gap,0,0,y22);
		}
		if(rightObj)rightObj.leftSelect = b;
		showLeftLine();
	}
	public function set leftSelect(b:Boolean):void
	{
		if(b){
			y = 0;
			if(Math.abs(x)>10){
				TweenLite.to(leftLine,.5,{x1:-gap,y1:selectedY,x2:0,y2:y21});
				TweenLite.to(leftLine2,.5,{x1:-gap,y1:selectedY,x2:0,y2:y22});
			}
			//leftLine.setpos(-gap,selectedY,0,0);
		}else{
			y = 0;
			leftLine.setpos(-gap,0,0,y21);
			leftLine2.setpos(-gap,0,0,y22);
		}
	}
	public function get selected():Boolean {
		return y!=0;
	}
	public function get leftSelect():Boolean {
		return leftLine.y1 == selectedY;
	}
	private static var mousex:int ;
	private static var oldSelectedNode:Node;
	private function MouseEvents(e:Event):void{
		switch(e.type)
		{
			case MouseEvent.MOUSE_DOWN:
				addEventListener(MouseEvent.MOUSE_UP,MouseEvents);
				mousex = stage.mouseX;
				break;
			case MouseEvent.MOUSE_UP:
				if(mousex - stage.mouseX > 20 || mousex -stage.mouseX < -20){
				}else{
					CONFIG::NET{
						Tdata.sendData(String(curIndex+1));
						return;
					}
					click(curIndex);
				}
			case MouseEvent.MOUSE_OUT:
				removeEventListener(MouseEvent.MOUSE_UP,MouseEvents);
				break;
		}

	}

	public static function click(i:int):void
	{
		var target:Node = list[i] as Node;
		if(target){
			if(oldSelectedNode)
				oldSelectedNode.selected = false;
			target.selected = true;
			oldSelectedNode = target;
			target.dispatchEvent(new Event(Event.SELECT));
		}
	}
}

