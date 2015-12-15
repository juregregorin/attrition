package ui
{
	import loom2d.animation.Transitions;
	import loom2d.animation.Tween;
	import loom2d.display.Image;
	import loom2d.events.Touch;
	import loom2d.events.TouchEvent;
	import loom2d.events.TouchPhase;
	import loom2d.Loom2D;
	import loom2d.math.Point;
	import loom2d.math.Rectangle;
	import loom2d.textures.Texture;
	import Entity;

	public class Card extends Entity
	{
		private static var STATE_HOVER:String = "hover";
		private static var STATE_USED:String = "used";
		private static var STATE_SELECTED:String = "selected";
		private static var STATE_DRAWING:String = "in_draw";
		private static var STATE_IN_DECK:String = "in_deck";

		private static var CARDS:Vector.<Card> = new Vector.<Card>();
		private static var TWEENS:Vector.<Tween> = new Vector.<Tween>();
		private static var CARD_LOCATIONS:Vector.<Point> = new Vector.<Point>();
		private static var MAX_CARDS:int = 3;

		private static var CARD_DECK:Vector.<Card> = new Vector.<Card>();

		private static var SELECTED_CARD:Card = null;

		public static var TYPE_RAIN:String = "rain";
		public static var TYPE_FOOD:String = "food";
		public static var TYPE_MEDITATE:String = "meditate";
		public static var TYPE_HEAL:String = "heal";
		public static var TYPE_SACRIFICE:String = "sacrifice";

		public static var TARGET_SELF:String = "self";
		public static var TARGET_AREA:String = "area";
		public static var TARGET_ALL:String = "all";
		public static var TARGET_SINGLE:String = "single";

		private static var cardImages:Vector.<Image>;

		private static var tweenTime:Number = 1;

		private static var drawTween:Tween;

		private var cardBase:ImageCard;

		private var cardType:String = "";
		private var cardName:String = "";
		private var manaCost:uint = 0;
		private var spellIntensity:Number = 0;
		private var spellDescription:String = "";
		private var targetEffect:String = "";

		public var enabled:Boolean = true;

		private static var minScale:Number = 0.28;
		private static var maxScale:Number = 0.70;

		public var scale:Number = 1;

		public function Card(type:String = "")
		{

			if (cardImages == null)
				cardImages = new Vector.<Image>();

			if (drawTween == null)
			{
				drawTween = new Tween(this, tweenTime, Transitions.EASE_IN);
				drawTween.animate("x", x);
				drawTween.animate("y", y);
				drawTween.animate("rotation", rotation);
			}
			else
			{
				drawTween.reset(cardBase, tweenTime, Transitions.EASE_IN);
			}

			generateCard(type);
			cardBase = new ImageCard(cardType);
			cardBase.setText(cardName, manaCost, spellDescription);

			trace("Generated: " + this);

			environment.getCardUI().addChild(cardBase);

			cardBase.scale = 0.35;

			cardBase.addEventListener(TouchEvent.TOUCH, touchEvent);
		}


		public function get type():String
		{
			return cardType;
		}

		public function get name():String
		{
			return cardName;
		}

		public function get cost():uint
		{
			return manaCost;
		}

		public function get intensity():Number
		{
			return spellIntensity;
		}

		public function get target():String
		{
			return targetEffect;
		}

		override public function destroy()
		{
			state = STATE_DESTROYED;
			environment.getUI().removeChild(cardBase);
			environment.removeEntity(this);
			cardBase.destroy();
			cardBase = null;

			super.destroy();

			clean();
			sortCards();
		}

		override public function render()
		{
			if (state == STATE_IN_DECK)
				cardBase.alpha = 0;
			else if (!enabled)
				cardBase.alpha = 0.3;
			else
				cardBase.alpha = _alpha;

			cardBase.x = x;
			cardBase.y = y;
			cardBase.rotation = rotation;
			cardBase.scale = scale;

			super.render();
		}

		override public function tick(dt:Number)
		{
			super.tick(dt);
		}

		public function generateCard(type:String = "")
		{
			if (type.length == 0)
				switch(Math.randomRangeInt(0,3))
				{
					case 0:
						type = TYPE_FOOD;
						break;
					case 1:
						type = TYPE_MEDITATE;
						break;
					case 2:
						type = TYPE_RAIN;
						break;
					case 3:
						type = TYPE_SACRIFICE;
						break;
				}

			cardType = type;
			switch (type)
			{
				case TYPE_FOOD:
					cardName = "Plentiful Harvest";
					manaCost = Math.randomRangeInt(1, 6);
					spellIntensity = 5 * manaCost;
					spellDescription = "Increase food production in target area by *" + spellIntensity + "* percent.";
					targetEffect = TARGET_AREA;
					break;
				case TYPE_MEDITATE:
					cardName = "Meditate";
					manaCost = 0;
					spellIntensity = 0;
					spellDescription = "Increase aether regeneration. Cannot cast spells until aether is fully regenerated.";
					targetEffect = TARGET_SELF;
					break;
				case TYPE_RAIN:
					cardName = "Downpour";
					manaCost = Math.randomRangeInt(1, 10);
					spellIntensity = 5 * manaCost;
					spellDescription = "Restore *" + spellIntensity + "* percent of water to tiles in target area.";
					targetEffect = TARGET_AREA;
					break;
				case TYPE_HEAL:
					cardName = "Divine Remedy";
					manaCost = Math.randomRangeInt(3, 10);
					spellIntensity = 5 * (manaCost);
					spellDescription = "Heal population by *" + spellIntensity + "* percent and/or remove plague in target area.";
					targetEffect = TARGET_AREA;
					break;
				case TYPE_SACRIFICE:
					cardName = "Sacrifice";
					manaCost = Math.randomRangeInt(0, 1) ? 0 : 4;
					targetEffect = manaCost == 0 ? TARGET_SINGLE : TARGET_AREA;
					spellDescription = "Sacrifice up to " + (manaCost == 0? "1" : "9") +" of the population in the target "
									 + (manaCost == 0 ? "tile" : "area") + ". You gain 1 aether for each sacrifice.";
			}
		}

		public static function newCard()
		{
			var c = new Card();

			c.state = STATE_IN_DECK;
			c.render();
			c.x = -environment.getCardUI().x + 1280 / 2;
			c.y = -environment.getCardUI().y - c.cardBase.height;
			c.scale = minScale;

			CARD_DECK.push(c);
		}

		public static function drawCard()
		{
			if (CARD_DECK.length == 0) return;

			var c = CARD_DECK[0];
			if (c.state != STATE_IN_DECK) return;
			c.state = STATE_DRAWING;

			environment.addEntity(c);

			Loom2D.juggler.remove(drawTween);
			drawTween.reset(c, tweenTime, Transitions.EASE_IN_OUT);
			drawTween.animate("x", -environment.getCardUI().x + (1280 / 2));
			drawTween.animate("y", -environment.getCardUI().y +  (720 / 2));
			drawTween.onComplete = takeCard;
			drawTween.onCompleteArgs = [c];
			Loom2D.juggler.add(drawTween);
		}

		public static function takeCard(c:Card)
		{
			CARD_DECK.remove(c);
			CARDS.push(c);
			var t = new Tween(c, tweenTime, Transitions.EASE_OUT);
			TWEENS.push(t);
			CARD_LOCATIONS.push(Point.ZERO);
			c.state = STATE_IDLE;
			sortCards();
			smartSort();
		}

		public static function handIsFull():Boolean
		{
			return CARDS.length >= MAX_CARDS;
		}

		public static function deckIsEmpty():Boolean
		{
			return CARD_DECK.length == 0;
		}

		public static function addCard(cardType:String):Card
		{
			if (CARDS.length >= MAX_CARDS) return null;
			var c = new Card();
			CARDS.push(c);

			var t = new Tween(c, 1, Transitions.EASE_OUT);
			TWEENS.push(t);
			CARD_LOCATIONS.push(Point.ZERO);

			c.x = -200;
			c.y = -200;

			sortCards();
			smartSort();

			return c;
		}

		public static function sortCards()
		{
			if (CARDS.length == 0) return;

			var px = environment.getCardUI().x;
			var py = environment.getCardUI().y;

			switch (CARDS.length)
			{
				case 1:
					if (CARDS[0].state != STATE_SELECTED && CARDS[0].state != STATE_DRAWING && CARDS[0].state != STATE_IN_DECK)
						animateCard(CARDS[0], TWEENS[0], 0, -20, 0, minScale);
					break;
				case 2:
					if (CARDS[0].state != STATE_SELECTED && CARDS[0].state != STATE_DRAWING && CARDS[0].state != STATE_IN_DECK)
						animateCard(CARDS[0], TWEENS[0], -30, 0, -Math.PI/15, minScale);
					if (CARDS[1].state != STATE_SELECTED && CARDS[0].state != STATE_DRAWING && CARDS[1].state != STATE_IN_DECK)
						animateCard(CARDS[1], TWEENS[1],  30, 0,  Math.PI/15, minScale);

					break;
				case 3:
					if (CARDS[0].state != STATE_SELECTED && CARDS[0].state != STATE_DRAWING && CARDS[0].state != STATE_IN_DECK)
						animateCard(CARDS[0], TWEENS[0], -90,   0, -Math.PI/10, minScale);
					if (CARDS[1].state != STATE_SELECTED && CARDS[1].state != STATE_DRAWING && CARDS[1].state != STATE_IN_DECK)
						animateCard(CARDS[1], TWEENS[1],   0, -20,  0, minScale);
					if (CARDS[2].state != STATE_SELECTED && CARDS[2].state != STATE_DRAWING && CARDS[2].state != STATE_IN_DECK)
						animateCard(CARDS[2], TWEENS[2],  90,   0,  Math.PI/10, minScale);

					break;
			}
		}

		private static function animateCard(card:Card, tween:Tween, x:Number, y:Number, rotation:Number, scale:Number = 1)
		{
			Loom2D.juggler.remove(tween);
			tween.reset(card, tweenTime, Transitions.EASE_OUT);
			tween.animate("x", x);
			tween.animate("y", y);
			tween.animate("scale", scale);
			tween.animate("rotation", rotation);
			Loom2D.juggler.add(tween);
		}

		public function use()
		{
			environment.getCardUI().removeChild(cardBase);
			environment.removeEntity(this);
		}

		public function numCards():int
		{
			return CARDS.length;
		}

		public function deselect()
		{
			state = STATE_IDLE;
		}

		private function clean()
		{
			for (var i = 0; i < CARDS.length; i++)
			{
				if (CARDS[i].getState() == Entity.STATE_DESTROYED) {
					CARDS.remove(CARDS[i]);
					TWEENS.remove(TWEENS[i]);
				}
			}
		}

		private function touchEvent(e:TouchEvent)
		{
			if (state == STATE_IN_DECK || state == STATE_DRAWING) return;
			var touch:Touch = null;

			if (environment.isTargeting()) return;

			// Click
			touch = e.getTouch(cardBase, TouchPhase.BEGAN);
			if (touch)
			{
				if (!enabled)
				{
					if (environment.mana < cost)
						environment.addLog("Not enough mana!", TextUI.COLOR_NEGATIVE);
					else
						environment.addLog("Cannot cast at this moment!", TextUI.COLOR_NEGATIVE);
					return;
				}
				if (state == STATE_SELECTED)
				{
					state = STATE_HOVER;
					SELECTED_CARD = null;
				}
				else
				{
					clearSelection();
					state = STATE_SELECTED;
					SELECTED_CARD = this;
					sortCards();
				}

				return;
			}

			// Hover
			touch = e.getTouch(cardBase, TouchPhase.HOVER);
			if (touch)
			{
				if (state == STATE_IDLE)
				{
					state = STATE_HOVER;
					animateCard(this, getTween(this), -25, -250, 0, Card.maxScale);
					smartSort();
					environment.getCardUI().sortChildren(ImageCard.zSort);
				}
			} else if (state != STATE_SELECTED) {
				state = STATE_IDLE;
				sortCards();
				smartSort();
			}
		}

		private static function smartSort()
		{
			for (var i = 0; i < CARDS.length; i++)
			{
				if (CARDS[i].state == STATE_SELECTED)
					CARDS[i].getImg().setDepth(-1);
				else if (CARDS[i].state == STATE_HOVER)
					CARDS[i].getImg().setDepth(-2);
				else
					CARDS[i].getImg().setDepth(i);
			}
			environment.getCardUI().sortChildren(ImageCard.zSort);
		}

		private static function clearSelection()
		{
			for (var i = 0; i < CARDS.length; i++)
			{
				CARDS[i].deselect();
			}
			SELECTED_CARD = null;
		}

		private function getTween(c:Card):Tween
		{
			for (var i = 0; i < TWEENS.length; i++) {
				if ((TWEENS[i] as Tween).target == this)
					return TWEENS[i];
			}
			return null;
		}

		private function getImg():ImageCard
		{
			return cardBase;
		}

		public static function selectedCard():Card
		{
			for (var i = 0; i < CARDS.length; i++)
			{
				if (CARDS[i].state == STATE_SELECTED)
				{
					return CARDS[i];
				}
			}
			return null;
		}

		public static function checkPlayability()
		{
			for (var i = 0; i < CARDS.length; i++)
			{
				var c:Card = CARDS[i];
				if (environment.mana < c.cost || !environment.canPlayCards)
					c.enabled = false;
				else
					c.enabled = true;
			}
		}

		public function toString():String
		{
			return "[Card state='"+state+"', cardName='"+cardName+"', cardDescription='"+spellDescription+"']";
		}
	}

}