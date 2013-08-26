package  
{
	import org.flixel.FlxPoint;
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxU;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Sam Tregillus
	 */
	public class CC 
	{
		public static var WINDOWWIDTH : Number = 800; //actual size of window
		public static var WINDOWHEIGHT : Number = 600;
		public static var WINDOWSCALE : Number = 1; //scale of window
		public static var VISIBLEWIDTH : Number = WINDOWWIDTH / WINDOWSCALE;
		public static var VISIBLEHEIGHT : Number = WINDOWHEIGHT / WINDOWSCALE;
		
		public static var RED : uint = 0xff0000;
		public static var GREEN : uint = 0x00ff00;
		public static var BLUE : uint = 0x0000ff;
		public static var WHITE : uint = 0xffffff;
		public static var BLACK : uint = 0x000000;
		
		public static var PURPLE : uint = RED + BLUE;
		public static var TEAL : uint = GREEN + BLUE;
		public static var YELLOW : uint = RED + GREEN;
		
		public static var GRIDWIDTH : int = 16;
		public static var GRIDHEIGHT : int = 12;
		
		public static function xor(a:Boolean, b:Boolean) {
			return !(a && b) && (a || b);
		}
		
		public static function getDistanceVector(a : FlxPoint, b:FlxPoint) : FlxPoint{
			return new FlxPoint(b.x - a.x, b.y - a.y);
		}

		
		//change a FlxPoint to a vector of length 1 with the same direction
		public static function normalizeVector(vector : FlxPoint) : FlxPoint {
			var returned = new FlxPoint();
			var length : Number = FlxU.getDistance(new FlxPoint(0, 0), vector);
			if(length > 0){
				returned.x = vector.x / length;
				returned.y = vector.y / length;
			}
			
			return returned;
		}
		
		public static function getRandom(min:int, max:int) : int {
			return Math.round(Math.random() * (max - min)) + min;
		}
		
		/*Original function by Pieter Iserbyt:
		http://local.wasp.uwa.edu.au/~pbourke/geometry/pointline/DistancePoint.java
		from Paul Bourke's website:
		http://local.wasp.uwa.edu.au/~pbourke/geometry/pointline/
		*/
		public static function pointToLineDistance(p1:FlxPoint, p2:FlxPoint, p3:FlxPoint):Number {
			var xDelta:Number = p2.x - p1.x;
			var yDelta:Number = p2.y - p1.y;
			if ((xDelta == 0) && (yDelta == 0)) {
				// p1 and p2 cannot be the same point
				p2.x += 1;
				p2.y += 1;
				xDelta = 1;
					yDelta = 1;
			}
			var u:Number = ((p3.x - p1.x) * xDelta + (p3.y - p1.y) * yDelta) / (xDelta * xDelta + yDelta * yDelta);
			var closestPoint:Point;
			if (u <0) {
				closestPoint = new Point(p1.x, p1.y);
			} else if (u> 1) {
				closestPoint = new Point(p2.x, p2.y);
			} else {
				closestPoint = new Point(p1.x + u * xDelta, p1.y + u * yDelta);
			}
			return Point.distance(closestPoint, new Point(p3.x, p3.y));
		}
	}

}