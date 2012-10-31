package GameUi {
	public class Utils extends Object {
		public static function Trim(str:String):String {
			return TrimBack(TrimFront(str));
		}

		private static function TrimBack(str:String):String {
			if (str.charAt(str.length - 1) == " ")
				str = TrimBack(str.substring(0, str.length - 1));
			return str;
		}

		private static function TrimFront(str:String):String {
			if (str.charAt(0) == " ")
				str = TrimFront(str.substring(1));
			return str;
		}
	}
}

