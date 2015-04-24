package thing 
{
	public class Tdata
	{
		public static const stageW:uint = 7680;
		public static const stageH:uint = 1080;

		public static function get rootPath():String
		{
			return "大事记/";
		}

		public static var windowIndex:uint = 0;


		CONFIG::NET{
			private static var _addressArr:Array=null;
			public static function get addressArr():Array
			{
				if(_addressArr==null){
					var arr:Array = SwfLoader.readfile("config.txt").split(/[\r\n]/);
					for each(var s:String in arr)
					{
						if(s && s.length>8)
						{
							var a:Array = s.split(":");
							if(a && a.length==2){
								if(_addressArr==null)
									_addressArr = new Array;
								_addressArr.push({ip:a[0],port:a[1]});
							}
						}
					}
				}
				return _addressArr ; 
			}

			public static function sendData(s:String):void
			{
				if(s && s.length>0)
				{
					if(_addressArr && _addressArr.length == 4)
					{
						for each(var o:Object in _addressArr)
						{
							SwfLoader.loadData("http://"+o.ip + ":" + o.port+"/"+s);
						}
					}
				}
			}
		}

	}
}
