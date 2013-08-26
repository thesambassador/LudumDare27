package  
{
	import org.flixel.FlxPoint;
	import org.flixel.FlxU;
	/**
	 * ...
	 * @author Sam Tregillus
	 */
	public class LoadoutShockwave extends PlayerLoadout
	{
		var bulletVelocity : int = 1000;
		var range : int = 100;
		
		public function LoadoutShockwave(player : Player)
		{
			super(player);
			weaponCooldown = .75;
			name = "Shockwave";
		}
		
		override public function onClick() {
			if (currentCooldown <= 0) {
				var center : FlxPoint = playerRef.getMidpoint();
				var shockwave : Shockwave = new Shockwave(center);
				shockwave.fromPlayer = true;
				shockwave.damage = 1;
				shockwave.life = .5;
				
				shockwave.maxRadius = 500;
				shockwave.radiusAccel = 15;
				
				shockwave.x = center.x - shockwave.width / 2;
				shockwave.y = center.y - shockwave.height / 2;
				
				
				
				//shockwave.velocity.x = velVector.x;
				//shockwave.velocity.y = velVector.y;
				
				fireWeapon(shockwave);
				currentCooldown = weaponCooldown;

			}
		}
		
		
		
	}

}