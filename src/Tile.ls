package
{
	import system.Boolean;
	import loom2d.math.Point;
	import loom2d.display.DisplayObject;
	import loom2d.display.DisplayObjectContainer;
	import loom2d.display.Image;
	import loom2d.textures.Texture;
	import loom2d.events.Touch;
	import loom2d.events.TouchEvent;
	import loom2d.events.TouchPhase;

	public enum TileType
	{
		Desert,
		Arid,
		Temperate,
		Forest,
		Settlement,
		Bottom,
	}

	public class TileTextures
	{
		private static var textureMap:Dictionary.<TileType, Vector.<Texture>>;
		private static var topTextureMap:Dictionary.<TileType, Vector.<Texture>>;

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
			textureMap[TileType.Forest] = new Vector.<Texture>;
			textureMap[TileType.Forest].push(Texture.fromAsset("assets/tiles/forest1.png"));
			textureMap[TileType.Forest].push(Texture.fromAsset("assets/tiles/forest2.png"));
			textureMap[TileType.Forest].push(Texture.fromAsset("assets/tiles/forest3.png"));

			topTextureMap = new Dictionary.<TileType, Vector.<Texture>>;
			topTextureMap[TileType.Settlement] = new Vector.<Texture>;
			topTextureMap[TileType.Settlement].push(Texture.fromAsset("assets/tiles/settlement1.png"));
			topTextureMap[TileType.Settlement].push(Texture.fromAsset("assets/tiles/settlement2.png"));
			topTextureMap[TileType.Settlement].push(Texture.fromAsset("assets/tiles/settlement3.png"));
			topTextureMap[TileType.Settlement].push(Texture.fromAsset("assets/tiles/settlement4.png"));
			topTextureMap[TileType.Settlement].push(Texture.fromAsset("assets/tiles/settlement5.png"));
			topTextureMap[TileType.Desert] = new Vector.<Texture>;
			topTextureMap[TileType.Desert].push(Texture.fromAsset("assets/tiles/empty.png"));
			topTextureMap[TileType.Arid] = new Vector.<Texture>;
			topTextureMap[TileType.Arid].push(Texture.fromAsset("assets/tiles/empty.png"));
			topTextureMap[TileType.Temperate] = new Vector.<Texture>;
			topTextureMap[TileType.Temperate].push(Texture.fromAsset("assets/tiles/empty.png"));
			topTextureMap[TileType.Temperate].push(Texture.fromAsset("assets/tiles/empty.png"));
			topTextureMap[TileType.Temperate].push(Texture.fromAsset("assets/tiles/temperate3.png"));
			topTextureMap[TileType.Temperate].push(Texture.fromAsset("assets/tiles/temperate4.png"));
			topTextureMap[TileType.Forest] = new Vector.<Texture>;
			topTextureMap[TileType.Forest].push(Texture.fromAsset("assets/tiles/forest1.png"));
			topTextureMap[TileType.Forest].push(Texture.fromAsset("assets/tiles/forest2.png"));
			topTextureMap[TileType.Forest].push(Texture.fromAsset("assets/tiles/forest3.png"));
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

		public static function getTopTexture(type:TileType, variant:Number, populationVariant:Number):Texture
		{
			if (topTextureMap == null)
			{
				init();
			}

			var typeMap:Vector.<Texture> = topTextureMap[type];

			var v = populationVariant;
			if (v == -1)
				v = variant;

			return typeMap[v % typeMap.length];
		}
	}

	public class TileImage extends Image
	{
		private var tile:Tile;
		private var ignoretouch:Boolean;
		public function TileImage(parent:Tile)
		{
			tile = parent;
			addEventListener(TouchEvent.TOUCH, touchEvent);
		}

		static var __top = new Point();
		static var __bottom = new Point();
		static var __left = new Point();
		static var __right = new Point();

		static var __points:Vector.<Point> = null;

		override public function hitTest(localPoint:Point, forTouch:Boolean):DisplayObject
		{
			// lol, hack
			// don't know why
			localPoint.y -= height - Tile.VIRTUAL_HEIGHT;

			if (__points == null)
			{
				__points = new Vector.<Point>;
				__points.push(__top);
				__points.push(__left);
				__points.push(__bottom);
				__points.push(__right);
			}

			__top.x = width / 2;
			__top.y = height + Tile.VIRTUAL_HEIGHT;
			__bottom.x = width / 2;
			__bottom.y = height;
			__left.x = 0;
			__left.y = height + Tile.VIRTUAL_HEIGHT / 2;
			__right.x = Tile.VIRTUAL_WIDTH;
			__right.y = height + Tile.VIRTUAL_HEIGHT / 2;

			var i = 0;
			var j = __points.length - 1;
			var result:Boolean = false;

			for (i = 0; i < __points.length; j = i++)
			{
				if ((__points[i].y > localPoint.y) != (__points[j].y > localPoint.y) &&
					(localPoint.x < (__points[j].x - __points[i].x) * (localPoint.y - __points[i].y) / (__points[j].y - __points[i].y) + __points[i].x))
					{
						result = !result;
					}
			}

			if (result)
			{
				return this;
			}

			return super.hitTest(localPoint, forTouch);
		}

		private function touchEvent(e:TouchEvent)
		{
			if (!touchable)
				return;

			var touch = e.getTouch(this, TouchPhase.ENDED);
			if (touch)
			{
				Environment.instance().tileSelected(tile);
			}
		}
	}

	public class Tile
	{
		public static const VIRTUAL_WIDTH = 50;
		public static const VIRTUAL_HEIGHT = 22;

		private var _population:Number;
		private var _water:Number;

		private var _type:TileType;
		private var _variant:Number;

		private var _base:TileImage;
		private var _top:Image;

		public function Tile(topLayer:DisplayObjectContainer, baseLayer:DisplayObjectContainer)
		{
			_population = 0;
			_variant = Math.randomRangeInt(0, 1000);

			_base = new TileImage(this);
			baseLayer.addChild(_base);

			_top = new Image();
			_top.touchable = false;
			topLayer.addChild(_top);
		}

		public function get population():Number
		{
			return _population;
		}

		public function update()
		{
			updateTexture();
			updateTopTexture();
		}

		public function set population(p:Number):void
		{
			_population = p;

			updateTopTexture();
		}

		public function get water():Number
		{
			return _water;
		}

		public function set water(value:Number)
		{
			_water = value;
			if (water < 0)
				water = 0;

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

			if (t == TileType.Bottom)
			{
				_top.visible = false;
				_top.touchable = false;
				_base.touchable = false;
			}

			updateTexture();
		}

		public function get type():TileType
		{
			return _type;
		}

		public function updateTexture()
		{
			_base.texture = TileTextures.getTexture(_type, _variant);
		}

		public function updateTopTexture()
		{
			if (_population == 0)
			{
				_top.texture = TileTextures.getTopTexture(_type, _variant, -1);
			}
			else
			{
				var pv:Number;
				if (population <= 2)
				{
					pv = 0;
				}
				else if (population <= 5)
				{
					pv = 1;
				}
				else if (population <= 10)
				{
					pv = 2;
				}
				else if (population <= 15)
				{
					pv = 3;
				}
				else
				{
					pv = 4;
				}

				_top.texture = TileTextures.getTopTexture(TileType.Settlement, _variant, pv);
			}

		}

		public function set flip(value:Boolean)
		{
			if (value)
			{
				_base.scaleX = -1;
				_top.scaleX = -1;
			}
			else
			{
				_base.scaleX = 1;
				_top.scaleX = 1;
			}
			x += _base.texture.width;
		}

		public function get foodConsumption():Number
		{
			return Math.log(1 + _population * 0.25);
		}

		public function get foodProduction():Number
		{
			return Math.log(1 + _population * 0.4 * water);
		}

		public function set x(value:Number)
		{
			_top.x = value;
			_base.x = value;
		}

		public function get x():Number
		{
			return _base.x;
		}

		public function set y(value:Number)
		{
			_top.y = value;
			_base.y = value;
		}

		public function get y():Number
		{
			return _base.y;
		}
	}
}