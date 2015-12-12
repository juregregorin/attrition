package
{
	import loom2d.display.Graphics;
	import loom2d.display.Shape;
	import loom2d.display.TextAlign;
	import loom2d.display.TextFormat;

	public class TextUI extends Entity
	{
		private var g:Graphics;

		var textShape:Shape;

		public function TextUI()
		{
			textShape = new Shape();

			environment.getUILayer().addChild(textShape);

			g = textShape.graphics;

			TextFormat.load("pixelmix", "assets/pixelmix.ttf");
		}

		public function setText(s:String)
		{
			var format = new TextFormat();
			format.font = "pixelmix";
			format.color = 0xFF4848;
			format.size = 12;
			format.align = TextAlign.TOP | TextAlign.LEFT;
			g.textFormat(format);
			g.drawTextLine(225, 25, s);
		}

		public override function render()
		{
			textShape.x = p.x;
			textShape.y = p.y;
		}
	}

}