/**
 * @file HttpServer.as
 *  
 * @author db0@qq.com
 * @version 1.0.1
 * @date 2015-04-03


 how to use:
 var httpserver:HttpServer = new HttpServer(1300);
 httpserver.addEventListener(HttpServer.DATA,data_recved);
 private function data_recved(e:Event):void
 {
 trace(e.target.data);
 }







 */
package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.ServerSocketConnectEvent;
	import flash.net.ServerSocket;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.desktop.NativeApplication;

	public class HttpServer extends Sprite
	{
		private var serverSocket:ServerSocket;
		public static const DATA:String = "__daterecvd__";
		public var data:String;
		private var port:uint;
		public function HttpServer(port:uint=8080)
		{
			this.port = port;
			//this.stage.nativeWindow.activate();
			addEventListener(Event.ADDED_TO_STAGE,init);
		}

		private function closeAll(e:Event):void
		{
			logs.adds("close Socket",e);
			removeEventListener(Event.REMOVED_FROM_STAGE,closeAll);
			if(serverSocket && serverSocket.bound) 
			{
				serverSocket.close();
			}
			serverSocket = null;
			if(stage)
				stage.nativeWindow.removeEventListener(Event.CLOSE,closeAll);
		}

		private function onConnect( event:ServerSocketConnectEvent ):void
		{
			var clientSocket:Socket = event.socket as Socket;
			clientSocket.addEventListener( ProgressEvent.SOCKET_DATA, onClientSocketData );
			logs.adds( "Connection from " + clientSocket.remoteAddress + ":" + clientSocket.remotePort );
		}

		private function onClientSocketData( e:ProgressEvent):void
		{
			var clientSocket:Socket = e.target as Socket;
			var buffer:ByteArray = new ByteArray();
			clientSocket.readBytes( buffer, 0, clientSocket.bytesAvailable );
			var s:String = buffer.toString();
			var data_arr:Array = s.split("\r\n\r\n");
			if(data_arr && data_arr.length > 0){
				data = String(data_arr[0].replace(/[\r\n]/img,"").replace(/(GET|POST)\s+([^\s]+)\s+HTTP.*/im,"$2"));
				dispatchEvent(new Event(DATA));
			}
			send(clientSocket,s);
		}

		private function bind(port:uint):void
		{
			if(serverSocket && serverSocket.bound) 
			{
				serverSocket.close();
			}
			serverSocket = new ServerSocket();
			try{
				serverSocket.bind(port,"0.0.0.0");
			}catch(e:Error){
				logs.adds(e);
				serverSocket.bind( 0, "0.0.0.0" );
			}
			serverSocket.addEventListener( ServerSocketConnectEvent.CONNECT, onConnect );
			serverSocket.listen();
			logs.adds( "Bound to: " + serverSocket.localAddress + ":" + serverSocket.localPort );
		}

		public function send(clientSocket:Socket,s:String):void
		{
			try
			{
				if( clientSocket != null && clientSocket.connected )
				{
					clientSocket.writeUTFBytes(s);
					clientSocket.flush(); 
					logs.adds( "Sent message to " + clientSocket.remoteAddress + ":" + clientSocket.remotePort );
					clientSocket.close();
				} else {
					logs.adds("No socket connection.");
				}
			}
			catch ( error:Error )
			{
				logs.adds( error.message );
			}
		}
		private function init(e:Event=null):void{
			addEventListener(Event.REMOVED_FROM_STAGE,closeAll);
			stage.nativeWindow.addEventListener(Event.CLOSE,closeAll);
			NativeApplication.nativeApplication.addEventListener(Event.EXITING,closeAll);
			bind(port);
		}
	}
}

