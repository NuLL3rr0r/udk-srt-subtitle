package GameUi {
	import flash.text.*;

	public class SubtitleCharacterItem extends Object {
		private var m_textColor:Object;
		private var m_name:String;

		[Inspectable(defaultValue="{CharacterName}", type="String")]
		public function get Name():String {
			return m_name;
		}
		public function set Name(value:String):void {
			m_name = Utils.Trim(value);
		}

		[Inspectable(defaultValue="", type="uint", format="Color")]
		public function get TextColor():Object {
			return m_textColor;
		}
		public function set TextColor(value:Object):void {
			m_textColor = value;
		}

		public function SubtitleCharacterItem() {
			Init();
		}

		public function toString():String {
			return m_name;
		}

		private function Init():void {
			m_textColor = null;
			m_name = "";
		}
	}
}

