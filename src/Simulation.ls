package
{
	public class Simulation
	{
		private var population:Number;

		private var elapsedTime:Number;
		private const SIMULATION_TICK_TIME = 1;

		public function Simulation()
		{
			// Set initial population;
			population = 100;

			elapsedTime = 0;
		}

		public function tick(dt:Number):void
		{
			elapsedTime += dt;
			if (elapsedTime >= SIMULATION_TICK_TIME)
			{
				elapsedTime -= SIMULATION_TICK_TIME;
				simulationTick();
			}
		}

		public function simulationTick():void
		{
			population += 1;

			trace(population);
		}

		public function get currentPopulation():Number
		{
			return population;
		}
	}
}