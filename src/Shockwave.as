package  
{
	
	import flash.filters.GlowFilter;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import org.flixel.FlxPoint;
	import org.flixel.FlxTilemap
	import org.flixel.FlxG;
	import org.flixel.FlxU;
	/**
	 * ...
	 * @author Sam Tregillus
	 */
	public class Shockwave extends Projectile
	{
		public var currentRadius : Number = 10;
		public var shockwaveWidth : int = 5;
		public var radiusAccel : Number = 10;
		public var radiusAccelDecay : Number = -1;
		public var center : FlxPoint;
		public var maxRadius : Number = 150;
		
		public function Shockwave(point : FlxPoint) 
		{
			center = point;
			damage = 5;
			makeGraphic(300, 300, 0x00000000);
			//solid = false;
			
			width = 20;
			height = 20;
			centerOffsets();
			
			FlxG.play(Resources.sounds['explosion']);
			FlxG.shake(.01, .2);
		}
		
		override public function update() : void {
			super.update();
			
			currentRadius += radiusAccel;
			
			if (currentRadius > maxRadius) currentRadius = maxRadius;
			
			//width = currentRadius*2;
			//height = currentRadius*2;
			//offset.x = width / 2;
			//offset.y = height / 2;
			
			if(radiusAccel > .5){
				radiusAccel += radiusAccelDecay;
			}
			else {
				radiusAccel = .5;
			}
			
		}
		
		override public function collideWall(wall : FlxTilemap) {
			
		}
		
		override public function collidePlayer(player : Player) {
			
		}
		
		override public function collideEnemy(enemy : Enemy) {
			var explosionVector : FlxPoint =  CC.getDistanceVector(this.getMidpoint(), enemy.getMidpoint());
			var dist : Number = FlxU.getDistance(this.getMidpoint(), enemy.getMidpoint());
			
			explosionVector = CC.normalizeVector(explosionVector);
			explosionVector.x *= 150/dist * 300;
			explosionVector.y *= 150/dist * 300;
			enemy.lastHit = explosionVector;
			enemy.kill();//(damage);
		}
		
		override public function draw() : void {
			var imgWidth = currentRadius * 2 + shockwaveWidth*2
			makeGraphic(imgWidth, imgWidth, 0x000000);
			centerOffsets();
			x = center.x - imgWidth / 2;
			y = center.y - imgWidth / 2;
			//y -= imgWidth / 4;
			
			var circle : Shape = new Shape();
			
			circle.graphics.lineStyle(10,0xffffff);
			circle.graphics.drawCircle(0, 0, currentRadius);
			//circle.graphics.endFill();
			
			var matrix : Matrix = new Matrix();
			matrix.tx = circle.width / 2;
			matrix.ty = circle.width / 2;
			
			this.framePixels.fillRect(new Rectangle(0, 0, framePixels.width, framePixels.height), 0x00000000);
			this.framePixels.draw(circle, matrix);
			
			super.draw();
			
		}
		
	}

}