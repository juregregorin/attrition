package ui
{
	import loom2d.display.Graphics;
	import loom2d.display.Shape;
	import loom2d.display.TextAlign;
	import loom2d.display.TextFormat;
	import Entity;

	public class TextUI extends Entity
	{
		private var g:Graphics;

		var textShape:Shape;
		var _format:TextFormat;

		protected var textDisplay:Vector.<String>;
		protected var textLines:uint;

		public function TextUI(textLines:uint = 5, color:uint = 0xFFFFFF)
		{
			textDisplay = new Vector.<String>();
			this.textLines = textLines;
			textShape = new Shape();

			environment.getUI().addChild(textShape);

			g = textShape.graphics;

			TextFormat.load("pixelmix", "assets/pixelmix.ttf");

			_format = new TextFormat();
			_format.font = "pixelmix";
			_format.color = color;
			_format.size = 12;
			_format.align = TextAlign.TOP | TextAlign.LEFT;
		}

		public function set format(f:TextFormat)
		{
			_format = f;
		}

		public function get format():TextFormat { return _format; }

		public function setText(s:String)
		{
			g.clear();
			g.textFormat(_format);

			if (textDisplay.length == 0 || textDisplay[textDisplay.length-1] != s)
				textDisplay.push(s);

			if (textDisplay.length > textLines) {
				textDisplay.shift();
			}

			for (var i = 0; i < textDisplay.length; i++)
			{
				g.drawTextLine(0, i * 12, textDisplay[i]);
			}
		}

		public override function render()
		{
			textShape.x = p.x;
			textShape.y = p.y;
		}
	}

}