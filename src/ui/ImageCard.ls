package ui
{
	import loom2d.display.Shape;
	import loom2d.display.Graphics;
	import loom2d.display.Image;
	import loom2d.display.Sprite;
	import loom2d.display.TextAlign;
	import loom2d.display.TextFormat;
	import loom2d.textures.Texture;

	public class ImageCard extends Sprite
	{
		private var _depth:int = 0;

		private var cardInfo:Shape;
		private var cardDescription:Shape;
		private var g:Graphics;
		private var dg:Graphics;

		public static var TYPE_RAIN:String = "rain";
		public static var TYPE_FOOD:String = "food";
		public static var TYPE_MEDITATE:String = "meditate";
		public static var TYPE_HEAL:String = "heal";
		public static var TYPE_SACRIFICE:String = "sacrifice";

		private static var cardRain:Texture;
		private static var cardFood:Texture;
		private static var cardMeditate:Texture;
		private static var cardHeal:Texture;
		private static var cardSacrifice:Texture;

		private var cardBase:Image;
		private var cardType:String;

		private static var FORMAT_NAME:TextFormat;
		private static var FORMAT_COST:TextFormat;
		private static var FORMAT_DESCRIPTION:TextFormat;

		public function ImageCard(type:String)
		{
			super();

			cardType = type;

			cardInfo = new Shape();
			cardDescription = new Shape();
			g = cardInfo.graphics;
			dg = cardDescription.graphics;

			generateGraphics();

			if (FORMAT_NAME == null)
			{
				FORMAT_NAME = new TextFormat();
				FORMAT_NAME.font = "dungeon";
				FORMAT_NAME.color = 0x000000;
				FORMAT_NAME.size = 50;
				FORMAT_NAME.align = TextAlign.CENTER | TextAlign.MIDDLE;
			}

			if (FORMAT_COST == null)
			{
				FORMAT_COST = new TextFormat();
				FORMAT_COST.font = "dungeon";
				FORMAT_COST.color = 0xFFFFFF;
				FORMAT_COST.size = 50;
				FORMAT_COST.align = TextAlign.CENTER | TextAlign.MIDDLE;
			}

			if (FORMAT_DESCRIPTION == null)
			{
				FORMAT_DESCRIPTION = new TextFormat();
				FORMAT_DESCRIPTION.font = "dungeon";
				FORMAT_DESCRIPTION.color = 0x000000;
				FORMAT_DESCRIPTION.size = 50;
				FORMAT_DESCRIPTION.align = TextAlign.LEFT | TextAlign.TOP;
			}

			//cardInfo.x = -10;
			addChild(cardInfo);
			addChild(cardDescription);

			//g.drawTextLine(0, -200, "ASDFGHJKJ");
			//g.drawTextLine( -150, 250, "Test");
		}

		private function generateGraphics()
		{
			if (cardRain == null)
				cardRain = Texture.fromAsset("assets/cards/card-downpour.png");
			if (cardFood == null)
				cardFood = Texture.fromAsset("assets/cards/card-harvest.png");
			if (cardMeditate == null)
				cardMeditate = Texture.fromAsset("assets/cards/card-meditate.png");
			if (cardHeal == null)
				cardHeal = Texture.fromAsset("assets/cards/card-remedy.png");
			if (cardSacrifice == null)
				cardSacrifice = Texture.fromAsset("assets/cards/card-remedy.png");

			switch(cardType)
			{
				case TYPE_FOOD:
					cardBase = new Image(cardFood);
					break;
				case TYPE_HEAL:
					cardBase = new Image(cardHeal);
					break;
				case TYPE_MEDITATE:
					cardBase = new Image(cardMeditate);
					break;
				case TYPE_RAIN:
					cardBase = new Image(cardRain);
					break;
				case TYPE_SACRIFICE:
					cardBase = new Image(cardSacrifice);
					break;
				default:
					return;
			}

			cardBase.center();
			addChild(cardBase);
		}

		public function setText(cardName:String = "", manaCost:uint = 0, description:String = "")
		{
			g.clear();
			// Card name
			g.textFormat(FORMAT_NAME);
			g.drawTextLine(0, -280, cardName);

			// Mana
			g.textFormat(FORMAT_COST);
			g.drawTextLine(187, -280, manaCost+"");

			dg.clear();
			// Description
			dg.textFormat(FORMAT_DESCRIPTION);
			dg.drawTextBox( 0, 0, 420, description); // -200, 90, 400
			cardDescription.x = -cardDescription.width / 2;
			cardDescription.y = 100; // - cardDescription.height;
		}

		public static function zSort(a:ImageCard, b:ImageCard):int
		{
			return a.getDepth() > b.getDepth() ? -1 : a.getDepth() < b.getDepth() ? 1 : 0;
		}

		public function getDepth():int
		{
			return _depth;
		}

		public function setDepth(d:int)
		{
			_depth = d;
		}

		public function destroy()
		{
			removeChild(cardBase);
			removeChild(cardInfo);
			removeChild(cardDescription);
		}
	}

}