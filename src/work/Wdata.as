package work
{
	public class Wdata
	{

		private static var _IP:String;
		public static function get IP():String
		{
			if(_IP == null)
				_IP = SwfLoader.readfile("config.txt").replace(/[\r\n\s]/g,"").split(":")[0];
			return _IP;
		}
		public static var _port:uint = 0;
		public static function get port():uint
		{
			if(_port== 0)
				_port= SwfLoader.readfile("config.txt").replace(/[\r\n\s]/g,"").split(":")[1];
			return _port;
		}

		public static const dirArr:Array = ["视频会议","生产监控","全球数据"];

		public static function get url():String
		{
			return "http://"+IP+":"+port+"/";
		}
	}
}

