/**
 * @file BtnMode.as
 *  set the a Sprite Object to BtnMode;
 * @author db0@qq.com
 * @version 1.0.1
 * @date 2015-04-08
 */
package
{
	import flash.filters.GlowFilter;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.display.Sprite;
	public class BtnMode
	{
		public function BtnMode()
		{
		}
		public static function setSpriteBtn(mc:Sprite):void
		{
			mc.mouseChildren = false;
			mc.buttonMode = true;
			mc.addEventListener(MouseEvent.MOUSE_DOWN,mouse_events);
			mc.addEventListener(MouseEvent.MOUSE_UP,mouse_events);
			mc.addEventListener(MouseEvent.MOUSE_OUT,mouse_events);
			mc.addEventListener(Event.REMOVED_FROM_STAGE,remove_events);
		}

		private static function remove_events(e:Event):void
		{
			var mc:Sprite = e.target as Sprite;
			if(mc){
				mc.removeEventListener(MouseEvent.MOUSE_DOWN,mouse_events);
				mc.removeEventListener(MouseEvent.MOUSE_UP,mouse_events);
				mc.removeEventListener(MouseEvent.MOUSE_OUT,mouse_events);
				mc.removeEventListener(Event.REMOVED_FROM_STAGE,remove_events);
			}
		}

		private static function mouse_events(e:MouseEvent):void
		{
			var mc:Sprite = e.target as Sprite;
			if(mc){
				switch(e.type)
				{
					case MouseEvent.MOUSE_DOWN:
						selectBtn(mc,true);
						break;
					case MouseEvent.MOUSE_UP:
					case MouseEvent.MOUSE_OUT:
						selectBtn(mc,false);
						break;
				}
			}
		}

		public static function selectBtn(mc:Sprite,b:Boolean=true):void
		{
			if(mc.numChildren > 1){
				mc.getChildAt(mc.numChildren-1).visible = !b;
			}else{
				if(b){
					mc.filters = [new GlowFilter(0x00)];
				}else{
					mc.filters = [];
				}
			}
		}
	}
}

