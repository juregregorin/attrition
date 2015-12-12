package
{
	import loom2d.math.Point;

	/**
	 * ...
	 * @author Tadej
	 */
	public class Entity
	{
		public var children:Vector.<Entity>;

		/* Position */
		protected var p:Point;

		public static var environment:Environment = null;

		public function Entity() {}

		public function setPosition(x:Number, y:Number)
		{
			p.x = x;
			p.y = y;
		}

		public function getPosition():Point
		{
			return p;
		}
	}

}