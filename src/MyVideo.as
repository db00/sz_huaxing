/**
 * @file MyVideo.as
d:\flex_sdk_4.5\bin\amxmlc MyVideo.as --source-path=.
d:\flex_sdk_4.5\bin\FlashPlayerDebugger.exe MyVideo.swf
java -Duser.language=en -Duser.country=US -jar d:/flex_sdk_4.5/lib/mxmlc.jar +flexlib d:/flex_sdk_4.5/frameworks +configname=air MyVideo.as
 *  
 * @author db0@qq.com
 * @version 1.0.1
 * @date 2015-04-23
 */
/*

 */
package
{
	import flash.system.Capabilities;
	import flash.events.MouseEvent;
	import flash.events.*;
	import flash.events.IOErrorEvent;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;

	public class MyVideo extends Sprite
	{
		private var _soundTransform:SoundTransform = null;
		private var connection:NetConnection = null;
		private var stream:NetStream = null;
		private var video:Video = null;
		private var videoURL:String = "Video.flv";
		private var loop:Boolean = false;
		private var volume:Number = 1.0;
		private var w:int = 0;
		private var h:int = 0;
		private var client:CustomClient;

		public function MyVideo(url:String="http://*****.flv",loop:Boolean=false,volume:Number=1.0)
		{
			videoURL = url;
			this.loop = loop;
			this.volume = volume;

			client = new CustomClient();
			connection = new NetConnection();
			connection.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			connection.client= client;
			connection.connect(null);

			//addEventListener(Event.ENTER_FRAME,enterFrames);
		}

		public function setSize(w:int=0,h:int=0):void
		{
			if(w!=0)this.w = w;
			if(h!=0)this.h = h;
			//videoHeight
			if (video){
				if(w == 0)this.w = video.videoWidth;
				if(h == 0)this.h = video.videoHeight;
				width = this.w;
				height = this.h;
			}
		}

		public function get time():Number//播放头位置
		{
			if(stream)
				return stream.time;
			return 0;
		}
		public function get currentFPS():Number//每秒显示的帧的数目
		{
			if(stream)
				return stream.currentFPS;
			return 0;
		}
		public function get inBufferSeek():Boolean//指定显示的数据是否进行缓存以供智能搜索
		{
			return stream.inBufferSeek;
		}


		private function netStatusHandler(event:NetStatusEvent):void
		{
			logs.adds(event.info.code,event.toString());
			switch (event.info.code)
			{
				case "NetConnection.Connect.Success": 
					connectStream();
					break;
				case "NetStream.Play.StreamNotFound": 
					logs.adds("Unable to locate video: " + videoURL);
					break;
				case "NetStream.Play.Stop": 
					if(loop){
						play();
					}else{
						stop();
					}
					dispatchEvent(new Event(Event.COMPLETE));
					break;
				case "NetStream.Buffer.Full": 
					break;
				case "NetStream.Play.Start":
					logs.adds(video.videoWidth + " x " + video.videoHeight);
					logs.adds("info:",info);
					setSize(w,h);
					setVolum(volume);
					break;
				case "NetStream.Buffer.Flush":
					break;	
			}
			//dispatchEvent(new Event(""));
		}

		public function setVolum(volume:Number=1.0):void
		{
			this.volume = volume;
			if(_soundTransform == null)
				_soundTransform = new SoundTransform();
			_soundTransform.volume = volume;
			if(stream){
				stream.soundTransform = _soundTransform;
			}
		}


		public function get info():String
		{
			if(stream)
				return stream.info.toString();
			return null;
		}

		public function stop(e:Event=null):void
		{
			if(video){
				video.clear();
				video = null;
			}
			if(stream)
			{
				stream.close();//停止播放流上的所有数据，将 time 属性设置为 0，并使该流可用于其它用途。
				stream = null;
			}
			if(connection){
				connection.close();// 关闭本地打开的连接或到服务器的连接，并调度 code 属性值为 NetConnection.Connect.Closed 的 netStatus 事件。
				connection = null;
			}
		}
		public function play(e:Event=null):void
		{
			logs.adds("play");
			connectStream();
		}

		private function connectStream():void
		{
			if(video){
				video.clear();
			}
			if(stream){
				stream.close();//停止播放流上的所有数据，将 time 属性设置为 0，并使该流可用于其它用途。
				stream = null;
			}

			if(stream == null){
				stream = new NetStream(connection);
				stream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
				stream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
				stream.client = client;//回调方法以处理流或 F4V/FLV 文件数据的对象
			}

			if(video == null){
				video = new Video();
				video.smoothing = true;
				video.deblocking = 0;
			}

			video.attachNetStream(stream);
			stream.play(videoURL);
			addChild(video);
		}

		public function pause():void
		{
			if(stream)
				stream.pause();
		}

		public function resume():void
		{
			if(stream)
				stream.resume();
		}

		public function seek(offset:Number):void//搜索与指定位置最接近的关键帧（在视频行业中也称为 I 帧）。
		{
			if(stream)
				stream.seek(offset);
		}

		public function step(frames:int):void//前进或后退（相对于当前显示的帧）指定帧数的步骤。
		{
			if(stream)
				stream.step(frames);
		}

		public function togglePause():void//暂停或恢复流的回放。
		{
			if(stream)
				stream.togglePause();
		}


		private function securityErrorHandler(event:SecurityErrorEvent):void
		{
			logs.adds("securityErrorHandler: " + event);
		}

		private function asyncErrorHandler(event:AsyncErrorEvent):void
		{
			// ignore AsyncErrorEvent events.
		}

		public function get infoStr():String
		{
			/*
audioBufferByteLength : Number
[只读] 提供 NetStream 音频缓冲区大小，以字节为单位。 NetStreamInfo 
audioBufferLength : Number
[只读] 提供 NetStream 音频缓冲区大小，以秒为单位。 NetStreamInfo 
audioByteCount : Number
[只读] 指定已到达队列的音频字节总数，这与已播放或已刷新的字节数无关。 NetStreamInfo 
audioBytesPerSecond : Number
[只读] 指定填充 NetStream 音频缓冲区的速率，以每秒字节数为单位。 NetStreamInfo 
audioLossRate : Number
[只读] 指定 NetStream 会话的音频丢失。 NetStreamInfo 
byteCount : Number
[只读] 指定已到达队列的总字节数，这与已播放或已刷新的字节数无关。 NetStreamInfo 
constructor : Object
对类对象或给定对象实例的构造函数的引用。 Object 
currentBytesPerSecond : Number
[只读] 指定填充 NetStream 缓冲区的速率，以每秒字节数为单位。 NetStreamInfo 
dataBufferByteLength : Number
[只读] 提供 NetStream 数据缓冲区大小，以字节为单位。 NetStreamInfo 
dataBufferLength : Number
[只读] 提供 NetStream 数据缓冲区大小，以秒为单位。 NetStreamInfo 
dataByteCount : Number
[只读] 指定已到达队列的数据消息的字节总数，这与已播放或已刷新的字节数无关。 NetStreamInfo 
dataBytesPerSecond : Number
[只读] 指定填充 NetStream 数据缓冲区的速率，以每秒字节数为单位。 NetStreamInfo 
droppedFrames : Number
[只读] 返回在当前 NetStream 播放会话中放弃的视频帧数。 NetStreamInfo 
maxBytesPerSecond : Number
[只读] 指定填充 NetStream 缓冲区的最大速率，以每秒字节数为单位。 NetStreamInfo 
playbackBytesPerSecond : Number
[只读] 返回流的播放速率，以每秒字节数为单位。 NetStreamInfo 
prototype : Object
[静态] 对类或函数对象的原型对象的引用。 Object 
SRTT : Number
[只读] NetStream 会话的平滑往返行程时间 (SRTT)（以毫秒为单位）。 NetStreamInfo 
videoBufferByteLength : Number
[只读] 提供 NetStream 视频缓冲区大小，以字节为单位。 NetStreamInfo 
videoBufferLength : Number
[只读] 提供 NetStream 视频缓冲区大小，以秒为单位。 NetStreamInfo 
videoByteCount : Number
[只读] 指定已到达队列的视频字节总数，这与已播放或已刷新的字节数无关。 NetStreamInfo 
videoBytesPerSecond : Number
[只读] 指定填充 NetStream 视频缓冲区的速率，以每秒字节数为单位。 NetStreamInfo 
videoLossRate : Number
[只读] 提供 NetStream 视频损失率（丢失的消息与全部消息的比例）。 
			 */
			return stream.info.toString();
		}

		private function enterFrames(e:Event=null):void{
			if(time>0)logs.adds("time:",time);
		}
	}
}

class CustomClient {
	public var framerate:Number= 0;
	public var duration:Number = 0;
	public var width:Number= 0;
	public var height:Number= 0;
	public var time:Number= 0;
	public var type:String= null;
	public var name:String= null;
	/*
	// asyncError 在异步引发异常（即来自本机异步代码）时调度。 NetStream 
	public function asyncError(info:Object):void {
	logs.adds("asyncError:",info);
	}

	// [广播事件] Flash Player 或 AIR 应用程序失去操作系统焦点并变为非活动状态时将调度此事件。 EventDispatcher 
	public function deactivate(info:Object):void {
	logs.adds("deactivate:",info);
	}

	//在 NetStream 对象尝试播放使用数字权限管理 (DRM) 加密的内容（播放前需要用户凭据以进行身份验证）时调度。 NetStream 
	public function drmAuthenticate (info:Object):void {
	logs.adds("drmAuthenticate: ",info);
	}


	//drmError 在 NetStream 对象尝试播放数字权限管理 (DRM) 加密的文件的过程中遇到与 DRM 相关的错误时调度。 NetStream 
	public function drmError(info:Object):void {
	logs.adds("drmError:",info);
	}


	//在开始播放数字权限管理 (DRM) 加密的内容时（如果已对用户进行身份验证并授权播放该内容）调度。 NetStream 
	public function drmStatus (info:Object):void {
	logs.adds("drmStatus :",info);
	}


	//在出现输入或输出错误并导致网络操作失败时调度。 NetStream 
	public function ioError (info:Object):void {
	logs.adds("ioError: ",info);
	}

	//netStatus 在 NetStream 对象报告其状态或错误条件时调度。 NetStream 
	public function netStatus (info:Object):void {
	logs.adds("netStatus:",info);
	}


	//建立一个侦听器，以便在 AIR 提取媒体文件中嵌入的 DRM 内容元数据时作出响应。 NetStream 
	public function onDRMContentData (info:Object):void {
	logs.adds("onDRMContentData :",info);
	}

	//在 Flash Player 以字节数组形式接收到正在播放的媒体文件中嵌入的图像数据时建立侦听器进行响应。 NetStream 
	public function onImageData (info:Object):void {
	logs.adds("onImageData :",info);
	}

	//onPlayStatus 在 NetStream 对象已完全播放流时建立侦听器进行响应。 NetStream 
	public function onPlayStatus (info:Object):void {
	logs.adds("onPlayStatus :",info);
	}

	//onSeekPoint 当追加字节分析程序遇到一个它认为是可搜索的点（例如，视频关键帧）时从 appendBytes() 同步调用。 NetStream 
	public function onSeekPoint (info:Object):void {
	logs.adds("onSeekPoint :",info);
	}

	//在 Flash Player 接收到正在播放的媒体文件中嵌入的文本数据时建立侦听器进行响应。 NetStream 
	public function onTextData(info:Object):void {
	logs.adds("onTextData:",info);
	}


	//onXMPData 建立一个侦听器，以便在 Flash Player 接收到特定于正在播放的视频中嵌入的 Adobe 可扩展元数据平台 (XMP) 的信息时进行响应。 NetStream 
	public function onXMPData (info:Object):void {
	logs.adds("onXMPData :",info);
	}

	//status 在应用程序尝试通过调用 NetStream.play() 方法播放用数字权限管理 (DRM) 加密的内容时调度。 
	public function status(info:Object):void {
		logs.adds("status:",info);
	}
	*/

		/*
		 *  onMetaData 在 Flash Player 接收到正在播放的视频中嵌入的描述性信息时建立侦听器进行响应。 NetStream 
		 */
		public function onMetaData(info:Object):void {
			logs.adds("metadata: duration=" + info.duration + " width=" + info.width + " height=" + info.height + " framerate=" + info.framerate);
			logs.adds("metadata: " , info);
			duration = info.duration;
			width = info.width;
			height = info.height;
			framerate = info.framerate;

		}
	/**
	 * 在播放视频文件期间到达嵌入提示点时建立侦听器进行响应。 NetStream 
	 */
	public function onCuePoint(info:Object):void {
		logs.adds("cuepoint: time=" + info.time + " name=" + info.name + " type=" + info.type);
		time = info.time;
		type = info.type;
		name = info.name;
	}
}

