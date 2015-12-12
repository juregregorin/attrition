package
{
	import loom2d.display.Image;
	import loom2d.textures.Texture;

	public enum TileType
	{
		Desert,
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
			textureMap[TileType.Bottom].push(Texture.fromAsset("assets/tiles/drought_bottom_D1.png"));
			textureMap[TileType.Bottom].push(Texture.fromAsset("assets/tiles/drought_bottom_D2.png"));
			textureMap[TileType.Bottom].push(Texture.fromAsset("assets/tiles/drought_bottom_D3.png"));
			textureMap[TileType.Desert] = new Vector.<Texture>;
			textureMap[TileType.Desert].push(Texture.fromAsset("assets/tiles/drought_tile1.png"));
			textureMap[TileType.Desert].push(Texture.fromAsset("assets/tiles/drought_tile2.png"));
			textureMap[TileType.Desert].push(Texture.fromAsset("assets/tiles/drought_tile1.png"));
			textureMap[TileType.Forest] = new Vector.<Texture>;
			textureMap[TileType.Forest].push(Texture.fromAsset("assets/tiles/forest_tile1.png"));
			textureMap[TileType.Forest].push(Texture.fromAsset("assets/tiles/forest_tile2.png"));
			textureMap[TileType.Forest].push(Texture.fromAsset("assets/tiles/forest_tile3.png"));
			textureMap[TileType.Ugabuga] = new Vector.<Texture>;
			textureMap[TileType.Ugabuga].push(Texture.fromAsset("assets/tiles/ugabuga_tile1.png"));
			textureMap[TileType.Ugabuga].push(Texture.fromAsset("assets/tiles/ugabuga_tile2.png"));
			textureMap[TileType.Ugabuga].push(Texture.fromAsset("assets/tiles/ugabuga_tile3.png"));
			textureMap[TileType.Ugabuga].push(Texture.fromAsset("assets/tiles/ugabuga_tile4.png"));
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
		private var _type:TileType;
		private var _variant:Number;
		private var _canPopulate:Boolean;

		public function Tile()
		{
			_population = 0;
			_canPopulate = true;
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

		public function get canPopulate():Boolean
		{
			return _canPopulate;
		}

		public function set canPopulate(value:Boolean):void
		{
			_canPopulate = value;
		}
	}
}