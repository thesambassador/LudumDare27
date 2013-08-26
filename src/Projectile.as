package  
{
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	import org.flixel.FlxTilemap;
	import org.flixel.system.FlxTile;
	/**
	 * ...
	 * @author Sam Tregillus
	 */
	public class Projectile extends FlxSprite
	{
		
		public var damage : int;
		public var life : Number = -1;
		public var fromPlayer : Boolean = false;
		
		public function Projectile(basic : Boolean = true) 
		{
			super();
			if(basic)
				makeGraphic(2, 2);
			
		}
		
		override public function update() : void{
			if (life > 0) {
				life -= FlxG.elapsed;
				if (life < 0) {
					this.kill();
				}
			}
			super.update();
		}
		
		public function collideWall(wall : FlxTilemap) {
			//if(wall.overlaps(this))
				this.kill();
		}
		
		public function collidePlayer(player : Player) {
			if(this.overlaps(player))
				player.hurt(damage);
		}
		
		public function collideEnemy(enemy : Enemy) {
			if (fromPlayer) {
				this.kill();
				enemy.projectileHit(damage, this.velocity);
			}

		}
		
		
		
	}

}