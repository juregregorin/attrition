package
{
	import loom2d.display.Image;
	import loom2d.display.Stage;

	/**
	 * ...
	 * @author Tadej
	 */
	public class Environment
	{
		private var w:int;
		private var h:int;

		private var background:Image;

		private var iso:IsometricEngine;
		private var simulation:Simulation;

		public function Environment(stage:Stage)
		{
			this.w = Const.SCREEN_WIDTH;
			this.h = Const.SCREEN_HEIGHT;
			this.h = h;

			Entity.environment = this;

			iso = new IsometricEngine;
			stage.addChild(iso);

			simulation = new Simulation();
		}

		public function tick(dt:Number)
		{
			simulation.tick(dt);
		}

		public function render()
		{

		}
	}

}