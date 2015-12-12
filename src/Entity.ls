package
{
	import loom2d.math.Point;

	public class Entity
	{
		public var children:Vector.<Entity>;

		/* Position */
		protected var p:Point;

		public static var environment:Environment = null;

		protected var members:Vector.<Entity>;

		public var rotation:Number = 0;

		public function Entity() {}

		public function setPosition(x:Number, y:Number)
		{
			p.x = x;
			p.y = y;
		}

		public function addMember(e:Entity)
		{
			if (members == null)
				members = new Vector.<Entity>();

			members.push(e);
		}

		public function getPosition():Point
		{
			return p;
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

		}
	}

}