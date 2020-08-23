package openfl.utils;
import haxe.Json;
import haxe.ds.StringMap;
import openfl.display.BitmapData;
import openfl.display.Tile;
import openfl.display.Tileset;
import openfl.utils.Object;

/**
The TileAtlas class allows you to import packaged tilesheets into 
Tileset using the TileAtlas data format. 

The `TileAtlas()` constructor creates a new TileAtlas object that
maps verbose identifiers to Tileset rectangles and provides a 
BitmapData reference for Tileset. Use the `Tileset.fromTileAtlas()`
method to intantiate a new Tileset from TileAtlas after the 
TileAtlas object is created.
 **/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
#if !flash
@:access(openfl.geom.Rectangle)
#end
class TileAtlas
{
	private var __data:Object;
	private var __bitmapData:BitmapData;
	private var __tilesetMap:StringMap<Int>;
	private var __tileset:Tileset;
	public function new(bitmapData:BitmapData, data:String) 
	{
		__data = Json.parse(data);
		__bitmapData = bitmapData;
		__tilesetMap = new StringMap<Int>();	
		__populateRectangles(__tileset = new Tileset(bitmapData));		
	}
	
	private function __populateRectangles(tileset:Tileset):Void
	{
		var i:Int = 0;
		for (i in 0...__data.numTiles)
		{
			var tileObj:Object = __data['$i'];
			__tilesetMap.set(tileObj.name, tileset.addRect(tileObj.rect));						
		}		
	}
	
	public function getTile(name:String):Tile{
		var tile:Tile = new Tile(__tilesetMap.get(name));
		tile.tileset = __tileset;
		return tile;
	}
	
}
