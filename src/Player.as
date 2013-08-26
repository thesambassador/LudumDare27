package 
{
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Bitmap;
	import flash.filters.GlowFilter;
	import flash.filters.BlurFilter;
	import flash.filters.GradientGlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import org.flixel.FlxParticle;
	import org.flixel.FlxPoint;
	
	import org.flixel.FlxSprite;
	import org.flixel.FlxGroup;
	import org.flixel.FlxG;
	/**
	 * ...
	 * @author Sam Tregillus
	 */
	public class Player extends FlxSprite
	{
		public var size : int = 30
		
		public var pt:Point = new Point(2, 2);
		public var rect:Rectangle = new Rectangle(pt.x, pt.y, size-10, size-10);
		public var origImage : BitmapData;
		
		public var str : Number = 0;
		public var strDir : Number = .1;
		
		public var acc : FlxPoint = new FlxPoint(2000, 2000);
		public var invuln : Number = -1;
		
		public var loadout : PlayerLoadout;
		
		public function Player(x:Number, y:Number) {
			super(x, y);
			
			origImage = new BitmapData(size, size, true, 0x000000);
			
			origImage.fillRect(rect, 0xFFFFFFFF);
			
			color = 0xFF0000;
			
			pixels = origImage;
			
			width = size-7;
			height = size-7;
			
			maxVelocity.x = 300;
			maxVelocity.y = 300;
			
			drag.x = maxVelocity.x;
			drag.y = maxVelocity.y;
			
			health = 1;
			
			loadout = new LoadoutPistol(this);
			//loadout = new LoadoutChargebeam(this);
			
		}
		
		override public function update() : void {
			acceleration.x = 0;
			acceleration.y = 0;
			velocity.x *= .95;
			velocity.y *= .95;
			
			if (loadout != null) {
				loadout.update();
				if (loadout.currentCooldown >= 0) {
					color = 0xFF9999;
				}
				else {
					color = 0xFF0000;
				}
			}
			
			baseMovement();
			
			
			if (invuln > 0) {
				invuln -= FlxG.elapsed;
				updateGlow()
			}
			else {
				
			}
			
			if (health <= 0) {
				this.kill();
			}
			
			super.update();
		}
		
		public function baseMovement() : void {
			var dirVect : FlxPoint = new FlxPoint();
			
			if (FlxG.keys["W"]) {
				dirVect.y -= 1;
			}
			if (FlxG.keys["S"]) {
				dirVect.y += 1;
			}
			if (FlxG.keys["A"]) {
				dirVect.x -= 1;
			}
			if (FlxG.keys["D"]) {
				dirVect.x += 1;
			}
			
			var accVect : FlxPoint = CC.normalizeVector(dirVect);
			acceleration.x += accVect.x * acc.x;
			acceleration.y += accVect.y * acc.y;

		}
		
		public function updateGlow() : void {
			var filter:GlowFilter = new GlowFilter();
				
			filter.color = 0xFFFFFFFF;
			filter.blurX = 10;
			filter.blurY = 10;
			filter.strength = str;
				
			framePixels.applyFilter(origImage, rect, pt, filter);
				
			str += strDir;
			if (str > 3) strDir = -strDir;
			if (str < 0) strDir = -strDir;
		}
		
		override public function hurt(damage : Number) : void {
			if (invuln <= 0) {
				super.hurt(damage);
			}
		}

	}
	
}