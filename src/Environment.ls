package
{
	import loom2d.display.TextAlign;
	import loom2d.display.Image;
	import loom2d.display.Sprite;
	import loom2d.display.Stage;
	import IsometricEngine;
	import loom2d.display.TextFormat;
	import loom2d.events.Touch;
	import loom2d.events.TouchEvent;
	import loom2d.events.TouchPhase;
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
		private static var _instance:Environment;

		private var ui:Sprite = new Sprite();

		private var entities = new Vector.<Entity>();

		public var iso:IsometricEngine;
		public var simulation:Simulation;

		private var logText:TextUI;

		private var tempStats:TextUI;

		private var testProgress:ProgressUI;
		private var manaDisplay:TextUI;
		private var cards:Sprite;

		private var fogBack:Image;
		private var fogBack2:Image;
		private var fogMiddle:Image;
		private var fogFront:Image;
		private var fogFront2:Image;

		private var portrait:Portrait;

		private var cardTimer:Number = 0;
		private var cardTreshold:Number = 2;

		private var cardGetter:Sprite;

		public function Environment(stage:Stage)
		{
			_instance = this;

			this.w = Const.SCREEN_WIDTH;
			this.h = Const.SCREEN_HEIGHT;
			this.h = h;

			TextFormat.load("dungeon", "assets/dungeon.ttf");

			Entity.environment = this;

			background = new Image(Texture.fromAsset("assets/back.png"));
			stage.addChild(background);

			fogBack = new Image(Texture.fromAsset("assets/fog_bottom.png"));
			fogBack.width = 2844;
			fogBack.height = 720;
			stage.addChild(fogBack);
			fogBack2 = new Image(Texture.fromAsset("assets/fog_bottom.png"));
			fogBack2.width = 2844;
			fogBack2.height = 720;
			fogBack2.x = fogBack.width;
			stage.addChild(fogBack2);

			logText = new TextUI(15);
			logText.x = 5;
			logText.y = stage.stageHeight - (15 * logText.format.size + 5);

			cardGetter = new Sprite();
			var cg = new Image(Texture.fromAsset("assets/card-getter.png"));
			cg.center();
			cardGetter.addChild(cg);
			cardGetter.x = stage.stageWidth / 2;
			ui.addChild(cardGetter);
			cardGetter.addEventListener(TouchEvent.TOUCH, touchEvent);

			tempStats = new TextUI(3);

			testProgress = new ProgressUI();

			cards = new Sprite();
			cards.x = stage.stageWidth -210;
			cards.y = stage.nativeStageHeight - 70;

			portrait = new Portrait();
			portrait.setPosition(stage.stageWidth / 2, 40);

			manaDisplay = new TextUI(1);
			manaDisplay.setPosition(portrait.getPosition().x - 150, portrait.getPosition().y);
			var manaF:TextFormat = manaDisplay.format;
			manaF.align = TextAlign.RIGHT;
			manaF.size = 20;
			manaDisplay.format = manaF;
			addEntity(manaDisplay);

			simulation = new Simulation();

			iso = new IsometricEngine;
			iso.init();
			stage.addChild(iso);

			fogMiddle = new Image(Texture.fromAsset("assets/fog.png"));
			stage.addChild(fogMiddle);

			addEntity(logText);
			addEntity(testProgress);
			addEntity(portrait);

			fogFront = new Image(Texture.fromAsset("assets/fog_top.png"));
			fogFront.alpha = 0.5;
			fogFront.width = 2844;
			fogFront.height = 720;
			fogFront.touchable = false;
			stage.addChild(fogFront);
			fogFront2 = new Image(Texture.fromAsset("assets/fog_top.png"));
			fogFront2.alpha = 0.5;
			fogFront2.width = 2844;
			fogFront2.height = 720;
			fogFront2.x += fogFront.width;
			fogFront2.touchable = false;
			stage.addChild(fogFront2);

			stage.addChild(ui);
			stage.addChild(cards);
		}

		public static function instance():Environment
		{
			return _instance;
		}

		public function tileSelected(tile:Tile)
		{
			trace("Tile clicked");
		}

		public function addEntity(e:Entity)
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

			if (!Card.handIsFull() && !Card.deckIsEmpty())
			{
				Card.drawCard();
			}

			/*if (cardTimer > cardTreshold)
			{
				cardTimer -= cardTreshold;
				var c = Card.addCard(Card.TYPE_RAIN);
				if (c != null) addEntity(c);
			}
			cardTimer += dt;*/

			testProgress.progress = testProgress.progress >= 1 ? testProgress.progress - 1 : testProgress.progress + dt;

			fogFront.x -= dt * 10;
			fogFront2.x -= dt * 10;
			if (fogFront.x + fogFront.width <= 0)
				fogFront.x += fogFront.width * 2;
			if (fogFront2.x + fogFront2.width <= 0)
				fogFront2.x += fogFront2.width * 2;

			fogBack.x += dt * 10;
			fogBack2.x += dt * 10;
			if (fogBack.x >= Const.SCREEN_WIDTH)
				fogBack.x -= fogBack.width * 2;
			if (fogBack2.x >= Const.SCREEN_WIDTH)
				fogBack2.x -= fogBack2.width * 2;

			simulation.tick(dt);
		}

		public function render()
		{
			tempStats.setText("Current population: " + simulation.currentPopulation, TextUI.COLOR_POSITIVE);
			tempStats.setText("Current food: " + simulation.currentFood, TextUI.COLOR_NEGATIVE);
			tempStats.setText("Food trend: " + simulation.foodTrend);

			manaDisplay.setText("20");

			for (var i:int = 0; i < entities.length; i++)
			{
				var entity = entities[i];
				entity.render();
			}
		}

		public function getUI():Sprite
		{
			return ui;
		}

		public function getCardUI():Sprite
		{
			return cards;
		}

		public function addLog(text:String, color:uint = 0xFFFFFF)
		{
			logText.setText(text, color);
		}

		private function touchEvent(e:TouchEvent)
		{
			var touch:Touch = e.getTouch(cardGetter, TouchPhase.BEGAN);
			if (touch)
			{
				Card.newCard();
			}
		}
	}

}
