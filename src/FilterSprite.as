package 
{
	import flash.filters.BevelFilter;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author bignobody
	 */
	public class FilterSprite extends FlxSprite
	{
		//Static filters, so we use the same filters for every FilterSprite
		public static var FILTERS:Array;
		public static var FILTERPOINTS:Array;
		// Some named indexes to make this a little more human friendly
		public static var FILTER_COLOR:int = 0;
		public static var FILTER_GLOW:int = 1;
		public static var FILTER_BLUR:int = 2;
		public static var FILTER_BEVEL:int = 3;
		
		// the filters currently affecting this sprite.
		protected var activeFilters:Array;
		protected var activeFilterPoints:Array;
		
		
		public function FilterSprite(x:int=0, y:int=0)
		{
			if (FilterSprite.FILTERS == null)
			{
				// if the filters don't exist yet, make 'em!
				FilterSprite.initializeFilters();
			}
			
			// initialize the arrays
			resetFilters();
			
			super(x,y);
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
			if (filterType > -1 && filterType < FilterSprite.FILTERS.length)
			{
				// add the requested filter to this sprites active filters
				activeFilters[activeFilters.length] = FilterSprite.FILTERS[filterType];
				activeFilterPoints[activeFilterPoints.length] = FilterSprite.FILTERPOINTS[filterType];
			}
		}
		
		// here's the Flixel integration!
		// framePixels is the Bitmapdata that we can apply flash filters to.
		// framePixels gets updated whenever the FlxSprite changes frames, so it seems like the best time to apply our filters
		override protected function calcFrame():void
		{
			super.calcFrame();
			if (activeFilters.length > 0)
			{
				// loop through all filters active on this sprite and apply them to the frame.
				for (var i:int = 0; i < activeFilters.length; i ++)
				{
					if (framePixels != null)
					{
						// Apparently this is the inefficient way (internal copying), but if you want to add a seperate bitmap and handle it yourself, be my guest :D
						framePixels.applyFilter( framePixels, framePixels.generateFilterRect(framePixels.rect, activeFilters[i]), activeFilterPoints[i], activeFilters[i]);
					}
				}
			}
		}
		
	}
	
}