package ui
{
	import loom2d.display.Graphics;
	import loom2d.display.Shape;
	import loom2d.display.Image;
	import loom2d.display.Sprite;
	import loom2d.display.TextAlign;
	import loom2d.display.TextFormat;
	import loom2d.events.Event;
	import loom2d.textures.Texture;

	public class StatBar extends Sprite
	{
		private var manaPool:TextUI;

		private var textBack:Image;
		private var foodIcon:Image;
		private var manaIcon:Image;
		private var populationIcon:Image;
		private var healthIcon:Image;

		private var cardTimer:CardTimer;

		private var curFood:Number = 0;
		private var foodTrend:Number = 0;
		private var maxFood:Number = 0;
		private var curPop:Number = 0;
		private var curHealth:Number = 0;
		private var maxHealth:Number = 100;
		private var curMana:Number = 0;

		private var tiFood:TrendIndicator;
		private var tiPop:TrendIndicator;

		private var text:Shape;
		private var format:TextFormat;
		private var format2:TextFormat;

		private var yText:Number = 23;

		private var g:Graphics;

		public function StatBar()
		{
			super();

			textBack = new Image(Texture.fromAsset("assets/ui/stat-box.png"));
			textBack.y = 20;
			addChild(textBack);

			foodIcon = new Image(Texture.fromAsset("assets/ui/ico_food.png"));
			manaIcon = new Image(Texture.fromAsset("assets/ui/ico_mana.png"));
			populationIcon = new Image(Texture.fromAsset("assets/ui/ico_population.png"));
			healthIcon = new Image(Texture.fromAsset("assets/ui/ico_health.png"));

			tiFood = new TrendIndicator();
			tiPop = new TrendIndicator();

			foodIcon.y = manaIcon.y = populationIcon.y = healthIcon.y = tiFood.y = tiPop.y = 25;

			foodIcon.x = 100;
			manaIcon.x = 320;
			populationIcon.x = 770;
			healthIcon.x = 990;

			//tiPop.x = 920;
			tiPop.x = populationIcon.x + 110;
			//tiFood.x = 250;
			tiFood.x = foodIcon.x + 110;

			text = new Shape();
			g = text.graphics;

			format = new TextFormat();
			format2 = new TextFormat();
			format.font = format2.font = "dungeon";
			format.color = format2.color = 0xFFFFFF;
			format.size = format2.size = 50;
			format.align = TextAlign.TOP | TextAlign.RIGHT;
			format2.align = TextAlign.TOP | TextAlign.LEFT;

			addChild(foodIcon);
			addChild(manaIcon);
			addChild(populationIcon);
			addChild(healthIcon);

			addChild(tiFood);
			addChild(tiPop);
			addChild(text);
		}

		public function set food(f:Number)
		{
			curFood = f;
			updateText();
		}

		public function set foodRate(f:Number)
		{
			foodTrend = f;
			tiFood.updateTrend(f);
		}

		public function set foodMax(f:Number)
		{
			maxFood = f;
		}

		public function set population(p:Number)
		{
			//trace((p / curPop) + "");
			//tiPop.updateTrend(p / curPop);
			curPop = p;
		}

		public function set health(h:Number)
		{
			curHealth = h < 0 ? 0 : h > maxHealth ? maxHealth : h;
			updateText();
		}

		public function set mana(m:Number)
		{
			curMana = m;
			updateText();
		}

		private function updateText()
		{
			g.clear();
			g.textFormat(format);
			g.drawTextLine(foodIcon.x + 110, yText, curFood + "");
			g.drawTextLine(manaIcon.x + 100, yText, curMana + "");
			g.drawTextLine(populationIcon.x + 110, yText, curPop + "");

			g.textFormat(format2);
			g.drawTextLine(manaIcon.x + 100, yText, " / 10");
		}
	}

}