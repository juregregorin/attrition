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

		private var iso:IsometricEngine;
		private var simulation:Simulation;

		private var testText:TextUI;

		public function Environment(stage:Stage)
		{
			this.w = Const.SCREEN_WIDTH;
			this.h = Const.SCREEN_HEIGHT;
			this.h = h;

			Entity.environment = this;

			testText = new TextUI();

			testText.setText("Test text");

			iso = new IsometricEngine;
			stage.addChild(iso);

			simulation = new Simulation(iso);
			addEntity(testText);

			stage.addChild(ui);
		}

		private function addEntity(e:Entity)
		{
			entities.push(e);
		}

		public function tick(dt:Number)
		{
			for (var i:int = 0; i < entities.length; i++)
			{
				var entity = entities[i];
				entity.tick(dt);
			}

			simulation.tick(dt);
		}

		public function render()
		{
			for (var i:int = 0; i < entities.length; i++)
			{
				var entity = entities[i];
				entity.render();
			}
		}

		public function getUILayer():Sprite
		{
			return ui;
		}
	}

}
