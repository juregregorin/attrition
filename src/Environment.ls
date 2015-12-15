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
	import ui.CardTimer;
	import ui.StatBar;
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

		//private var testProgress:ProgressUI;
		private var cards:Sprite;

		private var fogBack:Image;
		private var fogBack2:Image;
		private var fogMiddle:Image;
		private var fogFront:Image;
		private var fogFront2:Image;

		private var statBar:StatBar;

		private var cardTimer:CardTimer;

		private var cardGetter:Sprite;
		private var cardPlayer:Sprite;

		private var selectedSpell:Card = null;
		private var targetingMode:Boolean = false;
		private var canPlaySpells:Boolean = true;

		private var isGameOver = false;

		private var gameOverOverlay:Image;

		private var pFood:Number = 0;
		private var pPop:Number = 0;
		private var popTrend:Number = 0;

		private var maxMana:Number = 10;
		private var curMana:Number = 5;
		private var rechargeRate:Number = 0.05;

		private var manaTime:Number = 0;

		public var canPlayCards:Boolean = true;

		public function Environment(stage:Stage)
		{
			_instance = this;

			Card.reset();

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

			logText = new TextUI(10);
			logText.rowOffset = -10;
			logText.x = 5;
			logText.y = 720 - (10 * (logText.format.size - 10) + 5);

			cardPlayer = new Sprite();
			var cp = new Image(Texture.fromAsset("assets/play-card.png"));
			cp.center();
			cardPlayer.addChild(cp);
			cardPlayer.x = 290;
			cardPlayer.y = stage.stageHeight - (cardPlayer.height / 2 + 10);
			ui.addChild(cardPlayer);
			cardPlayer.addEventListener(TouchEvent.TOUCH, touchEvent);

			//testProgress = new ProgressUI();

			cards = new Sprite();
			cards.x = stage.stageWidth -210;
			cards.y = stage.nativeStageHeight - 70;

			statBar = new StatBar();
			statBar.maximumMana = maxMana;
			ui.addChild(statBar);

			simulation = new Simulation();

			iso = new IsometricEngine;
			iso.init();
			stage.addChild(iso);

			fogMiddle = new Image(Texture.fromAsset("assets/fog.png"));
			stage.addChild(fogMiddle);

			addEntity(logText);
			//addEntity(testProgress);

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

			stage.addChild(cards);
			stage.addChild(ui);

			cardTimer = new CardTimer();
			cardTimer.x = 1280 / 2;
			cardTimer.y = cardTimer.height / 2;
			cardTimer.touchableObject.addEventListener(TouchEvent.TOUCH, touchEvent);

			gameOverOverlay = new Image(Texture.fromAsset("assets/gameover.png"));
			gameOverOverlay.width = 1280;
			gameOverOverlay.height = 720;
			gameOverOverlay.visible = false;
			stage.addChild(gameOverOverlay);
		}

		public static function instance():Environment
		{
			return _instance;
		}

		public function pickCard(c:Card)
		{
			if (c == null) return;
			selectedSpell = c;
			if (selectedSpell.target == Card.TARGET_AREA || selectedSpell.target == Card.TARGET_SINGLE)
				targetingMode = true;
			if (selectedSpell.target == Card.TARGET_SELF || selectedSpell.target == Card.TARGET_ALL)
				playSpell();
		}

		public function playSpell(tile:Tile = null)
		{
			if (selectedSpell == null && !targetingMode) return;

			var t:Vector.<Tile>;

			if (tile != null)
			{
				t = new Vector.<Tile>();
				t.push(tile);
				t = t.concat(simulation.getNeighbours(tile.logx, tile.logy));
			}

			switch(selectedSpell.type)
			{
				case Card.TYPE_MEDITATE:
					rechargeRate = 0.5;
					canPlayCards = false;
					addLog("You cast " + selectedSpell.name, TextUI.COLOR_DEFAULT);
					Environment.instance().simulation.playEffect("assets/sounds/magic4.ogg", SoundType.Other);
					break;
				case Card.TYPE_RAIN:
					for (var i = 0; i < t.length; i++)
					{
						t[i].water += selectedSpell.intensity / 100;
					}
					addLog("You cast " + selectedSpell.name, TextUI.COLOR_DEFAULT);
					Environment.instance().simulation.playEffect("assets/sounds/watersplash.ogg", SoundType.Other);
					break;
				case Card.TYPE_SACRIFICE:
					if (selectedSpell.target == Card.TARGET_SINGLE)
					{
						if (tile.population > 0) curMana++;
						tile.population = Math.max(0, tile.population - 1);
					}
					else
					{
						for (i = 0; i < t.length; i++)
						{
							if (tile.population > 0) curMana++;
							t[i].population = Math.max(0, t[i].population - 1);
						}
					}
					Environment.instance().simulation.playEffect("assets/sounds/magic1.ogg", SoundType.Other);
					addLog("You cast " + selectedSpell.name, TextUI.COLOR_DEFAULT);
					break;
				case Card.TYPE_FOOD:
					for (i = 0; i < t.length; i++)
					{
						t[i].foodBonus += selectedSpell.intensity / 100;
					}
					addLog("You cast " + selectedSpell.name, TextUI.COLOR_DEFAULT);
					Environment.instance().simulation.playEffect("assets/sounds/magic2.ogg", SoundType.Other);
					break;
			}

			curMana -= selectedSpell.cost;

			selectedSpell.destroy();
			selectedSpell = null;
			targetingMode = false;
		}

		public function addEntity(e:Entity)
		{
			entities.push(e);
		}

		public function removeEntity(e:Entity)
		{
			entities.remove(e);
		}

		public function tick(dt:Number)
		{
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

			manaTime += dt;

			while (manaTime > 1/rechargeRate)
			{
				manaTime -= 1/rechargeRate;
				curMana += 1;
			}

			if (curMana >= maxMana)
			{
				curMana = maxMana;
				rechargeRate = 0.05;
				canPlayCards = true;
			}

			Card.checkPlayability();

			if (isGameOver)
				return;

			for (var i:int = 0; i < entities.length; i++)
			{
				var entity = entities[i];
				entity.tick(dt);
			}

			if (!Card.handIsFull() && !Card.deckIsEmpty())
			{
				Card.drawCard();
				cardTimer.resetTimer();
			}

			//testProgress.progress = testProgress.progress >= 1 ? testProgress.progress - 1 : testProgress.progress + dt;

			simulation.tick(dt);
		}

		public function render()
		{
			//trace("Food trend: " + simulation.foodTrend);

			statBar.food = simulation.currentFood;
			statBar.foodRate = simulation.foodTrend;
			statBar.population = simulation.currentPopulation;
			statBar.mana = curMana;

			if (simulation.currentFood != pFood && simulation.currentFood == 0)
			{
				pFood = simulation.currentFood;
				addLog("Food reserves empty!", TextUI.COLOR_NEGATIVE);
			}

			if (simulation.currentPopulation != pPop)
			{
				pPop = simulation.currentPopulation < pPop ? -1 : simulation.currentPopulation > pPop ? 1 : 0;
				pPop = simulation.currentPopulation;
			}


			if (Card.selectedCard() != null && !targetingMode)
			{
				cardPlayer.visible = true;
			}
			else
			{
				cardPlayer.visible = false;
			}

			if (selectedSpell != null && targetingMode)
			{
				selectedSpell.alpha = .3;
			}
			else if (selectedSpell != null)
			{
				selectedSpell.alpha = 1;
			}

			for (var i:int = 0; i < entities.length; i++)
			{
				var entity = entities[i];
				entity.render();
			}
		}

		public function isTargeting():Boolean
		{
			return targetingMode;
		}

		public function getUI():Sprite
		{
			return ui;
		}

		public function getCardUI():Sprite
		{
			return cards;
		}

		public function get mana():Number
		{
			return curMana;
		}

		public function addLog(text:String, color:uint = 0xFFFFFF)
		{
			logText.setText(text, color);
		}

		private function touchEvent(e:TouchEvent)
		{
			var touch:Touch = e.getTouch(cardPlayer, TouchPhase.BEGAN);
			if (touch)
			{
				if (selectedSpell == null)
					pickCard(Card.selectedCard());
			}
		}

		public function set gameOver(val:Boolean)
		{
			isGameOver = val;
			gameOverOverlay.visible = val;
		}

		public function get gameOver():Boolean
		{
			return isGameOver;
		}
	}

}
