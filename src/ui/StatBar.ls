package ui
{
	import loom2d.display.Image;
	import loom2d.display.Sprite;
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
		private var maxFood:Number = 0;
		private var curPop:Number = 0;
		private var curHealth:Number = 0;
		private var maxHealth:Number = 100;

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

			foodIcon.y = manaIcon.y = populationIcon.y = healthIcon.y = 25;

			foodIcon.x = 100;
			manaIcon.x = 320;
			populationIcon.x = 770;
			healthIcon.x = 990;


			addChild(foodIcon);
			addChild(manaIcon);
			addChild(populationIcon);
			addChild(healthIcon);

			addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init()
		{
			cardTimer = new CardTimer();
			cardTimer.x = 1280 / 2;
			cardTimer.y = cardTimer.height / 2;
		}

		public function set food(f:Number)
		{
			curFood = f;
		}

		public function set foodMax(f:Number)
		{
			maxFood = f;
		}

		public function set population(p:Number)
		{
			curPop = p;
		}

		public function set health(h:Number)
		{
			curHealth = h < 0 ? 0 : h > maxHealth ? maxHealth : h;
		}
	}

}