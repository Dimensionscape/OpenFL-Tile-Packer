package {
	import flash.filesystem.File;
	import flash.events.Event;
	import flash.net.FileFilter;
	import flash.display.BitmapData;
	import mx.graphics.codec.PNGEncoder;
	import flash.filesystem.FileStream;
	import flash.filesystem.FileMode;
	import flash.events.OutputProgressEvent;
	import flash.utils.ByteArray;

	public class FileUtils {

		public static function browseForSave(file: File, title: String, callback: Function): void {
			file.browseForSave(title);
			file.addEventListener(Event.SELECT, __onBrowseForSaveSelected(callback));

		}

		private static function __onBrowseForSaveSelected(callback: Function, onBrowseForSaveSelected: Function = null): Function {
			return onBrowseForSaveSelected = function (e: Event) {
				var file: File = e.target;
				callback(file);
				file.removeEventListener(Event.SELECT, onBrowseForSaveSelected);
			}
		}

		public static function browseForOpen(file: File, title: String, typeFilter: Array, callback: Function): void {
			var types: Array = [];
			for (var i: int = 0; i < typeFilter.length; i++) types.push(new FileFilter(typeFilter[i] + " file", typeFilter[i]));
			file.browseForOpen(title, types);
			file.addEventListener(Event.SELECT, __onBrowseForOpenSelected(callback));
		}

		private static function __onBrowseForOpenSelected(callback: Function, onBrowseForOpenSelected: Function = null): Function {
			return onBrowseForOpenSelected = function (e: Event) {
				var file: File = e.target;
				callback(file);
				file.removeEventListener(Event.SELECT, onBrowseForOpenSelected);
			}
		}

		public static function writeProjectFile(data: Object, filename: String, callback:Function = null): void {
			var fileStream: FileStream = new FileStream();
			fileStream.openAsync(new File(filename), FileMode.WRITE);
			fileStream.addEventListener(OutputProgressEvent.OUTPUT_PROGRESS, __onWriteData(filename, callback));
			fileStream.writeObject(data);
		}

		public static function writeObjectToFile(data: Object, filename: String, callback:Function = null): void {
			var fileStream: FileStream = new FileStream();
			fileStream.openAsync(new File(filename), FileMode.WRITE);
			fileStream.addEventListener(OutputProgressEvent.OUTPUT_PROGRESS, __onWriteData(filename, callback));
			fileStream.writeUTFBytes(JSON.stringify(data));

		}

		public static function writeBitmapDataToPNG(bitmapData: BitmapData, filename: String, callback:Function = null): void {
			var encoder: PNGEncoder = new PNGEncoder();
			var pngBytes: ByteArray = encoder.encode(bitmapData);

			var fileStream: FileStream = new FileStream();
			fileStream.openAsync(new File(filename), FileMode.WRITE);
			fileStream.addEventListener(OutputProgressEvent.OUTPUT_PROGRESS, __onWriteData(filename, callback));
			fileStream.writeBytes(pngBytes, 0, pngBytes.length);
		}

		private static function __onWriteData(filename:String, callback:Function = null, onWriteData:Function = null): Function {
			return onWriteData = function (e: OutputProgressEvent): void {
				var fileStream: FileStream = e.target as FileStream;
				fileStream.close();
				fileStream.removeEventListener(OutputProgressEvent.OUTPUT_PROGRESS, onWriteData);
				if(callback!=null) callback(filename, e.bytesPending, e.bytesTotal);
			}
		}
	}

}