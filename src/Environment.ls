package
{
	import loom2d.display.Image;
	import loom2d.display.Sprite;
	import loom2d.display.Stage;

	public class Environment
	{
		private var w:int;
		private var h:int;

		private var background:Image;

		private var ui:Sprite = new Sprite();

		private var entities = new Vector.<Entity>();

		private var testText:TextUI;

		public function Environment(stage:Stage, w:int, h:int)
		{
			this.w = Const.SCREEN_WIDTH;
			this.h = Const.SCREEN_HEIGHT;
			this.h = h;

			Entity.environment = this;

			testText = new TextUI();

			testText.setText("Test text");

			iso = new IsometricEngine;
			stage.addChild(iso);

			simulation = new Simulation();
			addEntity(testText);

			stage.addChild(ui);
		}

		private function addEntity(e:Entity)
		{
			entities.push(e);
		}

		public function tick(t:Number, dt:Number)
		{
			for (var i:int = 0; i < entities.length; i++)
			{
				var entity = entities[i];
				entity.tick(t, dt);
			}

			t += dt;

			simulation.tick(dt);
		}

		public function render(t:Number)
		{
			for (var i:int = 0; i < entities.length; i++)
			{
				var entity = entities[i];
				entity.render(t);
			}
		}

		public function getUILayer():Sprite
		{
			return ui;
		}
	}

}