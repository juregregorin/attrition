package
{
	import loom2d.display.Image;
	import loom2d.textures.Texture;

	public enum TileType
	{
		Desert,
		Arid,
		Temperate,
		Forest,
		Ugabuga,
		Bottom,
	}

	public class TileTextures
	{
		private static var textureMap:Dictionary.<TileType, Vector.<Texture>>;

		public static function init()
		{
			textureMap = new Dictionary.<TileType, Vector.<Texture>>;
			textureMap[TileType.Bottom] = new Vector.<Texture>;
			textureMap[TileType.Bottom].push(Texture.fromAsset("assets/tiles/bottom1.png"));
			textureMap[TileType.Bottom].push(Texture.fromAsset("assets/tiles/bottom2.png"));
			textureMap[TileType.Bottom].push(Texture.fromAsset("assets/tiles/bottom3.png"));
			textureMap[TileType.Desert] = new Vector.<Texture>;
			textureMap[TileType.Desert].push(Texture.fromAsset("assets/tiles/desert1.png"));
			textureMap[TileType.Desert].push(Texture.fromAsset("assets/tiles/desert2.png"));
			textureMap[TileType.Desert].push(Texture.fromAsset("assets/tiles/desert3.png"));
			textureMap[TileType.Arid] = new Vector.<Texture>;
			textureMap[TileType.Arid].push(Texture.fromAsset("assets/tiles/arid1.png"));
			textureMap[TileType.Arid].push(Texture.fromAsset("assets/tiles/arid2.png"));
			textureMap[TileType.Arid].push(Texture.fromAsset("assets/tiles/arid2.png"));
			textureMap[TileType.Temperate] = new Vector.<Texture>;
			textureMap[TileType.Temperate].push(Texture.fromAsset("assets/tiles/temperate1.png"));
			textureMap[TileType.Temperate].push(Texture.fromAsset("assets/tiles/temperate2.png"));
			textureMap[TileType.Temperate].push(Texture.fromAsset("assets/tiles/temperate3.png"));
			textureMap[TileType.Temperate].push(Texture.fromAsset("assets/tiles/temperate4.png"));
			textureMap[TileType.Forest] = new Vector.<Texture>;
			textureMap[TileType.Forest].push(Texture.fromAsset("assets/tiles/forest1.png"));
			textureMap[TileType.Forest].push(Texture.fromAsset("assets/tiles/forest2.png"));
			textureMap[TileType.Forest].push(Texture.fromAsset("assets/tiles/forest3.png"));
			textureMap[TileType.Ugabuga] = new Vector.<Texture>;
			textureMap[TileType.Ugabuga].push(Texture.fromAsset("assets/tiles/settlement1.png"));
			textureMap[TileType.Ugabuga].push(Texture.fromAsset("assets/tiles/settlement2.png"));
			textureMap[TileType.Ugabuga].push(Texture.fromAsset("assets/tiles/settlement3.png"));
			textureMap[TileType.Ugabuga].push(Texture.fromAsset("assets/tiles/settlement4.png"));
		}

		public static function getTexture(type:TileType, variant:Number):Texture
		{
			if (textureMap == null)
			{
				init();
			}

			var typeMap:Vector.<Texture> = textureMap[type];

			return typeMap[variant % typeMap.length];
		}
	}

	public class Tile extends Image
	{
		public static const VIRTUAL_WIDTH = 50;
		public static const VIRTUAL_HEIGHT = 22;

		private var _population:Number;
		private var _water:Number;

		private var _type:TileType;
		private var _variant:Number;

		public function Tile()
		{
			_population = 0;
			_variant = Math.randomRangeInt(0, 100);
		}

		public function get population():Number
		{
			return _population;
		}

		public function set population(p:Number):void
		{
			_population = p;
		}

		public function get water():Number
		{
			return _water;
		}

		public function set water(value:Number)
		{
			_water = value;

			if (population > 0)
				return;

			if (_water < 0.25)
			{
				type = TileType.Desert;
			}
			else if (_water < 0.5)
			{
				type = TileType.Arid;
			}
			else if (_water < 0.75)
			{
				type = TileType.Temperate;
			}
			else
			{
				type = TileType.Forest;
			}
		}

		public function removePopulated()
		{
			water = _water;
		}

		public function set type(t:TileType):void
		{
			_type = t;
			updateTexture();
		}

		public function get type():TileType
		{
			return _type;
		}

		public function updateTexture()
		{
			texture = TileTextures.getTexture(_type, _variant);
		}

		public function set flip(value:Boolean)
		{
			scaleX = -1;
			x += texture.width;
		}

		public function get foodConsumption():Number
		{
			return Math.log(1 + _population * 0.3);
		}

		public function get foodProduction():Number
		{
			return Math.log(1 + _population * 0.4 * water);
		}
	}
}