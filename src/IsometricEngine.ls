package 
{
	import loom2d.display.DisplayObjectContainer;
	import loom2d.textures.Texture;
	
	/**
	 * ...
	 * @author Jure Gregorin
	 */
	public class IsometricEngine extends DisplayObjectContainer
	{
		private var tiles:Vector.<Vector.<Tile>>;
		
		public function IsometricEngine() 
		{
			
			tiles = new Vector.<Vector.<Tile>>;
			
			var startX:Number = Const.SCREEN_WIDTH / 2 - Tile.VIRTUAL_WIDTH / 2;
			var startY:Number = Const.SCREEN_HEIGHT - Tile.HEIGHT - Tile.VIRTUAL_HEIGHT;
			
			for (var i = 0; i < 32; i++)
			{
				tiles.push(new Vector.<Tile>);
				
				for (var j = 0; j < 32; j++)
				{
					var t:Tile = new Tile;
					t.texture = ((i + j) % 2) ? Texture.fromAsset("assets/tiles/test1.png") : Texture.fromAsset("assets/tiles/test2.png");
					t.x = startX + (i * Tile.VIRTUAL_WIDTH / 2) + (j * -Tile.VIRTUAL_WIDTH / 2 );
					t.y = startY - (i * Tile.VIRTUAL_HEIGHT / 2) - (j * Tile.VIRTUAL_HEIGHT / 2);
					addChild(t);
					
					tiles[i].push(t);
				}
			}
		}
		
	}
	
}