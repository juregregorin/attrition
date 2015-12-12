package
{
	import loom2d.display.Image;
	import loom2d.textures.Texture;

	public class Tile extends Image
	{
		public static const WIDTH = 50;
		public static const HEIGHT = 58;
		public static const VIRTUAL_WIDTH = 22;
		public static const VIRTUAL_HEIGHT = 10;

		public function Tile()
		{
			width = WIDTH;
			height = HEIGHT;
		}
	}
}