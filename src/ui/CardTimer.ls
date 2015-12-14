package ui
{
	import loom2d.display.DisplayObject;
	import loom2d.display.Graphics;
	import loom2d.display.Shape;
	import loom2d.display.Image;
	import loom2d.display.Sprite;
	import loom2d.display.TextAlign;
	import loom2d.display.TextFormat;
	import loom2d.textures.Texture;
	import Entity;

	public class CardTimer extends Entity
	{
		public static var STATE_CARD_READY:String = "card_ready";

		private var wings:Image;
		private var disc:Image;
		private var glow:Image;

		private var holder:Sprite;

		private var cardTimer:Number = 0;
		private var cardInterval:Number = 5;

		private var timerDisplay:Shape;
		private var g:Graphics;

		private var glowMaxAlpha:Number = .7;
		private var glowTime:Number = 0;

		private var format:TextFormat;

		public function CardTimer()
		{
			holder = new Sprite();

			wings = new Image(Texture.fromAsset("assets/ui/wings.png"));
			wings.center();
			holder.addChild(wings);

			disc = new Image(Texture.fromAsset("assets/ui/disc.png"));
			disc.center();
			holder.addChild(disc);

			glow = new Image(Texture.fromAsset("assets/ui/glow.png"));
			glow.center();
			glow.scale = 2.5;
			glow.y = -26.5;
			glow.alpha = glowMaxAlpha;
			holder.addChild(glow);

			timerDisplay = new Shape();
			g = timerDisplay.graphics;
			holder.addChild(timerDisplay);

			format = new TextFormat();
			format.font = "dungeon";
			format.color = 0xFFFFFF;
			format.size = 45;
			format.align = TextAlign.MIDDLE | TextAlign.CENTER;

			timerDisplay.y = -24.5;

			environment.getUI().addChild(holder);
			environment.addEntity(this);
		}

		public function get height():Number
		{
			return wings.height;
		}

		public function get width():Number
		{
			return wings.width;
		}

		public function resetTimer()
		{
			cardTimer = 0;
			state = STATE_IDLE;
			glowTime = 0;
		}

		public function canDraw():Boolean
		{
			return state == STATE_CARD_READY;
		}

		override public function render()
		{
			holder.x = x;
			holder.y = y;
			//holder.rotation = rotation;

			g.clear();
			if (state != STATE_CARD_READY)
			{
				format.size = 45;
				g.textFormat(format);
				g.drawTextLine(0, 0, Math.ceil(cardInterval - cardTimer) + "");
			}
			else
			{
				format.size = 30;
				g.textFormat(format);
				g.drawTextLine(0, 0, "Ready");
			}

			glow.alpha = glowMaxAlpha * Math.abs(Math.sin(glowTime));

			super.render();
		}

		public function get touchableObject():DisplayObject
		{
			return holder;
		}

		override public function tick(dt:Number)
		{
			if (state == STATE_IDLE)
				cardTimer += dt;

			if (cardTimer >= cardInterval)
			{
				cardTimer = cardInterval;
				// do things to enable card draw
				state = STATE_CARD_READY;
			}

			if (state == STATE_CARD_READY)
				glowTime += dt * 2;

			super.tick(dt);
		}
	}

}