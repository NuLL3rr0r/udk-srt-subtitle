package GameUi {
	import fl.transitions.*;
	import fl.transitions.easing.*;
	import fl.transitions.Tween;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	import flash.text.*;
	import flashx.textLayout.accessibility.TextAccImpl;
    import flash.utils.Timer;

	public class Subtitle extends Sprite {
		private var m_antiAlias:String;
		private var m_autoRaise:Boolean;
		private var m_character:String;

		private var m_characters:Object;
		// This next line forces SubtitleCharacterItem to be compiled in, which
		// is necessary because being mentioned in the Collection
		// metadata does not necessarily do this.
		private var m_forceSubtitleCharacterItem:SubtitleCharacterItem

		private var m_fontName:String;
		private var m_fontSize:Object;
		private var m_isInitialized:Boolean; // it has to be true on last properties initialization
		private var m_manualRaise:Boolean;
		private var m_motionBlur:Number;
		private var m_motionBlurQuality:int;
		private var m_multiLine:Boolean;
		private var m_narrator:Boolean;
		private var m_renderAsHTML:Boolean;
		private var m_text:String;
		private var m_textAlignment:String;
		private var m_textColor:Object;
		private var m_timeOut:Number;
		private var m_transitionEasingAppear:Function;
		private var m_transitionEasingDisappear:Function;
		private var m_transitionEffectAppear:String;
		private var m_transitionEffectDisappear:String;
		private var m_transitionDurationAppear:Number;
		private var m_transitionDurationDisappear:Number;
		private var m_transitionIrishEffectShapeAppear:String;
		private var m_transitionIrishEffectShapeDisappear:String;
		private var m_wordWrap:Boolean;

		private var m_container:MovieClip

		private var m_currentSubtitleColor:Object;
		private var m_currentSubtitleTimeOut:Number;

		// Gfx fix
		private var m_transitions:Array;
		private var m_transitionManager:TransitionManager;
		private var m_timer:Timer;

		[Inspectable(enumeration="Advanced, Normal", defaultValue="Advanced", type="List")]
		public function get AntiAlias():String {
			return m_antiAlias.toUpperCase().substr(0, 1)
					+ m_antiAlias.toLocaleLowerCase().substr(1);
		}
		public function set AntiAlias(value:String):void {
			var antiAlias:String;
			
			switch (value) {
				case "Advanced":
					antiAlias = AntiAliasType.ADVANCED;
					break;
				case "Normal":
					antiAlias = AntiAliasType.NORMAL;
					break;
				default:
					antiAlias = AntiAliasType.ADVANCED;
					break;
			}
			
			m_antiAlias = antiAlias;
			Draw();
		}

		[Inspectable(defaultValue="false", type="Boolean")]
		public function get AutoRaise():Boolean {
			return m_autoRaise;
		}
		public function set AutoRaise(value:Boolean):void {
			m_autoRaise = value;
			Draw();
		}

		[Inspectable(defaultValue="", type="String")]
		public function get Character():String {
			return m_character;
		}
		public function set Character(value:String):void {
			m_character = Utils.Trim(value);
			Draw();
		}

		[Collection(collectionClass="GameUi.SubtitleCharacterCollection", collectionItem="GameUi.SubtitleCharacterItem", identifier="id")]
		public function get Characters():Object {
			return m_characters;
		}
		public function set Characters(value:Object):void {
			m_characters = value;
			
			var hasSelected:Boolean = false;

			// This next line forces SubtitleCharacterCollection to be compiled in,
			// which is necessary because being mentioned in the Collection
			// metadata does not necessarily do this.
			var c:SubtitleCharacterCollection = m_characters as SubtitleCharacterCollection;
			if (c != null) {
			}

			Draw();
		}

		[Inspectable(defaultValue="Verdana", type="Font Name")]
		public function get FontName():String {
			return m_fontName;
		}
		public function set FontName(value:String):void {
			m_fontName = Utils.Trim(value);
			Draw();
		}

		[Inspectable(defaultValue="24.0", type="Number")]
		public function get FontSize():Object {
			return m_fontSize;
		}
		public function set FontSize(value:Object):void {
			m_fontSize = value;
			Draw();
		}

		[Inspectable(defaultValue="3.0", type="Number")]
		public function get MotionBlur():Number {
			return m_motionBlur;
		}
		public function set MotionBlur(blur:Number):void {
			m_motionBlur = blur;
		}

		[Inspectable(enumeration="Low, Medium, High", defaultValue="Medium", type="List")]
		public function get MotionBlurQuality():String {
			var quality:String;

			switch (m_motionBlurQuality) {
				case BitmapFilterQuality.LOW:
					quality = "Low";
					break;
				case BitmapFilterQuality.MEDIUM:
					quality = "Medium";
					break;
				case BitmapFilterQuality.HIGH:
					quality = "High";
					break;
				default:
					quality = "Medium";
					break;
			}
			
			return quality;
		}
		public function set MotionBlurQuality(quality:String):void {
			switch (quality) {
				case "Low":
					m_motionBlurQuality = BitmapFilterQuality.LOW;
					break;
				case "Medium":
					m_motionBlurQuality = BitmapFilterQuality.MEDIUM;
					break;
				case "High":
					m_motionBlurQuality = BitmapFilterQuality.HIGH;
					break;
				default:
					m_motionBlurQuality = BitmapFilterQuality.MEDIUM;
					break;
			}
		}

		[Inspectable(defaultValue="false", type="Boolean")]
		public function get MultiLine():Boolean {
			return m_multiLine;
		}
		public function set MultiLine(value:Boolean):void {
			m_multiLine = value;
			Draw();
		}

		[Inspectable(defaultValue="true", type="Boolean")]
		public function get Narrator():Boolean {
			return m_narrator;
		}
		public function set Narrator(value:Boolean):void {
			m_narrator = value;
			Draw();
		}

		[Inspectable(defaultValue="true", type="Boolean")]
		public function get RenderAsHTML():Boolean {
			return m_renderAsHTML;
		}
		public function set RenderAsHTML(value:Boolean):void {
			m_renderAsHTML = value;
			Draw();
		}

		[Inspectable(defaultValue="", type="String")]
		public function get Text():String {
			return m_text;
		}
		public function set Text(value:String):void {
			m_text = Utils.Trim(value);
			Draw();
		}

		[Inspectable(enumeration="Center, Justify, Left, Right", defaultValue="Justify", type="List")]
		public function get TextAlignment():String {
			return m_textAlignment.toUpperCase().substr(0, 1)
					+ m_textAlignment.toLocaleLowerCase().substr(1);
		}
		public function set TextAlignment(value:String):void {
			var align:String;
			
			switch (value) {
				case "Center":
					align = TextFormatAlign.CENTER;
					break;
				case "Justify":
					align = TextFormatAlign.JUSTIFY;
					break;
				case "Left":
					align = TextFormatAlign.LEFT;
					break;
				case "Right":
					align = TextFormatAlign.RIGHT;
					break;
				default:
					align = TextFormatAlign.JUSTIFY;
					break;
			}
			
			m_textAlignment = align;
			Draw();
		}

		[Inspectable(defaultValue="#000099" ,type="Color")]
		public function get TextColor():Object {
			return m_textColor;
		}
		public function set TextColor(value:Object):void {
			m_textColor = value;
			Draw();
		}

		[Inspectable(defaultValue="4.0", type="Number")]
		public function get TimeOut():Number {
			return m_timeOut;
		}
		public function set TimeOut(value:Number):void {
			m_timeOut = value;
			Draw();
		}

		[Inspectable(enumeration="Back.easeIn, Back.easeOut, Back.easeInOut, Bounce.easeIn, Bounce.easeOut, Bounce.easeInOut, Elastic.easeIn, Elastic.easeOut, Elastic.easeInOut, None.easeNone, None.easeIn, None.easeOut, None.easeInOut, Regular.easeIn, Regular.easeOut, Regular.easeInOut, Strong.easeIn, Strong.easeOut, Strong.easeInOut", defaultValue="Regular.easeIn", type="List")]
		public function get TransitionEasingAppear():String {
			var ease:String;

			switch (m_transitionEasingAppear) {
				case Back.easeIn:
					ease = "Back.easeIn";
					break;
				case Back.easeOut:
					ease = "Back.easeOut";
					break;
				case Back.easeInOut:
					ease = "Back.easeInOut";
					break;
				case Bounce.easeIn:
					ease = "Bounce.easeIn";
					break;
				case Bounce.easeOut:
					ease = "Bounce.easeOut";
					break;
				case Bounce.easeInOut:
					ease = "Bounce.easeInOut";
					break;
				case Elastic.easeIn:
					ease = "Elastic.easeIn";
					break;
				case Elastic.easeOut:
					ease = "Elastic.easeOut";
					break;
				case Elastic.easeInOut:
					ease = "Elastic.easeInOut";
					break;
				case None.easeNone:
					ease = "None.easeNone";
					break;
				case None.easeIn:
					ease = "None.easeIn";
					break;
				case None.easeOut:
					ease = "None.easeOut";
					break;
				case None.easeInOut:
					ease = "None.easeInOut";
					break;
				case Regular.easeIn:
					ease = "Regular.easeIn";
					break;
				case Regular.easeOut:
					ease = "Regular.easeOut";
					break;
				case Regular.easeInOut:
					ease = "Regular.easeInOut";
					break;
				case Strong.easeIn:
					ease = "Strong.easeIn";
					break;
				case Strong.easeOut:
					ease = "Strong.easeOut";
					break;
				case Strong.easeInOut:
					ease = "Strong.easeInOut";
					break;
				default:
					ease = "Regular.easeIn";
					break;
					break;
			}
			
			return ease;
		}
		public function set TransitionEasingAppear(ease:String):void {
			switch (ease) {
				case "Back.easeIn":
					m_transitionEasingAppear = Back.easeIn;
					break;
				case "Back.easeOut":
					m_transitionEasingAppear = Back.easeOut;
					break;
				case "Back.easeInOut":
					m_transitionEasingAppear = Back.easeInOut;
					break;
				case "Bounce.easeIn":
					m_transitionEasingAppear = Bounce.easeIn;
					break;
				case "Bounce.easeOut":
					m_transitionEasingAppear = Bounce.easeOut;
					break;
				case "Bounce.easeInOut":
					m_transitionEasingAppear = Bounce.easeInOut;
					break;
				case "Elastic.easeIn":
					m_transitionEasingAppear = Elastic.easeIn;
					break;
				case "Elastic.easeOut":
					m_transitionEasingAppear = Elastic.easeOut;
					break;
				case "Elastic.easeInOut":
					m_transitionEasingAppear = Elastic.easeInOut;
					break;
				case "None.easeNone":
					m_transitionEasingAppear = None.easeNone;
					break;
				case "None.easeIn":
					m_transitionEasingAppear = None.easeIn;
					break;
				case "None.easeOut":
					m_transitionEasingAppear = None.easeOut;
					break;
				case "None.easeInOut":
					m_transitionEasingAppear = None.easeInOut;
					break;
				case "Regular.easeIn":
					m_transitionEasingAppear = Regular.easeIn;
					break;
				case "Regular.easeOut":
					m_transitionEasingAppear = Regular.easeOut;
					break;
				case "Regular.easeInOut":
					m_transitionEasingAppear = Regular.easeInOut;
					break;
				case "Strong.easeIn":
					m_transitionEasingAppear = Strong.easeIn;
					break;
				case "Strong.easeOut":
					m_transitionEasingAppear = Strong.easeOut;
					break;
				case "Strong.easeInOut":
					m_transitionEasingAppear = Strong.easeInOut;
					break;
				default:
					m_transitionEasingAppear = Back.easeInOut;
					break;
			}
		}

		[Inspectable(enumeration="Back.easeIn, Back.easeOut, Back.easeInOut, Bounce.easeIn, Bounce.easeOut, Bounce.easeInOut, Elastic.easeIn, Elastic.easeOut, Elastic.easeInOut, None.easeNone, None.easeIn, None.easeOut, None.easeInOut, Regular.easeIn, Regular.easeOut, Regular.easeInOut, Strong.easeIn, Strong.easeOut, Strong.easeInOut", defaultValue="Regular.easeOut", type="List")]
		public function get TransitionEasingDisappear():String {
			var ease:String;

			switch (m_transitionEasingDisappear) {
				case Back.easeIn:
					ease = "Back.easeIn";
					break;
				case Back.easeOut:
					ease = "Back.easeOut";
					break;
				case Back.easeInOut:
					ease = "Back.easeInOut";
					break;
				case Bounce.easeIn:
					ease = "Bounce.easeIn";
					break;
				case Bounce.easeOut:
					ease = "Bounce.easeOut";
					break;
				case Bounce.easeInOut:
					ease = "Bounce.easeInOut";
					break;
				case Elastic.easeIn:
					ease = "Elastic.easeIn";
					break;
				case Elastic.easeOut:
					ease = "Elastic.easeOut";
					break;
				case Elastic.easeInOut:
					ease = "Elastic.easeInOut";
					break;
				case None.easeNone:
					ease = "None.easeNone";
					break;
				case None.easeIn:
					ease = "None.easeIn";
					break;
				case None.easeOut:
					ease = "None.easeOut";
					break;
				case None.easeInOut:
					ease = "None.easeInOut";
					break;
				case Regular.easeIn:
					ease = "Regular.easeIn";
					break;
				case Regular.easeOut:
					ease = "Regular.easeOut";
					break;
				case Regular.easeInOut:
					ease = "Regular.easeInOut";
					break;
				case Strong.easeIn:
					ease = "Strong.easeIn";
					break;
				case Strong.easeOut:
					ease = "Strong.easeOut";
					break;
				case Strong.easeInOut:
					ease = "Strong.easeInOut";
					break;
				default:
					ease = "Regular.easeOut";
					break;
			}
			
			return ease;
		}
		public function set TransitionEasingDisappear(ease:String):void {
			switch (ease) {
				case "Back.easeIn":
					m_transitionEasingDisappear = Back.easeIn;
					break;
				case "Back.easeOut":

					m_transitionEasingDisappear = Back.easeOut;
					break;
				case "Back.easeInOut":
					m_transitionEasingDisappear = Back.easeInOut;
					break;
				case "Bounce.easeIn":
					m_transitionEasingDisappear = Bounce.easeIn;
					break;
				case "Bounce.easeOut":
					m_transitionEasingDisappear = Bounce.easeOut;
					break;
				case "Bounce.easeInOut":
					m_transitionEasingDisappear = Bounce.easeInOut;
					break;
				case "Elastic.easeIn":
					m_transitionEasingDisappear = Elastic.easeIn;
					break;
				case "Elastic.easeOut":
					m_transitionEasingDisappear = Elastic.easeOut;
					break;
				case "Elastic.easeInOut":
					m_transitionEasingDisappear = Elastic.easeInOut;
					break;
				case "None.easeNone":
					m_transitionEasingDisappear = None.easeNone;
					break;
				case "None.easeIn":
					m_transitionEasingDisappear = None.easeIn;
					break;
				case "None.easeOut":
					m_transitionEasingDisappear = None.easeOut;
					break;
				case "None.easeInOut":
					m_transitionEasingDisappear = None.easeInOut;
					break;
				case "Regular.easeIn":
					m_transitionEasingDisappear = Regular.easeIn;
					break;
				case "Regular.easeOut":
					m_transitionEasingDisappear = Regular.easeOut;
					break;
				case "Regular.easeInOut":
					m_transitionEasingDisappear = Regular.easeInOut;
					break;
				case "Strong.easeIn":
					m_transitionEasingDisappear = Strong.easeIn;
					break;
				case "Strong.easeOut":
					m_transitionEasingDisappear = Strong.easeOut;
					break;
				case "Strong.easeInOut":
					m_transitionEasingDisappear = Strong.easeInOut;
					break;
				default:
					m_transitionEasingDisappear = Back.easeInOut;
					break;
			}
		}

		[Inspectable(enumeration="Blinds, Fade, Fly, Iris, PixelDissolve, Photo, Rotate, Squeeze, Wipe, Zoom", defaultValue="Fade", type="List")]
		public function get TransitionEffectAppear():String {
			return m_transitionEffectAppear;
		}
		public function set TransitionEffectAppear(effect:String):void {
			m_transitionEffectAppear = effect
		}

		[Inspectable(enumeration="Blinds, Fade, Fly, Iris, PixelDissolve, Photo, Rotate, Squeeze, Wipe, Zoom", defaultValue="Fade", type="List")]
		public function get TransitionEffectDisappear():String {
			return m_transitionEffectDisappear;
		}
		public function set TransitionEffectDisappear(effect:String):void {
			m_transitionEffectDisappear = effect;
		}

		[Inspectable(defaultValue="0.300", type="Number")]
		public function get TransitionDurationAppear():Number {
			return m_transitionDurationAppear;
		}
		public function set TransitionDurationAppear(duration:Number):void {
			m_transitionDurationAppear = duration;
		}

		[Inspectable(defaultValue="0.300", type="Number")]
		public function get TransitionDurationDisappear():Number {
			return m_transitionDurationDisappear;
		}
		public function set TransitionDurationDisappear(duration:Number):void {
			m_transitionDurationDisappear = duration;
		}

		[Inspectable(enumeration="CIRCLE, SQUARE", defaultValue="CIRCLE", type="List")]
		public function get TransitionIrishEffectShapeAppear():String {
			return m_transitionIrishEffectShapeAppear;
		}
		public function set TransitionIrishEffectShapeAppear(shape:String):void {
			m_transitionIrishEffectShapeAppear = shape;
		}

		[Inspectable(enumeration="CIRCLE, SQUARE", defaultValue="SQUARE", type="List")]
		public function get TransitionIrishEffectShapeDisappear():String {
			return m_transitionIrishEffectShapeDisappear;
		}
		public function set TransitionIrishEffectShapeDisappear(shape:String):void {
			m_transitionIrishEffectShapeDisappear = shape;
		}

		[Inspectable(defaultValue="true", type="Boolean")]
		public function get WordWrap():Boolean {
			return m_wordWrap;
		}
		public function set WordWrap(value:Boolean):void {
			m_wordWrap = value;

			// it has to be true on last properties initialization
			if (!m_isInitialized)
				m_isInitialized = true;

			Draw();
		}

		public function Subtitle() {
			super();
			Init();
		}

		public function ShowSubtitle(color:Object = null, timeOut:Number = -1):void {
			m_currentSubtitleColor = color;
			m_currentSubtitleTimeOut = timeOut;
			m_manualRaise = true;
			Draw();
		}

		private function Draw():void {
			this.visible = false;

			while (m_container.numChildren > 0) {
				m_container.removeChildAt(0);
			}

			if (m_isInitialized && (m_autoRaise || m_manualRaise)) {
				m_manualRaise = false;

				var c:SubtitleCharacterCollection = m_characters as SubtitleCharacterCollection;
				var character:SubtitleCharacterItem = null;
				var foundCharacter:Boolean = false;
				if (c != null) {
					if (Utils.Trim(m_character) != "") {
						for (var i:int = 0; i < c.length; ++i) {
							character = SubtitleCharacterItem(c.getItemAt(i));
							if (m_character == Utils.Trim(character.Name)) {
								foundCharacter = true;
								break;
							}
						}
					}
				}
	
				var format:TextFormat = new TextFormat();
	
				if (m_currentSubtitleColor != "" && m_currentSubtitleColor != null) {
					format.color = m_currentSubtitleColor;
				} else {
					if (foundCharacter) {
						if (character.TextColor != "" && character.TextColor != null) {
							format.color = character.TextColor;
						} else {
							format.color = m_textColor;
						}
					} else {
						format.color = m_textColor;
					}
				}
	
				format.align = m_textAlignment;
				format.font = m_fontName;
				format.size = m_fontSize;
	
				var text:TextField = new TextField();
				if (m_narrator && foundCharacter) {
					if (m_renderAsHTML) {
						text.htmlText = character.Name + ": " + m_text;
					} else {
						text.text = character.Name + ": " + m_text;
					}
				} else {
					if (m_renderAsHTML) {
						text.htmlText = m_text;
					} else {
						text.text = m_text;
					}
				}
				text.setTextFormat(format);
				text.autoSize = TextFieldAutoSize.CENTER;
				text.gridFitType = GridFitType.SUBPIXEL;
				text.height = text.textHeight;
				text.multiline = m_multiLine;
				text.width = this.width;
				text.wordWrap = m_wordWrap;
				text.x = 0.0;
				text.y = 0.0;
	
				m_container.addChild(text);
				this.visible = true;

				StartInTransition();
			}
		}

		private function Init():void {
			m_isInitialized = false; // it has to be true on last properties initialization

			m_antiAlias = AntiAliasType.ADVANCED;
			m_autoRaise = false;
			m_character = "";
			m_characters = new SubtitleCharacterCollection();

			m_fontName = 'Verdana';
			m_fontSize = 24.0;
			m_manualRaise = false;
			m_motionBlur = 3.0;
			m_motionBlurQuality = BitmapFilterQuality.MEDIUM;
			m_multiLine = false;
			m_narrator = true;
			m_renderAsHTML = true;
			m_text = "";
			m_textAlignment = TextFormatAlign.JUSTIFY;
			m_textColor = 0x000099;
			m_timeOut = 4.0;
			m_transitionEasingAppear = Back.easeInOut;
			m_transitionEasingDisappear = Back.easeInOut;
			m_transitionEffectAppear = "Fade";
			m_transitionEffectDisappear = "Fade";
			m_transitionDurationAppear = 0.300;
			m_transitionDurationDisappear = 0.300;
			m_transitionIrishEffectShapeAppear = Iris.CIRCLE;
			m_transitionIrishEffectShapeDisappear = Iris.SQUARE;
			m_wordWrap = true;

			this.getChildAt(0).visible = false;
			m_container = new MovieClip();
			this.addChild(m_container);
			m_container.scaleX = 1.0 / this.scaleX;
			m_container.scaleY = 1.0 / this.scaleY;

			m_currentSubtitleColor = null;
			m_currentSubtitleTimeOut = -1;

			Draw();
		}
		
		private function GetEffectClass(effect:String):Class {
			switch (effect) {
				case "Blinds":
					return Blinds;
				case "Fade":
					return Fade;
				case "Fly":
					return Fly;
				case "Iris":
					return Iris;
				case "PixelDissolve":
					return PixelDissolve;
				case "Photo":
					return Photo;
				case "Rotate":
					return Rotate;
				case "Squeeze":
					return Squeeze;
				case "Wipe":
					return Wipe;
				case "Zoom":
					return Zoom;
				default:
					return Fade;
			}
		}

		private function SetBlurFilter(amount:Number):void {
			if (amount > 0.0) {
				var blur:BlurFilter = new BlurFilter();
				blur.blurX = amount;
				blur.blurY = 0.0;
				blur.quality = m_motionBlurQuality;
				m_container.filters = [blur];
			}
			else {
				m_container.filters = [];
			}
		}		

		private function StartInTransition():void {
			dispatchEvent(new SubtitleEvent(SubtitleEvent.SUBTITLE_RAISED, m_text));

			SetBlurFilter(m_motionBlur);

			m_transitions = new Array();

			m_transitionManager = new TransitionManager(m_container);
			m_transitionManager.startTransition({ type:GetEffectClass(m_transitionEffectAppear), direction:Transition.IN,
												duration:m_transitionDurationAppear, easing:m_transitionEasingAppear, shape:m_transitionIrishEffectShapeAppear });
			m_transitions.push(m_transitionManager);

			m_transitionManager.addEventListener("allTransitionsInDone", OnInTransitionCompleted);
		}

		private function StartOutTransition(event:TimerEvent):void {
			SetBlurFilter(m_motionBlur);

			m_transitions = new Array();

			m_transitionManager = new TransitionManager(m_container);
			m_transitionManager.startTransition({ type:GetEffectClass(m_transitionEffectDisappear), direction:Transition.OUT,
												duration:m_transitionDurationDisappear, easing:m_transitionEasingDisappear, shape:m_transitionIrishEffectShapeDisappear });
			m_transitions.push(m_transitionManager);

			m_transitionManager.addEventListener("allTransitionsOutDone", OnOutTransitionCompleted);
		}

		function OnInTransitionCompleted(e:Event):void {
			SetBlurFilter(0.0);

			m_timer = new Timer(m_timeOut * 1000.0, 1);
			m_timer.addEventListener(TimerEvent.TIMER, StartOutTransition);
			m_timer.start();
		}

		function OnOutTransitionCompleted(e:Event):void {
			this.visible = false;
			SetBlurFilter(0.0);

			dispatchEvent(new SubtitleEvent(SubtitleEvent.SUBTITLE_TIMED_OUT, m_text));
		}
	}
}

