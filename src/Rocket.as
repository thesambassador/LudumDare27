package  
{
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	/**
	 * ...
	 * @author Sam Tregillus
	 */
	public class Rocket extends Projectile
	{
		
		public function Rocket() 
		{
			super();
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