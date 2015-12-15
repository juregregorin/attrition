package
{
	import loom2d.math.Point;

	public class Entity
	{
		public static var STATE_IDLE:String = "idle";
		public static var STATE_DESTROYED:String = "destroyed";

		protected var state:String = STATE_IDLE;

		public var children:Vector.<Entity>;

		/* Position */
		public var x:Number = 0;
		public var y:Number = 0;

		public static var environment:Environment = null;

		protected var members:Vector.<Entity>;

		public var rotation:Number = 0;
		protected var _alpha:Number = 1;

		public function Entity() {}

		public function setPosition(x:Number, y:Number)
		{
			this.x = x;
			this.y = y;
		}

		public function addMember(e:Entity)
		{
			if (members == null)
				members = new Vector.<Entity>();

			members.push(e);
		}

		public function getPosition():Point
		{
			return new Point(x, y);
		}

		public function tick(dt:Number)
		{
			for (var i = 0; members != null && i < members.length; i++)
			{
				var member:Entity = members[i];
				member.tick(dt);
			}
		}

		public function render()
		{
			for (var i = 0; members != null && i < members.length; i++)
			{
				var member:Entity = members[i];
				member.render();
				trace("!");
			}
		}

		public function destroy()
		{
			state = STATE_DESTROYED;
		}

		public function getState():String
		{
			return state;
		}

		public function get alpha():Number
		{
			return alpha;
		}

		public function set alpha(a:Number)
		{
			_alpha = a < 0 ? 0 : a > 1 ? 1 : a;
		}
	}

}