package ui
{
	import loom2d.display.Graphics;
	import loom2d.display.Shape;
	import loom2d.display.TextAlign;
	import loom2d.display.TextFormat;
	import Entity;

	public class TextUI extends Entity
	{
		public static var COLOR_DEFAULT:uint = 0xFFFFFF;
		public static var COLOR_POSITIVE:uint = 0x00FF00;
		public static var COLOR_NEGATIVE:uint = 0xFF0000;

		private var g:Graphics;

		var textShape:Shape;
		var _format:TextFormat;

		protected var textDisplay:Vector.<String>;
		protected var textColors:Vector.<uint>;
		protected var textLines:uint;

		public function TextUI(textLines:uint = 5, color:uint = 0xFFFFFF)
		{
			textDisplay = new Vector.<String>();
			textColors = new Vector.<uint>();

			this.textLines = textLines;
			textShape = new Shape();

			environment.getUI().addChild(textShape);

			g = textShape.graphics;

			_format = new TextFormat();
			_format.font = "dungeon";
			_format.color = color;
			_format.size = 12;
			_format.align = TextAlign.TOP | TextAlign.LEFT;
		}

		public function set format(f:TextFormat)
		{
			_format = f;
		}

		public function get format():TextFormat { return _format; }

		public function setText(s:String, c:uint = 0xFFFFFF)
		{
			g.clear();
			//g.textFormat(_format);

			if (textDisplay.length == 0 || textDisplay[textDisplay.length - 1] != s)
			{
				textDisplay.push(s);
				textColors.push(c);
			}

			if (textDisplay.length > textLines) {
				textDisplay.shift();
				textColors.shift();
			}

			for (var i = 0; i < textDisplay.length; i++)
			{
				_format.color = textColors[i];
				g.textFormat(_format);
				g.drawTextLine(0, i * _format.size, textDisplay[i]);
			}
		}

		public override function render()
		{
			textShape.x = x;
			textShape.y = y;
		}
	}

}