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

		private static var CARDS:Vector.<Card> = new Vector.<Card>();
		private static var TWEENS:Vector.<Tween> = new Vector.<Tween>();
		private static var CARD_LOCATIONS:Vector.<Point> = new Vector.<Point>();
		private static var MAX_CARDS:int = 3;

		public static var TYPE_RAIN:String = "rain";
		public static var TYPE_FOOD:String = "food";

		private static var cardFace:Texture;
		private static var cardImages:Vector.<Image>;

		private static var tweenTime:Number = 1;

		private var img:ImageCard;

		public function Card()
		{
			if (cardFace == null)
				cardFace = Texture.fromAsset("assets/card-face.png");

			if (cardImages == null)
			{
				cardImages = new Vector.<Image>();
			}

			img = new ImageCard(cardFace);
			img.center();
			environment.getCardUI().addChild(img);

			img.addEventListener(TouchEvent.TOUCH, touchEvent);
		}

		override public function destroy()
		{
			environment.getUI().removeChild(img);
			img = null;

			super.destroy();

			clean();
		}

		override public function render()
		{
			img.x = x;
			img.y = y;
			img.rotation = rotation;

			super.render();
		}

		override public function tick(dt:Number)
		{


			super.tick(dt);
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
			defaultSort();

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
					animateCard(CARDS[0], TWEENS[0], 0, -20, 0);
					break;
				case 2:
					animateCard(CARDS[0], TWEENS[0], -30, 0, -Math.PI/15);
					animateCard(CARDS[1], TWEENS[1],  30, 0,  Math.PI/15);

					break;
				case 3:
					animateCard(CARDS[0], TWEENS[0], -90,   0, -Math.PI/10);
					animateCard(CARDS[1], TWEENS[1],   0, -20,  0);
					animateCard(CARDS[2], TWEENS[2],  90,   0,  Math.PI/10);

					break;
			}
		}

		private static function animateCard(card:Card, tween:Tween, x:Number, y:Number, rotation:Number)
		{
			Loom2D.juggler.remove(tween);
			tween.reset(card, tweenTime, Transitions.EASE_OUT);
			tween.animate("x", x);
			tween.animate("y", y);
			tween.animate("rotation", rotation);
			Loom2D.juggler.add(tween);
		}

		public function use()
		{
			this.destroy();
		}

		public function numCards():int
		{
			return CARDS.length;
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
			// Hover
			var touch = e.getTouch(img, TouchPhase.HOVER);
			if (touch)
			{
				//state = Entity.STATE_IDLE;
				if (state != STATE_HOVER)
				{
					state = STATE_HOVER;
					animateCard(this, getTween(this), this.x, -50, 0);
					img.setDepth(-1);
					environment.getCardUI().sortChildren(ImageCard.zSort);
				}
			} else {
				state = STATE_IDLE;
				sortCards();
				defaultSort();
			}
		}

		private static function defaultSort()
		{
			for (var i = 0; i < CARDS.length; i++)
			{
				CARDS[i].getImg().setDepth(i);
			}
			environment.getCardUI().sortChildren(ImageCard.zSort);
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
			return img;
		}
	}

}