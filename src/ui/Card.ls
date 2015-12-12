package ui
{
	import loom2d.display.Image;
	import loom2d.textures.Texture;
	import Entity;

	public class Card extends Entity
	{
		public static var CARDS:Vector.<Card> = new Vector.<Card>();
		public static var MAX_CARDS:int = 3;

		public static var TYPE_RAIN:String = "rain";
		public static var TYPE_FOOD:String = "food";

		private static var cardFace:Image;
		private static var cardImages:Vector.<Image>;

		private var img:Image;

		public function Card()
		{
			if (cardFace == null)
				cardFace = new Image(Texture.fromAsset("assets/card-face.png"));

			if (cardImages == null)
			{
				cardImages = new Vector.<Image>();
			}

			img = cardFace;
			environment.getUI().addChild(img);
		}

		override public function destroy()
		{
			environment.getUI().removeChild(img);
			img = null;

			super.destroy();
		}

		override public function render()
		{
			img.x = p.x;
			img.y = p.y;
			img.rotation = rotation;
			super.render();
		}

		public static function addCard(cardType:String)
		{
			if (CARDS.length >= MAX_CARDS) return;
			var c = new Card();
			CARDS.push(c);
		}

		public static function sortCards()
		{

		}

		public function use()
		{
			this.destroy();
		}
	}

}