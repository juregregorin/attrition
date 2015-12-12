package ui
{
	import loom2d.display.Image;
	import loom2d.display.Sprite;
	import loom2d.math.Rectangle;
	import loom2d.textures.Texture;
	import Entity;

	public class ProgressUI extends Entity
	{
		protected var progressBgTexture:Texture = null;
		protected var progressFgTexture:Texture = null;

		protected var progressBg:Image = null;
		protected var progressFg:Sprite = null;

		protected var _progress:Number;

		public function ProgressUI()
		{
			if (progressBgTexture == null)
				progressBgTexture = Texture.fromAsset("assets/progress-bar-bg.png");

			if (progressFgTexture == null)
				progressFgTexture = Texture.fromAsset("assets/progress-bar-fg.png");

			progressBg = new Image(progressBgTexture);
			progressFg = new Sprite();
			progressFg.addChild(new Image(progressFgTexture));

			Entity.environment.getUI().addChild(progressBg);
			Entity.environment.getUI().addChild(progressFg);
		}

		override public function render() {
			progressBg.x = p.x;
			progressBg.y = p.y;
			progressFg.x = progressBg.x;
			progressFg.y = progressBg.y;

			progressFg.clipRect = new Rectangle(0, 0, _progress * progressFgTexture.width, progressFgTexture.height);
		}

		public function set progress(p:Number) { _progress = p > 1 ? 1 : p < 0 ? 0 : p; }

		public function get progress():Number { return _progress; }
	}

}