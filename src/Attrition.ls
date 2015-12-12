package
{
	import loom.Application;
	import loom.gameframework.TimeManager;
	import loom2d.display.StageScaleMode;
	import loom2d.display.Image;
	import loom2d.textures.Texture;
	import loom2d.textures.TextureSmoothing;
	import loom2d.ui.SimpleLabel;

	public class Attrition extends Application
	{
		private var environment:Environment;

		[Inject]
		private var time:TimeManager;

		override public function run():void
		{
			stage.scaleMode = StageScaleMode.LETTERBOX;

			TextureSmoothing.defaultSmoothing = TextureSmoothing.NONE;

			environment = new Environment(stage);
		}

		override public function onTick()
		{
			environment.tick(time.deltaTime);

			return super.onTick();
		}

		override public function onFrame()
		{
			environment.render();
			return super.onFrame();
		}
	}
}