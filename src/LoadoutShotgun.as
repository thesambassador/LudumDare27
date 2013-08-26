package  
{
	import org.flixel.FlxPoint;
	import org.flixel.FlxU;
	import org.flixel.FlxG;
	/**
	 * ...
	 * @author Sam Tregillus
	 */
	public class LoadoutShotgun extends PlayerLoadout
	{
		var bulletVelocity : int = 1000;
		var pelletCount : int = 10;
		
		public function LoadoutShotgun(player : Player)
		{
			super(player);
			weaponCooldown = .75;
			name = "Shotgun";
		}
		
		override public function onClick() {
			if (currentCooldown <= 0) {
				fireWeapon(bullet, Resources.sounds['pistol']);
				for (var i:int = 0; i < pelletCount; i++){
					var bullet : Projectile = new Projectile();
					bullet.fromPlayer = true;
					bullet.damage = 1;
					bullet.life = .5;
					var center : FlxPoint = playerRef.getMidpoint();
					bullet.x = center.x;
					bullet.y = center.y;
					
					var velVector : FlxPoint = getMouseVector();
					
					//give it a slight amount of random spread
					velVector.x += CC.getRandom( -35, 35);
					velVector.y += CC.getRandom( -35, 35);
					
					velVector = CC.normalizeVector(velVector);
					velVector.x *= bulletVelocity + CC.getRandom(-100, 100);
					velVector.y *= bulletVelocity + CC.getRandom(-100, 100);
					
					bullet.velocity.x = velVector.x;
					bullet.velocity.y = velVector.y;
					
					
					FlxG.shake(.005, .1);
					currentCooldown = weaponCooldown;
				}
			}
		}
		
		
		
	}

}