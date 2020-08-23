package {

	import flash.display.MovieClip;
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import feathers.themes.AeonDesktopTheme;
	import feathers.controls.List;
	import starling.text.TextField;
	import feathers.controls.TextInput;
	import feathers.controls.Button;
	import feathers.controls.PickerList;
	import feathers.data.ArrayCollection;
	import feathers.controls.NumericStepper;
	import flash.desktop.NativeDragManager;
	import flash.events.NativeDragEvent;
	import flash.display.Shape;
	import flash.desktop.ClipboardFormats;
	import flash.filesystem.FileStream;
	import flash.filesystem.FileMode;
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	import flash.display.Loader;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import feathers.controls.ScrollContainer;
	import starling.textures.TextureAtlas;
	import starling.display.Image;
	import starling.textures.Texture;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;


	public class Main extends MovieClip {

		private var __root: Sprite;
		private var __tileList: List;
		private var __imageFieldInput: TextInput;
		private var __dataFieldInput: TextInput;
		private var __maxSizePicker: PickerList;
		private var __extrudeStepper: NumericStepper;
		private var __tileContainer: ScrollContainer;
		private var __tileAtlas: Sprite;
		private var __bounds: Rectangle;
		private var __maxBounds: Rectangle;
		private var __boundsIncrement: int = 128;
		private var __imageCollection: Array = [];
		private var __windowManager: WindowManager;
		private var __removeTileButton: starling.display.Button;
		private var __exportButton: Button;
		private var __shape: Shape;
		private var __filename: String = "";
		private var __projectSaveDirectory: String = File.documentsDirectory.nativePath + "\\untitled.otp";
		private var __exportFiles: Array = [];


		public function Main() {
			var starling: Starling = new Starling(Sprite as Class, this.stage)
			__windowManager = new WindowManager(stage, starling);
			starling.addEventListener(Event.ROOT_CREATED, __rootCreated);
			starling.start();
			__windowManager.saveMenuItemFunction = __saveProject;
			__windowManager.saveAsMenuItemFunction = __saveAs;
			__windowManager.openMenuItemFunction = __open;
			__windowManager.newMenuItemFunction = __newProject;
			__windowManager.exportMenuItemFunction = __export;
		}

		private function __rootCreated(e: Event): void {
			__root = Starling(e.currentTarget).root as Sprite;
			new AeonDesktopTheme();
			__drawEditor();
		}

		private function __newProject(): void {
			__destroyProject();
			__maxSizePicker.selectedIndex = 2;
			__extrudeStepper.value = 0;
			__filename = "";
			__maxBounds.width = 2048;
			__maxBounds.height = 2048;
			__bounds.width = 0;
			__bounds.height = __maxBounds.height;
			__imageFieldInput.text = "";
			__imageFieldInput.name = "custom";
			__imageFieldInput.fontStyles.italic = false;
			__imageFieldInput.fontStyles.color = 0x000000;
			__dataFieldInput.text = "";
			__dataFieldInput.name = "custom";
			__dataFieldInput.fontStyles.italic = false;
			__dataFieldInput.fontStyles.color = 0x000000;
			__updateTitle();
		}

		private function __destroyProject(): void {
			__tileAtlas.removeChildren();
			__imageCollection = [];
			__tileList.dataProvider = new ArrayCollection();
		}
		private function __loadProject(projectData: Object): void {
			__destroyProject();
			__extrudeStepper.value = projectData.extrude;
			__bounds = new Rectangle(projectData.bounds.x, projectData.bounds.y, projectData.bounds.width, projectData.bounds.height);
			__maxBounds = new Rectangle(projectData.maxBounds.x, projectData.maxBounds.y, projectData.maxBounds.width, projectData.maxBounds.height);
			__projectSaveDirectory = projectData.directory;
			__filename = projectData.filename;
			__imageFieldInput.text = projectData.imagePath;
			__dataFieldInput.text = projectData.dataPath;

			for (var i: int = 0; i < projectData.tiles.length; i++) {
				var tile: Object = projectData.tiles[i];
				var bitmapData: BitmapData = new BitmapData(tile.rect.width, tile.rect.height, true, 0x00ffffff);
				bitmapData.setPixels(new Rectangle(tile.rect.x, tile.rect.y, tile.rect.width, tile.rect.height), tile.data);
				this.addTile(bitmapData, projectData.tiles[i].name);
			}
			if (__imageFieldInput.text.charAt(0) == "\\") {
				__imageFieldInput.fontStyles.italic = true;
				__imageFieldInput.fontStyles.color = 0x808080;
				__imageFieldInput.name = "default"
			} else {
				__imageFieldInput.fontStyles.italic = false;
				__imageFieldInput.fontStyles.color = 0x000000;
				__imageFieldInput.name = "custom";
			}

			if (__dataFieldInput.text.charAt(0) == "\\") {
				__dataFieldInput.fontStyles.italic = true;
				__dataFieldInput.fontStyles.color = 0x808080;
				__dataFieldInput.name = "default"
			} else {
				__dataFieldInput.fontStyles.italic = false;
				__dataFieldInput.fontStyles.color = 0x000000;
				__dataFieldInput.name = "custom";
			}
			__updateTitle();
		}

		private function __open(): void {
			FileUtils.browseForOpen(File.documentsDirectory, "Open project..", ["*.otp"], __onOpen);
		}

		private function __onOpen(file: File): void {
			var fileStream: FileStream = new FileStream();
			fileStream.open(file, FileMode.READ);
			var projectData: Object = fileStream.readObject();
			fileStream.close();
			__loadProject(projectData);
		}

		private function __saveAs(): void {
			FileUtils.browseForSave(new File(__projectSaveDirectory), "Save project as..", __onSaveProject);
		}
		private function __saveProject(): void {
			if (__filename == "") FileUtils.browseForSave(new File(__projectSaveDirectory), "Save project as..", __onSaveProject);
			else __onSaveProject(new File(__projectSaveDirectory));
		}

		private function __onSaveProject(file: File) {
			var projectData: Object = new Object();
			projectData.extrude = __extrudeStepper.value;
			projectData.bounds = __bounds;
			projectData.maxBounds = __maxBounds;
			projectData.directory = __projectSaveDirectory;
			projectData.imagePath = __imageFieldInput.text;
			projectData.dataPath = __dataFieldInput.text;
			projectData.filename = __filename;
			projectData.tiles = [];
			var tileArray: Array = ArrayCollection(__tileList.dataProvider).arrayData;
			for (var i: int = 0; i < tileArray.length; i++) {
				var tileObject: Object = new Object();
				tileObject.name = tileArray[i].label;
				tileObject.rect = BitmapData(tileArray[i].data).rect;
				tileObject.data = BitmapData(tileArray[i].data).getPixels(tileObject.rect);
				projectData.tiles.push(tileObject);
			}
			switch (__maxBounds.width) {
				case 512:
					__maxSizePicker.selectedIndex = 0;
					break;
				case 1024:
					__maxSizePicker.selectedIndex = 1;
					break;
				case 2048:
					__maxSizePicker.selectedIndex = 2;
					break;
				case 4096:
					__maxSizePicker.selectedIndex = 3;
					break;
			}
			__projectSaveDirectory = file.nativePath;
			__filename = file.name;
			__updateTitle();
			FileUtils.writeProjectFile(projectData, file.nativePath);
		}

		private function __export(): void {
			if (__imageFieldInput.text == "" || __dataFieldInput.text == "") {
				__imageFieldInput.errorString = "Must select image output path";
				__dataFieldInput.errorString = "Must select data output path";
			} else {
				var tiles: Array = ArrayCollection(__tileList.dataProvider).arrayData;
				var data: Object = new Object();
				for (var i: int = 0; i < __tileList.dataProvider.length; i++) {
					var tileData: Object = tiles[i];
					var dataObject: Object = data[i.toString()] = new Object();
					dataObject.name = tileData.label.split(".")[0];
					dataObject.rect = {
						"x": tileData.tile.x,
						"y": tileData.tile.y,
						"width": tileData.tile.width,
						"height": tileData.tile.height
					}
				}


				function getImagePath(): String {
					return __imageFieldInput.text.substring(0, __imageFieldInput.text.indexOf(__dataFieldInput.text.substr(1).split(".")[0]) - 1) + __dataFieldInput.text;
				}
				function getDataPath(): String {
					return __dataFieldInput.text.substring(0, __dataFieldInput.text.indexOf(__imageFieldInput.text.substr(1).split(".")[0]) - 1) + __imageFieldInput.text;
				}
				var jsonFilename: String = (__dataFieldInput.name == "custom") ? __dataFieldInput.text : getImagePath();
				var pngFilename: String = (__imageFieldInput.name == "custom") ? __imageFieldInput.text : getDataPath();
				FileUtils.writeObjectToFile(data, jsonFilename, __onExport);
				FileUtils.writeBitmapDataToPNG(__tileAtlas.drawToBitmapData(), pngFilename, __onExport);
			}
		}

		private function __onExport(filename: String, bytesPending: int, bytesTotal: int): void {
			if (bytesPending == 0) {
				__exportFiles.push({
					"name": filename,
					"bytes": bytesTotal
				})
			}
			if (__exportFiles.length == 2) WindowManager.showAlert("Export Complete.\n" + __exportFiles[0].name + "(" + (__exportFiles[0].bytes / 1024).toPrecision(2) + "kb)\n" + __exportFiles[1].name + "(" + (__exportFiles[1].bytes/1024).toPrecision(2) + "kb)\nSize: " + __tileAtlas.width.toString() + " x " + __tileAtlas.height.toString(), [{
				"label": "OK",
				"triggered": function(){
					__exportFiles = [];
				}
			}]);
		}

		private function __updateTitle(): void {
			stage.nativeWindow.title = ((__filename == "") ? "untitled.otp" : __filename) + " - OpenFL Tile Packer (" + __tileAtlas.width + " x " + __tileAtlas.height + ")";
		}

		private function __drawEditor(): void {
			var settingsTitleBG: Quad = new Quad(356, 26, 0x49A6B6);
			settingsTitleBG.x = 2;
			settingsTitleBG.y = 2;
			__root.addChild(settingsTitleBG);

			var settingsTitleText: TextField = new TextField(356, 26, "  Settings");
			settingsTitleText.x = 2;
			settingsTitleText.y = 2;
			settingsTitleText.border = true;
			settingsTitleText.format.bold = true;
			settingsTitleText.format.size = 12;
			settingsTitleText.format.color = 0xFFFFFF;
			settingsTitleText.format.horizontalAlign = "left";
			__root.addChild(settingsTitleText);

			var settingsBG: Quad = new Quad(356, 82, 0xD5EAEE);
			settingsBG.x = 2;
			settingsBG.y = 28;
			__root.addChild(settingsBG);

			var imageFieldText: TextField = new TextField(82, 22, "Image Path:");
			imageFieldText.format.horizontalAlign = "right";
			imageFieldText.format.size = 11;
			imageFieldText.x = 2;
			imageFieldText.y = 30;
			__root.addChild(imageFieldText);

			__imageFieldInput = new TextInput();
			__imageFieldInput.x = 84;
			__imageFieldInput.y = 32;
			__imageFieldInput.width = 166;
			__imageFieldInput.addEventListener(Event.CHANGE, function () {
				__imageFieldInput.errorString = null;
				if (__imageFieldInput.text == "") __imageFieldInput.name = "custom";
				if (__imageFieldInput.text.charAt(0) == "\\") {
					if (__imageFieldInput.name == "default") {
						__imageFieldInput.fontStyles.italic = false;
						__imageFieldInput.fontStyles.color = 0x000000;
						__imageFieldInput.text = __imageFieldInput.text.charAt(__dataFieldInput.text.length - 1);
						__imageFieldInput.name = "custom";
					}
				}
			});
			__root.addChild(__imageFieldInput);

			var imagePathButton: Button = new Button();
			imagePathButton.defaultIcon = Quad.fromTexture(WindowManager.textureAtlas.getTexture("folder"));
			imagePathButton.x = 254;
			imagePathButton.y = 32;
			imagePathButton.addEventListener(Event.TRIGGERED, __onImagePathButtonTriggered);
			__root.addChild(imagePathButton);

			var dataFieldText: TextField = new TextField(82, 22, "Data Path:");
			dataFieldText.format.horizontalAlign = "right";
			dataFieldText.format.size = 11;
			dataFieldText.x = 2;
			dataFieldText.y = 56;
			__root.addChild(dataFieldText);

			__dataFieldInput = new TextInput();
			__dataFieldInput.x = 84;
			__dataFieldInput.y = 58;
			__dataFieldInput.width = 166;
			__dataFieldInput.addEventListener(Event.CHANGE, function () {
				__dataFieldInput.errorString = null
				if (__dataFieldInput.text == "") __dataFieldInput.name = "custom";
				if (__dataFieldInput.text.charAt(0) == "\\") {
					if (__dataFieldInput.name == "default") {
						__dataFieldInput.fontStyles.italic = false;
						__dataFieldInput.fontStyles.color = 0x000000;
						__dataFieldInput.text = __dataFieldInput.text.charAt(__dataFieldInput.text.length - 1);
						__dataFieldInput.name = "custom";
					}
				}
			});
			__root.addChild(__dataFieldInput);

			var dataPathButton: Button = new Button();
			dataPathButton.defaultIcon = Quad.fromTexture(WindowManager.textureAtlas.getTexture("folder"));
			dataPathButton.x = 254;
			dataPathButton.y = 58;
			dataPathButton.addEventListener(Event.TRIGGERED, __onDataPathButtonTriggered);
			__root.addChild(dataPathButton);

			__exportButton = new Button();
			__exportButton.label = "Export";
			__exportButton.width = 52;
			__exportButton.height = 52;
			__exportButton.x = 300;
			__exportButton.y = 30;
			__exportButton.defaultIcon = Quad.fromTexture(WindowManager.textureAtlas.getTexture("16x16c"));
			__exportButton.iconPosition = "bottom";
			__exportButton.isEnabled = false;
			__exportButton.addEventListener(Event.TRIGGERED, __onExportButtonTriggered);
			__root.addChild(__exportButton);

			var maxSizeText: TextField = new TextField(82, 22, "Max Size:");
			maxSizeText.format.horizontalAlign = "right";
			maxSizeText.format.size = 11;
			maxSizeText.x = 2;
			maxSizeText.y = 82;
			__root.addChild(maxSizeText);

			__maxSizePicker = new PickerList();
			__maxSizePicker.width = 166;
			__maxSizePicker.dataProvider = new ArrayCollection([{
				label: "512px x 512px",
				data: 512
			}, {
				label: "1024px x 1024px",
				data: 1024
			}, {
				label: "2048px x 2048px",
				data: 2048
			}, {
				label: "4096px x 4096px",
				data: 4096
			}]);
			__maxSizePicker.x = 84;
			__maxSizePicker.y = 84;
			__maxSizePicker.selectedIndex = 2;
			__maxSizePicker.addEventListener(Event.CHANGE, __onMaxSizeChanged);
			__maxSizePicker.addEventListener(Event.OPEN, __onMaxSizePickerOpen);
			__root.addChild(__maxSizePicker);

			var extrudeText: TextField = new TextField(54, 22, "Extrude:");
			extrudeText.format.horizontalAlign = "right";
			extrudeText.format.size = 11;
			extrudeText.x = 256;
			extrudeText.y = 82;
			__root.addChild(extrudeText);

			__extrudeStepper = new NumericStepper();
			__extrudeStepper.x = 308;
			__extrudeStepper.y = 84;
			__extrudeStepper.maximum = 10;
			__extrudeStepper.minimum = 0;
			__extrudeStepper.value = 0;
			__extrudeStepper.step = 1;
			__extrudeStepper.addEventListener(Event.CHANGE, __onExtrudeStepperChanged);
			__root.addChild(__extrudeStepper);

			var listTitleBG: Quad = new Quad(356, 26, 0x49A6B6);
			listTitleBG.x = 2;
			listTitleBG.y = 110;
			__root.addChild(listTitleBG);

			var listTitleText: TextField = new TextField(356, 26, "  Tiles");
			listTitleText.x = 2;
			listTitleText.y = 110;
			listTitleText.border = true;
			listTitleText.format.bold = true;
			listTitleText.format.size = 12;
			listTitleText.format.color = 0xFFFFFF;
			listTitleText.format.horizontalAlign = "left";
			__root.addChild(listTitleText);

			var addTileButton: starling.display.Button = AssetUtils.getStarlingButton(WindowManager.textureAtlas.getTexture("photo_add"));
			addTileButton.x = 304;
			addTileButton.y = 116;
			addTileButton.addEventListener(Event.TRIGGERED, __onAddTileButtonTriggered);
			__root.addChild(addTileButton);

			__removeTileButton = AssetUtils.getStarlingButton(WindowManager.textureAtlas.getTexture("photo_delete"));
			__removeTileButton.x = 332;
			__removeTileButton.y = 116;
			__removeTileButton.enabled = false;
			__removeTileButton.addEventListener(Event.TRIGGERED, __onRemoveTileButtonTriggered);
			__root.addChild(__removeTileButton);

			__tileList = new List();
			__tileList.x = 2;
			__tileList.y = 136;
			__tileList.width = 356;
			__tileList.height = stage.stageHeight - 138;
			__tileList.dataProvider = new ArrayCollection();
			__tileList.addEventListener(Event.CHANGE, __onTileListChanged);
			__root.addChild(__tileList);

			var tileAtlasBG: Quad = new Quad(32, 32, 0xC9D8DA);

			__tileContainer = new ScrollContainer();
			__tileContainer.x = 356;
			__tileContainer.y = 2;
			__tileContainer.width = stage.stageWidth - 358;
			__tileContainer.height = stage.stageHeight - 4;
			__tileContainer.backgroundSkin = tileAtlasBG;
			__root.addChild(__tileContainer);

			__tileAtlas = new Sprite();
			__maxBounds = new Rectangle(0, 0, 2048, 2048);
			__bounds = new Rectangle(0, 0, __boundsIncrement, __maxBounds.height);

			__root.stage.addEventListener(Event.RESIZE, __onStageResize);
			__root.stage.starling.nativeOverlay.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER, __onNativeDragEnter);
			__root.stage.starling.nativeOverlay.addEventListener(NativeDragEvent.NATIVE_DRAG_DROP, __onNativeDragDrop);

			__shape = new Shape();
			__shape.graphics.beginFill(0x000000);
			__shape.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			__shape.cacheAsBitmap = true;
			__shape.alpha = 0;
			__root.stage.starling.nativeOverlay.addChild(__shape);
			__root.stage.starling.nativeOverlayBlocksTouches = false;
			__updateTitle();

		}


		private function __onStageResize(e: Event): void {
			__tileContainer.width = stage.stageWidth - 358;
			__tileContainer.height = stage.stageHeight - 4;
			__tileList.width = 356;
			__tileList.height = stage.stageHeight - 138;

		}

		private function __onMaxSizePickerOpen(e: Event): void {
			__root.stage.starling.nativeOverlay.removeChild(__shape);
			__maxSizePicker.addEventListener(Event.CLOSE, __onMaxSizePickerClose);
		}

		private function __onMaxSizePickerClose(e: Event): void {
			__root.stage.starling.nativeOverlay.addChild(__shape);
			__maxSizePicker.removeEventListener(Event.CLOSE, __onMaxSizePickerClose);
		}

		private function __onMaxSizeChanged(e: Event): void {
			__maxBounds.width = PickerList(e.currentTarget).selectedItem.data;
			__maxBounds.height = PickerList(e.currentTarget).selectedItem.data;
		}

		private function __onImagePathButtonTriggered(e: Event): void {
			var file: File = new File(File.documentsDirectory.nativePath + "/tile-atlas.png");
			FileUtils.browseForSave(file, "Select Path", __onImagePathSelected);
		}

		private function __onImagePathSelected(file: File): void {
			__imageFieldInput.text = file.nativePath;
			__imageFieldInput.name = "custom";
			__imageFieldInput.fontStyles.italic = false;
			__imageFieldInput.fontStyles.color = 0x000000;
			if (__dataFieldInput.text == "" || __dataFieldInput.text.charAt(0) == "\\") {
				__dataFieldInput.text = "\\" + file.name.split(".")[0] + ".json";
				__dataFieldInput.fontStyles.italic = true;
				__dataFieldInput.fontStyles.color = 0x808080;
				__dataFieldInput.name = "default";
			}
		}

		private function __onDataPathButtonTriggered(e: Event): void {
			var file: File = new File(File.documentsDirectory.nativePath + "/tile-atlas.json");
			FileUtils.browseForSave(file, "Select Path", __onDataPathSelected);
		}

		private function __onDataPathSelected(file: File): void {
			__dataFieldInput.text = file.nativePath;
			__dataFieldInput.name = "custom";
			__dataFieldInput.fontStyles.italic = false;
			__dataFieldInput.fontStyles.color = 0x000000;
			if (__imageFieldInput.text == "" || __imageFieldInput.text.charAt(0) == "\\") {
				__imageFieldInput.text = "\\" + file.name.split(".")[0] + ".png";
				__imageFieldInput.fontStyles.italic = true;
				__imageFieldInput.fontStyles.color = 0x808080;
				__imageFieldInput.name = "default";
			}
		}

		private function __onExportButtonTriggered(e: Event): void {
			__export();
		}

		private function __onTileListChanged(e: Event): void {
			__removeTileButton.enabled = (__tileList.selectedIndex > -1);
		}

		private function __onAddTileButtonTriggered(e: Event): void {
			FileUtils.browseForOpen(File.documentsDirectory, "Select Image..", ["*.png", "*.bmp", "*.jpg"], __onAddTileImageSelected);
		}

		private function __onAddTileImageSelected(file: File): void {
			var fs: FileStream = new FileStream();
			fs.open(file, FileMode.READ);
			var data: ByteArray = new ByteArray();
			fs.readBytes(data, 0, fs.bytesAvailable);
			fs.close();
			AssetUtils.loadImageData(data, file.name, function (bitmapData: BitmapData, filename: String) {
				addTile(bitmapData, filename);
			});
		}
		private function __onRemoveTileButtonTriggered(e: Event): void {
			var tile: Image = __tileList.selectedItem.tile;
			tile.removeFromParent();
			__imageCollection.removeAt(__imageCollection.indexOf(tile));
			__tileList.dataProvider.removeItem(__tileList.selectedItem);
			__orderRectangles();

			__exportButton.isEnabled = (__imageCollection.length > 0);


		}

		private function __extrudeTile(tile: Image): void {
			var extrusion: int = __extrudeStepper.value * 2;
			var bitmapData: BitmapData = __getTileByName(tile.name).data;
			var extrudeValue: int = __extrudeStepper.value;
			var extrudeWidth: int = extrudeValue + bitmapData.width;
			var extrudeHeight: int = extrudeValue + bitmapData.height;
			var copyRect: Rectangle = new Rectangle();
			var copyPoint: Point = new Point();
			var extrudedBitmapData: BitmapData = new BitmapData(bitmapData.width + extrusion, bitmapData.height + extrusion, true, 0x00ffffff);
			//center
			copyRect.setTo(0, 0, bitmapData.width, bitmapData.height);
			copyPoint.setTo(extrudeValue, extrudeValue);
			extrudedBitmapData.copyPixels(bitmapData, copyRect, copyPoint);
			for (var j: int = 0; j < extrudeValue; j++) {
				//left
				copyRect.setTo(0, 0, 1, bitmapData.height);
				copyPoint.setTo(j, extrudeValue);
				extrudedBitmapData.copyPixels(bitmapData, copyRect, copyPoint);
				//top
				copyRect.setTo(0, 0, bitmapData.width, 1);
				copyPoint.setTo(extrudeValue, j);
				extrudedBitmapData.copyPixels(bitmapData, copyRect, copyPoint);
				//right
				copyRect.setTo(bitmapData.width - 1, 0, 1, bitmapData.height);
				copyPoint.setTo(extrudeWidth + j, extrudeValue);
				extrudedBitmapData.copyPixels(bitmapData, copyRect, copyPoint);
				//bottom
				copyRect.setTo(0, bitmapData.height - 1, bitmapData.width, 1);
				copyPoint.setTo(extrudeValue, extrudeHeight + j);
				extrudedBitmapData.copyPixels(bitmapData, copyRect, copyPoint);
			}
			//top left
			var topLeftPixel: uint = bitmapData.getPixel32(0, 0);
			copyRect.setTo(0, 0, extrudeValue, extrudeValue);
			extrudedBitmapData.fillRect(copyRect, topLeftPixel);
			//top right
			var topRightPixel: uint = bitmapData.getPixel32(bitmapData.width - 1, 0);
			copyRect.setTo(extrudeWidth, 0, extrudeValue, extrudeValue);
			extrudedBitmapData.fillRect(copyRect, topRightPixel);
			//bottom left
			var bottomLeftPixel: uint = bitmapData.getPixel32(0, bitmapData.height - 1);
			copyRect.setTo(0, extrudeHeight, extrudeValue, extrudeValue);
			extrudedBitmapData.fillRect(copyRect, bottomLeftPixel);
			//bottom right
			var bottomRightPixel: uint = bitmapData.getPixel32(bitmapData.width - 1, bitmapData.height - 1);
			copyRect.setTo(extrudeWidth, extrudeHeight, extrudeValue, extrudeValue);
			extrudedBitmapData.fillRect(copyRect, bottomRightPixel);

			tile.width = extrudedBitmapData.width;
			tile.height = extrudedBitmapData.height;
			tile.texture = Texture.fromBitmapData(extrudedBitmapData);
		}

		private function __onExtrudeStepperChanged(e: Event): void {
			for (var i: int = 0; i < __imageCollection.length; i++) {
				__extrudeTile(__imageCollection[i]);
			}
			__orderRectangles();
		}

		private function __getTileByName(name: String): Object {
			var tileListData: Array = ArrayCollection(__tileList.dataProvider).arrayData;
			for (var i: int; i < tileListData.length; i++) {
				if (tileListData[i].label == name) return tileListData[i];
			}
			return null;
		}

		private function __onNativeDragEnter(e: NativeDragEvent): void {
			//check and see if files are being drug in
			if (e.clipboard.hasFormat(ClipboardFormats.FILE_LIST_FORMAT)) {
				//get the array of files
				var files: Array = e.clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array;

				//make sure only one file is dragged in (i.e. this app doesn't
				//support dragging in multiple files)
				var extension: String = files[0].extension.toLowerCase();
				if (files.length == 1 && (extension == "png" || extension == "jpg" || extension == "bmp")) {
					//accept the drag action
					NativeDragManager.acceptDragDrop(__root.stage.starling.nativeOverlay);
				}
			}
		}

		private function __onNativeDragDrop(e: NativeDragEvent): void {

			var arr: Array = e.clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array;
			var f: File = File(arr[0]);
			var fs: FileStream = new FileStream();
			fs.open(f, FileMode.READ);
			var data: ByteArray = new ByteArray();
			fs.readBytes(data, 0, fs.bytesAvailable);
			fs.close();

			AssetUtils.loadImageData(data, f.name, function (bitmapData: BitmapData, filename: String) {
				addTile(bitmapData, filename);
			});

		}

		public function addTile(bitmapData: BitmapData, filename: String): void {
			if (__getTileByName(filename) == null) {
				var tile: Image = new Image(Texture.fromBitmapData(bitmapData));
				tile.name = filename;
				__tileList.dataProvider.addItem({
					label: filename,
					data: bitmapData,
					"tile": tile
				});
				__tileAtlas.addChild(tile);
				__imageCollection.push(tile);
				__extrudeTile(tile);
				__orderRectangles();
				__tileContainer.addChild(__tileAtlas);

			} else {
				WindowManager.showAlert("This image is already present in your tile collection.", [{
					label: "OK"
				}]);
			}
			__exportButton.isEnabled = (__imageCollection.length > 0);
		}

		private function __orderRectangles(): void {
			__bounds.width = __boundsIncrement;
			__imageCollection.sortOn("height", Array.NUMERIC);
			__imageCollection.reverse();
			var _y: int = 0;
			var newY: int = 0;
			for (var i: int = 0; i < __imageCollection.length; i++) {
				var _x: int;
				if (i == 0) {
					_x = 0;
					newY = __imageCollection[i].height;
				} else _x = __imageCollection[i - 1].x + __imageCollection[i - 1].width;

				if (_x + __imageCollection[i].width > __bounds.width) {
					_y += newY;
					newY = __imageCollection[i].height;
					_x = 0;
				}

				if (_y + __imageCollection[i].height > __bounds.width) {
					__tileAtlas.removeChildren();
					__bounds.width += __boundsIncrement;
					__orderRectangles();
					break;

				}
				__tileAtlas.addChild(__imageCollection[i]);
				__imageCollection[i].x = _x;
				__imageCollection[i].y = _y;
			}
			__updateTitle();
		}

	}

}