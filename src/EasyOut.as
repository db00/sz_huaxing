package
{
	import flash.display.Sprite;
	public class EasyOut
	{
		public function EasyOut()
		{
		}

		public static function alphaOutAndRemove(mc:Sprite,fun:Function=null,paras:Array=null):void {
			TweenLite.killTweensOf(mc);
			TweenLite.to(mc,1,{alpha:0,onComplete:fun,onCompleteParams:paras});
		}
		public static function alphaIn(mc:Sprite,fun:Function=null,paras:Array=null):void {
			TweenLite.killTweensOf(mc);
			TweenLite.from(mc,1,{alpha:0,onComplete:fun,onCompleteParams:paras});
		}
	}
}
