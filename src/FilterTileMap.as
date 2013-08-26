package 
{
	import org.flixel.FlxTilemap;
	
	/**
	 * ...
	 * @author bignobody
	 */
	public class FilterTileMap extends FlxTilemap 
	{
		//Static filters, so we use the same filters for every FilterTileMap
		// Alternatively, you could make a static Filters class that held a bunch of filter instances and use them everywhere...
		public static var FILTERS:Array;
		public static var FILTERPOINTS:Array;
		// Some named indexes to make this a little more human friendly
		public static var FILTER_COLOR:int = 0;
		public static var FILTER_GLOW:int = 1;
		public static var FILTER_BLUR:int = 2;
		public static var FILTER_BEVEL:int = 3;
		
		// active filters for this tilemap
		protected var activeFilters:Array;
		protected var activeFilterPoints:Array;
		
		public function FilterTileMap()
		{
			if (FilterTileMap.FILTERS == null)
			{
				FilterTileMap.initializeFilters();
			}
			super();
			resetFilters();
		}
		
		public static function initializeFilters():void
		{
			FILTERS = new Array();
			FILTERPOINTS = new Array();

			// For the colour filter, I'm just turning the brightness down 50%, but you can do lots of crazy cool stuff with this filter.
			var bright:Number = 0.5;
			var matrix:Array = new Array();
			matrix = matrix.concat([bright, 0, 0, 0, 0]); // red
			matrix = matrix.concat([0, bright, 0, 0, 0]); // green
			matrix = matrix.concat([0, 0, bright, 0, 0]); // blue
			matrix = matrix.concat([0, 0, 0, 1, 0]); // alpha

			FILTERS[FILTER_COLOR] = new ColorMatrixFilter(matrix);
			FILTERPOINTS[FILTER_COLOR] = new Point( 0, 0);
			
			// make the rest of our filters
			FILTERS[FILTER_GLOW] = new GlowFilter(0xffffff, 1.0, 16, 16, 2, 1, false, false);
			FILTERPOINTS[FILTER_GLOW] = new Point( -8, -8);
			FILTERS[FILTER_BLUR] = new BlurFilter(4, 4, 1);
			FILTERPOINTS[FILTER_BLUR] = new Point( -2, -2);
			FILTERS[FILTER_BEVEL] = new BevelFilter(4, 45, 0xffffff, 1, 0, 0.75, 4, 4, 1, 1, "inner", false);
			FILTERPOINTS[FILTER_BEVEL] = new Point( 0, 0);
			
		}
		
		public function resetFilters():void
		{
			// dump any references to existing filters
			activeFilters = new Array();
			activeFilterPoints = new Array();
		}
		
		public function activateFilter(filterType:int):void
		{
			if (filterType > -1 && filterType < FilterTileMap.FILTERS.length)
			{
				// add the requested filter to this sprites active filters
				activeFilters[activeFilters.length] = FilterTileMap.FILTERS[filterType];
				activeFilterPoints[activeFilterPoints.length] = FilterTileMap.FILTERPOINTS[filterType];
			}
		}
		
		// Here's the Flixel integration! 
		// drawTileMap stamps the visible section of the tilemap to the buffer, so we want to apply our filters right after that happens.
		override protected function drawTilemap(Buffer:FlxTilemapBuffer, Camera:FlxCamera):void
		{

			super.drawTilemap(Buffer, Camera);
			
			applyActiveFilters();
		}
		
		protected function applyActiveFilters():void
		{
			// _buffers is an internal array of FlxTilemapBuffer objects, which has the pixels we're filtering
			for (var i:int = 0; i < _buffers.length; i ++)
			{
				if (_buffers[i] != null)
				{
					for (var f:int = 0; f < activeFilters.length; f ++)
					{
						_buffers[i].pixels.applyFilter(_buffers[i].pixels, _buffers[i].pixels.generateFilterRect(_buffers[i].pixels.rect, activeFilters[f]), activeFilterPoints[f], activeFilters[f]);
					}
				}
			}
		}
	}
	
}