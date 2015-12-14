package
{
	import loom.sound.SimpleAudioEngine;
	import loom.sound.Sound;
	import TileType;

	public enum SoundType
	{
		Build,
		Death
	}

	public class Simulation
	{
		private var elapsedTime:Number;
		private const SIMULATION_TICK_TIME = 1;

		private var foodStatus:Number = 10;
		private var foodBalance:Number = 0;
		private var turnsStarving = 0;
		private var lastFoodRatio = 1;

		private var audio:SimpleAudioEngine;
		private var currentSound:Sound;
		private var timeSinceLastSound:Number = 0;
		private var lastSoundType:SoundType;

		private function playEffect(path:String, type:SoundType):void
		{
			if ((currentSound == null || !currentSound.isPlaying()) &&
				(lastSoundType == null || (lastSoundType == type && timeSinceLastSound > 10) || lastSoundType != type))
			{
				var id = audio.playEffect(path, false);
				currentSound = audio.getSoundById(id);
				timeSinceLastSound = 0;
				lastSoundType = type;
			}
		}

		public function Simulation()
		{
			elapsedTime = 0;
			audio = SimpleAudioEngine.sharedEngine();
		}

		public function tick(dt:Number):void
		{
			elapsedTime += dt;
			timeSinceLastSound += dt;
			if (elapsedTime >= SIMULATION_TICK_TIME)
			{
				elapsedTime -= SIMULATION_TICK_TIME;
				simulationTick();
			}
		}

		public function simulationTick():void
		{
			if (currentPopulation == 0)
			{
				Environment.instance().gameOver = true;
				return;
			}

			foodBalance = 0;
			var settlements = 0;
			for (var i = 0; i < Const.NUM_TILES; i++)
			{
				for (var j = 0; j < Const.NUM_TILES; j++)
				{
					var t = Environment.instance().iso.getTile(i, j);

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
								if ((1 - Math.log(Math.log(t.population))) / 3 <= tt.water)
								{
									if (Math.randomRange(0, 1) <= 0.01 * lastFoodRatio)
									{
										tt.population = 1;
										settlements++;

										playEffect("assets/sounds/build.ogg", SoundType.Build);
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

			for (i = 0; i < Const.NUM_TILES; i++)
			{
				for (j = 0; j < Const.NUM_TILES; j++)
				{
					t = Environment.instance().iso.getTile(i, j);
					t.update();
				}
			}

			if (foodBalance <= 0)
				foodStatus -= 1;
			else
				foodStatus += 1;

			if (foodStatus < 0 && currentPopulation > 0)
			{
				turnsStarving++;
				turnsStarving = Math.clamp(turnsStarving, 0, 10);
				settlements -= starve(turnsStarving);
				playEffect(Math.randomRangeInt(0, 1) ? "assets/sounds/death1.ogg" : "assets/sounds/death2.ogg", SoundType.Death);
				foodStatus = 0;
			}
			else
			{
				turnsStarving = 0;
			}

			var maxFood = 10 + settlements;

			foodStatus = Math.clamp(foodStatus, 0, maxFood);
			lastFoodRatio = foodStatus / maxFood;
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
				//trace("killing in tile with food production " + tiles[i].foodProduction);
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
					var t = Environment.instance().iso.getTile(i, j);
					if (t.population > 0)
					{
						tileBuffer.push(t);
					}
				}
			}

			return tileBuffer;
		}

		public function getNeighbours(x:Number, y:Number):Vector.<Tile>
		{
			tileBuffer.clear();

			var isometric = Environment.instance().iso;

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
					var ii = Environment.instance().iso;
					var t = ii.getTile(i, j);
					totalPopulation += t != null ? t.population : 0;
				}
			}

			return totalPopulation;
		}

		public function get currentFood():Number
		{
			return foodStatus;
		}

		public function get foodTrend():Number
		{
			return foodBalance;
		}
	}
}