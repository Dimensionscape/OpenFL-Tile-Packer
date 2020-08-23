package  {
	import flash.utils.ByteArray;
	import flash.events.Event;
	import flash.system.LoaderContext;
	import flash.display.LoaderInfo;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.BitmapData;
	import starling.textures.Texture;
	import starling.display.Button;
	
	public class AssetUtils {
		
		public static function loadImageData(data:ByteArray, filename:String, callback:Function):void{
			var imageLoader: Loader = new Loader();
				imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, __onImageLoaderComplete(callback, filename));
				var loaderContext: LoaderContext = new LoaderContext();
				loaderContext.allowCodeImport = true;
				imageLoader.loadBytes(data, loaderContext);
		} 
		
		private static function __onImageLoaderComplete(callback:Function, filename:String, onImageLoaderComplete:Function = null):Function {
			return onImageLoaderComplete = function(e:Event){
				var loaderInfo: LoaderInfo = LoaderInfo(e.target);
				loaderInfo.removeEventListener(Event.COMPLETE, onImageLoaderComplete);
				var bitmapData:BitmapData = new BitmapData(loaderInfo.width, loaderInfo.height, true, 0x00ffffff);
				bitmapData.draw(loaderInfo.loader)
				callback(bitmapData, filename);
			}				
		}
		
		public static function getStarlingButton(texture:Texture, label:String = ""):Button{
			return new Button(texture, label);
		}

	}
	
}
