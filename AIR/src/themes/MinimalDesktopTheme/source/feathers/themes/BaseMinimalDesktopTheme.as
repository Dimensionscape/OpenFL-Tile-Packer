/*
Copyright 2012-2019 Bowler Hat LLC. All Rights Reserved.

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
*/
package feathers.themes
{
	import feathers.controls.Alert;
	import feathers.controls.AutoComplete;
	import feathers.controls.AutoSizeMode;
	import feathers.controls.Button;
	import feathers.controls.ButtonGroup;
	import feathers.controls.ButtonState;
	import feathers.controls.Callout;
	import feathers.controls.Check;
	import feathers.controls.DataGrid;
	import feathers.controls.DateTimeSpinner;
	import feathers.controls.Drawers;
	import feathers.controls.GroupedList;
	import feathers.controls.Header;
	import feathers.controls.IScrollBar;
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.controls.LayoutGroup;
	import feathers.controls.List;
	import feathers.controls.NumericStepper;
	import feathers.controls.PageIndicator;
	import feathers.controls.PageIndicatorInteractionMode;
	import feathers.controls.Panel;
	import feathers.controls.PanelScreen;
	import feathers.controls.PickerList;
	import feathers.controls.ProgressBar;
	import feathers.controls.Radio;
	import feathers.controls.ScrollBar;
	import feathers.controls.ScrollBarDisplayMode;
	import feathers.controls.ScrollContainer;
	import feathers.controls.ScrollInteractionMode;
	import feathers.controls.ScrollPolicy;
	import feathers.controls.ScrollScreen;
	import feathers.controls.ScrollText;
	import feathers.controls.Scroller;
	import feathers.controls.SimpleScrollBar;
	import feathers.controls.Slider;
	import feathers.controls.SpinnerList;
	import feathers.controls.StepperButtonLayoutMode;
	import feathers.controls.TabBar;
	import feathers.controls.TextArea;
	import feathers.controls.TextCallout;
	import feathers.controls.TextInput;
	import feathers.controls.TextInputState;
	import feathers.controls.Toast;
	import feathers.controls.ToggleButton;
	import feathers.controls.ToggleSwitch;
	import feathers.controls.TrackLayoutMode;
	import feathers.controls.Tree;
	import feathers.controls.popups.DropDownPopUpContentManager;
	import feathers.controls.renderers.BaseDefaultItemRenderer;
	import feathers.controls.renderers.DefaultDataGridCellRenderer;
	import feathers.controls.renderers.DefaultDataGridHeaderRenderer;
	import feathers.controls.renderers.DefaultGroupedListHeaderOrFooterRenderer;
	import feathers.controls.renderers.DefaultGroupedListItemRenderer;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.DefaultTreeItemRenderer;
	import feathers.controls.text.BitmapFontTextEditor;
	import feathers.controls.text.BitmapFontTextRenderer;
	import feathers.controls.text.TextFieldTextEditorViewPort;
	import feathers.core.FeathersControl;
	import feathers.core.FocusManager;
	import feathers.core.PopUpManager;
	import feathers.core.ToolTipManager;
	import feathers.layout.Direction;
	import feathers.layout.HorizontalAlign;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.RelativePosition;
	import feathers.layout.VerticalAlign;
	import feathers.layout.VerticalLayout;
	import feathers.media.FullScreenToggleButton;
	import feathers.media.MuteToggleButton;
	import feathers.media.PlayPauseToggleButton;
	import feathers.media.SeekSlider;
	import feathers.media.VideoPlayer;
	import feathers.media.VolumeSlider;
	import feathers.skins.ImageSkin;

	import flash.geom.Rectangle;

	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Stage;
	import starling.text.TextField;
	import starling.text.TextFormat;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.textures.TextureSmoothing;

	/**
	 * The base class for the "Minimal" theme for desktop Feathers apps. Handles
	 * everything except asset loading, which is left to subclasses.
	 *
	 * @see MinimalDesktopTheme
	 * @see MinimalDesktopThemeWithAssetManager
	 */
	public class BaseMinimalDesktopTheme extends StyleNameFunctionTheme
	{
		/**
		 * The name of the embedded bitmap font used by controls in this theme.
		 */
		public static const FONT_NAME:String = "PF Ronda Seven";

		/**
		 * The stack of fonts to use for controls that don't use embedded fonts.
		 */
		public static const FONT_NAME_STACK:String = "PF Ronda Seven,Roboto,Helvetica,Arial,_sans";

		/**
		 * @private
		 * The theme's custom style name for the minimum track of a horizontal slider.
		 */
		protected static const THEME_STYLE_NAME_HORIZONTAL_SLIDER_MINIMUM_TRACK:String = "minimal-desktop-horizontal-slider-minimum-track";

		/**
		 * @private
		 * The theme's custom style name for the minimum track of a vertical slider.
		 */
		protected static const THEME_STYLE_NAME_VERTICAL_SLIDER_MINIMUM_TRACK:String = "minimal-desktop-vertical-slider-minimum-track";

		/**
		 * @private
		 * The theme's custom style name for the decrement button of a horizontal scroll bar.
		 */
		protected static const THEME_STYLE_NAME_HORIZONTAL_SCROLL_BAR_DECREMENT_BUTTON:String = "minimal-desktop-horizontal-scroll-bar-decrement-button";

		/**
		 * @private
		 * The theme's custom style name for the increment button of a horizontal scroll bar.
		 */
		protected static const THEME_STYLE_NAME_HORIZONTAL_SCROLL_BAR_INCREMENT_BUTTON:String = "minimal-desktop-horizontal-scroll-bar-increment-button";

		/**
		 * @private
		 * The theme's custom style name for the decrement button of a horizontal scroll bar.
		 */
		protected static const THEME_STYLE_NAME_VERTICAL_SCROLL_BAR_DECREMENT_BUTTON:String = "minimal-desktop-vertical-scroll-bar-decrement-button";

		/**
		 * @private
		 * The theme's custom style name for the increment button of a vertical scroll bar.
		 */
		protected static const THEME_STYLE_NAME_VERTICAL_SCROLL_BAR_INCREMENT_BUTTON:String = "minimal-desktop-vertical-scroll-bar-increment-button";

		/**
		 * @private
		 */
		protected static const THEME_STYLE_NAME_POP_UP_VOLUME_SLIDER_THUMB:String = "minimal-desktop-pop-up-volume-slider-thumb";

		/**
		 * @private
		 */
		protected static const THEME_STYLE_NAME_POP_UP_VOLUME_SLIDER_MINIMUM_TRACK:String = "minimal-desktop-pop-up-volume-slider-minimum-track";

		/**
		 * @private
		 */
		protected static const THEME_STYLE_NAME_NUMERIC_STEPPER_TEXT_INPUT_TEXT_EDITOR:String = "minimal-desktop-numeric-stepper-text-input-text-editor";

		/**
		 * @private
		 */
		protected static const THEME_STYLE_NAME_DATE_TIME_SPINNER_LIST_ITEM_RENDERER:String = "minimal-desktop-date-time-spinner-list-item-renderer";

		/**
		 * @private
		 * The theme's custom style name for the text renderer of a tool tip Label.
		 */
		protected static const THEME_STYLE_NAME_TOOL_TIP_LABEL_TEXT_RENDERER:String = "minimal-desktop-tool-tip-label-text-renderer";

		/**
		 * @private
		 */
		protected static const THEME_STYLE_NAME_ALERT_BUTTON_GROUP_BUTTON:String = "minimal-desktop-alert-button-group-button";
		
		/**
		 * @private
		 * The theme's custom style name for a button in a Toast.
		 */
		protected static const THEME_STYLE_NAME_TOAST_ACTIONS_BUTTON:String = "minimal-mobile-toast-actions-button";

		protected static const FONT_TEXTURE_NAME:String = "pf-ronda-seven-font";

		protected static const ATLAS_SCALE_FACTOR:Number = 2;

		protected static const SOLID_COLOR_TEXTURE_REGION:Rectangle = new Rectangle(1, 1, 1, 1);

		protected static const DEFAULT_SCALE_9_GRID:Rectangle = new Rectangle(3, 3, 1, 1);
		protected static const SCROLLBAR_THUMB_SCALE_9_GRID:Rectangle = new Rectangle(1, 1, 2, 2);
		protected static const TAB_SCALE_9_GRID:Rectangle = new Rectangle(4, 4, 1, 1);
		protected static const HEADER_SCALE_9_GRID:Rectangle = new Rectangle(0, 2, 3, 1);
		protected static const VOLUME_SLIDER_TRACK_SCALE9_GRID:Rectangle = new Rectangle(18, 13, 1, 1);
		protected static const SEEK_SLIDER_PROGRESS_SKIN_SCALE9_GRID:Rectangle = new Rectangle(0, 2, 2, 10);
		protected static const BACK_BUTTON_SCALE_9_GRID:Rectangle = new Rectangle(11, 0, 1, 20);
		protected static const FORWARD_BUTTON_SCALE_9_GRID:Rectangle = new Rectangle(1, 0, 1, 20);
		protected static const DATA_GRID_COLUMN_RESIZE_SKIN_SCALE_9_GRID:Rectangle = new Rectangle(0, 1, 1, 3);
		protected static const DATA_GRID_HEADER_DIVIDER_SCALE_9_GRID:Rectangle = new Rectangle(0, 1, 3, 3);
		protected static const DATA_GRID_HEADER_RENDERER_SCALE_9_GRID:Rectangle = new Rectangle(1, 1, 1, 1);
		protected static const DATA_GRID_COLUMN_DROP_INDICATOR_SCALE_9_GRID:Rectangle = new Rectangle(0, 1, 1, 3);

		protected static const BACKGROUND_COLOR:uint = 0xf3f3f3;
		protected static const PRIMARY_TEXT_COLOR:uint = 0x666666;
		protected static const DISABLED_TEXT_COLOR:uint = 0x999999;
		protected static const DANGER_TEXT_COLOR:uint = 0x990000;
		protected static const MODAL_OVERLAY_COLOR:uint = 0xcccccc;
		protected static const MODAL_OVERLAY_ALPHA:Number = 0.4;
		protected static const VIDEO_OVERLAY_COLOR:uint = 0xcccccc;
		protected static const VIDEO_OVERLAY_ALPHA:Number = 0.2;
		protected static const DATA_GRID_COLUMN_OVERLAY_COLOR:uint = 0xeeeeee;
		protected static const DATA_GRID_COLUMN_OVERLAY_ALPHA:Number = 0.6;

		/**
		 * The default global text renderer factory for this theme creates a
		 * BitmapFontTextRenderer.
		 */
		protected static function textRendererFactory():BitmapFontTextRenderer
		{
			var renderer:BitmapFontTextRenderer = new BitmapFontTextRenderer();
			//since it's a pixel font, we don't want to smooth it.
			renderer.textureSmoothing = TextureSmoothing.NONE;
			return renderer;
		}

		/**
		 * The default global text editor factory for this theme creates a
		 * BitmapFontTextEditor.
		 */
		protected static function textEditorFactory():BitmapFontTextEditor
		{
			return new BitmapFontTextEditor();
		}

		/**
		 * This theme's scroll bar type is ScrollBar.
		 */
		protected static function scrollBarFactory():IScrollBar
		{
			return new ScrollBar();
		}

		protected static function popUpOverlayFactory():DisplayObject
		{
			var quad:Quad = new Quad(100, 100, MODAL_OVERLAY_COLOR);
			quad.alpha = MODAL_OVERLAY_ALPHA;
			return quad;
		}
		
		protected static function pickerListButtonFactory():ToggleButton
		{
			return new ToggleButton();
		}

		/**
		 * Constructor.
		 */
		public function BaseMinimalDesktopTheme()
		{
			super();
		}

		/**
		 * A normal font size. Since it's a pixel font, we want a multiple of
		 * the original size, which, in this case, is 8.
		 */
		protected var fontSize:int = 8;

		/**
		 * A larger font size for headers.
		 */
		protected var largeFontSize:int = 16;

		/**
		 * The size, in pixels, of major regions in the grid. Used for sizing
		 * containers and larger UI controls.
		 */
		protected var gridSize:int = 30;

		/**
		 * The size, in pixels, of minor regions in the grid. Used for larger
		 * padding and gaps.
		 */
		protected var gutterSize:int = 8;

		/**
		 * The size, in pixels, of smaller padding and gaps within the major
		 * regions in the grid.
		 */
		protected var smallGutterSize:int = 4;

		/**
		 * The size, in pixels, of very smaller padding and gaps.
		 */
		protected var extraSmallGutterSize:int = 2;

		/**
		 * The width, in pixels, of UI controls that span across multiple grid regions.
		 */
		protected var wideControlSize:int = 98;

		/**
		 * The width, in pixels, of very large UI controls.
		 */
		protected var extraWideControlSize:int = 210;

		/**
		 * The minimum width, in pixels, of some types of buttons.
		 */
		protected var buttonMinWidth:int = 64;

		/**
		 * The size, in pixels, of a typical UI control.
		 */
		protected var controlSize:int = 20;

		/**
		 * The size, in pixels, of smaller UI controls.
		 */
		protected var smallControlSize:int = 12;

		/**
		 * The size, in pixels, of a border around any control.
		 */
		protected var borderSize:int = 1;

		/**
		 * The size, in pixels, of a drop shadow on a control's bottom right.
		 */
		protected var dropShadowSize:int = 4;

		protected var calloutBackgroundMinSize:int = 5;
		protected var calloutTopLeftArrowOverlapGapSize:int = -2;
		protected var calloutBottomRightArrowOverlapGapSize:int = -6;
		protected var progressBarFillMinSize:int = 7;
		protected var popUpSize:int = 336;
		protected var dropDownGapSize:int = -1;
		protected var focusPaddingSize:int = -2;
		protected var popUpVolumeSliderPaddingTopLeft:int = 9;
		protected var popUpVolumeSliderPaddingBottomRight:int = 13;

		/**
		 * The texture atlas that contains skins for this theme. This base class
		 * does not initialize this member variable. Subclasses are expected to
		 * load the assets somehow and set the <code>atlas</code> member
		 * variable before calling <code>initialize()</code>.
		 */
		protected var atlas:TextureAtlas;

		protected var focusIndicatorSkinTexture:Texture;

		protected var buttonUpSkinTexture:Texture;
		protected var buttonDownSkinTexture:Texture;
		protected var buttonDisabledSkinTexture:Texture;
		protected var buttonSelectedSkinTexture:Texture;
		protected var buttonSelectedDisabledSkinTexture:Texture;
		protected var buttonCallToActionUpSkinTexture:Texture;
		protected var buttonDangerUpSkinTexture:Texture;
		protected var buttonDangerDownSkinTexture:Texture;
		protected var buttonBackUpSkinTexture:Texture;
		protected var buttonBackDownSkinTexture:Texture;
		protected var buttonBackDisabledSkinTexture:Texture;
		protected var buttonForwardUpSkinTexture:Texture;
		protected var buttonForwardDownSkinTexture:Texture;
		protected var buttonForwardDisabledSkinTexture:Texture;

		protected var tabSkinTexture:Texture;
		protected var tabDisabledSkinTexture:Texture;
		protected var tabSelectedSkinTexture:Texture;
		protected var tabSelectedDisabledSkinTexture:Texture;

		protected var thumbSkinTexture:Texture;
		protected var thumbDisabledSkinTexture:Texture;

		protected var simpleScrollBarThumbSkinTexture:Texture;

		protected var insetBackgroundSkinTexture:Texture;
		protected var insetBackgroundDisabledSkinTexture:Texture;
		protected var insetBackgroundFocusedSkinTexture:Texture;
		protected var insetBackgroundDangerSkinTexture:Texture;

		protected var pickerListButtonIconUpTexture:Texture;
		protected var pickerListButtonIconSelectedTexture:Texture;
		protected var pickerListButtonIconDisabledTexture:Texture;
		protected var searchIconTexture:Texture;
		protected var searchIconDisabledTexture:Texture;
		protected var verticalScrollBarDecrementButtonIconTexture:Texture;
		protected var verticalScrollBarIncrementButtonIconTexture:Texture;
		protected var horizontalScrollBarIncrementButtonIconTexture:Texture;
		protected var horizontalScrollBarDecrementButtonIconTexture:Texture;

		protected var headerSkinTexture:Texture;
		protected var panelHeaderSkinTexture:Texture;

		protected var panelBackgroundSkinTexture:Texture;
		protected var popUpBackgroundSkinTexture:Texture;
		protected var dangerPopUpBackgroundSkinTexture:Texture;
		
		protected var calloutTopArrowSkinTexture:Texture;
		protected var calloutBottomArrowSkinTexture:Texture;
		protected var calloutLeftArrowSkinTexture:Texture;
		protected var calloutRightArrowSkinTexture:Texture;
		protected var dangerCalloutTopArrowSkinTexture:Texture;
		protected var dangerCalloutBottomArrowSkinTexture:Texture;
		protected var dangerCalloutLeftArrowSkinTexture:Texture;
		protected var dangerCalloutRightArrowSkinTexture:Texture;

		protected var checkIconTexture:Texture;
		protected var checkDisabledIconTexture:Texture;
		protected var checkSelectedIconTexture:Texture;
		protected var checkSelectedDisabledIconTexture:Texture;

		protected var radioIconTexture:Texture;
		protected var radioDisabledIconTexture:Texture;
		protected var radioSelectedIconTexture:Texture;
		protected var radioSelectedDisabledIconTexture:Texture;

		protected var pageIndicatorSymbolTexture:Texture;
		protected var pageIndicatorSelectedSymbolTexture:Texture;

		protected var listBackgroundSkinTexture:Texture;
		protected var listInsetBackgroundSkinTexture:Texture;
		
		protected var itemRendererUpSkinTexture:Texture;
		protected var itemRendererHoverSkinTexture:Texture;
		protected var itemRendererSelectedSkinTexture:Texture;
		protected var headerRendererSkinTexture:Texture;
		
		protected var listDrillDownAccessoryTexture:Texture;

		protected var treeDisclosureOpenIconTexture:Texture;
		protected var treeDisclosureClosedIconTexture:Texture;

		protected var dataGridHeaderRendererSkinTexture:Texture;
		protected var dataGridColumnResizeSkinTexture:Texture;
		protected var dataGridHeaderDividerSkinTexture:Texture;
		protected var dataGridColumnDropIndicatorSkinTexture:Texture;
		protected var dataGridHeaderSortAscendingIconTexture:Texture;
		protected var dataGridHeaderSortDescendingIconTexture:Texture;

		//media textures
		protected var playPauseButtonPlayUpIconTexture:Texture;
		protected var playPauseButtonPauseUpIconTexture:Texture;
		protected var overlayPlayPauseButtonPlayUpIconTexture:Texture;
		protected var overlayPlayPauseButtonPlayDownIconTexture:Texture;
		protected var fullScreenToggleButtonEnterUpIconTexture:Texture;
		protected var fullScreenToggleButtonExitUpIconTexture:Texture;
		protected var muteToggleButtonLoudUpIconTexture:Texture;
		protected var muteToggleButtonMutedUpIconTexture:Texture;
		protected var volumeSliderMinimumTrackSkinTexture:Texture;
		protected var volumeSliderMaximumTrackSkinTexture:Texture;
		protected var popUpVolumeSliderTrackSkinTexture:Texture;
		protected var seekSliderProgressSkinTexture:Texture;

		protected var primaryFontStyles:TextFormat;
		protected var disabledFontStyles:TextFormat;
		protected var headingFontStyles:TextFormat;
		protected var headingDisabledFontStyles:TextFormat;
		protected var centeredFontStyles:TextFormat;
		protected var centeredDisabledFontStyles:TextFormat;
		protected var dangerFontStyles:TextFormat;
		protected var scrollTextFontStyles:TextFormat;
		protected var scrollTextDisabledFontStyles:TextFormat;

		/**
		 * Disposes the texture atlas and bitmap font before calling
		 * super.dispose().
		 */
		override public function dispose():void
		{
			if(this.atlas)
			{
				//if anything is keeping a reference to the texture, we don't
				//want it to keep a reference to the theme too.
				this.atlas.texture.root.onRestore = null;
				
				this.atlas.dispose();
				this.atlas = null;
			}
			TextField.unregisterCompositor(FONT_NAME);

			var stage:Stage = this.starling.stage;
			FocusManager.setEnabledForStage(stage, false);
			ToolTipManager.setEnabledForStage(stage, false);

			//don't forget to call super.dispose()!
			super.dispose();
		}

		/**
		 * Initializes the theme. Expected to be called by subclasses after the
		 * assets have been loaded and the skin texture atlas has been created.
		 */
		protected function initialize():void
		{
			this.initializeFonts();
			this.initializeTextures();
			this.initializeGlobals();
			this.initializeStage();
			this.initializeStyleProviders();
		}

		/**
		 * Sets the stage background color.
		 */
		protected function initializeStage():void
		{
			this.starling.stage.color = BACKGROUND_COLOR;
			this.starling.nativeStage.color = BACKGROUND_COLOR;
		}

		/**
		 * Initializes global variables (not including global style providers).
		 */
		protected function initializeGlobals():void
		{
			var stage:Stage = this.starling.stage;
			FocusManager.setEnabledForStage(stage, true);
			ToolTipManager.setEnabledForStage(stage, true);

			PopUpManager.overlayFactory = popUpOverlayFactory;
			Callout.stagePadding = this.smallGutterSize;
			Toast.containerFactory = toastContainerFactory;

			FeathersControl.defaultTextRendererFactory = textRendererFactory;
			FeathersControl.defaultTextEditorFactory = textEditorFactory;
		}

		/**
		 * Initializes the textures by extracting them from the atlas and
		 * setting up any scaling grids that are needed.
		 */
		protected function initializeTextures():void
		{
			this.focusIndicatorSkinTexture = this.atlas.getTexture("focus-indicator-skin0000");

			this.buttonUpSkinTexture = this.atlas.getTexture("button-up-skin0000");
			this.buttonDownSkinTexture = this.atlas.getTexture("button-down-skin0000");
			this.buttonDisabledSkinTexture = this.atlas.getTexture("button-disabled-skin0000");
			this.buttonSelectedSkinTexture = this.atlas.getTexture("inset-background-enabled-skin0000");
			this.buttonSelectedDisabledSkinTexture = this.atlas.getTexture("inset-background-disabled-skin0000");
			this.buttonCallToActionUpSkinTexture = this.atlas.getTexture("call-to-action-button-up-skin0000");
			this.buttonDangerUpSkinTexture = this.atlas.getTexture("danger-button-up-skin0000");
			this.buttonDangerDownSkinTexture = this.atlas.getTexture("danger-button-down-skin0000");
			this.buttonBackUpSkinTexture = this.atlas.getTexture("back-button-up-skin0000");
			this.buttonBackDownSkinTexture = this.atlas.getTexture("back-button-down-skin0000");
			this.buttonBackDisabledSkinTexture = this.atlas.getTexture("back-button-disabled-skin0000");
			this.buttonForwardUpSkinTexture = this.atlas.getTexture("forward-button-up-skin0000");
			this.buttonForwardDownSkinTexture = this.atlas.getTexture("forward-button-down-skin0000");
			this.buttonForwardDisabledSkinTexture = this.atlas.getTexture("forward-button-disabled-skin0000");

			this.tabSkinTexture = this.atlas.getTexture("tab-up-skin0000");
			this.tabDisabledSkinTexture = this.atlas.getTexture("tab-disabled-skin0000");
			this.tabSelectedSkinTexture = this.atlas.getTexture("tab-selected-up-skin0000");
			this.tabSelectedDisabledSkinTexture = this.atlas.getTexture("tab-selected-disabled-skin0000");

			this.thumbSkinTexture = this.atlas.getTexture("face-up-skin0000");
			this.thumbDisabledSkinTexture = this.atlas.getTexture("face-disabled-skin0000");

			this.simpleScrollBarThumbSkinTexture = this.atlas.getTexture("simple-scroll-bar-thumb-skin0000");

			this.listBackgroundSkinTexture = this.atlas.getTexture("list-background-skin0000");
			this.listInsetBackgroundSkinTexture = this.atlas.getTexture("list-inset-background-skin0000");
			
			this.itemRendererUpSkinTexture = Texture.fromTexture(this.atlas.getTexture("item-renderer-up-skin0000"), SOLID_COLOR_TEXTURE_REGION);
			this.itemRendererHoverSkinTexture = Texture.fromTexture(this.atlas.getTexture("item-renderer-hover-skin0000"), SOLID_COLOR_TEXTURE_REGION);
			this.itemRendererSelectedSkinTexture = Texture.fromTexture(this.atlas.getTexture("item-renderer-selected-skin0000"), SOLID_COLOR_TEXTURE_REGION);
			this.headerRendererSkinTexture = Texture.fromTexture(this.atlas.getTexture("header-renderer-skin0000"), SOLID_COLOR_TEXTURE_REGION);

			this.insetBackgroundSkinTexture = this.atlas.getTexture("inset-background-enabled-skin0000");
			this.insetBackgroundDisabledSkinTexture = this.atlas.getTexture("inset-background-disabled-skin0000");
			this.insetBackgroundFocusedSkinTexture = this.atlas.getTexture("inset-background-focused-skin0000");
			this.insetBackgroundDangerSkinTexture = this.atlas.getTexture("inset-background-danger-skin0000");

			this.pickerListButtonIconUpTexture = this.atlas.getTexture("picker-list-icon0000");
			this.pickerListButtonIconSelectedTexture = this.atlas.getTexture("picker-list-selected-icon0000");
			this.pickerListButtonIconDisabledTexture = this.atlas.getTexture("picker-list-disabled-icon0000");
			this.searchIconTexture = this.atlas.getTexture("search-enabled-icon0000");
			this.searchIconDisabledTexture = this.atlas.getTexture("search-disabled-icon0000");
			this.verticalScrollBarDecrementButtonIconTexture = this.atlas.getTexture("vertical-scroll-bar-decrement-button-icon0000");
			this.verticalScrollBarIncrementButtonIconTexture = this.atlas.getTexture("vertical-scroll-bar-increment-button-icon0000");
			this.horizontalScrollBarDecrementButtonIconTexture = this.atlas.getTexture("horizontal-scroll-bar-decrement-button-icon0000");
			this.horizontalScrollBarIncrementButtonIconTexture = this.atlas.getTexture("horizontal-scroll-bar-increment-button-icon0000");

			this.headerSkinTexture = this.atlas.getTexture("header-background-skin0000");
			this.panelHeaderSkinTexture = this.atlas.getTexture("panel-header-background-skin0000");

			this.popUpBackgroundSkinTexture = this.atlas.getTexture("pop-up-background-skin0000");
			this.dangerPopUpBackgroundSkinTexture = this.atlas.getTexture("danger-pop-up-background-skin0000");
			this.panelBackgroundSkinTexture = this.atlas.getTexture("panel-background-skin0000");
			this.calloutTopArrowSkinTexture = this.atlas.getTexture("callout-top-arrow-skin0000");
			this.calloutBottomArrowSkinTexture = this.atlas.getTexture("callout-bottom-arrow-skin0000");
			this.calloutLeftArrowSkinTexture = this.atlas.getTexture("callout-left-arrow-skin0000");
			this.calloutRightArrowSkinTexture = this.atlas.getTexture("callout-right-arrow-skin0000");
			this.dangerCalloutTopArrowSkinTexture = this.atlas.getTexture("danger-callout-top-arrow-skin0000");
			this.dangerCalloutBottomArrowSkinTexture = this.atlas.getTexture("danger-callout-bottom-arrow-skin0000");
			this.dangerCalloutLeftArrowSkinTexture = this.atlas.getTexture("danger-callout-left-arrow-skin0000");
			this.dangerCalloutRightArrowSkinTexture = this.atlas.getTexture("danger-callout-right-arrow-skin0000");

			this.checkIconTexture = this.atlas.getTexture("check-up-icon0000");
			this.checkDisabledIconTexture = this.atlas.getTexture("check-disabled-icon0000");
			this.checkSelectedIconTexture = this.atlas.getTexture("check-selected-up-icon0000");
			this.checkSelectedDisabledIconTexture = this.atlas.getTexture("check-selected-disabled-icon0000");

			this.radioIconTexture = this.atlas.getTexture("radio-up-icon0000");
			this.radioDisabledIconTexture = this.atlas.getTexture("radio-disabled-icon0000");
			this.radioSelectedIconTexture = this.atlas.getTexture("radio-selected-up-icon0000");
			this.radioSelectedDisabledIconTexture = this.atlas.getTexture("radio-selected-disabled-icon0000");

			this.pageIndicatorSymbolTexture = this.atlas.getTexture("page-indicator-symbol0000");
			this.pageIndicatorSelectedSymbolTexture = this.atlas.getTexture("page-indicator-selected-symbol0000");

			this.playPauseButtonPlayUpIconTexture = this.atlas.getTexture("play-pause-toggle-button-play-up-icon0000");
			this.playPauseButtonPauseUpIconTexture = this.atlas.getTexture("play-pause-toggle-button-pause-up-icon0000");
			this.overlayPlayPauseButtonPlayUpIconTexture = this.atlas.getTexture("overlay-play-pause-toggle-button-play-up-icon0000");
			this.overlayPlayPauseButtonPlayDownIconTexture = this.atlas.getTexture("overlay-play-pause-toggle-button-play-down-icon0000");
			this.fullScreenToggleButtonEnterUpIconTexture = this.atlas.getTexture("full-screen-toggle-button-enter-up-icon0000");
			this.fullScreenToggleButtonExitUpIconTexture = this.atlas.getTexture("full-screen-toggle-button-exit-up-icon0000");
			this.muteToggleButtonMutedUpIconTexture = this.atlas.getTexture("mute-toggle-button-muted-up-icon0000");
			this.muteToggleButtonLoudUpIconTexture = this.atlas.getTexture("mute-toggle-button-loud-up-icon0000");
			this.volumeSliderMinimumTrackSkinTexture = this.atlas.getTexture("volume-slider-minimum-track-skin0000");
			this.volumeSliderMaximumTrackSkinTexture = this.atlas.getTexture("volume-slider-maximum-track-skin0000");
			this.popUpVolumeSliderTrackSkinTexture = this.atlas.getTexture("pop-up-volume-slider-track-skin0000");
			this.seekSliderProgressSkinTexture = this.atlas.getTexture("seek-slider-progress-skin0000");

			this.listDrillDownAccessoryTexture = this.atlas.getTexture("list-accessory-drill-down-icon0000");

			this.treeDisclosureOpenIconTexture = this.atlas.getTexture("tree-disclosure-open-icon0000");
			this.treeDisclosureClosedIconTexture = this.atlas.getTexture("tree-disclosure-closed-icon0000");

			this.dataGridColumnResizeSkinTexture = this.atlas.getTexture("data-grid-column-resize-skin0000");
			this.dataGridHeaderDividerSkinTexture = this.atlas.getTexture("data-grid-header-divider-skin0000");
			this.dataGridHeaderRendererSkinTexture = this.atlas.getTexture("data-grid-header-renderer-skin0000");
			this.dataGridColumnDropIndicatorSkinTexture = this.atlas.getTexture("data-grid-column-drop-indicator-skin0000");
			this.dataGridHeaderSortAscendingIconTexture = this.atlas.getTexture("data-grid-header-sort-ascending-icon0000");
			this.dataGridHeaderSortDescendingIconTexture = this.atlas.getTexture("data-grid-header-sort-descending-icon0000");
		}

		/**
		 * Initializes font sizes and formats.
		 */
		protected function initializeFonts():void
		{
			this.primaryFontStyles = new TextFormat(FONT_NAME, this.fontSize, PRIMARY_TEXT_COLOR, HorizontalAlign.LEFT, VerticalAlign.TOP);
			this.disabledFontStyles = new TextFormat(FONT_NAME, this.fontSize, DISABLED_TEXT_COLOR, HorizontalAlign.LEFT, VerticalAlign.TOP);
			this.headingFontStyles = new TextFormat(FONT_NAME, this.largeFontSize, PRIMARY_TEXT_COLOR, HorizontalAlign.LEFT, VerticalAlign.TOP);
			this.headingDisabledFontStyles = new TextFormat(FONT_NAME, this.largeFontSize, DISABLED_TEXT_COLOR, HorizontalAlign.LEFT, VerticalAlign.TOP);
			this.centeredFontStyles = new TextFormat(FONT_NAME, this.fontSize, PRIMARY_TEXT_COLOR, HorizontalAlign.CENTER, VerticalAlign.TOP);
			this.centeredDisabledFontStyles = new TextFormat(FONT_NAME, this.fontSize, DISABLED_TEXT_COLOR, HorizontalAlign.CENTER, VerticalAlign.TOP);
			this.dangerFontStyles = new TextFormat(FONT_NAME, this.fontSize, DANGER_TEXT_COLOR, HorizontalAlign.LEFT, VerticalAlign.TOP);
			this.scrollTextFontStyles = new TextFormat(FONT_NAME_STACK, this.fontSize, PRIMARY_TEXT_COLOR, HorizontalAlign.LEFT, VerticalAlign.TOP);
			this.scrollTextDisabledFontStyles = new TextFormat(FONT_NAME_STACK, this.fontSize, DISABLED_TEXT_COLOR, HorizontalAlign.LEFT, VerticalAlign.TOP);
		}

		/**
		 * Sets global style providers for all components.
		 */
		protected function initializeStyleProviders():void
		{
			//alert
			this.getStyleProviderForClass(Alert).defaultStyleFunction = this.setAlertStyles;
			this.getStyleProviderForClass(Header).setFunctionForStyleName(Alert.DEFAULT_CHILD_STYLE_NAME_HEADER, this.setPanelHeaderStyles);
			this.getStyleProviderForClass(ButtonGroup).setFunctionForStyleName(Alert.DEFAULT_CHILD_STYLE_NAME_BUTTON_GROUP, this.setAlertButtonGroupStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_ALERT_BUTTON_GROUP_BUTTON, this.setAlertButtonGroupButtonStyles);

			//autocomplete
			this.getStyleProviderForClass(AutoComplete).defaultStyleFunction = this.setTextInputStyles;
			this.getStyleProviderForClass(List).setFunctionForStyleName(AutoComplete.DEFAULT_CHILD_STYLE_NAME_LIST, this.setDropDownListStyles);

			//button
			this.getStyleProviderForClass(Button).defaultStyleFunction = this.setButtonStyles;
			this.getStyleProviderForClass(Button).setFunctionForStyleName(Button.ALTERNATE_STYLE_NAME_CALL_TO_ACTION_BUTTON, this.setCallToActionButtonStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(Button.ALTERNATE_STYLE_NAME_QUIET_BUTTON, this.setQuietButtonStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(Button.ALTERNATE_STYLE_NAME_DANGER_BUTTON, this.setDangerButtonStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(Button.ALTERNATE_STYLE_NAME_BACK_BUTTON, this.setBackButtonStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(Button.ALTERNATE_STYLE_NAME_FORWARD_BUTTON, this.setForwardButtonStyles);

			//button group
			this.getStyleProviderForClass(ButtonGroup).defaultStyleFunction = this.setButtonGroupStyles;
			this.getStyleProviderForClass(Button).setFunctionForStyleName(ButtonGroup.DEFAULT_CHILD_STYLE_NAME_BUTTON, this.setButtonGroupButtonStyles);
			this.getStyleProviderForClass(ToggleButton).setFunctionForStyleName(ButtonGroup.DEFAULT_CHILD_STYLE_NAME_BUTTON, this.setButtonGroupButtonStyles);

			//callout
			this.getStyleProviderForClass(Callout).defaultStyleFunction = this.setCalloutStyles;

			//check
			this.getStyleProviderForClass(Check).defaultStyleFunction = this.setCheckStyles;

			//data grid
			this.getStyleProviderForClass(DataGrid).defaultStyleFunction = this.setDataGridStyles;
			this.getStyleProviderForClass(DefaultDataGridHeaderRenderer).defaultStyleFunction = this.setDataGridHeaderRendererStyles;
			this.getStyleProviderForClass(DefaultDataGridCellRenderer).defaultStyleFunction = this.setItemRendererStyles;

			//date time spinner
			this.getStyleProviderForClass(DateTimeSpinner).defaultStyleFunction = this.setDateTimeSpinnerStyles;
			this.getStyleProviderForClass(DefaultListItemRenderer).setFunctionForStyleName(THEME_STYLE_NAME_DATE_TIME_SPINNER_LIST_ITEM_RENDERER, this.setDateTimeSpinnerListItemRendererStyles);

			//drawers
			this.getStyleProviderForClass(Drawers).defaultStyleFunction = this.setDrawersStyles;

			//grouped list (see also: item renderers)
			this.getStyleProviderForClass(GroupedList).defaultStyleFunction = this.setGroupedListStyles;
			this.getStyleProviderForClass(GroupedList).setFunctionForStyleName(GroupedList.ALTERNATE_STYLE_NAME_INSET_GROUPED_LIST, this.setInsetGroupedListStyles);

			//header
			this.getStyleProviderForClass(Header).defaultStyleFunction = this.setHeaderStyles;

			//item renderers for lists
			this.getStyleProviderForClass(DefaultListItemRenderer).defaultStyleFunction = this.setItemRendererStyles;
			this.getStyleProviderForClass(DefaultListItemRenderer).setFunctionForStyleName(DefaultListItemRenderer.ALTERNATE_STYLE_NAME_DRILL_DOWN, this.setDrillDownItemRendererStyles);
			this.getStyleProviderForClass(DefaultListItemRenderer).setFunctionForStyleName(DefaultListItemRenderer.ALTERNATE_STYLE_NAME_CHECK, this.setCheckItemRendererStyles);
			this.getStyleProviderForClass(DefaultGroupedListItemRenderer).defaultStyleFunction = this.setItemRendererStyles;
			this.getStyleProviderForClass(DefaultGroupedListItemRenderer).setFunctionForStyleName(DefaultGroupedListItemRenderer.ALTERNATE_STYLE_NAME_DRILL_DOWN, this.setDrillDownItemRendererStyles);
			this.getStyleProviderForClass(DefaultGroupedListItemRenderer).setFunctionForStyleName(DefaultGroupedListItemRenderer.ALTERNATE_STYLE_NAME_CHECK, this.setCheckItemRendererStyles);

			//header and footer renderers for grouped list
			this.getStyleProviderForClass(DefaultGroupedListHeaderOrFooterRenderer).defaultStyleFunction = this.setGroupedListHeaderOrFooterRendererStyles;
			this.getStyleProviderForClass(DefaultGroupedListHeaderOrFooterRenderer).setFunctionForStyleName(GroupedList.ALTERNATE_CHILD_STYLE_NAME_INSET_HEADER_RENDERER, this.setInsetGroupedListHeaderOrFooterRendererStyles);
			this.getStyleProviderForClass(DefaultGroupedListHeaderOrFooterRenderer).setFunctionForStyleName(GroupedList.ALTERNATE_CHILD_STYLE_NAME_INSET_FOOTER_RENDERER, this.setInsetGroupedListHeaderOrFooterRendererStyles);

			//label
			this.getStyleProviderForClass(Label).defaultStyleFunction = this.setLabelStyles;
			this.getStyleProviderForClass(Label).setFunctionForStyleName(Label.ALTERNATE_STYLE_NAME_HEADING, this.setHeadingLabelStyles);
			//no detail label because the font size would be too small
			this.getStyleProviderForClass(Label).setFunctionForStyleName(Label.ALTERNATE_STYLE_NAME_TOOL_TIP, this.setToolTipLabelStyles);

			//layout group
			this.getStyleProviderForClass(LayoutGroup).setFunctionForStyleName(LayoutGroup.ALTERNATE_STYLE_NAME_TOOLBAR, this.setToolbarLayoutGroupStyles);

			//list (see also: item renderers)
			this.getStyleProviderForClass(List).defaultStyleFunction = this.setListStyles;

			//numeric stepper
			this.getStyleProviderForClass(NumericStepper).defaultStyleFunction = this.setNumericStepperStyles;
			this.getStyleProviderForClass(TextInput).setFunctionForStyleName(NumericStepper.DEFAULT_CHILD_STYLE_NAME_TEXT_INPUT, this.setNumericStepperTextInputStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(NumericStepper.DEFAULT_CHILD_STYLE_NAME_DECREMENT_BUTTON, this.setNumericStepperButtonStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(NumericStepper.DEFAULT_CHILD_STYLE_NAME_INCREMENT_BUTTON, this.setNumericStepperButtonStyles);
			this.getStyleProviderForClass(BitmapFontTextEditor).setFunctionForStyleName(THEME_STYLE_NAME_NUMERIC_STEPPER_TEXT_INPUT_TEXT_EDITOR, this.setNumericStepperTextInputTextEditorStyles);

			//page indicator
			this.getStyleProviderForClass(PageIndicator).defaultStyleFunction = this.setPageIndicatorStyles;

			//panel
			this.getStyleProviderForClass(Panel).defaultStyleFunction = this.setPanelStyles;
			this.getStyleProviderForClass(Header).setFunctionForStyleName(Panel.DEFAULT_CHILD_STYLE_NAME_HEADER, this.setPanelHeaderStyles);

			//panel screen
			this.getStyleProviderForClass(PanelScreen).defaultStyleFunction = this.setPanelScreenStyles;

			//picker list (see also: item renderers)
			this.getStyleProviderForClass(PickerList).defaultStyleFunction = this.setPickerListStyles;
			this.getStyleProviderForClass(Button).setFunctionForStyleName(PickerList.DEFAULT_CHILD_STYLE_NAME_BUTTON, this.setPickerListButtonStyles);
			this.getStyleProviderForClass(ToggleButton).setFunctionForStyleName(PickerList.DEFAULT_CHILD_STYLE_NAME_BUTTON, this.setPickerListButtonStyles);
			this.getStyleProviderForClass(List).setFunctionForStyleName(PickerList.DEFAULT_CHILD_STYLE_NAME_LIST, this.setDropDownListStyles);

			//progress bar
			this.getStyleProviderForClass(ProgressBar).defaultStyleFunction = this.setProgressBarStyles;

			//radio
			this.getStyleProviderForClass(Radio).defaultStyleFunction = this.setRadioStyles;

			//scroll bar
			this.getStyleProviderForClass(ScrollBar).setFunctionForStyleName(Scroller.DEFAULT_CHILD_STYLE_NAME_HORIZONTAL_SCROLL_BAR, this.setHorizontalScrollBarStyles);
			this.getStyleProviderForClass(ScrollBar).setFunctionForStyleName(Scroller.DEFAULT_CHILD_STYLE_NAME_VERTICAL_SCROLL_BAR, this.setVerticalScrollBarStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(ScrollBar.DEFAULT_CHILD_STYLE_NAME_THUMB, this.setScrollBarThumbStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(ScrollBar.DEFAULT_CHILD_STYLE_NAME_MINIMUM_TRACK, this.setScrollBarMinimumTrackStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_HORIZONTAL_SCROLL_BAR_DECREMENT_BUTTON, this.setHorizontalScrollBarDecrementButtonStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_HORIZONTAL_SCROLL_BAR_INCREMENT_BUTTON, this.setHorizontalScrollBarIncrementButtonStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_VERTICAL_SCROLL_BAR_DECREMENT_BUTTON, this.setVerticalScrollBarDecrementButtonStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_VERTICAL_SCROLL_BAR_INCREMENT_BUTTON, this.setVerticalScrollBarIncrementButtonStyles);

			//scroll container
			this.getStyleProviderForClass(ScrollContainer).defaultStyleFunction = this.setScrollContainerStyles;
			this.getStyleProviderForClass(ScrollContainer).setFunctionForStyleName(ScrollContainer.ALTERNATE_STYLE_NAME_TOOLBAR, this.setToolbarScrollContainerStyles);

			//scroll screen
			this.getStyleProviderForClass(ScrollScreen).defaultStyleFunction = this.setScrollScreenStyles;

			//scroll text
			this.getStyleProviderForClass(ScrollText).defaultStyleFunction = this.setScrollTextStyles;

			//simple scroll bar
			this.getStyleProviderForClass(Button).setFunctionForStyleName(SimpleScrollBar.DEFAULT_CHILD_STYLE_NAME_THUMB, this.setSimpleScrollBarThumbStyles);

			//slider
			this.getStyleProviderForClass(Slider).defaultStyleFunction = this.setSliderStyles;
			this.getStyleProviderForClass(Button).setFunctionForStyleName(Slider.DEFAULT_CHILD_STYLE_NAME_THUMB, this.setSliderThumbStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_HORIZONTAL_SLIDER_MINIMUM_TRACK, this.setHorizontalSliderMinimumTrackStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_VERTICAL_SLIDER_MINIMUM_TRACK, this.setVerticalSliderMinimumTrackStyles);

			//spinner list
			this.getStyleProviderForClass(SpinnerList).defaultStyleFunction = this.setSpinnerListStyles;
			
			//tab bar
			this.getStyleProviderForClass(TabBar).defaultStyleFunction = this.setTabBarStyles;
			this.getStyleProviderForClass(ToggleButton).setFunctionForStyleName(TabBar.DEFAULT_CHILD_STYLE_NAME_TAB, this.setTabStyles);

			//text input
			this.getStyleProviderForClass(TextInput).defaultStyleFunction = this.setTextInputStyles;
			this.getStyleProviderForClass(TextInput).setFunctionForStyleName(TextInput.ALTERNATE_STYLE_NAME_SEARCH_TEXT_INPUT, this.setSearchTextInputStyles);
			this.getStyleProviderForClass(BitmapFontTextEditor).setFunctionForStyleName(TextInput.DEFAULT_CHILD_STYLE_NAME_TEXT_EDITOR, this.setTextInputTextEditorStyles);
			this.getStyleProviderForClass(TextCallout).setFunctionForStyleName(TextInput.DEFAULT_CHILD_STYLE_NAME_ERROR_CALLOUT, this.setTextInputErrorCalloutStyles);

			//text area
			this.getStyleProviderForClass(TextArea).defaultStyleFunction = this.setTextAreaStyles;
			this.getStyleProviderForClass(TextCallout).setFunctionForStyleName(TextArea.DEFAULT_CHILD_STYLE_NAME_ERROR_CALLOUT, this.setTextAreaErrorCalloutStyles);

			//text callout
			this.getStyleProviderForClass(TextCallout).defaultStyleFunction = this.setTextCalloutStyles;

			//toast
			this.getStyleProviderForClass(Toast).defaultStyleFunction = this.setToastStyles;
			this.getStyleProviderForClass(ButtonGroup).setFunctionForStyleName(Toast.DEFAULT_CHILD_STYLE_NAME_ACTIONS, this.setToastActionsStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_TOAST_ACTIONS_BUTTON, this.setToastActionsButtonStyles);

			//toggle button
			this.getStyleProviderForClass(ToggleButton).defaultStyleFunction = this.setButtonStyles;
			this.getStyleProviderForClass(ToggleButton).setFunctionForStyleName(Button.ALTERNATE_STYLE_NAME_QUIET_BUTTON, this.setQuietButtonStyles);

			//toggle switch
			this.getStyleProviderForClass(ToggleSwitch).defaultStyleFunction = this.setToggleSwitchStyles;
			this.getStyleProviderForClass(Button).setFunctionForStyleName(ToggleSwitch.DEFAULT_CHILD_STYLE_NAME_THUMB, this.setToggleSwitchThumbStyles);
			this.getStyleProviderForClass(ToggleButton).setFunctionForStyleName(ToggleSwitch.DEFAULT_CHILD_STYLE_NAME_THUMB, this.setToggleSwitchThumbStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(ToggleSwitch.DEFAULT_CHILD_STYLE_NAME_ON_TRACK, this.setToggleSwitchOnTrackStyles);
			
			//tree
			this.getStyleProviderForClass(Tree).defaultStyleFunction = this.setTreeStyles;
			this.getStyleProviderForClass(DefaultTreeItemRenderer).defaultStyleFunction = this.setTreeItemRendererStyles;

			//media controls
			this.getStyleProviderForClass(VideoPlayer).defaultStyleFunction = this.setVideoPlayerStyles;

			//play/pause toggle button
			this.getStyleProviderForClass(PlayPauseToggleButton).defaultStyleFunction = this.setPlayPauseToggleButtonStyles;
			this.getStyleProviderForClass(PlayPauseToggleButton).setFunctionForStyleName(PlayPauseToggleButton.ALTERNATE_STYLE_NAME_OVERLAY_PLAY_PAUSE_TOGGLE_BUTTON, this.setOverlayPlayPauseToggleButtonStyles);

			//full screen toggle button
			this.getStyleProviderForClass(FullScreenToggleButton).defaultStyleFunction = this.setFullScreenToggleButtonStyles;

			//mute toggle button
			this.getStyleProviderForClass(MuteToggleButton).defaultStyleFunction = this.setMuteToggleButtonStyles;
			this.getStyleProviderForClass(VolumeSlider).setFunctionForStyleName(MuteToggleButton.DEFAULT_CHILD_STYLE_NAME_VOLUME_SLIDER, this.setPopUpVolumeSliderStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_POP_UP_VOLUME_SLIDER_THUMB, this.setSliderThumbStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_POP_UP_VOLUME_SLIDER_MINIMUM_TRACK, this.setPopUpVolumeSliderTrackStyles);

			//seek slider
			this.getStyleProviderForClass(SeekSlider).defaultStyleFunction = this.setSeekSliderStyles;
			this.getStyleProviderForClass(Button).setFunctionForStyleName(SeekSlider.DEFAULT_CHILD_STYLE_NAME_THUMB, this.setSliderThumbStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(SeekSlider.DEFAULT_CHILD_STYLE_NAME_MINIMUM_TRACK, this.setHorizontalSliderMinimumTrackStyles);

			//volume slider
			this.getStyleProviderForClass(VolumeSlider).defaultStyleFunction = this.setVolumeSliderStyles;
			this.getStyleProviderForClass(Button).setFunctionForStyleName(VolumeSlider.DEFAULT_CHILD_STYLE_NAME_THUMB, this.setVolumeSliderThumbStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(VolumeSlider.DEFAULT_CHILD_STYLE_NAME_MINIMUM_TRACK, this.setVolumeSliderMinimumTrackStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(VolumeSlider.DEFAULT_CHILD_STYLE_NAME_MAXIMUM_TRACK, this.setVolumeSliderMaximumTrackStyles);
		}

		protected function pageIndicatorNormalSymbolFactory():DisplayObject
		{
			return new Image(this.pageIndicatorSymbolTexture);
		}

		protected function pageIndicatorSelectedSymbolFactory():DisplayObject
		{
			return new Image(this.pageIndicatorSelectedSymbolTexture);
		}

		protected function dataGridHeaderDividerFactory():DisplayObject
		{
			var skin:ImageSkin = new ImageSkin(this.dataGridHeaderDividerSkinTexture);
			skin.scale9Grid = DATA_GRID_HEADER_DIVIDER_SCALE_9_GRID;
			return skin;
		}

		protected function toastContainerFactory():DisplayObjectContainer
		{
			var container:LayoutGroup = new LayoutGroup();
			container.autoSizeMode = AutoSizeMode.STAGE;

			var layout:VerticalLayout = new VerticalLayout();
			layout.verticalAlign = VerticalAlign.BOTTOM;
			layout.horizontalAlign = HorizontalAlign.LEFT;
			layout.padding = this.gutterSize;
			layout.gap = this.gutterSize;
			container.layout = layout;

			return container;
		}

	//-------------------------
	// Shared
	//-------------------------

		protected function setScrollerStyles(scroller:Scroller):void
		{
			scroller.interactionMode = ScrollInteractionMode.MOUSE;
			scroller.scrollBarDisplayMode = ScrollBarDisplayMode.FIXED;
			scroller.horizontalScrollBarFactory = scrollBarFactory;
			scroller.verticalScrollBarFactory = scrollBarFactory;

			var focusIndicatorSkin:Image = new Image(this.focusIndicatorSkinTexture);
			focusIndicatorSkin.scale9Grid = DEFAULT_SCALE_9_GRID;
			scroller.focusIndicatorSkin = focusIndicatorSkin;
			scroller.focusPadding = 0;
		}

		protected function setDropDownListStyles(list:List):void
		{
			this.setListStyles(list);

			var layout:VerticalLayout = new VerticalLayout();
			layout.useVirtualLayout = true;
			layout.padding = 0;
			layout.gap = 0;
			layout.horizontalAlign = HorizontalAlign.JUSTIFY;
			layout.verticalAlign = VerticalAlign.TOP;
			layout.resetTypicalItemDimensionsOnMeasure = true;
			layout.maxRowCount = 5;
			list.layout = layout;
		}

	//-------------------------
	// Alert
	//-------------------------

		protected function setAlertStyles(alert:Alert):void
		{
			this.setScrollerStyles(alert);

			var backgroundSkin:Image = new Image(this.popUpBackgroundSkinTexture);
			backgroundSkin.scale9Grid = DEFAULT_SCALE_9_GRID;
			backgroundSkin.width = this.controlSize;
			backgroundSkin.height = this.controlSize;
			alert.backgroundSkin = backgroundSkin;

			alert.fontStyles = this.primaryFontStyles.clone();
			alert.disabledFontStyles = this.disabledFontStyles.clone();

			alert.paddingTop = this.gutterSize;
			alert.paddingRight = this.gutterSize;
			alert.paddingBottom = this.smallGutterSize;
			alert.paddingLeft = this.gutterSize;
			alert.outerPadding = this.borderSize;
			alert.outerPaddingBottom = this.borderSize + this.dropShadowSize;
			alert.outerPaddingRight = this.borderSize + this.dropShadowSize;
			alert.gap = this.smallGutterSize;
			alert.maxWidth = this.popUpSize;
			alert.maxHeight = this.popUpSize;
		}

		protected function setAlertButtonGroupStyles(group:ButtonGroup):void
		{
			group.customButtonStyleName = THEME_STYLE_NAME_ALERT_BUTTON_GROUP_BUTTON;
			group.direction = Direction.HORIZONTAL;
			group.horizontalAlign = HorizontalAlign.CENTER;
			group.verticalAlign = VerticalAlign.JUSTIFY;
			group.distributeButtonSizes = false;
			group.gap = this.smallGutterSize;
			group.padding = this.smallGutterSize;
		}

		protected function setAlertButtonGroupButtonStyles(button:Button):void
		{
			this.setButtonStyles(button);
		}

	//-------------------------
	// Button
	//-------------------------

		protected function setBaseButtonStyles(button:Button):void
		{
			var focusIndicatorSkin:Image = new Image(this.focusIndicatorSkinTexture);
			focusIndicatorSkin.scale9Grid = DEFAULT_SCALE_9_GRID;
			button.focusIndicatorSkin = focusIndicatorSkin;
			button.focusPadding = this.focusPaddingSize;

			button.paddingTop = this.smallGutterSize;
			button.paddingBottom = this.smallGutterSize;
			button.paddingLeft = this.gutterSize;
			button.paddingRight = this.gutterSize;
			button.gap = this.smallGutterSize;
			button.minGap = this.smallGutterSize;
		}

		protected function setButtonStyles(button:Button):void
		{
			var skin:ImageSkin = new ImageSkin(this.buttonUpSkinTexture);
			skin.setTextureForState(ButtonState.DOWN, this.buttonDownSkinTexture);
			skin.setTextureForState(ButtonState.DISABLED, this.buttonDisabledSkinTexture);
			if(button is ToggleButton)
			{
				//for convenience, this function can style both a regular button
				//and a toggle button
				skin.selectedTexture = this.buttonSelectedSkinTexture;
				skin.setTextureForState(ButtonState.DOWN_AND_SELECTED,  this.buttonDownSkinTexture);
				skin.setTextureForState(ButtonState.DISABLED_AND_SELECTED,  this.buttonSelectedDisabledSkinTexture);
			}
			skin.scale9Grid = DEFAULT_SCALE_9_GRID;
			skin.width = this.controlSize;
			skin.height = this.controlSize;
			skin.minWidth = this.buttonMinWidth;
			skin.minHeight = this.controlSize;
			button.defaultSkin = skin;

			button.fontStyles = this.primaryFontStyles.clone();
			button.disabledFontStyles = this.disabledFontStyles.clone();

			this.setBaseButtonStyles(button);
		}

		protected function setCallToActionButtonStyles(button:Button):void
		{
			var skin:ImageSkin = new ImageSkin(this.buttonCallToActionUpSkinTexture);
			skin.setTextureForState(ButtonState.DOWN, this.buttonDownSkinTexture);
			skin.setTextureForState(ButtonState.DISABLED, this.buttonDisabledSkinTexture);
			skin.scale9Grid = DEFAULT_SCALE_9_GRID;
			skin.width = this.buttonMinWidth;
			skin.height = this.controlSize;
			skin.minWidth = this.buttonMinWidth;
			skin.minHeight = this.controlSize;
			button.defaultSkin = skin;

			button.fontStyles = this.primaryFontStyles.clone();
			button.disabledFontStyles = this.disabledFontStyles.clone();

			this.setBaseButtonStyles(button);
		}

		protected function setQuietButtonStyles(button:Button):void
		{
			var defaultSkin:Quad = new Quad(this.controlSize, this.controlSize, 0xff00ff);
			defaultSkin.alpha = 0;
			button.defaultSkin = defaultSkin;

			var otherSkin:ImageSkin = new ImageSkin(null);
			otherSkin.setTextureForState(ButtonState.DOWN, this.buttonDownSkinTexture);
			if(button is ToggleButton)
			{
				//for convenience, this function can style both a regular button
				//and a toggle button
				otherSkin.selectedTexture = this.buttonSelectedSkinTexture;
				otherSkin.setTextureForState(ButtonState.DOWN_AND_SELECTED,  this.buttonDownSkinTexture);
				otherSkin.setTextureForState(ButtonState.DISABLED_AND_SELECTED,  this.buttonSelectedDisabledSkinTexture);
				ToggleButton(button).defaultSelectedSkin = otherSkin;
				button.setSkinForState(ButtonState.DOWN_AND_SELECTED, otherSkin);
				button.setSkinForState(ButtonState.DISABLED_AND_SELECTED, otherSkin);
			}
			button.setSkinForState(ButtonState.DOWN, otherSkin);
			otherSkin.scale9Grid = DEFAULT_SCALE_9_GRID;
			otherSkin.width = this.controlSize;
			otherSkin.height = this.controlSize;
			otherSkin.minWidth = this.controlSize;
			otherSkin.minHeight = this.controlSize;

			button.fontStyles = this.primaryFontStyles.clone();
			button.disabledFontStyles = this.disabledFontStyles.clone();

			this.setBaseButtonStyles(button);
		}

		protected function setDangerButtonStyles(button:Button):void
		{
			var skin:ImageSkin = new ImageSkin(this.buttonDangerUpSkinTexture);
			skin.setTextureForState(ButtonState.DOWN, this.buttonDangerDownSkinTexture);
			skin.setTextureForState(ButtonState.DISABLED, this.buttonDisabledSkinTexture);
			skin.scale9Grid = DEFAULT_SCALE_9_GRID;
			skin.width = this.buttonMinWidth;
			skin.height = this.controlSize;
			skin.minWidth = this.buttonMinWidth;
			skin.minHeight = this.controlSize;
			button.defaultSkin = skin;

			button.fontStyles = this.dangerFontStyles.clone();
			button.disabledFontStyles = this.disabledFontStyles.clone();

			this.setBaseButtonStyles(button);
		}

		protected function setBackButtonStyles(button:Button):void
		{
			var skin:ImageSkin = new ImageSkin(this.buttonBackUpSkinTexture);
			skin.setTextureForState(ButtonState.DOWN, this.buttonBackDownSkinTexture);
			skin.setTextureForState(ButtonState.DISABLED, this.buttonBackDisabledSkinTexture);
			skin.scale9Grid = BACK_BUTTON_SCALE_9_GRID;
			skin.width = this.controlSize;
			skin.height = this.controlSize;
			skin.minWidth = this.controlSize;
			skin.minHeight = this.controlSize;
			skin.textureSmoothing = TextureSmoothing.NONE;
			button.defaultSkin = skin;

			button.fontStyles = this.primaryFontStyles.clone();
			button.disabledFontStyles = this.disabledFontStyles.clone();

			this.setBaseButtonStyles(button);

			button.paddingLeft = 2 * this.gutterSize;
		}

		protected function setForwardButtonStyles(button:Button):void
		{
			var skin:ImageSkin = new ImageSkin(this.buttonForwardUpSkinTexture);
			skin.setTextureForState(ButtonState.DOWN, this.buttonForwardDownSkinTexture);
			skin.setTextureForState(ButtonState.DISABLED, this.buttonForwardDisabledSkinTexture);
			skin.scale9Grid = FORWARD_BUTTON_SCALE_9_GRID;
			skin.width = this.controlSize;
			skin.height = this.controlSize;
			skin.minWidth = this.controlSize;
			skin.minHeight = this.controlSize;
			skin.textureSmoothing = TextureSmoothing.NONE;
			button.defaultSkin = skin;

			button.fontStyles = this.primaryFontStyles.clone();
			button.disabledFontStyles = this.disabledFontStyles.clone();

			this.setBaseButtonStyles(button);

			button.paddingRight = 2 * this.gutterSize;
		}

	//-------------------------
	// ButtonGroup
	//-------------------------

		protected function setButtonGroupStyles(group:ButtonGroup):void
		{
			group.gap = this.smallGutterSize;
		}

		protected function setButtonGroupButtonStyles(button:Button):void
		{
			var skin:ImageSkin = new ImageSkin(this.buttonUpSkinTexture);
			skin.setTextureForState(ButtonState.DOWN, this.buttonDownSkinTexture);
			skin.setTextureForState(ButtonState.DISABLED, this.buttonDisabledSkinTexture);
			if(button is ToggleButton)
			{
				//for convenience, this function can style both a regular button
				//and a toggle button
				skin.selectedTexture = this.buttonSelectedSkinTexture;
				skin.setTextureForState(ButtonState.DOWN_AND_SELECTED,  this.buttonDownSkinTexture);
				skin.setTextureForState(ButtonState.DISABLED_AND_SELECTED,  this.buttonSelectedDisabledSkinTexture);
			}
			skin.scale9Grid = DEFAULT_SCALE_9_GRID;
			skin.width = this.wideControlSize;
			skin.height = this.controlSize;
			skin.minWidth = this.wideControlSize;
			skin.minHeight = this.controlSize;
			button.defaultSkin = skin;

			var focusIndicatorSkin:Image = new Image(this.focusIndicatorSkinTexture);
			focusIndicatorSkin.scale9Grid = DEFAULT_SCALE_9_GRID;
			button.focusIndicatorSkin = focusIndicatorSkin;
			button.focusPadding = this.focusPaddingSize;

			button.fontStyles = this.primaryFontStyles.clone();
			button.disabledFontStyles = this.disabledFontStyles.clone();

			button.paddingTop = this.smallGutterSize;
			button.paddingBottom = this.smallGutterSize;
			button.paddingLeft = this.gutterSize;
			button.paddingRight = this.gutterSize;
			button.gap = this.smallGutterSize;
			button.minGap = this.smallGutterSize;
		}

	//-------------------------
	// Callout
	//-------------------------

		protected function setCalloutStyles(callout:Callout):void
		{
			callout.padding = this.gutterSize;
			callout.paddingRight = this.gutterSize + this.dropShadowSize;
			callout.paddingBottom = this.gutterSize + this.dropShadowSize;

			var backgroundSkin:Image = new Image(this.popUpBackgroundSkinTexture);
			backgroundSkin.scale9Grid = DEFAULT_SCALE_9_GRID;
			backgroundSkin.width = this.calloutBackgroundMinSize;
			backgroundSkin.height = this.calloutBackgroundMinSize;
			callout.backgroundSkin = backgroundSkin;

			var topArrowSkin:Image = new Image(this.calloutTopArrowSkinTexture);
			callout.topArrowSkin = topArrowSkin;
			callout.topArrowGap = this.calloutTopLeftArrowOverlapGapSize;

			var bottomArrowSkin:Image = new Image(this.calloutBottomArrowSkinTexture);
			callout.bottomArrowSkin = bottomArrowSkin;
			callout.bottomArrowGap = this.calloutBottomRightArrowOverlapGapSize;

			var leftArrowSkin:Image = new Image(this.calloutLeftArrowSkinTexture);
			callout.leftArrowSkin = leftArrowSkin;
			callout.leftArrowGap = this.calloutTopLeftArrowOverlapGapSize;

			var rightArrowSkin:Image = new Image(this.calloutRightArrowSkinTexture);
			callout.rightArrowSkin = rightArrowSkin;
			callout.rightArrowGap = this.calloutBottomRightArrowOverlapGapSize;
		}

		protected function setDangerCalloutStyles(callout:Callout):void
		{
			callout.padding = this.gutterSize;
			callout.paddingRight = this.gutterSize + this.dropShadowSize;
			callout.paddingBottom = this.gutterSize + this.dropShadowSize;

			var backgroundSkin:Image = new Image(this.dangerPopUpBackgroundSkinTexture);
			backgroundSkin.scale9Grid = DEFAULT_SCALE_9_GRID;
			backgroundSkin.width = this.calloutBackgroundMinSize;
			backgroundSkin.height = this.calloutBackgroundMinSize;
			callout.backgroundSkin = backgroundSkin;

			var topArrowSkin:Image = new Image(this.dangerCalloutTopArrowSkinTexture);
			callout.topArrowSkin = topArrowSkin;
			callout.topArrowGap = this.calloutTopLeftArrowOverlapGapSize;

			var bottomArrowSkin:Image = new Image(this.dangerCalloutBottomArrowSkinTexture);
			callout.bottomArrowSkin = bottomArrowSkin;
			callout.bottomArrowGap = this.calloutBottomRightArrowOverlapGapSize;

			var leftArrowSkin:Image = new Image(this.dangerCalloutLeftArrowSkinTexture);
			callout.leftArrowSkin = leftArrowSkin;
			callout.leftArrowGap = this.calloutTopLeftArrowOverlapGapSize;

			var rightArrowSkin:Image = new Image(this.dangerCalloutRightArrowSkinTexture);
			callout.rightArrowSkin = rightArrowSkin;
			callout.rightArrowGap = this.calloutBottomRightArrowOverlapGapSize;
		}

	//-------------------------
	// Check
	//-------------------------

		protected function setCheckStyles(check:Check):void
		{
			var skin:Quad = new Quad(this.controlSize, this.controlSize);
			skin.alpha = 0;
			check.defaultSkin = skin;

			var icon:ImageSkin = new ImageSkin(this.checkIconTexture);
			icon.selectedTexture = this.checkSelectedIconTexture;
			icon.setTextureForState(ButtonState.DISABLED, this.checkDisabledIconTexture);
			icon.setTextureForState(ButtonState.DISABLED_AND_SELECTED,  this.checkSelectedDisabledIconTexture);
			icon.textureSmoothing = TextureSmoothing.NONE;
			check.defaultIcon = icon;

			var focusIndicatorSkin:Image = new Image(this.focusIndicatorSkinTexture);
			focusIndicatorSkin.scale9Grid = DEFAULT_SCALE_9_GRID;
			check.focusIndicatorSkin = focusIndicatorSkin;
			check.focusPaddingLeft = this.focusPaddingSize;
			check.focusPaddingRight = this.focusPaddingSize;

			check.fontStyles = this.primaryFontStyles.clone();
			check.disabledFontStyles = this.disabledFontStyles.clone();

			check.gap = this.smallGutterSize;
			check.horizontalAlign = HorizontalAlign.LEFT;
			check.verticalAlign = VerticalAlign.MIDDLE;
		}

	//-------------------------
	// DataGrid
	//-------------------------

		protected function setDataGridStyles(grid:DataGrid):void
		{
			this.setScrollerStyles(grid);

			grid.verticalScrollPolicy = ScrollPolicy.AUTO;

			var backgroundSkin:ImageSkin = new ImageSkin(this.listBackgroundSkinTexture);
			backgroundSkin.scale9Grid = DEFAULT_SCALE_9_GRID;
			backgroundSkin.width = this.controlSize;
			backgroundSkin.height = this.controlSize;
			grid.backgroundSkin = backgroundSkin;

			var backgroundDisabledSkin:ImageSkin = new ImageSkin(this.buttonDisabledSkinTexture);
			backgroundSkin.scale9Grid = DEFAULT_SCALE_9_GRID;
			backgroundDisabledSkin.width = this.controlSize;
			backgroundDisabledSkin.height = this.controlSize;
			grid.backgroundDisabledSkin = backgroundDisabledSkin;

			var columnDragOverlaySkin:Quad = new Quad(1, 1, DATA_GRID_COLUMN_OVERLAY_COLOR);
			columnDragOverlaySkin.alpha = DATA_GRID_COLUMN_OVERLAY_ALPHA;
			grid.columnDragOverlaySkin = columnDragOverlaySkin;

			var columnResizeSkin:ImageSkin = new ImageSkin(this.dataGridColumnResizeSkinTexture);
			columnResizeSkin.scale9Grid = DATA_GRID_COLUMN_RESIZE_SKIN_SCALE_9_GRID;
			grid.columnResizeSkin = columnResizeSkin;

			var columnDropIndicatorSkin:ImageSkin = new ImageSkin(this.dataGridColumnDropIndicatorSkinTexture);
			columnDropIndicatorSkin.scale9Grid = DATA_GRID_COLUMN_DROP_INDICATOR_SCALE_9_GRID;
			grid.columnDropIndicatorSkin = columnDropIndicatorSkin;

			grid.headerDividerFactory = this.dataGridHeaderDividerFactory;

			grid.padding = this.borderSize;
			grid.paddingRight = 0;
		}

		protected function setDataGridHeaderRendererStyles(headerRenderer:DefaultDataGridHeaderRenderer):void
		{
			var backgroundSkin:ImageSkin = new ImageSkin(this.dataGridHeaderRendererSkinTexture);
			backgroundSkin.scale9Grid = DATA_GRID_HEADER_RENDERER_SCALE_9_GRID;
			backgroundSkin.width = this.controlSize;
			backgroundSkin.height = this.controlSize;
			backgroundSkin.minWidth = this.controlSize;
			backgroundSkin.minHeight = this.controlSize;
			headerRenderer.backgroundSkin = backgroundSkin;

			headerRenderer.sortAscendingIcon = new ImageSkin(this.dataGridHeaderSortAscendingIconTexture);
			headerRenderer.sortDescendingIcon = new ImageSkin(this.dataGridHeaderSortDescendingIconTexture);

			headerRenderer.fontStyles = this.primaryFontStyles.clone();
			headerRenderer.disabledFontStyles = this.disabledFontStyles.clone();

			headerRenderer.paddingTop = this.smallGutterSize;
			headerRenderer.paddingBottom = this.smallGutterSize;
			headerRenderer.paddingLeft = this.gutterSize;
			headerRenderer.paddingRight = this.gutterSize;
		}

	//-------------------------
	// DateTimeSpinner
	//-------------------------

		protected function setDateTimeSpinnerStyles(spinner:DateTimeSpinner):void
		{
			spinner.customItemRendererStyleName = THEME_STYLE_NAME_DATE_TIME_SPINNER_LIST_ITEM_RENDERER;
		}

		protected function setDateTimeSpinnerListItemRendererStyles(itemRenderer:DefaultListItemRenderer):void
		{
			this.setItemRendererStyles(itemRenderer);
			itemRenderer.accessoryPosition = RelativePosition.LEFT;
			itemRenderer.accessoryGap = this.smallGutterSize;
		}

	//-------------------------
	// Drawers
	//-------------------------

		protected function setDrawersStyles(drawers:Drawers):void
		{
			var overlaySkin:Quad = new Quad(10, 10, MODAL_OVERLAY_COLOR);
			overlaySkin.alpha = MODAL_OVERLAY_ALPHA;
			drawers.overlaySkin = overlaySkin;
		}

	//-------------------------
	// GroupedList
	//-------------------------

		protected function setGroupedListStyles(list:GroupedList):void
		{
			this.setScrollerStyles(list);

			list.verticalScrollPolicy = ScrollPolicy.AUTO;

			var backgroundSkin:Image = new Image(this.listBackgroundSkinTexture);
			backgroundSkin.scale9Grid = DEFAULT_SCALE_9_GRID;
			backgroundSkin.width = this.gridSize;
			backgroundSkin.height = this.gridSize;
			list.backgroundSkin = backgroundSkin;

			var backgroundDisabledSkin:Image = new Image(this.buttonDisabledSkinTexture);
			backgroundDisabledSkin.scale9Grid = DEFAULT_SCALE_9_GRID;
			backgroundDisabledSkin.width = this.gridSize;
			backgroundDisabledSkin.height = this.gridSize;
			list.backgroundDisabledSkin = backgroundDisabledSkin;

			list.padding = this.borderSize;
		}

		//see List section for item renderer styles

		protected function setGroupedListHeaderOrFooterRendererStyles(renderer:DefaultGroupedListHeaderOrFooterRenderer):void
		{
			var backgroundSkin:ImageSkin = new ImageSkin(this.headerRendererSkinTexture);
			backgroundSkin.width = this.controlSize;
			backgroundSkin.height = this.controlSize;
			backgroundSkin.minWidth = this.controlSize;
			backgroundSkin.minHeight = this.controlSize;
			renderer.backgroundSkin = backgroundSkin;

			renderer.fontStyles = this.primaryFontStyles.clone();
			renderer.disabledFontStyles = this.disabledFontStyles.clone();

			renderer.paddingTop = this.smallGutterSize;
			renderer.paddingBottom = this.smallGutterSize;
			renderer.paddingLeft = this.gutterSize;
			renderer.paddingRight = this.gutterSize;
		}

		protected function setInsetGroupedListStyles(list:GroupedList):void
		{
			this.setScrollerStyles(list);

			var backgroundSkin:Image = new Image(this.listInsetBackgroundSkinTexture);
			backgroundSkin.scale9Grid = DEFAULT_SCALE_9_GRID;
			backgroundSkin.width = this.gridSize;
			backgroundSkin.height = this.gridSize;
			list.backgroundSkin = backgroundSkin;

			var backgroundDisabledSkin:Image = new Image(this.buttonDisabledSkinTexture);
			backgroundSkin.scale9Grid = DEFAULT_SCALE_9_GRID;
			backgroundDisabledSkin.width = this.gridSize;
			backgroundDisabledSkin.height = this.gridSize;
			list.backgroundDisabledSkin = backgroundDisabledSkin;

			list.verticalScrollPolicy = ScrollPolicy.AUTO;

			list.customHeaderRendererStyleName = GroupedList.ALTERNATE_CHILD_STYLE_NAME_INSET_HEADER_RENDERER;
			list.customFooterRendererStyleName = GroupedList.ALTERNATE_CHILD_STYLE_NAME_INSET_FOOTER_RENDERER;

			var layout:VerticalLayout = new VerticalLayout();
			layout.useVirtualLayout = true;
			layout.padding = this.gutterSize;
			layout.paddingTop = 0;
			layout.gap = 0;
			layout.horizontalAlign = HorizontalAlign.JUSTIFY;
			layout.verticalAlign = VerticalAlign.TOP;
			list.layout = layout;
		}

		protected function setInsetGroupedListHeaderOrFooterRendererStyles(renderer:DefaultGroupedListHeaderOrFooterRenderer):void
		{
			var skin:Quad = new Quad(this.controlSize, this.controlSize);
			skin.alpha = 0;
			renderer.backgroundSkin = skin;

			renderer.fontStyles = this.primaryFontStyles.clone();
			renderer.disabledFontStyles = this.disabledFontStyles.clone();

			renderer.paddingTop = this.smallGutterSize;
			renderer.paddingBottom = this.smallGutterSize;
			renderer.paddingLeft = this.gutterSize;
			renderer.paddingRight = this.gutterSize;
		}

	//-------------------------
	// Header
	//-------------------------

		protected function setHeaderStyles(header:Header):void
		{
			header.paddingTop = this.smallGutterSize;
			header.paddingBottom = this.smallGutterSize;
			header.paddingRight = this.gutterSize;
			header.paddingLeft = this.gutterSize;
			header.gap = this.smallGutterSize;
			header.titleGap = this.smallGutterSize;

			header.fontStyles = this.primaryFontStyles.clone();
			header.disabledFontStyles = this.disabledFontStyles.clone();

			var backgroundSkin:ImageSkin = new ImageSkin(this.headerSkinTexture);
			backgroundSkin.scale9Grid = HEADER_SCALE_9_GRID;
			backgroundSkin.width = this.gridSize;
			backgroundSkin.height = this.gridSize;
			backgroundSkin.minWidth = this.gridSize;
			backgroundSkin.minHeight = this.gridSize;
			header.backgroundSkin = backgroundSkin;
		}

	//-------------------------
	// Label
	//-------------------------

		protected function setLabelStyles(label:Label):void
		{
			label.fontStyles = this.primaryFontStyles.clone();
			label.disabledFontStyles = this.disabledFontStyles.clone();
		}

		protected function setHeadingLabelStyles(label:Label):void
		{
			label.fontStyles = this.headingFontStyles.clone();
			label.disabledFontStyles = this.headingDisabledFontStyles.clone();
		}

		protected function setToolTipLabelStyles(label:Label):void
		{
			var backgroundSkin:Image = new Image(this.popUpBackgroundSkinTexture)
			backgroundSkin.scale9Grid = DEFAULT_SCALE_9_GRID;
			label.backgroundSkin = backgroundSkin;

			label.fontStyles = this.primaryFontStyles.clone();
			label.disabledFontStyles = this.disabledFontStyles.clone();

			label.padding = this.smallGutterSize;
			label.paddingBottom = this.smallGutterSize + this.dropShadowSize;
			label.paddingRight = this.smallGutterSize + this.dropShadowSize;
		}

	//-------------------------
	// LayoutGroup
	//-------------------------

		protected function setToolbarLayoutGroupStyles(group:LayoutGroup):void
		{
			if(!group.layout)
			{
				var layout:HorizontalLayout = new HorizontalLayout();
				layout.padding = this.gutterSize;
				layout.gap = this.smallGutterSize;
				layout.verticalAlign = VerticalAlign.MIDDLE;
				group.layout = layout;
			}

			var backgroundSkin:ImageSkin = new ImageSkin(this.headerSkinTexture);
			backgroundSkin.scale9Grid = HEADER_SCALE_9_GRID;
			backgroundSkin.width = this.gridSize;
			backgroundSkin.height = this.gridSize;
			backgroundSkin.minWidth = this.gridSize;
			backgroundSkin.minHeight = this.gridSize;
			group.backgroundSkin = backgroundSkin;
		}

	//-------------------------
	// List
	//-------------------------

		protected function setListStyles(list:List):void
		{
			this.setScrollerStyles(list);

			list.verticalScrollPolicy = ScrollPolicy.AUTO;

			var backgroundSkin:Image = new Image(this.listBackgroundSkinTexture);
			backgroundSkin.scale9Grid = DEFAULT_SCALE_9_GRID;
			backgroundSkin.width = this.controlSize;
			backgroundSkin.height = this.controlSize;
			list.backgroundSkin = backgroundSkin;

			var backgroundDisabledSkin:Image = new Image(this.buttonDisabledSkinTexture);
			backgroundSkin.scale9Grid = DEFAULT_SCALE_9_GRID;
			backgroundDisabledSkin.width = this.controlSize;
			backgroundDisabledSkin.height = this.controlSize;
			list.backgroundDisabledSkin = backgroundDisabledSkin;

			var dropIndicatorSkin:Quad = new Quad(this.borderSize, this.borderSize, PRIMARY_TEXT_COLOR);
			list.dropIndicatorSkin = dropIndicatorSkin;

			list.padding = this.borderSize;
			list.paddingRight = 0;
		}

		protected function setItemRendererStyles(itemRenderer:BaseDefaultItemRenderer):void
		{
			var skin:ImageSkin = new ImageSkin(this.itemRendererUpSkinTexture);
			skin.selectedTexture = this.itemRendererSelectedSkinTexture;
			skin.setTextureForState(ButtonState.HOVER, this.itemRendererHoverSkinTexture);
			skin.setTextureForState(ButtonState.DOWN, this.itemRendererSelectedSkinTexture);
			skin.width = this.controlSize;
			skin.height = this.controlSize;
			skin.minWidth = this.controlSize;
			skin.minHeight = this.controlSize;
			itemRenderer.defaultSkin = skin;

			itemRenderer.fontStyles = this.primaryFontStyles.clone();
			itemRenderer.disabledFontStyles = this.disabledFontStyles.clone();
			itemRenderer.iconLabelFontStyles = this.primaryFontStyles.clone();
			itemRenderer.iconLabelDisabledFontStyles = this.disabledFontStyles.clone();
			itemRenderer.accessoryLabelFontStyles = this.primaryFontStyles.clone();
			itemRenderer.accessoryLabelDisabledFontStyles = this.disabledFontStyles.clone();

			itemRenderer.horizontalAlign = HorizontalAlign.LEFT;
			itemRenderer.paddingTop = this.smallGutterSize;
			itemRenderer.paddingBottom = this.smallGutterSize;
			itemRenderer.paddingLeft = this.gutterSize;
			itemRenderer.paddingRight = this.gutterSize;
			itemRenderer.gap = this.smallGutterSize;
			itemRenderer.minGap = this.smallGutterSize;
			itemRenderer.iconPosition = RelativePosition.LEFT;
			itemRenderer.accessoryGap = Number.POSITIVE_INFINITY;
			itemRenderer.minAccessoryGap = this.smallGutterSize;
			itemRenderer.accessoryPosition = RelativePosition.RIGHT;

			itemRenderer.useStateDelayTimer = false;
		}

		protected function setDrillDownItemRendererStyles(itemRenderer:BaseDefaultItemRenderer):void
		{
			this.setItemRendererStyles(itemRenderer);

			itemRenderer.itemHasAccessory = false;
			var defaultAccessory:ImageLoader = new ImageLoader();
			defaultAccessory.source = this.listDrillDownAccessoryTexture;
			itemRenderer.defaultAccessory = defaultAccessory;
		}

		protected function setCheckItemRendererStyles(itemRenderer:BaseDefaultItemRenderer):void
		{
			var skin:ImageSkin = new ImageSkin(this.itemRendererUpSkinTexture);
			skin.selectedTexture = this.itemRendererSelectedSkinTexture;
			skin.setTextureForState(ButtonState.HOVER, this.itemRendererHoverSkinTexture);
			skin.setTextureForState(ButtonState.DOWN, this.itemRendererSelectedSkinTexture);
			skin.width = this.controlSize;
			skin.height = this.controlSize;
			skin.minWidth = this.controlSize;
			skin.minHeight = this.controlSize;
			itemRenderer.defaultSkin = skin;

			itemRenderer.itemHasIcon = false;

			var icon:ImageSkin = new ImageSkin(this.checkIconTexture);
			icon.selectedTexture = this.checkSelectedIconTexture;
			itemRenderer.defaultIcon = icon;

			itemRenderer.fontStyles = this.primaryFontStyles.clone();
			itemRenderer.disabledFontStyles = this.disabledFontStyles.clone();
			itemRenderer.iconLabelFontStyles = this.primaryFontStyles.clone();
			itemRenderer.iconLabelDisabledFontStyles = this.disabledFontStyles.clone();
			itemRenderer.accessoryLabelFontStyles = this.primaryFontStyles.clone();
			itemRenderer.accessoryLabelDisabledFontStyles = this.disabledFontStyles.clone();

			itemRenderer.horizontalAlign = HorizontalAlign.LEFT;
			itemRenderer.paddingTop = this.smallGutterSize;
			itemRenderer.paddingBottom = this.smallGutterSize;
			itemRenderer.paddingLeft = this.gutterSize;
			itemRenderer.paddingRight = this.gutterSize;
			itemRenderer.gap = this.smallGutterSize;
			itemRenderer.minGap = this.smallGutterSize;
			itemRenderer.iconPosition = RelativePosition.LEFT;
			itemRenderer.accessoryGap = Number.POSITIVE_INFINITY;
			itemRenderer.minAccessoryGap = this.smallGutterSize;
			itemRenderer.accessoryPosition = RelativePosition.RIGHT;

			itemRenderer.useStateDelayTimer = false;
		}

	//-------------------------
	// NumericStepper
	//-------------------------

		protected function setNumericStepperStyles(stepper:NumericStepper):void
		{
			stepper.buttonLayoutMode = StepperButtonLayoutMode.SPLIT_HORIZONTAL;
			stepper.incrementButtonLabel = "+";
			stepper.decrementButtonLabel = "-";

			var focusIndicatorSkin:Image = new Image(this.focusIndicatorSkinTexture);
			focusIndicatorSkin.scale9Grid = DEFAULT_SCALE_9_GRID;
			stepper.focusIndicatorSkin = focusIndicatorSkin;
			stepper.focusPadding = this.focusPaddingSize;
		}

		protected function setNumericStepperButtonStyles(button:Button):void
		{
			var skin:ImageSkin = new ImageSkin(this.buttonUpSkinTexture);
			skin.setTextureForState(ButtonState.DOWN, this.buttonDownSkinTexture);
			skin.setTextureForState(ButtonState.DISABLED, this.buttonDisabledSkinTexture);
			skin.scale9Grid = DEFAULT_SCALE_9_GRID;
			skin.width = this.controlSize;
			skin.height = this.controlSize;
			button.defaultSkin = skin;
			button.keepDownStateOnRollOut = true;
			this.setBaseButtonStyles(button);
		}

		protected function setNumericStepperTextInputStyles(input:TextInput):void
		{
			input.gap = this.smallGutterSize;
			input.paddingTop = this.smallGutterSize;
			input.paddingBottom = this.smallGutterSize;
			input.paddingLeft = this.gutterSize;
			input.paddingRight = this.gutterSize;

			input.fontStyles = this.centeredFontStyles.clone();
			input.disabledFontStyles = this.centeredDisabledFontStyles.clone();

			var skin:ImageSkin = new ImageSkin(this.insetBackgroundSkinTexture);
			skin.setTextureForState(TextInputState.DISABLED, this.insetBackgroundDisabledSkinTexture);
			skin.setTextureForState(TextInputState.FOCUSED, this.insetBackgroundFocusedSkinTexture);
			skin.scale9Grid = DEFAULT_SCALE_9_GRID;
			skin.width = this.gridSize;
			skin.height = this.controlSize;
			skin.minWidth = this.gridSize;
			skin.minHeight = this.controlSize;
			input.backgroundSkin = skin;
		}

		protected function setNumericStepperTextInputTextEditorStyles(textEditor:BitmapFontTextEditor):void
		{
			textEditor.cursorSkin = new Quad(1, 1, PRIMARY_TEXT_COLOR);
			textEditor.selectionSkin = new Quad(1, 1, BACKGROUND_COLOR);
		}

	//-------------------------
	// PageIndicator
	//-------------------------

		protected function setPageIndicatorStyles(pageIndicator:PageIndicator):void
		{
			pageIndicator.interactionMode = PageIndicatorInteractionMode.PRECISE;

			pageIndicator.normalSymbolFactory = this.pageIndicatorNormalSymbolFactory;
			pageIndicator.selectedSymbolFactory = this.pageIndicatorSelectedSymbolFactory;

			pageIndicator.gap = this.gutterSize;
			pageIndicator.padding = this.smallGutterSize;
		}

	//-------------------------
	// Panel
	//-------------------------

		protected function setPanelStyles(panel:Panel):void
		{
			this.setScrollerStyles(panel);

			var backgroundSkin:Image = new Image(this.panelBackgroundSkinTexture);
			backgroundSkin.scale9Grid = DEFAULT_SCALE_9_GRID;
			backgroundSkin.width = this.controlSize;
			backgroundSkin.height = this.controlSize;
			panel.backgroundSkin = backgroundSkin;

			panel.padding = this.gutterSize;
		}

		protected function setPanelHeaderStyles(header:Header):void
		{
			var backgroundSkin:ImageSkin = new ImageSkin(this.panelHeaderSkinTexture);
			backgroundSkin.scale9Grid = HEADER_SCALE_9_GRID;
			backgroundSkin.width = this.gridSize;
			backgroundSkin.height = this.gridSize;
			backgroundSkin.minWidth = this.gridSize;
			backgroundSkin.minHeight = this.gridSize;
			header.backgroundSkin = backgroundSkin;

			header.fontStyles = this.primaryFontStyles.clone();
			header.disabledFontStyles = this.disabledFontStyles.clone();

			header.paddingTop = this.smallGutterSize;
			header.paddingBottom = this.smallGutterSize;
			header.paddingRight = this.gutterSize;
			header.paddingLeft = this.gutterSize;
			header.gap = this.smallGutterSize;
			header.titleGap = this.smallGutterSize;
		}

	//-------------------------
	// PanelScreen
	//-------------------------

		protected function setPanelScreenStyles(screen:PanelScreen):void
		{
			this.setScrollerStyles(screen);
		}

	//-------------------------
	// PickerList
	//-------------------------

		protected function setPickerListStyles(list:PickerList):void
		{
			list.toggleButtonOnOpenAndClose = true;
			var popUpContentManager:DropDownPopUpContentManager = new DropDownPopUpContentManager();
			popUpContentManager.gap = this.dropDownGapSize;
			list.popUpContentManager = popUpContentManager;
			list.buttonFactory = pickerListButtonFactory;
		}

		protected function setPickerListButtonStyles(button:Button):void
		{
			var skin:ImageSkin = new ImageSkin(this.buttonUpSkinTexture);
			skin.setTextureForState(ButtonState.DOWN, this.buttonDownSkinTexture);
			skin.setTextureForState(ButtonState.DOWN_AND_SELECTED,  this.buttonDownSkinTexture);
			skin.setTextureForState(ButtonState.DISABLED, this.buttonDisabledSkinTexture);
			skin.scale9Grid = DEFAULT_SCALE_9_GRID;
			skin.width = this.controlSize;
			skin.height = this.controlSize;
			skin.minWidth = this.buttonMinWidth;
			skin.minHeight = this.controlSize;
			button.defaultSkin = skin;

			var icon:ImageSkin = new ImageSkin(this.pickerListButtonIconUpTexture);
			icon.disabledTexture = this.pickerListButtonIconDisabledTexture;
			if(button is ToggleButton)
			{
				//for convenience, this function can style both a regular button
				//and a toggle button
				icon.selectedTexture = this.pickerListButtonIconSelectedTexture;
			}
			button.defaultIcon = icon;

			button.fontStyles = this.primaryFontStyles.clone();
			button.disabledFontStyles = this.disabledFontStyles.clone();

			this.setBaseButtonStyles(button);

			button.gap = Number.POSITIVE_INFINITY; //fill as completely as possible
			button.minGap = this.gutterSize;
			button.iconPosition = RelativePosition.RIGHT;
			button.horizontalAlign =  HorizontalAlign.LEFT;
		}

		//for the PickerList's pop-up list, see setDropDownListStyles()

	//-------------------------
	// ProgressBar
	//-------------------------

		protected function setProgressBarStyles(progress:ProgressBar):void
		{
			var backgroundSkin:Image = new Image(this.insetBackgroundSkinTexture);
			backgroundSkin.scale9Grid = DEFAULT_SCALE_9_GRID;
			if(progress.direction == Direction.VERTICAL)
			{
				backgroundSkin.width = this.smallControlSize;
				backgroundSkin.height = this.wideControlSize;
			}
			else
			{
				backgroundSkin.width = this.wideControlSize;
				backgroundSkin.height = this.smallControlSize;
			}
			progress.backgroundSkin = backgroundSkin;

			var backgroundDisabledSkin:Image = new Image(this.insetBackgroundDisabledSkinTexture);
			backgroundDisabledSkin.scale9Grid = DEFAULT_SCALE_9_GRID;
			if(progress.direction == Direction.VERTICAL)
			{
				backgroundDisabledSkin.width = this.smallControlSize;
				backgroundDisabledSkin.height = this.wideControlSize;
			}
			else
			{
				backgroundDisabledSkin.width = this.wideControlSize;
				backgroundDisabledSkin.height = this.smallControlSize;
			}
			progress.backgroundDisabledSkin = backgroundDisabledSkin;

			var fillSkin:Image = new Image(this.buttonUpSkinTexture);
			fillSkin.scale9Grid = DEFAULT_SCALE_9_GRID;
			if(progress.direction == Direction.VERTICAL)
			{
				fillSkin.width = this.smallControlSize;
				fillSkin.height = this.progressBarFillMinSize;
			}
			else
			{
				fillSkin.width = this.progressBarFillMinSize;
				fillSkin.height = this.smallControlSize;
			}
			progress.fillSkin = fillSkin;

			var fillDisabledSkin:Image = new Image(this.buttonDisabledSkinTexture);
			fillDisabledSkin.scale9Grid = DEFAULT_SCALE_9_GRID;
			if(progress.direction == Direction.VERTICAL)
			{
				fillDisabledSkin.width = this.smallControlSize;
				fillDisabledSkin.height = this.progressBarFillMinSize;
			}
			else
			{
				fillDisabledSkin.width = this.progressBarFillMinSize;
				fillDisabledSkin.height = this.smallControlSize;
			}
			progress.fillDisabledSkin = fillDisabledSkin;
		}

	//-------------------------
	// Radio
	//-------------------------

		protected function setRadioStyles(radio:Radio):void
		{
			var skin:Quad = new Quad(this.controlSize, this.controlSize);
			skin.alpha = 0;
			radio.defaultSkin = skin;

			var icon:ImageSkin = new ImageSkin(this.radioIconTexture);
			icon.selectedTexture = this.radioSelectedIconTexture;
			icon.setTextureForState(ButtonState.DISABLED, this.radioDisabledIconTexture);
			icon.setTextureForState(ButtonState.DISABLED_AND_SELECTED,  this.radioSelectedDisabledIconTexture);
			radio.defaultIcon = icon;

			var focusIndicatorSkin:Image = new Image(this.focusIndicatorSkinTexture);
			focusIndicatorSkin.scale9Grid = DEFAULT_SCALE_9_GRID;
			radio.focusIndicatorSkin = focusIndicatorSkin;
			radio.focusPadding = this.focusPaddingSize;

			radio.fontStyles = this.primaryFontStyles.clone();
			radio.disabledFontStyles = this.disabledFontStyles.clone();

			radio.gap = this.smallGutterSize;
			radio.horizontalAlign = HorizontalAlign.LEFT;
			radio.verticalAlign = VerticalAlign.MIDDLE;
		}

	//-------------------------
	// ScrollBar
	//-------------------------

		protected function setHorizontalScrollBarStyles(scrollBar:ScrollBar):void
		{
			scrollBar.trackLayoutMode = TrackLayoutMode.SINGLE;

			scrollBar.customIncrementButtonStyleName = THEME_STYLE_NAME_HORIZONTAL_SCROLL_BAR_INCREMENT_BUTTON;
			scrollBar.customDecrementButtonStyleName = THEME_STYLE_NAME_HORIZONTAL_SCROLL_BAR_DECREMENT_BUTTON;
		}

		protected function setVerticalScrollBarStyles(scrollBar:ScrollBar):void
		{
			scrollBar.trackLayoutMode = TrackLayoutMode.SINGLE;

			scrollBar.customIncrementButtonStyleName = THEME_STYLE_NAME_VERTICAL_SCROLL_BAR_INCREMENT_BUTTON;
			scrollBar.customDecrementButtonStyleName = THEME_STYLE_NAME_VERTICAL_SCROLL_BAR_DECREMENT_BUTTON;
		}

		protected function setScrollBarThumbStyles(thumb:Button):void
		{
			var skin:ImageSkin = new ImageSkin(this.thumbSkinTexture);
			skin.setTextureForState(ButtonState.DISABLED, this.thumbDisabledSkinTexture);
			skin.scale9Grid = DEFAULT_SCALE_9_GRID;
			skin.minWidth = this.smallControlSize;
			skin.minHeight = this.smallControlSize;
			thumb.defaultSkin = skin;

			thumb.hasLabelTextRenderer = false;
		}

		protected function setScrollBarMinimumTrackStyles(track:Button):void
		{
			var skin:ImageSkin = new ImageSkin(this.insetBackgroundSkinTexture);
			skin.disabledTexture = this.insetBackgroundDisabledSkinTexture;
			skin.scale9Grid = DEFAULT_SCALE_9_GRID;
			skin.width = this.smallControlSize;
			skin.height = this.smallControlSize;
			track.defaultSkin = skin;

			track.hasLabelTextRenderer = false;
		}

		protected function setBaseScrollBarButtonStyles(button:Button):void
		{
			var skin:ImageSkin = new ImageSkin(this.buttonUpSkinTexture);
			skin.setTextureForState(ButtonState.DOWN, this.buttonDownSkinTexture);
			skin.setTextureForState(ButtonState.DISABLED, this.buttonDisabledSkinTexture);
			skin.scale9Grid = DEFAULT_SCALE_9_GRID;
			skin.width = this.smallControlSize;
			skin.height = this.smallControlSize;
			skin.minWidth = this.smallControlSize;
			skin.minHeight = this.smallControlSize;
			button.defaultSkin = skin;

			button.horizontalAlign = HorizontalAlign.CENTER;
			button.verticalAlign = VerticalAlign.MIDDLE;
			button.padding = 0;
			button.gap = 0;
			button.minGap = 0;

			button.hasLabelTextRenderer = false;
		}

		protected function setHorizontalScrollBarDecrementButtonStyles(button:Button):void
		{
			this.setBaseScrollBarButtonStyles(button);

			var defaultIcon:Image = new Image(this.horizontalScrollBarDecrementButtonIconTexture);
			button.defaultIcon = defaultIcon;

			var disabledIcon:Quad = new Quad(this.horizontalScrollBarDecrementButtonIconTexture.frameWidth,
				this.horizontalScrollBarDecrementButtonIconTexture.frameHeight);
			button.disabledIcon = disabledIcon;
		}

		protected function setHorizontalScrollBarIncrementButtonStyles(button:Button):void
		{
			this.setBaseScrollBarButtonStyles(button);

			var defaultIcon:Image = new Image(this.horizontalScrollBarIncrementButtonIconTexture);
			button.defaultIcon = defaultIcon;

			var disabledIcon:Quad = new Quad(this.horizontalScrollBarIncrementButtonIconTexture.frameWidth,
				this.horizontalScrollBarIncrementButtonIconTexture.frameHeight);
			button.disabledIcon = disabledIcon;
		}

		protected function setVerticalScrollBarDecrementButtonStyles(button:Button):void
		{
			this.setBaseScrollBarButtonStyles(button);

			var defaultIcon:Image = new Image(this.verticalScrollBarDecrementButtonIconTexture);
			button.defaultIcon = defaultIcon;

			var disabledIcon:Quad = new Quad(this.verticalScrollBarDecrementButtonIconTexture.frameWidth,
				this.verticalScrollBarDecrementButtonIconTexture.frameHeight);
			button.disabledIcon = disabledIcon;
		}

		protected function setVerticalScrollBarIncrementButtonStyles(button:Button):void
		{
			this.setBaseScrollBarButtonStyles(button);

			var defaultIcon:Image = new Image(this.verticalScrollBarIncrementButtonIconTexture);
			button.defaultIcon = defaultIcon;

			var disabledIcon:Quad = new Quad(this.verticalScrollBarIncrementButtonIconTexture.frameWidth,
				this.verticalScrollBarIncrementButtonIconTexture.frameHeight);
			button.disabledIcon = disabledIcon;
		}

	//-------------------------
	// ScrollContainer
	//-------------------------

		protected function setScrollContainerStyles(container:ScrollContainer):void
		{
			this.setScrollerStyles(container);
		}

		protected function setToolbarScrollContainerStyles(container:ScrollContainer):void
		{
			this.setScrollerStyles(container);

			if(!container.layout)
			{
				var layout:HorizontalLayout = new HorizontalLayout();
				layout.padding = this.gutterSize;
				layout.gap = this.smallGutterSize;
				layout.verticalAlign = VerticalAlign.MIDDLE;
				container.layout = layout;
			}

			var backgroundSkin:ImageSkin = new ImageSkin(this.headerSkinTexture);
			backgroundSkin.scale9Grid = HEADER_SCALE_9_GRID;
			backgroundSkin.width = this.gridSize;
			backgroundSkin.height = this.gridSize;
			backgroundSkin.minWidth = this.gridSize;
			backgroundSkin.minHeight = this.gridSize;
			container.backgroundSkin = backgroundSkin;
		}

	//-------------------------
	// ScrollScreen
	//-------------------------

		protected function setScrollScreenStyles(screen:ScrollScreen):void
		{
			this.setScrollerStyles(screen);
		}

	//-------------------------
	// ScrollText
	//-------------------------

		protected function setScrollTextStyles(text:ScrollText):void
		{
			this.setScrollerStyles(text);

			text.fontStyles = this.scrollTextFontStyles.clone();
			text.disabledFontStyles = this.scrollTextDisabledFontStyles.clone();

			text.padding = this.gutterSize;
		}

	//-------------------------
	// SimpleScrollBar
	//-------------------------

		protected function setSimpleScrollBarThumbStyles(thumb:Button):void
		{
			var defaultSkin:Image = new Image(this.simpleScrollBarThumbSkinTexture);
			defaultSkin.scale9Grid = SCROLLBAR_THUMB_SCALE_9_GRID;
			defaultSkin.width = this.smallControlSize;
			defaultSkin.height = this.smallControlSize;
			thumb.defaultSkin = defaultSkin;

			thumb.hasLabelTextRenderer = false;
		}

	//-------------------------
	// Slider
	//-------------------------

		protected function setSliderStyles(slider:Slider):void
		{
			slider.trackLayoutMode = TrackLayoutMode.SINGLE;

			if(slider.direction == Direction.VERTICAL)
			{
				slider.customMinimumTrackStyleName = THEME_STYLE_NAME_VERTICAL_SLIDER_MINIMUM_TRACK;
			}
			else //horizontal
			{
				slider.customMinimumTrackStyleName = THEME_STYLE_NAME_HORIZONTAL_SLIDER_MINIMUM_TRACK;
			}

			var focusIndicatorSkin:Image = new Image(this.focusIndicatorSkinTexture);
			focusIndicatorSkin.scale9Grid = DEFAULT_SCALE_9_GRID;
			slider.focusIndicatorSkin = focusIndicatorSkin;
			slider.focusPadding = this.focusPaddingSize;
		}

		protected function setHorizontalSliderMinimumTrackStyles(track:Button):void
		{
			var skin:ImageSkin = new ImageSkin(this.insetBackgroundSkinTexture);
			skin.setTextureForState(ButtonState.DISABLED, this.insetBackgroundDisabledSkinTexture);
			skin.scale9Grid = DEFAULT_SCALE_9_GRID;
			skin.width = this.wideControlSize;
			skin.height = this.smallControlSize;
			skin.minWidth = this.wideControlSize;
			skin.minHeight = this.smallControlSize;
			track.defaultSkin = skin;

			track.hasLabelTextRenderer = false;
		}

		protected function setVerticalSliderMinimumTrackStyles(track:Button):void
		{
			var skin:ImageSkin = new ImageSkin(this.insetBackgroundSkinTexture);
			skin.setTextureForState(ButtonState.DISABLED, this.insetBackgroundDisabledSkinTexture);
			skin.scale9Grid = DEFAULT_SCALE_9_GRID;
			skin.width = this.smallControlSize;
			skin.height = this.wideControlSize;
			skin.minWidth = this.smallControlSize;
			skin.minHeight = this.wideControlSize;
			track.defaultSkin = skin;

			track.hasLabelTextRenderer = false;
		}

		protected function setSliderThumbStyles(thumb:Button):void
		{
			var skin:ImageSkin = new ImageSkin(this.thumbSkinTexture);
			skin.setTextureForState(ButtonState.DISABLED, this.thumbDisabledSkinTexture);
			skin.scale9Grid = DEFAULT_SCALE_9_GRID;
			skin.width = this.smallControlSize;
			skin.height = this.smallControlSize;
			thumb.defaultSkin = skin;

			thumb.hasLabelTextRenderer = false;
		}

	//-------------------------
	// SpinnerList
	//-------------------------

		protected function setSpinnerListStyles(list:SpinnerList):void
		{
			this.setListStyles(list);
		}

	//-------------------------
	// TabBar
	//-------------------------

		protected function setTabBarStyles(tabBar:TabBar):void
		{
			tabBar.distributeTabSizes = false;
			tabBar.horizontalAlign = HorizontalAlign.LEFT;
			tabBar.verticalAlign = VerticalAlign.JUSTIFY;
		}

		protected function setTabStyles(tab:ToggleButton):void
		{
			var skin:ImageSkin = new ImageSkin(this.tabSkinTexture);
			skin.selectedTexture = this.tabSelectedSkinTexture;
			skin.setTextureForState(ButtonState.DISABLED, this.tabDisabledSkinTexture);
			skin.setTextureForState(ButtonState.DISABLED_AND_SELECTED,  this.tabSelectedDisabledSkinTexture);
			skin.scale9Grid = TAB_SCALE_9_GRID;
			skin.width = this.controlSize;
			skin.height = this.controlSize;
			skin.minWidth = this.controlSize;
			skin.minHeight = this.controlSize;
			tab.defaultSkin = skin;

			tab.fontStyles = this.primaryFontStyles.clone();
			tab.disabledFontStyles = this.disabledFontStyles.clone();

			tab.iconPosition = RelativePosition.LEFT;

			tab.paddingTop = this.smallGutterSize;
			tab.paddingBottom = this.smallGutterSize;
			tab.paddingLeft = this.gutterSize;
			tab.paddingRight = this.gutterSize;
			tab.gap = this.smallGutterSize;
		}

	//-------------------------
	// TextArea
	//-------------------------

		protected function setTextAreaStyles(textArea:TextArea):void
		{
			this.setScrollerStyles(textArea);

			textArea.padding = this.borderSize;

			var skin:ImageSkin = new ImageSkin(this.insetBackgroundSkinTexture);
			skin.setTextureForState(TextInputState.DISABLED, this.insetBackgroundDisabledSkinTexture);
			skin.setTextureForState(TextInputState.FOCUSED, this.insetBackgroundFocusedSkinTexture);
			skin.setTextureForState(TextInputState.ERROR, this.insetBackgroundDangerSkinTexture);
			skin.scale9Grid = DEFAULT_SCALE_9_GRID;
			skin.width = this.wideControlSize * 2;
			skin.height = this.wideControlSize;
			textArea.backgroundSkin = skin;

			textArea.fontStyles = this.scrollTextFontStyles.clone();
			textArea.disabledFontStyles = this.scrollTextDisabledFontStyles.clone();

			textArea.promptFontStyles = this.primaryFontStyles.clone();
			textArea.promptDisabledFontStyles = this.disabledFontStyles.clone();

			textArea.focusPadding = this.focusPaddingSize;
			
			textArea.innerPaddingTop = this.extraSmallGutterSize;
			textArea.innerPaddingRight = this.smallGutterSize;
			textArea.innerPaddingBottom = this.extraSmallGutterSize;
			textArea.innerPaddingLeft = this.smallGutterSize;
		}

		protected function setTextAreaErrorCalloutStyles(callout:TextCallout):void
		{
			this.setDangerTextCalloutStyles(callout);
			callout.horizontalAlign = HorizontalAlign.LEFT;
			callout.verticalAlign = VerticalAlign.TOP;
		}

	//-------------------------
	// TextCallout
	//-------------------------

		protected function setTextCalloutStyles(callout:TextCallout):void
		{
			this.setCalloutStyles(callout);

			callout.fontStyles = this.primaryFontStyles.clone();
			callout.disabledFontStyles = this.disabledFontStyles.clone();
		}

		protected function setDangerTextCalloutStyles(callout:TextCallout):void
		{
			this.setDangerCalloutStyles(callout);

			callout.fontStyles = this.dangerFontStyles.clone();
			callout.disabledFontStyles = this.disabledFontStyles.clone();
		}

	//-------------------------
	// TextInput
	//-------------------------

		protected function setBaseTextInputStyles(input:TextInput):void
		{
			var skin:ImageSkin = new ImageSkin(this.insetBackgroundSkinTexture);
			skin.setTextureForState(TextInputState.DISABLED, this.insetBackgroundDisabledSkinTexture);
			skin.setTextureForState(TextInputState.FOCUSED, this.insetBackgroundFocusedSkinTexture);
			skin.setTextureForState(TextInputState.ERROR, this.insetBackgroundDangerSkinTexture);
			skin.scale9Grid = DEFAULT_SCALE_9_GRID;
			skin.width = this.wideControlSize;
			skin.height = this.controlSize;
			skin.minWidth = this.wideControlSize;
			skin.minHeight = this.controlSize;
			input.backgroundSkin = skin;

			var focusIndicatorSkin:Image = new Image(this.focusIndicatorSkinTexture);
			focusIndicatorSkin.scale9Grid = DEFAULT_SCALE_9_GRID;
			input.focusIndicatorSkin = focusIndicatorSkin;
			input.focusPadding = this.focusPaddingSize;

			input.fontStyles = this.primaryFontStyles.clone();
			input.disabledFontStyles = this.disabledFontStyles.clone();

			input.promptFontStyles = this.primaryFontStyles.clone();
			input.promptDisabledFontStyles = this.disabledFontStyles.clone();

			input.gap = this.smallGutterSize;
			input.paddingTop = this.smallGutterSize;
			input.paddingBottom = this.smallGutterSize;
			input.paddingLeft = this.gutterSize;
			input.paddingRight = this.gutterSize;
		}

		protected function setTextInputStyles(input:TextInput):void
		{
			this.setBaseTextInputStyles(input);
		}

		protected function setSearchTextInputStyles(input:TextInput):void
		{
			this.setBaseTextInputStyles(input);

			var icon:ImageSkin = new ImageSkin(this.searchIconTexture);
			icon.disabledTexture = this.searchIconDisabledTexture;
			input.defaultIcon = icon;
		}

		protected function setTextInputTextEditorStyles(textEditor:BitmapFontTextEditor):void
		{
			textEditor.cursorSkin = new Quad(1, 1, PRIMARY_TEXT_COLOR);
			textEditor.selectionSkin = new Quad(1, 1, BACKGROUND_COLOR);
		}

		protected function setTextInputErrorCalloutStyles(callout:TextCallout):void
		{
			this.setDangerTextCalloutStyles(callout);
			callout.horizontalAlign = HorizontalAlign.LEFT;
			callout.verticalAlign = VerticalAlign.TOP;
		}

	//-------------------------
	// Toast
	//-------------------------

		protected function setToastStyles(toast:Toast):void
		{
			var backgroundSkin:Quad = new Quad(1, 1, MODAL_OVERLAY_COLOR);
			toast.backgroundSkin = backgroundSkin;

			toast.fontStyles = this.primaryFontStyles.clone();
			toast.disabledFontStyles = this.disabledFontStyles.clone();

			toast.width = this.extraWideControlSize;
			toast.paddingTop = this.smallGutterSize;
			toast.paddingRight = this.gutterSize;
			toast.paddingBottom = this.smallGutterSize;
			toast.paddingLeft = this.gutterSize;
			toast.gap = Number.POSITIVE_INFINITY;
			toast.minGap = this.smallGutterSize;
			toast.horizontalAlign = HorizontalAlign.LEFT;
			toast.verticalAlign = VerticalAlign.MIDDLE;
		}

		protected function setToastActionsStyles(group:ButtonGroup):void
		{
			group.direction = Direction.HORIZONTAL;
			group.gap = this.smallGutterSize;
			group.customButtonStyleName = THEME_STYLE_NAME_TOAST_ACTIONS_BUTTON;
		}

		protected function setToastActionsButtonStyles(button:Button):void
		{
			button.fontStyles = this.primaryFontStyles.clone();
			button.disabledFontStyles = this.primaryFontStyles.clone();
		}

	//-------------------------
	// ToggleSwitch
	//-------------------------

		protected function setToggleSwitchStyles(toggleSwitch:ToggleSwitch):void
		{
			toggleSwitch.trackLayoutMode = TrackLayoutMode.SINGLE;

			var focusIndicatorSkin:Image = new Image(this.focusIndicatorSkinTexture);
			focusIndicatorSkin.scale9Grid = DEFAULT_SCALE_9_GRID;
			toggleSwitch.focusIndicatorSkin = focusIndicatorSkin;
			toggleSwitch.focusPadding = this.focusPaddingSize;

			toggleSwitch.offLabelFontStyles = this.primaryFontStyles.clone();
			toggleSwitch.offLabelDisabledFontStyles = this.disabledFontStyles.clone();

			toggleSwitch.onLabelFontStyles = this.primaryFontStyles.clone();
			toggleSwitch.onLabelDisabledFontStyles = this.disabledFontStyles.clone();
		}

		protected function setToggleSwitchOnTrackStyles(track:Button):void
		{
			var skin:ImageSkin = new ImageSkin(this.insetBackgroundSkinTexture);
			skin.setTextureForState(ButtonState.DISABLED, this.insetBackgroundDisabledSkinTexture);
			skin.scale9Grid = DEFAULT_SCALE_9_GRID;
			skin.width = Math.round(this.controlSize * 2.5);
			skin.height = this.controlSize;
			track.defaultSkin = skin;

			track.hasLabelTextRenderer = false;
		}

		protected function setToggleSwitchThumbStyles(thumb:Button):void
		{
			var skin:ImageSkin = new ImageSkin(this.thumbSkinTexture);
			skin.setTextureForState(ButtonState.DISABLED, this.thumbDisabledSkinTexture);
			skin.scale9Grid = DEFAULT_SCALE_9_GRID;
			skin.width = this.controlSize;
			skin.height = this.controlSize;
			thumb.defaultSkin = skin;

			thumb.hasLabelTextRenderer = false;
		}

	//-------------------------
	// Tree
	//-------------------------

		protected function setTreeStyles(tree:Tree):void
		{
			this.setScrollerStyles(tree);

			tree.verticalScrollPolicy = ScrollPolicy.AUTO;

			var backgroundSkin:Image = new Image(this.listBackgroundSkinTexture);
			backgroundSkin.scale9Grid = DEFAULT_SCALE_9_GRID;
			backgroundSkin.width = this.controlSize;
			backgroundSkin.height = this.controlSize;
			tree.backgroundSkin = backgroundSkin;

			var backgroundDisabledSkin:Image = new Image(this.buttonDisabledSkinTexture);
			backgroundSkin.scale9Grid = DEFAULT_SCALE_9_GRID;
			backgroundDisabledSkin.width = this.controlSize;
			backgroundDisabledSkin.height = this.controlSize;
			tree.backgroundDisabledSkin = backgroundDisabledSkin;

			tree.padding = this.borderSize;
			tree.paddingRight = 0;
		}

		protected function setTreeItemRendererStyles(itemRenderer:DefaultTreeItemRenderer):void
		{
			this.setItemRendererStyles(itemRenderer);

			itemRenderer.indentation = this.treeDisclosureOpenIconTexture.width;
			itemRenderer.disclosureGap = this.gutterSize;

			var disclosureOpenIcon:ImageSkin = new ImageSkin(this.treeDisclosureOpenIconTexture);
			disclosureOpenIcon.textureSmoothing = TextureSmoothing.NONE;
			disclosureOpenIcon.pixelSnapping = true;
			itemRenderer.disclosureOpenIcon = disclosureOpenIcon;

			var disclosureClosedIcon:ImageSkin = new ImageSkin(this.treeDisclosureClosedIconTexture);
			disclosureClosedIcon.textureSmoothing = TextureSmoothing.NONE;
			disclosureClosedIcon.pixelSnapping = true;
			itemRenderer.disclosureClosedIcon = disclosureClosedIcon;
		}

	//-------------------------
	// VideoPlayer
	//-------------------------

		protected function setVideoPlayerStyles(player:VideoPlayer):void
		{
			player.backgroundSkin = new Quad(1, 1, 0x000000);
		}

	//-------------------------
	// PlayPauseToggleButton
	//-------------------------

		protected function setPlayPauseToggleButtonStyles(button:PlayPauseToggleButton):void
		{
			var defaultSkin:Quad = new Quad(this.controlSize, this.controlSize, 0xff00ff);
			defaultSkin.alpha = 0;
			button.defaultSkin = defaultSkin;

			var otherSkin:ImageSkin = new ImageSkin(null);
			otherSkin.setTextureForState(ButtonState.DOWN, this.buttonDownSkinTexture);
			otherSkin.setTextureForState(ButtonState.DOWN_AND_SELECTED, this.buttonDownSkinTexture);
			otherSkin.width = this.controlSize;
			otherSkin.height = this.controlSize;
			otherSkin.minWidth = this.controlSize;
			otherSkin.minHeight = this.controlSize;
			button.setSkinForState(ButtonState.DOWN, otherSkin);
			button.setSkinForState(ButtonState.DOWN_AND_SELECTED, otherSkin);

			var icon:ImageSkin = new ImageSkin(this.playPauseButtonPlayUpIconTexture);
			icon.selectedTexture = this.playPauseButtonPauseUpIconTexture;
			icon.textureSmoothing = TextureSmoothing.NONE;
			button.defaultIcon = icon;

			var focusIndicatorSkin:Image = new Image(this.focusIndicatorSkinTexture);
			focusIndicatorSkin.scale9Grid = DEFAULT_SCALE_9_GRID;
			button.focusIndicatorSkin = focusIndicatorSkin;
			button.focusPadding = this.focusPaddingSize;

			button.hasLabelTextRenderer = false;

			button.padding = this.smallGutterSize;
			button.gap = this.smallGutterSize;
			button.minGap = this.smallGutterSize;
		}

		protected function setOverlayPlayPauseToggleButtonStyles(button:PlayPauseToggleButton):void
		{
			var icon:ImageSkin = new ImageSkin(null);
			icon.setTextureForState(ButtonState.UP, this.overlayPlayPauseButtonPlayUpIconTexture);
			icon.setTextureForState(ButtonState.HOVER, this.overlayPlayPauseButtonPlayUpIconTexture);
			icon.setTextureForState(ButtonState.DOWN, this.overlayPlayPauseButtonPlayDownIconTexture);
			button.defaultIcon = icon;

			button.hasLabelTextRenderer = false;

			var skin:Quad = new Quad(this.overlayPlayPauseButtonPlayUpIconTexture.width,
				this.overlayPlayPauseButtonPlayUpIconTexture.height);
			skin.alpha = 0;
			button.defaultSkin = skin;

			var overlaySkin:Quad = new Quad(1, 1, VIDEO_OVERLAY_COLOR);
			overlaySkin.alpha = VIDEO_OVERLAY_ALPHA;
			button.upSkin = overlaySkin;
			button.hoverSkin = overlaySkin;
		}

	//-------------------------
	// FullScreenToggleButton
	//-------------------------

		protected function setFullScreenToggleButtonStyles(button:FullScreenToggleButton):void
		{
			var defaultSkin:Quad = new Quad(this.controlSize, this.controlSize, 0xff00ff);
			defaultSkin.alpha = 0;
			button.defaultSkin = defaultSkin;

			var otherSkin:ImageSkin = new ImageSkin(null);
			otherSkin.setTextureForState(ButtonState.DOWN, this.buttonDownSkinTexture);
			otherSkin.setTextureForState(ButtonState.DOWN_AND_SELECTED, this.buttonDownSkinTexture);
			otherSkin.width = this.controlSize;
			otherSkin.height = this.controlSize;
			otherSkin.minWidth = this.controlSize;
			otherSkin.minHeight = this.controlSize;
			button.setSkinForState(ButtonState.DOWN, otherSkin);
			button.setSkinForState(ButtonState.DOWN_AND_SELECTED, otherSkin);

			var icon:ImageSkin = new ImageSkin(this.fullScreenToggleButtonEnterUpIconTexture);
			icon.selectedTexture = this.fullScreenToggleButtonExitUpIconTexture;
			button.defaultIcon = icon;

			var focusIndicatorSkin:Image = new Image(this.focusIndicatorSkinTexture);
			focusIndicatorSkin.scale9Grid = DEFAULT_SCALE_9_GRID;
			button.focusIndicatorSkin = focusIndicatorSkin;
			button.focusPadding = this.focusPaddingSize;

			button.hasLabelTextRenderer = false;

			button.padding = this.smallGutterSize;
			button.gap = this.smallGutterSize;
			button.minGap = this.smallGutterSize;
		}

	//-------------------------
	// MuteToggleButton
	//-------------------------

		protected function setMuteToggleButtonStyles(button:MuteToggleButton):void
		{
			var defaultSkin:Quad = new Quad(this.controlSize, this.controlSize, 0xff00ff);
			defaultSkin.alpha = 0;
			button.defaultSkin = defaultSkin;

			var otherSkin:ImageSkin = new ImageSkin(null);
			otherSkin.setTextureForState(ButtonState.DOWN, this.buttonDownSkinTexture);
			otherSkin.setTextureForState(ButtonState.DOWN_AND_SELECTED, this.buttonDownSkinTexture);
			otherSkin.width = this.controlSize;
			otherSkin.height = this.controlSize;
			otherSkin.minWidth = this.controlSize;
			otherSkin.minHeight = this.controlSize;
			button.setSkinForState(ButtonState.DOWN, otherSkin);
			button.setSkinForState(ButtonState.DOWN_AND_SELECTED, otherSkin);

			var icon:ImageSkin = new ImageSkin(this.muteToggleButtonLoudUpIconTexture);
			icon.selectedTexture = this.muteToggleButtonMutedUpIconTexture;
			icon.textureSmoothing = TextureSmoothing.NONE;
			button.defaultIcon = icon;

			var focusIndicatorSkin:Image = new Image(this.focusIndicatorSkinTexture);
			focusIndicatorSkin.scale9Grid = DEFAULT_SCALE_9_GRID;
			button.focusIndicatorSkin = focusIndicatorSkin;
			button.focusPadding = this.focusPaddingSize;

			button.hasLabelTextRenderer = false;
			button.showVolumeSliderOnHover = true;

			button.padding = this.smallGutterSize;
			button.gap = this.smallGutterSize;
			button.minGap = this.smallGutterSize;
		}

		protected function setPopUpVolumeSliderStyles(slider:VolumeSlider):void
		{
			slider.direction = Direction.VERTICAL;
			slider.trackLayoutMode = TrackLayoutMode.SINGLE;
			var focusIndicatorSkin:Image = new Image(this.focusIndicatorSkinTexture);
			focusIndicatorSkin.scale9Grid = DEFAULT_SCALE_9_GRID;
			slider.focusIndicatorSkin = focusIndicatorSkin;
			slider.focusPadding = this.focusPaddingSize;
			slider.maximumPadding = this.popUpVolumeSliderPaddingTopLeft;
			slider.minimumPadding = this.popUpVolumeSliderPaddingBottomRight;
			slider.thumbOffset = -Math.round(this.dropShadowSize / 2);
			slider.customThumbStyleName = THEME_STYLE_NAME_POP_UP_VOLUME_SLIDER_THUMB;
			slider.customMinimumTrackStyleName = THEME_STYLE_NAME_POP_UP_VOLUME_SLIDER_MINIMUM_TRACK;
			slider.width = this.smallControlSize + this.popUpVolumeSliderPaddingTopLeft + this.popUpVolumeSliderPaddingBottomRight;
			slider.height = this.wideControlSize + this.popUpVolumeSliderPaddingTopLeft + this.popUpVolumeSliderPaddingBottomRight;
		}

		protected function setPopUpVolumeSliderTrackStyles(track:Button):void
		{
			var skin:Image = new Image(this.popUpVolumeSliderTrackSkinTexture);
			skin.scale9Grid = VOLUME_SLIDER_TRACK_SCALE9_GRID;
			track.defaultSkin = skin;

			track.hasLabelTextRenderer = false;
		}

	//-------------------------
	// SeekSlider
	//-------------------------

		protected function setSeekSliderStyles(slider:SeekSlider):void
		{
			this.setSliderStyles(slider);

			var progressSkin:Image = new Image(this.seekSliderProgressSkinTexture);
			progressSkin.scale9Grid = SEEK_SLIDER_PROGRESS_SKIN_SCALE9_GRID;
			slider.progressSkin = progressSkin;
		}

	//-------------------------
	// VolumeSlider
	//-------------------------

		protected function setVolumeSliderStyles(slider:VolumeSlider):void
		{
			slider.direction = Direction.HORIZONTAL;
			slider.trackLayoutMode = TrackLayoutMode.SPLIT;
			var focusIndicatorSkin:Image = new Image(this.focusIndicatorSkinTexture);
			focusIndicatorSkin.scale9Grid = DEFAULT_SCALE_9_GRID;
			slider.focusIndicatorSkin = focusIndicatorSkin;
			slider.focusPadding = this.focusPaddingSize;
			slider.showThumb = false;
		}

		protected function setVolumeSliderThumbStyles(thumb:Button):void
		{
			var thumbSize:Number = 6;
			var defaultSkin:Quad = new Quad(thumbSize, thumbSize);
			defaultSkin.width = 0;
			defaultSkin.height = 0;
			thumb.defaultSkin = defaultSkin;
			thumb.hasLabelTextRenderer = false;
		}

		protected function setVolumeSliderMinimumTrackStyles(track:Button):void
		{
			var defaultSkin:ImageLoader = new ImageLoader();
			defaultSkin.scaleContent = false;
			defaultSkin.source = this.volumeSliderMinimumTrackSkinTexture;
			track.defaultSkin = defaultSkin;

			track.hasLabelTextRenderer = false;
		}

		protected function setVolumeSliderMaximumTrackStyles(track:Button):void
		{
			var defaultSkin:ImageLoader = new ImageLoader();
			defaultSkin.scaleContent = false;
			defaultSkin.horizontalAlign = HorizontalAlign.RIGHT;
			defaultSkin.source = this.volumeSliderMaximumTrackSkinTexture;
			track.defaultSkin = defaultSkin;

			track.hasLabelTextRenderer = false;
		}
	}
}
