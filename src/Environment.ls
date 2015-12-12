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
		
		public function Environment(stage:Stage, w:int, h:int) 
		{
			this.w = w;
			this.h = h;
			
			Entity.environment = this;
			
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