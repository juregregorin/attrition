package
{
	import loom2d.display.Image;
	import loom2d.textures.Texture;

	public class Tile extends Image
	{
		public static const WIDTH = 64;
		public static const HEIGHT = 64;
		public static const VIRTUAL_WIDTH = 32;
		public static const VIRTUAL_HEIGHT = 20;

		public function Tile()
		{
			width = WIDTH;
			height = HEIGHT;
		}
	}
}