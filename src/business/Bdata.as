package business
{
	import flash.display.Sprite;
	public class Bdata extends Sprite
	{
		public static var stageW:int = 1080;
		public static var stageH:int = 1920;
		private static var _rootPath:String;
		public static function get rootPath():String
		{
			if(_rootPath)
				return _rootPath;
			_rootPath = SwfLoader.rootPath + "购物橱窗/";
			return _rootPath;
		}
		private static var _btns0PathArr:Array;
		private static var _dirArr:Array;
		public static function get dirArr():Array//all dirs in cur rootPath
		{
			if(_dirArr)
				return _dirArr;
			_dirArr = SwfLoader.dirsInDir(rootPath,".*");
			return _dirArr;
		}
		public static function get btnsPathArr():Array//all first btns path Array
		{
			if(_btns0PathArr)
				return _btns0PathArr;
			for each(var dir:String in dirArr)
			{
				if(_btns0PathArr == null)
					_btns0PathArr = new Array();
				_btns0PathArr.push(SwfLoader.filesInDir(dir,SwfLoader.imgReg));
			}
			return _btns0PathArr;
		}

		public function Bdata()
		{
		}
	}
}

