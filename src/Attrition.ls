package
{
	import loom.Application;
	import loom.gameframework.TimeManager;
	import loom2d.display.StageScaleMode;
	import loom2d.display.Image;
	import loom2d.textures.Texture;
	import loom2d.textures.TextureSmoothing;
	import loom2d.ui.SimpleLabel;
	import loom2d.events.Touch;
	import loom2d.events.TouchEvent;
	import loom2d.events.TouchPhase;

	public class Attrition extends Application
	{
		private var environment:Environment;

		[Inject]
		private var time:TimeManager;

		override public function run():void
		{
			stage.scaleMode = StageScaleMode.LETTERBOX;
			this.stage.reportFps = true;

			environment = new Environment(stage);

			stage.addEventListener(TouchEvent.TOUCH, touchEvent);
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

		private function touchEvent(e:TouchEvent)
		{
			var touch:Touch = e.getTouch(stage, TouchPhase.ENDED);
			if (touch == null)
				touch = e.getTouch(stage, TouchPhase.BEGAN);
			if (touch)
			{
				trace("brodcasting touch");
				Environment.instance().iso.touchable = true;
				Environment.instance().iso.broadcastEvent(new TouchEvent(e.type, e.touches, e.shiftKey, e.ctrlKey, false));
				Environment.instance().iso.touchable = false;
			}
		}
	}
}