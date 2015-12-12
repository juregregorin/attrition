package
{
	import TileType;

	public class Simulation
	{
		private var elapsedTime:Number;
		private const SIMULATION_TICK_TIME = 1;

		private var isometric:IsometricEngine;

		public function Simulation(iso:IsometricEngine)
		{
			elapsedTime = 0;

			isometric = iso;
		}

		public function tick(dt:Number):void
		{
			elapsedTime += dt;
			if (elapsedTime >= SIMULATION_TICK_TIME)
			{
				elapsedTime -= SIMULATION_TICK_TIME;
				simulationTick();
				trace(currentPopulation);
			}
		}

		public function simulationTick():void
		{
			for (var i = 0; i < Const.NUM_TILES; i++)
			{
				for (var j = 0; j < Const.NUM_TILES; j++)
				{
					var t = isometric.getTile(i, j);

					if (t.population > 0 && t.canPopulate)
					{
						if (Math.randomRange(0, 1) > 0.0)
						{
							var success = populateTile(t);
							if (!success)
							{
								var neighbours:Vector.<Tile> = getNeighbours(i, j);
								neighbours.shuffle();
								for each(var tt:Tile in neighbours)
								{
									if (tt.canPopulate && populateTile(tt))
										break;
								}
							}
						}
					}
				}
			}
		}

		private function populateTile(tile:Tile):Boolean
		{
			tile.population += 1;
			tile.type = TileType.Ugabuga;

			if (tile.population > 5)
			{
				tile.population -= 1;
				tile.canPopulate = false;
				return false;
			}

			return true;
		}

		var neighbourBuffer:Vector.<Tile> = new Vector.<Tile>;
		private function getNeighbours(x:Number, y:Number):Vector.<Tile>
		{
			neighbourBuffer.clear();

			if (x - 1 >= 0 && y - 1 >= 0)
				neighbourBuffer.push(isometric.getTile(x - 1, y - 1));
			if (x - 1 >= 0)
				neighbourBuffer.push(isometric.getTile(x - 1, y));
			if (x - 1 >= 0 && y + 1 < Const.NUM_TILES)
				neighbourBuffer.push(isometric.getTile(x - 1, y + 1));
			if (y + 1 < Const.NUM_TILES)
				neighbourBuffer.push(isometric.getTile(x, y + 1));
			if (y - 1 >= 0)
				neighbourBuffer.push(isometric.getTile(x, y - 1));
			if (x + 1 < Const.NUM_TILES && y - 1 <= 0)
				neighbourBuffer.push(isometric.getTile(x + 1, y - 1));
			if (x + 1 < Const.NUM_TILES)
				neighbourBuffer.push(isometric.getTile(x + 1, y));
			if (x + 1 < Const.NUM_TILES && y + 1 < Const.NUM_TILES)
				neighbourBuffer.push(isometric.getTile(x + 1, y + 1));

			return neighbourBuffer;
		}

		public function get currentPopulation():Number
		{
			var totalPopulation = 0;

			for (var i = 0; i < Const.NUM_TILES; i++)
			{
				for (var j = 0; j < Const.NUM_TILES; j++)
				{
					totalPopulation += isometric.getTile(i, j).population;
				}
			}

			return totalPopulation;
		}
	}
}