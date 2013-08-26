package  
{
	import org.flixel.FlxPoint;
	import org.flixel.FlxU;
	/**
	 * ...
	 * @author Sam Tregillus
	 */
	public class LoadoutMachinegun extends PlayerLoadout
	{
		var bulletVelocity = 1000;
		public function LoadoutMachinegun(player : Player)
		{
			super(player);
			weaponCooldown = .05;
			name = "Repeater";
		}
		
		override public function onMouseDown() {
			if(currentCooldown <= 0){
				var bullet : Projectile = new Projectile();
				bullet.fromPlayer = true;
				bullet.damage = 1;
				var center : FlxPoint = playerRef.getMidpoint();
				bullet.x = center.x;
				bullet.y = center.y;
				
				var velVector : FlxPoint = getMouseVector();
				
				//give it a slight amount of random spread
				velVector.x += CC.getRandom( -35, 35);
				velVector.y += CC.getRandom( -35, 35);
				
				velVector = CC.normalizeVector(velVector);
				velVector.x *= bulletVelocity;
				velVector.y *= bulletVelocity;
				
				bullet.velocity.x = velVector.x;
				bullet.velocity.y = velVector.y;
				
				fireWeapon(bullet, Resources.sounds['repeater']);
				currentCooldown = weaponCooldown;
			}
		}
		
		
		
	}

}