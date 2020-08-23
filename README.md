# OpenFL-Tile-Packer
Tile Packer for OpenFL

TileAtlas usage:
```haxe
var tileAtlas:TileAtlas = new TileAtlas(Assets.getBitmapData("<tileset-png>"), Assets.getText("<tileset-json>"));
var tile:Tile = tileAtlas.getTile("<tile-name>");
var tileContainer:Tilemap = new Tilemap(100, 100);		
tileContainer.addTile(tile);
```
