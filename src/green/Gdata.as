package green
{
	
	public class Gdata
	{
		public static const rootPath:String = "绿色环保";
		
		public static const btns0:Array = ["天更蓝", "水更清", "更友好"];
		public static const btns10:Array = ["一次处理", "二次处理", "深度处理"];
		public static const btns11:Array = ["纯水回收", "废水处理", "人工湿地", "雨水回收"];
		public static const btns12:Array = ["新能源", "新技术", "减量化", "资源化"];
		
		//init("绿色环保/"+btns0[0]+"/"+btns10[0]);
		public static var dir0:String = "天更蓝";
		public static var dir1:String = "一次处理";
		
		public static function get curDir():String //当前图片文件夹
		{
			return rootPath + "/" + dir0 + "/" + dir1 + "/";
		}
		
		/**
		 *
		 * @param	d1	一级目录序号
		 * @param	d2	二级目录序号
		 * @return
		 */
		public static function dir(d1:int, d2:int):String
		{
			if (d1 >= 0 && d2 >= 0)
			{
				return rootPath + "/" + btns0[d1] + "/" + Gdata["btns1" + d1][d2] + "/";
			}
			else if (d1 >= 0)
			{
				return rootPath + "/" + btns0[d1] + "/";
			}
			return rootPath + "/";
		}
		
		public static function get curColorUrl():String //当前图片文件
		{
			return rootPath + "/" + dir0 + "/" + dir1 + ".png";
		}
		
		public static function get Dir0():String //根目录
		{
			return rootPath + "/";
		}
		
		public static function get Dir1():String //天更蓝
		{
			return rootPath + "/" + btns0[0] + "/";
		}
		
		public static function get Dir2():String //水更清
		{
			return rootPath + "/" + btns0[1] + "/";
		}
		
		public static function get Dir3():String //更友好
		{
			return rootPath + "/" + btns0[2] + "/";
		}
	}
}

