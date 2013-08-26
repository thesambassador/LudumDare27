package  
{
	import org.flixel.FlxPoint;
	import org.flixel.FlxU;
	/**
	 * ...
	 * @author Sam Tregillus
	 */
	public class LoadoutRocket extends PlayerLoadout
	{
		var bulletVelocity : int = 400;
		var pelletCount : int = 6;
		
		public function LoadoutRocket(player : Player)
		{
			super(player);
			weaponCooldown = 1;
			name = "Rocket";
		}
		
		override public function onClick() {
			if (currentCooldown <= 0) {

				var bullet : Rocket = new Rocket();
				bullet.fromPlayer = true;
				bullet.damage = 0;
				bullet.life = -1;
				var center : FlxPoint = playerRef.getMidpoint();
				bullet.x = center.x;
				bullet.y = center.y;
				
				var velVector : FlxPoint = getMouseVector();

				velVector = CC.normalizeVector(velVector);
				velVector.x *= bulletVelocity;
				velVector.y *= bulletVelocity;
				
				bullet.velocity.x = velVector.x;
				bullet.velocity.y = velVector.y;
				bullet.acceleration.x = velVector.x * 3;
				bullet.acceleration.y = velVector.y * 3;
				
				fireWeapon(bullet, Resources.sounds['rocket']);
				currentCooldown = weaponCooldown;
				
			}
		}
		
		
		
	}

}