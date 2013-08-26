package  
{
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Sam Tregillus
	 */
	public class Mine extends Projectile
	{
		
		public function Mine(center : FlxPoint) 
		{
			super(false);
			var imgWidth = 40;
			makeGraphic(imgWidth, imgWidth, 0x000000);
			centerOffsets();
			x = center.x - imgWidth / 2;
			y = center.y - imgWidth / 2;
			
			var circle : Shape = new Shape();
			
			circle.graphics.beginFill(0xff1111);
			circle.graphics.drawCircle(0, 0, imgWidth / 2);
			circle.graphics.endFill();
			
			var matrix : Matrix = new Matrix();
			matrix.tx = circle.width / 2;
			matrix.ty = circle.width / 2;

			this.framePixels.draw(circle, matrix);
		}
		
		public function fireWeapon(projectile : FlxSprite) {
			(FlxG.state as PlayState).projectiles.add(projectile);
		}
		
		override public function kill() : void {
			var center : FlxPoint = this.getMidpoint();
			var shockwave : Shockwave = new Shockwave(center);
			shockwave.fromPlayer = true;
			shockwave.damage = 1;
			shockwave.life = .5;
			
			shockwave.x = center.x - shockwave.width / 2;
			shockwave.y = center.y - shockwave.height / 2;
			
			fireWeapon(shockwave);
				
			super.kill();
		}
		
	}

}