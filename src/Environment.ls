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
		
		public function Environment(stage:Stage) 
		{
			this.w = Const.SCREEN_WIDTH;
			this.h = Const.SCREEN_HEIGHT;
			this.h = h;
			
			Entity.environment = this;
			
			iso = new IsometricEngine;
			stage.addChild(iso);
		}
		
		public function tick(t:Number, dt:Number)
		{
			t += dt;
		}
		
		public function render(t:Number)
		{
			
		}
	}
	
}