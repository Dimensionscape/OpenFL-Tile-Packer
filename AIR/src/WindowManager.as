package {
	import flash.display.Stage;
	import starling.core.Starling;
	import flash.events.Event;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import flash.geom.Point;
	import starling.textures.TextureAtlas;
	import mx.core.ByteArrayAsset;
	import starling.textures.Texture;
	import flash.display.BitmapData;
	import feathers.controls.Alert;
	import feathers.data.ArrayCollection;
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.desktop.NativeApplication;


	public class WindowManager {
		[Embed(source = 'icons/icons.xml', mimeType = "application/octet-stream")]
		public static const uiData: Class;
		[Embed(source = "icons/icons.png")]
		public static const uiSheet: Class;

		public static var textureAtlas: TextureAtlas;
		
		private var __stage: Stage;
		private var __starling: Starling;
		public var saveMenuItemFunction:Function;
		public var saveAsMenuItemFunction:Function;
		public var openMenuItemFunction:Function;
		public var newMenuItemFunction:Function;
		public var exportMenuItemFunction:Function;
		public function WindowManager(stage: Stage, starling: Starling) {
			__starling = starling;
			(__stage = stage).addEventListener(Event.RESIZE, __onResizeEvent);
			__stage.scaleMode = StageScaleMode.NO_SCALE;
			__stage.align = StageAlign.TOP_LEFT;
			__stage.stageWidth = Capabilities.screenResolutionX * .75;
			__stage.stageHeight = Capabilities.screenResolutionY * .75;
			__starling.addEventListener("rootCreated", __onStarlingInitialized);
			__setupMenu();
		}		

		private function __setupMenu(): void {
			var menu: NativeMenu = __stage.nativeWindow.menu = new NativeMenu();

			var fileMenu: NativeMenu = new NativeMenu();
			var newMenuItem: NativeMenuItem = new NativeMenuItem("New Project");
			newMenuItem.addEventListener(Event.SELECT, __onNewMenuItem);
			var openMenuItem: NativeMenuItem = new NativeMenuItem("Open Project");
			openMenuItem.addEventListener(Event.SELECT, __onOpenMenuItem);
			var dividerAItem: NativeMenuItem = new NativeMenuItem("divider", true);
			var saveMenuItem: NativeMenuItem = new NativeMenuItem("Save Project");
			saveMenuItem.addEventListener(Event.SELECT, __onSaveMenuItem);			
			var saveAsMenuItem: NativeMenuItem = new NativeMenuItem("Save As..");
			saveAsMenuItem.addEventListener(Event.SELECT, __onSaveAsMenuItem);
			var dividerBItem: NativeMenuItem = new NativeMenuItem("divider", true);
			var exportItem:NativeMenuItem = new NativeMenuItem("Export");
			exportItem.addEventListener(Event.SELECT, __onExportMenuItem);
			var dividerCItem: NativeMenuItem = new NativeMenuItem("divider", true);
			var exitItem:NativeMenuItem = new NativeMenuItem("Exit");
			exitItem.addEventListener(Event.SELECT, __onExitMenuItem);
			
			fileMenu.addItem(newMenuItem);
			fileMenu.addItem(openMenuItem);
			fileMenu.addItem(dividerAItem);
			fileMenu.addItem(saveMenuItem);
			fileMenu.addItem(saveAsMenuItem);
			fileMenu.addItem(dividerBItem);
			fileMenu.addItem(exportItem);
			fileMenu.addItem(dividerCItem);
			fileMenu.addItem(exitItem);
			menu.addSubmenu(fileMenu, "File");
			menu.addSubmenu(new NativeMenu(), "Edit");
			menu.addSubmenu(new NativeMenu(), "View");
			menu.addSubmenu(new NativeMenu(), "Modify");
			menu.addSubmenu(new NativeMenu(), "Tools");
			menu.addSubmenu(new NativeMenu(), "Window");

		}

		public static function showAlert(message: String, buttons: Array): void {
			Alert.show(message, "Information", new ArrayCollection(buttons));
		}

		private function __onStarlingInitialized(e): void {
			textureAtlas = new TextureAtlas(Texture.fromEmbeddedAsset(uiSheet), XML(new uiData()));
		}

		private function __onResizeEvent(e: Event): void {
			__starling.stage.stageWidth = __stage.stageWidth;
			__starling.stage.stageHeight = __stage.stageHeight;
			__starling.viewPort.width = __stage.stageWidth;
			__starling.viewPort.height = __stage.stageHeight;
		}
		
		private function __onNewMenuItem(e:Event):void{
			newMenuItemFunction();
		}
		private function __onOpenMenuItem(e:Event):void{
			openMenuItemFunction();
		}
		
		private function __onSaveMenuItem(e:Event):void{
			saveMenuItemFunction();
		}
		
		private function __onSaveAsMenuItem(e:Event):void{
			saveAsMenuItemFunction();
		}
		
		private function __onExportMenuItem(e:Event):void{
			exportMenuItemFunction();
		}
		private function __onExitMenuItem(e:Event):void{
			NativeApplication.nativeApplication.exit();
		}
	}

}