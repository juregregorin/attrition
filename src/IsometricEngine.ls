	package
	{
		import loom2d.display.DisplayObjectContainer;
		import loom2d.textures.Texture;
		import TileType;

		public class IsometricEngine extends DisplayObjectContainer
		{
			private var tiles:Vector.<Vector.<Tile>>;
			private var bottomTiles:Vector.<Tile>;

			public function IsometricEngine()
			{

				tiles = new Vector.<Vector.<Tile>>;
				var pn = new PerlinNoise(Const.NUM_TILES, Const.NUM_TILES);

				var startX:Number = Const.SCREEN_WIDTH / 2 - Tile.VIRTUAL_WIDTH / 2;
				var startY:Number = 100;

				for (var i = 0; i < Const.NUM_TILES; i++)
				{
					tiles.push(new Vector.<Tile>);

					for (var j = 0; j < Const.NUM_TILES; j++)
					{
						var t:Tile = new Tile;

						t.water = pn.GetRandomHeight(i, j, 1, 0.33, 0.5, 0.5, 0.5);
						t.x = startX + (i * Tile.VIRTUAL_WIDTH / 2) + (j * -Tile.VIRTUAL_WIDTH / 2 );
						t.y = startY + (i * Tile.VIRTUAL_HEIGHT / 2) + (j * Tile.VIRTUAL_HEIGHT / 2);

						addChild(t);

						tiles[i].push(t);
					}
				}

				getTile(Math.round(Const.NUM_TILES / 2), Math.round(Const.NUM_TILES / 2)).type = TileType.Ugabuga;
				getTile(Math.round(Const.NUM_TILES / 2), Math.round(Const.NUM_TILES / 2)).population = 10;

				bottomTiles = new Vector.<Tile>;

				for (i = 0; i < Const.NUM_TILES; i++)
				{
					t = new Tile;
					t.x = startX + (i * Tile.VIRTUAL_WIDTH / 2) + ((Const.NUM_TILES - 1) * -Tile.VIRTUAL_WIDTH / 2 );
					t.y = startY + (i * Tile.VIRTUAL_HEIGHT / 2) + ((Const.NUM_TILES - 1) * Tile.VIRTUAL_HEIGHT / 2) + 46;
					t.type = TileType.Bottom;
					t.flip = true;

					addChild(t);

					bottomTiles.push(t);
				}

				for (i = 0; i < Const.NUM_TILES; i++)
				{
					t = new Tile;
					t.x = startX + ((Const.NUM_TILES - 1) * Tile.VIRTUAL_WIDTH / 2) + (i * -Tile.VIRTUAL_WIDTH / 2 );
					t.y = startY + ((Const.NUM_TILES - 1) * Tile.VIRTUAL_HEIGHT / 2) + (i * Tile.VIRTUAL_HEIGHT / 2) + 46;
					t.type = TileType.Bottom;

					addChild(t);

					bottomTiles.push(t);
				}
			}

			public function getTile(x:Number, y:Number):Tile
			{
				if (x < 0 ||
					x >= Const.NUM_TILES ||
					y < 0 ||
					y >= Const.NUM_TILES)
				{
					Debug.assert(0, "Tile out of bounds");
				}

				return tiles[x][y];
			}
		}

	}