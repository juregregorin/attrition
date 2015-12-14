package ui
{
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
		private var wings:Image;
		private var disc:Image;
		private var glow:Image;

		private var holder:Sprite;

		private var cardTimer:Number = 0;
		private var cardInterval:Number = 20;

		private var timerDisplay:Shape;
		private var g:Graphics;

		private var format:TextFormat;

		public function CardTimer()
		{
			holder = new Sprite();

			wings = new Image(Texture.fromAsset("assets/ui/wings.png"));
			wings.center();
			holder.addChild(wings);

			glow = new Image(Texture.fromAsset("assets/ui/glow.png"));
			glow.center();
			glow.scale = 1.5;
			holder.addChild(glow);

			disc = new Image(Texture.fromAsset("assets/ui/disc.png"));
			disc.center();
			holder.addChild(disc);

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
		}

		override public function render()
		{
			holder.x = x;
			holder.y = y;
			//holder.rotation = rotation;

			g.clear();
			g.textFormat(format);
			g.drawTextLine(0, 0, Math.floor(cardInterval - cardTimer) + "");

			super.render();
		}

		override public function tick(dt:Number)
		{
			cardTimer += dt;

			if (cardTimer >= cardInterval)
			{
				cardTimer -= cardInterval;
				// do things to enable card draw
			}

			super.tick(dt);
		}
	}

}