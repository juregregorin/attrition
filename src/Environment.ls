package
{
	import loom2d.display.TextAlign;
	import loom2d.display.Image;
	import loom2d.display.Sprite;
	import loom2d.display.Stage;
	import IsometricEngine;
	import loom2d.display.TextFormat;
	import loom2d.textures.Texture;
	import ui.Card;
	import ui.Portrait;
	import ui.ProgressUI;
	import ui.TextUI;

	public class Environment
	{
		private var w:int;
		private var h:int;

		private var background:Image;

		private var ui:Sprite = new Sprite();

		private var entities = new Vector.<Entity>();

		private var iso:IsometricEngine;
		private var simulation:Simulation;

		private var testText:ui.TextUI;
		private var testProgress:ProgressUI;
		private var manaDisplay:TextUI;

		private var portrait:Portrait;

		private var cardTimer:Number = 0;
		private var cardTreshold:Number = 2;

		public function Environment(stage:Stage)
		{
			this.w = Const.SCREEN_WIDTH;
			this.h = Const.SCREEN_HEIGHT;
			this.h = h;

			Entity.environment = this;

			background = new Image(Texture.fromAsset("assets/back.png"));
			stage.addChild(background);

			testText = new TextUI();

			testProgress = new ProgressUI();

			portrait = new Portrait();
			portrait.setPosition(stage.stageWidth / 2, 40);

			manaDisplay = new TextUI(1);
			manaDisplay.setPosition(portrait.getPosition().x - 150, portrait.getPosition().y);
			var manaF:TextFormat = manaDisplay.format;
			manaF.align = TextAlign.RIGHT;
			manaF.size = 20;
			manaDisplay.format = manaF;
			addEntity(manaDisplay);

			iso = new IsometricEngine;
			stage.addChild(iso);

			simulation = new Simulation(iso);
			addEntity(testText);
			addEntity(testProgress);
			addEntity(portrait);

			stage.addChild(ui);

			Card.setLocation(stage.stageWidth - 100, stage.stageHeight - 50);
		}

		private function addEntity(e:Entity)
		{
			entities.push(e);
		}

		public function tick(dt:Number)
		{
			for (var i:int = 0; i < entities.length; i++)
			{
				var entity = entities[i];
				entity.tick(dt);
			}

			if (cardTimer > cardTreshold)
			{
				cardTimer -= cardTreshold;
				var c = Card.addCard(Card.TYPE_RAIN);
				if (c != null) addEntity(c);
			}
			cardTimer += dt;

			testProgress.progress = testProgress.progress >= 1 ? testProgress.progress - 1 : testProgress.progress + dt;

			simulation.tick(dt);
		}

		public function render()
		{
			testText.setText("Current population: " + simulation.currentPopulation);
			manaDisplay.setText("20");

			for (var i:int = 0; i < entities.length; i++)
			{
				var entity = entities[i];
				entity.render();
			}

			manaDisplay.setText("test");
		}

		public function getUI():Sprite
		{
			return ui;
		}
	}

}
