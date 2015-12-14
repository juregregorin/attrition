package ui
{
	import loom2d.display.Image;
	import loom2d.display.Sprite;
	import loom2d.textures.Texture;

	/**
	 * ...
	 * @author Tadej
	 */
	public class TrendIndicator extends Sprite
	{
		private static var INDICATOR_GROW:Texture;
		private static var INDICATOR_STABLE:Texture;
		private static var INDICATOR_FALL:Texture;

		private var growing:Image;
		private var stable:Image;
		private var falling:Image;

		public function TrendIndicator()
		{
			if (INDICATOR_GROW == null)
			{
				INDICATOR_GROW = Texture.fromAsset("assets/ui/ico_uparrow.png");
				INDICATOR_STABLE = Texture.fromAsset("assets/ui/ico_nochange.png");
				INDICATOR_FALL = Texture.fromAsset("assets/ui/ico_downarrow.png");
			}

			growing = new Image(INDICATOR_GROW);
			stable = new Image(INDICATOR_STABLE);
			falling = new Image(INDICATOR_FALL);

			addChild(growing);
			addChild(stable);
			addChild(falling);

			growing.alpha = stable.alpha = falling.alpha = 0;
		}

		public function updateTrend(trend:Number)
		{
			growing.alpha = stable.alpha = falling.alpha = 0;
			if (trend < 0)
				falling.alpha = 1;
			else if (trend > 0)
				growing.alpha = 1;
			else
				stable.alpha = 1;
		}
	}

}