package  
{
	import org.flixel.FlxPoint;
	import org.flixel.FlxU;
	import org.flixel.FlxG;
	/**
	 * ...
	 * @author Sam Tregillus
	 */
	public class LoadoutPistol extends PlayerLoadout
	{
		var bulletVelocity = 1000;
		public function LoadoutPistol(player : Player)
		{
			super(player);
			weaponCooldown = .05;
			name = "Pistol";
		}
		
		override public function onClick() {
			if(currentCooldown <= 0){
				var bullet : Projectile = new Projectile();
				bullet.fromPlayer = true;
				bullet.damage = 3;
				var center : FlxPoint = playerRef.getMidpoint();
				bullet.x = center.x;
				bullet.y = center.y;
				
				var velVector : FlxPoint = getMouseVector();
				velVector = CC.normalizeVector(velVector);
				velVector.x *= bulletVelocity;
				velVector.y *= bulletVelocity;
				
				bullet.velocity.x = velVector.x;
				bullet.velocity.y = velVector.y;
				
				fireWeapon(bullet, Resources.sounds['pistol']);
				FlxG.shake(.001, .1);
				currentCooldown = weaponCooldown;
			}
		}
		
		
		
	}

}