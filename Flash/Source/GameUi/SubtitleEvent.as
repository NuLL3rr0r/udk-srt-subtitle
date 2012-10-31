package GameUi {
	import flash.events.Event;

	public class SubtitleEvent extends Event {
		public static const SUBTITLE_RAISED:String = "subtitleRaised";
		public static const SUBTITLE_TIMED_OUT:String = "subtitleTimedOut";

		protected var m_text:String;

		public function get Text():String {
            return m_text;
        }
 
        public function set Text(value:String):void {
             m_text = value;
        }

		public function SubtitleEvent(type:String, text:String = "") {
			super(type);
			
			m_text = text;
		}

		override public function toString():String {
			return formatToString("SubtitleEvent", "type", "Text");
		}

		override public function clone():Event {
			return new SubtitleEvent(type, m_text);
		}
	}
}

