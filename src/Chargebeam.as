package  
{
	
	import flash.filters.GlowFilter;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxTilemap;
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	/**
	 * ...
	 * @author Sam Tregillus
	 */
	public class Chargebeam extends Projectile
	{
		public var smallbeamWidth : int = 5;
		public var smallbeamLength : int = 20;
		
		public var largebeamWidth : int = 5;
		
		public var chargeTime : Number = .75;
		public var shootTime : Number = .5;
		public var currentCharge : Number = chargeTime;
		
		public var player : Player;
		public var state : String = "charging";
		public var target : FlxPoint;
		public var enemies : FlxGroup;
		
		public function Chargebeam(playerRef : Player) 
		{
			player = playerRef;
			makeGraphic(CC.WINDOWWIDTH, CC.WINDOWHEIGHT, 0x000000 );
			this.x = 0;
			this.y = 0;
			this.solid = false;
			enemies = (FlxG.state as PlayState).entities;
		}
		
		override public function update() : void {
			super.update();
			
			if (state == "charging" && currentCharge == chargeTime) {
				FlxG.play(Resources.sounds["laserCharge"]);
			}
			
			currentCharge -= FlxG.elapsed;
			
			if (currentCharge <= 0 && state == "charging") {
				FlxG.play(Resources.sounds["laserShoot"]);
				state = "shooting";
				currentCharge = shootTime;
				if(target == null)
					target = FlxG.mouse.getWorldPosition();
			}
			else if (currentCharge <= 0 && state == "shooting") {
				this.kill();
			}
			
			if (state == "shooting") {
				var playerPoint : FlxPoint = player.getMidpoint();
	
				for each(var ent : FlxSprite in enemies.members) {
					if (ent is Enemy) {
						target = FlxG.mouse.getWorldPosition();
						var dist : Number = CC.pointToLineDistance(playerPoint, target, (ent as Enemy).getMidpoint());
						if (dist < 10) (ent as Enemy).kill();
					}
				}
			}

		}
		
		override public function draw() : void {
			
			var line : Shape = new Shape();
			var targetPoint : FlxPoint;
			var playerPoint : FlxPoint = player.getMidpoint();
			var length : int;
			
			if (state == "charging") {
				length = smallbeamLength;
				targetPoint = FlxG.mouse.getWorldPosition();
			}
			else {
				targetPoint = target;
				targetPoint = FlxG.mouse.getWorldPosition();
				length = 1000;
			}
			
			var diffVector = new FlxPoint(targetPoint.x - playerPoint.x, targetPoint.y - playerPoint.y);
			
			diffVector = CC.normalizeVector(diffVector);
			diffVector.x *= length;
			diffVector.y *= length;
			
			
			diffVector.x += playerPoint.x;
			diffVector.y += playerPoint.y;
			
			line.graphics.lineStyle(smallbeamWidth,0xffffff);
			line.graphics.moveTo(playerPoint.x, playerPoint.y);
			line.graphics.lineTo(diffVector.x, diffVector.y);
			//circle.graphics.endFill();
			
			var matrix : Matrix = new Matrix();
			//matrix.tx = line.width / 2;
			//matrix.ty = line.width / 2;
			
			this.framePixels.fillRect(new Rectangle(0, 0, framePixels.width, framePixels.height), 0x00000000);
			this.framePixels.draw(line, matrix);
			
			super.draw();
			
		}
		
	}

}