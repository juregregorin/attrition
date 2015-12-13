package
{
	import TileType;

	public class Simulation
	{
		private var elapsedTime:Number;
		private const SIMULATION_TICK_TIME = 1;

		private var isometric:IsometricEngine;

		private var foodStatus:Number = 10;
		private var turnsStarving = 0;
		private var lastFoodRatio = 1;

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
			}
		}

		public function simulationTick():void
		{
			var foodBalance = 0;
			var settlements = 0;
			for (var i = 0; i < Const.NUM_TILES; i++)
			{
				for (var j = 0; j < Const.NUM_TILES; j++)
				{
					var t = isometric.getTile(i, j);

					// Grow the tile population if possible
					if (t.population > 0)
					{
						settlements++;
						// If odds be, increase local population
						if (Math.randomRange(0, 1) <= Math.pow(t.population, -0.75) * lastFoodRatio && t.foodProduction - t.foodConsumption >= 0)
						{
							t.population += 1;
						}

						// Test the odds of creating a neighbouring tile
						var neighbours:Vector.<Tile> = getNeighbours(i, j);
						neighbours.shuffle();
						for each(var tt:Tile in neighbours)
						{
							if (tt.population == 0)
							{
								if ((1 - Math.pow(t.population, -0.5)) <= tt.water)
								{
									if (Math.randomRange(0, 1) <= 0.01 * lastFoodRatio)
									{
										tt.population = 1;
										settlements++;
									}
								}
							}

							tt.water -= tt.population * 0.00005;
						}

						// Update stats
						foodBalance += t.foodProduction;
						foodBalance -= t.foodConsumption;
					}

				}
			}

			if (foodBalance <= 0)
				foodStatus -= 1;
			else
				foodStatus += 1;

			if (foodStatus < 0)
			{
				turnsStarving++;
				turnsStarving = Math.clamp(turnsStarving, 0, 10);
				settlements -= starve(turnsStarving);
				foodStatus = 0;
			}
			else
			{
				turnsStarving = 0;
			}

			var maxFood = 10 + settlements;

			foodStatus = Math.clamp(foodStatus, 0, maxFood);
			lastFoodRatio = foodStatus / maxFood;

			trace("balance: " + foodBalance);
			trace("food: " + foodStatus);
		}

		private function sortFoodProduction(a:Tile, b:Tile):Number
		{
			return (a.foodProduction - a.foodConsumption > b.foodProduction - b.foodConsumption) ? 1 : -1;
		}

		private function starve(num:Number):Number
		{
			var result = 0;
			var tiles = getPopulatedTiles();
			tiles.sort(sortFoodProduction);
			for (var i = 0; i < num; i++)
			{
				if (i >= tiles.length)
					break;

				tiles[i].population -= 1;
				if (tiles[i].population <= 0)
				{
					tiles[i].removePopulated();
					result++;
				}
				trace("killing in tile with food production " + tiles[i].foodProduction);
			}

			return result;
		}

		var tileBuffer:Vector.<Tile> = new Vector.<Tile>;

		private function getPopulatedTiles():Vector.<Tile>
		{
			tileBuffer.clear();
			for (var i = 0; i < Const.NUM_TILES; i++)
			{
				for (var j = 0; j < Const.NUM_TILES; j++)
				{
					var t = isometric.getTile(i, j);
					if (t.population > 0)
					{
						tileBuffer.push(t);
					}
				}
			}

			return tileBuffer;
		}

		private function getNeighbours(x:Number, y:Number):Vector.<Tile>
		{
			tileBuffer.clear();

			if (x - 1 >= 0 && y - 1 >= 0)
				tileBuffer.push(isometric.getTile(x - 1, y - 1));
			if (x - 1 >= 0)
				tileBuffer.push(isometric.getTile(x - 1, y));
			if (x - 1 >= 0 && y + 1 < Const.NUM_TILES)
				tileBuffer.push(isometric.getTile(x - 1, y + 1));
			if (y + 1 < Const.NUM_TILES)
				tileBuffer.push(isometric.getTile(x, y + 1));
			if (y - 1 >= 0)
				tileBuffer.push(isometric.getTile(x, y - 1));
			if (x + 1 < Const.NUM_TILES && y - 1 >= 0)
				tileBuffer.push(isometric.getTile(x + 1, y - 1));
			if (x + 1 < Const.NUM_TILES)
				tileBuffer.push(isometric.getTile(x + 1, y));
			if (x + 1 < Const.NUM_TILES && y + 1 < Const.NUM_TILES)
				tileBuffer.push(isometric.getTile(x + 1, y + 1));

			return tileBuffer;
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