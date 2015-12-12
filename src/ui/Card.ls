package ui
{
	import loom2d.animation.Transitions;
	import loom2d.animation.Tween;
	import loom2d.display.Image;
	import loom2d.Loom2D;
	import loom2d.math.Point;
	import loom2d.textures.Texture;
	import Entity;

	public class Card extends Entity
	{
		private static var CARDS:Vector.<Card> = new Vector.<Card>();
		private static var TWEENS:Vector.<Tween> = new Vector.<Tween>();
		private static var MAX_CARDS:int = 3;
		private static var position:Point = Point.ZERO;

		public static var TYPE_RAIN:String = "rain";
		public static var TYPE_FOOD:String = "food";

		private static var cardFace:Texture;
		private static var cardImages:Vector.<Image>;

		private static var tweenTime:Number = 1;

		private var img:Image;

		public function Card()
		{
			if (cardFace == null)
				cardFace = Texture.fromAsset("assets/card-face.png");

			if (cardImages == null)
			{
				cardImages = new Vector.<Image>();
			}

			img = new Image(cardFace);
			img.center();
			environment.getUI().addChild(img);
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

		public static function addCard(cardType:String):Card
		{
			if (CARDS.length >= MAX_CARDS) return null;
			var c = new Card();
			CARDS.push(c);

			var t = new Tween(c, 1, Transitions.EASE_OUT);
			TWEENS.push(t);

			sortCards();

			return c;
		}

		public static function sortCards()
		{
			if (CARDS.length == 0) return;

			if (CARDS.length == 1)
			{
				CARDS[0].rotation = 0;
				CARDS[0].setPosition(position.x, position.y);
				return;
			}

			switch (CARDS.length)
			{
				case 1:
					//CARDS[0].rotation = 0;
					//CARDS[0].setPosition(position.x, position.y - 20);
					Loom2D.juggler.remove(TWEENS[0]);
					TWEENS[0].reset(CARDS[0], tweenTime, Transitions.EASE_OUT);
					TWEENS[0].animate("x", position.x);
					TWEENS[0].animate("y", position.y - 20);
					TWEENS[0].animate("rotation", 0);
					Loom2D.juggler.add(TWEENS[0]);

					break;
				case 2:
					Loom2D.juggler.remove(TWEENS[0]);
					TWEENS[0].reset(CARDS[0], tweenTime, Transitions.EASE_OUT);
					TWEENS[0].animate("x", position.x - 30);
					TWEENS[0].animate("y", position.y);
					TWEENS[0].animate("rotation", -Math.PI/15);
					Loom2D.juggler.add(TWEENS[0]);

					Loom2D.juggler.remove(TWEENS[1]);
					TWEENS[1].reset(CARDS[1], tweenTime, Transitions.EASE_OUT);
					TWEENS[1].animate("x", position.x + 30);
					TWEENS[1].animate("y", position.y);
					TWEENS[1].animate("rotation", Math.PI/15);
					Loom2D.juggler.add(TWEENS[1]);

					break;
				case 3:
					Loom2D.juggler.remove(TWEENS[0]);
					TWEENS[0].reset(CARDS[0], tweenTime, Transitions.EASE_OUT);
					TWEENS[0].animate("x", position.x - 70);
					TWEENS[0].animate("y", position.y);
					TWEENS[0].animate("rotation", -Math.PI/10);
					Loom2D.juggler.add(TWEENS[0]);

					Loom2D.juggler.remove(TWEENS[1]);
					TWEENS[1].reset(CARDS[1], tweenTime, Transitions.EASE_OUT);
					TWEENS[1].animate("x", position.x);
					TWEENS[1].animate("y", position.y - 20);
					TWEENS[1].animate("rotation", 0);
					Loom2D.juggler.add(TWEENS[1]);

					Loom2D.juggler.remove(TWEENS[2]);
					TWEENS[2].reset(CARDS[2], tweenTime, Transitions.EASE_OUT);
					TWEENS[2].animate("x", position.x + 70);
					TWEENS[2].animate("y", position.y);
					TWEENS[2].animate("rotation", Math.PI/10);
					Loom2D.juggler.add(TWEENS[2]);

					break;
			}
		}

		public static function setLocation(x:Number = 0, y:Number = 0)
		{
			position.x = x;
			position.y = y;
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
	}

}