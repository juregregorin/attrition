package
{
	import loom.Application;
	import loom2d.display.StageScaleMode;
	import loom2d.display.Image;
	import loom2d.textures.Texture;
	import loom2d.textures.TextureSmoothing;
	import loom2d.ui.SimpleLabel;

	public class Attrition extends Application
	{
		/** Simulation delta time */
		private var dt = 1 / 60;
		
		/** Simulation time */
		private var t = 0;
		
		private var environment:Environment;
		
		override public function run():void
		{
			stage.scaleMode = StageScaleMode.LETTERBOX;
			
			TextureSmoothing.defaultSmoothing = TextureSmoothing.NONE;
			
			environment = new Environment(stage);
		}
		
		override public function onTick()
		{
			environment.tick(t, dt);
			return super.onTick();
		}
		
		override public function onFrame()
		{
			environment.render(t);
			return super.onFrame();
		}
	}
}