package ui
{
	import loom2d.display.Image;
	import loom2d.textures.Texture;

	public class ImageCard extends Image
	{
		private var _depth:int = 0;

		public function ImageCard(_texture:Texture)
		{
			super(_texture);
		}

		public static function zSort(a:ImageCard, b:ImageCard):int
		{
			return a.getDepth() > b.getDepth() ? -1 : a.getDepth() < b.getDepth() ? 1 : 0;
		}

		public function getDepth():int
		{
			return _depth;
		}

		public function setDepth(d:int)
		{
			_depth = d;
		}
	}

}